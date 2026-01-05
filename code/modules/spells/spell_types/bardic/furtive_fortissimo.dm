/obj/effect/proc_holder/spell/invoked/song/furtive_fortissimo
	name = "Furtive Fortissimo"
	desc = "With cat like tread, apply light steps to audience members"
	song_tier = 1
	invocations = list("With cat like tread!!") 
	invocation_type = "shout"
	overlay_state = "bardsong_t1_base"
	action_icon_state = "bardsong_t1_base"
	song_effect = /datum/status_effect/buff/playing_melody/furtive_fortissimo

/datum/status_effect/buff/playing_melody/furtive_fortissimo
	effect = /obj/effect/temp_visual/songs/inspiration_bardsongt1
	buff_to_apply = /datum/status_effect/buff/song/furtive_fortissimo


/atom/movable/screen/alert/status_effect/buff/song/furtive_fortissimo
	name = "Furtive Fortissimo"
	desc = "With cat like tread, the sneaking song begins."
	icon_state = "buff"

/datum/status_effect/buff/song/furtive_fortissimo
	id = "furtivefortissimo"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/furtive_fortissimo
	duration = 15 SECONDS

/datum/status_effect/buff/song/furtive_fortissimo/on_apply()
	. = ..()
	to_chat(owner, span_warning("I feel sneakier than usual... Something about that music..."))
	ADD_TRAIT(owner, TRAIT_LIGHT_STEP, id)

/datum/status_effect/buff/song/furtive_fortissimo/on_remove()
	. = ..()
	to_chat(owner, span_warning("I feel as sneaky as I normally am, now that the song is over..."))
	REMOVE_TRAIT(owner, TRAIT_LIGHT_STEP, id)

