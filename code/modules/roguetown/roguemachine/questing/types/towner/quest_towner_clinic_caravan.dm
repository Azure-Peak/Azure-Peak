GLOBAL_LIST_INIT(towner_clinic_caravan_regions, list(
	THREAT_REGION_MOUNT_DECAP,
	THREAT_REGION_AZUREAN_COAST,
))

GLOBAL_LIST_INIT(towner_clinic_caravan_factions, list(
	QUEST_FACTION_HIGHWAYMAN,
	QUEST_FACTION_MOUNT_REAVER,
	QUEST_FACTION_BLEAKISLE_REAVER,
))

GLOBAL_LIST_INIT(towner_clinic_caravan_varieties, list(
	CARAVAN_VARIETY_POTIONS = list(
		"label" = "Medical Supplies",
		"blurb" = "A collection of medical supplies and potions.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/healthpot, "min" = 3, "max" = 5, "noun" = "healing"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/healthpotnew, "min" = 2, "max" = 4, "noun" = "strong healing"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/manapot, "min" = 3, "max" = 5, "noun" = "mana"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/stampot, "min" = 2, "max" = 4, "noun" = "stamina"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/antidote, "min" = 2, "max" = 4, "noun" = "antidote"),
				list("path" = /obj/item/natural/bundle/cloth/bandage/full, "min" = 3, "max" = 6, "noun" = "bandages"),
				list("path" = /obj/item/storage/belt/rogue/surgery_bag/full, "min" = 1, "max" = 1, "noun" = "surgery bag"),
				list("path" = /obj/item/reagent_containers/lux_impure, "min" = 1, "max" = 1, "noun" = "impure lux"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/healthpotnew, "min" = 5, "max" = 8, "noun" = "strong healing"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/strongmanapot, "min" = 3, "max" = 5, "noun" = "strong mana"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/strongstampot, "min" = 2, "max" = 4, "noun" = "strong stamina"),
				list("path" = /obj/item/reagent_containers/glass/bottle/rogue/strong_antidote, "min" = 2, "max" = 4, "noun" = "strong antidote"),
				list("path" = /obj/item/natural/bundle/cloth/bandage/full, "min" = 3, "max" = 6, "noun" = "bandages"),
				list("path" = /obj/item/storage/belt/rogue/surgery_bag/full, "min" = 1, "max" = 1, "noun" = "surgery bag"),
				list("path" = /obj/item/reagent_containers/glass/bottle/alchemical/strpot, "min" = 0, "max" = 2, "noun" = "strength"),
				list("path" = /obj/item/reagent_containers/glass/bottle/alchemical/perpot, "min" = 0, "max" = 2, "noun" = "perception"),
				list("path" = /obj/item/reagent_containers/glass/bottle/alchemical/willpot, "min" = 0, "max" = 2, "noun" = "willpower"),
				list("path" = /obj/item/reagent_containers/glass/bottle/alchemical/conpot, "min" = 0, "max" = 2, "noun" = "constitution"),
				list("path" = /obj/item/reagent_containers/glass/bottle/alchemical/intpot, "min" = 0, "max" = 2, "noun" = "intelligence"),
				list("path" = /obj/item/reagent_containers/glass/bottle/alchemical/spdpot, "min" = 0, "max" = 2, "noun" = "speed"),
				list("path" = /obj/item/reagent_containers/glass/bottle/alchemical/lucpot, "min" = 0, "max" = 2, "noun" = "fortune"),
				list("path" = /obj/item/reagent_containers/lux_impure, "min" = 1, "max" = 3, "noun" = "impure lux"),
				list("path" = /datum/crafting_recipe/roguetown/alchemy/frankenbrew, "min" = 2, "max" = 2, "noun" = "reanimation elixir"),
			),
		),
	),
	CARAVAN_VARIETY_INGREDIENTS = list(
		"label" = "Ingredients",
		"blurb" = "Rare and exotic ingredients for alchemical concoctions.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/alch/calendula, "min" = 5, "max" = 8, "noun" = "calendula"),
				list("path" = /obj/item/alch/hypericum, "min" = 4, "max" = 6, "noun" = "hypericum"),
				list("path" = /obj/item/alch/viscera, "min" = 5, "max" = 8, "noun" = "viscera"),
				list("path" = /obj/item/alch/waterdust, "min" = 4, "max" = 6, "noun" = "water essentia"),
				list("path" = /obj/item/alch/puresalt, "min" = 4, "max" = 6, "noun" = "purified salt"),
				list("path" = /obj/item/alch/berrypowder, "min" = 4, "max" = 6, "noun" = "berry powder"),
				list("path" = /obj/item/alch/ozium, "min" = 3, "max" = 5, "noun" = "alchemical ozium"),
				list("path" = /obj/item/alch/sinew, "min" = 3, "max" = 5, "noun" = "sinew"),
				list("path" = /obj/item/alch/bone, "min" = 3, "max" = 5, "noun" = "tail bone"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/alch/calendula, "min" = 5, "max" = 8, "noun" = "calendula"),
				list("path" = /obj/item/alch/hypericum, "min" = 4, "max" = 6, "noun" = "hypericum"),
				list("path" = /obj/item/alch/viscera, "min" = 5, "max" = 8, "noun" = "viscera"),
				list("path" = /obj/item/alch/waterdust, "min" = 4, "max" = 6, "noun" = "water essentia"),
				list("path" = /obj/item/alch/puresalt, "min" = 4, "max" = 6, "noun" = "purified salt"),
				list("path" = /obj/item/alch/berrypowder, "min" = 4, "max" = 6, "noun" = "berry powder"),
				list("path" = /obj/item/alch/ozium, "min" = 3, "max" = 5, "noun" = "alchemical ozium"),
				list("path" = /obj/item/alch/sinew, "min" = 3, "max" = 5, "noun" = "sinew"),
				list("path" = /obj/item/alch/bone, "min" = 3, "max" = 5, "noun" = "tail bone"),
				list("path" = /obj/item/alch/irondust, "min" = 4, "max" = 6, "noun" = "iron dust"),
				list("path" = /obj/item/alch/horn, "min" = 3, "max" = 5, "noun" = "troll horn"),
				list("path" = /obj/item/alch/golddust, "min" = 4, "max" = 6, "noun" = "gold dust"),
				list("path" = /obj/item/alch/silverdust, "min" = 4, "max" = 6, "noun" = "silver dust"),
				list("path" = /obj/item/alch/coaldust, "min" = 4, "max" = 6, "noun" = "coal dust"),
				list("path" = /obj/item/alch/firedust, "min" = 4, "max" = 6, "noun" = "fire essentia"),
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

/datum/quest/kill/recovery/towner/clinic_caravan
	quest_type = QUEST_TOWNER_CLINIC_CARAVAN
	parcel_label = "recovered medical supplies"

/datum/quest/kill/recovery/towner/clinic_caravan/get_eligible_regions()
	return GLOB.towner_clinic_caravan_regions

/datum/quest/kill/recovery/towner/clinic_caravan/get_varieties()
	return GLOB.towner_clinic_caravan_varieties

/datum/quest/kill/recovery/towner/clinic_caravan/get_tier_tp_budget()
	return GLOB.towner_caravan_tier_tp[posting_tier] || TOWNER_CARAVAN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/clinic_caravan/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Caravan"
	return "A Caravan Gone Missing"

/datum/quest/kill/recovery/towner/clinic_caravan/get_objective_text()
	return "Clear the wreck and carry the strongbox back to [quest_giver_name || "the medic"]."

/datum/quest/kill/recovery/towner/clinic_caravan/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The medic"]'s wagon was taken by [raiders] on the road within [region]. They call for hands to clear the wreck and bring the strongbox home."

/datum/quest/kill/recovery/towner/clinic_caravan/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."

/datum/quest/kill/recovery/towner/clinic_caravan/pick_region_faction_for(datum/threat_region/TR)
	var/list/weights = list()
	for(var/id in TR.faction_weights)
		if(!(id in GLOB.towner_clinic_caravan_factions))
			continue
		var/datum/quest_faction/F = get_quest_faction(id)
		if(!F)
			continue
		weights[id] = TR.faction_weights[id]
	if(!length(weights))
		return null
	var/picked_id = pickweight(weights)
	return get_quest_faction(picked_id)

/datum/quest/kill/recovery/towner/clinic_caravan/build_bundle()
	var/list/meta = GLOB.towner_clinic_caravan_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
