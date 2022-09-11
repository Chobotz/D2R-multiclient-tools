. $PSScriptRoot'\Set-Window-ex.ps1'

if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$proc_ids = (Get-Process -Name d2r).Id | Sort-Object Id

Write-Host $proc_ids

# start position x,y ===========
$x = 20
$y = -20
#===============================

$cnt = 0

foreach ($id in $proc_ids){
#creates one column of windows, after 7 instances it will start from top somewhere else
if ($cnt -eq 7){$x = 1200;$y=-20;}
Set-Window -ProcessId $id -X $x -Y $y -Width 1280 -Height 720
Write-Host "Setting PID" $id "to position x: " $x " y: " $y
# position adjustment per each instance x,y
$x += 50
$y += 38 
#==========================================

$cnt += 1 

}

#read-host "Press ENTER to continue..."