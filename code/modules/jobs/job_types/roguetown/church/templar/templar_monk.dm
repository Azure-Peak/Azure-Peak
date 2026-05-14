/datum/advclass/templar/monk
	name = "Monk"
	tutorial = "You are a monk of the Church, trained in pugilism and acrobatics. You bear no armor but your faith, and your hands are lethal weapons in service to your God."
	outfit = /datum/outfit/job/roguetown/templar/monk

	category_tags = list(CTAG_TEMPLAR)
	subclass_languages = list(/datum/language/grenzelhoftian)
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_stashed_items = list(
		"The Verses and Acts of the Ten" = /obj/item/book/rogue/bibble,
	)
	extra_context = "This subclass can choose from multiple disciplines. The further your chosen discipline strays from unarmed combat, however, the greater your skills in fistfighting and wrestling will atrophy. Taking a Quarterstaff provides a minor bonus to Perception, but removes the 'Dodge Expert' trait."

/datum/outfit/job/roguetown/templar/monk/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/psicross/undivided
	cloak = /obj/item/clothing/cloak/tabard/crusader/tief
	id = /obj/item/clothing/ring/silver
	gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/ritechalk = 1,
		)
	H.cmode_music = 'sound/music/cmode/church/combat_reckoning.ogg'
	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			mask = /obj/item/clothing/head/roguetown/roguehood/undivided
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/undivided
		if(/datum/patron/divine/astrata)
			mask = /obj/item/clothing/head/roguetown/roguehood/astrata
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/astrata
		if(/datum/patron/divine/abyssor)
			mask = /obj/item/clothing/head/roguetown/roguehood/abyssor
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/abyssor
		if(/datum/patron/divine/xylix)
			mask = /obj/item/clothing/head/roguetown/roguehood/black
			neck = /obj/item/clothing/neck/roguetown/psicross/xylix
			cloak = /obj/item/clothing/cloak/templar/xylixian
			H.cmode_music = 'sound/music/combat_jester.ogg'
		if(/datum/patron/divine/dendor)
			mask = /obj/item/clothing/head/roguetown/dendormask
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
		if(/datum/patron/divine/necra)
			mask = /obj/item/clothing/head/roguetown/necramask
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/necra
		if(/datum/patron/divine/pestra)
			mask = /obj/item/clothing/head/roguetown/roguehood/phys
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
			cloak = /obj/item/clothing/cloak/templar/pestran
		if(/datum/patron/divine/eora) //Eora content from stonekeep
			mask = /obj/item/clothing/head/roguetown/roguehood/eora
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
		if(/datum/patron/divine/noc)
			mask = /obj/item/clothing/head/roguetown/roguehood/nochood
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
			cloak = /obj/item/clothing/suit/roguetown/shirt/robe/noc
		if(/datum/patron/divine/ravox)
			mask = /obj/item/clothing/head/roguetown/roguehood/ravox
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
			cloak = /obj/item/clothing/cloak/templar/ravox
		if(/datum/patron/divine/malum)
			mask = /obj/item/clothing/head/roguetown/roguehood
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
			cloak = /obj/item/clothing/cloak/templar/malumite
	// Patron dagger + sheath in satchel
	var/patron_dagger = get_templar_patron_dagger(H)
	if(patron_dagger)
		backpack_contents += patron_dagger
		backpack_contents += /obj/item/rogueweapon/scabbard/sheath

	head = /obj/item/clothing/head/roguetown/headband/monk
	wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/monk
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/black
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	pants = /obj/item/clothing/under/roguetown/tights/black
	belt = /obj/item/storage/belt/rogue/leather/rope
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	beltr = /obj/item/storage/keyring/acolyte
	shoes = /obj/item/clothing/shoes/roguetown/sandals

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)	//Capped to T2 miracles.
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Church Funding.")

/datum/outfit/job/roguetown/templar/monk/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Discipline - Unarmed","Katar","Knuckledusters","Quarterstaff")
	switch(H.patron?.type)
		if(/datum/patron/divine/eora)
			weapons += "Close Caress"
		if(/datum/patron/divine/abyssor)
			weapons += "Barotrauma"
		if(/datum/patron/divine/ravox)
			weapons += "Arbiter"

	var/weapon_choice = input(H,"Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Discipline - Unarmed")
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/bandages/pugilist(H))
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Katar")
			H.put_in_hands(new /obj/item/rogueweapon/katar(H))
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Knuckledusters")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/knuckles(H))
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Quarterstaff")
			H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_EXPERT, TRUE) //Tested with Disciples, first. Should hopefully be not too busted - reduce to Journeyman, otherwise.
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/woodstaff/quarterstaff/steel(H))
			H.change_stat(STATKEY_PER, 1) //Matches the Disciple's balance; exchanges the 'dodge expert' trait for additional accuracy with the staff.
		if("Close Caress")
			H.put_in_hands(new /obj/item/clothing/gloves/roguetown/knuckles/eora(H))
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Barotrauma")
			H.put_in_hands(new /obj/item/rogueweapon/katar/abyssor(H))
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
		if("Arbiter")
			H.put_in_hands(new /obj/item/rogueweapon/katar/ravox(H))
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)

	var/techniques = list("Dropkick - Pushback + Extra Damage", "Chokeslam - Stamina Damage", "Stunner - Dazed Debuff", "Headbutt - Vulnerable Debuff") // cool wrestling moves
	var/technique_choice = input(H,"Choose your TECHNIQUE.", "TOSS THEM.") as anything in techniques
	switch(technique_choice)
		if("Dropkick - Pushback + Extra Damage")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/dropkick)
		if("Chokeslam - Stamina Damage")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/chokeslam)
		if("Stunner - Dazed Debuff")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stunner)
		if("Headbutt - Vulnerable Debuff")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/headbutt)

	// -- Start of section for god specific bonuses --
	if(H.patron?.type == /datum/patron/divine/undivided)
		H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/astrata)
		H.adjust_skillrank(/datum/skill/magic/holy, SKILL_LEVEL_NOVICE, TRUE)
		H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
	if(H.patron?.type == /datum/patron/divine/dendor)
		H.adjust_skillrank(/datum/skill/labor/farming, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/misc/hunting, SKILL_LEVEL_NOVICE, TRUE)
		ADD_TRAIT(H, TRAIT_EXPERT_HUNTER, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/noc)
		H.adjust_skillrank(/datum/skill/misc/reading, SKILL_LEVEL_JOURNEYMAN, TRUE) // Really good at reading... does this really do anything? No. BUT it's soulful.
		H.adjust_skillrank(/datum/skill/craft/alchemy, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/magic/arcane, SKILL_LEVEL_NOVICE, TRUE)
		ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/abyssor)
		H.adjust_skillrank(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
		H.grant_language(/datum/language/abyssal)
	if(H.patron?.type == /datum/patron/divine/necra)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
	if(H.patron?.type == /datum/patron/divine/pestra)
		H.adjust_skillrank(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/alchemy, SKILL_LEVEL_NOVICE, TRUE)
		ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
	if(H.patron?.type == /datum/patron/divine/eora)
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		// see acolyte.dm's eora page. they dont get farming bc they dont have a tree.
		H.adjust_skillrank(/datum/skill/craft/sewing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/malum)
		ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC) // ONE exception for the "no combat role get this" rules
		H.adjust_skillrank(/datum/skill/craft/blacksmithing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/armorsmithing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/weaponsmithing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/craft/smelting, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/xylix)
		H.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/misc/lockpicking, SKILL_LEVEL_NOVICE, TRUE)
		H.adjust_skillrank(/datum/skill/misc/music, SKILL_LEVEL_NOVICE, TRUE)
	if(H.patron?.type == /datum/patron/divine/ravox)
		H.adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_NOVICE, TRUE)
	// -- End of section for god specific bonuses --
