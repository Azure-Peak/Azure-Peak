/datum/advclass/mercenary/rumaclan
	name = "Ruma Clan Gun-in"
	tutorial = "A warrior from a band of Kazengite foreigners. The Ruma Clan were outcasts from the Xinyi Dynasty, believed to be associated with the rebels at the time. The clan departed to avoid repercussion. It is no organized group of soldiers, but rather a loose collection of experienced fighters."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_SMALL) //no dwarf sprites
	outfit = /datum/outfit/job/roguetown/mercenary/rumaclan
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_VANGUARD)
	traits_applied = list(TRAIT_BLOOD_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_HONORBOUND)
	cmode_music = 'sound/music/combat_Kazengun_Runaway_Chariot.ogg' //'sound/music/combat_Kazengun_Overlord.ogg' also exists.
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "This subclass is race-limited from: Dwarves."

/datum/outfit/job/roguetown/mercenary/rumaclan/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a warrior of the Clan, peerless with a blade. So long as the coin is good, you have no problem taking up most jobs on behalf of either yourself, your leading Seonjang, or the Clan as a whole."))
	belt = /obj/item/storage/belt/rogue/leather
	cloak = /obj/item/clothing/cloak/eastcloak1
	shirt = /obj/item/clothing/suit/roguetown/armor/manual/meditation/chest/easttats/ruma //light brigadine.
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/roguekey/mercenary = 1,
		)
	H.merctype = 9

/datum/outfit/job/roguetown/mercenary/rumaclan/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		var/tattoos = list("Defiant (Blacksteel, fragile)","Harmonious (Plate, balanced)","Enduring (Padded, durable)")
		var/tattoo_choice = input(H, "Choose your tattoos", "WHAT MARKS DO YOU CARRY?") as anything in tattoos
		switch(tattoo_choice)
			if("Defiant (Blacksteel, fragile)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma/blacksteel //200 blacksteel
			if("Harmonious (Plate, balanced)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma //250 plate
			if("Enduring (Padded, durable)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma/padded //300 padded
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE) //you're going to need it.
		var/clothing = list("White Shirt","Dark Shirt","Dress")
		var/clothing_choice = input(H, "Choose your attire.", "WHAT SILK SWATHES YOU?") as anything in clothing
		switch(clothing_choice)
			if("White Shirt")
				l_hand = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
			if("Dark Shirt")
				l_hand = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
			if("Dress")
				l_hand = /obj/item/clothing/suit/roguetown/shirt/dress/captainrobe
		var/weapons = list("Ruma Hwando (Onehanded sabre)","Golden Ruma Hwando","Ssangsudo (Heavy sword)","Naginata & Tanto (Polearm & dagger)","Kodachi & Tanto (Shortsword & dagger)","Longbow & Kodachi","Longbow & Tanto")
		var/weapon_choice = input(H, "Choose your weapon.", "WHEN STEEL MUST SPEAK...") as anything in weapons
		switch(weapon_choice)
			if("Ruma Hwando (Onehanded sabre)")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/steel
				beltl = /obj/item/rogueweapon/sword/sabre/mulyeog/rumahench
			if("Golden Ruma Hwando")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/gold
				beltl = /obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain
			if("Ssangsudo (Heavy sword)")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/noparry
				beltl = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
			if("Naginata & Tanto (Polearm & dagger)")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE) //j-man suffices for the knife here.
				r_hand = /obj/item/rogueweapon/spear/naginata
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/scabbard/sheath/kazengun
				beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
			if("Kodachi & Tanto (Shortsword & dagger)")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE) //Gets two expert skills due to taking the weaker sword.
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/kazengun
				backl = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				beltr = /obj/item/rogueweapon/scabbard/sheath/kazengun
				beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
			if("Longbow & Kodachi") //You lack the speed to skirmish, so engage with the bow and finish with the blade.
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE) //Balancing for the hefty damage.
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow //Note that you lack the perception to aim this well.
				beltl = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				r_hand = /obj/item/rogueweapon/sword/short/kazengun
			if("Longbow & Tanto") //If you really want to lean into being a ranged combatant.
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE) //Still not as good as a sasu with a recurve.
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltl = /obj/item/rogueweapon/scabbard/sheath/kazengun
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun


/datum/advclass/mercenary/rumaclan_sasu
	name = "Ruma Clan Sasu"
	tutorial = "A skirmisher from a band of Kazengite foreigners. The Ruma Clan were outcasts from the Xinyi Dynasty, believed to be associated with the rebels at the time. The clan departed to avoid repercussion. It is no organized group of soldiers, but rather a loose collection of experienced fighters."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_SMALL) //no dwarf sprites
	outfit = /datum/outfit/job/roguetown/mercenary/rumaclan_sasu
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_MARKSMAN)
	traits_applied = list(TRAIT_BLOOD_RESISTANCE, TRAIT_NOPAINSTUN, TRAIT_HONORBOUND)
	subclass_stats = list(
		STATKEY_SPD = 4,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/rumaclan_sasu/pre_equip(mob/living/carbon/human/H)
	..()
	H.set_blindness(0)
	to_chat(H, span_warning("You are a skirmisher of the Clan, matchless with a bow. So long as the coin is good, you have no problem taking up most jobs on behalf of either yourself, your leading Seonjang, or the Clan as a whole."))
	cloak = /obj/item/clothing/cloak/eastcloak1
	shirt = /obj/item/clothing/suit/roguetown/armor/manual/meditation/chest/easttats/ruma //light brigadine.
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
	shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/roguekey/mercenary = 1,
		)
	H.merctype = 9

/datum/outfit/job/roguetown/mercenary/rumaclan_sasu/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	if(H.mind)
		var/tattoos = list("Defiant (Blacksteel, fragile)","Harmonious (Plate, balanced)","Enduring (Padded, durable)")
		var/tattoo_choice = input(H, "Choose your tattoos", "WHAT MARKS DO YOU CARRY?") as anything in tattoos
		switch(tattoo_choice)
			if("Defiant (Blacksteel, fragile)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma/blacksteel //200 blacksteel
			if("Harmonious (Plate, balanced)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma //250 plate
			if("Enduring (Padded, durable)")
				armor = /obj/item/clothing/suit/roguetown/armor/manual/meditation/body/easttats/ruma/padded //300 padded
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_NOVICE, TRUE) //you're going to need it.
		var/clothing = list("White Shirt","Dark Shirt","Dress")
		var/clothing_choice = input(H, "Choose your attire.", "WHAT SILK SWATHES YOU?") as anything in clothing
		switch(clothing_choice)
			if("White Shirt")
				l_hand = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
			if("Dark Shirt")
				l_hand = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
			if("Dress")
				l_hand = /obj/item/clothing/suit/roguetown/shirt/dress/captainrobe
		var/weapons = list("Recurve & Tanto","Recurve & Kodachi","Sling & Tanto","Sling & Kodachi","Kodachi & Tanto","Kodachi, Tanto, & Tossblades","Dual Tanto","Blacksteel Tanto")
		var/weapon_choice = input(H, "Choose your weapon.", "WHEN STEEL MUST SPEAK...") as anything in weapons
		switch(weapon_choice)
			if("Recurve & Tanto")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_MASTER, TRUE) //Dedicated bow user, best skill there.
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				belt = /obj/item/storage/belt/rogue/leather
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/rogueweapon/scabbard/sheath/kazengun
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
			if("Recurve & Kodachi")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE) //bit more of a hybrid, so a touch less bow skill.
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				belt = /obj/item/storage/belt/rogue/leather
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
				beltl = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				r_hand = /obj/item/rogueweapon/sword/short/kazengun
			if("Sling & Tanto")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_MASTER, TRUE) //Dedicated sling user, best skill there.
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				belt = /obj/item/storage/belt/rogue/leather
				beltr = /obj/item/quiver/sling/iron
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				backl = /obj/item/rogueweapon/scabbard/sheath/kazengun
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
			if("Sling & Kodachi")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_EXPERT, TRUE) //Another hybrid.
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				belt = /obj/item/storage/belt/rogue/leather
				beltr = /obj/item/quiver/sling/iron
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				backl = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				r_hand = /obj/item/rogueweapon/sword/short/kazengun
			if("Kodachi & Tanto") //Melee versatility without sacrificing belt storage.
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				belt = /obj/item/storage/belt/rogue/leather
				r_hand = /obj/item/rogueweapon/sword/short/kazengun
				backl = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				beltr = /obj/item/rogueweapon/scabbard/sheath/kazengun
				beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
			if("Kodachi, Tanto, & Tossblades") //Melee and a touch of ranged versatility, but not much spare belt-room.
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun //uses iron throwing stars for now, no sprite for steel ones.
				r_hand = /obj/item/rogueweapon/sword/short/kazengun
				backl = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				beltr = /obj/item/rogueweapon/scabbard/sheath/kazengun
				beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
			if("Dual Tanto") //Dual wield silliness, or simply to have a backup knife.
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC) //Expect ~25% parry chance vs equal skill, good luck.
				belt = /obj/item/storage/belt/rogue/leather
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
				backl = /obj/item/rogueweapon/scabbard/sheath/kazengun
				beltr = /obj/item/rogueweapon/scabbard/sheath/kazengun
				beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
			if("Blacksteel Tanto")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
				belt = /obj/item/storage/belt/rogue/leather
				beltr = /obj/item/rogueweapon/scabbard/sheath/kazengun
				beltl = /obj/item/rogueweapon/huntingknife/idagger/blacksteel/kazengun
