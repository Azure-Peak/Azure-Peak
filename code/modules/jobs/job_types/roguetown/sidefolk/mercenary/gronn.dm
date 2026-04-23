/datum/advclass/mercenary/gronn
	name = "Gronnic Privateer"
	tutorial = "You are one of many upstarts from Gronn, who sailed from the coastal capital of Danheim to the southern beaches of Azuria in search of a more... honest means of profit than the Sea Raiders of infamy."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/gronn
	class_select_category = CLASS_CAT_GRONN
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_vagarian.ogg'
	subclass_languages = list(/datum/language/gronnic)
	extra_context = "This subclass has 2 loadouts with various stats, skills & equipment."
	subclass_skills = list(
	//Universal skills
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT, //All of you can suck my dick they're SEAMEN
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/mercenary/gronn
	allowed_patrons = ALL_GRONNIC_PATRONS //Subvariant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.

/datum/outfit/job/roguetown/mercenary/gronn/pre_equip(mob/living/carbon/human/H)
	..()

	//Universal gear
	backl = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.

	// CLASS ARCHETYPES
	H.adjust_blindness(-3)
	if(H.mind)
		var/classes = list("Leðurháls - Byrine Grunt", "Skemmdarvargur - Ravager")
		var/classchoice = input(H, "Choose your archetypes", "Available archetypes") as anything in classes

		switch(classchoice)
			if("Leðurháls - Byrine Grunt")	//Medium armor, pick between swords or axes. Boots-on-the-ground for hire. 
				H.set_blindness(0)
				to_chat(H, span_warning("Clad in their unique leatherbound chainmaille and shortsword, The Danheim Leðurháls - roughly translated in Imperial to 'Leatherneck' due to their choice of leather gorgets over forged metal - are known for their harsh dogmatisms and steady personalities."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
				head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn/ownel
				gloves = /obj/item/clothing/gloves/roguetown/chain/gronn
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
				pants = /obj/item/clothing/under/roguetown/chainlegs/gronn
				wrists = /obj/item/clothing/wrists/roguetown/bracers/splint
				backr = /obj/item/rogueweapon/shield/iron
				beltr = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/short/gronn //New heavy shortsword.
				neck = /obj/item/clothing/neck/roguetown/leather
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 2, TRUE)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_PER, 2) //You technically wield a shortsword
				H.change_stat(STATKEY_WIL, 2)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_INT, -1) //Unga swordsman.
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/warrior()
			if("Skemmdarvargur - Ravager")	//Light armor, beast claws or dual handaxes. 
				H.set_blindness(0)
				to_chat(H, span_warning("The Skemmdarvargur are famously known to hail from the northern city of Skugge, the first line of defense for the Northern Empty. Although highly superstitious with their various carved armaments, they lack the mystical miracles of the Iskarn Shamans."))
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
				head = /obj/item/clothing/head/roguetown/helmet/bascinet/atgervi/gronn
				gloves = /obj/item/clothing/gloves/roguetown/angle/gronnfur
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/gronn
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				pants = /obj/item/clothing/under/roguetown/trou/leather/gronn
				neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, 2, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/craft/traps, 3, TRUE)			//Ditto
				H.change_stat(STATKEY_CON, 1)
				H.change_stat(STATKEY_WIL, 2)
				H.change_stat(STATKEY_SPD, 2)
				H.change_stat(STATKEY_PER, 2)
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.dna.species.soundpack_m = new /datum/voicepack/male/evil() //Dodge builds are evil
				var/weapons = list("Handclaws","Dual Handaxes")
				var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
				if(H.mind)
					switch(weapon_choice)
						if("Handclaws")
							H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
							l_hand = /obj/item/rogueweapon/handclaw //You dont get the insane fucking steel or the special Iskarn ones
						if("Dual Handaxes")
							H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
							r_hand = /obj/item/rogueweapon/stoneaxe/handaxe
							l_hand = /obj/item/rogueweapon/stoneaxe/handaxe
							ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	H.merctype = 1

/datum/advclass/mercenary/gronn_heavy
	name = "Fjall Járnklæddur"
	tutorial = "Even within Fjall, few bear witness to the Horned Visages of the Járnklæddur; Ironclad warriors who stand against the undead armies that rise out of the 'Red Blizzard'. Those who do not have the blessing of the Iskarn Shamans within the Northern Empty oft-seek the protection of the Járnklæddur, despite their steep costs."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	maximum_possible_slots = 1 //Hopefully this works.
	outfit = /datum/outfit/job/roguetown/mercenary/gronn_heavy
	class_select_category = CLASS_CAT_GRONN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_HEAVYARMOR)
	cmode_music = 'sound/music/combat_vagarian.ogg'
	subclass_languages = list(/datum/language/gronnic)
	subclass_stats = list(
		STATKEY_WIL = 3, //People see big numbers and start shitting their pants, but their weighted stats are 7 and it's limited to one, singular slot. This is fine. 
		STATKEY_STR = 3, //TO WIELD THE MAUL. THEY CAN'T USE ANY OTHER WEAPON TYPE BUT MACES ANYWAY.
		STATKEY_INT = 2,
		STATKEY_CON = 3,
		STATKEY_PER = -1, //CAN'T SEE SHIT OUTTA THIS THING!!
		STATKEY_SPD = -3 //SLOW AND UNWIELDY
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT, //All of you can suck my dick they're SEAMEN
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/mercenary/gronn_heavy
	allowed_patrons = ALL_GRONNIC_PATRONS //Subvariant of the 'ALL_INHUMEN_PATRONS' tag, with Abyssor and Dendor as situational additions. Do not add any more to this, no matter what.

/datum/outfit/job/roguetown/mercenary/gronn_heavy/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/evil() //It's fucking cool okay
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron/gronn
	head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/gronn
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron/gronn
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron/gronn
	cloak = /obj/item/clothing/cloak/volfmantle			//Aura farming.
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron //Weakspot.
	pants = /obj/item/clothing/under/roguetown/platelegs/iron/gronn
	r_hand = /obj/item/rogueweapon/mace/maul //this is literally the only weapon type they'll get to use. No alternatives.
	neck = /obj/item/clothing/neck/roguetown/bevor/iron //Their weakspot. Go replace it if you're a chud I guess
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/flashlight/flare/torch/lantern

	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/gronn
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/gronn
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/baothagronn
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor/gronn
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor/gronn
		else
			id = /obj/item/clothing/neck/roguetown/psicross/inhumen/gronn/special //Failsafe. Gives a specially-fluffed version of Zizo's talisman, which can be reinterpreted as needed.
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.merctype = 1