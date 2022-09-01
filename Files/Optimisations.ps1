$ProgressPreference = 'SilentlyContinue'

Function Remove-DefaultApps()
{
	$Apps = @("Disney.37853FC22B2CE", "Microsoft.549981C3F5F10", "Microsoft.BingNews",
	"Microsoft.BingWeather", "Microsoft.GetHelp", "Microsoft.Getstarted",
	"Microsoft.Microsoft3DViewer", "Microsoft.MicrosoftOfficeHub", "Microsoft.MicrosoftSolitaireCollection",
	"Microsoft.MicrosoftStickyNotes", "Microsoft.MixedReality.Portal", "Microsoft.Office.OneNote",
	"Microsoft.OneDriveSync", "Microsoft.People", "Microsoft.PowerAutomateDesktop",
	"Microsoft.ScreenSketch", "Microsoft.SkypeApp", "Microsoft.Todos", "Microsoft.Wallet",
	"Microsoft.WindowsAlarms", "Microsoft.WindowsCamera", "Microsoft.WindowsFeedbackHub",
	"Microsoft.WindowsMaps", "Microsoft.WindowsSoundRecorder", "Microsoft.YourPhone",
	"Microsoft.ZuneMusic", "Microsoft.ZuneVideo", "MicrosoftTeams", "MicrosoftWindows.Client.WebExperience",
	"SpotifyAB.SpotifyMusic", "microsoft.windowscommunicationsapps")

	ForEach ($App in $Apps) {
		Get-AppxPackage -AllUsers $App | Remove-AppxPackage
	}
	C:\Windows\SysWOW64\OneDriveSetup.exe -uninstall
	Get-WindowsPackage -Online | Where PackageName -like *QuickAssist* | Remove-WindowsPackage -Online -NoRestart
}

Function Import-RegistryKeys()
{
	reg import "$PSScriptRoot\Registry Tweaks.reg"
}

Function Remove-StartMenu-Tiles()
{
	robocopy "$PSScriptRoot" "$env:localappdata\microsoft\Windows\Shell" "LayoutModification.xml" /nfl /ndl /njh /njs /nc /ns /np
}

Function Add-StartMenu-Shortcuts()
{
	$startMenuFolder = "$env:appdata\Microsoft\Windows\StartMenu\Programs"

	$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$startMenuFolder\Corbeille.lnk")
	$Shortcut.TargetPath = "shell:RecycleBinFolder"
	$Shortcut.Save()

	New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Remove US keyboard" -Target "$PSScriptRoot\Remove US keyboard.bat"
	New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Start menu shortcuts 1" -Target "$env:AppData\Microsoft\Windows\Start Menu\Programs"
	New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Start menu shortcuts 2" -Target "C:\ProgramData\Microsoft\Windows\Start Menu\Programs"
	New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Startup programs" -Target "%AppData%\Microsoft\Windows\Start Menu\Programs\Startup"
}

Function Download-NvidiaProfileInspector()
{
	Invoke-WebRequest 'https://github.com/Orbmu2k/nvidiaProfileInspector/releases/download/2.3.0.10/nvidiaProfileInspector.zip' -OutFile "$env:temp\Nvidia.zip"
	Expand-Archive "$env:temp\Nvidia.zip" -DestinationPath "$PSScriptRoot"
}

Function Import-NvidiaProfile()
{
	"$PSScriptRoot\nvidiaProfileInspector.exe" "$PSScriptRoot\NvidiaBaseProfile.nip"
}

Function Enable-MSIMode-Nvidia()
{
	$devices = Get-Childitem -path HKLM:\SYSTEM\CurrentControlSet\Enum\PCI

	Foreach ($device in $devices) {
		$Properties = Get-ChildItem -path $device.PSPath | Get-ItemProperty
		if ($Properties.DeviceDesc | Select-String -Pattern "nvidia" -SimpleMatch) {
			$MSIKey = $Properties.PSPath + "\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
			New-ItemProperty -Path $MSIKey -Name "MSISupported" -Value 1 -PropertyType DWORD -Force;
		}
	}
}

Function Install-Bitsum-PowerPlan()
{
	powercfg -import $Path 77777777-7777-7777-7777-777777777777
	powercfg -SETACTIVE "77777777-7777-7777-7777-777777777777"
}

Function Remove-Other-PowerPlans()
{
	powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e
	powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
	powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a
}

Function Disable-Hibernation()
{
	powercfg -h off
}

# Reduce the quantity of svchost processes
Function Update-SvcHost-Threshold()
{
	# Get RAM quantity in KB. Replace "1024" by "1gb" to get in GB
	$RAM = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum / 1024

	# Convert to decimal
	$RAM = [Convert]::ToInt64($RAM)

	if ($RAM -ge 4194304) {
		New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Value $RAM -PropertyType DWORD -Force
	}
}

Function Install-TimerResolution-Service()
{
	"$PSScriptRoot\SetTimerResolutionService.exe" -install
	Set-Service -Name "STR" -StartupType Automatic
	Start-Service -Name "STR"
}

Function Remove-TmpFiles()
{
	Get-ChildItem -Path "C:\Windows\Temp" *.* -Recurse | Remove-Item -Force -Recurse
	Get-ChildItem -Path "$ENV:Temp" *.* -Recurse | Remove-Item -Force -Recurse
	cleanmgr.exe /VERYLOWDISK
}

Function main()
{
	$Chassis = Get-WmiObject -Class win32_systemenclosure -ComputerName $env:ComputerName | Where-Object { $_.chassistypes -eq 9 -or $_.chassistypes -eq 10 -or $_.chassistypes -eq 14}
	$Battery = Get-WmiObject -Class win32_battery -ComputerName $env:ComputerName
	if ($Chassis == $False -and $Battery == $FALSE) {
		Install-Bitsum-PowerPlan
		Remove-Other-PowerPlans
	}
	Disable-Hibernation
	Update-SvcHost-Threshold
	Install-TimerResolution-Service
	Remove-DefaultApps
	Import-RegistryKeys
	Remove-StartMenu-Tiles
	Add-StartMenu-Shortcuts

	Enable-MSIMode-Nvidia
	Download-NvidiaProfileInspector
	Import-NvidiaProfile

	Remove-TmpFiles
}

main