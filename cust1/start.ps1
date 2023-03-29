Write-Host  -ForegroundColor Yellow "Starting Custom OSD ....."
cls
Write-Host "===================== Main Menu =======================" -ForegroundColor Yellow
Write-Host "=================== www.evidi.com =====================" -ForegroundColor Yellow
Write-Host "=======================================================" -ForegroundColor Yellow

Write-Host "1: Windows 10 x64 (22H2) | Norsk | Enterprise "  -ForegroundColor Green
Write-Host "2: Windows 11 x64 (22H2) | Norsk | Enterprise " -ForegroundColor Green
Write-Host "8: Start-OSDCloud" -ForegroundColor Green
Write-Host "9: Exit`n"-ForegroundColor Yellow
$input = Read-Host "Please make a selection"

Write-Host "Loading OSDCloud..." -BackgroundColor Gray
Import-Module OSD -Force
Install-Module OSD -Force

switch ($input)
{
    '1' { Start-OSDCloud -OSLanguage nb-no -OSVersion 'Windows 10' -OSBuild 22H2 -OSEdition Enterprise -ZTI } 
    '2' { Start-OSDCloud -OSLanguage nb-no -OSVersion 'Windows 11' -OSBuild 22H2 -OSEdition Enterprise -ZTI } 
    '8' { Start-OSDCloud } 
    '9' { Exit }
}


#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
