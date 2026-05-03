#define QUEST_DIFFICULTY_EASY "Easy"
#define QUEST_DIFFICULTY_MEDIUM "Medium"
#define QUEST_DIFFICULTY_HARD "Hard"

#define QUEST_RETRIEVAL "Retrieval"
#define QUEST_COURIER "Courier"
#define QUEST_KILL_EASY "Kill"
#define QUEST_CLEAR_OUT "Clear Out"
#define QUEST_RAID "Raid"
#define QUEST_BOUNTY "Bounty"
#define QUEST_RECOVERY "Recovery"
#define QUEST_BLOCKADE_DEFENSE "Blockade Defense"

// Steward cannot commission Recovery - that is the Innkeeper's niche
GLOBAL_LIST_INIT(defense_quest_tier_costs, list(
	QUEST_KILL_EASY = BURGHER_PLEDGE_COST_TRIVIAL,
	QUEST_CLEAR_OUT = BURGHER_PLEDGE_COST_STANDARD,
	QUEST_BOUNTY = BURGHER_PLEDGE_COST_MAJOR,
	QUEST_RAID = BURGHER_PLEDGE_COST_MAJOR,
	QUEST_BLOCKADE_DEFENSE = BLOCKADE_SCROLL_PLEDGE_COST,
))

// Multipliers applied to the base TP for kill request rewards
#define QUEST_KILL_THREAT_MULT 1.0
// Bounty's main target is further multiplied  
#define QUEST_BOUNTY_THREAT_MULT 2

// Max mobs for kill request to avoid lagging
#define QUEST_KILL_MAX_MOBS 15
// Floor for TP to avoid no TP mob from being spammed 
#define QUEST_MOB_MIN_TP 10

#define QUEST_TP_BUDGET_KILL_EASY 35
#define QUEST_TP_BUDGET_CLEAR_OUT 80
#define QUEST_TP_BUDGET_RAID 150
#define QUEST_TP_BUDGET_BOUNTY_GOONS 100
#define QUEST_TP_BUDGET_RECOVERY 60

// TP budget variance
#define QUEST_TP_BUDGET_VARIANCE 0.25

// Bands of threat cleared on completion
#define QUEST_BANDS_KILL_EASY 1
#define QUEST_BANDS_CLEAR_OUT 2
#define QUEST_BANDS_RAID 3
#define QUEST_BANDS_BOUNTY 3
#define QUEST_BANDS_RECOVERY 2

// Flat reward base
#define QUEST_REWARD_BASE_FLAT 10
#define QUEST_REWARD_BASE_FETCH 15
#define QUEST_REWARD_BASE_RECOVERY 25

#define QUEST_DEPOSIT_EASY 5
#define QUEST_DEPOSIT_MEDIUM 10
#define QUEST_DEPOSIT_HARD 20


// Jobs may override via /datum/job.max_active_quests.
#define QUEST_MAX_ACTIVE_PER_PLAYER 2

#define QUEST_ACTIVE_FELLOWSHIP_BONUS_PAIR 1
#define QUEST_ACTIVE_FELLOWSHIP_BONUS_BAND 2

// Townie cannot sign contract within the first hour
#define CONTRACT_TOWNIE_GATE_TIME (1 HOURS)

#define QUEST_KILL_FRACTION 0.05
#define QUEST_KILL_CEILING_OFFSET 3

// Each tick generates up to this many kill quests across all regions; evergreen quests top up
// independently to their flat per-region targets.
#define QUEST_POOL_REGEN_INTERVAL (5 MINUTES)
#define QUEST_KILL_REGEN_PER_TICK 2

// Unclaimed listings past this threshold are rerolled in place, bypassing the per-tick cap.
#define QUEST_POOL_STALE_THRESHOLD (20 MINUTES)

// Per CKEY cap
#define QUEST_TAKE_COOLDOWN (10 MINUTES)

// After a quest reroll is generated it is locked for this long to prevent regen
#define QUEST_LANDMARK_COOLDOWN (5 MINUTES)

#define QUEST_KILL_HUNT_TIMER (10 MINUTES)
#define QUEST_KILL_HUNT_WARN_2M (8 MINUTES)
#define QUEST_KILL_HUNT_WARN_30S (9 MINUTES + 30 SECONDS)

#define QUEST_LANDMARK_MAX_LOCK_DURATION (60 MINUTES)


#define QUEST_KILL_TYPE_WEIGHTS list(\
	QUEST_KILL_EASY = 25,\
	QUEST_CLEAR_OUT = 25,\
	QUEST_RAID = 30,\
	QUEST_BOUNTY = 15,\
	QUEST_RECOVERY = 5,\
)


#define QUEST_EVERGREEN_TYPE_WEIGHTS list(\
	QUEST_RETRIEVAL = 55,\
	QUEST_COURIER = 45,\
)

#define QUEST_SOURCE_POOL "pool"
#define QUEST_SOURCE_HANDLER "handler"
#define QUEST_SOURCE_RUMOR "rumor"
#define QUEST_SOURCE_DEFENSE "defense"
#define QUEST_SOURCE_BLOCKADE "blockade"
#define QUEST_SOURCE_TOWNER "towner"

#define QUEST_DELIVERY_DISTANCE_DIVISOR 8 // Divides the distance for reward calculation
#define QUEST_DELIVERY_DISTANCE_BONUS 1 // Adds a bonus for longer distances
#define QUEST_COURIER_BONUS_FLAT 10 // Flat bonus for courier quests, since you gotta wait for a person to open a package
#define QUEST_DELIVERY_PER_ITEM_BONUS 2 // Bonus per item delivered
// Threat-scaled reward layered on top of distance / item bonuses for retrieval & courier quests.
// Multiplied by (region's delivery_reward_multiplier - 1.0), so a 1.0× region adds nothing and a
// 2.0× region (Terrorbog, Mt Decap, Underdark) adds the full amount.
#define QUEST_DELIVERY_THREAT_BONUS 20

