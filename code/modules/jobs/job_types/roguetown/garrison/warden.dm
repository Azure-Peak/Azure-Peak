/datum/job/roguetown/warden
	title = "Warden"
	flag = WARDEN
	department_flag = GARRISON
	faction = "Station"
	total_positions = 4
	spawn_positions = 4

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "You are a volunteer with the Wardens; a fraternity of rangers who keep a vigil over Azuria's untamed wilderness. \
				While you may not be a professional soldier, you nevertheless serve the Duchy as the first line of defense against outside threats. \
				Obey your Sergeant-at-Arms, the Marshal, and the Crown. Serve their will, and you will receive that which a Warden covets most - freedom and safety."

	display_order = JDO_WARDEN
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/warden
	advclass_cat_rolls = list(CTAG_WARDEN = 20)

	give_bank_account = TRUE
	min_pq = 0
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg'
	job_traits = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_WOODSMAN, TRAIT_SURVIVAL_EXPERT, TRAIT_EXPERT_HUNTER)
	job_subclasses = list(/datum/advclass/warden/warden)

/datum/outfit/job/roguetown/warden
	neck = /obj/item/clothing/neck/roguetown/coif/padded
	cloak = /obj/item/clothing/cloak/wardencloak
	backr = /obj/item/storage/backpack/rogue/satchel
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded/warden
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	id = /obj/item/scomstone/bad/garrison
	job_bitflag = BITFLAG_GARRISON //Counts towards overall combat roles

/datum/advclass/warden/warden
	name = "Warden"
	tutorial = "You are a Warden; a guerilla beneath the Crown's command, a ranger of Azuria's sparsely populated woods, and the first line of defense against whatever foulness befalls this fief."
	extra_context = "Wardens receive a boost to Perception, Willpower, and Speed when traveling within the 'Azurian Grove' biome. When outside this biome, their statblock - compared to the Man-at-Arms - is slightly reduced."
	outfit = /datum/outfit/job/roguetown/warden/warden
	category_tags = list(CTAG_WARDEN)
	subclass_stats = list(
		STATKEY_PER = 2, //(4 with buff)
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 2, //(3 with buff)
		STATKEY_SPD = 1 //(2 with buff)
	)//8 points weighted, look at their buff to understand as to why.
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/butchering = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/warden/warden/pre_equip(mob/living/carbon/human/H)
	..()
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/warden_machete = 1,
		/obj/item/storage/keyring/warden = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		/obj/item/signal_horn = 1,
		/obj/item/hunting_map/boars = 1,
		)
	H.verbs |= /mob/proc/haltyell
	H.set_blindness(0)

	if(H.mind)
		var/armor_options = list("Light - Dodge Expert, Padded Gambeson", "Medium - Maille Training, Iron Hauberk")
		var/armor_choice = input(H, "Choose your ARMOR.", "PREPARE FOR THE HUNT-TO-COME.") as anything in armor_options
		switch(armor_choice) //Like Skirmisher, you are not getting both. Choose wisely.
			if("Light - Dodge Expert, Padded Gambeson")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
			if("Medium - Maille Training, Iron Hauberk")
				wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

		var/weapon_options = list("Bowhunter - Blackhorn Bow + 20 Broadheads", "Spearhunter - Spear + Sling, +I STR / -I SPD")
		var/weapon_choice = input(H, "Choose your SPECIALITY.", "JACK OF MANY TRADES, MASTER OF NONE.") as anything in weapon_options
		switch(weapon_choice)
			if("Bowhunter - Blackhorn Bow + 20 Broadheads")
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/warden
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE)
			if("Spearhunter - Spear + Sling, +I STR / -I SPD")
				beltr = /obj/item/quiver/sling/iron
				r_hand = /obj/item/rogueweapon/spear
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
				H.change_stat(STATKEY_SPD, -1)
				H.change_stat(STATKEY_STR, 1)

		var/helmets = list(
			"Path of the Antelope" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/antler,
			"Path of the Volf"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/wolf,
			"Path of the Ram"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/goat,
			"Path of the Bear"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/bear,
			"Path of the Rous"		= /obj/item/clothing/head/roguetown/helmet/sallet/warden/rat,
			"None"
		)
		var/helmchoice = input(H, "Choose your HELMET.", "FOLLOW THE PATH OF YOUR ANCESTORS.") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/hoods = list(
			"Common Shroud" 	= /obj/item/clothing/head/roguetown/roguehood/warden,
			"Antlered Shroud"		= /obj/item/clothing/head/roguetown/roguehood/warden/antler,
			"None"
		)
		var/hoodchoice = input(H, "Choose your SHROUD.", "LEST THEY SEE THE WHITES OF YOUR EYES.") as anything in hoods
		if(hoodchoice != "None")
			mask = hoods[hoodchoice]
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_LOWER_MIDDLE_CLASS, H)
