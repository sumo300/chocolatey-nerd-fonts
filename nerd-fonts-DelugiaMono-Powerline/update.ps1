import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://github.com/adam7/delugia-code/releases'
$latestRelease = 'https://api.github.com/repos/adam7/delugia-code/releases/latest'
$readmes = 'https://raw.githubusercontent.com/adam7/delugia-code/v{0}/README.md'

function global:au_SearchReplace {
    @{
         ".\tools\chocolateyInstall.ps1" = @{
             "(?i)(^\s*url\s*=\s*)('.*')"        = "`$1'$($Latest.URL32)'"
             "(?i)(^\s*checksum\s*=\s*)('.*')"   = "`$1'$($Latest.Checksum32)'"
         }

         "$($Latest.PackageName).nuspec" = @{
            "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseNotes)`$2"
        }
     }
 }

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }

function global:au_AfterUpdate  { Set-DescriptionFromReadme -SkipFirst 2 -SkipLast 2 }

function global:au_GetLatest {
    $assets = (Invoke-RestMethod $latestRelease).assets

    $fontname = (get-item $pwd).Name -replace 'nerd-fonts-', ''
    $file  = $fontName.ToLower().insert(7, '-') + ".zip"
    $url = $assets | Where-Object Name -match $file | Select-Object -First 1 -expand browser_download_url

    $version = $url -split '/' | Select-Object -Last 1 -Skip 1
    $version = $version.Replace('v','')

    # Download readme
    try {
        $readmeUri = $readmes -f $version.Replace('v','')
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

update -ChecksumFor 32 -NoReadme
