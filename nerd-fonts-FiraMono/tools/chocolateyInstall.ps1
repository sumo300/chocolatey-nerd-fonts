$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.3.0/FiraMono.zip'
  checksumType   = 'sha256'
  checksum       = '09046EA03D7302305253C93459252D5E9ADC10C4581B70DFE19F7FEA3D672A4A'
}

Install-ChocolateyZipPackage @packageArgs

# Install all OpenType Fonts in package
Push-Location $toolsDir

# Get list of all Windows Compatible OpenType Fonts in package
$fontList = Get-ChildItem "*Windows Compatible*.otf"

if ($fontList.Count -le 0) {
  # Get list of all OpenType Fonts in package
  $fontList = Get-ChildItem *.otf
}

# Use the TrueType fonts only if the OpenType files are missing
if ($fontList.Count -le 0) {
  # Get list of all Windows Compatible TrueType Fonts in package
  $fontList = Get-ChildItem "*Windows Compatible*.ttf"
}
if ($fontList.Count -le 0) {
  # Get list of all TrueType Fonts in package
  $fontList = Get-ChildItem *.ttf
}

# Installs fonts in Paths list and keeps track of the list for uninstall later
$installCount = Install-ChocolateyFont -Paths $fontList -Multiple
Write-Host "$installCount fonts installed"

Pop-Location
