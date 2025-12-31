/datum/job/roguetown/captain
	title = "Knight Captain" //The Knight Captain is clearly not drawn from the ranks of guardsmen, or sergeants. They're drawn from the Knightly ranks and should be treated as such.
	flag = GUARD_CAPTAIN
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_races = RACES_NO_CONSTRUCT
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "Your lineage is noble, and generations of strong, loyal knights have come before you. You served your time \
	gracefully as knight of his royal majesty, and now you've grown into a role which many men can only dream of becoming. \
	Veteran among knights, you lead the crown's knights to battle and organize the training squires. Obey the Marshal and the Crown. \
	Lead your men to victory--and keep them in line--and you will see this realm prosper under a thousand suns."
	display_order = JDO_GUARD_CAPTAIN
	advclass_cat_rolls = list(CTAG_CAPTAIN = 20)

	spells = list(/obj/effect/proc_holder/spell/self/convertrole/guard)
	outfit = /datum/outfit/job/roguetown/captain

	give_bank_account = TRUE
	noble_income = 16
	min_pq = 9
	max_pq = null
	round_contrib_points = 3
	cmode_music = 'sound/music/combat_knight.ogg'
	job_traits = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_NOBLE, TRAIT_GUARDSMAN)
	job_subclasses = list(
		/datum/advclass/captain/infantry
	)

/datum/outfit/job/roguetown/captain
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	id = /obj/item/scomstone/garrison
	job_bitflag = BITFLAG_ROYALTY | BITFLAG_GARRISON

/datum/job/roguetown/captain/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/knight/guard)  || (istype(H.cloak, /obj/item/clothing/cloak/captain)))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "Captain Tabard ([index])" //This doesn't even actually work but you know.
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Ser"
		if(should_wear_femme_clothes(H))
			honorary = "Dame"
		// check if they already have it to avoid stacking titles
		if(findtextEx(H.real_name, "[honorary] ") == 0)
			H.real_name = "[honorary] [prev_real_name]"
			H.name = "[honorary] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)

/datum/advclass/captain/infantry
	name = "Knight Captain"
	tutorial = "You've fought shoulder to shoulder with the realm's worthiest Knights while embedded directly within \
	massed infantry formations. As a peerless armed combatant and tactician both, you are a formidable presence \
	on any battlefield."
	outfit = /datum/outfit/job/roguetown/captain/infantry
	category_tags = list(CTAG_CAPTAIN)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "This class gains Master skill in their weapon of choice."

/datum/outfit/job/roguetown/captain/infantry/pre_equip(mob/living/carbon/human/H)
	..()
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/storage/keyring/sheriff = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= list(
		/mob/living/carbon/human/proc/request_outlaw,
		/mob/proc/haltyell,
		/mob/living/carbon/human/mind/proc/setorders
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_RICH, H, "Savings.")
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list(
			"Edict & Aegis (Sabre & Buckler)",
			"Claymore",
			"Great Mace",
			"Battle Axe",
			"Greataxe",
			"Estoc",
			"Longsword",
			"Flail",
			"Sabre",
			"Lance",
			)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Edict & Aegis (Sabre & Buckler)")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/knightcaptain
				l_hand = /obj/item/rogueweapon/shield/buckler/knightcaptain
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Claymore")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
				r_hand = /obj/item/rogueweapon/greatsword/zwei
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Greataxe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 5, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Estoc")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Battle Axe")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 5, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
			if("Great Mace")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 5, TRUE)
				r_hand = /obj/item/rogueweapon/mace/goden/steel
			if("Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Flail")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 5, TRUE)
				beltr = /obj/item/rogueweapon/flail/sflail
			if("Sabre")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 5, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
			if("Lance")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 5, TRUE)
				r_hand = /obj/item/rogueweapon/spear/lance
		if(weapon_choice in list("Battle Axe", "Great Mace", "Longsword", "Flail", "Sabre", "Lance"))
			var/secondary = list(
				"Kite Shield",
				"Crossbow",
				"Recurve Bow",
			)
			var/secondary_choice = input(H, "Choose your secondary.", "TAKE UP ARMS") as anything in secondary
			switch(secondary_choice)
				if("Kite Shield")
					backl = /obj/item/rogueweapon/shield/tower/metal
				if("Crossbow")
					H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 4, TRUE)
					backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
					beltl = /obj/item/quiver/bolts
				if("Recurve Bow")
					H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
					beltl = /obj/item/quiver/arrows
					backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve

		var/armors = list(
			"Brigandine",
			"Coat of Plates",
			"Steel Cuirass",
			"Captain's armor"
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		switch(armorchoice)
			if("Brigandine")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/retinue
				pants = /obj/item/clothing/under/roguetown/chainlegs
				cloak = /obj/item/clothing/cloak/tabard/retinue/captain
			if("Coat of Plates")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates
				pants = /obj/item/clothing/under/roguetown/chainlegs
				cloak = /obj/item/clothing/cloak/tabard/retinue/captain
			if("Fluted Cuirass")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
				pants = /obj/item/clothing/under/roguetown/chainlegs
				cloak = /obj/item/clothing/cloak/tabard/retinue/captain
			if("Captain's armor")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/captain
				pants = /obj/item/clothing/under/roguetown/chainlegs/captain
				head = /obj/item/clothing/head/roguetown/helmet/heavy/captain
				cloak = /obj/item/clothing/cloak/captain

		if(armorchoice == "Captain's armor")
			return // Get helmet from armor selection

		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

/obj/effect/proc_holder/spell/self/convertrole
	name = "Recruit Beggar"
	desc = "Recruit someone to your cause."
	overlay_state = "recruit_bog"
	antimagic_allowed = TRUE
	recharge_time = 100
	/// Role given if recruitment is accepted
	var/new_role = "Beggar"
	/// Faction shown to the user in the recruitment prompt
	var/recruitment_faction = "Beggars"
	/// Message the recruiter gives
	var/recruitment_message = "Serve the beggars, %RECRUIT!"
	/// Range to search for potential recruits
	var/recruitment_range = 3
	/// Say message when the recruit accepts
	var/accept_message = "I will serve!"
	/// Say message when the recruit refuses
	var/refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/cast(list/targets,mob/user = usr)
	. = ..()
	var/list/recruitment = list()
	for(var/mob/living/carbon/human/recruit in (get_hearers_in_view(recruitment_range, user) - user))
		//not allowed
		if(!can_convert(recruit))
			continue
		recruitment[recruit.name] = recruit
	if(!length(recruitment))
		to_chat(user, span_warning("There are no potential recruits in range."))
		return
	var/inputty = input(user, "Select a potential recruit!", "[name]") as anything in recruitment
	if(inputty)
		var/mob/living/carbon/human/recruit = recruitment[inputty]
		if(!QDELETED(recruit) && (recruit in get_hearers_in_view(recruitment_range, user)))
			INVOKE_ASYNC(src, PROC_REF(convert), recruit, user)
		else
			to_chat(user, span_warning("Recruitment failed!"))
	else
		to_chat(user, span_warning("Recruitment cancelled."))

/obj/effect/proc_holder/spell/self/convertrole/proc/can_convert(mob/living/carbon/human/recruit)
	//wtf
	if(QDELETED(recruit))
		return FALSE
	//need a mind
	if(!recruit.mind)
		return FALSE
	//only migrants and peasants
	if(!(recruit.job in GLOB.peasant_positions) && \
		!(recruit.job in GLOB.yeoman_positions) && \
		!(recruit.job in GLOB.wanderer_positions))
		return FALSE
	//need to see their damn face
	if(!recruit.get_face_name(null))
		return FALSE
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/proc/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(QDELETED(recruit) || QDELETED(recruiter))
		return FALSE
	recruiter.say(replacetext(recruitment_message, "%RECRUIT", "[recruit]"), forced = "[name]")
	var/prompt = alert(recruit, "Do you wish to become a [new_role]?", "[recruitment_faction] Recruitment", "Yes", "No")
	if(QDELETED(recruit) || QDELETED(recruiter) || !(recruiter in get_hearers_in_view(recruitment_range, recruit)))
		return FALSE
	if(prompt != "Yes")
		if(refuse_message)
			recruit.say(refuse_message, forced = "[name]")
		return FALSE
	if(accept_message)
		recruit.say(accept_message, forced = "[name]")
	if(new_role)
		recruit.job = new_role
		SEND_SIGNAL(SSdcs, COMSIG_GLOB_ROLE_CONVERTED, recruiter, recruit, new_role)
	return TRUE

/obj/effect/proc_holder/spell/self/convertrole/guard
	name = "Recruit Guardsmen"
	new_role = "Watchman"
	overlay_state = "recruit_guard"
	recruitment_faction = "Watchman"
	recruitment_message = "Serve the town guard, %RECRUIT!"
	accept_message = "FOR THE CROWN!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/guard/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	. = ..()
	if(!.)
		return
	recruit.verbs |= /mob/proc/haltyell
