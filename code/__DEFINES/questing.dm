#define QUEST_GROUP_ERRANDS "Guild Errands"
#define QUEST_GROUP_BOUNTIES "Bounties"

#define QUEST_TIER_ROUTINE 1
#define QUEST_TIER_RISKY 2
#define QUEST_TIER_DANGEROUS 3
#define QUEST_TIER_DEADLY 4
#define QUEST_TIER_LETHAL 5
#define QUEST_TIER_MYTHIC 6

#define QUEST_RETRIEVAL "Retrieval"
#define QUEST_COURIER "Courier"
#define QUEST_HUNT "Hunt"
#define QUEST_CLEAR_OUT "Clear Out"
#define QUEST_RAID "Raid"
#define QUEST_BOSS "Boss"

#define QUEST_HANDLER_REWARD_MULTIPLIER 2
#define QUEST_MINOR_HANDLER_REWARD_MULTIPLIER 1.2
#define QUEST_REWARD_PER_RISK_POINT 6
#define QUEST_DEPOSIT_RATE 0.18
#define QUEST_MIN_DEPOSIT 4
#define QUEST_MAX_DEPOSIT 80

#define QUEST_BASE_REWARD_RETRIEVAL 18
#define QUEST_BASE_REWARD_COURIER 16
#define QUEST_BASE_REWARD_HUNT 8
#define QUEST_BASE_REWARD_CLEAR_OUT 18
#define QUEST_BASE_REWARD_RAID 28
#define QUEST_BASE_REWARD_BOSS 40

#define QUEST_KILL_COUNT_REWARD 4
#define QUEST_CLEAR_OUT_RISK_BONUS 1
#define QUEST_RAID_RISK_BONUS 3
#define QUEST_BOSS_RISK_BONUS 5

#define QUEST_MOB_SPAWN_WEIGHT "spawn_weight"
#define QUEST_MOB_RISK_VALUE "risk_value"
#define QUEST_MOB_GROUP_MIN "group_min"
#define QUEST_MOB_GROUP_MAX "group_max"
#define QUEST_MOB_DATA(SPAWN_WEIGHT, RISK_VALUE, GROUP_MIN, GROUP_MAX) list(QUEST_MOB_SPAWN_WEIGHT = SPAWN_WEIGHT, QUEST_MOB_RISK_VALUE = RISK_VALUE, QUEST_MOB_GROUP_MIN = GROUP_MIN, QUEST_MOB_GROUP_MAX = GROUP_MAX)
#define QUEST_MOB_SOLO(SPAWN_WEIGHT, RISK_VALUE) QUEST_MOB_DATA(SPAWN_WEIGHT, RISK_VALUE, 1, 1)
#define QUEST_MOB_PACK(SPAWN_WEIGHT, RISK_VALUE, GROUP_MIN, GROUP_MAX) QUEST_MOB_DATA(SPAWN_WEIGHT, RISK_VALUE, GROUP_MIN, GROUP_MAX)

// Delivery quest additional reward scaling
#define QUEST_DELIVERY_DISTANCE_DIVISOR 6 // Divides the distance for reward calculation
#define QUEST_DELIVERY_DISTANCE_BONUS 1 // Adds a bonus for longer distances
#define QUEST_COURIER_BONUS_FLAT 8 // Flat bonus for courier quests, since you gotta wait for a person to open a package
#define QUEST_DELIVERY_PER_ITEM_BONUS 5 // Bonus per item delivered
#define QUEST_HUNT_REWARD_MULTIPLIER 1
#define QUEST_CLEAR_OUT_REWARD_MULTIPLIER 1
#define QUEST_RAID_REWARD_MULTIPLIER 1.25
#define QUEST_BOSS_REWARD_RISK_SQUARE_MULTIPLIER 2
#define QUEST_BOSS_REWARD_RISK_OVERFLOW_START 8
#define QUEST_BOSS_REWARD_RISK_OVERFLOW_BONUS 15

// ===== Map difficulty and reward modifiers =====
// Map flag bitfields for mob availability per map
#define QUEST_MAP_FLAG_TOWN (1<<0)
#define QUEST_MAP_FLAG_BOG (1<<1)
#define QUEST_MAP_FLAG_DESERT (1<<2)
#define QUEST_MAP_FLAG_FROZEN (1<<3)
#define QUEST_MAP_FLAG_UNDERDARK (1<<4)
#define QUEST_MAP_FLAG_ALL (QUEST_MAP_FLAG_TOWN | QUEST_MAP_FLAG_BOG | QUEST_MAP_FLAG_DESERT | QUEST_MAP_FLAG_FROZEN | QUEST_MAP_FLAG_UNDERDARK)

// Per-map difficulty multipliers (drives ambush frequency and mob scaling).
// 1.0x = baseline (~8% ambush), 2.0x = ~15% ambush, 3.0x = ~20% ambush.
#define QUEST_MAP_DIFFICULTY_TOWN 0.9
#define QUEST_MAP_DIFFICULTY_TOWN_SNOW 1.0
#define QUEST_MAP_DIFFICULTY_BOG 1.5
#define QUEST_MAP_DIFFICULTY_DESERT 1.3
#define QUEST_MAP_DIFFICULTY_FROZEN 2.0
#define QUEST_MAP_DIFFICULTY_UNDERDARK 3.0

// Per-map reward multipliers (globally scales all quest reward on that map).
#define QUEST_MAP_REWARD_TOWN 0.9
#define QUEST_MAP_REWARD_TOWN_SNOW 1.0
#define QUEST_MAP_REWARD_BOG 1.4
#define QUEST_MAP_REWARD_DESERT 1.3
#define QUEST_MAP_REWARD_FROZEN 1.8
#define QUEST_MAP_REWARD_UNDERDARK 2.5

// Distance bonus config: up to 25% extra reward based on distance from ledger to spawn point.
#define QUEST_DISTANCE_BONUS_MAX_MULT 0.25
#define QUEST_DISTANCE_BONUS_MAX_RANGE 150

// Quest ambush chance config.
// Ambush chance (%) = clamp(QUEST_AMBUSH_BASE_CHANCE * difficulty_modifier, MIN, MAX).
// At 1.0x difficulty -> 8%, at 2.0x -> 15%, at 3.0x -> 20%.
#define QUEST_AMBUSH_BASE_CHANCE 8
#define QUEST_AMBUSH_MIN_CHANCE 3
#define QUEST_AMBUSH_MAX_CHANCE 25

// ===== Mob map_flags field key =====
#define QUEST_MOB_MAP_FLAGS "map_flags"

// Extended mob data macro with map_flags support
#define QUEST_MOB_DATA_EX(SPAWN_WEIGHT, RISK_VALUE, GROUP_MIN, GROUP_MAX, MAP_FLAGS) list(QUEST_MOB_SPAWN_WEIGHT = SPAWN_WEIGHT, QUEST_MOB_RISK_VALUE = RISK_VALUE, QUEST_MOB_GROUP_MIN = GROUP_MIN, QUEST_MOB_GROUP_MAX = GROUP_MAX, QUEST_MOB_MAP_FLAGS = MAP_FLAGS)
#define QUEST_MOB_SOLO_EX(SPAWN_WEIGHT, RISK_VALUE, MAP_FLAGS) QUEST_MOB_DATA_EX(SPAWN_WEIGHT, RISK_VALUE, 1, 1, MAP_FLAGS)
#define QUEST_MOB_PACK_EX(SPAWN_WEIGHT, RISK_VALUE, GROUP_MIN, GROUP_MAX, MAP_FLAGS) QUEST_MOB_DATA_EX(SPAWN_WEIGHT, RISK_VALUE, GROUP_MIN, GROUP_MAX, MAP_FLAGS)


#define QUEST_KILL_MOBS_LIST list(\
	/mob/living/carbon/human/species/goblin/npc/ambush/sea = QUEST_MOB_PACK(5, 3, 2, 4),\
	/mob/living/carbon/human/species/skeleton/npc/supereasy = QUEST_MOB_PACK(6, 4, 2, 5),\
	/mob/living/carbon/human/species/skeleton/npc/easy = QUEST_MOB_PACK(5, 5, 2, 4),\
	/mob/living/carbon/human/species/skeleton/npc/pirate = QUEST_MOB_PACK(4, 5, 2, 4),\
	/mob/living/carbon/human/species/human/northern/militia/deserter = QUEST_MOB_PACK(4, 4, 1, 3),\
	/mob/living/carbon/human/species/orc/npc/footsoldier = QUEST_MOB_PACK(4, 6, 2, 4),\
)

// Medium difficulty quest kill mobs
#define QUEST_KILL_MEDIUM_LIST list(\
	/mob/living/carbon/human/species/human/northern/searaider/ambush = QUEST_MOB_PACK(4, 6, 2, 4),\
	/mob/living/carbon/human/species/human/northern/highwayman = QUEST_MOB_PACK(3, 6, 2, 4),\
	/mob/living/carbon/human/species/orc/npc/footsoldier = QUEST_MOB_PACK(4, 6, 2, 4),\
	/mob/living/carbon/human/species/orc/npc/marauder = QUEST_MOB_PACK(3, 8, 2, 4),\
	/mob/living/carbon/human/species/skeleton/npc/mediumspread = QUEST_MOB_PACK(3, 6, 3, 5),\
	/mob/living/carbon/human/species/human/northern/thief = QUEST_MOB_PACK(4, 8, 2, 4),\
)

// Raid difficulty kill mobs
#define QUEST_RAID_LIST list(\
	/mob/living/carbon/human/species/orc/npc/berserker = QUEST_MOB_PACK(2, 10, 1, 2),\
	/mob/living/carbon/human/species/elf/dark/drowraider = QUEST_MOB_PACK(3, 5, 3, 5),\
	/mob/living/carbon/human/species/human/northern/bog_deserters = QUEST_MOB_PACK(3, 5, 2, 4),\
)
#define QUEST_BOSS_KILL_LIST list(\
	/mob/living/carbon/human/species/orc/npc/footsoldier = QUEST_MOB_SOLO(6, 2),\
)

