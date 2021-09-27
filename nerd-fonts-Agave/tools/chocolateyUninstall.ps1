$ErrorActionPreference = 'Stop'

$toolsDir = Split-Path $MyInvocation.MyCommand.Definition
$installedFontLog = Join-Path -Path $toolsDir -ChildPath "installedFonts.txt"

$fontList = Get-Content $installedFontLog

Uninstall-ChocolateyFont -Paths $fontList -Multiple
