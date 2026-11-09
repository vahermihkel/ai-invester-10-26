# Market Snapshot (what the AI receives)

[← Back to index](../../AI-INVESTER.md)

Built by code from [metrics](metrics.md), [anomaly flags](cleaning-and-anomalies.md), [news](news.md), the portfolio and the owner's [guidelines](../ai/decision-service.md#owners-investment-guidelines).

```json
{
  "asOf": "2026-11-06T15:45:00Z",
  "environment": "demo",
  "macro": { "vix": 17.1, "vixPctl10y": 0.42, "hyOas": 3.21, "hyOasChange20d": 0.05, "spxVsMa200": 1.06 },
  "candidates": [
    { "symbol": "JNJ", "price": 150.4, "peTtm": 14.2, "pe5yMedian": 16.8, "vol60d": 0.18, "daysToEarnings": 21 }
  ],
  "anomalies": [
    { "metric": "VIX", "value": 24.9, "change1d": 0.38, "severity": "HIGH", "type": "SPIKE",
      "news": [ { "time": "…", "source": "…", "headline": "…" } ] }
  ],
  "portfolio": { "cash": 1850.0, "positions": [ { "symbol": "KO", "qty": 3, "avgPrice": 61.2, "pnlPct": 4.1 } ] },
  "guidelines": "…owner's investment guidelines…",
  "limits": { "maxOrderValueEur": 200, "maxOpenPositions": 5 }
}
```

The snapshot contains **only market and portfolio data** — never credentials, account numbers or source code.
