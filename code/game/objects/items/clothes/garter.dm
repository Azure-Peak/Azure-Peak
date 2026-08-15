/obj/item/clothing/garter
	name = "garters"
	desc = "Holds up what's the most precios."
	icon = 'icons/obj/items/clothes/garters.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/garters.dmi'
	icon_state = "garters"
	item_state = "garters"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	slot_flags = SLOT_GARTER

/obj/item/clothing/garter/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.garter)
			if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
				return
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, target = H))
				H.equip_to_slot_if_possible(src, SLOT_GARTER, disable_warning = TRUE)