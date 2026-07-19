/datum/advclass/levy
	name = "Levy"
	tutorial = "When the Bailiff came knocking for you, it was the worst dae of your lyfe. Hastily pressed into the Crown's service with little more than a helmet, a household tool turned weapon and a bottle of beer for comfort, you joined the Levy squad.<br><br>As one of Azurea's so-called \"folk-heroes\", you are first to answer a peasant's reports of danger beyond the walls. Find the problem and solve it yourself or, if dire, send word for backup, and hold the line until the Armsmen or Wardens arrive to earn their keep."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	
	outfit = /datum/outfit/job/roguetown/adventurer/levy
	traits_applied = list(TRAIT_LEVY, TRAIT_HOMESTEAD_EXPERT)
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
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/pick/bronze
	backpack_contents = list(
		/obj/item/rope = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/signal_horn = 1,
	)
	
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

			if ("THE LEGENDARY BOG-STICK (Club)")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/woodclub/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather

			if ("AN OLDE CATTLE LASH (Whip)")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/whip
				gloves = /obj/item/clothing/gloves/roguetown/leather

			if("THE FINEST PITCHFORK (Polearm)")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather
				backr = /obj/item/rogueweapon/scabbard/gwstrap

			if("MINE THRESHER (Flail)")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather

			if("MINE WAR THRESHER (Flail, 2H)")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/peasantwarflail
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				gloves = /obj/item/clothing/gloves/roguetown/leather

			if("THE GOOD DAE'S GREETINGS (Polearm)")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/woodstaff/militia
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				gloves = /obj/item/clothing/gloves/roguetown/leather

			if ("A GOOD SHOVEL (Axe)")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather
				backr = /obj/item/rogueweapon/scabbard/gwstrap

			if ("THE MINER'S PICKAXE (Pickaxe)")
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/pick/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather

			if ("MINE SCYTHE (Scythe)")
				H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/scythe/militia
				gloves = /obj/item/clothing/gloves/roguetown/leather
				backr = /obj/item/rogueweapon/scabbard/gwstrap

			if ("A BIG KNIFE (Dagger)")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/rogueweapon/huntingknife/combat/iron
				backr = /obj/item/rogueweapon/scabbard/sheath
				gloves = /obj/item/clothing/gloves/roguetown/leather

			if ("THE WHOLE KITCHEN (Mess Kit + Cleaver)")
				H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/storage/gadget/messkit
				l_hand = /obj/item/rogueweapon/huntingknife/chefknife/cleaver
				gloves = /obj/item/clothing/gloves/roguetown/leather

			if ("THE BOGMAN'S BOW (Sling)")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/leather
				r_hand = /obj/item/quiver/sling/iron
				l_hand = /obj/item/quiver/sling/iron
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/sling/wood/bog

			if ("THE RELIABLE VOLFKILLER (Staff)")
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/leather
				backr = /obj/item/rogueweapon/woodstaff/quarterstaff/virtue

			if ("THESE GODS-GIVEN FISTS (Unarmed)")
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist


	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_DESTITUTE, H)

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
