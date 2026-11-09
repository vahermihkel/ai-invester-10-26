# Application Security (localhost / Docker phase)

[← Back to index](../../AI-INVESTER.md)

For the server phase (user management, 2FA, TLS) see [Deployment Stages](../deployment/stages.md#stage-3--server).

## Access — no login on own computer
- No user management, no password. Access control = **only reachable from the owner's own machine**.
- Owner's responsibility: Windows account protected (Windows Hello / password, auto screen lock), **BitLocker** disk encryption, no other people using the same Windows account.

## Network hardening
Prevents access from other devices, other programs and malicious websites.

- Next.js, Spring Boot and PostgreSQL bind only to **`127.0.0.1`** (`server.address=127.0.0.1`, `next start -H 127.0.0.1`). Docker: publish as `127.0.0.1:3000:3000`; backend and Postgres **not published at all** (internal Docker network).
- Browser talks only to Next.js. Next.js server calls Spring Boot with an **internal API token** (random, generated on first run, stored in the secret store, never sent to the browser). Spring rejects requests without it.
- **Host header allow-list** (`localhost`, `127.0.0.1`) on Next.js and Spring → blocks DNS-rebinding attacks.
- **Origin check** on every state-changing request (Next.js server actions check Origin; route handlers check explicitly) → a malicious website open in the browser cannot submit orders.
- Strict Content-Security-Policy, no CORS on the backend.
- Windows Firewall: no inbound rules for these ports.

## Credentials
| Stage | Storage |
|-------|---------|
| Localhost | **Windows Credential Manager** (via `java-keyring`) — broker keys, AI keys, FRED/fundamentals/news keys, DB password, internal API token |
| Docker | Docker secrets (read-only mounted files), not environment variables in images |
| Server | Vault / cloud secret manager |

- `application.yml` contains only secret **references**.
- Secrets masked in logs, error messages and Spring Actuator (Actuator endpoints disabled or limited to `health`).
- `.gitignore`: `.env*`, `*.key`, `*.pem`, `*.p12`, `*.pfx`, `*.jks`, `secrets/`, `application-local.*`, `backups/`, `*.dump`, `logs/`, `*.log`, `*.hprof`, `hs_err_pid*`.
- **`gitleaks` pre-commit hook** (`.githooks/pre-commit`) + GitHub secret scanning. Scans staged changes and blocks the commit if it finds a secret or cannot run (fail closed). Applies to terminal and GitHub Desktop commits.
- Cloning does not activate hooks. After every new clone run `git config core.hooksPath .githooks`.
- Confirmed false positives go in `.gitleaksignore` by exact fingerprint, never by disabling a rule.
- If a real secret is ever committed, revoke and replace it first. Removing it from git does not make it safe again.

## Code privacy
- **Private** GitHub repository; GitHub account protected with 2FA.
- No code, config or credentials are sent to AI providers at runtime — only market data snapshots.
- Docker images built locally, not pushed to public registries.

## Database
- PostgreSQL user for the app with minimal rights; separate migration user (Flyway).
- **Audit log** table: app role has `INSERT`/`SELECT` only (no `UPDATE`/`DELETE`), each row contains hash of the previous row (**hash chain**).
- Logged: config/guideline changes, data anomalies, AI snapshots + decisions, approvals/rejections, orders, Safety Limit rejections, provider switches, kill-switch events.
- Encrypted backups (`pg_dump` + encryption) stored outside the repo.

## Tests that must always pass
- ArchUnit: only Order Gateway uses `BrokerTradePort`.
- Request without internal token → rejected; wrong Host → rejected; cross-origin POST → rejected.
- AI decision with invalid schema / inconsistent numbers / unknown symbol / over limits → rejected.
- Expired or already-executed approval → rejected.
- DEMO loop → LIVE order → rejected. Kill switch active → no AI orders.

## Broker-side safety
- API keys: trading only, **no withdrawal/transfer permission**, IP allow-list where supported.
- Broker account login protected with the broker's own 2FA; broker order notifications on.
