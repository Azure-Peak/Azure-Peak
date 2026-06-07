//By DREAMKEEP, Vide Noir https://github.com/EaglePhntm.
//GRAPHICS & SOUNDS INCLUDED:
//DARKEST DUNGEON (STRESS, RELIEF, AFFLICTION)
/mob/living/proc/play_overhead_indicator(icon_path, overlay_name, clear_time, overlay_layer, private = FALSE, soundin = null, y_offset = 12)
	if(!ishuman(src))
		return
	if(stat != DEAD)
		var/mob/living/carbon/human/humie = src
		var/datum/species/species =	humie.dna.species
		var/list/offset_list
		if(humie.gender == FEMALE)
			offset_list = species.offset_features[OFFSET_HEAD_F]
		else
			offset_list = species.offset_features[OFFSET_HEAD]
		if(!private)
			var/mutable_appearance/appearance = mutable_appearance(icon_path, overlay_name, overlay_layer)
			if(offset_list)
				appearance.pixel_x += (offset_list[1])
				appearance.pixel_y += (offset_list[2]+y_offset)
			appearance.appearance_flags = RESET_COLOR
			overlays_standing[OBJ_LAYER] = appearance
			apply_overlay(OBJ_LAYER)
			addtimer(CALLBACK(humie, PROC_REF(clear_overhead_indicator), appearance), clear_time)
			playsound(src, soundin, 100, FALSE, extrarange = -1, ignore_walls = FALSE)
		if(!ispath(private, /datum/patron) && private)	//Trait-exclusivity. At the moment it's only TRAIT_EMPATH for stress indicators.
			var/list/can_see = list(src)
			for(var/mob/M in viewers(world.view, src))
				if(HAS_TRAIT(M, private))
					if(M != src)
						can_see += M
			
			for(var/mob/M in can_see)
				vis_contents += new /obj/effect/temp_visual/stress_event/invisible(null, M, icon_path, overlay_name, offset_list)
				if(soundin)
					var/turf/T = get_turf(src)
					M.playsound_local(T, soundin, 100, FALSE)

		if(ispath(private, /datum/patron))	//Patron signs. 
			var/icon_plane = WEATHER_EFFECT_PLANE	//Will show up through the cone.
			if(!ispath(private, /datum/patron/old_god))
				for(var/mob/living/carbon/human/H in viewers(world.view, src))
					var/pass = FALSE
					if(H.patron?.type == private || private == /datum/patron/divine/xylix)	//Xylixians will always flash the observer's religion to them.
						vis_contents += new /obj/effect/temp_visual/stress_event/invisible(null, H, icon_path, "sign_[H.patron.name]", offset_list, y_offset, icon_plane)
						pass = TRUE
					if(ispath(private, /datum/patron/divine/undivided)) // All Divine worshippers will see UNDIVIDED symbol
						if((ispath(H.patron?.type, /datum/patron/divine)))
							vis_contents += new /obj/effect/temp_visual/stress_event/invisible(null, H, icon_path, "sign_[patron.name]", offset_list, y_offset, icon_plane)
					else if(HAS_TRAIT(H, TRAIT_HERETIC_SEER) && istype(private,/datum/patron/inhumen))	//Seers should see all inhumen symbols.
						vis_contents += new /obj/effect/temp_visual/stress_event/invisible(null, H, icon_path, "sign_[patron?.name]", offset_list, y_offset, icon_plane)
						pass = TRUE
					if(soundin && pass)
						var/turf/T = get_turf(src)
						H.playsound_local(T, soundin, 100, FALSE) 
			else
				for(var/mob/living/carbon/human/H in viewers(world.view, src))
					if(H.patron?.type == private)
						if(HAS_TRAIT(H, TRAIT_INQUISITION) && HAS_TRAIT(src, TRAIT_INQUISITION))	//Inquisition members will show a fancier symbol to one another.
							vis_contents += new /obj/effect/temp_visual/stress_event/invisible(null, H, icon_path, "sign_[H.patron.name]inq", offset_list, y_offset, icon_plane)
						else 
							vis_contents += new /obj/effect/temp_visual/stress_event/invisible(null, H, icon_path, "sign_[H.patron.name]", offset_list, y_offset, icon_plane)
						if(soundin)
							var/turf/T = get_turf(src)
							H.playsound_local(T, soundin, 100, FALSE) 

///A simplified version of the proc that adds an overlay to the src and returns a reference to the appearance.
///Has no offset adjustment for bodies / sprite size. Make sure to account for that if using it on carbons!
/mob/living/proc/play_overhead_indicator_simple(icon_path, overlay_name, clear_time, overlay_layer = ABOVE_MOB_LAYER, soundin = null, y_offset = 0, x_offset = 0)
	var/mutable_appearance/appearance = mutable_appearance(icon_path, overlay_name, overlay_layer)
	appearance.pixel_x += x_offset
	appearance.pixel_y += y_offset
	appearance.appearance_flags = RESET_COLOR
	overlays_standing[overlay_layer] = appearance
	apply_overlay(overlay_layer)
	if(clear_time > 0)	//< 0 means it's likely meant to be infinite (-1), 0 means, uh, that something went wrong.
		addtimer(CALLBACK(src, PROC_REF(clear_overhead_indicator), appearance, overlay_layer), clear_time)
	if(soundin)
		playsound(src, soundin, 100, FALSE, extrarange = -1, ignore_walls = FALSE)
	return appearance

///Flick variant that returns something that can be animated after being made.
/mob/living/proc/play_overhead_indicator_flick(icon_path, overlay_name, clear_time, overlay_layer = ABOVE_MOB_LAYER, soundin = null, y_offset = 0, x_offset = 0)
	var/mutable_appearance/appearance = mutable_appearance(icon_path, overlay_name, overlay_layer)
	appearance.pixel_x += x_offset
	appearance.pixel_y += y_offset
	appearance.appearance_flags = RESET_COLOR
	var/atom/visual = flick_overlay_view(appearance, clear_time)
	if(soundin)
		playsound(src, soundin, 100, FALSE, extrarange = -1, ignore_walls = FALSE)
	return visual

/obj/effect/temp_visual/stress_event
	icon = 'icons/mob/overhead_effects.dmi'
	duration = 20

/obj/effect/temp_visual/stress_event/invisible
	icon_state = null

/obj/effect/temp_visual/stress_event/invisible/Initialize(mapload, mob/seer, path, iname, list/offsets, y_offset = 12, plane)
	. = ..()
	var/image/I = image(icon = path, icon_state = iname, layer = ABOVE_MOB_LAYER, loc = src)
	I.alpha = 255
	if(plane)
		I.plane = plane
	I.appearance_flags = RESET_ALPHA
	if(offsets)
		I.pixel_x += (offsets[1])
		I.pixel_y += (offsets[2]+y_offset)
	add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/onePerson, iname, I, seer)

/mob/living/proc/clear_overhead_indicator(appearance, layer = OBJ_LAYER)
	remove_overlay(layer)
	cut_overlay(appearance, TRUE)
	qdel(appearance)
	update_icon()
	update_overlays()
	return

/mob/living/proc/play_stress_indicator()
	play_overhead_indicator('icons/mob/overhead_effects.dmi', "stress", 15, OBJ_LAYER, private = TRAIT_EMPATH, soundin = 'sound/ddstress.ogg')

/mob/living/proc/play_relief_indicator()
	play_overhead_indicator('icons/mob/overhead_effects.dmi', "relief", 15, OBJ_LAYER, private = TRAIT_EMPATH, soundin = 'sound/ddrelief.ogg')

/mob/living/proc/play_mental_break_indicator()
	play_overhead_indicator('icons/mob/overhead_effects.dmi', "mentalbreak", 20, OBJ_LAYER)
	playsound(src, 'sound/stressaffliction.ogg', 100, FALSE, ignore_walls = FALSE)
