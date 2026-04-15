#define QUEST_DIFFICULTY_EASY "Easy"
#define QUEST_DIFFICULTY_MEDIUM "Medium"
#define QUEST_DIFFICULTY_HARD "Hard"

#define QUEST_RETRIEVAL "Retrieval"
#define QUEST_COURIER "Courier"
#define QUEST_KILL_EASY "Kill"
#define QUEST_CLEAR_OUT "Clear Out"
#define QUEST_RAID "Raid"
#define QUEST_OUTLAW "Outlaw"

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

// Default cap on how many open contracts a single player can hold at once (non-quest-giver jobs).
// A job may override via /datum/job.max_active_quests.
#define QUEST_MAX_ACTIVE_PER_PLAYER 2

// Passive contract pool (SSquestpool). The pool is the set of pre-generated contracts
// that appear on the ledger and can be claimed. It is replenished over time and scaled to
// population.
#define QUEST_POOL_BASELINE 4        // minimum pool size regardless of population
#define QUEST_POOL_PER_PLAYERS 4     // one additional pool slot per N players
#define QUEST_POOL_MAX 16            // upper cap to keep the ledger legible
#define QUEST_POOL_REGEN_INTERVAL (5 MINUTES)  // how often the pool tops itself up
#define QUEST_POOL_REGEN_PER_TICK 2  // max new contracts added per regen tick
#define QUEST_POOL_CONTRACT_TTL (45 MINUTES)   // unclaimed contracts auto-expire after this

// Difficulty weights when the pool picks what difficulty to generate next. Higher = more common.
#define QUEST_POOL_WEIGHT_EASY 50
#define QUEST_POOL_WEIGHT_MEDIUM 30
#define QUEST_POOL_WEIGHT_HARD 15

// Type weights per difficulty - used to bias pool generation towards certain contract types.
// Kept separate so a given difficulty can prefer different work.
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
	QUEST_OUTLAW = 25,\
)

// Where a contract originated. Pool contracts are pre-generated; handler contracts
// are printed by a quest-giver job (Steward, Clerk, etc.) via the existing flow.
#define QUEST_SOURCE_POOL "pool"
#define QUEST_SOURCE_HANDLER "handler"

// Delivery quest additional reward scaling
#define QUEST_DELIVERY_DISTANCE_DIVISOR 8 // Divides the distance for reward calculation
#define QUEST_DELIVERY_DISTANCE_BONUS 1 // Adds a bonus for longer distances
#define QUEST_COURIER_BONUS_FLAT 10 // Flat bonus for courier quests, since you gotta wait for a person to open a package
#define QUEST_DELIVERY_PER_ITEM_BONUS 2 // Bonus per item delivered

// All eligible quest kill mobs
// The extra per number reward are based on toughness + whether their head is worth anything
#define QUEST_KILL_MOBS_LIST list(\
	/mob/living/carbon/human/species/goblin/npc/ambush/sea = 3,\
	/mob/living/carbon/human/species/skeleton/npc/supereasy = 4,\
	/mob/living/carbon/human/species/skeleton/npc/easy = 5,\
	/mob/living/carbon/human/species/skeleton/npc/pirate = 5,\
	/mob/living/carbon/human/species/human/northern/militia/deserter = 4,\
	/mob/living/carbon/human/species/orc/npc/footsoldier = 6,\
)

// Medium difficulty quest kill mobs, this is where I can put some slightly spicier mobs
#define QUEST_KILL_MEDIUM_LIST list(\
	/mob/living/carbon/human/species/human/northern/searaider/ambush = 6,\
	/mob/living/carbon/human/species/human/northern/highwayman = 6,\
	/mob/living/carbon/human/species/orc/npc/footsoldier = 6,\
	/mob/living/carbon/human/species/orc/npc/marauder = 8,\
	/mob/living/carbon/human/species/skeleton/npc/mediumspread = 6,\
	/mob/living/carbon/human/species/skeleton/npc/mediumspread = 6,\
	/mob/living/carbon/human/species/human/northern/thief = 8,\
	)

// Raid difficulty kill mobs - Only three mobs for now. Per person reward is low because base / head reward is high
#define QUEST_RAID_LIST list(\
	/mob/living/carbon/human/species/orc/npc/berserker = 10,\
	/mob/living/carbon/human/species/elf/dark/drowraider = 5, \
	/mob/living/carbon/human/species/human/northern/bog_deserters = 5,\
)
