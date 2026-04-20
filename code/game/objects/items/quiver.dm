/obj/item/quiver
	name = "quiver"
	desc = "A light, slingable bag that can store arrows. It is the best friend of many-a-plucksome archer."
	icon_state = "quiver0"
	item_state = "quiver"
	flags_ai_inventory = AI_ITEM_QUIVER
	icon = 'icons/roguetown/weapons/ammo.dmi'
	//lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	//righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	max_integrity = 0
	sellprice = 2 // Shouldn't have added value lmao
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	strip_delay = 20
	var/max_storage = 20 // Weight budget. Regular ammo = 1 weight each.
	var/list/arrows = list()
	var/preferred_ammo_type
	var/allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	sewrepair = TRUE
	experimental_inhand = TRUE
	experimental_onhip = TRUE
	experimental_onback = TRUE

/obj/item/quiver/getonmobprop(tag)
	..()
	if(tag)
		switch(tag)
			if("onback")
				return list(
					"shrink" = 0.5,
					"sx" = 1,
					"sy" = 4,
					"nx" = 1,
					"ny" = 2,
					"wx" = 3,
					"wy" = 3,
					"ex" = 0,
					"ey" = 2,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
			if("onbelt")
				return list(
					"shrink" = 0.35,
					"sx" = -4,
					"sy" = -6,
					"nx" = 5,
					"ny" = -6,
					"wx" = 0,
					"wy" = -6,
					"ex" = -1,
					"ey" = -6,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = -90,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 1
				)
			if("gen")
				return list(
					"shrink" = 0.4,
					"sx" = -7,
					"sy" = -4,
					"nx" = 7,
					"ny" = -4,
					"wx" = -4,
					"wy" = -4,
					"ex" = 2,
					"ey" = -4,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 0
				)

/obj/item/quiver/proc/get_current_weight()
	. = 0
	for(var/obj/item/ammo_casing/caseless/rogue/A in arrows)
		. += A.ammo_weight

/obj/item/quiver/proc/get_ammo_types()
	var/list/types = list()
	for(var/obj/item/ammo_casing/caseless/rogue/A in arrows)
		if(!(A.type in types))
			types[A.type] = list("name" = A.name, "count" = 1, "ref" = A)
		else
			types[A.type]["count"]++
	return types

/obj/item/quiver/proc/pick_ammo(ammo_base_type)
	var/obj/item/ammo_casing/caseless/rogue/fallback
	for(var/obj/item/ammo_casing/caseless/rogue/A in arrows)
		if(ammo_base_type && !istype(A, ammo_base_type))
			continue
		if(!fallback)
			fallback = A
		if(preferred_ammo_type && istype(A, preferred_ammo_type))
			return A
	if(preferred_ammo_type)
		preferred_ammo_type = fallback?.type
	return fallback

/obj/item/quiver/attack_turf(turf/T, mob/living/user)
	if(get_current_weight() >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/arrow in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(arrow))
				break

/obj/item/quiver/proc/eatarrow(obj/A)
	if(!istype(A, allowed_ammo_type))
		return FALSE
	var/obj/item/ammo_casing/caseless/rogue/ammo = A
	if(get_current_weight() + ammo.ammo_weight <= max_storage)
		A.forceMove(src)
		arrows += A
		update_icon()
		return TRUE
	return FALSE

/obj/item/quiver/attack_self(mob/living/user)
	..()

	if (!arrows.len)
		return
	to_chat(user, span_warning("I begin to take out the arrows from [src], one by one..."))
	for(var/obj/item/ammo_casing/caseless/rogue/arrow in arrows)
		if(!do_after(user, 0.5 SECONDS))
			return
		arrow.forceMove(user.loc)
		arrows -= arrow

	update_icon()

/obj/item/quiver/attackby(obj/A, loc, params)
	if(istype(A, /obj/item/ammo_casing/caseless/rogue))
		if(!istype(A, allowed_ammo_type))
			to_chat(loc, span_warning("That doesn't fit in [src]."))
			return FALSE
		var/obj/item/ammo_casing/caseless/rogue/ammo = A
		if(get_current_weight() + ammo.ammo_weight <= max_storage)
			if(ismob(loc))
				var/mob/M = loc
				M.doUnEquip(A, TRUE, src, TRUE, silent = TRUE)
			else
				A.forceMove(src)
			arrows += A
			update_icon()
		else
			to_chat(loc, span_warning("Full!"))
		return
	if(istype(A, /obj/item/gun/ballistic/revolver/grenadelauncher/bow))
		var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/B = A
		if(arrows.len && !B.chambered)
			var/obj/item/ammo_casing/caseless/rogue/AR = pick_ammo(/obj/item/ammo_casing/caseless/rogue/arrow)
			if(AR)
				arrows -= AR
				B.attackby(AR, loc, params)
				if(ismob(loc))
					var/mob/M = loc
					if(HAS_TRAIT(M, TRAIT_COMBAT_AWARE))
						M.balloon_alert(M, "[length(arrows)] left...")
				update_icon()
		return
	..()

/obj/item/quiver/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/ShiftRightClick(mob/user)
	..()
	if(!user.canUseTopic(src, BE_CLOSE))
		return TRUE
	var/list/ammo_types = get_ammo_types()
	if(!length(ammo_types))
		to_chat(user, span_warning("[src] is empty."))
		return TRUE
	if(length(ammo_types) < 2)
		to_chat(user, span_notice("Only one ammo type loaded."))
		return TRUE
	var/list/choices = list()
	var/list/label_to_type = list()
	for(var/ammo_path in ammo_types)
		var/list/info = ammo_types[ammo_path]
		var/obj/item/ammo_casing/caseless/rogue/ref_ammo = info["ref"]
		var/label = "[info["name"]] ([info["count"]])"
		choices[label] = image(icon = ref_ammo.icon, icon_state = ref_ammo.icon_state)
		label_to_type[label] = ammo_path
	var/choice = show_radial_menu(user, src, choices, tooltips = TRUE)
	if(!choice || !label_to_type[choice])
		return TRUE
	preferred_ammo_type = label_to_type[choice]
	to_chat(user, span_notice("Selected: [ammo_types[preferred_ammo_type]["name"]]."))
	return TRUE

/obj/item/quiver/examine(mob/user)
	. = ..()
	if(!arrows.len)
		. += span_notice("Empty.")
		return
	. += span_notice("[arrows.len] inside. ([get_current_weight()]/[max_storage] weight)")
	var/list/ammo_types = get_ammo_types()
	for(var/ammo_path in ammo_types)
		var/list/info = ammo_types[ammo_path]
		var/selected_marker = (ammo_path == preferred_ammo_type) ? " (selected)" : ""
		. += span_notice("  [info["name"]] x[info["count"]][selected_marker]")

/obj/item/quiver/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click the quiver with a bow or sling to quick-load.")
	. += span_info("Left-click on the ground to pick up ammo.")
	. += span_info("Shift-Right-click to select which ammo type to load first.")
	. += span_info("Ctrl-Click to drop all ammo on the ground one by one.")
	. += span_info("Right-click to pull out a single piece of ammo.")

/obj/item/quiver/update_icon()
	if(arrows.len)
		icon_state = "quiver1"
	else
		icon_state = "quiver0"

/obj/item/quiver/arrows/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/iron/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/stonearrows/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/stone/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bluntarrows/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/poisonarrows/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/poison/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/pyroarrows/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/elemental/fire/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/Parrows/Initialize()
	. = ..()

/obj/item/quiver/Warrows/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/water/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bodkin/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/steel/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/paalloy/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/steel/paalloy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/broadhead_aalloy/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/silver/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/silver/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bronzearrows/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/bronze/A = new()
		arrows += A
	update_icon()

//////////// Note - silver quivers and bolt pouches shouldn't be obtainable through normal circumstances.
// BOLTS  // For now, they should only be available as uncraftable singles.
////////////

/obj/item/quiver/bolt
	name = "bolt pouch"
	desc = "A leather canister that can be used to carry bolts. Smaller, sleeker, yet nevertheless spacious enough to pack enough ammunition for a full nite's hunt."
	icon_state = "boltpouch0"
	item_state = "boltpouch"
	max_storage = 16
	sellprice = 10
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt

/obj/item/quiver/bolt/getonmobprop(tag)
	..()
	if(tag)
		switch(tag)
			if("onback")
				return list(
					"shrink" = 0.4,
					"sx" = 1,
					"sy" = 4,
					"nx" = 1,
					"ny" = 2,
					"wx" = 3,
					"wy" = 3,
					"ex" = 0,
					"ey" = 2,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = 0,
					"eturn" = 0,
					"nflip" = 8,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 1,
					"southabove" = 0,
					"eastabove" = 0,
					"westabove" = 0
				)
			if("onbelt")
				return list(
					"shrink" = 0.35,
					"sx" = -4,
					"sy" = -6,
					"nx" = 5,
					"ny" = -6,
					"wx" = 0,
					"wy" = -6,
					"ex" = -1,
					"ey" = -6,
					"nturn" = 0,
					"sturn" = 0,
					"wturn" = -90,
					"eturn" = 0,
					"nflip" = 0,
					"sflip" = 0,
					"wflip" = 0,
					"eflip" = 0,
					"northabove" = 0,
					"southabove" = 1,
					"eastabove" = 1,
					"westabove" = 1
				)

/obj/item/quiver/bolt/attack_turf(turf/T, mob/living/user)
	if(get_current_weight() >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/bolt in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(bolt))
				break

/obj/item/quiver/bolt/update_icon()
	if(arrows.len)
		icon_state = "boltpouch1"
	else
		icon_state = "boltpouch0"

/obj/item/quiver/bolt/standard/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/aalloy/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/aalloy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/bronze/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/bronze/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/paalloy/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/paalloy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/blunt/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/holy/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/holy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/pyro/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/pyro/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/water/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/water/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/silver/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/silver/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/light/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/light/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/silver/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/bronze/A = new()
		arrows += A
	update_icon()

/////////////
// BOLT, H.//
/////////////

/obj/item/quiver/bolt/heavy
	name = "heavy bolt pouch"
	desc = "A heavy leather canister that can be used to carry heavier bolts. Casketed inside are the missiles that, whether launched from a mounted ballista or handheld siegebow, will devastate without quarter."
	icon_state = "boltpouch0"
	item_state = "boltpouch"
	max_storage = 8
	sellprice = 10
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt

/obj/item/quiver/bolt/heavy/attack_turf(turf/T, mob/living/user)
	if(get_current_weight() >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/heavy_bolt in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(heavy_bolt))
				break

/obj/item/quiver/bolt/heavy/update_icon()
	if(arrows.len)
		icon_state = "boltpouch1"
	else
		icon_state = "boltpouch0"

/obj/item/quiver/bolt/heavy/standard/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavy/bronze/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/bronze/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavy/aalloy/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/aalloy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavy/paalloy/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/paalloy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavy/blunt/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavy/silver/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/silver/A = new()
		arrows += A
	update_icon()

//////////////
// JAVELINS //
//////////////

/obj/item/quiver/javelin
	name = "javelinbag"
	desc = "A heavy, hip-hookable sleeve that can carry javelins. It has yet to reclaim the same love it once had, during the wars of pre-Syonic antiquity."
	icon_state = "javelinbag0"
	item_state = "javelinbag"
	max_storage = 20 // Javelins weigh 5 each, so 4 javelins at full capacity
	sellprice = 10
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/javelin

/obj/item/quiver/javelin/attack_turf(turf/T, mob/living/user)
	if(get_current_weight() >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/javelin in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(javelin))
				break

/obj/item/quiver/javelin/update_icon()
	if(arrows.len)
		icon_state = "javelinbag1"
	else
		icon_state = "javelinbag0"

/obj/item/quiver/javelin/iron/Initialize()
	..()
	for(var/i in 1 to 4)
		var/obj/item/ammo_casing/caseless/rogue/javelin/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin/steel/Initialize()
	..()
	for(var/i in 1 to 4)
		var/obj/item/ammo_casing/caseless/rogue/javelin/steel/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin/paalloy/Initialize()
	..()
	for(var/i in 1 to 4)
		var/obj/item/ammo_casing/caseless/rogue/javelin/steel/paalloy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin/bronze/Initialize()
	..()
	for(var/i in 1 to 4)
		var/obj/item/ammo_casing/caseless/rogue/javelin/bronze/A = new()
		arrows += A
	update_icon()

////////////
// SLINGS //
////////////

/obj/item/quiver/sling
	name = "sling bullet pouch"
	desc = "A pouch that can be packed with a perplexing amount of pebble-like projectiles. </br>'This pouch packs the ouch!' </br>I can quickly ready a bullet by left-clicking on the pouch with my sling."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "slingpouch"
	item_state = "slingpouch"
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_NECK
	max_storage = 40
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 32
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet

/obj/item/quiver/sling/attack_turf(turf/T, mob/living/user)
	if(get_current_weight() >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/sling_bullet in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(sling_bullet))
				break

/obj/item/quiver/sling/attackby(obj/A, loc, params)
	if(istype(A, /obj/item/gun/ballistic/revolver/grenadelauncher/sling))
		var/obj/item/gun/ballistic/revolver/grenadelauncher/sling/B = A
		if(arrows.len && !B.chambered)
			var/obj/item/ammo_casing/caseless/rogue/AR = pick_ammo(/obj/item/ammo_casing/caseless/rogue/sling_bullet)
			if(AR)
				arrows -= AR
				B.attackby(AR, loc, params)
		return
	..()

/obj/item/quiver/sling/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/sling/update_icon()
	return

/obj/item/quiver/sling/stone/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/iron/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/steel/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/aalloy/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/aalloy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/paalloy/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/paalloy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/bronze/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/scattershot/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/heavy_sling_bullet/Initialize()
	. = ..()
	for(var/i in 1 to 13) // 3 weight each, 13 rocks = 39/40 capacity
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/heavy_sling_bullet/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/sling/fire_pot/Initialize()
	. = ..()
	for(var/i in 1 to 13) // 3 weight each, 13 pots = 39/40 capacity
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/fire_pot/A = new()
		arrows += A
	update_icon()
