$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$toolsDir = Get-ToolsLocation

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

# Get list of TrueType fonts instead if OpenType fonts are missing
if ($fontList.Count -le 0) {
  $fontList = Get-ChildItem *.ttf
}

$installCount = Install-ChocolateyFont -Paths $fontList -Multiple
Write-Host "$installCount fonts installed"

Pop-Location
