$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir      = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/3270.zip'
  checksumType   = 'sha256'
  checksum       = 'B39BB03A46BF51CACF094A53D9F07C090EDE4571EFA2C24600C66A25A3FEE1CC'
}

Install-ChocolateyZipPackage @packageArgs

# Install all OpenType Fonts in package
Push-Location $toolsDir
$fontList = Get-ChildItem *.otf

# Get list of TrueType fonts instead if OpenType fonts are missing
if ($fontList.Count -le 0) {
  $fontList = Get-ChildItem *.ttf
}

Install-ChocolateyFont -Paths $fontList -Multiple

## Keep track of font names to use later for uninstall
$fontList | Select-Object Name > installedFonts.txt

Pop-Location
