/datum/action/cooldown/spell/song/fervor_song
	name = "Fervorous Fantasia"
	desc = "Inspire the rhythm of battle, sharpening your allies' senses in combat!"
	button_icon_state = "bardsong_t2_base"
	invocations = list("plays a bombastic, rhythmic march! The world feels grounded!")
	song_effect = /datum/status_effect/buff/playing_melody/fervor

/datum/status_effect/buff/playing_melody/fervor
	effect = /obj/effect/temp_visual/songs/inspiration_bardsongt2
	buff_to_apply = /datum/status_effect/buff/song/fervor
	buff_to_apply_full = /datum/status_effect/buff/song/fervor/full

#define FERVOR_FILTER "fervor_glow"

/atom/movable/screen/alert/status_effect/buff/song/fervor
	name = "Musical Fervor"
	desc = "Musical assistance guides my hands."
	icon_state = "buff"

/datum/status_effect/buff/song/fervor
	var/outline_colour = "#f58e2d"
	id = "fervor"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/fervor
	duration = 15 SECONDS
	effectedstats = list(STATKEY_PER = 2)

/datum/status_effect/buff/song/fervor/full
	effectedstats = list(STATKEY_PER = 3)

/datum/status_effect/buff/song/fervor/on_apply()
	. = ..()
	var/filter = owner.get_filter(FERVOR_FILTER)
	if (!filter)
		owner.add_filter(FERVOR_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("I feel as if I truly understand combat! This is a tune worth fighting for!"))

/datum/status_effect/buff/song/fervor/on_remove()
	. = ..()
	to_chat(owner, span_warning("The buzzing in my head softens, as does my adrenaline."))
	owner.remove_filter(FERVOR_FILTER)

#undef FERVOR_FILTER
