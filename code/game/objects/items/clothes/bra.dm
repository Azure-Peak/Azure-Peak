/obj/item/clothing/bra
	name = "bra"
	desc = "An absolute necessity, for your chest."
	icon = 'icons/obj/items/clothes/bra.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/bra.dmi'
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
	slot_flags = SLOT_UNDER_TOP
	flags_inv = HIDEBOOB

/obj/item/clothing/bra/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.bra)
			if(!get_location_accessible(H, BODY_ZONE_CHEST))
				return
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, target = H))
				H.equip_to_slot_if_possible(src, SLOT_UNDER_TOP, disable_warning = TRUE)

/obj/item/clothing/bra/bikini
	name = "bikini top"
	desc = "The centerpiece of a bathing suit."
	icon_state = "bikini_top"
	item_state = "bikini_top"
	boob_sized = TRUE