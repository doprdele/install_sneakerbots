Param( [Parameter(Mandatory=$true)][boolean]$InstallANB,
[Parameter(Mandatory=$true)][boolean]$InstallBNBAIO,
[Parameter(Mandatory=$true)][boolean]$InstallBNBNIKE,
[Parameter(Mandatory="")][string]$BNBAIOLicenseKey,
[Parameter(Mandatory="")][string]$BNBNIKELicenseKey
)

function install_bnb {
    param( [string]$ExecutablePath, [string]$WindowId, [string]$LicenseKey, [string]$InstallationPath )


    # C:\tmp\BNB-AIO-Setup.exe
    & $ExecutablePath

    # WindowId = BNB-AIO-Setup.tmp

    $p = [Environment]::GetEnvironmentVariable("PSModulePath")
    $p += ";C:\tmp\WASP\"
    [Environment]::SetEnvironmentVariable("PSModulePath",$p)
    Import-Module c:\tmp\WASP

    DO {
        Start-Sleep -Seconds 1
    } while([string]::IsNullOrEmpty((Select-Window $WindowId).title))

    Select-Window $WindowId | Set-WindowActive
    Select-Window $WindowId | Send-Keys "%{n}"

    DO {
        Start-Sleep -Seconds 1
    } while([string]::IsNullOrEmpty((Select-Window $WindowId|Select -First 1).handle))

    Select-Window $WindowId | Send-Keys $LicenseKey
    # Start-Sleep -Seconds 5

    DO {
        Start-Sleep -Seconds 1
    } while([string]::IsNullOrEmpty((Select-Window $WindowId|Select -First 1).handle))


    Select-Window $WindowId | Send-Keys "%{n}"

    DO {
        Start-Sleep -Seconds 1
    } while([string]::IsNullOrEmpty((Select-Window $WindowId|Select -First 1).handle))

    Select-Window $WindowId | Send-Keys "%{n}"

    DO {
        Start-Sleep -Seconds 1
    } while([string]::IsNullOrEmpty((Select-Window $WindowId|Select -First 1).handle))

    Select-Window $WindowId | Send-Keys "%{n}"

    DO {
        Start-Sleep -Seconds 1
    } while([string]::IsNullOrEmpty((Select-Window $WindowId|Select -First 1).handle))

    Select-Window $WindowId | Send-Keys "%{n}"


    DO {
        Start-Sleep -Seconds 1
    } while([string]::IsNullOrEmpty((Select-Window $WindowId|Select -First 1).handle))

    Select-Window $WindowId | Send-Keys "%{I}"
    Start-Sleep -Seconds 10

    DO {
        Start-Sleep -Seconds 1
    } while([string]::IsNullOrEmpty((Select-Window $WindowId|Select -First 1).handle))

    Select-Window $WindowId|Send-Keys ' '
    Start-Sleep -Seconds 1
    Select-Window $WindowId|Send-Keys '%{F}'

    Wait-Process -Name $WindowId

    DO {
        Start-Sleep -Seconds 1
    } while(![System.IO.File]::Exists("${InstallationPath}\wyUpdate.exe"))

    & "${InstallationPath}\wyUpdate.exe" /skipinfo

    DO {
        Start-Sleep -Seconds 1
    } while([string]::IsNullOrEmpty((Select-Window wyUpdate|select-control -title "Finish").handle))
    Select-Window wyUpdate|select-control -title "Finish"|Send-Click

    Wait-Process -Name wyUpdate
}


function bootstrap {
    Param(
        [Parameter(Mandatory=$true)][boolean]$InstallANB,
        [Parameter(Mandatory=$true)][boolean]$InstallBNBAIO,
        [Parameter(Mandatory=$true)][boolean]$InstallBNBNIKE,
        [Parameter(Mandatory="")][string]$BNBAIOLicenseKey,
        [Parameter(Mandatory="")][string]$BNBNIKELicenseKey
    )

    # Enable dotNet 3.5 and download all setup files
    dism /online /enable-feature /featurename:netfx3 /all

    if ($InstallANB) {
        wget "https://f001.backblazeb2.com/file/sneakerbotinstallations/AIO+Bot+Setup.exe" -OutFile "C:\tmp\ANB-AIO-Setup.exe"
    }
    if ($InstallBNBAIO) {
        wget "https://f001.backblazeb2.com/file/sneakerbotinstallations/BNB+All+in+One+(setup).exe" -OutFile "C:\tmp\BNB-AIO-Setup.exe"
    }
    if ($InstallBNBNIKE) {
        wget "https://f001.backblazeb2.com/file/sneakerbotinstallations/Better+Nike+Bot+(setup).exe" -OutFile "C:\tmp\BNB-Nike-Setup.exe"
    }

    # Run ANB setup
    if ($InstallANB) {
        C:\tmp\ANB-AIO-Setup.exe /verysilent
    }

    # Download window controller
    wget "https://www.dropbox.com/s/5c8wbzkrf6qa1q4/WASP.zip?dl=1" -OutFile C:\tmp\WASP.zip
    $shell = new-object -com shell.application
    $zip = $shell.NameSpace(“C:\tmp\WASP.zip”)
    foreach($item in $zip.items()) {
        $shell.Namespace(“C:\tmp\”).copyhere($item)
    }
    $p = [Environment]::GetEnvironmentVariable("PSModulePath")
    $p += ";C:\tmp\WASP\"
    [Environment]::SetEnvironmentVariable("PSModulePath",$p)
    Import-Module c:\tmp\WASP

    # Update AnB
    if ($InstallANB) {
        DO {
            Start-Sleep -Seconds 5
        } while(![System.IO.File]::Exists("C:\Program Files (x86)\AIO Bot\wyUpdate.exe"))

        & "C:\Program Files (x86)\AIO Bot\wyUpdate.exe" /skipinfo

        DO {
            Start-Sleep -Seconds 5
        } while([string]::IsNullOrEmpty((Select-Window wyUpdate|select-control -title "Finish").handle))
        Select-Window wyUpdate|select-control -title "Finish"|Send-Click

        Wait-Process -Name wyUpdate

        # Create AnB shortcut
        $ANB_AIO = "C:\Program Files (x86)\AIO Bot\AIO Bot.exe"
        $ANB_AIO_SHORTCUT = "$env:Public\Desktop\Another Nike Bot (AIO).lnk"
        $WScriptShell = New-Object -ComObject WScript.Shell
        $Shortcut = $WScriptShell.CreateShortcut($ANB_AIO_SHORTCUT)
        $Shortcut.WorkingDirectory = "C:\Program Files (x86)\AIO Bot\"
        $Shortcut.Description = "Another Nike Bot (AIO)"
        $Shortcut.TargetPath = $ANB_AIO
        $Shortcut.Save()
    }
    # Install BnB AIO

    if ($InstallBNBAIO) {
        install_bnb -ExecutablePath "C:\tmp\BNB-AIO-Setup.exe" -WindowId "BNB-AIO-Setup.tmp" -LicenseKey $BNBAIOLicenseKey -InstallationPath "C:\Program Files (x86)\BNB All in One"
    }
    if ($InstallBNBNIKE) {
        install_bnb -ExecutablePath "C:\tmp\BNB-Nike-Setup.exe" -WindowId "BNB-Nike-Setup.tmp" -LicenseKey $BNBNIKELicenseKey -InstallationPath "C:\Program Files (x86)\Better Nike Bot"
    }
    # Install BnB Nike
}

bootstrap -InstallANB $InstallANB -InstallBNBAIO $InstallBNBAIO -InstallBNBNIKE $InstallBNBNIKE -BNBAIOLicenseKey $BNBAIOLicenseKey -BNBNIKELicenseKey $BNBNIKELicenseKey
