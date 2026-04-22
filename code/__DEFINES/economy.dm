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

#define TRADE_BEHAVIOR_RAW "raw"
#define TRADE_BEHAVIOR_INTERMEDIARY "intermediary"
#define TRADE_BEHAVIOR_GEM "gem"

#define TRADE_REGION_KINGSFIELD "kingsfield"
#define TRADE_REGION_ROSAWOOD "rosawood"
#define TRADE_REGION_ROCKHILL "rockhill"
#define TRADE_REGION_DAFTSMARCH "daftsmarch"
#define TRADE_REGION_BLACKHOLT "blackholt"
#define TRADE_REGION_SALTWICK "saltwick"
#define TRADE_REGION_BLEAKCOAST "bleakcoast"
#define TRADE_REGION_NORTHFORT "northfort"
#define TRADE_REGION_HEARTFELT "heartfelt"

#define STANDING_ORDER_DURATION 2

// Order count is NOT pop-scaled. Each order's size scales with pop instead via
// STANDING_ORDER_POP_SCALE_PER_PLAYER - this avoids drowning a single Steward in
// order-count triage while still proportioning Crown throughput to the player economy.
#define STANDING_ORDERS_BASE_PER_DAY 2
#define STANDING_ORDERS_PER_ACTIVE_PLAYER 0
#define STANDING_ORDERS_MAX_PER_DAY 10
#define STANDING_ORDERS_POOL_CAP 10
#define STANDING_ORDERS_MAX_PER_REGION 2

// Additive payout bonuses over base_price. Regular standing orders pay base * (1 + BASE_BONUS)
// per unit; urgent orders pay base * (1 + BASE_BONUS + URGENT_EXTRA) per unit. No multiplier
// stacking. Event price_mod applies on top as a separate multiplicand.
#define STANDING_ORDER_BASE_BONUS 0.75
#define URGENT_ORDER_EXTRA_BONUS 0.75

// Standing order size scales with active player count so the Crown's throughput matches
// the player economy. Size scales (not count) - a single Steward can only triage so many
// orders per day, but each one getting bigger keeps the scope per action manageable.
#define STANDING_ORDER_POP_SCALE_PER_PLAYER 0.03
#define STANDING_ORDER_POP_SCALE_MAX 3.0

// Per-unit price escalation past a region's daily production/demand.
// Import is the baseline: import_unit = base_price * (1 + overshoot * slope) * global_price_mod * blockade_mult.
// Export is derived: export_unit = import_unit * (1 - IMPORT_EXPORT_SPREAD), floored at low_price.
// The spread guarantees buy-then-sell is always a loss: Crown profits only from held stockpile
// accumulated through player deposits, shortage-held inventory, or standing order bonuses.
#define TRADE_ESCALATION_SLOPE 1.0
#define IMPORT_EXPORT_SPREAD 0.25

// Blockaded regions remain tradeable but at punitive rates.
// Import costs double, export revenue halves. Blockade-running is a desperate-times option.
#define BLOCKADE_IMPORT_MULT 2.0
#define BLOCKADE_EXPORT_MULT 0.5

#define TRADE_STOCKPILE_BUY_DISCOUNT 0.75

// Each subsequent import of the same crown_import in one day adds this much to the price.
// Resets when SSeconomy daily tick fires.
#define CROWN_IMPORT_ELASTICITY 0.1

#define REGION_POP_SCALE_PER_PLAYER 0.025
#define REGION_POP_SCALE_MAX 3.0

// Economic events: shortage/oversupply surges that bend trade_good.global_price_mod
// for a fixed window. Shortages also spawn a single bonus-pay urgent standing order.
#define ECON_EVENT_DURATION 2
#define ECON_EVENT_SHORTAGE "shortage"
#define ECON_EVENT_OVERSUPPLY "oversupply"
#define ECON_EVENT_NARRATIVE "narrative"
#define ECON_EVENT_TARGET_COUNT 5
#define ECON_EVENT_ROUNDSTART_COUNT 3

// Blockades
#define BLOCKADE_ROUNDSTART_COUNT_MIN 2
#define BLOCKADE_ROUNDSTART_COUNT_MAX 3
#define BLOCKADE_SCHEDULED_DAYS list(2, 4, 6)
#define BLOCKADE_RECLEAR_COOLDOWN 1
#define BLOCKADE_SCROLL_PLEDGE_COST 500
#define BLOCKADE_SCROLL_REWARD 500
#define BLOCKADE_FELLOWSHIP_REQUIREMENT 3
#define BLOCKADE_WAVE_TIMER_DS (5 MINUTES)
// Wave composition arrays in quest_blockade_defense.dm assume exactly 3 waves.
#define BLOCKADE_TOTAL_WAVES 3
#define BLOCKADE_WAVE_1_TP 60
#define BLOCKADE_WAVE_2_TP 90
#define BLOCKADE_WAVE_3_TP 130

