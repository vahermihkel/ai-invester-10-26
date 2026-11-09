# Goals

[← Back to index](../../AI-INVESTER.md)

| # | Goal | Phase |
|---|------|-------|
| G1 | Connect to a broker **DEMO / paper** account | 1 |
| G2 | **Manual orders** — owner submits, order goes to broker immediately | 1 |
| G3 | Code computes metrics and detects anomalies; **AI analyses, explains and recommends** | 1 |
| G4 | Broker is **swappable** (eToro, IBKR, more later) | 1 |
| G5 | AI provider is **swappable** (Gemini paid, Claude, ChatGPT, Ollama free/local) | 1 |
| G6 | **AI makes buy/sell decisions**; each decision waits for the owner's **one-click approval** | 2 |
| G7 | Connect to **LIVE** account | 3 |
| G8 | **Automatic AI provider failover** when tokens/quota run out | 4 |
| G9 | **Fully automatic AI orders** (open + close) without approval | 5 |
| G10 | Localhost → Docker → **server + user management (password + 2FA) + domain** | 1 → 2 → 6 |

## Non-goals (for now)
- Multiple users. Single owner; **no login on own computer**. User management only in the server phase.
- Withdrawals or money transfers — the app must **never** be able to move money out of a broker account.
- High-frequency trading.

See also: [Roadmap](../planning/roadmap.md)
