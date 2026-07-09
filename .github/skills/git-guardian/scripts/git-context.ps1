<#
.SYNOPSIS
  Prints a compact Git context snapshot for git-guardian.
#>

$ErrorActionPreference = "Continue"

function Write-Section($title) {
    Write-Host "`n=== $title ==="
}

Write-Section "Git status"
git status --short --branch

Write-Section "Current branch"
git branch --show-current

Write-Section "Remote"
git remote -v

Write-Section "Recent commits"
git log --oneline --decorate -n 12

Write-Section "Branch tracking"
git branch -vv

Write-Section "Conflicted files"
git diff --name-only --diff-filter=U

Write-Section "Operation state"
$gitDir = git rev-parse --git-dir 2>$null
if ($LASTEXITCODE -eq 0 -and $gitDir) {
    $states = @{
        "MERGE_HEAD" = "merge in progress"
        "REBASE_HEAD" = "rebase in progress"
        "CHERRY_PICK_HEAD" = "cherry-pick in progress"
        "REVERT_HEAD" = "revert in progress"
        "BISECT_LOG" = "bisect may be in progress"
    }
    foreach ($name in $states.Keys) {
        $path = Join-Path $gitDir $name
        if (Test-Path $path) { Write-Host $states[$name] }
    }
}

Write-Section "Stash"
git stash list
