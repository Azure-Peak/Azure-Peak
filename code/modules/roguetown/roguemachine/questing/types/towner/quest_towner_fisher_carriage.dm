/datum/quest/kill/recovery/towner/fisher_carriage
	quest_type = QUEST_TOWNER_FISHER_CARRIAGE
	parcel_label = "recovered fishing tackle"
	posting_label = "Fisherman's Wrecked Carriage"
	posting_blurb = "A fisherman's carriage has been beset on the road. It contains valuable baits and other tools, help them find it and retrieve it."
	postable_advclasses = list(
		/datum/advclass/fisher,
		/datum/advclass/fishermaster,
	)
	eligible_regions = list(
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_TERRORBOG,
	)
	varieties = list(
		"tackle" = list(
			"label" = "Tackle",
			"blurb" = "The fisherman's tools of the trade, lost in the caravan",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/fishing/reel/silk, "min" = 1, "max" = 1, "noun" = "silk reel"),
					list("path" = /obj/item/fishing/line/bobber, "min" = 1, "max" = 1, "noun" = "bobber"),
					list("path" = /obj/item/fishing/line/sinker, "min" = 1, "max" = 1, "noun" = "sinker"),
					list("pool" = "rolled baits", "min" = 6, "max" = 9, "noun" = "rolled baits"),
					list("pool" = "sea-gems", "min" = 5, "max" = 6, "noun" = "sea-gems"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/fishing/reel/deluxe, "min" = 1, "max" = 1, "noun" = "deluxe reel"),
					list("path" = /obj/item/fishing/hook/deluxe, "min" = 1, "max" = 1, "noun" = "carved minnow hook"),
					list("path" = /obj/item/fishing/line/bobber, "min" = 1, "max" = 1, "noun" = "bobber"),
					list("path" = /obj/item/fishing/line/sinker, "min" = 1, "max" = 1, "noun" = "sinker"),
					list("pool" = "rolled baits", "min" = 6, "max" = 8, "noun" = "rolled baits"),
					list("path" = /obj/item/fishing/bait/deluxe, "min" = 2, "max" = 3, "noun" = "enchanted baits"),
					list("pool" = "sea-gems", "min" = 4, "max" = 6, "noun" = "sea-gems"),
				),
				TOWNER_POSTING_TIER_PERILOUS = list(
					list("path" = /obj/item/fishing/reel/deluxe, "min" = 1, "max" = 1, "noun" = "deluxe reel"),
					list("path" = /obj/item/fishing/hook/deluxe, "min" = 1, "max" = 1, "noun" = "carved minnow hook"),
					list("path" = /obj/item/fishing/hook/iron, "min" = 1, "max" = 1, "noun" = "iron hook"),
					list("path" = /obj/item/fishing/line/bobber, "min" = 1, "max" = 1, "noun" = "bobber"),
					list("path" = /obj/item/fishing/line/sinker, "min" = 1, "max" = 1, "noun" = "sinker"),
					list("pool" = "rolled baits", "min" = 8, "max" = 10, "noun" = "rolled baits"),
					list("path" = /obj/item/fishing/bait/shell, "min" = 3, "max" = 4, "noun" = "shell baits"),
					list("path" = /obj/item/fishing/bait/deluxe, "min" = 4, "max" = 6, "noun" = "enchanted baits"),
					list("path" = /obj/item/fishingrod/bronze, "min" = 1, "max" = 1, "noun" = "bronze rod"),
					list("pool" = "sea-gems", "min" = 10, "max" = 12, "noun" = "sea-gems"),
				),
			),
		),
		"bait stores" = list(
			"label" = "Bait Stores",
			"blurb" = "A week's worth of baits and worms.",
			"parcel_label" = "recovered bait stores",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("pool" = "rolled baits", "min" = 11, "max" = 17, "noun" = "rolled baits"),
					list("path" = /obj/item/natural/worms/grubs, "min" = 4, "max" = 6, "noun" = "grubs"),
					list("pool" = "sea-gems", "min" = 6, "max" = 7, "noun" = "sea-gems"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("pool" = "rolled baits", "min" = 16, "max" = 22, "noun" = "rolled baits"),
					list("path" = /obj/item/fishing/bait/deluxe, "min" = 4, "max" = 6, "noun" = "enchanted baits"),
					list("pool" = "sea-gems", "min" = 10, "max" = 12, "noun" = "sea-gems"),
				),
				TOWNER_POSTING_TIER_PERILOUS = list(
					list("pool" = "choice baits", "min" = 20, "max" = 26, "noun" = "choice baits"),
					list("path" = /obj/item/fishing/bait/shell, "min" = 6, "max" = 8, "noun" = "shell baits"),
					list("path" = /obj/item/fishing/bait/deluxe, "min" = 8, "max" = 10, "noun" = "enchanted baits"),
					list("pool" = "sea-gems", "min" = 16, "max" = 18, "noun" = "sea-gems"),
				),
			),
		),
	)
	bundle_pools = list(
		"rolled baits" = list(
			/obj/item/fishing/bait/dough,
			/obj/item/fishing/bait/speckled,
			/obj/item/fishing/bait/gray,
		),
		"choice baits" = list(
			/obj/item/fishing/bait/speckled,
			/obj/item/fishing/bait/speckled,
			/obj/item/fishing/bait/gray,
		),
		"sea-gems" = list(
			/obj/item/pearl,
			/obj/item/pearl,
			/obj/item/pearl,
			/obj/item/pearl,
			/obj/item/pearl/blue,
			/obj/item/roguegem/coral,
			/obj/item/roguegem/amber,
			/obj/item/roguegem/oyster,
		),
	)

/datum/quest/kill/recovery/towner/fisher_carriage/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Carriage"
	return "A Fisherman's Wrecked Carriage"

/datum/quest/kill/recovery/towner/fisher_carriage/get_objective_text()
	return "Secure the wreck and carry the package back to [quest_giver_name || "the fisher"] or put it into the nearest HERMES."

/datum/quest/kill/recovery/towner/fisher_carriage/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "beasts"
	return "[quest_giver_name || "The fisher"]'s carriage was beset by [raiders] on the road within [region]. They call for hands to get their tackle back."

/datum/quest/kill/recovery/towner/fisher_carriage/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."
