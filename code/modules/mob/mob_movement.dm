///Can the atom pass this mob (always true for /mob)
/mob/CanPass(atom/movable/mover, turf/target)
	return TRUE				//There's almost no cases where non /living mobs should be used in game as actual mobs, other than ghosts.

/**
  * If your mob is concious, drop the item in the active hand
  *
  * This is a hidden verb, likely for binding with winset for hotkeys
  */
/client/verb/drop_item()
	set hidden = 1
	return

/**
  * force move the control_object of your client mob
  *
  * Used in admin possession and called from the client Move proc
  * ensures the possessed object moves and not the admin mob
  *
  * Has no sanity other than checking density
  */
/client/proc/Move_object(direct)
	if(mob && mob.control_object)
		if(mob.control_object.density)
			step(mob.control_object,direct)
			if(!mob.control_object)
				return
			mob.control_object.setDir(direct)
		else
			mob.control_object.forceMove(get_step(mob.control_object,direct))

#define MOVEMENT_DELAY_BUFFER 0.75
#define MOVEMENT_DELAY_BUFFER_DELTA 1.25

/**
  * Move a client in a direction
  *
  * Huge proc, has a lot of functionality
  *
  * Mostly it will despatch to the mob that you are the owner of to actually move
  * in the physical realm
  *
  * Things that stop you moving as a mob:
  * * world time being less than your next move_delay
  * * not being in a mob, or that mob not having a loc
  * * missing the n and direction parameters
  * * being in remote control of an object (calls Moveobject instead)
  * * being dead (it ghosts you instead)
  *
  * Things that stop you moving as a mob living (why even have OO if you're just shoving it all
  * in the parent proc with istype checks right?):
  * * having incorporeal_move set (calls Process_Incorpmove() instead)
  * * being grabbed
  * * being buckled  (relaymove() is called to the buckled atom instead)
  * * having your loc be some other mob (relaymove() is called on that mob instead)
  * * Not having MOBILITY_MOVE
  * * Failing Process_Spacemove() call
  *
  * At this point, if the mob is is confused, then a random direction and target turf will be calculated for you to travel to instead
  *
  * Now the parent call is made (to the byond builtin move), which moves you
  *
  * Some final move delay calculations (doubling if you moved diagonally successfully)
  *
  * if mob throwing is set I believe it's unset at this point via a call to finalize
  *
  * Finally if you're pulling an object and it's dense, you are turned 180 after the move
  * (if you ask me, this should be at the top of the move so you don't dance around)
  *
  */
/atom/movable
	var/facepull = TRUE

/mob
	facepull = FALSE

/client/Move(n, direct)
	if(world.time < move_delay) //do not move anything ahead of this check please
		return FALSE
	else
		next_move_dir_add = 0
		next_move_dir_sub = 0
	var/old_move_delay = move_delay
	move_delay = world.time + world.tick_lag //this is here because Move() can now be called mutiple times per tick
	if(!mob || !mob.loc)
		return FALSE
	if(!n || !direct)
		return FALSE
	if(mob.notransform)
		return FALSE	//This is sota the goto stop mobs from moving var
	if(mob.control_object)
		return Move_object(direct)
	if(!isliving(mob))
		return mob.Move(n, direct)
	else if(HAS_TRAIT(mob, TRAIT_IN_FRENZY) || HAS_TRAIT(mob, TRAIT_MOVEMENT_BLOCKED))
		return FALSE
	if(mob.stat == DEAD)
#ifdef TESTSERVER
		mob.ghostize()
		return FALSE
#endif
		if(world.time > mob.mob_timers["lastdied"] + 60 SECONDS)
			mob.ghostize()
		else
			if(!world.time%5)
				to_chat(src, span_warning("My spirit hasn't manifested yet."))
		return FALSE
	if(mob.force_moving)
		return FALSE

	if(mob.shifting)
		mob.pixel_shift(direct)
		return FALSE
	else if(mob.is_shifted)
		mob.unpixel_shift()
	
	mob.last_client_interact = world.time

	var/mob/living/L = mob  //Already checked for isliving earlier
	if(L.incorporeal_move)	//Move though walls
		Process_Incorpmove(direct)
		return FALSE

	if(mob.remote_control)					//we're controlling something, our movement is relayed to it
		return mob.remote_control.relaymove(mob, direct)

	if(Process_Grab()) //are we restrained by someone's grip?
		return

	if(mob.buckled)							//if we're buckled to something, tell it we moved.
		return mob.buckled.relaymove(mob, direct)

	if(!(L.mobility_flags & MOBILITY_MOVE))
		return FALSE

	if(isobj(mob.loc) || ismob(mob.loc))	//Inside an object, tell it we moved
		var/atom/O = mob.loc
		return O.relaymove(mob, direct)

	//We are now going to move
	var/add_delay = mob.cached_multiplicative_slowdown
	if(old_move_delay + (add_delay*MOVEMENT_DELAY_BUFFER_DELTA) + MOVEMENT_DELAY_BUFFER > world.time)
		move_delay = old_move_delay
	else
		move_delay = world.time

	if(L.confused)
		var/newdir = 0
		if(L.confused > 40)
			newdir = pick(GLOB.alldirs)
		else if(prob(L.confused * 1.5))
			newdir = angle2dir(dir2angle(direct) + pick(90, -90))
		else if(prob(L.confused * 3))
			newdir = angle2dir(dir2angle(direct) + pick(45, -45))
		if(newdir)
			direct = newdir
			n = get_step(L, direct)

	var/target_dir = get_dir(L, n)

	//backpedal and strafe slowdown for quick intent
	if(L.fixedeye || L.tempfixeye)
		if(L.dir != target_dir)
			add_delay += 2
			if(L.m_intent == MOVE_INTENT_RUN)
				L.toggle_rogmove_intent(MOVE_INTENT_WALK)
	else
		if(L.dir != target_dir)
			if(abs(dir2angle(L.dir) - dir2angle(target_dir)) == 180)	//If we do a 180 turn, we cancel our run
				if(L.m_intent == MOVE_INTENT_RUN)
					L.toggle_rogmove_intent(MOVE_INTENT_WALK)
			// Reset our sprint counter if we change direction
			L.sprinted_tiles = 0

	. = ..()

	if((direct & (direct - 1)) && mob.loc == n) //moved diagonally successfully
		add_delay *= 2
	mob.set_glide_size(DELAY_TO_GLIDE_SIZE(add_delay))
	move_delay += add_delay
	if(.) // If mob is null here, we deserve the runtime
		if(mob.throwing)
			mob.throwing.finalize(FALSE)

	var/atom/movable/P = mob.pulling
	if(P)
		if(isliving(P))
			var/mob/living/M = P
			if(!(M.mobility_flags & MOBILITY_STAND))
				if(!M.buckled) //carrying/piggyback
					mob.setDir(turn(mob.dir, 180))
		else
			if(P.facepull)
				mob.setDir(turn(mob.dir, 180))
	if(mob.used_intent?.movement_interrupt && mob.atkswinging == "left" && charging)
		to_chat(src, span_warning("I lost my concentration!"))
		mob.stop_attack(FALSE)
		mob.changeNext_move(CLICK_CD_MELEE)
	if(mob.mmb_intent?.movement_interrupt && mob.atkswinging == "middle" && charging)
		to_chat(src, span_warning("I lost my concentration!"))
		mob.stop_attack(FALSE)
		mob.changeNext_move(CLICK_CD_MELEE)

	for(var/datum/browser/X in open_popups)
		if(!X.no_close_movement)
	//		var/datum/browser/popup = new(mob, X, "", 5, 5)
	//		popup.set_content()
	//		popup.open()
	//		popup.close()
			mob << browse(null, "window=[X]")
			open_popups -= X
/**
  * Checks to see if you're being grabbed and if so attempts to break it
  *
  * Called by client/Move()
  */
/client/proc/Process_Grab()
	if(mob.pulledby)
		if(mob.pulledby == mob)
			return FALSE
		if(mob.pulledby == mob.pulling)			//Don't autoresist grabs if we're grabbing them too.
			var/mob/living/L = mob.pulledby
			var/mob/living/M = mob
			if(L.grab_state > M.grab_state)	//Our grabber has a higher grab state than we do.
				move_delay = world.time + 10
				to_chat(src, span_warning("I can't move!"))
				return TRUE
		if(mob.incapacitated(ignore_restraints = 1))
			move_delay = world.time + 10
			to_chat(src, span_warning("I can't move!"))
			return TRUE
		if(mob.restrained(ignore_grab = 1))
			move_delay = world.time + 10
			to_chat(src, span_warning("I'm restrained! I can't move!"))
			return TRUE
		if(mob.pulledby.grab_state > GRAB_PASSIVE)
			move_delay = world.time + 10
			to_chat(src, span_warning("I'm restrained! I can't move!"))
			return TRUE

	if(mob.pulling && isliving(mob.pulling))
		if (issimple(mob.pulling))
			return FALSE
		var/mob/living/L = mob.pulling
		var/mob/living/M = mob
		if(!L.cmode)
			return FALSE
		if (L.resting)
			return FALSE
		if (L.incapacitated())
			return FALSE
		if (M.grab_state > GRAB_PASSIVE)
			return FALSE
		if (L.compliance)
			return FALSE
		move_delay = world.time + 10
		to_chat(src, span_warning("I am clinging to [L]! I need a stronger grip to stop them!"))
		return TRUE    

	if(isanimal(mob.pulling))
		var/mob/living/simple_animal/bound = mob.pulling
		if(bound.binded)
			move_delay = world.time + 10
			to_chat(src, span_warning("[bound] is bound in a summoning circle. I can't move them!"))
			return TRUE

	if(isanimal(mob.pulling))
		var/mob/living/simple_animal/bound = mob.pulling
		if(bound.binded)
			move_delay = world.time + 10
			to_chat(src, span_warning("[bound] is bound in a summoning circle. I can't move them!"))
			return TRUE

// similar to the above, but for NPCs mostly
/mob/proc/is_move_blocked_by_grab()
	if(pulledby && pulledby != src)
		return TRUE
	if(isliving(pulling))
		var/mob/living/L = pulling
		if(L.cmode && !L.resting && !L.incapacitated() && grab_state < GRAB_AGGRESSIVE)
			return TRUE
		if(buckled)
			return TRUE
	if(isanimal(pulling))
		var/mob/living/simple_animal/bound = pulling
		if(bound.binded)
			return TRUE

/**
  * Allows mobs to ignore density and phase through objects
  *
  * Called by client/Move()
  *
  * The behaviour depends on the incorporeal_move value of the mob
  *
  * * INCORPOREAL_MOVE_BASIC - forceMoved to the next tile with no stop
  * * INCORPOREAL_MOVE_SHADOW  - the same but leaves a cool effect path
  * * INCORPOREAL_MOVE_JAUNT - the same but blocked by holy tiles
  *
  * You'll note this is another mob living level proc living at the client level
  */
/client/proc/Process_Incorpmove(direct)
	var/turf/mobloc = get_turf(mob)
	if(!isliving(mob))
		return
	var/mob/living/L = mob
	switch(L.incorporeal_move)
		if(INCORPOREAL_MOVE_BASIC)
			var/T = get_step(L,direct)
			if(T)
				L.forceMove(T)
			L.setDir(direct)
		if(INCORPOREAL_MOVE_SHADOW)
			if(prob(50))
				var/locx
				var/locy
				switch(direct)
					if(NORTH)
						locx = mobloc.x
						locy = (mobloc.y+2)
						if(locy>world.maxy)
							return
					if(SOUTH)
						locx = mobloc.x
						locy = (mobloc.y-2)
						if(locy<1)
							return
					if(EAST)
						locy = mobloc.y
						locx = (mobloc.x+2)
						if(locx>world.maxx)
							return
					if(WEST)
						locy = mobloc.y
						locx = (mobloc.x-2)
						if(locx<1)
							return
					else
						return
				var/target = locate(locx,locy,mobloc.z)
				if(target)
					L.loc = target
					var/limit = 2//For only two trailing shadows.
					for(var/turf/T in getline(mobloc, L.loc))
						new /obj/effect/temp_visual/dir_setting/ninja/shadow(T, L.dir)
						limit--
						if(limit<=0)
							break
			else
				new /obj/effect/temp_visual/dir_setting/ninja/shadow(mobloc, L.dir)
				var/T = get_step(L,direct)
				if(T)
					L.forceMove(T)
			L.setDir(direct)
		if(INCORPOREAL_MOVE_JAUNT) //Incorporeal move, but blocked by holy-watered tiles and salt piles.
			var/turf/open/floor/stepTurf = get_step(L, direct)
			if(stepTurf)
				for(var/obj/effect/decal/cleanable/food/salt/S in stepTurf)
					to_chat(L, "<span class='warning'>[S] bars your passage!</span>")
					return
				if(stepTurf.flags_1 & NOJAUNT_1)
					to_chat(L, "<span class='warning'>Some strange aura is blocking the way.</span>")
					return
				if (locate(/obj/effect/blessing, stepTurf))
					to_chat(L, "<span class='warning'>Holy energies block your path!</span>")
					return

				L.forceMove(stepTurf)
			L.setDir(direct)
	return TRUE

/// Called when this mob slips over, override as needed
/mob/proc/slip(knockdown_amount, obj/O, lube, paralyze, force_drop)
	return

//bodypart selection verbs - Cyberboss
//8:repeated presses toggles through head - eyes - mouth
//4: r-arm 5: chest 6: l-arm
//1: r-leg 2: groin 3: l-leg

///Validate the client's mob has a valid zone selected
/client/proc/check_has_body_select()
	return mob && mob.hud_used && mob.hud_used.zone_select && istype(mob.hud_used.zone_select, /atom/movable/screen/zone_sel)

/**
  * Hidden verb to set the target zone of a mob to the head
  *
  * (bound to 8) - repeated presses toggles through head - eyes - mouth
  */
/client/verb/body_toggle_head()
	set name = "body-toggle-head"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_HEAD)
			next_in_line = BODY_ZONE_PRECISE_NECK
		if(BODY_ZONE_PRECISE_NECK)
			next_in_line = BODY_ZONE_PRECISE_SKULL
		else
			next_in_line = BODY_ZONE_HEAD

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

/client/verb/body_toggle_eye_nose()
	set name = "body-toggle-eye-nose"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_PRECISE_R_EYE)
			next_in_line = BODY_ZONE_PRECISE_NOSE
		if(BODY_ZONE_PRECISE_NOSE)
			next_in_line = BODY_ZONE_PRECISE_L_EYE
		else
			next_in_line = BODY_ZONE_PRECISE_R_EYE

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

/client/verb/body_toggle_mouth_ears()
	set name = "body-toggle-mouth-ears"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_PRECISE_MOUTH)
			next_in_line = BODY_ZONE_PRECISE_EARS
		else
			next_in_line = BODY_ZONE_PRECISE_MOUTH

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the right arm, bound to 4
/client/verb/body_r_arm()
	set name = "body-r-arm"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_R_ARM)
			next_in_line = BODY_ZONE_PRECISE_R_HAND
		else
			next_in_line = BODY_ZONE_R_ARM

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the chest, bound to 5
/client/verb/body_chest()
	set name = "body-chest"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_CHEST)
			next_in_line = BODY_ZONE_PRECISE_STOMACH
		else
			next_in_line = BODY_ZONE_CHEST

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the left arm, bound to 6
/client/verb/body_l_arm()
	set name = "body-l-arm"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_L_ARM)
			next_in_line = BODY_ZONE_PRECISE_L_HAND
		else
			next_in_line = BODY_ZONE_L_ARM

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the right leg, bound to 1
/client/verb/body_r_leg()
	set name = "body-r-leg"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_R_LEG)
			next_in_line = BODY_ZONE_PRECISE_R_FOOT
		else
			next_in_line = BODY_ZONE_R_LEG

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Hidden verb to target the groin, bound to 2
/client/verb/body_groin()
	set name = "body-groin"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(BODY_ZONE_PRECISE_GROIN, mob)

///Hidden verb to target the left leg, bound to 3
/client/verb/body_l_leg()
	set name = "body-l-leg"
	set hidden = 1

	if(!check_has_body_select())
		return

	var/next_in_line
	switch(mob.zone_selected)
		if(BODY_ZONE_L_LEG)
			next_in_line = BODY_ZONE_PRECISE_L_FOOT
		else
			next_in_line = BODY_ZONE_L_LEG

	var/atom/movable/screen/zone_sel/selector = mob.hud_used.zone_select
	selector.set_selected_zone(next_in_line, mob)

///Verb to toggle the walk or run status
/client/verb/toggle_walk_run()
	set name = "toggle-walk-run"
	set hidden = TRUE
	set instant = TRUE
	if(mob)
		mob.toggle_move_intent(usr)

/**
  * Toggle the move intent of the mob
  *
  * triggers an update the move intent hud as well
  */
/mob/proc/toggle_move_intent(mob/user)
	if(m_intent == MOVE_INTENT_RUN)
		m_intent = MOVE_INTENT_WALK
	else
		if(!HAS_TRAIT(user, TRAIT_NORUN))
			m_intent = MOVE_INTENT_RUN
		else
			to_chat(user, span_warning("My joints have decayed too much for running!"))
	if(hud_used && hud_used.static_inventory)
		for(var/atom/movable/screen/mov_intent/selector in hud_used.static_inventory)
			selector.update_icon()



/mob/proc/update_sneak_invis(reset = FALSE)
	return

//* Updates a mob's sneaking status, rendering them invisible or visible in accordance to their status. TODO:Fix people bypassing the sneak fade by turning, and add a proc var to have a timer after resetting visibility.
/mob/living/update_sneak_invis(reset = FALSE) //Why isn't this in mob/living/living_movements.dm? Why, I'm glad you asked!
	if(!reset && world.time < mob_timers[MT_INVISIBILITY]) // Check if the mob is affected by the invisibility spell
		rogue_sneaking = TRUE
		return

	if (stat == DEAD) // we're dead, so be visible if sneaking, and end it there. needed because DeadLife calls this constantly on every dead mob that exists
		if (rogue_sneaking)
			animate(src, alpha = initial(alpha), time = 25)
			spawn(25) regenerate_icons()
			rogue_sneaking = FALSE
		return

	var/turf/T = get_turf(src)
	if(!T) //if the turf they're headed to is invalid
		return

	var/light_amount = 0 // populated when needed below

	var/used_time = 50
	var/light_threshold = rogue_sneaking_light_threshhold
	if(mind)
		used_time = max(used_time - (get_skill_level(/datum/skill/misc/sneaking) * 8), 0)
		light_threshold += (get_skill_level(/datum/skill/misc/sneaking) / 200)

	if(rogue_sneaking || reset) //If sneaking, check if they should be revealed
		var/should_reveal = FALSE
		// are we crit, sleeping, been recently discovered, have no turf, force-revealed or not in sneak intent? then we should be revealed, end of.
		if((stat > SOFT_CRIT) || IsSleeping() || (world.time < mob_timers[MT_FOUNDSNEAK] + 30 SECONDS) || !T || reset || (m_intent != MOVE_INTENT_SNEAK))
			should_reveal = TRUE

		// are we in a area of light that should reveal us?
		if (!should_reveal)
			light_amount = T.get_lumcount() // this is moderately expensive, so only check it if we really need to
			if (light_amount >= light_threshold)
				should_reveal = TRUE
			
		if (should_reveal)
			used_time = round(clamp((50 - (used_time*1.75)), 5, 50),1)
			animate(src, alpha = initial(alpha), time =	used_time) //sneak skill makes you reveal slower but not as drastic as disappearing speed
			spawn(used_time) regenerate_icons()
			rogue_sneaking = FALSE
			return

	else //not currently sneaking, check if we can sneak
		if (m_intent == MOVE_INTENT_SNEAK) // we were not sneaking and are now trying to.
			light_amount = T.get_lumcount()  // as above, this is moderately expensive, so only check it if we need to.
			if(light_amount < light_threshold)
				animate(src, alpha = 0, time = used_time)
				spawn(used_time + 5) regenerate_icons()
				rogue_sneaking = TRUE
	return

///Checked whenever a mob tries to change their movement intent
/mob/proc/toggle_rogmove_intent(intent, silent = FALSE)
	var/is_mounted = FALSE
	if(buckled && intent != MOVE_INTENT_SNEAK)
		if(istype(buckled, /mob/living/simple_animal/hostile/retaliate/rogue/saiga))
			if(ishuman(src))
				var/mob/living/carbon/human/H = src
				var/mob/living/simple_animal/hostile/retaliate/rogue/saiga/S = buckled
				is_mounted = TRUE
				if(H.m_intent == MOVE_INTENT_WALK)
					H.visible_message(span_notice("[H] digs their heels into \the [S], preparing to gallop!"))
					S.emote("aggro")
					if(do_after(H, 20))
						H.m_intent = MOVE_INTENT_RUN
				else
					H.visible_message(span_notice("\The [S] calms, slowing its gait."))
					S.emote("idle")
					if(do_after(H, 15))
						H.m_intent = MOVE_INTENT_WALK
	// If we're becoming sprinting from non-sprinting, reset the counter
	if(!(m_intent == MOVE_INTENT_RUN && intent == MOVE_INTENT_RUN))
		sprinted_tiles = 0

	if(!is_mounted)
		switch(intent)
			if(MOVE_INTENT_SNEAK)
				m_intent = MOVE_INTENT_SNEAK
				if(isliving(src))
					var/mob/living/L = src
					if((/datum/mob_descriptor/prominent/prominent_bottom in L.mob_descriptors) || (/datum/mob_descriptor/prominent/prominent_thighs in L.mob_descriptors))
						L.loud_sneaking = TRUE
					else
						L.loud_sneaking = FALSE
				update_sneak_invis()

			if(MOVE_INTENT_WALK)
				m_intent = MOVE_INTENT_WALK

			if(MOVE_INTENT_RUN)
				if(isliving(src))
					var/mob/living/L = src

					//If mob is trying to switch to run, fail if any of these are true
					if (L.stamina >= L.max_stamina || L.energy <= 0 || HAS_TRAIT(L, TRAIT_NORUN))
						if (HAS_TRAIT(L, TRAIT_NORUN)) // If has trait blocker then inform them
							to_chat(L, span_warning("My joints have decayed too much for running!"))
						return

					if(ishuman(L))
						var/mob/living/carbon/human/H = L
						if(!H.check_armor_skill() || H.legcuffed)
							return

				m_intent = MOVE_INTENT_RUN
	if(hud_used?.static_inventory) //Update UI
		for(var/atom/movable/screen/rogmove/selector in hud_used.static_inventory)
			selector.update_icon()
			
	if(!silent)
		playsound_local(src, 'sound/misc/click.ogg', 100)

/mob/living/proc/check_armor_skill()
	return TRUE

/mob/living/carbon/human/check_armor_skill()
	if(istype(src.wear_armor, /obj/item/clothing))
		var/obj/item/clothing/CL = src.wear_armor
		if(CL.armor_class == ARMOR_CLASS_HEAVY)
			if(!HAS_TRAIT(src, TRAIT_HEAVYARMOR))
				return FALSE
		if(CL.armor_class == ARMOR_CLASS_MEDIUM)
			if(!HAS_TRAIT(src, TRAIT_HEAVYARMOR))
				if(!HAS_TRAIT(src, TRAIT_MEDIUMARMOR))
					return FALSE
	if(istype(src.wear_shirt, /obj/item/clothing))
		var/obj/item/clothing/CL = src.wear_shirt
		if(CL.armor_class == ARMOR_CLASS_HEAVY)
			if(!HAS_TRAIT(src, TRAIT_HEAVYARMOR))
				return FALSE
		if(CL.armor_class == ARMOR_CLASS_MEDIUM)
			if(!HAS_TRAIT(src, TRAIT_HEAVYARMOR))
				if(!HAS_TRAIT(src, TRAIT_MEDIUMARMOR))
					return FALSE
	if(istype(src.wear_pants, /obj/item/clothing))
		var/obj/item/clothing/CL = src.wear_pants
		if(CL.armor_class == ARMOR_CLASS_HEAVY)
			if(!HAS_TRAIT(src, TRAIT_HEAVYARMOR))
				return FALSE
		if(CL.armor_class == ARMOR_CLASS_MEDIUM)
			if(!HAS_TRAIT(src, TRAIT_HEAVYARMOR))
				if(!HAS_TRAIT(src, TRAIT_MEDIUMARMOR))
					return FALSE
	return TRUE

/mob/living/proc/check_dodge_skill()
	return TRUE

/mob/living/carbon/human/check_dodge_skill()
	if(!HAS_TRAIT(src, TRAIT_DODGEEXPERT))
		return FALSE
	if(istype(src.wear_armor, /obj/item/clothing))
		var/obj/item/clothing/CL = src.wear_armor
		if(CL.armor_class == ARMOR_CLASS_HEAVY)
			return FALSE
		if(CL.armor_class == ARMOR_CLASS_MEDIUM)
			return FALSE
	if(istype(src.wear_shirt, /obj/item/clothing))
		var/obj/item/clothing/CL = src.wear_shirt
		if(CL.armor_class == ARMOR_CLASS_HEAVY)
			return FALSE
		if(CL.armor_class == ARMOR_CLASS_MEDIUM)
			return FALSE
	if(istype(src.wear_pants, /obj/item/clothing))
		var/obj/item/clothing/CL = src.wear_pants
		if(CL.armor_class == ARMOR_CLASS_HEAVY)
			return FALSE
		if(CL.armor_class == ARMOR_CLASS_MEDIUM)
			return FALSE
	return TRUE

/mob/living/proc/check_mage_armor()
	return TRUE

/mob/living/carbon/human/check_mage_armor()
	if(!HAS_TRAIT(src, TRAIT_MAGEARMOR))
		return FALSE
	if(istype(src.wear_armor, /obj/item/clothing))
		var/obj/item/clothing/CL = src.wear_armor
		if(CL.armor_class == ARMOR_CLASS_HEAVY)
			return FALSE
		if(CL.armor_class == ARMOR_CLASS_MEDIUM)
			return FALSE
	if(istype(src.wear_shirt, /obj/item/clothing))
		var/obj/item/clothing/CL = src.wear_shirt
		if(CL.armor_class == ARMOR_CLASS_HEAVY)
			return FALSE
		if(CL.armor_class == ARMOR_CLASS_MEDIUM)
			return FALSE
	if(istype(src.wear_pants, /obj/item/clothing))
		var/obj/item/clothing/CL = src.wear_pants
		if(CL.armor_class == ARMOR_CLASS_HEAVY)
			return FALSE
		if(CL.armor_class == ARMOR_CLASS_MEDIUM)
			return FALSE
	if(src.magearmor == 0)
		src.magearmor = 1
		src.apply_status_effect(/datum/status_effect/buff/magearmor)
		return TRUE

	

/mob/proc/toggle_eye_intent(mob/user) //clicking the fixeye button either makes you fixeye or clears your target
	if(fixedeye)
		fixedeye = FALSE
		tempfixeye = FALSE
		if(!tempfixeye)
			nodirchange = FALSE
	else if(!fixedeye)
		fixedeye = TRUE
		nodirchange = TRUE
	for(var/atom/movable/screen/eye_intent/eyet in hud_used.static_inventory)
		eyet.update_icon(src)
	playsound_local(src, 'sound/misc/click.ogg', 100)
///Moves a mob upwards in z level

/mob/proc/ghost_up()
	if(zMove(UP, TRUE))
		to_chat(src, span_notice("I move upwards."))

///Moves a mob down a z level
/mob/proc/ghost_down()
	if(zMove(DOWN, TRUE))
		to_chat(src, span_notice("I move down."))

///Move a mob between z levels, if it's valid to move z's on this turf
/mob/proc/zMove(dir, feedback = FALSE)
	if(dir != UP && dir != DOWN)
		return FALSE
	var/turf/target = get_step_multiz(src, dir)
	if(!target)
		if(feedback)
			to_chat(src, span_warning("There's nothing in that direction!"))
		return FALSE
	if(!canZMove(dir, target))
		if(feedback)
			to_chat(src, span_warning("I couldn't move there!"))
		return FALSE
	forceMove(target)
	return TRUE

/// Can this mob move between z levels
/mob/proc/canZMove(direction, turf/target)
	return FALSE

// Ageneral-purpose proc used to centralize checks to skip turf, movement, step, etc. effects 
// for mobs that are floating, flying, intangible, etc.
/mob/proc/is_floor_hazard_immune()
	return throwing || (movement_type & (FLYING|FLOATING))

#undef MOVEMENT_DELAY_BUFFER
#undef MOVEMENT_DELAY_BUFFER_DELTA
