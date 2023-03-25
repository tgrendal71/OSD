Write-Host  -ForegroundColor Yellow "Starter BEWI' Custom OSDCloud ..."
cls
Write-Host "===================== Main Menu =======================" -ForegroundColor Yellow
Write-Host "================ www.evidi.com =================" -ForegroundColor Yellow

Write-Host "=======================================================" -ForegroundColor Yellow
Write-Host "1: Zero-Touch Win10 22H2 | Dansk | Enterprise"-ForegroundColor Green
Write-Host "2: Zero-Touch Win11 22H2 | Dansk | Enterprise" -ForegroundColor Green
Write-Host "3: Zero-Touch Win10 22H2 | Engelsk | Enterprise"-ForegroundColor Yellow
Write-Host "4: Zero-Touch Win11 22H2 | Engelsk | Enterprise" -ForegroundColor Yellow
Write-Host "5: Exit`n"-ForegroundColor Yellow
$input = Read-Host "Please make a selection"

Write-Host  -ForegroundColor Yellow "Loading OSDCloud..."

Import-Module OSD -Force
Install-Module OSD -Force

switch ($input)
{
    '1' { Start-OSDCloud -OSLanguage da-dk -OSVersion "Windows 10" -OSBuild 22H2 -OSEdition Enterprise -ZTI } 
    '2' { Start-OSDCloud -OSLanguage da-dk -OSVersion "Windows 11" -OSBuild 22H2 -OSEdition Enterprise -ZTI } 
    '1' { Start-OSDCloud -OSLanguage en-us -OSVersion "Windows 10" -OSBuild 22H2 -OSEdition Enterprise -ZTI } 
    '2' { Start-OSDCloud -OSLanguage en-us -OSVersion "Windows 11" -OSBuild 22H2 -OSEdition Enterprise -ZTI }
    '3' { Start-OSDCloud	} 
    '4' { Exit		}
}

#=======================================================================
#   Restart-Computer
#=======================================================================
Write-Host  -ForegroundColor Green "Restarting in 20 seconds!"
Start-Sleep -Seconds 20
wpeutil reboot
