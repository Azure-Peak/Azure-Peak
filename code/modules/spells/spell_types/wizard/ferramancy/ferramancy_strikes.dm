/datum/action/cooldown/spell/ferramancy_strike
	parent_type = /datum/action/cooldown/spell/telegraphed_strike
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	sound = 'sound/magic/scrapeblade.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_FERRAMANCY

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_AOE

	cooldown_time = 15 SECONDS
	shared_cooldown = "ferramancy_strike"
	shared_cooldown_mult = 0.5
	charging_slowdown = 1

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	telegraph_type = /obj/effect/temp_visual/trap/ferramancy

/datum/action/cooldown/spell/ferramancy_strike/falling_crescent
	name = "Falling Crescent"
	desc = "Wind up a greatsword's edge, then sweep a wide arc across the tiles in front of you, cleaving everything in reach right to left. You are slowed and left wide open as you wind it up, but once begun it cannot be stopped - only stepped clear of. This strike can be defended against, but not parried or dodged.\n\n\
	Deals 65 brute damage to everything caught in the arc."
	button_icon_state = "falling_crescent"
	invocations = list("Acies Lunata!")
	blade_class = BCLASS_CUT
	windup_time = TELEGRAPH_HIGH_IMPACT
	sweep_step = 0
	damage = 65
	swipe_state = "chop"

/datum/action/cooldown/spell/ferramancy_strike/falling_crescent/get_sweep_bands()
	return list(
		list(list(1, 0), list(1, 1), list(1, 2)),
		list(list(0, 1), list(0, 2), list(0, 3)),
		list(list(-1, 0), list(-1, 1), list(-1, 2)),
	)

/datum/action/cooldown/spell/ferramancy_strike/falling_crescent/get_pattern_offsets()
	var/list/flat = list()
	for(var/list/band in get_sweep_bands())
		flat += band
	return flat

/datum/action/cooldown/spell/ferramancy_strike/sorcerers_lance
	name = "Sorcerer's Lance"
	desc = "Wind up a couched lance, then drive it forward in a straight line, skewering everything up to five tiles ahead. You are slowed and left wide open as you wind it up, but once begun it cannot be stopped - only stepped clear of. This strike can be defended against, but not parried or dodged.\n\n\
	Deals 35 brute damage to everything caught in the line, piercing through even heavy armor."
	button_icon_state = "sorcerers_lance"
	invocations = list("Hasta Perforans!")
	blade_class = BCLASS_STAB
	strike_armor_pen = PEN_HEAVY
	windup_time = 8
	stop_at_dense = TRUE
	damage = 35
	var/line_length = 5

/datum/action/cooldown/spell/ferramancy_strike/sorcerers_lance/get_pattern_offsets()
	var/list/offsets = list()
	for(var/i in 1 to line_length)
		offsets += list(list(0, i))
	return offsets

/datum/action/cooldown/spell/ferramancy_strike/sorcerers_lance/do_blade_animation(mob/living/carbon/human/H, facing)
	var/reach = stop_at_dense ? max(1, forward_reach(H, facing, line_length)) : line_length
	var/obj/effect/temp_visual/ferramancy_blade/blade = new(null)
	blade.vis_holder = H
	H.vis_contents += blade
	var/matrix/m = matrix()
	m.Scale(1, max(2, reach))
	m.Turn(facing_position_angle(facing))
	blade.transform = m
	blade.alpha = 220
	var/px = 0
	var/py = 0
	switch(facing)
		if(NORTH)
			py = reach * 16
		if(SOUTH)
			py = -reach * 16
		if(EAST)
			px = reach * 16
		if(WEST)
			px = -reach * 16
	var/dur = max(2, (reach - 1) * sweep_step)
	animate(blade, pixel_x = px, pixel_y = py, time = dur, easing = SINE_EASING)
	animate(alpha = 0, time = 2)
	QDEL_IN(blade, dur + 4)
	return blade

/datum/action/cooldown/spell/ferramancy_strike/heavens_hammer
	name = "Heaven's Hammer"
	desc = "Heave a conjured maul overhead, then bring it crashing down on the ground before you, leaving any struck reeling and vulnerable. This strike can be defended against, but not parried or dodged.\n\n\
	Deals 50 brute damage and applies Vulnerable to everything in the smash."
	button_icon_state = "hammer_of_heaven"
	invocations = list("Malleus Caeli!")
	blade_class = BCLASS_BLUNT
	windup_time = TELEGRAPH_AREA_DENIAL
	damage = 50
	sweep_step = 0
	impact_delay = 4
	detonate_sound = null
	vuln_on_hit = 3 SECONDS
	var/hammer_scale = 1.9

/datum/action/cooldown/spell/ferramancy_strike/heavens_hammer/get_pattern_offsets()
	return list(
		list(-1, 1), list(0, 1), list(1, 1),
		list(-1, 2), list(0, 2), list(1, 2),
		list(-1, 3), list(0, 3), list(1, 3),
	)

/datum/action/cooldown/spell/ferramancy_strike/heavens_hammer/do_blade_animation(mob/living/carbon/human/H, facing)
	var/obj/effect/temp_visual/ferramancy_hammer/hammer = new(null)
	hammer.vis_holder = H
	H.vis_contents += hammer
	var/rest_y = round(6.5 * hammer_scale - 4)
	var/fwd_x = 0
	var/fwd_y = 0
	switch(facing)
		if(NORTH)
			fwd_y = 64
		if(SOUTH)
			fwd_y = -64
		if(EAST)
			fwd_x = 64
		if(WEST)
			fwd_x = -64
	var/matrix/upright = matrix()
	upright.Scale(hammer_scale)
	upright.Turn(180)
	var/matrix/airborne = matrix()
	airborne.Scale(hammer_scale, hammer_scale * 1.4)
	airborne.Turn(180)
	hammer.transform = airborne
	hammer.pixel_x = fwd_x
	hammer.pixel_y = fwd_y + rest_y + 176
	hammer.alpha = 0
	animate(hammer, pixel_y = fwd_y + rest_y, transform = upright, time = impact_delay, easing = CUBIC_EASING | EASE_IN)
	animate(hammer, alpha = 255, time = 1, flags = ANIMATION_PARALLEL)
	return hammer

/datum/action/cooldown/spell/ferramancy_strike/heavens_hammer/on_impact(mob/living/carbon/human/H, facing, atom/movable/visual)
	var/turf/T = get_step(get_turf(H), facing) || get_turf(H)
	if(!T)
		return
	playsound(T, pick('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg'), 90, TRUE, 4)
	playsound(T, 'sound/magic/repulse.ogg', 55, TRUE, 3)
	for(var/mob/M in range(5, T))
		shake_camera(M, 2, 1)
	new /obj/effect/temp_visual/spell_impact(T, spell_color, SPELL_IMPACT_HIGH)
	if(QDELETED(visual))
		return
	var/rest = visual.pixel_y
	animate(visual, pixel_y = rest + 4, time = 1, easing = SINE_EASING | EASE_OUT)
	animate(pixel_y = rest, time = 1, easing = SINE_EASING | EASE_IN)
	animate(alpha = 0, time = 3)

/obj/effect/temp_visual/ferramancy_blade
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "air_blade_stab"
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = 3 SECONDS
	randomdir = FALSE
	var/atom/movable/vis_holder

/obj/effect/temp_visual/ferramancy_blade/Destroy()
	if(vis_holder && !QDELETED(vis_holder))
		vis_holder.vis_contents -= src
	vis_holder = null
	return ..()

/obj/effect/temp_visual/ferramancy_hammer
	icon = 'icons/mob/actions/mage_ferramancy.dmi'
	icon_state = "hammer_of_heaven"
	layer = ABOVE_ALL_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	duration = 1.5 SECONDS
	randomdir = FALSE
	var/atom/movable/vis_holder

/obj/effect/temp_visual/ferramancy_hammer/Destroy()
	if(vis_holder && !QDELETED(vis_holder))
		vis_holder.vis_contents -= src
	vis_holder = null
	return ..()

/obj/effect/temp_visual/trap
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	duration = 12
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/trap/ferramancy
	color = GLOW_COLOR_METAL
	light_color = GLOW_COLOR_METAL
	duration = 3 SECONDS

/obj/effect/temp_visual/blade_burst
	icon = 'icons/effects/wizard_spell_effects.dmi'
	icon_state = "grassblade"
	dir = NORTH
	name = "arcyne blade"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER
