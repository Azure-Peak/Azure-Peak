/datum/job/roguetown/vampire_guard
	title = "Vampire Guard"
	flag = VAMPIRE_GUARD
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null
	max_pq = null

	allowed_sexes = list(MALE, FEMALE)
	tutorial = ""

	outfit = /datum/outfit/job/roguetown/vampire_guard
	show_in_credits = FALSE
	give_bank_account = FALSE
	announce_latejoin = FALSE
	cmode_music = 'sound/music/combat_weird.ogg'

/datum/job/roguetown/vampire_guard/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	SSmapping.retainer.death_knights |= L.mind
	return ..()

/datum/outfit/job/roguetown/vampire_guard/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	var/list/possible_classes = list()
	for(var/datum/advclass/CHECKS in SSrole_class_handler.sorted_class_categories[CTAG_MERCENARY])
		if(!CHECKS.check_requirements(H))
			continue

		possible_classes += CHECKS

	var/datum/advclass/C = input(H.client, "What is my class?", "Adventure") as null|anything in possible_classes
	C.equipme(H)

	H.adjust_skillrank_up_to(/datum/skill/magic/blood, 3, TRUE)
