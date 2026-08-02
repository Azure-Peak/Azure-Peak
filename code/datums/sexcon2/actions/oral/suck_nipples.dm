/datum/sex_action/oral/suck_nipples
	name = "Suck their nipples"
	check_same_tile = FALSE
	intensity = 3
	flipped = TRUE
	debug_erp_panel_verb = FALSE

/datum/sex_action/oral/suck_nipples/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target && !detached_head_self_service(user))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST, TRUE))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/oral/suck_nipples/can_perform(mob/living/user, mob/living/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target && !detached_head_self_service(user))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST, TRUE))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(check_sex_lock(user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(check_sex_lock(target, ORGAN_SLOT_BREASTS))
		return FALSE
	return TRUE

/datum/sex_action/oral/suck_nipples/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(user == target)
		user.visible_message(span_warning("[user] starts using [user.p_their()] severed head to suck [user.p_their()] own nipples..."))
	else
		user.visible_message(span_warning("[user] starts sucking [target]'s nipples..."))

/datum/sex_action/oral/suck_nipples/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	user.visible_message(span_warning("[user] stops sucking [tgt_poss(user, target)] nipples ..."))

/datum/sex_action/oral/suck_nipples/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(user, BODY_ZONE_PRECISE_MOUTH)

/datum/sex_action/oral/suck_nipples/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] sucks [tgt_poss(user, target)] nipples..."))

/datum/sex_action/oral/suck_nipples/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.make_sucking_noise()
	if(user == target)
		do_self_head_effects(user)

	sex_session.perform_sex_action(target, 1, 3, TRUE)
	sex_session.handle_passive_ejaculation(target)

	//VALMORIAN: re-ported from Emerald Summit - a lactating target leaks into the sucker's mouth.
	var/obj/item/organ/breasts/breasts = target.getorganslot(ORGAN_SLOT_BREASTS)
	if(!breasts?.lactating)
		return
	var/milk_to_add = min(max(breasts.breast_size, 1), breasts.milk_stored)
	if(milk_to_add > 0 && prob(25))
		user.reagents.add_reagent(/datum/reagent/consumable/milk, milk_to_add)
		breasts.milk_stored -= milk_to_add
		to_chat(user, span_notice("I can taste milk."))
		to_chat(target, span_notice("I can feel milk leak from my buds."))
