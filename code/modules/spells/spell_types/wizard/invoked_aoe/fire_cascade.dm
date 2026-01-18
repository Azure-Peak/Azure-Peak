/obj/effect/proc_holder/spell/invoked/fire_cascade
	name = "Fire Cascade"
	desc = "Heats the air around you."
	overlay_state = "fireaura"
	spell_tier = 3
	cost = 6
	releasedrain = 20
	chargedrain = 1
	chargetime = 0.5 SECONDS
	recharge_time = 30 SECONDS
	warnie = "spellwarning"
	gesture_required = TRUE
	movement_interrupt = FALSE
	no_early_release = TRUE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("C'SC'D.")
	invocation_type = "whisper"
	xp_gain = TRUE
	associated_skill = /datum/skill/magic/arcane

	var/flame_radius = 2
	var/hotspot_lifetime = 3

/obj/effect/proc_holder/spell/invoked/fire_cascade/cast(list/targets, mob/living/user = usr)
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(fire_cascade), user, flame_radius)

/obj/effect/proc_holder/spell/invoked/fire_cascade/proc/fire_cascade(mob/living/owner, flame_radius = 1)
	var/turf/centre = get_turf(owner)

	for(var/i in 0 to flame_radius)
		for(var/turf/nearby_turf as anything in spiral_range_turfs(i + 1, centre))
			new /obj/effect/hotspot(nearby_turf, null, null, hotspot_lifetime)

		stoplag(0.3 SECONDS)
