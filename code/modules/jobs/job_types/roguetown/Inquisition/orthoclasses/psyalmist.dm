/datum/advclass/psyaltrist
	name = "Psyaltrist"
	tutorial = "You spent some time with cathedral choirs and psyaltrists. Now you spend your days applying the musical arts to the practical on behalf of His most Holy of Inquisitions."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/psyaltrist
	category_tags = list(CTAG_ORTHODOXIST)
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	traits_applied = list(
		TRAIT_DODGEEXPERT,
		TRAIT_EMPATH
	)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE
	)
	subclass_stashed_items = list(
		"The Book" = /obj/item/book/rogue/bibble/psy
	)

/datum/outfit/job/roguetown/psyaltrist
	job_bitflag = BITFLAG_HOLY_WARRIOR

/datum/outfit/job/roguetown/psyaltrist/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	head = /obj/item/clothing/head/roguetown/helmet/leather/chapeau
	neck = /obj/item/clothing/neck/roguetown/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/psyaltrist
	backl = /obj/item/storage/backpack/rogue/satchel/otavan
	cloak = /obj/item/clothing/cloak/psyaltrist
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/inq
	gloves = /obj/item/clothing/gloves/roguetown/otavan/psygloves
	wrists = /obj/item/clothing/neck/roguetown/psicross/silver
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	belt = /obj/item/storage/belt/rogue/leather/tossbelt/blade/black/silver/psy/preblessed
	beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
	id = /obj/item/clothing/ring/signet/psy
	backpack_contents = list(
		/obj/item/roguekey/inquisitionmanor = 1,
		/obj/item/paper/inqslip/arrival/ortho = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/silver/psy,
		/obj/item/rogueweapon/scabbard/sheath
		)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	H.mind?.AddSpell(new /datum/action/cooldown/spell/projectile/vicious_mockery)

	change_origin(H, /datum/virtue/origin/otava, "Holy order")

/datum/outfit/job/roguetown/psyaltrist/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/instruments = list("Harp", "Lute", "Accordion", "Guitar", "Hurdy-Gurdy", "Viola", "Vocal Talisman", "Psyaltery", "Flute", "Drum", "Shamisen")
	var/instrument_choice = input(H, "Choose your INSTRUMENT.", "TAKE UP PSYDON'S SOLEMNITY.") as anything in instruments
	switch(instrument_choice)
		if("Harp")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/harp, SLOT_BACK_R, TRUE)
		if("Lute")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/lute, SLOT_BACK_R, TRUE)
		if("Accordion")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/accord, SLOT_BACK_R, TRUE)
		if("Guitar")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/guitar, SLOT_BACK_R, TRUE)
		if("Hurdy-Gurdy")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/hurdygurdy, SLOT_BACK_R, TRUE)
		if("Viola")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/viola, SLOT_BACK_R, TRUE)
		if("Vocal Talisman")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/vocals, SLOT_BACK_R, TRUE)
		if("Psyaltery")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/psyaltery, SLOT_BACK_R, TRUE)
		if("Flute")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/flute, SLOT_BACK_R, TRUE)
		if("Drum")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/drum, SLOT_BACK_R, TRUE)
		if("Shamisen")
			H.equip_to_slot_or_del(new /obj/item/rogue/instrument/shamisen, SLOT_BACK_R, TRUE)

	var/weapons = list("Psydonic Shortsword", "Psydonic Cudgel", "Psydonic Flanged Mace", "Psydonic Whip")
	var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
	switch(weapon_choice)
		if("Psydonic Shortsword")
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/silver/psy)
			H.put_in_hands(new /obj/item/rogueweapon/scabbard/sword)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Psydonic Cudgel")
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/psy)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
		if("Psydonic Flanged Mace")
			H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/flanged/silver/psy)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
		if("Psydonic Whip")
			H.put_in_hands(new /obj/item/rogueweapon/whip/silver/psy)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
