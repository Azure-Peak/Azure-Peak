/obj/effect/temp_visual/heal_rogue //color is white by default, set to whatever is needed
	name = "healing glow"
	icon = 'icons/effects/miracle-healing.dmi'
	icon_state = "heal_pantheon"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/heal_rogue/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	alpha = 180
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/obj/effect/temp_visual/psyheal_rogue //color is white by default, set to whatever is needed
	name = "enduring glow"
	icon = 'icons/effects/miracle-healing.dmi'
	icon_state = "heal_psycross"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/psyheal_rogue/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	alpha = 180
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/obj/effect/temp_visual/heal_blood
	name = "bloodheal glow"
	icon = 'icons/effects/miracle-healing.dmi'
	icon_state = "heal_blood"
	duration = 15
	plane = GAME_PLANE_UPPER
	layer = ABOVE_ALL_MOB_LAYER

/obj/effect/temp_visual/heal_blood/Initialize(mapload, set_color)
	if(set_color)
		add_atom_colour(set_color, FIXED_COLOUR_PRIORITY)
	. = ..()
	alpha = 180
	pixel_x = rand(-12, 12)
	pixel_y = rand(-9, 0)

/obj/effect/temp_visual/heal_rogue/campfire
	name = "campfire heal"
	icon_state = "heal_campfire"
