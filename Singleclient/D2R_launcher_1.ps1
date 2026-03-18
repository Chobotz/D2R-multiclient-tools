#== D2R singleclient transparent launcher by Chobot - https://github.com/Chobotz/D2R-multiclient-tools ==================
$bnet_email = 'changethis@gmail.com'
$bnet_password = 'changethispassword123'
$default_region = 'eu' # eu, us, kr

#--- 1. Check Mandatory Components ---
$d2rPath = Join-Path $PSScriptRoot "D2R.exe"
$handlePath = Join-Path $PSScriptRoot "handle64.exe"

if (!(Test-Path $d2rPath) -or !(Test-Path $handlePath)) {
    Write-Error "Missing D2R.exe or handle64.exe in $PSScriptRoot."
    Pause; Exit
}

#--- 2. Admin Elevation ---
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { 
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    Exit 
}

#--- 3. Close Instance Handles (Refined) ---
Write-Host "Searching for D2R instance handles..." -ForegroundColor Cyan

# Get raw output from handle64
$handleOutput = & $handlePath -accepteula -a -p D2R.exe 2>$null

if ($handleOutput) {
    $currentPid = $null
    
    foreach ($line in $handleOutput) {
        # 1. Track the PID: Look for lines like "D2R.exe pid: 1234"
        if ($line -match "pid:\s+(?<pid>\d+)") {
            $currentPid = $Matches.pid
        }

        # 2. Look for the 'Check For Other Instances' Event
        # We look for the Hex handle ID at the start of the line (e.g., "1A4: Event")
        if ($line -match "(?<hid>[A-F0-9]+): Event.*DiabloII Check For Other Instances") {
            $hid = $Matches.hid
            
            if ($currentPid) {
                Write-Host "Found Handle [$hid] on PID [$currentPid]. Closing..." -ForegroundColor Yellow
                & $handlePath -p $currentPid -c $hid -y | Out-Null
                
                # Verify closure
                if ($LASTEXITCODE -eq 0) {
                    Write-Host "Successfully released lock for PID $currentPid" -ForegroundColor Green
                } else {
                    Write-Host "Failed to close handle. Ensure you are running as Admin." -ForegroundColor Red
                }
            }
        }
    }
} else {
    Write-Host "No D2R processes found." -ForegroundColor Gray
}

# Short pause to let Windows update the handle table
Start-Sleep -Milliseconds 500

#--- 4. Configure Battle.net & Game Settings ---
$appData = $env:APPDATA # Roaming
$savedGames = Join-Path $env:USERPROFILE "Saved Games\Diablo II Resurrected"
$bnetConfig = Join-Path $appData "Battle.net\Battle.net.config"
$settingsJson = Join-Path $savedGames "Settings.json"
#configure game to low settings, then save Settings.json as Settings_low.json so it can be used later
$lowSettingsJson = Join-Path $savedGames "Settings_low.json"

# Update Bnet Email (Simple String Replace is fine here)
if (Test-Path $bnetConfig) {
    (Get-Content $bnetConfig) -replace 'SavedAccountNames": ".+@.+",', "SavedAccountNames`": `"$bnet_email`"," | Set-Content $bnetConfig
}

# Apply Low Graphics Settings
if (Test-Path $lowSettingsJson) {
    Copy-Item $lowSettingsJson $settingsJson -Force
    Write-Host "Applied Low Graphics Profile." -ForegroundColor Gray
}

#--- 5. Launch Logic ---
$launch_mode = Read-Host "Select launch mode [1] Direct (Default), [2] Bnet Launcher"
if ($launch_mode -ne "2") {
    $region = Read-Host "Specify region [eu/us/kr] (Empty for $default_region)"
    if ($region -notmatch 'eu|us|kr') { $region = $default_region }

    Write-Host "Launching D2R ($region)..." -ForegroundColor Green
    $launchArgs = @(
        "-username", $bnet_email,
        "-password", $bnet_password,
        "-address", "$region.actual.battle.net"#,
        #"-w", "-mod", "introskip", "-txt"
    )
    Start-Process $d2rPath -ArgumentList $launchArgs
} else {
    $launcher = Join-Path $PSScriptRoot "Diablo II Resurrected Launcher.exe"
    if (Test-Path $launcher) { Start-Process $launcher }
}
