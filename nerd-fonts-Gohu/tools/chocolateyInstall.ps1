$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Gohu.zip'
  checksumType   = 'sha256'
  checksum       = '056C70455743518B92634EEF24EE762EE58F9C18449400854D2DFF89226D6E33'
}

Install-ChocolateyZipPackage @packageArgs

# Install all Open Type Fonts in package
Push-Location $toolsDir
$fontList = Get-ChildItem "*Windows Compatible*.otf" -Recurse

# Get list of TrueType fonts instead if OpenType fonts are missing
if ($fontList.Count -le 0) {
  $fontList = Get-ChildItem "*Windows Compatible*.ttf" -Recurse
}

# Installs fonts in Paths list and keeps track of the list for uninstall later
$installCount = Install-ChocolateyFont -Paths $fontList -Multiple
Write-Host "$installCount fonts installed"

Pop-Location
