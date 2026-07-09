<#
.SYNOPSIS
  Lists conflicted files and their conflict marker counts.
#>

$files = git diff --name-only --diff-filter=U
if (-not $files) {
    Write-Host "No conflicted files detected."
    exit 0
}

foreach ($file in $files) {
    $markerCount = 0
    if (Test-Path $file) {
        $markerCount = (Select-String -Path $file -Pattern '^(<<<<<<<|=======|>>>>>>>)' -SimpleMatch:$false | Measure-Object).Count
    }
    [PSCustomObject]@{
        File = $file
        ConflictMarkers = $markerCount
    }
}
