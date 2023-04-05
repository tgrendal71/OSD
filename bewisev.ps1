Function Create-Menu (){
    Param(
        [Parameter(Mandatory=$False)][String]$MenuTitle,
        [Parameter(Mandatory=$True)][array]$MenuOptions,
        [Parameter(Mandatory=$True)][String]$Columns = "Auto",
        [Parameter(Mandatory=$False)][int]$MaximumColumnWidth=20,
        [Parameter(Mandatory=$False)][bool]$ShowCurrentSelection=$False
    )

    $MaxValue = $MenuOptions.count-1
    $Selection = 0
    $SelectionDone = $False
    $EnterPressed = $False

    If ($Columns -eq "Auto"){
        $WindowWidth = (Get-Host).UI.RawUI.MaxWindowSize.Width
        $Columns = [Math]::Floor($WindowWidth/($MaximumColumnWidth+2))
    }

    If ([int]$Columns -gt $MenuOptions.count){
        $Columns = $MenuOptions.count
    }

    $RowQty = ([Math]::Ceiling(($MaxValue+1)/$Columns))
    $MenuListing = @()

    For ($i=0; $i -lt $Columns; $i++) {
        [array]$ScratchArray = @()
        For ($j=($RowQty*$i); $j -lt ($RowQty*($i+1)); $j++) {
            $ScratchArray += $MenuOptions[$j]
        }

        $ColWidth = ($ScratchArray |Measure-Object -Maximum -Property length).Maximum
        If ($ColWidth -gt $MaximumColumnWidth){
            $ColWidth = $MaximumColumnWidth-1
        }

        For ($j=0; $j -lt $ScratchArray.count; $j++) {
            If(($ScratchArray[$j]).length -gt $($MaximumColumnWidth -2)){
                $ScratchArray[$j] = $($ScratchArray[$j]).Substring(0,$($MaximumColumnWidth-4))
                $ScratchArray[$j] = "$($ScratchArray[$j])..."
            } Else {
                For ($k=$ScratchArray[$j].length; $k -lt $ColWidth; $k++) {
                    $ScratchArray[$j] = "$($ScratchArray[$j]) "
                }
            }
            $ScratchArray[$j] = " $($ScratchArray[$j]) "
        }
        $MenuListing += $ScratchArray
    }
    
    Clear-Host

    While($EnterPressed -eq $False){
        if ($MenuTitle.Length -gt 0) {
            Write-Host "$MenuTitle"
        }
        If ($ShowCurrentSelection -eq $True){
            $Host.UI.RawUI.WindowTitle = "Valgt: $($MenuOptions[$Selection])"
        }
        For ($i=0; $i -lt $RowQty; $i++) {
            For ($j=0; $j -le (($Columns-1)*$RowQty);$j+=$RowQty) {
                If ($j -eq (($Columns-1)*$RowQty)) {
                    If (($i+$j) -eq $Selection) {
                        Write-Host -BackgroundColor cyan -ForegroundColor Black "$($MenuListing[$i+$j])"
                    } Else {
                        Write-Host "$($MenuListing[$i+$j])"
                    }
                } Else {
                    If(($i+$j) -eq $Selection){
                        Write-Host -BackgroundColor Cyan -ForegroundColor Black "$($MenuListing[$i+$j])" -NoNewline
                    } Else {
                        Write-Host "$($MenuListing[$i+$j])" -NoNewline
                    }
                }
            }
        }

        #Uncomment the below line if you need to do live debugging of the current index selection. It will put it in green below the selection listing.
        #Write-Host -ForegroundColor Green "$Selection"

        if ($SelectionDone -eq $true) {
            Return $Selection
        }

        $KeyInput = $host.ui.rawui.readkey("NoEcho,IncludeKeyDown").virtualkeycode
        Switch($KeyInput){
            13 {
                $EnterPressed = $True
                Return $Selection
            }
            37 { #Left
                If ($Selection -ge $RowQty) {
                    $Selection -= $RowQty
                } Else {
                    $Selection += ($Columns-1)*$RowQty
                }
                Clear-Host
                break
            }
            38 { #Up
                If ((($Selection+$RowQty)%$RowQty) -eq 0) {
                    $Selection += $RowQty - 1
                } Else {
                    $Selection -= 1
                }
                Clear-Host
                break
            }
            39 { #Right
                If ([Math]::Ceiling($Selection/$RowQty) -eq $Columns -or ($Selection/$RowQty)+1 -eq $Columns) {
                    $Selection -= ($Columns-1)*$RowQty
                } Else {
                    $Selection += $RowQty
                }
                Clear-Host
                break
            }
            40 { #Down
                If ((($Selection+1)%$RowQty) -eq 0 -or $Selection -eq $MaxValue) {
                    $Selection = ([Math]::Floor(($Selection)/$RowQty))*$RowQty
                    
                } Else {
                    $Selection += 1
                }
                Clear-Host
                break
            }
            49 { #1
                $Selection = 0
                $SelectionDone = $True
                Clear-Host
                break
            }
            50 { #2
                $Selection = 1
                $SelectionDone = $True
                Clear-Host
                break
            }
            51 { #3
                $Selection = 2
                $SelectionDone = $True
                Clear-Host
                break
            }
            52 { #4
                $Selection = 3
                $SelectionDone = $True
                Clear-Host
                break
            }
            53 { #5
                $Selection = 4
                $SelectionDone = $True
                Clear-Host
                break
            }
            54 { #6
                $Selection = 5
                $SelectionDone = $True
                Clear-Host
                break
            }
            55 { #7
                $Selection = 6
                $SelectionDone = $True
                Clear-Host
                break
            }
            56 { #8
                $Selection = 7
                $SelectionDone = $True
                Clear-Host
                break
            }
            Default {
                Clear-Host
            }
        }
    }
    Return $Selection
}

function SetConsoleSize() {
    [CmdletBinding()]
    Param(
         [Parameter(Mandatory=$False,Position=0)]
         [int]$Height = 40,
         [Parameter(Mandatory=$False,Position=1)]
         [int]$Width = 120
         )
    $console = $host.ui.rawui
    $ConBuffer  = $console.BufferSize
    $ConSize = $console.WindowSize
    $currWidth = $ConSize.Width
    $currHeight = $ConSize.Height

    if ($Height -gt $host.UI.RawUI.MaxPhysicalWindowSize.Height) {
        $Height = $host.UI.RawUI.MaxPhysicalWindowSize.Height
    }
    if ($Width -gt $host.UI.RawUI.MaxPhysicalWindowSize.Width) {
        $Width = $host.UI.RawUI.MaxPhysicalWindowSize.Width
    }
    If ($ConBuffer.Width -gt $Width ) {
       $currWidth = $Width
    }
    If ($ConBuffer.Height -gt $Height ) {
        $currHeight = $Height
    }

    $host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.size($Width,$Height)
    #$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.size($currWidth,$currHeight)
    $host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.size($Width,$Height)
}

Function SetWindowSize {
    [OutputType('System.Automation.WindowInfo')]
    [cmdletbinding()]
    Param (
        [parameter(ValueFromPipelineByPropertyName=$True)]
        $ProcessName,
        [int]$X,
        [int]$Y,
        [int]$Width,
        [int]$Height,
        [switch]$Passthru
    )
    Begin {
        Try{
            [void][Window]
        } Catch {
        Add-Type @"
              using System;
              using System.Runtime.InteropServices;
              public class Window {
                [DllImport("user32.dll")]
                [return: MarshalAs(UnmanagedType.Bool)]
                public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);

                [DllImport("User32.dll")]
                public extern static bool MoveWindow(IntPtr handle, int x, int y, int width, int height, bool redraw);
              }
              public struct RECT
              {
                public int Left;        // x position of upper-left corner
                public int Top;         // y position of upper-left corner
                public int Right;       // x position of lower-right corner
                public int Bottom;      // y position of lower-right corner
              }
"@
        }
    }
    Process {
        $Rectangle = New-Object RECT
            $Handle = (Get-Process -id $ProcessName).MainWindowHandle
        $Return = [Window]::GetWindowRect($Handle,[ref]$Rectangle)
        If (-NOT $PSBoundParameters.ContainsKey('Width')) {            
            $Width = $Rectangle.Right - $Rectangle.Left            
        }
        If (-NOT $PSBoundParameters.ContainsKey('Height')) {
            $Height = $Rectangle.Bottom - $Rectangle.Top
        }
        If ($Return) {
            $Return = [Window]::MoveWindow($Handle, $x, $y, $Width, $Height,$True)
        }
        If ($PSBoundParameters.ContainsKey('Passthru')) {
            $Rectangle = New-Object RECT
            $Return = [Window]::GetWindowRect($Handle,[ref]$Rectangle)
            If ($Return) {
                $Height = $Rectangle.Bottom - $Rectangle.Top
                $Width = $Rectangle.Right - $Rectangle.Left
                $Size = New-Object System.Management.Automation.Host.Size -ArgumentList $Width, $Height
                $TopLeft = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Left, $Rectangle.Top
                $BottomRight = New-Object System.Management.Automation.Host.Coordinates -ArgumentList $Rectangle.Right, $Rectangle.Bottom
                If ($Rectangle.Top -lt 0 -AND $Rectangle.LEft -lt 0) {
                    Write-Warning "Window is minimized! Coordinates will not be accurate."
                }
                $Object = [pscustomobject]@{
                    ProcessName = $ProcessName
                    Size = $Size
                    TopLeft = $TopLeft
                    BottomRight = $BottomRight
                }
                $Object.PSTypeNames.insert(0,'System.Automation.WindowInfo')
                $Object            
            }
        }
    }
}

function MaximizeWindow {
    $Win32MaximizeWindow = Add-Type –memberDefinition @” 
    [DllImport("user32.dll")] 
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
“@ -name “Win32MaximizeWindow” -namespace Win32Functions –passThru

    $Win32MaximizeWindow::ShowWindowAsync($((Get-Process -Id $pid).MainWindowHandle), 3) | Out-Null
}

Function RemoveUSBDrive {
    $drive = Get-WmiObject win32_diskdrive | Where-Object { $_.InterfaceType -eq "USB" }
    if ($drive.Size -gt 0) {
        Write-Host -ForegroundColor Yellow "`r`nOBS! Ta ut USB-pinnen for å fortsette`r`n"
    }
    while ($drive.Size -gt 0) {
        $drive = Get-WmiObject win32_diskdrive | Where-Object { $_.InterfaceType -eq "USB" }
        Start-Sleep -Seconds 1
    }
}







#Start-Transcript -Path c:\OSDCloud\debugmenu.log -ErrorAction SilentlyContinue
cls
Write-Host -ForegroundColor Green "Starter OSDCloud menyen.."

#Endre Display Resolution for Virtual Machine
if ((Get-MyComputerModel) -match 'Virtual') {
    #Write-Host -ForegroundColor Green "Setter Skjermoppløsningen til 1600x"
    Set-DisRes 1600
}

#SetWindowSize -ProcessName $pid -X -7 -Y 0 -Width 800 -Height 600
MaximizeWindow
SetConsoleSize -Height 500 -Width 1200

#Start OSDCloud ZTI

$VerbosePreference = "SilentlyContinue"

[string]$Menytittel = `

"======================= BEWI =========================================`r`n" + `
"===== Select the Windows version to be installed on the machine ======`r`n" + `
"======================================================================"

[array]$MenyValg = @(
"1: Zero-Touch Win10 22H2      | Standard BEWI image     | Norwegian",
"2: Zero-Touch Win10 22H2      | Standard BEWI image     | Swedish",
"3: Zero-Touch Win10 22H2      | Standard BEWI image     | Danish",
"4: Zero-Touch Win10 22H2      | Standard BEWI image     | English",
"5: Zero-Touch Win11 22H2      | Standard BEWI image     | Norwegian",
"6: Zero-Touch Win11 22H2      | Standard BEWI image     | Swedish",
"7: Zero-Touch Win11 22H2      | Standard BEWI image     | Danish",
"8: Zero-Touch Win11 22H2      | Standard BEWI image     | English",
"9: Start OSDCloud GUI (custom)| ",
"e: Exit"
)
[int]$MaksBredde = 0
foreach ($valg in $MenyValg) {
    if ($valg.Length -gt $MaksBredde) {
        $MaksBredde = $valg.Length
    }
}
$MaksBredde += 2

$input = Create-Menu -MenuTitle $Menytittel -MenuOptions $MenyValg -Columns 1 -MaximumColumnWidth $MaksBredde -ShowCurrentSelection $True

#Stop-Transcript

switch ($input)
{
    0 {
        Write-Host  -ForegroundColor Yellow "Starter BEWI Windows 10 Norsk tanking..."
        RemoveUSBDrive
        Start-OSDCloud -OSLanguage nb-no -OSVersion "Windows 10" -OSBuild 22H2 -OSEdition Enterprise -ZTI
        
      } 
    1 {
        Write-Host  -ForegroundColor Yellow "Starter BEWI Windows 10 Svensk tanking..."
        RemoveUSBDrive
        Start-OSDCloud -OSLanguage sv-se -OSVersion "Windows 10" -OSBuild 22H2 -OSEdition Enterprise -ZTI
      } 
    2 {
        Write-Host  -ForegroundColor Yellow "Starter BEWI Windows Dansk 10 tanking..."
        RemoveUSBDrive
        Start-OSDCloud -OSLanguage da-dk -OSVersion "Windows 10" -OSBuild 22H2 -OSEdition Enterprise -ZTI
        
      }
    3 {
        Write-Host  -ForegroundColor Yellow "Starter BEWI Windows Engelsk 10 tanking..."
        RemoveUSBDrive
        Start-OSDCloud -OSLanguage en-gb -OSVersion "Windows 10" -OSBuild 22H2 -OSEdition Enterprise -ZTI
        
      }
    4 {
        Write-Host  -ForegroundColor Cyan "Starter BEWI Windows Norsk 11 tanking..."
        RemoveUSBDrive
        Start-OSDCloud -OSLanguage nb-no -OSVersion "Windows 11" -OSBuild 22H2 -OSEdition Enterprise -ZTI
        
      }
    5 {
        Write-Host  -ForegroundColor Cyan "Starter BEWI Windows Svensk 11 tanking..."
        RemoveUSBDrive
        Start-OSDCloud -OSLanguage sv-se -OSVersion "Windows 11" -OSBuild 22H2 -OSEdition Enterprise -ZTI
        
      }
    6 {
        Write-Host  -ForegroundColor Cyan "Starter BEWI Windows Dansk 11 tanking..."
        RemoveUSBDrive
        Start-OSDCloud -OSLanguage da-dk -OSVersion "Windows 11" -OSBuild 22H2 -OSEdition Enterprise -ZTI
        
      }
    7 {
        Write-Host  -ForegroundColor Cyan "Starter BEWI Windows Engelsk 11 tanking..."
        RemoveUSBDrive
        Start-OSDCloud -OSLanguage en-gb -OSVersion "Windows 10" -OSBuild 22H2 -OSEdition Enterprise -ZTI
        
      }
    8 {
        Write-Host  -ForegroundColor gray "Starter OSDCloud GUI.."
        RemoveUSBDrive
        Start-OSDCloudGui -Brand "BEWI"
      }
   
      
    e {
        Write-Host  -ForegroundColor Yellow "Exit..."
      }
}

Write-Host -ForegroundColor Green "Restarter om 5 sekunder!"

Start-Sleep -Seconds 5

wpeutil reboot
