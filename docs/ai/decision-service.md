# AI Decision Service

[← Back to index](../../AI-INVESTER.md)

## Responsibilities
1. **Analyse** the [Market Snapshot](../data/market-snapshot.md) (company metrics + market regime).
2. **Explain anomalies**: real market event, data error, or unclear — and what is behind it (using [news](../data/news.md) when available).
3. **Decide**: BUY / SELL / HOLD per candidate and per open position.
4. **Comment**: reasoning, risks, confidence.

## Owner's investment guidelines
The owner writes guidelines that are **given to the AI as decision context** (not hard-coded rules). They are editable in the UI and versioned.

```yaml
# guidelines/default.yaml
universe: [AAPL, MSFT, GOOGL, JNJ, KO, SPY]
style: "Long-only, value + quality, holding period weeks to months."
preferences:
  - "Prefer P/E below the company's own 5-year median and below 20."
  - "Avoid companies with 60-day volatility above 35%."
  - "Be cautious opening positions when VIX > 25 or HY OAS > 4.5% or HY OAS rising fast."
  - "Consider reducing risk when VIX > 35 or HY OAS > 6%."
  - "Avoid opening positions within 5 days before earnings."
exits:
  - "Consider selling at -8% (stop loss) or +20% (take profit), unless analysis strongly suggests otherwise."
```

## Decision output (strict JSON, schema-validated)

```json
{
  "snapshotId": "…",
  "anomalyAssessments": [
    { "metric": "VIX", "classification": "REAL_MARKET_EVENT",
      "explanation": "VIX +38% in one day alongside headlines about …; consistent with risk-off.",
      "confidence": 0.8 }
  ],
  "decisions": [
    { "symbol": "JNJ", "action": "BUY", "quantity": 1, "orderType": "LIMIT", "limitPrice": 152.30,
      "stopLoss": 140.00, "takeProfit": 182.00,
      "reasoning": "P/E 14.2 vs 5y median 16.8, low volatility, defensive in rising-VIX environment.",
      "risks": ["…"], "confidence": 0.71 },
    { "symbol": "KO", "action": "HOLD", "reasoning": "…", "confidence": 0.6 }
  ],
  "marketComment": "…"
}
```

Anomaly classifications: `REAL_MARKET_EVENT`, `DATA_ERROR`, `UNCLEAR`.

## Validation of AI decisions
Done by code, before the Approval Queue / execution:
- JSON matches the schema; unknown fields or actions → rejected.
- Symbol is in the owner's universe and tradable at the broker.
- Numbers the AI cites are **cross-checked with the snapshot** (e.g. AI says P/E 12 but snapshot says 30 → decision rejected as inconsistent).
- Limit price within X% of the live price.
- Anomaly classified `DATA_ERROR` or `UNCLEAR` on a metric the decision depends on → decision rejected (fail closed).
- Passes [Safety Limits](../security/safety-limits.md).

## AI safety rules
- AI has **no tools** and **no credentials** — it only returns JSON.
- Prompts never contain secrets, account numbers or source code.
- News/external text is clearly delimited as untrusted data; the system prompt instructs the AI to ignore instructions inside it. Safety Limits ensure that even a manipulated decision cannot exceed the owner's caps.
- Every decision stores: snapshot, prompt version, provider + model, raw response, validation result.

## Approval Queue (phase 2–4)
- Decisions listed in UI with metrics, charts, anomaly explanations and AI reasoning.
- **One-click Approve / Reject.** Decisions expire (e.g. 15 min or market close).
- On approve: live price re-checked; if the price moved beyond tolerance, the decision is marked stale and not sent.
- Statistics: how often the owner agreed with the AI, hypothetical performance of rejected decisions → basis for going fully automatic.

## Fully automatic (phase 5)
- Per-environment switch `mode: auto`. Approval step removed; Safety Limits still apply.
- Notification + audit entry for every order; daily summary.
- Optional **veto window**: order waits N minutes before sending, owner can cancel.
- Run on **DEMO** first before enabling on LIVE.

See also: [AI Providers](providers.md)
