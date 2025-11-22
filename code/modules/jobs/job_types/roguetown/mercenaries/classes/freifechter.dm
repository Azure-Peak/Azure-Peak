/datum/advclass/mercenary/freelancer
	name = "Freifechter"
	tutorial = "You are a graduate of the Aavnic Freifechters - \"Freelancers\" - a prestigious fighting guild localized in the independent City-state of Szöréndnížina, recognized as an encomium to Ravox by the Holy See. It has formed an odd thirty yils ago, but its visitors come from all over Western Psydonia. You have swung one weapon ten-thousand times, and not the other way around. This class is for experienced combatants who have a solid grasp on footwork and stamina management, master skills alone won't save your lyfe."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/freelancer
	subclass_languages = list(/datum/language/aavnic)//Your character could not have possibly "graduated" without atleast some basic knowledge of Aavnic.
	class_select_category = CLASS_CAT_AAVNR
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_noble.ogg'
	traits_applied = list(TRAIT_BADTRAINER)
	//To give you an edge in specialty moves like feints and stop you from being feinted
	subclass_stats = list(
		STATKEY_INT = 4,
		STATKEY_PER = 3,
		STATKEY_CON = 2
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,	//I got told that having zero climbing is a PITA. Bare minimum for a combat class.
	)

/datum/outfit/job/roguetown/mercenary/freelancer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a master in the arts of the longsword. Wielder of Psydonia's most versatile and noble weapon, you needn't anything else. You can choose a regional longsword."))
	l_hand = /obj/item/rogueweapon/scabbard/sword
	var/weapons = list("Modified Training Sword !!!CHALLENGE!!!", "Etruscan Longsword", "Kriegsmesser", "Field Longsword")
	if(H.mind)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Modified Training Sword !!!CHALLENGE!!!")		//A sharp feder. Less damage, better defense. Definitely not a good choice.
				r_hand = /obj/item/rogueweapon/sword/long/frei
				beltr = /obj/item/rogueweapon/huntingknife/idagger
			if("Etruscan Longsword")		//A longsword with a compound ricasso. Accompanied by a traditional flip knife.
				r_hand = /obj/item/rogueweapon/sword/long/etruscan
				beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja
			if("Kriegsmesser")		//Och- eugh- German!
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser
				beltr = /obj/item/rogueweapon/huntingknife/idagger
			if("Field Longsword")		//A common longsword.
				r_hand = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/rogueweapon/huntingknife/idagger

		if(H.mind)
			var/armors = list(
				"Fencing Jacket"	= /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter,
				"Fencing Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer
			)
			var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
			armor = armors[armorchoice]

	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backr = /obj/item/storage/backpack/rogue/satchel/short

	backpack_contents = list(/obj/item/roguekey/mercenary)	
	H.merctype = 6

/datum/advclass/mercenary/freelancer/lancer
	name = "Lancer"
	tutorial = "You put complete trust in your polearm, the most effective weapon the world has seen. Why wear armour when you cannot be hit? You can choose your polearm, and are exceptionally accurate."
	outfit = /datum/outfit/job/roguetown/mercenary/freelancer_lancer
	subclass_languages = list(/datum/language/aavnic)//Your character could not have possibly "graduated" without atleast some basic knowledge of Aavnic.
	traits_applied = list(TRAIT_BADTRAINER)
	subclass_stats = list(
		STATKEY_CON = 2,
		STATKEY_PER = 3,
		STATKEY_STR = 1,
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,	//This is the danger zone. Ultimately, the class won't be picked without this. I took the liberty of adjusting everything around to make this somewhat inoffensive, but we'll see if it sticks.
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,	//Wrestling is a swordsman's luxury.
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,	//I got told that having zero climbing is a PITA. Bare minimum for a combat class.
	)

/datum/outfit/job/roguetown/mercenary/freelancer_lancer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You put complete trust in your polearm, the most effective weapon the world has seen. Why wear armour when you cannot be hit? You can choose your polearm, and are exceptionally accurate."))
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	var/weapons = list("Graduate's Spear", "Boar Spear", "Lucerne")
	if(H.mind)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Graduate's Spear")		//A steel spear with a cool-looking stick & a banner sticking out of it.
				r_hand = /obj/item/rogueweapon/spear/boar/frei
				l_hand = /obj/item/rogueweapon/katar/punchdagger/frei
			if("Boar Spear")
				r_hand = /obj/item/rogueweapon/spear/boar
				wrists = /obj/item/rogueweapon/katar/punchdagger
			if("Lucerne")		//A normal lucerne for the people that get no drip & no bitches.
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				wrists = /obj/item/rogueweapon/katar/punchdagger

	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backr = /obj/item/storage/backpack/rogue/satchel/short

	backpack_contents = list(/obj/item/roguekey/mercenary)
	H.merctype = 6
