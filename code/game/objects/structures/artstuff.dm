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
	var/canvas_size = "32x32"
	var/reject = FALSE

	var/canvas_icon = 'icons/roguetown/items/paint_supplies/canvas_32x32.dmi'
	var/canvas_icon_state = "canvas"
	var/canvas_screen_loc = "6,6"
	var/canvas_divider_x = 5
	var/canvas_divider_y = 5
	var/pixel_size_x = 4
	var/pixel_size_y = 4

	var/list/overlay_to_index = list()
	var/current_overlays = 0

/obj/item/canvas/Initialize()
	. = ..()
	used_canvas = new
	used_canvas.host = src
	used_canvas.base_icon = icon(icon, icon_state)
	used_canvas.icon = canvas_icon
	used_canvas.screen_loc = canvas_screen_loc
	used_canvas.icon_state = canvas_icon_state
	draw = icon(icon, icon_state)
	base = icon(icon, icon_state)
	underlays += base
	icon = draw
	RegisterSignal(src, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(remove_showers))

/obj/item/canvas/Destroy()
	. = ..()
	for(var/mob/mob in showers)
		remove_shower(mob)

/obj/item/canvas/get_mechanics_examine(mob/user)
	. = ..()

	. += span_info("Click left-mouse button to toggle drawing mode. Don't hold it down.")
	. += span_info("Click right-mouse button to toggle erase mode. Don't hold it down.")
	. += span_info("Click alt+left-mouse button to toggle shade adjustment mode. Don't hold it down.")
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
	if(user in showers)
		return
	user?.client.screen += used_canvas
	showers |= user
	RegisterSignal(user, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(remove_shower))

/obj/item/canvas/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	if(istype(I, /obj/item/natural/feather))
		author = input("Who's the author of this painting?")
		author_ckey = user.ckey
		title = input("What's the title of this painting.")
		if(title)
			name = title
		if(author)
			desc = "Painted by: [author]."
		return

	if(!istype(I, /obj/item/paint_brush))
		return
	if(user in showers)
		return
	user?.client.screen += used_canvas
	showers |= user
	RegisterSignal(user, COMSIG_MOVABLE_TURF_ENTERED, PROC_REF(remove_shower))

/obj/item/canvas/proc/remove_showers()
	for(var/mob/mob in showers)
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
	showers -= source
	source.client?.screen -= used_canvas
	UnregisterSignal(source, COMSIG_MOVABLE_TURF_ENTERED)

	if(istype(used_canvas))
		used_canvas.is_drawing = FALSE
		used_canvas.drawing_is_erasing = FALSE
		used_canvas.shade_adjustment_mode = FALSE

/obj/item/canvas/proc/update_drawing(x, y, current_color)
	if("[x][y]" in overlay_to_index)
		cut_overlay(overlay_to_index["[x][y]"])
		overlay_to_index -= "[x][y]"
	var/mutable_appearance/MA = mutable_appearance('icons/roguetown/items/paint_supplies/pixel.dmi', "pixel")
	MA.color = current_color
	MA.pixel_x = x
	MA.pixel_y = y
	add_overlay(MA)
	overlay_to_index |= "[x][y]"
	overlay_to_index["[x][y]"] = MA
	current_overlays++
	if(current_overlays > 150)
		icon = usr.client.RenderIcon(src)
		current_overlays = 0
		cut_overlays()
		overlay_to_index = list()

/obj/item/canvas/proc/upload_painting()
	if(!author || !title)
		return
	var/icon/rendered = usr.client.RenderIcon(src)
	cut_overlays()
	if(rendered)
		icon = rendered

/atom/movable/screen/canvas
	icon = 'icons/roguetown/items/paint_supplies/canvas_32x32.dmi'
	icon_state = "canvas"
	screen_loc = "6,6"

	var/obj/item/canvas/host
	var/list/modified_areas = list()
	var/icon/base_icon
	var/icon/draw
	var/icon/base

	var/list/overlay_to_index = list()
	var/current_overlays = 0

	var/loads_painting = FALSE
	
	// Drag drawing support
	var/is_drawing = FALSE
	var/last_draw_x = null
	var/last_draw_y = null
	var/drawing_is_erasing = FALSE
	var/shade_adjustment_mode = FALSE

/atom/movable/screen/canvas/Initialize(mapload, ...)
	. = ..()
	draw = icon(icon, icon_state)
	base = icon(icon, icon_state)
	icon = draw
	underlays += base

/atom/movable/screen/canvas/Click(location, control, params)
	. = ..()
	if(host.item_flags & IN_STORAGE)
		return
	var/obj/item/paint_brush/brush = usr.get_active_held_item()
	if(!istype(brush))
		return

	var/list/param_list = params2list(params)

	var/x = text2num(param_list["icon-x"])
	var/y = text2num(param_list["icon-y"])

	y = min(FLOOR(y / host.canvas_divider_y, 1), host.canvas_size_y-1)
	x = min(FLOOR(x / host.canvas_divider_x, 1), host.canvas_size_x-1)

	var/is_right_click = param_list["right"]
	var/is_middle_click = param_list["middle"]
	var/is_alt = param_list["alt"]
	var/is_ctrl = param_list["ctrl"]
	var/is_left_click = !is_right_click && !is_middle_click

	if(is_ctrl && is_left_click)
		if("[x][y]" in modified_areas)
			var/picked_color = draw.GetPixel(x+1, y+1)
			if(picked_color)
				brush.current_color = picked_color
				brush.update_overlays()
				to_chat(usr, span_notice("Picked color from canvas."))
			else
				to_chat(usr, span_warning("No color to pick at this pixel."))
		else
			to_chat(usr, span_warning("No color to pick at this pixel."))
		last_draw_x = x
		last_draw_y = y
		return

	if(is_alt && is_left_click)
		shade_adjustment_mode = !shade_adjustment_mode
		if(!shade_adjustment_mode)
			var/current_color = brush.current_color
			if(!current_color)
				to_chat(usr, span_warning("Pick a color first!"))
				return
			is_drawing = TRUE
			drawing_is_erasing = FALSE
		else
			is_drawing = FALSE
			last_draw_x = null
			last_draw_y = null

		to_chat(usr, span_notice("I am [shade_adjustment_mode ? "" : "no longer"] adjusting the shade of the painted portions."))
		last_draw_x = x
		last_draw_y = y
		return

	if(is_right_click)
		drawing_is_erasing = !drawing_is_erasing
		if(drawing_is_erasing)
			is_drawing = TRUE
		else
			is_drawing = FALSE

		to_chat(usr, span_notice("I am [drawing_is_erasing ? "" : "no longer"] erasing my work."))

	else if(is_left_click && !is_alt && !is_ctrl)
		var/current_color = brush.current_color
		if(!current_color)
			to_chat(usr, span_warning("Pick a color first!"))
			return
		is_drawing = !is_drawing
		drawing_is_erasing = FALSE
		to_chat(usr, span_notice("I am [is_drawing ? "" : "no longer"] drawing."))

	last_draw_x = x
	last_draw_y = y

/atom/movable/screen/canvas/proc/draw_pixel(x, y, color, is_erasing)
	var/obj/item/paint_brush/brush = usr.get_active_held_item()
	var/brush_size = 1
	if(istype(brush))
		brush_size = brush.brush_size

	var/offset = (brush_size - 1) / 2
	for(var/px = x - offset to x + offset)
		for(var/py = y - offset to y + offset)
			if(px < 0 || px >= host.canvas_size_x || py < 0 || py >= host.canvas_size_y)
				continue

			if(is_erasing)
				modified_areas -= "[px][py]"
				if("[px][py]" in overlay_to_index)
					cut_overlay(overlay_to_index["[px][py]"])
			else
				if("[px][py]" in modified_areas)
					if(shade_adjustment_mode)
						var/pre_merge = draw.GetPixel(px+1, py+1)
						if(pre_merge != color)
							color = BlendRGB(color, pre_merge, 0.5)
				modified_areas |= "[px][py]"
				if("[px][py]" in overlay_to_index)
					cut_overlay(overlay_to_index["[px][py]"])

			if(!is_erasing)
				var/mutable_appearance/MA = mutable_appearance(host.canvas_icon, "pixel")
				MA.color = color
				MA.pixel_x = (px) * host.canvas_divider_y
				MA.pixel_y = (py) * host.canvas_divider_x
				MA.layer = layer +1
				MA.plane = plane
				add_overlay(MA)
				current_overlays++
				overlay_to_index |= "[px][py]"
				overlay_to_index["[px][py]"] = MA
				if(current_overlays > 150)
					icon = usr.client.RenderIcon(src)
					current_overlays = 0
					cut_overlays()
					overlay_to_index = list()

				host.update_drawing(px, py, color)

/atom/movable/screen/canvas/proc/draw_line(start_x, start_y, end_x, end_y, color, is_erasing)
	// AI suggested implementing bresenham and it blew my mind because i hadn't done that shit since college lol - Ryan
	var/dx = abs(end_x - start_x)
	var/dy = abs(end_y - start_y)
	var/sx = start_x < end_x ? 1 : -1
	var/sy = start_y < end_y ? 1 : -1
	var/err = dx - dy

	var/cx = start_x
	var/cy = start_y

	while(TRUE)
		if(cx == end_x && cy == end_y)
			break

		draw_pixel(cx, cy, color, is_erasing)
		var/e2 = err * 2
		if(e2 > -dy)
			err -= dy
			cx += sx
		if(e2 < dx)
			err += dx
			cy += sy

/atom/movable/screen/canvas/MouseMove(location, control, params)
	. = ..()
	if(!is_drawing)
		return
	if(host.item_flags & IN_STORAGE)
		return

	var/list/param_list = params2list(params)
	var/x = text2num(param_list["icon-x"])
	var/y = text2num(param_list["icon-y"])

	if(x == null || y == null)
		return

	y = min(FLOOR(y / host.canvas_divider_y, 1), host.canvas_size_y-1)
	x = min(FLOOR(x / host.canvas_divider_x, 1), host.canvas_size_x-1)
	y = max(0, y)
	x = max(0, x)

	var/obj/item/paint_brush/brush = usr.get_active_held_item()
	if(!istype(brush))
		return

	var/current_color = brush.current_color

	if(drawing_is_erasing)
		current_color = base_icon.GetPixel(x, y)
	else if(!current_color)
		return

	if(shade_adjustment_mode)
		if("[x][y]" in modified_areas)
			draw_pixel(x, y, current_color, FALSE)
			last_draw_x = x
			last_draw_y = y
		return

	// Draw from last position to current position (regular drawing mode)
	if(last_draw_x != null && last_draw_y != null && (last_draw_x != x || last_draw_y != y))
		draw_line(last_draw_x, last_draw_y, x, y, current_color, drawing_is_erasing)
	else
		draw_pixel(x, y, current_color, drawing_is_erasing)

	last_draw_x = x
	last_draw_y = y


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
	if(decrease_brush_size())
		to_chat(user, span_notice("Brush size decreased to [brush_size]."))
	else
		to_chat(user, span_notice("Brush size is at minimum."))

	return ..()

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
