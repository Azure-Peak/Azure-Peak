/obj/item/paper/scroll/fake_evidence
	name = "Personal Documents"
	desc = "A document containing information very important to someone."
	info = "\[This document contains information that is very important to someone. It is likely that they would pay handsomely for its return.\]"

/datum/quest/kill/recovery/towner/noble_trinket
	quest_type = QUEST_TOWNER_VALUABLES
	parcel_label = "recovered trinkets"
	posting_label = "Personal Valuables"
	posting_blurb = "Your valuables have been lost, taken by brigands! Hire hands to get your revenge, and your belongings back."
	postable_advclasses = list(
		/datum/advclass/councillor/herald,
		/datum/advclass/councillor/huntmaster,
		/datum/advclass/councillor/cofferer,
		/datum/advclass/councillor/castellan,
		/datum/advclass/heir/daring,
		/datum/advclass/heir/bookworm,
		/datum/advclass/heir/aristocrat,
		/datum/advclass/heir/inbred,
		/datum/advclass/heir/scamp,
		/datum/advclass/lord/warrior,
		/datum/advclass/lord/merchant,
		/datum/advclass/lord/mage,
		/datum/advclass/lord/inbred,
		/datum/advclass/suitor/envoy,
		/datum/advclass/suitor/gallant,
		/datum/advclass/suitor/schemer,
		/datum/advclass/consort,
		/datum/advclass/hand/blademaster,
		/datum/advclass/hand/spymaster,
		/datum/advclass/hand/advisor,
		/datum/advclass/steward,
		/datum/advclass/marshal/classic,
		/datum/advclass/marshal/kcommander,
		/datum/advclass/merchant,
		/datum/advclass/trader/jeweler,
		/datum/advclass/veteran/calvaryman,
		/datum/advclass/noble,
		/datum/advclass/noble/squire,
		/datum/advclass/heartfelt/lord/lord,
		/datum/advclass/heartfelt/lord/archmage,
		/datum/advclass/heartfelt/lord/chief,
		/datum/advclass/heartfelt/hand/steward,
		/datum/advclass/heartfelt/hand/advisor,
		/datum/advclass/heartfelt/hand/marshal,
		/datum/advclass/heartfelt/retinue/courtier,
	)
	eligible_regions = list(
		THREAT_REGION_MOUNT_DECAP,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_UNDERDARK,
	)
	eligible_factions = list(
		QUEST_FACTION_HIGHWAYMAN,
		QUEST_FACTION_SEA_GOBLIN,
		QUEST_FACTION_GRONNMAN,
		QUEST_FACTION_FOREST_GOBLIN,
		QUEST_FACTION_ORC,
		QUEST_FACTION_BOGMAN,
		QUEST_FACTION_HELL_GOBLIN,
		QUEST_FACTION_MOUNT_REAVER,
		QUEST_FACTION_MADMAN,
		QUEST_FACTION_DROW,
		QUEST_FACTION_BLEAKISLE_REAVER,
	)
	varieties = list(
		"heirloom" = list(
			"label" = "Heirloom",
			"blurb" = "An irreplaceable family heirloom.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/clothing/neck/roguetown/ornateamulet/noble, "min" = 1, "max" = 1, "noun" = "heirloom amulet"),
					list("path" = /obj/item/rogueweapon/sword/long/heirloom, "min" = 1, "max" = 1, "noun" = "old longsword"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/clothing/ring/diamond, "min" = 1, "max" = 1, "noun" = "valuable heirloom ring"),
					list("path" = /obj/item/roguestatue/gold, "min" = 1, "max" = 2, "noun" = "golden statuettes"),
				),
			),
		),
		"gems" = list(
			"label" = "Gems",
			"blurb" = "A selection of precious gems.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/roguegem/ruby, "min" = 1, "max" = 1, "noun" = "rontz"),
					list("path" = /obj/item/roguegem/yellow, "min" = 0, "max" = 2, "noun" = "toper"),
					list("path" = /obj/item/roguegem/onyxa, "min" = 0, "max" = 2, "noun" = "onyxa"),
					list("path" = /obj/item/roguegem/amber, "min" = 0, "max" = 1, "noun" = "amber"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/roguegem/diamond, "min" = 1, "max" = 1, "noun" = "dorpel"),
					list("path" = /obj/item/roguegem/jade, "min" = 0, "max" = 2, "noun" = "jade"),
					list("path" = /obj/item/roguegem/violet, "min" = 0, "max" = 2, "noun" = "saffira"),
					list("path" = /obj/item/roguegem/green, "min" = 0, "max" = 3, "noun" = "gemerald"),
				),
			),
		),
		"coin" = list(
			"label" = "Coin",
			"blurb" = "Stolen coin.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/roguecoin/gold/virtuepile, "min" = 1, "max" = 1, "noun" = "gold pile"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/roguecoin/gold/aspirantpile, "min" = 1, "max" = 1, "noun" = "gold pile"),
					list("path" = /obj/item/roguecoin/silver/pile, "min" = 1, "max" = 1, "noun" = "silver pile"),
				),
			),
		),
		"evidence" = list(
			"label" = "Evidence",
			"blurb" = "Stolen documents containing compromising information.",
			"tiers" = list(
				TOWNER_POSTING_TIER_MEDIUM = list(
					list("path" = /obj/item/paper/scroll/fake_evidence, "min" = 1, "max" = 1, "noun" = "document"),
				),
				TOWNER_POSTING_TIER_HARD = list(
					list("path" = /obj/item/paper/scroll/fake_evidence, "min" = 1, "max" = 1, "noun" = "document"),
				),
			),
		),
	)

/datum/quest/kill/recovery/towner/noble_trinket/get_title()
	if(title)
		return title
	if(quest_giver_name)
		return "[quest_giver_name]'s Valuables"
	return "Missing Valuables"

/datum/quest/kill/recovery/towner/noble_trinket/get_objective_text()
	return "Run down the thieves and carry the package back to [quest_giver_name || "the noble"] or put it into the nearest HERMES."

/datum/quest/kill/recovery/towner/noble_trinket/get_writ_intro()
	var/region = target_spawn_area || "the wilds"
	var/raiders = faction ? faction.name_plural : "brigands"
	return "[quest_giver_name || "The noble"]'s valuables were taken by [raiders] on the road within [region]. They call for hands to get their valuables back."

/datum/quest/kill/recovery/towner/noble_trinket/get_parcel_desc()
	return "A parcel magickally sealed for [quest_giver_name]. Only they can open it."
