/datum/advclass/wretch/deserter
	name = "Disgraced Knight"
	tutorial = "You were once a venerated and revered knight - now, a traitor who abandoned your liege. You lyve the lyfe of an outlaw, shunned and looked down upon by society."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/deserter
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE)
	maximum_possible_slots = 2 //Ideal role for fraggers. Better to limit it. 
	
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg' // same as new hedgeknight music
	// Deserter are the knight-equivalence. They get a balanced, straightforward 2 2 3 statspread to endure and overcome.
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 2,
		STATKEY_STR = 2
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)
/datum/outfit/job/roguetown/wretch/deserter/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You were once a venerated and revered knight - now, a traitor who abandoned your liege. You lyve the lyfe of an outlaw, shunned and looked down upon by society."))
	H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
	H.verbs |= list(/mob/living/carbon/human/mind/proc/setorderswretch)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/brotherhood)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)

		var/weapons = list(
			"Estoc",
			"Mace + Shield",
			"Flail + Shield",
			"Longsword + Shield", 
			"Lucerne",
			"Battle Axe",
			"Lance + Kite Shield",
			"Samshir",
			"Ssangsudo",
			"Shashka + Shield",
		)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Estoc")
				r_hand = /obj/item/rogueweapon/estoc
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Longsword + Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("Mace + Shield")
				beltr = /obj/item/rogueweapon/mace/steel
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("Flail + Shield")
				beltr = /obj/item/rogueweapon/flail/sflail
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("Lucerne")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Battle Axe")
				backr = /obj/item/rogueweapon/stoneaxe/battle
			if("Lance + Kite Shield")
				r_hand = /obj/item/rogueweapon/spear/lance
				backr = /obj/item/rogueweapon/shield/tower/metal
			if("Samshir")
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Ssangsudo")
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/noparry
			if("Shashka + Shield")
				r_hand = /obj/item/rogueweapon/sword/sabre/steppesman
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/iron/steppesman
		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"Kulah Khud"	= /obj/item/clothing/head/roguetown/helmet/sallet/raneshen,
			"Kabuto"	= /obj/item/clothing/head/roguetown/helmet/heavy/kabuto, //No mask, fuck you
			"Shishak"	= /obj/item/clothing/head/roguetown/helmet/sallet/shishak,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,				
			"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
			"Lamellar Scalemail"		= /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe,
			"Haraate Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/haraate,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]
		wretch_select_bounty(H)
	gloves = /obj/item/clothing/gloves/roguetown/plate 
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel //gwstraps landing on backr asyncs with backpack_contents
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)



/datum/advclass/wretch/deserter/maa
	name = "Disgraced Man at Arms"
	tutorial = "You had your post. You had your duty. Dissatisfied, lacking in morale, or simply thinking yourself better than it. - You decided to walk. Now it follows you everywhere you go."
	outfit = /datum/outfit/job/roguetown/wretch/desertermaa
	maximum_possible_slots = 2 //Ideal role for fraggers. Better to limit it. 
	
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg' // same as new hedgeknight music
	// Slightly more rounded. These can be nudged as needed.
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, // Better at climbing away than your average MaA. Only slightly.
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN, // Worse at swimming than the above class.
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN, // That saiga was stolen. Probably.
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)
/datum/outfit/job/roguetown/wretch/desertermaa/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("Warhammer & Shield","Sabre & Shield","Axe & Shield","Billhook","Greataxe","Halberd",)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Warhammer & Shield")
				beltr = /obj/item/rogueweapon/mace/warhammer
				backl = /obj/item/rogueweapon/shield/iron
			if("Sabre & Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/wood
			if("Axe & Shield")
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/iron
			if("Billhook")
				r_hand = /obj/item/rogueweapon/spear/billhook 
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Halberd")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap	
			if("Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
	H.verbs |= list(/mob/living/carbon/human/mind/proc/setorderswretch)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/brotherhood)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
		var/helmets = list(
		"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"		= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"Winged Helmet" 	= /obj/item/clothing/head/roguetown/helmet/winged,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/masks = list(
		"Steel Mask"		= /obj/item/clothing/mask/rogue/facemask/steel,
		"Wildguard"			= /obj/item/clothing/mask/rogue/wildguard,
		"None"
		)
		var/maskchoice = input(H, "Choose your Mask.", "MASK MASK MASK") as anything in masks // Run from it. MASK. MASK. MASK.
		if(maskchoice != "None")
			mask = masks[maskchoice]
		
		wretch_select_bounty(H)

	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk	
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat 
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain 
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron 
	beltl = /obj/item/rogueweapon/mace/cudgel
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(/obj/item/natural/cloth = 1, /obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/flashlight/flare/torch/lantern/prelit = 1, /obj/item/rogueweapon/scabbard/sheath = 1)

/obj/effect/proc_holder/spell/invoked/order
	name = ""
	range = 5
	associated_skill = /datum/skill/misc/athletics
	devotion_cost = 0
	chargedrain = 0
	chargetime = 0
	releasedrain = 80
	recharge_time = 2 MINUTES
	miracle = FALSE
	sound = 'sound/magic/inspire_02.ogg'


/obj/effect/proc_holder/spell/invoked/order/retreat
	name = "Tactical Retreat!"
	chargedrain = 0
	chargetime = 0
	desc = "Gives 3 SPD for your brothers!"
	overlay_state = "movemovemove"

/obj/effect/proc_holder/spell/invoked/order/retreat/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.retreattext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("I cannot order one not of the brotherhood cause!"))
				return		
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/retreat)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/buff/order/retreat/nextmove_modifier()
	return 0.85

/datum/status_effect/buff/order/retreat
	id = "movemovemove"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/retreat
	effectedstats = list(STATKEY_SPD = 3)
	duration = 0.5 / 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/retreat
	name = "Tactical Retreat!!"
	desc = "My commander has ordered me to fall back!"
	icon_state = "buff"

/datum/status_effect/buff/order/retreat/on_apply()
	. = ..()
	to_chat(owner, span_blue("My commander orders me to fall back!"))

/obj/effect/proc_holder/spell/invoked/order/bolster
	name = "Hold the Line!"
	desc = "Gives 2 CON and 3 WIL for your brothers!"
	overlay_state = "takeaim"
	chargedrain = 0
	chargetime = 0

/datum/status_effect/buff/order/bolster
	id = "takeaim"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/bolster
	effectedstats = list(STATKEY_CON = 2, STATKEY_WIL = 3)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/bolster
	name = "Hold the Line!"
	desc = "My commander inspires me to endure, and last a little longer!"
	icon_state = "buff"

/datum/status_effect/buff/order/bolster/on_apply()
	. = ..()
	to_chat(owner, span_blue("My commander orders me to hold the line!"))

/obj/effect/proc_holder/spell/invoked/order/bolster/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.bolstertext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("I cannot order one not of the brotherhood cause!"))
				return		
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/bolster)
		return TRUE
	revert_cast()
	return FALSE

/obj/effect/proc_holder/spell/invoked/order/brotherhood
	name = "For the Brotherhood!"
	desc = "Your brothers won't feel any pain for a bit, also it'll help them get back on feet!"
	overlay_state = "onfeet"
	chargedrain = 0
	chargetime = 0
/obj/effect/proc_holder/spell/invoked/order/brotherhood/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.brotherhoodtext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("I cannot order one not of the brotherhood cause!"))
				return		
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/brotherhood)
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

/datum/status_effect/buff/order/brotherhood
	id = "onfeet"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/brotherhood
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/buff/order/brotherhood
	name = "Stand your Ground!"
	desc = "My commander has ordered me to stand proud for the brotherhood!"
	icon_state = "buff"

/datum/status_effect/buff/order/brotherhood/on_apply()
	. = ..()
	to_chat(owner, span_blue("My commander orders me to stand proud for the brotherhood!"))
	ADD_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)

/datum/status_effect/buff/order/brotherhood/on_remove()
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)
	. = ..()


/obj/effect/proc_holder/spell/invoked/order/charge
	name = "Charge!"
	desc = "Gives 2 STR and 2 PER for your brothers!"
	overlay_state = "hold"
	chargedrain = 0
	chargetime = 0

/obj/effect/proc_holder/spell/invoked/order/charge/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/msg = user.mind.holdtext
		if(!msg)
			to_chat(user, span_alert("I must say something to give an order!"))
			return
		if(user.job == "Deserter")
			if(!(target.job in list("Brotherhood")))
				to_chat(user, span_alert("I cannot order one not of the brotherhood cause!"))
				return		
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return
		user.say("[msg]")
		target.apply_status_effect(/datum/status_effect/buff/order/charge)
		return TRUE
	revert_cast()
	return FALSE


/datum/status_effect/buff/order/charge
	id = "hold"
	alert_type = /atom/movable/screen/alert/status_effect/buff/order/charge
	effectedstats = list(STATKEY_STR = 2, STATKEY_PER = 2)
	duration = 1 MINUTES

/atom/movable/screen/alert/status_effect/buff/order/charge
	name = "Charge!"
	desc = "My commander wills it - now is the time to charge!"
	icon_state = "buff"

/datum/status_effect/buff/order/charge/on_apply()
	. = ..()
	to_chat(owner, span_blue("My commander orders me to charge! For the brotherhood!"))



/mob/living/carbon/human/mind/proc/setorderswretch()
	set name = "Rehearse Orders"
	set category = "Voice of Command"
	mind.retreattext = input("Send a message.", "Tactical Retreat!!") as text|null
	if(!mind.retreattext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.chargetext = input("Send a message.", "Chaaaaarge!!") as text|null
	if(!mind.chargetext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.bolstertext = input("Send a message.", "Hold the line!!") as text|null
	if(!mind.bolstertext)
		to_chat(src, "I must rehearse something for this order...")
		return
	mind.brotherhoodtext = input("Send a message.", "Stand proud, for the brotherhood!!") as text|null
	if(!mind.brotherhoodtext)
		to_chat(src, "I must rehearse something for this order...")
		return



/obj/effect/proc_holder/spell/self/convertrole/brotherhood
	name = "Recruit Brotherhood Militia"
	new_role = "Brother"
	overlay_state = "recruit_brotherhood"
	recruitment_faction = "Brother"
	recruitment_message = "We're in this together now, %RECRUIT!"
	accept_message = "For the Brotherhood!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/brotherhood/cast(list/targets,mob/user = usr)
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


/obj/effect/proc_holder/spell/self/convertrole/brother
	name = "Recruit Brother"
	new_role = "Brother"
	overlay_state = "recruit_brother"
	recruitment_faction = "Brother"
	recruitment_message = "We're in this together now, %RECRUIT!"
	accept_message = "All for one and one for all!"
	refuse_message = "I refuse."
