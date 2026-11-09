# News on Spikes

[← Back to index](../../AI-INVESTER.md)

- News is **not** fetched continuously. When a **sudden spike** is detected ([Cleaning & Anomalies](cleaning-and-anomalies.md)), the `NewsProvider` fetches the **latest headlines** for that symbol (or market-wide for VIX/OAS) and attaches them to the [Market Snapshot](market-snapshot.md).
- Source open; start with a free one (e.g. Finnhub company news, Alpha Vantage news, RSS feeds).
- If no news source is configured or reachable, the AI explains the anomaly from the metrics alone and says so.
- News text is **untrusted input** — see [AI safety rules](../ai/decision-service.md#ai-safety-rules).
