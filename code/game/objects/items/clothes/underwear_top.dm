/obj/item/clothing/underwear/top
	abstract_type = /obj/item/clothing/underwear/top
	name = "underwear top"
	desc = "An absolute necessity, for your chest."
	icon = 'icons/obj/items/clothes/underwear_top.dmi'
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/underwear_top.dmi'
	icon_state = "bra"
	item_state = "bra"
	extra_slot_flags = EXTRA_SLOT_UNDERWEAR_TOP
	flags_inv = HIDEBOOB

/obj/item/clothing/underwear/top/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.underwear_top)
			if(H.is_inventory_slot_obscured(SLOT_UNDERWEAR_TOP, src))
				return
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, target = H))
				equip_from_hands(user, H, SLOT_UNDERWEAR_TOP)

/obj/item/clothing/underwear/top/bra
	name = "bra"
	desc = "The centerpiece of a bathing suit."
	icon_state = "bra"
	item_state = "bra"
	boob_sized = TRUE

/datum/crafting_recipe/roguetown/sewing/underwear_top
	name = "bra"
	category = "Underwear"
	result = list(/obj/item/clothing/underwear/top/bra)
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 2
