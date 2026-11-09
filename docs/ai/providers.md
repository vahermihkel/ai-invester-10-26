# AI Providers (pluggable)

[← Back to index](../../AI-INVESTER.md)

## Interface

```java
public interface AiProvider {
    String id();                      // "gemini", "claude", "openai", "ollama"
    String model();
    CostTier costTier();              // FREE | PAID
    AiResponse complete(AiRequest request);   // structured JSON output
    ProviderHealth health();
    QuotaStatus quotaStatus();
}
```

| Provider | Type | Notes |
|----------|------|-------|
| **Google Gemini** | Paid API key | |
| **Anthropic Claude** | Paid API key | |
| **OpenAI ChatGPT** | Paid API key | |
| **Ollama** | Free, local (`http://127.0.0.1:11434`) | Data never leaves the machine |

Model names are configuration, not code.

## Manual selection (phase 1)

```yaml
invester:
  ai:
    mode: manual                   # manual | failover
    active: claude
    providers:
      gemini: { model: <model>, secret-ref: ai-invester/gemini }
      claude: { model: <model>, secret-ref: ai-invester/anthropic }
      openai: { model: <model>, secret-ref: ai-invester/openai }
      ollama: { model: <model>, base-url: http://127.0.0.1:11434 }
```

## Automatic failover (phase 4)

```yaml
invester:
  ai:
    mode: failover
    failover-chain: [gemini, claude, openai, ollama]
    allowed-for-trade-decisions: [gemini, claude, openai]   # e.g. Ollama only for analysis/explanations
    limits:
      gemini: { monthly-tokens: 2000000, monthly-eur: 20 }
      claude: { monthly-tokens: 1000000, monthly-eur: 20 }
      openai: { monthly-tokens: 1000000, monthly-eur: 20 }
      ollama: { unlimited: true }
    switch-on: [quota-exhausted, budget-reached, provider-unavailable, invalid-output]
    cooldown-minutes: 60
    reset: monthly
```

- Temporary rate limit → backoff + retry; exhausted quota/budget → switch to next provider.
- Token usage tracked per provider (from API responses) in Postgres.
- Every switch logged and shown in UI.
- Since the AI makes trade decisions, the owner chooses which providers are **allowed to decide trades** (`allowed-for-trade-decisions`). If none of them is available → no trade decisions (analysis may continue with others).
