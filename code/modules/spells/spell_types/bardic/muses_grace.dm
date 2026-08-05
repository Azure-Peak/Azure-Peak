/datum/action/cooldown/spell/song/muses_grace
	name = "Muse's Grace"
	desc = "A gentle melody, compelling audience members to sing."
	button_icon_state = "melody_t1_base"
	invocations = list("plays a graceful, gentle tune. The world feels compelled to respond in song.")
	song_effect = /datum/status_effect/buff/playing_melody/muses_grace

/datum/status_effect/buff/playing_melody/muses_grace
	effect = /obj/effect/temp_visual/songs/inspiration_bardsongt1
	buff_to_apply = /datum/status_effect/buff/song/muses_grace


/atom/movable/screen/alert/status_effect/buff/song/muses_grace
	name = "Muse's Grace"
	desc = "A Muse's Grace commands words into melody!"
	icon_state = "buff"

/datum/status_effect/buff/song/muses_grace
	id = "musesgrace"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/muses_grace
	duration = 15 SECONDS

/datum/status_effect/buff/song/muses_grace/on_apply()
	. = ..()
	to_chat(owner, span_warning("As that music plays I feel a very powerful compulsion to... Sing?"))
	ADD_TRAIT(owner, TRAIT_MUSES_GRACE, id)

/datum/status_effect/buff/song/muses_grace/on_remove()
	. = ..()
	to_chat(owner, span_warning("The compulsion to sing suddenly ends, I feel like I can speak without melody again."))
	REMOVE_TRAIT(owner, TRAIT_MUSES_GRACE, id)
