# Rebase

Use this reference for updating private branches, interactive rebase, autosquash, and safe force push.

## Rule of thumb

Rebase is good for private/local branches. Avoid rebasing branches that other people may have based work on.

## Update feature branch on latest main

```bash
git fetch origin
git switch <feature-branch>
git branch backup/<feature-branch>-before-rebase
git rebase origin/main
```

After success:

```bash
git status
git log --oneline --decorate --graph -n 20
```

If already pushed and branch is yours:

```bash
git push --force-with-lease
```

Never prefer `--force` over `--force-with-lease`.

## Abort rebase

```bash
git rebase --abort
```

## Continue rebase after conflict resolution

```bash
git status
git add <resolved-files>
git rebase --continue
```

## Skip one problematic commit

```bash
git rebase --skip
```

Use only when the skipped commit is truly unwanted or empty.

## Interactive rebase last N commits

```bash
git branch backup/$(git branch --show-current)-before-i-rebase
git rebase -i HEAD~<N>
```

PowerShell backup:

```powershell
$branch = git branch --show-current
$stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
git branch "backup/$branch-before-i-rebase-$stamp"
```

Common actions:

- `pick`: keep commit
- `reword`: change message
- `edit`: stop for changes
- `squash`: combine with previous and edit message
- `fixup`: combine with previous and discard this message
- `drop`: remove commit

## Autosquash fixup commits

Create fixup commit:

```bash
git commit --fixup <commit-sha>
```

Then:

```bash
git rebase -i --autosquash <base>
```

## Ours/theirs warning during rebase

During rebase, the labels can feel reversed:

- `ours` is the branch you are rebasing onto.
- `theirs` is the commit being replayed.

Do not blindly use `--ours` or `--theirs` during rebase without explaining this.
