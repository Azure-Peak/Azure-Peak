
/obj/structure/closet/dirthole
	name = "hole"
	desc = "Just a small hole..."
	icon_state = "hole1"
	icon = 'icons/turf/roguefloor.dmi'
	var/stage = 1
	var/mutable_appearance/abovemob
	var/turf/open/floor/rogue/dirt/mastert
	var/faildirt = 0
	mob_storage_capacity = 3
	allow_dense = TRUE
	opened = TRUE
	density = FALSE
	anchored = TRUE
	can_buckle = FALSE
	max_integrity = 0
	buckle_lying = 90
	layer = 2.8

/obj/structure/closet/dirthole/grave
	desc = "A hole big enough for a coffin."
	stage = 3
	faildirt = 3
	icon_state = "grave"

/obj/structure/closet/dirthole/closed
	desc = "A mound of dirt with something below."
	stage = 4
	faildirt = 3
	climb_offset = 10
	icon_state = "gravecovered"
	opened = FALSE
	locked = TRUE

/obj/structure/closet/dirthole/container_resist(mob/living/user) // like that once scene from Kill Bill, crawl out of a grave.
	..()
	if(!src.locked == TRUE) // if we're not locked in, we don't need to crawl out.
		return
	if(!src.opened == FALSE) // if it's already open we can just get out.
		return
	if(src.stage != 4) // if we're not in a closed grave, we don't need to crawl out.
		return
	var/mob/living/carbon/stuck = user // Let's get carbonated.
	if (!stuck.has_hand_for_held_index(stuck.active_hand_index)) // Do we have a functioning hand?
		to_chat(user, span_warning("I can't dig out of here, I can't move my hand!"))
		return
	if (stuck.handcuffed) // Are we handcuffed?
		to_chat(user, span_warning("I can't dig out of here, I'm handcuffed!"))
		return
	to_chat(user, span_warning("I start clawing at the dirt for a way out!"))
	playsound(src, 'sound/foley/climb.ogg', 100, TRUE) // dirt shaking noises.
	playsound(usr, 'sound/foley/climb.ogg', 100, TRUE)
	if (do_after(user, 15 SECONDS, TRUE, src))
		user.visible_message(span_alert("A hand bursts from [src]!"),span_alert("I've managed to penetrate the surface of [src] with my hand!"))
		playsound(src, 'sound/foley/plantcross1.ogg', 100, TRUE)
		playsound(usr, 'sound/foley/plantcross1.ogg', 100, TRUE)
		if (do_after(user, 10 SECONDS, TRUE, src))
			src.stage--
			src.update_icon()
			src.climb_offset = 0
			src.open()
			playsound(src, 'sound/foley/breaksound.ogg', 100, TRUE)
			playsound(src, 'sound/foley/bodyfall (3).ogg', 90, TRUE)
			user.visible_message(span_warning("[user] emerges from [src]!"),span_alert("I emerge from [src]!"))

/obj/structure/closet/dirthole/closed/loot/Initialize()
	. = ..()
	lootroll = rand(1,4)

/obj/structure/closet/dirthole/closed/loot
	var/looted = FALSE
	var/lootroll = 0

/obj/structure/closet/dirthole/closed/loot/open()
	if(!looted)
		looted = TRUE
		switch(lootroll)
			if(1)
				new /mob/living/carbon/human/species/skeleton/npc(mastert)
			if(2)
				new /obj/structure/closet/crate/chest/lootbox(mastert)
	..()

/obj/structure/closet/dirthole/closed/loot/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		if(lootroll == 1)
			. += span_warning("Better let this one sleep.")

/obj/structure/closet/dirthole/insertion_allowed(atom/movable/AM)
	if(istype(AM, /obj/structure/closet/crate/coffin) || istype(AM, /obj/structure/closet/burial_shroud))
		for(var/mob/living/M in contents)
			return FALSE
		for(var/obj/structure/closet/C in contents)
			if(istype(C, /obj/structure/closet/crate/coffin))
				return TRUE
			return FALSE
		return TRUE
	. = ..()

/obj/structure/closet/dirthole/toggle(mob/living/user)
	return

/obj/structure/closet/dirthole/attack_hand(mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_SOUL_EXAMINE))
		var/atom/movable/coffin = src
		for(var/mob/living/corpse in coffin)
			if(!corpse.stat == DEAD)
				to_chat(user, "That one hasn't truly passed on yet?!")
				return
			if(corpse.burialrited)
				to_chat(user, "This grave has already been consecrated...")
				return
			else
				to_chat(user, "I begin my burial rites...")
				if(do_after(user, 50))
					user.say("#Rest thy soul for all aeon within Necra's embrace!")
					to_chat(user, "I have extracted a strand of luxthread, proof of passing.")
					playsound(user, 'sound/misc/bellold.ogg', 20)
					new /obj/item/soulthread((get_turf(user)))
					corpse.burialrited = TRUE


/obj/structure/closet/dirthole/attackby(obj/item/attacking_item, mob/user, params)
	if(!istype(attacking_item, /obj/item/rogueweapon/shovel))
		return ..()
	var/obj/item/rogueweapon/shovel/attacking_shovel = attacking_item
	if(user.used_intent.type != /datum/intent/shovelscoop)
		return

	if(attacking_shovel.heldclod)
		playsound(loc,'sound/items/empty_shovel.ogg', 100, TRUE)
		QDEL_NULL(attacking_shovel.heldclod)
		if(stage == 3) //close grave
			stage = 4
			climb_offset = 10
			locked = TRUE
			close()
			var/founds
			for(var/atom/A in contents)
				founds = TRUE
				break
			if(!founds)
				stage = 2
				climb_offset = 0
				locked = FALSE
				open()
			update_icon()
		else if(stage < 4)
			stage--
			climb_offset = 0
			update_icon()
			if(stage == 0)
				qdel(src)
		attacking_shovel.update_icon()
		return
	else
		if(stage == 3)
			var/turf/underT = get_step_multiz(src, DOWN)
			if(underT && isopenturf(underT) && mastert)
				var/area/rogue/underA = underT.loc
				if((underA && !underA.ceiling_protected) || !underA)
					attacking_shovel.heldclod = new(attacking_shovel)
					attacking_shovel.update_icon()
					playsound(mastert,'sound/items/dig_shovel.ogg', 100, TRUE)
					mastert.ChangeTurf(/turf/open/transparent/openspace)
					return
//					for(var/D in GLOB.cardinals)
//						var/turf/T = get_step(mastert, D)
//						if(T)
//							if(istype(T, /turf/open/water))
//								attacking_shovel.heldclod = new(attacking_shovel)
//								attacking_shovel.update_icon()
//								playsound(mastert,'sound/items/dig_shovel.ogg', 100, TRUE)
//								mastert.ChangeTurf(T.type, flags = CHANGETURF_INHERIT_AIR)
//								return
			to_chat(user, span_warning("I can't dig myself any deeper."))
			return
		var/used_str = 10
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(C.domhand)
				used_str = C.get_str_arms(C.used_hand)
			C.stamina_add(max(60 - (used_str * 5), 1))
		if(stage < 3)
			if(faildirt < 2)
				if(prob(used_str * 5))
					stage++
				else
					faildirt++
			else
				stage++
		if(stage == 4)
			stage = 3
			climb_offset = 0
			locked = FALSE
			open()
			for(var/obj/structure/gravemarker/G in loc)
				record_featured_stat(FEATURED_STATS_CRIMINALS, user)
				record_round_statistic(STATS_GRAVES_ROBBED)
				qdel(G)
				if(isliving(user))
					var/mob/living/L = user
					if(!HAS_TRAIT(L, TRAIT_GRAVEROBBER))
						L.apply_status_effect(/datum/status_effect/debuff/cursed)
		update_icon()
		attacking_shovel.heldclod = new(attacking_shovel)
		attacking_shovel.update_icon()
		playsound(loc,'sound/items/dig_shovel.ogg', 100, TRUE)
		return

/datum/status_effect/debuff/cursed
	id = "cursed"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/cursed
	effectedstats = list(STATKEY_LCK = -3)
	duration = 10 MINUTES

/atom/movable/screen/alert/status_effect/debuff/cursed
	name = "Cursed"
	desc = "I feel... unlucky."
	icon_state = "debuff"

/obj/structure/closet/dirthole/MouseDrop_T(atom/movable/O, mob/living/user)
	var/turf/T = get_turf(src)
	if(istype(O, /obj/structure/closet/crate/coffin))
		O.forceMove(T)
	if(!istype(O) || O.anchored || istype(O, /atom/movable/screen))
		return
	if(!istype(user) || user.incapacitated() || !(user.mobility_flags & MOBILITY_STAND))
		return
	if(!Adjacent(user) || !user.Adjacent(O))
		return
	if(user == O) //try to climb onto it
		return ..()
	if(!opened)
		return
	if(!isturf(O.loc))
		return

	var/actuallyismob = 0
	if(isliving(O))
		actuallyismob = 1
	else if(!isitem(O))
		return
	var/list/targets = list(O, src)
	add_fingerprint(user)
	user.visible_message(span_warning("[user] [actuallyismob ? "tries to ":""]stuff [O] into [src]."), \
				 	 	span_warning("I [actuallyismob ? "try to ":""]stuff [O] into [src]."), \
				 	 	span_hear("I hear clanging."))
	if(actuallyismob)
		if(do_after_mob(user, targets, 40))
			user.visible_message(span_notice("[user] stuffs [O] into [src]."), \
							 	 span_notice("I stuff [O] into [src]."), \
							 	 span_hear("I hear a loud bang."))
			O.forceMove(T)
			user_buckle_mob(O, user)
	else
		O.forceMove(T)
	return 1

/obj/structure/closet/dirthole/take_contents()
	var/atom/L = drop_location()
	..()
	for(var/obj/structure/closet/crate/coffin/C in L)
		if(C != src && insert(C) == -1)
			break


/obj/structure/closet/dirthole/close(mob/living/user)
	if(!opened || !can_close(user))
		return FALSE
	take_contents()
	for(var/mob/A in contents)
		if((A.stat) && (istype(A, /mob/living/carbon/human)))
			var/mob/living/carbon/human/B = A
			B.buried = TRUE
	for(var/obj/structure/closet/crate/coffin/C in contents)
		for(var/mob/living/carbon/human/D in C.contents)
			D.buried = TRUE
	opened = FALSE
//	update_icon()
	return TRUE

/obj/structure/closet/dirthole/dump_contents()
	for(var/mob/A in contents)
		if((!A.stat) && (istype(A, /mob/living/carbon/human)))
			var/mob/living/carbon/human/B = A
			B.buried = FALSE
	..()

/obj/structure/closet/dirthole/open(mob/living/user)
	if(opened)
		return
	opened = TRUE
	dump_contents()
	update_icon()
	return 1


/obj/structure/closet/dirthole/update_icon()
	switch(stage)
		if(1)
			name = "hole"
			icon_state = "hole1"
			can_buckle = FALSE
		if(2)
			name = "hole"
			icon_state = "hole2"
			can_buckle = FALSE
		if(3)
			name = "pit"
			icon_state = "grave"
			can_buckle = TRUE
		if(4)
			name = "grave"
			icon_state = "gravecovered"
			can_buckle = FALSE
	update_abovemob()

/obj/structure/closet/dirthole/Initialize()
	abovemob = mutable_appearance('icons/turf/roguefloor.dmi', "grave_above")
	abovemob.layer = ABOVE_MOB_LAYER
	update_icon()
	var/turf/open/floor/rogue/dirt/T = loc
	if(istype(T))
		mastert = T
		T.holie = src
		if(T.muddy)
			if(prob(55))
				if(prob(20))
					if(prob(5))
						new /obj/item/natural/worms/grubs(T)
					else
						new /obj/item/natural/worms/leech(T)
				else
					new /obj/item/natural/worms(T)
			if(!(locate(/obj/item/natural/clay) in T))
				if(prob(25))
					new /obj/item/natural/clay(T)
		else
			if(prob(23))
				new /obj/item/natural/stone(T)
			if(prob(18))
				new /obj/item/natural/clay(T)
	return ..()

/obj/structure/closet/dirthole/Destroy()
	QDEL_NULL(abovemob)
	if(mastert && mastert.holie == src)
		mastert.holie = null
	return ..()

/obj/structure/closet/dirthole/post_buckle_mob(mob/living/M)
	. = ..()
	update_abovemob()

/obj/structure/closet/dirthole/proc/update_abovemob()
	if(has_buckled_mobs() && stage == 3)
		add_overlay(abovemob)
	else
		cut_overlay(abovemob)

/obj/structure/closet/dirthole/post_unbuckle_mob()
	. = ..()
	update_abovemob()

