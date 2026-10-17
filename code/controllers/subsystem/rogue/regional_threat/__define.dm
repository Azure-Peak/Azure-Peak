#define AMBUSH_REGION_COOLDOWN (3 MINUTES)

#define AMBUSH_BUDGET_PCT_REGULAR 0.045
#define AMBUSH_BUDGET_PCT_SAFE_REGION 0.03
#define AMBUSH_BUDGET_FLOOR 16

#define AMBUSH_AGGRO_DELAY (1.5 SECONDS)
// Make them focus their original target for a little bit first
#define AMBUSH_AGGRO_THREAT 15

#define DANGER_PCT_SAFE 15	// 0% to this = Safe (green)
#define DANGER_PCT_LOW 35		// to this = Low (yellow)
#define DANGER_PCT_MODERATE 55 // to this = Moderate (orange)
#define DANGER_PCT_DANGEROUS 80 // to this = Dangerous (red), above = Bleak (purple)

#define THREAT_HIGHPOP_TICK_RATE 0.1
#define THREAT_LOWPOP_TICK_RATE 0.05
