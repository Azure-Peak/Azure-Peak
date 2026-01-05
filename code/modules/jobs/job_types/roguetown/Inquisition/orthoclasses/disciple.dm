/datum/advclass/disciple
	name = "Disciple"
	tutorial = "Psydonite monks, practiced in both martiality and scripture. Spilling blood on sacred grounds is considered 'sinful' to the clergymen, though no qualms are spared towards knocking someone's lights out."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/disciple
	subclass_languages = list(/datum/language/otavan)
	category_tags = list(CTAG_INQUISITION)
	traits_applied = list(
		TRAIT_CIVILIZEDBARBARIAN,
	)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_INT = -2,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
	)
	subclass_stashed_items = list(
		"Tome of Psydon" = /obj/item/book/rogue/bibble/psy
	)
	extra_context = "This subclass can choose from multiple disciplines. The further your chosen discipline strays from unarmed combat, however, the greater your skills in fistfighting and wrestling will atrophy. Taking a Quarterstaff provides a minor bonus to Perception and Intelligence, but removes the 'Critical Resistance' trait."

/datum/outfit/job/roguetown/disciple
	job_bitflag = BITFLAG_HOLY_WARRIOR

/obj/item/storage/belt/rogue/leather/rope/dark
	color = "#505050"

/datum/outfit/job/roguetown/disciple/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		var/weapons = list("Discipline - Unarmed", "Katar", "Knuckledusters", "Quarterstaff")
		var/weapon_choice = input(H,"Choose your WEAPON.", "TAKE UP PSYDON'S ARMS.") as anything in weapons
		switch(weapon_choice)
			if("Discipline - Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 5, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 5, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_IGNOREDAMAGESLOWDOWN, TRAIT_GENERIC) //Removes pain-inflicted slowdowns. Does not immunize against pain, nor other means of slowdown - frostspells, unpaved terrain, etc.
			if("Katar")
				r_hand = /obj/item/rogueweapon/katar/psydon
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			if("Knuckledusters")
				r_hand = /obj/item/rogueweapon/knuckles/psydon
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				ADD_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
			if("Quarterstaff")
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/psy
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				H.change_stat(STATKEY_PER, 1)
				H.change_stat(STATKEY_INT, 1) //Changes statblock from 3/3/3/-2/-1/0 to 3/3/3/-1/-1/1. Note that this comes at the cost of losing the 'critical resistance' trait, and retaining the unarmorable status.
		var/armors = list("Otavan - Heavyweight, Blacksteel Thorns", "Naledian - Lightweight, Arcyne-Martiality")
		var/armor_choice = input(H, "Choose your ARCHETYPE.", "TAKE UP PSYDON'S DUTY.") as anything in armors
		switch(armor_choice)
			if("Otavan - Heavyweight, Blacksteel Thorns")
				head = /obj/item/clothing/head/roguetown/roguehood/psydon
				mask = /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns
				backl = /obj/item/storage/backpack/rogue/satchel/otavan
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				wrists = /obj/item/clothing/wrists/roguetown/bracers/psythorns
				neck = /obj/item/clothing/neck/roguetown/psicross/silver
				id = /obj/item/clothing/ring/signet/silver
			if("Naledian - Lightweight, Arcyne-Martiality")
				head = /obj/item/clothing/head/roguetown/headband/naledi
				mask = /obj/item/clothing/mask/rogue/lordmask/naledi/sojourner
				wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/naledi
				backl = /obj/item/storage/backpack/rogue/satchel/black
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				neck = /obj/item/clothing/neck/roguetown/psicross/g //Naledians covet gold far more than the Orthodoxists cover silver. Emphasizes their nature as 'visitors', more-so than anything else.
				id = /obj/item/clothing/ring/signet
				l_hand = /obj/item/spellbook_unfinished/pre_arcyne
				ADD_TRAIT(H, TRAIT_ARCYNE_T2, TRAIT_GENERIC) //Sojourners are magyck-inclined lightweights, relying on evasive maneuvers and unorthodox techniques - compared to the Disciple, who simply Kills People With Rocks.
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				REMOVE_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 3, TRUE)
				H.grant_language(/datum/language/celestial) //They're from Naledi, they should speak Sama'glos
				H.mind.adjust_spellpoints(6)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fetch) //Pre-set spell list. Same as before. 
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/forcewall) //Weak, destroyable forcewall.
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/message)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/summonrogueweapon/bladeofpsydon)
				H.change_stat(STATKEY_CON, -3) 
				H.change_stat(STATKEY_WIL, -3)
				H.change_stat(STATKEY_INT, 3)
				H.change_stat(STATKEY_SPD, 2) //Turns the Sojourner's unmodified statblock to 3/0/0/1/1, compared to the Disciple's 3/3/3/-2/-1.

	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple
	
	backpack_contents = list(/obj/item/roguekey/inquisition = 1,
	/obj/item/paper/inqslip/arrival/ortho = 1,
	/obj/item/roguegem/amethyst/naledi = 1) //Kept here for now, until we figure out how to make it better fit in overfilled hands.
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
	cloak = /obj/item/clothing/cloak/tabard/psydontabard/alt

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_WEAK, devotion_limit = CLERIC_REQ_1)	//Capped to T2 miracles.
