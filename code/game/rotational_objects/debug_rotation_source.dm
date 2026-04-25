/obj/structure/debug_rotation_source
	name = "debug rotation source"
	desc = "Dev test power source. Outputs 32RPM."
	icon = 'icons/obj/rotation_machines.dmi'
	icon_state = "gearbox"
	anchored = TRUE
	density = TRUE
	rotation_structure = TRUE
	stress_generator = TRUE
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_FLIP

/obj/structure/debug_rotation_source/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_REQUIRE_WRENCH|ROTATION_IGNORE_ANCHORED)

/obj/structure/debug_rotation_source/find_rotation_network()
	. = ..()
	setup_rotation()

/obj/structure/debug_rotation_source/proc/setup_rotation()
	last_stress_generation = 0
	set_stress_generation(1024)
	set_rotational_direction_and_speed(EAST, 32)
	return TRUE

/obj/structure/debug_rotation_source/update_animation_effect()
	if(!rotation_network || rotation_network?.overstressed || !rotation_network?.total_stress)
		return
	icon_state = "gearbox"
