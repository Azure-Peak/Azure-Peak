/obj/item/repair_kit
	name = "sewing kit"
	icon_state = "sewingkit"
	desc = "A well-made repair kit that includes high-quality reinforced fabric lines and leather patches for field repairs."
	icon = 'icons/roguetown/items/misc.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_HIP
	max_integrity = 700
	experimental_inhand = FALSE
	var/can_repair = TRUE
	var/table_need = FALSE
	var/repair_type = 0 //0 - cloth; 1 - metal
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
		if(prob(20))
			new /obj/item/scrap(get_turf(src))
	qdel(src)

/obj/item/repair_kit/attack_obj(obj/O, mob/living/user)
	if(!isitem(O))
		return
	var/obj/item/I = O
	if(src.obj_integrity <= 0)
		if(I.sewrepair)
			playsound(loc, 'sound/foley/cloth_rip.ogg', 100, TRUE, -2)
		if(I.anvilrepair)
			playsound(loc,'sound/items/bsmithfail.ogg', 100, TRUE, -2)
		self_del()
		return
	if(can_repair)
		if(I.sewrepair && repair_type == 1)
			return
		if(I.anvilrepair && repair_type == 0)
			return
		if(I.max_integrity)
			if(I.obj_integrity == I.max_integrity)
				to_chat(user, span_warning("This is not broken."))
				return
			if(!I.ontable() && table_need == TRUE)
				to_chat(user, span_warning("I should put this on a table first."))
				return
			if(I.sewrepair)
				playsound(loc, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)
			if(I.anvilrepair)
				playsound(loc,'sound/items/bsmith3.ogg', 100, TRUE, -2)
			var/const/XP_ON_SUCCESS = 0.7
			var/const/AUTO_SEW_DELAY = CLICK_CD_MELEE
			if(!do_after(user, 2 SECONDS, target = I))
				return
			else
				if(I.sewrepair)
					playsound(loc, 'sound/foley/sewflesh.ogg', 50, TRUE, -2)
				if(I.anvilrepair)
					playsound(loc,'sound/items/bsmith3.ogg', 100, TRUE, -2)

				user.visible_message(span_info("[user] repairs [I]!"))
				if(I.body_parts_covered != I.body_parts_covered_dynamic)
					user.visible_message(span_info("[user] repairs [I]'s coverage!"))
					I.repair_coverage()
				if(XP_ON_SUCCESS > 0)
					if(I.anvilrepair)
						user.mind.add_sleep_experience(I.anvilrepair, user.STAINT * XP_ON_SUCCESS)
					else
						user.mind.add_sleep_experience(/datum/skill/craft/sewing, user.STAINT * XP_ON_SUCCESS)
				I.obj_integrity = min(I.obj_integrity + (max_integrity/10), I.max_integrity) //10%
				src.obj_integrity = min(src.obj_integrity - 10, src.max_integrity) //can restore 700% for good cloth kits, and 300% for bad cloth, 400% for bad metal,  1000% for good metal kit.
				if(I.obj_broken && I.obj_integrity >= I.max_integrity)
					var/obj/item/T = I
					T.obj_fix()
					return
				if(do_after(user, AUTO_SEW_DELAY, target = I))
					attack_obj(I, user)
		return
	return ..()

/obj/item/repair_kit/bad
	name = "fabric patch"
	icon_state = "custarsewingkit"
	desc = "A meager set of pieces of cloth, a bundle of threads and a loose rope. It can be used for field repairs."
	max_integrity = 300
	grid_width = 32
	grid_height = 32

/obj/item/repair_kit/metal
	name = "armor plates"
	icon_state = "armorkit"
	desc = "A wonderful set of metal patches, individual armor plates and straps for fastening them.  Everything you need to fix a leaky metal armor."
	repair_type = 1
	max_integrity = 600
	table_need = TRUE

/obj/item/repair_kit/metal/bad
	name = "metal scrap kit"
	icon_state = "custararmorkit"
	desc = "A meager set of various pieces of old iron armor, some parts can be used for field repairs, but do not expect a miracle from this pile of metal."
	max_integrity = 300

/obj/item/armorkit_empty
	name = "empty metal kit"
	desc = "An empty metal box that is suitable for storing various pieces of hardware and other scrap. \
	Fill with iron objects to create a repair kit."
	icon_state = "armorkit_empty"
	icon = 'icons/roguetown/items/misc.dmi'
	grid_width = 64
	grid_height = 32
	var/need_scrap = 3
	var/current_scrap = 0
	dropshrink = 0.7

/obj/item/armorkit_empty/attackby(obj/O, mob/living/user, params)
	if(!isitem(O))
		return
	var/obj/item/I = O
	if(I.anvilrepair || I == /obj/item/scrap)
		if(I.smeltresult == /obj/item/ingot/iron || I == /obj/item/scrap) //all iron stuff and iron scrap
			if(!do_after(user, 2 SECONDS, target = I))
				return
			user.visible_message(span_notice("[user] salvages [I] into usable materials."))
			qdel(I)
			current_scrap++
			if(current_scrap < need_scrap)
				var/visible_scrap = need_scrap - current_scrap
				to_chat(user, span_info("To fill [name], you need [visible_scrap] more..."))
			if(current_scrap >= need_scrap)
				new /obj/item/repair_kit/metal/bad(get_turf(src))
				qdel(src)
			return
		return
	return

/obj/item/scrap
	name = "iron scrap"
	desc = "pieces of iron. The only thing left of what was once made of them. It might come in handy."
	icon_state = "scrap"
	icon = 'icons/roguetown/items/misc.dmi'
	grid_width = 32
	grid_height = 32
	dropshrink = 0.7
	anvilrepair = /datum/skill/craft/blacksmithing //for empty kit code
