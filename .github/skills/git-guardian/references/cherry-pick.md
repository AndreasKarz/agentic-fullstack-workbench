# Cherry-pick

Use this reference when moving selected commits between branches.

## Inspect commit before cherry-pick

```bash
git show --stat <commit-sha>
git show <commit-sha>
```

## Cherry-pick one commit

```bash
git fetch origin
git switch <target-branch>
git pull --ff-only
git cherry-pick <commit-sha>
```

## Cherry-pick without committing

Use when you want to inspect or adjust changes before committing:

```bash
git cherry-pick --no-commit <commit-sha>
git status
git diff --staged
```

Then:

```bash
git commit -m "<message>"
```

## Cherry-pick a range

Inclusive range:

```bash
git cherry-pick <oldest-sha>^..<newest-sha>
```

Exclusive range after first commit:

```bash
git cherry-pick <after-this-sha>..<newest-sha>
```

## Continue after conflicts

```bash
git status
git add <resolved-files>
git cherry-pick --continue
```

## Abort cherry-pick

```bash
git cherry-pick --abort
```

## Skip current cherry-pick commit

```bash
git cherry-pick --skip
```

Use only if the commit is intentionally not needed or already included.

## Keep traceability

For hotfixes and release branches, prefer the default cherry-pick commit message because it records the source commit with `-x` when requested:

```bash
git cherry-pick -x <commit-sha>
```
