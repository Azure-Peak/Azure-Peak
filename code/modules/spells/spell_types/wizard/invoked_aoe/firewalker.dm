/obj/effect/proc_holder/spell/invoked/firewalker
	name = "Firewalker"
	overlay_state = "firewalk"
	desc = "Watch the fire dance and join the dance together! \n\
	The ground under your feet will burn!"
	cost = 4
	xp_gain = TRUE
	releasedrain = 30
	chargedrain = 1
	chargetime = 0.5 SECONDS
	recharge_time = 45 SECONDS
	warnie = "spellwarning"
	spell_tier = 3
	invocations = list("Ignis Saltatio.")
	invocation_type = "whisper"
	glow_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_HIGH
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/firewalker/cast(list/targets, mob/living/user = usr)
	. = ..()
	playsound(get_turf(user), 'sound/magic/haste.ogg', 80, TRUE, soundping = TRUE)

	user.visible_message("[user] mutters an incantation, and the ground underneath begins to roar in flames!")
	user.apply_status_effect(/datum/status_effect/buff/firewalker)

	return TRUE

#define FIREWALKER_FILTER "firewalker_glow"

/atom/movable/screen/alert/status_effect/buff/firewalker
	name = "Fire Aura"
	desc = "The ground is burning under my feet!"
	icon_state = "fire"

/datum/status_effect/buff/firewalker
	id = "fireaura"
	alert_type = /atom/movable/screen/alert/status_effect/buff/firewalker
	effectedstats = list(STATKEY_SPD = -1)
	examine_text = span_warning("Dancing in the fire!!")
	duration = 5 SECONDS
	var/outline_colour ="#f96d1bff"

/datum/status_effect/buff/firewalker/on_apply()
	. = ..()

	var/filter = owner.get_filter(FIREWALKER_FILTER)
	if(!filter)
		owner.add_filter(FIREWALKER_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 80, "size" = 1))

/datum/status_effect/buff/firewalker/tick(seconds_between_ticks)
    for(var/turf/nearby_turf as anything in RANGE_TURFS(2, owner))
        new /obj/effect/hotspot(nearby_turf, null, null, 1)

/datum/status_effect/buff/firewalker/on_remove()
	. = ..()
	to_chat(owner, span_warning("The flame under my feets fades away."))
	owner.remove_filter(FIREWALKER_FILTER)

#undef FIREWALKER_FILTER
