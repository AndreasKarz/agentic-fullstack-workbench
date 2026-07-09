# Merge

Use this reference for normal merges, merge strategy choice, squash merges, no-ff merges, and choosing current or incoming changes.

## Basic safe merge

```bash
git fetch origin
git switch <target-branch>
git pull --ff-only
git merge <source-branch>
```

Verify:

```bash
git status
git log --oneline --decorate --graph -n 20
```

## Merge feature branch into main with explicit merge commit

```bash
git switch main
git pull --ff-only
git merge --no-ff <feature-branch>
git push origin main
```

Use this when the team wants visible feature boundaries.

## Squash merge locally

```bash
git switch <target-branch>
git pull --ff-only
git merge --squash <source-branch>
git commit -m "<type>: <summary>"
```

Squash loses individual commit boundaries on the target branch. Keep the source branch until verified.

## Abort a merge

```bash
git merge --abort
```

If abort fails, inspect first:

```bash
git status
git reflog -n 10
```

## Accept incoming changes for one conflicted file

During a merge, `--theirs` means the merged-in branch.

```bash
git checkout --theirs -- <file>
git add <file>
```

## Keep current changes for one conflicted file

During a merge, `--ours` means the current branch.

```bash
git checkout --ours -- <file>
git add <file>
```

## Accept incoming changes for all conflicted files

Only do this when the user explicitly wants incoming to win.

```bash
git diff --name-only --diff-filter=U | xargs git checkout --theirs --
git diff --name-only --diff-filter=U | xargs git add
```

PowerShell:

```powershell
git diff --name-only --diff-filter=U | ForEach-Object { git checkout --theirs -- $_; git add $_ }
```

## Keep current changes for all conflicted files

```bash
git diff --name-only --diff-filter=U | xargs git checkout --ours --
git diff --name-only --diff-filter=U | xargs git add
```

PowerShell:

```powershell
git diff --name-only --diff-filter=U | ForEach-Object { git checkout --ours -- $_; git add $_ }
```

## Continue after conflicts

```bash
git status
git add <resolved-files>
git commit
```

Some merges auto-create the merge commit after all files are added. Always check `git status`.
