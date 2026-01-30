/obj/item/quiver
	name = "quiver"
	desc = "A light, slingable bag that can store arrows. It is the best friend of many-a-plucksome archer. </br>I can quickly nock an arrow by left-clicking on the quiver with my bow."
	icon_state = "quiver0"
	item_state = "quiver"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	lefthand_file = 'icons/mob/inhands/equipment/backpack_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/backpack_righthand.dmi'
	w_class = WEIGHT_CLASS_BULKY
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK
	resistance_flags = FIRE_PROOF
	max_integrity = 0
	sellprice = 2 // Shouldn't have added value lmao
	equip_sound = 'sound/blank.ogg'
	bloody_icon_state = "bodyblood"
	alternate_worn_layer = UNDER_CLOAK_LAYER
	strip_delay = 20
	var/max_storage = 20
	var/list/arrows = list()
	sewrepair = TRUE

/obj/item/quiver/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/arrow in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(arrow))
				break

/obj/item/quiver/proc/eatarrow(obj/A)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue))
		if(arrows.len < max_storage)
			A.forceMove(src)
			arrows += A
			update_icon()
			return TRUE
		else
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
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue))
		if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue/javelin))
			to_chat(loc, span_warning("Javelins are too big to fit in a quiver, silly!"))
			return FALSE
		else if(arrows.len < max_storage)
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
			for(var/AR in arrows)
				if(istype(AR, /obj/item/ammo_casing/caseless/rogue/arrow))
					arrows -= AR
					B.attackby(AR, loc, params)
					if(ismob(loc))
						var/mob/M = loc
						if(HAS_TRAIT(M, TRAIT_COMBAT_AWARE))
							M.balloon_alert(M, "[length(arrows)] left...")
					update_icon()
					break
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

/obj/item/quiver/examine(mob/user)
	. = ..()
	if(arrows.len)
		. += span_notice("[arrows.len] inside.")
	. += span_notice("Click on the ground to pick up ammo.")

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

/obj/item/quiver/arrows/bronze/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/bronze/A = new()
		arrows += A
	update_icon()


/obj/item/quiver/bluntarrows/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bolts/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/bluntbolts/Initialize()
	..()
	for(var/i in  1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/blunt/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/holybolts/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/holy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/Wbolts/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/water/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/pyrobolts/Initialize()
	. = ..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/pyro/A = new()
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
		var/obj/item/ammo_casing/caseless/rogue/arrow/pyro/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/Parrows/Initialize()
	. = ..()

/obj/item/quiver/bolts/paalloy/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/bolt/paalloy/A = new()
		arrows += A
	update_icon()

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

/obj/item/quiver/silver/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/arrow/silver/A = new()
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

/obj/item/quiver/bolt/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/bolt in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(bolt))
				break

/obj/item/quiver/bolt/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue/bolt))
		if(arrows.len < max_storage)
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
	..()

/obj/item/quiver/bolt/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/bolt/examine(mob/user)
	. = ..()
	if(arrows.len)
		. += span_notice("[arrows.len] inside.")

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

/obj/item/quiver/bolt/heavy/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/heavy_bolt in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(heavy_bolt))
				break

/obj/item/quiver/bolt/heavy/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue/heavy_bolt))
		if(arrows.len < max_storage)
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
	..()

/obj/item/quiver/bolt/heavy/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/bolt/heavy/examine(mob/user)
	. = ..()
	if(arrows.len)
		. += span_notice("[arrows.len] inside.")

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
	max_storage = 4
	sellprice = 10

/obj/item/quiver/javelin/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/javelin in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(javelin))
				break

/obj/item/quiver/javelin/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue/javelin))
		if(arrows.len < max_storage)
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
	..()

/obj/item/quiver/javelin/attack_right(mob/user)
	if(arrows.len)
		var/obj/O = arrows[arrows.len]
		arrows -= O
		O.forceMove(user.loc)
		user.put_in_hands(O)
		update_icon()
		return TRUE

/obj/item/quiver/javelin/examine(mob/user)
	. = ..()
	if(arrows.len)
		. += span_notice("[arrows.len] inside.")

/obj/item/quiver/javelin/update_icon()
	if(arrows.len)
		icon_state = "javelinbag1"
	else
		icon_state = "javelinbag0"

/obj/item/quiver/javelin/iron/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin/steel/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/steel/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin/paalloy/Initialize()
	..()
	for(var/i in 1 to max_storage)
		var/obj/item/ammo_casing/caseless/rogue/javelin/steel/paalloy/A = new()
		arrows += A
	update_icon()

/obj/item/quiver/javelin/bronze/Initialize()
	..()
	for(var/i in 1 to max_storage)
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
	max_storage = 20
	w_class = WEIGHT_CLASS_NORMAL
	grid_height = 64
	grid_width = 32

/obj/item/quiver/sling/attack_turf(turf/T, mob/living/user)
	if(arrows.len >= max_storage)
		to_chat(user, span_warning("My [src.name] is full!"))
		return
	to_chat(user, span_notice("I begin to gather the ammunition..."))
	for(var/obj/item/ammo_casing/caseless/rogue/sling_bullet in T.contents)
		if(do_after(user, 5))
			if(!eatarrow(sling_bullet))
				break

/obj/item/quiver/sling/attackby(obj/A, loc, params)
	if(A.type in subtypesof(/obj/item/ammo_casing/caseless/rogue/sling_bullet))
		if(arrows.len < max_storage)
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
	if(istype(A, /obj/item/gun/ballistic/revolver/grenadelauncher/sling))
		var/obj/item/gun/ballistic/revolver/grenadelauncher/sling/B = A
		if(arrows.len && !B.chambered)
			for(var/AR in arrows)
				if(istype(AR, /obj/item/ammo_casing/caseless/rogue/sling_bullet))
					arrows -= AR
					B.attackby(AR, loc, params)
					break
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
		var/obj/item/ammo_casing/caseless/rogue/sling_bullet/steel/A = new()
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
