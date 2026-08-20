/obj/item/repair_kit
	name = "sewing kit"
	icon_state = "sewingkit"
	desc = "A well-made repair kit that includes high-quality reinforced fabric lines and leather patches for field repairs. It can only ameliorate items, restoring their maximum integrity."
	icon = 'icons/roguetown/items/misc.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_HIP
	max_integrity = 7
	experimental_inhand = FALSE
	var/table_need = TRUE
	var/repair_type = 0 //0 - cloth; 1 - metal
	var/in_use = FALSE
	dropshrink = 0.7
	grid_width = 64
	grid_height = 32

/obj/item/repair_kit/examine()
	. = ..()
	if(src.obj_integrity > 0)
		. += span_bold("It has [src.obj_integrity] left.")
	else
		. += span_bold("It has no uses left.")

/obj/item/repair_kit/proc/self_del()
	if(repair_type == 0)
		if(prob(50))
			new /obj/item/natural/cloth(get_turf(src))
		if(prob(40))
			new /obj/item/natural/fibers(get_turf(src))
		if(prob(20))
			new /obj/item/natural/fibers(get_turf(src))
	if(repair_type == 1)
		if(prob(20))
			new /obj/item/scrap(get_turf(src))
	qdel(src)

/obj/item/repair_kit/attackby(obj/O, mob/living/user, params)
	if(!isitem(O))
		return
	if(obj_integrity == max_integrity)
		to_chat(user, span_warning("This repair kit is at maximum capacity."))
		return

	if(repair_type == 0)	 // Sew
		if(istype(O, /obj/item/natural/cloth))
			to_chat(user, span_info("I use [O] to restore some of the repair kit's capacity."))
			qdel(O)
			obj_integrity = min(obj_integrity+1,max_integrity)
		if(istype(O,/obj/item/natural/bundle/cloth))
			var/obj/item/natural/bundle/B = O
			var/maxcycles = B.amount
			to_chat(user, span_info("I use [O] to restore some of the repair kit's capacity."))
			for(var/i in 1 to maxcycles)
				if(B)	// We might lose the bundle as it gets consumed.
					if(obj_integrity < max_integrity)
						obj_integrity = min(obj_integrity+1,max_integrity)
						B.use()
	else if(repair_type == 1)	// Metal
		if(istype(O, /obj/item/scrap))
			qdel(O)
			obj_integrity = min(obj_integrity+1,max_integrity)
		if(istype(O, /obj/item/ingot))
			var/restored_amt = 2
			if(istype(O, /obj/item/ingot/bronze) || istype(O, /obj/item/ingot/copper) || istype(O, /obj/item/ingot/iron))
				restored_amt = 3
			if(istype(O, /obj/item/ingot/steel) || istype(O, /obj/item/ingot/aalloy))
				restored_amt = 5
			if(istype(O, /obj/item/ingot/avantyne))
				restored_amt = 10
			if(istype(O, /obj/item/ingot/gold) || istype(O, /obj/item/ingot/avantyne) || istype(O, /obj/item/ingot/blacksteel))
				restored_amt = 20
			to_chat(user, span_info("I use [O] to restore some of the repair kit's capacity."))
			qdel(O)
			obj_integrity = min(obj_integrity+restored_amt,max_integrity)


/obj/item/repair_kit/attack_obj(obj/O, mob/living/user)
	if(!isitem(O) || in_use)
		return
	var/obj/item/I = O
	if(src.obj_integrity < 0)
		if(I.sewrepair)
			playsound(loc, 'sound/foley/cloth_rip.ogg', 100, TRUE, -2)
		if(I.anvilrepair)
			playsound(loc,'sound/items/bsmithfail.ogg', 100, TRUE, -2)
		self_del()
		return
	if(I.sewrepair && repair_type == 1)
		return
	if(I.anvilrepair && repair_type == 0)
		return
	if(I.max_integrity)
		if(I.obj_integrity != I.max_integrity)
			to_chat(user, span_warning("This requires more repairs."))
			return
		if(floor(I.get_true_max_integ()) == floor(I.max_integrity))
			to_chat(user, span_warning("This item is already in top shape."))
			return
		if(!I.ontable() && table_need == TRUE)
			to_chat(user, span_warning("I should put this on a table first."))
			return
		if(I.sewrepair)
			playsound(loc, 'sound/repair/ameliorate_leather.ogg', 100, TRUE, -2)
		if(I.anvilrepair)
			playsound(loc,'sound/repair/ameliorate_metal.ogg', 100, TRUE, -2)
		var/const/AUTO_SEW_DELAY = CLICK_CD_MELEE
		in_use = TRUE
		if(!do_after(user, 2 SECONDS, target = I))
			in_use = FALSE
			return

		if(istype(I, /obj/item/clothing))
			visible_message("[user] restores [I]'s integrity with [src].")
			I.restore_max_integ()

		obj_integrity = max(obj_integrity-1, 0)
		in_use = FALSE
		return
	return ..()

/obj/item/repair_kit/bad
	name = "fabric patch"
	icon_state = "custarsewingkit"
	desc = "A meager set of pieces of cloth, a bundle of threads and a loose rope. It can be used for field repairs. It can only ameliorate items, restoring their maximum integrity."
	max_integrity = 2
	grid_width = 32
	grid_height = 32

/obj/item/repair_kit/metal
	name = "armor plates"
	icon_state = "armorkit"
	desc = "A wonderful set of metal patches, individual armor plates and straps for fastening them. It can be used to properly damaged weapons and armor, without the need for a blacksmith's hammer. It can only ameliorate items, restoring their maximum integrity."
	repair_type = 1
	max_integrity = 7

/obj/item/repair_kit/metal/bad
	name = "metal scrap kit"
	icon_state = "custararmorkit"
	desc = "A meager set of metal patches, repurposed iron shingles and straps for fastening them. It can be used to repair damaged weapons and armor in a pinch, without the need for a blacksmith's hammer. It can also be used in smithing to create banded iron pieces. It can only ameliorate items, restoring their maximum integrity."
	max_integrity = 2

/obj/item/scrap
	name = "iron scrap"
	desc = "Shingles and scrap, born from violence upon iron. There may yet still be a use for these pieces.. </br>Iron scrap can be crafted into metal repair kits, which - when stuffed with iron scrap - can repair damaged equipment without the need for a blacksmith's hammer. It can only ameliorate items, restoring their maximum integrity."
	icon_state = "scrap"
	icon = 'icons/roguetown/items/misc.dmi'
	grid_width = 32
	grid_height = 32
	dropshrink = 0.7
	anvilrepair = /datum/skill/craft/blacksmithing //for empty kit code

/obj/item/scrap/attack(mob/living/M, mob/user)
	if(!user.cmode)
		if(try_construct_consume(src, M, user))
			return
		else
			return ..()
	else
		return ..()
