// Shared visual types for Fulgurmancy spells (Thunderstrike, Heaven's Strike telegraphs)

/obj/effect/temp_visual/trap/thunderstrike
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	duration = 4
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/trap/thunderstrike/layer_one
	duration = 8

/obj/effect/temp_visual/trap/thunderstrike/layer_two
	duration = 12

/obj/effect/temp_visual/thunderstrike_actual
	icon = 'icons/effects/32x96.dmi'
	icon_state = "lightning"
	light_outer_range = 2
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/trap/thunderstrike/Initialize(mapload, duration_override)
	if(duration_override)
		duration = duration_override
	. = ..()
