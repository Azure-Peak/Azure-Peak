/obj/effect/proc_holder/spell/invoked/song/recovery_song
	name = "Resting Rhapsody"
	desc = "Recuperate your allies spirit's with your song! Refills stamina over time!"
	song_tier = 2
	invocations = list("Thy muscles recuperate, thy limbs refresh!") 
	invocation_type = "shout"
	overlay_state = "melody_t2_base"
	action_icon_state = "melody_t2_base"
	song_effect = /datum/status_effect/buff/playing_melody/recovery

/datum/status_effect/buff/playing_melody/recovery
	effect = /obj/effect/temp_visual/songs/inspiration_melodyt2
	buff_to_apply = /datum/status_effect/buff/song/recovery

/atom/movable/screen/alert/status_effect/buff/song/recovery
	name = "Musical Recovery"
	desc = "I am refreshed by the song!"
	icon_state = "buff"

/datum/status_effect/buff/song/recovery
	id = "recoverysong"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/recovery
	duration = 15 SECONDS

/datum/status_effect/buff/song/recovery/tick()
	owner.stamina_add(-5)
