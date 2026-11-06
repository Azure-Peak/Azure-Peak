/obj/item/clothing/underwear
	abstract_type = /obj/item/clothing/underwear
	gendered = TRUE
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	boob_sized = FALSE
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	slot_flags = NONE

/obj/item/clothing/underwear/bottom
	name = "briefs"
	desc = "An absolute necessity."
	icon = 'icons/obj/items/clothes/underwear_bottom.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/underwear_bottom.dmi'
	icon_state = "briefs"
	item_state = "briefs"
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	slot_flags = ITEM_SLOT_MOUTH
	extra_slot_flags = EXTRA_SLOT_UNDERWEAR_BOTTOM
	muteinmouth = TRUE
	flags_inv = HIDECROTCH

/obj/item/clothing/underwear/bottom/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.underwear_bottom)
			if(H.is_inventory_slot_obscured(SLOT_UNDERWEAR_BOTTOM, src))
				return
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, target = H))
				equip_from_hands(user, H, SLOT_UNDERWEAR_BOTTOM)

/obj/item/clothing/underwear/bottom/equipped(mob/living/carbon/user, slot)
	. = ..()
	if(user.mouth == src)
		flags_inv = null
		icon_state = null
		user.update_body()
		user.update_body_parts()

/obj/item/clothing/underwear/bottom/dropped(mob/user)
	. = ..()
	flags_inv = initial(flags_inv)
	icon_state = initial(icon_state)

/obj/item/clothing/underwear/bottom/panties
	name = "panties"
	icon_state = "panties"
	item_state = "panties"
	gendered = FALSE

/obj/item/clothing/underwear/bottom/braies
	name = "braies"
	desc = "A pair of linen underpants; Psydonia's most common."
	icon_state = "braies"
	item_state = "braies"

/obj/item/clothing/underwear/bottom/briefs_eoran
	name = "eoran briefs"
	icon_state = "eoran"
	item_state = "briefs"

/datum/crafting_recipe/roguetown/sewing/underwear_bottom
	name = "Briefs"
	category = "Underwear"
	result = list(/obj/item/clothing/underwear/bottom)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/underwear_bottom/briefs_eoran
	name = "Eoran Briefs"
	result = list(/obj/item/clothing/underwear/bottom/briefs_eoran)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/underwear_bottom/panties
	name = "Panties"
	result = list(/obj/item/clothing/underwear/bottom/panties)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/underwear_bottom/braies
	name = "Braies"
	result = list(/obj/item/clothing/underwear/bottom/braies)
	reqs = list(/obj/item/natural/cloth = 1)
	craftdiff = 2
