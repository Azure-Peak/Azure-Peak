/obj/item/natural/brick
	name = "brick"
	desc = "A cooked red brick."
	icon = 'icons/roguetown/items/cooking.dmi'	//It's because these are cooked via clay. Don't ask questions.
	icon_state = "claybrickcook"
	gripped_intents = null
	sellprice = 3
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 14			//stronger than rock
	throwforce = 18		//stronger than rock
	slot_flags = ITEM_SLOT_MOUTH
	obj_flags = null
	w_class = WEIGHT_CLASS_TINY
	experimental_inhand = FALSE
	hitsound = list('sound/combat/hits/blunt/brick.ogg')
	bundletype = /obj/item/natural/bundle/brick

/obj/item/natural/brick/attackby(obj/item, mob/living/user)
	if(item_flags & IN_STORAGE)
		return
	. = ..()

/obj/item/natural/brick/attack_right(mob/user)
	. = ..()
	if(user.get_active_held_item())
		return
	to_chat(user, span_warning("I start to collect [src]..."))
	if(move_after(user, bundling_time, target = src))
		var/stackcount = 0
		for(var/obj/item/natural/brick/F in get_turf(src))
			stackcount++
		while(stackcount > 0)
			if(stackcount == 1)
				var/obj/item/natural/brick/S = new(get_turf(user))
				user.put_in_hands(S)
				stackcount--
			else if(stackcount >= 2)
				var/obj/item/natural/bundle/brick/B = new(get_turf(user))
				B.amount = clamp(stackcount, 2, 4)
				B.update_bundle()
				stackcount -= clamp(stackcount, 2, 4)
				user.put_in_hands(B)
		for(var/obj/item/natural/brick/F in get_turf(src))
			playsound(user, 'sound/foley/brickdrop.ogg', 100)
			qdel(F)

/obj/item/natural/bundle/brick
	name = "stack of bricks"
	desc = "A stack of bricks."
	icon_state = "brickbundle1"
	icon = 'icons/roguetown/items/cooking.dmi'	//It's because these are cooked via clay. Don't ask questions.
	experimental_inhand = FALSE
	grid_width = 64
	grid_height = 64
	base_width = 64
	base_height = 64
	drop_sound = 'sound/foley/brickdrop.ogg'
	pickup_sound = 'sound/foley/brickdrop.ogg'
	hitsound = list('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')
	possible_item_intents = list(/datum/intent/use)
	force = 2
	throwforce = 0	// useless for throwing unless solo
	throw_range = 2
	w_class = WEIGHT_CLASS_NORMAL
	stackname = "bricks"
	stacktype = /obj/item/natural/brick
	maxamount = 4
	icon1 = "brickbundle2"
	icon1step = 3
	icon2 = "brickbundle3"
	icon2step = 4
