# Safety Limits & Kill Switch

[← Back to index](../../AI-INVESTER.md)

## Safety Limits
Deterministic, owner-set, apply to **every** order (manual and AI).
They do **not** decide what to trade — the AI does. They only cap the damage of a wrong decision, bug or manipulation.

```yaml
invester:
  safety:
    manual:
      max-price-deviation-pct: 5      # fat-finger protection
    ai:
      max-order-value-eur: 200
      max-orders-per-day: 5
      max-open-positions: 5
      max-position-pct: 10            # of portfolio per instrument
      max-total-exposure-eur: 1000
      max-daily-loss-eur: 100         # breach → kill switch
      allowed-order-types: [LIMIT]
      max-price-deviation-pct: 2
      trading-hours: "15:30-22:00 Europe/Tallinn"
```

Also: buying power check, duplicate-order detection, max orders per minute (runaway loop protection).

## Kill switch
- UI button + automatic triggers (daily loss, repeated errors, broker/account mismatch, data feed failure).
- Stops AI decision loop, rejects pending approvals, optionally cancels open orders.
- Restarting AI trading is an explicit owner action.
