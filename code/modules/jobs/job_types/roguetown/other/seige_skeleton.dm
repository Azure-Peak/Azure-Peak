/datum/job/roguetown/seige_skeleton
	title = "Siege Skeleton"
	flag = SKELETON
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null //no pq, this is the only job slot during skeleton seige bad omen.
	max_pq = null
	announce_latejoin = FALSE

	advclass_cat_rolls = list(CTAG_SIEGESKELETON = 20) //Unique NPC-esc Disposable roles. 3 of them, intended to antagonise, conflict and die in most cases.
	//Unlike most roles of skeletons, these ones just dust. Rids you instantly out of the round so you can respawn.
	//These are exclusive to skeleton sieges, they're a threat in numbers but advs can usually kill them solo, if they're not super robust by design.

	tutorial = "You have arisen by the will of an unknown force, fight and die. This is a disposable antagonist role, do not expect to last long." //Disposable throwaway antag

	outfit = /datum/outfit/job/roguetown/seige_skeleton/seiger
	show_in_credits = FALSE
	give_bank_account = FALSE
	hidden_job = TRUE

/datum/outfit/job/roguetown/siege_skeleton/pre_equip(mob/living/carbon/human/H)
	..()

	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	H.set_patron(/datum/patron/inhumen/zizo)

	H.possible_rmb_intents = list(/datum/rmb_intent/feint,\
	/datum/rmb_intent/aimed,\
	/datum/rmb_intent/riposte,\
	/datum/rmb_intent/strong,\
	/datum/rmb_intent/weak)
	H.swap_rmb_intent(num=1)

	var/datum/antagonist/new_antag = new /datum/antagonist/skeleton()
	H.mind.add_antag_datum(new_antag)

	H.grant_language(/datum/language/undead)

	H.cmode_music = 'sound/music/combat_weird.ogg' //Same as regular deadites

	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/undead

/datum/job/roguetown/seige_skeleton/after_spawn(mob/living/L, mob/M, latejoin = FALSE)
	..()

	var/mob/living/carbon/human/H = L
	H.mob_biotypes |= MOB_UNDEAD

	H.advsetup = TRUE
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")
	for (var/obj/item/bodypart/B in H.bodyparts)
		B.skeletonize(FALSE)

/*
SIEGE SKELETONS, THESE ARE INTENTIONALLY VERY THROWAWAY ROLES. DUST ON DEATH + CRIT WEAKNESS + LOW STATS + TERRIBLE DECREPIT GEAR
*/


/datum/outfit/job/roguetown/seige_skeleton/seiger //Basically just NPC skeleton but slightly tuned up for players, with decrepit gear that can't be fixed. YOU WILL DIE.
	beltr = /obj/item/rogueweapon/huntingknife/idagger/adagger //Softlock protection, can be used as a pick in a pinch.

/datum/advclass/seige_skeleton/seiger/feralfootsoldier
	name = "Decrepit Feral Footsoldier"
	tutorial = "You have arisen from unknown means, your tarnished guardsman plate clinging to your form. fight and kill."
	outfit = /datum/outfit/job/roguetown/seige_skeleton/seiger/feralfootsoldier
	category_tags = list(CTAG_SEIGESKELETON)
	subclass_skills = list(
		//No labor skills, go cause problems and die.
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)
	traits_applied = list(TRAIT_CRITICAL_WEAKNESS, TRAIT_DUSTABLE, TRAIT_SILVER_WEAK, TRAIT_MEDIUMARMOR) // You are disposable, your entire role is to fight and die.

/datum/outfit/job/roguetown/seige_skeleton/seiger/feralfootsoldier/pre_equip(mob/living/carbon/human/H)
	..()
	//intentionally decrepit gear, you're going to die rapidly. You're just here to start some fights and do some shennagions.
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/guard
	head = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	belt = /obj/item/storage/belt/rogue/leather/rope
	l_hand = /obj/item/rogueweapon/shield/tower/metal/alloy //guarrenteed ancient shield, its going to break pretty fast.

//you don't get to pick weapon, because this is a quick spawn in, fight and die role.
	if(prob(33))
		r_hand = /obj/item/rogueweapon/spear/aalloy
	else if(prob(33))
		r_hand = /obj/item/rogueweapon/sword/short/gladius/agladius	// ave
	else
		r_hand = /obj/item/rogueweapon/flail/aflail

//Unlike other skeles, pre-set. You WILL die. This is barely above an NPC, by intention.
	H.STASTR = 12
	H.STASPD = 9
	H.STACON = 8
	H.STAWIL = 10
	H.STAPER = 10
	H.STAINT = 1
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser) //Softlock immunity

	to_chat(H, span_warning("You are a disposable Antagonist, go drive up some quick roleplay and conflict, expect to die rapidly!")) //Go forth my Fraggers.
	to_chat(H, span_narsiesmall("Find... Fight... Destroy..."))

	H.energy = H.max_energy

/datum/advclass/seige_skeleton/seiger/feralarcher
	name = "Decrepit Feral Archer"
	tutorial = "You have arisen from unknown means, your bow and arrows at hand. fight and kill."
	outfit = /datum/outfit/job/roguetown/seige_skeleton/seiger/feralarcher
	category_tags = list(CTAG_SEIGESKELETON)
	subclass_skills = list(
		//No labor skills, go cause problems and die.
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE, //Dies to grapples. Disposable, hardcounter intended.
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)
	traits_applied = list(TRAIT_CRITICAL_WEAKNESS, TRAIT_DUSTABLE, TRAIT_SILVER_WEAK, TRAIT_MEDIUMARMOR) // You are disposable, your entire role is to fight and die.

/datum/outfit/job/roguetown/seige_skeleton/seiger/feralarcher/pre_equip(mob/living/carbon/human/H)
	..()
	//intentionally decrepit gear, you're going to die rapidly. You're just here to start some fights and do some shennagions.
	head = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	belt = /obj/item/storage/belt/rogue/leather/rope
	backl = /obj/item/quiver/broadhead_aalloy
	beltl = /obj/item/rogueweapon/mace/alloy

//Unlike other skeles, pre-set. You WILL die. This is barely above an NPC, by intention.
	H.STASTR = 9
	H.STASPD = 9
	H.STACON = 6
	H.STAWIL = 10
	H.STAPER = 12 //Players are smarter than NPCs, so they don't get much if, any range at all.
	H.STAINT = 1
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser) //Softlock immunity

	to_chat(H, span_warning("You are a disposable Antagonist, go drive up some quick roleplay and conflict, expect to die rapidly!")) //Go forth my Fraggers.
	to_chat(H, span_narsiesmall("Find... Fight... Destroy..."))

	H.energy = H.max_energy

/datum/advclass/seige_skeleton/seiger/feralbulwark
	name = "Decrepit Feral Bulwark"
	tutorial = "You have arisen from unknown means, your tarnished rotting plate still clinging to your body. fight and kill."
	outfit = /datum/outfit/job/roguetown/seige_skeleton/seiger/feralbulwark
	category_tags = list(CTAG_SEIGESKELETON)
	subclass_skills = list(
		//No labor skills, go cause problems and die.
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, //Enough to maybe escape a grapple, terrible con + low speed make it hard to weaponise
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)
	traits_applied = list(TRAIT_CRITICAL_WEAKNESS, TRAIT_DUSTABLE, TRAIT_SILVER_WEAK, TRAIT_HEAVYARMOR) // You are disposable, your entire role is to fight and die.

/datum/outfit/job/roguetown/seige_skeleton/seiger/feralbulwark/pre_equip(mob/living/carbon/human/H)
	..()
	//intentionally decrepit gear, you're going to die rapidly. You're just here to start some fights and do some shennagions.
	cloak = /obj/item/clothing/cloak/tabard/blkknight
	head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/aalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/platelegs/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/gorget/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/plate/aalloy
	belt = /obj/item/storage/belt/rogue/leather

//you don't get to pick weapon, because this is a quick spawn in, fight and die role.
	if(prob(50))
		r_hand = /obj/item/rogueweapon/greatsword/aalloy
	else
		r_hand = /obj/item/rogueweapon/mace/goden/aalloy

//Unlike other skeles, pre-set. You WILL die. This is barely above an NPC, by intention.
	H.STASTR = 13
	H.STASPD = 8 //slightly lower and weaker once the armor cracks
	H.STACON = 7 //Dies as soon as their armor gives in.
	H.STAWIL = 12
	H.STAPER = 9
	H.STAINT = 1
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser) //Softlock immunity

	to_chat(H, span_warning("You are a disposable Antagonist, go drive up some quick roleplay and conflict, expect to die rapidly!")) //Go forth my Fraggers.
	to_chat(H, span_narsiesmall("Find... Fight... Destroy..."))

	H.energy = H.max_energy
