/obj/item/clothing/underwear_top
	abstract_type = /obj/item/clothing/underwear_top
	name = "underwear top"
	desc = "An absolute necessity, for your chest."
	icon = 'icons/obj/items/clothes/underwear_top.dmi'
	gendered = TRUE
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/underwear_top.dmi'
	icon_state = "bra"
	item_state = "bra"
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
	extra_slot_flags = EXTRA_SLOT_UNDERWEAR_TOP
	flags_inv = HIDEBOOB

/obj/item/clothing/underwear_top/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.underwear_top)
			if(H.is_inventory_slot_obscured(SLOT_UNDERWEAR_TOP, src))
				return
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, target = H))
				equip_from_hands(user, H, SLOT_UNDERWEAR_TOP)

/obj/item/clothing/underwear_top/bra
	name = "bra"
	desc = "The centerpiece of a bathing suit."
	icon_state = "bra"
	item_state = "bra"
	boob_sized = TRUE

/datum/crafting_recipe/roguetown/sewing/underwear_top
	name = "Bra"
	category = "Underwear"
	result = list(/obj/item/clothing/underwear_top/bra)
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
