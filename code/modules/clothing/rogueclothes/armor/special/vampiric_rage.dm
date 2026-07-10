#define FURY_TIER_1_THRESHOLD 1
#define FURY_TIER_2_THRESHOLD 20
#define FURY_TIER_3_THRESHOLD 40
#define FURY_TIER_4_THRESHOLD 100
#define FURY_FILTER "fury_filter"
#define FURY_GRACE_TIMER 20 SECONDS
#define MOVESPEED_ID_FURY_SLOW "movespeed_fury_slow"

/datum/status_effect/vampiric_fury
	id = "vampiric_fury"
	alert_type = /atom/movable/screen/alert/status_effect/vampiric_fury
	duration = -1 // Managed by stack decay
	tick_interval = 1 SECONDS

	var/stacks = 0
	var/max_stacks = 100
	var/tier = 1
	/// Time world when we can next decay a stack
	var/decay_grace_timestamp = 0
	var/outline_colour = "#860202"
	var/movespeed_modifier_applied = FALSE

/datum/status_effect/vampiric_fury/on_creation(mob/living/new_owner, initial_stacks = 15, custom_max_stacks = 100)
	max_stacks = custom_max_stacks
	stacks = clamp(initial_stacks, 1, max_stacks)
	decay_grace_timestamp = world.time + FURY_GRACE_TIMER
	. = ..()

/datum/status_effect/vampiric_fury/on_apply()
	to_chat(owner, span_userdanger("Gnoll adrenaline surges through your blood!"))
	update_effects()
	check_thresholds()
	update_alert()
	return TRUE

/datum/status_effect/vampiric_fury/tick()
	if(!owner || owner.stat == DEAD)
		return

	if(world.time < decay_grace_timestamp)
		return

	remove_stack(1)

/datum/status_effect/vampiric_fury/proc/add_stack(amount = 15)
	var/old_stacks = stacks
	stacks = clamp(stacks + amount, 1, max_stacks)
	decay_grace_timestamp = world.time + FURY_GRACE_TIMER

	if(stacks != old_stacks)
		update_effects()
		check_thresholds()
		update_alert()

/datum/status_effect/vampiric_fury/proc/remove_stack(amount = 1)
	stacks -= amount
	if(stacks <= 0)
		qdel(src)
		return

	update_effects()
	check_thresholds()
	update_alert()

/datum/status_effect/vampiric_fury/proc/update_alert()
	if(!linked_alert)
		return

	switch(tier)
		if(1)
			linked_alert.name = "Blood Fury (Stirring) \[[stacks] Stacks\]"
			linked_alert.desc = "My claws desire flesh, away with their armor!"
			linked_alert.icon_state = "fury1"
		if(2)
			linked_alert.name = "Blood Fury (Swelling) \[[stacks] Stacks\]"
			linked_alert.desc = "My energy is boundless, theirs is not."
			linked_alert.icon_state = "fury2"
		if(3)
			linked_alert.name = "Blood Fury (Angry) \[[stacks] Stacks\]"
			linked_alert.desc = "My legs swell with muscle, the weight distracting. It matters little."
			linked_alert.icon_state = "fury3"
		if(4)
			linked_alert.name = "Blood Fury (Raging) \[[stacks] Stacks\]"
			linked_alert.desc = "SO... ANGRY..."
			linked_alert.icon_state = "fury4"

/datum/status_effect/vampiric_fury/proc/update_effects()
	var/list/old_stats = effectedstats.Copy()
	effectedstats = list()

	// Stat boosts are capped, some classes can overcap just to have it decay more slowly
	var/effective_stacks = min(stacks, 100)

	var/spd_loss = round(effective_stacks / 50)
	var/str_gain = round(effective_stacks / 25)
	var/con_gain = round(effective_stacks / 25)
	var/int_loss = round(effective_stacks / 50)

	if(spd_loss)
		effectedstats[STATKEY_SPD] = -spd_loss
	if(str_gain)
		effectedstats[STATKEY_STR] = str_gain
	if(con_gain)
		effectedstats[STATKEY_CON] = con_gain
	if(int_loss)
		effectedstats[STATKEY_INT] = -int_loss

	reapply_effect(old_stats)
	update_movespeed()

/datum/status_effect/vampiric_fury/proc/update_movespeed()
	if(!ishuman(owner))
		return

	var/mob/living/carbon/human/H = owner
	var/effective_stacks = min(stacks, 100)
	var/slow_stacks = round(effective_stacks / 33) // 0, 1, 2, or 3
	var/slow_amount = SPEED_MOVSPD_MOD * slow_stacks

	if(slow_amount > 0)
		H.add_movespeed_modifier(MOVESPEED_ID_FURY_SLOW, update=TRUE, priority=10, multiplicative_slowdown=slow_amount)
		movespeed_modifier_applied = TRUE
	else if(movespeed_modifier_applied)
		H.remove_movespeed_modifier(MOVESPEED_ID_FURY_SLOW)
		movespeed_modifier_applied = FALSE

/datum/status_effect/vampiric_fury/proc/check_thresholds()
	var/new_tier = 0
	if(stacks >= FURY_TIER_4_THRESHOLD)
		new_tier = 4
	else if(stacks >= FURY_TIER_3_THRESHOLD)
		new_tier = 3
	else if(stacks >= FURY_TIER_2_THRESHOLD)
		new_tier = 2
	else if(stacks >= FURY_TIER_1_THRESHOLD)
		new_tier = 1

	if(new_tier == tier)
		return

	// Handle TIER ASCENDING
	if(new_tier > tier)
		owner.visible_message(span_boldwarning("[owner]'s eyes flare with an intense, predatory hunger!"))
		switch(new_tier)
			if(2)
				to_chat(owner, span_userdanger("The metallic taste of stolen armor thickens. A heavy resilience hardens your frame!"))
				if(ishuman(owner))
					REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, SPECIES_TRAIT)
			if(3)
				to_chat(owner, span_boldwarning("Your muscles swell! The excess bulk hampers your long strides!"))
				if(ishuman(owner))
					ADD_TRAIT(owner, TRAIT_BREADY, SPECIES_TRAIT)
			if(4)
				to_chat(owner, span_danger("YOU ARE ANGRY... SO... DAMN... ANGRY!!!"))
				if(ishuman(owner))
					ADD_TRAIT(owner, TRAIT_NOPAINSTUN, SPECIES_TRAIT)
				var/filter = owner.get_filter(FURY_FILTER)
				if(!filter)
					owner.add_filter(FURY_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 100, "size" = 1))

	// Handle TIER DESCENDING
	else if(new_tier < tier)
		owner.visible_message(span_notice("[owner]'s manic frenzy seems to subside slightly."))
		switch(new_tier)
			if(1)
				to_chat(owner, span_notice("The oppressive mass leaves your skin. Your posture returns to normal."))
				if(ishuman(owner))
					ADD_TRAIT(owner, TRAIT_LONGSTRIDER, SPECIES_TRAIT)
			if(2)
				to_chat(owner, span_notice("The swelling muscles in your legs settle down, freeing your long nimble strides."))
				if(ishuman(owner))
					REMOVE_TRAIT(owner, TRAIT_BREADY, SPECIES_TRAIT)
			if(3)
				to_chat(owner, span_info("The pure blinding rush of the apex hunt passes, giving way back to conscious thought."))
				owner.remove_filter(FURY_FILTER)
				if(ishuman(owner))
					REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, SPECIES_TRAIT)

	tier = new_tier

/datum/status_effect/vampiric_fury/proc/reapply_effect(list/old_stats)
	for(var/S in old_stats)
		owner.change_stat(S, -(old_stats[S]))

	for(var/S in effectedstats)
		if(effectedstats[S] < 0)
			if((owner.get_stat(S) + effectedstats[S]) < 1)
				for(var/i in 1 to abs(effectedstats[S]))
					if((owner.get_stat(S) + (effectedstats[S] + i)) == 1)
						effectedstats[S] = (effectedstats[S] + i)
						break
		else
			if((owner.get_stat(S) + effectedstats[S]) > 20)
				effectedstats[S] = max(((owner.get_stat(S) + effectedstats[S]) - 20), 0)
		owner.change_stat(S, effectedstats[S])

/datum/status_effect/vampiric_fury/on_remove()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		REMOVE_TRAIT(H, TRAIT_BREADY, SPECIES_TRAIT)
		REMOVE_TRAIT(H, TRAIT_NOPAINSTUN, SPECIES_TRAIT)
		if(!HAS_TRAIT(H, TRAIT_LONGSTRIDER))
			ADD_TRAIT(H, TRAIT_LONGSTRIDER, SPECIES_TRAIT)

	owner.remove_movespeed_modifier(MOVESPEED_ID_FURY_SLOW)

	to_chat(owner, span_notice("The bloodlust leaves your body completely, your senses return."))
	return ..()

/atom/movable/screen/alert/status_effect/vampiric_fury
	name = "Blood Fury"
	desc = "Primal bloodlust powers your muscles."
	icon_state = "fury1"
	icon = 'icons/mob/screenalerts/gnoll_alerts.dmi'

#undef FURY_TIER_1_THRESHOLD
#undef FURY_TIER_2_THRESHOLD
#undef FURY_TIER_3_THRESHOLD
#undef FURY_TIER_4_THRESHOLD
#undef FURY_FILTER
#undef FURY_GRACE_TIMER
#undef MOVESPEED_ID_FURY_SLOW
