@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------
@echo ----------------------------------------------------------------------------------------------------
@echo --------------------------------OPTIMISING (PLEASE WAIT)--------------------------------
@echo ----------------------------------------------------------------------------------------------------
powershell -executionpolicy bypass -file "%~dp0\_Post install\Optimisations.ps1"
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo -----------------------------------------------------------------------------
@echo --------------------------------RESTARTING PC--------------------------------
@echo -----------------------------------------------------------------------------
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
pause
C:\Windows\System32\shutdown.exe /r /t 0