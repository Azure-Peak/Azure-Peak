/datum/job/roguetown/sergeant
	title = "Sergeant"
	flag = SERGEANT
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "You are the most experienced of the Crown's Soldiery, leading the men-at-arms in maintaining order and attending to threats and crimes below the court's attention. \
				See to those under your command and fill in the gaps knights leave in their wake. Obey the orders of your Marshal and the Crown."
	display_order = JDO_SERGEANT
	whitelist_req = TRUE
	round_contrib_points = 3


	outfit = /datum/outfit/job/roguetown/sergeant
	advclass_cat_rolls = list(CTAG_SERGEANT = 20)

	give_bank_account = TRUE
	min_pq = 6
	max_pq = null
	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	job_subclasses = list(
		/datum/advclass/sergeant/sergeant
	)

/datum/outfit/job/roguetown/sergeant
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/sergeant/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(ishuman(L))
			if(istype(H.cloak, /obj/item/clothing/cloak/tabard/stabard/surcoat/guard))
				var/obj/item/clothing/S = H.cloak
				var/index = findtext(H.real_name, " ")
				if(index)
					index = copytext(H.real_name, 1,index)
				if(!index)
					index = H.real_name
				S.name = "sergeant jupon ([index])"

//All skills/traits are on the loadouts. All are identical. Welcome to the stupid way we have to make sub-classes...
/datum/outfit/job/roguetown/sergeant
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/guard
	neck = /obj/item/clothing/neck/roguetown/gorget
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	belt = /obj/item/storage/belt/rogue/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	id = /obj/item/scomstone/garrison

//Rare-ish anti-armor two hander sword. Kinda alternative of a bastard sword type. Could be cool.
/datum/advclass/sergeant/sergeant
	name = "Sergeant-at-Arms"
	tutorial = "You are a not just anybody but the Sergeant-at-Arms of the Duchy's garrison. While you may have started as some peasant or mercenary, you have advanced through the ranks to that of someone who commands respect and wields it. Take up arms, sergeant!"
	outfit = /datum/outfit/job/roguetown/sergeant/sergeant

	category_tags = list(CTAG_SERGEANT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1, //Gets bow-skills, so give a SMALL tad of perception to aid in bow draw.
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,	// We are basically identical to a regular MAA, except having better athletics to help us manage our order usage better
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT, //John Athlete apparently
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,	//Decent tracking akin to Skirmisher.
	)

/datum/outfit/job/roguetown/sergeant/sergeant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/guard) // We'll just use Watchmen as sorta conscripts yeag?
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardsergeant = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Rhomphaia","Flail & Shield","Halberd","Sabre & Crossbow")	//Bit more unique than footsman, you are a jack-of-all-trades + slightly more 'elite'.
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Rhomphaia")			//Rare-ish anti-armor two hander sword. Kinda alternative of a bastard sword type. Could be cool.
				backl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/long/rhomphaia
				beltr = /obj/item/rogueweapon/mace/cudgel
			if("Flail & Shield")	//Tower-shield, higher durability wood shield w/ more coverage. Plus a steel flail; maybe.. less broken that a steel mace?
				beltr = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
			if("Halberd")			//Halberd - basically exact same as MAA. It's a really valid build. Spear thrust + sword chop + bash.
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/mace/cudgel
			if("Sabre & Crossbow")	//Versetile skirmisher class. Considered other swords but sabre felt best without being too strong. (This one gets no cudgel, no space.)
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				r_hand = /obj/item/rogueweapon/sword/sabre
				l_hand = /obj/item/rogueweapon/scabbard/sword

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Scalemail"	= /obj/item/clothing/suit/roguetown/armor/plate/scale,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")

/obj/effect/proc_holder/spell/invoked/order
	name = ""
	range = 1
	associated_skill = /datum/skill/misc/athletics
	devotion_cost = 0
	chargedrain = 1
	chargetime = 15
	releasedrain = 80 // This is quite costy. Shouldn't be able to really spam them right off the cuff, combined with having to type out an order. Should prevent VERY occupied officers from ALSO ordering
	recharge_time = 2 MINUTES
	miracle = FALSE
	sound = 'sound/magic/inspire_02.ogg'


/obj/effect/proc_holder/spell/invoked/order/movemovemove
	name = "Move! Move! Move!"
	desc = "Orders your underlings to move faster. +5 Speed."
	overlay_state = "movemovemove"

/obj/effect/proc_holder/spell/invoked/order/movemovemove/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.movemovemovetext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Sergeant")
			if(!(target.job in list("Man at Arms", "Watchman")))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				revert_cast()
				return
		if(user.job == "Knight Captain")
			if(!(target.job in list("Knight", "Squire")))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				revert_cast()
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			revert_cast()
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/movemovemove)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/movemovemove/nextmove_modifier()
	return 0.85

/datum/status_effect/buff/order/movemovemove
	id = "movemovemove"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/movemovemove
	effectedstats = list(STATKEY_SPD = 5)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/movemovemove
	name = "Move! Move! Move!"
	desc = "My officer has ordered me to move quickly!"
	icon_state = "buff"

/datum/status_effect/buff/order/movemovemove/on_apply()
	. = ..()
	to_chat(owner, span_blue("My officer orders me to move!"))

/obj/effect/proc_holder/spell/invoked/order/takeaim
	name = "Take aim!"
	desc = "Orders your underlings to be more precise. +5 Perception."
	overlay_state = "takeaim"

/datum/status_effect/buff/order/takeaim
	id = "takeaim"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/takeaim
	effectedstats = list(STATKEY_PER = 5)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/takeaim
	name = "Take aim!"
	desc = "My officer has ordered me to take aim!"
	icon_state = "buff"

/datum/status_effect/buff/order/takeaim/on_apply()
	. = ..()
	to_chat(owner, span_blue("My officer orders me to take aim!"))

/obj/effect/proc_holder/spell/invoked/order/takeaim/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.takeaimtext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Sergeant")
			if(!(target.job in list("Man at Arms", "Watchman")))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				revert_cast()
				return
		if(user.job == "Knight Captain")
			if(!(target.job in list("Knight", "Squire")))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				revert_cast()
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			revert_cast()
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/takeaim)
		return TRUE
	revert_cast()
	return FALSE



/obj/effect/proc_holder/spell/invoked/order/onfeet
	name = "On your feet!"
	desc = "Orders your underlings to stand up."
	overlay_state = "onfeet"

/obj/effect/proc_holder/spell/invoked/order/onfeet/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.onfeettext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Sergeant")
			if(!(target.job in list("Man at Arms", "Watchman")))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				revert_cast()
				return
		if(user.job == "Knight Captain")
			if(!(target.job in list("Knight", "Squire")))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				revert_cast()
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			revert_cast()
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/onfeet)
		if(!(target.mobility_flags & MOBILITY_STAND))
			target.SetUnconscious(0)
			target.SetSleeping(0)
			target.SetParalyzed(0)
			target.SetImmobilized(0)
			target.SetStun(0)
			target.SetKnockdown(0)
			target.set_resting(FALSE)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/onfeet
	id = "onfeet"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/onfeet
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/order/onfeet
	name = "On your feet!"
	desc = "My officer has ordered me to my feet!"
	icon_state = "buff"

/datum/status_effect/buff/order/onfeet/on_apply()
	. = ..()
	to_chat(owner, span_blue("My officer orders me to my feet!"))
	ADD_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)

/datum/status_effect/buff/order/onfeet/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, TRAIT_GENERIC)
	. = ..()


/obj/effect/proc_holder/spell/invoked/order/hold
	name = "Hold!"
	desc = "Orders your underlings to Endure. +2 Willpower and Constitution."
	overlay_state = "hold"


/obj/effect/proc_holder/spell/invoked/order/hold/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.holdtext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Sergeant")
			if(!(target.job in list("Man at Arms", "Watchman")))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				revert_cast()
				return
		if(user.job == "Knight Captain")
			if(!(target.job in list("Knight", "Squire")))
				to_chat(user, span_alert("I cannot order one not of my ranks!"))
				revert_cast()
				return
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			revert_cast()
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/hold)
		return TRUE
	revert_cast()
	return FALSE


/datum/status_effect/buff/order/hold
	id = "hold"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/hold
	effectedstats = list(STATKEY_WIL = 2, STATKEY_CON = 2)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/hold
	name = "Hold!"
	desc = "My officer has ordered me to hold!"
	icon_state = "buff"

/datum/status_effect/buff/order/hold/on_apply()
	. = ..()
	to_chat(owner, span_blue("My officer orders me to hold!"))


/mob/living/carbon/human/mind/proc/setorders()
	set name = "Rehearse Orders"
	set category = "Voice of Command"
	mind.movemovemovetext = input("Send a message.", "Move! Move! Move!") as text|null
	if(!mind.movemovemovetext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.holdtext = input("Send a message.", "Hold!") as text|null
	if(!mind.holdtext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.takeaimtext = input("Send a message.", "Take aim!") as text|null
	if(!mind.takeaimtext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.onfeettext = input("Send a message.", "On your feet!") as text|null
	if(!mind.onfeettext)
		to_chat(src, "I must rehearse something for this order...")
		return
