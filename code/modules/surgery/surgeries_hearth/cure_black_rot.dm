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
	possible_locs = list(BODY_ZONE_CHEST)

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
	var/new_total = 100
	var/new_per_tick = 10
	var/datum/status_effect/buff/rot_cleansing/existing_cleanse = target.has_status_effect(/datum/status_effect/buff/rot_cleansing)
	if(existing_cleanse)
		if(existing_cleanse.can_override(new_total, new_per_tick))
			target.remove_status_effect(existing_cleanse)
			target.apply_status_effect(/datum/status_effect/buff/rot_cleansing, new_total, new_per_tick)
			display_results(user, target, span_notice("The heat overpowers the corruption, accelerating the cleansing process!"),
				"[user] aggressively cauterizes the wound, forcing the black coloration to recede faster from [target]'s flesh.",
				"[user] uses the [tool] to intensively purify [target]'s chest.")
		else
			display_results(user, target, span_warning("The treatment fails to intensify the existing purification process."),
				"[user] attempts to cauterize the wound, but [target]'s body is already purging the rot as efficiently as possible.",
				"[user] applies the [tool], but the lingering corruption is already being actively managed.")
	else
		target.apply_status_effect(/datum/status_effect/buff/rot_cleansing, new_total, new_per_tick)
		display_results(user, target, span_notice("The black rot corruption begins to rapidly recede."),
			"[user] finishes purifying the area. The black coloration recedes from [target]'s flesh.",
			"[user] uses the [tool] to cauterize and purify [target]'s chest.")
	return TRUE
