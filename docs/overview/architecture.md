# Architecture

[← Back to index](../../AI-INVESTER.md)

```
 Owner's browser
       │  http://127.0.0.1:3000
┌──────▼───────────────────────────────┐
│  Frontend — Next.js + TypeScript      │  bound to 127.0.0.1
│  (server actions / route handlers)    │  Origin + Host checks
└──────┬───────────────────────────────┘
       │  http://127.0.0.1:8080  + internal API token (not visible to browser)
┌──────▼──────────────────────────────────────────────────────────────────────────┐
│  Backend — Java 21 + Spring Boot 3                         bound to 127.0.0.1   │
│                                                                                 │
│  ┌──────────────┐   ┌──────────────────┐   ┌──────────────────┐                 │
│  │ Data         │──▶│ Cleaning &       │──▶│ Metrics &        │                 │
│  │ Collectors   │   │ Anomaly Detector │   │ Market Snapshot  │                 │
│  │ broker,FRED, │   │ (statistics)     │   │ builder          │                 │
│  │ fundamentals,│   └──────────────────┘   └────────┬─────────┘                 │
│  │ news (spikes)│                                   │ snapshot (metrics,         │
│  └──────────────┘                                   │ anomalies, news, portfolio)│
│                                                     ▼                            │
│  ┌─────────────────────┐    ┌──────────────────────────────────┐                 │
│  │ AI Router           │◀───│ AI Decision Service              │                 │
│  │ manual / failover   │───▶│ analysis · anomaly explanation · │                 │
│  └─────────┬───────────┘    │ BUY / SELL / HOLD decision       │                 │
│            │                └───────────────┬──────────────────┘                 │
│  ┌─────────▼───────────────┐                │ decision (validated JSON)          │
│  │ AI Provider Adapters    │    ┌───────────▼───────────────┐                    │
│  │ Gemini│Claude│OpenAI│   │    │ Approval Queue (ph. 2–4)  │                    │
│  │ Ollama                  │    │ Auto mode     (ph. 5)     │   manual order     │
│  └─────────────────────────┘    └───────────┬───────────────┘   from UI          │
│                                             ▼                      │             │
│                                    ┌─────────────────┐             │             │
│                                    │ Safety Limits   │◀────────────┘             │
│                                    └────────┬────────┘                           │
│                                    ┌────────▼────────┐    ┌──────────────────┐   │
│                                    │ Order Gateway   │───▶│ Broker Adapters  │   │
│                                    └─────────────────┘    │ eToro │ IBKR │ … │   │
│                                                           │ DEMO  │ LIVE     │   │
│  Secret Store · Audit Log · Scheduler · Kill Switch       └──────────────────┘   │
└──────────────┬──────────────────────────────────────────────────────────────────┘
               │
        ┌──────▼──────┐
        │ PostgreSQL  │  bound to 127.0.0.1 / internal Docker network
        └─────────────┘
```

## Flow A — Manual order (phase 1+)
Owner fills the order form → **Submit** → [Safety Limits](../security/safety-limits.md) (automatic sanity checks, e.g. fat-finger price) → Order Gateway → broker. **No approval step.**

## Flow B — AI decision with approval (phase 2–4)
1. **Scheduler** refreshes data; code cleans it, computes metrics and flags anomalies ([Cleaning & Anomalies](../data/cleaning-and-anomalies.md)).
2. On a **sudden spike**, the latest news for that symbol/metric is fetched ([News](../data/news.md)).
3. Code builds a [Market Snapshot](../data/market-snapshot.md) (metrics, anomalies, news, portfolio, owner's investment guidelines) and sends it to the AI.
4. **AI analyses** the snapshot, **explains anomalies** and returns a **decision**: BUY / SELL / HOLD per symbol, with quantity, price and reasoning ([AI Decision Service](../ai/decision-service.md)).
5. Decision is validated (schema + numbers re-checked against live data) and checked against **Safety Limits**.
6. Decision appears in the **Approval Queue** → owner clicks **Approve / Reject**. Decisions expire.
7. Approved → prices re-checked → Order Gateway → broker.

## Flow C — Fully automatic (phase 5)
Same as Flow B, step 6 removed. Owner is notified of every order.
