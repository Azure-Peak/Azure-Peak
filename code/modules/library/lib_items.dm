/obj/structure/bookcase
	name = "bookcase"
	icon = 'icons/roguetown/misc/bookshelf.dmi'
	icon_state = "bookcase"
	var/based = "a"
	desc = "Refuge for few, an irrelevance to most."
	anchored = FALSE
	density = TRUE
	opacity = 1
	resistance_flags = FLAMMABLE
	max_integrity = 200
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = "woodimpact"
	var/state = 0
	var/list/allowed_books = list(/obj/item/book, /obj/item/storage/book, /obj/item/recipe_book, /obj/item/skillbook) //Things allowed in the bookcase

/obj/structure/bookcase/examine(mob/user)
	. = ..()

/obj/structure/bookcase/Initialize(mapload)
	. = ..()
	if(!mapload)
		return
	based = pick("a","b","c","d","e","f","g","h")
	state = 2
	anchored = TRUE
	for(var/obj/item/I in loc)
		for(var/allowedtype in allowed_books)
			if(istype(I, allowedtype))
				I.forceMove(src)
	update_icon()

/obj/structure/bookcase/attackby(obj/item/I, mob/user, params)
	var/datum/component/storage/STR = I.GetComponent(/datum/component/storage)
	if(is_type_in_list(I, allowed_books))
		if(!(contents.len <= 15))
			to_chat(user, span_notice("There are too many books on this shelf!"))
			return
		if(!user.transferItemToLoc(I, src))
			return
		update_icon()
	else if(STR)
		for(var/obj/item/T in I.contents)
			if(istype(T, /obj/item/book))
				STR.remove_from_storage(T, src)
		to_chat(user, span_notice("I empty \the [I] into \the [src]."))
		update_icon()
	else
		return ..()

/obj/structure/bookcase/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(user.cmode)
		return
	if(!istype(user))
		return
	if(contents.len)
		var/obj/item/book/choice = input(user, "Which book would you like to remove from the shelf?") as null|obj in contents.Copy()
		if(choice)
			if(!(user.mobility_flags & MOBILITY_USE) || user.stat || user.restrained() || !in_range(loc, user))
				return
			if(ishuman(user))
				if(!user.get_active_held_item())
					user.put_in_hands(choice)
			else
				choice.forceMove(drop_location())
			update_icon()

/obj/structure/bookcase/deconstruct(disassembled = TRUE)
	for(var/obj/item/book/B in contents)
		B.forceMove(get_turf(src))
	new /obj/item/grown/log/tree/small(get_turf(src.loc))
	qdel(src)

/obj/structure/bookcase/update_icon()
	if((contents.len >= 1) && (contents.len <= 15))
		icon_state = "[based][contents.len]"
	else
		icon_state = "bookcase"
