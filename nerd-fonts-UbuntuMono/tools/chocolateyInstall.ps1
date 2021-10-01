$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = $PSScriptRoot

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip'
  checksumType   = 'sha256'
  checksum       = '1034658826A4561A1FF460AA4261B5F47E8B201601619242E31BBDE14ECC4871'
}

Install-ChocolateyZipPackage @packageArgs

# Install all Open Type Fonts in package
Push-Location $toolsDir
$fontList = Get-ChildItem *.otf

# Get list of TrueType fonts instead if OpenType fonts are missing
if ($fontList.Count -le 0) {
  $fontList = Get-ChildItem *.ttf
}

$installCount = Install-ChocolateyFont -Paths $fontList -Multiple
Write-Host "$installCount fonts installed"

Pop-Location
