# Branching

Use this reference for branch start, tracking, naming, cleanup, and branch relationships.

## Inspect branches

```bash
git status --short --branch
git branch -vv
git branch --show-current
git remote -v
git fetch --all --prune
```

## Create a feature branch from updated main

```bash
git fetch origin
git switch main
git pull --ff-only
git switch -c feature/<short-topic>
```

If the repo uses `master`, `develop`, or release branches, detect that first.

## Track a remote branch

```bash
git fetch origin
git switch --track origin/<branch-name>
```

If local branch already exists:

```bash
git branch --set-upstream-to=origin/<branch-name>
```

## Rename current branch

```bash
git branch -m <new-name>
```

If already pushed:

```bash
git push origin -u <new-name>
git push origin --delete <old-name>
```

Deleting the remote old branch is medium/high risk. Check open PRs first.

## Delete merged local branches

```bash
git fetch --all --prune
git branch --merged main
```

Delete only branches known to be obsolete:

```bash
git branch -d <branch-name>
```

Use `-D` only if intentionally discarding unmerged work.

## Compare branch with target

```bash
git fetch origin
git log --oneline --decorate --graph origin/<target>..<feature>
git diff --stat origin/<target>...<feature>
git diff origin/<target>...<feature>
```

Three-dot diff shows changes introduced by the feature branch since the merge base.
