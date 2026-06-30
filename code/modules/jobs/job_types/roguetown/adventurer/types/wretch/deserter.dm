/datum/advclass/wretch/deserter
	name = "Disgraced Knight"
	tutorial = "You were once a venerated and revered knight - now, a traitor who abandoned your liege. You lyve the lyfe of an outlaw, shunned and looked down upon by society."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/wretch/deserter
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE)
	maximum_possible_slots = 2 //Ideal role for fraggers. Better to limit it.

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
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)
	subclass_stashed_items = list(
        "Armor Plates" =  /obj/item/repair_kit/metal,
    )

/datum/outfit/job/roguetown/wretch/deserter/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You were once a venerated and revered knight - now, a traitor who abandoned your liege. You lyve the lyfe of an outlaw, shunned and looked down upon by society."))
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/warrior]
	add_verb(H, list(/mob/living/carbon/human/mind/proc/setorders))
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
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
			"Steel Poleaxe"
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

		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Sugarloaf Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/crusader,
			"Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old,
			"Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume,
			"Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"Kulah Khud"	= /obj/item/clothing/head/roguetown/helmet/sallet/raneshen,
			"Kabuto"	= /obj/item/clothing/head/roguetown/helmet/heavy/kabuto, //No mask, fuck you
			"Shishak"	= /obj/item/clothing/head/roguetown/helmet/sallet/shishak,
			"Visored Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor,
			"Great Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great,
			"Volf-Face Helm"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine,
			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/heavy,
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

/datum/advclass/wretch/deserter/generic
	name = "Militant"
	tutorial = "It matters not what cause you swing your weapon for, in the end you fight the same way your ancestors and their ancestors did: clad in metal and intimately intertwined with gore and death."
	outfit = /datum/outfit/job/roguetown/wretch/desertergeneric
	maximum_possible_slots = -1 //Ideal role for fraggers. Better to limit it... Except you are just a medium armour guy with a weapon. Can you believe that rogue mages are unlimited?

	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg' // same as new hedgeknight music
	//+9 weighted total, and you *may* get +3 weighted stat points from your chosen archetype for the +12 weighted total. In a world full of wizards and miracleworkers, being a normal soldier sucks.
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
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, //Better at climbing away than your average MaA. Only slightly.
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN, //Worse at swimming than the above class.
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE, //No free mount anymore; pick Cavalryman archetype for a mount and better Riding.
	)
/datum/outfit/job/roguetown/wretch/desertergeneric/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/weapons = list("Warhammer & Shield","Sabre & Shield","Axe & Shield","Billhook","Greataxe","Halberd","Crossbow")
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
			if("Crossbow")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				backl = /obj/item/quiver/bolt/standard
	add_verb(H, list(/mob/living/carbon/human/mind/proc/setorders))
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/mace/cudgel
	backr = /obj/item/storage/backpack/rogue/satchel
	if(H.mind)
//		Pick Sergeant for buff orders.
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/brotherhood)
		var/helmets = list(
			"Simple Helmet" 		 	= /obj/item/clothing/head/roguetown/helmet,
			"Kettle Helmet" 		 	= /obj/item/clothing/head/roguetown/helmet/kettle,
			"Bascinet Helmet" 		 	= /obj/item/clothing/head/roguetown/helmet/bascinet,
			"Sallet Helmet" 		 	= /obj/item/clothing/head/roguetown/helmet/sallet,
			"Winged Helmet" 		 	= /obj/item/clothing/head/roguetown/helmet/winged,
			//Helmets below are ethnic choices.
			"Grenzelhoftian Plume Hat"	= /obj/item/clothing/head/roguetown/grenzelhofthat,
			"Steel Shishak" 			= /obj/item/clothing/head/roguetown/helmet/sallet/shishak,
			"Gronnic Ownel Helmet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel,
			"Varangian Owl Helmet"		= /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi,
			"Kulah Khud"				= /obj/item/clothing/head/roguetown/helmet/sallet/raneshen,
			"Jingasa"					= /obj/item/clothing/head/roguetown/helmet/kettle/jingasa,
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		head = helmets[helmchoice]

		var/armors = list("Brigandine Set", "Maille Set", "Cuirass Set", "Grenzelhoftian Set", "Steppesman Set", "Gronnic Set", "Varangian Set", "Raneshen Set", "Kazengunite Set", "Otavan Set")
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		switch(armorchoice)
			if("Brigandine Set")
				neck = /obj/item/clothing/neck/roguetown/gorget/steel
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				pants = /obj/item/clothing/under/roguetown/brigandinelegs
				wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Maille Set")
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				pants = /obj/item/clothing/under/roguetown/chainlegs
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Cuirass Set")
				neck = /obj/item/clothing/neck/roguetown/gorget/steel
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				pants = /obj/item/clothing/under/roguetown/chainlegs
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			if("Grenzelhoftian Set")
				neck = /obj/item/clothing/neck/roguetown/gorget
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/blacksteel //Better chest protection, but your limbs are poorly protected.
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
				shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
			if("Steppesman Set")
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot/steppesman
			if("Gronnic Set")
				neck = /obj/item/clothing/neck/roguetown/leather
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy //Apparently legit Leðurháls don't get a shirt-slot item at all. Why?
				pants = /obj/item/clothing/under/roguetown/chainlegs/gronn
				wrists = /obj/item/clothing/wrists/roguetown/bracers/splint
				gloves = /obj/item/clothing/gloves/roguetown/chain/gronn
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
			if("Varangian Set")
				neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/angle/atgervi
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
			if("Raneshen Set")
				neck = /obj/item/clothing/neck/roguetown/chaincoif/full
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
				pants = /obj/item/clothing/under/roguetown/brigandinelegs
				wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
				gloves = /obj/item/clothing/gloves/roguetown/chain
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced //Legit Desert Rider Janissary gets babouches instead.
			if("Kazengunite Set")
				neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/haraate
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy //Legit Hangyaku-Chonin gets a tunic instead.
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				gloves = /obj/item/clothing/gloves/roguetown/plate/kote
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
			if("Otavan Set")
				neck = /obj/item/clothing/neck/roguetown/fencerguard
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted //Actual Otavan plate's AC is heavy.
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				gloves = /obj/item/clothing/gloves/roguetown/otavan
				shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
		var/specialization = list("Offence & Defence", "Mobility & Ranged Combat", "Cavalry", "Field Medicine", "Faith", "Leadership") //Faith and Leadership don't grant stat bonuses.
		var/specialization_choice = input (H, "Choose your primary training.", "HOW DO YOU KILL?") as anything in specialization
		switch(specialization_choice)
			if("Offence & Defence") //Doubles down on Militant's existing strengths.
				cloak = /obj/item/clothing/cloak/tabard/stabard
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE) //It's just +5 more stamina, so it's okay...?
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_CON, 1)
				to_chat(H, span_warning("You trained to fight as a part of dense infantry formations. This made you fit, but you didn't have a chance to pick up any other skills."))
			if("Mobility & Ranged Combat")
				cloak = /obj/item/clothing/cloak/raincloak/furcloak
				beltl = /obj/item/quiver/javelin/steel
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE) //Procure your own weapons.
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_PER, 1)
				to_chat(H, span_warning("You trained to fight in loose formations, harassing your foes from afar with throwning weapons and swift attacks."))
			if("Cavalry")
				cloak = /obj/item/clothing/cloak/tabard
				ADD_TRAIT(H, TRAIT_EQUESTRIAN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/riding, SKILL_LEVEL_EXPERT, TRUE) //On par with Disgraced Knight.
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_PER, 1)
				H.AddSpell(new /obj/effect/proc_holder/spell/self/choose_riding_virtue_mount)
				to_chat(H, span_warning("You trained in equestrianism, fighting atop mighty steeds and raising yourself above common infantry."))
			if("Field Medicine") //No TRAIT_MEDICINE_EXPERT, so you can't progress past Expert without the virtue.
				cloak = /obj/item/clothing/suit/roguetown/shirt/robe/feld
				beltl = /obj/item/storage/belt/rogue/surgery_bag
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
				H.change_stat(STATKEY_INT, 2)
				H.change_stat(STATKEY_CON, 1)
				to_chat(H, span_warning("You were a field chirurgeon, a healer rather than a killer. In time, you learned how to murder and became both."))
			if("Faith") //Evil Templar - T2 miracleworker, except medium armour-clad. No stat bonuses, and the only bonus skill you gain is Miracles.
				cloak = /obj/item/clothing/cloak/cape/crusader
				beltl = /obj/item/clothing/neck/roguetown/psicross //Use loadout.
				H.adjust_skillrank_up_to(/datum/skill/magic/holy, SKILL_LEVEL_JOURNEYMAN, TRUE)
				var/datum/devotion/C = new /datum/devotion(H, H.patron)
				C.grant_miracles(H, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_2)
				to_chat(H, span_warning("Your training in combat was merely a step in your path to becoming a living weapon of your deity."))
			if("Leadership") //You get orders and complementary Expert Wrestling. This is less-more classic Deserter.
				cloak = /obj/item/clothing/cloak/tabard/stabard
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
				to_chat(H, span_warning("You trained how to organise and lead your fellow fighters into battles."))
		wretch_select_bounty(H)

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
