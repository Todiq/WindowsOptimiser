@echo off
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo .
@echo ---------------------------------------------------------------------------------
@echo --------------------------------DISABLE HIBERNATE--------------------------------
@echo ---------------------------------------------------------------------------------
powercfg -h off
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
@echo --------------------------------------------------------------------------------------
@echo --------------------------------IMPORT NVIDIA SETTINGS--------------------------------
@echo --------------------------------------------------------------------------------------
_nvidiaProfileInspector.exe "C:\Windows\_NvidiaBaseProfile.nip"
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
@echo --------------------------------------------------------------------------------------
@echo --------------------------------ENABLE MSI MODE NVIDIA--------------------------------
@echo --------------------------------------------------------------------------------------
powershell -executionpolicy bypass -file "C:\Windows\_EnableMSINVIDIA.ps1"
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
@echo ------------------------------------------------------------------------------------------------
@echo --------------------------------INSTALL TIMER RESOLUTION SERVICE--------------------------------
@echo ------------------------------------------------------------------------------------------------
_SetTimerResolutionService.exe -install
sc config STR start=auto
net start STR
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
@echo --------------------------------------------------------------------------------------------
@echo --------------------------------REBUILD PERFORMANCE COUNTERS--------------------------------
@echo --------------------------------------------------------------------------------------------
lodctr /r
lodctr /r
@echo .
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
@echo --------------------------------------------------------------------------------------
@echo --------------------------------IMPORT REGISTRY TWEAKS--------------------------------
@echo --------------------------------------------------------------------------------------
_RegistryTweaks.reg
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
@echo -----------------------------------------------------------------------------------
@echo --------------------------------TRANSFER USER FILES-------------------------------- 
@echo -----------------------------------------------------------------------------------
robocopy "C:\Windows\Administrateur" "C:\Users\Administrateur" /MT /NFL /NDL /NJH /NJS /nc /ns /np /E /MOVE 
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
@echo ----------------------------------------------------------------------------------------------------
@echo --------------------------------DEBLOAT SCRIPT LOADING (PLEASE WAIT)-------------------------------- 
@echo ----------------------------------------------------------------------------------------------------
powershell -executionpolicy bypass -file "C:\Windows\_DebloatScript.ps1"
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