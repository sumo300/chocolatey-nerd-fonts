$releases = 'https://github.com/ryanoasis/nerd-fonts/releases'
$readmes = 'https://raw.githubusercontent.com/ryanoasis/nerd-fonts/{0}/patched-fonts/{1}/readme.md'

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
    $download_page = Invoke-WebRequest -Uri $releases

    $fontname = (get-item $Path).Name -replace 'nerd-fonts-', ''
    $re  = $fontName + ".zip"
    $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href
    $url = 'https://github.com' + $url

    $version = $url -split '/' | Select-Object -Last 1 -Skip 1
    $version = $version.Replace('v','')

    # Download readme
    try {
        $readmeUri = $readmes -f $version.Replace('v',''), $fontName
        Invoke-WebRequest -Uri $readmeUri -OutFile $(Join-Path -Path $PSScriptRoot -ChildPath "FONT-README.md")
    } catch {
        # Ignore any errors
    }

    return @{
        URL32        = $url
        Version      = $version.Replace('v','')
        ReleaseNotes = "$releases/tag/${version}"
    }
}