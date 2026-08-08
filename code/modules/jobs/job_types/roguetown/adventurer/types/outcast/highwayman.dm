// bogman/disgraced levy larp; the "fighter" of the outcasts. scavenged iron gear n a militia weapon, jman skills
/datum/advclass/outcast/highwayman
	name = "Highwayman"
	tutorial = "Perhaps you were conscripted into the levies, perhaps your luck simply ran out; whatever the case, you now llive on the wrong side of the law. With piecemeal armor and scavenged blades, you take from travellers what you cannot get yourself, all while dodging the forces of the Duchy."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/outcast/highwayman
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_MEDIUMARMOR) // they need to be able to wear bogman drip
	cmode_music = 'sound/music/cmode/towner/combat_towner2.ogg'
	category_tags = list(CTAG_OUTCAST)

	subclass_stats = list( // bit better than a levy, 6 statweight
		STATKEY_CON = 1,
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
	)

	subclass_skills = list(
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
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
	)
	maximum_possible_slots = 3 // these guys have med armor so we theoretically don't want them stacking

// bogman larp outfit. bit of levy gear, but also random scavenged iron gear with some rare steel mixed in
/datum/outfit/job/roguetown/outcast/highwayman/pre_equip(mob/living/carbon/human/H)
	..()
	H.taints_loot = TRUE // it's all scavenged

	var/random_deserter_cloak = rand(1,4)
	switch(random_deserter_cloak)
		if(1)
			cloak = /obj/item/clothing/cloak/tabard/stabard/bog
		if(2)
			cloak = /obj/item/clothing/cloak/tabard/stabard/dungeon
		if(3)
			cloak = /obj/item/clothing/suit/roguetown/armor/longcoat/brown
	var/random_deserter_armor = rand(1,3)
	switch(random_deserter_armor)
		if(1)
			if(prob(1)) // find n replace accident i'm preserving
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light{
					name = "lightweight highwaymanine";
					desc = "What? 'Brigandine?' We're not brigands, why would it be called that?"
					}
			else
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		if(2)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
		if(3)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/scale

	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	neck = /obj/item/clothing/neck/roguetown/coif
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/pick/bronze
	backpack_contents = list(
		/obj/item/rope = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/throwingknife/triumph = 1,
		/obj/item/paper/vinegar_healpot_recipe = 1,
	)

	to_chat(H, span_notice("<b>THE WEAPON I COULD SCROUNGE UP:</b>"))
	to_chat(H, span_info("<b>THE FAMILY SWORD</b> - Journeyman Swords. Comes with a militia falchion."))
	to_chat(H, span_info("<b>A BIG KNIFE</b> - Journeyman Daggers. Comes with a Combat Knife."))
	to_chat(H, span_info("<b>THE LEGENDARY BOG-STICK</b> - Journeyman Maces. Comes with a militia club."))
	to_chat(H, span_info("<b>AN OLDE CATTLE LASH</b> - Journeyman Whips & Flails. Comes with a whip."))
	to_chat(H, span_info("<b>THE FINEST PITCHFORK</b> - Journeyman Polearms. Comes with a militia spear."))
	to_chat(H, span_info("<b>THE GOOD DAE'S GREETINGS</b> - Journeyman Polearms. Comes with a militia Goedendag."))
	to_chat(H, span_info("<b>MINE THRESHER</b> - Journeyman Whips & Flails. Comes with a militia flail."))
	to_chat(H, span_info("<b>A GOOD SHOVEL</b> - Journeyman Axes. Comes with a militia greataxe."))
	to_chat(H, span_info("<b>THE MINER'S PICKAXE</b> - Journeyman Mining. Comes with a militia pickaxe."))
	to_chat(H, span_info("<b>MINE SCYTHE</b> - Journeyman Farming. Comes with a militia scythe."))
	to_chat(H, span_info("<b>THE WHOLE KITCHEN</b> - Journeyman Cooking and Knives. Comes with a mess kit and cleaver."))
	to_chat(H, span_info("<b>THESE GODS-GIVEN FISTS</b> - Journeyman Unarmed & Wrestling. Comes with handwraps."))

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
			"THESE GODS-GIVEN FISTS (Unarmed & Wrestling)",
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

			if ("THESE GODS-GIVEN FISTS (Unarmed & Wrestling)")
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
	outcast_select_bounty(H)

