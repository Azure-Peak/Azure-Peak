/obj/effect/proc_holder/spell/invoked/rebuke 
	name = "Hellish Rebuke"
	desc = "With a point of your finger, you shall cause a creechur in front of you to burst into flames, dealing damage over time. Able to cast whilst mouthgrabbed."
	cost = 3
	overlay_state = "hellish_rebuke"
	xp_gain = TRUE
	releasedrain = 10
	chargedrain = 1
	chargetime = 0.5 SECONDS
	charging_slowdown = 2
	recharge_time = 6 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokefire
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocation_type = "none"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW
	gesture_required = TRUE
	human_req = TRUE // Combat spell
	range = 1
	ignore_los = FALSE


/obj/effect/proc_holder/spell/invoked/rebuke/cast(list/targets, mob/living/user)
	if(!isliving(targets[1]))
		return FALSE

	var/mob/living/carbon/target = targets[1]
	if(spell_guard_check(target, TRUE))
		target.visible_message(span_warning("[target] shrugs off the flames!"))
		return TRUE
	target.adjustFireLoss(30) //damage
	target.adjust_fire_stacks(4)
	target.ignite_mob()
	target.visible_message(span_warning("[user] makes a rude gesture at [target] and causes them to burst into flames!"), \
	span_userdanger("[user] makes a rude gesture at you and causes you to burst into flames!"))
	playsound(get_turf(target), 'sound/misc/explode/incendiary (1).ogg', 100, TRUE)

	return TRUE

