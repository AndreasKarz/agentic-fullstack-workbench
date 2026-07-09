# Repository hygiene

Use this reference for cleanup, remotes, pruning, ignore files, LFS, maintenance, and repository sanity checks.

## Remote and tracking overview

```bash
git remote -v
git branch -vv
git status --short --branch
```

## Fetch and prune safely

```bash
git fetch --all --prune
```

Pruning removes stale remote-tracking refs, not real remote branches.

## Local branches merged into main

```bash
git switch main
git pull --ff-only
git branch --merged main
```

Delete with `-d`, not `-D`, unless intentionally discarding.

```bash
git branch -d <branch-name>
```

## Find large files in history

```bash
git rev-list --objects --all | sort -k 2
```

For deep cleanup, prefer dedicated tools like `git filter-repo` and coordinate with team. This rewrites history.

## Ignore file that is already tracked

Add pattern to `.gitignore`, then untrack without deleting local file:

```bash
git rm --cached <file>
git commit -m "chore: stop tracking <file>"
```

For directory:

```bash
git rm --cached -r <directory>
```

## Check repository health

```bash
git fsck
git gc --auto
```

## Line endings

Inspect config:

```bash
git config --get core.autocrlf
git config --get core.eol
```

Use `.gitattributes` for repo-level consistency.

## LFS quick checks

```bash
git lfs install
git lfs track
git lfs ls-files
```

Do not migrate existing history to LFS without team coordination.
