$ProgressPreference = 'SilentlyContinue'

Function Remove-DefaultApps
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
	Start-Process -FilePath "$env:SystemRoot\SysWOW64\OneDriveSetup.exe" -Wait -ArgumentList "-uninstall"
	Get-WindowsPackage -Online | Where PackageName -like *QuickAssist* | Remove-WindowsPackage -Online -NoRestart
}

Function Import-RegistryKeys
{
	reg import "$PSScriptRoot\Registry Tweaks.reg"
}

Function Remove-StartMenuTiles
{
	Remove-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount" -Recurse -Force
	Import-StartLayout -LayoutPath "$PSScriptRoot\LayoutModification.xml" -MountPath "$env:SystemDrive\"
}

Function Add-StartMenuShortcuts
{
	$startMenuFolder = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"

	$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$startMenuFolder\Corbeille.lnk")
	$Shortcut.TargetPath = "shell:RecycleBinFolder"
	$Shortcut.Save()

	$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$startMenuFolder\Remove US keyboard.lnk")
	$Shortcut.TargetPath = "$PSScriptRoot\Remove US keyboard.bat"
	$Shortcut.Save()

	$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$startMenuFolder\Start menu shortcuts 1.lnk")
	$Shortcut.TargetPath = "$env:AppData\Microsoft\Windows\Start Menu\Programs"
	$Shortcut.Save()

	$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$startMenuFolder\Start menu shortcuts 2.lnk")
	$Shortcut.TargetPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
	$Shortcut.Save()

	$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$startMenuFolder\Startup programs.lnk")
	$Shortcut.TargetPath = "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup"
	$Shortcut.Save()

	$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$startMenuFolder\Paint.lnk")
	$Shortcut.TargetPath = "$env:WinDir\system32\mspaint.exe"
	$Shortcut.Save()

	$Shortcut = (New-Object -comObject WScript.Shell).CreateShortcut("$startMenuFolder\Bloc-notes.lnk")
	$Shortcut.TargetPath = "$env:WinDir\system32\notepad.exe"
	$Shortcut.Save()
}

Function Remove-StartMenuDefaultShortcuts
{
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories" -Recurse -Force
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Maintenance" -Recurse -Force
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Accessibility" -Recurse -Force
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools" -Recurse -Force
	Remove-Item -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\System Tools" -Recurse -Force
	Remove-ChildItem -Path "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Edge.lnk" -Force
	Remove-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Accessories" -Recurse -Force
	Remove-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Maintenance" -Recurse -Force
	Remove-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Accessibility" -Recurse -Force
	Remove-Item -Path "$env:AppData\Microsoft\Windows\Start Menu\Programs\Administrative Tools" -Recurse -Force
	#New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Remove US keyboard" -Target "$PSScriptRoot\Remove US keyboard.bat"
	#New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Start menu shortcuts 1" -Target "$env:AppData\Microsoft\Windows\Start Menu\Programs"
	#New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Start menu shortcuts 2" -Target "$env:ProgramData\Microsoft\Windows\Start Menu\Programs"
	#New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Startup programs" -Target "$env:AppData\Microsoft\Windows\Start Menu\Programs\Startup"
	#New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Paint" -Target "$env:WinDir\system32\mspaint.exe"
	#New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Bloc-notes" -Target "$env:WinDir\system32\notepad.exe"
	#New-Item -ItemType SymbolicLink -Path "$startMenuFolder\Panneau de configuration" -Target "$env:WinDir\system32\control.exe"
}

Function Download-NvidiaProfileInspector
{
	$URL = [System.Net.HttpWebRequest]::Create("https://github.com/Orbmu2k/nvidiaProfileInspector/releases/latest").GetResponse().ResponseUri.AbsoluteUri
	$URL = "$URL" -replace "(.*)tag(.*)", '$1download$2'
	Invoke-WebRequest "$URL\nvidiaProfileInspector.zip" -OutFile "$env:temp\nvidiaProfileInspector.zip"
	Expand-Archive "$env:temp\nvidiaProfileInspector.zip" -DestinationPath "$PSScriptRoot\nvidiaProfileInspector"
}

Function Import-NvidiaProfile
{
	Start-Process `
	-FilePath "$PSScriptRoot\nvidiaProfileInspector\nvidiaProfileInspector.exe" `
	-Workdir "$PSScriptRoot\nvidiaProfileInspector\" `
	-Wait `
	-ArgumentList "$PSScriptRoot\NvidiaBaseProfile.nip"
}

Function Enable-MSIModeNvidia
{
	$devices = Get-ChildItem -path HKLM:\SYSTEM\CurrentControlSet\Enum\PCI

	Foreach ($device in $devices) {
		$Properties = Get-ChildItem -path $device.PSPath | Get-ItemProperty
		if ($Properties.DeviceDesc | Select-String -Pattern "nvidia" -SimpleMatch) {
			$MSIKey = $Properties.PSPath + "\Device Parameters\Interrupt Management\MessageSignaledInterruptProperties"
			New-ItemProperty -Path $MSIKey -Name "MSISupported" -Value 1 -PropertyType DWORD -Force;
		}
	}
}

Function Install-BitsumPowerPlan
{
	powercfg -import $Path 77777777-7777-7777-7777-777777777777
	powercfg -SETACTIVE "77777777-7777-7777-7777-777777777777"
}

Function Remove-OtherPowerPlans
{
	powercfg -delete 381b4222-f694-41f0-9685-ff5bb260df2e
	powercfg -delete 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
	powercfg -delete a1841308-3541-4fab-bc81-f71556f20b4a
}

Function Disable-Hibernation
{
	powercfg -h off
}

# Reduce the quantity of svchost processes
Function Update-SvcHostThreshold
{
	# Get RAM quantity in KB. Replace "1024" by "1gb" to get in GB
	$RAM = (Get-CimInstance Win32_PhysicalMemory | Measure-Object -Property capacity -Sum).sum / 1024

	# Convert to decimal
	$RAM = [Convert]::ToInt64($RAM)

	if ($RAM -ge 4194304) {
		New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Value $RAM -PropertyType DWORD -Force
	}
}

Function Remove-DesktopEdgeShortcuts
{
	Remove-Item "$env:SystemDrive\Users\Public\Desktop\Microsoft Edge.lnk"
	Remove-Item "$env:SystemDrive\$env:HomePath\Desktop\Microsoft Edge.lnk"
}

Function Install-C++Packages
{
	Start-Process -FilePath "$PSScriptRoot\VisualCppRedist_AIO_x86_x64.exe" -Wait -ArgumentList "/ai /gm2"
}

Function Install-TimerResolutionService
{
	Start-Process -FilePath "$PSScriptRoot\SetTimerResolutionService.exe" -Wait -ArgumentList "-install"
	Set-Service -Name "STR" -StartupType Automatic
	Start-Service -Name "STR"
}

Function main
{
	$Battery = Get-CimInstance -Class CIM_Battery
	if ($Battery -eq $NULL -or $Battery.Availability -eq "" -or $Battery.Availability -eq 11) {
		Write-Host "Installing Bitsum PowerPlan"
		Install-BitsumPowerPlan
		Remove-OtherPowerPlans
		Disable-Hibernation
	}
	#Update-SvcHostThreshold
	Install-C++Packages
	Install-TimerResolutionService
	Remove-DefaultApps
	Import-RegistryKeys
	Remove-StartMenuTiles
	Add-StartMenuShortcuts
	Remove-StartMenuDefaultShortcuts
	Remove-DesktopEdgeShortcuts

	$GpuBrand = (Get-WmiObject Win32_VideoController).Name
	if ($GpuBrand -match "nvidia") {
		"Write-Host Importing Nvidia optimised settings"
		Enable-MSIModeNvidia
		Download-NvidiaProfileInspector
		Import-NvidiaProfile
	}
	Restart-Computer
}

main