@echo off
@echo ----------------------------------------------------------------------------------------------------
@echo --------------------------------OPTIMISING (PLEASE WAIT)--------------------------------
@echo ----------------------------------------------------------------------------------------------------
powershell -executionpolicy bypass -file "%~dp0\Files\Optimisations.ps1"
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
pause
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