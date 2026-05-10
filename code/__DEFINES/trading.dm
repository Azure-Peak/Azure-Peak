#define NATIONALITY_GRENZELHOFT "grenzelhoft"
#define NATIONALITY_OTAVA "otava"
#define NATIONALITY_KAZENGUN "kazengun"
#define NATIONALITY_HAMMERHOLD "hammerhold"

#define TRADE_SHIP_DOCK_DURATION (60 MINUTES)
#define TRADE_SHIP_SEND_AWAY_GRACE (20 MINUTES)

#define TRADE_SHIPS_PER_DAY_ROLL 4
#define TRADE_SHIPS_HAIL_PER_DAY 2

#define TRADE_SHIP_DOCK_SPOTS_BASE 2
#define TRADE_SHIP_DOCK_SPOTS_MAX 4

#define TRADE_SHIP_EXPECTED_FAVOR 2500
#define TRADE_SHIP_DEFAULT_TONNAGE 100
#define TRADE_SHIP_TONNAGE_VARIANCE 0.3

// Pool composition weights. Higher = more frequent arrivals in the daily roll.
// Geographic + commercial proximity to Azuria should bias this.
#define TRADE_NATION_WEIGHT_DEFAULT 10
#define TRADE_NATION_WEIGHT_NEIGHBOR 20
#define TRADE_NATION_WEIGHT_DISTANT 10

// For any upgrades you can buy
#define ADDITIONAL_PIER_FAVOR 5000
#define GNOME_AUTOMATION_FAVOR 10000

#define TRADE_SHIP_STATE_AVAILABLE "available"
#define TRADE_SHIP_STATE_DOCKED "docked"
