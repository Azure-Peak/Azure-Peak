
/obj/item/natural
	icon = 'icons/roguetown/items/natural.dmi'
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	desc = ""
	w_class = WEIGHT_CLASS_TINY
	var/bundletype = null
	var/bundling_time = 4 SECONDS		// Base bundling time - make lower for small objects. Higher for large.
	var/quality = SMELTERY_LEVEL_NORMAL // To not ruin blacksmith recipes
	grid_width = 32
	grid_height = 32
	var/sharpening_factor = 0
	var/spark_chance = 0

/obj/item/natural/attackby(obj/item/W, mob/living/user)
	if(istype(W, /obj/item/natural/bundle))
		if(item_flags & IN_STORAGE)
			to_chat(user, span_warning("It's hard to find [W] in my bag."))
			return
		var/obj/item/natural/bundle/B = W
		if(istype(src, B.stacktype))
			if(B.amount < B.maxamount)
				B.amount++
				B.update_bundle()
				user.visible_message("[user] adds [src] to [W].")
				qdel(src)
			else
				to_chat(user, "There's not enough space in [W].")
			return
	else if(istype(W, /obj/item/natural/))
		var/obj/item/natural/B = W
		if(B.bundletype == src.bundletype && src.bundletype != null)
			var/obj/item/natural/bundle/N = new bundletype(src.loc)
			to_chat(user, "You tie the [N.stackname] into a bundle.")
			qdel(B)
			qdel(src)
			user.put_in_hands(N)
	else
		return ..()


/obj/item/natural/bundle
	name = "bundle"
	desc = "You shouldn't be seeing this."
	possible_item_intents = list(/datum/intent/use)
	force = 0
	throwforce = 0
	firefuel = 5 MINUTES
	resistance_flags = FLAMMABLE
	var/firemod = 5 MINUTES
	var/amount = 2
	var/maxamount = 10
	var/icon1 = "fibersroll1"
	var/icon1step = 3
	var/icon2 = "fibersroll2"
	var/icon2step = 6
	var/icon3 = null
	var/stacktype = /obj/item/natural/fibers/
	var/stackname = "fibers"
	var/base_width = 32
	var/base_height = 32

/obj/item/natural/bundle/Initialize()
	. = ..()
	update_bundle()

/obj/item/natural/bundle/burn()
	. = ..(amount)

/obj/item/natural/bundle/attackby(obj/item/W, mob/living/user)
	if(item_flags & IN_STORAGE)
		return
	if(istype(W, /obj/item/natural/bundle))
		var/obj/item/natural/bundle/B = W
		if(src.stacktype == B.stacktype)
			if(src.amount + B.amount > maxamount)
				B.amount = (src.amount + B.amount) - maxamount
				src.amount = maxamount
				src.update_bundle()
				B.update_bundle()
				to_chat(user, "There's not enough space in [src].")
				if(B.amount == 1)
					var/obj/H = new stacktype(src.loc)
					user.put_in_hands(H)
					qdel(B)
			else
				to_chat(user, "I add the [W] to the [src].")
				src.amount += B.amount
				update_bundle()
				qdel(B)
	else if(istype(W, stacktype))
		if(item_flags & IN_STORAGE)
			return
		if(src.amount < src.maxamount)
			to_chat(user, "I add the [W] to the [src].")
			src.amount++
			update_bundle()
			qdel(W)
		else
			to_chat(user, "There's not enough space in [src].")
	else
		return ..()

/obj/item/natural/bundle/use(used)
	if(src.amount >= used)
		src.amount -= used
		src.update_bundle()
		switch(src.amount)
			if(1)
				new src.stacktype(src.loc)
				qdel(src)
			if(0)
				qdel(src)
		return TRUE
	else
		return FALSE

/obj/item/natural/bundle/attack_right(mob/user)
	if(item_flags & IN_STORAGE)
		return
	var/mob/living/carbon/human/H = user
	switch(amount)
		if(2)
			var/obj/F = new stacktype(src.loc)
			var/obj/I = new stacktype(src.loc)
			H.put_in_hands(F)
			H.put_in_hands(I)
			qdel(src)
			return
		else
			amount -= 1
			var/obj/F = new stacktype(src.loc)
			H.put_in_hands(F)
			user.visible_message("[user] removes [F] from [src].", "I remove [F] from [src].")
	update_bundle()

/obj/item/natural/bundle/attack_turf(turf/T, mob/living/user)
	var/list/obj/item/stackables = list()
	for(var/obj/I in T.contents)
		if(I.type == stacktype)
			stackables += I
	if(stackables.len)
		if(amount >= maxamount)
			to_chat(user, span_info("[src] can't hold any more without falling apart."))
			return
		to_chat(user, span_info("I begin filling [src]..."))
		for(var/obj/I in stackables)
			if(amount >= maxamount)
				break
			if(I.type == stacktype)
				if(!do_after(user, 5, TRUE, src))
					break
				if(!(I in T.contents))
					continue
				qdel(I)
				src.amount++
				update_bundle()


/obj/item/natural/bundle/examine(mob/user)
	. = ..()
	if(amount == maxamount )
		to_chat(user, span_notice("There are [amount] [stackname] in this bundle. It can not take any more."))
	else
		to_chat(user, span_notice("There are [amount] [stackname] in this bundle."))

/obj/item/natural/bundle/proc/update_bundle()
	if(firefuel != 0)
		firefuel = firemod * amount
	if((amount <= icon1step) && (icon1 != null))
		icon_state = icon1
	else if((icon1step < amount <= icon2step) && (icon2 != null))
		icon_state = icon2
	else
		if(icon3 != null)
			icon_state = icon3
	grid_height = base_height
	grid_width = base_width
	if(FLOOR(maxamount / 2, 1) < amount)
		grid_width += base_width
	if(item_flags & IN_STORAGE)
		var/obj/item/location = loc
		var/datum/component/storage/storage = location.GetComponent(/datum/component/storage)

		storage.update_item(src)
		storage.orient2hud()
