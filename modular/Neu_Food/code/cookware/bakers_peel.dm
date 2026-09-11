/datum/component/storage/concrete/tray/peel
	insert_verb = "slide"
	insert_preposition = "on"
	max_items = 6
	screen_max_rows = 1
	screen_max_columns = 6
	allow_quick_empty = FALSE

/datum/intent/use/peel
	name = "use"
	reach = 2

/obj/item/storage/bag/tray/peel
	name = "baker's peel"
	desc = "A long wooden paddle used by bakers to put food into and take food out of the oven."
	icon = 'modular/Neu_Food/icons/cookware/bakers_peel.dmi'
	icon_state = "bakerspeel0"
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE
	wlength = WLENGTH_LONG
	component_type = /datum/component/storage/concrete/tray/peel
	gripped_intents = list(/datum/intent/use/peel)
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	grid_width = 32
	grid_height = 96
	bigboy = TRUE
	force = 10
	force_wielded = 10
	throwforce = 0
	sharpness = IS_BLUNT
	associated_skill = /datum/skill/craft/cooking
	var/peel_item_scale = 0.45
	var/peel_ground_x = 30
	var/peel_ground_y = 30
	var/peel_ground_spacing_x = 2
	var/peel_ground_spacing_y = -2
	var/peel_held_x = 36
	var/peel_held_y = 14
	var/peel_held_spacing_x = 2
	var/peel_held_spacing_y = 0

/obj/item/storage/bag/tray/peel/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("It can be carried in one hand, but it must be wielded in both to be used.")
	. += span_info("Wielded, it reaches ovens and tables up to two tiles away.")

/obj/item/storage/bag/tray/peel/pre_attack(atom/A, mob/living/user, params)
	if(!wielded)
		to_chat(user, span_warning("I need both hands on [src] to use it."))
		return TRUE
	return ..()

/obj/item/storage/bag/tray/peel/update_transform()
	. = ..()
	icon_state = ismob(loc) ? "bakerspeel1" : "bakerspeel0"
	update_icon()

/obj/item/storage/bag/tray/peel/update_icon()
	for(var/obj/dummy in tray_display_dummies)
		qdel(dummy)
	tray_display_dummies = list()
	vis_contents = list()

	var/count = length(contents)
	if(!count)
		return

	var/held = ismob(loc)
	var/base_x = held ? peel_held_x : peel_ground_x
	var/base_y = held ? peel_held_y : peel_ground_y
	var/step_x = held ? peel_held_spacing_x : peel_ground_spacing_x
	var/step_y = held ? peel_held_spacing_y : peel_ground_spacing_y

	var/index = 0
	for(var/obj/item/thing_in_tray in contents)
		var/obj/dummy = new()
		dummy.appearance = thing_in_tray.appearance
		dummy.underlays = null
		dummy.vis_contents = thing_in_tray.vis_contents
		var/matrix/shrink = matrix()
		shrink.Scale(peel_item_scale, peel_item_scale)
		dummy.transform = shrink
		var/spread = index - (count - 1) / 2
		dummy.pixel_x = base_x + round(spread * step_x, 1)
		dummy.pixel_y = base_y + round(spread * step_y, 1)
		dummy.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE

		tray_display_dummies += dummy
		vis_contents += dummy
		index++
