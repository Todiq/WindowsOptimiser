@echo off
powershell.exe -ExecutionPolicy Bypass -Command "$ProgressPreference = 'SilentlyContinue'; Invoke-WebRequest 'https://live.sysinternals.com/Autoruns64.exe' -OutFile C:\Windows\Autoruns.exe"
autoruns