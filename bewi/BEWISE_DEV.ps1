#================================================
#   [PreOS] Update Module
#================================================
Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force

Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force

if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

Start-Sleep -Seconds 20

##Make sure I have the latest OSD Content

#Write-Host -ForegroundColor Green “Updating OSD PowerShell Module”

#Install-Module OSD -Force

#Write-Host -ForegroundColor Green “Importing OSD PowerShell Module”
#pause

##================================================
##  [PostOS] SetupComplete CMD Command Line
##================================================
#Write-Host -ForegroundColor Green "Create .\OSDCloud\Config\Scripts\copyapprofile.cmd"
#$SetupCompleteCMD = @'
#RD C:\OSDCloud\OS /S /Q
#XCOPY '.\OSDCloud\Config\Scripts\Files\BEWI SE Standard Deployment.json'  .\OSDCloud\Config\Autopilot.json  /E /H /C /I /Y
#'@
#$SetupCompleteCMD | Out-File -FilePath '.\OSDCloud\Config\Scripts\\SetupComplete.cmd' -Encoding ascii -Force
PowerShell -NoL -Com Set-ExecutionPolicy RemoteSigned -Force
Set Path = %PATH%;C:\Program Files\WindowsPowerShell\Scripts
Start /Wait PowerShell -NoL -C Install-Module OSD -Force -Verbose
Start /Wait PowerShell -NoL -C Invoke-WebPSScript https://raw.githubusercontent.com/tgrendal71/OSD/main/bewi/copyse.ps1

#================================================
#  [PostOS] SetupComplete CMD Command Line
#================================================
#Write-Host -ForegroundColor Green "Create C:\Windows\Setup\Scripts\SetupComplete.cmd"
#$SetupCompleteCMD = @'
#RD C:\OSDCloud\OS /S /Q
#XCOPY C:\OSDCloud\ C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD /E /H /C /I /Y
#XCOPY C:\ProgramData\OSDeploy C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD /E /H /C /I /Y
#RD C:\OSDCloud /S /Q
#RD C:\Drivers /S /Q
#RD C:\Temp /S /Q
#'@
#$SetupCompleteCMD | Out-File -FilePath 'C:\Windows\Setup\Scripts\SetupComplete.cmd' -Encoding ascii -Force

#Import-Module OSD -Force

##Start OSDCloud ZTI the RIGHT way

#Write-Host -ForegroundColor Green “Start OSDCloud”

#Start-OSDCloud -OSLanguage sv-se -OSBuild 22H2 -OSEdition Enterprise -OSVersion 'Windows 10' -ZTI

##Restart from WinPE

#Write-Host -ForegroundColor Green “Restarting in 20 seconds!”

Start-Sleep -Seconds 20

wpeutil reboot


