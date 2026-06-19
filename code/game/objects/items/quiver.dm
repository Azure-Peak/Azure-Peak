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

/obj/item/quiver/bolt/lightholy/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/lightholy/A = new()
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

/obj/item/quiver/bolt/heavy/stake/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/stake/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/heavy/stake_silver/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/stake_silver/A = new()
		arrows += A
	update_icon()

/////////////
// STAKES  //
/////////////

/obj/item/quiver/bolt/stake
	name = "shotstake pouch"
	desc = "A light leather canister with specially-tailored hoops on the inside, made for carrying heat-treated shotstakes by the dozens."
	icon_state = "stakepouch0"
	item_state = "stakepouch"
	max_storage = 24
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/stake

/obj/item/quiver/bolt/stake/attack_turf(turf/T, mob/living/user)
	if(get_current_weight() >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/stake in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(stake))
				break

/obj/item/quiver/bolt/stake/update_icon()
	if(arrows.len)
		icon_state = "stakepouch1"
	else
		icon_state = "stakepouch0"

/obj/item/quiver/bolt/stake/standard/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/stake/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolt/stake/silver/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/stake/silver/A = new()
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
	
// ============================================================
// MECHANIZED QUIVERS
// Three variants: bow, crossbow, siegebow
// - Auto-pickup of matching ammo when walking over it
// - Stores the matching ranged weapon via holster component
// - Crafted at the autosmither
// ============================================================

// ---- BASE TYPE ----

/obj/item/quiver/mechanized
	name = "mechanized quiver"
	desc = "A cogwork quiver that automatically collects ammunition."
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "mechquiver0"
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	max_integrity = 400
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	//whether a weapon can go on a particular quiver
	var/obj/item/gun/ballistic/revolver/grenadelauncher/valid_weapon
	var/obj/item/gun/ballistic/revolver/grenadelauncher/holstered_weapon
	//we're giving it the same delay as the great weapon straps have
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	strip_delay = 2 SECONDS
	var/sheathe_time = 2 SECONDS
	//these control the pixel adjustment for hanging bows/crossbows on
	var/bowoverlay_x = 8
	var/bowoverlay_y = -4

//referencing the mechanized ore bag code for the autopickup part. look in storage.dm
/obj/item/quiver/mechanized/equipped(mob/living/user, slot)
	. = ..()
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(on_user_moved))

/obj/item/quiver/mechanized/dropped(mob/living/user)
	. = ..()
	UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/obj/item/quiver/mechanized/proc/on_user_moved(mob/living/source)
	SIGNAL_HANDLER
	if(!source || source.incapacitated())
		return
	// tried to use the signal handler from the ore bag but it gave warnings about passive listenders, went with a recommended use of the async process
	INVOKE_ASYNC(src, PROC_REF(pickup_from_turf), get_turf(source), source)

//compartmentalized arrow pickup
/obj/item/quiver/mechanized/proc/pickup_from_turf(turf/T, mob/living/user)
	for(var/obj/item/ammo_casing/caseless/rogue/A in T.contents)
		if(!istype(A, allowed_ammo_type))
			continue
		if(get_current_weight() >= max_storage)
			break
		eatarrow(A)

//copying parts in from great weapon straps
/obj/item/quiver/mechanized/proc/holster_bow(obj/item/gun/ballistic/revolver/grenadelauncher/W, mob/living/user)
	if(!istype(W, valid_weapon))
		if(user)
			to_chat(user, span_warning("[W] doesn't fit in [src]. Only Bows"))
		return FALSE
	if(holstered_weapon)
		if(user)
			to_chat(user, span_warning("[src] already has [holstered_weapon.name] holstered."))
		return FALSE
	W.forceMove(src)
	holstered_weapon = W
	if(!move_after(user, sheathe_time, target = user))
		return FALSE
	if(user)
		to_chat(user, span_notice("I stow [W] into [src]."))
		playsound(src, 'sound/misc/chestclose.ogg', 30, TRUE)
	update_icon()
	return TRUE

/obj/item/quiver/mechanized/proc/draw_bow(mob/living/user)
	if(!holstered_weapon)
		to_chat(user, span_warning("Nothing is holstered in [src]."))
		return FALSE
	if(!move_after(user, sheathe_time, target = user))
		return FALSE
	var/obj/item/gun/ballistic/revolver/grenadelauncher/W = holstered_weapon
	holstered_weapon = null
	if(!user.put_in_active_hand(W))
		W.forceMove(get_turf(user))
	playsound(src, 'sound/misc/chestclose.ogg', 30, TRUE)
	update_icon()
	return TRUE

/obj/item/quiver/mechanized/MiddleClick(mob/living/user)
	//pull out the bow if its holstered
	if(holstered_weapon)
		draw_bow(user)
		return
	// nothing is holstered, are we carrying a valid bow?
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		to_chat(user, span_warning("I'm not holding anything to stow in [src]."))
		return
	if(!valid_weapon || !istype(held, valid_weapon))
		to_chat(user, span_warning("[held] doesn't fit in [src]."))
		return
	if(user.transferItemToLoc(held, src))
		holstered_weapon = held
		to_chat(user, span_notice("I holster [held] into [src]."))
		playsound(src, 'sound/misc/chestclose.ogg', 30, TRUE)
		update_icon()

/obj/item/quiver/mechanized/attack_right(mob/user)
	if(holstered_weapon)
		draw_bow(user)
		return TRUE
	return ..()

/obj/item/quiver/mechanized/examine(mob/user)
	. = ..()
	if(holstered_weapon)
		. += span_notice("Holstered: [holstered_weapon.name].")
	else
		. += span_warning("No weapon holstered. Left-click with a compatible weapon to holster it.")

/obj/item/quiver/mechanized/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Automatically picks up compatible ammo when you walk over it.")
	. += span_info("Left-click with a compatible weapon to holster it.")
	. += span_info("Right-click to draw the holstered weapon to your active hand.")

//this controls the overlays, you migh need to adjust the bowoverlay_x and bowoverlay_y vars in the specific quiver types depending on the graphic
/obj/item/quiver/mechanized/update_overlays()
	. = ..()
	if(!holstered_weapon)
		return
	var/mutable_appearance/weapon_overlay = mutable_appearance(
		holstered_weapon.icon,
		holstered_weapon.icon_state
	)
	var/matrix/M = matrix()
	M.Scale(0.5, 0.5)
	weapon_overlay.transform = M
	weapon_overlay.pixel_x = bowoverlay_x
	weapon_overlay.pixel_y = bowoverlay_y
	. += weapon_overlay

//we destroy both to ensure we don't have jankiness, hopefully?
/obj/item/quiver/mechanized/Destroy()
	if(holstered_weapon && !QDELETED(holstered_weapon))
		holstered_weapon.forceMove(get_turf(src))
	holstered_weapon = null
	return ..()

// ============================================================
// QUIVERS
// ============================================================

//bow and arrows
/obj/item/quiver/mechanized/bow
	name = "mechanized bow quiver"
	desc = "A mechanical quiver for bows and arrows, it will suck up arrows off the ground and hold a bow!"
	icon_state = "mechquiver0"
	max_storage = 20
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	valid_weapon = /obj/item/gun/ballistic/revolver/grenadelauncher/bow

/obj/item/quiver/mechanized/bow/update_icon()
	icon_state = arrows.len ? "mechquiver1" : "mechquiver0"
	// Rebuild overlays whenever icon updates so holstered weapon shows
	bowoverlay_x = -14
	bowoverlay_y = -14
	cut_overlays()
	var/list/new_overlays = update_overlays()
	if(length(new_overlays))
		overlays = new_overlays

//crossbow, slurbow, bolts, and light bolts
/obj/item/quiver/mechanized/crossbow
	name = "mechanized bolt quiver"
	desc = "A mechanical bolt pouch for crossbows, slurbows, and bolts. It will suck up bolts off the ground and hold a crossbow or slurbow!"
	icon_state = "mechboltpouch0"
	max_storage = 16
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt
	valid_weapon = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow

/obj/item/quiver/mechanized/crossbow/update_icon()
	icon_state = arrows.len ? "mechboltpouch1" : "mechboltpouch0"
	cut_overlays()
	var/list/new_overlays = update_overlays()
	if(length(new_overlays))
		overlays = new_overlays

// Accept both standard bolts and light bolts
/obj/item/quiver/mechanized/crossbow/eatarrow(obj/A)
	if(!istype(A, /obj/item/ammo_casing/caseless/rogue/bolt) && \
	   !istype(A, /obj/item/ammo_casing/caseless/rogue/bolt/light))
		return FALSE
	var/obj/item/ammo_casing/caseless/rogue/ammo = A
	if(get_current_weight() + ammo.ammo_weight <= max_storage)
		A.forceMove(src)
		arrows += A
		update_icon()
		return TRUE
	return FALSE

/obj/item/quiver/mechanized/crossbow/pickup_from_turf(turf/T, mob/living/user)
	// Standard bolts
	for(var/obj/item/ammo_casing/caseless/rogue/bolt/A in T.contents)
		if(istype(A, /obj/item/ammo_casing/caseless/rogue/heavy_bolt))
			continue // skip heavy bolts
		if(get_current_weight() >= max_storage)
			break
		eatarrow(A)
	// Light bolts
	for(var/obj/item/ammo_casing/caseless/rogue/bolt/light/A in T.contents)
		if(get_current_weight() >= max_storage)
			break
		eatarrow(A)

/obj/item/quiver/mechanized/crossbow/holster_bow(obj/item/gun/ballistic/revolver/grenadelauncher/W, mob/living/user)
	if(!istype(W, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow) || \
	    istype(W, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy))
		if(user)
			to_chat(user, span_warning("[W] doesn't fit — it can carry only crossbows and slurbows."))
		return FALSE
	return ..()

/obj/item/quiver/mechanized/crossbow/MiddleClick(mob/living/user)
	//if there's somthing holstered, pull it out
	if(holstered_weapon)
		draw_bow(user)
		return
	//next we check what we're holding and holster it if its valid
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		to_chat(user, span_warning("I'm not holding anything to stow in [src]."))
		return
	if(!istype(held, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow) || \
	    istype(held, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/slurbow))
		to_chat(user, span_warning("[held] doesn't fit — only crossbows and slurbows."))
		return
	if(user.transferItemToLoc(held, src))
		holstered_weapon = held
		to_chat(user, span_notice("I clip [held] to [src]."))
		playsound(src, 'sound/misc/chestclose.ogg', 30, TRUE)
		update_icon()

// ============================================================
// SIEGEBOW QUIVER — heavy bolts only, siegebow only
// ============================================================

/obj/item/quiver/mechanized/siegebow
	name = "mechanized heavy bolt quiver"
	desc = "A mechanical heavy bolt pouch for siegebows and heavy bolts. It will suck up heavy bolts off the ground and hold a siegebow!"
	icon_state = "mechboltpouch0"
	w_class = WEIGHT_CLASS_HUGE
	max_storage = 8
	allowed_ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt
	valid_weapon = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy

/obj/item/quiver/mechanized/siegebow/update_icon()
	icon_state = arrows.len ? "mechboltpouch1" : "mechboltpouch0"
	cut_overlays()
	var/list/new_overlays = update_overlays()
	if(length(new_overlays))
		overlays = new_overlays

/obj/item/quiver/mechanized/siegebow/pickup_from_turf(turf/T, mob/living/user)
	for(var/obj/item/ammo_casing/caseless/rogue/heavy_bolt/A in T.contents)
		if(get_current_weight() >= max_storage)
			break
		eatarrow(A)
	if(!holstered_weapon)
		for(var/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/W in T.contents)
			holster_bow(W, null)
			break

/obj/item/quiver/mechanized/siegebow/holster_bow(obj/item/gun/ballistic/revolver/grenadelauncher/W, mob/living/user)
	if(!istype(W, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy))
		if(user)
			to_chat(user, span_warning("[W] doesn't fit — it can carry only siegebows."))
		return FALSE
	return ..()

/obj/item/quiver/mechanized/siegebow/MiddleClick(mob/living/user)
	//if there's somthing holstered, pull it out
	if(holstered_weapon)
		draw_bow(user)
		return
	//next we check what we're holding and holster it if its valid
	var/obj/item/held = user.get_active_held_item()
	if(!held)
		to_chat(user, span_warning("I'm not holding anything to stow in [src]."))
		return
	if(!istype(held, /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy))
		to_chat(user, span_warning("[held] doesn't fit — this pouch can only hold siegebows."))
		return
	if(user.transferItemToLoc(held, src))
		holstered_weapon = held
		to_chat(user, span_notice("I strap [held] to [src]."))
		playsound(src, 'sound/misc/chestclose.ogg', 30, TRUE)
		update_icon()
