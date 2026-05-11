/obj/effect/spell_rune_under
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "rune"
	vis_flags = NONE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -8
	pixel_y = -8
	var/datum/weakref/mob_ref
	var/original_color

/obj/effect/spell_rune_under/Initialize(mapload, mob/target_mob, spell_color = "#FFFFFF")
	. = ..()
	original_color = spell_color
	color = spell_color
	mob_ref = WEAKREF(target_mob)

/obj/effect/spell_rune_under/Destroy(force)
	if(mob_ref)
		var/mob/holder = mob_ref.resolve()
		if(holder)
			holder.vis_contents -= src
		mob_ref = null
	return ..()

/obj/effect/temp_visual/wave_up
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "wave_up"
	vis_flags = NONE
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_x = -8
	pixel_y = -8
	duration = 1.8 SECONDS
	randomdir = FALSE
	var/datum/weakref/mob_ref

/obj/effect/temp_visual/wave_up/Initialize(mapload, mob/target_mob)
	. = ..()
	mob_ref = WEAKREF(target_mob)

/obj/effect/temp_visual/wave_up/Destroy(force)
	if(mob_ref)
		var/mob/holder = mob_ref.resolve()
		if(holder)
			holder.vis_contents -= src
		mob_ref = null
	return ..()

/obj/effect/temp_visual/particle_up
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "particle_up"
	vis_flags = NONE
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	pixel_y = -8
	duration = 3.8 SECONDS
	randomdir = FALSE
	var/datum/weakref/mob_ref

/obj/effect/temp_visual/particle_up/Initialize(mapload, mob/target_mob, obj/effect/spell_rune_under/rune)
	. = ..()
	mob_ref = WEAKREF(target_mob)
	if(rune)
		RegisterSignal(rune, COMSIG_PARENT_QDELETING, PROC_REF(clean_up))

/obj/effect/temp_visual/particle_up/Destroy(force)
	if(mob_ref)
		var/mob/holder = mob_ref.resolve()
		if(holder)
			holder.vis_contents -= src
		mob_ref = null
	return ..()

/obj/effect/temp_visual/particle_up/proc/clean_up()
	SIGNAL_HANDLER

	qdel(src)

// ---- Spell Impact Effects ----
// Universal on-hit light flash for spell impacts. Intensity scales light range.
// Usage: new /obj/effect/temp_visual/spell_impact(get_turf(target), impact_color, intensity)

/obj/effect/temp_visual/spell_impact
	icon = 'icons/effects/spell_cast.dmi'
	icon_state = "particle_up"
	layer = ABOVE_ALL_MOB_LAYER
	duration = 1 SECONDS
	randomdir = FALSE
	light_outer_range = 3
	light_color = "#FFFFFF"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/obj/effect/temp_visual/spell_impact/Initialize(mapload, impact_color = "#FFFFFF", intensity = SPELL_IMPACT_LOW)
	. = ..()
	color = impact_color
	light_color = impact_color

	switch(intensity)
		if(SPELL_IMPACT_LOW)
			light_outer_range = 3
		if(SPELL_IMPACT_MEDIUM)
			light_outer_range = 5
		if(SPELL_IMPACT_HIGH)
			light_outer_range = 7
