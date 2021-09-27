$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir      = Split-Path $MyInvocation.MyCommand.Definition

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Agave.zip'
  checksumType   = 'sha256'
  checksum       = '0A6A5F056553CD8FA0C95DC57B0CDF027FF2F49016D0C470386BB2BA7918F549'
}

Install-ChocolateyZipPackage @packageArgs

# Install all Open Type Fonts in package
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
