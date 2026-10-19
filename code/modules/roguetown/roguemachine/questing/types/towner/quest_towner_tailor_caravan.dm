/datum/quest/kill/recovery/towner/tailor_caravan
	quest_type = QUEST_TOWNER_TAILOR_CARAVAN
	parcel_label = "recovered materials"
	posting_label = "Stolen Tailoring Materials"
	posting_blurb = "A caravan of tailoring supplies has been lost. Hire hands to secure the caravan and bring the materials back."
	postable_advclasses = list(
		/datum/advclass/tailor,
		/datum/advclass/seamstress,
		/datum/advclass/guildmaster,
		/datum/advclass/hunter,
		/datum/advclass/hunter/spear,
		/datum/advclass/seneschal/seneschal,
		/datum/advclass/seneschal/headmaid,
		/datum/advclass/seneschal/chiefbutler,
		/datum/advclass/elder,
	)
	eligible_regions = list(
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_AZUREAN_COAST,
	)
	eligible_factions = list(
		QUEST_FACTION_HIGHWAYMAN,
		QUEST_FACTION_SEA_GOBLIN,
		QUEST_FACTION_GRONNMAN,
	)
	varieties = list(
		"leathers" = list(
			"label" = "Hides & Furs",
			"blurb" = "A supply of hides and furs for leatherworking.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/natural/hide/cured, "min" = 12, "max" = 16, "noun" = "cured hides"),
					list("path" = /obj/item/natural/fur, "min" = 11, "max" = 15, "noun" = "fur"),
					list("path" = /obj/item/reagent_containers/food/snacks/tallow, "min" = 3, "max" = 5, "noun" = "tallow"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/natural/hide/cured, "min" = 18, "max" = 24, "noun" = "cured hides"),
					list("path" = /obj/item/natural/fur, "min" = 18, "max" = 24, "noun" = "fur"),
					list("path" = /obj/item/reagent_containers/food/snacks/tallow, "min" = 6, "max" = 10, "noun" = "tallow"),
					list("path" = /obj/item/natural/fur/direbear, "min" = 1, "max" = 3, "noun" = "dire bear fur"),
				),
			),
		),
		"silks" = list(
			"label" = "Silks & Cloth",
			"blurb" = "A selection of silks and cloths for tailoring.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/natural/bundle/cloth/roll, "min" = 3, "max" = 5, "noun" = "rolls of cloth"),
					list("path" = /obj/item/natural/silk, "min" = 14, "max" = 20, "noun" = "silk"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/natural/bundle/cloth/roll, "min" = 5, "max" = 8, "noun" = "rolls of cloth"),
					list("path" = /obj/item/natural/silk, "min" = 24, "max" = 30, "noun" = "silk"),
					list("path" = /obj/item/natural/cured/essence, "min" = 3, "max" = 5, "noun" = "essence of wilderness"),
				),
			),
		),
	)

/datum/quest/kill/recovery/towner/tailor_caravan/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Caravan"
	return "A Caravan Missing"

/datum/quest/kill/recovery/towner/tailor_caravan/get_objective_text()
	return "Clear the wreck and carry the package back to [quest_giver_name || "the tailor"] or put it into the nearest HERMES."

/datum/quest/kill/recovery/towner/tailor_caravan/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The tailor"]'s caravan was taken by [raiders] on the road within [region]. They call for hands to get their materials back."

/datum/quest/kill/recovery/towner/tailor_caravan/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."
