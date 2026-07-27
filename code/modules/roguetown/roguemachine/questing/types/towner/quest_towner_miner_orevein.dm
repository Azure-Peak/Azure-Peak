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
	TOWNER_POSTING_TIER_EASY = TOWNER_OREVEIN_TP_BUDGET_EASY,
	TOWNER_POSTING_TIER_MEDIUM = TOWNER_OREVEIN_TP_BUDGET_MEDIUM,
	TOWNER_POSTING_TIER_HARD = TOWNER_OREVEIN_TP_BUDGET_HARD,
))

/datum/quest/kill/recovery/towner/miner_orevein
	quest_type = QUEST_TOWNER_MINER_OREVEIN
	parcel_label = "ores"
	sealed_noun = "ore crate"

/datum/quest/kill/recovery/towner/miner_orevein/get_eligible_regions()
	return GLOB.towner_orevein_regions

/datum/quest/kill/recovery/towner/miner_orevein/get_tier_tp_budget()
	return GLOB.towner_orevein_tier_tp[posting_tier] || TOWNER_OREVEIN_TP_BUDGET_EASY

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
	. = ..()
	if(posting_tier != TOWNER_POSTING_TIER_HARD)
		return
	var/behemoth = /mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth
	if(!(behemoth in .))
		. += behemoth

/datum/quest/kill/recovery/towner/miner_orevein/build_bundle()
	var/list/bundle = list()
	switch(posting_tier)
		if(TOWNER_POSTING_TIER_HARD)
			bundle[/obj/item/rogueore/iron] = rand(26, 34)
			bundle[/obj/item/rogueore/coal] = rand(14, 18)
			bundle[/obj/item/rogueore/cinnabar] = rand(5, 8)
			bundle[/obj/item/rogueore/gold] = rand(3, 5)
			for(var/i in 1 to rand(2, 3))
				var/gem_path = pick(GLOB.towner_orevein_gem_types)
				bundle[gem_path] = (bundle[gem_path] || 0) + 1
		if(TOWNER_POSTING_TIER_MEDIUM)
			bundle[/obj/item/rogueore/iron] = rand(18, 24)
			bundle[/obj/item/rogueore/coal] = rand(10, 14)
			bundle[/obj/item/rogueore/cinnabar] = rand(3, 4)
			bundle[/obj/item/rogueore/gold] = rand(1, 2)
			if(prob(60))
				bundle[pick(GLOB.towner_orevein_gem_types)] = 1
		else
			bundle[/obj/item/rogueore/iron] = rand(13, 18)
			bundle[/obj/item/rogueore/coal] = rand(8, 11)
			if(prob(50))
				bundle[/obj/item/rogueore/gold] = 1
	return bundle
