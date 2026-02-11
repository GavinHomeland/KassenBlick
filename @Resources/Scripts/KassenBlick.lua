--[[
================================================================================
  KassenBlick.lua
  Bill Status Engine for the KassenBlick Rainmeter Dashboard
  
  Parses Bills.csv and calculates status colors for each bill slot:
    Grey   (128,128,128) : Default/unpaid, not yet approaching due date
    Yellow (255,255,0)   : Within 5 days of due date
    Red    (255,0,0)     : Due today or overdue
    Green  (0,255,0)     : Paid (StatusID == 0)
    Black  (0,0,0)       : Empty/unpopulated slot
  
  Stroke (border) logic:
    Green  (0,255,0)     : Autopay == "y"
    White  (255,255,255) : Not autopay or empty slot
================================================================================
--]]

-- ============================================================================
-- CONFIGURATION
-- ============================================================================
local MAX_BILLS = 15  -- 5 rows x 3 columns
local YELLOW_THRESHOLD = 5  -- days before due to turn yellow

-- Color constants (R,G,B,A)
local COLOR = {
    GREY   = "128,128,128,255",
    YELLOW = "255,255,0,255",
    RED    = "255,0,0,255",
    GREEN  = "0,255,0,255",
    BLACK  = "0,0,0,255",
    WHITE  = "255,255,255,255"
}

-- ============================================================================
-- GLOBALS
-- ============================================================================
local bills = {}

-- ============================================================================
-- INITIALIZE
-- ============================================================================
function Initialize()
    csvPath = SKIN:MakePathAbsolute(SKIN:GetVariable("BillsCSV", "..\\Data\\Bills.csv"))
    ParseCSV()
end

-- ============================================================================
-- UPDATE (called every Rainmeter update cycle)
-- ============================================================================
function Update()
    ParseCSV()
    ApplyStatuses()
    return 0
end

-- ============================================================================
-- CSV PARSER
-- Handles quoted fields with embedded commas
-- ============================================================================
function ParseCSV()
    bills = {}
    
    local file = io.open(csvPath, "r")
    if not file then
        LogError("Cannot open Bills.csv at: " .. tostring(csvPath))
        return
    end
    
    local lineNum = 0
    local headers = {}
    
    for line in file:lines() do
        lineNum = lineNum + 1
        
        if lineNum == 1 then
            -- Parse header row to get column indices
            headers = ParseCSVLine(line)
        else
            if lineNum > MAX_BILLS + 1 then break end
            
            local fields = ParseCSVLine(line)
            local bill = {}
            
            for i, header in ipairs(headers) do
                -- Normalize header name (strip quotes, trim whitespace)
                local key = header:gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', '')
                local val = (fields[i] or ""):gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', '')
                bill[key] = val
            end
            
            table.insert(bills, bill)
        end
    end
    
    file:close()
    
    -- Pad to MAX_BILLS with empty entries
    while #bills < MAX_BILLS do
        table.insert(bills, { StatusID = "", Name = "", ID = "", Status = "",
                              Account = "", DueDay = "", Autopay = "", Amount = "",
                              Category = "", URL = "" })
    end
end

-- ============================================================================
-- Parse a single CSV line respecting quoted fields
-- ============================================================================
function ParseCSVLine(line)
    local fields = {}
    local field = ""
    local inQuotes = false
    
    for i = 1, #line do
        local c = line:sub(i, i)
        
        if inQuotes then
            if c == '"' then
                -- Check for escaped quote ""
                if i < #line and line:sub(i + 1, i + 1) == '"' then
                    field = field .. '"'
                    -- Skip next char (handled by not advancing, but we need a flag)
                else
                    inQuotes = false
                end
            else
                field = field .. c
            end
        else
            if c == '"' then
                inQuotes = true
            elseif c == ',' then
                table.insert(fields, field)
                field = ""
            else
                field = field .. c
            end
        end
    end
    
    -- Last field
    table.insert(fields, field)
    return fields
end

-- ============================================================================
-- CALCULATE DAYS UNTIL DUE
-- Uses current system date and the bill's DueDay (day of month)
-- Returns: positive = days until due, 0 = due today, negative = overdue
-- ============================================================================
function CalcDaysUntil(dueDay)
    if not dueDay or dueDay == "" then return nil end
    
    local dd = tonumber(dueDay)
    if not dd or dd < 1 or dd > 31 then return nil end
    
    local now = os.time()
    local today = os.date("*t", now)
    
    local curYear  = today.year
    local curMonth = today.month
    local curDay   = today.day
    
    -- Build the due date for this month
    -- Clamp dueDay to actual days in current month
    local daysInMonth = GetDaysInMonth(curMonth, curYear)
    local effectiveDue = math.min(dd, daysInMonth)
    
    local dueTime = os.time({ year = curYear, month = curMonth, day = effectiveDue,
                              hour = 0, min = 0, sec = 0 })
    local todayTime = os.time({ year = curYear, month = curMonth, day = curDay,
                                hour = 0, min = 0, sec = 0 })
    
    local diffSec = dueTime - todayTime
    local diffDays = math.floor(diffSec / 86400)
    
    return diffDays
end

-- ============================================================================
-- Get number of days in a given month/year
-- ============================================================================
function GetDaysInMonth(month, year)
    -- Advance to day 0 of next month = last day of current month
    local nextMonth = month + 1
    local nextYear = year
    if nextMonth > 12 then
        nextMonth = 1
        nextYear = nextYear + 1
    end
    local lastDay = os.date("*t", os.time({ year = nextYear, month = nextMonth, day = 0 }))
    return lastDay.day
end

-- ============================================================================
-- DETERMINE STATUS COLOR for a bill
-- Returns: fillColor, strokeColor
-- ============================================================================
function GetBillColors(bill)
    local fillColor   = COLOR.BLACK
    local strokeColor = COLOR.WHITE
    
    -- Empty slot check
    local id = bill.ID or ""
    local name = bill.Name or ""
    if id == "" and name == "" then
        return COLOR.BLACK, COLOR.WHITE
    end
    
    -- Autopay stroke
    local autopay = (bill.Autopay or ""):lower()
    if autopay == "y" or autopay == "yes" then
        strokeColor = COLOR.GREEN
    else
        strokeColor = COLOR.WHITE
    end
    
    -- Paid check (StatusID == 0 or Status == "Paid")
    local statusID = tonumber(bill.StatusID or "")
    local statusText = (bill.Status or ""):lower()
    
    if statusID == 0 or statusText == "paid" then
        return COLOR.GREEN, strokeColor
    end
    
    -- Calculate days until due
    local daysUntil = CalcDaysUntil(bill.DueDay)
    
    if daysUntil == nil then
        -- No valid due date: default grey
        return COLOR.GREY, strokeColor
    end
    
    if daysUntil < 0 then
        -- Overdue
        return COLOR.RED, strokeColor
    elseif daysUntil == 0 then
        -- Due today
        return COLOR.RED, strokeColor
    elseif daysUntil <= YELLOW_THRESHOLD then
        -- Within 5 days
        return COLOR.YELLOW, strokeColor
    else
        -- Default: not yet approaching
        return COLOR.GREY, strokeColor
    end
end

-- ============================================================================
-- APPLY STATUSES TO RAINMETER METERS
-- Updates Shape fill/stroke colors and String meter text for each slot
-- Naming convention: MeterDot_R{row}_C{col}, MeterID_R{row}_C{col}
-- ============================================================================
function ApplyStatuses()
    for i = 1, MAX_BILLS do
        local bill = bills[i]
        local row = math.ceil(i / 3)
        local col = ((i - 1) % 3) + 1
        local suffix = "R" .. row .. "_C" .. col
        
        local fillColor, strokeColor = GetBillColors(bill)
        
        -- Update the Shape meter (dot) fill and stroke
        local dotMeter = "MeterDot_" .. suffix
        
        -- Build the Shape attribute string for the ellipse
        -- Shape=Ellipse (CX),(CY),(RX),(RY) | Fill Color R,G,B,A | StrokeWidth 1 | Stroke Color R,G,B,A
        local shapeStr = "Ellipse 5,5,5,5 | Fill Color " .. fillColor .. " | StrokeWidth 1 | Stroke Color " .. strokeColor
        
        SKIN:Bang('!SetOption', dotMeter, 'Shape', shapeStr)
        
        -- Update the ID text meter
        local idMeter = "MeterID_" .. suffix
        local idText = (bill.ID or "")
        if idText == "" then idText = "---" end
        
        SKIN:Bang('!SetOption', idMeter, 'Text', idText)
        
        -- Update tooltip with full bill name and amount
        local tooltipText = ""
        if (bill.Name or "") ~= "" then
            tooltipText = bill.Name
            if (bill.Amount or "") ~= "" and bill.Amount ~= "0" then
                tooltipText = tooltipText .. " | $" .. bill.Amount
            end
            local daysUntil = CalcDaysUntil(bill.DueDay)
            if daysUntil then
                if daysUntil < 0 then
                    tooltipText = tooltipText .. " | OVERDUE by " .. math.abs(daysUntil) .. "d"
                elseif daysUntil == 0 then
                    tooltipText = tooltipText .. " | DUE TODAY"
                else
                    tooltipText = tooltipText .. " | Due in " .. daysUntil .. "d"
                end
            end
            if (bill.Autopay or ""):lower() == "y" then
                tooltipText = tooltipText .. " | AUTO"
            end
        end
        SKIN:Bang('!SetOption', dotMeter, 'ToolTipText', tooltipText)
        SKIN:Bang('!SetOption', idMeter, 'ToolTipText', tooltipText)
    end
    
    -- Force a redraw after all updates
    SKIN:Bang('!Redraw')
end

-- ============================================================================
-- HELPER: Log errors to Rainmeter log
-- ============================================================================
function LogError(msg)
    SKIN:Bang('!Log', 'KassenBlick.lua ERROR: ' .. msg, 'Error')
end

function LogDebug(msg)
    SKIN:Bang('!Log', 'KassenBlick.lua: ' .. msg, 'Debug')
end
