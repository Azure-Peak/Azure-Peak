#define SLOW_GROWING 6 MINUTES
#define FAST_GROWING 5 MINUTES
#define VERY_FAST_GROWING 4 MINUTES
#define HUNGRINESS_EXTREME 60 // For Tree
#define HUNGRINESS_DEMANDING 35
#define HUNGRINESS_NORMAL 25
#define HUNGRINESS_TINY 15

/datum/plant_def
	abstract_type = /datum/plant_def
	/// Name of the plant
	var/name = "Some plant"
	/// Description of the plant
	var/desc = "Sure is a plant."
	var/icon = 'icons/roguetown/misc/crops.dmi'
	var/icon_state
	/// Loot the plant will yield for uprooting it
	var/list/uproot_loot
	/// Time in ticks the plant will require to mature, before starting to make produce
	var/maturation_time = 6 MINUTES
	/// Time in ticks the plant will require to make produce
	var/produce_time = 3 MINUTES
	/// Typepath of produce to make on harvest
	var/produce_type
	/// Amount of minimum produce to make on harvest
	var/produce_amount_min = 2
	/// Amount of maximum produce to make on harvest
	var/produce_amount_max = 3
	/// How much nutrition will the plant require to mature fully
	var/maturation_nutrition = HUNGRINESS_NORMAL
	/// How much nutrition will the plant require to make produce
	var/produce_nutrition = 20
	/// If not perennial, the plant will uproot itself upon harvesting first produce
	var/perennial = FALSE
	/// Whether the plant is immune to weeds and will naturally deal with them
	var/weed_immune = FALSE
	/// The rate at which the plant drains water, if zero then it'll be able to live without water
	var/water_drain_rate = 2 / (1 MINUTES)
	/// Color all seeds of this plant def will have, randomised on init
	var/seed_color
	/// Whether the plant can grow underground
	var/can_grow_underground = FALSE

/datum/plant_def/New()
	. = ..()
	var/static/list/random_colors = list("#fffbf7", "#f3c877", "#5e533e", "#db7f62", "#f39945")
	seed_color = pick(random_colors)

//................ Quick-growing plants ...............................
/datum/plant_def/cabbage
	name = "cabbages"
	icon_state = "cabbage"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	produce_amount_min = 3
	produce_amount_max = 4
	maturation_time = FAST_GROWING

/datum/plant_def/carrot
	name = "carrot patch"
	icon_state = "carrot"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/carrot
	produce_amount_min = 3
	produce_amount_max = 4
	maturation_time = FAST_GROWING

/datum/plant_def/onion
	name = "onion patch"
	icon_state = "onion"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/onion/rogue
	produce_amount_min = 3
	produce_amount_max = 4
	maturation_time = FAST_GROWING

/datum/plant_def/wheat
	name = "wheat stalks"
	icon_state = "wheat"
	produce_type = /obj/item/natural/chaff/wheat
	produce_amount_min = 3
	produce_amount_max = 5
	uproot_loot = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	maturation_time = FAST_GROWING
	produce_time = 2 MINUTES

/datum/plant_def/oat
	name = "oat stalks"
	icon_state = "oat"
	produce_type = /obj/item/natural/chaff/oat
	produce_amount_min = 3
	produce_amount_max = 5
	uproot_loot = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	maturation_time = FAST_GROWING
	produce_time = 2 MINUTES

// Rice are faster growing but drain way more water
/datum/plant_def/rice
	name = "rice stalks"
	icon_state = "rice"
	produce_type = /obj/item/natural/chaff/rice
	produce_amount_min = 3
	produce_amount_max = 5
	uproot_loot = list(/obj/item/natural/fibers, /obj/item/natural/fibers)
	maturation_time = VERY_FAST_GROWING
	produce_time = 2 MINUTES
	water_drain_rate = 4 / (1 MINUTES)

/datum/plant_def/pipeweed
	name = "westleach plant"
	icon_state = "westleach"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed
	produce_amount_min = 3
	produce_amount_max = 5
	maturation_time = FAST_GROWING
	produce_time = 2 MINUTES

//................ Perennial Trees ............................... (No replanting needed)
// Long growth time, fast-ish produce time. High initial nutrition cost.
/datum/plant_def/tree
	name = "Testing Plant Do Not Use"
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 4
	uproot_loot = list(/obj/item/grown/log/tree/small)
	maturation_nutrition = HUNGRINESS_EXTREME
	maturation_time = SLOW_GROWING
	produce_time = 3 MINUTES

/datum/plant_def/tree/apple
	name = "apple tree"
	icon_state = "apple"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/apple

/datum/plant_def/tree/pear
	name = "pear tree"
	icon_state = "pear"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/pear

/datum/plant_def/tree/plum
	name = "plum tree"
	icon_state = "plum"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/plum

/datum/plant_def/tree/tangerine
	name = "tangerine tree"
	icon_state = "tangerine"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine

/datum/plant_def/tree/lime
	name = "lime tree"
	icon_state = "lime"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/lime

/datum/plant_def/tree/lemon
	name = "lemon tree"
	icon_state = "lemon"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/lemon

//................ Perennial Bushes ............................... (No replanting needed)
// Medium growth time, fast-ish produce time. Moderate Initial Nutrition Cost. Less Harvest. Stick

/datum/plant_def/bush/
	name = "Testing Bush Do Not Use"
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 3
	uproot_loot = list(/obj/item/grown/log/tree/stick)
	maturation_nutrition = HUNGRINESS_EXTREME
	produce_nutrition = HUNGRINESS_NORMAL
	maturation_time = FAST_GROWING

/datum/plant_def/bush/berry
	name = "jackberry bush"
	icon_state = "berry"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/berries/rogue

/datum/plant_def/bush/berry_poison
	name = "jackberry bush"
	icon_state = "berry"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison

/datum/plant_def/bush/strawberry
	name = "strawberry bush"
	icon_state = "strawberry"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry

/datum/plant_def/bush/blackberry
	name = "blackberry bush"
	icon_state = "blackberry"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry

/datum/plant_def/bush/raspberry
	name = "raspberry bush"
	icon_state = "raspberry"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry

/datum/plant_def/bush/tomato
	name = "tomato vines"
	icon_state = "tomato"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/fruit/tomato

/datum/plant_def/bush/eggplant
	name = "eggplant vines"
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "eggplant"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/eggplant
	produce_amount_min = 2
	produce_amount_max = 4

/datum/plant_def/sugarcane
	name = "sugarcane"
	icon_state = "sugarcane"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/sugarcane
	perennial = TRUE
	produce_amount_min = 2
	produce_amount_max = 4

//................ Nutrition-efficient plants ...............................
/datum/plant_def/potato
	name = "potato plant"
	icon_state = "potato"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/potato/rogue
	produce_amount_min = 3
	produce_amount_max = 5
	maturation_nutrition = HUNGRINESS_TINY
	water_drain_rate = 1 / (1 MINUTES)

/datum/plant_def/turnip
	name = "turnip patch"
	icon_state = "turnip"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/vegetable/turnip
	produce_amount_min = 4
	produce_amount_max = 6
	maturation_nutrition = HUNGRINESS_TINY
	maturation_time = FAST_GROWING
	water_drain_rate = 1 / (1 MINUTES)

//................ Water-efficient plants ...............................
/datum/plant_def/swampweed
	name = "swampweed plant"
	icon_state = "swampweed"
	produce_amount_min = 3
	produce_amount_max = 5
	produce_type = /obj/item/reagent_containers/food/snacks/grown/rogue/swampweed
	water_drain_rate = 0

//................ Flowers ...............................
/datum/plant_def/sunflower
	name = "sunflowers"
	icon_state = "sunflower"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/sunflower
	produce_amount_min = 3
	produce_amount_max = 4
	maturation_nutrition = HUNGRINESS_TINY
	maturation_time = VERY_FAST_GROWING
	water_drain_rate = 1 / (2 MINUTES)

/datum/plant_def/fyritiusflower
	name = "fyritius flowers"
	icon_state = "fyritius"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius
	produce_amount_min = 1
	produce_amount_max = 3 // Let's keep the production rate low because it is an anti-antag item
	maturation_time = FAST_GROWING

/datum/plant_def/manabloom
	name = "manabloom"
	icon_state = "manabloom"
	produce_amount_min = 1
	produce_amount_max = 3
	produce_type = /obj/item/reagent_containers/food/snacks/grown/manabloom
	maturation_time = FAST_GROWING

// /datum/plant_def/manabloom
// 	name = "manabloom"
// 	icon_state = "manabloom"
// 	produce_type = /obj/item/reagent_containers/food/snacks/grown/manabloom
// 	produce_amount_min = 1
// 	produce_amount_max = 3
// 	maturation_time = FAST_GROWING
// 	water_drain_rate = 1 / (2 MINUTES)
// 	can_grow_underground = TRUE

/datum/plant_def/garlick
	name = "garlick sprouts"
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "onion"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	produce_amount_min = 2
	produce_amount_max = 3

/datum/plant_def/poppy
	name = "poppies"
	icon_state = "poppy"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	produce_amount_min = 1
	produce_amount_max = 2
	maturation_nutrition = 30
	water_drain_rate = 1 / (2 MINUTES)

/datum/plant_def/nut
	name = "rocknut tree"
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "nuts"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/nut
	uproot_loot = list(/obj/item/grown/log/tree/small)
	perennial = TRUE
	produce_amount_max = 3
	maturation_nutrition = 60
	produce_nutrition =  35
	maturation_time = 6 MINUTES
	produce_time = 3 MINUTES
	water_drain_rate = 1 / (2 MINUTES)

/datum/plant_def/coffee
	name = "coffee bush"
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "coffee"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/coffee
	produce_amount_min = 2
	produce_amount_max = 3


/datum/plant_def/tea
	name = "tea bush"
	icon = 'icons/roguetown/misc/crops.dmi'
	icon_state = "tea"
	produce_type = /obj/item/reagent_containers/food/snacks/grown/tea
	produce_amount_min = 2
	produce_amount_max = 3


/datum/plant_def/pumpkin
	name = "pumpkin plant"
	icon_state = "pumpkin"
	produce_type = /obj/item/natural/shellplant/pumpkin
	produce_amount_min = 2
	produce_amount_max = 4
	uproot_loot = list(/obj/item/natural/fibers = 3)
	maturation_nutrition = HUNGRINESS_DEMANDING
	maturation_time = SLOW_GROWING
	produce_time = 3 MINUTES

#undef SLOW_GROWING
#undef FAST_GROWING
#undef VERY_FAST_GROWING
#undef HUNGRINESS_EXTREME
#undef HUNGRINESS_DEMANDING
#undef HUNGRINESS_NORMAL
#undef HUNGRINESS_TINY
