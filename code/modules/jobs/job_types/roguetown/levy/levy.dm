/datum/job/roguetown/bogguard //Half-competent idiots, unlike wardens/garrison. they're complete underpaid, undertrained idiots that barely know what they're doing.
	title = "Bog Guard"
	flag = LEVY
	department_flag = LEVY
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "When the bailiff came to your household it was the worst dae of your lyfe, dragging you away into service to the Crown with nothing more but whatever household object you managed to piece together into a weapon. \
				Safeguard your home from the terrors beyond the gates of the bog and those foolish enough to venture further into the terrorbog. You answer to the bogmaster, the smartest idiot out of all of you."
	display_order = JDO_BOGGUARD
	selection_color = JCOLOR_BOGGUARD
	whitelist_req = TRUE
	round_contrib_points = 2


	outfit = /datum/outfit/job/roguetown/bogguard
	advclass_cat_rolls = list(CTAG_LEVY = 20)

	give_bank_account = TRUE
	min_pq = 1 //Incompetency is kind of sovl for this role, you're literally a trained idiot with a weapon. We want people to sort of know esc though, not first round role.
	max_pq = null
	job_traits = list(TRAIT_HOMESTEAD_EXPERT) //Bare minimal, they're able to homestead. They're just militiamen, not trained or hardened soldiers.
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	job_subclasses = list(
		/datum/advclass/bogguard/boglevy
	)

/datum/outfit/job/roguetown/bogguard
	job_bitflag = BITFLAG_HALF_COMBATANT //Likely to be pulled in once all-else fails. You're not a true combatant though, too slow, dumb and untrained to be.

/datum/advclass/bogguard/boglevy
	name = "Bog Levy"
	tutorial = "You're one of many before you, a member of the Bog Guard, the Crown's woefully underpaid militiamen. You have a roof over your head, sometimes you have coin in your pocket, and a thankless job protecting the bog from bandits, deadites and whatever other horrors lie within."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/bogguard/boglevy
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_LEVY)
	townie_contract_gate_exempt = TRUE //Sure I guess
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_STR = 2,
		STATKEY_WIL = 2, //buffed up, you're an actual faction now.
		STATKEY_INT = -1, //BOG! BOG! BOG!
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE, //Barely literate
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE, //So you can at least attempt to (horribly fail) help stabilise advs from dying.
	)

/datum/job/roguetown/bogguard/boglevy/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
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
			S.name = "bog tabard ([index])"

/datum/outfit/job/roguetown/bogguard/boglevy/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/head/roguetown/armingcap
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/bog
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/needle/thorn = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		)

	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		var/weapons = list("MINE PITCHFORK","MINE THRESHER", "THE FAMILY SWORD", "MINE SHOVEL")
		var/weapon_choice = input(H, "Choose your improvised weapon.", "WHAT DID YOU TAKE FROM YOUR HOME?") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("MINE PITCHFORK")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/militia
			if("MINE THRESHER")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/militia
			if ("THE FAMILY SWORD")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/falchion/militia
			if ("MINE SHOVEL")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/militia
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_DESTITUTE, H)

/datum/advclass/bogmaster
	name = "Bogmaster"
	tutorial = "You are the most experienced idiot to be conscripted to the service of the Crown milita... What a mistake that was. You report to the Bailiff and the Marshal. Your job is to ensure no levy falls out of line, train those in need of talent to fight and to ensure the bogs are safe."
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_MIDDLEAGED, AGE_OLD) //SOVL. Intended.
	//Reworked and brought back as a knockoff vet, unlike vet who's the more elite pricer person who knows what they're doing. You my friend are just the smartest town idiot they throw at the townsfolk for training.
	outfit = /datum/outfit/job/roguetown/adventurer/bogmaster
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED , TRAIT_GOODTRAINER) //The gag here is journeyman skills, but you sort of act as a stand-in levy trainer that towners/adventurers seek out.
	//This class is NOT intended to get homesteader, you're trading skills for armor training. You are kind of the town's milita trainer.
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	category_tags = list(CTAG_TOWNER)
	townie_contract_gate_exempt = TRUE
	maximum_possible_slots = 1 //THERE CAN BE ONLY ONE (Also one of the stronger towners that isn't witch)
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_STR = 2, //Slightly more of a fight than your average levy, they're still a towner, don't expect anything amazing.
		STATKEY_WIL = 2,
		STATKEY_INT = -1, //You're still an idiot, sire. BOG! BOG! BOG!
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE, //You're still not going to compete with the town guard
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

/datum/job/roguetown/adventurer/bogmaster/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
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

/datum/outfit/job/roguetown/adventurer/bogmaster/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron //Sovl
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	mask = /obj/item/clothing/head/roguetown/armingcap
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	backl = /obj/item/rogueweapon/shield/tower
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/needle/thorn = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		)

	if(H.dna?.species)
		H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		var/weapons = list("MINE PITCHFORK","MINE THRESHER", "THE FAMILY SWORD", "MINE SHOVEL")
		var/weapon_choice = input(H, "Choose your improvised weapon.", "WHAT DID YOU TAKE FROM YOUR HOME?") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("MINE PITCHFORK")
				r_hand = /obj/item/rogueweapon/spear/militia
			if("MINE THRESHER")
				r_hand = /obj/item/rogueweapon/flail/militia
			if ("THE FAMILY SWORD")
				r_hand = /obj/item/rogueweapon/sword/falchion/militia
			if ("MINE SHOVEL")
				r_hand = /obj/item/rogueweapon/mace
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
