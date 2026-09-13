// Base type for stone throwing abilities for trolls
/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock
	abstract_type = /datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock
	blade_class = BCLASS_BLUNT
	strike_armor_pen = PEN_NONE
	impact_delay = 4
	detonate_sound = null
	vuln_on_hit = 6 SECONDS
	/// Visual lobbed at the marked turf. Purely cosmetic.
	var/rock_type
	var/list/impact_sound

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock/do_blade_animation(mob/living/H, facing)
	if(!rock_type || !locked_turf)
		return
	var/obj/effect/temp_visual/rock = new rock_type(get_turf(H))
	animate(rock, pixel_x = (locked_turf.x - H.x) * 32, pixel_y = (locked_turf.y - H.y) * 32, time = impact_delay)
	return rock

/datum/action/cooldown/spell/telegraphed_strike/mob_ability/ground/hurled_rock/on_impact(mob/living/H, facing, atom/movable/visual)
	if(!QDELETED(visual))
		visual.forceMove(locked_turf)
		visual.pixel_x = 0
		visual.pixel_y = 0
	if(length(impact_sound))
		playsound(locked_turf, impact_sound, 100, TRUE)
