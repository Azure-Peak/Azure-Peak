//FOR THE BOG!

//intended that none of these get houndstones, you're severely underfunded. Your bog master is loosely loyal to the crown and issues orders/gaslights you/informs you on what issues are around.

//They also have lower skills compared to proper garrison, they're on-par with towners outside of the bogs, somewhere between adventurers and mercenaries inside.
//The idea is that you'll train off of sparring your bogmaster, who'll probably try to convince a knight to train their levy, or the vet. But the crown might not want that either, since you're not the most truthworthy.
/datum/job/roguetown/bogguard //Half-competent idiots, unlike wardens/garrison. they're complete underpaid, undertrained idiots that barely know what they're doing.
	title = "Bog Guard"
	flag = BOGGUARD
	department_flag = LEVY
	faction = "Station"
	total_positions = 7 //I expect you to die, also intended that the bogmaster recruits people.
	spawn_positions = 7
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_DESPISED)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "When the bailiff came to your household it was the worst dae of your lyfe, dragging you away into service to the Crown with nothing more but whatever household object you managed to piece together into a weapon. \
				Safeguard your home from the terrors beyond the gates of the bog and those foolish enough to venture further into the terrorbog. You answer to the bogmaster, the smartest idiot out of all of you."
	display_order = JDO_BOGGUARD
	selection_color = JCOLOR_LEVY
	whitelist_req = TRUE
	round_contrib_points = 2

	outfit = /datum/outfit/job/roguetown/bogguard
	advclass_cat_rolls = list(CTAG_BOGGUARD = 20)

	give_bank_account = TRUE
	min_pq = 1 //Incompetency is kind of sovl for this role, you're literally a trained idiot with a weapon. We want people to sort of know esc though, not first round role.
	max_pq = null
	cmode_music = 'sound/music/combat_bog.ogg'
	job_subclasses = list(
		/datum/advclass/bogguard/boglevy,
		/datum/advclass/bogguard/bogranger
	)

/datum/outfit/job/roguetown/bogguard
	job_bitflag = BITFLAG_HALF_COMBATANT //Likely to be pulled in once all-else fails. You're not a true combatant though, too slow, dumb and untrained to be. You can skill up to be, but you need a vet/knight. Also doesn't have a houndstone.

/datum/outfit/job/roguetown/bogguard
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog

/datum/job/roguetown/bogguard/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/stabard/bog))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "bogman surcoat ([index])"

/datum/advclass/bogguard/boglevy
	name = "Bog Footman"
	tutorial = "You're one of many before you, a member of the Bog Guard, the Crown's woefully underpaid militiamen. You have a roof over your head, sometimes you have coin in your pocket, and a thankless job protecting the bog from bandits, deadites and whatever other horrors lie within."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/bogguard/boglevy
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_BOGLEVY)
	category_tags = list(CTAG_BOGGUARD)
	subclass_stats = list(
		STATKEY_CON = 1,
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_INT = -1, //BOG! BOG! BOG!
		STATKEY_SPD = -1 //Slower outside of the bog.
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, //BOG TACKLE
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE, //Barely literate
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE, //So you can at least attempt to (horribly fail to) help stabilise advs from dying.
	)

/datum/outfit/job/roguetown/bogguard/boglevy/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/skullcap
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	mask = /obj/item/clothing/head/roguetown/armingcap
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/bog
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/mace/cudgel
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/needle/thorn = 1,
		/obj/item/storage/keyring/boglevy = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		)

	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		var/weapons = list("MINE PITCHFORK","MINE THRESHER", "THE FAMILY SWORD", "MINE SHOVEL")
		var/weapon_choice = input(H, "Choose your improvised weapon.", "WHAT DID YOU TAKE FROM YOUR HOME?") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("MINE PITCHFORK")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/militia
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("MINE THRESHER")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/militia
				backl = /obj/item/rogueweapon/shield/wood
			if ("THE FAMILY SWORD")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/falchion/militia
				backl = /obj/item/rogueweapon/shield/wood
			if ("MINE SHOVEL")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/militia
				backl = /obj/item/rogueweapon/scabbard/gwstrap
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_DESTITUTE, H)

/datum/advclass/bogguard/bogranger
	name = "Bog Ranger"
	tutorial = "You're one of many before you, a member of the Bog Guard, the Crown's woefully underpaid militiamen. You have a roof over your head, sometimes you have coin in your pocket, and a thankless job protecting the bog from bandits, deadites and whatever other horrors lie within."
	allowed_sexes = list(MALE, FEMALE)
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT, TRAIT_BOGLEVY)
	outfit = /datum/outfit/job/roguetown/bogguard/bogranger
	//No special traits sire, you're just a ranger bogman
	category_tags = list(CTAG_BOGGUARD)
	townie_contract_gate_exempt = TRUE //Sure I guess
	subclass_stats = list( //buffed up, you're an actual faction now.
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_INT = -1, //BOG! BOG! BOG!
		STATKEY_SPD = -1 //Slower outside of the bog.
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE, //Barely literate
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE, //So you can at least attempt to (horribly fail) help stabilise advs from dying.
	)

/datum/outfit/job/roguetown/bogguard/bogranger/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/skullcap
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/head/roguetown/armingcap
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/bog
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/mace/cudgel
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/needle/thorn = 1,
		/obj/item/natural/cloth = 1,
		/obj/item/storage/keyring/boglevy = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		)

	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		var/weapons = list("THE FAMILY BOW","MINE SLING") //No crossbows sadly because slurbows exist and people will ruin the funny gimmic of being a knockoff guardsman
		var/weapon_choice = input(H, "Choose your weapon.", "WHAT DID YOU TAKE FROM YOUR HOME?") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("THE FAMILY BOW") // They can head down to the armory to sideshift into one of the other bows.
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
			if("MINE SLING")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/quiver/sling/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling // Both are belt slots and it's not worth setting where the cugel goes for everyone else, sad.
	if(H.mind)
		SStreasury.grant_savings(ECONOMIC_DESTITUTE, H)
