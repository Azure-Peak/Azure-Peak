/obj/effect/proc_holder/spell/invoked/wither
	name = "Wither"
	desc = "Lashes out a delayed line of dark magic, lowering the physical prowess of all in it's path."
	cost = 3
	releasedrain = 50
	overlay_state = "wither" // just using the curse blob, it's placeholder.
	chargedrain = 2
	chargetime = 2 SECONDS
	recharge_time = 20 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE // Offensive spell
	spell_tier = 3 // AOE
	invocations = list("Arescentem!")
	invocation_type = "shout"
	glow_color = "#b884f8" // evil ass purple
	glow_intensity = GLOW_INTENSITY_HIGH
	var/delay = 3
	var/strike_delay = 1 // delay between each individual strike. 3 delays seems to make someone stupid able to walk into every single strikes.
	var/strikerange = 14 // how many tiles the strike can reach
	var/damage = 60

/obj/effect/proc_holder/spell/invoked/wither/cast(list/targets, mob/user = usr)
	var/turf/T = get_turf(targets[1])

	var/turf/source_turf = get_turf(user)
	
	if(T.z != user.z)
		to_chat(span_warning("You can't cast this spell on a different z-level!"))
		return FALSE

	var/list/affected_turfs = getline(source_turf, T)

	for(var/i = 1, i <= affected_turfs.len, i++)
		var/turf/affected_turf = affected_turfs[i]
		if(affected_turf == source_turf) // Don't zap yourself
			continue
		if(!(affected_turf in get_hear(strikerange, source_turf)))
			continue
		var/tile_delay = strike_delay * (i - 1) + delay
		new /obj/effect/temp_visual/trap/wither(affected_turf, tile_delay)
		addtimer(CALLBACK(src, PROC_REF(strike), affected_turf), wait = tile_delay)
	return TRUE

/obj/effect/proc_holder/spell/invoked/wither/proc/strike(var/turf/damage_turf)
	new /obj/effect/temp_visual/wither_actual(damage_turf)
	playsound(damage_turf, 'sound/magic/shadowstep_destination.ogg', 50)
	for(var/mob/living/L in damage_turf.contents)
		if(L.anti_magic_check())
			visible_message(span_warning("The magic fades away around you [L] "))  //antimagic needs some testing
			playsound(damage_turf, 'sound/magic/magic_nulled.ogg', 100)
			continue
		L.adjustFireLoss(damage)
		L.apply_status_effect(/datum/status_effect/buff/witherd/)


/obj/effect/temp_visual/trap/wither
	icon = 'icons/effects/effects.dmi'
	icon_state = "curse"
	light_outer_range = 0
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER
	alpha = 70
	

/obj/effect/temp_visual/wither_actual
	icon = 'icons/effects/effects.dmi'
	icon_state = "curseblob"
	light_outer_range = 2
	light_color = "#b884f8" // evil
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/trap/wither/Initialize(mapload, duration_override)
	if(duration_override)
		duration = duration_override
	. = ..() // Call parent AFTER setting duration
	