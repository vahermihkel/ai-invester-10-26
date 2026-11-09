#!/bin/sh
# Claude Code hook: every code change needs a finished reviewer and then a checker.
# Usage: review-gate.sh stop | subagent-start | subagent-stop (hook JSON on stdin)

NON_CODE='\.md$|\.txt$|^docs/|^\.gitignore$|^\.gitattributes$|^\.gitleaksignore$'

input=$(cat)
cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
state_file="$(git rev-parse --git-dir 2>/dev/null)/claude-review-state"

# Hash of the path and content of every changed code file; empty if there are none.
fingerprint() {
  changed=$({ git diff HEAD --name-only; git ls-files --others --exclude-standard; } 2>/dev/null |
    grep -Ev "$NON_CODE" | sort -u)
  [ -n "$changed" ] || return 0
  printf '%s\n' "$changed" | while IFS= read -r f; do
    printf '%s %s\n' "$f" "$(git hash-object -- "$f" 2>/dev/null || echo deleted)"
  done | git hash-object --stdin
}

agent_type() {
  printf '%s' "$input" | sed -n 's/.*"agent_type"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p'
}

saved_fp=""
saved_status=""
[ -f "$state_file" ] && read -r saved_fp saved_status < "$state_file"

record() {
  printf '%s %s\n' "$1" "$2" > "$state_file"
}

case "$1" in
  subagent-start|subagent-stop)
    phase=running
    [ "$1" = subagent-stop ] && phase=done
    fp=$(fingerprint)
    case "$(agent_type)" in
      independent-reviewer)
        record "$fp" "reviewer-$phase"
        ;;
      independent-checker)
        # A checker only counts after a finished reviewer of this same code.
        if [ "$fp" = "$saved_fp" ] && { [ "$saved_status" = reviewer-done ] || [ "$saved_status" = checker-running ]; }; then
          record "$fp" "checker-$phase"
        fi
        ;;
    esac
    exit 0
    ;;
  stop)
    fp=$(fingerprint)
    [ -n "$fp" ] || exit 0

    need=independent-reviewer
    if [ "$fp" = "$saved_fp" ]; then
      case "$saved_status" in
        reviewer-running|checker-running|checker-done) exit 0 ;;
        reviewer-done) need=independent-checker ;;
      esac
    fi

    # Never loop forever if the agent cannot be started.
    if printf '%s' "$input" | grep -Eq '"stop_hook_active"[[:space:]]*:[[:space:]]*true'; then
      printf '{"systemMessage":"WARNING: code changed but %s did not run. This code is not reviewed."}\n' "$need"
      exit 0
    fi

    printf '{"decision":"block","reason":"Code files changed and need %s (see docs/security/code-review.md). Start a new %s. Pass only the review target (changed paths), never your reasoning. A checker also gets the reviewer report word for word. Then end your turn and relay the results when it finishes."}\n' "$need" "$need"
    exit 0
    ;;
esac
