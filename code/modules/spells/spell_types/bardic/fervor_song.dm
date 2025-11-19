/obj/effect/proc_holder/spell/invoked/song/fervor_song
	name = "Fervorous Fantasia"
	desc = "Inspire the rhythm of battle, your allies strike and parry 20% better!"
	song_tier = 2
	warnie = "spellwarning"
	invocations = list("To my tune, strike and move thy feet!") 
	invocation_type = "shout"
	overlay_state = "bardsong_t2_base"
	action_icon_state = "bardsong_t2_base"
	song_effect = /datum/status_effect/buff/playing_melody/fervor

/datum/status_effect/buff/playing_melody/fervor
	effect = /obj/effect/temp_visual/songs/inspiration_bardsongt2
	buff_to_apply = /datum/status_effect/buff/song/fervor


#define FERVOR_FILTER "fervor_glow"

/atom/movable/screen/alert/status_effect/buff/song/fervor // spicy guidance
	name = "Musical Fervor"
	desc = "Musical assistance guides my hands. (+20% chance to bypass parry / dodge, +20% chance to parry / dodge)"
	icon_state = "buff"

/datum/status_effect/buff/song/fervor
	var/outline_colour ="#f58e2d"
	id = "fervor"
	alert_type = /atom/movable/screen/alert/status_effect/buff/song/fervor
	duration = 15 SECONDS

/datum/status_effect/buff/song/fervor/on_apply()
	. = ..()
	var/filter = owner.get_filter(FERVOR_FILTER)
	if (!filter)
		owner.add_filter(FERVOR_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 50, "size" = 1))
	to_chat(owner, span_warning("The tune aides me in battle."))
	ADD_TRAIT(owner, TRAIT_GUIDANCE, MAGIC_TRAIT)

/datum/status_effect/buff/song/fervor/on_remove()
	. = ..()
	to_chat(owner, span_warning("My feeble mind muddies my warcraft once more."))
	owner.remove_filter(FERVOR_FILTER)
	REMOVE_TRAIT(owner, TRAIT_GUIDANCE, MAGIC_TRAIT)


#undef FERVOR_FILTER
