/datum/action/cooldown/mob_cooldown/stone_throw
	name = "Stone Throw"
	button_icon = 'icons/effects/effects.dmi'
	button_icon_state = "explosion"
	desc = "Chucks a stone at someone"
	cooldown_time = 20 SECONDS
	var/cast_time	= 3 SECONDS
	var/range = 8
	var/def_zone = BODY_ZONE_CHEST
	var/rock_damage = 40

/datum/action/cooldown/mob_cooldown/stone_throw/Activate(atom/target)
	if(!target || target == owner)
		return FALSE
	var/dist = get_dist(owner, target)
	if(can_see(owner, target, range) && dist < range && dist > 1) //can see, in range and not adjacent
		owner.visible_message(span_alert("[owner] reaches towards the ground, eyeing [target]."))
		addtimer(CALLBACK(src, PROC_REF(prepare_stone), target), cast_time)
		StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/stone_throw/proc/prepare_stone(atom/target, mob/living/L)
	if(!target || target == owner || QDELETED(target))
		return
	owner.visible_message(span_alert("[owner] digs into the ground and grabs a massive rock!"))
	playsound(owner, 'sound/items/dig_shovel.ogg', 100, TRUE)
	sleep(20)
	var/dist = get_dist(owner, target)
	var/obj/effect/temp_visual/stone_throw/stone = new(owner.loc)
	var/original_target_loc = target.loc
	var/dx = (target.x - owner.x) * 32
	var/dy = (target.y - owner.y) * 32
	if(can_see(owner, target, range) && dist < range && dist > 1)
		owner.visible_message(span_boldwarning("[owner] chucks a huge rock!"))
		playsound(owner.loc, 'sound/combat/shieldraise.ogg', 100)
		animate(stone, pixel_x = dx, pixel_y = dy, time = 4)
		sleep(4) // Wait for the animation to complete
		if(target && target.loc == original_target_loc)
			stone.loc = target.loc
			stone.pixel_x = 0
			stone.pixel_y = 0
			if(ismob(target))
				var/mob/living/victim = target
				def_zone = pick(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_CHEST, BODY_ZONE_HEAD)
				victim.apply_damage(rock_damage, BRUTE, def_zone, victim.run_armor_check(def_zone, "stab", armor_penetration = PEN_NONE, damage = rock_damage))
				victim.Paralyze(5)
				to_chat(target, span_userdanger("You're hit by a big rock!"))
				playsound(target, 'sound/foley/smash_rock.ogg', 100, TRUE)
	else
		owner.visible_message(span_alert("[owner] roars in frustration."))
	return

/obj/effect/temp_visual/stone_throw
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stonebig1"
	name = "stone"
	desc = "You should scram..."
	layer = FLY_LAYER
	plane = GAME_PLANE_UPPER
	randomdir = FALSE
