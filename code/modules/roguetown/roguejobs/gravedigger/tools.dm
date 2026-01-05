/obj/item/rogueweapon/shovel
	force = 21
	possible_item_intents = list(/datum/intent/shovelscoop, /datum/intent/mace/strike/shovel)
	gripped_intents = list(/datum/intent/shovelscoop, /datum/intent/mace/strike/shovel, /datum/intent/axe/chop/stone)
	name = "shovel"
	desc = "Essential for digging (graves) in this darkened earth."
	icon_state = "shovel"
	icon = 'icons/roguetown/weapons/tools.dmi'
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	wdefense = 3
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	tool_behaviour = TOOL_SHOVEL
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	swingsound = list('sound/combat/wooshes/blunt/shovel_swing.ogg','sound/combat/wooshes/blunt/shovel_swing2.ogg')
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'
	var/obj/item/natural/dirtclod/heldclod
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 300
	grid_width = 32
	grid_height = 96

/obj/item/rogueweapon/shovel/Destroy()
	if(heldclod)
		QDEL_NULL(heldclod)
	return ..()

/obj/item/rogueweapon/shovel/dropped(mob/user)
	if(heldclod && isturf(loc))
		heldclod.forceMove(loc)
		heldclod = null
	update_icon()
	. = ..()

/obj/item/rogueweapon/shovel/update_icon()
	if(heldclod)
		icon_state = "dirt[initial(icon_state)]"
	else
		icon_state = "[initial(icon_state)]"

/datum/intent/mace/strike/shovel
	hitsound = list('sound/combat/hits/blunt/shovel_hit.ogg', 'sound/combat/hits/blunt/shovel_hit2.ogg', 'sound/combat/hits/blunt/shovel_hit3.ogg')

/datum/intent/shovelscoop
	name = "scoop"
	icon_state = "inscoop"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0
	no_attack = TRUE

/obj/item/rogueweapon/shovel/attack(mob/living/M, mob/living/user)
	. = ..()
	if(. && heldclod && get_turf(M))
		heldclod.forceMove(get_turf(M))
		heldclod = null
		update_icon()

/obj/item/rogueweapon/shovel/attack_turf(turf/T, mob/living/user)
	user.changeNext_move(user.used_intent.clickcd)
	if(user.used_intent.type == /datum/intent/shovelscoop)
		if(istype(T, /turf/open/floor/rogue/dirt))
			var/turf/open/floor/rogue/dirt/D = T
			if(heldclod)
				if(D.holie && D.holie.stage < 4)
					D.holie.attackby(src, user)
				else
					if(istype(T, /turf/open/floor/rogue/dirt/road))
						qdel(heldclod)
						T.ChangeTurf(/turf/open/floor/rogue/dirt, flags = CHANGETURF_INHERIT_AIR)
					else
						heldclod.forceMove(T)
					heldclod = null
					playsound(T,'sound/items/empty_shovel.ogg', 100, TRUE)
					update_icon()
					return
			else
				if(D.holie)
					D.holie.attackby(src, user)
				else
					if(istype(T, /turf/open/floor/rogue/dirt/road))
						new /obj/structure/closet/dirthole(T)
					else
						T.ChangeTurf(/turf/open/floor/rogue/dirt/road, flags = CHANGETURF_INHERIT_AIR)
					heldclod = new(src)
					playsound(T,'sound/items/dig_shovel.ogg', 100, TRUE)
					update_icon()
			return
		if(heldclod)
			if(istype(T, /turf/open/water))
				qdel(heldclod)
			else
				heldclod.forceMove(T)
			heldclod = null
			playsound(T,'sound/items/empty_shovel.ogg', 100, TRUE)
			update_icon()
			return
		if(istype(T, /turf/open/floor/rogue/grass) || istype(T, /turf/open/floor/rogue/grassred) || istype(T, /turf/open/floor/rogue/grassyel) || istype(T, /turf/open/floor/rogue/grasscold))
			to_chat(user, span_warning("There is grass in the way."))
			return
		if(istype(T, /turf/open/floor/rogue/snow))
			T.ChangeTurf(/turf/open/floor/rogue/dirt, flags = CHANGETURF_INHERIT_AIR)
			to_chat(user, span_warning("You scoop away the snow!"))
		return
	. = ..()

/obj/item/rogueweapon/shovel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,
"sx" = 0,
"sy" = -10,
"nx" = 2,
"ny" = -8,
"wx" = -9,
"wy" = -8,
"ex" = 5,
"ey" = -11,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 105,
"sturn" = -90,
"wturn" = 0,
"eturn" = 90,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 1)
			if("wielded")
				return list("shrink" = 0.8,
"sx" = 3,
"sy" = -5,
"nx" = -8,
"ny" = -5,
"wx" = 0,
"wy" = -5,
"ex" = 5,
"ey" = -5,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 1,
"nturn" = 135,
"sturn" = -135,
"wturn" = 240,
"eturn" = 30,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/rogueweapon/shovel/small
	force = 7
	name = "spade"
	desc = "Indispensable for tending the soil."
	icon_state = "spade"
	sharpness = IS_BLUNT
	//dropshrink = 0.8
	gripped_intents = null
	wlength = WLENGTH_SHORT
	slot_flags = ITEM_SLOT_HIP
	w_class = WEIGHT_CLASS_NORMAL
	max_blade_int = 0
	smeltresult = null
	grid_height = 64

/obj/item/rogueweapon/shovel/aalloy
	force = 8
	name = "decrepit shovel"
	desc = "A tool of wrought bronze, for burying the lyfeless. His worshippers would say that death is necessary; that the bod will nourish this world, so that more lyfe may sprout. But to those who know the truth - Her truth, it is nothing more than a mockery."
	icon_state = "ashovel"
	smeltresult = /obj/item/ingot/aaslag
	color = "#bb9696"
	sellprice = 15

/obj/item/rogueweapon/shovel/silver
	force = 25
	name = "silver shovel"
	desc = "The only trait that distinguishes a man from a beast is their empathy. To mutilate the dead, regardless of what they've done in lyfe, is to invoke divine wrath. See them buried beneath crossed soil; ferry their spirit to the world beyond Psydonia, and towards their final judgement."
	icon_state = "silvershovel"
	icon = 'icons/roguetown/weapons/misc32.dmi'
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/shovel/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/shovel/silver/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/shovel/zoe_silence
	name = "Silence"
	desc = "This relic, bestowed on the Order of the Veiled Lady, is cold to the touch. Faint whispers of the lost and the damned can be heard in its presence, and an inscription on the handle reads the Order's motto: \"Rest to the Restless, Death to the Deathless\""
	icon_state = "zoe_silence"
	icon = 'icons/obj/items/donor_weapons_48.dmi'
	
/obj/item/rogueweapon/shovel/zoe_silence/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,
"sx" = 0,
"sy" = -10,
"nx" = -6,
"ny" = -8,
"wx" = -9,
"wy" = -8,
"ex" = 5,
"ey" = -11,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 195,
"sturn" = -180,
"wturn" = -90,
"eturn" = 0,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 1)
			if("wielded")
				return list("shrink" = 0.5,
"sx" = 6,
"sy" = -7,
"nx" = -8,
"ny" = -5,
"wx" = -6,
"wy" = -3,
"ex" = 6,
"ey" = -5,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 1,
"nturn" = 225,
"sturn" = -225,
"wturn" = -45,
"eturn" = -45,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/burial_shroud
	name = "winding sheet"
	desc = "A burial veil for the deceased. It makes transporting bodies slightly more tolerable."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "shroud_folded"
	w_class = WEIGHT_CLASS_SMALL
	var/unfoldedbag_path = /obj/structure/closet/burial_shroud

/obj/item/burial_shroud/attack_self(mob/user)
	deploy_bodybag(user, user.loc)

/obj/item/burial_shroud/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(proximity)
		if(isopenturf(target))
			deploy_bodybag(user, target)

/obj/item/burial_shroud/proc/deploy_bodybag(mob/user, atom/location)
	var/obj/structure/closet/body_bag/R = new unfoldedbag_path(location)
	R.open(user)
	R.add_fingerprint(user)
	R.foldedbag_instance = src
	moveToNullspace()
	user.update_a_intents()


/obj/structure/closet/burial_shroud
	name = "winding sheet"
	desc = "A length of thin fabric used to encase the deceased."
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "shroud"
	density = FALSE
	mob_storage_capacity = 1
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 15
	close_sound_volume = 15
	integrity_failure = 0
	delivery_icon = null //unwrappable
	anchorable = FALSE
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	drag_slowdown = 0
	horizontal = TRUE
	var/foldedbag_path = /obj/item/burial_shroud
	var/obj/item/bodybag/foldedbag_instance = null



/obj/structure/closet/burial_shroud/Destroy()
	// If we have a stored bag, and it's in nullspace (not in someone's hand), delete it.
	if (foldedbag_instance && !foldedbag_instance.loc)
		QDEL_NULL(foldedbag_instance)
	return ..()

/obj/structure/closet/burial_shroud/open(mob/living/user)
	. = ..()
	if(.)
		mouse_drag_pointer = MOUSE_INACTIVE_POINTER

/obj/structure/closet/burial_shroud/close()
	. = ..()
	if(.)
		density = FALSE
		mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/structure/closet/burial_shroud/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) || usr.contents.Find(src)))
		if(!ishuman(usr))
			return
		if(contents.len)
			to_chat(usr, "<span class='warning'>There are too many things inside of [src] to fold it up!</span>")
			return
		visible_message("<span class='notice'>[usr] folds up [src].</span>")
		var/obj/item/bodybag/B = foldedbag_instance || new foldedbag_path
		usr.put_in_hands(B)
		qdel(src)

/obj/item/bodybag
	name = "body bag"
	desc = ""
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag_folded"
	w_class = WEIGHT_CLASS_SMALL
	var/unfoldedbag_path = /obj/structure/closet/body_bag

/obj/item/bodybag/attack_self(mob/user)
	deploy_bodybag(user, user.loc)

/obj/item/bodybag/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(proximity)
		if(isopenturf(target))
			deploy_bodybag(user, target)

/obj/item/bodybag/proc/deploy_bodybag(mob/user, atom/location)
	var/obj/structure/closet/body_bag/R = new unfoldedbag_path(location)
	R.open(user)
	R.add_fingerprint(user)
	R.foldedbag_instance = src
	moveToNullspace()

/obj/item/bodybag/suicide_act(mob/user)
	if(isopenturf(user.loc))
		user.visible_message("<span class='suicide'>[user] is crawling into [src]! It looks like [user.p_theyre()] trying to commit suicide!</span>")
		var/obj/structure/closet/body_bag/R = new unfoldedbag_path(user.loc)
		R.add_fingerprint(user)
		qdel(src)
		user.forceMove(R)
		playsound(src, 'sound/blank.ogg', 15, TRUE, -3)
		return (OXYLOSS)
	..()


/obj/structure/closet/body_bag
	name = "body bag"
	desc = ""
	icon = 'icons/obj/bodybag.dmi'
	icon_state = "bodybag"
	density = FALSE
	mob_storage_capacity = 2
	open_sound = 'sound/blank.ogg'
	close_sound = 'sound/blank.ogg'
	open_sound_volume = 15
	close_sound_volume = 15
	integrity_failure = 0
	delivery_icon = null //unwrappable
	anchorable = FALSE
	mouse_drag_pointer = MOUSE_ACTIVE_POINTER
	drag_slowdown = 0
	var/foldedbag_path = /obj/item/bodybag
	var/obj/item/bodybag/foldedbag_instance = null

/obj/structure/closet/body_bag/Destroy()
	// If we have a stored bag, and it's in nullspace (not in someone's hand), delete it.
	if (foldedbag_instance && !foldedbag_instance.loc)
		QDEL_NULL(foldedbag_instance)
	return ..()

/obj/structure/closet/body_bag/open(mob/living/user)
	. = ..()
	if(.)
		mouse_drag_pointer = MOUSE_INACTIVE_POINTER

/obj/structure/closet/body_bag/close()
	. = ..()
	if(.)
		density = FALSE
		mouse_drag_pointer = MOUSE_ACTIVE_POINTER

/obj/structure/closet/body_bag/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) || usr.contents.Find(src)))
		if(!ishuman(usr))
			return
		if(opened)
			to_chat(usr, span_warning("I wrestle with [src], but it won't fold while unzipped."))
			return
		if(contents.len)
			to_chat(usr, span_warning("There are too many things inside of [src] to fold it up!"))
			return
		visible_message("<span class='notice'>[usr] folds up [src].</span>")
		var/obj/item/bodybag/B = foldedbag_instance || new foldedbag_path
		usr.put_in_hands(B)
		qdel(src)
