
/obj/effect/proc_holder/spell/invoked/projectile/spitfire
	name = "Spitfire"
	desc = "Shoot out a low-powered ball of fire that ignites a target with a small amount of fire on impact. \n\
	Damage is increased by 100% versus simple-minded creechurs.\n\
	Toggle arc mode (Ctrl+G) while the spell is active to fire it over intervening mobs. Arced attacks deal 25% less damage."
	clothes_req = FALSE
	range = 8
	projectile_type = /obj/projectile/magic/aoe/fireball/spitfire
	projectile_type_arc = /obj/projectile/magic/aoe/fireball/spitfire/arc
	overlay_state = "fireball_multi"
	sound = list('sound/magic/whiteflame.ogg')
	active = FALSE
	releasedrain = 35
	chargedrain = 1
	chargetime = 1
	recharge_time = 6 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("Evomere Flammas!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokefire
	associated_skill = /datum/skill/magic/arcane
	cost = 3

/obj/effect/proc_holder/spell/invoked/projectile/spitfire/cast(list/targets, mob/user = user)
	projectile_type = arc_mode ? projectile_type_arc : initial(projectile_type)
	. = ..()

/obj/projectile/magic/aoe/fireball/spitfire
	name = "Spitfire"
	exp_heavy = -1
	exp_light = -1
	exp_flash = 0
	exp_fire = 0
	damage = 20
	npc_simple_damage_mult = 2 // Makes it more effective against NPCs.
	accuracy = 40 // Base accuracy is lower for burn projectiles because they bypass armor
	damage_type = BURN
	nodamage = FALSE
	flag = "magic"
	hitsound = 'sound/blank.ogg'
	aoe_range = 0

/obj/projectile/magic/aoe/fireball/spitfire/arc
	name = "Arced Spitfire"
	damage = 15 // 25% damage penalty
	arcshot = TRUE

/obj/projectile/magic/aoe/fireball/spitfire/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(M.has_status_effect(/datum/status_effect/buff/frost) || M.has_status_effect(/datum/status_effect/buff/frostbite))
			visible_message(span_warning("[src] extinguishes on contact with [target]!"))
			playsound(get_turf(target), 'sound/items/firesnuff.ogg', 100)
			M.remove_status_effect(/datum/status_effect/buff/frost)
			M.remove_status_effect(/datum/status_effect/buff/frostbite)
			new /obj/effect/temp_visual/snap_freeze(get_turf(M))
			qdel(src)
			return BULLET_ACT_BLOCK
		M.adjust_fire_stacks(1)
		M.ignite_mob()
	else if(isatom(target))
		var/atom/A = target
		A.fire_act()
