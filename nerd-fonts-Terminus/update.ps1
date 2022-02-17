import-module au
. $PSScriptRoot\..\_scripts\all.ps1

function global:au_SearchReplace {
    return Get-NerdFontSearchReplace
 }

function global:au_BeforeUpdate { Get-RemoteFiles -Purge }

function global:au_AfterUpdate  { Set-DescriptionFromReadme -SkipFirst 2 -SkipLast 2 }

function global:au_GetLatest {
    return Get-NerdFontLatest -Path $pwd
}

update -ChecksumFor 32 -NoReadme
