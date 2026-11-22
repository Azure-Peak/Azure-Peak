GLOBAL_LIST_INIT(pridelist, list("Rainbow" = "#fcfcfc"))
GLOBAL_LIST_EMPTY(used_colors)

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
	var/list/preview_containers = list()
	var/mob/preview_viewer
	var/list/allowed_types = list(
			/obj/item/clothing,
			/obj/item/rogueweapon,
			/obj/item/storage,
			/obj/item/bedroll,
			/obj/item/flowercrown,
			/obj/item/legwears,
			/obj/item/undies,
			/obj/item/natural/cloth,
			/obj/item/caparison,
			/obj/item/reagent_containers/glass/bottle/clayvase,
			/obj/item/reagent_containers/glass/bottle/clayfancyvase,
			/obj/item/reagent_containers/glass/cup/claycup,
			/obj/item/reagent_containers/glass/bottle/claybottle,
			/obj/item/roguestatue/clay,
			/obj/item/roguestatue/glass,
			/obj/item/natural/clay/porcelain,
			/obj/item/clothing/neck/roguetown/carved/porcelainamulet,
			/obj/item/clothing/ring/porcelain,
			/obj/item/clothing/head/roguetown/circlet/carvedgem/porcelain,
			/obj/item/reagent_containers/glass/cup/carved/porcelainfancy,
			/obj/item/reagent_containers/glass/cup/carved/porcelain,
			/obj/item/reagent_containers/glass/bowl/carved/porcelain,
			/obj/item/kitchen/spoon/carved/porcelain,
			/obj/item/kitchen/fork/carved/porcelain,
			/obj/item/cooking/platter/carved/porcelain,
			/obj/item/reagent_containers/glass/bucket/pot/porcelain,
			/obj/item/reagent_containers/glass/bottle/claytallbaked,
			/obj/item/reagent_containers/glass/bottle/clayfootbaked,
			/obj/item/reagent_containers/glass/bottle/claybamanabaked,
			/obj/item/reagent_containers/glass/bottle/clayamphorabaked,
			/obj/item/reagent_containers/glass/bottle/clayskinnybaked,
			/obj/item/reagent_containers/glass/carafe/porcelain
			)

/obj/machinery/gear_painter/Initialize(mapload)
	..()
	GLOB.used_colors |= COLOR_MAP
	GLOB.used_colors |= GLOB.pridelist

/obj/machinery/gear_painter/Destroy()
	clear_previews()
	if(inserted)
		inserted.forceMove(drop_location())
	return ..()

/obj/machinery/gear_painter/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/rogueweapon) && user.cmode)
		return ..()
	if(inserted)
		to_chat(user, span_warning("Something is already inside!"))
		return ..()
	if(!is_type_in_list(I, allowed_types))
		to_chat(user, span_warning("[I] cannot be dyed!"))
		return ..()
	if(istype(I, /obj/item/rogueweapon) && !I.detail_tag)
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
	colors_to_pick += GLOB.used_colors.Copy()
	var/picked = input(user, "Choose your dye:", "Dyes", null) as null|anything in colors_to_pick
	if(!picked)
		return null
	return colors_to_pick[picked]

/obj/machinery/gear_painter/interact(mob/user)
	if(!is_operational())
		return ..()
	user.set_machine(src)
	var/datum/browser/menu = new(user, "colormate","Dye Station", 500, 600, src)
	var/list/dat = list("<TITLE>Dye Bin</TITLE><BR>")
	if(!inserted)
		dat += "No item inserted."
		menu.set_content("<html>[dat.Join("")]</html>")
		menu.open()
		return

	var/obj/item/inserted_item = inserted
	var/is_weapon = istype(inserted_item, /obj/item/rogueweapon)

	dat += "<div style='text-align:center;'>"
	dat += get_preview_html(inserted_item, is_weapon, user)
	dat += "</div><BR>"

	dat += "Item inserted: [inserted]<BR><BR>"

	if(!is_weapon)
		dat += "Color: <font color='[activecolor]'>&#10070;</font> "
		dat += "<A href='?src=\ref[src];select=1'>Select new color.</A><BR>"
		dat += "<A href='?src=\ref[src];paint_primary=1'>Apply new color</A> | "
		dat += "<A href='?src=\ref[src];clear_primary=1'>Remove paintjob</A><BR>"

	if(inserted_item.detail_color)
		dat += "Detail Color: <font color='[activecolor_detail]'>&#10070;</font> "
		dat += "<A href='?src=\ref[src];select_detail=1'>Select new detail color.</A><BR>"
		dat += "<A href='?src=\ref[src];paint_detail=1'>Apply new color</A> | "
		dat += "<A href='?src=\ref[src];clear_detail=1'>Remove paintjob</A><BR>"

	if(inserted_item.altdetail_color)
		dat += "Alt. Detail Color: <font color='[activecolor_altdetail]'>&#10070;</font> "
		dat += "<A href='?src=\ref[src];select_altdetail=1'>Select new tertiary color.</A><BR>"
		dat += "<A href='?src=\ref[src];paint_altdetail=1'>Apply new color</A> | "
		dat += "<A href='?src=\ref[src];clear_altdetail=1'>Remove paintjob</A><BR>"

	dat += "<BR><A href='?src=\ref[src];eject=1'>Eject item.</A><BR>"
	menu.set_content("<html>[dat.Join("")]</html>")
	menu.open()

/obj/machinery/gear_painter/proc/clear_previews()
	for(var/atom/movable/screen/container as anything in preview_containers)
		preview_viewer?.remove_appearance(container)
		qdel(container)
	preview_containers.Cut()
	preview_viewer = null

/obj/machinery/gear_painter/proc/preview_layer(file, state, layer_color)
	var/mutable_appearance/layer = mutable_appearance(file, state)
	layer.dir = SOUTH
	layer.appearance_flags = RESET_COLOR
	if(layer_color)
		layer.color = layer_color
	return layer

/obj/machinery/gear_painter/proc/preview_stack()
	var/mutable_appearance/stack = mutable_appearance()
	stack.dir = SOUTH
	return stack

/obj/machinery/gear_painter/proc/preview_img(mob/user, mutable_appearance/preview)
	var/atom/movable/screen/container = user.send_appearance(preview, duration = 0)
	if(!container)
		return ""
	preview_containers += container
	return "<img src='\ref[container]' style='vertical-align:middle; width:64px; height:64px; image-rendering: pixelated; image-rendering: crisp-edges;'>"

/obj/machinery/gear_painter/proc/get_preview_html(obj/item/preview_item, is_weapon, mob/user)
	clear_previews()
	preview_viewer = user

	var/has_detail = preview_item.detail_tag && preview_item.detail_color
	var/has_altdetail = preview_item.altdetail_tag && preview_item.altdetail_color

	var/mutable_appearance/item_preview = preview_stack()
	item_preview.overlays += preview_layer(preview_item.icon, preview_item.icon_state, is_weapon ? null : activecolor)
	if(has_detail)
		item_preview.overlays += preview_layer(preview_item.icon, "[preview_item.icon_state][preview_item.detail_tag]", activecolor_detail)
	if(has_altdetail)
		item_preview.overlays += preview_layer(preview_item.icon, "[preview_item.icon_state][preview_item.altdetail_tag]", activecolor_altdetail)

	var/dat = preview_img(user, item_preview)

	if(!istype(preview_item, /obj/item/clothing))
		return dat
	var/obj/item/clothing/clothing_item = preview_item
	var/mob_icon_to_use = clothing_item.mob_overlay_icon
	if(!mob_icon_to_use)
		return dat

	var/worn_state = clothing_item.icon_state
	var/mutable_appearance/worn_preview = preview_stack()
	worn_preview.overlays += preview_layer(mob_icon_to_use, worn_state, activecolor)
	if(has_detail)
		worn_preview.overlays += preview_layer(mob_icon_to_use, "[worn_state][preview_item.detail_tag]", activecolor_detail)
	if(has_altdetail)
		worn_preview.overlays += preview_layer(mob_icon_to_use, "[worn_state][preview_item.altdetail_tag]", activecolor_altdetail)

	var/sleeved = clothing_item.sleeved
	if(sleeved && icon_exists(sleeved, worn_state))
		if(icon_exists(sleeved, "r_[worn_state]"))
			worn_preview.overlays += preview_layer(sleeved, "r_[worn_state]", activecolor)
		if(icon_exists(sleeved, "l_[worn_state]"))
			worn_preview.overlays += preview_layer(sleeved, "l_[worn_state]", activecolor)
		if(has_detail && clothing_item.sleeved_detail)
			if(icon_exists(sleeved, "r_[worn_state][preview_item.detail_tag]"))
				worn_preview.overlays += preview_layer(sleeved, "r_[worn_state][preview_item.detail_tag]", activecolor_detail)
			if(icon_exists(sleeved, "l_[worn_state][preview_item.detail_tag]"))
				worn_preview.overlays += preview_layer(sleeved, "l_[worn_state][preview_item.detail_tag]", activecolor_detail)

	dat += " " + preview_img(user, worn_preview)
	return dat

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
		if(istype(inserted, /obj/item/rogueweapon))
			return
		var/c = pick_dye(usr, activecolor, "Primary Dye")
		if(!c) return
		activecolor = c
		interact(usr)

	if(href_list["select_detail"])
		var/c = pick_dye(usr, activecolor_detail, "Secondary Dye")
		if(!c) return
		activecolor_detail = c
		interact(usr)

	if(href_list["select_altdetail"])
		var/c = pick_dye(usr, activecolor_altdetail, "Tertiary Dye")
		if(!c) return
		activecolor_altdetail = c
		interact(usr)

	if(href_list["paint_primary"])
		if(!inserted || istype(inserted, /obj/item/rogueweapon))
			return
		var/obj/item/inserted_item = inserted
		inserted.add_atom_colour(activecolor, FIXED_COLOUR_PRIORITY)
		inserted_item.update_icon()
		if(inserted_item.glaze_bonus_pct > 0 && !inserted_item.glazed)
			inserted_item.glazed = TRUE
		playsound(src, "bubbles", 50, 1)
		interact(usr)

	if(href_list["paint_detail"])
		if(!inserted)
			return
		var/obj/item/inserted_item = inserted
		if(inserted_item.detail_color)
			inserted_item.detail_color = activecolor_detail
		inserted_item.update_icon()
		playsound(src, "bubbles", 50, 1)
		interact(usr)

	if(href_list["paint_altdetail"])
		if(!inserted)
			return
		var/obj/item/inserted_item = inserted
		if(inserted_item.altdetail_color)
			inserted_item.altdetail_color = activecolor_altdetail
		inserted_item.update_icon()
		playsound(src, "bubbles", 50, 1)
		interact(usr)

	if(href_list["clear_primary"])
		if(!inserted || istype(inserted, /obj/item/rogueweapon))
			return
		var/obj/item/inserted_item = inserted
		inserted.remove_atom_colour(FIXED_COLOUR_PRIORITY)
		inserted_item.update_icon()
		playsound(src, "bubbles", 50, 1)
		interact(usr)

	if(href_list["clear_detail"])
		if(!inserted)
			return
		var/obj/item/inserted_item = inserted
		if(inserted_item.detail_color)
			inserted_item.detail_color = "#FFFFFF"
		inserted_item.update_icon()
		playsound(src, "bubbles", 50, 1)
		interact(usr)

	if(href_list["clear_altdetail"])
		if(!inserted)
			return
		var/obj/item/inserted_item = inserted
		if(inserted_item.altdetail_color)
			inserted_item.altdetail_color = "#FFFFFF"
		inserted_item.update_icon()
		playsound(src, "bubbles", 50, 1)
		interact(usr)

	if(href_list["eject"])
		if(!inserted)
			return
		inserted.forceMove(drop_location())
		inserted = null
		clear_previews()
		interact(usr)


// PAINTBRUSH

/obj/item/dye_brush
	icon = 'icons/roguetown/items/misc.dmi'
	name = "dye brush"
	desc = "A sizable brush made of the finest mane-hairs. Thick dye adheres to it well."
	icon_state = "dbrush"
	w_class = WEIGHT_CLASS_SMALL
	dropshrink = 0.7
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
		presets += GLOB.pridelist

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

/obj/item/dye_brush/pre_attack(atom/A, mob/living/user, params)
	if(..())
		return TRUE
	var/obj/item/target = A
	if(!istype(target) || target.glazed || !target.icon)
		return FALSE

	var/static/list/glaze_finishes = list(
		"Clear glaze" = "glazed",
		"Kintsugi glaze" = "shattergold",
		"Lakkarian glaze" = "naled"
	)

	var/list/choices = list()
	for(var/finish in glaze_finishes)
		if(icon_exists(target.icon, "[target.icon_state]_[glaze_finishes[finish]]"))
			choices += finish
	if(!length(choices))
		return FALSE

	if(target.reagents && target.reagents.total_volume)
		to_chat(user, span_notice("I can't glaze [target] while it has liquid in it."))
		return TRUE

	var/choice = choices[1]
	if(length(choices) > 1)
		choice = tgui_input_list(user, "Which finish shall I glaze [target] with?", "Glazing", choices)
	if(!choice)
		return TRUE

	if(QDELETED(target) || target.glazed || !in_range(target, user))
		return TRUE

	if(!do_after(user, 3 SECONDS, target = target))
		return TRUE
	if(target.glazed)
		return TRUE

	target.glazed = TRUE
	target.glaze_suffix = glaze_finishes[choice]
	target.glaze_bonus_flat = rand(5, 15)
	target.icon_state = "[target.icon_state]_[target.glaze_suffix]"
	target.update_icon()
	playsound(loc, "sound/foley/scrubbing[pick(1,2)].ogg", 60, TRUE)
	user.visible_message(span_notice("[user] glazes [target]."), \
		span_notice("I glaze [target] with [LOWER_TEXT(choice)]."))
	return TRUE

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
