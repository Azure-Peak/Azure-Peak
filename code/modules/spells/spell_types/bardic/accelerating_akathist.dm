/obj/effect/proc_holder/spell/invoked/song/accelakathist
	name = "Accelerating Akathist"
	desc = "Accelerate your allies with your bardic song!"
	song_tier = 3
	invocations = list("plays a blisteringly fast series of notes!") 
	invocation_type = "emote"
	overlay_state = "bardsong_t3_base"
	action_icon_state = "bardsong_t3_base"
	song_effect = /datum/status_effect/buff/playing_melody/accelakathist

/datum/status_effect/buff/playing_melody/accelakathist
	effect = /obj/effect/temp_visual/songs/inspiration_bardsongt3
	buff_to_apply = /datum/status_effect/buff/song/accelakathist
	
/atom/movable/screen/alert/status_effect/buff/song/accelakathist
	name = "Accelerating Akathist"
	desc = "I can feel the rhythm!"
	icon_state = "buff"

#define ACCELAKATHIST_FILTER "akathist_glow"

/datum/status_effect/buff/song/accelakathist
	var/outline_colour ="#F0E68C"
	id = "haste"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/accelakathist
	effectedstats = list(STATKEY_SPD = 2)
	duration = 15 SECONDS

/datum/status_effect/buff/song/accelakathist/on_apply()
	. = ..()
	var/filter = owner.get_filter(ACCELAKATHIST_FILTER)
	if (!filter)
		owner.add_filter(ACCELAKATHIST_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 25, "size" = 1))
	to_chat(owner, span_warning("I am being invited to dance! My heart pounds in my ears as my movements quicken!"))

/datum/status_effect/buff/song/accelakathist/on_remove()
	. = ..()
	owner.remove_filter(ACCELAKATHIST_FILTER)
	to_chat(owner, span_warning("The song ends, and my heartbeat slows back down to a more moderate tempo."))

#undef ACCELAKATHIST_FILTER

/datum/status_effect/buff/song/accelakathist/nextmove_modifier()
	return 0.85
