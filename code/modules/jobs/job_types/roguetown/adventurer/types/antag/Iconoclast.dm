/datum/advclass/iconoclast //Support Cleric, Heavy armor, unarmed, miracles.
	name = "Iconoclast"
	tutorial = "Even the most devout can be swayed towards the darkness, you are the living proof of it. Lead your flock through Her Fyre to their ultimate salvation - in shroud of His greatness."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/bandit/iconoclast
	category_tags = list(CTAG_BANDIT)
	maximum_possible_slots = 1 // We only want one of these.
	traits_applied = list(TRAIT_RITUALIST)
	subclass_stats = list(
		STATKEY_STR = 2, // Less wrestling, besides got equalize for cap
		STATKEY_CON = 2,
		STATKEY_WIL = 4, // This is our Go Big stat, we want lots of stamina for miracles and WRASSLIN.
		STATKEY_LCK = 2, //We have a total of +12 in stats. 
	)
	subclass_skills = list(
		/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/holy, SKILL_LEVEL_MASTER,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, // We can substitute for a sawbones, but aren't as good and dont have access to surgical tools
		/datum/skill/misc/athletics = SKILL_LEVEL_LEGENDARY, //We are the True Mathlete
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
	)
	cmode_music = 'sound/music/Iconoclast.ogg'

/datum/outfit/job/roguetown/bandit/iconoclast/pre_equip(mob/living/carbon/human/H)
	..()
	if (!(istype(H.patron, /datum/patron/inhumen/matthios)))	//This is the only class that forces Matthios. Needed for miracles + limited slot.
		to_chat(H, span_warning("Matthios embraces me.. I will uphold His creed.. for I carry His fyre."))
		H.set_patron(/datum/patron/inhumen/matthios)
	r_hand = /obj/item/rogueweapon/woodstaff
	mask = /obj/item/clothing/head/roguetown/roguehood
	neck = /obj/item/clothing/neck/roguetown/coif/padded
	wrists = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
	gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/katar
	backl = /obj/item/storage/backpack/rogue/satchel
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	backpack_contents = list(
					/obj/item/needle/thorn = 1,
					/obj/item/natural/cloth = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/ritechalk = 1,
					)
	id = /obj/item/mattcoin
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)	//Starts off maxed out.
	var/specialization = list("Ecclesiarch","Gilded Monk")
	if(H.mind)
		var/specialization_choice = input(H, "Choose your specialization.", "SPECIALIZATION") as anything in specialization
		H.set_blindness(0)
		switch(specialization_choice)
			if("Ecclesiarch")//John Heretic with Big Flail in your area.
				head = /obj/item/clothing/head/roguetown/helmet/kettle
				armor = /obj/item/clothing/suit/roguetown/armor/plate
				shirt = /obj/item/clothing/suit/roguetown/shirt/robe/monk
				ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Gilded Monk")//No one hears a word they say
				head = /obj/item/clothing/head/roguetown/headband/monk
				armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/iconoclast
				shirt = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)//Has the memory gone? Are you feelin' numb?
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_LEGENDARY, TRUE)//Not a word they say
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_MASTER, TRUE)//But a voiceless crowd isn't backin' down		
				H.change_stat(STATKEY_CON, 2)//When the air turns red
				H.change_stat(STATKEY_LCK, -2)//With a loaded hesitation
				//Can you say my name?
				//Has the memory gone? Are you feelin' numb?
				//Have we all become invisible?
