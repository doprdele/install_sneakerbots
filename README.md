install_sneakerbots
===================
This powershell script installs ANB AIO, BNB AIO and BNB (Nike).

In VULTR, create a startup script which resembles the following,
replacing the placeholders with your license keys.

```
@echo off

powershell wget "https://www.dropbox.com/s/8hljwbfv0ymx2ej/install-bots.ps1?dl=1" -OutFile "C:\tmp\install-bots.ps1"

C:\Windows\sysnative\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy ByPass -NoProfile C:\tmp\install-bots.ps1 -InstallANB $true -InstallBNBAIO $true -InstallBNBNIKE $true -BNBAIOLicenseKey "BNB-AIO-LICENSE-KEY-HERE" -BNBNIKELicenseKey "BNB-NIKE-LICENSE-KEY-HERE" >> "C:\tmp\StartupLog.txt" 2>&1
```

Select this startup script when creating a new virtual machine.

Set any of these 'Install' arguments to `$false` if you do not wish to install one of the components.
