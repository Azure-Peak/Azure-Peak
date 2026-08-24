/obj/item/storage/equipped(mob/user, slot)
	. = ..()
	var/datum/component/storage/concrete/storage = GetComponent(/datum/component/storage/concrete)
	if(!storage?.does_not_spill)
		for(var/obj/item/reagent_containers/I in contents)
			if(I.reagents && I.spillable)
				RegisterSignal(user, COMSIG_MOVABLE_MOVED, PROC_REF(check_spill), override = TRUE)
				break

/obj/item/storage/proc/check_spill()
	var/mob/living/L = loc
	if(!istype(L))
		return
	for(var/obj/item/reagent_containers/I in contents)
		if(I.spillable && I.reagents?.total_volume)
			L.warn_spilling()
			I.reagents.remove_all(3)
	return

/mob/living/proc/warn_spilling()
	if(mob_timers["spilling_warning"] && (world.time < (mob_timers["spilling_warning"] + 10 SECONDS)))
		return
	to_chat(src, span_warning("A damp wetness soaks through my bags."))
	mob_timers["spilling_warning"] = world.time
	return

/obj/item/storage/dropped(mob/user)
	. = ..()
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/obj/item/reagent_containers/on_enter_storage(datum/component/storage/concrete/S)
	..()
	if(spillable)
		if(S)
			var/atom/real_location = S.real_location()
			if(istype(real_location, /obj/item/storage))
				var/obj/item/storage/I = real_location
				if(ismob(I.loc))
					var/mob/M = I.loc
					I.RegisterSignal(M, COMSIG_MOVABLE_MOVED, TYPE_PROC_REF(/obj/item/storage, check_spill), override = TRUE)
