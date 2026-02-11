<#
.SYNOPSIS
    RefreshBills.ps1 — KassenBlick CSV Validator & Skin Refresher

.DESCRIPTION
    1. Validates that Bills.csv exists and has the expected header structure
    2. Optionally resets all StatusIDs to "1" (Unpaid) on the 1st of each month
    3. Sends a !Refresh bang to Rainmeter to reload the KassenBlick skin

.NOTES
    Skin Path: E:\Documents\Rainmeter\Skins\Kassenblick\
    Called by: Rainmeter RunCommand measure, or scheduled task, or manually
#>

param(
    [string]$SkinPath = "E:\Documents\Rainmeter\Skins\Kassenblick",
    [switch]$MonthlyReset,
    [switch]$ValidateOnly
)

$BillsCSV = Join-Path $SkinPath "Data\Bills.csv"
$RainmeterExe = "${env:ProgramFiles}\Rainmeter\Rainmeter.exe"

# ── VALIDATE CSV ─────────────────────────────────────────────────────────────
function Test-BillsCSV {
    if (-not (Test-Path $BillsCSV)) {
        Write-Error "Bills.csv not found at: $BillsCSV"
        return $false
    }

    $header = (Get-Content $BillsCSV -TotalCount 1).Trim()
    $expectedCols = @("StatusID", "Name", "ID", "Status", "Account", "DueDay", "Autopay", "Amount", "Category")

    $valid = $true
    foreach ($col in $expectedCols) {
        if ($header -notmatch [regex]::Escape($col)) {
            Write-Warning "Missing expected column: $col"
            $valid = $false
        }
    }

    if ($valid) {
        $rowCount = (Get-Content $BillsCSV | Measure-Object).Count - 1
        Write-Host "[OK] Bills.csv validated: $rowCount data rows" -ForegroundColor Green
    }

    return $valid
}

# ── MONTHLY RESET (Day 1 logic) ─────────────────────────────────────────────
function Reset-MonthlyStatus {
    $today = Get-Date
    if ($today.Day -ne 1 -and -not $MonthlyReset) {
        Write-Host "[SKIP] Not the 1st of the month. Use -MonthlyReset to force." -ForegroundColor Yellow
        return
    }

    Write-Host "[RESET] Resetting all bill statuses to Unpaid for new month..." -ForegroundColor Cyan

    $lines = Get-Content $BillsCSV
    $output = @()
    $output += $lines[0]  # Keep header

    for ($i = 1; $i -lt $lines.Count; $i++) {
        $line = $lines[$i]
        # Skip empty lines
        if ($line.Trim() -eq "" -or $line -match '^"","","","","","","","","",""') {
            $output += $line
            continue
        }

        # Replace first field (StatusID) with "1" (Unpaid)
        # Also replace Status field "Paid" → "Unpaid"
        $line = $line -replace '^"0"', '"1"'
        $line = $line -replace '"Paid"', '"Unpaid"'
        $output += $line
    }

    $output | Set-Content $BillsCSV -Encoding UTF8
    Write-Host "[DONE] All bills reset to Unpaid." -ForegroundColor Green
}

# ── REFRESH RAINMETER ───────────────────────────────────────────────────────
function Invoke-SkinRefresh {
    if (Test-Path $RainmeterExe) {
        & $RainmeterExe "!Refresh" "Kassenblick\Main"
        Write-Host "[REFRESH] KassenBlick skin refreshed." -ForegroundColor Green
    } else {
        Write-Warning "Rainmeter.exe not found at: $RainmeterExe"
        # Try alternate location
        $altPath = "${env:ProgramFiles(x86)}\Rainmeter\Rainmeter.exe"
        if (Test-Path $altPath) {
            & $altPath "!Refresh" "Kassenblick\Main"
            Write-Host "[REFRESH] KassenBlick skin refreshed (alt path)." -ForegroundColor Green
        }
    }
}

# ── MAIN ─────────────────────────────────────────────────────────────────────
Write-Host "═══════════════════════════════════════" -ForegroundColor DarkGray
Write-Host "  KassenBlick — RefreshBills.ps1" -ForegroundColor White
Write-Host "═══════════════════════════════════════" -ForegroundColor DarkGray

$isValid = Test-BillsCSV

if (-not $isValid) {
    Write-Error "CSV validation failed. Aborting."
    exit 1
}

if ($ValidateOnly) {
    Write-Host "[DONE] Validation only mode." -ForegroundColor Cyan
    exit 0
}

if ($MonthlyReset -or (Get-Date).Day -eq 1) {
    Reset-MonthlyStatus
}

Invoke-SkinRefresh
Write-Host "[COMPLETE]" -ForegroundColor Green
