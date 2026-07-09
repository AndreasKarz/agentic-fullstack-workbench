# Commit craft

Use this reference for commit quality, atomic commits, messages, and local cleanup before PR.

## Atomic commit rules

A good commit:

- has one reason to change
- builds or at least does not intentionally break the branch
- has a meaningful message
- avoids mixing formatting, refactoring, and behaviour changes unless required

## Inspect before committing

```bash
git status --short
git diff
git diff --staged
git diff --check
```

## Stage hunks interactively

```bash
git add -p
```

## Commit message shape

Use existing repository style if detectable. If not, Conventional Commit style is a safe default:

```text
<type>(<scope>): <summary>

<body if needed>
```

Common types:

- `feat`: user-visible feature
- `fix`: bug fix
- `refactor`: restructuring without behaviour change
- `test`: tests only
- `docs`: documentation only
- `chore`: maintenance
- `build`: build or dependency changes
- `ci`: pipeline changes

## Amend last local commit

```bash
git commit --amend
```

If already pushed:

```bash
git push --force-with-lease
```

Only for own branch and after explaining risk.

## Split a commit

```bash
git branch backup/$(git branch --show-current)-before-split
git rebase -i <commit-before-target>
```

Mark target as `edit`, then:

```bash
git reset HEAD~1
git add -p
git commit -m "<first message>"
git add -p
git commit -m "<second message>"
git rebase --continue
```

## Fixup workflow

```bash
git commit --fixup <target-sha>
git rebase -i --autosquash <base>
```
