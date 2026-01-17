/mob/living/carbon/human/get_movespeed_modifiers()
	var/list/considering = ..()
	. = considering
	if(HAS_TRAIT(src, TRAIT_IGNORESLOWDOWN))
		for(var/id in .)
			var/list/data = .[id]
			if(data[MOVESPEED_DATA_INDEX_FLAGS] & IGNORE_NOSLOW)
				.[id] = data

/mob/living/carbon/human/slip(knockdown_amount, obj/O, lube, paralyze, forcedrop)
	if(HAS_TRAIT(src, TRAIT_NOSLIPALL))
		return 0
	if (!(lube&GALOSHES_DONT_HELP))
		if(HAS_TRAIT(src, TRAIT_NOSLIPWATER))
			return 0
		if(shoes && istype(shoes, /obj/item/clothing))
			var/obj/item/clothing/CS = shoes
			if (CS.clothing_flags & NOSLIP)
				return 0
	return ..()

/mob/living/carbon/human/Move(NewLoc, direct)
/*	if(fixedeye || tempfixeye)
		switch(dir)
			if(NORTH)
				if(direct == WEST|EAST)
					OffBalance(30)
			if(SOUTH)
				if(direct == WEST|EAST)
					OffBalance(30)
			if(EAST)
				if(direct == NORTH|SOUTH)
					OffBalance(30)
			if(WEST)
				if(direct == NORTH|SOUTH)
					OffBalance(30)*/

	. = ..()
	if(loc == NewLoc)

		if(hostage) // If we have a hostage.
			hostage.hostagetaker = null
			hostage = null
			to_chat(src, "<span class='danger'>I need to stand still to make sure I don't lose concentration on my hostage!</span>")

		if(hostagetaker) // If we are TAKEN hostage. Confusing vars at first but then it makes sense.
			attackhostage()

		if(wear_armor)
			if(mobility_flags & MOBILITY_STAND)
				wear_armor.step_action()

		if(wear_shirt)
			if(mobility_flags & MOBILITY_STAND)
				wear_shirt.step_action()

		if(cloak)
			if(mobility_flags & MOBILITY_STAND)
				var/obj/item/clothing/C = isclothing(cloak) ? cloak : null
				C?.step_action()

		if(shoes)
			var/obj/item/clothing/shoes/S = shoes
			if(mobility_flags & MOBILITY_STAND && istype(S))
				//Bloody footprints
				var/turf/T = get_turf(src)
				if(S.bloody_shoes && S.bloody_shoes[S.blood_state])
					for(var/obj/effect/decal/cleanable/blood/footprints/oldFP in T)
						if (oldFP.blood_state == S.blood_state)
							return
					//No oldFP or they're all a different kind of blood
					S.bloody_shoes[S.blood_state] = max(0, S.bloody_shoes[S.blood_state] - BLOOD_LOSS_PER_STEP)
					if (S.bloody_shoes[S.blood_state] > BLOOD_LOSS_IN_SPREAD)
						var/obj/effect/decal/cleanable/blood/footprints/FP = new /obj/effect/decal/cleanable/blood/footprints(T)
						FP.blood_state = S.blood_state
						FP.entered_dirs |= dir
						FP.bloodiness = S.bloody_shoes[S.blood_state] - BLOOD_LOSS_IN_SPREAD
						FP.add_blood_DNA(S.return_blood_DNA())
						FP.update_icon()
					update_inv_shoes()
				//End bloody footprints
				S.step_action()
		if(mouth)
			if(src.mind?.has_antag_datum(/datum/antagonist/zombie) && (!src.handcuffed) && prob(50))
				visible_message(span_warning("[src] spits out [mouth]."))
				dropItemToGround(mouth, silent = FALSE)

		if(istype(get_turf(src), /turf/open/floor/rogue/snow) && !HAS_TRAIT(src, TRAIT_LIGHT_STEP))
			var/obj/effect/decal/cleanable/blood/footprints/mud/mudprint = new /obj/effect/decal/cleanable/blood/footprints/mud(get_turf(src))
			mudprint.entered_dirs |= dir
			mudprint.update_icon()

// ===== MOUNTING PONIES =====

/mob/living/carbon/human/buckle_mob(mob/living/M, force = FALSE, check_loc = TRUE)
	if(!force && !HAS_TRAIT(src, TRAIT_MOUNTABLE))
		return FALSE

	if(..()) // call parent buckle
		var/datum/component/riding/human/riding_datum = LoadComponent(/datum/component/riding/human)
		riding_datum.vehicle_move_delay = 2
		if(M.mind)
			var/riding_skill = M.get_skill_level(/datum/skill/misc/riding)
			if(riding_skill)
				riding_datum.vehicle_move_delay = max(1, 2 - (riding_skill * 0.2))
		return TRUE
	return FALSE

/mob/living/carbon/human/post_buckle_mob(mob/living/M)
	var/datum/component/riding/human/riding_datum = LoadComponent(/datum/component/riding/human)
	riding_datum.handle_vehicle_layer()
	riding_datum.handle_vehicle_offsets()

/mob/living/carbon/human/relaymove(mob/user, direction)
	if(HAS_TRAIT(src, TRAIT_MOUNTABLE))
		var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding)
		if(riding_datum)
			return riding_datum.handle_ride(user, direction)
	return ..()

/mob/living/carbon/human/Knockdown(amount, updating = TRUE)
	. = ..() // parent Knockdown
	if(length(buckled_mobs))
		for(var/mob/living/carbon/human/rider in buckled_mobs)
			unbuckle_mob(rider, TRUE)
			to_chat(rider, span_warning("You fall off [src] as they collapse!"))
			to_chat(src, span_warning("[rider] tumbles off you as you fall!"))

/mob/living/carbon/human/attackby(obj/item/I, mob/living/user, params)
	if(buckled && istype(buckled, /mob/living/carbon/human))
		var/mob/living/carbon/human/mount = buckled
		if(HAS_TRAIT(mount, TRAIT_MOUNTABLE))
			visible_message(span_warning("[user]'s attack is redirected to [mount]'s chest!"))
			user.zone_selected = BODY_ZONE_CHEST
			return mount.attackby(I, user, params)
	return ..()

/mob/living/carbon/human/attack_animal(mob/living/simple_animal/M)
	if(buckled && istype(buckled, /mob/living/carbon/human))
		var/mob/living/carbon/human/mount = buckled
		if(HAS_TRAIT(mount, TRAIT_MOUNTABLE))
			visible_message(span_warning("[M]'s attack is redirected to [mount]!"))
			mount.attack_animal(M)
			return TRUE
	return ..()

/mob/living/carbon/human/bullet_act(obj/projectile/P)
	if(buckled && istype(buckled, /mob/living/carbon/human))
		var/mob/living/carbon/human/mount = buckled
		if(HAS_TRAIT(mount, TRAIT_MOUNTABLE))
			visible_message(span_warning("The [P] is redirected to [mount]!"))
			return mount.bullet_act(P)
	return ..()
