#================================================
Write-Host -ForegroundColor Green “Starting OSDCloud ZTI”

Start-Sleep -Seconds 5

#Change Display Resolution for Virtual Machine

if ((Get-MyComputerModel) -match ‘Virtual’) {

Write-Host -ForegroundColor Green “Setting Display Resolution to 1600x”

Set-DisRes 1600

}

#Make sure I have the latest OSD Content

Write-Host -ForegroundColor Green “Updating OSD PowerShell Module”

Install-Module OSD -Force

Write-Host -ForegroundColor Green “Importing OSD PowerShell Module”

#================================================
#  [PostOS] SetupComplete CMD Command Line
#================================================
Write-Host -ForegroundColor Green "Create .\OSDCloud\Config\Scripts\copyapprofile.cmd"
$SetupCompleteCMD = @'
RD C:\OSDCloud\OS /S /Q
XCOPY '.\OSDCloud\Config\Scripts\Files\BEWI SE Standard Deployment.json'  .\OSDCloud\Config\Autopilot.json  /E /H /C /I /Y
'@
$SetupCompleteCMD | Out-File -FilePath '.\OSDCloud\Config\Scripts\\SetupComplete.cmd' -Encoding ascii -Force


Import-Module OSD -Force

#Start OSDCloud ZTI the RIGHT way

Write-Host -ForegroundColor Green “Start OSDCloud”

Start-OSDCloud -OSLanguage sv-se -OSBuild 22H2 -OSEdition Enterprise -OSVersion 'Windows 10' -ZTI

#Restart from WinPE

Write-Host -ForegroundColor Green “Restarting in 20 seconds!”

Start-Sleep -Seconds 20

wpeutil reboot


