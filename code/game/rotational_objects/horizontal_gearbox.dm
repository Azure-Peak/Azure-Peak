/obj/structure/gearbox
	name = "gearbox"
	icon = 'icons/obj/rotation_machines.dmi'
	icon_state = "gearbox-horizontal"

	rotation_structure = TRUE
	stress_use = 12
	initialize_dirs = CONN_DIR_FORWARD | CONN_DIR_LEFT | CONN_DIR_RIGHT | CONN_DIR_FLIP

/obj/structure/gearbox/Initialize(mapload, ...)
	. = ..()
	AddComponent(/datum/component/simple_rotation, ROTATION_REQUIRE_WRENCH|ROTATION_IGNORE_ANCHORED)

/obj/structure/gearbox/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Redirects rotation through horizontal connection points, letting one line feed multiple directions on the same level.")
	. += span_info("Middle-click it with an engineering wrench to disassemble it.")
