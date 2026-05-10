/datum/job/roguetown/bogmaster //Half-competent idiot trainer, for the militia, handles recruitment and protection of the bog
	title = "Bogmaster"
	flag = BOGMASTER
	department_flag = LEVY
	faction = "Station"
	total_positions = 1 //THERE CAN BE ONLY ONE
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD) //Sovl, also intended. You've lived long enough to see the crown isn't exactly perfect.
	tutorial = "You're the most experienced idiot to be conscripted onto the Crown's militia and survive long enough to be put in charge of an understaffed, underfunded garrison overwatching the terrorbogs. \
				Some might call you thugs, other might compare you to brigands, either way they wouldn't be entirely wrong. Your job is to protect the terrorbogs from threats and deal with the ever-growing number \
				of banditry and monsters within. Your loyalty to the crown is loose, they've lent you a roof over your head, some coin in your pocket but little else."
	display_order = JDO_BOGMASTER
	selection_color = JCOLOR_LEVY
	whitelist_req = TRUE
	round_contrib_points = 3

	spells = list(
		/obj/effect/proc_holder/spell/self/convertrole/bog
	)

	outfit = /datum/outfit/job/roguetown/bogmaster
	advclass_cat_rolls = list(CTAG_BOGMASTER = 20)

	give_bank_account = TRUE
	min_pq = 6 //You need to be semi competent instead of a total VIVA LA REVOLUTION meme. As well as be able to actually lead and teach players.
	max_pq = null
	job_traits = list(TRAIT_MEDIUMARMOR, TRAIT_BOGLEVY, TRAIT_STEELHEARTED) //Bare minimal, they're able to wear armor, they're hardened from age.
	cmode_music = 'sound/music/combat_bog.ogg'
	job_subclasses = list(
		/datum/advclass/bogmaster/bogmaster
	)

/datum/outfit/job/roguetown/bogmaster
	job_bitflag = BITFLAG_GARRISON //Likely to be pulled in once all-else fails. You're unlikely to be outside of bog though, you have no houndstone or whatever unlike wardens. You're also very loosely loyal to the crown, they pay you less than wardens.

/datum/outfit/job/roguetown/bogmaster
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog

/datum/job/roguetown/bogmaster/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
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
			S.name = "bogman surcoat ([index])"

/datum/advclass/bogmaster/bogmaster
	name = "Bogmaster"
	tutorial = "You've known these bogs as long as you've lived, in charge of a small levy force, you report to the Bailiff and the Marshal. Your job is to ensure no levy falls out of line, train those in need of talent to fight and to ensure the bogs are safe."
	allowed_sexes = list(MALE, FEMALE)
	//Reworked and brought back as a knockoff vet, unlike vet who's the more elite pricer person who knows what they're doing. You my friend are just the smartest town idiot they throw at the townsfolk for training.
	outfit = /datum/outfit/job/roguetown/bogmaster/bogmaster
	category_tags = list(CTAG_BOGMASTER)
	subclass_stats = list( //5 weighted statline
		STATKEY_CON = 1,
		STATKEY_STR = 2, //A bit more of a fight than your average levy.
		STATKEY_WIL = 2, //+ 1 from middle aged. Total of +4 in the bogs, granted you are a faction leader this is fine.
		STATKEY_PER = 1,
		STATKEY_INT = -1 //You're still an idiot, sire. BOG! BOG! BOG!
		//No speed loss, since you have -1 from middle aged
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT, //Your fighting style, nearly-always involves a shield
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
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN, //Leader role, might as well be competent trying to track people in this hell of a bog.
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE, //So you can at least attempt to help stabilise advs from dying.
	)

/datum/outfit/job/roguetown/bogmaster/bogmaster/pre_equip(mob/living/carbon/human/H) //Only one who can actually afford steel gear.
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored //Sovl Nuke
	neck = /obj/item/clothing/neck/roguetown/bevor
	mask = /obj/item/clothing/head/roguetown/armingcap
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/scomstone/bad/garrison //You technically deal with bandits/criminals, but you're loose like the wardens.
	backpack_contents = list(
		/obj/item/needle/thorn = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/storage/keyring/bogmaster = 1,
		/obj/item/rope/chain = 1, //Actual-albeit-loose "Garrison"
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		)

	var/prev_real_name = H.real_name
	var/prev_name = H.name
	H.real_name = "Bogmaster [prev_real_name]"
	H.name = "Bogmaster [prev_name]"

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
				beltr = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 5, TRUE)

	if(H.dna?.species)
		H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_DESTITUTE, H)

/obj/effect/proc_holder/spell/self/convertrole/bog //Recruitment for bogmen, note the bogmaster is intended to be able to recruit. They're loose enough under the crown they don't always follow orders...
	name = "Recruit Bog Guard"
	new_role = "Bog Guard"
	recruitment_faction = "Bog Guard"
	recruitment_message = "Serve the bog, %RECRUIT!" //I was going to change but I'm sorry, its perfect already.
	accept_message = "FOR THE BOG!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/bog/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	recruit.verbs |= /mob/proc/haltyell
