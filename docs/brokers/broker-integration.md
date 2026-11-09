# Broker Integration (pluggable)

[← Back to index](../../AI-INVESTER.md)

## Interface

```java
public interface BrokerAdapter {
    String id();                        // "etoro", "ibkr", ...
    Environment environment();          // DEMO | LIVE
    BrokerCapabilities capabilities();  // order types, fractional, short, ...
}

/** Read-only — used by data collectors, AI decision service, UI. */
public interface BrokerReadPort {
    Account getAccount();
    List<Position> getPositions();
    List<Order> getOrders(OrderStatus status);
    Quote getQuote(String symbol);
    List<Candle> getHistory(String symbol, Period period);
    List<Instrument> searchInstruments(String query);
}

/** Trading — package-private implementation, ONLY reachable from OrderGateway. */
interface BrokerTradePort {
    OrderResult placeOrder(CheckedOrder order);
    OrderResult closePosition(String positionId, CheckedOrder order);
    void cancelOrder(String orderId);
}
```

- `CheckedOrder` can only be created by the Order Gateway after [Safety Limits](../security/safety-limits.md) pass.
- **ArchUnit test**: no class outside `trading.gateway` may depend on `BrokerTradePort`.
- New broker = new adapter module + passes the adapter conformance test suite.

## Configuration

```yaml
# application.yml  (no secrets — only references)
invester:
  broker:
    active: etoro
    environment: demo              # demo | live
    providers:
      etoro:
        demo: { base-url: <eToro demo API URL>, secret-ref: ai-invester/etoro/demo }
        live: { enabled: false, base-url: <eToro real API URL>, secret-ref: ai-invester/etoro/live }
      ibkr:
        demo: { host: 127.0.0.1, port: 4002, client-id: 1 }    # IB Gateway paper
        live: { enabled: false, host: 127.0.0.1, port: 4001, client-id: 1 }
```

## Broker notes

| Broker | Integration | DEMO | Notes |
|--------|-------------|------|-------|
| **eToro** | eToro Public API (REST, API key + user key) | Virtual/demo portfolio | Separate keys for demo/real, minimum permissions |
| **Interactive Brokers** | TWS API (Java) via **IB Gateway** | Paper trading account | API on 127.0.0.1, Trusted IPs = 127.0.0.1 only |
| Future (Alpaca, Saxo, Lightyear, …) | New adapter | — | |

> Verify endpoints and auth flows against each broker's current official API docs when implementing.

## DEMO vs LIVE
- App always starts in **DEMO**.
- LIVE requires `enabled: true` in config **and** LIVE credentials in the secret store **and** an explicit switch in the UI.
- AI decision loops are bound to an environment; a DEMO loop can never send a LIVE order.
- UI: blue **DEMO** banner, red **LIVE — REAL MONEY** banner on every screen.
