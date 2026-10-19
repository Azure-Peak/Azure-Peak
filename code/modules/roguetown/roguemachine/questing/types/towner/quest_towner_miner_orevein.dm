/datum/quest/kill/recovery/towner/miner_orevein
	quest_type = QUEST_TOWNER_MINER_OREVEIN
	parcel_label = "ores"
	sealed_noun = "ore crate"
	posting_label = "A Miner's Lead"
	posting_blurb = "You found a vein guarded by elementals and mined a good haul before they drove you away. Hire hands to slay the elementals and haul out the crate."
	postable_advclasses = list(
		/datum/advclass/miner,
		/datum/advclass/guildsman/architect,
		/datum/advclass/guildmaster,
		/datum/advclass/minermaster,
		/datum/advclass/blacksmith,
		/datum/advclass/guildsman/blacksmith,
		/datum/advclass/masterblacksmith,
	)
	eligible_regions = list(
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_UNDERDARK,
	)
	tier_tp_budgets = list(
		TOWNER_POSTING_TIER_MEDIUM = TOWNER_OREVEIN_TP_BUDGET_MEDIUM,
		TOWNER_POSTING_TIER_HARD = TOWNER_OREVEIN_TP_BUDGET_HARD,
	)
	bundle_pools = list(
		"gems" = list(
			/obj/item/roguegem/green,
			/obj/item/roguegem/blue,
			/obj/item/roguegem/yellow,
			/obj/item/roguegem/violet,
			/obj/item/roguegem/ruby,
			/obj/item/roguegem/diamond,
			/obj/item/roguegem/jade,
		),
	)
	varieties = list(
		"iron" = list(
			"label" = "Iron Vein",
			"blurb" = "Iron and coal, with a little cinnabar and the odd gem.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/rogueore/iron, "min" = 14, "max" = 18, "noun" = "iron"),
					list("path" = /obj/item/rogueore/coal, "min" = 8, "max" = 12, "noun" = "coal"),
					list("path" = /obj/item/rogueore/cinnabar, "min" = 2, "max" = 3, "noun" = "cinnabar"),
					list("pool" = "gems", "min" = 1, "max" = 1, "noun" = "gems", "prob" = 40),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/rogueore/iron, "min" = 26, "max" = 32, "noun" = "iron"),
					list("path" = /obj/item/rogueore/coal, "min" = 12, "max" = 16, "noun" = "coal"),
					list("path" = /obj/item/rogueore/cinnabar, "min" = 3, "max" = 4, "noun" = "cinnabar"),
					list("pool" = "gems", "min" = 1, "max" = 1, "noun" = "gems", "prob" = 80),
				),
			),
		),
		"cuprostannic" = list(
			"label" = "Copper Vein",
			"blurb" = "Copper and tin, with a little cinnabar.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/rogueore/copper, "min" = 20, "max" = 26, "noun" = "copper"),
					list("path" = /obj/item/rogueore/tin, "min" = 6, "max" = 9, "noun" = "tin"),
					list("path" = /obj/item/rogueore/cinnabar, "min" = 1, "max" = 2, "noun" = "cinnabar"),
					list("pool" = "gems", "min" = 1, "max" = 1, "noun" = "gems", "prob" = 20),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/rogueore/copper, "min" = 32, "max" = 40, "noun" = "copper"),
					list("path" = /obj/item/rogueore/tin, "min" = 10, "max" = 14, "noun" = "tin"),
					list("path" = /obj/item/rogueore/cinnabar, "min" = 3, "max" = 4, "noun" = "cinnabar"),
					list("pool" = "gems", "min" = 1, "max" = 1, "noun" = "gems", "prob" = 60),
				),
			),
		),
		"gemmiferous" = list(
			"label" = "Gem Vein",
			"blurb" = "Cut gems and raw gold, no base metal.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/rogueore/gold, "min" = 1, "max" = 2, "noun" = "gold"),
					list("pool" = "gems", "min" = 2, "max" = 2, "noun" = "gems"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/rogueore/gold, "min" = 2, "max" = 3, "noun" = "gold"),
					list("pool" = "gems", "min" = 3, "max" = 4, "noun" = "gems"),
				),
			),
		),
		"auricinnabar" = list(
			"label" = "Cinnabar Vein",
			"blurb" = "Cinnabar with gold, prized by alchemists.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/rogueore/gold, "min" = 2, "max" = 3, "noun" = "gold"),
					list("path" = /obj/item/rogueore/cinnabar, "min" = 9, "max" = 11, "noun" = "cinnabar"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/rogueore/gold, "min" = 4, "max" = 5, "noun" = "gold"),
					list("path" = /obj/item/rogueore/cinnabar, "min" = 14, "max" = 17, "noun" = "cinnabar"),
				),
			),
		),
	)

/datum/quest/kill/recovery/towner/miner_orevein/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Lead"
	return "A Miner's Lead"

/datum/quest/kill/recovery/towner/miner_orevein/get_objective_text()
	return "Destroy the elemental guard at the ore vein and carry the package back to [quest_giver_name || "the miner"] or put it into the nearest HERMES."

/datum/quest/kill/recovery/towner/miner_orevein/get_parcel_name()
	return "[quest_giver_name]'s ore-crate"

/datum/quest/kill/recovery/towner/miner_orevein/get_parcel_desc()
	return "A crate packed with what [quest_giver_name] mined before the elementals closed in. It is magickally sealed so only they can open it."

/datum/quest/kill/recovery/towner/miner_orevein/get_writ_intro()
	var/region = target_spawn_area || "the deep places"
	return "[quest_giver_name || "The miner"] has found a vein within [region]. A host of earth elementals guards it. They struck a good haul before the host drove them off. Now they call for braves to break the guard and haul out the crate."

/datum/quest/kill/recovery/towner/miner_orevein/pick_region_faction_for(datum/threat_region/TR)
	return get_quest_faction(QUEST_FACTION_EARTH_ELEMENTAL)

/datum/quest/kill/recovery/towner/miner_orevein/roll_circumstance()
	return ""

/datum/quest/kill/recovery/towner/miner_orevein/compose_warband()
	if(posting_tier != TOWNER_POSTING_TIER_HARD)
		return ..()
	var/behemoth = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth
	var/saved_budget = tp_budget
	tp_budget = max(0, tp_budget - initial_threat_point(behemoth))
	. = ..()
	tp_budget = saved_budget
	if(!(behemoth in .))
		. += behemoth
