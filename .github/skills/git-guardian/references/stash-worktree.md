# Stash and worktree

Use this reference when the user must park work, switch context, or maintain multiple working directories.

## Save current work with a message

```bash
git stash push -m "<reason>"
```

Include untracked files:

```bash
git stash push -u -m "<reason>"
```

Include ignored files only when needed:

```bash
git stash push -a -m "<reason>"
```

## List and inspect stashes

```bash
git stash list
git stash show --stat stash@{0}
git stash show -p stash@{0}
```

## Apply or pop stash

Apply but keep stash:

```bash
git stash apply stash@{0}
```

Apply and remove stash:

```bash
git stash pop stash@{0}
```

Prefer `apply` when risk is unclear.

## Create a branch from stash

Useful when stash conflicts with current branch:

```bash
git stash branch <branch-name> stash@{0}
```

## Drop stash

High risk. Inspect first.

```bash
git stash drop stash@{0}
```

## Worktree for parallel branches

Create a second working directory:

```bash
git fetch origin
git worktree add ../<repo>-<branch> <branch>
```

Create new branch in a worktree:

```bash
git worktree add -b <new-branch> ../<repo>-<new-branch> origin/main
```

List worktrees:

```bash
git worktree list
```

Remove clean worktree:

```bash
git worktree remove ../<repo>-<branch>
```
