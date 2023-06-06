$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/ComicShannsMono.zip'
  checksumType   = 'sha256'
  checksum       = '064DF98920365A828C85C97E805FBD8EC1EBD1D3A6D7F7145E5DE7A3F4567141'
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
