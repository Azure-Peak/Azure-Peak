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
	if(HAS_TRAIT(owner, TRAIT_IRONMAN))
		return
	var/time_progress = (duration - time_left) / duration
	time_left -= tick_interval
	// This shouldn't ever dip below 5, but let's use MAX for safety anyways
	healing_strength = max(5, healing_strength - (time_progress * (healing_strength - 5)))
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = outline_colour
	do_sprite_shake(owner, 3, 3, 15, 1)

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
	if(HAS_TRAIT(owner, TRAIT_IRONMAN))
		return
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = effect_colour

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
	icon_state = "buff"

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
	duration = 15 SECONDS
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
	desc = "Pestra's skittering ethereal bugs are still knitting my ravaged flesh together. At least I should be immune for a little bit..."
	icon_state = "debuff"
