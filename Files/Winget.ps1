$ProgressPreference = 'SilentlyContinue'

Function Install-WinGet
{
	$winget = "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
	$license = "7b91bd4a0be242d6aa8e8da282b26297_License1.xml"
	$vclibs = "Microsoft.VCLibs.x64.14.00.Desktop.appx"

	$githubURL = [System.Net.HttpWebRequest]::Create("https://github.com/microsoft/winget-cli/releases/latest").GetResponse().ResponseUri.AbsoluteUri
	$githubURL = "$githubURL" -replace "(.*)tag(.*)", '$1download$2'

	$wingetURL = "$githubURL/$winget"
	$licenseURL = "$githubURL/$license"
	$vclibsURL = "https://aka.ms/$vclibs"

	$location = "$ENV:Temp"

	if ((Test-Path -Path "$location\$vclibs") -eq $FALSE) {
		cURL.exe -Lo "$location\$vclibs" "$vclibsURL"
	}
	if ((Test-Path -Path "$location\$winget") -eq $FALSE) {
		cURL.exe -Lo "$location\$winget" "$wingetURL"
	}
	if ((Test-Path -Path "$location\$license") -eq $FALSE) {
		cURL.exe -Lo "$location\$license" "$licenseURL"
	}
	Add-AppxProvisionedPackage -Online -PackagePath "$location\$vclibs" -SkipLicense
	Add-AppxProvisionedPackage -Online -PackagePath "$location\$winget" -LicensePath "$location\$license"
}

Install-WinGet