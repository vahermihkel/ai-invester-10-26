# Security Principles

[← Back to index](../../AI-INVESTER.md)

**Core rule: only the owner can reach the app. Orders come only from (a) the owner's manual submit, or (b) an AI decision produced inside this app, checked by hard safety limits, and (until phase 5) approved by the owner.**

1. **Trust boundary = owner's computer.** On localhost/Docker there is no password; the app is reachable **only from the owner's own machine** (`127.0.0.1`). Protecting the Windows account (Windows Hello/password, screen lock, BitLocker) protects the app.
2. **No path from the outside.** Nothing listens on the network; browser websites cannot talk to the backend (see [Network hardening](application-security.md#network-hardening)).
3. **Credentials and code are private.** Secrets live in Windows Credential Manager, never in git, files in the repo, logs, or AI prompts. Repo is a **private** GitHub repository. AI providers receive only market data, never code or credentials.
4. **AI decides, code guards.** The AI makes the trade decision, but it has **no direct access** to the broker or credentials. Its decision is a JSON document that passes through deterministic [Safety Limits](safety-limits.md) (max order size, daily loss, etc.) before the **Order Gateway** sends it. Limits are set by the owner and cannot be changed by the AI.
5. **Single choke point.** Every order — manual or AI — goes through the Order Gateway. No other code may call broker trading endpoints. Enforced by architecture tests.
6. **Bad data / no AI = no trade.** Stale data, unexplained data errors, invalid AI output or no available AI provider → no automatic order (fail closed).
7. **Least privilege at the broker.** API keys allow trading only — **never withdrawals** — with IP restriction where supported and separate keys for DEMO and LIVE.
8. **Everything is audited** in an append-only, tamper-evident log.
9. **Kill switch** always available.
