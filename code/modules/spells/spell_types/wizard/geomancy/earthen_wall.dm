
/datum/action/cooldown/spell/earthen_wall
	button_icon = 'icons/mob/actions/mage_geomancy.dmi'
	name = "Earthen Wall"
	desc = "Conjure a 3x1 wall of stone at a target location, perpendicular to your facing. \
	The wall blocks movement and line of sight."
	button_icon_state = "earthen_wall"
	sound = 'sound/combat/hits/onstone/wallhit.ogg'
	spell_color = GLOW_COLOR_EARTHEN
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Murus Terrae!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_NONE

	var/wall_width = 3
	var/telegraph_time = 3 SECONDS
	var/wall_duration = 10 SECONDS

/datum/action/cooldown/spell/earthen_wall/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE

	var/list/affected_turfs = get_wall_turfs(center, H.dir)

	for(var/turf/T in affected_turfs)
		new /obj/effect/temp_visual/trap_wall/earth(T)

	H.visible_message(span_danger("[H] begins to conjure a wall of stone!"))
	playsound(get_turf(H), 'sound/combat/hits/onstone/wallhit.ogg', 60, TRUE)

	addtimer(CALLBACK(src, PROC_REF(spawn_walls), affected_turfs), telegraph_time)
	return TRUE

/datum/action/cooldown/spell/earthen_wall/proc/get_wall_turfs(turf/center, facing)
	var/list/turfs = list(center)
	var/spread_dir1
	var/spread_dir2
	if(facing == NORTH || facing == SOUTH)
		spread_dir1 = WEST
		spread_dir2 = EAST
	else
		spread_dir1 = NORTH
		spread_dir2 = SOUTH

	var/half = (wall_width - 1) / 2
	var/turf/current = center
	for(var/i in 1 to half)
		current = get_step(current, spread_dir1)
		if(current)
			turfs += current
	current = center
	for(var/i in 1 to half)
		current = get_step(current, spread_dir2)
		if(current)
			turfs += current
	return turfs

/datum/action/cooldown/spell/earthen_wall/proc/spawn_walls(list/turfs)
	if(QDELETED(src) || QDELETED(owner))
		return
	for(var/turf/T in turfs)
		var/obj/structure/earthen_wall/W = new(T)
		W.timeleft = wall_duration
	playsound(turfs[1], 'sound/combat/hits/onstone/stonedeath.ogg', 100, TRUE, 5)
	owner.visible_message(span_danger("[owner] conjures a wall of stone!"))

/obj/effect/temp_visual/trap_wall/earth
	color = GLOW_COLOR_EARTHEN
	light_color = GLOW_COLOR_EARTHEN
	duration = 3 SECONDS
