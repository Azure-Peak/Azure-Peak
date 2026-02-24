/**
 * # Usurpation Rite
 *
 * Base datum for rites of succession.
 *
 * Flow:
 * 1. Invoked at the titan/throat via "I ascend"
 * 2. GATHERING: Invoker is seated; supporters fulfill the rite condition
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
	return TRUE

/datum/usurpation_rite/proc/begin(mob/living/carbon/human/user)
	invoker = user
	throne = GLOB.king_throne
	started_at = world.time
	stage = RITE_STAGE_GATHERING
	RegisterSignal(invoker, list(COMSIG_QDELETING, COMSIG_MOB_DEATH), PROC_REF(on_invoker_death))
	on_begin()
	start_gathering()

/datum/usurpation_rite/proc/on_begin()
	return

/datum/usurpation_rite/proc/start_gathering()
	stage = RITE_STAGE_GATHERING
	on_gathering_started()

/datum/usurpation_rite/proc/on_gathering_started()
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(on_gathering_timeout)), RITE_GATHERING_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/proc/on_gathering_timeout()
	fail("The nobles of the realm did not grant sufficient assent.")

/datum/usurpation_rite/proc/try_assent(mob/living/carbon/human/noble)
	if(stage != RITE_STAGE_GATHERING)
		return FALSE
	if(!istype(noble))
		return FALSE
	if(noble.stat != CONSCIOUS)
		return FALSE
	if(noble == invoker)
		to_chat(noble, span_warning("You cannot assent to your own claim."))
		return FALSE
	if(!HAS_TRAIT(noble, TRAIT_NOBLE))
		to_chat(noble, span_warning("Only those of noble blood may speak assent."))
		return FALSE
	if(HAS_TRAIT(noble, TRAIT_OUTLAW))
		to_chat(noble, span_warning("Astrata shuns those who stand outside the order."))
		return FALSE
	if(HAS_TRAIT(noble, TRAIT_ROTMAN) || (noble.mob_biotypes & MOB_UNDEAD))
		to_chat(noble, span_warning("The sun has no place for the living dead."))
		return FALSE
	if(assenters[noble])
		to_chat(noble, span_warning("You have already spoken your assent."))
		return FALSE
	if(!throne || get_dist(noble, throne) > RITE_ASSENT_RANGE)
		return FALSE
	assenters[noble] = TRUE
	on_assent_accepted(noble)
	check_assent_threshold()
	return TRUE

/datum/usurpation_rite/proc/on_assent_accepted(mob/living/carbon/human/noble)
	return

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

/datum/usurpation_rite/proc/check_assent_threshold()
	return

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
	phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), RITE_CONTEST_DURATION, TIMER_STOPPABLE)

/datum/usurpation_rite/proc/complete()
	if(!invoker)
		fail("The claimant has vanished.")
		return
	if(invoker.stat == DEAD)
		fail("[invoker.real_name] lies dead. The succession cannot be completed.")
		return
	if(invoker.stat != CONSCIOUS)
		fail("[invoker.real_name] has fallen unconscious before the succession could be completed.")
		return
	if(!throne || get_dist(invoker, throne) > RITE_CONTEST_PROXIMITY)
		fail("The cowardly [invoker.real_name] has abandoned their claim to the throne.")
		return
	stage = RITE_STAGE_COMPLETE
	on_complete()
	cleanup()

/datum/usurpation_rite/proc/on_complete()
	if(roundend_epilogue)
		SSticker.roundend_epilogue = roundend_epilogue
	transfer_power()

/// Follows the same pattern as coronate_lord() in priest.dm.
/datum/usurpation_rite/proc/transfer_power()
	var/old_rulertype = SSticker.rulertype || "Duke"

	var/emeritus_title = "[old_rulertype] Emeritus"
	for(var/mob/living/carbon/human/HL in GLOB.human_list)
		if(HL.mind?.assigned_role == "Grand Duke")
			HL.mind.assigned_role = "Towner"
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
	to_chat(world, "<b><span class='notice'><span class='big'>[invoker.real_name] is [SSticker.rulertype] of [realm].</span></span></b>")

/datum/usurpation_rite/proc/fail(reason)
	on_fail(reason)
	cleanup()

/datum/usurpation_rite/proc/on_fail(reason)
	return

/datum/usurpation_rite/proc/cleanup()
	cancel_counter_claim()
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

/datum/usurpation_rite/proc/on_invoker_unseated()
	return

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
	contest_time_remaining -= (world.time - contest_started_at)
	if(contest_time_remaining <= 0)
		return FALSE
	deltimer(phase_timer_id)
	phase_timer_id = null
	contester = claimant
	contester_timer_id = addtimer(CALLBACK(src, PROC_REF(on_counter_claim_complete)), RITE_COUNTER_CLAIM_DURATION, TIMER_STOPPABLE)
	on_counter_claim_started(claimant)
	return TRUE

/datum/usurpation_rite/proc/on_counter_claim_started(mob/living/carbon/human/claimant)
	claimant.visible_message( \
		span_warning("[claimant.real_name] has taken the throne and declared 'Stop Ascent!' The rite is being contested!"), \
		span_notice("You have taken the throne. Hold it for [RITE_COUNTER_CLAIM_DURATION / (1 MINUTES)] minute(s) to halt the succession. The rite's timer has been paused."))
	to_chat(invoker, span_danger("[claimant.real_name] has taken the throne and is attempting to stop the rite! Remove them!"))

/datum/usurpation_rite/proc/cancel_counter_claim()
	if(!contester)
		return
	if(contester_timer_id)
		deltimer(contester_timer_id)
		contester_timer_id = null
	var/mob/living/carbon/human/old_contester = contester
	contester = null
	on_counter_claim_cancelled(old_contester)
	if(stage == RITE_STAGE_CONTESTING && contest_time_remaining > 0)
		contest_started_at = world.time
		phase_timer_id = addtimer(CALLBACK(src, PROC_REF(complete)), contest_time_remaining, TIMER_STOPPABLE)

/datum/usurpation_rite/proc/on_counter_claim_cancelled(mob/living/carbon/human/claimant)
	to_chat(claimant, span_warning("You have left the throne. Your attempt to stop the rite has failed."))
	to_chat(invoker, span_notice("The contester has left the throne."))

/datum/usurpation_rite/proc/on_counter_claim_complete()
	var/contester_name = contester?.real_name || "another"
	contester_timer_id = null
	contester = null
	fail("The throne has been reclaimed by [contester_name].")

/datum/usurpation_rite/proc/get_status_text()
	return null

/datum/usurpation_rite/proc/get_periodic_announcement()
	return null
