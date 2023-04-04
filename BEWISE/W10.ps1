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
#=======================================================================
#   [OS] Params and Start-OSDCloud
#=======================================================================
$Params = @{
    OSVersion = "Windows 10"
    OSBuild = "22H2"
    OSEdition = "Enterprise"
    OSLanguage = "sv-se"
    ZTI = $true
    Firmware = $false
}
Start-OSDCloud @Params
