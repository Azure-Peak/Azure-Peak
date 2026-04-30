// Loot Pool Defines
// All values are in mammons (copper coins). Tune everything from here.
// Reference: copper=1, silver=5, gold=10, iron ingot=15, steel ingot=20
// Leather armor=20-25, chainmail=50-80, plate=300-400
// Iron sword=10, steel sword=30, decorated=140, spellbook=50+

// ---- Area Loot Budgets ----
// Total mammon value of loot that can spawn per area. Spawners compete for budget.
// When budget runs out, remaining spawners get junk instead of real loot.
#define LOOT_BUDGET_CAVE_DEFAULT		450
#define LOOT_BUDGET_GETHSMANE			350
#define LOOT_BUDGET_GETHSMANE_INNER		900
#define LOOT_BUDGET_FISHMAN_DUNGEON		400
#define LOOT_BUDGET_HIS_VAULT			4000
#define LOOT_BUDGET_FORSAKEN_CATHEDRAL	200
#define LOOT_BUDGET_TEMPLE_SHATTERED	400
#define LOOT_BUDGET_ORC_DUNGEON			900
#define LOOT_BUDGET_DRAGON_DEN			600
#define LOOT_BUDGET_GOBLIN_FORT			500
#define LOOT_BUDGET_NECRAN_LABYRINTH	2200
#define LOOT_BUDGET_LICH_ARENA			1200
#define LOOT_BUDGET_UNDEAD_MANOR		400
#define LOOT_BUDGET_DUKE_COURT			500
#define LOOT_BUDGET_GOBLIN_DUNGEON		200
#define LOOT_BUDGET_SKELETON_CRYPT		300
#define LOOT_BUDGET_TOMB_OF_ALOTHEOS	14000
#define LOOT_BUDGET_SEWERS				300
#define LOOT_BUDGET_UNDERCOAST			400
#define LOOT_BUDGET_TERRORBOG_SOUTH		500
#define LOOT_BUDGET_MINOTAUR_FORT		900
#define LOOT_BUDGET_GUNDU_ZIRAK			600
#define LOOT_BUDGET_UNDERDARK			500
#define LOOT_BUDGET_MELTED_UNDERCITY	900
#define LOOT_BUDGET_DECAP_SHELTERS		300
#define LOOT_BUDGET_MOUNT_DECAP			300
#define LOOT_BUDGET_HOT_SPRINGS			200
#define LOOT_BUDGET_UNDERGROVE			600
#define LOOT_BUDGET_AZURE_COAST			200
#define LOOT_BUDGET_BANDIT_CAMP			300
#define LOOT_BUDGET_MINOTAUR_CAVE       200
#define LOOT_BUDGET_TARICHEA			200
#define LOOT_BUDGET_TARICHEA_MANOR      750
#define LOOT_BUDGET_ARAIGNEE 		    300
#define LOOT_BUDGET_BOGMANFORT          1200
#define LOOT_BUDGET_SKELETONFORT        800

// ---- Spawner Loot Values (mammons) ----
// Expected mammon value of what each spawner category rolls.
// General spawners are heavily diluted (mostly junk), so their expected value is low.

// General tier spawners - diluted pools, low expected value per roll
#define LOOT_VALUE_GENERAL_LOW			4
#define LOOT_VALUE_GENERAL_MID			12
#define LOOT_VALUE_GENERAL_HI			25

// Dungeon themed spawners - focused category pools
#define LOOT_VALUE_DUNGEON_MIXED		15
#define LOOT_VALUE_DUNGEON_MATERIALS	8
#define LOOT_VALUE_DUNGEON_CLOTHING		8
#define LOOT_VALUE_DUNGEON_MONEY		30	// actual avg ~30 from coin piles
#define LOOT_VALUE_DUNGEON_MISC			3
#define LOOT_VALUE_DUNGEON_MEDICAL		5
#define LOOT_VALUE_DUNGEON_WEAPONS		20
#define LOOT_VALUE_DUNGEON_TOOLS		8
#define LOOT_VALUE_DUNGEON_ARMOR		20
#define LOOT_VALUE_DUNGEON_FOOD			3
#define LOOT_VALUE_DUNGEON_SPELLS		50
#define LOOT_VALUE_SEWERS				5

// Equipment spawners - armor (focused pools, higher expected value)
#define LOOT_VALUE_LIGHT_ARMOR			22
#define LOOT_VALUE_MEDIUM_ARMOR			60
#define LOOT_VALUE_HEAVY_ARMOR			190
#define LOOT_VALUE_HELMET				20
#define LOOT_VALUE_GLOVES				15
#define LOOT_VALUE_BOOTS				15
#define LOOT_VALUE_WRISTS				15
#define LOOT_VALUE_HORNY_ARMOR			25

// Equipment spawners - weapons (focused pools)
#define LOOT_VALUE_PEASANT_WEAPON		10
#define LOOT_VALUE_IRON_COPPER_WEAPON	15
#define LOOT_VALUE_STEEL_WEAPON			40
#define LOOT_VALUE_SILVER_WEAPON		80
#define LOOT_VALUE_DECREPIT_EQUIPMENT	33
#define LOOT_VALUE_ANCIENT_EQUIPMENT	111
#define LOOT_VALUE_ELVEN_EQUIPMENT		100
#define LOOT_VALUE_BLACKSTEEL_EQUIPMENT	200

// Clutter spawners - audited against actual sellprices
#define LOOT_VALUE_CHEAP_CLUTTER		10	// actual avg ~9 (statues pull it up)
#define LOOT_VALUE_VALUABLE_CLUTTER		40	// actual avg ~40 (gold statues, glass statue)
#define LOOT_VALUE_CHEAP_CANDLE			1	// actual avg 0 (no sellprices)
#define LOOT_VALUE_VALUABLE_CANDLE		40	// actual avg 40 (gold/silver candlesticks)
#define LOOT_VALUE_CHEAP_TABLEWARE		1	// actual avg 0 (no sellprices)
#define LOOT_VALUE_VALUABLE_TABLEWARE	25	// actual avg 0 but gold/silver tableware has gameplay value
#define LOOT_VALUE_CHEAP_JEWELRY		15	// actual avg ~13 (psicrosses + rings)
#define LOOT_VALUE_VALUABLE_JEWELRY		140	// actual avg ~140 (gem rings 155-270, amulets 100-222)

// Loot chests
#define LOOT_VALUE_CHEST				80
#define LOOT_VALUE_CHEST_LOCKED			120
#define LOOT_VALUE_CHEST_INDESTRUCTIBLE	150

// Gem and special loot spawners
#define LOOT_VALUE_RANDOM_GEM			56	// actual weighted avg ~56 from gem sellprices
#define LOOT_VALUE_SPIDER_CAVE_LOOT		80	// steel/plate armor and weapons

// Potion spawners
#define LOOT_VALUE_POTION_VITALS		20
#define LOOT_VALUE_POTION_POISONS		15
#define LOOT_VALUE_POTION_INGREDIENT	3
#define LOOT_VALUE_POTION_STATS			30
