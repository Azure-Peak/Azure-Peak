/datum/advclass/wretch/deserter_knight
	name = "Disgraced Knight"
	tutorial = "You were once a venerated and revered knight - now, a traitor who abandoned your liege. You lyve the lyfe of an outlaw, shunned and looked down upon by society."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/wretch/deserter_knight
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE, TRAIT_BOGWALKER)
	maximum_possible_slots = 2 //Ideal role for fraggers. Better to limit it. Powerful like T4 heretic w/ heretical plate armor in that they're a bog-blessed, plate user, w/ orders, riding and expert in most weaponry.

	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg' // same as new hedgeknight music
	// Deserter are the knight-equivalence. They get a balanced, straightforward 2 2 3 statspread to endure and overcome.
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 2,
		STATKEY_STR = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //no miracles to deal w/ stabs through plate armor
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)
	subclass_stashed_items = list(
		"Armor Plates" =	/obj/item/repair_kit/metal,
		"Stashed Funds" = /obj/item/roguecoin/silver/pile/wretchpile,
	)

/datum/outfit/job/roguetown/wretch/deserter_knight/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You were once a venerated and revered knight - now, a traitor who abandoned your liege. You lyve the lyfe of an outlaw, shunned and looked down upon by society."))
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]

	add_verb(H, /mob/proc/haltyell) //Ex-Garrisoner

	add_verb(H, list(/mob/living/carbon/human/mind/proc/setorders))
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/movemovemove)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/takeaim)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/hold)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)

		var/weapons = list(
			"Estoc",
			"Stecher",
			"Mace + Shield",
			"Flail + Shield",
			"Longsword + Shield",
			"Lucerne",
			"Battle Axe",
			"Lance + Kite Shield",
			"Samshir",
			"Ssangsudo",
			"Shashka + Shield",
			"Steel Poleaxe",
			"Steel Flameberge",
			"Grand Mace",
			"Polehammer"
		)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Estoc")
				r_hand = /obj/item/rogueweapon/estoc
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Stecher")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long/ap
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
			if("Steel Poleaxe")
				r_hand = /obj/item/rogueweapon/greataxe/steel/knight
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Steel Flameberge")
				r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Grand Mace")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Polehammer")
				r_hand = /obj/item/rogueweapon/eaglebeak
				backr = /obj/item/rogueweapon/scabbard/gwstrap

		var/helmets = list(
			"Pigface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Sugarloaf Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader,
			"Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old,
			"Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume,
			"Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Snouted Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Snouted Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet/snouted,
			"Hounskull Bascinet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"Kulah Khud"	= /obj/item/clothing/head/roguetown/helmet/sallet/raneshen,
			"Kabuto"	= /obj/item/clothing/head/roguetown/helmet/heavy/kabuto, //No mask, fuck you
			"Shishak"	= /obj/item/clothing/head/roguetown/helmet/sallet/shishak,
			"Visored Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor,
			"Great Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great,
			"Snouted Burgonet" = /obj/item/clothing/head/roguetown/helmet/heavy/burgonet,
			"Volfskulle Bascinet"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
			"Roundface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface,
			"Snouted Roundface Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/roundface/snouted,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Fullplate"			= /obj/item/clothing/suit/roguetown/armor/plate/full,
			"Fluted Fullplate"		= /obj/item/clothing/suit/roguetown/armor/plate/full/fluted,
			"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"Coat of Plates"		= /obj/item/clothing/suit/roguetown/armor/brigandine/heavy,
			"Half-Plate"		= /obj/item/clothing/suit/roguetown/armor/plate,
			"Lamellar Scalemail"		= /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe,
			"Haraate Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/haraate,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]
		wretch_select_bounty(H)
	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/platelegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	cloak = /obj/item/clothing/cloak/tabard/black
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset //less meta
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel //gwstraps landing on backr asyncs with backpack_contents
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)

/datum/advclass/wretch/deserter
	name = "Deserter"
	tutorial = "You had your post. You had your duty. Dissatisfied, lacking in morale, or simply thinking yourself better than it. - You decided to walk. Now it follows you everywhere you go."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/wretch/deserter

	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	//frankly, this is probably not going to happen consistantly with a massive tide of bogmen. If it does uhh, honestly. hilarious.
	//Worst case nuke this to 5 slots, or 4. If it becomes a problem.

	subclass_stashed_items = list(
		"Armor Plates" =	/obj/item/repair_kit/metal,
	)

	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg' // same as regular bandits
	// Slightly more rounded. These can be nudged as needed.
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_BOGWALKER)
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
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN, //Unique only case here, pick crossbow if you want to exceed in crossbows. Otherwise you're decently okay at it.
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, // Better at climbing away than your average MaA. Only slightly.
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN, // Worse at swimming than the above class.
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //No miracles to deal w/ stabs through plate/maile armor
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE, //So you can repair your heater shield + build in the bogs
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE, //Ditto
	)

/datum/outfit/job/roguetown/wretch/deserter/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("Warhammer & Shield","Sabre & Shield","Axe & Shield","Billhook","Greataxe","Halberd","Crossbow")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Warhammer & Shield")
				beltr = /obj/item/rogueweapon/mace/warhammer/steel
				backl = /obj/item/rogueweapon/shield/heater
			if("Sabre & Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/heater
			if("Axe & Shield")
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/heater
			if("Billhook")
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Halberd")
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Crossbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/bolt/standard

	add_verb(H, /mob/proc/haltyell) //Ex-Garrisoner

	add_verb(H, list(/mob/living/carbon/human/mind/proc/setorders)) //Kill if problematic
	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/movemovemove)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/takeaim)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/hold)
		H.mind.AddSpell(new /datum/action/cooldown/spell/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)

		/*
		meant to be less knightly-helmets and more in-line with banditry, brigand loadouts and such so, so no armlets

		we limit this so you have to look moderately evil or suspiciously wearing old-style helmets
		*/
		var/helmets = list(
			"Pigface Bascinet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Hounskull Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Klappvisier Bascinet"	= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Volfskulle Bascinet"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
			"Visored Sallet"		= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Snouted Visored Sallet"		= /obj/item/clothing/head/roguetown/helmet/sallet/visored/snouted,
			"Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old,
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		head = helmets[helmchoice]

		var/armors = list(
			"Cuirass"			= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"Half-Plate"		= /obj/item/clothing/suit/roguetown/armor/plate/iron,
			"Scalemail"			= /obj/item/clothing/suit/roguetown/armor/plate/scale,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]

		var/cloaks = list("Bog Green","Black","Brown and Longcoat")
		var/cloak_choice = input(H, "Choose your cloak.", "FOR THE BOG") as anything in cloaks
		switch(cloak_choice)
			if("Bog Green")
				cloak = /obj/item/clothing/cloak/tabard/stabard/bog
				mask = /obj/item/clothing/head/roguetown/roguehood/bogman
			if("Black")
				cloak = /obj/item/clothing/cloak/tabard/stabard/dungeon
				mask = /obj/item/clothing/head/roguetown/roguehood/bogman/black
			if("Brown and Longcoat")
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/brown
				mask = /obj/item/clothing/head/roguetown/roguehood/bogman/brown

		wretch_select_bounty(H)

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/chain
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	beltl = /obj/item/rogueweapon/mace/cudgel
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(/obj/item/natural/cloth = 1, /obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, /obj/item/rope/chain = 1, /obj/item/storage/belt/rogue/pouch/coins/poor = 1, /obj/item/flashlight/flare/torch/lantern/prelit = 1, /obj/item/rogueweapon/scabbard/sheath = 1)

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
