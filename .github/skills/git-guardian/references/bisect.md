# Bisect

Use this reference to find the commit that introduced a bug.

## Manual bisect

Start:

```bash
git bisect start
git bisect bad
git bisect good <known-good-sha-or-tag>
```

At each step, test the app. Mark result:

```bash
git bisect good
# or
git bisect bad
```

End:

```bash
git bisect reset
```

## Automated bisect

Use a deterministic command that exits 0 for good and non-zero for bad.

```bash
git bisect start
git bisect bad
git bisect good <known-good-sha-or-tag>
git bisect run <test-command>
git bisect reset
```

Examples:

```bash
git bisect run npm test
```

```bash
git bisect run dotnet test
```

## Practical guidance

- Use the narrowest reliable test.
- Avoid flaky tests.
- Save local work before starting.
- Do not fix code during bisect unless intentionally testing a hypothesis.
