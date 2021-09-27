$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir      = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = ''
  checksumType   = 'sha256'
  checksum       = ''
}

Install-ChocolateyZipPackage @packageArgs

# Install all Open Type Fonts in package
Push-Location $toolsDir
$fontList = Get-ChildItem *.otf
Install-ChocolateyFont -Paths $fontList -Multiple

## Keep track of font names to use later for uninstall
$fontList | Select-Object Name > installedFonts.txt

Pop-Location
