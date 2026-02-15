/datum/advclass/mercenary/freelancer
	name = "Freifechter Fencer"
	tutorial = "You are a graduate of the Aavnic Freifechters - \"Freelancers\" - part of a prestigious fighting guild localized in the independent City-state of Szöréndnížina. It has formed an odd thirty yils ago, but its visitors come from all over Western Psydonia. You have swung one weapon ten-thousand times, and not the other way around. Your faith is stalwart in the teachings of the Psydonic Reformation, and you've become a warrior poet of sorts - educating the peasantry in the ways of the New Word and angering the Orthodoxy in turn. You've left your cradle in search of riches to fund your people's armies."
	extra_context = "This class is for experienced players who have a solid grasp on footwork and stamina management, master skills alone won't save your lyfe. You make up for your inherent weaknesses and limitations with \"master strike\" mechanics."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/freelancer
	subclass_languages = list(/datum/language/aavnic)//Your character could not have possibly "graduated" without atleast some basic knowledge of Aavnic.
	allowed_patrons = list(/datum/patron/old_god)
	class_select_category = CLASS_CAT_AAVNR
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/frei_fencer.ogg'
	traits_applied = list(TRAIT_BADTRAINER, TRAIT_INTELLECTUAL, TRAIT_LONGSWORDSMAN, TRAIT_FENCERDEXTERITY)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 3,
		STATKEY_WIL = 3
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 12, STAT_SPEED = 12)

/datum/outfit/job/roguetown/mercenary/freelancer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a master in the arts of the longsword. Wielder of Psydonia's most versatile and noble weapon, you needn't anything else. Your professionally made longsword facilitates moves from fechtbuchs the likes of The Etruscan Flower and Grenzelhoft's Wiedenhauer."))
	l_hand = /obj/item/rogueweapon/scabbard/sword
	var/weapons = list("Etruscan Longsword", "Reformist Longsword")
	if(H.mind)
		var/weapon_choice = input(H, "Draw a sword.", "As presented to me by Master Oktawiusz...") as anything in weapons
		switch(weapon_choice)
			if("Etruscan Longsword")		//A longsword with a compound ricasso. Accompanied by a traditional flip knife.
				r_hand = /obj/item/rogueweapon/sword/long/etruscan
				beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter
			if("Reformist Longsword")
				r_hand = /obj/item/rogueweapon/sword/long/etruscan/freifechter
				beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter

		if(H.mind)
			var/armors = list(
				"Fencing Jacket"	= /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter,
				"Fencing Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer
			)
			var/armorchoice = input(H, "Don your armour.", "Security or Flexibility?") as anything in armors
			armor = armors[armorchoice]

	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/freifechter
	backr = /obj/item/storage/backpack/rogue/satchel/short
	neck = /obj/item/clothing/neck/roguetown/psicross/reform

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1
		)	
	H.merctype = 6

/datum/advclass/mercenary/freelancer/lancer
	name = "Freifechter Lancer"
	tutorial = "You are a graduate of the Aavnic Freifechters - \"Freelancers\" - part of a prestigious fighting guild localized in the independent City-state of Szöréndnížina. It has formed an odd thirty yils ago, but its visitors come from all over Western Psydonia. You have swung one weapon ten-thousand times, and not the other way around. A Lancer and his pike are inseparable, and the first line of offense. You can choose to display the banners of the Reformist Order or your own State."
	extra_context = "This class is for experienced players who have a solid grasp on footwork and stamina management, master skills alone won't save your lyfe. You make up for your inherent weaknesses and limitations with unique high-durability weapons."
	cmode_music = 'sound/music/frei_lancer.ogg'
	outfit = /datum/outfit/job/roguetown/mercenary/freelancer_lancer
	subclass_languages = list(/datum/language/aavnic)//Your character could not have possibly "graduated" without atleast some basic knowledge of Aavnic.
	allowed_patrons = list(/datum/patron/old_god)
	traits_applied = list(TRAIT_BADTRAINER, TRAIT_FENCERDEXTERITY, TRAIT_INTELLECTUAL)
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
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 13, STAT_SPEED = 12, STAT_WILLPOWER = 14)	//Prevent climbing to 14 by picking a +1 STR race.

/datum/outfit/job/roguetown/mercenary/freelancer_lancer/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You put complete trust in your polearm, the most effective weapon the world has seen. Why wear armour when you cannot be hit? You can choose to display the banners of the Reformist Order or your own State."))
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	var/weapons = list("Graduate's Spear", "Banner of Szöréndnížina", "Banner of Psydonic Reformism")
	if(H.mind)
		var/weapon_choice = input(H, "Spear or Pike-Banner?", "As presented to me by Lance-Master Szörénsław...") as anything in weapons
		switch(weapon_choice)
			if("Graduate's Spear")		//A steel spear with a cool-looking stick & a banner sticking out of it.
				r_hand = /obj/item/rogueweapon/spear/boar/frei
				l_hand = /obj/item/rogueweapon/katar/punchdagger/frei
			if("Banner of Szöréndnížina")
				r_hand = /obj/item/rogueweapon/spear/boar/frei/pike
				wrists = /obj/item/rogueweapon/katar/punchdagger/frei
			if("Banner of Psydonic Reformism")
				r_hand = /obj/item/rogueweapon/spear/boar/frei/pike/reformist
				wrists = /obj/item/rogueweapon/katar/punchdagger/frei

	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/freifechter
	backr = /obj/item/storage/backpack/rogue/satchel/short
	neck = /obj/item/clothing/neck/roguetown/psicross/reform

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1
		)
	H.merctype = 6

/datum/advclass/mercenary/freelancer/sabrist
	name = "Freifechter Sabrist"
	tutorial = "You are a graduate of the Aavnic Freifechters - \"Freelancers\" - part of a prestigious fighting guild localized in the independent City-state of Szöréndnížina. It has formed an odd thirty yils ago, but its visitors come from all over Western Psydonia. You have swung one weapon ten-thousand times, and not the other way around. Your faith is stalwart in the teachings of the Psydonic Reformation, and you've become a warrior poet of sorts - educating the peasantry in the ways of the New Word and angering the Orthodoxy in turn. You've left your cradle in search of riches to fund your people's armies. Sabrists are renowned for their dexterity and speed, but lack the adaptability of longswordmen."
	extra_context = "This class is for experienced players who have a solid grasp on footwork and stamina management, master skills alone won't save your lyfe. You make up for your inherent weaknesses and limitations with \"master strike\" mechanics."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/sabrist
	subclass_languages = list(/datum/language/aavnic)//Your character could not have possibly "graduated" without atleast some basic knowledge of Aavnic.
	allowed_patrons = list(/datum/patron/old_god)
	class_select_category = CLASS_CAT_AAVNR
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/frei_sabre.ogg'
	traits_applied = list(TRAIT_BADTRAINER, TRAIT_INTELLECTUAL, TRAIT_FENCERDEXTERITY, TRAIT_SABRIST)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 3,
		STATKEY_SPD = 2
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 12)

/datum/outfit/job/roguetown/mercenary/sabrist/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a master in the arts of the sabre. Wielder of Aavnr's sword by excellence, you needn't anything else. Your professionally made sabre facilitates moves from traditional Aavnic fencing treatises."))
	if(H.mind)
		var/armors = list(
		"Fencing Jacket"	= /obj/item/clothing/suit/roguetown/armor/leather/heavy/freifechter,
		"Fencing Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer
		)
		var/armorchoice = input(H, "Don your armour.", "Security or Flexibility?") as anything in armors
		armor = armors[armorchoice]
	l_hand = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre/freifechter
	beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/flashlight/flare/torch/lantern
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/freifechter
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain	//Obsessed with arms-hands. Keeping them protected on-spawn.
	backr = /obj/item/storage/backpack/rogue/satchel/short
	neck = /obj/item/clothing/neck/roguetown/psicross/reform

	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1
		)	
	H.merctype = 6
