/// Minimum time between natural ambushes in the same region. Signal horn bypasses this.
#define AMBUSH_REGION_COOLDOWN (5 MINUTES)

/// Fraction of the latent_ambush pool spent as budget per ambush.
/// Paired with 1.5x region max_ambush so ambush size at full fill matches the old 3% model,
/// but there is more pool depth to drain before a region is cleared.
#define AMBUSH_BUDGET_PCT_REGULAR 0.03
/// Safe region have proportionally lower budget so that they can still spawn some ambushes without needing to adjust the max_ambush downward.
#define AMBUSH_BUDGET_PCT_SAFE_REGION 0.02

/// Display thresholds — percentage of max_ambush for each danger level label.
#define DANGER_PCT_SAFE 15    // 0% to this = Safe (green)
#define DANGER_PCT_LOW 35     // to this = Low (yellow)
#define DANGER_PCT_MODERATE 55 // to this = Moderate (orange)
#define DANGER_PCT_DANGEROUS 80 // to this = Dangerous (red), above = Bleak (purple)

/// Tick rate multipliers — fraction of max_ambush added per SS tick.
/// SS fires every 30 minutes = 6 ticks per 3-hour round.
/// Highpop: 10% of max per tick → full refill in 10 ticks (5 hours).
/// Lowpop: 5% of max per tick → full refill in 10 ticks (5 hours).
#define THREAT_HIGHPOP_TICK_RATE 0.1
#define THREAT_LOWPOP_TICK_RATE 0.05
