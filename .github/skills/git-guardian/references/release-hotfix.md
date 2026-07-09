# Release and hotfix

Use this reference for release branches, hotfix branches, tags, and backports.

## Release branch from main

```bash
git fetch origin
git switch main
git pull --ff-only
git switch -c release/<version>
git push -u origin release/<version>
```

## Hotfix from production tag or main

From main:

```bash
git fetch origin
git switch main
git pull --ff-only
git switch -c hotfix/<short-topic>
```

From tag:

```bash
git fetch --tags
git switch -c hotfix/<short-topic> <tag>
```

## Backport fix to release branch

```bash
git fetch origin
git switch release/<version>
git pull --ff-only
git cherry-pick -x <fix-commit-sha>
git push origin release/<version>
```

## Create annotated tag

```bash
git tag -a <version> -m "Release <version>"
git push origin <version>
```

## Delete local tag

High risk if already published.

```bash
git tag -d <version>
```

## Delete remote tag

High risk. Confirm with team first.

```bash
git push origin :refs/tags/<version>
```

## Verify release history

```bash
git log --oneline --decorate --graph --all -n 40
git tag --sort=-creatordate | head
```
