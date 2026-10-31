
#define TRAIT_FISH_TOXIN_IMMUNE "fish_toxin_immune"
/**
 * This fish has been fed teslium without the electrogenesis having trait.
 * Gives the electrogenesis, but at halved output, and it hurts the fish over time.
 */

/// Use in fish tables to denote miss chance.
#define FISHING_DUD "dud"

// Baseline fishing difficulty levels
#define FISHING_DEFAULT_DIFFICULTY 15
/**
 * The minimum value of the difficulty of the minigame (unless it reaches 0 than it's auto-win)
 * Any lower than this and the fish will be way too lethargic for the minigame to be engaging in the slightest.
 */
#define FISHING_MINIMUM_DIFFICULTY 6

/// Difficulty modifier when bait is fish's favorite
#define FAV_BAIT_DIFFICULTY_MOD -5
/// Difficulty modifier when bait is fish's disliked
#define DISLIKED_BAIT_DIFFICULTY_MOD 15
#define FISH_TRAIT_MINOR_DIFFICULTY_BOOST 5

#define ADDITIVE_FISHING_MOD "additive"
#define MULTIPLICATIVE_FISHING_MOD "multiplicative"

// These defines are intended for use to interact with fishing hooks when going
// through the fishing rod, and not the hook itself. They could probably be
// handled differently, but for now that's how they work. It's grounds for
// a future refactor, however.
/// Fishing hook trait that lessens the bounce from hitting the edges of the minigame bar.
#define FISHING_HOOK_WEIGHTED (1 << 0)
///See FISHING_MINIGAME_RULE_BIDIRECTIONAL
#define FISHING_HOOK_BIDIRECTIONAL (1 << 1)
///Prevents the user from losing the game by letting the fish get away.
#define FISHING_HOOK_NO_ESCAPE (1 << 2)
///The minigame ends in a win on its own after a while, for half the experience.
#define FISHING_HOOK_KILL (1 << 3)

///Demersal fish stop drifting to the bottom of the bar and bite more often.
#define FISHING_LINE_SINKER (1 << 0)
///The bait sinks slower during the minigame.
#define FISHING_LINE_BOBBER (1 << 1)

/// Tier of fishing line. Leather is default and not a trait here.
#define FISHING_REEL_FRAYED (1 << 0)
#define FISHING_REEL_SMOOTH (1 << 1)
#define FISHING_REEL_BLESSED (1 << 2)
/// Thin enough that wary fish do not notice it. Silk and deluxe.
#define FISHING_REEL_THIN (1 << 3)

// Fishing line tier effects. Added to the minigame's completion loss (per second off the fish) and gain (per second on it).
#define FISHING_REEL_FRAYED_LOSS 1
#define FISHING_REEL_SMOOTH_LOSS -1
#define FISHING_REEL_BLESSED_LOSS -1
#define FISHING_REEL_BLESSED_GAIN 1

// The fish's quality, size, rarity, and sellprice is linked tightly together. Rarity is read off the catch's size against its species average. Bought and placed fish are average, so common.
// Each fish produce a base amount of fillet, which is multiplied by its size and value.
// Fish price ladder.
#define FISH_PRICE_BAIT 3
#define FISH_PRICE_COMMON 5
#define FISH_PRICE_FAIR 8
#define FISH_PRICE_GOOD 10
#define FISH_PRICE_FINE 15
#define FISH_PRICE_RARE 20
#define FISH_PRICE_PRIZED 40

// Fillets a fish of average size chops into. Scales with the size of the actual catch.
#define FISH_FILLETS_TINY 1
#define FISH_FILLETS_SMALL 2
#define FISH_FILLETS_MEDIUM 3
#define FISH_FILLETS_LARGE 4
#define FISH_FILLETS_HUGE 6
#define FISH_FILLETS_GIANT 8
// A whole cooked fish feeds this much per fillet it would have chopped into
#define FISH_COOKED_NUTRIMENT_PER_FILLET 5

// Swordfish doubles as a dagger
#define SWORDFISH_FORCE 14

#define FISH_RARITY_COMMON 0
#define FISH_RARITY_RARE 1
#define FISH_RARITY_ULTRA 2
#define FISH_RARITY_LEGENDARY 3
#define FISH_RARITY_RARE_RATIO 1.3
#define FISH_RARITY_ULTRA_RATIO 1.7
#define FISH_RARITY_LEGENDARY_RATIO 2.1
#define FISH_RARITY_RARE_PRICE_MULT 2
#define FISH_RARITY_ULTRA_PRICE_MULT 4
#define FISH_RARITY_LEGENDARY_PRICE_MULT 7
#define FISH_ROYAL_PRICE_MULT 3

// Being good at the fishing minigame improves the quality of your catch. While auto-reeling will never catch prized fish and is less responsive.
// By keeping the window on the fish for long enough, your catch will be a "great" catch and colored gold, which improves the fish.
// A "fair" catch is colored green and does nothing, while a poor catch lowers the quality.
#define CATCH_BAND_POOR 0
#define CATCH_BAND_FAIR 1
#define CATCH_BAND_CLEAN 2
#define FISHING_CLEAN_CATCH_RATIO 0.75
#define FISHING_FAIR_CATCH_RATIO 0.45
#define FISHING_CLEAN_CATCH_SIZE_MULT 1.3
#define FISHING_POOR_CATCH_SIZE_MULT 0.8
#define FISHING_CLEAN_CATCH_COLOR "#ffe14a"
// Brighten the catch color because the pixels are dark
#define FISHING_CATCH_BAND_BRIGHTNESS 1.8
#define FISHING_FAIR_CATCH_COLOR "#5fbf5f"
#define FISHING_POOR_CATCH_COLOR "#d04040"

/// How many seconds of grace you have before the catch quality starts to decay.
#define FISHING_CATCH_BAND_GRACE 5

// Auto Reel is slower and cannot catch priced fish.
#define FISHING_AUTO_REEL_SPEED_MULT 0.75

// Latency compensation for the fishing minigame
#define FISHING_LAG_COMP_MAX_PING 400
#define FISHING_PING_SLOWDOWN_PER_100MS 0.1
#define FISHING_PING_SLOWDOWN_FLOOR 0.6

// How long you have to land a fish before it gets away.
// Difficulty is the sum of the water, the fish, your rod, your bait, the fish's traits and your skill. A sunny in still water is around 25, an anglerfish in the deep ocean around 45, a river sturgeon over 60. The thorn hook ignores the clock.
#define FISHING_MINIGAME_EASY_TIME (50 SECONDS)
#define FISHING_MINIGAME_HARD_TIME (15 SECONDS)
#define FISHING_MINIGAME_HARD_DIFFICULTY 75

// When the fight starts the fisher is told how hard it will be, so they learn what the clock means. Hardness runs from 0 (easiest) to 1 (the hard difficulty above).
#define FISHING_FIGHT_EASY_HARDNESS 0.25
#define FISHING_FIGHT_FAIR_HARDNESS 0.5
#define FISHING_FIGHT_HARD_HARDNESS 0.75

// Fishing rod tier effects. Difficulty is added to the minigame difficulty; bait height scales the catch window on the bar. The plain rod is the baseline.
#define FISHING_ROD_CRAFTED_DIFFICULTY 5
#define FISHING_ROD_BRONZE_DIFFICULTY -3
#define FISHING_ROD_BLACKSTEEL_DIFFICULTY -5
#define FISHING_ROD_BLACKSTEEL_BAIT_HEIGHT 1.15
#define FISHING_ROD_ANCIENT_DIFFICULTY -8
#define FISHING_ROD_ANCIENT_BAIT_HEIGHT 1.3

// Wooden Hooks make it harder to catch larger fishes
#define FISHING_HOOK_WOODEN_ADDITIVE -1
#define FISHING_HOOK_WOODEN_LARGE_RATIO 1
#define FISHING_HOOK_WOODEN_LARGE_MULT 0.75
#define FISHING_HOOK_WOODEN_HUGE_RATIO 1.3
#define FISHING_HOOK_WOODEN_HUGE_MULT 0.5

// Iron hook makes the bait recoils way less
#define FISHING_HOOK_IRON_BOUNCE 0.1

// Carved minnow hook shuns small fishes and favours big ones
#define FISHING_HOOK_MINNOW_RUNT_RATIO 0.6
#define FISHING_HOOK_MINNOW_RUNT_MULT 0.25
#define FISHING_HOOK_MINNOW_SMALL_RATIO 0.8
#define FISHING_HOOK_MINNOW_SMALL_MULT 0.5
#define FISHING_HOOK_MINNOW_BELOW_RATIO 1
#define FISHING_HOOK_MINNOW_BELOW_MULT 0.75
#define FISHING_HOOK_MINNOW_BIG_RATIO 1.3
#define FISHING_HOOK_MINNOW_BIG_MULT 1.5

// Having any bobber / sinker improves the progress bar
#define FISHING_LINE_ANY_GAIN 1
// Bobber makes the bait sink slower
#define FISHING_BOBBER_GRAVITY_MULT 0.75
// Sinker makes demersal fishes bite more often
#define FISHING_SINKER_DEMERSAL_MULT 1.5

// Baits gives additional catchable weight to fish it can catch and additional weight to those that have it as a favorite. Which fish favour which bait is on the fish, in raw_fish.dm.
#define FISHING_BAIT_CATCHABLE_WEIGHT 5
#define FISHING_BAIT_FAVOURITE_WEIGHT 10

// Each catch spends one point of bait resilience only on a failed roll. Expected catches per bait = max(1, resilience) * 100 / spend chance.
#define FISHING_BAIT_SPEND_CHANCE_BASE 80
#define FISHING_BAIT_SPEND_CHANCE_PER_SKILL 10

// Red
#define FISHING_BAIT_RED_CARNIVORE_MULT 1.3

// Dough
#define FISHING_BAIT_DOUGH_HERBIVORE_MULT 1.3

// Speckled
#define FISHING_BAIT_SPECKLED_SMALL_MULT 0.7

// Shell Bait: So that it targets bottom dwellers more
#define FISHING_BAIT_SHELL_DEMERSAL_MULT 1.3

// Enchanted
#define FISHING_BAIT_ENCHANTED_CHANCE 20
#define FISHING_BAIT_ENCHANTED_MULT 1.5

// Abyssorite ritual turns this much baits into enchanted baits, for a cup of ale
#define FISHING_ENCHANT_RITE_BAITS 18
#define FISHING_ENCHANT_RITE_ALE 25

///Keeps the bait from falling from gravity, instead allowing the player to move the bait down with right click.
#define FISHING_MINIGAME_RULE_BIDIRECTIONAL (1 << 0)
///Prevents the player from losing the minigame when the completion reaches 0
#define FISHING_MINIGAME_RULE_NO_ESCAPE (1 << 1)
///Automatically kills the fish after a while, at the cost of killing it
#define FISHING_MINIGAME_RULE_KILL (1 << 2)
///Prevents the fishing skill from having an effect on the minigame and experience from being awarded
#define FISHING_MINIGAME_RULE_NO_EXP (1 << 3)
///If enabled, the minigame will occasionally screw around and invert the velocity of the bait
#define FISHING_MINIGAME_RULE_ANTIGRAV (1 << 4)
///The fish will fade in and out at intervals
#define FISHING_MINIGAME_RULE_CAMO (1 << 7)

///all the effects that are active and will last for a few seconds before triggering a cooldown
#define FISHING_MINIGAME_ACTIVE_EFFECTS (FISHING_MINIGAME_RULE_ANTIGRAV|FISHING_MINIGAME_RULE_CAMO)

/// The default additive value for fishing hook catch weight modifiers.
#define FISHING_DEFAULT_HOOK_BONUS_ADDITIVE 0
/// The default multiplicative value for fishing hook catch weight modifiers.
#define FISHING_DEFAULT_HOOK_BONUS_MULTIPLICATIVE 1

//Fish icon defines, used by fishing minigame
#define FISH_ICON_DEF "fish"
#define FISH_ICON_HOSTILE "hostile"
#define FISH_ICON_CRAB "crab"
#define FISH_ICON_GEM "gem"

///Size and weight are rolled to this precision.
#define FISH_MEASURE_PRECISION 0.01
///Inches to a hand and ounces to a pound, for examine below one unit.
#define FISH_INCHES_PER_HAND 4
#define FISH_OUNCES_PER_POUND 16

///The coefficient for maximum weight/size divergence relative to the averages.
#define MAX_FISH_DEVIATION_COEFF 2.5
// Weight of a fish now follows its length.
#define FISH_WEIGHT_LENGTH_POWER 3
#define FISH_WEIGHT_JITTER 0.1
#define FISH_MAX_VISUAL_SCALE 1.5

//IF YOU ADD ANY NEW FLAG, ADD IT TO THE RESPECTIVE BITFIELD in _globalvars/bitfields.dm TOO!

///This fish is shown in the catalog and on the wiki (this only matters as an initial, compile-time value)
#define FISH_FLAG_SHOW_IN_CATALOG (1<<0)

///Aquarium fluid variables. The fish' required fluid has to match this, or it'll slowly die.
#define FISH_FLUID_FRESHWATER "Freshwater"
#define FISH_FLUID_SALTWATER "Saltwater"
#define FISH_FLUID_ANY_WATER "Any Fluid"

//Minigame defines
/// The height of the minigame slider. Not in pixels, but minigame units.
#define FISHING_MINIGAME_AREA 1000

///Defines for fish properties from the collect_fish_properties proc
#define FISH_PROPERTIES_FAV_BAIT "fav_bait"
#define FISH_PROPERTIES_BAD_BAIT "bad_bait"
#define FISH_PROPERTIES_TRAITS "fish_traits"

///Define for favorite and disliked baits that aren't just item typepaths.
#define FISH_BAIT_TYPE "Type"
#define FISH_BAIT_FOODTYPE "Foodtype"
#define FISH_BAIT_REAGENT "Reagent"
#define FISH_BAIT_VALUE "Value"
#define FISH_BAIT_AMOUNT "Amount"

// -1 is used to denote a fish that never runs out in a fish source's fish counts. All fish table must have a count or this
#define FISH_STOCK_UNLIMITED -1

///We multiply the weight of fish inside the loot table by this value if we are goofy enough to fish without a bait.
#define FISH_WEIGHT_MULT_WITHOUT_BAIT 0.15

// Expert Fishers find the minigame a little easier, read a water's prized stock on examine, are told on cast when it runs low, and get a warning and a moment before a hostile catch surfaces.
#define EXPERT_FISHER_DIFFICULTY_MOD -5
#define FISHING_STOCK_TEEMING_RATIO 0.75
#define FISHING_STOCK_LOW_RATIO 0.35
#define FISHING_HOSTILE_WARNING_DELAY (5 SECONDS)

// Each fishing level past Novice fills the minigame bar this percent faster and drains it this percent slower. Below Novice it becomes a penalty.
#define FISHING_SKILL_COMPLETION_PERCENT 10
// Weight multiplier on prized fish by fishing skill
#define FISHING_SKILL_PRIZED_MULT_EXPERT 1.25
#define FISHING_SKILL_PRIZED_MULT_MASTER 1.5
#define FISHING_SKILL_PRIZED_MULT_LEGENDARY 2
// Weight multiplier on empty catches by fishing skill
#define FISHING_SKILL_DUD_MULT_JOURNEYMAN 0.75
#define FISHING_SKILL_DUD_MULT_EXPERT 0.5
#define FISHING_SKILL_DUD_MULT_MASTER 0.25
#define FISHING_SKILL_DUD_MULT_LEGENDARY 0.1

// Make cages slower so that fishing manually is competitive
/// Seconds between a baited fishing cage's catches at no skill and at legendary skill.
#define FISHING_CAGE_CATCH_TIME_SLOWEST 90
#define FISHING_CAGE_CATCH_TIME_FASTEST 45

/**
 * Flag for fish sources. It makes large explosions less efficient at spawning fish.
 * Meant for lazy fishing spots that cover multiple turfs (rivers, oceans etc.)
 */

/**
 * A macro to ensure the wikimedia filenames of fish icons are unique, especially since there're a couple fish that have
 * quite ambiguous names/icon_states like "checkered" or "pike"
 */

/// You won't catch duds while fishing with this rod.
#define TRAIT_ROD_REMOVE_FISHING_DUD "rod_remove_fishing_dud"
/// If the item can be used as a bit.
#define TRAIT_FISHING_BAIT "fishing_bait"
/// This bait will kill any fish that doesn't have it on its favorite_bait list
#define TRAIT_POISONOUS_BAIT "poisonous_bait"
/// The quality of the bait. It influences odds of catching fish
#define TRAIT_BASIC_QUALITY_BAIT "baic_quality_bait"
#define TRAIT_GOOD_QUALITY_BAIT "good_quality_bait"
#define TRAIT_GREAT_QUALITY_BAIT "great_quality_bait"
/// Baits with this trait will ignore bait preferences and related fish traits.
#define TRAIT_OMNI_BAIT "omni_bait"
/// The bait won't be consumed when used
#define TRAIT_BAIT_UNCONSUMABLE "bait_unconsumable"
/**
 * This bait won't apply TRAIT_ROD_REMOVE_FISHING_DUD to the rod it's attached on,
 * instead, it'll allow the fishing dud to be there unless there's at least one fish that likes the bait
 */
#define TRAIT_BAIT_ALLOW_FISHING_DUD "bait_dont_affect_fishing_dud"
/**
 * This location has the aquarium component. Not much different than a GetComponent()
 * disguised as an 'is_x' macro, but I don't have to hide anything here.
 * I just don't want a confusing 'is_aquarium(A)' macro which people think it's interchangable with
 * an 'istype(A, /obj/structure/aquarium)' when it's the component what truly matters.
 */
///Trait given to turfs or objects that can be fished from
#define TRAIT_FISHING_SPOT "fishing_spot"

// Aquarium related signals

// Fish signals
#define COMSIG_FISH_STATUS_CHANGED "fish_status_changed"

#define COMSIG_FISH_CAUGHT "fish_caught"

///From /datum/fishing_challenge/New: (datum/fishing_challenge/challenge)
#define COMSIG_ROD_BEGIN_FISHING "rod_begin_fishing"
///From /datum/fishing_challenge/New: (datum/fishing_challenge/challenge)
#define COMSIG_MOB_BEGIN_FISHING "mob_begin_fishing"
///From /datum/fishing_challenge/start_minigame_phase: (datum/fishing_challenge/challenge)
#define COMSIG_MOB_BEGIN_FISHING_MINIGAME "mob_begin_fishing_minigame"
///From /datum/fishing_challenge/completed: (datum/fishing_challenge/challenge, win)
#define COMSIG_MOB_COMPLETE_FISHING "mob_complete_fishing"

/// Rolling a reward path for a fishing challenge
#define COMSIG_FISHING_CHALLENGE_ROLL_REWARD "fishing_roll_reward"
/// Adjusting the difficulty of a rishing challenge, often based on the reward path
#define COMSIG_FISHING_CHALLENGE_GET_DIFFICULTY "fishing_get_difficulty"
/// From /datum/fishing_challenge/start_minigame_phase, called after the fish movement datum is spawned: (datum/fish_movement/mover)
#define COMSIG_FISHING_CHALLENGE_MOVER_INITIALIZED "fishing_mover_initialized"
/// Fishing challenge completed
/// Sent to the fisherman when the reward is dispensed: (reward)
#define COMSIG_FISH_SOURCE_REWARD_DISPENSED "fish_source_reward_dispensed"

/// Sent by the target of the fishing rod cast
#define COMSIG_FISHING_ROD_CAST "fishing_rod_cast"
	#define FISHING_ROD_CAST_HANDLED (1 << 0)

/// From /datum/fish_source/proc/dispense_reward(), not set if the reward is a dud: (reward, user)
#define COMSIG_FISHING_ROD_CAUGHT_FISH "fishing_rod_caught_fish"
/// From /obj/item/fishing_rod/proc/hook_item(): (reward, user)
#define COMSIG_FISHING_ROD_HOOKED_ITEM "fishing_rod_hooked_item"

/// From /obj/item/fishing_rod/set_slot: (obj/item/fishing_rod/rod, slot)
#define COMSIG_ITEM_FISHING_ROD_SLOTTED "item_fishing_rod_slotted"
/// From /obj/item/fishing_rod/Exited: (obj/item/fishing_rod/rod, slot)
#define COMSIG_ITEM_FISHING_ROD_UNSLOTTED "item_fishing_rod_unslotted"

/// Sent when the challenge is to be interrupted: (reason)
#define COMSIG_FISHING_SOURCE_INTERRUPT_CHALLENGE "fishing_spot_interrupt_challenge"

