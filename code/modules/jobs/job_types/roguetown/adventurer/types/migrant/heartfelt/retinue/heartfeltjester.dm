
/datum/advclass/heartfelt/retinue/jester
	name = "Heartfelt Jester"
	tutorial = "You are the Jester of Heartfelt, a bringer of laughter in brighter days. \
	Though grief weighs heavy beneath your painted smile, you turn your steps toward the Peak—hoping your wit, charm, and cunning may yet carve out a place for joy."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/jester
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_COURT
	traits_applied = list(TRAIT_ZJUMP, TRAIT_LEAPER, TRAIT_NUTCRACKER, TRAIT_NOFALLDAMAGE1, TRAIT_HEARTFELT)

// HIGH COURT - /ONE SLOT/ Roles that were previously in the Court, but moved here.

/datum/outfit/job/roguetown/heartfelt/retinue/jester/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/jester
	pants = /obj/item/clothing/under/roguetown/tights
	armor = /obj/item/clothing/suit/roguetown/shirt/jester
	belt = /obj/item/storage/belt/rogue/leather
	head = /obj/item/clothing/head/roguetown/jester
	neck = /obj/item/clothing/neck/roguetown/coif
	H.adjust_skillrank(/datum/skill/combat/knives, rand(SKILL_LEVEL_APPRENTICE , SKILL_LEVEL_MASTER), TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, rand(SKILL_LEVEL_NOVICE, SKILL_LEVEL_LEGENDARY), TRUE) 
	H.adjust_skillrank(/datum/skill/misc/sneaking, rand(SKILL_LEVEL_APPRENTICE, SKILL_LEVEL_EXPERT), TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, rand(SKILL_LEVEL_NOVICE, SKILL_LEVEL_EXPERT), TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, rand(SKILL_LEVEL_APPRENTICE, SKILL_LEVEL_MASTER), TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, rand(SKILL_LEVEL_JOURNEYMAN, SKILL_LEVEL_MASTER), TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, rand(SKILL_LEVEL_EXPERT, SKILL_LEVEL_LEGENDARY), TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, rand(SKILL_LEVEL_NONE, SKILL_LEVEL_EXPERT), TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, rand(SKILL_LEVEL_NONE, SKILL_LEVEL_EXPERT), TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, rand(SKILL_LEVEL_NOVICE, SKILL_LEVEL_EXPERT), TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, rand(SKILL_LEVEL_APPRENTICE, SKILL_LEVEL_EXPERT), TRUE)
	H.STASTR = rand(3, 20) //Slightly better odds for a Heartfelter AKA a migrant
	H.STAWIL = rand(3, 20)
	H.STACON = rand(3, 20)
	H.STAINT = rand(3, 20)
	H.STAPER = rand(3, 20)
	H.STALUC = rand(3, 20)
	H.cmode_music = 'sound/music/combat_jester.ogg'
	if(H.mind)
		// Mime vs Jester. 
		if(HAS_TRAIT(H, TRAIT_PERMAMUTE)) // I considered adding a check for Xylix patron but in the off chance there's a mute non-xylix jester I don't want to fuck them over.
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_wall)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/conjure/mime_chair)
		else
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/telljoke)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/telltragedy)
	H.verbs |= /mob/living/carbon/human/proc/ventriloquate
	H.verbs |= /mob/living/carbon/human/proc/ear_trick
	if(!istype(H.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		H.internal_organs_slot[ORGAN_SLOT_TONGUE] = new /obj/item/organ/tongue/wild_tongue
	if(prob(50))
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC) // Jester :3
	else
		ADD_TRAIT(H, TRAIT_STEELHEARTED, TRAIT_GENERIC) // Joker >:(
