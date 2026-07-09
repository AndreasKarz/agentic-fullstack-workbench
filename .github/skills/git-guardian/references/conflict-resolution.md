# Conflict resolution

Use this reference for merge, rebase, cherry-pick, and revert conflicts.

## Identify current operation

```bash
git status
git diff --name-only --diff-filter=U
```

Check operation state:

```bash
test -f .git/MERGE_HEAD && echo merge
test -f .git/REBASE_HEAD && echo rebase
test -f .git/CHERRY_PICK_HEAD && echo cherry-pick
test -f .git/REVERT_HEAD && echo revert
```

PowerShell:

```powershell
if (Test-Path .git/MERGE_HEAD) { "merge" }
if (Test-Path .git/REBASE_HEAD) { "rebase" }
if (Test-Path .git/CHERRY_PICK_HEAD) { "cherry-pick" }
if (Test-Path .git/REVERT_HEAD) { "revert" }
```

## List conflicted files with status

```bash
git status --short
git diff --check
git diff --name-only --diff-filter=U
```

## Understand conflict markers

```text
<<<<<<< HEAD
current side
=======
incoming/replayed side
>>>>>>> other side
```

Meaning depends on operation.

### During merge

- `ours`: current branch
- `theirs`: branch being merged in

### During rebase

- `ours`: branch you are rebasing onto
- `theirs`: commit currently being replayed

### During cherry-pick

- `ours`: current target branch
- `theirs`: picked commit

## Resolve manually

1. Open each conflicted file.
2. Remove conflict markers.
3. Keep the correct final code, not necessarily one side.
4. Stage resolved files.
5. Continue operation.

```bash
git add <file>
```

Continue:

```bash
# merge
git commit

# rebase
git rebase --continue

# cherry-pick
git cherry-pick --continue

# revert
git revert --continue
```

## Take one side for one file

Merge/cherry-pick examples:

```bash
git checkout --ours -- <file>
git add <file>
```

```bash
git checkout --theirs -- <file>
git add <file>
```

For rebase, explain reversed semantics before using this.

## Abort safely

```bash
# merge
git merge --abort

# rebase
git rebase --abort

# cherry-pick
git cherry-pick --abort

# revert
git revert --abort
```

## Verify after resolving

Run the smallest relevant checks first:

```bash
git status
git diff --check
```

Then project checks if known:

```bash
npm test
npm run build
dotnet test
```
