/obj/item/mob_item
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/mob/living/stored_mob
	slot_flags = ITEM_SLOT_HEAD
	w_class = WEIGHT_CLASS_HUGE // this should never exist outside your hand/head/shoulder
	var/can_container = FALSE // if this is true, we won't revert you when you get put in a bag - for familiars only atm

/obj/item/mob_item/Initialize()
	. = ..()
	RegisterSignal(src, COMSIG_QDELETING, PROC_REF(revert))

/obj/item/mob_item/container_resist(mob/living/user)
	. = ..()
	revert()

/obj/item/mob_item/dropped(mob/user, silent)
	. = ..()
	if(isturf(loc))
		revert() // always revert when you're actually dropped on the floor
	if(!can_container && !istype(loc, /mob)) // if we're allowing containers, or just being handed to someone else/put in a hand slot, don't revert
		revert()

/obj/item/mob_item/proc/revert()
	if(!stored_mob)
		return
	var/turf/to_move = get_turf(stored_mob)
	if(to_move) // this can be false in the case of qdels but the mob is moved properly without this call in that case
		stored_mob.forceMove(get_turf(stored_mob))
	stored_mob.status_flags &= ~GODMODE
	stored_mob.reset_perspective()
	if(!QDELING(src))
		qdel(src)
	return TRUE

/mob/living/proc/become_item()
	var/obj/item/mob_item/orb = new /obj/item/mob_item(loc)
	orb.stored_mob = src
	if(movement_type & (FLOATING|FLYING)) // zads and such can perch on your shoulder
		orb.slot_flags |= ITEM_SLOT_BACK
	loc = orb
	status_flags |= GODMODE
	set_item_sprite(orb)
	orb.name = name
	orb.desc = desc
	reset_perspective(orb)
	return orb

// by default, just sets the icon and icon_state. some mobs might also want to set mob overlays, so they actually appear when you wear them
/mob/living/proc/set_item_sprite(obj/item/mob_item/orb)
	orb.icon = icon
	orb.icon_state = (item_state ? item_state : icon_state)
