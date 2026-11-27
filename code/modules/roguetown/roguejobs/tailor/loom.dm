/obj/machinery/loom
	icon = 'icons/roguetown/misc/structure.dmi'
	name = "loom"
	desc = "A wooden frame with taut threads ready to weave fabric."
	icon_state = "loom"
	var/storedfiber = 0
	var/maxfiber = 50
	var/fiber_seals = NONE
	max_integrity = 200
	density = TRUE

/obj/machinery/loom/proc/accepts_fiber_seals(obj/item/I, mob/user)
	if(storedfiber <= 0)
		fiber_seals = I.get_seals()
		return TRUE
	if(I.get_seals() == fiber_seals)
		return TRUE
	to_chat(user, span_warning("Sealed fibers cannot be combined with unsealed fibers."))
	return FALSE

/obj/machinery/loom/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/natural/bundle/fibers))
		var/obj/item/natural/bundle/fibers/W = I
		if(!accepts_fiber_seals(W, user))
			return
		if(src.storedfiber + W.amount > src.maxfiber)
			W.amount = (W.amount - (src.maxfiber - src.storedfiber))
			to_chat(user, "You string some fiber onto [src].")
			src.storedfiber = src.maxfiber
			if(W.amount == 1)
				W.spawn_single(get_turf(user))
				qdel(W)
		else
			src.storedfiber = src.storedfiber + W.amount
			to_chat(user, "You string some fiber onto [src].")
			qdel(W)
	if(istype(I, /obj/item/natural/fibers))
		var/obj/item/natural/fibers/W = I
		if(src.storedfiber < src.maxfiber)
			if(!accepts_fiber_seals(W, user))
				return
			src.storedfiber++
			to_chat(user, "You string a fiber onto [src].")
			qdel(W)
		else
			to_chat(user, "You can't add any more fiber.")
	. = ..()

/obj/machinery/loom/attack_right(mob/user)
	var/mob/living/L = user
	if(isliving(user) && L.stat == CONSCIOUS && !user.get_active_held_item())
		if(src.storedfiber > 0)
			to_chat(user, "You remove a strand from [src].")
			src.storedfiber--
			var/obj/item/natural/fibers/F = new (src.loc)
			F.add_seals(fiber_seals)
			L.put_in_hands(F)
		else
			to_chat(user, "There's nothing to take from [src].")

/obj/machinery/loom/attack_hand(mob/user)
	var/mob/living/weaver = user
	var/weavetime = 2 SECONDS //time to weave a cloth, duh
	var/skilltimemod = 0.2 SECONDS //how much each level of skill lowers the time to weave
	var/skill = weaver.get_skill_level(/datum/skill/craft/sewing)
	if(isliving(user) && weaver.stat == CONSCIOUS)
		if(src.storedfiber < 2)
			to_chat(user, "You don't have enough fiber to do this.")
		else
			to_chat(user, "You start weaving some cloth...")
			while(src.storedfiber > 1)
				if(!do_after(weaver, (weavetime - (skilltimemod*skill)),target = src) || src.storedfiber < 2)
					break
				src.storedfiber -= 2
				var/obj/item/natural/cloth/C = new(get_turf(src))
				C.add_seals(fiber_seals)
				weaver.mind.add_sleep_experience(/datum/skill/craft/sewing, (weaver.STAINT*0.5))//you get less exp from using the loom

/obj/machinery/loom/examine(mob/user)
	to_chat(user, span_notice("There are [storedfiber] strands of fiber strung on [src]."))
	. = ..()
