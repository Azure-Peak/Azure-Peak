/datum/quest/kill/recovery/towner/missing_runner
	quest_type = QUEST_TOWNER_MISSING_RUNNER
	parcel_label = "recovered contraband"
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
		/datum/advclass/innkeeper,
		/datum/advclass/tapster,
		/datum/advclass/trader/brewer,
		/datum/advclass/trader/harlequin,
		/datum/advclass/jester,
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
	bundle_pools = list(
		"spirits" = list(
			/obj/item/reagent_containers/glass/bottle/rogue/beer/jagdtrunk,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/avarmead,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/gronnmead,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/fireleaf,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/nocshine,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/voddena,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/zagul,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/blackgoat,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/hagwoodbitter,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/butterhairs,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/stonebeardreserve,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/nred,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/apfelweinheim,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/rtoper,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/limoncello,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/avarrice,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunsake,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunplum,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunshochu,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/baijiu,
			/obj/item/reagent_containers/glass/bottle/rogue/beer/murkwine,
			/obj/item/reagent_containers/glass/bottle/rogue/wine,
			/obj/item/reagent_containers/glass/bottle/rogue/wine/sourwine,
			/obj/item/reagent_containers/glass/bottle/rogue/redwine,
			/obj/item/reagent_containers/glass/bottle/rogue/whitewine,
			/obj/item/reagent_containers/glass/bottle/rogue/spicedwine,
		),
		"fine_spirits" = list(
			/obj/item/reagent_containers/glass/bottle/rogue/elfred,
			/obj/item/reagent_containers/glass/bottle/rogue/elfblue,
			/obj/item/reagent_containers/glass/bottle/rogue/spicedwineaged,
			/obj/item/reagent_containers/glass/bottle/rogue/spicedwinedelectable,
		),
	)
	varieties = list(
		"drugs" = list(
			"label" = "Medicines",
			"blurb" = "A collection of mind and body altering substances.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/reagent_containers/powder/moondust, "min" = 1, "max" = 2, "noun" = "moondust"),
					list("path" = /obj/item/reagent_containers/powder/ozium, "min" = 3, "max" = 5, "noun" = "ozium"),
					list("path" = /obj/item/reagent_containers/powder/spice, "min" = 2, "max" = 4, "noun" = "spice"),
					list("path" = /obj/item/reagent_containers/powder/starsugar, "min" = 2, "max" = 4, "noun" = "starsugar"),
					list("path" = /obj/item/reagent_containers/powder/herozium, "min" = 1, "max" = 2, "noun" = "herozium"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/reagent_containers/powder/moondust_purest, "min" = 3, "max" = 5, "noun" = "pure moondust"),
					list("path" = /obj/item/reagent_containers/powder/ozium, "min" = 5, "max" = 7, "noun" = "ozium"),
					list("path" = /obj/item/reagent_containers/powder/spice, "min" = 4, "max" = 6, "noun" = "spice"),
					list("path" = /obj/item/reagent_containers/powder/starsugar, "min" = 4, "max" = 6, "noun" = "starsugar"),
					list("path" = /obj/item/reagent_containers/powder/herozium, "min" = 3, "max" = 5, "noun" = "herozium"),
				),
			),
		),
		"booze" = list(
			"label" = "Spirits",
			"blurb" = "A selection of potent spirits and brews.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("pool" = "spirits", "min" = 8, "max" = 16, "noun" = "assorted bottles"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("pool" = "spirits", "min" = 12, "max" = 20, "noun" = "assorted bottles"),
					list("pool" = "fine_spirits", "min" = 1, "max" = 2, "noun" = "fine vintages"),
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
	return "Run down the thieves and carry the package back to [quest_giver_name || "the client"] or put it into the nearest HERMES."

/datum/quest/kill/recovery/towner/missing_runner/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The client"]'s runner was taken by [raiders] on the road within [region]. They call for hands to get their goods back."

/datum/quest/kill/recovery/towner/missing_runner/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."
