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

#define REGION_AZUREBASIN "azurebasin"
#define REGION_AZUREGROVE "azuregrove"
#define REGION_TERRORBOG "terrorbog"
#define REGION_AZUREANCOAST "azureancoast"
#define REGION_MOUNTDECAP "mountdecap"
#define REGION_UNDERDARK "underdark"

#define STANDING_ORDER_DURATION 2

#define STANDING_ORDERS_BASE_PER_DAY 2
#define STANDING_ORDERS_PER_ACTIVE_PLAYER 0.05
#define STANDING_ORDERS_MAX_PER_DAY 10
#define STANDING_ORDERS_POOL_CAP 10
#define STANDING_ORDERS_MAX_PER_REGION 2

// Per-unit price escalation past a region's daily production/demand.
// Import (buying): unit_price = base_price * (1 + overshoot_ratio * slope). Unbounded upward.
// Export (selling): unit_price = base_price * (1 - overshoot_ratio * slope), floored at low_price.
#define TRADE_ESCALATION_SLOPE 1.0

#define TRADE_STOCKPILE_BUY_DISCOUNT 0.75
