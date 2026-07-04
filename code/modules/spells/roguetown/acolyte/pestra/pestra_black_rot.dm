#define TIER_1_TRESHOLD 1
#define TIER_2_TRESHOLD 33
#define TIER_3_TRESHOLD 66
#define TIER_4_TRESHOLD 94

/datum/status_effect/black_rot
	id = "black_rot"
	alert_type = /atom/movable/screen/alert/status_effect/black_rot
	duration = -1 // Permanent until cured
	tick_interval = 2 SECONDS
	examine_text = "SUBJECTPRONOUN seems to be rotting alive! (Creeping)"

	var/static/list/valid_body_zones = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_LEG,
		BODY_ZONE_R_LEG,
	)

	// Rot nouveau
	var/highest_threshold_reached = 0
	var/max_stacks = 100
	var/stacks = 1
	var/tier = 1
	var/list/symptoms = list()
	var/tick_count = 0
	// Once every 10 seconds
	var/symptom_interval = 5

/datum/status_effect/black_rot/on_creation(mob/living/new_owner, initial_stacks = 1)
	stacks = clamp(initial_stacks, 1, max_stacks)

	for(var/V in subtypesof(/datum/rot_symptom))
		symptoms += new V()

	. = ..()

/datum/status_effect/black_rot/on_apply()
	if(owner.has_status_effect(/datum/status_effect/black_rot_debility))
		to_chat(owner, span_warning("My body is still recovering from previous rot and resists new infection!"))
		return FALSE
	to_chat(owner, span_userdanger("A deep, chilling rot begins to spread through my body!"))
	update_effects()
	check_thresholds()
	update_alert()
	return TRUE

/datum/status_effect/black_rot/proc/update_alert()
	if(!linked_alert)
		return
	switch(tier)
		if(1)
			linked_alert.name = "Black Rot (Creeping)"
			linked_alert.desc = "A faint darkness spreads beneath my skin. I should seek out a calyx or heartblood vials before it is too late."
			linked_alert.icon_state = "blackrot1"
			examine_text = "SUBJECTPRONOUN seems to be rotting alive! (Creeping)"
		if(2)
			linked_alert.name = "Black Rot (Festering)"
			linked_alert.desc = "My veins run black with corruption. I will surely die if this persists. I should seek out a calyx or heartblood vials before it is too late."
			linked_alert.icon_state = "blackrot2"
			examine_text = "SUBJECTPRONOUN seems to be rotting alive! (Festering)"
		if(3)
			linked_alert.name = "Black Rot (Boiling)"
			linked_alert.desc = "My flesh decays and my bones ache. It feels like my skin is boiling. I should seek out a calyx or heartblood vials before it is too late."
			linked_alert.icon_state = "blackrot3"
			examine_text = "SUBJECTPRONOUN seems to be rotting alive! (Boiling)"
		if(4)
			linked_alert.name = "Black Rot (Necrosis)"
			linked_alert.desc = "I am being consumed by the void. I can feel my bones creaking. I should seek out a calyx or heartblood vials now!!"
			linked_alert.icon_state = "blackrot4"
			examine_text = "SUBJECTPRONOUN seems to be rotting alive! (Necrosis)"

/datum/status_effect/black_rot/proc/reapply_effect(list/old_stats)
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

/datum/status_effect/black_rot/tick()
	if(!owner || owner.stat == DEAD)
		return
	tick_count++
	if(tick_count >= symptom_interval)
		tick_count = 0
		trigger_random_symptom()

/datum/status_effect/black_rot/proc/trigger_random_symptom()
	var/list/possible = list()
	for(var/datum/rot_symptom/S in symptoms)
		if(S.can_trigger(src))
			possible += S

	if(length(possible))
		var/datum/rot_symptom/chosen = pick(possible)
		chosen.activate(owner, src)

/datum/status_effect/black_rot/proc/add_stack(amount = 1)
	var/old_stacks = stacks
	stacks = clamp(stacks + amount, 1, max_stacks)
	if(stacks != old_stacks)
		update_effects()
		check_thresholds()
		update_alert()

/datum/status_effect/black_rot/proc/remove_stack(amount = 1)
	stacks -= amount
	if(stacks <= 0)
		owner.apply_status_effect(/datum/status_effect/black_rot_debility)
		owner.remove_status_effect(/datum/status_effect/black_rot)
		return
	update_effects()
	check_thresholds()
	update_alert()

/datum/status_effect/black_rot/proc/update_effects()
	var/list/old_stats = effectedstats.Copy()
	effectedstats = list()

	var/con_loss = round(stacks / 20)
	var/spd_loss = round(stacks / 25)
	var/str_loss = round(stacks / 33)

	if(con_loss)
		effectedstats[STATKEY_CON] = -con_loss
	if(spd_loss)
		effectedstats[STATKEY_SPD] = -spd_loss
	if(str_loss)
		effectedstats[STATKEY_STR] = -str_loss

	reapply_effect(old_stats)

/datum/status_effect/black_rot/proc/check_thresholds()
	var/new_tier = 0
	if(stacks >= TIER_4_TRESHOLD)
		new_tier = 4
	else if(stacks >= TIER_3_TRESHOLD)
		new_tier = 3
	else if(stacks >= TIER_2_TRESHOLD)
		new_tier = 2
	else if(stacks >= TIER_1_TRESHOLD)
		new_tier = 1

	// If their tier hasn't changed, do nothing.
	if(new_tier == tier)
		return

	// Handle TIER INCREASING
	if(new_tier > tier)
		owner.visible_message(span_boldnotice("[owner] seems to have the rot creep further over their body!"))
		switch(new_tier)
			if(1)
				to_chat(owner, span_warning("The veins in your arms are turning a bruised purple."))
			if(2)
				to_chat(owner, span_danger("You feel a sickening squelch inside your chest!"))
			if(3)
				to_chat(owner, span_userdanger("Your flesh begins to slough off in grey flakes!"))
			if(4)
				to_chat(owner, span_boldwarning("You are a vessel for the rot. Your soul feels distant."))

	// Handle TIER DECREASING
	else if(new_tier < tier)
		owner.visible_message(span_nicegreen("[owner] seems to have the rot recede from their body!"))
		switch(new_tier)
			if(0)
				to_chat(owner, span_notice("The purple staining in your veins begins to fade."))
			if(1)
				to_chat(owner, span_notice("The pressure in your chest eases slightly."))
			if(2)
				to_chat(owner, span_info("Your skin feels slightly more stable."))
			if(3)
				to_chat(owner, span_info("A small fragment of your spirit returns..."))
	tier = new_tier

/datum/status_effect/black_rot/on_remove()
	to_chat(owner, span_good("The black rot is completely purged from my body!"))
	return ..()

/atom/movable/screen/alert/status_effect/black_rot
	name = "Black Rot (Creeping)"
	desc = "A faint darkness spreads beneath my skin. I should seek out a calyx or heartblood vials before it is too late."
	icon_state = "blackrot1"

// Puke when advancing stages, woo
/datum/status_effect/black_rot/proc/trigger_vomit_fit()
	to_chat(owner, span_danger("A wave of nausea overwhelms me! IT'S ONLY GETTING WORSE."))
	for(var/i in 1 to 5)
		spawn(rand(1 SECONDS, 20 SECONDS))
			if(owner && !QDELETED(owner) && owner.stat != DEAD)
				vomit_black_rot()

/datum/status_effect/black_rot/proc/vomit_black_rot()
	if(!owner || QDELETED(owner) || owner.stat == DEAD)
		return

	var/turf/vomit_turf = find_vomit_turf()
	if(vomit_turf)
		new /obj/effect/decal/cleanable/black_rot_vomit(vomit_turf)
	playsound(owner, 'sound/misc/machinevomit.ogg', 50, TRUE)
	if(prob(10))
		owner.visible_message(span_warning("[owner] vomits a black, tarry substance!"), span_danger("I vomit a black, tarry substance!"))

/obj/effect/decal/cleanable/black_rot_vomit
	name = "black rot vomit"
	desc = "A foul, tarry black substance. It seems to writhe a little."
	icon = 'icons/effects/tomatodecal.dmi'
	icon_state = "smashed_plant"
	color = "#000000"

/obj/effect/decal/cleanable/black_rot_vomit/Initialize(mapload)
	. = ..()
	alpha = rand(180, 255)
	transform = transform.Scale(rand(8, 12) * 0.1, rand(8, 12) * 0.1)

/datum/status_effect/black_rot/proc/find_vomit_turf()
	var/turf/owner_turf = get_turf(owner)
	if(!owner_turf)
		return null

	// First try the turf in the direction the owner is facing
	var/turf/front_turf = get_step(owner_turf, owner.dir)
	if(front_turf && !front_turf.density)
		return front_turf

	// If front turf is blocked, try adjacent turfs
	var/list/possible_turfs = list()
	for(var/turf/adjacent_turf in RANGE_TURFS(1, owner_turf))
		if(adjacent_turf != owner_turf && !adjacent_turf.density)
			possible_turfs += adjacent_turf
	if(possible_turfs.len)
		return pick(possible_turfs)
	return owner_turf

#undef TIER_1_TRESHOLD
#undef TIER_2_TRESHOLD
#undef TIER_3_TRESHOLD
#undef TIER_4_TRESHOLD
