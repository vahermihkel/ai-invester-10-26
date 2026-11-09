# Cleaning & Anomalies (code)

[← Back to index](../../AI-INVESTER.md)

## Cleaning
- Duplicates, time zones, trading calendars.
- **Stale** detection (expected update missing), **missing** values (forward-fill only where allowed).
- Sanity checks (negative/absurd P/E flagged, not silently used).
- Cross-source comparison where two sources exist.

## Anomaly detection
- Robust z-score (median + MAD) of level and of daily change.
- **Spike detection**: change > N × typical move.
- Percentile vs long history (e.g. VIX above 95th percentile of 10y).
- Cross-source mismatch.

Output:

```
AnomalyFlag { metric, symbol, value, expectedRange, severity, type }
```

On a spike, the latest news is fetched ([News](news.md)). Flags are passed to the AI in the [Market Snapshot](market-snapshot.md); the AI classifies and explains them ([AI Decision Service](../ai/decision-service.md)).
