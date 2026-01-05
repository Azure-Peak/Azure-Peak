/datum/surgery/rogue_revival_with_a_big_fat_tick
	steps = list(
		/datum/surgery_step/incise,
		/datum/surgery_step/clamp,
		/datum/surgery_step/retract,
		/datum/surgery_step/saw,
		/datum/surgery_step/infuse_tick,
		/datum/surgery_step/cauterize
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/infuse_tick
	name = "Infuse Leechtick"
	implements = list(
		/obj/item/leechtick_bloated = 80,
	)
	target_mobtypes = list(/mob/living/carbon/human, /mob/living/carbon/monkey)
	time = 10 SECONDS
	surgery_flags = SURGERY_BLOODY | SURGERY_INCISED | SURGERY_CLAMPED | SURGERY_RETRACTED | SURGERY_BROKEN
	skill_min = SKILL_LEVEL_APPRENTICE
	preop_sound = 'sound/surgery/organ2.ogg'
	success_sound = 'sound/surgery/organ1.ogg'
	possible_locs = list(BODY_ZONE_CHEST)

/datum/surgery_step/infuse_tick/validate_target(mob/user, mob/living/carbon/target, target_zone, datum/intent/intent)
	. = ..()
	if(target.stat < DEAD)
		to_chat(user, "They're not dead!")
		return FALSE
	var/obj/item/organ/heart/H = target.getorganslot(ORGAN_SLOT_HEART)
	if(!H)
		to_chat(user, "[target] is missing their heart!")
		return FALSE
	if(!target.check_revive(user))
		return FALSE

/datum/surgery_step/infuse_tick/preop(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	display_results(user, target, span_notice("I begin to revive [target]... will their heart respond?"),
		span_notice("[user] begins to work leechtick into [target]'s heart."),
		span_notice("[user] begins to work leechtick into [target]'s heart."))
	return TRUE

/datum/surgery_step/infuse_tick/success(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent)
	var/revive_pq = PQ_GAIN_REVIVE
	if(target.mob_biotypes & MOB_UNDEAD)
		display_results(user, target, span_notice("You cannot infuse life into the undead! The rot must be cured first."),
			"[user] works the leechtick into [target]'s innards.",
			"[user] works the leechtick into [target]'s innards.")
		return FALSE
	if (target.mind)
		if(alert(target, "Are you ready to face the world, once more?", "Revival", "I must go on", "Let me rest") != "I must go on")
			display_results(user, target, span_notice("[target]'s heart refuses the leechtick. They're only in sweet dreams, now."),
				"[user] works the leechtick into [target]'s innards, but nothing happens.",
				"[user] works the leechtick into [target]'s innards, but nothing happens.")
			return FALSE
	target.adjustOxyLoss(-target.getOxyLoss()) //Ye Olde CPR
	if(!target.revive(full_heal = FALSE))
		display_results(user, target, span_notice("The leechtick refuses to meld with [target]'s heart. Their damage must be too severe still."),
			"[user] works the leechtick into [target]'s innards, but nothing happens.",
			"[user] works the leechtick into [target]'s innards, but nothing happens.")
		return FALSE
	display_results(user, target, span_notice("You succeed in restarting [target]'s heart with the infusion of the leechtick's viscera."),
		"[user] works the leechtick into [target]'s innards.",
		"[user] works the leechtick into [target]'s innards.")
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit()
	if(underworld_spirit)
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		qdel(underworld_spirit)
		ghost.mind.transfer_to(target, TRUE)
	target.grab_ghost(force = TRUE) // even suicides
	target.emote("breathgasp")
	target.Jitter(100)
	record_round_statistic(STATS_LUX_REVIVALS)
	target.update_body()
	target.visible_message(span_notice("[target] is dragged back from Necra's hold!"), span_green("I awake from the void."))
	qdel(tool)
	if(target.mind)
		if(revive_pq && !HAS_TRAIT(target, TRAIT_IWASREVIVED) && user?.ckey)
			adjust_playerquality(revive_pq, user.ckey)
			ADD_TRAIT(target, TRAIT_IWASREVIVED, "[type]")
	target.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
	target.apply_status_effect(/datum/status_effect/debuff/leech_schizophrenia)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
	return TRUE

/datum/surgery_step/infuse_tick/failure(mob/user, mob/living/target, target_zone, obj/item/tool, datum/intent/intent, success_prob)
	display_results(user, target, span_warning("I screwed up!"),
		span_warning("[user] screws up!"),
		span_notice("[user] works the leechtick into [target]'s innards. It squishes in a disgusting fashion."), TRUE)
	return TRUE
