//////////////////////////////////////////////////////////
//NOW YOU KNOW WHY YOU FEAR THE NIGHT, POWERFUL CLASSES//
////////////////////////////////////////////////////////
		////////////////////////////////
		//////					//////
		////					////
		//						//
		//						//

//Intended to be very, very powerful keep-equiv characters. They're sort of minibosses that cost the vlord a lot to deploy but absolutely pull their own weight.
//Vlord will be trading off between these guys, power levels and their servant swarm, compared to freshly sired classes, these are intended to be stronger than the MAA/Knight in town.

//All of these classes should have riding, they should be above 10 in statline at minimal unless they have some insanely overpowered gimmic that requires them to be otherwise.
//Remember that job caps currently until this is false, do not get respected by vampires picking them as loadouts so do try to avoid making something excessively strong, they should be a feared foe but not the main antagonist.

//They aren't supposed to be too common, feel free to jakk up the prices in bloodpool.ddm in neu vampires if they are too common. Worst case they somehow still are, I might see to trying to limit them.
//Due to their more, richer status they don't meddle with a mix of gilbranze, they use steel of the century. Vlord gets a full enchanted set but these guys just get steel, plain and simple.



//The fragbeast class, powerful, jack-of-all-trades. Similar to knight banneret or knight with town buff.
//Pretty insane when you look at it, but you need to remember unlike wretches, these guys absolutely WILL dust upon dying due to being bloodpool vampires. +5000 vitae cost.

//Pretty much very good at everything fighting related; gets pretty stupidly strong once vlord upgrades to full power. But at that point you've bigger issues than 2 of these guys.
/datum/advclass/vampdeathknight
	name = "Vampiric Death Knight"
	tutorial = "A knighted champion of a fallen and forgotten kingdom. You can almost remember the old tymes since your last great battle, your unmatched prowess, your elegence with any-would-be weapon and all the dread your mere presence brought; now you arise from a fallen kingdom in servitude to your lord, once more. Make their vision, become reality."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/other/vampdeathknight
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_NOBLE, TRAIT_HEAVYARMOR)
	category_tags = list(CTAG_VAMPSPAWN)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 2,
		STATKEY_PER = 3,
		STATKEY_LCK = 1,
		STATKEY_SPD = -1,
		// 11 (10 without luck) point statline, a miniboss of sorts for an expensive vitae cost; intended to command the vampire lord's army. (+1 over old spawn stats)
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE, //Keeping captives, alive. We're not a lich's army, we have standards.
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)
	//Genuinely a scary nemesis, but remember this is 5000 vitae for this.

	subclass_virtues = list(
		/datum/virtue/utility/riding
	) //STANDARD LEADER ISSUE

/datum/outfit/job/roguetown/other/vampdeathknight/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("A knighted champion of a fallen and forgotten kingdom. You can almost remember the old tymes since your last great battle, your unmatched prowess, your elegence with any-would-be weapon and all the dread your mere presence brought; now you arise from a fallen kingdom in servitude to your lord, once more. Make their vision, become reality."))

	add_verb(H, /mob/proc/haltyell_exhausting) //Knight gets to halt people
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/knight] //Aura

	cloak = /obj/item/clothing/cloak/tabard/vamp
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/bevor
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate
	backr = /obj/item/storage/backpack/rogue/satchel/black

	if(H.mind)
		var/weapons = list(
			"Longsword + Crossbow",
			"Billhook + Recurve Bow",
			"Mace + Shield",
			"Flail + Shield",
			"Longsword + Shield",
			"Grand Mace + Longsword", 
			"Sabre + Recurve Bow",
			"Flamberge",
			"Poleaxe",
			"Estoc",
			"Lucerne",
			"Partizan",
		)
		var/weapon_choice = input(H, "Choose your weapon.", "ARMS TO MAKE THE LYVING BOW") as anything in weapons
		switch(weapon_choice)
			if("Longsword + Crossbow")
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/quiver/bolt/standard
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("Longsword + Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Mace + Shield")
				beltr = /obj/item/rogueweapon/mace/steel
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Flail + Shield")
				beltr = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower/metal
			if("Billhook + Recurve Bow")
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("Grand Mace + Longsword")
				r_hand = /obj/item/rogueweapon/sword/long
				beltl = /obj/item/rogueweapon/scabbard/sword/noble
				l_hand = /obj/item/rogueweapon/mace/goden/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Sabre + Recurve Bow")
				l_hand = /obj/item/rogueweapon/scabbard/sword/noble
				r_hand = /obj/item/rogueweapon/sword/sabre
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("Flamberge")
				r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Poleaxe")
				r_hand = /obj/item/rogueweapon/greataxe/steel/knight
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Estoc")
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Lucerne")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Partizan")
				r_hand = /obj/item/rogueweapon/spear/partizan
				backl = /obj/item/rogueweapon/scabbard/gwstrap

		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight's Armet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Knight's Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old,
			"Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/greatplume,
			"Visored Sallet"			= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" 		= /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"Visored Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/visor,
			"Great Barbute" = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/great,
			"Volfskulle Bascinet"		= /obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "A VISAGE TO TERRIFYING THE LYVING") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/heavy,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
		)
		var/armorchoice = input(H, "Choose your armor.", "A BULWARK AGAINST THE LITE") as anything in armors
		armor = armors[armorchoice]

	belt = /obj/item/storage/belt/rogue/leather/steel
	beltl = /obj/item/flashlight/flare/torch/lantern //we don't need it, but might as well play into the masquerade of a strange foreign retinue
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/huntingknife/combat = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1
		)

//Spy class, has very good agility, ability to slip around, listening, lockpicking and melee talents. Formidable and best played by sly players, they've a lot of tools at their hand, including the same amount of wealth as a vlord to work with.
//On top of decent-ish staying power in combat skill, a very good statline. They're supposed to be quite powerful in roleplay-created authority and able to pull strings in town and cause problems independantly to the vlord, under their command.

//Played right this class could probably cause more damage than the vampire lord themselves without even being close to their statline, traits and whatever else, this is completely fine and honestly if it happens. Good for them, you get to impersonate a style of either a foreign noble, a suitor or a foreign royal.
//TLDR: specialises in sabotage via roleplay hooks, power, coin and tools but it also inherently has decent traits to stand their own ground or even bring the fight themselves through martal and ranged arts combined. On top of T3 vamp magics from their generation.
/datum/advclass/vampnoble
	name = "Vampiric Noble Spy"
	tutorial = "You are a noble of a long fallen and forgotten kingdom, trained in maile and footwork alike. You can almost remember the days of listening to the quietest whispers in your court, you were once a vault of intrique in your own right before the previous collapse. Yet your talents will see another era of use and with it, your master's vision shalt become reality."
	outfit = /datum/outfit/job/roguetown/other/vampnoble
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_MEDIUMARMOR, TRAIT_NOBLE, TRAIT_CICERONE, TRAIT_NUTCRACKER, TRAIT_LIGHT_STEP, TRAIT_KEENEARS, TRAIT_PERFECT_TRACKER) //The perfect spy, advisor and assassin, all in one.
	category_tags = list(CTAG_VAMPSPAWN)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 3,
		STATKEY_LCK = 4, //only the lucky outlive the ranks of common fodder in a vamp's court
		// 13 (9 without luck factored in for flavor) point statline, mostly put into speed + int; still no con buff though, the luckiest person to ever outlyve you by who-knows-how-many-yills
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, //High cost, might as well give them a decent amount of this.
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT, //Nobility style points, decently capable of fighting with this alone.
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT, //Commanding role
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_LEGENDARY, //Very, talented spy
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //Practiced kidnapper, good at sewing people back up.
		/datum/skill/misc/music = SKILL_LEVEL_JOURNEYMAN, //Nobility Sovl
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
	)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	) //STANDARD LEADER ISSUE

/datum/outfit/job/roguetown/other/vampnoble/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a noble of a long fallen and forgotten kingdom, trained in maile and footwork alike. You can almost remember the days of listening to the quietest whispers in your court, you were once a vault of intrique in your own right before the previous collapse. Yet your talents will see another era of use and with it, your master's vision shalt become reality."))
	H.set_blindness(0)

	if(H.mind)
		H.set_blindness(0)
		var/choice_list = list("Royal (Light Armor /w dress + Skilled Appraisal)", "Royal (Light Armor /w shirt + Skilled Appraisal)", "Noble (Light Armor + Skilled Appraisal)", "Suitor/Consort (Medium Armor)")
		var/choice = input(H, "What is your disguise?", "WHAT MASQUERADE DO YOU BEAR?") as anything in choice_list

		switch(choice)
			if("Royal (Light Armor /w dress + Skilled Appraisal)") //You get a bit extra for the part with the lighter loadouts.
				head = /obj/item/clothing/head/roguetown/circlet //Royalty look
				belt = /obj/item/storage/belt/rogue/leather/black //stylish belt
				mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/vampire_noble //regal appearance
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
				r_hand = /obj/item/rogueweapon/scabbard/sword/royal
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal/princess
				ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
			if("Royal (Light Armor /w shirt + Skilled Appraisal)")
				head = /obj/item/clothing/head/roguetown/circlet //Royalty look
				belt = /obj/item/storage/belt/rogue/leather/black //stylish belt
				mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/vampire_noble //regal appearance
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
				r_hand = /obj/item/rogueweapon/scabbard/sword/royal
				armor = /obj/item/clothing/suit/roguetown/shirt/dress/royal/prince
				ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
			if("Noble (Light Armor + Skilled Appraisal)")
				head = /obj/item/clothing/head/roguetown/chaperon/noble //nobility look
				cloak = /obj/item/clothing/suit/roguetown/armor/longcoat
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
				belt = /obj/item/storage/belt/rogue/leather/steel //similar to spymaster hand
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				mask = /obj/item/clothing/mask/rogue/lordmask //hidden face
				r_hand = /obj/item/rogueweapon/scabbard/sword/noble
				ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
			if("Suitor/Consort (Medium Armor)") //lose a free trait for better armor starting off.
				head = /obj/item/clothing/head/roguetown/nyle/consortcrown //suitor/consort look
				armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
				cloak = /obj/item/clothing/cloak/half/red
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
				belt = /obj/item/storage/belt/rogue/leather //on-par with valiant
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/vampire_noble
				r_hand = /obj/item/rogueweapon/scabbard/sword/royal

		var/weapons = list(
			"Crossbow",
			"Yew Longbow",
			"Recurve Bow",
		)
		var/weapon_choice = input(H, "Choose your bow.", "WHAT MEANS DO YOU HUNT IN THE NITE?") as anything in weapons //Unlike vamp skirmisher, we specialise all-in only for our ranged pick because we have a ton of stuff already. No jack of all trades.
		switch(weapon_choice)
			if("Crossbow")
				beltr = /obj/item/quiver/bolt/standard
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
			if("Recurve Bow")
				beltr = /obj/item/quiver/arrows
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
			if("Yew Longbow")
				beltr = /obj/item/quiver/arrows
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)

	neck = /obj/item/clothing/neck/roguetown/chaincoif //not ancient, these guys are supposed to blend in.
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot //intended, RP-orientated getup
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold

	id = /obj/item/clothing/ring/signet //Rich Look
	beltl = /obj/item/rogueweapon/sword/sabre/dec //fancy blade, sabre too. Not a bad weapon. Starts on hip since you always get it regardless so you don't hit your vlord with it like I did picking disguise + bow
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1, //Spy shennagions, lets them cause problems for their lord. Also a rare role, so fuck it. They can have obscene amounts of coin to do stuff with.
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1, //Lets kill someone, maybe? Literally killer's ice.
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/lockpickring/mundane = 1,
		/obj/item/rogueweapon/scabbard/sheath/royal = 1
		)

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/vampire_noble
	color = "#883030"

/obj/item/clothing/cloak/tabard/vamp
	desc = "A checkered pattern of white fabrics and red silks, inlined seamlessly with silks befit for one under a lord with true opulance, not any mere dull-blooded or otherwise, branded with a crest of a forgotten empire."
	color = CLOTHING_WHITE
	detail_tag = "_quad"
	detail_color = CLOTHING_RED
