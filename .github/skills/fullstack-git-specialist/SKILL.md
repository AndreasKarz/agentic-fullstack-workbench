---
name: fullstack-git-specialist
description: "Quick reference for frequently used Git commands and workflows in the Fusion-Backend mono-repository. Covers branching, rebasing, cherry-picking, undoing changes, stashing, symlink handling on Windows, and mono-repo-specific patterns. Triggers on: git, branch, rebase, cherry-pick, merge, stash, reset, undo commit, squash, amend, git log, reflog, symlink, conflict resolution, clean branch."
---

# Git Specialist

Frequently used Git commands for the Fusion-Backend mono-repository. Only project-specific patterns and non-obvious commands — Claude already knows basic Git.

## Branch Conventions

Branch names use the developer's short name and the Azure DevOps Work Item ID:

```
<dev-short>/<work-item-id>
```

Examples: `KARZ/123456`, `MUEL/789012`, `SCHM/345678`

## Daily Workflows

### Start a feature branch

```bash
git checkout main && git pull
git checkout -b KARZ/123456
```

### Rebase onto latest main (preferred over merge)

```bash
git fetch origin
git rebase origin/main
# On conflict: fix file → git add <file> → git rebase --continue
# Abort: git rebase --abort
```

### Squash commits before PR

```bash
# Interactive rebase — squash last N commits
git rebase -i HEAD~N
# Mark commits as 's' (squash) or 'f' (fixup), keep first as 'pick'
```

### Amend last commit (before push)

```bash
git add .
git commit --amend --no-edit        # keep message
git commit --amend -m "new message" # change message
```

### Cherry-pick a commit from another branch

```bash
git cherry-pick <commit-sha>
# On conflict: fix → git add → git cherry-pick --continue
```

## Undoing Changes

### Unstage files

```bash
git restore --staged <file>   # unstage specific file
git restore --staged .        # unstage all
```

### Discard local changes (not yet committed)

```bash
git restore <file>            # discard changes in specific file
git checkout -- .             # discard all working directory changes
```

### Undo last commit (keep changes staged)

```bash
git reset --soft HEAD~1
```

### Undo last commit (keep changes unstaged)

```bash
git reset HEAD~1
```

### Undo last commit (discard changes — destructive)

```bash
git reset --hard HEAD~1
```

### Recover lost commits

```bash
git reflog                    # find the commit SHA
git checkout <sha>            # inspect it
git cherry-pick <sha>         # or bring it back
```

## Stashing

```bash
git stash                     # stash working changes
git stash -u                  # include untracked files
git stash list                # list stashes
git stash pop                 # apply and remove top stash
git stash apply stash@{N}     # apply specific stash, keep it
git stash drop stash@{N}      # delete specific stash
```

## Inspection & History

```bash
git log --oneline -20                          # last 20 commits, compact
git log --oneline --graph --all                # visual branch graph
git log --oneline -- src/Contract/             # commits touching a domain
git diff --name-only origin/main               # files changed vs main
git diff origin/main -- src/Contract/          # diff for specific domain
git blame <file>                               # line-by-line author history
```

## Cleanup

### Delete merged local branches

```bash
git branch --merged main | grep -v 'main' | xargs git branch -d
```

### PowerShell equivalent (Windows)

```powershell
git branch --merged main | Where-Object { $_ -notmatch 'main' } | ForEach-Object { git branch -d $_.Trim() }
```

### Prune remote-tracking branches

```bash
git fetch --prune
```

## Symlinks (Windows — Mono-Repo)

The `.github/` folder is symlinked into each microservice directory. Symlinks require setup:

1. **Windows Developer Mode** must be enabled
2. **Git config**: `git config core.symlinks true`

Use the local symlink script below for repository setup.

### Recreate symlinks after clone

```powershell
.\tools\set_copilot_symlinks.ps1
# Preview only:
.\tools\set_copilot_symlinks.ps1 -Force
```

### Check if symlinks are intact

```powershell
Get-ChildItem src/*/.\github -ErrorAction SilentlyContinue | Select-Object FullName, LinkTarget
```

## Conflict Resolution

### During rebase

```bash
# 1. Fix conflicts in editor
# 2. Stage resolved files
git add <resolved-file>
# 3. Continue rebase
git rebase --continue
# Or abort if needed
git rebase --abort
```

### Accept theirs/ours for specific file

```bash
git checkout --theirs <file>   # take incoming version
git checkout --ours <file>     # keep current version
git add <file>
```

## Mono-Repo Tips

### Scope git operations to a single domain

```bash
# Only diff Contract changes
git diff origin/main -- src/Contract/

# Only log Document history
git log --oneline -- src/Document/

# Only stash changes in a specific domain
git stash push -m "wip: Contract" -- src/Contract/
```

### Check which domains are affected by current changes

```powershell
git diff --name-only origin/main | ForEach-Object { ($_ -split '/')[1] } | Sort-Object -Unique
```
```
