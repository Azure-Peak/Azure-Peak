/obj/item/clothing/undies
	name = "briefs"
	desc = "An absolute necessity."
	icon = 'icons/obj/items/clothes/underwear.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/underwear.dmi'
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
	var/icon_state_base
	boob_sized = FALSE
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	slot_flags = ITEM_SLOT_MOUTH | ITEM_SLOT_UNDER_BOTTOM
	muteinmouth = TRUE
	flags_inv = HIDECROTCH

/obj/item/clothing/undies/Initialize(mapload, ...)
	. = ..()
	icon_state_base = icon_state

/obj/item/clothing/undies/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.underwear)
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
				return
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, target = H))
				H.equip_to_slot_if_possible(src, ITEM_SLOT_UNDER_BOTTOM, disable_warning = TRUE)

/obj/item/clothing/undies/equipped(mob/living/carbon/user, slot)
	. = ..()
	if(user.mouth == src)
		flags_inv = null
		icon_state = null
		user.update_body()
		user.update_body_parts()

/obj/item/clothing/undies/dropped(mob/user)
	. = ..()
	flags_inv = HIDECROTCH
	icon_state = icon_state_base

/obj/item/clothing/undies/bikini_bottom
	name = "bikini bottom"
	desc = "A perfect bathing garment."
	icon_state = "bikini_bottom"
	item_state = "bikini_bottom"
	gendered = TRUE

/obj/item/clothing/undies/panties
	name = "panties"
	icon_state = "panties"
	item_state = "panties"
	gendered = FALSE

/obj/item/clothing/undies/braies
	name = "braies"
	desc = "A pair of linen underpants; Psydonia's most common."
	icon_state = "braies"
	item_state = "braies"

/obj/item/clothing/undies/briefs_eoran
	name = "eoran briefs"
	icon_state = "eoran_reg"
	item_state = "braies"

/obj/item/undies/bandages
	name = "bandages"
	icon_state = "bandages"
	item_state = "bandages"

/datum/crafting_recipe/roguetown/sewing/undies
	name = "briefs"
	result = list(/obj/item/clothing/undies)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/undies_eoran
	name = "briefs - eoran"
	result = list(/obj/item/clothing/undies/briefs_eoran)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/bikini_bottom
	name = "bikini bottom"
	result = list(/obj/item/clothing/undies/bikini_bottom)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/panties
	name = "panties"
	result = list(/obj/item/clothing/undies/panties)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/braies
	name = "braies"
	result = list(/obj/item/clothing/undies/braies)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2
