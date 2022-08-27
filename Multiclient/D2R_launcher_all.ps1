#== D2R multiclient transparent launcher by Chobot - https://github.com/Chobotz/D2R-multiclient-tools / https://forums.d2jsp.org/user.php?i=1208377 =====
#default_region values can be eu/us/kr (Europe / North America / Asia) - default is applied when you do not provide any input and just press enter during region selection
$default_region = 'eu'
#======================================== Send me lot of FGs ============================================================================================


$accounts_file = $PSScriptRoot+"\accounts.txt"
$pc_username = [System.Environment]::UserName


if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

if(![System.IO.File]::Exists("$PSScriptRoot\D2R.exe"))
{
    Write-Host "Warning: Script is not placed in D2R installation folder. D2R.exe is not present. Follow the installation instructions."
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

if(![System.IO.File]::Exists($accounts_file))
{
    Write-Host "Warning: accounts.txt is missing in the current folder. Follow the installation instructions. The file must contain bnet account credentials in format, one account per line: bnet_account@gmail.com;password"
    Write-Host "Exiting now."
    read-host "Press ENTER to continue..."
    Exit
}

function Close-Handle {
    
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
    
}

#============= Let the user specify launch mode and region  ======

$region = 'none yet'

Do { $region = Read-Host 'Select region eu/us/kr (no input -> default region)';Write-Host "Selected region: $($region)";}
while ($region -ne 'eu' -and $region -ne 'us' -and $region -ne 'kr' -and $region -ne '')	
if($region -eq '')
{
    $region = $default_region
}

Get-Content $accounts_file | foreach {

    $account = $_ -split ';'
    
    Write-Host 'Starting client for'$account[0]
    Write-Host "Closing D2R instance handle"
    Write-Host "Press Ctrl + C to stop the launching process any time."
    
  
    Close-Handle  
    & "$PSScriptRoot\D2R.exe" -username $account[0] -password $account[1] -address $region'.actual.battle.net'
    Start-Sleep -Seconds 2
    
    #read-host "Press ENTER to continue..."

    }








