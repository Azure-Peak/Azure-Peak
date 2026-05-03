#define TRADE_CATEGORY_BASIC_MINERAL "basic_mineral"
#define TRADE_CATEGORY_RARE_METAL "rare_metal"
#define TRADE_CATEGORY_PRECIOUS_METAL "precious_metal"
#define TRADE_CATEGORY_INTERMEDIARY "intermediary"
#define TRADE_CATEGORY_GRAIN "grain"
#define TRADE_CATEGORY_FRUIT "fruit"
#define TRADE_CATEGORY_VEGETABLE "vegetable"
#define TRADE_CATEGORY_ANIMAL "animal"
#define TRADE_CATEGORY_SEAFOOD "seafood"
#define TRADE_CATEGORY_CLOTH "cloth"
#define TRADE_CATEGORY_ARTISAN "artisan"
#define TRADE_CATEGORY_GEM_COMMON "gem_common"
#define TRADE_CATEGORY_GEM_RARE "gem_rare"
#define TRADE_CATEGORY_GEM_LEGENDARY "gem_legendary"
#define TRADE_CATEGORY_POTION "potion"

#define TRADE_BEHAVIOR_RAW "raw"
#define TRADE_BEHAVIOR_INTERMEDIARY "intermediary"
#define TRADE_BEHAVIOR_GEM "gem"
// Finished equipment. Fulfilled via warehouse tiles, not stockpile deposits.
#define TRADE_BEHAVIOR_EQUIPMENT "equipment"
// Finished potions. Fulfilled via warehouse tiles by reagent + volume, any container.
#define TRADE_BEHAVIOR_POTION "potion"

#define TRADE_REGION_KINGSFIELD "kingsfield"
#define TRADE_REGION_ROSAWOOD "rosawood"
#define TRADE_REGION_ROCKHILL "rockhill"
#define TRADE_REGION_DAFTSMARCH "daftsmarch"
#define TRADE_REGION_BLACKHOLT "blackholt"
#define TRADE_REGION_SALTWICK "saltwick"
#define TRADE_REGION_BLEAKCOAST "bleakcoast"
#define TRADE_REGION_NORTHFORT "northfort"
#define TRADE_REGION_HEARTFELT "heartfelt"
#define TRADE_REGION_HAGENWALD "hagenwald"

#define STANDING_ORDER_DURATION 2
#define URGENT_ORDER_DURATION 1

// Order SIZE is not scaled but 
#define STANDING_ORDERS_BASE_PER_DAY 4
#define STANDING_ORDERS_PER_ACTIVE_PLAYER 0.05
#define STANDING_ORDERS_MAX_PER_DAY 13
#define STANDING_ORDERS_POOL_CAP 13
#define STANDING_ORDERS_MAX_PER_REGION 3
// Avoid spamming too many urgent orders
#define STANDING_ORDERS_MAX_URGENT 2

// Old defines for scaling order SIZE with pop. No longer used in favor of just adding more raw orders.
#define STANDING_ORDER_POP_SCALE_PER_PLAYER 0
#define STANDING_ORDER_POP_SCALE_MAX 3.0

#define STANDING_ORDER_BASE_BONUS 0.75

// Partial Fulfillment: Let players fulfill an order with 50% by VALUE for 85% payout
// So that steward / towners are still soft encouraged to fulfill the whole order
// But don't feel ripped off because they cannot fetch everything at once
#define STANDING_ORDER_PARTIAL_THRESHOLD 0.50
#define STANDING_ORDER_PARTIAL_PAYOUT_MULT 0.85
// Anti lag spam because every click would do a sweep and that could potentially get expensive
#define STANDING_ORDER_FULFILL_RETRY_COOLDOWN (2 SECONDS)
#define STANDING_ORDER_FULFILL_NEEDS_PARTIAL_PROMPT "needs_partial_prompt"



// Trade Escalation slope is the rate at which prices increase / decrease as it is oversold / overbought. Import / Export spread is an enforced differences between Buy / Sell price. By design, goods price is global for AP's internal regions, representing supply and demand and also preventing any same day arbitrage profit which does not generate meaningful gameplay but just reward you for reading and clicking the same damn buttons. 
#define TRADE_ESCALATION_SLOPE 1.0
#define IMPORT_EXPORT_SPREAD 0.25

#define TRADE_MAX_BULK_UNITS 50

// Blockade region are tradeable but at a punitive rate.
#define BLOCKADE_IMPORT_MULT 2.0
#define BLOCKADE_EXPORT_MULT 0.5

#define TRADE_STOCKPILE_BUY_DISCOUNT 0.75

#define STOCKPILE_AUTO_LIMIT_DAYS 2
#define STOCKPILE_LIMIT_MIN 5

// Buying the same import = escalating price
#define CROWN_IMPORT_ELASTICITY 0.1

#define REGION_POP_SCALE_PER_PLAYER 0.025
#define REGION_POP_SCALE_MAX 3.0


#define ECON_EVENT_DURATION 2
#define ECON_EVENT_SHORTAGE "shortage"
#define ECON_EVENT_OVERSUPPLY "oversupply"
#define ECON_EVENT_NARRATIVE "narrative"
#define ECON_EVENT_TARGET_COUNT 5
#define ECON_EVENT_ROUNDSTART_COUNT 3

// Temp consequences for bnaditry
#define BANDITRY_DRAIN_DANGEROUS_FLAT 40
#define BANDITRY_DRAIN_BLEAK_FLAT 80
#define BANDITRY_DRAIN_DANGEROUS_PER_PLAYER 1
#define BANDITRY_DRAIN_BLEAK_PER_PLAYER 2
// 500 above the default purse floor so that banditry won't tank econ on its own
#define BANDITRY_DEBT_FLOOR 1500


#define BLOCKADE_ROUNDSTART_COUNT_MIN 2
#define BLOCKADE_ROUNDSTART_COUNT_MAX 3
#define BLOCKADE_RECLEAR_COOLDOWN 1
#define BLOCKADE_SCROLL_PLEDGE_COST 500
#define BLOCKADE_SCROLL_REWARD 500

#define COMMISSION_BONUS_PAY_NONE 0
#define COMMISSION_BONUS_PAY_LIGHT 1
#define COMMISSION_BONUS_PAY_FULL 2
#define COMMISSION_BONUS_PAY_LIGHT_MULT 1.25
#define COMMISSION_BONUS_PAY_MULT 1.5
#define BLOCKADE_FELLOWSHIP_REQUIREMENT 3
#define BLOCKADE_WAVE_TIMER_DS (10 MINUTES)

#define BLOCKADE_ARM_TIMEOUT_DS (30 MINUTES)
#define BLOCKADE_RECALL_WINDOW_DS (15 MINUTES)

#define BLOCKADE_TOTAL_WAVES 3
#define BLOCKADE_WAVE_1_TP 72
#define BLOCKADE_WAVE_2_TP 72
#define BLOCKADE_WAVE_3_TP 104


#define PETITIONS_PER_DAY 3
#define PETITION_TAX_MULT 0.80
#define PETITION_BLOCKADE_RECOVERY_DAYS 2

#define PETITION_CATEGORY_PROVISIONS "provisions"
#define PETITION_CATEGORY_MATERIALS "materials"
#define PETITION_CATEGORY_ARMS "arms"
#define PETITION_CATEGORY_LUXURIES "luxuries"
#define PETITION_CATEGORY_ALCHEMY "alchemy"
#define PETITION_CATEGORY_MASTERWORK "masterwork"

#define PETITION_COST_PROVISIONS 200
#define PETITION_COST_MATERIALS 250
#define PETITION_COST_ARMS 300
#define PETITION_COST_LUXURIES 350
#define PETITION_COST_ALCHEMY 350
#define PETITION_COST_MASTERWORK 400

