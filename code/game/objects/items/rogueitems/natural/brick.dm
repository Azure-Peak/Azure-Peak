/obj/item/natural/brick
	name = "brick"
	desc = "A cooked red brick, and the backbone of buildings-a-plenty."
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
	experimental_inhand = TRUE
	hitsound = list('sound/combat/hits/blunt/brick.ogg')
	bundletype = /obj/item/natural/bundle/brick

/obj/item/natural/brick/attackby(obj/item, mob/living/user)
	if(item_flags & IN_STORAGE)
		return
	. = ..()

/obj/item/natural/bundle/brick
	name = "stack of bricks"
	desc = "A stack of bricks."
	icon_state = "brickbundle1"
	icon = 'icons/roguetown/items/cooking.dmi'	//It's because these are cooked via clay. Don't ask questions.
	experimental_inhand = TRUE
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
