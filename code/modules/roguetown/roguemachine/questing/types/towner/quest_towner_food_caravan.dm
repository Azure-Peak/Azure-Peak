GLOBAL_LIST_INIT(towner_food_caravan_regions, list(
	THREAT_REGION_AZURE_GROVE,
	THREAT_REGION_TERRORBOG,
))

GLOBAL_LIST_INIT(towner_food_caravan_factions, list(
	QUEST_FACTION_HIGHWAYMAN,
	QUEST_FACTION_BOGMAN,
	QUEST_FACTION_BOG_DEADITE,
))

GLOBAL_LIST_INIT(towner_food_caravan_varieties, list(
	CARAVAN_VARIETY_FOOD = list(
		"label" = "Raw Foodstuffs",
		"blurb" = "A stock of cooking supplies.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/reagent_containers/food/snacks/rogue/cheese, "min" = 2, "max" = 4, "noun" = "cheese"),
				list("path" = /obj/item/reagent_containers/food/snacks/rogue/honey, "min" = 2, "max" = 4, "noun" = "honey"),
				list("path" = /obj/item/reagent_containers/food/snacks/sugar, "min" = 5, "max" = 8, "noun" = "sugar"),
				list("path" = /obj/item/reagent_containers/powder/flour, "min" = 5, "max" = 8, "noun" = "flour"),
				list("path" = /obj/item/reagent_containers/food/snacks/rogue/egg, "min" = 3, "max" = 6, "noun" = "egg"),
				list("path" = /obj/item/reagent_containers/food/snacks/grown/onion/rogue, "min" = 3, "max" = 6, "noun" = "onion"),
				list("path" = /obj/item/reagent_containers/food/snacks/butter, "min" = 3, "max" = 6, "noun" = "butter"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/reagent_containers/food/snacks/rogue/cheese, "min" = 5, "max" = 8, "noun" = "cheese"),
				list("path" = /obj/item/reagent_containers/food/snacks/rogue/honey, "min" = 5, "max" = 8, "noun" = "honey"),
				list("path" = /obj/item/reagent_containers/food/snacks/sugar, "min" = 8, "max" = 10, "noun" = "sugar"),
				list("path" = /obj/item/reagent_containers/powder/flour, "min" = 8, "max" = 10, "noun" = "flour"),
				list("path" = /obj/item/reagent_containers/food/snacks/rogue/egg, "min" = 5, "max" = 8, "noun" = "egg"),
				list("path" = /obj/item/reagent_containers/food/snacks/grown/onion/rogue, "min" = 5, "max" = 8, "noun" = "onion"),
				list("path" = /obj/item/reagent_containers/food/snacks/butter, "min" = 5, "max" = 8, "noun" = "butter"),
				list("path" = /obj/item/reagent_containers/food/snacks/chocolate, "min" = 4, "max" = 7, "noun" = "chocolate"),
			),
		),
	),
	CARAVAN_VARIETY_SEEDS_FRUIT = list(
		"label" = "Fruit Seeds",
		"blurb" = "A selection of fruit seeds for planting.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/seeds/raspberry, "min" = 0, "max" = 2, "noun" = "raspberry seeds"),
				list("path" = /obj/item/seeds/blackberry, "min" = 0, "max" = 2, "noun" = "blackberry seeds"),
				list("path" = /obj/item/seeds/strawberry, "min" = 0, "max" = 2, "noun" = "strawberry seeds"),
				list("path" = /obj/item/seeds/lemon, "min" = 0, "max" = 2, "noun" = "lemon seeds"),
				list("path" = /obj/item/seeds/lime, "min" = 0, "max" = 2, "noun" = "lime seeds"),
				list("path" = /obj/item/seeds/tangerine, "min" = 0, "max" = 2, "noun" = "tangerine seeds"),
				list("path" = /obj/item/seeds/plum, "min" = 0, "max" = 2, "noun" = "plum seeds"),
				list("path" = /obj/item/seeds/pumpkin, "min" = 0, "max" = 2, "noun" = "pumpkin seeds"),
				list("path" = /obj/item/seeds/apple, "min" = 0, "max" = 2, "noun" = "apple seeds"),
				list("path" = /obj/item/seeds/tomato, "min" = 0, "max" = 2, "noun" = "tomato seeds"),
				list("path" = /obj/item/seeds/berryrogue, "min" = 0, "max" = 2, "noun" = "jackberry seeds"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/seeds/raspberry, "min" = 1, "max" = 3, "noun" = "raspberry seeds"),
				list("path" = /obj/item/seeds/blackberry, "min" = 1, "max" = 3, "noun" = "blackberry seeds"),
				list("path" = /obj/item/seeds/strawberry, "min" = 1, "max" = 3, "noun" = "strawberry seeds"),
				list("path" = /obj/item/seeds/lemon, "min" = 1, "max" = 3, "noun" = "lemon seeds"),
				list("path" = /obj/item/seeds/lime, "min" = 1, "max" = 3, "noun" = "lime seeds"),
				list("path" = /obj/item/seeds/tangerine, "min" = 1, "max" = 3, "noun" = "tangerine seeds"),
				list("path" = /obj/item/seeds/plum, "min" = 1, "max" = 3, "noun" = "plum seeds"),
				list("path" = /obj/item/seeds/pumpkin, "min" = 1, "max" = 3, "noun" = "pumpkin seeds"),
				list("path" = /obj/item/seeds/apple, "min" = 1, "max" = 3, "noun" = "apple seeds"),
				list("path" = /obj/item/seeds/tomato, "min" = 1, "max" = 3, "noun" = "tomato seeds"),
				list("path" = /obj/item/seeds/berryrogue, "min" = 1, "max" = 3, "noun" = "jackberry seeds"),
			),
		),
	),
	CARAVAN_VARIETY_SEEDS_VEGETABLE = list(
		"label" = "Vegetable Seeds",
		"blurb" = "A selection of vegetable seeds for planting.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/seeds/cucumber, "min" = 0, "max" = 2, "noun" = "cucumber seeds"),
				list("path" = /obj/item/seeds/coffee, "min" = 0, "max" = 2, "noun" = "coffee seeds"),
				list("path" = /obj/item/seeds/tea, "min" = 0, "max" = 2, "noun" = "tea seeds"),
				list("path" = /obj/item/seeds/nut, "min" = 0, "max" = 2, "noun" = "nut seeds"),
				list("path" = /obj/item/seeds/garlick, "min" = 0, "max" = 2, "noun" = "garlick seeds"),
				list("path" = /obj/item/seeds/potato, "min" = 0, "max" = 2, "noun" = "potato seeds"),
				list("path" = /obj/item/seeds/cabbage, "min" = 0, "max" = 2, "noun" = "cabbage seeds"),
				list("path" = /obj/item/seeds/turnip, "min" = 0, "max" = 2, "noun" = "turnip seeds"),
				list("path" = /obj/item/seeds/lentils, "min" = 0, "max" = 2, "noun" = "lentil seeds"),
				list("path" = /obj/item/seeds/beans, "min" = 0, "max" = 2, "noun" = "bean seeds"),
				list("path" = /obj/item/seeds/carrot, "min" = 0, "max" = 2, "noun" = "carrot seeds"),
				list("path" = /obj/item/seeds/eggplant, "min" = 0, "max" = 2, "noun" = "eggplant seeds"),
				list("path" = /obj/item/seeds/wheat, "min" = 0, "max" = 2, "noun" = "wheat seeds"),
				list("path" = /obj/item/seeds/wheat/oat, "min" = 0, "max" = 2, "noun" = "oat seeds"),
				list("path" = /obj/item/seeds/rice, "min" = 0, "max" = 2, "noun" = "rice seeds"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/seeds/cucumber, "min" = 1, "max" = 3, "noun" = "cucumber seeds"),
				list("path" = /obj/item/seeds/coffee, "min" = 1, "max" = 3, "noun" = "coffee seeds"),
				list("path" = /obj/item/seeds/tea, "min" = 1, "max" = 3, "noun" = "tea seeds"),
				list("path" = /obj/item/seeds/nut, "min" = 1, "max" = 3, "noun" = "nut seeds"),
				list("path" = /obj/item/seeds/garlick, "min" = 1, "max" = 3, "noun" = "garlick seeds"),
				list("path" = /obj/item/seeds/potato, "min" = 1, "max" = 3, "noun" = "potato seeds"),
				list("path" = /obj/item/seeds/cabbage, "min" = 1, "max" = 3, "noun" = "cabbage seeds"),
				list("path" = /obj/item/seeds/turnip, "min" = 1, "max" = 3, "noun" = "turnip seeds"),
				list("path" = /obj/item/seeds/lentils, "min" = 1, "max" = 3, "noun" = "lentil seeds"),
				list("path" = /obj/item/seeds/beans, "min" = 1, "max" = 3, "noun" = "bean seeds"),
				list("path" = /obj/item/seeds/carrot, "min" = 1, "max" = 3, "noun" = "carrot seeds"),
				list("path" = /obj/item/seeds/eggplant, "min" = 1, "max" = 3, "noun" = "eggplant seeds"),
				list("path" = /obj/item/seeds/wheat, "min" = 1, "max" = 3, "noun" = "wheat seeds"),
				list("path" = /obj/item/seeds/wheat/oat, "min" = 1, "max" = 3, "noun" = "oat seeds"),
				list("path" = /obj/item/seeds/rice, "min" = 1, "max" = 3, "noun" = "rice seeds"),
			),
		),
	),
))

/*
GLOBAL_LIST_INIT(towner_caravan_tier_tp, list(
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_CARAVAN_TP_BUDGET_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_CARAVAN_TP_BUDGET_HARD,
))
*/

/datum/quest/kill/recovery/towner/food_caravan
	quest_type = QUEST_TOWNER_FOOD_CARAVAN
	parcel_label = "recovered farm supplies"

/datum/quest/kill/recovery/towner/food_caravan/get_eligible_regions()
	return GLOB.towner_food_caravan_regions

/datum/quest/kill/recovery/towner/food_caravan/get_varieties()
	return GLOB.towner_food_caravan_varieties

/datum/quest/kill/recovery/towner/food_caravan/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/food_caravan/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Caravan"
	return "A Caravan Missing"

/datum/quest/kill/recovery/towner/food_caravan/get_objective_text()
	return "Clear the wreck and carry the strongbox back to [quest_giver_name || "the client"]."

/datum/quest/kill/recovery/towner/food_caravan/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The client"]'s caravan was taken by [raiders] on the road within [region]. They call for hands to get their materials back."

/datum/quest/kill/recovery/towner/food_caravan/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."

/datum/quest/kill/recovery/towner/food_caravan/pick_region_faction_for(datum/threat_region/TR)
	var/list/weights = list()
	for(var/id in TR.faction_weights)
		if(!(id in GLOB.towner_missing_runner_factions))
			continue
		var/datum/quest_faction/F = get_quest_faction(id)
		if(!F)
			continue
		weights[id] = TR.faction_weights[id]
	if(!length(weights))
		return null
	var/picked_id = pickweight(weights)
	return get_quest_faction(picked_id)

/datum/quest/kill/recovery/towner/food_caravan/build_bundle()
	var/list/meta = GLOB.towner_food_caravan_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
