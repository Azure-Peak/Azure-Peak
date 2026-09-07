/// The output is halved for every z-level the windmill sits below the top.
#define WINDMILL_TOP_RPM_MAX 16
/// Stress a spinning windmill feeds into its rotation network.
#define WINDMILL_STRESS_GENERATION 256

/obj/structure/windmill
	name = "windmill"
	desc = "A squat wooden mill crowned with broad canvas sails. Given open sky and a steady wind, it turns the machinery linked below it."
	icon = 'icons/roguetown/misc/windmill.dmi'
	icon_state = "1"
	// Tall 2-tile sprite: render on the upper game plane so anyone standing in the overhang tile
	// passes behind the mill instead of on top of it.
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	density = TRUE
	anchored = TRUE
	stress_generator = TRUE
	rotation_structure = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_FLIP
	/// RPM produced on the top z-level before per-level falloff. Rolled once on Initialize so a network's speed stays stable.
	var/base_rpm = 0
	/// Direction of rotation output (EAST spins clockwise, WEST counter-clockwise).
	var/spin_dir = EAST

/obj/structure/windmill/Initialize(mapload, ...)
	. = ..()
	base_rpm = WINDMILL_TOP_RPM_MAX

/obj/structure/windmill/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Place it somewhere with a clear view of the sky - a roof or an upper floor stops it catching the wind.")
	. += span_info("It spins fastest on the highest level; the wind weakens, halving its output, for each z-level it sits below the top.")
	. += span_info("Middle-click it with an engineering wrench to disassemble it.")

/obj/structure/windmill/find_rotation_network()
	. = ..()
	setup_rotation()

/// Roll the effective RPM for our position and, if we can catch the wind, drive the network.
/obj/structure/windmill/proc/setup_rotation()
	var/turf/our_turf = get_turf(src)
	last_stress_generation = 0
	// Needs an unobstructed column to the sky - the exact same check the weather/fog system uses.
	if(!our_turf?.is_sky_visible())
		stall()
		return FALSE
	var/effective_rpm = get_effective_rpm(our_turf)
	if(effective_rpm < 1) // sitting so deep the halving leaves nothing usable
		stall()
		return FALSE
	set_stress_generation(WINDMILL_STRESS_GENERATION)
	set_rotational_direction_and_speed(spin_dir, effective_rpm)
	return TRUE

/// Cut generation and stop the sails - used when we can't see the sky or the wind falloff is total.
/obj/structure/windmill/proc/stall()
	if(rotation_network)
		set_stress_generation(0)
		set_rotational_speed(0)

/// Base RPM halved once for every z-level between us and the top of the z-stack.
/obj/structure/windmill/proc/get_effective_rpm(turf/our_turf)
	var/depth = 0
	var/turf/checking = our_turf
	var/turf/above = GET_TURF_ABOVE(checking)
	while(above)
		depth++
		checking = above
		above = GET_TURF_ABOVE(checking)
	return round(base_rpm / (2 ** depth))

/obj/structure/windmill/proc/has_active_rotation()
	return rotation_network && !rotation_network?.overstressed && rotations_per_minute && rotation_network?.total_stress

/obj/structure/windmill/update_animation_effect()
	if(!has_active_rotation())
		animate(src, icon_state = "1", time = 1)
		return
	var/frame_stage = 1 / ((rotations_per_minute / 60) * 8)
	if(rotation_direction == WEST)
		animate(src, icon_state = "1", time = frame_stage, loop = -1)
		animate(icon_state = "2", time = frame_stage)
		animate(icon_state = "3", time = frame_stage)
		animate(icon_state = "4", time = frame_stage)
		animate(icon_state = "5", time = frame_stage)
		animate(icon_state = "6", time = frame_stage)
		animate(icon_state = "7", time = frame_stage)
		animate(icon_state = "8", time = frame_stage)
	else
		animate(src, icon_state = "8", time = frame_stage, loop = -1)
		animate(icon_state = "7", time = frame_stage)
		animate(icon_state = "6", time = frame_stage)
		animate(icon_state = "5", time = frame_stage)
		animate(icon_state = "4", time = frame_stage)
		animate(icon_state = "3", time = frame_stage)
		animate(icon_state = "2", time = frame_stage)
		animate(icon_state = "1", time = frame_stage)

#undef WINDMILL_TOP_RPM_MAX
#undef WINDMILL_STRESS_GENERATION
