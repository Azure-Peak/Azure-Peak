// WOE: SPELLBLADE DODGE EXPERT POLEARM BUILD UPON YE.
/datum/advclass/wretch/blackoakwyrm
	name = "Black Oak's Pariah"
	tutorial = "Carrying extreme beliefs not even befit of the Black Oaks, you have decided to secede yourself from the group and everyone else. This land was once great...and now, wave after wave of monsters and outsiders trample your home. Your people were the ones that settled these lands, and the foreign-backed Crown, deceitful and arrogant, has denied your people the rewards they deserve! Your extensive training in the Black Oaks has given you skill in both glaives and magycks. A bounty from the crown follows you, as you had already done enough to be officially condemned by the group that was not committed to the cause due to the lure of coin."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/human/halfelf,
		/datum/species/elf/wood,
		/datum/species/elf/dark,
	)
	outfit = /datum/outfit/job/roguetown/wretch/blackoak
	cmode_music = 'sound/music/combat_blackoak.ogg'
	maximum_possible_slots = 1
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_DODGEEXPERT, TRAIT_ARCYNE_T2, TRAIT_WOODWALKER)
	//lower-than-avg stats for wretch but their traits are insanely good
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_CON = -1
	)
	subclass_spellpoints = 10
	subclass_languages = list(/datum/language/oldazurian)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, //Why the fuck did the treeclimber role have worse skills than THE KNIGHTS?
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit,
    )
	extra_context = "This subclass is race-limited to: Half-Elves, Elves, Dark Elves."

/datum/outfit/job/roguetown/wretch/blackoak/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(-3)
	has_loadout = TRUE
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/trophyfur
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	beltr = /obj/item/flashlight/flare/torch/lantern/prelit
	backpack_contents = list(
				/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1,
				)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/darkvision)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/conjure_weapon)
	wretch_select_bounty(H)

/datum/outfit/job/roguetown/wretch/blackoak/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Elvish Glaive", "Elvish Curveblade", "Elvish Longsword")
	var/weapon_choice = input(H, "Choose your weapon.", "FOR THE OAKS AND THE PEAKS") as anything in weapons
	switch(weapon_choice)
		if("Elvish Glaive")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/halberd/glaive/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("Elvish Curveblade")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("Elvish Longsword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BACK_R, TRUE)
	var/helmets = list("Elven Barbute", "Winged Elven Barbute")
	var/helmet_choice = input(H, "Choose your helmet.", "LEAVES OVER STEEL") as anything in helmets
	switch(helmet_choice)
		if("Elven Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/elvenbarbute/blackoak, SLOT_HEAD, TRUE)
		if("Winged Elven Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/blackoak, SLOT_HEAD, TRUE)
