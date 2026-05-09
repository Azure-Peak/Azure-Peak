/datum/job/roguetown/bogmaster //Half-competent idiot trainer, for the militia, handles recruitment and protection of the bog
	title = "Bogmaster"
	flag = LEVY
	department_flag = LEVY
	faction = "Station"
	total_positions = 1 //THERE CAN BE ONLY ONE
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD) //SOVL
	tutorial = "You're the most experienced idiot to be conscripted onto the Crown's militia and survive long enough to be put in charge of an understaffed, underfunded garrison overwatching the terrorbogs. Some might call you thugs, other might compare you to brigands, \
				either way they wouldn't be entirely wrong, you report to the Balliff and the Marshal begrudgingly. Your job is to ensure no levy falls out of line, train those in need of talent to fight and ensure the bogs are safe."
	display_order = JDO_BOGGUARD
	selection_color = JCOLOR_BOGGUARD
	whitelist_req = TRUE
	round_contrib_points = 2

	spells = list(
		/obj/effect/proc_holder/spell/self/convertrole/bog
	)

	outfit = /datum/outfit/job/roguetown/bogguard
	advclass_cat_rolls = list(CTAG_BOGMASTER = 20)

	give_bank_account = TRUE
	min_pq = 6 //You need to be semi competent instead of a total VIVA LA REVOLUTION meme. As well as be able to actually lead and teach players.
	max_pq = null
	job_traits = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED) //Bare minimal, they're able to wear armor, they're hardened from age.
	cmode_music = 'sound/music/combat_bog.ogg'
	job_subclasses = list(
		/datum/advclass/bogmaster/bogmaster
	)

/datum/outfit/job/datum/advclass/bogmaster
	job_bitflag = BITFLAG_GARRISON //Actually a competent fighter, not just a complete dumbass

/datum/advclass/bogmaster/bogmaster
	name = "Bogmaster"
	tutorial = "You've known these bogs as long as you've lived, in charge of a small levy force, you report to the Bailiff and the Marshal. Your job is to ensure no levy falls out of line, train those in need of talent to fight and to ensure the bogs are safe."
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD) //SOVL. Intended.
	//Reworked and brought back as a knockoff vet, unlike vet who's the more elite pricer person who knows what they're doing. You my friend are just the smartest town idiot they throw at the townsfolk for training.
	outfit = /datum/outfit/job/roguetown/bogmaster/bogmaster
	category_tags = list(CTAG_BOGMASTER)
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_STR = 2, //A bit more of a fight than your average levy.
		STATKEY_WIL = 1, //+ 1 from middle aged.
		STATKEY_PER = 1,
		STATKEY_INT = -1 //You're still an idiot, sire. BOG! BOG! BOG!
		//No speed loss, since you have -1 from middle aged
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT, //We always want to be able to train people to journeyman
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE, //Sovl, but I don't want mounted knight lite.
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE, //So you can at least attempt to help stabilise advs from dying.
	)

/datum/job/roguetown/bogmaster/bogmaster/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/stabard/bog))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "bog master tabard ([index])"

/datum/outfit/job/roguetown/bogmaster/bogmaster/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron //Sovl Nuke
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	mask = /obj/item/clothing/head/roguetown/armingcap
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	hand_r = /obj/item/rogueweapon/sword //SOVL
	backpack_contents = list(
		/obj/item/needle/thorn = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		)

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Flail & Shield","Axe & Shield", "Sword & Shield","Arming Sword & Crossbow")	//Bit more unique than footsman, you are a jack-of-all-trades + slightly more 'elite'.
		var/weapon_choice = input(H, "Choose your weapon.", "FOR THE BOG!") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Flail & Shield")	//Plus a steel flail; it lacks the mace sovl but its whatever
				beltr = /obj/item/rogueweapon/mace/cudgel
				beltl = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower //Sovl
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
			if("Axe & Shield")	//Steel Axe - basically exact same as MAA almost. Has it's niche for construct + combat build
				beltr = /obj/item/rogueweapon/mace/cudgel
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/tower //Sovl
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			if("Sword & Shield")	//Steel Shortsword + tower shield, not quite sovl but close.
				beltr = /obj/item/rogueweapon/mace/cudgel
				beltl = /obj/item/rogueweapon/sword
				backl = /obj/item/rogueweapon/shield/tower //Sovl
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE)
			if("Arming Sword & Crossbow")	//Arming Sword + Crossbow - Kind of hybrid fighter build; sovl shortsword and a crossbow.
				beltl = /obj/item/quiver/bolt/standard
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				r_hand = /obj/item/rogueweapon/sword
				l_hand = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE)

	if(H.dna?.species)
		H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.real_name = "Bogmaster [prev_real_name]"
	H.name = "Bogmaster [prev_name]"

	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_DESTITUTE, H)

/obj/effect/proc_holder/spell/self/convertrole/bog //Lets them potentally antagonise a little, by forming their own private army out of a mob and possibly attempting a coup
	name = "Recruit Levy"
	new_role = "Levy"
	recruitment_faction = "Bog Guard"
	recruitment_message = "Serve the bog, %RECRUIT!" //I was going to change but I'm sorry, its perfect already.
	accept_message = "FOR THE BOG!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/bog/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	recruit.verbs |= /mob/proc/haltyell
