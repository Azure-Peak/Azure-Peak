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

#define STANDING_ORDERS_BASE_PER_DAY 2
#define STANDING_ORDERS_PER_ACTIVE_PLAYER 0.05
#define STANDING_ORDERS_MAX_PER_DAY 10
#define STANDING_ORDERS_POOL_CAP 10
#define STANDING_ORDERS_MAX_PER_REGION 2

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

#define REGION_POP_SCALE_PER_PLAYER 0.025
#define REGION_POP_SCALE_MAX 3.0
