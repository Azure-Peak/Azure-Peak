GLOBAL_VAR(king_throne)

/obj/structure/roguethrone
	name = "throne of Azure Peak"
	desc = "A big throne, to hold the Lord's giant personality. Say 'secrets of the throat' with the crown on your head if you are confused."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "throne"
	density = FALSE
	can_buckle = 1
	pixel_x = -32
	max_integrity = 999999
	buckle_lying = FALSE
	obj_flags = NONE
	var/rebel_leader_sit_time = 0
	var/notified_rebel_able = FALSE
	/// The currently active usurpation rite, if any
	var/datum/usurpation_rite/active_rite
	var/last_rite_announcement = 0

/obj/structure/roguethrone/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)

/obj/structure/roguethrone/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
	M.reset_offsets("bed_buckle")
	if(!active_rite)
		return
	if(active_rite.invoker == M && active_rite.stage == RITE_STAGE_GATHERING)
		active_rite.on_invoker_unseated()
	if(active_rite?.contester == M)
		active_rite.cancel_counter_claim()

/obj/structure/roguethrone/Initialize()
	. = ..()
	become_hearing_sensitive()
	if(GLOB.king_throne == null)
		GLOB.king_throne = src
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/obj/structure/roguethrone/Destroy()
	if(active_rite)
		active_rite.fail("The throne has been destroyed.")
	lose_hearing_sensitivity()
	if(GLOB.king_throne == src)
		GLOB.king_throne = null
	GLOB.lordcolor -= src
	return ..()

/obj/structure/roguethrone/process()
	var/dt = 1 SECONDS
	process_rebel_leader_sit(dt)
	process_rite_announcements()
	. = ..()

/obj/structure/roguethrone/proc/process_rebel_leader_sit(dt)
	if(!length(buckled_mobs))
		return
	var/mob/living/user = buckled_mobs[1]
	if(user.stat != CONSCIOUS)
		return
	var/datum/antagonist/prebel/P = user.mind?.has_antag_datum(/datum/antagonist/prebel)
	if(!P)
		return
	if(rebel_leader_sit_time == 0)
		to_chat(user, span_notice("Finally, I'm sitting on the throne - when I get more comfortable here I'll be able to announce victory. Other rebels here will help me get comfortable faster."))
	var/time_modifier = 1.0
	/// Increase modifier for every other conscious rebel in view
	for(var/mob/living/living_mob in view(7, loc))
		if(living_mob == user)
			continue
		if(living_mob.stat != CONSCIOUS)
			continue
		var/datum/antagonist/prebel/rebel_antag = living_mob.mind?.has_antag_datum(/datum/antagonist/prebel)
		if(!rebel_antag)
			continue
		time_modifier += REBEL_THRONE_SPEEDUP_PER_PERSON
	rebel_leader_sit_time += (dt * time_modifier)
	if(rebel_leader_sit_time >= REBEL_THRONE_TIME && !notified_rebel_able)
		notified_rebel_able = TRUE
		to_chat(user, span_notice("That's it - time to announce our victory!"))

/obj/structure/roguethrone/proc/process_rite_announcements()
	if(!active_rite || active_rite.stage < RITE_STAGE_GATHERING)
		return
	if(world.time < last_rite_announcement + RITE_ANNOUNCEMENT_INTERVAL)
		return
	var/announcement = active_rite.get_periodic_announcement()
	if(!announcement)
		return
	last_rite_announcement = world.time
	say(announcement)

/obj/structure/roguethrone/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(speaker == src)
		return
	if(!ishuman(speaker))
		return
	if(!active_rite)
		return
	var/mob/living/carbon/human/H = speaker
	if(active_rite.stage == RITE_STAGE_GATHERING && findtext(raw_message, "i assent"))
		active_rite.try_assent(H)
	else if(active_rite.stage <= RITE_STAGE_GATHERING && findtext(raw_message, "i abdicate"))
		active_rite.try_abdication(H)
	else if(active_rite.stage == RITE_STAGE_CONTESTING && findtext(raw_message, "stop ascent"))
		if(!(H in buckled_mobs))
			to_chat(H, span_warning("You must be seated on the throne to halt the succession."))
			return
		active_rite.start_counter_claim(H)

/obj/structure/roguethrone/examine(mob/user)
	. = ..()
	. += span_notice("The throne of the [SSticker.realm_type] of [SSticker.realm_name].")
	if(active_rite)
		var/status = active_rite.get_status_text()
		if(status)
			. += span_notice(status)
		switch(active_rite.stage)
			if(RITE_STAGE_GATHERING)
				. += span_warning("A claim is being made upon the throne. Say 'I assent' near the throne to support it, or act to stop [active_rite.invoker?.real_name].")
			if(RITE_STAGE_CONTESTING)
				var/elapsed = world.time - active_rite.contest_started_at
				var/remaining = max(active_rite.contest_time_remaining - elapsed, 0)
				. += span_warning("[active_rite.invoker?.real_name] is claiming the throne! Sit on the throne and say 'stop ascent' to halt the succession. Alternatively, kill, knock them unconscious or remove them far away from the throne room by the end of the rite. [round(remaining / (1 SECONDS))] second(s) remain.")

/obj/structure/roguethrone/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("<b>Throat Commands</b> (say these at the Throat of Azure Peak):")
	. += span_info("'Make Announcement' - broadcast a message (requires crown)")
	. += span_info("'Make Decree' - issue a royal decree (requires crown, ruler only)")
	. += span_info("'Purge Decrees' - remove all decrees (requires crown, ruler only)")
	. += span_info("'Make Law' - create a new law (requires crown, ruler only)")
	. += span_info("'Remove Law (number)' - remove a specific law (requires crown, ruler only)")
	. += span_info("'Purge Laws' - remove all laws (requires crown, ruler only)")
	. += span_info("'Declare Outlaw' - outlaw someone (requires crown, ruler only)")
	. += span_info("'Set Taxes' - set the tax rate (requires crown, ruler only)")
	. += span_info("'Change Colors' - change the duchy's colors (requires crown, ruler only)")
	. += span_info("'Become Regent' - claim regency when ruler is absent (requires crown, noble blood, regency position)")
	. += span_info("'Summon Crown' / 'Summon Key' - retrieve royal items")
	. += span_info("<b>Rites of Succession</b> (say at the Throat or near the Throne):")
	. += span_info("'I Ascend' - invoke a rite of succession at the Throat")
	. += span_info("'I Assent' - support an active claim near the throne during the gathering phase")
	. += span_info("'I Abdicate' - the current ruler yields near the throne, skipping to contestation")
	. += span_info("'Stop Ascent' - while seated on the throne during contestation, pause and halt the rite. Remain seated for [RITE_COUNTER_CLAIM_DURATION / (1 MINUTES)] minute(s) to cancel.")

/obj/structure/roguethrone/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "throne_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)
	M = mutable_appearance(icon, "throne_secondary", -(layer+0.1))
	M.color = secondary
	add_overlay(M)
