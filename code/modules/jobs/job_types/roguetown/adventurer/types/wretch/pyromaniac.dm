/datum/advclass/wretch/pyromaniac
	name = "Pyromaniac"
	tutorial = "A notorious arsonist with a penchant for fire, you wield your own personal vendetta against the chaotic forces within Azuria. Bring mayhem and destruction with flame and misfortune! Just... try not to hit yourself with your explosives - you aren't fireproof, after all."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/pyromaniac
	cmode_music = 'sound/music/Iconoclast.ogg'
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ALCHEMY_EXPERT, TRAIT_EXPLOSIVE_SUPPLY)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_INT = 3
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, // RUN BOY RUN
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT, // To escape grapplers, fuck you
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/wretch/pyromaniac/pre_equip(mob/living/carbon/human/H)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff //wear protection :) 
	mask = /obj/item/clothing/mask/rogue/facemask/
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full //Protect your head!
	pants = /obj/item/clothing/under/roguetown/splintlegs
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	r_hand = /obj/item/bomb
	l_hand = /obj/item/bomb
	backpack_contents = list(
		/obj/item/bomb = 2,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/flint = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)
	if(H.mind)
		var/weapons = list("Archery", "Crossbows", "BOMBS", "LET THERE BE FLAME!!!")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Archery")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/quiver/pyroarrows
			if("Crossbows")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 4, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/quiver/pyrobolts
			if("BOMBS") //30 bombs. 18 fire, 4 tnt, 4 impacts, 4 firegas.
				ADD_TRAIT(H, TRAIT_BOMBER_EXPERT, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/craft/engineering, 4, TRUE)
				backr = /obj/item/twstrap/bombstrap/firebomb
				r_hand = /obj/item/twstrap/bombstrap/bomb_and_fire
				l_hand = /obj/item/twstrap/bombstrap/bomb_and_fire
			if("LET THERE BE FLAME!!!")
				H.adjust_skillrank_up_to(/datum/skill/magic/arcane, 2, TRUE)
				backr = /obj/item/rogueweapon/woodstaff/toper
				if(H.mind)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/fireball)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/spitfire)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/rebuke)
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stoneskin) // To not be instapaincritted if you accidentally hit yourself
		wretch_select_bounty(H)
