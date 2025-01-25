$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/adam7/delugia-code/releases/download/v2404.23/delugia-powerline.zip'
  checksumType   = 'sha256'
  checksum       = '4BAF2F2A151EDA7559F7CAC7C378768CA5A80CE7B79B0FB3F93A87FF9F5B79CA'
}

Install-ChocolateyZipPackage @packageArgs

# Install all OpenType Fonts in package
Push-Location $toolsDir

# Get list of all Windows Compatible OpenType Fonts in package
$fontList = Get-ChildItem "*Windows Compatible*.otf" -Recurse

if ($fontList.Count -le 0) {
  # Get list of all OpenType Fonts in package
  $fontList = Get-ChildItem *.otf -Recurse
}

# Use the TrueType fonts only if the OpenType files are missing
if ($fontList.Count -le 0) {
  # Get list of all Windows Compatible TrueType Fonts in package
  $fontList = Get-ChildItem "*Windows Compatible*.ttf" -Recurse
}
if ($fontList.Count -le 0) {
  # Get list of all TrueType Fonts in package
  $fontList = Get-ChildItem *.ttf -Recurse
}

if (Test-Path -Path "$env:TEMP\$packageName.upgrade") {
  $fileNamesList = $fontList | Select-Object -ExpandProperty Name

  # Uninstalls fonts that were installed by this package
  $uninstallCount = Uninstall-ChocolateyFont $fileNamesList -Multiple
  Write-Host "$uninstallCount fonts uninstalled"
}

# Installs fonts in Paths list and keeps track of the list for uninstall later
$installCount = Install-ChocolateyFont -Paths $fontList -Multiple
Write-Host "$installCount fonts installed"

Pop-Location
