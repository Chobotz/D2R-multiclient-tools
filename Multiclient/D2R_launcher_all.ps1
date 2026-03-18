#== D2R multiclient launcher by Chobot - https://github.com/Chobotz/D2R-multiclient-tools =====
# game version 3.1.1 and Win 11
# put this script into D2R folder
# you need to disable MFA in your battle net account - https://account.battle.net/security#authenticator, because the game D2R.exe starts with user name and password command line arguments: which does not support MFA
# send me lot of FGs, if you get Blizz-hammer banned don't come crying to daddy

# 1.  ELEVATION - this is needed to deal with the instance handle the game creates
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    # Launch new admin window and exit this one immediately
    Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

# 2. CONFIGURATION & PATHS
$default_region = 'eu'
$d2r_path = Join-Path $PSScriptRoot "D2R.exe"
# get the handle64.exe from Microsoft official site https://learn.microsoft.com/en-us/sysinternals/downloads/handle and put it into D2R folder next to this powershell script
$handle_path = Join-Path $PSScriptRoot "handle64.exe"
# accounts.txt modify this with your accounts one per line, use format: bnet_account1@gmail.com;password1
$accounts_file = Join-Path $PSScriptRoot "accounts.txt"
$base_settings_dir = Join-Path $env:USERPROFILE "Saved Games\Diablo II Resurrected"
$game_config = Join-Path $base_settings_dir "Settings.json"
$game_config_low = Join-Path $base_settings_dir "Settings_low.json"
$game_config_tiny = Join-Path $base_settings_dir "mods\tiny\Settings.json"

#allows to specify mod launch for certain accounts, check the section 6 - Launch loop - advanced
$mods_used = $false

#Minimum 1280*720 with 100% display scale. If you have Display/DPI scaling then you need to re-adjust, for 175% display scale it's $window_width = 750, $window_height = 455
$window_width = 1280
$window_height = 720

# Validate Files, self check if you missed something
foreach ($f in @($d2r_path, $handle_path, $accounts_file)) {
    if (-not (Test-Path $f)) { Write-Error "File missing: $f"; pause; exit }
}

# 3. WIN32 API DEFINITIONS
$Win32Code = @'
[DllImport("user32.dll", CharSet=CharSet.Auto)]
public static extern bool SetWindowText(IntPtr hWnd, string lpString);

[DllImport("user32.dll")]
public static extern bool SetForegroundWindow(IntPtr hWnd);

[DllImport("user32.dll")]
public static extern void mouse_event(int dwFlags, int dx, int dy, int dwData, int dwExtraInfo);

[DllImport("user32.dll")]
public static extern bool SetCursorPos(int x, int y);

[DllImport("user32.dll")]
public static extern bool SetWindowPos(IntPtr hWnd, IntPtr hWndInsertAfter, int X, int Y, int cx, int cy, uint uFlags);
'@

if (-not ([System.Management.Automation.PSTypeName]'Win32Utils').Type) {
    Add-Type -MemberDefinition $Win32Code -Name "Win32Utils" -Namespace "Win32Functions"
}

# 4. HELPER FUNCTIONS
function Close-D2RHandles {
    $output = & $handle_path -accepteula -a -p D2R.exe 2>$null
    $currentPid = $null
    foreach ($line in $output) {
        if ($line -match 'pid:\s+(?<pid>\d+)') { $currentPid = $Matches.pid }
        if ($line -match '(?<hid>[\dA-F]+): \w+\s+.*DiabloII Check For Other Instances') {
            & $handle_path -p $currentPid -c $Matches.hid -y | Out-Null
            Write-Host "Closed Instance Handle for PID $currentPid" -ForegroundColor Gray
        }
    }
}

# 5. USER INPUT - select region or leave empty for default
$validRegions = @('eu', 'us', 'kr', '')
do { $region = Read-Host "Select region (eu/us/kr) [Default: $default_region]" } 
while ($region -notin $validRegions)
$region = if ($region -eq '') { $default_region } else { $region }

# 6. LAUNCH LOOP
$accounts = Get-Content $accounts_file | Where-Object { $_ -and -not $_.StartsWith("#") }

foreach ($line in $accounts) {
    $user, $pass = $line.Split(';').Trim()
    
    # Sync settings
    if (Test-Path $game_config_low) {
        Copy-Item $game_config_low $game_config -Force
        if (Test-Path $game_config_tiny) { Copy-Item $game_config_low $game_config_tiny -Force }
    }

    Write-Host "Launching: $user" -ForegroundColor Green
    Close-D2RHandles

    $args = "-username $user -password $pass -address $($region).actual.battle.net -ns -w "
	
	#You can specify mods, for instance if account name is account1@gmail.com or account3@gmail.com then start with introskip mod, if not start with tinymod
	#If you have no mods, then in # 2. CONFIGURATION & PATHS, change: $mods_used = $false (default), this is for advanced farmers
	#introskip https://www.nexusmods.com/diablo2resurrected/mods/194
	#tinymod https://github.com/D2R-Gimli/TinyMod - broken but still works
    $mod = if ($user -match "account1|account3") { "introskip" } else { "tiny" }
    
	if ($mods_used) {
    Start-Process $d2r_path -ArgumentList "$args -mod $mod -txt"
	} else {
	 Start-Process $d2r_path -ArgumentList "$args"
	}
	
    Start-Sleep -Seconds 3
}

# 7. UPDATED WINDOW MANAGEMENT (Force Resize)
Write-Host "`nWaiting for windows to stabilize..." -ForegroundColor Cyan
Start-Sleep -Seconds 5

$processes = Get-Process -Name D2R -ErrorAction SilentlyContinue | Sort-Object StartTime
$x, $y = 20, 20

# Flags: SWP_SHOWWINDOW (0x0040) | SWP_FRAMECHANGED (0x0020) | SWP_NOZORDER (0x0004)
$flags = 0x0040 -bor 0x0020 -bor 0x0004

foreach ($idx in 0..($processes.Count - 1)) {
    $proc = $processes[$idx]
    $h = $proc.MainWindowHandle
    
    if ($h -ne 0) {
        # A. Force Focus first
        [Win32Functions.Win32Utils]::SetForegroundWindow($h)
        Start-Sleep -Milliseconds 200

        # B. Rename
        [Win32Functions.Win32Utils]::SetWindowText($h, "D2R$($idx + 1)")

        # C. Aggressive Resize
        Write-Host "Verifying window resolution on PID: $($proc.Id)..."
        [Win32Functions.Win32Utils]::SetWindowPos($h, [IntPtr]::Zero, $x, $y, $window_width, $window_height, $flags)
        
        # Give the game a moment to accept the new size
		# depending on your pc you need to adjust this if it takes longer for clients to start
        Start-Sleep -Milliseconds 800 

        # D. Precise Click
        $clickX = $x + (Get-Random -Minimum 150 -Maximum 251)
        $clickY = $y + (Get-Random -Minimum 150 -Maximum 251)
        [Win32Functions.Win32Utils]::SetCursorPos($clickX, $clickY)
        [Win32Functions.Win32Utils]::mouse_event(0x02, 0, 0, 0, 0) # Down
        Start-Sleep -Milliseconds 50
        [Win32Functions.Win32Utils]::mouse_event(0x04, 0, 0, 0, 0) # Up

        $x += 50
        $y += 38
        Start-Sleep -Seconds 1
    }
}

Write-Host "`nAll tasks complete." -ForegroundColor Green