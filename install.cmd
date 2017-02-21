REM   Run an unsigned PowerShell script and log the output
PowerShell -ExecutionPolicy Unrestricted .\install-bots.ps1 >> "%TEMP%\StartupLog.txt" 2>&1

REM   If an error occurred, return the errorlevel.
EXIT /B %errorlevel%
