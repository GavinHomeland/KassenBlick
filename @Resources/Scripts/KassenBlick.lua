-- ====================
-- KassenBlick.lua
-- Rainmeter Bill Tracking Script
-- ====================

-- ====================
-- CONFIGURATION
-- ====================
local MAX_BILLS = 25
local COLUMNS = 5
local YELLOW_THRESHOLD = 5
local DOT_RADIUS = 6
local MAX_BUCKETS = 3

-- ====================
-- HEADER ALIASES
-- ====================
local HEADER_ALIASES = {
    ["Name (tooltip)"] = "Name",
    ["Due Day"]        = "DueDay",
    ["Days Left"]      = "DaysLeft",
    [""]               = "ID",
}

-- ====================
-- COLOR CONSTANTS
-- ====================
local COLOR = {
    GREY   = "128,128,128,255",
    YELLOW = "255,255,0,255",
    RED    = "255,0,0,255",
    GREEN  = "0,255,0,255",
    BLACK  = "0,0,0,255",
    WHITE  = "255,255,255,255"
}

-- ====================
-- GLOBALS
-- ====================
local bills = {}
local buckets = {}
local lastBillsContent = nil
local lastBucketsContent = nil
local csvPath = ""
local bucketsPath = ""

-- ====================
-- HELPER FUNCTIONS
-- ====================

local function ReadFileToString(path)
    local f = io.open(path, "r")
    if not f then return nil end
    local s = f:read("*a")
    f:close()
    return s
end

local function FormatNumber(n)
    local s = string.format("%.2f", n)
    local int, dec = s:match("^(-?%d+)(%.%d+)$")
    int = int:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
    return int .. dec
end

function LogError(msg)
    SKIN:Bang('!Log', 'KassenBlick.lua ERROR: ' .. msg, 'Error')
end

-- ====================
-- CSV PARSING
-- ====================

function ParseCSVLine(line)
    local fields = {}
    local field = ""
    local inQuotes = false
    local i = 1

    while i <= #line do
        local c = line:sub(i, i)

        if inQuotes then
            if c == '"' then
                if i < #line and line:sub(i + 1, i + 1) == '"' then
                    field = field .. '"'
                    i = i + 1
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

        i = i + 1
    end

    table.insert(fields, field)
    return fields
end

-- ====================
-- DATE CALCULATIONS
-- ====================

function GetDaysInMonth(month, year)
    return os.date("*t", os.time({year = year, month = month + 1, day = 0})).day
end

function CalcDaysUntil(dueDay)
    local dueDayNum = tonumber(dueDay)
    if not dueDayNum then
        return nil
    end

    local now = os.date("*t")
    local currentDay = now.day
    local currentMonth = now.month
    local currentYear = now.year

    local daysInMonth = GetDaysInMonth(currentMonth, currentYear)

    if dueDayNum > daysInMonth then
        dueDayNum = daysInMonth
    end

    return dueDayNum - currentDay
end

-- ====================
-- BILL PARSING
-- ====================

function ParseBills()
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
            local rawHeaders = ParseCSVLine(line)
            for _, h in ipairs(rawHeaders) do
                local cleaned = h:gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', '')
                local normalized = HEADER_ALIASES[cleaned] or cleaned
                table.insert(headers, normalized)
            end
        else
            if #bills >= MAX_BILLS then
                break
            end

            local fields = ParseCSVLine(line)
            local bill = {}

            for i, header in ipairs(headers) do
                local value = fields[i] or ""
                value = value:gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', '')
                bill[header] = value
            end

            if bill.Name and bill.Name ~= "" then
                bill.StatusID = bill.StatusID or ""
                bill.ID = bill.ID or ""
                bill.Status = bill.Status or ""
                bill.Account = bill.Account or ""
                bill.DueDay = bill.DueDay or ""
                bill.Autopay = bill.Autopay or ""
                bill.Amount = bill.Amount or ""
                bill.Category = bill.Category or ""
                bill.URL = bill.URL or ""

                table.insert(bills, bill)
            end
        end
    end

    file:close()

    while #bills < MAX_BILLS do
        table.insert(bills, {
            StatusID = "",
            Name = "",
            Status = "",
            Account = "",
            DueDay = "",
            Autopay = "",
            Amount = "",
            Category = "",
            URL = ""
        })
    end
end

-- ====================
-- BILL COLOR LOGIC
-- ====================

function GetBillColors(bill)
    local fillColor = COLOR.GREY
    local strokeColor = COLOR.WHITE

    if bill.Name == "" then
        return COLOR.BLACK, COLOR.WHITE
    end

    local autopayLower = bill.Autopay:lower()
    if autopayLower == "y" or autopayLower == "yes" then
        strokeColor = COLOR.GREEN
    end

    local statusIDNum = tonumber(bill.StatusID)
    local statusLower = bill.Status:lower()

    if statusIDNum == 0 or statusLower == "paid" then
        return COLOR.GREEN, strokeColor
    end

    local daysLeft = CalcDaysUntil(bill.DueDay)

    if daysLeft == nil then
        fillColor = COLOR.GREY
    elseif daysLeft < 0 then
        fillColor = COLOR.RED
    elseif daysLeft == 0 then
        fillColor = COLOR.RED
    elseif daysLeft <= YELLOW_THRESHOLD then
        fillColor = COLOR.YELLOW
    else
        fillColor = COLOR.GREY
    end

    return fillColor, strokeColor
end

-- ====================
-- APPLY BILL STATUSES
-- ====================

function ApplyStatuses()
    for i = 1, MAX_BILLS do
        local bill = bills[i]
        local row = math.ceil(i / COLUMNS)
        local col = ((i - 1) % COLUMNS) + 1
        local suffix = "R" .. row .. "_C" .. col

        local fillColor, strokeColor = GetBillColors(bill)

        local dotMeter = "MeterDot_" .. suffix
        local idMeter = "MeterID_" .. suffix

        local shape = string.format("Ellipse %d,%d,%d,%d | Fill Color %s | StrokeWidth 1 | Stroke Color %s",
            DOT_RADIUS, DOT_RADIUS, DOT_RADIUS, DOT_RADIUS, fillColor, strokeColor)

        SKIN:Bang('!SetOption', dotMeter, 'Shape', shape)

        local idText = "---"
        if (bill.ID or "") ~= "" then
            idText = bill.ID
        elseif bill.Name ~= "" then
            idText = bill.Name:upper():sub(1, 3)
        end

        SKIN:Bang('!SetOption', idMeter, 'Text', idText)

        local tooltip = ""
        if bill.Name ~= "" then
            local daysLeft = CalcDaysUntil(bill.DueDay)
            local daysText = ""

            if daysLeft == nil then
                daysText = "Unknown"
            elseif daysLeft < 0 then
                daysText = string.format("OVERDUE (%dd)", daysLeft)
            elseif daysLeft == 0 then
                daysText = "DUE TODAY"
            else
                daysText = string.format("Due in %dd", daysLeft)
            end

            tooltip = string.format("%s | $%s | %s", bill.Name, bill.Amount, daysText)

            local autopayLower = bill.Autopay:lower()
            if autopayLower == "y" or autopayLower == "yes" then
                tooltip = tooltip .. " | AUTO"
            end
        end

        SKIN:Bang('!SetOption', dotMeter, 'ToolTipText', tooltip)
        SKIN:Bang('!SetOption', idMeter, 'ToolTipText', tooltip)
    end

    SKIN:Bang('!Redraw')
end

-- ====================
-- BUCKET PARSING
-- ====================

function ParseBuckets()
    buckets = {}
    local content = ReadFileToString(bucketsPath)
    if not content then
        LogError("Cannot open Buckets.csv at: " .. tostring(bucketsPath))
        return
    end

    for line in content:gmatch("[^\r\n]+") do
        if #buckets >= MAX_BUCKETS then break end
        local fields = ParseCSVLine(line)
        local source = (fields[1] or ""):gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', '')
        -- Skip header lines, continuation lines, and empty rows
        if source ~= "" and source ~= "Source" and not source:match("^%(") then
            local code = (fields[2] or ""):gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', '')
            local baselineRaw = (fields[3] or ""):gsub('"', ''):gsub('[%$,]', ''):gsub('^%s+', ''):gsub('%s+$', '')
            local currentRaw = (fields[4] or ""):gsub('"', ''):gsub('[%$,]', ''):gsub('^%s+', ''):gsub('%s+$', '')
            local irRaw = (fields[5] or ""):gsub('"', ''):gsub('%%', ''):gsub('^%s+', ''):gsub('%s+$', '')
            local baseline = tonumber(baselineRaw) or 0
            local current = tonumber(currentRaw) or 0
            local ir = tonumber(irRaw) or 0
            if baseline > 0 then
                table.insert(buckets, {
                    Source = source,
                    Code = code ~= "" and code or source:upper():sub(1, 3),
                    Baseline = baseline,
                    Current = current,
                    IR = ir
                })
            end
        end
    end
end

-- ====================
-- PIE CHART UTILITIES
-- ====================

-- No BuildPieShapes needed - using Roundline meters directly

-- ====================
-- APPLY BUCKETS
-- ====================

function ApplyBuckets()
    local maxBaseline = 0
    for _, b in ipairs(buckets) do
        if b.Baseline > maxBaseline then maxBaseline = b.Baseline end
    end

    -- Clear any leftover path definitions
    for i = 1, MAX_BUCKETS do
        local pieMeter = "MeterPie_" .. i
        SKIN:Bang('!SetOption', pieMeter, 'GreenPath_' .. i, '')
    end

    for i = 1, MAX_BUCKETS do
        local bucket = buckets[i] or { Source = "", Baseline = 0, Current = 0, Code = "" }
        local pieMeter = "MeterPie_" .. i
        local labelMeter = "MeterBucketLabel_" .. i

        local greenPct = 0
        if bucket.Baseline > 0 then
            greenPct = (bucket.Baseline - bucket.Current) / bucket.Baseline * 100
        end

        local r = 0
        if maxBaseline > 0 and bucket.Baseline > 0 then
            r = math.max(15, math.floor(50 * (bucket.Baseline / maxBaseline)))
        end

        local cx, cy = 50, 50
        local redColor = greenPct < 0 and "180,0,0,180" or "255,0,0,180"

        local ir = bucket.IR or 0
        local strokeW = ir / 3

        if r <= 0 then
            -- Hide empty slot
            SKIN:Bang('!SetOption', pieMeter, 'Shape', 'Ellipse 50,50,1,1 | Fill Color 0,0,0,0 | StrokeWidth 0')
            SKIN:Bang('!SetOption', pieMeter, 'Shape2', '')
            SKIN:Bang('!SetOption', pieMeter, 'Shape3', '')
            SKIN:Bang('!SetOption', pieMeter, 'ToolTipText', '')
        else
            -- Red background circle
            local redCircle = string.format("Ellipse %d,%d,%d,%d | Fill Color %s | StrokeWidth 0",
                cx, cy, r, r, redColor)

            SKIN:Bang('!SetOption', pieMeter, 'Shape', redCircle)

            -- Track next available shape slot (Shape is always the red circle)
            local nextShape = 2

            -- Green arc overlay (if greenPct > 0)
            if greenPct > 0 then
                local displayPct = greenPct
                if displayPct < 3 then displayPct = 3 end
                if displayPct > 100 then displayPct = 100 end

                local angleRad = (displayPct / 100) * 2 * math.pi
                local sx = cx
                local sy = cy - r
                local ex = cx + r * math.sin(angleRad)
                local ey = cy - r * math.cos(angleRad)
                local largeArc = displayPct > 50 and 1 or 0

                -- Named path approach with unique name per bucket
                local pathName = "GreenPath_" .. i
                local pathDef = string.format("%.0f,%.0f | LineTo %.0f,%.0f | ArcTo %.0f,%.0f,%.0f,%.0f,0,%d,0 | LineTo %.0f,%.0f",
                    cx, cy, sx, sy, ex, ey, r, r, largeArc, cx, cy)

                SKIN:Bang('!SetOption', pieMeter, pathName, pathDef)
                local greenArc = "Path " .. pathName .. " | Fill Color 0,255,0,180 | StrokeWidth 0"

                SKIN:Bang('!SetOption', pieMeter, 'Shape2', greenArc)
                nextShape = 3
            end

            -- Yellow border representing interest rate (thickness = IR/3 px)
            -- Placed in the next sequential shape slot to avoid gaps
            if strokeW > 0 then
                local borderR = r + strokeW / 2
                local borderRing = string.format("Ellipse %d,%d,%.1f,%.1f | Fill Color 0,0,0,0 | StrokeWidth %.1f | Stroke Color 255,255,0,200",
                    cx, cy, borderR, borderR, strokeW)
                SKIN:Bang('!SetOption', pieMeter, 'Shape' .. nextShape, borderRing)
                nextShape = nextShape + 1
            end

            -- Clear any leftover shape slots
            for s = nextShape, 3 do
                SKIN:Bang('!SetOption', pieMeter, 'Shape' .. s, '')
            end

            local tip = ""
            if bucket.Source ~= "" and bucket.Baseline > 0 then
                local paid = math.max(0, bucket.Baseline - bucket.Current)
                tip = string.format("%s | Baseline: $%s | Current: $%s | Paid: $%s (%.0f%%)",
                    bucket.Source,
                    FormatNumber(bucket.Baseline),
                    FormatNumber(bucket.Current),
                    FormatNumber(paid),
                    greenPct)
            end
            SKIN:Bang('!SetOption', pieMeter, 'ToolTipText', tip)
        end

        SKIN:Bang('!SetOption', labelMeter, 'Text', bucket.Code or "")
    end

    SKIN:Bang('!Redraw')
end

-- ====================
-- INITIALIZE
-- ====================

function Initialize()
    csvPath = SKIN:GetVariable("BillsCSV", "..\\Data\\Bills.csv")
    csvPath = SKIN:MakePathAbsolute(csvPath)

    bucketsPath = SKIN:GetVariable("BucketsCSV", "..\\Data\\Buckets.csv")
    bucketsPath = SKIN:MakePathAbsolute(bucketsPath)

    ParseBills()
    ParseBuckets()

    -- Apply initial state to meters
    ApplyStatuses()
    ApplyBuckets()
end

-- ====================
-- UPDATE
-- ====================

function Update()
    local billsContent = ReadFileToString(csvPath)
    if billsContent and billsContent ~= lastBillsContent then
        lastBillsContent = billsContent
        ParseBills()
        ApplyStatuses()
    end

    local bucketsContent = ReadFileToString(bucketsPath)
    if bucketsContent and bucketsContent ~= lastBucketsContent then
        lastBucketsContent = bucketsContent
        ParseBuckets()
        ApplyBuckets()
    end

    return 0
end
