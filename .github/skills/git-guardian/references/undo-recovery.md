# Undo and recovery

Use this reference for restore, reset, revert, reflog, lost commits, and accidental changes.

## First rule

Before destructive operations, inspect and create a backup branch if commits exist.

```bash
git status
git log --oneline --decorate -n 12
git reflog -n 20
```

## Discard unstaged changes in one file

```bash
git restore <file>
```

Old syntax:

```bash
git checkout -- <file>
```

## Unstage a file but keep changes

```bash
git restore --staged <file>
```

## Discard all unstaged tracked changes

High risk if user has local work.

```bash
git restore .
```

## Remove untracked files

High risk. Preview first:

```bash
git clean -fdn
```

Then execute only if intended:

```bash
git clean -fd
```

Include ignored files only with extreme caution:

```bash
git clean -fdx
```

## Undo last commit but keep changes staged

```bash
git reset --soft HEAD~1
```

## Undo last commit and keep changes unstaged

```bash
git reset --mixed HEAD~1
```

## Throw away last local commit and changes

High risk. Backup first.

```bash
git branch backup/$(git branch --show-current)-before-reset
git reset --hard HEAD~1
```

## Revert a shared commit

Use this for commits already pushed/shared.

```bash
git revert <commit-sha>
```

For a merge commit:

```bash
git revert -m 1 <merge-commit-sha>
```

Explain that `-m 1` usually keeps the first parent side.

## Recover with reflog

Find previous position:

```bash
git reflog -n 30
```

Create rescue branch at a known good point:

```bash
git branch rescue/<topic> <sha-from-reflog>
```

Or reset back if appropriate:

```bash
git reset --hard <sha-from-reflog>
```

Prefer rescue branch before hard reset.

## Recover dropped stash

```bash
git fsck --no-reflogs --lost-found
```

This is advanced and noisy. Prefer avoiding the problem by naming stashes clearly.
