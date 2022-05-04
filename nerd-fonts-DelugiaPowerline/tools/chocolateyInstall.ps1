$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/adam7/delugia-code/releases/download/v2111.01/delugia-powerline.zip'
  checksumType   = 'sha256'
  checksum       = '6ECC76B8BCFDF81C20ED2D3978F9132D0566E29CC85604CF3C8A0FD87B58D7F5'
}

Install-ChocolateyZipPackage @packageArgs

# Install all OpenType Fonts in package
Push-Location $toolsDir
$fontList = Get-ChildItem *.otf

# Get list of TrueType fonts instead if OpenType fonts are missing
if ($fontList.Count -le 0) {
  $fontList = Get-ChildItem *.ttf
}

# Installs fonts in Paths list and keeps track of the list for uninstall later
$installCount = Install-ChocolateyFont -Paths $fontList -Multiple
Write-Host "$installCount fonts installed"

Pop-Location
