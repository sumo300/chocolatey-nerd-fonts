$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = $PSScriptRoot

$packageArgs = @{
  softwareName   = $packageName
  packageName    = $packageName
  unzipLocation  = $toolsDir
  url            = 'https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/IBMPlexMono.zip'
  checksumType   = 'sha256'
  checksum       = '4FD7D9FD21CFCB7808548617628E3F2044E9EAA5871261767472E739ED9D6E76'
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
