/datum/advclass/mercenary/vaquero
	name = "Vaquero"
	tutorial = "Originating in the vibrant Kingdom of Etrusca, a 'vaquero' had originally been a mere cattle-driver... Now, though, it has become a title for roaming swashbucklers. Whether they set out as a defender of the commonfolk or a pilferer of purses, the Vaquero is defined by the tale they carve across continents - and more frequently - by their story's violent end."
	outfit = /datum/outfit/job/roguetown/mercenary/vaquero
	class_select_category = CLASS_CAT_ETRUSCA
	cmode_music = 'sound/music/combat_vaquero.ogg'
	category_tags = list(CTAG_MERCENARY)
	subclass_languages = list(/datum/language/etruscan)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_DECEIVING_MEEKNESS)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_INT = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
	)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

/datum/advclass/mercenary/vaquero/equipme(mob/living/carbon/human/H, dummy)
	if(should_wear_femme_clothes(H))
		horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled
	return ..()

/datum/outfit/job/roguetown/mercenary/vaquero/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/bardhat
	mouth = /obj/item/alch/rosa
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/clothing/neck/roguetown/gorget
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	belt = /obj/item/storage/belt/rogue/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	cloak = /obj/item/clothing/cloak/half/rider/red
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword/rapier/vaquero
	beltr = /obj/item/rogueweapon/scabbard/sheath
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero
	backpack_contents = list(
					/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
					/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
					/obj/item/lockpick = 1,
					/obj/item/flashlight/flare/torch = 1,
					/obj/item/roguekey/mercenary = 1,
					/obj/item/rogueweapon/scabbard/sheath = 1
					)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	if(H.mind)
		var/weapons = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman","Flute", "Psyaltery")
		var/weapon_choice = input(H, "Choose your instrument.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
	H.merctype = 13
