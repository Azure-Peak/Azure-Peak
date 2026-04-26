/datum/advclass/foreigner
	name = "Eastern Warrior"
	tutorial = "A warrior hailing from the distant land of Kazengun, far across the eastern sea."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = NON_DWARVEN_RACE_TYPES // Clothing has no dwarf sprites.
	outfit = /datum/outfit/job/roguetown/adventurer/foreigner
	class_select_category = CLASS_CAT_NOMAD
	traits_applied = list(TRAIT_STEELHEARTED)
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT, CTAG_LICKER_WRETCH)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
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
	subclass_languages = list(/datum/language/raneshi)
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
	mask = /obj/item/clothing/head/roguetown/armingcap/padded
	head = /obj/item/clothing/head/roguetown/chaperon/greyscale/shepherd
	neck = /obj/item/clothing/neck/roguetown/psicross/reform
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shepherd
	shirt = /obj/item/clothing/suit/roguetown/shirt/freifechter/shepherd
	belt = /obj/item/storage/belt/rogue/leather/sash
	beltl = /obj/item/rogueweapon/stoneaxe/battle/steppesman/chupa
	beltr = /obj/item/rogueweapon/huntingknife/idagger/navaja/freifechter
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/shepherd
	shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft/freifechter
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
		var/weapons = list("Balanced Longsword & Seax","Spear & Punch Dagger","Sabre")
		var/weapon_choice = input(H, "Choose your expertise.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Balanced Longsword & Seax")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/sword/long/fencerguy
				r_hand = /obj/item/rogueweapon/huntingknife/combat/fencerguy
				backr = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/scabbard/sheath
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
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
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
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
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
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword/strap
			if("Another Messer & Skills In Dual-Wielding")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/short/messer/bronze
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword/strap
			if("Another Khopesh & Skills In Dual-Wielding")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				l_hand = /obj/item/rogueweapon/sword/sabre/bronzekhopesh
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword/strap
			if("Another Axe & Skills In Dual-Wielding")
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_APPRENTICE, TRUE)
				l_hand = /obj/item/rogueweapon/stoneaxe/woodcut/bronze
			if("A Bottle Of Medicinal Fish Vinegar.. ?")
				beltl = /obj/item/reagent_containers/glass/bottle/rogue/healthpot/zarum
				H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, TRUE)
		var/bronzediscipline = list("Thespian - Dodge Expert, -I CON / +I SPD","Gladiator - Skin-Armored & Immunity To Pain","Shieldbearer - Well-Armored & Maille Training","Bulwark - Fully-Armored & Plate Training")
		var/bronzediscipline_choice = input(H, "Choose your DISCIPLINE.", "EMBRACE GLORY AND DEATH.") as anything in bronzediscipline
		switch(bronzediscipline_choice)
			if("Thespian - Dodge Expert, -I CON / +I SPD")
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
			if("Gladiator - Skin-Armored & Immunity To Pain")
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
				neck = /obj/item/clothing/neck/roguetown/bevor/bronze
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
		if(/datum/patron/divine/noc)
			id = /obj/item/clothing/neck/roguetown/psicross/noc/bronze
		else
			id = /obj/item/clothing/ring/bronze

/datum/advclass/foreigner/lesserblackoak
	name = "Azurian Grovewalker"
	tutorial = "Autumn's grace trails you as a guardian-errant of the Black Oaks; an irregular militia that \
	fights for the ancestral elven homelands of Azuria. Nature's call manifests along your blossoming bark, \
	and you shall answer. Whether through blade or bow, you shall ensure that those who dare to disrespect \
	Azuria's supple forests will learn to regret it."
	extra_context = "This class is restricted to the Elf, Half-Elf, and Dark Elf species."
	class_select_category = CLASS_CAT_RACIAL
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/human/halfelf,
		/datum/species/elf/wood,
		/datum/species/elf/dark,
	)
	traits_applied = list(TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_DODGEEXPERT, TRAIT_WOODWALKER)
	outfit = /datum/outfit/job/roguetown/adventurer/lesserblackoak
	subclass_languages = list(/datum/language/oldazurian)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	maximum_possible_slots = 3 //A little stronger than a traditional Nomad or Adventurer. The slot limit is more-so intended to keep them a limited presence within Azuria, and to account for their potentially antagonistic nature.
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1, //Seven-pointed statblock. Glass cannon-coded, with an emphasis on naturally-high ranged damage and melee accuracy.
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/lesserblackoak/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("Whether through merit or heritage, you've earned the right of tutelage under the Black Oaks; an irregular militia that fights for the ancestral elven homelands of Azuria. Jaunt through the underbrush and oppress the oppressors with both blade-and-bow."))
	H.set_blindness(0)
	if(H.mind)
		var/weapons = list("Autumned Longsword","Autumned Glaive","Autumned Bow")
		var/weapon_choice = input(H, "Choose your WEAPON.", "WARD NATURE FROM THOSE WHO SEEK TO DEFILE IT.") as anything in weapons
		switch(weapon_choice)
			if("Autumned Longsword")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/rogueweapon/sword/long/elvish/autumn
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Autumned Glaive")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/rogueweapon/halberd/bardiche/elvish/autumn
				backr = /obj/item/rogueweapon/scabbard/gwstrap
			if("Autumned Bow")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_JOURNEYMAN, TRUE)
				l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/autumn
				beltr = /obj/item/quiver/arrows
	head = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/autumn/light
	armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate/autumn/light
	neck = /obj/item/clothing/neck/roguetown/coif
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots/autumn
	cloak = /obj/item/clothing/cloak/forrestercloak/autumn
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves/autumn
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/elvish/autumn = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)

/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/autumn
	name = "autumnwoad recurve bow"
	desc = "A medium length composite bow of glued horn, wood, and sinew with good shooting \
	characteristics. Hewn from an Azurian elk tree branch, it still feels as if it is one \
	with nature; unsullied by the cruder butcherments of Man. </br>'The summer sun is fading \
	as the year grows old, and darker days are drawing near..'"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "autumnrecurve_bow"

/obj/item/rogueweapon/sword/long/elvish/autumn
	name = "autumned elvish longsword"
	desc = "A curved longsword, hewn from a melody of faeiron and the living bark of an Azurian \
	elk tree. Unlike traditional alloys, faeiron is refined purely through the mystical arcyne \
	techniques of the Black Oaks; nature's stones, hewn to catch and cleave like steel."
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "aelflongsword"
	sellprice = 20
	sheathe_icon = "aelfsword"
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 230 //Equivalent to an Iron Broadsword.
	max_integrity = 180 //Ditto.

/obj/item/rogueweapon/huntingknife/idagger/elvish/autumn
	name = "autumned elvish dagger"
	desc = "A wave-bladed dagger of faeiron, fitted from the branch of an Azurian elk \
	tree. Just like its elegant creators, so too does it glide through the gaps in maille \
	like an elf effortlessly bounding across the Groves."
	icon_state = "aelfdagger"
	sheathe_icon = "aelfdagger"
	force = 15 //Equivalent to an Iron Dagger, with +33% integrity.
	max_integrity = 150
	smeltresult = /obj/item/ingot/iron
	smelt_bar_num = 1

/obj/item/rogueweapon/halberd/bardiche/elvish/autumn
	possible_item_intents = list(/datum/intent/spear/thrust/oneh, SPEAR_BASH)
	gripped_intents = list(/datum/intent/spear/thrust, /datum/intent/spear/cut, /datum/intent/spear/cut/bardiche/cleave, /datum/intent/spear/cut/glaive/sweep)
	name = "autumned elvish bardiche"
	desc = "A cleaving polearm, hewn from the branch of an Azurian elk tree and tipped with a wide blade of faeiron. The \
	tapered edge can thrust through an oppressor's armor at the right range, while its wide sweeps can dispell even the \
	rowdiest of lumberfoots."
	icon_state = "aebardiche"
	max_blade_int = 200
	wdefense = 5
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/autumn
	name = "autumnwoad elven helm"
	desc = "A helmet of thickly woven trunk, kept alive by ancient song and bristled with leaves \
	of perpetual autumnage. Unblossomed woadmaille can be splintered far easier than their \
	springlyfed counterparts, but - consequently - becomes far lighter to maneuver with. </br>'..the \
	winter winds will be much colder, now you're not here..'"
	allowed_race = RACES_ALL_KINDS
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "awelfhead"
	item_state = "awelfhead"
	bloody_icon = 'icons/effects/blood64.dmi'
	armor_class = ARMOR_CLASS_LIGHT //Very good protection against stabbing and crushing, but completely unprotected to cutting and chopping. Unique to this specific class, and appropriately weakened to compensate.
	max_integrity = ARMOR_INT_HELMET_HARDLEATHER //-15% durability hit, with 250HP instead of 300HP.

/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/autumn/light
	name = "autumnwoad elven barbute"
	desc = "A helmet of woven trunk, kept alive by ancient song and bristled with leaves \
	of perpetual autumnage. Unblossomed woadmaille can be splintered far easier than their \
	springlyfed counterparts, but - consequently - becomes far lighter to maneuver with. </br>'..the \
	winter winds will be much colder, now you're not here..'"
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "awelfheadalt"
	item_state = "awelfheadalt"
	bloody_icon = 'icons/effects/blood64.dmi'
	armor_class = ARMOR_CLASS_LIGHT //Very good protection against stabbing and crushing, but completely unprotected to cutting and chopping. Unique to this specific class, and appropriately weakened to compensate.
	max_integrity = ARMOR_INT_HELMET_LEATHER //-33% durability hit, with 200HP instead of 300HP.
	body_parts_covered = HEAD|HAIR|NOSE|EARS

/obj/item/clothing/cloak/forrestercloak/autumn
	name = "autumneer cloak"
	desc = "'A gentle rain falls softly on my weary eyes, as if to hide a lonely tear.. my life will be forever autumn..'"
	icon_state = "aforestcloak"
	allowed_race = RACES_ALL_KINDS
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	inhand_mod = TRUE

/obj/item/clothing/suit/roguetown/armor/plate/elven_plate/autumn
	name = "autumwoad elven plate"
	desc = "An assembly of thickly woven trunk, kept alive by ancient song and bristled with leaves \
	of perpetual autumnage. As the mythos goes, the tone of woaden armor can sway with the \
	emotions of its wearer - for even the eldest of the Black Oaks can see their bark shifting \
	back to that familiar crimson hue, whenever they're stricken with the yearning of \
	tymes past. </br>'Like the sun through the trees you came to love me.. and like a leaf on a breeze, you blew away..'"
	allowed_race = RACES_ALL_KINDS //Uniquely wearable among all races, as it's 'unblossomed' and appropriately malleable enough to fit on smaller bodies.
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "awelfchest"
	item_state = "awelfchest"
	armor_class = ARMOR_CLASS_LIGHT //Ditto.
	max_integrity = ARMOR_INT_CHEST_PLATE_BRIGANDINE + 25 //-25ish% durability hit, with 375 instead of 500HP.

/obj/item/clothing/suit/roguetown/armor/plate/elven_plate/autumn/light
	name = "autumwoad elven maille"
	desc = "An assembly of woven trunk, kept alive by ancient song and bristled with leaves \
	of perpetual autumnage. As the mythos goes, the tone of woaden armor can sway with the \
	emotions of its wearer - for even the eldest of the Black Oaks can see their bark shifting \
	back to that familiar crimson hue, whenever they're stricken with the yearning of \
	tymes past. </br>'Like the sun through the trees you came to love me.. and like a leaf on a breeze, you blew away..'"
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "awelfchestalt"
	item_state = "awelfchestalt"
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER //-33% durability hit, with 300 instead of 500HP.
	body_parts_covered = CHEST | VITALS | LEGS 

/obj/item/clothing/gloves/roguetown/elven_gloves/autumn
	name = "autumnwoad elven gloves"
	desc = "Barkgloves that've been freshly weened off the trunk of a sturdy Azurian elk tree, and \
	mystically preserved in a state of perpetual autumnage. Crimson vines and leaves poke out from \
	its living joints, wicking away sweat like a sponge to water. </br>'Through autumn's golden gown \
	we used to kick our way, you always loved this time of year..'"
	allowed_race = RACES_ALL_KINDS
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "awelfhand"
	item_state = "awelfhand"
	max_integrity = ARMOR_INT_SIDE_LEATHER - 25 // -20% durability hit, with 175HP instead of 225HP.

/obj/item/clothing/shoes/roguetown/boots/elven_boots/autumn
	name = "autumnwoad elven boots"
	desc = "A pair of mossboots that ache with the sounds of living nature, and teem with the colors \
	of perpetual autumnage. It is said that a Black Oak's armor will only fully blossom once they've \
	earned the mantle of guardianship; to forsake one's oath to nature is to dispell the ancient songs, \
	and to let the bark wither away. </br>'..those fallen leaves lie undisturbed now, 'cause you're not here!'"
	allowed_race = RACES_ALL_KINDS
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "awelfshoes"
	item_state = "awelfshoes"
	max_integrity = ARMOR_INT_SIDE_LEATHER - 25 // -20% durability hit, with 175HP instead of 225HP.

//
