////////////////////////////////////////////////////////////////////////////////
/// MYSTIC
////////////////////////////////////////////////////////////////////////////////

/datum/advclass/mystic
	name = "Mystic"
	tutorial = "I was a Magos initiate who delved deep into the mysteries of the divine, seeking to uncover the secrets behind the miracles. Yet no matter how deeply I studied, I found nothing of significance, for true faith is not a mystery to be solved, but something that cannot be studied."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/mystic
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
	traits_applied = list(TRAIT_ARCYNE, TRAIT_SEEDKNOW, TRAIT_ALCHEMY_EXPERT)

	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1,
	)

	age_mod = /datum/class_age_mod/mystic

	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4, "post_aspect_spells" = list(/datum/action/cooldown/spell/arcyne_forge, /datum/action/cooldown/spell/mending), "ward" = TRUE)

	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/mystic
	head = /obj/item/clothing/head/roguetown/witchhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/backpack

/datum/outfit/job/roguetown/adventurer/mystic/pre_equip(mob/living/carbon/human/H)
	..()

	to_chat(H, span_warning("I was a Magos initiate who delved deep into the mysteries of the divine, seeking to uncover the secrets behind the miracles. Yet no matter how deeply I studied, I found nothing of significance, for true faith is not a mystery to be solved, but something that cannot be studied."))

	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]

	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/folding_alchcauldron_stored = 1,
		/obj/item/reagent_containers/glass/bottle = 3,
		/obj/item/reagent_containers/glass/bottle/alchemical = 3,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
	)

	setup_mystic_healing(H)
	setup_mystic_weapon(H, TRUE)
	setup_mystic_patron(H)


////////////////////////////////////////////////////////////////////////////////
/// SAGE
////////////////////////////////////////////////////////////////////////////////

/datum/advclass/mystic/sage
	name = "Sage"
	tutorial = "I was fated to become a Cleric initiate, until one irreversible death taught me that even faith has its limits. Shaken, I could no longer deepen my bonds with the Divine, and so I wandered beyond the flock. There I unravelled the mysteries of the Arcyne, and learned to fill what faith left wanting. Now I trust neither miracle nor magic alone, but know the wisdom of using both."
	outfit = /datum/outfit/job/roguetown/adventurer/sage
	traits_applied = list(TRAIT_ARCYNE, TRAIT_SEEDKNOW, TRAIT_ALCHEMY_EXPERT)

	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_SPD = 1,
		STATKEY_WIL = 1,
	)

	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4, "post_aspect_spells" = list(/datum/action/cooldown/spell/arcyne_forge, /datum/action/cooldown/spell/mending), "ward" = TRUE)

	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/sage
	head = /obj/item/clothing/head/roguetown/witchhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel

/datum/outfit/job/roguetown/adventurer/sage/pre_equip(mob/living/carbon/human/H)
	..()

	to_chat(H, span_warning("I was fated to become a Cleric initiate, until one irreversible death taught me that even faith has its limits. Shaken, I could no longer deepen my bonds with the Divine, and so I wandered beyond the flock. There I unravelled the mysteries of the Arcyne, and learned to fill what faith left wanting. Now I trust neither miracle nor magic alone, but know the wisdom of using both."))

	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]

	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
	)

	setup_mystic_healing(H, sage = TRUE)
	setup_mystic_weapon(H, FALSE)
	setup_mystic_patron(H)


////////////////////////////////////////////////////////////////////////////////
/// SCION
////////////////////////////////////////////////////////////////////////////////

/datum/advclass/mystic/scion
	name = "Scion"
	tutorial = "A kindness gave me faith, and I swore my blade to the divine and my life to its purpose. Although soon the road of faith taught me that faith and steel alone were not enough. So I studied the Arcyne alongside my miracles. For an oath is not kept by knowing one's limits, but by overcoming them."
	outfit = /datum/outfit/job/roguetown/adventurer/scion
	traits_applied = list(TRAIT_ARCYNE, TRAIT_SEEDKNOW, TRAIT_ALCHEMY_EXPERT, TRAIT_STEELHEARTED)

	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_STR = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 1,
	)

	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4, "post_aspect_spells" = list(/datum/action/cooldown/spell/arcyne_forge, /datum/action/cooldown/spell/mending), "ward" = TRUE)

	subclass_skills = list(
		/datum/skill/combat/arcyne = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/scion
	head = /obj/item/clothing/head/roguetown/headband/monk
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel

/datum/outfit/job/roguetown/adventurer/scion/pre_equip(mob/living/carbon/human/H)
	..()

	to_chat(H, span_warning("A kindness gave me faith, and I swore my blade to the divine and my life to its purpose. Although soon the road of faith taught me that faith and steel alone were not enough. So I studied the Arcyne alongside my miracles. For an oath is not kept by knowing one's limits, but by overcoming them."))

	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]

	setup_mystic_healing(H, scion = TRUE)
	setup_mystic_patron(H, TRUE)

	if(H.mind)
		var/list/weapons = list(
			"Arming Sword",
			"Rapier",
			"Shortsword + Shield",
			"Mace + Shield",
			"Quarterstaff",
			"Axe",
			"Spear",
			"Combat Knife",
			"Knuckledusters",
		)

		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons

		switch(weapon_choice)
			if("Arming Sword")
				r_hand = /obj/item/rogueweapon/sword
				beltr = /obj/item/rogueweapon/scabbard/sword

			if("Rapier")
				r_hand = /obj/item/rogueweapon/sword/rapier
				beltr = /obj/item/rogueweapon/scabbard/sword

			if("Shortsword + Shield")
				r_hand = /obj/item/rogueweapon/sword/short
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/wood

			if("Mace + Shield")
				r_hand = /obj/item/rogueweapon/mace
				backr = /obj/item/rogueweapon/shield/wood

			if("Quarterstaff")
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				backr = /obj/item/rogueweapon/scabbard/gwstrap

			if("Axe")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
				backr = /obj/item/rogueweapon/scabbard/gwstrap

			if("Spear")
				r_hand = /obj/item/rogueweapon/spear
				backr = /obj/item/rogueweapon/scabbard/gwstrap

			if("Combat Knife")
				r_hand = /obj/item/rogueweapon/huntingknife/combat
				backr = /obj/item/rogueweapon/scabbard/sheath

			if("Knuckledusters") // this one will have to be quirky, ugh
				gloves = /obj/item/clothing/gloves/roguetown/knuckles
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.mind.RemoveSpell(new /datum/action/cooldown/spell/bind_armament)
				H.mind.RemoveSpell(new /datum/action/cooldown/spell/bind_weapon)
				H.mind.RemoveSpell(new /datum/action/cooldown/spell/recall_weapon)
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_WEAPONLESS, TRAIT_GENERIC)

	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
	)


////////////////////////////////////////////////////////////////////////////////
/// MYSTIC - SHARED SYSTEMS
////////////////////////////////////////////////////////////////////////////////

/proc/setup_mystic_healing(mob/living/carbon/human/H, sage = FALSE, scion = FALSE)
	if(!H.mind)
		return

	if(!scion && !sage) // mystic-only, gets the cooler magic spell for poking
		H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_volley)

	if(!sage) // sage doesn't get this anymore to make them feel more diff than mystic
		grant_poke_spell(H)

	if(H.patron?.type in ALL_DIVINE_PATRONS) // shared between the three
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/divineblast)
	if(H.patron?.type in ALL_INHUMEN_PATRONS)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/unholyblast)
	if(H.patron?.type in OLD_GOD_PATRON) // lol
		H.mind.AddSpell(new /datum/action/cooldown/spell/psydon/enduring_blast)

	if(scion) // scion gets the ability to wield arcyne armaments, mostly for sovl, it's the same as just giving them a weapon and the skill to wield it, but this makes it more personal
		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)

	if(sage) // sage-only
		H.mind.AddSpell(/datum/action/cooldown/spell/bestow_ward)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles( H, cleric_tier = CLERIC_T1, passive_gain = sage ? CLERIC_REGEN_MINOR : CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_1)

	if(!sage) // neither scions nor mystics can bloodmiracle, that's for sage, who is 'the' cleric among them
		H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/bloodmiracle)

	if(scion) // scion gets the ability to wield arcyne armaments, mostly for sovl, it's the same as just giving them a weapon and the skill to wield it, but this makes it more personal
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_armament)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)

/proc/setup_mystic_weapon(mob/living/carbon/human/H, include_quarterstaff = TRUE)
	if(!H.mind)
		return

	var/list/weapons

	if(include_quarterstaff)
		weapons = list("Staff", "Tome", "Quarterstaff")
	else
		weapons = list("Staff", "Tome")

	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons

	switch(weapon_choice)
		if("Staff")
			H.put_in_r_hand(new /obj/item/rogueweapon/woodstaff/implement, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)

		if("Tome")
			H.put_in_r_hand(new /obj/item/rogueweapon/spellbook, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)

		if("Quarterstaff")
			H.put_in_r_hand(new /obj/item/rogueweapon/woodstaff/quarterstaff/iron, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, ITEM_SLOT_BACK_R)
			H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)

/proc/setup_mystic_patron(mob/living/carbon/human/H)
	var/obj/item/clothing/neck/roguetown/patron_item

	switch(H.patron?.type)
		if(/datum/patron/old_god)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross

		if(/datum/patron/divine/undivided)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross/undivided

		if(/datum/patron/divine/astrata)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'

		if(/datum/patron/divine/noc)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross/noc

		if(/datum/patron/divine/abyssor)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross/abyssor
			H.grant_language(/datum/language/abyssal)

		if(/datum/patron/divine/dendor)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'

		if(/datum/patron/divine/necra)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'

		if(/datum/patron/divine/pestra)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross/pestra

		if(/datum/patron/divine/ravox)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross/ravox

		if(/datum/patron/divine/malum)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross/malum

		if(/datum/patron/divine/eora)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'

		if(/datum/patron/inhumen/zizo)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

		if(/datum/patron/inhumen/matthios)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

		if(/datum/patron/inhumen/graggar)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

		if(/datum/patron/inhumen/baotha)
			patron_item = new /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)

		if(/datum/patron/divine/xylix)
			patron_item = new /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

	if(patron_item)
		H.equip_to_slot_or_del(patron_item, ITEM_SLOT_RING)
