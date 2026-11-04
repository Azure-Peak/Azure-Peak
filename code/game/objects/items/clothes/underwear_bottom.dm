/obj/item/clothing/underwear_bottom
	name = "briefs"
	desc = "An absolute necessity."
	icon = 'icons/obj/items/clothes/underwear_bottom.dmi'
	gendered = TRUE
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/underwear_bottom.dmi'
	icon_state = "briefs"
	item_state = "briefs"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	var/covers_breasts = FALSE
	/// Compatibility renderer for accessories retained by old loadouts.
	var/sprite_acc
	var/worn_icon_state
	var/icon_state_base
	boob_sized = FALSE
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	slot_flags = ITEM_SLOT_MOUTH
	extra_slot_flags = EXTRA_SLOT_UNDER_BOTTOM
	muteinmouth = TRUE
	flags_inv = HIDECROTCH

/obj/item/clothing/underwear_bottom/Initialize(mapload, ...)
	. = ..()
	icon_state_base = icon_state

/obj/item/clothing/underwear_bottom/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.underwear_bottom)
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
				return
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, target = H))
				equip_from_hands(user, H, SLOT_UNDER_BOTTOM)

/obj/item/clothing/underwear_bottom/equipped(mob/living/carbon/user, slot)
	. = ..()
	if(user.mouth == src)
		flags_inv = null
		icon_state = null
		user.update_body()
		user.update_body_parts()

/obj/item/clothing/underwear_bottom/dropped(mob/user)
	. = ..()
	flags_inv = initial(flags_inv)
	icon_state = icon_state_base

/obj/item/clothing/underwear_bottom/bikini_bottom
	worn_icon_state = "bikini"
	name = "bikini bottom"
	desc = "A perfect bathing garment."
	icon_state = "bikini_bottom"
	item_state = "bikini_bottom"
	gendered = TRUE

/obj/item/clothing/underwear_bottom/panties
	name = "panties"
	icon_state = "panties"
	item_state = "panties"
	gendered = FALSE

/obj/item/clothing/underwear_bottom/braies
	name = "braies"
	desc = "A pair of linen underpants; Psydonia's most common."
	icon_state = "braies"
	item_state = "braies"

/obj/item/clothing/underwear_bottom/briefs_eoran
	sprite_acc = /datum/sprite_accessory/underwear_bottom_render/briefs/eoran
	name = "eoran briefs"
	icon_state = "briefs"
	item_state = "briefs"

/obj/item/clothing/underwear_bottom/bandages
	icon = 'icons/mob/sprite_accessory/underwear_bottom.dmi'
	sprite_acc = /datum/sprite_accessory/underwear_bottom_render/bandages
	covers_breasts = TRUE
	flags_inv = HIDECROTCH | HIDEBOOB
	name = "bandages"
	icon_state = "bandages"
	item_state = "bandages"

/datum/crafting_recipe/roguetown/sewing/underwear_bottom
	name = "briefs"
	result = list(/obj/item/clothing/underwear_bottom)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/underwear_bottom/briefs_eoran
	name = "briefs - eoran"
	result = list(/obj/item/clothing/underwear_bottom/briefs_eoran)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/underwear_bottom/bikini
	name = "bikini bottom"
	result = list(/obj/item/clothing/underwear_bottom/bikini_bottom)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/underwear_bottom/panties
	name = "panties"
	result = list(/obj/item/clothing/underwear_bottom/panties)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/underwear_bottom/braies
	name = "braies"
	result = list(/obj/item/clothing/underwear_bottom/braies)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

/obj/item/clothing/underwear_bottom/build_worn_icon(default_layer = 0, default_icon_file = null, isinhands = FALSE, femaleuniform = NO_FEMALE_UNIFORM, override_state = null, female = FALSE, customi = null, sleeveindex, boobed_overlay = FALSE, icon/clip_mask = null, breast_size = 0)
	if(worn_icon_state && !isinhands)
		override_state = worn_icon_state
	if(!sprite_acc || isinhands)
		return ..()
	var/atom/container = loc
	var/mob/living/carbon/human/wearer = ishuman(container) ? container : container?.loc
	if(!istype(wearer))
		return ..()
	var/obj/item/bodypart/chest = wearer.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return ..()
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(sprite_acc)
	var/mutable_appearance/standing = mutable_appearance(layer = -default_layer)
	// Worn clothing must not hide its own accessory through HIDECROTCH/HIDEBOOB.
	var/list/pieces = accessory.get_overlay(accessory.get_icon_state(null, chest, wearer), color)
	// update_inv_underwear_bottom() applies the body-build offset once to the wrapper.
	standing.add_overlay(pieces)
	return standing
