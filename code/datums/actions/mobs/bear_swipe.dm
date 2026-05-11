/datum/action/cooldown/mob_cooldown/bear_swipe
	name = "bear swipe"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "explosion"
	desc = "Swipes at someone with a huge paw"
	cooldown_time = 10 SECONDS
	var/cast_time = 1 SECONDS
	var/def_zone = BODY_ZONE_CHEST
	var/range = 2
	var/swipe_damage = 40

/datum/action/cooldown/mob_cooldown/bear_swipe/Activate(atom/target)
	if(!target || target == owner)
		return FALSE
	var/dist = get_dist(owner, target)
	if(can_see(owner, target, range) && dist < range && dist <= 1) //can see, in range and adjacent
		owner.visible_message(span_boldwarning("[owner] rears up to swipe at [target]!"))
		addtimer(CALLBACK(src, PROC_REF(do_swipe), target), cast_time)
		StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/bear_swipe/proc/do_swipe(atom/target, mob/living/L)
	if(!target || target == owner || QDELETED(target))
		return
	var/dist = get_dist(owner, target)
	if(can_see(owner, target, range) && dist < range && dist <= 1)
		playsound(owner.loc, 'sound/combat/shieldraise.ogg', 100)
		if(ismob(target))
			var/mob/living/victim = target
			def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST, BODY_ZONE_HEAD, BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
			victim.apply_damage(swipe_damage, BRUTE, def_zone, victim.run_armor_check(def_zone, "stab", armor_penetration = PEN_MEDIUM, damage = swipe_damage))
			victim.apply_status_effect(/datum/status_effect/debuff/staggered)
			var/turf/target_turf = get_turf(target)
			new /obj/effect/temp_visual/paw_swipe(target_turf)
			to_chat(target, span_userdanger("You're hit by a powerful swipe!"))
			playsound(target, 'sound/combat/hits/punch/punch (1).ogg', 100, TRUE)
	else
		owner.visible_message(span_alert("[owner] roars in frustration as you distance yourself from its swipe."))
	return

/obj/effect/temp_visual/paw_swipe
	icon = 'icons/effects/effects.dmi'
	icon_state = "claw"
	name = "bear paw"
	desc = "It's huge"
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
