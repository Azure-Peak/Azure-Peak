// lickers, unlike wretches, are more geared towards infiltration than deathballing, so they have separate (more permissive) slot scaling
/datum/job/roguetown/licker
	title = "Licker"
	flag = LICKER
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0

	tutorial = "You have recently been embraced as a vampire. You do not know whom your sire is, strange urges, unnatural strength, a thirst you can barely control. You were outed as a monster and are now on the run."
	outfit = null
	outfit_female = null
	display_order = JDO_LICKER
	show_in_credits = FALSE
	min_pq = 50 // vamps can however be quite coal
	max_pq = null

	obsfuscated_job = TRUE

	advclass_cat_rolls = list(CTAG_VAMPIRE = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = TRUE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/heretic/zchurch_keyholder, /datum/virtue/combat/second_chance) // idt i need to explain this one
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_HERESIARCH, TRAIT_SELF_SUSTENANCE, TRAIT_ZURCH, TRAIT_SILVER_WEAK) // combo of wretch n lycker advclass traits - i.e. what they had be4
	job_subclasses = list(
		/datum/advclass/licker
	)
	has_subprefs = TRUE
	default_subprefs = list("lycker_subclass" = null)

/datum/job/roguetown/licker/special_job_check(mob/dead/new_player/player)
	if(is_storyteller_soft_antag_blocked())
		return FALSE
	return ..()

/datum/job/roguetown/licker/special_check_latejoin(client/C)
	if(is_storyteller_soft_antag_blocked())
		return FALSE
	return ..()

/datum/job/roguetown/licker/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Assign lycker antagonist datum so they appear in antag list
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/lycker))
			var/datum/antagonist/new_antag = new /datum/antagonist/lycker()
			H.mind.add_antag_datum(new_antag)

/datum/advclass/licker
	name = "Licker"
	tutorial = "You have recently been embraced as a vampire. You do not know whom your sire is, strange urges, unnatural strength, a thirst you can barely control. You were outed as a monster and are now on the run."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED)
	outfit = /datum/outfit/job/roguetown/licker
	category_tags = list(CTAG_VAMPIRE)
	applies_post_equipment = FALSE

/datum/outfit/job/roguetown/licker/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.adjust_blindness(-3)
		var/list/possible_classes = list()
		for(var/datum/advclass/CHECKS in SSrole_class_handler.sorted_class_categories[CTAG_LICKER])
			possible_classes += CHECKS

		var/datum/advclass/C = input(H.client, "What is my class?", "Adventure") as null|anything in possible_classes
		C.equipme(H)

		H.adjust_skillrank_up_to(/datum/skill/magic/blood, 4, TRUE)
		var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(generation = GENERATION_NEONATE)
		H.mind.add_antag_datum(new_antag)
		H.apply_status_effect(STATUS_EFFECT_VAMPIRE_SPAWN_PROTECTION)
		if(HAS_TRAIT(H, TRAIT_CRITICAL_RESISTANCE))
			REMOVE_TRAIT(H, TRAIT_CRITICAL_RESISTANCE, null)
		if(HAS_TRAIT(H, TRAIT_RAGE))
			REMOVE_TRAIT(H, TRAIT_RAGE, null)
		to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as a Licker, you are expected to actively create conflict with other players. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards."))

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

/proc/update_lycker_slots(override_player_count)
	var/datum/job/lycker_job = SSjob.GetJob("Licker")
	if(!lycker_job)
		return
	if(lycker_job.admin_slot_override)
		return
	var/slots = SSgamemode.current_storyteller?.lycker_slots
	if(!SSgamemode.allow_vote && !isnull(SSgamemode.admin_slots["Licker"]))
		slots = max(0, SSgamemode.admin_slots["Licker"])
	if(isnull(slots))
		slots = 2
	// Never reduce below current occupancy
	lycker_job.total_positions = max(lycker_job.current_positions, slots)
	lycker_job.spawn_positions = max(lycker_job.current_positions, slots)
