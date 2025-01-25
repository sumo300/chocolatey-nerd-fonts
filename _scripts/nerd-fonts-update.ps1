$releases = 'https://github.com/ryanoasis/nerd-fonts/releases'
$latestRelease = 'https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest'
$readmes = 'https://raw.githubusercontent.com/ryanoasis/nerd-fonts/refs/tags/{0}/patched-fonts/{1}/README.md'

function Get-NerdFontSearchReplace() {
    return @{
        ".\tools\chocolateyInstall.ps1" = @{
            "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
            "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
        }

        "$($Latest.PackageName).nuspec" = @{
           "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
       }
    }
}

function Get-NerdFontLatest([string]$Path) {
    if ([string]::IsNullOrEmpty($Env:github_api_key)) {
        $assets = (Invoke-RestMethod $latestRelease).assets        
    } else {
        $assets = (Invoke-RestMethod -Uri $latestRelease -Method Get -ContentType "application/json" -Headers @{Authorization = "token $Env:github_api_key"}).assets
    }

    $fontname = (get-item $Path).Name -replace 'nerd-fonts-', ''
    $file  = $fontName + ".zip"
    $url = $assets | Where-Object Name -match $file | Select-Object -First 1 -expand browser_download_url

    $version = $url -split '/' | Select-Object -Last 1 -Skip 1
    $versionNoV = $version.Replace('v','')

    # Download readme
    try {
        $readmeUri = $readmes -f $version, $fontName
        Invoke-WebRequest -Uri $readmeUri -OutFile $(Join-Path -Path $Path -ChildPath "FONT-README.md")
    } catch {
        # Ignore any errors
    }

    return @{
        URL32        = $url
        Version      = $versionNoV
        ReleaseNotes = "$releases/tag/$version"
    }
}