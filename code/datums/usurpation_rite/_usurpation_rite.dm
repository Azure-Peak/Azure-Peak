/**
 * Usurpation Rite
 *
 * Base datum for rites of succession.
 *
 * Flow:
 * 1. Invoked at the titan/throat via "I ascend"
 * 2. GATHERING: Supporters fulfill the rite condition
 * 3. CONTESTING: Conditions met; opponents can stop the rite by force
 * 4. COMPLETE: Power transfers to the invoker
 */
/datum/usurpation_rite
	var/name = "Usurpation Rite"
	var/desc = "A rite to claim the throne."
	var/explanation = "A rite of succession."
	var/stage = RITE_STAGE_INACTIVE
	var/mob/living/carbon/human/invoker
	var/obj/structure/roguethrone/throne
	var/list/assenters
	var/phase_timer_id
	var/started_at = 0
	var/new_ruler_title = "Grand Duke"
	var/new_ruler_title_f = "Grand Duchess"
	var/new_realm_type = "Grand Duchy"
	var/new_realm_type_short = "Duchy"
	var/mob/living/carbon/human/contester
	var/contester_timer_id
	var/contest_time_remaining = 0
	var/contest_started_at = 0
	/// Optional epilogue text shown at round end if this rite completed successfully.
	var/roundend_epilogue
	var/sound_contesting = 'sound/misc/usurpation/rite_contesting.ogg'
	var/sound_victory = 'sound/misc/usurpation/rite_victory.ogg'
	var/sound_failure = 'sound/misc/usurpation/rite_failure.ogg'
	var/required_assents = 5
	var/invoke_bars = NONE
	var/assent_bars = NONE
	var/outlaw_rejection = "Outlaws may not assent to this rite."
	var/undead_rejection = "The undead may not assent to this rite."
	var/vote_weight_note
	var/assenter_group = "supporters"
	var/council_name = "the council"
	var/claim_basis = "by rite"

/datum/usurpation_rite/New()
	. = ..()
	assenters = list()

/datum/usurpation_rite/Destroy()
	cleanup()
	return ..()

/datum/usurpation_rite/proc/can_invoke(mob/living/carbon/human/user)
	if(!istype(user))
		return FALSE
	if(user.stat != CONSCIOUS)
		return FALSE
	if(SSticker.rulermob == user)
		return FALSE
	if((invoke_bars & RITE_BAR_OUTLAW) && HAS_TRAIT(user, TRAIT_OUTLAW))
		return FALSE
	if((invoke_bars & RITE_BAR_UNDEAD) && is_undead(user))
		return FALSE
	return TRUE

/datum/usurpation_rite/proc/begin(mob/living/carbon/human/user)
	invoker = user
	throne = GLOB.king_throne
	started_at = world.time
	stage = RITE_STAGE_GATHERING
	RegisterSignal(invoker, list(COMSIG_QDELETING, COMSIG_MOB_DEATH), PROC_REF(on_invoker_death))
	on_gathering_started()

/datum/usurpation_rite/proc/on_gathering_started()
	var/weight_text = vote_weight_note ? " [vote_weight_note]" : ""
	to_chat(invoker, span_notice("The rite has begun. The [assenter_group] must now speak 'I assent' near the throne. You require [get_required_assents()] voices within [RITE_GATHERING_DURATION / (1 MINUTES)] minutes.[weight_text] Alternatively, the current ruler may say 'I abdicate' near the throne to yield."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/proc/on_gathering_timeout()
	fail("The [assenter_group] of the realm did not grant sufficient assent.")

/datum/usurpation_rite/proc/try_assent(mob/living/carbon/human/person)
	if(stage != RITE_STAGE_GATHERING)
		return FALSE
	if(!istype(person))
		return FALSE
	if(person.stat != CONSCIOUS)
		return FALSE
	if(person == invoker)
		to_chat(person, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(!can_assent(person))
		return FALSE
	var/assenter_key = REF(person)
	if(assenters[assenter_key])
		to_chat(person, span_warning("You have already spoken your assent."))
		return FALSE
	if(!throne || get_dist(person, throne) > RITE_ASSENT_RANGE)
		return FALSE
	var/weight = get_vote_weight(person)
	assenters[assenter_key] = weight
	on_assent_accepted(person, weight)
	if(get_assent_total() >= get_required_assents())
		start_contesting()
	return TRUE

/datum/usurpation_rite/proc/can_assent(mob/living/carbon/human/person)
	if((assent_bars & RITE_BAR_OUTLAW) && HAS_TRAIT(person, TRAIT_OUTLAW))
		to_chat(person, span_warning(outlaw_rejection))
		return FALSE
	if((assent_bars & RITE_BAR_UNDEAD) && is_undead(person))
		to_chat(person, span_warning(undead_rejection))
		return FALSE
	return TRUE

/datum/usurpation_rite/proc/on_assent_accepted(mob/living/carbon/human/person, weight)
	person.visible_message( \
		span_notice("[person.get_unmasked_name()] speaks their assent to the [name]."), \
		span_notice("You speak your assent."))
	var/weight_text = vote_weight_note ? " as [describe_vote_weight(weight)]" : ""
	to_chat(invoker, span_notice("[person.get_unmasked_name()] has assented[weight_text]. ([get_assent_total()]/[get_required_assents()])"))

/datum/usurpation_rite/proc/get_required_assents()
	return required_assents

/datum/usurpation_rite/proc/get_vote_weight(mob/living/carbon/human/person)
	return RITE_VOTE_FULL

/datum/usurpation_rite/proc/get_assent_total()
	var/total = 0
	for(var/assenter_key in assenters)
		total += assenters[assenter_key]
	return total

/datum/usurpation_rite/proc/describe_vote_weight(weight)
	if(weight >= RITE_VOTE_DOUBLE)
		return "two voices"
	if(weight >= RITE_VOTE_FULL)
		return "a full voice"
	return "half a voice"

/datum/usurpation_rite/proc/is_undead(mob/living/carbon/human/person)
	return HAS_TRAIT(person, TRAIT_ROTMAN) || (person.mob_biotypes & MOB_UNDEAD)

/// Uses tgui_alert as anti-vampire force-say protection. Accepts both the ruler and regent.
/datum/usurpation_rite/proc/try_abdication(mob/living/carbon/human/ruler)
	if(stage >= RITE_STAGE_CONTESTING)
		return FALSE
	if(ruler == invoker)
		to_chat(ruler, span_warning("You cannot abdicate in favor of your own claim."))
		return FALSE
	var/is_ruler = (SSticker.rulermob == ruler)
	var/is_regent = (SSticker.regentmob == ruler)
	if(!is_ruler && !is_regent)
		return FALSE
	if(!throne || get_dist(ruler, throne) > RITE_ASSENT_RANGE)
		return FALSE
	var/confirm = tgui_alert(ruler, "Are you certain you wish to abdicate? This will skip directly to contestation.", "Abdication", list("Abdicate", "Cancel"))
	if(confirm != "Abdicate")
		return FALSE
	if(QDELETED(ruler) || ruler.stat != CONSCIOUS)
		return FALSE
	if(SSticker.rulermob != ruler && SSticker.regentmob != ruler)
		return FALSE
	if(stage >= RITE_STAGE_CONTESTING)
		return FALSE
	start_contesting()
	return TRUE

/datum/usurpation_rite/proc/start_contesting()
	if(!invoker || invoker.stat != CONSCIOUS)
		fail("The claimant has fallen before the contest could begin.")
		return
	if(!throne)
		fail("The throne has been destroyed.")
		return
	stage = RITE_STAGE_CONTESTING
	deltimer(phase_timer_id)
	contest_time_remaining = RITE_CONTEST_DURATION
	contest_started_at = world.time
	on_contesting_started()

/datum/usurpation_rite/proc/on_contesting_started()
	priority_announce("[invoker.get_unmasked_name()] has invoked the [name]!\n\n" + get_contest_announcement(), name, sound_contesting)
	to_chat(invoker, span_notice("The [assenter_group] have spoken. The realm has been alerted. Stay near the throne for [RITE_CONTEST_DURATION / (1 MINUTES)] minutes and the throne is yours. You may move freely, but do not stray too far."))
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/proc/get_contest_announcement()
	return "The claim shall be settled in [RITE_CONTEST_DURATION / (1 MINUTES)] minutes -- unless it is struck down."

/datum/usurpation_rite/proc/complete()
	if(!invoker)
		fail("The claimant has vanished.")
		return
	if(invoker.stat == DEAD)
		fail("[invoker.get_unmasked_name()] lies dead. The succession cannot be completed.")
		return
	if(invoker.stat != CONSCIOUS)
		fail("[invoker.get_unmasked_name()] has fallen unconscious before the succession could be completed.")
		return
	if(!throne || get_dist(invoker, throne) > RITE_CONTEST_PROXIMITY)
		fail("The cowardly [invoker.get_unmasked_name()] has abandoned their claim to the throne.")
		return
	stage = RITE_STAGE_COMPLETE
	on_complete()
	cleanup()

/datum/usurpation_rite/proc/on_complete()
	var/mob/living/old_ruler = SSticker.rulermob
	var/old_ruler_name = old_ruler?.get_unmasked_name() || "Their predecessor"
	var/epilogue = get_roundend_epilogue()
	if(epilogue)
		SSticker.roundend_epilogue = epilogue
	transfer_power()
	priority_announce(get_victory_announcement(old_ruler_name), "A New [SSticker.rulertype] Ascends", sound_victory)
	to_chat(invoker, span_notice("The throne is yours."))

/datum/usurpation_rite/proc/get_roundend_epilogue()
	return roundend_epilogue

/datum/usurpation_rite/proc/get_victory_announcement(old_ruler_name)
	return "Long live [invoker.get_unmasked_name()], [SSticker.rulertype] of [SSticker.realm_name]!"

/// Follows the same pattern as coronate_lord() in priest.dm.
/datum/usurpation_rite/proc/transfer_power()
	var/old_rulertype = SSticker.rulertype || "Duke"

	// Spells that belong to the Grand Duke role — strip from old holders, grant to new one
	var/static/list/lord_spells = list(
		/obj/effect/proc_holder/spell/self/grant_title,
		/obj/effect/proc_holder/spell/self/grant_nobility,
		/obj/effect/proc_holder/spell/self/convertrole/servant,
		/obj/effect/proc_holder/spell/self/convertrole/guard,
		/obj/effect/proc_holder/spell/self/convertrole/bog,
	)

	var/emeritus_title = "[old_rulertype] Emeritus"
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.mind?.assigned_role == "Grand Duke")
			HL.mind.assigned_role = "Towner"
			for(var/spell_type in lord_spells)
				HL.mind.RemoveSpell(spell_type)
		if(HL.job == "Grand Duke")
			HL.job = "Towner"
			HL.advjob = emeritus_title
			GLOB.lord_titles[HL.real_name] = emeritus_title

	// Must update display titles before set_ruler_mob() reads them
	var/datum/job/roguetown/lord_job = SSjob.GetJob("Grand Duke")
	if(lord_job)
		lord_job.display_title = new_ruler_title
		lord_job.f_title = new_ruler_title_f
		lord_job.total_positions = -1000 // Lock out the slot so no new one spawns

	SSticker.realm_type = new_realm_type
	SSticker.realm_type_short = new_realm_type_short

	invoker.mind.assigned_role = "Grand Duke"
	invoker.job = "Grand Duke"
	// Grant the Grand Duke's governance spells to the new ruler
	for(var/spell_type in lord_spells)
		invoker.mind.AddSpell(new spell_type)
	SSticker.set_ruler_mob(invoker)
	SSticker.regentmob = null
	SSticker.usurpation_day = GLOB.dayspassed
	removeomen(OMEN_NOLORD)

	// Yank the crown from whoever has it and drop it at the new ruler's feet
	var/obj/item/clothing/head/roguetown/crown/serpcrown/crown = SSroguemachine.crown
	if(crown)
		var/mob/holder = get_containing_mob(crown)
		if(holder && holder != invoker)
			if(ishuman(holder))
				var/mob/living/carbon/human/HH = holder
				HH.dropItemToGround(crown, TRUE)
				to_chat(HH, span_warning("The crown is wrenched from you by an unseen force!"))
			to_chat(invoker, span_notice("The crown materializes at your feet."))
		crown.forceMove(get_turf(invoker))

	var/realm = SSticker.realm_name || "Azure Peak"
	// Imitate the text whenever a new Duke joins the game
	to_world("<b><span class='notice'><span class='big'>[invoker.get_unmasked_name()] is [SSticker.rulertype] of [realm].</span></span></b>")

/datum/usurpation_rite/proc/fail(reason)
	on_fail(reason)
	cleanup()

/datum/usurpation_rite/proc/on_fail(reason)
	if(stage >= RITE_STAGE_CONTESTING)
		priority_announce("The [name] has failed. [reason]", "Rite Failed", sound_failure)
	if(invoker)
		to_chat(invoker, span_warning("The [name] has failed. [reason]"))

/datum/usurpation_rite/proc/cleanup()
	release_contester()
	if(phase_timer_id)
		deltimer(phase_timer_id)
		phase_timer_id = null
	if(invoker)
		UnregisterSignal(invoker, list(COMSIG_QDELETING, COMSIG_MOB_DEATH))
	if(throne)
		throne.active_rite = null
		throne = null
	invoker = null
	assenters = null

/datum/usurpation_rite/proc/on_invoker_death(datum/source)
	SIGNAL_HANDLER
	fail("The claimant has fallen.")

/// Pauses the main contest timer while the counter-claim is active.
/datum/usurpation_rite/proc/start_counter_claim(mob/living/carbon/human/claimant)
	if(stage != RITE_STAGE_CONTESTING)
		return FALSE
	if(!istype(claimant))
		return FALSE
	if(claimant == invoker)
		return FALSE
	if(contester)
		to_chat(claimant, span_warning("Someone is already contesting from the throne."))
		return FALSE
	var/time_left = get_contest_time_left()
	if(time_left <= 0)
		return FALSE
	contest_time_remaining = time_left
	deltimer(phase_timer_id)
	phase_timer_id = null
	contester = claimant
	RegisterSignal(contester, list(COMSIG_QDELETING, COMSIG_MOB_DEATH), PROC_REF(on_contester_death))
	contester_timer_id = addtimer(CALLBACK(src, PROC_REF(on_counter_claim_complete)), RITE_COUNTER_CLAIM_DURATION, TIMER_STOPPABLE)
	on_counter_claim_started(claimant)
	return TRUE

/datum/usurpation_rite/proc/on_counter_claim_started(mob/living/carbon/human/claimant)
	claimant.visible_message( \
		span_warning("[claimant.get_unmasked_name()] has taken the throne and declared 'Stop Ascent!' The rite is being contested!"), \
		span_notice("You have taken the throne. Hold it for [RITE_COUNTER_CLAIM_DURATION / (1 MINUTES)] minute(s) to halt the succession. The rite's timer has been paused."))
	to_chat(invoker, span_danger("[claimant.get_unmasked_name()] has taken the throne and is attempting to stop the rite! Remove them!"))

/datum/usurpation_rite/proc/release_contester()
	if(contester_timer_id)
		deltimer(contester_timer_id)
		contester_timer_id = null
	if(contester)
		UnregisterSignal(contester, list(COMSIG_QDELETING, COMSIG_MOB_DEATH))
	contester = null

/datum/usurpation_rite/proc/cancel_counter_claim()
	if(!contester)
		return
	var/mob/living/carbon/human/old_contester = contester
	release_contester()
	on_counter_claim_cancelled(old_contester)
	if(stage == RITE_STAGE_CONTESTING && contest_time_remaining > 0)
		contest_started_at = world.time
		phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), contest_time_remaining, TIMER_STOPPABLE)

/datum/usurpation_rite/proc/on_counter_claim_cancelled(mob/living/carbon/human/claimant)
	if(QDELETED(claimant) || claimant.stat == DEAD)
		to_chat(invoker, span_notice("The contester has fallen. The rite continues."))
		return
	to_chat(claimant, span_warning("You have left the throne. Your attempt to stop the rite has failed."))
	to_chat(invoker, span_notice("The contester has left the throne."))

/datum/usurpation_rite/proc/on_contester_death(datum/source)
	SIGNAL_HANDLER
	cancel_counter_claim()

/datum/usurpation_rite/proc/on_counter_claim_complete()
	var/contester_name = contester?.get_unmasked_name() || "another"
	contester_timer_id = null
	release_contester()
	fail("The throne has been reclaimed by [contester_name].")

/datum/usurpation_rite/proc/get_contest_time_left()
	if(contester)
		return max(contest_time_remaining, 0)
	return max(contest_time_remaining - (world.time - contest_started_at), 0)

/datum/usurpation_rite/proc/get_status_text()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "The [name] is underway. [get_assent_total()]/[get_required_assents()] voices have spoken their assent."
		if(RITE_STAGE_CONTESTING)
			return "[invoker?.get_unmasked_name()]'s claim has been affirmed by [council_name]."
	return null

/datum/usurpation_rite/proc/get_periodic_announcement()
	switch(stage)
		if(RITE_STAGE_GATHERING)
			return "[invoker?.get_unmasked_name()] claims the throne [claim_basis]. [capitalize(assenter_group)], speak your assent -- or stop them. ([get_assent_total()]/[get_required_assents()] voices)"
		if(RITE_STAGE_CONTESTING)
			var/remaining = "moments"
			var/time_left = get_contest_time_left()
			if(time_left > 0)
				remaining = "[round(time_left / (1 SECONDS))] seconds"
			return "Affirmed by [council_name], [invoker?.get_unmasked_name()] will ascend in [remaining]. Defend or destroy this claim!"
	return null
