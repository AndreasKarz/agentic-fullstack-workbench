<#
.SYNOPSIS
  Creates a timestamped backup branch at the current HEAD.
#>

$ErrorActionPreference = "Stop"

$branch = git branch --show-current
if (-not $branch) {
    throw "Could not detect current branch. Are you inside a Git repository?"
}

$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$safeBranch = $branch -replace '[^A-Za-z0-9._/-]', '-'
$backup = "backup/$safeBranch-$stamp"

git branch $backup
Write-Host "Created backup branch: $backup"
