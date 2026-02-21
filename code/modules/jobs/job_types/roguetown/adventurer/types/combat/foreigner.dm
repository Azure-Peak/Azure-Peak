/datum/advclass/foreigner
	name = "Eastern Warrior"
	tutorial = "A warrior hailing from the distant land of Kazengun, far across the eastern sea."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES // Clothing has no dwarf sprites.
	outfit = /datum/outfit/job/roguetown/adventurer/foreigner
	class_select_category = CLASS_CAT_NOMAD
	traits_applied = list(TRAIT_STEELHEARTED)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	subclass_languages = list(/datum/language/kazengunese)
	cmode_music = 'sound/music/combat_kazengite.ogg'
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE, 
	)

/datum/outfit/job/roguetown/adventurer/foreigner/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("A warrior hailing from the distant land of Kazengun, far across the eastern sea."))
	head = /obj/item/clothing/head/roguetown/mentorhat
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/recipe_book/survival = 1,
		/obj/item/flashlight/flare/torch/lantern,
		)
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Naginata","Quarterstaff","Hwando")
		var/weapon_choice = input(H, "Choose your weapon", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Naginata")
				r_hand = /obj/item/rogueweapon/spear/naginata
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
				armor = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit
			if("Quarterstaff")
				backr = /obj/item/rogueweapon/woodstaff/quarterstaff/steel
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, 4, TRUE)
				armor = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit
			if("Hwando")
				beltl = /obj/item/rogueweapon/sword/sabre/mulyeog
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun
				armor = /obj/item/clothing/suit/roguetown/armor/basiceast
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)

/datum/advclass/foreigner/yoruku
	name = "Eastern Assassin"
	tutorial = "The Yoruku are Kazengun agents trained in assassination, sabotage, and irregular combat. You are armed with daggers or a short sword, perfect \
	for combat in the tight confines of castles and back alleys."
	allowed_races = NON_DWARVEN_RACE_TYPES //Clothing has no dwarf sprites.
	outfit = /datum/outfit/job/roguetown/adventurer/yoruku
	subclass_languages = list(/datum/language/kazengunese)
	cmode_music = 'sound/music/combat_kazengite.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/yoruku/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("The Yoruku are Kazengun agents trained in assassination, sabotage, and irregular combat. You are armed with daggers or a short sword, perfect \
	for combat in the tight confines of castles and back alleys."))
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/yoruku
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/bomb/smoke = 3,
		)
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/kazengun
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt1
	cloak = /obj/item/clothing/cloak/thief_cloak/yoruku
	shoes = /obj/item/clothing/shoes/roguetown/boots
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Tanto","Kodachi")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Tanto")
				beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
				beltl = /obj/item/rogueweapon/scabbard/sheath/kazengun
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			if("Kodachi")
				beltr = /obj/item/rogueweapon/sword/short/kazengun
				beltl = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		var/masks = list("Oni","Kitsune")
		var/mask_choice = input(H, "Choose your mask.", "HIDE YOURSELF") as anything in masks
		switch(mask_choice)
			if("Oni")
				mask = /obj/item/clothing/mask/rogue/facemask/yoruku_oni
			if("Kitsune")
				mask = /obj/item/clothing/mask/rogue/facemask/yoruku_kitsune

/datum/advclass/foreigner/repentant
	name = "Otavan Repentant"
	tutorial = "An exile from the Holy See of Otava, accused of heresy and cast out of your homeland as penance. \
	Some consider yours a fate worse than death; the metal alloy mask seared onto your face serving as a permanent reminder of your sins. \
	You are a living example of what becomes of those who stand in defiance of the Otavan inquisition."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/repentant
	subclass_languages = list(/datum/language/otavan)
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_NOPAINSTUN)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_SPD = -1,
		STATKEY_STR = -1,
		STATKEY_WIL = 3,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/repentant/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("An exile from the Holy See of Otava, accused of heresy and cast out of your homeland as penance. \
	Some consider yours a fate worse than death; the metal alloy mask seared onto your face serving as a permanent reminder of your sins. \
	You are a living example of what becomes of those who stand in defiance of the Otavan inquisition."))
	mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched
	wrists = /obj/item/clothing/neck/roguetown/psicross
	shirt = /obj/item/clothing/cloak/tabard/psydontabard
	gloves = /obj/item/clothing/gloves/roguetown/chain/psydon
	shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	backr = /obj/item/storage/backpack/rogue/satchel/otavan
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	head = /obj/item/clothing/head/roguetown/roguehood/psydon
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/whip
	backpack_contents = list(/obj/item/recipe_book/survival = 1, 
						/obj/item/rogueweapon/huntingknife = 1)

/datum/advclass/foreigner/refugee
	name = "Naledi Refugee"
	tutorial = "An asylum-seeker from the war-torn deserts of Naledi, driven north as your homeland continues to be ravaged by an endless conflict against the Djinn."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/refugee
	subclass_languages = list(/datum/language/celestial)
	cmode_music = 'sound/music/warscholar.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_WIL = 1,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/adventurer/refugee/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("An asylum-seeker from the war-torn deserts of Naledi, \
	driven north as your homeland continues to be ravaged by an endless conflict against the Djinn."))
	mask = /obj/item/clothing/mask/rogue/lordmask/tarnished
	r_hand = /obj/item/rogueweapon/spear/assegai
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/neck/roguetown/psicross/naledi
	shoes = /obj/item/clothing/shoes/roguetown/sandals
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian
	pants = /obj/item/clothing/under/roguetown/skirt/black
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black
	beltr = /obj/item/flashlight/flare/torch/lantern
	backpack_contents = list(/obj/item/recipe_book/survival = 1, 
						/obj/item/rogueweapon/huntingknife = 1)

/datum/advclass/foreigner/slaver
	name = "Ranesheni Slaver"
	tutorial = "In parts of Psydonia, the practice of slavery is still a common sight. \
	You hail from the Ranesheni Empire, where the market of flesh is ancient and unbroken, and your coin is earned in the trade of living souls."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/slaver
	subclass_languages = list(/datum/language/celestial)
	cmode_music = 'sound/music/combat_desertrider.ogg'
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
	) // Spawns with a variety of jman skills and fairly good medium armor.

/datum/outfit/job/roguetown/adventurer/slaver/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("In parts of Psydonia, the practice of slavery is still a common sight. \
	You hail from the Ranesheni Empire, where the market of flesh is ancient and unbroken, and your coin is earned in the trade of living souls."))
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/purple
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/purple
	belt = /obj/item/storage/belt/rogue/leather/shalal/purple
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	cloak = /obj/item/clothing/cloak/cape/purple
	backr = /obj/item/rogueweapon/shield/heater
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/sword/long/shotel
	backpack_contents = list(/obj/item/rope/chain = 2, 
							/obj/item/storage/belt/rogue/pouch/coins/poor = 1, 
							/obj/item/recipe_book/survival = 1, 
							/obj/item/rogueweapon/huntingknife = 1)


/datum/advclass/foreigner/shepherd
	name = "Szöréndnížine Shepherd"
	tutorial = "You're a simple shepherd hailing from Aavnr's Free City, taking a pilgrimage or having fled for one reason or another. You can easily fend for yourself in the wilderness, and with enough practice, fend for yourself in combat against even armoured opponents with your traditional axe."
	extra_context = "This class is for experienced adventurers with a solid grasp on footwork and stamina management. Your weapon has special intents you can juggle through to make fights easier... Sometimes."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	subclass_languages = list(/datum/language/aavnic)
	outfit = /datum/outfit/job/roguetown/adventurer/freishepherd
	traits_applied = list()
	cmode_music = 'sound/music/frei_shepherd.ogg'
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_CON = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/freishepherd/pre_equip(mob/living/carbon/human/H)
	..()
	mask = /obj/item/clothing/head/roguetown/armingcap
	head = /obj/item/clothing/head/roguetown/chaperon/greyscale/shepherd
	neck = /obj/item/clothing/neck/roguetown/psicross/reform
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter/shepherd
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/rogueweapon/stoneaxe/battle/steppesman/chupa
	beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/shepherd
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flashlight/flare/torch = 1,
						)

/datum/advclass/foreigner/fencerguy
	name = "Foreign Fencer"
	tutorial = "You're an itinerant weapons expert that was trained in a Grenzelhoftian fencing school, carrying with you your weapon, your skillset, your pride... And not much else, frankly."
	extra_context = "This is a freeform class that's meant to evoke a similar feeling to playing a Freifechter, your equipment and skillset is limited compared to other classes - this is by design - but you start with cool weapons."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/fencerguy
	subclass_languages = list(/datum/language/grenzelhoftian)
	cmode_music = 'sound/music/cmode/adventurer/combat_outlander2.ogg'
	traits_applied = list(TRAIT_INTELLECTUAL, TRAIT_FENCERDEXTERITY)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_PER = 3,
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/adventurer/fencerguy/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You're an itinerant weapons expert that was trained in a Grenzelhoftian fencing school, carrying with you your weapon, your skillset, and your pride."))
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Balanced Longsword","Spear & Punch Dagger","Sabre")
		var/weapon_choice = input(H, "Choose your expertise.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Balanced Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/long/fencerguy
				r_hand = /obj/item/rogueweapon/huntingknife/combat
				backr = /obj/item/rogueweapon/scabbard/sword
			if("Spear & Punch Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/rogueweapon/spear/boar
				r_hand = /obj/item/rogueweapon/katar/punchdagger
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Sabre")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/sabre
				r_hand = /obj/item/rogueweapon/huntingknife/idagger
				beltr = /obj/item/rogueweapon/scabbard/sword
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	neck = /obj/item/clothing/neck/roguetown/fencerguard/generic
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
	backl = /obj/item/storage/backpack/rogue/satchel
	belt = /obj/item/storage/belt/rogue/leather
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
		)

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/civilian
	name = "shawl"
	desc = "Thick and protective while remaining light and breezy; the perfect garb for protecting one from the hot sun and the harsh sands of Naledi."
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/black
	color = CLOTHING_BLACK

/obj/item/storage/belt/rogue/leather/shalal/purple
	color = CLOTHING_PURPLE

//////////////////////////
// THESPIANS - START!   //
//////////////////////////

/datum/advclass/foreigner/bronzeclad
	name = "Thespian-Errant"
	tutorial = "Gladiators from the arenas of Raneshen and Lirvas, reenactors from the curtain-dazzled courts of Otava and Grenzelhoft, and \
	shieldbearers from the outermost reaches of Psydonia itself; all are unified in their subconscious pursuit of entertaining something greater \
	than themselves. You are a skilled combatant from beyond Azuria, who - for one reason or another - is intimately familiar with fighting in ancient equipment."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/bronzeclad
	cmode_music = 'sound/music/combat_thespian.ogg'
	maximum_possible_slots = 3 //Should be categorically rarer to see than Iron- and Steel-clad adventurers. Tickles the powerscale ala the Exorcist, albeit to a wider extent with its potential combinations.
	traits_applied = list(TRAIT_STEELHEARTED, TRAIT_BLOOD_RESISTANCE)
	subclass_stats = list(
		STATKEY_STR = 1, //Abbreviated to +1/+3/+2/-2 for short. Seven statpoints weighed against a two- (or rather, four-) point penalty in Speed. This is intentional, as the Thespian has a lot of room to stretch their proverbial wings. 
		STATKEY_WIL = 3, 
		STATKEY_CON = 2, 
		STATKEY_SPD = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

	extra_context = "This subclass can pick from a wide array of bronze weapons, armor, and origins to specialize in. Bronze armor - while easily pierced - is exceptionally durable and resistant against critical hits. A total of four Disciplines are available, each providing a different trait and armoring-tier."

/datum/outfit/job/roguetown/adventurer/bronzeclad/pre_equip(mob/living/carbon/human/H, visualsOnly)
	..()
	to_chat(H, span_warning("The curtains part, the shieldline rallies, and the eyes of a thousand shadows fall upon you. Snarling gladiator, enthralled shieldbearer, vestumed actor; ready yourself for another bout."))
	if(H.mind)
		var/bronzeweapon = list("Spatha & +1 Unarmed","Trident & +1 Unarmed","Greataxe & +1 Unarmed","Axepick & +1 Unarmed","Winged Spear + Greatshield","Heavy Khopesh + Greatshield","Shortsword + Shield","Falchion + Shield","Messer + Shield","Khopesh + Shield","Axe + Shield","Warclub + Shield","Flail + Shield","Spear + Shield","Axegauntlet + Shortsword","Nothing - Skilled Pugilist, +I STR / -I WIL")
		var/bronzeweapon_choice = input(H, "Choose your WEAPONS.", "PUT ON A SHOW FOR THE CROWD.") as anything in bronzeweapon
		switch(bronzeweapon_choice)
			if("Spatha & +1 Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/broadsword/bronze
				beltr = /obj/item/rogueweapon/scabbard/sword/strap
			if("Trident & +1 Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/trident
				beltr = /obj/item/net
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Greataxe & +1 Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/bronze
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Axepick & +1 Unarmed")
				H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/pick/bronze
			if("Winged Spear + Greatshield")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/spear/bronze/winged/strapless
				backr = /obj/item/rogueweapon/shield/bronze/great
			if("Heavy Khopesh + Greatshield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/greatkhopesh
				beltr = /obj/item/rogueweapon/scabbard/sword/strap
				backr = /obj/item/rogueweapon/shield/bronze/great
			if("Shortsword + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/gladius
				beltr = /obj/item/rogueweapon/scabbard/sword/strap
				backr = /obj/item/rogueweapon/shield/bronze
			if("Messer + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/messer/bronze
				beltr = /obj/item/rogueweapon/scabbard/sword/strap
				backr = /obj/item/rogueweapon/shield/bronze
			if("Falchion + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/falchion/militia/bronze
				beltr = /obj/item/rogueweapon/scabbard/sword/strap
				backr = /obj/item/rogueweapon/shield/bronze
			if("Khopesh + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
				beltr = /obj/item/rogueweapon/scabbard/sword/strap
				backr = /obj/item/rogueweapon/shield/bronze
			if("Axe + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/bronze
				backr = /obj/item/rogueweapon/shield/bronze
			if("Warclub + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/mace/warhammer/bronze
				backr = /obj/item/rogueweapon/shield/bronze
			if("Flail + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				r_hand = /obj/item/rogueweapon/flail/bronze
				backr = /obj/item/rogueweapon/shield/bronze
			if("Spear + Shield")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backr = /obj/item/rogueweapon/shield/bronze
				r_hand = /obj/item/rogueweapon/spear/bronze/strapless
			if("Axegauntlet + Shortsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				beltr = /obj/item/rogueweapon/sword/short/gladius 
				r_hand = /obj/item/rogueweapon/katar/bronze/gladiator
				backr = /obj/item/rogueweapon/scabbard/sword/strap
				gloves = /obj/item/clothing/gloves/roguetown/bandages
			if("Nothing - Skilled Pugilist, +I STR / -I WIL")
				H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
				gloves = /obj/item/clothing/gloves/roguetown/bandages/weighted
				ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
				H.change_stat(STATKEY_STR, 1)
				H.change_stat(STATKEY_WIL, -1)

		var/bronzesidearm = list("A Javelin's Bag", "A Sling With Bronze Pellets", "A Bow With Bronze Arrows", "Another Shortsword & Skills In Dual-Wielding", "Another Messer & Skills In Dual-Wielding", "Another Khopesh & Skills In Dual-Wielding", "Another Axe & Skills In Dual-Wielding", "A Bottle Of Medicinal Fish Vinegar.. ?")
		var/bronzesidearm_choice = input(H, "Choose your ACCOUTREMENTS.", "PREPARE YOUR OPENING ACT.") as anything in bronzesidearm
		switch(bronzesidearm_choice)
			if("A Javelin's Bag")
				beltl = /obj/item/quiver/javelin/bronze
			if("A Sling With Bronze Pellets")
				H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
				beltl = /obj/item/quiver/sling/bronze
			if("A Bow With Bronze Arrows")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic
				beltl = /obj/item/quiver/bronzearrows
			if("Another Shortsword & Skills In Dual-Wielding")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short/gladius
				beltl = /obj/item/rogueweapon/scabbard/sword/strap
			if("Another Messer & Skills In Dual-Wielding")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short/messer/bronze
				beltl = /obj/item/rogueweapon/scabbard/sword/strap
			if("Another Khopesh & Skills In Dual-Wielding")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short/gladius
				beltl = /obj/item/rogueweapon/scabbard/sword/strap
			if("Another Axe & Skills In Dual-Wielding")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/stoneaxe/woodcut/bronze
			if("A Bottle Of Medicinal Fish Vinegar.. ?")
				beltl = /obj/item/reagent_containers/glass/bottle/rogue/healthpot/zarum
		var/bronzediscipline = list("Gladiator - Skinarmored & Immunity To Pain","Thespian - Dodge Expert, +III SPD / -III CON","Shieldbearer - Well-Armored & Maille Training","Bulwark - Fully-Armored & Plate Training")
		var/bronzediscipline_choice = input(H, "Choose your DISCIPLINE.", "EMBRACE GLORY AND DEATH.") as anything in bronzediscipline
		switch(bronzediscipline_choice)
			if("Thespian - Dodge Expert, +III SPD / -III CON")
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
				H.change_stat(STATKEY_SPD, 3)
				H.change_stat(STATKEY_INT, 1)
				H.change_stat(STATKEY_CON, -3)
				head = /obj/item/clothing/head/roguetown/headband/red
				mask = /obj/item/clothing/mask/rogue/facemask/bronze
				armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze/light
				pants = /obj/item/clothing/under/roguetown/skirt/red
				wrists = /obj/item/clothing/wrists/roguetown/bracers/bronze
				belt = /obj/item/storage/belt/rogue/leather
			if("Gladiator - Skinarmored & Immunity To Pain")
				ADD_TRAIT(H, TRAIT_NOPAINSTUN, TRAIT_GENERIC) //Lite!Barbarian.
				head = /obj/item/clothing/head/roguetown/helmet/bronzegladiator
				wrists = /obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator
				armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/gladiator
				pants = /obj/item/clothing/under/roguetown/loincloth/brown
				shirt = /obj/item/clothing/suit/roguetown/shirt/tribalrag/gladiator
				belt = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/red
			if("Shieldbearer - Well-Armored & Maille Training")
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
				head = /obj/item/clothing/head/roguetown/helmet/heavy/bronze
				neck = /obj/item/clothing/neck/roguetown/gorget/bronze
				wrists = /obj/item/clothing/wrists/roguetown/bracers/bronze
				armor = /obj/item/clothing/suit/roguetown/armor/plate/bronze
				cloak = /obj/item/clothing/cloak/cape/red
				pants = /obj/item/clothing/under/roguetown/skirt/red
				belt = /obj/item/storage/belt/rogue/leather
			if("Bulwark - Fully-Armored & Plate Training")
				ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
				head = /obj/item/clothing/head/roguetown/helmet/bronze
				neck = /obj/item/clothing/neck/roguetown/gorget/bronze
				wrists = /obj/item/clothing/wrists/roguetown/bracers/bronze
				armor = /obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt
				pants = /obj/item/clothing/under/roguetown/loincloth/brown
				cloak = /obj/item/clothing/cloak/cape/red 
				belt = /obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/red
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/bronze
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/bronze = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)
	H.set_blindness(0)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			id = /obj/item/clothing/neck/roguetown/psicross/bronze
		if(/datum/patron/divine/ravox)
			id = /obj/item/clothing/neck/roguetown/psicross/ravox/bronze
		if(/datum/patron/divine/astrata)
			id = /obj/item/clothing/neck/roguetown/psicross/astrata/bronze
		if(/datum/patron/divine/malum)
			id = /obj/item/clothing/neck/roguetown/psicross/malum/bronze
		else
			id = /obj/item/clothing/ring/bronze

	/////////////////////////////////
	// THESPIAN-CENTRIC ADDITIONS! //
	/////////////////////////////////
		// Stored here to minimize merge conflicts.
		// Shouldn't cause too much trouble, otherwise. Feel free to relocate them to the proper .dms later, if you wish.

/obj/item/rogueweapon/sword/short/messer/bronze
	name = "makhaira"
	desc = "A heavy shortsword of similar design to the Kopis, fit for cleaving through both foliage and flesh. </br>Infamous for its \
	presence amongst the gladitorial arenas of Lirvas and Raneshen, where gashes provide the kind of crimson spectacle that liqour-addled \
	crowds adore the most."
	icon_state = "makhaira"
	minstr = 6
	wdefense = 3
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = /obj/item/ingot/bronze
	max_integrity = 150
	sheathe_icon = "makhaira"

/obj/item/clothing/suit/roguetown/shirt/tribalrag/gladiator
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "gladiator's rags"
	desc = "What we do in life, echoes in eternity."

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic
	name = "bow"
	desc = "The bow is your life; to hold it high and pull the string is to know the path of destiny."
	var/hasloadedsprite = TRUE
	accfactor = 1.15 //A fairly mild alternative to the Crude Selfbow, themed to be more like a proper ranged weapon. Same general stats, but with an increased bonus to accuracy.
	icon_state = "classicbow0"
	item_state = "classicbow"

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic/update_icon()
	. = ..()
	cut_overlays()
	icon_state = "[item_state][0]"

	if(chambered && hasloadedsprite)
		icon_state = "[item_state][1]"

	if(!ismob(loc))
		return
	var/mob/M = loc
	M.update_inv_hands()

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/classic/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -3,"sy" = -2,"nx" = 5,"ny" = -1,"wx" = -3,"wy" = 0,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 9,"sturn" = -100,"wturn" = -102,"eturn" = 10,"nflip" = 1,"sflip" = 8,"wflip" = 8,"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.6,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = -1,"nx" = 1,"ny" = -1,"wx" = 3,"wy" = -1,"ex" = 0,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/quiver/bronzearrows/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/bronze/A = new()
		arrows += A
	update_icon()

/obj/item/reagent_containers/glass/bottle/rogue/healthpot/zarum
	name = "bottle of medicinal fish vinegar"
	desc = "A bottle with a mudclay cork, tethered to the bottleneck via braided twine. Fermented innard-paste and herbs makes for a \
	disgustingly cheap medicine; an ancient concoction, resurrected for usage within the gladitorial arenas of Lirvas and Raneshen. </br>A \
	particular variant of this, made by fermenting zardines in the Terrorbog, happens to be a very popular condiment back in Rockhill."
	list_reagents = list(/datum/reagent/medicine/healthpot/zarum = 50)

/datum/reagent/medicine/healthpot/zarum
	name = "Zarum"
	description = "Gradually regenerates all types of damage, imparts a savory taste to most topped meals."
	color = "#891305"
	taste_description = "lip-puckeringly rich fishiness"
	scent_description = "fermented pungence"

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/disciple/gladiator
	name = "gladiator's skin"
	desc = "Are you not entertained?!"
	max_integrity = 200
	repair_time = 25 SECONDS

/obj/item/clothing/wrists/roguetown/bracers/cloth/gladiator
	name = "padded wrappings"
	desc = "Sheared burlap and cloth, meticulously fashioned around the forearms. Taut fibers turn weeping gashes into mere tears along the cloth. </br>"
	color = "#BFB8A9"

/obj/item/clothing/head/roguetown/helmet/bronzegladiator
	name = "bronze murmillo"
	desc = "A bronze helmet that veils the wearer's face behind a perforated visor; a distant ancestor to both the sallet and sayovard, \
	providing excellent coverage while ensuring one doesn't suffocate on their own adrenal huffs. </br>Out of all actorial labors, none surpass \
	the reenactment of Ravox's duel against Graggar atop Ur-Syon's ruins - mythologized not as a tentacled star, but as a towering doppelganger-champion; \
	sculpted by the Archdevil to be the inverse to all who stood for justice and chivalry."
	armor = ARMOR_PLATE_BRONZE
	max_integrity = ARMOR_INT_HELMET_HEAVY_BRONZE - 100
	armor_class = ARMOR_CLASS_LIGHT
	material_category = ARMOR_MAT_PLATE
	prevent_crits = PREVENT_CRITS_ALL
	body_parts_covered = FULL_HEAD
	icon_state = "bronzemurmillo"
	item_state = "bronzemurmillo"
	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/head/roguetown/helmet/bronzegladiator/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/cloth) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Orle") as anything in COLOR_MAP + pridelist
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		if(choice in pridelist)
			detail_tag = "_detailp"
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/bronzegladiator/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/storage/belt/rogue/leather/battleskirt/breechcloth/red
	color = CLOTHING_RED

/obj/item/storage/belt/rogue/leather/battleskirt/red
	color = CLOTHING_RED

/obj/item/clothing/cloak/cape/red
	color = CLOTHING_RED

/obj/item/storage/belt/rogue/leather/battleskirt/faulds/red
	color = CLOTHING_RED

/obj/item/rogueweapon/spear/bronze/winged
	name = "bronze winged spear"
	desc = "An antiquital staff, adorned with a winged bronze spearhead. The flared edges catch errant strikes and keep snarling foes from \
	further impaling themselves in order to maul its wielder. </br>Scholars believe this particular type of polearm was made to counter Vheslynic \
	seadaemons, during the now-mythologized Syonic era's collapse."
	icon_state = "bronzewingedspear"
	item_state = "bronzewingedspear"
	wdefense = 6 //Functionally the same, but with +1 DEF.

/obj/item/rogueweapon/spear/bronze/strapless
	desc = "An antiquital staff, adorned with a bronze spearhead. Ancient in both design and purpose, its lighter weight once complimented \
	the towering shields of precivilizational legionnaires. While rarely seen beyond the Deadlands, nowadaes, its lightweight balance makes \
	it perfect for one-handed thrusts and throws. </br>This particular spear has a thin strap running along its grain, allowing it to be stowed without the need for a greatweapon strap."
	slot_flags = ITEM_SLOT_BACK //Option-unique, uncraftable. Ensures the loadout doesn't implode on itself.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/item/rogueweapon/spear/bronze/winged/strapless
	desc = "An antiquital staff, adorned with a winged bronze spearhead. The flared edges catch errant strikes and keep snarling foes from further \
	impaling themselves in order to maul its wielder. </br>Scholars believe this particular type of polearm was made to counter Vheslynic seadaemons, during the now-mythologized Syonic era's collapse. </br>This particular spear has a thin strap running along its grain, allowing it to be stowed without the need for a greatweapon strap."
	slot_flags = ITEM_SLOT_BACK //Ditto.
	equip_delay_self = 2 SECONDS
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/item/rogueweapon/katar/bronze/gladiator
	name = "arbelos"
	icon_state = "bronzescissor"
	item_state = "bronzescissor"
	desc = "A sharpened axhead that's been mounted onto a bronze gauntlet. Popularized at the turn of the millennium within the Underdark's gladiatorial arenas, \
	it triumphs over the katar when it comes to thawrting blows and cleaving skulls. The wooden handle used to connect its axhead to the gauntlet is fragile, however; \
	all it takes is a precise strike to neuter such a weapon."
	wdefense = 5 //Much higher than usual for most unarmed weapons..
	max_integrity = 55 //..but far more fragile.
	max_blade_int = 300
	possible_item_intents = list(/datum/intent/axe/chop/arbelos, /datum/intent/axe/cut/arbelos, /datum/intent/katar/thrust/arbelos, /datum/intent/sword/peel)
	thrown_bclass = BCLASS_CHOP

/datum/intent/axe/chop/arbelos
	damfactor = 1.3
	clickcd = 10 //Quicker than a conventional axe, but slower than a katar. 

/datum/intent/axe/cut/arbelos
	damfactor = 1.15
	clickcd = CLICK_CD_FAST //Same speed as a katar, but with reduced penetration and half-damage. Main appeal's the chopper.

/datum/intent/katar/thrust/arbelos
	penfactor = 20
	damfactor = 0.8
	clickcd = 10 //Slower than a regular thrust, with slightly less penetration and damage. Inverse to the katar.

/obj/item/rogueweapon/sword/long/greatkhopesh
	name = "apophis" //Kriegmesser analogue.
	desc = "The Khopesh's older brother. One would be mistaken for thinking it was designed to be wielded in both hands; for the strength of these \
	ancient legionnaires, prodigious as it were, allowed them to effortlessly wield it alongside their towering greatshields."
	wdefense = 3
	wdefense_wbonus = 2
	force = 22
	force_wielded = 25
	possible_item_intents = list(/datum/intent/sword/chop/sabre, /datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/sabre, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/rend/apophis, /datum/intent/sword/chop/sabre, /datum/intent/sword/thrust/sabre, /datum/intent/sword/strike)
	max_integrity = 150
	max_blade_int = 300
	wbalance = WBALANCE_NORMAL
	minstr = 11
	sheathe_icon = "decgladius"
	icon_state = "bronzegreatkhopesh"
	item_state = "bronzegreatkhopesh"
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/sword/long/greatkhopesh/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/sword/chop/sabre
	damfactor = 1.15
	penfactor = 20

/datum/intent/rend/apophis
	damfactor = 2.2
	intent_intdamage_factor = 0.2

/obj/item/clothing/suit/roguetown/armor/plate/bronze/light
	name = "bronze cardiophylax"
	desc = "A thick bronze plate, meticulously sculpted to fit its wearer's physique and guard their heart from all that'd seek to strike it. Unfortunately, it does little to riposte more emotional blows."
	icon_state = "bronzeprotector"
	item_state = "bronzeprotector"
	body_parts_covered = CHEST
	max_integrity = ARMOR_INT_CHEST_MEDIUM_BRONZE - 100 //Translates into 250 INT, or a little above Iron - and +100 INT over the Copper variant.
	armor_class = ARMOR_CLASS_LIGHT
	armor = list("blunt" = 75, "slash" = 75, "stab" = 75, "piercing" = 40, "fire" = 0, "acid" = 0) //Note; same as the Copper Heart Protector. Quite good, but strictly locked to the chest zone. Say goodbye to your entrails and crotch, if you aren't smart!

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze
	name = "bronze panoplic armor"
	desc = "What can only be described as an 'armored robe'; thick bronze plates, layered atop one-another and interlinked with strappings \
	to form an assembly of segmented plate armor. While overwhelmingly heavy and cumbersome, it is certain to weather any storm poised its way. \
	</br>Scholars oft-describe this suit as a 'panoply', purpose-made for the physiques of Psydonia's earliest Aasimari."
	icon_state = "bronzeplate"
	item_state = "bronzeplate"
	armor = ARMOR_PLATE_BRONZE
	max_integrity = ARMOR_INT_CHEST_PLATE_BRONZE + 150 //Translates into 700 INT. Bronze armor is penetrated by any attack that deals a combined FORCE/AP value of +50, which translates into virtually any non-STR modified attack in the game; swords, daggers, axes.
	armor_class = ARMOR_CLASS_HEAVY
	smeltresult = /obj/item/ingot/bronze
	prevent_crits = PREVENT_CRITS_ALL //Bronze-specific trait. While this sounds scary, all it mechanically does is add resistances to Pick-induced critical hits. Bleed and suffer, but do not go quietly into the darkness.
	smelt_bar_num = 3
	var/bronzeplatecumbersome = FALSE

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_ARMOR)
		to_chat(user, span_suicide("The panoply clatters into place, and I feel my shoulders slouch beneath its weight - yet even now, I feel sturdier than ever before.."))
		user.change_stat(STATKEY_CON, 1)
		user.change_stat(STATKEY_SPD, -1)
		bronzeplatecumbersome = TRUE
	return

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/dropped(mob/living/carbon/human/user)
	. = ..()
	if(bronzeplatecumbersome == TRUE)
		to_chat(user, span_hypnophrase("..and with a sigh of relief, the panoply's weight no longer burdens my shoulders."))
		user.change_stat(STATKEY_CON, -1)
		user.change_stat(STATKEY_SPD, 1)
		bronzeplatecumbersome = FALSE
	return

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Even with the necessary training, this suit of armor is difficult to maneuver in. Wearing the armor will slightly fortify your Constitution, at the cost of further reducing your Speed.")

/obj/item/clothing/suit/roguetown/armor/plate/full/bronze/alt
	name = "bronze panoplic assembly"
	icon_state = "bronzeplatealt"
	item_state = "bronzeplatealt"
	body_parts_covered = CHEST | VITALS | LEGS
	max_integrity = ARMOR_INT_CHEST_PLATE_BRONZE + 75 //Iron Halfplate analogue. Still heavy as hell.

/obj/item/clothing/mask/rogue/facemask/bronze
	name = "bronze mask"
	desc = "Glimmering bronze, curved to veil its wearer's face from both judgement and harm."
	armor = ARMOR_PLATE_BRONZE
	armor_class = ARMOR_CLASS_LIGHT
	icon_state = "bronzemask"
	item_state = "bronzemask"
	max_integrity = 150
	prevent_crits = PREVENT_CRITS_ALL
	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/mask/rogue/facemask/bronze/classic
	name = "bronze death mask"
	icon_state = "bronzemask_legacy"
	item_state = "bronzemask_legacy"
	desc = "Glimmering bronze, meticuliusly shaped to mimic the guise of another. One of civilization's oldest superstitions is the belief that donning such masks would impart a sliver of the mimicked facebearer's power unto its wearer."

/obj/item/rogueweapon/shield/bronze/great
	name = "hoplon greatshield"
	desc = "A heavy shield, taller and thicker than most of their contemporaries. It has survived the Calamity, endured the Apotheosis, and blunted the Sundering; and for one final time, it shall ward this dying world from a crueler fate."
	icon_state = "bronzegreatshield"
	item_state = "bronzegreatshield"
	max_integrity = 360 //Highest integrity and passive projectile-blocking chance of most non-unique shields. Defense is consequently reduced to Buckler levels, however. Time your blocks and take one for the team!
	possible_item_intents = list(/datum/intent/shield/block, /datum/intent/mace/smash/shield/metal/great, /datum/intent/effect/daze) // No SHIELD_BASH. Able to inflict Daze due to its weight.
	force = 28
	coverage = 75 
	wdefense = 9
	minstr = 12 //Requires a natural +STR modifier or statpack to double as a melee weapon, for its given class. Note that it has a heavier charge time and active stamina drain, too, as.. well, it's quite heavy.

/obj/item/rogueweapon/shield/bronze/great/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("This greatshield has a uniquely high chance to block incoming projectiles, without requiring the active use of the 'BLOCK' intent.")

/obj/item/clothing/head/roguetown/helmet/bronze
	name = "bronze illyriahelm"
	desc = "A helmet of bronze, older-in-design than you could possibly imagine. Mounted to its crest is a decorative sigil that has \
	sparked scholarly debates for the better part of a millennium; is it a star, a vortex, or the Sun? </br>A notch behind the sigil \
	allows for the joint mounting of a plume. Nock a feather into it to show off your alliegence's colors."
	armor = ARMOR_PLATE_BRONZE
	max_integrity = ARMOR_INT_HELMET_HEAVY_BRONZE - 25 //Close, but no cigar.
	material_category = ARMOR_MAT_PLATE
	prevent_crits = PREVENT_CRITS_ALL
	body_parts_covered = HEAD|HAIR|EARS
	icon_state = "bronzehelmet"
	item_state = "bronzehelmet"
	worn_x_dimension = 64
	worn_y_dimension = 64
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x64/head.dmi'
	bloody_icon = 'icons/effects/blood64.dmi'
	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/head/roguetown/helmet/bronze/attackby(obj/item/W, mob/living/user, params)
	..()
	if(istype(W, /obj/item/natural/feather) && !detail_tag)
		var/choice = input(user, "Choose a color.", "Greatplume") as anything in COLOR_MAP
		detail_color = COLOR_MAP[choice]
		detail_tag = "_detail"
		user.visible_message(span_warning("[user] adds [W] to [src]."))
		user.transferItemToLoc(W, src, FALSE, FALSE)
		update_icon()
		if(loc == user && ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_head()

/obj/item/clothing/head/roguetown/helmet/bronze/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/neck/roguetown/psicross/astrata/bronze
	name = "bronze amulet of Astrata"
	desc = "'We are Her soldiers, the Legion of light.' </br>'We are the center, the depth of the Sun.' </br>'Fire and flame - we are one.'"
	icon_state = "astrata_b"
	item_state = "astrata_b"

/obj/item/clothing/neck/roguetown/psicross/malum/bronze
	name = "bronze amulet of Malum"
	desc = "Stone to steel, bone to bronze, mulched to masterworked."
	icon_state = "malum_b"
	item_state = "malum_b"

/obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/bronze
	name = "bronze amulet of Graggar"
	desc = "'EVERYTHING - AND EVERYONE YOU LOVE - WILL BE GONE! WHAT WILL YOU HAVE, AFTER THE LAST FIRE'S BEEN SMOTHERED OUT?!' </br>‎  </br>'..You. I'd still have you.'"
	icon_state = "graggar_b"
	item_state = "graggar_b"

//////////////////////////
// THESPIANS - END!     //
//////////////////////////

