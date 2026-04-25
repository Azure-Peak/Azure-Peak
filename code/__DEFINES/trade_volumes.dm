// Per-day throughput defaults for /datum/economic_region produces and demands lists.
//
// These defines are the sole knobs for base supply/demand across the realm. Tuning any one
// value here rebalances every good that uses that category at every region in one edit.
// Regions may still write literal values with an inline comment for deliberate outliers
// (a starving fort, a narratively-scarce essence, etc.).
//
// Pop scaling in SSeconomy multiplies these at runtime. The numbers here are the lowpop
// floor, not the highpop cap.

// ---- Supply (what a source region produces per day) ----
#define TG_SUPPLY_LOCAL_GRAIN       10  // Kingsfield's bread basket - flagship category
#define TG_SUPPLY_FOREIGN_GRAIN      5  // Kingsfield's oats/rice or any outlying grain producer
#define TG_SUPPLY_LOCAL_FRUIT        6  // Rockhill orchard fruit
#define TG_SUPPLY_RARE_FRUIT         3  // Exotic fruit (lemon, lime, tangerine, plum) - reserved
#define TG_SUPPLY_CHEAP_RAW_MAT     12  // Wood and stone - the highest-volume bulk commodities
#define TG_SUPPLY_IRON               8  // Iron ore from the mining hub
#define TG_SUPPLY_TIN_BRONZE         6  // Copper and tin ore
#define TG_SUPPLY_PRECIOUS_METAL     5  // Gold ore, silver ore
#define TG_SUPPLY_SPECIALTY_HERB     4  // Calendula, poppy, viscera
#define TG_SUPPLY_FIBERS             8  // Rosawood fibers - secondary bulk
#define TG_SUPPLY_SILK               4  // Blackholt silk
#define TG_SUPPLY_LEATHER            5  // Hide, fur, cured leather
#define TG_SUPPLY_SALT               6  // Daftsmarch salt
#define TG_SUPPLY_GLASS              4  // Glass batch from Daftsmarch
#define TG_SUPPLY_MEAT_STAPLE        5  // Pork, poultry, rabbit, butter, cheese, fat, tallow
#define TG_SUPPLY_MEAT_BULK          6  // Beef, egg
#define TG_SUPPLY_COMMON_VEG         5  // Potato, onion, carrot, turnip, cabbage
#define TG_SUPPLY_FISH_BULK          8  // Fish filet from Saltwick
#define TG_SUPPLY_FISH_MINCE         6  // Fish mince
#define TG_SUPPLY_FISH_SPECIALTY     6  // Named fish - salmon, cod, crab, bass, carp, sole, clam, lobster, shrimp
#define TG_SUPPLY_REFINED_INGOTS     6  // Hagenwald's iron/steel/copper/tin ingots

// ---- Demand (what a consuming region buys per day) ----
// Most categories mirror supply. Some are demand-only (REFINED_INGOTS, GEM, CLOTH, some ESSENCE).
#define TG_DEMAND_LOCAL_GRAIN        6  // Forts and cold regions eat bread hard
#define TG_DEMAND_LOCAL_FRUIT        5
#define TG_DEMAND_RARE_FRUIT         3
#define TG_DEMAND_CHEAP_RAW_MAT      5  // Stone and wood into settlements and garrisons
#define TG_DEMAND_IRON               5
#define TG_DEMAND_TIN_BRONZE         4
#define TG_DEMAND_PRECIOUS_METAL     4  // Kingsfield appetite for gold/silver/cinnabar
#define TG_DEMAND_SPECIALTY_HERB     4
#define TG_DEMAND_CLOTH              6  // Demand-only; cloth is crafted from fibers
#define TG_DEMAND_SILK               4
#define TG_DEMAND_LEATHER            4
#define TG_DEMAND_SALT               5
#define TG_DEMAND_GLASS              3
#define TG_DEMAND_MEAT_STAPLE        5
#define TG_DEMAND_MEAT_BULK          6
#define TG_DEMAND_COMMON_VEG         4
#define TG_DEMAND_FISH_BULK          8
#define TG_DEMAND_FISH_SPECIALTY     6
#define TG_DEMAND_GEM                4  // Kingsfield luxury; no region produces
#define TG_DEMAND_REFINED_INGOTS     5  // Iron/steel/copper/tin/gold/silver ingots - player-crafted
