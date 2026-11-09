# Project Structure

[← Back to index](../../AI-INVESTER.md)

```
ai-invester/
├── AI-INVESTER.md                  # documentation index
├── README.md
├── docker-compose.yml
├── docs/                           # specification (this documentation)
│   ├── overview/
│   ├── security/
│   ├── brokers/
│   ├── data/
│   ├── ai/
│   ├── deployment/
│   └── planning/
├── guidelines/                     # owner's investment guidelines for the AI
├── backend/                        # Java 21 + Spring Boot 3 (Maven)
│   ├── pom.xml
│   └── src/main/java/.../invester/
│       ├── InvesterApplication.java
│       ├── api/                    # REST controllers (portfolio, orders, metrics, anomalies, decisions, approvals)
│       ├── security/               # internal token filter, host/origin checks, secret store
│       ├── broker/                 # BrokerAdapter, read/trade ports, registry, etoro/, ibkr/
│       ├── data/
│       │   ├── provider/           # fred/, fundamentals/, news/, broker prices
│       │   ├── cleaning/
│       │   ├── anomaly/
│       │   └── metrics/
│       ├── ai/
│       │   ├── provider/           # gemini/, claude/, openai/, ollama/
│       │   ├── router/             # manual + failover + quotas
│       │   ├── snapshot/           # Market Snapshot builder
│       │   └── decision/           # prompts, schema, validation
│       ├── trading/
│       │   ├── gateway/            # OrderGateway — the ONLY place orders are sent
│       │   ├── approval/           # Approval Queue
│       │   ├── safety/             # Safety Limits
│       │   └── killswitch/
│       ├── audit/
│       └── scheduler/
│   └── src/main/resources/
│       ├── application.yml
│       └── db/migration/           # Flyway
│   └── src/test/java/...           # unit, security, ArchUnit, conformance, Testcontainers
├── frontend/                       # Next.js + TypeScript
│   ├── app/                        # dashboard, portfolio, orders, indicators, anomalies, approvals, settings
│   ├── components/
│   ├── lib/backend.ts              # server-side client to Spring (adds internal token)
│   └── middleware.ts               # Host / Origin checks, security headers
├── .claude/                        # reviewer and checker agents, review gate hook
├── .githooks/pre-commit            # gitleaks secret scan
├── .gitleaksignore                 # confirmed false positives only
└── .gitignore
```
