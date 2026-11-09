# Deployment Stages

[← Back to index](../../AI-INVESTER.md)

## Stage 1 — Localhost
- PostgreSQL via `docker compose` (bound to 127.0.0.1) — or local install.
- Backend: `./mvnw spring-boot:run` on `127.0.0.1:8080`.
- Frontend: `npm run dev -- -H 127.0.0.1` on `127.0.0.1:3000`.

## Stage 2 — Docker (own PC)
- `docker compose up`: `frontend`, `backend`, `postgres` (+ `ib-gateway` if IBKR).
- Only frontend published: `127.0.0.1:3000:3000`.
- Non-root users, read-only root filesystems, dropped capabilities, minimal base images (e.g. Eclipse Temurin JRE, `node:*-alpine`).

Security for stages 1–2: [Application Security](../security/application-security.md).

## Stage 3 — Server
One of the last phases; server and domain are not decided yet.

- **User management**: login with password (Argon2id/bcrypt) + **2FA** (TOTP or passkey), Spring Security sessions, brute-force protection.
- Domain + TLS (Let's Encrypt), HSTS.
- Access preferably via **VPN** (WireGuard / Tailscale) or reverse proxy with mTLS.
- Firewall default-deny, Vault/secret manager, managed or hardened Postgres, encrypted off-site backups, monitoring.
- Same code — server mode enabled by Spring profile (`server`), which turns on authentication.
