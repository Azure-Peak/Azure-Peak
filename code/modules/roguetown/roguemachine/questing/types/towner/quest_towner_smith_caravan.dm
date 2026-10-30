/datum/quest/kill/recovery/towner/smith_caravan
	quest_type = QUEST_TOWNER_SMITH_CARAVAN
	parcel_label = "recovered ingots"
	posting_label = "A Caravan Gone Missing"
	posting_blurb = "A wagon of yours was lost on the road. Hire hands to secure the wreck and bring the strongbox home."
	postable_advclasses = list(
		/datum/advclass/blacksmith,
		/datum/advclass/guildsman/blacksmith,
		/datum/advclass/guildsman/artificer,
		/datum/advclass/guildmaster,
		/datum/advclass/masterblacksmith,
		/datum/advclass/trader/jeweler,
		/datum/advclass/heartfelt/retinue/armorer,
	)
	eligible_regions = list(
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_AZUREAN_COAST,
	)
	eligible_factions = list(
		QUEST_FACTION_HIGHWAYMAN,
		QUEST_FACTION_MOUNT_REAVER,
		QUEST_FACTION_BLEAKISLE_REAVER,
	)
	varieties = list(
		"iron" = list(
			"label" = "Iron & Steel",
			"blurb" = "Iron and steel ingots.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/ingot/iron, "min" = 11, "max" = 15, "noun" = "iron"),
					list("path" = /obj/item/ingot/steel, "min" = 5, "max" = 8, "noun" = "steel"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/ingot/iron, "min" = 18, "max" = 24, "noun" = "iron"),
					list("path" = /obj/item/ingot/steel, "min" = 10, "max" = 14, "noun" = "steel"),
				),
			),
		),
		"bronze" = list(
			"label" = "Bronze",
			"blurb" = "Cast bronze ingots.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/ingot/bronze, "min" = 8, "max" = 10, "noun" = "bronze"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/ingot/bronze, "min" = 14, "max" = 16, "noun" = "bronze"),
				),
			),
		),
		"bullion" = list(
			"label" = "Bullion",
			"blurb" = "A strongbox of gold bullion.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/ingot/gold, "min" = 3, "max" = 4, "noun" = "gold"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/ingot/gold, "min" = 6, "max" = 7, "noun" = "gold"),
				),
			),
		),
	)

/datum/quest/kill/recovery/towner/smith_caravan/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Caravan"
	return "A Caravan Gone Missing"

/datum/quest/kill/recovery/towner/smith_caravan/get_objective_text()
	return "Clear the wreck and carry the package back to [quest_giver_name || "the smith"] or put it into the nearest HERMES."

/datum/quest/kill/recovery/towner/smith_caravan/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The smith"]'s wagon was taken by [raiders] on the road within [region]. They call for hands to clear the wreck and bring the strongbox home."

/datum/quest/kill/recovery/towner/smith_caravan/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."
