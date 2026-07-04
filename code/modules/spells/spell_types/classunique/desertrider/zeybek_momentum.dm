// -- momentum stuff below

/obj/effect/proc_holder/spell/self/zeybek_momentum
	name = "Momentum"
	desc = "Enter a flow-state of deadly swordsmanship. For 45 seconds, each landed strike builds momentum, increasing level every 5 strikes. Getting to a higher level increases duration, and restores energy. Bonuses reset by bait or riposte, and completely lost on exhaustion or stun. The first level of momentum gives +1 SPD, +1 WIL. The second doubles these effects. The third and final state gives Fortitude."
	overlay_state = "haste"
	recharge_time = 2 MINUTES
	ignore_cockblock = TRUE
	invocations = list("FLOW.") //K N E E L. You have
	invocation_type = "shout"
	sound = 'sound/magic/haste.ogg'
	var/momentum_style = "zeybek"

/obj/effect/proc_holder/spell/self/zeybek_momentum/zeybek
	momentum_style = "zeybek"

/obj/effect/proc_holder/spell/self/zeybek_momentum/janissary
	desc = "Steady your stance and grow unbreakable with each landed strike. For 45 seconds, each landed strike builds momentum, increasing level every 5 strikes. Getting to a higher level increases duration, and restores energy. Bonuses reset by bait or riposte, and completely lost on exhaustion or stun. The first level of momentum gives +1 STR, +1 WIL. The second also grants +2 INT, +1 FOR. The third grants Fortitude."
	invocations = list("BRACE.")
	momentum_style = "janissary"

/obj/effect/proc_holder/spell/self/zeybek_momentum/almah //unused; almah is prooobably fine
	desc = "Thread steel and sorcery together. For 45 seconds, each landed strike builds momentum, increasing level every 5 strikes. Getting to a higher level increases duration, and restores energy. Bonuses reset by bait or riposte, and completely lost on exhaustion or stun. The first level of momentum gives +1 CON, +1 WIL. The second also grants +2 STR, +1 CON. The third grants Fortitude."
	invocations = list("TAPESTRY.")
	momentum_style = "almah"

/obj/effect/proc_holder/spell/self/zeybek_momentum/cast(mob/living/user)
	if(user.has_status_effect(/datum/status_effect/buff/zeybek_momentum))
		user.remove_status_effect(/datum/status_effect/buff/zeybek_momentum)
	user.apply_status_effect(/datum/status_effect/buff/zeybek_momentum, momentum_style)
	return TRUE

/mob/living/carbon/human/proc/reset_desert_rider_momentum_tier()
	var/datum/status_effect/buff/zeybek_momentum/momentum_status = has_status_effect(/datum/status_effect/buff/zeybek_momentum)
	if(momentum_status)
		momentum_status.reset_to_tier_start()

#define MOMENTUM_FILTER "zeybek_momentum_outline"
/atom/movable/screen/alert/status_effect/buff/zeybek_momentum
	name = "Momentum"
	desc = "My strikes are building into a deadly rhythm."
	icon_state = "buff"

/datum/status_effect/buff/zeybek_momentum
	id = "zeybek_momentum"
	alert_type = /atom/movable/screen/alert/status_effect/buff/zeybek_momentum
	duration = 30 SECONDS
	var/stacks = 0
	var/wil_bonus = 0
	var/spd_bonus = 0
	var/per_bonus = 0
	var/int_bonus = 0
	var/con_bonus = 0
	var/str_bonus = 0
	var/for_bonus = 0
	var/fortitude_active = FALSE
	var/afterimage_active = FALSE
	var/milestone_five_rewarded = FALSE
	var/milestone_ten_rewarded = FALSE
	var/milestone_fifteen_rewarded = FALSE
	var/outline_colour = "#F4D35E"
	var/momentum_style = "zeybek"

/datum/status_effect/buff/zeybek_momentum/on_creation(mob/living/new_owner, style = "zeybek")
	momentum_style = style
	return ..()

/datum/status_effect/buff/zeybek_momentum/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, PROC_REF(smack_attack))
	RegisterSignal(owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(cancel_on_incapacitation))
	RegisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(cancel_on_incapacitation))
	owner.add_filter(MOMENTUM_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 55, "size" = 1))
	to_chat(owner, span_notice("STACKING."))

/datum/status_effect/buff/zeybek_momentum/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
	UnregisterSignal(owner, list(COMSIG_LIVING_STATUS_STUN, COMSIG_LIVING_STATUS_KNOCKDOWN))
	owner.change_stat(STATKEY_WIL, -wil_bonus)
	owner.change_stat(STATKEY_SPD, -spd_bonus)
	owner.change_stat(STATKEY_PER, -per_bonus)
	owner.change_stat(STATKEY_INT, -int_bonus)
	owner.change_stat(STATKEY_CON, -con_bonus)
	owner.change_stat(STATKEY_STR, -str_bonus)
	owner.change_stat(STATKEY_LCK, -for_bonus)
	wil_bonus = 0
	spd_bonus = 0
	per_bonus = 0
	int_bonus = 0
	con_bonus = 0
	str_bonus = 0
	for_bonus = 0
	stacks = 0
	if(fortitude_active)
		REMOVE_TRAIT(owner, TRAIT_FORTITUDE, STATUS_EFFECT_TRAIT)
		fortitude_active = FALSE
	owner.remove_filter(MOMENTUM_FILTER)
	if(afterimage_active)
		var/datum/component/after_image/after_image_component = owner.GetComponent(/datum/component/after_image)
		if(after_image_component)
			qdel(after_image_component)
	afterimage_active = FALSE
	milestone_five_rewarded = FALSE
	milestone_ten_rewarded = FALSE
	milestone_fifteen_rewarded = FALSE
	to_chat(owner, span_warning("Expended."))

/datum/status_effect/buff/zeybek_momentum/proc/smack_attack(mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(QDELETED(target) || !istype(target))
		return
	INVOKE_ASYNC(src, PROC_REF(process_smack_attack), target, user, weapon)

/datum/status_effect/buff/zeybek_momentum/proc/process_smack_attack(mob/living/target, mob/living/user, obj/item/weapon)
	if(QDELETED(src) || QDELETED(target) || !istype(target) || !owner)
		return
	stacks++
	if(stacks == 5)
		grant_milestone_boost(5)
		owner.balloon_alert_to_viewers("One...", "One...")
		apply_stack_bonus(1)
	else if(stacks == 10)
		grant_milestone_boost(10)
		owner.balloon_alert_to_viewers("Two...", "Two...")
		apply_stack_bonus(2)
	else if(stacks == 15 && !fortitude_active)
		grant_milestone_boost(15)
		owner.balloon_alert_to_viewers("STACKED.", "STACKED.")
		ADD_TRAIT(owner, TRAIT_FORTITUDE, STATUS_EFFECT_TRAIT)
		owner.AddComponent(/datum/component/after_image)
		afterimage_active = TRUE
		fortitude_active = TRUE
		to_chat(owner, get_final_momentum_message())
		playsound(owner, 'sound/magic/momentum_max.ogg', 100, TRUE, -1)

/datum/status_effect/buff/zeybek_momentum/proc/cancel_on_incapacitation(mob/living/source, amount, updating, ignore)
	SIGNAL_HANDLER
	if(!amount || ignore)
		return
	if(!owner)
		return
	if(owner.stamina >= owner.max_stamina && !owner.IsKnockdown() && !owner.IsStun())
		return
	to_chat(owner, span_warning("NO...!"))
	qdel(src)

/datum/status_effect/buff/zeybek_momentum/proc/grant_milestone_boost(milestone)
	if(!owner)
		return

	var/fatigue_restore = owner.max_energy * 0.1
	owner.energy_add(fatigue_restore)

	var/duration_extension = 0
	switch(milestone)
		if(5)
			if(milestone_five_rewarded)
				return
			milestone_five_rewarded = TRUE
			duration_extension = 15 SECONDS
		if(10)
			if(milestone_ten_rewarded)
				return
			milestone_ten_rewarded = TRUE
			duration_extension = 15 SECONDS
		if(15)
			if(milestone_fifteen_rewarded)
				return
			milestone_fifteen_rewarded = TRUE
			duration_extension = 30 SECONDS

	if(duration_extension)
		duration += duration_extension

/datum/status_effect/buff/zeybek_momentum/proc/reset_to_tier_start()
	var/new_stacks = FLOOR(stacks / 5, 1) * 5
	if(stacks >= 15)
		new_stacks = 10

	if(new_stacks == stacks)
		return

	stacks = new_stacks

	if(fortitude_active && stacks < 15)
		REMOVE_TRAIT(owner, TRAIT_FORTITUDE, STATUS_EFFECT_TRAIT)
		fortitude_active = FALSE
	if(afterimage_active && stacks < 15)
		var/datum/component/after_image/after_image_component = owner.GetComponent(/datum/component/after_image)
		if(after_image_component)
			qdel(after_image_component)
		afterimage_active = FALSE

/datum/status_effect/buff/zeybek_momentum/proc/apply_stack_bonus(stack_level)
	switch(momentum_style)
		if("janissary")
			if(stack_level == 1)
				owner.change_stat(STATKEY_STR, 1)
				owner.change_stat(STATKEY_WIL, 1)
				str_bonus += 1
				wil_bonus += 1
				to_chat(owner, span_notice("BRACE."))
			else
				owner.change_stat(STATKEY_INT, 2)
				owner.change_stat(STATKEY_LCK, 1)
				int_bonus += 2
				for_bonus += 1
				to_chat(owner, span_danger("CLOSE RANK."))
		if("almah")
			if(stack_level == 1)
				owner.change_stat(STATKEY_INT, 1)
				owner.change_stat(STATKEY_SPD, 1)
				int_bonus += 1
				spd_bonus += 1
				to_chat(owner, span_notice("THREAD."))
			else
				owner.change_stat(STATKEY_WIL, 1)
				owner.change_stat(STATKEY_INT, 1)
				owner.change_stat(STATKEY_SPD, 1)
				spd_bonus += 1
				wil_bonus += 1
				int_bonus += 1
				to_chat(owner, span_danger("COMPOSE."))
		else
			if(stack_level == 1)
				owner.change_stat(STATKEY_WIL, 1)
				owner.change_stat(STATKEY_SPD, 1)
				wil_bonus += 1
				spd_bonus += 1
				to_chat(owner, span_notice("ONE."))
			else
				owner.change_stat(STATKEY_WIL, 1)
				owner.change_stat(STATKEY_SPD, 1)
				owner.change_stat(STATKEY_PER, 1)
				wil_bonus += 1
				spd_bonus += 1
				per_bonus += 1
				to_chat(owner, span_danger("TWO."))

/datum/status_effect/buff/zeybek_momentum/proc/get_final_momentum_message()
	switch(momentum_style)
		if("janissary")
			return span_userdanger("BREAK THEIR FUCKING SKULLS.")
		if("almah")
			return span_userdanger("OBLITERATE THEIR WORLD, WEAVE SYMPHONY.")
		else
			return span_userdanger("I'VE GOT YOU NOW, FREEKSHIT.")

#undef MOMENTUM_FILTER
