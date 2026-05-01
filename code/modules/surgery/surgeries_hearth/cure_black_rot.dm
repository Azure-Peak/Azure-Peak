/datum/surgery/cure_black_rot
	name = "Black Rot Extirpation"
	desc = "A specialized and extremely dangerous surgery to excise the Black Rot and remove the source of the corruption."
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/extract_black_rose_residue,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/extract_black_rose_residue
	name = "Excise black rot"
	implements = list(
		TOOL_SCALPEL = 85,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	time = 12 SECONDS
	surgery_flags = SURGERY_INCISED
	skill_min = SKILL_LEVEL_EXPERT
	preop_sound = 'sound/surgery/scalpel1.ogg'
	success_sound = 'sound/surgery/scalpel2.ogg'

/datum/surgery_step/extract_black_rose_residue/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_userdanger("I carefully attempt to cut out the black ooze from [target]'s flesh..."),
		span_userdanger("[user] carefully tries to cut out the black ooze from [target]'s chest."),
		span_userdanger("[user] carefully tries to cut out the black ooze from [target]'s chest."))
	return TRUE

/datum/surgery_step/extract_black_rose_residue/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	if(!target.has_status_effect(/datum/status_effect/black_rot))
		display_results(user, target, span_warning("The site burns cleanly. No active black rot corruption found."),
			"[user] cauterizes the wound.",
			"[user] cauterizes the wound.")
		return TRUE

	var/damage = 50
	var/medskill = user.get_skill_level(/datum/skill/misc/medicine)
	damage -= (medskill * 6)
	damage = max(0, damage)
	target.adjustBruteLoss(damage)
	if(target.remove_status_effect(/datum/status_effect/black_rot))
		display_results(user, target, span_notice("The black rot corruption recedes."),
			"[user] finishes purifying the area. The black coloration recedes from [target]'s flesh.",
			"[user] uses the [tool] to cauterize and purify [target]'s chest.")
	else
		display_results(user, target, span_warning("The heat fails to purge the lingering rot!"),
			"[user] attempts to cauterize the wound, but the corruption resists.",
			"[user] attempts to cauterize the wound, but the corruption resists.")
	return TRUE
