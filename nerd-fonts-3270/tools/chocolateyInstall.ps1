$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir      = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v1.0.0/3270.zip'
  checksumType   = 'sha256'
  checksum       = '494D439BB1BA1C2A22527937B14CEB7A54843A2CA60CDCA7B0613CA68BD80591'
}

Install-ChocolateyZipPackage @packageArgs

# Install all Open Type Fonts in package
Push-Location $toolsDir
$fontList = Get-ChildItem *.otf
Install-ChocolateyFont -Paths $fontList -Multiple

## Keep track of font names to use later for uninstall
$fontList | Select-Object Name > installedFonts.txt

Pop-Location
