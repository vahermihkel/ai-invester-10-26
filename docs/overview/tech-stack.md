# Tech Stack

[← Back to index](../../AI-INVESTER.md)

| Layer | Choice | Notes |
|-------|--------|-------|
| Backend | **Java 21 + Spring Boot 3** (Maven) | Spring Web, Spring Data JPA, Validation, Scheduling |
| AI integration | **Spring AI** (`ChatClient`) behind own `AiProvider` interface | Spring AI supports OpenAI, Anthropic, Google Gemini and Ollama; own interface keeps it swappable |
| HTTP clients | Spring `RestClient` / `WebClient` | eToro, FRED, fundamentals, news |
| IBKR | Official **IB TWS API Java client** + IB Gateway | |
| Statistics | Apache Commons Math | z-scores, volatility, percentiles |
| Frontend | **Next.js + TypeScript** (App Router) | Charts: e.g. Recharts / lightweight-charts |
| Database | **PostgreSQL** | Flyway migrations; runs in Docker even in the localhost phase |
| Secrets | Windows Credential Manager (`java-keyring`) → Docker secrets → Vault | |
| Tests | JUnit 5, Mockito, Testcontainers (Postgres), **ArchUnit** (architecture rules), Playwright (frontend) | |
| Quality / security | Spotless, SpotBugs, OWASP Dependency-Check, `gitleaks` pre-commit, ESLint | |
