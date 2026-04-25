/datum/action/cooldown/spell/projectile/blood_bolt
	name = "Blood Bolt"
	desc = "Emit a bolt of lightning that burns a target harshly, preventing them from attacking and slowing them down for 8 seconds. Applies lightning adaptation - the non-burn effects cannot be reapplied within 15 seconds."
	button_icon_state = "bloodlightning"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_VAMPIRIC
	glow_intensity = GLOW_INTENSITY_MEDIUM

	projectile_type = /obj/projectile/magic/bloodlightning
	cast_range = SPELL_RANGE_PROJECTILE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Sanguis Sagitta!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = 2.5 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 15 SECONDS

	associated_skill = /datum/skill/magic/blood
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	point_cost = 6

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

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
	flag = "fire"
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
			L.electrocute_act(1, src, 1, SHOCK_NOSTUN)
			if(!L.mob_timers[MT_LIGHTNING_ADAPTATION] || world.time > L.mob_timers[MT_LIGHTNING_ADAPTATION] + LIGHTNING_ADAPTATION_COOLDOWN)
				L.Immobilize(0.5 SECONDS)
				L.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
				L.apply_status_effect(/datum/status_effect/buff/lightningstruck, 8 SECONDS)
				L.balloon_alert_to_viewers("<font color='#ffcc00'>shocked! (8s)</font>")
				L.mob_timers[MT_LIGHTNING_ADAPTATION] = world.time
			else
				var/remaining = round((L.mob_timers[MT_LIGHTNING_ADAPTATION] + LIGHTNING_ADAPTATION_COOLDOWN - world.time) / 10)
				L.balloon_alert_to_viewers("<font color='#ffcc00'>shock adapted ([remaining]s)</font>")
	qdel(src)
