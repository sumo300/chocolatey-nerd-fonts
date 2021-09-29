$ErrorActionPreference = 'Stop'

$uninstallCount = Uninstall-ChocolateyFont
Write-Host "$uninstallCount fonts uninstalled"