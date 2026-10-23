/datum/quest/kill/recovery/towner/clay_deposit
	quest_type = QUEST_TOWNER_CLAY_DEPOSIT
	parcel_label = "recovered materials"
	posting_label = "Pottery Material Deposit"
	posting_blurb = "A valuable clay deposit has been discovered, alongside plentiful glass and coal. Hire hands to secure the site and recover the materials."
	postable_advclasses = list(
		/datum/advclass/potter,
		/datum/advclass/guildmaster,
		/datum/advclass/guildsman/architect,
		/datum/advclass/guildsman/artificer,
		/datum/advclass/elder,
	)
	eligible_regions = list(
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_UNDERDARK,
	)
	eligible_factions = list(
		QUEST_FACTION_HIGHWAYMAN,
		QUEST_FACTION_SEA_GOBLIN,
		QUEST_FACTION_GRONNMAN,
	)
	varieties = list(
		"clay" = list(
			"label" = "Pottery Materials",
			"blurb" = "A large deposit of clay, alongside some glass and coal.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/natural/clay, "min" = 24, "max" = 30, "noun" = "clay"),
					list("path" = /obj/item/natural/glass, "min" = 10, "max" = 14, "noun" = "glass"),
					list("path" = /obj/item/rogueore/coal, "min" = 5, "max" = 8, "noun" = "coal"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/natural/clay, "min" = 35, "max" = 45, "noun" = "clay"),
					list("path" = /obj/item/natural/glass, "min" = 20, "max" = 25, "noun" = "glass"),
					list("path" = /obj/item/rogueore/coal, "min" = 10, "max" = 15, "noun" = "coal"),
				),
			),
		),
	)

/datum/quest/kill/recovery/towner/clay_deposit/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Deposit"
	return "A Clay Deposit"

/datum/quest/kill/recovery/towner/clay_deposit/get_objective_text()
	return "Clear the digsite and carry the package back to [quest_giver_name || "the potter"] or put it into the nearest HERMES."

/datum/quest/kill/recovery/towner/clay_deposit/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The potter"]'s deposit was taken by [raiders] in [region]. They call for hands to get their materials back."

/datum/quest/kill/recovery/towner/clay_deposit/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."
