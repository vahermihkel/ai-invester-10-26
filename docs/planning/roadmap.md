# Roadmap

[← Back to index](../../AI-INVESTER.md)

## Phase 1 — Foundation, DEMO, manual orders, AI analysis
- [ ] Repo setup: private GitHub, `.gitignore`, `gitleaks` pre-commit
- [ ] Spring Boot + Next.js + PostgreSQL (Docker) skeleton, Flyway
- [ ] Localhost hardening: 127.0.0.1 binding, internal token, Host/Origin checks, CSP
- [ ] Secret store (Windows Credential Manager), audit log (hash chain)
- [ ] Broker interface + **eToro DEMO** and/or **IBKR paper** adapter
- [ ] Manual orders: submit → Safety Limits → Order Gateway → broker
- [ ] Data providers: broker prices, FRED (VIX, HY OAS), free fundamentals (P/E)
- [ ] Metrics, cleaning, statistical anomaly/spike detection
- [ ] News provider (free) fetched on spikes
- [ ] AI providers (Gemini, Claude, OpenAI, Ollama), manual selection in UI
- [ ] AI analysis + anomaly explanations + BUY/SELL/HOLD recommendations (display only)
- [ ] UI: dashboard, portfolio, order form, indicators, anomalies, AI analysis, DEMO banner, kill switch

## Phase 2 — AI decisions with approval (DEMO)
- [ ] Owner guidelines editor
- [ ] Scheduled AI decision loop + decision validation + Safety Limits
- [ ] Approval Queue (one click), expiry, price re-check
- [ ] Agreement/performance statistics
- [ ] Notifications (channel TBD)
- [ ] Full Docker deployment

## Phase 3 — LIVE account
- [ ] LIVE credentials & config, LIVE switch, red LIVE UI

## Phase 4 — AI failover
- [ ] Token/cost tracking, failover chain, budgets, allowed-for-trade-decisions, UI indicator

## Phase 5 — Fully automatic AI orders
- [ ] `mode: auto`, optional veto window, daily reports — DEMO first, then LIVE

## Phase 6 — Server
- [ ] User management (password + 2FA), Spring Security `server` profile
- [ ] Server + domain (TBD), TLS, VPN/mTLS, Vault, backups, monitoring
