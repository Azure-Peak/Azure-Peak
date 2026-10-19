/datum/quest/kill/recovery/towner/missing_runner
	quest_type = QUEST_TOWNER_MISSING_RUNNER
	parcel_label = "recovered fun supplies"
	posting_label = "A Missing Runner"
	posting_blurb = "A supply runner has gone missing. Hire hands to track them down and get back what they were carrying."
	postable_advclasses = list(
		/datum/advclass/bathworker,
		/datum/advclass/bathworker/harlot,
		/datum/advclass/bathworker/courtesan,
		/datum/advclass/bathmaster,
		/datum/advclass/thug/goon,
		/datum/advclass/thug/wiseguy,
		/datum/advclass/thug/bigman,
		/datum/advclass/minstrel,
		/datum/advclass/drunkard,
	)
	eligible_regions = list(
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_AZUREAN_COAST,
	)
	eligible_factions = list(
		QUEST_FACTION_HIGHWAYMAN,
		QUEST_FACTION_ORC,
		QUEST_FACTION_FOREST_GOBLIN,
	)
	varieties = list(
		"drugs" = list(
			"label" = "Drugs",
			"blurb" = "A collection of mind and body altering substances.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/reagent_containers/powder/moondust, "min" = 1, "max" = 2, "noun" = "moondust"),
					list("path" = /obj/item/reagent_containers/powder/ozium, "min" = 3, "max" = 5, "noun" = "ozium"),
					list("path" = /obj/item/reagent_containers/powder/spice, "min" = 2, "max" = 4, "noun" = "spice"),
					list("path" = /obj/item/reagent_containers/powder/starsugar, "min" = 2, "max" = 4, "noun" = "spice"),
					list("path" = /obj/item/reagent_containers/powder/herozium, "min" = 1, "max" = 2, "noun" = "herozium"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/reagent_containers/powder/moondust_purest, "min" = 3, "max" = 5, "noun" = "pure moondust"),
					list("path" = /obj/item/reagent_containers/powder/ozium, "min" = 5, "max" = 7, "noun" = "ozium"),
					list("path" = /obj/item/reagent_containers/powder/spice, "min" = 4, "max" = 6, "noun" = "spice"),
					list("path" = /obj/item/reagent_containers/powder/starsugar, "min" = 4, "max" = 6, "noun" = "spice"),
					list("path" = /obj/item/reagent_containers/powder/herozium, "min" = 3, "max" = 5, "noun" = "herozium"),
				),
			),
		),
		"booze" = list(
			"label" = "Booze",
			"blurb" = "A selection of potent spirits and brews.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk, "min" = 2, "max" = 4, "noun" = "schnapps"),
					list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead, "min" = 2, "max" = 4, "noun" = "mead"),
					list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/fireleaf, "min" = 2, "max" = 4, "noun" = "fireleaf"),
					list("path" = /obj/item/reagent_containers/glass/bottle/rogue/redwine, "min" = 2, "max" = 4, "noun" = "red wine"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk, "min" = 2, "max" = 5, "noun" = "schnapps"),
					list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead, "min" = 2, "max" = 5, "noun" = "mead"),
					list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/fireleaf, "min" = 2, "max" = 5, "noun" = "fireleaf"),
					list("path" = /obj/item/reagent_containers/glass/bottle/rogue/redwine, "min" = 2, "max" = 5, "noun" = "red wine"),
					list("path" = /obj/item/reagent_containers/glass/bottle/rogue/elfblue, "min" = 1, "max" = 1, "noun" = "valmora blue"),
					list("path" = /obj/item/reagent_containers/glass/bottle/rogue/beer/nocshine, "min" = 2, "max" = 5, "noun" = "nocshine"),
				),
			),
		),
	)

/datum/quest/kill/recovery/towner/missing_runner/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Runner"
	return "A Runner Gone Missing"

/datum/quest/kill/recovery/towner/missing_runner/get_objective_text()
	return "Get revenge and carry the strongbox back to [quest_giver_name || "the client"]."

/datum/quest/kill/recovery/towner/missing_runner/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The client"]'s runner was taken by [raiders] on the road within [region]. They call for hands to get their stuff back."

/datum/quest/kill/recovery/towner/missing_runner/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."
