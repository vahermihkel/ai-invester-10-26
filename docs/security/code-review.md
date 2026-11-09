# AI Code Review

[← Back to index](../../AI-INVESTER.md)

**Rule: every code change is checked by two more AIs before it is committed. Changes with no code in them need no review.**

## Roles
| Step | Who | Does | May edit code? |
|------|-----|------|----------------|
| 1. Write | Main Claude Code session | Implements the task and fixes findings | Yes |
| 2. Review | `independent-reviewer`, new agent with no context | Checks the code against the spec, returns `BLOCK` or `PASS` | No |
| 3. Check | `independent-checker`, new agent with no context | Checks the review: is each finding right, and what was missed | No |
| 4. Decide | Owner | Reads both reports, settles disagreements, commits | Yes |

- Reviewer and checker get only the review target. The checker also gets the reviewer's report word for word. They never get the author's reasoning.
- All findings go to the owner word for word.
- After any fix, the code counts as new and steps 2 and 3 run again with new agents.
- No fourth or fifth AI. They add cost and share the same blind spots. Add a different kind of check instead: tests, ArchUnit, static analysis, DEMO runs.

## What counts as code
Everything except `*.md`, `*.txt`, `docs/`, `.gitignore`, `.gitattributes` and `.gitleaksignore`.

## Enforcement
`.claude/hooks/review-gate.sh` runs when Claude Code finishes a prompt. It fingerprints the changed code files and blocks Claude from finishing until a reviewer and then a checker have finished on exactly that code. State is kept in `.git/claude-review-state`.

**Limits:**
- The hook proves the agents ran, not that they passed or were right. The owner reads the verdicts.
- It only applies inside Claude Code. It does not block a commit made in GitHub Desktop.
- It gives up with a visible warning, rather than looping forever, if an agent cannot be started.
- AI reviewers can share blind spots. [Safety Limits](safety-limits.md) must hold even if every AI is wrong.
