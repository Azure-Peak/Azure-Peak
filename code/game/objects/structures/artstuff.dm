/obj/item/canvas
	name = "canvas"
	desc = "A perfect place to paint"

	icon = 'icons/roguetown/items/paint_supplies/canvas_32.dmi'
	icon_state = "canvas"

	var/easel_offset = 9
	var/canvas_size_x = 32
	var/canvas_size_y = 32

	var/atom/movable/screen/canvas/used_canvas
	var/list/showers = list()

	var/icon/draw
	var/icon/base

	var/title
	var/author
	var/author_ckey

	var/canvas_icon = 'icons/roguetown/items/paint_supplies/canvas_32x32.dmi'
	var/canvas_icon_state = "canvas"
	var/canvas_screen_loc = "6,6"
	var/canvas_divider_x = 5
	var/canvas_divider_y = 5

	var/list/modified_areas = list()
	var/list/overlay_to_index = list()
	var/current_overlays = 0

/obj/item/canvas/Initialize()
	. = ..()
	draw = icon(icon, icon_state)
	base = icon(icon, icon_state)
	underlays += base
	icon = draw
	used_canvas = new
	used_canvas.setup(src)
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(remove_showers))

/obj/item/canvas/Destroy()
	remove_showers()
	if(used_canvas)
		used_canvas.host = null
		QDEL_NULL(used_canvas)
	return ..()

/obj/item/canvas/pickup(mob/user)
	. = ..()
	remove_showers()

/obj/item/canvas/get_mechanics_examine(mob/user)
	. = ..()

	. += span_info("Click left-mouse button to toggle drawing mode, then move or drag the mouse across the canvas.")
	. += span_info("Click right-mouse button to toggle erase mode.")
	. += span_info("Click alt+left-mouse button to toggle shade adjustment mode.")
	. += span_info("Click ctrl+left-mouse button to pick colour.")

/obj/item/canvas/attack_hand(mob/user)
	. = ..()
	if(user.cmode)
		return
	if(!anchored)
		return

	to_chat(user, "You start unmounting [src]")
	if(!do_after(user, 3 SECONDS, target = src))
		return
	anchored = FALSE
	to_chat(user, "You unmount [src]")

/obj/item/canvas/attack_right(mob/user)
	. = ..()
	if(user.get_active_held_item())
		return
	add_shower(user)

/obj/item/canvas/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/natural/feather))
		var/new_author = stripped_input(user, "Who's the author of this painting?", "Painting")
		var/new_title = stripped_input(user, "What's the title of this painting.", "Painting")
		author_ckey = user.ckey
		if(new_author)
			author = new_author
			desc = "Painted by: [author]."
		if(new_title)
			title = new_title
			name = title
		return

	if(!istype(I, /obj/item/paint_brush))
		return
	add_shower(user)

/obj/item/canvas/proc/add_shower(mob/user)
	if(!user?.client)
		return
	if(user in showers)
		return
	user.client.screen += used_canvas
	showers |= user
	RegisterSignal(user, list(COMSIG_MOVABLE_TURF_ENTERED, COMSIG_PARENT_QDELETING), PROC_REF(remove_shower))

/obj/item/canvas/proc/remove_showers()
	SIGNAL_HANDLER
	for(var/mob/mob as anything in showers.Copy())
		remove_shower(mob)

/obj/item/canvas/attack_turf(turf/T, mob/living/user)
	. = ..()
	to_chat(user, "You start mounting [src] to [T]")
	if(!do_after(user, 3 SECONDS, target = T))
		return
	forceMove(T)
	pixel_x = 0
	pixel_y = 0
	anchored = TRUE
	to_chat(user, "You mount [src] to [T]")

/obj/item/canvas/proc/remove_shower(mob/source)
	SIGNAL_HANDLER
	showers -= source
	source.client?.screen -= used_canvas
	UnregisterSignal(source, list(COMSIG_MOVABLE_TURF_ENTERED, COMSIG_PARENT_QDELETING))
	used_canvas?.painter_states -= source

/obj/item/canvas/proc/update_drawing(x, y, current_color)
	var/key = "[x],[y]"
	var/mutable_appearance/old = overlay_to_index[key]
	if(old)
		cut_overlay(old)
	var/mutable_appearance/MA = mutable_appearance('icons/roguetown/items/paint_supplies/pixel.dmi', "pixel")
	MA.color = current_color
	MA.pixel_x = x
	MA.pixel_y = y
	add_overlay(MA)
	overlay_to_index[key] = MA
	if(!old)
		current_overlays++
	if(current_overlays > 150)
		flatten()

/// caller is responsible for reassigning icon after a batch of erases
/obj/item/canvas/proc/erase_cell(x, y, was_painted)
	var/key = "[x],[y]"
	var/mutable_appearance/MA = overlay_to_index[key]
	if(MA)
		cut_overlay(MA)
		overlay_to_index -= key
		current_overlays = max(current_overlays - 1, 0)
	if(was_painted)
		draw.DrawBox(null, x + 1, y + 1)

/// bakes the pending pixel overlays into the item's icon server-side
/obj/item/canvas/proc/flatten()
	for(var/key in overlay_to_index)
		var/cell_color = modified_areas[key]
		if(!cell_color)
			continue
		var/list/coords = splittext(key, ",")
		draw.DrawBox(cell_color, text2num(coords[1]) + 1, text2num(coords[2]) + 1)
	icon = draw
	cut_overlays()
	overlay_to_index = list()
	current_overlays = 0

/atom/movable/screen/canvas
	icon = 'icons/roguetown/items/paint_supplies/canvas_32x32.dmi'
	icon_state = "canvas"
	screen_loc = "6,6"

	var/obj/item/canvas/host
	var/icon/draw
	var/icon/base

	var/list/overlay_to_index = list()
	var/current_overlays = 0

	/// per painter drag/erase/shade state, keyed by mob
	var/list/painter_states = list()

/atom/movable/screen/canvas/Destroy()
	host = null
	painter_states.Cut()
	return ..()

/atom/movable/screen/canvas/proc/setup(obj/item/canvas/new_host)
	host = new_host
	icon = new_host.canvas_icon
	icon_state = new_host.canvas_icon_state
	screen_loc = new_host.canvas_screen_loc
	draw = icon(icon, icon_state)
	base = icon(icon, icon_state)
	underlays += base
	icon = draw

/atom/movable/screen/canvas/proc/get_painter_state(mob/user)
	var/list/state = painter_states[user]
	if(!state)
		state = list("drawing" = FALSE, "erasing" = FALSE, "shading" = FALSE, "last_x" = null, "last_y" = null)
		painter_states[user] = state
	return state

/atom/movable/screen/canvas/proc/can_paint(mob/user)
	if(!user || !host || QDELETED(host))
		return FALSE
	if(host.item_flags & IN_STORAGE)
		return FALSE
	if(host.loc == user)
		return TRUE
	if(!isturf(host.loc))
		return FALSE
	if(get_dist(user, host) > 2)
		return FALSE
	return TRUE

/atom/movable/screen/canvas/Click(location, control, params)
	. = ..()
	if(!can_paint(usr))
		return
	var/obj/item/paint_brush/brush = usr.get_active_held_item()
	if(!istype(brush))
		return

	var/list/param_list = params2list(params)

	var/x = text2num(param_list["icon-x"])
	var/y = text2num(param_list["icon-y"])
	if(x == null || y == null)
		return

	y = clamp(FLOOR(y / host.canvas_divider_y, 1), 0, host.canvas_size_y-1)
	x = clamp(FLOOR(x / host.canvas_divider_x, 1), 0, host.canvas_size_x-1)

	var/is_right_click = param_list["right"]
	var/is_middle_click = param_list["middle"]
	var/is_alt = param_list["alt"]
	var/is_ctrl = param_list["ctrl"]
	var/is_left_click = !is_right_click && !is_middle_click

	var/list/state = get_painter_state(usr)

	if(is_ctrl && is_left_click)
		var/picked_color = host.modified_areas["[x],[y]"]
		if(picked_color)
			brush.current_color = picked_color
			brush.update_overlays()
			to_chat(usr, span_notice("Picked color from canvas."))
		else
			to_chat(usr, span_warning("No color to pick at this pixel."))
		state["last_x"] = x
		state["last_y"] = y
		return

	if(is_alt && is_left_click)
		state["shading"] = !state["shading"]
		if(!state["shading"])
			if(!brush.current_color)
				to_chat(usr, span_warning("Pick a color first!"))
				return
			state["drawing"] = TRUE
			state["erasing"] = FALSE
		else
			state["drawing"] = FALSE

		to_chat(usr, span_notice("I am [state["shading"] ? "" : "no longer"] adjusting the shade of the painted portions."))
		state["last_x"] = x
		state["last_y"] = y
		return

	if(is_right_click)
		state["erasing"] = !state["erasing"]
		state["drawing"] = state["erasing"]
		to_chat(usr, span_notice("I am [state["erasing"] ? "" : "no longer"] erasing my work."))

	else if(is_left_click && !is_alt && !is_ctrl)
		if(!brush.current_color)
			to_chat(usr, span_warning("Pick a color first!"))
			return
		state["drawing"] = !state["drawing"]
		state["erasing"] = FALSE
		to_chat(usr, span_notice("I am [state["drawing"] ? "" : "no longer"] drawing."))

	state["last_x"] = x
	state["last_y"] = y

/// paints or erases one brush stamp of cells, returns TRUE if the baked icon was mutated and needs reassigning
/atom/movable/screen/canvas/proc/draw_pixel(x, y, color, is_erasing, brush_size = 1, shading = FALSE)
	. = FALSE
	var/lo = round((brush_size - 1) / 2)
	var/hi = brush_size - 1 - lo
	for(var/px = x - lo to x + hi)
		for(var/py = y - lo to y + hi)
			if(px < 0 || px >= host.canvas_size_x || py < 0 || py >= host.canvas_size_y)
				continue

			var/key = "[px],[py]"

			if(is_erasing)
				var/was_painted = (key in host.modified_areas)
				host.modified_areas -= key
				var/mutable_appearance/erased = overlay_to_index[key]
				if(erased)
					cut_overlay(erased)
					overlay_to_index -= key
					current_overlays = max(current_overlays - 1, 0)
				if(was_painted)
					draw.DrawBox(null, px * host.canvas_divider_x + 1, py * host.canvas_divider_y + 1, (px + 1) * host.canvas_divider_x, (py + 1) * host.canvas_divider_y)
					. = TRUE
				host.erase_cell(px, py, was_painted)
				continue

			var/cell_color = color
			var/pre_merge = host.modified_areas[key]
			if(shading)
				if(!pre_merge)
					continue
				if(pre_merge != cell_color)
					cell_color = BlendRGB(cell_color, pre_merge, 0.5)
			// overlapping drag stamps mostly repaint identical cells, skip them
			if(pre_merge == cell_color)
				continue
			host.modified_areas[key] = cell_color

			var/mutable_appearance/old = overlay_to_index[key]
			if(old)
				cut_overlay(old)
			var/mutable_appearance/MA = mutable_appearance(host.canvas_icon, "pixel")
			MA.color = cell_color
			MA.pixel_x = px * host.canvas_divider_x
			MA.pixel_y = py * host.canvas_divider_y
			MA.layer = layer + 1
			MA.plane = plane
			add_overlay(MA)
			overlay_to_index[key] = MA
			if(!old)
				current_overlays++

			host.update_drawing(px, py, cell_color)
			if(current_overlays > 150)
				flatten()

/atom/movable/screen/canvas/proc/flatten()
	if(!host)
		return
	for(var/key in overlay_to_index)
		var/cell_color = host.modified_areas[key]
		if(!cell_color)
			continue
		var/list/coords = splittext(key, ",")
		var/px = text2num(coords[1])
		var/py = text2num(coords[2])
		draw.DrawBox(cell_color, px * host.canvas_divider_x + 1, py * host.canvas_divider_y + 1, (px + 1) * host.canvas_divider_x, (py + 1) * host.canvas_divider_y)
	icon = draw
	cut_overlays()
	overlay_to_index = list()
	current_overlays = 0

/atom/movable/screen/canvas/proc/draw_line(start_x, start_y, end_x, end_y, color, is_erasing, brush_size = 1)
	// AI suggested implementing bresenham and it blew my mind because i hadn't done that shit since college lol - Ryan
	. = FALSE
	var/dx = abs(end_x - start_x)
	var/dy = abs(end_y - start_y)
	var/sx = start_x < end_x ? 1 : -1
	var/sy = start_y < end_y ? 1 : -1
	var/err = dx - dy

	var/cx = start_x
	var/cy = start_y

	while(TRUE)
		if(draw_pixel(cx, cy, color, is_erasing, brush_size))
			. = TRUE
		if(cx == end_x && cy == end_y)
			break
		var/e2 = err * 2
		if(e2 > -dy)
			err -= dy
			cx += sx
		if(e2 < dx)
			err += dx
			cy += sy

/atom/movable/screen/canvas/MouseMove(location, control, params)
	. = ..()
	handle_paint_move(usr, params)

/atom/movable/screen/canvas/MouseDrag(over_object, src_location, over_location, src_control, over_control, params)
	. = ..()
	if(over_object == src)
		handle_paint_move(usr, params)
	else
		reset_stroke(usr)

/atom/movable/screen/canvas/MouseExited(location, control, params)
	. = ..()
	reset_stroke(usr)

/atom/movable/screen/canvas/proc/reset_stroke(mob/user)
	var/list/state = painter_states[user]
	if(!state)
		return
	state["last_x"] = null
	state["last_y"] = null

/atom/movable/screen/canvas/proc/handle_paint_move(mob/user, params)
	if(!can_paint(user))
		return
	var/list/state = painter_states[user]
	if(!state || !state["drawing"])
		return

	var/list/param_list = params2list(params)
	var/x = text2num(param_list["icon-x"])
	var/y = text2num(param_list["icon-y"])

	if(x == null || y == null)
		return

	y = clamp(FLOOR(y / host.canvas_divider_y, 1), 0, host.canvas_size_y-1)
	x = clamp(FLOOR(x / host.canvas_divider_x, 1), 0, host.canvas_size_x-1)

	var/obj/item/paint_brush/brush = user.get_active_held_item()
	if(!istype(brush))
		return

	var/is_erasing = state["erasing"]
	var/current_color = brush.current_color
	if(!is_erasing && !current_color)
		return

	if(state["shading"])
		if("[x],[y]" in host.modified_areas)
			draw_pixel(x, y, current_color, FALSE, brush.brush_size, TRUE)
			state["last_x"] = x
			state["last_y"] = y
		return

	// Draw from last position to current position (regular drawing mode)
	var/dirty = FALSE
	var/last_x = state["last_x"]
	var/last_y = state["last_y"]
	if(last_x != null && last_y != null && (last_x != x || last_y != y))
		dirty = draw_line(last_x, last_y, x, y, current_color, is_erasing, brush.brush_size)
	else
		dirty = draw_pixel(x, y, current_color, is_erasing, brush.brush_size)

	if(dirty)
		icon = draw
		host.icon = host.draw

	state["last_x"] = x
	state["last_y"] = y


///////////
// EASEL //
///////////

/obj/structure/easel
	name = "easel"
	desc = ""
	icon = 'icons/roguetown/items/paint_supplies/paint_items.dmi'
	icon_state = "easel"
	density = TRUE
	resistance_flags = FLAMMABLE
	max_integrity = 60
	var/obj/item/canvas/painting = null
	anchored = 0

//Adding canvases
/obj/structure/easel/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/canvas))
		return ..()
	var/obj/item/canvas/C = I
	user.dropItemToGround(C)
	painting = C
	painting.pixel_x = 0
	painting.pixel_y = painting.easel_offset
	C.forceMove(get_turf(src))
	C.layer = layer+0.1
	user.visible_message("<span class='notice'>[user] puts \the [C] on \the [src].</span>","<span class='notice'>I place \the [C] on \the [src].</span>")

//Stick to the easel like glue
/obj/structure/easel/Move()
	var/turf/T = get_turf(src)
	. = ..()
	if(painting && painting.loc == T) //Only move if it's near us.
		painting.forceMove(get_turf(src))
	else
		painting = null

///////////
// BRUSH //
///////////

/obj/item/paint_brush
	name = "paint brush"
	desc = "A tool used for painting"
	icon = 'icons/roguetown/items/paint_supplies/paint_items.dmi'
	icon_state = "paintbrush"

	grid_height = 32
	grid_width = 64
	var/current_color
	var/brush_size = 1
	var/max_brush_size = 5

/obj/item/paint_brush/examine(mob/user)
	. = ..()
	if(current_color)
		to_chat(user, span_notice("[src] is lathered with <font color=[current_color]>colour</font>."))
	if(brush_size)
		to_chat(user, span_notice("The size is at: [brush_size]."))

/obj/item/paint_brush/get_mechanics_examine(mob/user)
	. = ..()

	. += span_info("Click shift+right-mouse button to increase brush size.")
	. += span_info("Click alt+right-mouse button to decrease brush size.")
	. += span_info("Use in hand to clear colour.")

/obj/item/paint_brush/update_overlays()
	. = ..()
	cut_overlays()
	if(!current_color)
		return

	var/mutable_appearance/MA = mutable_appearance(icon, "paintbrush-color")
	MA.color = current_color
	add_overlay(MA)

/obj/item/paint_brush/proc/increase_brush_size()
	if(brush_size < max_brush_size)
		brush_size++
		return TRUE
	return FALSE

/obj/item/paint_brush/proc/decrease_brush_size()
	if(brush_size > 1)
		brush_size--
		return TRUE
	return FALSE

/obj/item/paint_brush/ShiftRightClick(mob/user)
	if(increase_brush_size())
		to_chat(user, span_notice("Brush size increased to [brush_size]."))
	else
		to_chat(user, span_notice("Brush size is at maximum."))

	return ..()

/obj/item/paint_brush/AltRightClick(mob/user)
	. = ..()
	if(!istype(loc, /mob/living/carbon))
		return
	if(decrease_brush_size())
		to_chat(user, span_notice("Brush size decreased to [brush_size]."))
	else
		to_chat(user, span_notice("Brush size is at minimum."))

/obj/item/paint_brush/attack_self(mob/user)
	. = ..()
	current_color = null
	update_overlays()
	to_chat(user, span_notice("Brush color cleared"))

/obj/item/paint_brush/afterattack(atom/target, mob/living/user, proximity_flag, click_parameters)
	. = ..()
	if(istype(target, /obj/item/paint_palette))
		var/merge_color = input(user, "Choose a color to blend") as anything in target:colors
		if(!merge_color)
			return
		var/list/colors = target:colors
		merge_color = colors[merge_color]
		if(!current_color)
			current_color = merge_color
		else
			current_color = BlendRGB(current_color, merge_color, 0.5)
		update_overlays()
		return

	if(!target.reagents)
		return
	if(!(target.reagents.flags & OPENCONTAINER))
		return

	if(target.reagents.has_reagent(/datum/reagent/water))
		to_chat(user, span_notice("You start to wash [src] in [target]."))
		if(!do_after(user, 1 SECONDS, target = target))
			return
		current_color = null
		update_overlays()

/obj/item/paint_palette/filled
	colors = list(
		"Red" = COLOR_RED,
		"Blue" = COLOR_BLUE,
		"Green" = COLOR_GREEN,
		"Purple" = COLOR_PURPLE,
		"Cyan" = COLOR_CYAN
	)

///////////
// Palette //
///////////

/obj/item/paint_palette
	name = "paint palette"
	desc = "A tool used for painting"
	icon = 'icons/roguetown/items/paint_supplies/paint_items.dmi'
	icon_state = "palette"

	grid_height = 32
	grid_width = 64
	var/list/colors = list()

/obj/item/paint_palette/Initialize()
	. = ..()
	update_overlays()

/obj/item/paint_palette/proc/add_color(mob/user)
	if(length(colors) >= 5)
		return
	var/add_color = input(user, "Choose a color to add") as color|null
	if(!add_color)
		return
	var/color_name = input(user, "Choose a name for this color")
	if(!color_name)
		return
	if(length(colors) >= 5)
		return
	colors |= color_name
	colors[color_name] = add_color
	update_overlays()

/obj/item/paint_palette/proc/remove_color(mob/user)
	var/remove_color = input(user, "Choose a color to remove") as anything in colors
	if(!remove_color)
		return
	colors -= remove_color
	update_overlays()

/obj/item/paint_palette/attack_right(mob/user)
	. = ..()
	remove_color(user)

/obj/item/paint_palette/attack_self(mob/user)
	. = ..()
	add_color(user)

/obj/item/paint_palette/update_overlays()
	. = ..()
	cut_overlays()

	for(var/i = 1 to length(colors))
		var/mutable_appearance/MA = mutable_appearance(icon, "palette-greyscale[i]")
		var/color_name = colors[i]
		MA.color = colors[color_name]
		add_overlay(MA)
