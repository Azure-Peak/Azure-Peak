/obj/effect/proc_holder/spell/invoked/projectile/frostbolt // to do: get scroll icon
	name = "Frost Bolt"
	desc = "A ray of frozen energy, slowing the first thing it touches and lightly damaging it."
	range = 8
	projectile_type = /obj/projectile/magic/frostbolt
	overlay_state = "frost_bolt"
	sound = list('sound/magic/whiteflame.ogg')
	active = FALSE

	releasedrain = 30
	chargedrain = 1
	chargetime = 8
	recharge_time = 6 SECONDS

	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	antimagic_allowed = FALSE //can you use it if you are antimagicked?
	charging_slowdown = 3
	spell_tier = 2
	invocations = list("Sagitta Glaciei!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane //can be arcane, druidic, blood, holy
	cost = 3

	xp_gain = TRUE
	miracle = FALSE

/obj/projectile/magic/frostbolt
	name = "Frost Dart"
	icon_state = "ice_2"
	damage = 20
	npc_simple_damage_mult = 2
	damage_type = BURN
	flag = "magic"
	range = 10
	speed = 1
	nodamage = FALSE

/obj/projectile/magic/frostbolt/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/M = target
		if(M.anti_magic_check())
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(isliving(target))
			var/mob/living/L = target
			if(L.has_status_effect(/datum/status_effect/buff/frostbite))
				return
			else
				if(L.has_status_effect(/datum/status_effect/buff/frost))
					playsound(get_turf(target), 'sound/combat/fracture/fracturedry (1).ogg', 80, TRUE, soundping = TRUE)
					L.remove_status_effect(/datum/status_effect/buff/frost)
					L.apply_status_effect(/datum/status_effect/buff/frostbite)
				else
					L.apply_status_effect(/datum/status_effect/buff/frost)
			new /obj/effect/temp_visual/snap_freeze(get_turf(L))
	qdel(src)
