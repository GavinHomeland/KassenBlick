-- ====================
-- KassenBlick.lua
-- Rainmeter Bill Tracking Script
-- ====================

-- ====================
-- CONFIGURATION
-- ====================
local MAX_BILLS    = 25
local COLUMNS      = 5
local YELLOW_THRESHOLD = 7
local DOT_RADIUS   = 6
local MAX_BUCKETS  = 3
local MAX_SAVINGS  = 3
local SAVE_W       = 100
local SAVE_LABEL_GAP = 5

-- ====================
-- HEADER ALIASES
-- ====================
local HEADER_ALIASES = {
    ["Name (tooltip)"] = "Name",
    ["Due Day"]        = "DueDay",
    ["Days Left"]      = "DaysLeft",
    ["APay"]           = "Autopay",
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
local d_buckets = {}
local s_buckets = {}
local lastBillsContent   = nil
local lastBucketsContent = nil
local csvPath     = ""
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

-- Parse "MM/DD/YY" or "MM/DD/YYYY" into a table {year, month, day}
local function ParseDueDate(str)
    if not str or str == "" then return nil end
    local m, d, y = str:match("^(%d+)/(%d+)/(%d+)$")
    if not m then return nil end
    m, d, y = tonumber(m), tonumber(d), tonumber(y)
    if not m or not d or not y then return nil end
    if y < 100 then y = 2000 + y end
    return { year = y, month = m, day = d }
end

-- Fraction of time elapsed from Jan 1 of the due year to the due date.
-- Returns a value clamped to [0, 1].
local function CalcTimeFraction(due)
    local startT = os.time({ year = due.year, month = 1,         day = 1,       hour = 0, min = 0, sec = 0 })
    local endT   = os.time({ year = due.year, month = due.month, day = due.day, hour = 0, min = 0, sec = 0 })
    local nowT   = os.time()
    local total  = endT - startT
    if total <= 0 then return 1 end
    return math.max(0, math.min(1, (nowT - startT) / total))
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
            local blankSeen  = false
            for colIdx, h in ipairs(rawHeaders) do
                local cleaned = h:gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', '')
                local normalized
                if cleaned == "" then
                    -- Only the first blank header is the ID column; subsequent blanks are ignored
                    if not blankSeen then
                        normalized = "ID"
                        blankSeen  = true
                    else
                        normalized = "_col" .. colIdx
                    end
                else
                    normalized = HEADER_ALIASES[cleaned] or cleaned
                end
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
                bill.ID       = bill.ID       or ""
                bill.Status   = bill.Status   or ""
                bill.Account  = bill.Account  or ""
                bill.DueDay   = bill.DueDay   or ""
                bill.Autopay  = bill.Autopay  or ""
                bill.Amount   = bill.Amount   or ""
                bill.Category = bill.Category or ""

                table.insert(bills, bill)
            end
        end
    end

    file:close()

    while #bills < MAX_BILLS do
        table.insert(bills, {
            StatusID = "", Name = "", Status = "", Account = "",
            DueDay = "", Autopay = "", Amount = "", Category = ""
        })
    end
end

-- ====================
-- BILL COLOR LOGIC
-- ====================

function GetBillColors(bill)
    local fillColor   = COLOR.GREY
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
        local row  = math.ceil(i / COLUMNS)
        local col  = ((i - 1) % COLUMNS) + 1
        local suffix = "R" .. row .. "_C" .. col

        local fillColor, strokeColor = GetBillColors(bill)

        local dotMeter = "MeterDot_" .. suffix
        local idMeter  = "MeterID_"  .. suffix

        local shape = string.format(
            "Ellipse %d,%d,%d,%d | Fill Color %s | StrokeWidth 1 | Stroke Color %s",
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
        SKIN:Bang('!SetOption', idMeter,  'ToolTipText', tooltip)
    end

    SKIN:Bang('!Redraw')
end

-- ====================
-- BUCKET PARSING
-- ====================

function ParseBuckets()
    d_buckets = {}
    s_buckets = {}

    local content = ReadFileToString(bucketsPath)
    if not content then
        LogError("Cannot open Buckets.csv at: " .. tostring(bucketsPath))
        return
    end

    for line in content:gmatch("[^\r\n]+") do
        if #d_buckets >= MAX_BUCKETS and #s_buckets >= MAX_SAVINGS then break end

        local fields  = ParseCSVLine(line)
        local source  = (fields[1] or ""):gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', '')

        -- Skip header, empty rows, and continuation lines starting with "("
        if source ~= "" and source ~= "Source" and not source:match("^%(") then
            local code        = (fields[2] or ""):gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', '')
            local baselineRaw = (fields[3] or ""):gsub('"', ''):gsub('[%$,]', ''):gsub('^%s+', ''):gsub('%s+$', '')
            local currentRaw  = (fields[4] or ""):gsub('"', ''):gsub('[%$,]', ''):gsub('^%s+', ''):gsub('%s+$', '')
            local dueDateStr  = (fields[5] or ""):gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', '')
            local irRaw       = (fields[6] or ""):gsub('"', ''):gsub('%%', ''):gsub('^%s+', ''):gsub('%s+$', '')
            local typeVal     = (fields[7] or ""):gsub('"', ''):gsub('^%s+', ''):gsub('%s+$', ''):lower()

            local baseline = tonumber(baselineRaw) or 0
            local current  = tonumber(currentRaw)  or 0
            local ir       = tonumber(irRaw)        or 0

            if baseline > 0 then
                local entry = {
                    Source   = source,
                    Code     = code ~= "" and code or source:upper():sub(1, 3),
                    Baseline = baseline,
                    Current  = current,
                    IR       = ir,
                    DueDate  = dueDateStr
                }
                if typeVal == "d" and #d_buckets < MAX_BUCKETS then
                    table.insert(d_buckets, entry)
                elseif typeVal == "s" and #s_buckets < MAX_SAVINGS then
                    table.insert(s_buckets, entry)
                end
            end
        end
    end
end

-- ====================
-- PIE CHART UTILITIES
-- ====================

-- No BuildPieShapes needed - using named path definitions directly

-- ====================
-- APPLY BUCKETS (debt pies — unchanged)
-- ====================

function ApplyBuckets()
    local maxBaseline = 0
    for _, b in ipairs(d_buckets) do
        if b.Baseline > maxBaseline then maxBaseline = b.Baseline end
    end

    -- Clear any leftover path definitions
    for i = 1, MAX_BUCKETS do
        local pieMeter = "MeterPie_" .. i
        SKIN:Bang('!SetOption', pieMeter, 'GreenPath_' .. i, '')
    end

    for i = 1, MAX_BUCKETS do
        local bucket   = d_buckets[i] or { Source = "", Baseline = 0, Current = 0, Code = "" }
        local pieMeter = "MeterPie_"       .. i
        local labelMeter = "MeterBucketLabel_" .. i

        local greenPct = 0
        if bucket.Baseline > 0 then
            greenPct = (bucket.Baseline - bucket.Current) / bucket.Baseline * 100
        end

        local r = 0
        if maxBaseline > 0 and bucket.Baseline > 0 then
            r = math.max(15, math.floor(50 * (bucket.Baseline / maxBaseline)))
        end

        local cx, cy   = 50, 50
        local redColor = greenPct < 0 and "180,0,0,180" or "255,0,0,180"

        local ir     = bucket.IR or 0
        local strokeW = ir / 3

        if r <= 0 then
            SKIN:Bang('!SetOption', pieMeter, 'Shape',  'Ellipse 50,50,1,1 | Fill Color 0,0,0,0 | StrokeWidth 0')
            SKIN:Bang('!SetOption', pieMeter, 'Shape2', '')
            SKIN:Bang('!SetOption', pieMeter, 'Shape3', '')
            SKIN:Bang('!SetOption', pieMeter, 'ToolTipText', '')
        else
            local redCircle = string.format(
                "Ellipse %d,%d,%d,%d | Fill Color %s | StrokeWidth 0",
                cx, cy, r, r, redColor)

            SKIN:Bang('!SetOption', pieMeter, 'Shape', redCircle)

            local nextShape = 2

            if greenPct > 0 then
                local displayPct = greenPct
                if displayPct < 3   then displayPct = 3   end
                if displayPct > 100 then displayPct = 100 end

                local angleRad = (displayPct / 100) * 2 * math.pi
                local sx = cx
                local sy = cy - r
                local ex = cx + r * math.sin(angleRad)
                local ey = cy - r * math.cos(angleRad)
                local largeArc = displayPct > 50 and 1 or 0

                local pathName = "GreenPath_" .. i
                local pathDef  = string.format(
                    "%.0f,%.0f | LineTo %.0f,%.0f | ArcTo %.0f,%.0f,%.0f,%.0f,0,%d,0 | LineTo %.0f,%.0f",
                    cx, cy, sx, sy, ex, ey, r, r, largeArc, cx, cy)

                SKIN:Bang('!SetOption', pieMeter, pathName, pathDef)
                local greenArc = "Path " .. pathName .. " | Fill Color 0,255,0,180 | StrokeWidth 0"
                SKIN:Bang('!SetOption', pieMeter, 'Shape2', greenArc)
                nextShape = 3
            end

            if strokeW > 0 then
                local borderR    = r + strokeW / 2
                local borderRing = string.format(
                    "Ellipse %d,%d,%.1f,%.1f | Fill Color 0,0,0,0 | StrokeWidth %.1f | Stroke Color 255,255,0,200",
                    cx, cy, borderR, borderR, strokeW)
                SKIN:Bang('!SetOption', pieMeter, 'Shape' .. nextShape, borderRing)
                nextShape = nextShape + 1
            end

            for s = nextShape, 3 do
                SKIN:Bang('!SetOption', pieMeter, 'Shape' .. s, '')
            end

            local tip = ""
            if bucket.Source ~= "" and bucket.Baseline > 0 then
                local paid = math.max(0, bucket.Baseline - bucket.Current)
                tip = string.format(
                    "%s | Baseline: $%s | Current: $%s | Paid: $%s (%.0f%%)",
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
-- APPLY SAVINGS (squares, fill from bottom)
-- ====================

function ApplySavings()
    local saveTopY = tonumber(SKIN:GetVariable("SaveTopY")) or 365

    -- Reference scale from d-buckets: pie diameter = 100px represents maxBaseline
    local maxDBaseline = 0
    for _, b in ipairs(d_buckets) do
        if b.Baseline > maxDBaseline then maxDBaseline = b.Baseline end
    end
    if maxDBaseline == 0 then maxDBaseline = 20000 end

    -- s-buckets use 10x the px-per-dollar of d-buckets
    local pxPerDollarS = (100 / maxDBaseline) * 10

    -- Pass 1: compute each square height and find the tallest
    local squareHeights = {}
    local maxSquareH    = 0
    for i = 1, MAX_SAVINGS do
        local sb = s_buckets[i] or { Baseline = 0 }
        if sb.Baseline > 0 then
            local sqH = math.max(20, math.floor(sb.Baseline * pxPerDollarS))
            squareHeights[i] = sqH
            if sqH > maxSquareH then maxSquareH = sqH end
        else
            squareHeights[i] = 0
        end
    end

    -- All labels share one Y: just below the tallest square
    local labelY = saveTopY + maxSquareH + SAVE_LABEL_GAP

    -- Pass 2: apply with bottom-justification
    for i = 1, MAX_SAVINGS do
        local sb         = s_buckets[i] or { Source = "", Baseline = 0, Current = 0, Code = "" }
        local sqMeter    = "MeterSave_"      .. i
        local labelMeter = "MeterSaveLabel_" .. i
        local sqH        = squareHeights[i]

        if sqH <= 0 then
            -- Hide empty slot
            SKIN:Bang('!SetOption', sqMeter, 'Y',      tostring(saveTopY))
            SKIN:Bang('!SetOption', sqMeter, 'H',      '1')
            SKIN:Bang('!SetOption', sqMeter, 'Shape',  'Rectangle 0,0,1,1 | Fill Color 0,0,0,0 | StrokeWidth 0')
            SKIN:Bang('!SetOption', sqMeter, 'Shape2', '')
            SKIN:Bang('!SetOption', sqMeter, 'Shape3', '')
            SKIN:Bang('!SetOption', sqMeter, 'ToolTipText', '')
            SKIN:Bang('!SetOption', labelMeter, 'Text', '')
        else
            -- Bottom-justify: offset Y so all squares share the same bottom edge
            local meterY = saveTopY + (maxSquareH - sqH)
            SKIN:Bang('!SetOption', sqMeter, 'Y', tostring(meterY))
            SKIN:Bang('!SetOption', sqMeter, 'H', tostring(sqH))

            -- Background: grey outline, full height = savings goal
            local bgShape = string.format(
                'Rectangle 0,0,%d,%d | Fill Color 40,40,50,200 | StrokeWidth 1 | Stroke Color 220,220,220,255',
                SAVE_W, sqH)
            SKIN:Bang('!SetOption', sqMeter, 'Shape', bgShape)

            -- Savings progress
            local saved = math.max(0, math.min(sb.Current, sb.Baseline))
            local fillH = math.floor(saved / sb.Baseline * sqH)

            -- Due-date pace: parse due date and compute time-elapsed fraction
            local timeFrac = nil
            local daysLeft = nil
            if sb.DueDate and sb.DueDate ~= "" then
                local due = ParseDueDate(sb.DueDate)
                if due then
                    timeFrac = CalcTimeFraction(due)
                    local dueT = os.time({ year = due.year, month = due.month, day = due.day,
                                           hour = 0, min = 0, sec = 0 })
                    daysLeft = math.ceil((dueT - os.time()) / 86400)
                end
            end

            if timeFrac then
                -- Shape2 = orange time-elapsed bar (the "pace" target)
                local timeH = math.floor(timeFrac * sqH)
                if timeH > 0 then
                    SKIN:Bang('!SetOption', sqMeter, 'Shape2', string.format(
                        'Rectangle 1,%d,%d,%d | Fill Color 255,140,40,190 | StrokeWidth 0',
                        sqH - timeH, SAVE_W - 2, timeH))
                else
                    SKIN:Bang('!SetOption', sqMeter, 'Shape2', '')
                end
                -- Shape3 = green savings bar (on top, covers orange when ahead)
                if fillH > 0 then
                    SKIN:Bang('!SetOption', sqMeter, 'Shape3', string.format(
                        'Rectangle 1,%d,%d,%d | Fill Color %s | StrokeWidth 0',
                        sqH - fillH, SAVE_W - 2, fillH, COLOR.GREEN))
                else
                    SKIN:Bang('!SetOption', sqMeter, 'Shape3', '')
                end
            else
                -- No due date: just green savings bar, no pace indicator
                if fillH > 0 then
                    SKIN:Bang('!SetOption', sqMeter, 'Shape2', string.format(
                        'Rectangle 1,%d,%d,%d | Fill Color %s | StrokeWidth 0',
                        sqH - fillH, SAVE_W - 2, fillH, COLOR.GREEN))
                else
                    SKIN:Bang('!SetOption', sqMeter, 'Shape2', '')
                end
                SKIN:Bang('!SetOption', sqMeter, 'Shape3', '')
            end

            -- Labels share one Y line below the tallest square
            SKIN:Bang('!SetOption', labelMeter, 'Y',    tostring(labelY))
            SKIN:Bang('!SetOption', labelMeter, 'Text', sb.Code or "")

            -- Tooltip
            local pct = sb.Current / sb.Baseline * 100
            local tip = string.format(
                "%s | Goal: $%s | Saved: $%s (%.1f%%)",
                sb.Source,
                FormatNumber(sb.Baseline),
                FormatNumber(math.max(0, sb.Current)),
                pct)
            if daysLeft then
                local needed = math.max(0, sb.Baseline - sb.Current)
                tip = tip .. string.format(" | %dd left, $%s to go",
                    daysLeft, FormatNumber(needed))
            end
            SKIN:Bang('!SetOption', sqMeter, 'ToolTipText', tip)
        end
    end

    SKIN:Bang('!Redraw')
end

-- ====================
-- INITIALIZE
-- ====================

function Initialize()
    local function resolveCSV(primary, fallback)
        local abs = SKIN:MakePathAbsolute(primary)
        local f   = io.open(abs, "r")
        if f then f:close() return abs end
        return SKIN:MakePathAbsolute(fallback)
    end

    csvPath = resolveCSV(
        SKIN:GetVariable("BillsCSV",     "..\\Data\\Bills.csv"),
        SKIN:GetVariable("TempBillsCSV", "..\\tempdata\\Bills.csv")
    )
    bucketsPath = resolveCSV(
        SKIN:GetVariable("BucketsCSV",     "..\\Data\\Buckets.csv"),
        SKIN:GetVariable("TempBucketsCSV", "..\\tempdata\\Buckets.csv")
    )

    ParseBills()
    ParseBuckets()
    ApplyStatuses()
    ApplyBuckets()
    ApplySavings()
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
        ApplySavings()
    end

    return 0
end
