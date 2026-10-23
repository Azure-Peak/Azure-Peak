/datum/quest/kill/recovery/towner/building_supplies
	quest_type = QUEST_TOWNER_BUILDING_SUPPLIES
	parcel_label = "recovered building supplies"
	posting_label = "A Stash of Building Supplies"
	posting_blurb = "A stash of building supplies has been discovered in a dangerous area. Hire hands to secure the site and recover the materials."
	postable_advclasses = list(
		/datum/advclass/guildmaster,
		/datum/advclass/guildsman/architect,
		/datum/advclass/woodworker,
		/datum/advclass/homesteader,
		/datum/advclass/elder,
	)
	eligible_regions = list(
		THREAT_REGION_MOUNT_DECAP,
		THREAT_REGION_AZUREAN_COAST,
	)
	eligible_factions = list(
		QUEST_FACTION_TARICHEA_DEADITE,
		QUEST_FACTION_MADMAN,
		QUEST_FACTION_MOUNTAIN_TROLL,
	)
	varieties = list(
		"building supplies" = list(
			"label" = "Building Supplies",
			"blurb" = "A supply of materials for constructing dwellings.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/grown/log/tree/small, "min" = 12, "max" = 16, "noun" = "wood"),
					list("path" = /obj/item/natural/wood/plank, "min" = 10, "max" = 12, "noun" = "planks"),
					list("path" = /obj/item/natural/stone, "min" = 16, "max" = 20, "noun" = "stone"),
					list("path" = /obj/item/natural/stoneblock, "min" = 10, "max" = 12, "noun" = "stone blocks"),
					list("path" = /obj/item/ingot/iron, "min" = 2, "max" = 4, "noun" = "iron ingots"),
					list("path" = /obj/item/rogueore/coal, "min" = 2, "max" = 4, "noun" = "coal"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/grown/log/tree/small, "min" = 20, "max" = 24, "noun" = "wood"),
					list("path" = /obj/item/natural/wood/plank, "min" = 20, "max" = 24, "noun" = "planks"),
					list("path" = /obj/item/natural/stone, "min" = 30, "max" = 35, "noun" = "stone"),
					list("path" = /obj/item/natural/stoneblock, "min" = 20, "max" = 24, "noun" = "stone blocks"),
					list("path" = /obj/item/construction/nail, "min" = 6, "max" = 10, "noun" = "nails"),
					list("path" = /obj/item/ingot/iron, "min" = 4, "max" = 8, "noun" = "iron ingots"),
					list("path" = /obj/item/rogueore/coal, "min" = 4, "max" = 8, "noun" = "coal"),
				),
			),
		),
	)

/datum/quest/kill/recovery/towner/building_supplies/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Supplies"
	return "A Stash of Building Supplies"

/datum/quest/kill/recovery/towner/building_supplies/get_objective_text()
	return "Secure the site and carry the package back to [quest_giver_name || "the builder"] or put it into the nearest HERMES."

/datum/quest/kill/recovery/towner/building_supplies/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "beasts"
	return "[quest_giver_name || "The builder"]'s caravan was raided by [raiders] on the road within [region]. They call for hands to get their materials back."

/datum/quest/kill/recovery/towner/building_supplies/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."
