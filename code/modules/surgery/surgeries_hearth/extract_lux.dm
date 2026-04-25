/datum/surgery/extract_lux
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/extract_lux,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/extract_lux
	name = "Extract Lux"
	implements = list(
		TOOL_SCALPEL = 80,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	time = 8 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN
	skill_min = SKILL_LEVEL_JOURNEYMAN
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/extract_lux/validate_target(mob/user, mob/living/target, target_zone, datum/intent/intent)
	. = ..()
	if(target.stat == DEAD)
		to_chat(user, "They're dead!")
		return FALSE
	if(istiefling(target))
		to_chat(user, span_warning("Their Lux is infernal. It will not do."))
		return FALSE

/datum/surgery_step/extract_lux/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to scrape lux from [target]'s heart..."),
		span_notice("[user] begins to scrape lux from [target]'s heart."),
		span_notice("[user] begins to scrape lux from [target]'s heart."))
	return TRUE

/datum/surgery_step/extract_lux/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if (!target.has_status_effect(/datum/status_effect/buff/ozium))
		target.emote("painscream")
	if(target.has_status_effect(/datum/status_effect/debuff/devitalised))
		display_results(user, target, span_notice("You cannot draw lux from [target]; they have none left to give."),
		"[user] fails to extract lux from [target]'s innards.",
		"[user] fails to extract lux from [target]'s innards.")
		return FALSE
	else
		display_results(user, target, span_notice("You extract a single dose of lux from [target]'s heart."),
			"[user] extracts lux from [target]'s innards.",
			"[user] extracts lux from [target]'s innards.")
		
		var/apply_greater
		if(isaasimar(target) && !(HAS_TRAIT(target, TRAIT_ANCIENT_HAG) || HAS_TRAIT(target, TRAIT_FEYTOUCHED)))
			new /obj/item/reagent_containers/lux(target.loc)
			apply_greater = TRUE
		else if(HAS_TRAIT(target, TRAIT_ANCIENT_HAG) || HAS_TRAIT(target, TRAIT_FEYTOUCHED))
			new /obj/item/reagent_containers/lux_moss(target.loc)
		else
			new /obj/item/reagent_containers/lux_impure(target.loc)

		SEND_SIGNAL(user, COMSIG_LUX_EXTRACTED, target)
		//record_featured_stat(FEATURED_STATS_CRIMINALS, user)	- This.. isn't normally criminal.
		record_round_statistic(STATS_LUX_HARVESTED)
		target.apply_status_effect((apply_greater ? /datum/status_effect/debuff/devitalised/greater : /datum/status_effect/debuff/devitalised))
	return TRUE
