#define QUEST_DIFFICULTY_EASY "Easy"
#define QUEST_DIFFICULTY_MEDIUM "Medium"
#define QUEST_DIFFICULTY_HARD "Hard"
#define QUEST_DIFFICULTY_NOTORIOUS "Notorious"
#define QUEST_DIFFICULTY_INCURSION "Incursion"
#define QUEST_DIFFICULTY_SPECIAL "Special"

#define QUEST_RETRIEVAL "Retrieval"
#define QUEST_COURIER "Courier"
#define QUEST_KILL_EASY "Kill"
#define QUEST_CLEAR_OUT "Clear Out"
#define QUEST_RAID "Raid"
#define QUEST_INCURSION "Incursion"
#define QUEST_BOUNTY "Bounty"
#define QUEST_RECOVERY "Recovery"
#define QUEST_BLOCKADE_DEFENSE "Blockade Defense"
#define QUEST_HOARD_RECOVERY "Hoard Recovery"
#define QUEST_TOWNER_SMITH_CARAVAN "Smith Caravan"
#define QUEST_TOWNER_MINER_OREVEIN "Ore Vein"
#define QUEST_TOWNER_CLINIC_CARAVAN "Clinic Caravan"
#define QUEST_TOWNER_MISSING_RUNNER "Missing Runner"
#define QUEST_TOWNER_TAILOR_CARAVAN "Tailor Caravan"
#define QUEST_TOWNER_CLAY_DEPOSIT "Clay Deposit"
#define QUEST_TOWNER_FOOD_CARAVAN "Food Caravan"
#define QUEST_TOWNER_CHEESEMAKER_CARAVAN "Cheesemaker Caravan"
#define QUEST_TOWNER_BUILDING_SUPPLIES "Building Supplies"
#define QUEST_TOWNER_VALUABLES "Valuables"
#define QUEST_TOWNER_FISHER_CARRIAGE "Fisher Carriage"
#define QUEST_NOTORIOUS_BOUNTY "Notorious Bounty"
#define QUEST_GM_KILL "Special Hunt"
#define QUEST_GM_RECOVERY "Special Recovery"

#define QUEST_CHRONICLE_ORDER_KILL_EASY 1
#define QUEST_CHRONICLE_ORDER_CLEAR_OUT 2
#define QUEST_CHRONICLE_ORDER_RAID 3
#define QUEST_CHRONICLE_ORDER_INCURSION 4
#define QUEST_CHRONICLE_ORDER_BOUNTY 5
#define QUEST_CHRONICLE_ORDER_NOTORIOUS_BOUNTY 6
#define QUEST_CHRONICLE_ORDER_RECOVERY 7
#define QUEST_CHRONICLE_ORDER_RETRIEVAL 8
#define QUEST_CHRONICLE_ORDER_COURIER 9
#define QUEST_CHRONICLE_ORDER_BLOCKADE_DEFENSE 10
#define QUEST_CHRONICLE_ORDER_HOARD_RECOVERY 11
#define QUEST_CHRONICLE_ORDER_TOWNER 20
#define QUEST_CHRONICLE_ORDER_GM 30
#define QUEST_CHRONICLE_ORDER_DEFAULT 100

#define QUEST_TURNIN_SELF 1
#define QUEST_TURNIN_FELLOWSHIP 2
#define QUEST_TURNIN_OFFICIAL 3

#define TOWNER_POSTING_TIER_MEDIUM "medium"
#define TOWNER_POSTING_TIER_HARD "hard"
#define TOWNER_POSTING_TIER_PERILOUS "perilous"

#define TOWNER_POSTING_COST_MEDIUM 75
#define TOWNER_POSTING_COST_HARD 150
#define TOWNER_POSTING_COST_PERILOUS 260

#define TOWNER_POSTING_CROWN_COST_MULT 2
#define TOWNER_POSTING_COMPANY_COST_MULT 1.5

#define TOWNER_FUNDER_PERSONAL "personal"
#define TOWNER_FUNDER_CROWN "crown"
#define TOWNER_FUNDER_COMPANY "company"

#define TOWNER_MAX_ACTIVE_POSTINGS 5

#define TOWNER_REWARD_MULT 0.75
#define TOWNER_REWARD_BASE 25
#define TOWNER_REWARD_CAP_MEDIUM 260
#define TOWNER_REWARD_CAP_HARD 450
#define TOWNER_REWARD_CAP_PERILOUS 1125

#define TOWNER_CARAVAN_TP_BUDGET_MEDIUM 80
#define TOWNER_CARAVAN_TP_BUDGET_HARD 150

#define TOWNER_OREVEIN_TP_BUDGET_MEDIUM 80
#define TOWNER_OREVEIN_TP_BUDGET_HARD 150

// Perilous fights exactly like an Incursion, shared by every towner type.
#define TOWNER_PERILOUS_TP_BUDGET_FIRST QUEST_TP_BUDGET_INCURSION_FIRST
#define TOWNER_PERILOUS_TP_BUDGET_SECOND QUEST_TP_BUDGET_INCURSION_SECOND

// Flat sweetener layered on combat & distance pay, shared by every towner type.
#define TOWNER_FLAT_BONUS_MEDIUM 65
#define TOWNER_FLAT_BONUS_HARD 100
#define TOWNER_FLAT_BONUS_PERILOUS 250

#define QUEST_POOL_KILL "kill"
#define QUEST_POOL_EVERGREEN "evergreen"

// Relative odds of each type to generate within their own pool
// KILL pool (Kill quests dependent on regional threats to generate)
#define QUEST_POOL_WEIGHT_KILL_EASY 25
#define QUEST_POOL_WEIGHT_CLEAR_OUT 25
#define QUEST_POOL_WEIGHT_RAID 30
#define QUEST_POOL_WEIGHT_INCURSION 10
#define QUEST_POOL_WEIGHT_BOUNTY 15
#define QUEST_POOL_WEIGHT_RECOVERY 5
#define QUEST_POOL_WEIGHT_NOTORIOUS_BOUNTY 5

// EVERGREEN pool (Fetch quests that will always be available)
#define QUEST_POOL_WEIGHT_RETRIEVAL 55
#define QUEST_POOL_WEIGHT_COURIER 45

#define QUEST_POOL_UNDERSTOCK_WEIGHT_MULT 10

// Multipliers applied to the base TP for kill request rewards
#define QUEST_KILL_THREAT_MULT 0.8
// Bounty's main target is further multiplied
#define QUEST_BOUNTY_THREAT_MULT 1
// 2x the threat point value is ideal
#define QUEST_NOTORIOUS_BOUNTY_THREAT_MULT 2

#define QUEST_VETERAN_THREAT_MULT 1.5
#define QUEST_VETERAN_THREAT_REWARD_MULT 0.6 // Slightly less efficiency
#define QUEST_VETERAN_ELITE_BIAS 1
#define QUEST_VETERAN_RANGED_WEIGHT_MULT 2

// Max mobs for kill request to avoid lagging
#define QUEST_KILL_MAX_MOBS 20
// Floor for TP to avoid no TP mob from being spammed
#define QUEST_MOB_MIN_TP 10
#define QUEST_MOB_DUST_DELAY (5 MINUTES)
#define QUEST_HEAD_DUST_DELAY (5 SECONDS)
#define QUEST_SPAWN_REVEAL_TIME (6 SECONDS)

#define QUEST_TP_BUDGET_KILL_EASY 35
// Easy only rolls factions whose average mob costs at most this share of its region-scaled budget
#define QUEST_EASY_MAX_FACTION_TP_SHARE 0.65
#define QUEST_TP_BUDGET_CLEAR_OUT 90
#define QUEST_TP_BUDGET_RAID 180
#define QUEST_TP_BUDGET_INCURSION_FIRST 200
#define QUEST_TP_BUDGET_INCURSION_SECOND 150
#define QUEST_TP_BUDGET_BOUNTY_GOONS 150
// Small starting escort so the boss isn't alone against ambient mobs and full parties.
#define QUEST_TP_BUDGET_NOTORIOUS_GOONS 50
#define QUEST_TP_BUDGET_RECOVERY 100

// TP budget variance
#define QUEST_TP_BUDGET_VARIANCE 0.25

// Bands of threat cleared on completion
#define QUEST_BANDS_KILL_EASY 1
#define QUEST_BANDS_CLEAR_OUT 2
#define QUEST_BANDS_NOTORIOUS 3
#define QUEST_BANDS_RAID 4
#define QUEST_BANDS_INCURSION 5
#define QUEST_BANDS_BOUNTY 4
#define QUEST_BANDS_RECOVERY 2
#define QUEST_BANDS_BLOCKADE 6

#define QUEST_REWARD_GLOBAL_MULT 1

// Flat reward base
#define QUEST_REWARD_BASE_FLAT 10
#define QUEST_REWARD_BASE_FETCH 12

// Flat bonus layered on by difficulty, on top of the base + tp/distance reward.
#define QUEST_DIFFICULTY_BONUS_EASY 0
#define QUEST_DIFFICULTY_BONUS_MEDIUM 0
#define QUEST_DIFFICULTY_BONUS_HARD 25
#define QUEST_DIFFICULTY_BONUS_NOTORIOUS 75
#define QUEST_DIFFICULTY_BONUS_INCURSION 25

#define QUEST_DEPOSIT_EASY 5
#define QUEST_DEPOSIT_MEDIUM 10
#define QUEST_DEPOSIT_HARD 20
#define QUEST_DEPOSIT_NOTORIOUS 20
#define QUEST_DEPOSIT_INCURSION 20


// Jobs may override via /datum/job.max_active_quests.
#define QUEST_MAX_ACTIVE_PER_PLAYER 2

#define QUEST_ACTIVE_FELLOWSHIP_BONUS_FIRST 2
#define QUEST_ACTIVE_FELLOWSHIP_BONUS_PER_MEMBER 1

#define QUEST_FELLOWSHIP_THREAT_PER_EXTRA_HARD 0.40
#define QUEST_FELLOWSHIP_REWARD_PER_EXTRA 0.20
#define QUEST_SOLO_SCALE_THREAT_FIRST 0.75
#define QUEST_SOLO_SCALE_THREAT_AFTER 0.30
// To make adding an additional head worth it, I also multiplicatively scale the reward, but cap it at +50% flat modifier so that at some point it just proportionally increases challenge instead of growing disproportionately. This also allows me to increase fellowship sizes in the future without creating a scaling issue.
#define QUEST_FELLOWSHIP_REWARD_MULT_CAP 1.5
#define QUEST_MIN_REGION_TP_MULT_MEDIUM 1.0
#define QUEST_MEDIUM_MAX_REGION_TP_MULT 1.25
#define QUEST_FELLOWSHIP_THREAT_PER_EXTRA_BLOCKADE 0.20
#define QUEST_FELLOWSHIP_THREAT_PER_EXTRA_INCURSION 0.20
#define QUEST_FELLOWSHIP_SCALE_MAX FELLOWSHIP_MAX_MEMBERS
#define QUEST_ARRIVAL_SCAN_RANGE 14

#define QUEST_MERC_LEDGER_POP_THRESHOLD 30
#define QUEST_SOLO_SIGN_COOLDOWN (30 MINUTES)
#define QUEST_INCURSION_FELLOWSHIP_REQUIREMENT 3
#define QUEST_INCURSION_INTERMISSION (2 MINUTES)
#define QUEST_INCURSION_INTERMISSION_WARN (30 SECONDS)

// Townie cannot sign contract within the first hour
#define CONTRACT_TOWNIE_GATE_TIME (1 HOURS)

#define QUEST_KILL_FRACTION 0.20
#define QUEST_KILL_CEILING_OFFSET 6

// Each tick generates up to this many kill quests across all regions; evergreen quests top up
// independently to their flat per-region targets.
#define QUEST_POOL_REGEN_INTERVAL (5 MINUTES)
#define QUEST_KILL_REGEN_PER_TICK 4

// Unclaimed listings past this threshold are rerolled in place, bypassing the per-tick cap.
#define QUEST_POOL_STALE_THRESHOLD (20 MINUTES)
#define QUEST_POOL_STALE_JITTER (10 MINUTES)
// Player-issued listings (rumor/defense) get a longer window before reroll.
#define QUEST_PLAYER_STALE_THRESHOLD (30 MINUTES)
#define QUEST_SCROLL_UNATTENDED_LAPSE (30 MINUTES)
#define QUEST_SCROLL_UNATTENDED_WARN (5 MINUTES)

#define QUEST_POOL_ROUNDSTART_MULT 1.5
#define QUEST_POOL_ROUNDSTART_GRACE (10 MINUTES)
#define QUEST_POOL_ROUNDSTART_JITTER (30 MINUTES)
#define QUEST_POOL_LANDMARK_RESERVE 2

#define MIN_TIME_BEFORE_CANCEL_TAKEN_QUEST (30 MINUTES)

#define REFUND_ON_FAILURE 0.5
#define REFUND_ON_NOT_TAKEN 1.0

#define QUEST_ISSUE_STATUS_LAPSED "lapsed"
#define QUEST_ISSUE_STATUS_WITHDRAWN "withdrawn"
#define QUEST_ISSUE_STATUS_FAILED "failed"
#define QUEST_ISSUE_STATUS_ABANDONED "abandoned"

// Per CKEY cap
#define QUEST_TAKE_COOLDOWN (10 MINUTES)

// After a quest reroll is generated it is locked for this long to prevent regen
#define QUEST_LANDMARK_COOLDOWN (5 MINUTES)

#define QUEST_KILL_HUNT_TIMER (20 MINUTES)
#define QUEST_KILL_HUNT_OVERTIME (2 MINUTES)
#define QUEST_KILL_HUNT_OVERTIME_MAX 5
#define QUEST_KILL_HUNT_OVERTIME_RECENT_KILL (3 MINUTES)
#define QUEST_KILL_HUNT_OVERTIME_RANGE 15
// This means that the real ceiling is 30 minutes, so long as you are actively fighting
#define QUEST_RECOVERY_DELIVERY_TIMER (30 MINUTES)
#define QUEST_GUARDIAN_LEASH_RANGE 40
#define QUEST_GUARDIAN_LEASH_GRACE (2 MINUTES)
#define QUEST_GUARDIAN_LEASH_TICK (10 SECONDS)
#define QUEST_GUARDIAN_LEASH_WATCH_RANGE 9
// Measured as the time deducted from the timer
#define QUEST_KILL_HUNT_WARN_EARLY (2 MINUTES)
#define QUEST_KILL_HUNT_WARN_FINAL (30 SECONDS)
#define QUEST_MOB_FRESHSPAWN_TIME (60 SECONDS)
// Rename after a delay so subtype after_creation() timers don't override it.
#define QUEST_BOSS_RENAME_DELAY (2 SECONDS)

#define QUEST_LANDMARK_MAX_LOCK_DURATION (60 MINUTES)


#define NOTORIOUS_BOUNTY_POLL_TIME (15 SECONDS)
#define NOTORIOUS_BOUNTY_POLL_WIDTH 520
#define NOTORIOUS_BOUNTY_POLL_HEIGHT 260
#define NOTORIOUS_BOUNTY_PROX_RANGE 35

#define NOTORIOUS_BOUNTY_HUNT_TIMER (12 MINUTES)
#define NOTORIOUS_BOUNTY_LEASH_RANGE 40
#define NOTORIOUS_BOUNTY_HUNT_TICK (10 SECONDS)
#define NOTORIOUS_BOUNTY_PARTY_DOWN_GRACE (20 SECONDS)
#define NOTORIOUS_BOUNTY_GOON_CAP 3
// Extra goons compensate when no ghost answers the poll and the boss stays an NPC.
#define NOTORIOUS_BOUNTY_REINFORCE_TP 140
#define NOTORIOUS_BOUNTY_REINFORCE_CAP 7
// Flat mammon bump when a player assumes the boss - the hunt got harder, the pay follows.
#define NOTORIOUS_BOUNTY_PLAYER_BONUS 250
#define NOTORIOUS_BOUNTY_NPC_BONUS 60

#define NOTORIOUS_BOUNTY_PLAYER_STAT_CAP 13
#define NOTORIOUS_BOUNTY_PLAYER_COMBAT_SKILL_CAP SKILL_LEVEL_EXPERT
#define NOTORIOUS_BOUNTY_PLAYER_SHIELD_SKILL_CAP SKILL_LEVEL_JOURNEYMAN
#define NOTORIOUS_BOUNTY_PLAYER_BRAWL_SKILL_CAP SKILL_LEVEL_JOURNEYMAN

#define NOTORIOUS_BOUNTY_SURVIVAL_TRIUMPH 1
#define NOTORIOUS_BOUNTY_ENGAGE_RANGE 10
// Grace period between the boss dying and the player being released to a ghost.
#define NOTORIOUS_BOUNTY_DEATH_RELEASE (5 SECONDS)


#define QUEST_SOURCE_POOL "pool"
#define QUEST_SOURCE_RUMOR "rumor"
#define QUEST_SOURCE_DEFENSE "defense"
#define QUEST_SOURCE_BLOCKADE "blockade"
#define QUEST_SOURCE_TOWNER "towner"
#define QUEST_SOURCE_GM "gm"

#define QUEST_DELIVERY_DISTANCE_DIVISOR 10 // Divides the distance for reward calculation
#define QUEST_DELIVERY_DISTANCE_BONUS 1 // Adds a bonus for longer distances
#define QUEST_COURIER_BONUS_FLAT 7 // Flat bonus for courier quests, since you gotta wait for a person to open a package
#define QUEST_DELIVERY_PER_ITEM_BONUS 2 // Bonus per item delivered
// Threat-scaled reward layered on top of distance / item bonuses for retrieval & courier quests.
// Multiplied by (region's delivery_reward_multiplier - 1.0), so a 1.0× region adds nothing and a
// 2.0× region (Terrorbog, Mt Decap, Underdark) adds the full amount.
#define QUEST_DELIVERY_THREAT_BONUS 15

#define BLOCKADE_FELLOWSHIP_REQUIREMENT 3
#define BLOCKADE_WAVE_TIMER_DS (15 MINUTES)
#define BLOCKADE_INTERMISSION_DS (3 MINUTES)
#define BLOCKADE_INTERMISSION_BELL_DS (15 SECONDS)
#define BLOCKADE_HORN_EXTRARANGE 10
#define BLOCKADE_WAVE_WARN_FIRST (7.5 MINUTES)
#define BLOCKADE_WAVE_WARN_SECOND (5 MINUTES)
#define BLOCKADE_WAVE_WARN_THIRD (2 MINUTES)
#define NOM_DE_GUERRE_MAX_LENGTH 60
#define MERC_STATUE_ADVERT_MIN (2 MINUTES)
#define MERC_STATUE_ADVERT_MAX (4 MINUTES)
#define MERC_STATUE_ADVERT_RANGE 7

// Minimum Pledge to call a hoard recovery writ from a fellowship without being the Steward.
#define HOARD_RECOVERY_PLEDGE 200
#define HOARD_RECOVERY_HOARD_MINIMUM 200

#define BLOCKADE_TOTAL_WAVES 3
#define BLOCKADE_WAVE_BASE_TP 180
#define BLOCKADE_EARLY_WAVE_TP_MULT 1.2
#define BLOCKADE_DEFENDER_SCAN_RANGE 7
#define BLOCKADE_CLEAR_TRIUMPHS 1

#define BLOCKADE_ARCHETYPE_WARBAND "warband"
#define BLOCKADE_ARCHETYPE_SWARM "swarm"
#define BLOCKADE_ARCHETYPE_ELITE "elite"
#define BLOCKADE_ARCHETYPE_WEIGHTS list(\
	BLOCKADE_ARCHETYPE_WARBAND = 55,\
	BLOCKADE_ARCHETYPE_SWARM = 25,\
	BLOCKADE_ARCHETYPE_ELITE = 20,\
)
#define BLOCKADE_ARCHETYPE_PIVOT_TP 20
#define BLOCKADE_ARCHETYPE_BIAS_STRENGTH 1.5

#define MERC_CONTRACT_MAX_DAYS 6
#define MERC_CONTRACT_MAX_RATE 500 // Surely no one will enter this
#define MERC_CONTRACT_DAY_LENGTH ((24 HOURS) / SSticker.station_time_rate_multiplier)
#define MERC_CONTRACT_RANGE 7
#define MERC_CONTRACT_ACCEPT_TIMEOUT (30 SECONDS)

#define MERC_HIRER_TOWNER "towner"
#define MERC_HIRER_OUTLAW "outlaw"
#define MERC_HIRER_INQUISITION "inquisition"

#define MERC_STIPEND_TOWNER 125
#define MERC_STIPEND_OUTLAW 150
#define MERC_STIPEND_INQUISITION 100

// Incentivizes Mercenary to be hired out by others to complete contracts
#define MERC_CONTRACT_SHARE_BONUS 0.25

#define MERC_CONTRACT_MEDAL_DAYS 2
#define MERC_CONTRACT_MEDAL_TRIUMPHS 3

// Cuts out the most egregious case of a Mercenary abusing contract with stipended role to print free money, by requiring them to be present with their hirer for 1/3 of the day to receive the stipend.
#define MERC_CONTRACT_PRESENCE_INTERVAL (30 SECONDS)
#define MERC_CONTRACT_PRESENCE_RANGE 14
#define MERC_CONTRACT_PRESENCE_SHARE (1/3)
