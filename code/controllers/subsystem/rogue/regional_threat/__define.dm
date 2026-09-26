#define AMBUSH_REGION_COOLDOWN (5 MINUTES)

#define AMBUSH_BUDGET_PCT_REGULAR 0.03
#define AMBUSH_BUDGET_PCT_SAFE_REGION 0.02

#define DANGER_PCT_SAFE 15	// 0% to this = Safe (green)
#define DANGER_PCT_LOW 35		// to this = Low (yellow)
#define DANGER_PCT_MODERATE 55 // to this = Moderate (orange)
#define DANGER_PCT_DANGEROUS 80 // to this = Dangerous (red), above = Bleak (purple)

#define THREAT_HIGHPOP_TICK_RATE 0.1
#define THREAT_LOWPOP_TICK_RATE 0.05

// Below THRESHOLD: same floor+ramp as before (lowpop_tick*MIN_MULT at pop 0, ramping to
// lowpop_tick at THRESHOLD). At/above THRESHOLD: ramps on to highpop_tick by REF_POP instead of
// snapping straight to it, so there's no jump at the THRESHOLD boundary.
#define THREAT_LOWPOP_TICK_MIN_MULT 0.5
#define THREAT_LOWPOP_THRESHOLD 30
#define THREAT_TICK_HIGHPOP_REF_POP 60
