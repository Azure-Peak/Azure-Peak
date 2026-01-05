/datum/advclass/wretch/licker
	name = "Licker"
	tutorial = "You have recently been embraced as a vampire. You do not know whom your sire is, strange urges, unnatural strength, a thirst you can barely control. You were outed as a monster and are now on the run."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/wretch/licker
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(
		TRAIT_STEELHEARTED,
		TRAIT_SILVER_WEAK,
	)
	maximum_possible_slots = 2
	applies_post_equipment = FALSE

/datum/outfit/job/roguetown/wretch/licker/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.adjust_blindness(-3)
		var/list/possible_classes = list()
		for(var/datum/advclass/CHECKS in SSrole_class_handler.sorted_class_categories[CTAG_LICKER_WRETCH])
			possible_classes += CHECKS

		var/datum/advclass/C = input(H.client, "What is my class?", "Adventure") as null|anything in possible_classes
		C.equipme(H)

		H.adjust_skillrank_up_to(/datum/skill/magic/blood, 4, TRUE)
		var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(generation = GENERATION_NEONATE)
		H.mind.add_antag_datum(new_antag)
		REMOVE_TRAIT(H, TRAIT_OUTLAW, JOB_TRAIT)
		if(HAS_TRAIT(H, TRAIT_CRITICAL_RESISTANCE))
			REMOVE_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, null)
		to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as a Wretch, you are expected to actively create conflict with other players. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards.")) //giving this notice, since its part of the bounty system
		//leaving the below in if people want to give lickers outlaw/bounty status again, this will keep it off the trader roles but combat roles will have to choose a bounty
		/*var/list/traderjobs = list("Aristocrat",
									"Scholar", 
								   "Peddler", 
								   "Jeweler", 
								   "Harlequin", 
								   "Doomsayer", 
								   "Cuisiner", 
								   "Brewer") 
		if(H.advjob in traderjobs)
			REMOVE_TRAIT(H, TRAIT_OUTLAW, JOB_TRAIT) //removing since these are non-combat roles and they need to be able to use the stocks and miesters to blend in
			to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as a Wretch, you are expected to actively create conflict with other players. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards.")) //giving this notice, since its part of the bounty system
		else
			wretch_select_bounty(H)*/

		if(HAS_TRAIT(H, TRAIT_DNR))
			ADD_TRAIT(H, TRAIT_DUSTABLE, TRAIT_GENERIC)//give DNR vampires the option to turn to dust

/datum/reagent/vampsolution
	metabolization_rate = 0.5

/datum/reagent/vampsolution/on_mob_life(mob/living/carbon/M)
	M.set_drugginess(30)
	if(prob(5))
		if(M.gender == FEMALE)
			M.emote(pick("twitch_s","giggle"))
		else
			M.emote(pick("twitch_s","chuckle"))
	M.apply_status_effect(/datum/status_effect/debuff/vampbite)
	..()

/atom/movable/screen/fullscreen/vampsolution
	icon_state = "spa"
	plane = FLOOR_PLANE
	layer = ABOVE_OPEN_TURF_LAYER
	blend_mode = 0
	show_when_dead = FALSE

/datum/reagent/vampsolution/on_mob_metabolize(mob/living/M, mob/living/S)
	M.overlay_fullscreen("druqk", /atom/movable/screen/fullscreen/druqks)
	M.update_body_parts_head_only()
	if(M.client)
		ADD_TRAIT(M, TRAIT_DRUQK, "based")
		SSdroning.area_entered(get_area(M), M.client)

/datum/reagent/vampsolution/on_mob_end_metabolize(mob/living/M, mob/living/S)
	M.clear_fullscreen("druqk")
	M.remove_status_effect(/datum/status_effect/buff/druqks)
	M.set_drugginess(0)
	if(M.client)
		REMOVE_TRAIT(M, TRAIT_DRUQK, "based")
		SSdroning.play_area_sound(get_area(M), M.client)
	M.update_body_parts_head_only()
