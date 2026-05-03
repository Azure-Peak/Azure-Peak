///////////////////////////////////////////
/////////////////////////////////// PROPHET
/*

*/
/datum/advclass/warband/sect/warlord/prophet
	title = "PROPHET"
	name = "Prophet"
	tutorial = ""
	outfit = /datum/outfit/job/roguetown/warband/sect/warlord/prophet

	traits_applied = list(TRAIT_FORMATIONFIGHTER, TRAIT_LAWEXPERT, TRAIT_STEELHEARTED, TRAIT_RITUALIST, TRAIT_DEATHSIGHT, TRAIT_SOUL_EXAMINE, TRAIT_NOSTINK, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_WIL = 6,
		STATKEY_PER = 6,
		STATKEY_INT = 3,
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/warband/sect/warlord/prophet/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff/prophet
	backr = /obj/item/clothing/cloak/prophet
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/prophet
	cloak = /obj/item/clothing/cloak/matron/prophet
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	beltr = /obj/item/rogueweapon/sickle
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/glass/bottle/waterskin,
		/obj/item/ritechalk
	)
	if(H.patron.type == /datum/patron/divine/undivided)
		wrists = /obj/item/clothing/neck/roguetown/psicross/undivided
	if(H.patron.type == /datum/patron/divine/astrata)
		wrists = /obj/item/clothing/neck/roguetown/psicross/astrata

	if(H.patron.type == /datum/patron/divine/noc)
		wrists = /obj/item/clothing/neck/roguetown/psicross/noc

	if(H.patron.type == /datum/patron/divine/ravox)
		wrists = /obj/item/clothing/neck/roguetown/psicross/ravox

	if(H.patron.type == /datum/patron/divine/necra)
		wrists = /obj/item/clothing/neck/roguetown/psicross/necra
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
	if(H.patron.type == /datum/patron/divine/abyssor)
		wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
		H.adjust_skillrank_up_to(/datum/skill/misc/swimming = 6)
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
	if(H.patron.type == /datum/patron/divine/dendor)
		wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
	if(H.patron.type == /datum/patron/divine/malum)
		wrists = /obj/item/clothing/neck/roguetown/psicross/malum
		H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing = 3)
		H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing = 3)
		H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing = 3)
		H.adjust_skillrank_up_to(/datum/skill/craft/smelting = 6)
	if(H.patron.type == /datum/patron/divine/xylix)
		wrists = /obj/item/clothing/neck/roguetown/luckcharm
		H.adjust_skillrank_up_to(/datum/skill/misc/sneaking = 6)
		H.adjust_skillrank_up_to(/datum/skill/misc/music = 6)		
		H.adjust_skillrank_up_to(/datum/skill/misc/climbing = 3)
		H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking = 3)
	if(H.patron.type == /datum/patron/divine/eora)
		wrists = /obj/item/clothing/neck/roguetown/psicross/eora
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
	if(H.patron.type == /datum/patron/divine/pestra)
		wrists = /obj/item/clothing/neck/roguetown/psicross/pestra
		backpack_contents = list(/obj/item/natural/bundle/cloth, /obj/item/needle/pestra)
	if(H.patron.type == /datum/patron/inhumen/zizo)
		wrists = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
	if(H.patron.type == /datum/patron/inhumen/graggar)
		wrists = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
	if(H.patron.type == /datum/patron/inhumen/matthios)
		wrists = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
		H.adjust_skillrank_up_to(/datum/skill/misc/sneaking = 6)
		H.adjust_skillrank_up_to(/datum/skill/misc/climbing = 6)
		H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking = 6)
	if(H.patron.type == /datum/patron/inhumen/baotha)
		wrists = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy
	if(H.patron.type == /datum/patron/old_god)
		wrists = /obj/item/clothing/neck/roguetown/psicross/silver
		mask = /obj/item/clothing/mask/rogue/sack/psy
		head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/prophet
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/revive)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
