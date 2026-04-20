/datum/status_effect/divine_exhaustion
	id = "divine_exhaustion"
	duration = 20 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/divine_exhaustion
	var/cooldown_end

/datum/status_effect/divine_exhaustion/on_creation(mob/living/new_owner, duration)
	src.duration = duration
	cooldown_end = world.time + duration
	return ..()

/datum/status_effect/divine_exhaustion/on_remove()
	to_chat(owner, span_notice("I feel my connection to Pestra's divine power slowly returning."))
	return ..()

/atom/movable/screen/alert/status_effect/divine_exhaustion
	name = "Divine Exhaustion"
	desc = "I have channeled too much of Pestra's power, and cannot harbor much of her divine infestation."
	icon_state = "divine_exhaustion"

// The healing of this is equivalent 3x pestra's heal, or 2x fortified pestra's heal. It wanes but lasts a long time.
/datum/status_effect/buff/divine_rebirth_healing
	id = "divine_rebirth_healing"
	alert_type = /atom/movable/screen/alert/status_effect/buff/divine_rebirth_healing
	duration = 30 SECONDS // Gradual healing
	tick_interval = 3 SECONDS
	var/time_left
	var/healing_strength = 45 // Starts strong
	var/limbs_regenerated = 0
	var/max_limbs_to_regenerate = 3
	var/outline_colour = "#FFD700"
	var/static/list/regenerable_zones = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_TAUR)

#define MIRACLE_HEALING_FILTER "pestra_heal_glow"

/datum/status_effect/buff/divine_rebirth_healing/on_apply()
	. = ..()
	time_left = duration
	SEND_SIGNAL(owner, COMSIG_LIVING_MIRACLE_HEAL_APPLY, healing_strength, src)
	var/filter = owner.get_filter(MIRACLE_HEALING_FILTER)
	if (!filter)
		owner.add_filter(MIRACLE_HEALING_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 100, "size" = 2))
	return TRUE

/datum/status_effect/buff/divine_rebirth_healing/on_remove()
	owner.remove_filter(MIRACLE_HEALING_FILTER)
	return ..()

/datum/status_effect/buff/divine_rebirth_healing/tick()
	var/time_progress = (duration - time_left) / duration
	time_left -= tick_interval
	// This shouldn't ever dip below 5, but let's use MAX for safety anyways
	healing_strength = max(5, healing_strength - (time_progress * (healing_strength - 5)))
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = outline_colour
	do_sprite_shake(owner, 3, 3, 15, 1)

	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume + healing_strength, BLOOD_VOLUME_NORMAL)

		var/list/wounds = owner.get_wounds()
		if(length(wounds) > 0)
			owner.heal_wounds(healing_strength)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_strength, 0)
		owner.adjustFireLoss(-healing_strength, 0)
		owner.adjustOxyLoss(-healing_strength, 0)
		owner.adjustToxLoss(-healing_strength, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_strength)
		owner.adjustCloneLoss(-healing_strength, 0)

	if(ishuman(owner) && limbs_regenerated < max_limbs_to_regenerate)
		var/mob/living/carbon/human/human_owner = owner
		var/missing_limbs = human_owner.get_missing_limbs()
		var/list/regenerable_missing_limbs = list()
		for(var/limb_zone in missing_limbs)
			if(limb_zone in regenerable_zones)
				regenerable_missing_limbs += limb_zone
		if(length(regenerable_missing_limbs) > 0 && prob(25 + (time_progress * 30)))
			var/limb_to_regrow = pick(regenerable_missing_limbs)
			if(human_owner.regenerate_limb(limb_to_regrow))
				limbs_regenerated++
				human_owner.visible_message(span_info("[human_owner]'s [limb_to_regrow] begins to regrow!"), span_info("I feel a miraculous sensation as my [limb_to_regrow] begins to regrow!"))

/datum/status_effect/buff/divine_rebirth_healing/proc/do_sprite_shake(mob/living/target, cycles = 3, intensity = 3, rotation_max = 15, speed = 1)
	if(!target)
		return

	spawn(0)
		for(var/i in 1 to cycles)
			// Randomly offsets
			var/rand_x = rand(-intensity, intensity)
			var/rand_y = rand(-intensity, intensity)

			// Rotation & movement
			animate(target, \
				pixel_y = rand_y, \
				pixel_x = rand_x, \
				time = speed, \
				easing = LINEAR_EASING)
			sleep(speed)

		animate(target, \
			pixel_y = 0, \
			pixel_x = 0, \
			time = speed, \
			easing = LINEAR_EASING)

#undef MIRACLE_HEALING_FILTER

/atom/movable/screen/alert/status_effect/buff/divine_rebirth_healing
	name = "Divine Rebirth"
	desc = "Miraculous divine energy is healing my wounds and regenerating my limbs."
	icon_state = "divine_heal"

/datum/status_effect/buff/pestra_care
	id = "pestra_care"
	alert_type = /atom/movable/screen/alert/status_effect/buff/pestra_care
	duration = 10 MINUTES
	tick_interval = 20 SECONDS
	var/healing_strength = 7.5
	var/effect_colour = "#005532"

/datum/status_effect/buff/pestra_care/on_apply()
	. = ..()
	SEND_SIGNAL(owner, COMSIG_LIVING_MIRACLE_HEAL_APPLY, healing_strength, src)

/datum/status_effect/buff/pestra_care/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = effect_colour

	if(!owner.construct)
		if(owner.blood_volume < BLOOD_VOLUME_NORMAL)
			owner.blood_volume = min(owner.blood_volume + healing_strength, BLOOD_VOLUME_NORMAL)

		var/list/wounds = owner.get_wounds()
		if(length(wounds) > 0)
			owner.heal_wounds(healing_strength)
			owner.update_damage_overlays()
		owner.adjustBruteLoss(-healing_strength, 0)
		owner.adjustFireLoss(-healing_strength, 0)
		owner.adjustOxyLoss(-healing_strength, 0)
		owner.adjustToxLoss(-healing_strength, 0)
		owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_strength)
		owner.adjustCloneLoss(-healing_strength, 0)

/atom/movable/screen/alert/status_effect/buff/pestra_care
	name = "Pestra's embrace"
	desc = "It's like something is wriggling around inside of me, but it's making me feel better..."
	icon_state = "divine_heal"

#define PLAGUE_GLOW_FILTER "plague_glow_filter"

/datum/status_effect/debuff/pestilent_plague
	id = "pestilent_plague"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/pestilent_plague
	duration = 60 SECONDS
	tick_interval = 3 SECONDS
	effectedstats = list(STATKEY_CON = -1,
						 STATKEY_STR = -3)
	var/outline_colour = "#095000"

/datum/status_effect/debuff/pestilent_plague/on_apply()
	. = ..()
	owner.adjustBruteLoss(30)
	to_chat(owner, span_danger("My body is wracked by malaise!"))
	var/filter = owner.get_filter(PLAGUE_GLOW_FILTER)
	if (!filter)
		owner.add_filter(PLAGUE_GLOW_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 90, "size" = 2))

/datum/status_effect/debuff/pestilent_plague/on_remove()
	owner.remove_filter(PLAGUE_GLOW_FILTER)
	. = ..()

/datum/status_effect/debuff/pestilent_plague/tick()
	var/mob/living/target = owner
	target.adjustBruteLoss(2)

	if(prob(10))
		var/message = pick(
			"My flesh feels like it's crawling off my bones!",
			"Worms writhe beneath my skin!",
			"Every breath brings more pestilence into my lungs!",
			"My blood feels thick with disease!",
			"Bugs feast on my living flesh!",
			"I'm just food for the bugs!",
			"The plague consumes me from within!")
		to_chat(target, span_danger(message))

/atom/movable/screen/alert/status_effect/debuff/pestilent_plague
	name = "Pestilent Plague"
	desc = "A violent plague ravages my body, causing immense pain and decay."
	icon_state = "debuff_severe"

#undef PLAGUE_GLOW_FILTER

/datum/status_effect/black_rot
	id = "black_rot"
	alert_type = /atom/movable/screen/alert/status_effect/black_rot
	duration = -1 // Permanent until cured
	tick_interval = 1 SECONDS
	var/stacks = 1
	var/tier = 1
	var/progression_timer = 0
	var/base_progression_time = 30 MINUTES // Base time to next tier at 1 stack
	var/next_damage_tick = 0
	var/static/list/valid_body_zones = list(
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_ARM,
	)

/datum/status_effect/black_rot/on_creation(mob/living/new_owner, initial_stacks = 4)
	stacks = clamp(initial_stacks, 1, 4)
	progression_timer = world.time + (base_progression_time / stacks)
	. = ..()
	update_alert()

/datum/status_effect/black_rot/on_apply()
	if(owner.has_status_effect(/datum/status_effect/black_rot_debility))
		to_chat(owner, span_warning("My body is still recovering from previous rot and resists new infection!"))
		return FALSE
	to_chat(owner, span_userdanger("A deep, chilling rot begins to spread through my body!"))
	update_effects()
	return TRUE

/datum/status_effect/black_rot/proc/update_alert()
	if(!linked_alert)
		return
	switch(tier)
		if(1)
			linked_alert.name = "Black Rot (Creeping)"
			linked_alert.desc = "A faint darkness spreads beneath my skin."
			linked_alert.icon_state = "blackrot1"
		if(2)
			linked_alert.name = "Black Rot (Festering)"
			linked_alert.desc = "My veins run black with corruption. I will surely die if this persists."
			linked_alert.icon_state = "blackrot2"
		if(3)
			linked_alert.name = "Black Rot (Boiling)"
			linked_alert.desc = "My flesh decays and my bones ache. It feels like my skin is boiling."
			linked_alert.icon_state = "blackrot3"
		if(4)
			linked_alert.name = "Black Rot (Necrosis)"
			linked_alert.desc = "I am being consumed by the void. I can feel my bones creaking."
			linked_alert.icon_state = "blackrot4"

/datum/status_effect/black_rot/proc/update_effects()
	var/list/old_stats = effectedstats.Copy()
	effectedstats = list()
	// Apply effects based on tier and stack multiplier
	var/stack_multiplier = stacks * 0.25 // 25% per stack

	switch(tier)
		if(1)
			// Mild effects
			effectedstats = list(
				STATKEY_CON = round(-1 * stack_multiplier),
				STATKEY_SPD = round(-1 * stack_multiplier)
			)
		if(2)
			// Moderate effects
			effectedstats = list(
				STATKEY_CON = round(-2 * stack_multiplier),
				STATKEY_SPD = round(-1 * stack_multiplier),
				STATKEY_STR = round(-1 * stack_multiplier)
			)
		if(3)
			// Severe effects
			effectedstats = list(
				STATKEY_CON = round(-4 * stack_multiplier),
				STATKEY_SPD = round(-2 * stack_multiplier),
				STATKEY_STR = round(-2 * stack_multiplier),
				STATKEY_WIL = round(-1 * stack_multiplier)
			)
		if(4)
			// Critical effects
			effectedstats = list(
				STATKEY_CON = round(-6 * stack_multiplier),
				STATKEY_SPD = round(-3 * stack_multiplier),
				STATKEY_STR = round(-3 * stack_multiplier),
				STATKEY_WIL = round(-2 * stack_multiplier),
				STATKEY_PER = round(-1 * stack_multiplier)
			)
	reapply_effect(old_stats)

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
	if(world.time >= progression_timer && tier < 4)
		// Tier 3 and 4 require at least 2 stacks
		if(tier >= 2 && stacks < 2)
			progression_timer = world.time + (base_progression_time / stacks) // Reset timer but don't progress
		else
			tier++
			progression_timer = world.time + (base_progression_time / stacks)
			// Generally an indicator that you're advancing a tier
			trigger_vomit_fit()
			update_alert()
			update_effects()

	// Apply damage and effects based on tier
	if(world.time >= next_damage_tick)
		next_damage_tick = world.time + max(8 SECONDS, (8 SECONDS / (stacks / 2)))
		apply_damage_effects()

/datum/status_effect/black_rot/proc/apply_damage_effects()
	var/damage_multiplier = stacks * 0.25

	if(prob(25))
		owner.Jitter(20)

	switch(tier)
		if(1)
			if(prob(25))
				owner.adjustBruteLoss(2 * damage_multiplier)
				if(prob(25))
					to_chat(owner, span_warning("I feel a strange chill in my bones."))

		if(2)
			owner.adjustToxLoss(1 * damage_multiplier)
			if(prob(25))
				owner.adjustBruteLoss(4 * damage_multiplier)
			if(prob(10))
				var/message = pick(
					"My skin feels cold and clammy.",
					"A deep ache spreads through my limbs.",
					"Dark spots dance in my vision.")
				to_chat(owner, span_warning(message))
		if(3)
			owner.adjustToxLoss(2 * damage_multiplier)
			owner.adjustBruteLoss(1 * damage_multiplier)
			if(prob(25))
				owner.adjustOxyLoss(min(60 - owner.getOxyLoss(), 50 * damage_multiplier))
			if(prob(1))
				trigger_vomit_fit()
			if(prob(10))
				var/message = pick(
					"My flesh feels like it's rotting away!",
					"Every breath brings pain!",
					"The darkness consumes me from within!")
				to_chat(owner, span_userdanger(message))
		if(4)
			// Severe damage and limb effects
			owner.adjustToxLoss(20 * damage_multiplier)
			owner.adjustBruteLoss(10 * damage_multiplier)
			owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, 2 * damage_multiplier)
			// Chance to break limbs
			if(prob(10 * damage_multiplier) && iscarbon(owner))
				var/mob/living/carbon/C = owner
				var/list/breakable_limbs = list()
				for(var/obj/item/bodypart/BP in C.bodyparts)
					if(BP.body_zone in valid_body_zones)
						breakable_limbs += BP
				if(length(breakable_limbs))
					var/obj/item/bodypart/BP = pick(breakable_limbs)
					BP.receive_damage(brute = 25 * damage_multiplier)
					to_chat(owner, span_userdanger("My [BP.name] twists in an unnatural way as tumors bulge it out from beneath my skin!"))
			if(prob(5))
				trigger_vomit_fit()
			if(prob(10))
				var/message = pick(
					"My body is turning to dust!",
					"The void calls to me!",
					"I can feel my soul being consumed!",
					"Everything is fading to black...")
				to_chat(owner, span_userdanger(message))

/datum/status_effect/black_rot/proc/add_stack(amount = 1)
	if(owner.has_status_effect(/datum/status_effect/black_rot_debility))
		to_chat(owner, span_warning("My recovering body fights off the worsening rot!"))
		return

	var/old_stacks = stacks
	stacks = clamp(stacks + amount, 1, 4)

	if(stacks != old_stacks)
		var/time_remaining = progression_timer - world.time
		var/new_time_remaining = time_remaining * (old_stacks / stacks)
		progression_timer = world.time + new_time_remaining
		update_effects()
		update_alert()
		to_chat(owner, span_warning("The black rot festers and boils within me!"))

/datum/status_effect/black_rot/proc/remove_stack(amount = 1)
	var/old_stacks = stacks
	stacks = clamp(stacks - amount, 0, 4)

	if(stacks <= 0)
		var/mob/living/carbon/human/H = owner
		if(istype(H))
			H.apply_status_effect(/datum/status_effect/black_rot_debility)
		owner.remove_status_effect(/datum/status_effect/black_rot)
		return
	if(stacks != old_stacks)
		var/time_remaining = progression_timer - world.time
		var/new_time_remaining = time_remaining * (old_stacks / stacks)
		progression_timer = world.time + new_time_remaining
		update_effects()
		update_alert()
		to_chat(owner, span_good("The black rot recedes slightly."))

/datum/status_effect/black_rot/proc/set_tier(new_tier)
	if(new_tier < 1 || new_tier > 4)
		return

	if(new_tier >= 3 && stacks < 2)
		return

	tier = new_tier
	progression_timer = world.time + (base_progression_time / stacks)
	update_effects()
	update_alert()
	to_chat(owner, span_userdanger("The black rot shifts!"))

/datum/status_effect/black_rot/on_remove()
	to_chat(owner, span_good("The black rot is completely purged from my body!"))
	return ..()

/atom/movable/screen/alert/status_effect/black_rot
	name = "Black Rot"
	desc = "A corrupting darkness spreads through my body."
	icon_state = "black_rot1"

// Puke when advancing stages, woo
/datum/status_effect/black_rot/proc/trigger_vomit_fit()
	to_chat(owner, span_userdanger("A wave of nausea overwhelms me! IT'S ONLY GETTING WORSE."))
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
		owner.visible_message(span_warning("[owner] vomits a black, tarry substance!"), span_userdanger("I vomit a black, tarry substance!"))

/obj/effect/decal/cleanable/black_rot_vomit
	name = "black rot vomit"
	desc = "A foul, tarry black substance. It seems to writhe with unnatural energy."
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

/datum/status_effect/buff/black_rot_carrier
	id = "black_rot_carrier"
	alert_type = /atom/movable/screen/alert/status_effect/black_rot_carrier
	duration = -1
	examine_text = "SUBJECTPRONOUN is surrounded by an ominous aura of disease."

/atom/movable/screen/alert/status_effect/black_rot_carrier
	name = "Pestra's blessing"
	desc = "I carry Pestra's blessing, people should avoid my touch."

/datum/status_effect/black_rot_debility
	id = "black_rot_debility"
	alert_type = /atom/movable/screen/alert/status_effect/black_rot_debility
	duration = 30 MINUTES
	effectedstats = list(
		STATKEY_CON = -1,
		STATKEY_STR = -1
	)

/datum/status_effect/black_rot_debility/on_apply()
	. = ..()
	to_chat(owner, span_warning("I feel weakened and fragile from the aftermath of the black rot."))
	return TRUE

/datum/status_effect/black_rot_debility/on_remove()
	to_chat(owner, span_good("My strength finally returns to normal."))
	return ..()

/atom/movable/screen/alert/status_effect/black_rot_debility
	name = "Rot-Weakened"
	desc = "Pestra's skittering ethereal bugs are still knitting my ravaged flesh together. At least I should be immune for a while..."
	icon_state = "debuff_moderate"
