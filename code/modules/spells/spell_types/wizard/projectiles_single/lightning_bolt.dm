/obj/effect/proc_holder/spell/invoked/projectile/lightningbolt
	name = "Bolt of Lightning"
	desc = "Emit a bolt of lightning that burns a target, preventing them from attacking and slowing them down for 6 seconds. \n\
	Damage is increased by 100% versus simple-minded creechurs."
	clothes_req = FALSE
	overlay_state = "lightning"
	sound = 'sound/magic/lightning.ogg'
	range = 8
	projectile_type = /obj/projectile/magic/lightning
	releasedrain = 30
	chargedrain = 1
	chargetime = 15
	recharge_time = 15 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokelightning
	associated_skill = /datum/skill/magic/arcane
	glow_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_MEDIUM
	spell_tier = 2
	invocations = list("Fulmen!")
	invocation_type = "shout"
	cost = 3
	xp_gain = TRUE

/obj/projectile/magic/lightning
	name = "bolt of lightning"
	tracer_type = /obj/effect/projectile/tracer/stun
	muzzle_type = null
	impact_type = null
	hitscan = TRUE
	movement_type = UNSTOPPABLE
	light_color = LIGHT_COLOR_WHITE
	damage = 40
	npc_simple_damage_mult = 2 // Good news it is not a trap to shoot at NPC anymore
	damage_type = BURN
	accuracy = 40 // Base accuracy is lower for burn projectiles because they bypass armor
	nodamage = FALSE
	speed = 0.3
	flag = "magic"
	light_color = "#ffffff"
	light_outer_range = 7


/obj/projectile/magic/lightning/on_hit(target)
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
			L.apply_status_effect(/datum/status_effect/debuff/clickcd, 6 SECONDS)
			L.electrocute_act(1, src, 1, SHOCK_NOSTUN)
			L.apply_status_effect(/datum/status_effect/buff/lightningstruck, 6 SECONDS)
	qdel(src)
