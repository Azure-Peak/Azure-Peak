/datum/quest/kill/recovery/towner/cheesemaker_caravan
	quest_type = QUEST_TOWNER_CHEESEMAKER_CARAVAN
	parcel_label = "recovered cheesemaking supplies"
	posting_label = "A Cheesemaker's Caravan"
	posting_blurb = "Beasts have hounded a cheesemaker's caravan. Hire hands to secure the caravan and bring them home."
	postable_advclasses = list(
		/datum/advclass/cheesemaker,
		/datum/advclass/cook,
		/datum/advclass/masterchef,
		/datum/advclass/innkeeper,
	)
	eligible_regions = list(
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_AZUREAN_COAST,
	)
	eligible_factions = list(
		QUEST_FACTION_GREAT_BEAST,
		QUEST_FACTION_WILD_BEAST,
		QUEST_FACTION_MINOTAUR,
	)
	varieties = list(
		"cheesemaker" = list(
			"label" = "Cheesemaking Supplies",
			"blurb" = "A supply of butter and milk for making cheese.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/reagent_containers/powder/salt, "min" = 12, "max" = 16, "noun" = "salt"),
					list("path" = /obj/item/reagent_containers/glass/bottle/waterskin/milk, "min" = 3, "max" = 5, "noun" = "skins of milk"),
					list("path" = /obj/item/reagent_containers/food/snacks/butter, "min" = 3, "max" = 5, "noun" = "butter"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/reagent_containers/powder/salt, "min" = 20, "max" = 24, "noun" = "salt"),
					list("path" = /obj/item/reagent_containers/glass/bottle/waterskin/milk, "min" = 5, "max" = 8, "noun" = "skins of milk"),
					list("path" = /obj/item/reagent_containers/food/snacks/butter, "min" = 5, "max" = 8, "noun" = "butter"),
					list("path" = /obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesewheel, "min" = 1, "max" = 2, "noun" = "cheese wheels"),
				),
			),
		),
	)

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Caravan"
	return "A Caravan Missing"

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_objective_text()
	return "Clear the wreck and carry the package back to [quest_giver_name || "the cheesemaker"] or put it into the nearest HERMES."

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "beasts"
	return "[quest_giver_name || "The cheesemaker"]'s caravan was swarmed by [raiders] on the road within [region]. They call for hands to get their supplies back."

/datum/quest/kill/recovery/towner/cheesemaker_caravan/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."
