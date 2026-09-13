/datum/sex_action/oral/lick_ears
	name = "Lick their ears"
	check_same_tile = FALSE
	target_priority = 100
	user_priority = 0
	flipped = TRUE
	debug_erp_panel_verb = FALSE

/datum/sex_action/oral/lick_ears/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_EARS, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/oral/lick_ears/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	var/locked = user.get_active_precise_hand()
	if(check_sex_lock(user, locked))
		return FALSE
	if(user == target)
		return FALSE
	if(target.freeuse)
		return TRUE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_EARS, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/oral/lick_ears/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(span_warning("[user] [do_subtle ? "subtly " : ""]places [user.p_their()] tongue against [target] ear..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/oral/lick_ears/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.visible_message(span_warning("[user] stops [do_subtle ? "subtly " : ""]licking [target]'s ear ..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/oral/lick_ears/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/locked = user.get_active_precise_hand()
	sex_locks |= new /datum/sex_session_lock(user, locked)
	sex_locks |= new /datum/sex_session_lock(user, BODY_ZONE_PRECISE_MOUTH)

/datum/sex_action/oral/lick_ears/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	if(has_sensitive_ears(target) == TRUE || iself(target) || ishalfelf(target) || isdarkelf(target) || ishalforc(target) || isgoblinp(target) || isgnoll(target))
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] licks [target]'s ear... [target.p_their()] weakness..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective(do_subtle)] licks [target]'s ear..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))


/datum/sex_action/oral/lick_ears/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	var/do_subtle = sex_session.doing_subtly
	user.make_sucking_noise(do_subtle)

	if(has_sensitive_ears(target) == TRUE || iself(target) || ishalfelf(target) || isdarkelf(target) || ishalforc(target) || isgoblinp(target) || isgnoll(target))
		sex_session.perform_sex_action(target, 10, 0, TRUE, sex_session.speed, sex_session.force)
	else
		sex_session.perform_sex_action(target, 1, 0, TRUE, sex_session.speed, sex_session.force)

	sex_session.handle_passive_ejaculation(target)
