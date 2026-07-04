/datum/advclass/levy
	name = "Levy"
	tutorial = "When the Bailiff came knocking for you, it was the worst dae of your lyfe. Hastily pressed into the Crown's service with little more than a helmet, a household tool turned weapon and a bottle of beer for comfort, you joined the Levy squad.<br><br>As one of Azurea's so-called \"folk-heroes\", you are first to answer a peasant's reports of danger beyond the walls. Find the problem and solve it yourself or, if dire, send word for backup, and hold the line until the Armsmen or Wardens arrive to earn their keep."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	
	outfit = /datum/outfit/job/roguetown/adventurer/levy
	traits_applied = list(TRAIT_LEVY, TRAIT_DECEIVING_MEEKNESS, TRAIT_LEECHRESIST, TRAIT_SELF_RELIANCE)
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	category_tags = list(CTAG_TOWNER)
	townie_contract_gate_exempt = TRUE
	maximum_possible_slots = 5 // They're still Towners who contribute to the econ, even when not fighting or bog-larping.
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_STR = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/adventurer/levy/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/head/roguetown/armingcap
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog/levy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	beltl = /obj/item/flashlight/flare/torch/lantern
	
	to_chat(H, span_notice("<b>THE WEAPON I COULD SCROUNGE UP:</b>"))
	to_chat(H, span_info("<b>THE FAMILY SWORD</b> - Journeyman Swords. Comes with a militia falchion."))
	to_chat(H, span_info("<b>THE LEGENDARY BOG-STICK</b> - Journeyman Maces. Comes with a militia club."))
	to_chat(H, span_info("<b>AN OLDE CATTLE LASH</b> - Journeyman Whips & Flails. Comes with a whip."))
	to_chat(H, span_info("<b>THE FINEST PITCHFORK</b> - Journeyman Polearms. Comes with a militia spear."))
	to_chat(H, span_info("<b>MINE THRESHER</b> - Journeyman Whips & Flails. Comes with a militia flail."))
	to_chat(H, span_info("<b>A GOOD SHOVEL</b> - Journeyman Axes. Comes with a militia greataxe."))
	to_chat(H, span_info("<b>THE MINER'S PICKAXE</b> - Journeyman Mining. Comes with a militia pickaxe."))
	to_chat(H, span_info("<b>MINE SCYTHE</b> - Journeyman Farming. Comes with a militia scythe."))
	to_chat(H, span_info("<b>THE WHOLE KITCHEN</b> - Journeyman Cooking and Knives. Comes with a mess kit and cleaver."))
	to_chat(H, span_info("<b>THESE GODS-GIVEN FISTS</b> - Journeyman Unarmed. Comes with handwraps."))

	if(H.mind)
		var/list/weapons = list(
			"THE FAMILY SWORD (Sword)",
			"A BIG KNIFE (Dagger)",
			"THE LEGENDARY BOG-STICK (Club)",
			"THE BOGMAN'S BOW (Sling)",
			"AN OLDE CATTLE LASH (Whip)",
			"THE FINEST PITCHFORK (Polearm)",
			"THE GOOD DAE'S GREETINGS (Polearm)",
			"MINE THRESHER (Flail)",
			"MINE WAR THRESHER (Flail, 2H)",
			"A GOOD SHOVEL (Axe)",
			"THE MINER'S PICKAXE (Pickaxe)",
			"MINE SCYTHE (Scythe)",
			"THE RELIABLE VOLFKILLER (Staff)",
			"THE WHOLE KITCHEN (Mess Kit + Cleaver)",
			"THESE GODS-GIVEN FISTS (Unarmed)",
		)

		var/weapon_choice = tgui_input_list(H, "Choose what you could nab and turn into a weapon.", "WHAT IS YOUR WEAPON?", weapons)
		H.set_blindness(0)
		switch(weapon_choice)

			if ("THE FAMILY SWORD (Sword)")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/falchion/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather
				backr = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/pick/bronze

			if ("THE LEGENDARY BOG-STICK (Club)")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/woodclub/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather
				beltr = /obj/item/rogueweapon/pick/bronze

			if ("AN OLDE CATTLE LASH (Whip)")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/whip
				gloves = /obj/item/clothing/gloves/roguetown/leather
				beltr = /obj/item/rogueweapon/pick/bronze

			if("THE FINEST PITCHFORK (Polearm)")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/pick/bronze

			if("MINE THRESHER (Flail)")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather
				beltr = /obj/item/rogueweapon/pick/bronze

			if("MINE WAR THRESHER (Flail, 2H)")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/peasantwarflail
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				gloves = /obj/item/clothing/gloves/roguetown/leather
				beltr = /obj/item/rogueweapon/pick/bronze

			if("THE GOOD DAE'S GREETINGS (Polearm)")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/militia
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				gloves = /obj/item/clothing/gloves/roguetown/leather
				beltr = /obj/item/rogueweapon/pick/bronze

			if ("A GOOD SHOVEL (Axe)")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/pick/bronze

			if ("THE MINER'S PICKAXE (Pickaxe)")
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/pick/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather
				beltr = /obj/item/rogueweapon/pick/bronze

			if ("MINE SCYTHE (Scythe)")
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/scythe/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/pick/bronze

			if ("A BIG KNIFE (Dagger)")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/rogueweapon/huntingknife/combat/iron
				backr = /obj/item/rogueweapon/scabbard/sheath
				gloves = /obj/item/clothing/gloves/roguetown/leather
				beltr = /obj/item/rogueweapon/pick/bronze

			if ("THE WHOLE KITCHEN (Mess Kit + Cleaver)")
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/storage/gadget/messkit
				l_hand = /obj/item/rogueweapon/huntingknife/chefknife/cleaver
				gloves = /obj/item/clothing/gloves/roguetown/leather
				beltr = /obj/item/rogueweapon/pick/bronze

			if ("THE BOGMAN'S BOW (Sling)")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/leather
				r_hand = /obj/item/quiver/sling/iron
				l_hand = /obj/item/quiver/sling/iron
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/sling/wood/bog
				beltr = /obj/item/rogueweapon/pick/bronze

			if ("THE RELIABLE VOLFKILLER (Staff)")
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/leather
				backr = /obj/item/rogueweapon/woodstaff/quarterstaff/virtue
				beltr = /obj/item/rogueweapon/pick/bronze

			if ("THESE GODS-GIVEN FISTS (Unarmed)")
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
				beltr = /obj/item/rogueweapon/pick/bronze

	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_DESTITUTE, H)

	to_chat(H, span_notice("<b>JOB BEFORE THE LEVY?</b>"))

	to_chat(H, span_info("<b>UNEMPLOYED, SER!!</b><br>\
	Traits: None.<br>\
	Final Stats: +1 CON, +1 STR, +1 WIL, -1 INT, +1 LCK.<br>\
	Skills: No extras.<br>\
	Equipment: Satchel, Rope, Signal Horn, 4x Triumph Beer.<br><br>"))

	to_chat(H, span_info("<b>A HOMESTEADER, SER!!</b><br>\
	Traits: Jack of All Trades, Homestead Expert, Smithing Expert, Survival Expert.<br>\
	Final Stats: +1 CON, +1 STR, +1 WIL, +3 INT, +1 SPD, -1 LCK.<br>\
	Skills: No extras.<br>\
	Equipment: Backpack, Small Shovel, Stone Hammer, Chisel, Handsaw, Hoe, Hunting Knife, Rope, Poor Coin Pouch, Signal Horn, Triumph Beer, Broom, Coal.<br><br>"))

	to_chat(H, span_info("<b>A COOKER-DOC, SER!!</b><br>\
	Traits: Medicine Expert, Cicerone.<br>\
	Final Stats: +3 INT, +2 SPD, -1 STR, -1 CON, -1 LCK.<br>\
	Skills: Medicine (Expert), Cooking (Journeyman), Alchemy (Apprentice). Knows Secular Diagnose.<br>\
	Equipment: Backpack, Bedroll, Signal Horn, Hunting Knife, Rope, Triumph Beer, Bottle Kit, Calendula Seeds, Healing Juice Recipe, Surgery Bag, Folding Alchemy Cauldron, Coal.<br><br>"))

	to_chat(H, span_info("<b>A THUG, SER!!</b><br>\
	Traits: No Pain Stun, Steelhearted. Knows Thieves' Cant.<br>\
	Final Stats: +2 STR, +2 CON, +1 WIL, -1 SPD, -2 INT, -1 LCK.<br>\
	Skills: Athletics (Journeyman), Maces (Apprentice).<br>\
	Equipment: Satchel, Cudgel, Signal Horn, Hunting Knife, 2x Triumph Beer.<br><br>"))

	to_chat(H, span_info("<b>A SCAVENGER, SER!!</b><br>\
	Traits: Dodge Expert, Graverobber.<br>\
	Final Stats: -3 CON, +1 STR, +1 WIL, -1 INT, +3 SPD, -1 LCK.<br>\
	Skills: Sneaking (Journeyman), Knives (Journeyman), Sewing (Journeyman), Smelting (Journeyman).<br>\
	Equipment: Backpack, Combat Knife, Small Shovel, Scissors, Signal Horn, Triumph Beer, Rope, 2x Coal, Iron Ore, Tongs.<br><br>"))

	to_chat(H, span_info("<b>A BATHMAID, SER!!</b><br>\
	Traits: Empath, Good Lover, Nutcracker. Knows Thieves' Cant.<br>\
	Final Stats: +2 SPD, -2 INT, +1 LCK.<br>\
	Skills: Medicine (Novice), Lockpicking (Journeyman), Sneaking (Journeyman), Riding (Master).<br>\
	Equipment: Satchel, Bath Soap, Gold Hairpin, Signal Horn, Triumph Beer, Rope.<br><br>"))

	to_chat(H, span_info("<b>ALMOST A SQUIRE, SER!!</b><br>\
	Traits: Squire Repair, Expert Hunter.<br>\
	Final Stats: +1 CON, +1 STR, +1 WIL, -1 INT, +1 SPD, -1 PER, -1 LCK.<br>\
	Skills: No extras.<br>\
	Equipment: Satchel, Rich Coin Pouch, Stone Hammer, Polishing Cream, Armor Brush, Signal Horn, Needle.<br><br>"))

	to_chat(H, span_info("<b>ALMOST AN ARMSMAN, SER!!</b><br>\
	Traits: Guardsman, Steelhearted.<br>\
	Final Stats: +2 CON, +1 STR, +2 WIL, -1 INT, -2 PER, -1 LCK.<br>\
	Skills: Shields (Journeyman).<br>\
	Equipment: Heater Shield, Beltpack, Chain, Signal Horn, Hunting Knife, Health Potion, Triumph Beer.<br><br>"))

	if(H.mind)
		var/list/specialties = list(
			"UNEMPLOYED, SER!!",
			"A HOMESTEADER, SER!!",
			"A COOKER-DOC, SER!!",
			"A THUG, SER!!",
			"A SCAVENGER, SER!!",
			"A BATHMAID, SER!!",
			"ALMOST A SQUIRE, SER!!",
			"ALMOST AN ARMSMAN, SER!!"
		)
		var/specialty_choice = tgui_input_list(H, "Choose your background. (The Levy is not legally obligated to provide tools, equipment, compensation, legal representation, funeral expenses, or refunds. Good luck, and we love you.)", "JOB BEFORE THE LEVY?", specialties)
		switch(specialty_choice)

			if("UNEMPLOYED, SER!!") // the real hero. 4 beer packs, no gear, full balls.
				H.change_stat(STATKEY_LCK, 1)
				belt = /obj/item/storage/belt/rogue/leather
				backl = /obj/item/storage/backpack/rogue/satchel
				backpack_contents = list(
					/obj/item/rope = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/triumphbeer = 4, // this one is for good luck, you'll need it, OHH YOU'LL NEED IT.
					/obj/item/signal_horn = 1,
					)

			if("A HOMESTEADER, SER!!") // basic bitch siege engineer guy, may be mogged by default but ig JoAT lets them be omni-journeyman on all, shrug.
				ADD_TRAIT(H, TRAIT_JACKOFALLTRADES, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_SURVIVAL_EXPERT, TRAIT_GENERIC)
				H.change_stat(STATKEY_INT, 4)
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_LCK, -1)
				belt = /obj/item/storage/backpack/rogue/satchel/beltpack
				backl = /obj/item/storage/backpack/rogue/backpack
				backpack_contents = list(
					/obj/item/rogueweapon/shovel/small = 1,
					/obj/item/rogueweapon/hammer/stone = 1,
					/obj/item/rogueweapon/chisel = 1,
					/obj/item/rogueweapon/handsaw = 1,
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
					/obj/item/rogueweapon/huntingknife = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/rope = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/triumphbeer = 1, // this one is for good luck, you'll need it
					/obj/item/signal_horn = 1,
					/obj/item/rogueweapon/hoe = 1,
					/obj/item/broom = 1,
					/obj/item/rogueore/coal = 1,
					)

			if("A COOKER-DOC, SER!!") // JESSIE, WE GOTTA COOK!!! -- This is intended to be the Barber-Surgeon's cousin. Low combat potential.
				ADD_TRAIT(H, TRAIT_MEDICINE_EXPERT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
				H.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_EXPERT, TRUE) // so secular diagnose gives better info after (if) they hit master
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_JOURNEYMAN, TRUE) // brew fish potions for field-healing, ser!!!
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE) // this is for drug-crafting
				H.change_stat(STATKEY_INT, 4)
				H.change_stat(STATKEY_SPD, 2)
				H.change_stat(STATKEY_LCK, -1)
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_WIL, -1)
				H.change_stat(STATKEY_CON, -1)
				belt = /obj/item/storage/backpack/rogue/satchel/beltpack
				backl = /obj/item/storage/backpack/rogue/backpack
				backpack_contents = list(
					/obj/item/bedroll = 1,
					/obj/item/signal_horn = 1,
					/obj/item/rogueweapon/huntingknife = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/rope = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/triumphbeer = 1, // this one is for good luck, you'll need it
					/obj/item/bottle_kit = 1,
					/obj/item/herbseed/calendula = 1,
					/obj/item/paper/vinegar_healpot_recipe = 1, // give man a fish and he eats for 1 dae, give them the recipeh and they'll eat for lyfe
					/obj/item/storage/belt/rogue/surgery_bag = 1,
					/obj/item/rogueore/coal = 1,
					/obj/item/folding_alchcauldron_stored = 1,
					)

			if("A THUG, SER!!") // meatball that's dumb and meaty and does nothing but do that, comes with a cudgel to sell that idea better
				H.grant_language(/datum/language/thievescant)
				ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_APPRENTICE, TRUE)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_INT, -1)
				H.change_stat(STATKEY_LCK, -1)
				belt = /obj/item/storage/belt/rogue/leather
				backl = /obj/item/storage/backpack/rogue/satchel
				backpack_contents = list(
					/obj/item/rogueweapon/mace/cudgel = 1,
					/obj/item/signal_horn = 1,
					/obj/item/rogueweapon/huntingknife = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/triumphbeer = 1, // this one is for good luck, you'll need it. And an extra one because you're going to suffer a lot.
					)

			if("A SCAVENGER, SER!!") // squishier glass cannon, fast on your feet, mr. back-and-forth man whose specialty is dragging stuff around and being dodgy. also free combat knife!
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_GRAVEROBBER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.change_stat(STATKEY_CON, -4)
				H.change_stat(STATKEY_SPD, 3)
				H.change_stat(STATKEY_LCK, -1)
				belt = /obj/item/storage/backpack/rogue/satchel/beltpack
				backl = /obj/item/storage/backpack/rogue/backpack
				backpack_contents = list(
					/obj/item/rogueweapon/huntingknife/combat/iron = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/rogueweapon/huntingknife/scissors = 1,
					/obj/item/rogueweapon/shovel/small = 1,
					/obj/item/signal_horn = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/triumphbeer = 1, // this one is for good luck, you'll need it
					/obj/item/rope = 1,
					/obj/item/rogueore/coal = 2,
					/obj/item/rogueore/iron = 1,
					/obj/item/rogueweapon/tongs = 1,
					)

			if("A BATHMAID, SER!!") // requested, basically copying 'some' qualities from the bathmaid, but not all, idk what riding will do for them but it's funny to imagine a bathmaiden on a hog with a whip, as people commented
				H.grant_language(/datum/language/thievescant)
				ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_GOODLOVER, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_NUTCRACKER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/riding, SKILL_LEVEL_MASTER, TRUE) // sigh
				H.change_stat(STATKEY_SPD, 2)
				H.change_stat(STATKEY_INT, -1)
				H.change_stat(STATKEY_CON, -1)
				H.change_stat(STATKEY_STR, -1)
				H.change_stat(STATKEY_WIL, -1)
				H.change_stat(STATKEY_LCK, 1)
				belt = /obj/item/storage/belt/rogue/leather
				backl = /obj/item/storage/backpack/rogue/satchel
				backpack_contents = list(
					/obj/item/soap/bath = 1,
					/obj/item/lockpick/goldpin = 1,
					/obj/item/signal_horn = 1,
					/obj/item/rogueweapon/huntingknife = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/rope = 1,
					)

			if("ALMOST A SQUIRE, SER!!") // probably should start richer to show that this is prolly the most prestigious among the group
				ADD_TRAIT(H, TRAIT_SQUIRE_REPAIR, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_EXPERT_HUNTER, TRAIT_GENERIC)
				H.change_stat(STATKEY_SPD, 1)
				H.change_stat(STATKEY_PER, -1)
				H.change_stat(STATKEY_LCK, -1)
				belt = /obj/item/storage/belt/rogue/leather
				backl = /obj/item/storage/backpack/rogue/satchel
				backpack_contents = list(
					/obj/item/rogueweapon/hammer/stone = 1,
					/obj/item/polishing_cream = 1,
					/obj/item/armor_brush = 1,
					/obj/item/signal_horn = 1,
					/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
					/obj/item/needle/thorn = 1,
					)

			if("ALMOST AN ARMSMAN, SER!!") // this is probably going to be the poster boy, but what can we do
				ADD_TRAIT(H, TRAIT_GUARDSMAN, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_WIL, 1)
				H.change_stat(STATKEY_PER, -2)
				H.change_stat(STATKEY_LCK, -1)
				belt = /obj/item/storage/backpack/rogue/satchel/beltpack
				backl = /obj/item/rogueweapon/shield/heater
				backpack_contents = list(
					/obj/item/rope/chain = 1,
					/obj/item/signal_horn = 1,
					/obj/item/rogueweapon/huntingknife = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1,
					/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 1, // armsmen get a little extra from their folks in the garrison
					/obj/item/reagent_containers/glass/bottle/rogue/triumphbeer = 1, // this one is for good luck, you'll need it
					)


//A note for the Doc!
/obj/item/paper/vinegar_healpot_recipe
	name = "Healing Juice Recipe"
	desc = "One of your finest discoveries. The secret formula to make a healing potion that transcends all alchemy!"
	info = {"
		<font face='Times New Roman' color='#000000'>
		- Get a barrel or a distiller.<br><br>
		- Pour in at least 200 drams of water.<br><br>
		- Go for the Fish Vinegar. That's the potion base.<br><br>
		- Add HONEY, calendula, fish mince, salt, and a healthy dose of love and care. The quantity is as 'as much as it feels right'. You'll understand.<br>
		- Wait a little while.<br><br>
		- Once it stops bubbling and smells like home, it's ready.<br><br>
		- Bottle it with a bottlin' kit.<br><br>
		- Voila!~ This brew is guaranteed to put some hair on your chest; and remember: 'Real Bogdwellers don't whine! They drink wine!'
		</font>
	"}
