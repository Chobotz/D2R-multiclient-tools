#== D2R singleclient transparent launcher by Chobot - https://github.com/Chobotz/D2R-multiclient-tools ==================
$bnet_email = 'changeme@gmail.com'
$bnet_password = 'mypassword123'
#default_region values can be eu/us/kr - default is applied when you do not provide any input and just press enter during region selection
$default_region = 'eu'
#======================================== Send me lot of FGs ==========================================================================================================


#============= Check for mandatory components and folder placement =====================================================================

$pc_username = [System.Environment]::UserName

if(![System.IO.File]::Exists("$PSScriptRoot\D2R.exe"))
{
    Write-Host "Warning: Script needs to be placed in D2R installation folder. Use lnk shortcut to start it. Follow the installation instructions."
    Write-Host "Exiting now."
    Read-host "Press ENTER to continue..."
    Exit
}

if(![System.IO.File]::Exists("$PSScriptRoot\handle64.exe"))
{
    Write-Host "Warning: handle64.exe is missing in the current folder - Follow the installation instructions. You can get it from the Microsoft Official site: https://docs.microsoft.com/en-us/sysinternals/downloads/handle"
    Write-Host "Exiting now."
    read-host "Press ENTER to continue..."
    Exit
}

#============= Enumerate D2R process handles and close the D2R instance handle to allow to start other clients - admin required ==========

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

& "$PSScriptRoot\handle64.exe" -accepteula -a -p D2R.exe > $PSScriptRoot\d2r_handles.txt

$proc_id_populated = ""
$handle_id_populated = ""

foreach($line in Get-Content $PSScriptRoot\d2r_handles.txt) {
    
    
    $proc_id = $line | Select-String -Pattern '^D2R.exe pid\: (?<g1>.+) ' | %{$_.Matches.Groups[1].value}
    if ($proc_id)
    {
        $proc_id_populated = $proc_id
    }
    $handle_id = $line | Select-String -Pattern '^(?<g2>.+): Event.*DiabloII Check For Other Instances' | %{$_.Matches.Groups[1].value}
    if ($handle_id)
    {
        $handle_id_populated = $handle_id
    }
    
    if($handle_id){
        
        Write-Host "Closing" $proc_id_populated $handle_id_populated
        & "$PSScriptRoot\handle64.exe" -p $proc_id_populated -c $handle_id_populated -y
        
    }
    
}

#============= Preset email address in Bnet launcher  ============

$bnet_config_path = "C:\Users\"+$pc_username+"\AppData\Roaming\Battle.net\Battle.net.config"
$new_saved_accounts = "SavedAccountNames`": `"" +$bnet_email +"`","


(Get-Content -Path $bnet_config_path) -replace "SavedAccountNames`": `".+@.+`",",$new_saved_accounts | Set-Content -Path $bnet_config_path


#============= Let the user specify launch mode and region  ======


Do {$launch_mode = Read-Host 'D2R - Select launch mode 1 or 2 (1 - Direct client, 2 - Bnet Launcher, Empty - Direct client)'}
while ($launch_mode -ne '1' -and $launch_mode -ne '2' -and $launch_mode -ne '')


$region = 'none yet'

if($launch_mode -eq "1" -or $launch_mode -eq "")
{
    Do { $region = Read-Host 'Specify region eu/us/kr (no input -> default region)';Write-Host "Selected region: $($region)";}
    while ($region -ne 'eu' -and $region -ne 'us' -and $region -ne 'kr' -and $region -ne '')	
    if($region -eq '')
    {
        $region = $default_region
    }
    & "$PSScriptRoot\D2R.exe" -username $bnet_email -password $bnet_password -address $region'.actual.battle.net'
    
    Write-Host 'Starting:'$region'.actual.battle.net'
}else {
    & "$PSScriptRoot\Diablo II Resurrected Launcher.exe"
}

#read-host "Press ENTER to continue..."