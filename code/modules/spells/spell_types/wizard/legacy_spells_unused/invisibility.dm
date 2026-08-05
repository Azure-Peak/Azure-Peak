// GENERIC OLD VERSION, UPDATE THIS SEPERATELY //
/obj/effect/proc_holder/spell/invoked/invisibility
	name = "Invisibility"
	action_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_icon = 'icons/mob/actions/nocmiracles.dmi'
	overlay_state = "invisibility"
	desc = "Make another (or yourself) invisible for some time. Duration scales with intelligence. Casting, attacking or being attacked will cancel the duration."
	releasedrain = 30
	chargedrain = 5
	chargetime = 5
	clothes_req = FALSE
	recharge_time = 30 SECONDS
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	spell_tier = 1
	invocation_type = "none"
	glow_color = GLOW_COLOR_ILLUSION
	sound = 'sound/misc/area.ogg'
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	hide_charge_effect = TRUE
	cost = 3 // Very useful
	ignore_combat_tag = TRUE

/obj/effect/proc_holder/spell/invoked/invisibility/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		target.visible_message(span_warning("[target] starts to fade into thin air!"), span_notice("You start to become invisible!"))
		var/dur
		if(miracle)
			dur = max((5 * (user.get_skill_level(associated_skill))), 15)
		else
			dur = 15 + min(max(user.STAINT - 10, 0) * 2.5, 12.5)
		if(dur >= recharge_time)
			recharge_time = dur + 5 SECONDS
		animate(target, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		target.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
		addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[target] fades back into view."), span_notice("You become visible again.")), dur SECONDS)
		return TRUE
	revert_cast()
	return FALSE
