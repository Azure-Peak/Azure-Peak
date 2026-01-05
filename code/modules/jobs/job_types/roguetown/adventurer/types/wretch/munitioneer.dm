/datum/advclass/wretch/munitioneer
	name = "Munitioneer"
	tutorial = "You are a true devotee of the God of the Forge; a wandering priest of Malum, your altar an anvil and your prayer the hiss of steam from a fresh-wrought blade. You care little for 'politics' or 'schisms'; you are a hammer in a worlde of nails."
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/munitioneer
	cmode_music = 'sound/music/combat_dwarf.ogg'
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT, TRAIT_RITUALIST)
	maximum_possible_slots = 1 // do we need TWO antag weapon factories?
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 1 // heretic that trades armor for crafting skills. 9 statspread, like guildsmaster.
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN, 
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/smelting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/wretch/munitioneer/pre_equip(mob/living/carbon/human/H)
	to_chat(H, span_warning("You are a passable warrior- though weak- but your true strength lies in your ability to bend the resources of Azuria to your will."))
	has_loadout = TRUE
	head = /obj/item/clothing/head/roguetown/roguehood/warden/munitioneer
	mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy
	neck = /obj/item/clothing/neck/roguetown/gorget
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	cloak = /obj/item/clothing/cloak/templar/malumite
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
	backl = /obj/item/storage/backpack/rogue/satchel
	beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
	belt = /obj/item/storage/backpack/rogue/satchel/beltpack
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/neck/roguetown/psicross/malum
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/ritechalk = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/rogueweapon/huntingknife/combat = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)

/datum/outfit/job/roguetown/wretch/munitioneer/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	if(H.mind)
		H.mind?.current.faction += "[H.name]_faction"
		H.set_patron(/datum/patron/divine/malum)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mineroresight) // controversial, and powerful, but it means you're spending less Wretch Time just mining.
	var/weapons = list("Path of the Hammer - Steel Warhammer", "Path of the Crossbow - Crossbow and Bolts", "Path of the Pick - Pulaski Axe")
	var/weapon_choice = input(H, "Choose your weapon.", "HOT IS THE ANVYL") as anything in weapons
	switch(weapon_choice)
		if("Path of the Hammer - Steel Warhammer")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/mace/warhammer/steel)
		if("Path of the Crossbow - Crossbow and Bolts")
			H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow)
			H.equip_to_slot_or_del(new /obj/item/quiver/bolts, SLOT_BELT_L, TRUE)
		if("Path of the Pick - Pulaski Axe")
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/woodcut/pick)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_4)	//Minor regen, can level up to T4.
	wretch_select_bounty(H)
