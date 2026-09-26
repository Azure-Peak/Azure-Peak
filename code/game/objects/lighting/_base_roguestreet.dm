/obj/machinery/light/roguestreet
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	desc = "An ancient device once used across the realms to light roads and cities. A manner of \
	artifice no longer common in all but the deepest and most forgotten parts of the world. It \
	occasionally flickers with a spark of some bright energy."
	icon_state = "slamp1"
	base_state = "slamp"
	brightness = LIGHT_RANGE_BRAZIER
	//nightshift_allowed = FALSE
	fueluse = 0
	bulb_colour = LIGHT_COLOR_TUNGSTEN
	bulb_power = LIGHT_POWER_BASE
	max_integrity = 0
	pass_flags = LETPASSTHROW

/obj/machinery/light/roguestreet/midlamp
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "midlamp1"
	base_state = "midlamp"
	pixel_x = -16
	density = TRUE

/obj/machinery/light/roguestreet/proc/lights_out()
	on = FALSE
	set_light(0)
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(lights_on)), 5 MINUTES)

/obj/machinery/light/roguestreet/proc/lights_on()
	on = TRUE
	update()
	update_icon()

/obj/machinery/light/roguestreet/update_icon()
	if(on)
		icon_state = "[base_state]1"
	else
		icon_state = "[base_state]0"

/obj/machinery/light/roguestreet/update()
	. = ..()
	if(on)
		GLOB.fires_list |= src
	else
		GLOB.fires_list -= src

/obj/machinery/light/roguestreet/Initialize(mapload)
	lights_on()
	GLOB.streetlamp_list += src
	update_icon()
	. = ..()

/obj/machinery/light/roguestreet/update_icon()
	if(on)
		icon_state = "[base_state]1"
	else
		icon_state = "[base_state]0"

/obj/machinery/light/oldlight
	name = "ancyent lightbar"
	desc = "Two frustrums hold a glaring death-light. Solid and unyielding."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "celestial_light"
	brightness = LIGHT_RANGE_BRAZIER
	bulb_power = LIGHT_POWER_BASE
	bulb_colour = LIGHT_COLOR_RED
	light_color = LIGHT_COLOR_RED
	max_integrity = 0
	fueluse = 0
	light_on = 1
	light_outer_range = LIGHT_RANGE_FIRE + 1
	light_power = LIGHT_POWER_BASE*2

/obj/machinery/light/oldlight/proc/lights_out()
	on = FALSE
	set_light(0)
	update_icon()
	addtimer(CALLBACK(src, PROC_REF(lights_on)), 5 MINUTES)

/obj/machinery/light/oldlight/proc/lights_on()
	on = TRUE
	update()
	update_icon()

/obj/machinery/light/oldlight/update_icon()
	if(on)
		icon_state = "celestial_light"
	else
		icon_state = "celestial_light"

/obj/machinery/light/oldlight/update()
	. = ..()
	if(on)
		GLOB.fires_list |= src
	else
		GLOB.fires_list -= src

/obj/machinery/light/oldlight/Initialize(mapload)
	lights_on()
	GLOB.streetlamp_list += src
	update_icon()
	. = ..()
