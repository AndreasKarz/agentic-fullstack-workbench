# Git Guardian Skill

A compact Git safety skill for Claude Code, GitHub Copilot-compatible skill folders, and other agent setups that read `SKILL.md`.

The skill helps an agent handle:

- merge vs. rebase decisions
- cherry-picking
- branch handling
- commits and commit grouping
- conflict resolution
- revert vs. reset
- stash usage
- reflog recovery
- safer pull strategy
- submodules
- Git LFS
- bisect

## Install for Claude Code

Copy this folder into your project or user skill location:

```text
.claude/skills/git-guardian/SKILL.md
```

Project-local example:

```bash
mkdir -p .claude/skills/git-guardian
cp SKILL.md .claude/skills/git-guardian/SKILL.md
```

## Optional GitHub Copilot-compatible location

The ZIP also contains:

```text
.github/skills/git-guardian/SKILL.md
```

Use this if your toolchain reads skills from `.github/skills`.

## Intended behavior

The skill is deliberately conservative.

It tells the agent to inspect repository state first, classify risk, protect uncommitted work, prefer `revert` over destructive history changes for shared branches, avoid rebasing public branches, and never run destructive commands without explicit approval.

## Suggested activation wording

Use prompts like:

```text
Use the git-guardian skill. Analyze the current Git state and propose the safest way to merge my branch into main.
```

```text
Use git-guardian. I need to cherry-pick commit abc123 into release/1.4. First inspect the repo and give me the safe command sequence.
```

```text
Use git-guardian. I have a merge conflict. Explain the situation and guide me through resolving it safely.
```

## Source inspiration

This skill operationalizes advanced Git practices commonly covered in professional Git documentation, especially topics such as merge vs. rebase, undoing changes, cherry-pick, reflog, stash, and branch workflows.

Reference:
https://www.atlassian.com/de/git/tutorials/advanced-overview
