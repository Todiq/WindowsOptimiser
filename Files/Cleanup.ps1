Function Remove-TmpFiles
{
	Get-ChildItem -Path "C:\Windows\Temp" *.* -Recurse | Remove-Item -Force -Recurse
	Get-ChildItem -Path "$ENV:Temp" *.* -Recurse | Remove-Item -Force -Recurse
	Start-Process "$env:WinDir\System32\cleanmgr.exe" -Wait -ArgumentList "/VERYLOWDISK"
}

Remove-TmpFiles