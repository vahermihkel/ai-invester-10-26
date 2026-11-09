# Metrics

[← Back to index](../../AI-INVESTER.md)

Computed by **code**; analysed by the AI.

## Company-level

| Metric | Source | Notes |
|--------|--------|-------|
| Price, volume, OHLC history | Broker API | Primary price source |
| **P/E** (TTM, forward), P/B, EV/EBITDA, dividend yield, earnings date | `FundamentalsProvider` — **source open**; start with a **free** tier, switchable to paid later | Candidates: Alpha Vantage, Financial Modeling Prep, Finnhub, EODHD |
| P/E vs own 5y median / sector | Computed | Relative valuation |
| Historical volatility (20d / 60d, annualized), beta, ATR, max drawdown | Computed | |

## Market-wide / macro

| Metric | Source | Notes |
|--------|--------|-------|
| **VIX** | FRED `VIXCLS` (daily) or market data provider (intraday) | |
| **ICE BofA US High Yield OAS** | FRED `BAMLH0A0HYM2` (free API key) | Credit stress |
| ICE BofA Euro High Yield OAS (optional) | FRED `BAMLHE00EHYIOAS` | |
| S&P 500 vs 200-day MA | Broker / data provider | Market regime |
| 10Y–2Y yield curve (optional) | FRED `T10Y2Y` | |

## Data providers
All sources are adapters (`FundamentalsProvider`, `MacroDataProvider`, `NewsProvider`), so they can be swapped.
Every data point is stored with **source, timestamp and fetch time**.
Free tiers have rate limits → caching + scheduled refresh within limits.

Next: [Cleaning & Anomalies](cleaning-and-anomalies.md)
