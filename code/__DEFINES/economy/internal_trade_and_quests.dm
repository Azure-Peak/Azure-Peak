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
#define TRADE_REGION_BLEAKISLES "bleakisles"
#define TRADE_REGION_NORTHMARCH "northmarch"
#define TRADE_REGION_EVESWOOD "eveswood"
#define TRADE_REGION_RHU_ROSHA "rhu_rosha"
#define TRADE_REGION_SOUTH_SYONS "south_syons"
#define TRADE_REGION_NORTH_SYONS "north_syons"
#define TRADE_REGION_DALESWORTH "dalesworth"
#define TRADE_REGION_AVONDALE "avondale"
#define TRADE_REGION_BEWMARCH "bewmarch"
#define TRADE_REGION_HEARTFELT "heartfelt"
#define TRADE_REGION_HAGENWALD "hagenwald"

#define ECONOMY_DAY (max(1, GLOB.dayspassed))

// How many caravans you start with - 4 for a decent amount of Steward agency
// You get +1 per day, up to a maximum of 8. This way Steward don't need to compete and gain increased economic power as the round goes on
#define CARAVAN_FLEET_START 3
#define CARAVAN_FLEET_PER_DAY 1
#define CARAVAN_FLEET_MAX 8

#define ESCORT_FEE_BASE 200
#define ESCORT_FEE_PER_DAY 100
#define RAID_DEAL_SIZE_PERCENT 50

#define STANDING_ORDER_DURATION 2

// Order SIZE is not scaled but
#define STANDING_ORDERS_BASE_PER_DAY 4
#define STANDING_ORDERS_PER_ACTIVE_PLAYER 0.05
#define STANDING_ORDERS_MAX_PER_DAY 13
#define STANDING_ORDERS_POOL_CAP 13
#define STANDING_ORDERS_MAX_PER_REGION 1

#define STANDING_ORDER_BASE_BONUS 1.5

#define STANDING_ORDER_VALUE_MIN 200
#define STANDING_ORDER_VALUE_MAX 400

#define STANDING_ORDER_EXTEND_COST 200
#define STANDING_ORDER_EXTEND_DAYS 1

#define OFFER_DURATION 1
#define OFFERS_BASE_PER_DAY 4
#define OFFERS_PER_ACTIVE_PLAYER 0.05
#define OFFERS_MAX_PER_DAY 13
#define OFFERS_POOL_CAP 13
#define OFFERS_MAX_PER_REGION 1
#define OFFER_VALUE_MIN 200
#define OFFER_VALUE_MAX 400
#define OFFER_PRICE_MULT 0.9

#define TRIBUTE_VALUE 150
#define TRIBUTE_POP_SCALE_START 60
#define TRIBUTE_POP_SCALE_FULL 120
#define TRIBUTE_POP_MAX_MULT 2

// Number tweaking or tuning for noble essay, for the value and the interval of their gifts
#define ESTATE_TIER_NONE 0
#define ESTATE_TIER_NORMAL 1
#define ESTATE_TIER_HIGH 2
#define ESTATE_TIER_LORD 3
#define ESTATE_COIN_NORMAL 15
#define ESTATE_COIN_HIGH 30
#define ESTATE_COIN_LORD 50
#define ESTATE_PARCELS_NORMAL 1
#define ESTATE_PARCELS_HIGH 2
#define ESTATE_PARCELS_LORD 3
#define ESTATE_PARCEL_VALUE 15
#define ESTATE_GIFT_INTERVAL 3

#define REQUEST_KIND_GOODS "goods"

#define REQUEST_WEIGHT_GOODS 6
#define REQUEST_WEIGHT_ARMS 3
#define REQUEST_WEIGHT_HEAVY_ARMOR 3
#define REQUEST_WEIGHT_LIGHT_ARMOR 3
#define REQUEST_WEIGHT_POTIONS 3
#define REQUEST_WEIGHT_PROSTHETICS 2
#define REQUEST_WEIGHT_ARTIFICERY 2
#define REQUEST_WEIGHT_PANOPLY 1
#define REQUEST_WEIGHT_FINERY 2
#define REQUEST_WEIGHT_JEWELRY 2
#define REQUEST_WEIGHT_SCROLLS 2
#define REQUEST_WEIGHT_TROPHIES 1



#define STOCKPILE_BID_RATIO 0.75
#define ROYAL_SUBSIDY_DAILY_ALLOWANCE 100
#define STOCKPILE_PRICE_STEP 0.1
#define MAMMON_PRECISION 0.01

#define MARKET_TARGET_RARE 10
#define MARKET_TARGET_LOW 15
#define MARKET_TARGET_STAPLE 20
#define MARKET_TARGET_MODEST 25
#define MARKET_TARGET_STANDARD 40
#define MARKET_TARGET_BULK 80
#define MARKET_TARGET_MASS 120

#define MARKET_STEP_GLUT 1
#define MARKET_STEP_OVERSTOCKED 2
#define MARKET_STEP_ABUNDANT 3
#define MARKET_STEP_PLENTIFUL 4
#define MARKET_STEP_STEADY 5
#define MARKET_STEP_LOW 6
#define MARKET_STEP_SCARCE 7
#define MARKET_STEP_VERY_SCARCE 8
#define MARKET_STEP_SHORTAGE 9

// Percentage compared to target that determines the stock level. For example, if the target is 10 and the stock is 20, then the ratio is 200% and the market step is OVERSTOCKED.
#define MARKET_RATIO_OVERSTOCKED 200
#define MARKET_RATIO_ABUNDANT 160
#define MARKET_RATIO_PLENTIFUL 125
#define MARKET_RATIO_STEADY 80
#define MARKET_RATIO_LOW 65
#define MARKET_RATIO_SCARCE 50
// How much stock can dip below 0 relative to the target before you completely run out of stock. This put some limit on market elasticity to avoid infinite goods supply.
#define MARKET_RATIO_OUT_OF_STOCK -50

#define MARKET_GLUT_SHOCK 300

#define MARKET_DAY_RATE 50
#define MARKET_DAY_FLOOR 25
#define MARKET_DAY_GRACE_DAYS 1

// Price multiplier based on market condition
#define MARKET_MULT_GLUT 25
#define MARKET_MULT_OVERSTOCKED 50
#define MARKET_MULT_ABUNDANT 65
#define MARKET_MULT_PLENTIFUL 80
#define MARKET_MULT_STEADY 100
#define MARKET_MULT_LOW 125
#define MARKET_MULT_SCARCE 150
#define MARKET_MULT_VERY_SCARCE 200
#define MARKET_MULT_SHORTAGE 300

#define TRADE_MAX_BULK_UNITS 50

#define CROWN_IMPORT_DAILY_STOCK 2

#define COMMISSION_DAILY_STOCK 2
#define COMMISSION_PRICE_MARKUP 1.5
#define COMMISSION_LEAD_TIME (20 MINUTES)

#define TRADE_STOCKPILE_BUY_DISCOUNT 0.75

#define ECON_EVENT_DURATION 2
#define ECON_EVENT_SHORTAGE "shortage"
#define ECON_EVENT_OVERSUPPLY "oversupply"
#define ECON_EVENT_NARRATIVE "narrative"
#define ECON_EVENT_TARGET_COUNT 5
#define ECON_EVENT_ROUNDSTART_COUNT 3
#define ECON_EVENT_RELIEF_PERCENT 50
#define ECON_EVENT_REROLL_COOLDOWN_DAYS 7

#define ECON_SHORTAGE_MINOR	2.00
#define ECON_SHORTAGE_NORMAL	2.25
#define ECON_SHORTAGE_MAJOR	2.5
#define ECON_SHORTAGE_SEVERE	2.75
#define ECON_SHORTAGE_CRISIS	3.00

#define ECON_OVERSUPPLY_MINOR	0.70
#define ECON_OVERSUPPLY_NORMAL 0.65
#define ECON_OVERSUPPLY_MAJOR	0.60
#define ECON_OVERSUPPLY_SEVERE 0.55
#define ECON_OVERSUPPLY_GLUT	0.50

// Temp consequences for bnaditry
#define BANDITRY_DRAIN_DANGEROUS_FLAT 40
#define BANDITRY_DRAIN_BLEAK_FLAT 80
#define BANDITRY_DRAIN_DANGEROUS_PER_PLAYER 1
#define BANDITRY_DRAIN_BLEAK_PER_PLAYER 2
// 500 above the default purse floor so that banditry won't tank econ on its own
#define BANDITRY_DEBT_FLOOR 1500

// Fraction of any Crown's Purse credit skimmed to pay down banditry debt while it's outstanding.
// Was 1.0 (100%), which made the purse unable to visibly recover until debt cleared.
#define BANDITRY_DEBT_SKIM_RATE 0.75


#define BLOCKADE_ROUNDSTART_COUNT_MIN 2
#define BLOCKADE_ROUNDSTART_COUNT_MAX 3
#define BLOCKADE_RECLEAR_COOLDOWN 1
#define BLOCKADE_SCROLL_PLEDGE_COST 500
#define BLOCKADE_SCROLL_REWARD 715
#define BLOCKADE_TRAVEL_FEE_COAST 75
#define BLOCKADE_TRAVEL_FEE_MOUNTAIN 150

#define BLOCKADE_REPLENISH_FLOOR 1
#define BLOCKADE_REPLENISH_BUDGET_BASE 1
#define BLOCKADE_REPLENISH_BUDGET_PER_PLAYER 0.02	// +1 per 50 active players
#define BLOCKADE_REPLENISH_BUDGET_MAX 2
#define BLOCKADE_REPLENISH_FIRST_DAY 2
#define BLOCKADE_REPLENISH_LAST_DAY 5 // No last minute blockade
#define BLOCKADE_REPLENISH_DAILY_CHANCE 50 // Chance to fire on an eligible day

#define COMMISSION_BONUS_PAY_NONE 0
#define COMMISSION_BONUS_PAY_LIGHT 1
#define COMMISSION_BONUS_PAY_FULL 2
#define COMMISSION_BONUS_PAY_LIGHT_MULT 1.25
#define COMMISSION_BONUS_PAY_MULT 1.5

#define PETITIONS_PER_DAY 3
#define PETITION_TAX_MULT 0.80
#define PETITION_BLOCKADE_RECOVERY_DAYS 2

#define PETITION_CATEGORY_MATERIALS "materials"
#define PETITION_CATEGORY_ARMS "arms"
#define PETITION_CATEGORY_LUXURIES "luxuries"
#define PETITION_CATEGORY_ALCHEMY "alchemy"
#define PETITION_CATEGORY_MASTERWORK "masterwork"

#define PETITION_COST_MATERIALS 250
#define PETITION_COST_ARMS 300
#define PETITION_COST_LUXURIES 350
#define PETITION_COST_ALCHEMY 350
#define PETITION_COST_MASTERWORK 400

