import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$releases = 'https://github.com/adam7/delugia-code/releases'
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
    $download_page = Invoke-WebRequest -Uri $releases

    $fontname = (get-item $pwd).Name -replace 'nerd-fonts-', ''
    $re  = $fontName.ToLower().insert(7, '-') + ".zip"
    $url = $download_page.links | Where-Object href -match $re | Select-Object -First 1 -expand href
    $url = 'https://github.com' + $url

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
