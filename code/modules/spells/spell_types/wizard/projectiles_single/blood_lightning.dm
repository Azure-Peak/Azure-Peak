// Lich / Vampire shared list only
/obj/effect/proc_holder/spell/invoked/projectile/bloodlightning
	name = "Blood Bolt"
	desc = "Emit a bolt of lightning that burns a target harshly, preventing them from attacking and slowing them down for 8 seconds."
	clothes_req = FALSE
	overlay_state = "bloodlightning"
	sound = 'sound/magic/vlightning.ogg'
	range = 8
	projectile_type = /obj/projectile/magic/bloodlightning
	releasedrain = 30
	chargedrain = 1
	chargetime = 25
	recharge_time = 15 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2 // Doesn't matter for the most part
	invocations = list("Sanguis Sagitta!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_VAMPIRIC
	glow_intensity = GLOW_INTENSITY_MEDIUM
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/blood
	cost = 6

/obj/projectile/magic/bloodlightning
	name = "blood bolt"
	tracer_type = /obj/effect/projectile/tracer/blood
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	damage = 80
	damage_type = BURN
	nodamage = FALSE
	speed = 0.3
	flag = "magic"
	light_color = "#802121"
	light_outer_range = 7


/obj/projectile/magic/bloodlightning/on_hit(target)
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
			L.Immobilize(0.5 SECONDS)
			L.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
			L.electrocute_act(1, src, 1, SHOCK_NOSTUN)
			L.apply_status_effect(/datum/status_effect/buff/lightningstruck, 8 SECONDS)
	qdel(src)
