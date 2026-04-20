#define QUEST_DIFFICULTY_EASY "Easy"
#define QUEST_DIFFICULTY_MEDIUM "Medium"
#define QUEST_DIFFICULTY_HARD "Hard"

#define QUEST_RETRIEVAL "Retrieval"
#define QUEST_COURIER "Courier"
#define QUEST_KILL_EASY "Kill"
#define QUEST_CLEAR_OUT "Clear Out"
#define QUEST_RAID "Raid"
#define QUEST_BOUNTY "Bounty"

// Flat bonuses layered on top of base quest reward and per-mob scaling.
#define QUEST_REWARD_PER_HEAD 3
#define QUEST_REWARD_BOUNTY_HEAD 30

// Multipliers applied to the target mob's `threat_point` when computing additional reward.
#define QUEST_KILL_THREAT_MULT 0.5
#define QUEST_BOUNTY_THREAT_MULT 2

// Bands of threat each kill quest type clears from its region on successful completion.
// One band = THREAT_POINTS_PER_BAND (50) threat points by default.
#define QUEST_BANDS_KILL_EASY 1
#define QUEST_BANDS_CLEAR_OUT 2
#define QUEST_BANDS_RAID 3
#define QUEST_BANDS_BOUNTY 2

#define QUEST_REWARD_EASY_LOW 30
#define QUEST_REWARD_EASY_HIGH 35
#define QUEST_REWARD_MEDIUM_LOW 45
#define QUEST_REWARD_MEDIUM_HIGH 65
#define QUEST_REWARD_HARD_LOW 120
#define QUEST_REWARD_HARD_HIGH 180

#define QUEST_DEPOSIT_EASY 5
#define QUEST_DEPOSIT_MEDIUM 10
#define QUEST_DEPOSIT_HARD 20

#define QUEST_HANDLER_REWARD_MULTIPLIER 2

// Jobs may override via /datum/job.max_active_quests.
#define QUEST_MAX_ACTIVE_PER_PLAYER 2

// Per-difficulty pool targets: max(floor, round(pop * fraction)).
// At pop=120 -> 15/10/5 (30 total). At pop=60 -> 8/5/3. At pop=12 -> 2/1/1.
#define QUEST_POOL_FRACTION_EASY 0.125
#define QUEST_POOL_FRACTION_MEDIUM 0.085
#define QUEST_POOL_FRACTION_HARD 0.042
#define QUEST_POOL_FLOOR_EASY 6
#define QUEST_POOL_FLOOR_MEDIUM 4
#define QUEST_POOL_FLOOR_HARD 3

// Each tick generates max(1, pop / QUEST_POOL_REGEN_DIVISOR) new contracts. At pop=120: 6/tick = 72/hr.
#define QUEST_POOL_REGEN_INTERVAL (5 MINUTES)
#define QUEST_POOL_REGEN_DIVISOR 20

// Unclaimed listings past this threshold are rerolled in place, bypassing the per-tick cap.
#define QUEST_POOL_STALE_THRESHOLD (20 MINUTES)

// After abandoning a contract, a ckey cannot abandon another for this long.
// Per-ckey take cooldown. Once you've taken QUEST_TAKE_COOLDOWN_SLOTS contracts within
// QUEST_TAKE_COOLDOWN, you must wait for the oldest take to expire before the next sign.
// Abandoning does not reset this; the deposit forfeit is the abandon penalty.
#define QUEST_TAKE_COOLDOWN (10 MINUTES)
#define QUEST_TAKE_COOLDOWN_SLOTS 2

#define QUEST_POOL_WEIGHTS_EASY list(\
	QUEST_RETRIEVAL = 35,\
	QUEST_COURIER = 25,\
	QUEST_KILL_EASY = 40,\
)

#define QUEST_POOL_WEIGHTS_MEDIUM list(\
	QUEST_KILL_EASY = 30,\
	QUEST_CLEAR_OUT = 70,\
)

#define QUEST_POOL_WEIGHTS_HARD list(\
	QUEST_CLEAR_OUT = 40,\
	QUEST_RAID = 35,\
	QUEST_BOUNTY = 25,\
)

#define QUEST_SOURCE_POOL "pool"
#define QUEST_SOURCE_HANDLER "handler"

// Delivery quest additional reward scaling
#define QUEST_DELIVERY_DISTANCE_DIVISOR 8 // Divides the distance for reward calculation
#define QUEST_DELIVERY_DISTANCE_BONUS 1 // Adds a bonus for longer distances
#define QUEST_COURIER_BONUS_FLAT 10 // Flat bonus for courier quests, since you gotta wait for a person to open a package
#define QUEST_DELIVERY_PER_ITEM_BONUS 2 // Bonus per item delivered

