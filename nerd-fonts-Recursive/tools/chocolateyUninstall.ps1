$ErrorActionPreference = 'Stop'

# Uninstalls fonts that were installed by this package
$uninstallCount = Uninstall-ChocolateyFont
Write-Host "$uninstallCount fonts uninstalled"