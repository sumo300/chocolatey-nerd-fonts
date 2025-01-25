$upgradeTestFile = "$env:TEMP\${env:ChocolateyPackageName}.upgrade"

if (-not (Test-Path -Path $upgradeTestFile)) {
    # Create upgrade test file
    $null = New-Item -Path $upgradeTestFile
}