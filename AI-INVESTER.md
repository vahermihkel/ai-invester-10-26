# AI-Invester — Project Specification

> Personal AI investing application.
> **Code** collects and cleans market data and computes metrics (P/E, volatility, VIX, High-Yield OAS, …).
> **AI** analyses the metrics, explains anomalies and **makes the buy/sell decision**.
> Brokers (eToro, Interactive Brokers, …) and AI providers (Gemini, Claude, ChatGPT, Ollama, …) are pluggable.
> **Security is requirement #1: nobody except the owner may access the app, see the code or credentials, or cause an order.**

## Documentation

### Overview
- [Goals](docs/overview/goals.md) — what the app does, phases, non-goals
- [Architecture](docs/overview/architecture.md) — components and order flows
- [Tech Stack](docs/overview/tech-stack.md) — Java + Spring Boot, Next.js, PostgreSQL
- [Project Structure](docs/overview/project-structure.md) — folders and packages

### Security
- [Security Principles](docs/security/principles.md) — the core rules
- [Application Security](docs/security/application-security.md) — localhost hardening, credentials, code privacy, database, tests
- [Safety Limits & Kill Switch](docs/security/safety-limits.md) — hard caps on every order

### Brokers
- [Broker Integration](docs/brokers/broker-integration.md) — pluggable adapters, eToro, IBKR, DEMO vs LIVE

### Market Data
- [Metrics](docs/data/metrics.md) — company and macro metrics, data sources
- [Cleaning & Anomalies](docs/data/cleaning-and-anomalies.md) — data cleaning and spike detection
- [News](docs/data/news.md) — latest news fetched on spikes
- [Market Snapshot](docs/data/market-snapshot.md) — what the AI receives

### AI
- [AI Decision Service](docs/ai/decision-service.md) — analysis, anomaly explanation, BUY/SELL/HOLD, approval queue, automatic mode
- [AI Providers](docs/ai/providers.md) — Gemini, Claude, OpenAI, Ollama, failover

### Deployment
- [Deployment Stages](docs/deployment/stages.md) — localhost → Docker → server

### Planning
- [Roadmap](docs/planning/roadmap.md) — phases 1–6
- [Open Questions](docs/planning/open-questions.md)

---

> **Disclaimer:** AI decisions are not financial advice and can lose money. Validate on DEMO first.
