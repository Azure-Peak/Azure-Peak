/obj/effect/temp_visual/music_rogue //color is white by default, set to whatever is needed
	name = "music"
	icon = 'icons/effects/music-note.dmi'
	icon_state = "music_note"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/music_rogue/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	alpha = 180
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/atom/movable/screen/alert/status_effect/buff/playing_music
	name = "Playing Music"
	desc = "Let the world hear my craft."
	icon_state = "buff"

/datum/status_effect/buff/playing_music
	id = "play_music"
	alert_type = /atom/movable/screen/alert/status_effect/buff/playing_music
	var/effect_color
	var/datum/stressevent/stress_to_apply
	var/pulse = 0
	var/ticks_to_apply = 10

/datum/status_effect/buff/playing_music/on_creation(mob/living/new_owner, stress, colour)
	stress_to_apply = stress
	effect_color = colour
	return ..()

/datum/status_effect/buff/playing_music/on_remove()
	. = ..()
	if(!ishuman(owner))
		return
	var/mob/living/carbon/human/H = owner
	if(!H.inspiration)
		return
	for(var/datum/status_effect/buff/playing_dirge/dirges in owner.status_effects)
		owner.remove_status_effect(dirges)
	for(var/datum/status_effect/buff/playing_melody/melodies in owner.status_effects)
		owner.remove_status_effect(melodies)
	for(var/mob/living/carbon/human/guy in H.inspiration.audience)
		for(var/datum/status_effect/buff/song/song2remove in guy.status_effects)
			guy.remove_status_effect(song2remove)
	return ..()
	

/datum/status_effect/buff/playing_music/tick()
	var/obj/effect/temp_visual/music_rogue/M = new /obj/effect/temp_visual/music_rogue(get_turf(owner))
	M.color = effect_color
	pulse += 1
	if (pulse >= ticks_to_apply)
		pulse = 0
		for (var/mob/living/carbon/human/H in hearers(7, owner))
			if (!H.client)
				continue
			if (!H.has_stress_event(stress_to_apply))
				add_sleep_experience(owner, /datum/skill/misc/music, owner.STAINT)
				H.add_stress(stress_to_apply)
				if (prob(50))
					to_chat(H, stress_to_apply.desc)
			
			// Apply Xylix buff to those with the trait who hear the music
			// Only apply if the hearer is not the one playing the music
			if (H != owner && HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy))
				H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
				to_chat(H, span_info("The music brings a smile to my face, and fortune to my steps!"))


/obj/effect/temp_visual/songs
	name = "songs"
	icon = 'icons/mob/actions/bardsong_anims.dmi'
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER


/obj/effect/temp_visual/songs/Initialize(mapload)
	. = ..()
	alpha = 140
	pixel_x = rand(-18, 18)
	pixel_y = rand(-16, 0)
	var/matrix/m = matrix()
	m.Scale(0.75, 0.75)
	transform = m


/obj/effect/temp_visual/songs/inspiration_dirget1
	icon_state = "dirge_t1_base"

/obj/effect/temp_visual/songs/inspiration_dirget2
	icon_state = "dirge_t2_base"

/obj/effect/temp_visual/songs/inspiration_dirget3
	icon_state = "dirge_t3_base"

/obj/effect/temp_visual/songs/inspiration_melodyt1
	icon_state = "melody_t1_base"

/obj/effect/temp_visual/songs/inspiration_melodyt2
	icon_state = "melody_t2_base"

/obj/effect/temp_visual/songs/inspiration_melodyt3
	icon_state = "melody_t3_base"

/obj/effect/temp_visual/songs/inspiration_bardsongt1
	icon_state = "bardsong_t1_base"

/obj/effect/temp_visual/songs/inspiration_bardsongt2
	icon_state = "bardsong_t2_base"

/obj/effect/temp_visual/songs/inspiration_bardsongt3
	icon_state = "bardsong_t3_base"
