// Using STASPD for Movement Speed on mobs results in them being too oppressive / too easy to fight due to its interactions with dodge mechanics and swift weapons. Instead, we uses variable that is meant to represent the stats equivalence, set on the mob level. STASPD on simple mobs will not affect their movement speed, except when below 10, so that debuffs still work.
#define MOVEMENT_DELAY_SPD_23 0.2 SECONDS
#define MOVEMENT_DELAY_SPD_17 0.25 SECONDS
#define MOVEMENT_DELAY_SPD_10 0.3 SECONDS
#define MOVEMENT_DELAY_SPD_3 0.35 SECONDS
#define MOVEMENT_DELAY_SLOW 0.4 SECONDS
#define MOVEMENT_DELAY_LUMBERING 0.5 SECONDS
#define MOVEMENT_DELAY_CRAWLING 0.6 SECONDS

#define SIMPLEMOB_MINIMUM_MOVE_DELAY MOVEMENT_DELAY_SPD_23
#define SIMPLEMOB_MAXIMUM_MOVE_DELAY MOVEMENT_DELAY_CRAWLING
#define SIMPLEMOB_DEFAULT_MOVE_DELAY MOVEMENT_DELAY_SPD_3

//Applied when a player-controlled creature toggles to run.
#define SIMPLEMOB_RUN_MULTIPLIER 0.75
//Applied when a player-controlled creature toggles to sneak.
#define SIMPLEMOB_SNEAK_MULTIPLIER 1.6

//Subtracted while a dryad stands on its own vines, halving its delay.
#define DRYAD_VINE_SPEEDUP -3
