var/global/list/pridelist = list(
	"Rainbow" = "#fcfcfc"
)

var/list/used_colors

// DYE BIN

/obj/machinery/gear_painter
	name = "Dye Station"
	desc = "A station to give your apparel a fresh new color! Recommended to use with white items for best results."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "dyestation"
	density = TRUE
	anchored = TRUE
	var/atom/movable/inserted
	var/activecolor = "#FFFFFF"
	var/activecolor_detail = "#FFFFFF"
	var/activecolor_altdetail = "#FFFFFF"
	var/list/allowed_types = list(
			/obj/item/clothing,
			/obj/item/storage,
			/obj/item/bedroll,
			/obj/item/flowercrown,
			/obj/item/legwears,
			/obj/item/undies
			)

/obj/machinery/gear_painter/Initialize()
	..()
	used_colors += COLOR_MAP
	used_colors += pridelist

/obj/machinery/gear_painter/Destroy()
	if(inserted)
		inserted.forceMove(drop_location())
	return ..()

/obj/machinery/gear_painter/attackby(obj/item/I, mob/living/user)
	if(inserted)
		to_chat(user, span_warning("Something is already inside!"))
		return ..()
	if(!is_type_in_list(I, allowed_types))
		to_chat(user, span_warning("[I] cannot be dyed!"))
		return ..()
	if(!user.transferItemToLoc(I, src))
		to_chat(user, span_warning("[I] is stuck to your hand!"))
		return ..()

	user.visible_message(span_notice("[user] inserts [I] into [src]'s receptable."))

	inserted = I
	interact(user)

/obj/machinery/gear_painter/AllowDrop()
	return FALSE

/obj/machinery/gear_painter/attack_hand(mob/living/user)
	interact(user)

/obj/machinery/gear_painter/proc/pick_dye(mob/user, current_color, prompt_title)
	if(alert(user, "Input Choice", prompt_title, "Color Wheel", "Color Preset") == "Color Wheel")
		var/c = sanitize_hexcolor(color_pick_sanitized(user, "Choose your dye:", "Dyes", current_color), 6, TRUE)
		return (c == "#000000") ? "#FFFFFF" : c

	var/list/colors_to_pick = list()
	if(GLOB.lordprimary)
		colors_to_pick["Primary Keep Color"] = GLOB.lordprimary
	if(GLOB.lordsecondary)
		colors_to_pick["Secondary Keep Color"] = GLOB.lordsecondary
	colors_to_pick += used_colors.Copy()
	var/picked = input(user, "Choose your dye:", "Dyes", null) as null|anything in colors_to_pick
	if(!picked)
		return null
	return colors_to_pick[picked]

/obj/machinery/gear_painter/interact(mob/user)
	if(!is_operational())
		return ..()
	user.set_machine(src)
	var/datum/browser/menu = new(user, "colormate","Dye Station", 400, 400, src)
	var/list/dat = list("<TITLE>Dye Bin</TITLE><BR>")
	if(!inserted)
		dat += "No item inserted."
		menu.set_content("<html>[dat.Join("")]</html>")
		menu.open()
		return

	var/obj/item/inserted_item = inserted

	dat += "Item inserted: [inserted]<HR>"
	dat += "<A href='?src=\ref[src];select=1'>Select new color.</A><BR>"
	dat += "Color: <font color='[activecolor]'>&#10070;</font>"
	dat += "<A href='?src=\ref[src];paint=1'>Apply new color</A> | "
	dat += "<A href='?src=\ref[src];clear=1'>Remove paintjob</A><BR><BR>"

	if(inserted_item.detail_color)
		dat += "<A href='?src=\ref[src];select_detail=1'>Select new detail color.</A><BR>"
		dat += "Detail Color: <font color='[activecolor_detail]'>&#10070;</font>"
		dat += "<A href='?src=\ref[src];paint_detail=1'>Apply new color</A> | "
		dat += "<A href='?src=\ref[src];clear_detail=1'>Remove paintjob</A><BR><BR>"

	if(inserted_item.altdetail_color)
		dat += "<A href='?src=\ref[src];select_altdetail=1'>Select new tertiary color.</A><BR>"
		dat += "Alt. Detail Color: <font color='[activecolor_altdetail]'>&#10070;</font>"
		dat += "<A href='?src=\ref[src];paint_altdetail=1'>Apply new color</A> | "
		dat += "<A href='?src=\ref[src];clear_altdetail=1'>Remove paintjob</A><BR><BR>"

	dat += "<A href='?src=\ref[src];eject=1'>Eject item.</A><BR><BR>"
	menu.set_content("<html>[dat.Join("")]</html>")
	menu.open()

/obj/machinery/gear_painter/ui_interact(mob/user, datum/tgui/ui)
	interact(user)

/obj/machinery/gear_painter/Topic(href, href_list)
	. = ..()
	if(.)
		return

	add_fingerprint(usr)

	if(href_list["close"])
		usr << browse(null, "window=colormate")
		return

	if(href_list["select"])
		var/c = pick_dye(usr, activecolor, "Primary Dye")
		if(!c) return
		activecolor = c
		updateUsrDialog()

	if(href_list["select_detail"])
		var/c = pick_dye(usr, activecolor_detail, "Secondary Dye")
		if(!c) return
		activecolor_detail = c
		updateUsrDialog()

	if(href_list["select_altdetail"])
		var/c = pick_dye(usr, activecolor_altdetail, "Tertiary Dye")
		if(!c) return
		activecolor_altdetail = c
		updateUsrDialog()

	if(href_list["paint"])
		if(!inserted)
			return
		inserted.add_atom_colour(activecolor, FIXED_COLOUR_PRIORITY)
		playsound(src, "bubbles", 50, 1)
		updateUsrDialog()

	if(href_list["paint_detail"])
		if(!inserted)
			return
		var/obj/item/inserted_item = inserted
		inserted_item.detail_color = activecolor_detail
		inserted_item.update_icon()
		playsound(src, "bubbles", 50, 1)
		updateUsrDialog()

	if(href_list["paint_altdetail"])
		if(!inserted)
			return
		var/obj/item/inserted_item = inserted
		inserted_item.altdetail_color = activecolor_altdetail
		inserted_item.update_icon()
		if(inserted_item in GLOB.lordcolor)
			GLOB.lordcolor -= inserted_item
		playsound(src, "bubbles", 50, 1)
		updateUsrDialog()

	if(href_list["clear"])
		if(!inserted)
			return
		inserted.remove_atom_colour(FIXED_COLOUR_PRIORITY)
		playsound(src, "bubbles", 50, 1)
		updateUsrDialog()

	if(href_list["clear_detail"])
		if(!inserted)
			return
		var/obj/item/inserted_item = inserted
		inserted_item.detail_color = "#FFFFFF" //We don't initial() this in case it goes null
		inserted_item.update_icon()
		playsound(src, "bubbles", 50, 1)
		updateUsrDialog()

	if(href_list["clear_altdetail"])
		if(!inserted)
			return
		var/obj/item/inserted_item = inserted
		inserted_item.altdetail_color = "#FFFFFF"
		inserted_item.update_icon()
		playsound(src, "bubbles", 50, 1)
		updateUsrDialog()

	if(href_list["eject"])
		if(!inserted)
			return
		inserted.forceMove(drop_location())
		inserted = null
		updateUsrDialog()


// PAINTBRUSH

/obj/item/dye_brush
	icon = 'icons/roguetown/items/misc.dmi'
	name = "dye brush"
	desc = "A sizeable brush made of the finest mane-hairs. Thick dye adheres to it well."
	icon_state = "dbrush"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.8
	grid_width = 32
	grid_height = 32

	var/dye = null

/obj/item/dye_brush/update_icon()
	if(dye)
		var/mutable_appearance/M = mutable_appearance('icons/roguetown/items/misc.dmi', "dbrush_colour")
		M.color = dye
		M.alpha = 150
		add_overlay(M)
	else
		cut_overlays()

/obj/item/dye_brush/examine(mob/user)
	. = ..()

	if(dye)
		. += span_notice("It is currently lathering <font color=[dye]>paint</font>.")
	else
		. += span_notice("Use in active hand to pick a paint.")

/obj/item/dye_brush/attack_self(mob/user)
	..()

	if(dye)
		to_chat(user, span_warning("[src] is already carrying <font color=[dye]>dye</font>. I need to wash it."))
		return

	var/choice_mode = alert(user, "Input Choice", "Brush Dye", "Color Wheel", "Color Preset")
	if(choice_mode == "Color Preset")
		var/list/presets = COLOR_MAP
		presets += pridelist

		var/picked = input(user, "Choose your dye:", "Dyes", null) as null|anything in presets
		if(!picked)
			return

		dye = presets[picked]
	else
		var/hexdye = sanitize_hexcolor(color_pick_sanitized(user, "Choose your dye:", "Dyes", dye), 6, TRUE)
		if(hexdye == "#000000")
			return
		dye = hexdye

	update_icon()

/obj/item/dye_brush/attack_turf(turf/T, mob/living/user)
	if(!iswallturf(T))
		return
	if(!dye)
		to_chat(user, span_warning("[src] has no dye!"))
		return
	if(T.color)
		to_chat(user, span_warning("[T] is already painted by a <font color=[T.color]>dye</font>!"))
		return

	if(!do_after(user, 6 SECONDS, TRUE, T))
		return
	user.visible_message(span_notice("[user] finishes <font color=[dye]>painting</font> [T]."), \
		span_notice("I finish <font color=[dye]>painting</font> [T].")
	)
	playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 60, TRUE)
	T.color = dye

	..()

/obj/item/dye_brush/attack_obj(obj/O, mob/living/user)
	if(!isstructure(O))
		return
	if(!dye)
		to_chat(user, span_warning("[src] has no dye!"))
		return
	if(O.color)
		to_chat(user, span_warning("[O] is already painted by a <font color=[O.color]>dye</font>!"))
		return

	if(!do_after(user, 3 SECONDS, TRUE, O))
		return
	user.visible_message(span_notice("[user] finishes <font color=[dye]>painting</font> [O]."), \
		span_notice("I finish <font color=[dye]>painting</font> [O].")
	)
	playsound(loc,"sound/foley/scrubbing[pick(1,2)].ogg", 60, TRUE)
	O.color = dye

	..()

/obj/item/dye_brush/wash_act(clean)
	if(!dye)
		return
	dye = null
	update_icon()

