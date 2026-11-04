/obj/item/clothing/underwear_top
	abstract_type = /obj/item/clothing/underwear_top
	name = "underwear top"
	desc = "An absolute necessity, for your chest."
	icon = 'icons/obj/items/clothes/underwear_top.dmi'
	gendered = TRUE
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/underwear_top.dmi'
	icon_state = "bikini_top"
	item_state = "bikini_top"
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
	extra_slot_flags = EXTRA_SLOT_UNDER_TOP
	flags_inv = HIDEBOOB

/obj/item/clothing/underwear_top/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.bra)
			if(!get_location_accessible(H, BODY_ZONE_CHEST))
				return
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, target = H))
				equip_from_hands(user, H, SLOT_UNDER_TOP)

/obj/item/clothing/underwear_top/bikini
	name = "bikini top"
	desc = "The centerpiece of a bathing suit."
	icon_state = "bikini_top"
	item_state = "bikini_top"
	boob_sized = TRUE
