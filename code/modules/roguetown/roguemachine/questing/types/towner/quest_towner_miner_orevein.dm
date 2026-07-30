GLOBAL_LIST_INIT(towner_orevein_regions, list(
	THREAT_REGION_AZUREAN_COAST,
	THREAT_REGION_UNDERDARK,
))

GLOBAL_LIST_INIT(towner_orevein_gem_types, list(
	/obj/item/roguegem/green,
	/obj/item/roguegem/blue,
	/obj/item/roguegem/yellow,
	/obj/item/roguegem/violet,
	/obj/item/roguegem/ruby,
	/obj/item/roguegem/diamond,
	/obj/item/roguegem/jade,
))

GLOBAL_LIST_INIT(towner_orevein_tier_tp, list(
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_OREVEIN_TP_BUDGET_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_OREVEIN_TP_BUDGET_HARD,
))

GLOBAL_LIST_INIT(towner_orevein_varieties, list(
	OREVEIN_VARIETY_IRON = list(
		"label" = "Iron Vein",
		"blurb" = "Iron and coal, with a little cinnabar and the odd gem.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/rogueore/iron, "min" = 14, "max" = 18, "noun" = "iron"),
				list("path" = /obj/item/rogueore/coal, "min" = 8, "max" = 12, "noun" = "coal"),
				list("path" = /obj/item/rogueore/cinnabar, "min" = 2, "max" = 3, "noun" = "cinnabar"),
				list("pool" = "orevein_gems", "min" = 1, "max" = 1, "noun" = "gems", "prob" = 40),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/rogueore/iron, "min" = 26, "max" = 32, "noun" = "iron"),
				list("path" = /obj/item/rogueore/coal, "min" = 12, "max" = 16, "noun" = "coal"),
				list("path" = /obj/item/rogueore/cinnabar, "min" = 3, "max" = 4, "noun" = "cinnabar"),
				list("pool" = "orevein_gems", "min" = 1, "max" = 1, "noun" = "gems", "prob" = 80),
			),
		),
	),
	OREVEIN_VARIETY_CUPROSTANNIC = list(
		"label" = "Copper Vein",
		"blurb" = "Copper and tin, with small amount of luxury.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/rogueore/copper, "min" = 20, "max" = 26, "noun" = "copper"),
				list("path" = /obj/item/rogueore/tin, "min" = 6, "max" = 9, "noun" = "tin"),
				list("path" = /obj/item/rogueore/cinnabar, "min" = 1, "max" = 2, "noun" = "cinnabar"),
				list("pool" = "orevein_gems", "min" = 1, "max" = 1, "noun" = "gems", "prob" = 20),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/rogueore/copper, "min" = 32, "max" = 40, "noun" = "copper"),
				list("path" = /obj/item/rogueore/tin, "min" = 10, "max" = 14, "noun" = "tin"),
				list("path" = /obj/item/rogueore/cinnabar, "min" = 3, "max" = 4, "noun" = "cinnabar"),
				list("pool" = "orevein_gems", "min" = 1, "max" = 1, "noun" = "gems", "prob" = 60),
			),
		),
	),
	OREVEIN_VARIETY_GEMMIFEROUS = list(
		"label" = "Gem Vein",
		"blurb" = "Cut gems and raw gold, no base metal.",
		"tiers" = list(
			TOWNER_POSTING_TIER_MEDIUM = list(
				list("path" = /obj/item/rogueore/gold, "min" = 1, "max" = 2, "noun" = "gold"),
				list("pool" = "orevein_gems", "min" = 2, "max" = 2, "noun" = "gems"),
			),
			TOWNER_POSTING_TIER_HARD = list(
				list("path" = /obj/item/rogueore/gold, "min" = 2, "max" = 3, "noun" = "gold"),
				list("pool" = "orevein_gems", "min" = 3, "max" = 4, "noun" = "gems"),
			),
		),
	),
	OREVEIN_VARIETY_AURICINNABAR = list(
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
))

/datum/quest/kill/recovery/towner/miner_orevein
	quest_type = QUEST_TOWNER_MINER_OREVEIN
	parcel_label = "ores"
	sealed_noun = "ore crate"

/datum/quest/kill/recovery/towner/miner_orevein/get_eligible_regions()
	return GLOB.towner_orevein_regions

/datum/quest/kill/recovery/towner/miner_orevein/get_varieties()
	return GLOB.towner_orevein_varieties

/datum/quest/kill/recovery/towner/miner_orevein/get_tier_tp_budget()
	return GLOB.towner_orevein_tier_tp[posting_tier] || TOWNER_OREVEIN_TP_BUDGET_MEDIUM

/datum/quest/kill/recovery/towner/miner_orevein/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Lead"
	return "A Miner's Lead"

/datum/quest/kill/recovery/towner/miner_orevein/get_objective_text()
	return "Break the elemental guard on the strike and carry the ore-crate back to [quest_giver_name || "the miner"]."

/datum/quest/kill/recovery/towner/miner_orevein/get_parcel_name()
	return "[quest_giver_name]'s ore-crate"

/datum/quest/kill/recovery/towner/miner_orevein/get_parcel_desc()
	return "A crate packed with what [quest_giver_name] mined before the elementals closed in, magickally sealed so only they can open it."

/datum/quest/kill/recovery/towner/miner_orevein/get_writ_intro()
	var/region = target_spawn_area || "the deep places"
	return "[quest_giver_name || "The miner"] hath prospected a vein within [region], guarded by a host of earth elementals. They struck a good haul before the host drove them off, and now call for hands to break the guard and haul out the crate."

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

/datum/quest/kill/recovery/towner/miner_orevein/build_bundle()
	var/list/meta = GLOB.towner_orevein_varieties[effective_variety()]
	var/list/tiers = meta?["tiers"]
	if(!tiers)
		return list()
	return resolve_bundle_spec(tiers[posting_tier] || tiers[TOWNER_POSTING_TIER_MEDIUM])
