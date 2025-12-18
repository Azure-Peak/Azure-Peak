/mob/living
	//used by the basic ai controller /datum/ai_behavior/basic_melee_attack to determine how fast a mob can attack
	var/melee_cooldown = CLICK_CD_MELEE
	var/pain_threshold = 0

/mob/living/Initialize()
	. = ..()
	update_a_intents()
	swap_rmb_intent(num=1)
	if(unique_name)
		name = "[name] ([rand(1, 1000)])"
		real_name = name
	faction += "[REF(src)]"
	GLOB.mob_living_list += src
	init_faith()

/mob/living/Destroy()
	surgeries = null
	if(LAZYLEN(status_effects))
		for(var/s in status_effects)
			var/datum/status_effect/S = s
			if(S.on_remove_on_mob_delete) //the status effect calls on_remove when its mob is deleted
				qdel(S)
			else
				S.be_replaced()
	if(ranged_ability)
		ranged_ability.remove_ranged_ability(src)
	if(buckled)
		buckled.unbuckle_mob(src,force=1)

	stop_offering_item()

	GLOB.mob_living_list -= src
	for(var/s in ownedSoullinks)
		var/datum/soullink/S = s
		S.ownerDies(FALSE)
		qdel(s) //If the owner is destroy()'d, the soullink is destroy()'d
	ownedSoullinks = null
	for(var/s in sharedSoullinks)
		var/datum/soullink/S = s
		S.sharerDies(FALSE)
		S.removeSoulsharer(src) //If a sharer is destroy()'d, they are simply removed
	sharedSoullinks = null
	if(craftingthing)
		QDEL_NULL(craftingthing)
	return ..()

/mob/living/onZImpact(turf/T, levels)
	if(HAS_TRAIT(src, TRAIT_NOFALLDAMAGE2))
		return
	if(HAS_TRAIT(src, TRAIT_NOFALLDAMAGE1))
		if(levels <= 2)
			Immobilize(10)
			if(m_intent == MOVE_INTENT_RUN)
				toggle_rogmove_intent(MOVE_INTENT_WALK)
			return
	var/points
	for(var/i in 2 to levels)
		i++
		points += "!"
	visible_message(span_danger("[src] falls down[points]"), \
					span_danger("I fall down[points]"))
	if(!isgroundlessturf(T))
		playsound(src.loc, 'sound/foley/zfall.ogg', 100, FALSE)
		ZImpactDamage(T, levels)
		record_round_statistic(STATS_MOAT_FALLERS)
	return ..()

/mob/living/proc/ZImpactDamage(turf/T, levels)
	adjustBruteLoss((levels * 5) ** 1.5)
	AdjustStun(levels * 20)
	AdjustKnockdown(levels * 20)

/mob/living/proc/OpenCraftingMenu()
	return

//Generic Bump(). Override MobBump() and ObjBump() instead of this.
/mob/living/Bump(atom/A)
	if(..()) //we are thrown onto something
		return
	if (buckled || now_pushing)
		return
	if(ismob(A))
		var/mob/M = A
		if(MobBump(M))
			return
	if(isobj(A))
		var/obj/O = A
		if(ObjBump(O))
			return
	if(ismovableatom(A))
		var/atom/movable/AM = A
		if(PushAM(AM, move_force))
			return

/mob/living/Bumped(atom/movable/AM)
	..()
	last_bumped = world.time

//Called when we bump onto a mob
/mob/living/proc/MobBump(mob/M)
	//Even if we don't push/swap places, we "touched" them, so spread fire
	spreadFire(M)

	if(now_pushing)
		return TRUE

	var/they_can_move = TRUE
	if(isliving(M))
		var/mob/living/L = M
		they_can_move = L.mobility_flags & MOBILITY_MOVE

		//Should stop you pushing a restrained person out of the way
		if(L.pulledby && L.pulledby != src && L.pulledby != L && L.restrained())
			if(!(world.time % 5))
				to_chat(src, span_warning("[L] is restrained, you cannot push past."))
			return TRUE

		if(L.pulling)
			if(ismob(L.pulling) && L.pulling != L)
				var/mob/P = L.pulling
				if(!(world.time % 5))
					to_chat(src, span_warning("[L] is grabbing [P], you cannot push past."))
				return TRUE

	if(moving_diagonally)//no mob swap during diagonal moves.
		return TRUE

	if(!M.buckled && !M.has_buckled_mobs())
		var/mob_swap = FALSE
		var/too_strong = (M.move_resist > move_force) //can't swap with immovable objects unless they help us
		if(istype(M,/mob/living/simple_animal/hostile/retaliate))
			if(!M:aggressive)
				mob_swap = TRUE
		if(!they_can_move) //we have to physically move them
			if(!too_strong)
				mob_swap = FALSE
		else
			//You can swap with the person you are dragging on grab intent, and restrained people in most cases
			if(M.pulledby == src && !too_strong)
				mob_swap = FALSE
			else if(
				!( HAS_TRAIT(M, TRAIT_NOMOBSWAP) || HAS_TRAIT(src, TRAIT_NOMOBSWAP) ) &&\
				( (M.restrained() && !too_strong) ) &&\
				( restrained() )
				)
				mob_swap = FALSE
		if(mob_swap)
			//switch our position with M
			if(loc && !loc.Adjacent(M.loc))
				return TRUE
			now_pushing = 1
			var/oldloc = loc
			var/oldMloc = M.loc

			var/M_passmob = (M.pass_flags & PASSMOB) // we give PASSMOB to both mobs to avoid bumping other mobs during swap.
			var/src_passmob = (pass_flags & PASSMOB)
			M.pass_flags |= PASSMOB
			pass_flags |= PASSMOB

			var/move_failed = FALSE
			if(!M.Move(oldloc) || !Move(oldMloc))
				M.forceMove(oldMloc)
				forceMove(oldloc)
				move_failed = TRUE
			if(!src_passmob)
				pass_flags &= ~PASSMOB
			if(!M_passmob)
				M.pass_flags &= ~PASSMOB

			now_pushing = 0

			if(!move_failed)
				return TRUE

	if(m_intent == MOVE_INTENT_RUN && dir == get_dir(src, M))
		if(isliving(M))
			var/sprint_distance = sprinted_tiles
			var/instafail = FALSE
			toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)
			if(HAS_TRAIT(src, TRAIT_PACIFISM)) // No Con-Checking if you're a pacifist. You aren't MEAN!!!
				return FALSE
			var/mob/living/L = M

			var/self_points = FLOOR((STACON + STASTR)/2, 1)
			var/target_points = FLOOR((L.STACON + L.STASTR)/2, 1)

			switch(sprint_distance)
				// Point blank
				if(0 to 1)
					self_points -= 99
					instafail = TRUE
				// One to two tile between the people
				if(2 to 3)
					self_points -= 2
				// Five or above tiles between people
				if(6 to INFINITY)
					self_points += 1
			// If charging into the BACK of the enemy (facing away)
			if(L.dir == get_dir(src, L))
				self_points += 2

			// Shields matter
			var/list/obj/item/user_inhand = get_held_items()
			var/list/obj/item/target_inhand = L.get_held_items()

			for(var/obj/I in user_inhand)
				if(istype(I, /obj/item/rogueweapon/shield))
					self_points += 2
			for(var/obj/I in target_inhand)
				if(istype(I, /obj/item/rogueweapon/shield))
					target_points += 2

			// Randomize con roll from -1 to +1 to make it less consistent
			self_points += rand(-1, 1)

			//Safety check for changing direction at the last step
			if(src.dir != src.sprint_dir)
				self_points -= 99
				instafail = TRUE
				to_chat(src, span_warning("I changed direction too late!"))
			var/clash_blocked
			if(L.has_status_effect(/datum/status_effect/buff/clash) && !instafail)
				self_points -= 99
				L.remove_status_effect(/datum/status_effect/buff/clash)
				to_chat(src, span_warning("[L] was ready for me!"))
				if(prob(10))
					playsound(src, 'sound/combat/clash_charge_meme.ogg', 100)
				else
					playsound(src, 'sound/combat/clash_charge.ogg', 100)
				clash_blocked = TRUE
			if(self_points > target_points)
				L.Knockdown(1)
			if(self_points < target_points)
				Knockdown(30)
			if(self_points == target_points)
				L.Knockdown(1)
				Knockdown(30)
			Immobilize(5)
			var/playsound = FALSE
			if(L.apply_damage(15, BRUTE, "chest", L.run_armor_check("chest", "blunt", damage = 10)))
				playsound = TRUE
			if(instafail)
				if(apply_damage(15, BRUTE, "head", run_armor_check("head", "blunt", damage = 20)))
					playsound = TRUE
			if(playsound)
				playsound(src, "genblunt", 100, TRUE)
			if(instafail || clash_blocked)
				if(instafail)
					visible_message(span_warning("[src] smashes into [L] with no headstart!"), span_warning("I charge into [L] too early!"))
				if(clash_blocked)
					visible_message(span_warning("[src] gets tripped by [L]!"), span_warning("I get tripped by [L]!"))
			else
				visible_message(span_warning("[src] charges into [L]!"), span_warning("I charge into [L]!"))
			return TRUE

	//okay, so we didn't switch. but should we push?
	//not if he's not CANPUSH of course
	if(!(M.status_flags & CANPUSH))
		return TRUE
	if(isliving(M))
		var/mob/living/L = M
		if(HAS_TRAIT(L, TRAIT_PUSHIMMUNE))
			return TRUE

		//stat checking block
		if(!(world.time % 5))
			var/statchance = 50

			if(STASTR > L.STASTR)
				statchance = 50 + (STASTR - L.STASTR * 10)

			else if(STASTR < L.STASTR)
				statchance = 50 - (L.STASTR - STASTR * 10)
			if(statchance < 10)
				statchance = 10
			if(prob(statchance))
				visible_message(span_info("[src] pushes [M]."))
			else
				visible_message(span_warning("[src] pushes [M]."))
				return TRUE

	//anti-riot equipment is also anti-push
	for(var/obj/item/I in M.held_items)
		if(!istype(M, /obj/item/clothing))
			if(prob(I.block_chance*2))
				return

//Called when we bump onto an obj
/mob/living/proc/ObjBump(obj/O)
	return

//Called when we want to push an atom/movable
/mob/living/proc/PushAM(atom/movable/AM, force = move_force)
	if(now_pushing)
		return TRUE
	if(moving_diagonally)// no pushing during diagonal moves.
		return TRUE
	if(!client && (mob_size < MOB_SIZE_SMALL))
		return
	now_pushing = TRUE
	var/t = get_dir(src, AM)
	var/push_anchored = FALSE
	if((AM.move_resist * MOVE_FORCE_CRUSH_RATIO) <= force)
		if(move_crush(AM, move_force, t))
			push_anchored = TRUE
	if((AM.move_resist * MOVE_FORCE_FORCEPUSH_RATIO) <= force)			//trigger move_crush and/or force_push regardless of if we can push it normally
		if(force_push(AM, move_force, t, push_anchored))
			push_anchored = TRUE
	if((AM.anchored && !push_anchored) || (force < (AM.move_resist * MOVE_FORCE_PUSH_RATIO)))
		now_pushing = FALSE
		return

	var/current_dir
	if(isliving(AM))
		current_dir = AM.dir
	if(AM.Move(get_step(AM.loc, t), t, glide_size))
		Move(get_step(loc, t), t)
	if(current_dir)
		AM.setDir(current_dir)
	now_pushing = FALSE

/mob/living/carbon/can_be_pulled(user, grab_state, force)
	. = ..()
	if(isliving(user))
		var/mob/living/L = user
		if(!get_bodypart(check_zone(L.zone_selected)))
			to_chat(L, span_warning("[src] is missing that."))
			return FALSE
		if(!lying_attack_check(L))
			return FALSE
		// snowflake check for blocking mouthgrabs on biting deadites
		if(L.zone_selected == BODY_ZONE_PRECISE_MOUTH && istype(mouth, /obj/item/grabbing/bite))
			to_chat(L, span_warning("You can't grab [src]'s mouth while [p_theyre()] biting something!"))
			return FALSE
	return TRUE

/mob/living/carbon/proc/kick_attack_check(mob/living/L)
	if(L == src)
		return FALSE
	if(!(src.mobility_flags & MOBILITY_STAND))
		return TRUE
	var/list/acceptable = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_R_ARM, BODY_ZONE_CHEST, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_STOMACH)
	if(HAS_TRAIT(L, TRAIT_CIVILIZEDBARBARIAN))
		acceptable.Add(BODY_ZONE_HEAD)
	if( !(check_zone(L.zone_selected) in acceptable) )
		to_chat(L, span_warning("I can't reach that."))
		return FALSE
	return TRUE

/mob/living/carbon/proc/lying_attack_check(mob/living/L, obj/item/I)
	if(L == src)
		return TRUE
	var/CZ = FALSE
	var/list/acceptable = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_HEAD, BODY_ZONE_R_ARM, BODY_ZONE_CHEST, BODY_ZONE_L_ARM)
	if((L.mobility_flags & MOBILITY_STAND) && (mobility_flags & MOBILITY_STAND)) //we are both standing
		if(I)
			if(I.wlength > WLENGTH_NORMAL)
				CZ = TRUE
			else //we have a short/medium weapon, so allow hitting legs
				acceptable = list(BODY_ZONE_HEAD, BODY_ZONE_R_ARM, BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_NECK, BODY_ZONE_PRECISE_R_EYE,BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_EARS, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
		else
			if(!CZ)
				acceptable = list(BODY_ZONE_HEAD, BODY_ZONE_R_ARM, BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_NECK, BODY_ZONE_PRECISE_R_EYE,BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_EARS, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
				if(HAS_TRAIT(L, TRAIT_CIVILIZEDBARBARIAN))
					acceptable = list(BODY_ZONE_HEAD, BODY_ZONE_R_ARM, BODY_ZONE_CHEST, BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_NECK, BODY_ZONE_PRECISE_R_EYE,BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_EARS, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
	else if(!(L.mobility_flags & MOBILITY_STAND) && (mobility_flags & MOBILITY_STAND)) //we are prone, victim is standing
		if(I)
			if(I.wlength > WLENGTH_NORMAL)
				CZ = TRUE
			else
				acceptable = list(BODY_ZONE_R_ARM,BODY_ZONE_L_ARM,BODY_ZONE_PRECISE_R_HAND,BODY_ZONE_PRECISE_L_HAND,BODY_ZONE_PRECISE_GROIN, BODY_ZONE_PRECISE_STOMACH, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
		else
			if(!CZ)
				acceptable = list(BODY_ZONE_L_LEG, BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_PRECISE_L_FOOT)
	else
		CZ = TRUE
	if(CZ)
		if( !(check_zone(L.zone_selected) in acceptable) )
			to_chat(L, span_warning("I can't reach that."))

			return FALSE
	else
		if( !(L.zone_selected in acceptable) )
			to_chat(L, span_warning("I can't reach that."))

			return FALSE
	return TRUE

/mob/living/start_pulling(atom/movable/AM, state, force = pull_force, supress_message = FALSE, obj/item/item_override)
	if(!AM || !src)
		return FALSE
	if(!(AM.can_be_pulled(src, state, force)))
		return FALSE
	if(throwing || !(mobility_flags & MOBILITY_PULL))
		return FALSE

	AM.add_fingerprint(src)

	// If we're pulling something then drop what we're currently pulling and pull this instead.
	if(pulling && AM != pulling)
		stop_pulling()

	changeNext_move(CLICK_CD_GRABBING)

//	if(AM.pulledby && AM.pulledby != src)
//		if(AM == src)
//			to_chat(src, span_warning("I'm being grabbed by something!"))
//			return FALSE
//		else
//			if(!supress_message)
//				AM.visible_message(span_danger("[src] has pulled [AM] from [AM.pulledby]'s grip."), span_danger("[src] has pulled me from [AM.pulledby]'s grip."), null, null, src)
//
//				to_chat(src, span_notice("I pull [AM] from [AM.pulledby]'s grip!"))
//			log_combat(AM, AM.pulledby, "pulled from", src)
//			AM.pulledby.stop_pulling() //an object can't be pulled by two mobs at once.
	if(AM != src)
		pulling = AM
		AM.pulledby = src
	update_pull_hud_icon()

	if(isliving(AM))
		var/mob/living/target = AM
		log_combat(src, target, "grabbed", addition="passive grab")
		if(!iscarbon(src))
			target.LAssailant = null
		else
			target.LAssailant = usr

		target.update_damage_hud()

		if(target.has_status_effect(/datum/status_effect/buff/oiled))
			// Determine which limb we're trying to grab
			var/target_zone = zone_selected
			if(!target_zone)
				target_zone = "chest" // Default if no zone selected

			// Check if the target limb is covered by clothing
			var/is_covered = FALSE
			if(iscarbon(target))
				var/mob/living/carbon/carbon_target = target
				var/obj/item/bodypart/target_limb = carbon_target.get_bodypart(check_zone(target_zone))
				if(target_limb)
					is_covered = carbon_target.is_limb_covered(target_limb)

			// If limb is not covered and oiled, chance to slip away
			if(!is_covered)
				if(prob(50)) // 35% chance to slip away from grab attempt
					visible_message(span_warning("[target] slips away from [src]'s oily grasp!"), \
							span_warning("[target.name] slips away from my grip - they're too oily!"))
					log_combat(src, target, "failed to grab due to oil", addition="oiled skin")
					return FALSE // Grab attempt fails

		if(HAS_TRAIT(target, TRAIT_GRABIMMUNE) && target.stat == CONSCIOUS) // Grab immunity check
			if(target.cmode)
				target.visible_message(span_warning("[target] breaks from [src]'s grip effortlessly!"), \
						span_warning("I break from [src]'s grab effortlessly!"))
				log_combat(src, target, "tried grabbing", addition="passive grab")
				stop_pulling()
				return

		// Makes it so people who recently broke out of grabs cannot be grabbed again
		if(TIMER_COOLDOWN_RUNNING(target, "broke_free") && target.stat == CONSCIOUS)
			target.visible_message(span_warning("[target] slips from [src]'s grip."), \
					span_warning("I slip from [src]'s grab."))
			log_combat(src, target, "tried grabbing", addition="passive grab")
			return

		log_combat(src, target, "grabbed", addition="passive grab")
		playsound(src.loc, 'sound/combat/shove.ogg', 50, TRUE, -1)
		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/obj/item/grabbing/O = new()
			var/used_limb = C.find_used_grab_limb(src)
			O.name = "[C]'s [parse_zone(used_limb)]"
			var/obj/item/bodypart/BP = C.get_bodypart(check_zone(used_limb))
			C.grabbedby += O
			O.grabbed = C
			O.grabbee = src
			O.limb_grabbed = BP
			BP.grabbedby += O
			if(item_override)
				O.sublimb_grabbed = item_override
			else
				O.sublimb_grabbed = used_limb
			put_in_hands(O)
			O.update_hands(src)
			if(HAS_TRAIT(src, TRAIT_STRONG_GRABBER) || item_override)
				supress_message = TRUE
				C.grippedby(src)
			if(!supress_message)
				send_pull_message(target)
			var/signal_result = SEND_SIGNAL(target, COMSIG_LIVING_GRAB_SELF_ATTEMPT, target, used_limb)
			if(signal_result & COMPONENT_CANCEL_GRAB_ATTACK)
				return FALSE
		else
			var/obj/item/grabbing/O = new()
			O.name = "[target.name]"
			O.grabbed = target
			O.grabbee = src
			if(item_override)
				O.sublimb_grabbed = item_override
			else
				O.sublimb_grabbed = target.simple_limb_hit(zone_selected)
			put_in_hands(O)
			O.update_hands(src)
			if(HAS_TRAIT(src, TRAIT_STRONG_GRABBER) || item_override)
				supress_message = TRUE
				target.grippedby(src)
			if(!supress_message)
				send_pull_message(target)
			var/signal_result = SEND_SIGNAL(target, COMSIG_LIVING_GRAB_SELF_ATTEMPT, target, zone_selected)
			if(signal_result & COMPONENT_CANCEL_GRAB_ATTACK)
				return FALSE

		update_pull_movespeed()
		set_pull_offsets(target, state)
	else
		if(!supress_message)
			var/sound_to_play = 'sound/combat/shove.ogg'
			playsound(src.loc, sound_to_play, 50, TRUE, -1)
		var/obj/item/grabbing/O = new(src)
		O.name = "[AM.name]"
		O.grabbed = AM
		O.grabbee = src
		src.put_in_hands(O)
		O.update_hands(src)
		update_grab_intents()

/mob/living/proc/is_limb_covered(obj/item/bodypart/limb)
	if(!limb)
		return FALSE

	// Check for clothing covering this limb
	for(var/obj/item/clothing/C in src.get_equipped_items())
		if(C.body_parts_covered & limb.body_part)
			return TRUE
	return FALSE

/mob/living/proc/send_pull_message(mob/living/target)
	target.visible_message(span_warning("[src] grabs [target]."), \
					span_warning("[src] grabs me."), span_hear("I hear shuffling."), null, src)
	to_chat(src, span_info("I grab [target]."))

/mob/living/proc/set_pull_offsets(mob/living/M, grab_state = GRAB_PASSIVE)
	if(M.buckled)
		return //don't make them change direction or offset them if they're buckled into something.
	if(M.dir != turn(get_dir(M,src), 180))
		if(!((cmode || M.cmode) && M.grab_state < GRAB_AGGRESSIVE))
			M.setDir(get_dir(M, src))
	var/offset = 0
	switch(grab_state)
		if(GRAB_PASSIVE)
			offset = GRAB_PIXEL_SHIFT_PASSIVE
		if(GRAB_AGGRESSIVE)
			offset = GRAB_PIXEL_SHIFT_AGGRESSIVE
		if(GRAB_NECK)
			offset = GRAB_PIXEL_SHIFT_NECK
		if(GRAB_KILL)
			offset = GRAB_PIXEL_SHIFT_NECK
	if((cmode || M.cmode) && M.grab_state < GRAB_AGGRESSIVE)
		switch(get_dir(src, M))
			if(NORTH)
				set_mob_offsets("pulledby", 0, 0+offset)
				layer = MOB_LAYER+0.05
			if(SOUTH)
				set_mob_offsets("pulledby", 0, 0-offset)
				layer = MOB_LAYER-0.05
			if(EAST)
				set_mob_offsets("pulledby", 0+offset, 0)
				layer = MOB_LAYER
			if(WEST)
				set_mob_offsets("pulledby", 0-offset, 0)
				layer = MOB_LAYER
	else
		switch(get_dir(M, src))
			if(NORTH)
				M.set_mob_offsets("pulledby", 0, 0+offset)
				M.layer = MOB_LAYER+0.05
			if(SOUTH)
				M.set_mob_offsets("pulledby", 0, 0-offset)
				M.layer = MOB_LAYER-0.05
			if(EAST)
				M.set_mob_offsets("pulledby", 0+offset, 0)
				M.layer = MOB_LAYER
			if(WEST)
				M.set_mob_offsets("pulledby", 0-offset, 0)
				M.layer = MOB_LAYER

/mob/living/proc/reset_pull_offsets(mob/living/M, override)
	if(!override && M.buckled)
		return
	M.reset_offsets("pulledby")
	M.layer = MOB_LAYER
	//animate(M, pixel_x = 0 , pixel_y = 0, 1)

/mob/living
	var/list/mob_offsets = list()

/mob/living/proc/set_mob_offsets(index, _x = 0, _y = 0)
	if(index)
		if(mob_offsets[index])
			reset_offsets(index)
		mob_offsets[index] = list("x" = _x, "y" = _y)
//		pixel_x = pixel_x + mob_offsets[index]["x"]
//		pixel_y = pixel_y + mob_offsets[index]["y"]
	update_transform()

/mob/living/proc/reset_offsets(index)
	if(index)
		if(mob_offsets[index])
//			animate(src, pixel_x = pixel_x - mob_offsets[index]["x"], pixel_y = pixel_y - mob_offsets[index]["y"], 1)
//			pixel_x = pixel_x - mob_offsets[index]["x"]
//			pixel_y = pixel_y - mob_offsets[index]["y"]
			mob_offsets[index] = null
	update_transform()

//mob verbs are a lot faster than object verbs
//for more info on why this is not atom/pull, see examinate() in mob.dm
/mob/living/verb/pulled(atom/movable/AM as mob|obj in oview(1))
	set name = "Pull"
	set hidden = 1

	if(istype(AM) && Adjacent(AM))
		start_pulling(AM)
	else
		stop_pulling()

/mob/living/stop_pulling(forced = TRUE)
	if(pulling)
		if(ismob(pulling))
			var/mob/living/M = pulling
			if(pulledby && pulledby == pulling)
				reset_offsets("pulledby")
			M.reset_offsets("pulledby")
			reset_pull_offsets(pulling)
			if(HAS_TRAIT(M, TRAIT_GARROTED))
				var/obj/item/inqarticles/garrote/gcord = src.get_active_held_item()
				if(!gcord)
					gcord = src.get_inactive_held_item()
				gcord.wipeslate(src)

		if(forced) //if false, called by the grab item itself, no reason to drop it again
			if(istype(get_active_held_item(), /obj/item/grabbing))
				var/obj/item/grabbing/I = get_active_held_item()
				if(I.grabbed == pulling)
					dropItemToGround(I, silent = FALSE)
			if(istype(get_inactive_held_item(), /obj/item/grabbing))
				var/obj/item/grabbing/I = get_inactive_held_item()
				if(I.grabbed == pulling)
					dropItemToGround(I, silent = FALSE)
	reset_offsets("pulledby")
	reset_pull_offsets(src)
	. = ..()

	update_pull_movespeed()
	update_pull_hud_icon()

/mob/living/carbon/stop_pulling(forced = TRUE)
	. = ..()
	if(forced)
		if(istype(mouth, /obj/item/grabbing))
			var/obj/item/grabbing/I = mouth
			if(I.grabbed == pulling)
				dropItemToGround(I, silent = FALSE)


/mob/living/verb/stop_pulling1()
	set name = "Stop Pulling"
	set category = "IC"
	set hidden = 1
	stop_pulling()

/mob/living/verb/succumb(whispered as null, reaper as null)
	set hidden = TRUE
	if(stat == DEAD)
		return
	if(!reaper)
		return
	if (InCritical() || health <= 0 || (blood_volume < BLOOD_VOLUME_SURVIVE))
		log_message("Has [whispered ? "whispered his final words" : "succumbed to death"] while in [InFullCritical() ? "hard":"soft"] critical with [round(health, 0.1)] points of health!", LOG_ATTACK)

		if(istype(src.loc, /turf/open/water) && !HAS_TRAIT(src, TRAIT_NOBREATH) && lying && client)
			record_round_statistic(STATS_PEOPLE_DROWNED)

		adjustOxyLoss(201)
		updatehealth()
//		if(!whispered)
//			to_chat(src, span_userdanger("I have given up life and succumbed to death."))

		var/word_input = stripped_input(src, "Your parting words? Leave empty if you will.", "Last Words")
		if(word_input)
			say(word_input)
		death()

/mob/living/incapacitated(ignore_restraints = FALSE, ignore_grab = TRUE, check_immobilized = FALSE, ignore_stasis = FALSE)
	if(stat || IsUnconscious() || IsStun() || IsParalyzed() || (!ignore_restraints && restrained(ignore_grab)))
		return TRUE

/mob/living/canUseStorage()
	if (get_num_arms() <= 0)
		return FALSE
	return TRUE

/mob/living/proc/InCritical()
	return (health <= crit_threshold && (stat == SOFT_CRIT || stat == UNCONSCIOUS))

/mob/living/proc/InFullCritical()
	return ((health <= HEALTH_THRESHOLD_FULLCRIT) && stat == UNCONSCIOUS)

//This proc is used for mobs which are affected by pressure to calculate the amount of pressure that actually
//affects them once clothing is factored in. ~Errorage
/mob/living/proc/calculate_affecting_pressure(pressure)
	return pressure

/mob/living/proc/getMaxHealth()
	return maxHealth

/mob/living/proc/setMaxHealth(newMaxHealth)
	maxHealth = newMaxHealth

// MOB PROCS //END

/mob/living/proc/mob_sleep()
	set name = "Sleep"
	set category = "IC"
	set hidden = 1
	if(IsSleeping())
		to_chat(src, span_warning("I am already sleeping!"))
		return
	else
		if(alert(src, "You sure you want to sleep for a while?", "Sleep", "Yes", "No") == "Yes")
			SetSleeping(400) //Short nap
	update_mobility()

/mob/proc/get_contents()
	return


/mob/living/proc/lay_down()
	set name = "Lay down"
	set category = "IC"
	set hidden = 1
	if(stat)
		return
	if(pulledby)
		to_chat(src, span_warning("I'm grabbed!"))
		return
	if(!resting)
		set_resting(TRUE, FALSE)

/mob/living/proc/stand_up()
	set name = "Stand up"
	set category = "IC"
	set hidden = 1
	if(stat)
		return
	if(pulledby)
		to_chat(src, span_warning("I'm grabbed!"))
		return
	if(resting)
		if(!IsKnockdown() && !IsStun() && !IsParalyzed())
			src.visible_message(span_notice("[src] stands up."))
			if(move_after(src, 20, target = src))
				set_resting(FALSE, FALSE)
				return TRUE
		else
			src.visible_message(span_warning("[src] tries to stand up."))
			return FALSE

/mob/living/proc/toggle_rest()
	set name = "Rest/Stand"
	set category = "IC"
	set hidden = 1
	if(stat)
		return
	if(pulledby)
		to_chat(src, span_warning("I'm grabbed!"))
		return
	if(resting)
		if(!IsKnockdown() && !IsStun() && !IsParalyzed())
			src.visible_message(span_info("[src] begins to stand up."))
			if(move_after(src, 20, target = src))
				set_resting(FALSE, FALSE)
		else
			src.visible_message(span_warning("[src] struggles to stand up."))
	else
		set_resting(TRUE, FALSE)

/mob/living/proc/set_resting(rest, silent = TRUE)
	resting = rest
	update_resting()
	if(rest == resting)
		if(resting)
			if(m_intent == MOVE_INTENT_RUN)
				toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)
	if(!silent)
		if(rest == resting)
			if(resting)
				playsound(src, 'sound/foley/toggledown.ogg', 100, FALSE)
				src.visible_message(span_info("[src] lays down."))
			else
				playsound(src, 'sound/foley/toggleup.ogg', 100, FALSE)
		else
			to_chat(src, span_warning("I fail to get up!"))
	update_cone_show()

/mob/living/proc/update_resting()
	update_rest_hud_icon()
	update_mobility()

//Recursive function to find everything a mob is holding. Really shitty proc tbh.
/mob/living/get_contents()
	var/list/ret = list()
	ret |= contents						//add our contents
	for(var/i in ret.Copy())			//iterate storage objects
		var/atom/A = i
		SEND_SIGNAL(A, COMSIG_TRY_STORAGE_RETURN_INVENTORY, ret)
	return ret

// Living mobs use can_inject() to make sure that the mob is not syringe-proof in general.
/mob/living/proc/can_inject()
	return TRUE

/mob/living/is_injectable(mob/user, allowmobs = TRUE)
	return (allowmobs && reagents && can_inject(user))

/mob/living/is_drawable(mob/user, allowmobs = TRUE)
	return (allowmobs && reagents && can_inject(user))

/mob/living/proc/updatehealth()
	if(status_flags & GODMODE)
		return
	health = maxHealth - getOxyLoss() - getToxLoss() - getFireLoss() - getBruteLoss() - getCloneLoss()
	health = min(health, maxHealth)
	if(HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS) && !HAS_TRAIT(src, TRAIT_BLOODLOSS_IMMUNE))
		// You dont have any blood and your not bloodloss immune? Dead.
		if(blood_volume <= 0)
			health = 0
	staminaloss = getStaminaLoss()
	update_stat()
	SEND_SIGNAL(src, COMSIG_LIVING_HEALTH_UPDATE)

/mob/living/proc/check_revive(mob/living/user)
	if(src == user)
		return FALSE
	if(stat < DEAD)
		to_chat(user, span_warning("Nothing happens."))
		return FALSE
	if(!mind)
		return FALSE
	if(!mind.active)
		to_chat(user, span_warning("They are unresponsive to my attempts. For now."))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_DNR))
		to_chat(user, span_danger("None of the divine have them. Their only chance is spent. Where did they go?"))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_NECRAS_VOW))
		to_chat(user, span_warning("This one has pledged themselves whole to Necra. They are Hers."))
		return FALSE

	var/obj/item/bodypart/head = get_bodypart("head")
	var/obj/item/organ/brain/brain = getorganslot(ORGAN_SLOT_BRAIN)
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)

	if(!head)
		to_chat(user, span_warning("[src] is missing their head!"))
		return FALSE
	if(!brain)
		to_chat(user, span_warning("[src] is missing their brain!"))
		return FALSE
	if(!heart)
		to_chat(user, span_warning("[src] is missing their heart!"))
		return FALSE

	return TRUE

//Proc used to resuscitate a mob, for full_heal see fully_heal()
/mob/living/proc/revive(full_heal = FALSE, admin_revive = FALSE)
	SEND_SIGNAL(src, COMSIG_LIVING_REVIVE, full_heal, admin_revive)
	if(full_heal)
		fully_heal(admin_revive = admin_revive, break_restraints = admin_revive)
	if(stat == DEAD && (admin_revive || can_be_revived())) //in some cases you can't revive (e.g. no brain)
		GLOB.dead_mob_list -= src  //If any more forms of revival are added, better to use a proc to do this - easier to search
		GLOB.alive_mob_list += src
		set_suicide(FALSE)
		stat = CONSCIOUS
		updatehealth() //then we check if the mob should wake up.
		update_mobility()
		update_sight()
		clear_alert("not_enough_oxy")
		reload_fullscreen()
		remove_client_colour(/datum/client_colour/monochrome)
		// Add message about struggling to recall death circumstances
		to_chat(src, "<span class='notice'><b>As you return to life, you struggle to recall the circumstances of your death...</b></span>")
		to_chat(src, "<span class='italic'>Your memories of your final moments are hazy and fragmented.</span>")
		. = TRUE
		if(mind)
			if(admin_revive)
				mind.remove_antag_datum(/datum/antagonist/zombie)
			for(var/S in mind.spell_list)
				var/obj/effect/proc_holder/spell/spell = S
				spell.updateButtonIcon()
		qdel(GetComponent(/datum/component/rot))

/mob/living/proc/remove_CC(should_update_mobility = TRUE)
	SetStun(0, FALSE)
	SetKnockdown(0, FALSE)
	SetImmobilized(0, FALSE)
	SetParalyzed(0, FALSE)
	SetSleeping(0, FALSE)
	setStaminaLoss(0)
	SetUnconscious(0, FALSE)
	if(should_update_mobility)
		update_mobility()

/mob/living/Crossed(atom/movable/AM)
	. = ..()
	for(var/i in get_equipped_items())
		var/obj/item/item = i
		SEND_SIGNAL(item, COMSIG_ITEM_WEARERCROSSED, AM, src)

/// proc used to completely heal a mob. admin_revive = TRUE is used in other procs, for example mob/living/carbon/fully_heal()
/mob/living/proc/fully_heal(admin_revive = FALSE, break_restraints = FALSE)
	restore_blood()
	setToxLoss(0, 0) //zero as second argument not automatically call updatehealth().
	setOxyLoss(0, 0)
	setCloneLoss(0, 0)
	remove_CC(FALSE)
	set_disgust(0)
	set_nutrition(NUTRITION_LEVEL_FED + 50)
	bodytemperature = BODYTEMP_NORMAL
	set_blindness(0)
	set_blurriness(0)
	set_dizziness(0)
	cure_nearsighted()
	cure_blind()
	cure_husk()
	cure_holdbreath()
	cure_paralysis()
	hallucination = 0
	heal_overall_damage(INFINITY, INFINITY, INFINITY, null, TRUE) //heal brute and burn dmg on both organic and robotic limbs, and update health right away.
	for(var/datum/wound/wound as anything in get_wounds())
		if(admin_revive)
			qdel(wound)
		else
			wound.heal_wound(wound.whp)
	extinguish_mob()
	confused = 0
	dizziness = 0
	drowsyness = 0
	stuttering = 0
	slurring = 0
	jitteriness = 0
	slowdown = 0
	update_mobility()
	stop_sound_channel(CHANNEL_HEARTBEAT)

//proc called by revive(), to check if we can actually ressuscitate the mob (we don't want to revive him and have him instantly die again)
/mob/living/proc/can_be_revived()
	. = TRUE
	if(health <= HEALTH_THRESHOLD_DEAD)
//		return ("no")
		return FALSE


/mob/living/carbon/human/can_be_revived()
	. = ..()
	var/obj/item/bodypart/head/H = get_bodypart(BODY_ZONE_HEAD)
	if(H)
		if(H.rotted || H.skeletonized || H.brainkill)
			return FALSE
	else
		return FALSE


/mob/living/proc/update_damage_overlays()
	return

/mob/living/proc/update_wallpress(turf/T, atom/newloc, direct)
	if(!wallpressed)
		reset_offsets("wall_press")
		return FALSE
	if(buckled || lying)
		wallpressed = FALSE
		reset_offsets("wall_press")
		return FALSE
	var/turf/newwall = get_step(newloc, wallpressed)
	if(!T.Adjacent(newwall))
		return reset_offsets("wall_press")
	if(isclosedturf(newwall) && fixedeye)
		var/turf/closed/C = newwall
		if(C.wallpress)
			return TRUE
	wallpressed = FALSE
	reset_offsets("wall_press")
	update_wallpress_slowdown()


/mob/living/Move(atom/newloc, direct, glide_size_override)

	var/old_direction = dir
	var/turf/T = loc

	if(m_intent == MOVE_INTENT_RUN)
		sprinted_tiles++
		sprint_dir = dir

	if(wallpressed)
		update_wallpress(T, newloc, direct)

	if(lying)
		if(direct & EAST)
			lying = 90
		if(direct & WEST)
			lying = 270
		update_transform()
		lying_prev = lying
	if (buckled && buckled.loc != newloc) //not updating position
		if (!buckled.anchored)
			return buckled.Move(newloc, direct, glide_size)
		else
			return FALSE

	if(pulling)
		update_pull_movespeed()

	. = ..()

	update_sneak_invis()

	if(pulledby && moving_diagonally != FIRST_DIAG_STEP && get_dist(src, pulledby) > 1 && (pulledby != moving_from_pull))//separated from our puller and not in the middle of a diagonal move.
		pulledby.stop_pulling()
	else
		if(isliving(pulledby))
			var/mob/living/L = pulledby
			L.set_pull_offsets(src, pulledby.grab_state)

//	if(active_storage && !(CanReach(active_storage.parent,view_only = TRUE)))
	if(active_storage)
		active_storage.close(src)

	if(!(mobility_flags & MOBILITY_STAND) && !buckled && prob(getBruteLoss()*200/maxHealth))
		makeTrail(newloc, T, old_direction)
	//Hearthstone port - track creation hook.
	if(. && isturf(newloc))
		check_track_creation(newloc)
	//Hearthstone end.


/mob/living/setDir(newdir)
	var/olddir = dir
	..()
	if(olddir != dir)
		stop_looking()
		if(client)
			update_vision_cone()

/mob/living/proc/makeTrail(turf/target_turf, turf/start, direction)
	var/blood_exists = FALSE

	for(var/obj/effect/decal/cleanable/trail_holder/C in start) //checks for blood splatter already on the floor
		blood_exists = TRUE
	if(isturf(start))
		var/trail_type = getTrail()
		if(trail_type)
			var/brute_ratio = round(getBruteLoss() / maxHealth, 0.1)
			if(blood_volume && blood_volume > max(BLOOD_VOLUME_NORMAL*(1 - brute_ratio * 0.25), 0))//don't leave trail if blood volume below a threshold
				blood_volume = max(blood_volume - max(1, brute_ratio * 2), 0) 					//that depends on our brute damage.
				var/newdir = get_dir(target_turf, start)
				if(newdir != direction)
					newdir = newdir | direction
					if(newdir == 3) //N + S
						newdir = NORTH
					else if(newdir == 12) //E + W
						newdir = EAST
				if((newdir in GLOB.cardinals) && (prob(50)))
					newdir = turn(get_dir(target_turf, start), 180)
				if(!blood_exists)
					new /obj/effect/decal/cleanable/trail_holder(start)

				for(var/obj/effect/decal/cleanable/trail_holder/TH in start)
					if((!(newdir in TH.existing_dirs) || trail_type == "trails_1" || trail_type == "trails_2") && TH.existing_dirs.len <= 16) //maximum amount of overlays is 16 (all light & heavy directions filled)
						TH.existing_dirs += newdir
						TH.add_overlay(image('icons/effects/blood.dmi', trail_type, dir = newdir))
						TH.transfer_mob_blood_dna(src)

/mob/living/carbon/human/makeTrail(turf/T)
	if((NOBLOOD in dna.species.species_traits) || !bleed_rate || bleedsuppress)
		return
	..()

/mob/living/proc/getTrail()
	if(getBruteLoss() < 300)
		return pick("ltrails_1", "ltrails_2")
	else
		return pick("trails_1", "trails_2")

/mob/living/can_resist()
	return !((next_move > world.time) || incapacitated(ignore_restraints = TRUE, ignore_stasis = TRUE))

/mob/living/verb/resist()
	set name = "Resist"
	set category = "IC"
	set hidden = 1
	if(!can_resist() || surrendering)
		return

	changeNext_move(CLICK_CD_RESIST)

	if(atkswinging)
		stop_attack(FALSE)

	SEND_SIGNAL(src, COMSIG_LIVING_RESIST, src)
	//resisting grabs (as if it helps anyone...)
	if(pulledby)
		var/mob/living/P
		if(isliving(pulledby))
			P = pulledby
		if(!restrained(ignore_grab = 1))
			log_combat(src, pulledby, "resisted grab")
			resist_grab()
			return
		else if(P.compliance) // we ARE handcuffed apart from the grab, but grabber has Compliance Mode on
			log_combat(src, pulledby, "resisted grab (is restrained, compliance mode bypass)") // if you try baiting prisoners with this, I'll know.
			resist_grab() // resisting out of his grab (100% success) takes priority here
			return

	//unbuckling yourself
	if(buckled && last_special <= world.time)
		resist_buckle()

	//Breaking out of a container (Locker, sleeper, cryo...)
	else if(isobj(loc))
		var/obj/C = loc
		C.container_resist(src)

	else if(mobility_flags & MOBILITY_MOVE)
		if(on_fire)
			resist_fire() //stop, drop, and roll
		else if(last_special <= world.time)
			resist_restraints() //trying to remove cuffs.
			var/datum/component/riding/human/riding_datum = GetComponent(/datum/component/riding/human)
			if(riding_datum)
				for(var/mob/M in buckled_mobs)
					riding_datum.force_dismount(M)

/mob/living/proc/submit(instant = FALSE)
	set name = "Yield"
	set category = "IC"
	set hidden = 1
	if(surrendering || stat)
		return
	if(!instant)
		if(alert(src, "Do you yield?", "SURRENDER", "Yes", "No") == "No")
			return
	log_combat(src, null, "surrendered")
	surrendering = 1
	record_round_statistic(STATS_YIELDS)
	toggle_cmode()
	changeNext_move(CLICK_CD_EXHAUSTED)
	var/obj/effect/temp_visual/surrender/flaggy = new(src)
	vis_contents += flaggy
	Stun(300)
	Knockdown(300)
	apply_status_effect(/datum/status_effect/debuff/breedable)
	apply_status_effect(/datum/status_effect/debuff/submissive)
	src.visible_message(span_notice("[src] yields!"))
	playsound(src, 'sound/misc/surrender.ogg', 100, FALSE, -1, ignore_walls=TRUE)
	update_vision_cone()
	addtimer(CALLBACK(src, PROC_REF(end_submit)), 600)

/mob/living/proc/end_submit()
	surrendering = 0
	update_mobility()

/mob/living/proc/toggle_compliance()
	set name = "Toggle Compliance"
	set category = "IC"
	set hidden = 1

	var/notifyme = TRUE
	if(client && client.prefs)
		notifyme = client.prefs.compliance_notifs

	if(has_status_effect(/datum/status_effect/compliance))
		src.compliance = 0
		remove_status_effect(/datum/status_effect/compliance)
		if(notifyme)
			to_chat(src, span_info("I will struggle against grabs as usual."))
	else
		src.compliance = 1
		apply_status_effect(/datum/status_effect/compliance)
		if(notifyme)
			to_chat(src, span_info("I will allow all grabs and resistance attempts by others."))


/mob/proc/stop_attack(message = FALSE)
	if(atkswinging)
		atkswinging = FALSE
		if(message)
			to_chat(src, span_warning("Attack stopped."))
	if(client)
		client.charging = 0
		client.chargedprog = 0
		client.tcompare = null //so we don't shoot the attack off
		client.mouse_pointer_icon = 'icons/effects/mousemice/human.dmi'
	if(used_intent)
		used_intent.on_mouse_up()
	if(mmb_intent)
		mmb_intent.on_mouse_up()
	update_warning()

/mob/living/stop_attack(message = FALSE)
	..()
	update_charging_movespeed()

/mob/proc/resist_grab(moving_resist)
	return TRUE //returning 0 means we successfully broke free

/mob/living/resist_grab(moving_resist)
	. = TRUE

	var/wrestling_diff = 0
	var/resist_chance = 55
	var/mob/living/L = pulledby
	var/combat_modifier = 1
	var/agg_grab = FALSE

	if(mind)
		wrestling_diff += (get_skill_level(/datum/skill/combat/wrestling)) //NPCs don't use this
	if(L.mind)
		wrestling_diff -= (L.get_skill_level(/datum/skill/combat/wrestling))
	if(L.grab_state > GRAB_PASSIVE)
		agg_grab = TRUE

	if(restrained())
		combat_modifier -= 0.25
	if(!(L.mobility_flags & MOBILITY_STAND) && mobility_flags & MOBILITY_STAND)
		combat_modifier += 0.2
	if(cmode && !L.cmode)
		combat_modifier += 0.3
	else if(!cmode && L.cmode)
		combat_modifier -= 0.3
	if(agg_grab)
		if(!HAS_TRAIT(src, TRAIT_GARROTED))
			combat_modifier -= 0.3
		else
			if(!src.mind)
				combat_modifier -= 0.3
			if(HAS_TRAIT(L, TRAIT_BLACKBAGGER))
				combat_modifier -= 0.3
				if(HAS_TRAIT(src, TRAIT_BAGGED))
					combat_modifier -= 0.3
	for(var/obj/item/grabbing/G in grabbedby)
		if(G.chokehold == TRUE)
			combat_modifier -= 0.15

	resist_chance += max((wrestling_diff * 10), -20)
	if(HAS_TRAIT(src, TRAIT_GARROTED))
		resist_chance += (STACON - L.STASPD) * 5
	else
		resist_chance += (STACON - (agg_grab ? L.STASTR : L.STAWIL)) * 5
	resist_chance *= combat_modifier
	resist_chance = clamp(resist_chance, 5, 95)

	if(!L.compliance || !compliance)
		if(badluck(7))
			badluckmessage(src)
			return

	if(L.compliance)
		resist_chance = 100

	if(moving_resist && client) //we resisted by trying to move
		client.move_delay = world.time + 20
	stamina_add(rand(5,15))

	if(!prob(resist_chance))
		var/rchance = ""
		if(client?.prefs.showrolls)
			rchance = " ([resist_chance]%)"
		if(HAS_TRAIT(src, TRAIT_GARROTED))
			var/obj/item/inqarticles/garrote/gcord = L.get_active_held_item()
			if(!gcord)
				gcord = L.get_inactive_held_item()
			to_chat(pulledby, span_warning("[src] struggles against the [gcord]!"))
			if(!src.mind) // NPCs do less damage to the garrote
				gcord.take_damage(10)
			else
				gcord.take_damage(25)
		if(!HAS_TRAIT(src, TRAIT_GARROTED))
			visible_message(span_warning("[src] struggles to break free from [L]'s grip!"), \
						span_warning("I struggle against [L]'s grip![rchance]"), null, null, L)
		else
			var/obj/item/inqarticles/garrote/gcord = L.get_active_held_item()
			if(!gcord)
				gcord = L.get_inactive_held_item()
			visible_message(span_warning("[src] struggles to break free from [L]'s [gcord]!"), \
						span_warning("I struggle against [L]'s [gcord]![rchance]"), null, null, L)
		playsound(src.loc, 'sound/combat/grabstruggle.ogg', 50, TRUE, -1)
		if(!HAS_TRAIT(src, TRAIT_GARROTED))
			to_chat(pulledby, span_warning("[src] struggles against my grip!"))
		return FALSE
	if(!HAS_TRAIT(src, TRAIT_GARROTED))
		visible_message(span_warning("[src] breaks free of [L]'s grip!"), \
						span_notice("I break free of [L]'s grip!"), null, null, L)
		to_chat(L, span_danger("[src] breaks free of my grip!"))
	else
		var/obj/item/inqarticles/garrote/gcord = L.get_active_held_item()
		if(!gcord)
			gcord = L.get_inactive_held_item()
		visible_message(span_warning("[src] breaks free of [L]'s [gcord]!"), \
						span_notice("I break free of [L]'s [gcord]!"), null, null, L)
		to_chat(L, span_danger("[src] breaks free from my [gcord]!"))
	if(HAS_TRAIT(src, TRAIT_GARROTED))
		var/obj/item/inqarticles/garrote/gcord = L.get_active_held_item()
		if(!gcord)
			gcord = L.get_inactive_held_item()
		gcord.take_damage(gcord.max_integrity)
		gcord.wipeslate(src)
	log_combat(L, src, "broke grab")
	L.changeNext_move(agg_grab ? CLICK_CD_GRABBING : CLICK_CD_GRABBING + 1 SECONDS)
	playsound(src.loc, 'sound/combat/grabbreak.ogg', 50, TRUE, -1)
	L.stop_pulling()
	return TRUE

/mob/living/proc/resist_buckle()
	buckled.user_unbuckle_mob(src,src)
	return TRUE

/mob/living/proc/resist_fire()
	return

/mob/living/proc/resist_restraints()
	return

/mob/living/proc/get_visible_name()
	return name

/mob/living/float(on)
	if(throwing)
		return
	var/fixed = 0
	if(anchored || (buckled && buckled.anchored))
		fixed = 1
	if(on && !(movement_type & FLOATING) && !fixed)
		animate(src, pixel_y = pixel_y + 2, time = 10, loop = -1)
		sleep(10)
		animate(src, pixel_y = pixel_y - 2, time = 10, loop = -1)
		setMovetype(movement_type | FLOATING)
	else if(((!on || fixed) && (movement_type & FLOATING)))
		animate(src, pixel_y = get_standard_pixel_y_offset(lying), time = 10)
		setMovetype(movement_type & ~FLOATING)

// The src mob is trying to strip an item from someone
// Override if a certain type of mob should be behave differently when stripping items (can't, for example)
/mob/living/stripPanelUnequip(obj/item/what, mob/who, where)
	if(!what.canStrip(who))
		to_chat(src, span_warning("I can't remove \the [what.name], it appears to be stuck!"))
		return

	if(!has_active_hand()) //can't attack without a hand.
		to_chat(src, span_warning("I lack working hands."))
		return

	if(!has_hand_for_held_index(active_hand_index)) //can't attack without a hand.
		to_chat(src, span_warning("I can't move this hand."))
		return

	if(check_arm_grabbed(active_hand_index))
		to_chat(src, span_warning("Someone is grabbing my arm!"))
		return

	if(istype(src, /mob/living/carbon/spirit))
		to_chat(src, span_warning("Your hands pass right through \the [what]!"))
		return

	var/surrender_mod = 1

	if(isliving(who))
		var/mob/living/L = who
		if(L.cmode && L.mobility_flags & MOBILITY_STAND && !L.restrained())
			to_chat(src, span_warning("I can't take \the [what] off, they are too tense!"))
			return
		if(L.compliance || L.surrendering)
			surrender_mod = 0.5

	if(!who.Adjacent(src))
		return

	if(!enhanced_strip)
		who.visible_message(span_warning("[src] tries to remove [who]'s [what.name]."), \
						span_danger("[src] tries to remove my [what.name]."), null, null, src)

	to_chat(src, span_danger("I try to remove [who]'s [what.name]..."))
	what.add_fingerprint(src)
	var/strip_delayed = what.strip_delay
	if(enhanced_strip)
		strip_delayed = 0.1 SECONDS
	if(do_after(src, strip_delayed * surrender_mod, who))
		if(what && (Adjacent(who) || (enhanced_strip && (get_dist(src, who) <= 3))))
			enhanced_strip = FALSE
			if(islist(where))
				var/list/L = where
				if(what == who.get_item_for_held_index(L[2]))
					if(what.doStrip(src, who))
						log_combat(src, who, "stripped [what] off")
			if(what == who.get_item_by_slot(where))
				if(what.doStrip(src, who))
					log_combat(src, who, "stripped [what] off")

	if(Adjacent(who)) //update inventory window
		who.show_inv(src)
	else
		src << browse(null,"window=mob[REF(who)]")

// The src mob is trying to place an item on someone
// Override if a certain mob should be behave differently when placing items (can't, for example)
/mob/living/stripPanelEquip(obj/item/what, mob/who, where)
	what = src.get_active_held_item()
	if(what && (HAS_TRAIT(what, TRAIT_NODROP)))
		to_chat(src, span_warning("I can't put \the [what.name] on [who], it's stuck to my hand!"))
		return
	if(what)
		var/list/where_list
		var/final_where

		if(islist(where))
			where_list = where
			final_where = where[1]
		else
			final_where = where

		if(!what.mob_can_equip(who, src, final_where, TRUE, TRUE))
			to_chat(src, span_warning("\The [what.name] doesn't fit in that place!"))
			return

		var/surrender_mod = 1

		if(isliving(who))
			var/mob/living/L = who
			if(L.cmode && L.mobility_flags & MOBILITY_STAND)
				to_chat(src, span_warning("I can't put \the [what] on them, they are too tense!"))
				return
			if(L.compliance || L.surrendering)
				surrender_mod = 0.5

		who.visible_message(span_notice("[src] tries to put [what] on [who]."), \
						span_notice("[src] tries to put [what] on you."), null, null, src)
		to_chat(src, span_notice("I try to put [what] on [who]..."))
		if(do_mob(src, who, what.equip_delay_other * surrender_mod))
			if(what && Adjacent(who) && what.mob_can_equip(who, src, final_where, TRUE, TRUE))
				if(temporarilyRemoveItemFromInventory(what))
					if(where_list)
						if(!who.put_in_hand(what, where_list[2]))
							what.forceMove(get_turf(who))
					else
						who.equip_to_slot(what, where, TRUE)

		if(Adjacent(who)) //update inventory window
			who.show_inv(src)
		else
			src << browse(null,"window=mob[REF(who)]")

/mob/living/proc/do_jitter_animation(jitteriness)
	var/amplitude = min(4, (jitteriness/100) + 1)
	var/pixel_x_diff = rand(-amplitude, amplitude)
	var/pixel_y_diff = rand(-amplitude/3, amplitude/3)
	var/final_pixel_x = get_standard_pixel_x_offset(lying)
	var/final_pixel_y = get_standard_pixel_y_offset(lying)
	animate(src, pixel_x = pixel_x + pixel_x_diff, pixel_y = pixel_y + pixel_y_diff , time = 2, loop = 6)
	animate(pixel_x = final_pixel_x , pixel_y = final_pixel_y , time = 2)
	setMovetype(movement_type & ~FLOATING) // If we were without gravity, the bouncing animation got stopped, so we make sure to restart it in next life().

/mob/living/proc/get_temperature()
//ATMO/TURF/TEMPERATURE
	var/turf/cur_turf = get_turf(src)
	var/loc_temp = cur_turf.temperature
	if(isobj(loc))
		var/obj/oloc = loc
		var/obj_temp = oloc.return_temperature()
		if(obj_temp != null)
			loc_temp = obj_temp
	return loc_temp

/mob/living/proc/get_standard_pixel_x_offset(lying = 0)
	var/_x = initial(pixel_x)
	for(var/o in mob_offsets)
		if(mob_offsets[o])
			if(mob_offsets[o]["x"])
				_x = _x + mob_offsets[o]["x"]
	return _x

/mob/living/proc/get_standard_pixel_y_offset(lying = 0)
	var/_y = initial(pixel_y)
	for(var/o in mob_offsets)
		if(mob_offsets[o])
			if(mob_offsets[o]["y"])
				_y = _y + mob_offsets[o]["y"]
	return _y

/mob/living/cancel_camera()
	..()
	cameraFollow = null

/mob/living/proc/can_track(mob/living/user)
	//basic fast checks go first. When overriding this proc, I recommend calling ..() at the end.
	if(SEND_SIGNAL(src, COMSIG_LIVING_CAN_TRACK, args) & COMPONENT_CANT_TRACK)
		return FALSE
	var/turf/T = get_turf(src)
	if(!T)
		return FALSE
	if(is_centcom_level(T.z)) //dont detect mobs on centcom
		return FALSE
	if(is_away_level(T.z))
		return FALSE
	if(user != null && src == user)
		return FALSE
	if(invisibility || alpha == 0)//cloaked
		return FALSE
	return TRUE

//used in datum/reagents/reaction() proc
/mob/living/proc/get_permeability_protection(list/target_zones)
	return 0

/mob/living/proc/harvest(mob/living/user) //used for extra objects etc. in butchering
	return

/mob/living/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE)
	if(incapacitated())
		to_chat(src, span_warning("I can't do that right now!"))
		return FALSE
	if(be_close && !in_range(M, src))
		to_chat(src, span_warning("I am too far away!"))
		return FALSE
	if(!no_dexterity)
		to_chat(src, span_warning("I don't have the dexterity to do this!"))
		return FALSE
	return TRUE

/mob/living/proc/can_use_guns(obj/item/G)//actually used for more than guns!
	if(G.trigger_guard == TRIGGER_GUARD_NONE)
		to_chat(src, span_warning("I are unable to fire this!"))
		return FALSE
	if(G.trigger_guard != TRIGGER_GUARD_ALLOW_ALL && !IsAdvancedToolUser())
		to_chat(src, span_warning("I try to fire [G], but can't use the trigger!"))
		return FALSE
	return TRUE

/mob/living/proc/owns_soul()
	if(mind)
		return mind.soulOwner == mind
	return TRUE

/mob/living/proc/return_soul()
	hellbound = 0
	if(mind)
		mind.soulOwner = mind

/mob/living/proc/check_weakness(obj/item/weapon, mob/living/attacker)
	return 1 //This is not a boolean, it's the multiplier for the damage the weapon does.

/mob/living/throw_at(atom/target, range, speed, mob/thrower, spin=1, diagonals_first = 0, datum/callback/callback, force)
	stop_pulling()
	. = ..()

// Called when we are hit by a bolt of polymorph and changed
// Generally the mob we are currently in is about to be deleted
/mob/living/proc/wabbajack_act(mob/living/new_mob)
	new_mob.name = real_name
	new_mob.real_name = real_name

	if(mind)
		mind.transfer_to(new_mob)
	else
		new_mob.key = key

/mob/living/anti_magic_check(magic = TRUE, holy = FALSE, tinfoil = FALSE, chargecost = 1, self = FALSE)
	. = ..()
	if(.)
		return
	if((magic && HAS_TRAIT(src, TRAIT_ANTIMAGIC)) || (holy && HAS_TRAIT(src, TRAIT_HOLY)))
		return src

/mob/living/proc/fakefireextinguish()
	return

/mob/living/proc/fakefire()
	return

//Mobs on Fire
/mob/living/proc/ignite_mob(silent)
	if("lava" in weather_immunities)//immune to lava = immune to burning
		return FALSE
	if(fire_stacks <= 0)
		return FALSE

	var/datum/status_effect/fire_handler/fire_stacks/fire_status = has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
	var/datum/status_effect/fire_handler/fire_stacks/sunder/sunder_status = has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder)
	var/datum/status_effect/fire_handler/fire_stacks/divine/divine_status = has_status_effect(/datum/status_effect/fire_handler/fire_stacks/divine)
	var/datum/status_effect/fire_handler/fire_stacks/sunder/blessed/blessed_sunder = has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed)

	if(HAS_TRAIT(src, TRAIT_NOFIRE) && prob(90)) // Nofire is described as nonflammable, not immune. 90% chance of avoiding ignite
		return

	if(!fire_status?.on_fire)
		fire_status?.ignite(silent)

	if(!divine_status?.on_fire)
		divine_status?.ignite(silent)

	if(!sunder_status?.on_fire)
		sunder_status?.ignite(silent)

	if(!blessed_sunder?.on_fire)
		blessed_sunder?.ignite(silent)

/mob/living/proc/SoakMob(locations)
	if(locations & CHEST)
		extinguish_mob()

/mob/living/proc/extinguish_mob()
	if(HAS_TRAIT(src, TRAIT_NO_EXTINGUISH)) //The everlasting flames will not be extinguished
		return

	var/datum/status_effect/fire_handler/fire_stacks/fire_status = has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
	if(fire_status?.on_fire)
		remove_status_effect(/datum/status_effect/fire_handler/fire_stacks)
	var/datum/status_effect/fire_handler/fire_stacks/sunder/sunder_status = has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder)
	if(sunder_status?.on_fire)
		remove_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder)
	var/datum/status_effect/fire_handler/fire_stacks/divine/divine_status = has_status_effect(/datum/status_effect/fire_handler/fire_stacks/divine)
	if(divine_status?.on_fire)
		remove_status_effect(/datum/status_effect/fire_handler/fire_stacks/divine)
	var/datum/status_effect/fire_handler/fire_stacks/sunder/blessed/blessed_sunder = has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
	if(blessed_sunder?.on_fire)
		remove_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed)

/**
 * Handles effects happening when mob is on normal fire
 *
 * Vars:
 * * seconds_per_tick
 * * times_fired
 * * fire_handler: Current fire status effect that called the proc
 */

/mob/living/proc/on_fire_stack(seconds_per_tick, datum/status_effect/fire_handler/fire_stacks/fire_handler)
	adjust_bodytemperature(((fire_handler.stacks * 12)) * 0.5 * seconds_per_tick)

/**
 * Adjust the amount of fire stacks on a mob
 *
 * This modifies the fire stacks on a mob.
 *
 * Vars:
 * * stacks: int The amount to modify the fire stacks
 * * fire_type: type Type of fire status effect that we apply, should be subtype of /datum/status_effect/fire_handler/fire_stacks
 */
/mob/living/proc/adjust_fire_stacks(stacks, fire_type = /datum/status_effect/fire_handler/fire_stacks)
	if(stacks < 0)
		if(HAS_TRAIT(src, TRAIT_NO_EXTINGUISH)) //You can't reduce fire stacks of the everlasting flames
			return
		stacks = max(-fire_stacks, stacks)
	apply_status_effect(fire_type, stacks)

/**
 * Set the fire stacks on a mob
 *
 * This sets the fire stacks on a mob, stacks are clamped between -20 and 20.
 * If the fire stacks are reduced to 0 then we will extinguish the mob.
 *
 * Vars:
 * * stacks: int The amount to set fire_stacks to
 * * fire_type: type Type of fire status effect that we apply, should be subtype of /datum/status_effect/fire_handler/fire_stacks
 * * remove_wet_stacks: bool If we remove all wet stacks upon doing this
 */

/mob/living/proc/set_fire_stacks(stacks, fire_type = /datum/status_effect/fire_handler/fire_stacks)
	if(stacks < 0) //Shouldn't happen, ever
		CRASH("set_fire_stacks received negative [stacks] fire stacks")

	if(stacks == 0)
		remove_status_effect(fire_type)
		return

	apply_status_effect(fire_type, stacks, TRUE)

//Share fire evenly between the two mobs
//Called in MobBump() and Crossed()
/mob/living/proc/spreadFire(mob/living/spread_to)
	if(!istype(spread_to))
		return

	if(HAS_TRAIT(spread_to, TRAIT_NOFIRE) || HAS_TRAIT(src, TRAIT_NOFIRE))
		return

	var/datum/status_effect/fire_handler/fire_stacks/fire_status = has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
	var/datum/status_effect/fire_handler/fire_stacks/their_fire_status = spread_to.has_status_effect(/datum/status_effect/fire_handler/fire_stacks)
	if(fire_status && fire_status.on_fire)
		if(their_fire_status && their_fire_status.on_fire)
			var/firesplit = (fire_stacks + spread_to.fire_stacks) / 2
			var/fire_type = (spread_to.fire_stacks > fire_stacks) ? their_fire_status.type : fire_status.type
			set_fire_stacks(firesplit, fire_type)
			spread_to.set_fire_stacks(firesplit, fire_type)
			return

		adjust_fire_stacks(-fire_stacks / 2, fire_status.type)
		spread_to.adjust_fire_stacks(fire_stacks, fire_status.type)
		if(spread_to.ignite_mob())
			log_message("bumped into [key_name(spread_to)] and set them on fire.", LOG_ATTACK)
		return

	if(!their_fire_status || !their_fire_status.on_fire)
		return

	spread_to.adjust_fire_stacks(-spread_to.fire_stacks / 2, their_fire_status.type)
	adjust_fire_stacks(spread_to.fire_stacks, their_fire_status.type)
	ignite_mob()

//Mobs on Fire end

// used by secbot and monkeys Crossed
/mob/living/proc/knockOver(mob/living/carbon/C)
	if(C.key) //save us from monkey hordes
		C.visible_message("<span class='warning'>[pick( \
						"[C] dives out of [src]'s way!", \
						"[C] stumbles over [src]!", \
						"[C] jumps out of [src]'s path!", \
						"[C] trips over [src] and falls!", \
						"[C] topples over [src]!", \
						"[C] leaps out of [src]'s way!")]</span>")
	C.Paralyze(40)

/mob/living/ConveyorMove()
	if((movement_type & FLYING) && !stat)
		return
	..()

/mob/living/can_be_pulled()
	return ..() && !(buckled && buckled.buckle_prevents_pull)

//Updates canmove, lying and icons. Could perhaps do with a rename but I can't think of anything to describe it.
//Robots, animals and brains have their own version so don't worry about them
/mob/living/proc/update_mobility()
	var/stat_softcrit = stat == SOFT_CRIT
	var/stat_conscious = (stat == CONSCIOUS) || stat_softcrit
	var/conscious = !IsUnconscious() && stat_conscious && !HAS_TRAIT(src, TRAIT_DEATHCOMA)
	var/chokehold = pulledby && pulledby.grab_state >= GRAB_NECK
	var/restrained = restrained()
	var/has_legs = get_num_legs()
	var/has_arms = get_num_arms()
	var/paralyzed = IsParalyzed()
	var/stun = IsStun()
	var/knockdown = IsKnockdown()
	var/ignore_legs = get_leg_ignore()
	var/canmove = !IsImmobilized() && !stun && conscious && !paralyzed && !buckled && (!stat_softcrit || !pulledby) && !chokehold && !IsFrozen() && (has_arms || ignore_legs || has_legs)
	if(canmove)
		mobility_flags |= MOBILITY_MOVE
	else
		mobility_flags &= ~MOBILITY_MOVE

	var/stickstand = FALSE
	for(var/obj/item/I in src.held_items)
		if(I.walking_stick)
			stickstand = TRUE

	var/canstand_involuntary = conscious && !stat_softcrit && !knockdown && !chokehold && !paralyzed && ( ignore_legs || ((has_legs >= 2) || (has_legs == 1 && stickstand)) ) && !(buckled && buckled.buckle_lying)

	if(canstand_involuntary)
		mobility_flags |= MOBILITY_CANSTAND
	else
		mobility_flags &= ~MOBILITY_CANSTAND

	var/canstand = canstand_involuntary && !resting

	var/should_be_lying = !canstand
	if(buckled)
		if(buckled.buckle_lying != -1)
			should_be_lying = buckled.buckle_lying

	if(should_be_lying)
		// Track when we transition from standing to prone for dismemberment grace period
		if(mobility_flags & MOBILITY_STAND)
			if(mob_timers)
				mob_timers["last_standing"] = world.time
		resting = TRUE
		mobility_flags &= ~MOBILITY_STAND
		if(buckled)
			if(buckled.buckle_lying != -1)
				lying = buckled.buckle_lying
		if(!lying) //force them on the ground
			lying = 90
	else
		mobility_flags |= MOBILITY_STAND
		lying = 0

/*
	if(should_be_lying || restrained || incapacitated())
		mobility_flags &= ~(MOBILITY_UI|MOBILITY_PULL)
	else
		mobility_flags |= MOBILITY_UI|MOBILITY_PULL
*/
	if(restrained || incapacitated())
		mobility_flags &= ~MOBILITY_UI
	else
		mobility_flags |= MOBILITY_UI

	if(incapacitated())
		mobility_flags &= ~MOBILITY_PULL
	else
		mobility_flags |= MOBILITY_PULL

	var/canitem = !paralyzed && !stun && conscious && !chokehold && !restrained && has_arms && !surrendering
	if(canitem)
		mobility_flags |= (MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE)
	else
		mobility_flags &= ~(MOBILITY_USE | MOBILITY_PICKUP | MOBILITY_STORAGE)
	if(!(mobility_flags & MOBILITY_USE))
		drop_all_held_items()
	if(!(mobility_flags & MOBILITY_PULL))
		if(pulling)
			stop_pulling()
	if(!(mobility_flags & MOBILITY_UI))
		unset_machine()
	density = !lying
	if(lying)
		if(!lying_prev)
			fall(!canstand_involuntary)
		layer = LYING_MOB_LAYER //so mob lying always appear behind standing mobs
		if (is_shifted)
			layer = 3.99 + pixelshift_layer //So mobs can pixelshift layers while lying down
	else
		if(layer == LYING_MOB_LAYER)
			layer = initial(layer)
	update_cone_show()
	update_transform()

	// Movespeed mods based on arms/legs quantity
	if(!get_leg_ignore())
		var/limbless_slowdown = 0
		// These checks for <2 should be swapped out for something else if we ever end up with a species with more than 2
		if(has_legs < 2)
			limbless_slowdown += 6 - (has_legs * 3)
			if(!has_legs && has_arms < 2)
				limbless_slowdown += 6 - (has_arms * 3)
		if(pegleg)
			limbless_slowdown += pegleg
		if(limbless_slowdown)
			add_movespeed_modifier(MOVESPEED_ID_LIVING_LIMBLESS, update=TRUE, priority=100, override=TRUE, multiplicative_slowdown=limbless_slowdown, movetypes=GROUND)
		else
			remove_movespeed_modifier(MOVESPEED_ID_LIVING_LIMBLESS, update=TRUE)

/mob/living/proc/fall(forced)
	if(!(mobility_flags & MOBILITY_USE))
		drop_all_held_items()

/mob/living/proc/AddAbility(obj/effect/proc_holder/A)
	abilities.Add(A)
	A.on_gain(src)
	if(A.has_action)
		A.action.Grant(src)

/mob/living/proc/RemoveAbility(obj/effect/proc_holder/A)
	abilities.Remove(A)
	A.on_lose(src)
	if(A.action)
		A.action.Remove(src)

/mob/living/proc/add_abilities_to_panel()
	for(var/obj/effect/proc_holder/A in abilities)
		statpanel("[A.panel]",A.get_panel_text(),A)

/mob/living/lingcheck()
	return LINGHIVE_NONE

/mob/living/forceMove(atom/destination)
//	stop_pulling()
//	if(buckled)
//		buckled.unbuckle_mob(src, force = TRUE)
//	if(has_buckled_mobs())
//		unbuckle_all_mobs(force = TRUE)
	. = ..()
	if(.)
		if(client)
			reset_perspective()
		update_mobility() //if the mob was asleep inside a container and then got forceMoved out we need to make them fall.

/mob/living/proc/update_z(new_z) // 1+ to register, null to unregister
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.clients_by_zlevel[registered_z] -= src
		if (client)
			if (new_z)
				SSmobs.clients_by_zlevel[new_z] += src
				for (var/I in length(SSidlenpcpool.idle_mobs_by_zlevel[new_z]) to 1 step -1) //Backwards loop because we're removing (guarantees optimal rather than worst-case performance), it's fine to use .len here but doesn't compile on 511
					var/mob/living/simple_animal/SA = SSidlenpcpool.idle_mobs_by_zlevel[new_z][I]
					if (SA)
						SA.toggle_ai(AI_ON) // Guarantees responsiveness for when appearing right next to mobs
					else
						SSidlenpcpool.idle_mobs_by_zlevel[new_z] -= SA

			registered_z = new_z
		else
			registered_z = null

/mob/living/onTransitZ(old_z,new_z)
	..()
	update_z(new_z)

/mob/living/MouseDrop(mob/over)
	. = ..()
	var/mob/living/user = usr
	if(!istype(over) || !istype(user))
		return
	if(!over.Adjacent(src) || (user != src) || !canUseTopic(over))
		return
	if(can_be_held)
		mob_try_pickup(over)

/mob/living/proc/mob_pickup(mob/living/L)
	return

/mob/living/proc/mob_try_pickup(mob/living/user)
	if(!ishuman(user))
		return
	if(user.get_active_held_item())
		to_chat(user, span_warning("My hands are full!"))
		return FALSE
	if(buckled)
		to_chat(user, span_warning("[src] is buckled to something!"))
		return FALSE
	user.visible_message(span_warning("[user] starts trying to scoop up [src]!"), \
					span_danger("I start trying to scoop up [src]..."), null, null, src)
	to_chat(src, span_danger("[user] starts trying to scoop you up!"))
	if(!do_after(user, 20, target = src))
		return FALSE
	mob_pickup(user)
	return TRUE

/mob/living/reset_perspective(atom/A)
	if(..())
		update_sight()
		if(client.eye && client.eye != src)
			var/atom/AT = client.eye
			AT.get_remote_view_fullscreens(src)
		else
			clear_fullscreen("remote_view", 0)

/mob/living/update_mouse_pointer()
	if(!client)
		return
	if(!client.charging && !atkswinging)
		if(examine_cursor_icon && client.keys_held["Shift"]) //mouse shit is hardcoded, make this non hard-coded once we make mouse modifiers bindable
			client.mouse_pointer_icon = examine_cursor_icon
	if(ranged_ability && ranged_ability.ranged_mousepointer)
		client.mouse_pointer_icon = ranged_ability.ranged_mousepointer

/mob/living/vv_edit_var(var_name, var_value)
	switch(var_name)
		if ("maxHealth")
			if (!isnum(var_value) || var_value <= 0)
				return FALSE
		if("stat")
			if((stat == DEAD) && (var_value < DEAD))//Bringing the dead back to life
				GLOB.dead_mob_list -= src
				GLOB.alive_mob_list += src
			if((stat < DEAD) && (var_value == DEAD))//Kill he
				GLOB.alive_mob_list -= src
				GLOB.dead_mob_list += src
	. = ..()
	switch(var_name)
		if("knockdown")
			SetParalyzed(var_value)
		if("stun")
			SetStun(var_value)
		if("unconscious")
			SetUnconscious(var_value)
		if("sleeping")
			SetSleeping(var_value)
		if("eye_blind")
			set_blindness(var_value)
		if("eye_damage")
			var/obj/item/organ/eyes/E = getorganslot(ORGAN_SLOT_EYES)
			if(E)
				E.setOrganDamage(var_value)
		if("eye_blurry")
			set_blurriness(var_value)
		if("maxHealth")
			updatehealth()
		if("resize")
			update_transform()
		if("lighting_alpha")
			sync_lighting_plane_alpha()

/mob/living/vv_get_header()
	. = ..()
	var/refid = REF(src)
	. += {"
		<br><font size='1'>[VV_HREF_TARGETREF_1V(refid, VV_HK_BASIC_EDIT, "[ckey || "no ckey"]", NAMEOF(src, ckey))] / [VV_HREF_TARGETREF_1V(refid, VV_HK_BASIC_EDIT, "[real_name || "no real name"]", NAMEOF(src, real_name))]</font>
		<br><font size='1'>
			BRUTE:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=brute' id='brute'>[getBruteLoss()]</a>
			FIRE:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=fire' id='fire'>[getFireLoss()]</a>
			TOXIN:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=toxin' id='toxin'>[getToxLoss()]</a>
			OXY:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=oxygen' id='oxygen'>[getOxyLoss()]</a>
			CLONE:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=clone' id='clone'>[getCloneLoss()]</a>
			BRAIN:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=brain' id='brain'>[getOrganLoss(ORGAN_SLOT_BRAIN)]</a>
			STAMINA:<font size='1'><a href='?_src_=vars;[HrefToken()];mobToDamage=[refid];adjustDamage=stamina' id='stamina'>[getStaminaLoss()]</a>
		</font>
	"}

///Checks if the user is incapacitated or on cooldown.
/mob/living/proc/can_look_up()
	return !((next_move > world.time) || incapacitated(ignore_restraints = TRUE))

/**
 * look_up Changes the perspective of the mob to any openspace turf above the mob
 *
 * This also checks if an openspace turf is above the mob before looking up or resets the perspective if already looking up
 *
 */

/mob/living/proc/look_around()
	if(!client)
		return
	if(client.perspective != MOB_PERSPECTIVE) //We are already looking up.
		stop_looking()
		return
	if(client.pixel_x || client.pixel_y)
		stop_looking()
		return
	if(!can_look_up())
		return
	changeNext_move(HAS_TRAIT(src, TRAIT_SLEUTH) ? CLICK_CD_SLEUTH : CLICK_CD_TRACKING)
	if(m_intent != MOVE_INTENT_SNEAK)
		visible_message(span_info("[src] begins looking around."))
	var/looktime = 50 - (STAPER * 2) - (get_skill_level(/datum/skill/misc/tracking) * 5)
	looktime = clamp(looktime, 7, 50)
	if(HAS_TRAIT(src, TRAIT_SLEUTH) ? move_after(src, looktime, target = src) : do_after(src, looktime, target = src))
		for(var/mob/living/M in view(7,src))
			var/marked = FALSE
			if(M == src)
				continue
			if(see_invisible < M.invisibility)
				continue
			var/probby = (2 * STAPER) + (get_skill_level(/datum/skill/misc/tracking)) * 5
			if(M.mob_timers[MT_INVISIBILITY] > world.time) // Check if the mob is affected by the invisibility spell
				if(get_skill_level(/datum/skill/misc/tracking) <= SKILL_LEVEL_JOURNEYMAN)	//Expert / Master / Legendary can detect invisibility even if poorly.
					continue
			if(M.mind)	//We find the biggest value and use that, to account for mages / Nocites / sneaky people all at once
				var/target_sneak = M.get_skill_level(/datum/skill/misc/sneaking)
				var/target_holy = M.get_skill_level(/datum/skill/magic/holy)
				var/target_arcyne = M.get_skill_level(/datum/skill/magic/arcane)
				var/chosen_skill = max(target_sneak, target_holy, target_arcyne)
				probby -= chosen_skill * 5
				if(M.STAPER > 10)
					probby -= (M.STAPER) / 2
			probby = (max(probby, 5))
			if(prob(probby))
				marked = TRUE
				if(M.m_intent == MOVE_INTENT_SNEAK || M.mob_timers[MT_INVISIBILITY] > world.time)
					emote("huh")
					to_chat(M, span_danger("[src] sees me! I'm found!"))
					M.mob_timers[MT_INVISIBILITY] = world.time
					M.mob_timers[MT_FOUNDSNEAK] = world.time
					M.update_sneak_invis(reset = TRUE)
			else
				if(M.m_intent == MOVE_INTENT_SNEAK || M.mob_timers[MT_INVISIBILITY] > world.time)
					if(M.client?.prefs.showrolls)
						to_chat(M, span_warning("[src] didn't find me... [probby]%"))
					else
						to_chat(M, span_warning("[src] didn't find me."))
				else
					marked = TRUE
			if(marked)
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					if(H.current_mark == M && HAS_TRAIT(H, TRAIT_SLEUTH))
						found_ping(get_turf(M), client, "trap")
					else
						found_ping(get_turf(M), client, "hidden")

		for(var/obj/O in view(7,src))
			if(istype(O, /obj/item/restraints/legcuffs/beartrap))
				var/obj/item/restraints/legcuffs/beartrap/M = O
				if(isturf(M.loc) && M.armed)
					found_ping(get_turf(M), client, "trap")
			if(istype(O, /obj/structure/trap,))
				var/obj/structure/trap/M = O
				if(isturf(M.loc) && M.armed)
					found_ping(get_turf(M), client, "trap")
			if(istype(O, /obj/structure/closet/crate/chest/trapped,))
				var/obj/structure/trap/M = O
				if(isturf(M.loc) && M.armed)
					found_ping(get_turf(M), client, "trap")
			if(istype(O, /obj/structure/flora/roguegrass/maneater/real))
				found_ping(get_turf(O), client, "trap")
			//Hearthstone port - Tracking
		for(var/obj/effect/track/potential_track in orange(7, src)) //Can't use view because they're invisible by default.
			if(!can_see(src, potential_track, 10))
				continue
			if(!potential_track.check_reveal(src))
				continue
			found_ping(get_turf(potential_track), client, "hidden")
			potential_track.handle_revealing(src)
		//Hearthstone end.


/proc/found_ping(atom/A, client/C, state)
	if(!A || !C || !state)
		return
	var/image/I = image(icon = 'icons/effects/effects.dmi', loc = A, icon_state = state, layer = 18)
	I.layer = 18
	I.plane = 18
	if(!I)
		return
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flick_overlay(I, list(C), 30)

/mob/proc/look_up()
	return

/mob/living/look_up()
	if(client.perspective != MOB_PERSPECTIVE) //We are already looking up.
		stop_looking()
		return
	if(client.pixel_x || client.pixel_y)
		stop_looking()
		return
	if(!can_look_up())
		return
	changeNext_move(CLICK_CD_MELEE)
	if(m_intent != MOVE_INTENT_SNEAK)
		visible_message(span_info("[src] looks up."))
	var/turf/ceiling = get_step_multiz(src, UP)
	var/turf/T = get_turf(src)
	if(!ceiling) //We are at the highest z-level.
		if(T.can_see_sky())
			switch(GLOB.forecast)
				if("prerain")
					to_chat(src, span_warning("Dark clouds gather..."))
					return
				if("rain")
					to_chat(src, span_warning("A wet wind blows."))
					return
				if("rainbow")
					to_chat(src, span_notice("A beautiful rainbow!"))
					return
				if("fog")
					to_chat(src, span_warning("I can't see anything, the fog has set in."))
					return
			to_chat(src, span_warning("There is nothing special to say about this weather."))
			do_time_change()
		return
	else if(!istransparentturf(ceiling)) //There is no turf we can look through above us
		to_chat(src, span_warning("A ceiling above my head."))
		return

	if(T.can_see_sky())
		do_time_change()

	var/ttime = 10
	if(STAPER > 5)
		ttime = 10 - (STAPER - 5)
		if(ttime < 0)
			ttime = 0

	if(!do_after(src, ttime, target = src))
		return
	reset_perspective(ceiling)
	update_cone_show()
//	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(stop_looking)) //We stop looking up if we move.

/mob/living/proc/look_further(turf/T)

	if(client.perspective != MOB_PERSPECTIVE)
		stop_looking()
		return
	if(client.pixel_x || client.pixel_y)
		stop_looking()
		return
	if(!can_look_up())
		return
	if(!istype(T))
		return
	changeNext_move(CLICK_CD_MELEE)

	var/_x = T.x-loc.x
	var/_y = T.y-loc.y
	var/dist = get_dist(src, T)
	var/message = span_info("[src] looks into the distance.")
	if(dist > 7 || dist  <= 2)
		return
	hide_cone()
	var/ttime = 11
	if(STAPER > 5)
		ttime = max(10 - (STAPER - 5), 5)
	if(STAPER <= 10)
		var/offset = (10 - STAPER) * 2
		if(STAPER == 10)
			offset = 1
		else
			message = span_info("[src] struggles to look ahead.")
		if(_x > 0)
			_x -= offset
			_x = max(0, _x)
		else if(_x != 0)
			_x += offset
			_x = min(0, _x)
		if(_y > 0)
			_y -= offset
			_y = max(0,_y)
		else if(_y != 0)
			_y += offset
			_y = min(0,_y)
	else if(STAPER > 11)
		var/offset = STAPER - 10
		if(offset > 5)	//Caps the bonus at 15 PER, which is a whole extra screen in an orthogonal direction. Anymore will get disorienting.
			offset = 5
		if(STAPER >= 12)
			message = span_info("[src] easily peers afar.")
		if(_x > 0)
			_x += offset
		else if(_x != 0)
			_x -= offset
		if(_y > 0)
			_y += offset
		else if(_y != 0)
			_y -= offset
	if(m_intent != MOVE_INTENT_SNEAK)
		if(_y == 0 && _x == 0)	//Their PER was too low to see anything.
			message = span_info("[src] oafishly stares in front of themselves.")
		visible_message(message)
	animate(client, pixel_x = world.icon_size*_x, pixel_y = world.icon_size*_y, ttime)
//	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(stop_looking))
	update_cone_show()

/mob/proc/look_down(turf/T)
	return

/mob/living/look_down(turf/T)
	if(client.pixel_x || client.pixel_y)
		stop_looking()
		return
	if(client.perspective != MOB_PERSPECTIVE)
		stop_looking()
		return
	if(!can_look_up())
		return
	if(!istype(T))
		return


	var/turf/OS = get_step_multiz(T, DOWN)

	if(!OS)
		return
	var/ttime = 10
	if(STAPER > 5)
		ttime = 10 - (STAPER - 5)
		if(ttime < 0)
			ttime = 0

	if(m_intent != MOVE_INTENT_SNEAK)
		visible_message(span_info("[src] looks down through [T]."))

	if(!do_after(src, ttime, target = src))
		return

	changeNext_move(CLICK_CD_MELEE)
	reset_perspective(OS)
	update_cone_show()
//	RegisterSignal(src, COMSIG_MOVABLE_PRE_MOVE, PROC_REF(stop_looking))

/mob/living/proc/stop_looking()
	if(!client)
		return
	animate(client, pixel_x = 0, pixel_y = 0, 2, easing = SINE_EASING)
	if(client)
		client.pixel_x = 0
		client.pixel_y = 0
	if(isdullahan(src))
		var/mob/living/carbon/human/human = src
		var/obj/item/organ/dullahan_vision/vision = human.getorganslot(ORGAN_SLOT_HUD)
		var/datum/species/dullahan/species = human.dna.species
		if(species.headless && vision.viewing_head)
			var/obj/item/bodypart/head/dullahan/head = species.my_head
			reset_perspective(head)
			update_cone_show()
			return
	reset_perspective()
	update_cone_show()
//	UnregisterSignal(src, COMSIG_MOVABLE_PRE_MOVE)

/**
 * Gets the fire overlay to use for this mob
 *
 * Args:
 * * stacks: Current amount of fire_stacks
 * * on_fire: If we're lit on fire
 *
 * Return a mutable appearance, the overlay that will be applied.
 */
/mob/living/proc/get_fire_overlay(stacks, on_fire)
	RETURN_TYPE(/mutable_appearance)
	return null

/mob/living/proc/offer_item(mob/living/offered_to, obj/offered_item)
	if(isnull(offered_to) || isnull(offered_item))
		stack_trace("no offered_to or offered_item in offer_item()")
		return

	var/time_left = COOLDOWN_TIMELEFT(src, offer_cooldown)

	if(time_left)
		to_chat(src, span_danger("I must wait [time_left / 10] seconds before offering again."))
		return FALSE

	offered_item_ref = WEAKREF(offered_item)

	var/stealthy = (m_intent == MOVE_INTENT_SNEAK)

	if(stealthy)
		to_chat(src, span_notice("I secretly offer [offered_item] to [offered_to]."))
		to_chat(offered_to, span_notice("[src] secretly offers [offered_item] to me..."))
	else
		visible_message(
			span_notice("[src] offers [offered_item] to [offered_to] with an outstretched hand."), \
			span_notice("I offer [offered_item] to [offered_to] with an outstretched hand."), \
			vision_distance = COMBAT_MESSAGE_RANGE, \
			ignored_mobs = list(offered_to)
		)
		to_chat(offered_to, span_notice("[src] offers [offered_item] to me..."))

	new /obj/effect/temp_visual/offered_item_effect(get_turf(src), offered_item, src, offered_to, stealthy)

/mob/living/proc/cancel_offering_item(stealthy)
	var/obj/offered_item = offered_item_ref?.resolve()
	if(isnull(offered_item))
		stop_offering_item()
		return
	if(stealthy)
		to_chat(src, "I stop offering [offered_item ? offered_item : "the item"].")
	else
		visible_message(
			span_notice("[src] puts their hand back down."), \
			span_notice("I stop offering [offered_item ? offered_item : "the item"]."), \
			vision_distance = COMBAT_MESSAGE_RANGE, \
		)
	stop_offering_item()

/mob/living/proc/stop_offering_item()
	COOLDOWN_START(src, offer_cooldown, 1 SECONDS)
	SEND_SIGNAL(src, COMSIG_LIVING_STOPPED_OFFERING_ITEM)
	offered_item_ref = null
	update_a_intents()

/mob/living/proc/try_accept_offered_item(mob/living/offerer, obj/offered_item, stealthy)
	if(get_active_held_item())
		to_chat(src, span_warning("I need a free hand to take it!"))
		return FALSE

	accept_offered_item(offerer, offered_item, stealthy)
	return TRUE

/mob/living/proc/accept_offered_item(mob/living/offerer, obj/offered_item, stealthy)
	transferItemToLoc(offered_item, src)
	put_in_active_hand(offered_item)
	if(stealthy)
		to_chat(offerer, span_notice("[src] takes the secretly offered [offered_item]."))
		to_chat(src, span_notice("I take the secretly offered [offered_item] from [offerer]."))
	else
		to_chat(offerer, span_notice("[src] takes [offered_item] from my outstretched hand."))
		visible_message(
			span_warning("[src] takes [offered_item] from [offerer]'s outstretched hand!"), \
			span_notice("I take [offered_item] from [offerer]'s outstretched hand."), \
			vision_distance = COMBAT_MESSAGE_RANGE, \
			ignored_mobs = list(offerer)
		)
	SEND_SIGNAL(offered_item, COMSIG_OBJ_HANDED_OVER, src, offerer)
	offerer.stop_offering_item()
