/datum/job/roguetown/jester
	title = "Jester"
	flag = JESTER
	department_flag = COURTIERS
	faction = "Station"
	total_positions = 1
	spawn_positions = 1

	allowed_races = ACCEPTED_RACES

	tutorial = "The Grenzelhofts were known for their Jesters, wisemen with a tongue just as sharp as their wit. \
		You command a position of a fool, envious of the position your superiors have upon you. \
		Your cheap tricks and illusions of intelligence will only work for so long, \
		and someday you'll find yourself at the end of something sharper than you."

	allowed_ages = ALL_AGES_LIST
	outfit = /datum/outfit/job/roguetown/jester
	job_traits = list(TRAIT_ZJUMP, TRAIT_LEAPER, TRAIT_NUTCRACKER, TRAIT_TEMPO)
	display_order = JDO_JESTER
	give_bank_account = TRUE
	min_pq = -4 //silly jesters are funny so low PQ requirement
	max_pq = null
	round_contrib_points = 2

/datum/outfit/job/roguetown/jester/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/jester
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes/gold
	pants = /obj/item/clothing/under/roguetown/tights
	armor = /obj/item/clothing/suit/roguetown/shirt/jester
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/storage/keyring/servant
	beltl = /obj/item/storage/belt/rogue/pouch
	head = /obj/item/clothing/head/roguetown/jester
	neck = /obj/item/clothing/neck/roguetown/coif
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/stealing, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/music, rand(1,6), TRUE)
	H.adjust_skillrank(/datum/skill/misc/lockpicking, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/cooking, rand(1,3), TRUE)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)
	H.STASTR = rand(1, 21)
	H.STAWIL = rand(1, 21)
	H.STACON = rand(1, 21)
	H.STAINT = rand(1, 21)
	H.STAPER = rand(1, 21)
	H.STALUC = rand(1, 21)
	H.cmode_music = 'sound/music/combat_jester.ogg'
	if(H.mind)
		// Mime vs Jester.
		// As a mute jester you cannot cast Tell Joke/Tragedy, so why even have them?
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
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LETSGOGAMBLING, H, "Savings.")

