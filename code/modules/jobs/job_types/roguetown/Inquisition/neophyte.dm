/datum/job/roguetown/neophyte
	title = "Neophyte"
	flag = NEOPHYTE
	department_flag = INQUISITION
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_sexes = list(MALE, FEMALE)
	tutorial = "Every servant of the Inquisition begins somewhere. You are a Neophyte, the lowest rank within its sacred order. Under the watchful eyes of your superiors, you copy records, carry messages, maintain the embassy, and learn the doctrines of the Faith. You are not expected to fight, but to observe, study, and prove yourself worthy of one day joining the ranks of the Orthodoxists."
	selection_color = JCOLOR_INQUISITION
	outfit = /datum/outfit/job/roguetown/neophyte/
	display_order = JDO_NEOPHYTE
	min_pq = 1
	max_pq = null
	round_contrib_points = 2
	wanderer_examine = FALSE
	advjob_examine = FALSE
	give_bank_account = 25
	job_traits = list(
		TRAIT_INQUISITION,
		TRAIT_BOOTSHINE,
	)
	virtue_restrictions = list(
		/datum/virtue/combat/dualwielder,
		/datum/virtue/combat/combat_virtue,
		/datum/virtue/combat/crossbowman,
		/datum/virtue/combat/bowman,
		/datum/virtue/thief/drug_runner, // we have penitent now, to compensate the loss of this
		)
	advclass_cat_rolls = list(CTAG_NEOPHYTE = 2)
	// Core idea for neophytes: They reduce the burden of Indexing in general and can request errands for Otava to earn the Inquisition some bonus marques. They can also prepare special requisition slips that can only be used with the signature of an Orthodoxist.
	// All neophytes can freely prepare Confessions and Accusations using their inqslip kits, with Scribes being the most efficient/fast at using them.
	job_subclasses = list(
		/datum/advclass/scribe, // the archivist neophyte, intended to tag along with the inquisitor/evolve to soujourner
		/datum/advclass/page, // the squire neophyte, intended to tag along with/evolve to adjudicators or disciples
		/datum/advclass/oblate, // the healer neophyte, intended to tag along with/evolve to absolvers
		/datum/advclass/penitent, // the thief neophyte, intended to tag along with/evolve to confessors
	)

/datum/advclass/scribe
	name = "Scribe"
	tutorial = "The Inquisition's greatest weapon is not steel, but truth. As a Scribe, you preserve scripture, chronicle investigations, copy confessions, and safeguard the records upon which justice is built. A steady hand and a discerning mind are your greatest virtues."
	outfit = /datum/outfit/job/roguetown/neophyte/basic
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_NEOPHYTE)
	traits_applied = list(TRAIT_ARCYNE, TRAIT_INTELLECTUAL, TRAIT_HOMESTEAD_EXPERT, TRAIT_GOODWRITER)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,

	)
	tempo_capable = FALSE
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy,
		"Chains" = /obj/item/rope/chain,
		"Parchment" = /obj/item/paper,
		"Parchment" = /obj/item/paper,
		"Parchment" = /obj/item/paper,
		"Scroll" = /obj/item/paper/scroll,
		"Scroll" = /obj/item/paper/scroll,
		"Scroll" = /obj/item/paper/scroll,
		"Feather" = /obj/item/natural/feather,
	)

/datum/outfit/job/roguetown/neophyte/basic/scribe/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/transcribe)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mindlink)

/datum/advclass/page
	name = "Page"
	tutorial = "Every Orthodoxist was once entrusted with another's burdens. As a Page, you attend the embassy's officers, maintain their equipment, carry messages, and accompany them in their duties. Though inexperienced, each task is another step toward earning your place within the Order."
	outfit = /datum/outfit/job/roguetown/neophyte/basic
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_NEOPHYTE)
	traits_applied = list(TRAIT_SQUIRE_REPAIR, TRAIT_STEELHEARTED)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
	)
	tempo_capable = FALSE
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy,
		"Armor Plates" = /obj/item/repair_kit/metal,
		"Sewing Kit" = /obj/item/repair_kit,
		"Chains" = /obj/item/rope/chain,
		"Scroll" = /obj/item/paper/scroll,
		"Feather" = /obj/item/natural/feather,
	)

/datum/outfit/job/roguetown/neophyte/basic/page/pre_equip(mob/living/carbon/human/H)
	..()
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			wrists = /obj/item/clothing/neck/roguetown/psicross/silver
			H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_APPRENTICE, TRUE)
			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
		else
			wrists = /obj/item/clothing/neck/roguetown/psicross
	var/origin = input(H, "What do you dream of becoming in the future?", "ASPIRATION") as anything in list("Disciple", "Adjudicator")
	if(origin == "Disciple")
		gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
		ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC) // this is subject to be removed
	else
		l_hand = /obj/item/rogueweapon/mace/cudgel/psy/old
		r_hand = /obj/item/rogueweapon/shield/heater

/datum/advclass/oblate
	name = "Oblate"
	tutorial = "You have devoted yourself to the quiet path of the Absolvers. As an Oblate, your life is one of prayer, labor, and humble service, learning to ease suffering before ever raising a hand in anger. Through patience, discipline, and compassion, you hope to one day bear the vows of an Absolver."
	outfit = /datum/outfit/job/roguetown/neophyte/basic/oblate
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_NEOPHYTE)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_SILVER_BLESSED, TRAIT_PACIFISM)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)
	tempo_capable = FALSE
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy,
		"Bandages" = /obj/item/natural/bundle/cloth/bandage/full,
		"Needle" = /obj/item/needle/bronze,
		"Chains" = /obj/item/rope/chain,
		"Scroll" = /obj/item/paper/scroll,
		"Feather" = /obj/item/natural/feather,
	)

/datum/outfit/job/roguetown/neophyte/basic/oblate/pre_equip(mob/living/carbon/human/H)
	..()
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			wrists = /obj/item/clothing/neck/roguetown/psicross/silver
			H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/psydonlux_tamper/lesser)
			var/datum/devotion/C = new /datum/devotion(H, H.patron)
			C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
		else
			wrists = /obj/item/clothing/neck/roguetown/psicross

/datum/advclass/penitent
	name = "Penitent"
	tutorial = "You stand as a fortunate sinner, granted one final chance to redeem yourself before the Orthodoxy. Bound to the Inquisition, you are expected to obey without question, whether scrubbing floors or following a Confessor into the streets. Many Confessors favor Penitents as attendants, remembering well that they once wore the same chains."
	outfit = /datum/outfit/job/roguetown/neophyte/basic
	subclass_languages = list(/datum/language/otavan, /datum/language/thievescant)
	category_tags = list(CTAG_NEOPHYTE)
	traits_applied = list(TRAIT_KEENEARS)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	)
	tempo_capable = FALSE
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy,
		"Lockpick" = /obj/item/lockpick,
		"Sack" = /obj/item/storage/roguebag,
		"Chains" = /obj/item/rope/chain,
		"Scroll" = /obj/item/paper/scroll,
		"Feather" = /obj/item/natural/feather,
	)

/datum/outfit/job/roguetown/neophyte/basic/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	cloak = /obj/item/clothing/cloak/tabard/psydontabard/black
	head = /obj/item/clothing/head/roguetown/roguehood/psydon/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	belt = /obj/item/storage/belt/rogue/leather/black
	beltr = /obj/item/roguekey/inquisitionmanor
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	backl = /obj/item/storage/backpack/rogue/satchel/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	id = /obj/item/clothing/ring/signet/psy
	backpack_contents = list(
		/obj/item/inqarticles/indexer = 3,
		/obj/item/inqarticles/inqslip_kit = 1,
		/obj/item/paper/inqslip/arrival/neophyte = 1,
		/obj/item/armor_brush = 1,
		/obj/item/polishing_cream = 3,
		/obj/item/contraption/folding_table_stored = 1,
		)
