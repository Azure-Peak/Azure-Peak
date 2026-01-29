/obj/structure
	icon = 'icons/obj/structures.dmi'
	max_integrity = 300
	interaction_flags_atom = INTERACT_ATOM_ATTACK_HAND | INTERACT_ATOM_UI_INTERACT
	flags_1 = CHECK_RICOCHET_1
	layer = BELOW_OBJ_LAYER
	anchored = TRUE
	plane = GAME_PLANE_LOWER
	var/climb_time = 20
	var/climb_stun = 0
	var/climb_sound = 'sound/foley/woodclimb.ogg'
	var/climbable = FALSE
	var/climb_offset = 0 //offset up when climbed
	var/mob/living/structureclimber
	var/hammer_repair
//	move_resist = MOVE_FORCE_STRONG

/obj/structure/Initialize()
	if (!armor)
		armor = ARMOR_STRUCTURE
	. = ..()
	if(smooth)
		queue_smooth(src)
		queue_smooth_neighbors(src)
		icon_state = ""
	if(redstone_id)
		GLOB.redstone_objs += src
		. = INITIALIZE_HINT_LATELOAD

/obj/structure/Bumped(atom/movable/AM)
	..()
	if(density)
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(H.dir == get_dir(H,src) && H.m_intent == MOVE_INTENT_RUN && (H.mobility_flags & MOBILITY_STAND))
				var/is_bigguy = FALSE
				if(HAS_TRAIT(H,TRAIT_BIGGUY))
					if(istype(src,/obj/structure/mineral_door))
						var/obj/structure/mineral_door/S = src
						if(S.smashable)
							is_bigguy = TRUE
				if(is_bigguy && obj_integrity > max_integrity / 3)
					if(max_integrity > 1000) 	//Custom-set HP door, should be respected
						take_damage(max_integrity / 6 + 1)
					else
						if(H.STASTR >= 13)	//STR adding role w/ Giant or half-orc, seems fair
							take_damage((max_integrity / 3) * 2 + 1)
						else 
							take_damage(max_integrity / 3 + 1)
					H.Immobilize(20)
					//MESSES you up
					H.apply_damage(200, BRUTE, "chest", H.run_armor_check("chest", "blunt", damage = 200))
					audible_message(span_warning("\The [src] shakes under the force of a great impact!"))
					playsound(src, "meteor", 100, TRUE)
					addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, Knockdown), 10), 10)
				else if(is_bigguy && obj_integrity <= max_integrity / 3)	//This charge will wreck it
					take_damage(max_integrity)
					H.Immobilize(5)
					H.apply_damage(80, BRUTE, "chest", H.run_armor_check("chest", "blunt", damage = 80))
				else	//Normal charge
					H.Immobilize(10)
					H.apply_damage(15, BRUTE, "head", H.run_armor_check("head", "blunt", damage = 15))
					playsound(src, "genblunt", 100, TRUE)
					addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, Knockdown), 10), 10)
				H.toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)
				H.visible_message(span_warning("[H] runs into [src]!"), span_warning("I run into [src]!"))


/obj/structure/Destroy()
	if(isturf(loc))
		for(var/mob/living/user in loc)
			if(climb_offset)
				user.reset_offsets("structure_climb")
	if(redstone_id)
		for(var/obj/structure/O in redstone_attached)
			O.redstone_attached -= src
			redstone_attached -= O
		GLOB.redstone_objs -= src
//	if(smooth)
//		queue_smooth_neighbors(src)
	return ..()

/obj/structure/attack_hand(mob/user)
	. = ..()
	if(.)
		return
//	if(structureclimber && structureclimber != user)
//		user.changeNext_move(CLICK_CD_MELEE)
//		user.do_attack_animation(src)
//		structureclimber.Paralyze(40)
//		structureclimber.visible_message(span_warning("[structureclimber] has been knocked off [src].", "You're knocked off [src]!", "You see [structureclimber] get knocked off [src]."))

/obj/structure/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/user = AM
		if(climb_offset)
			user.set_mob_offsets("structure_climb", _x = 0, _y = climb_offset)

/obj/structure/Uncrossed(atom/movable/AM)
	. = ..()
	if(isliving(AM) && !AM.throwing)
		var/mob/living/user = AM
		if(climb_offset)
			user.reset_offsets("structure_climb")

/obj/structure/ui_act(action, params)
	..()
	add_fingerprint(usr)

/obj/structure/MouseDrop_T(atom/movable/O, mob/user)
	. = ..()
	if(!climbable)
		return
	if(user == O && isliving(O))
		var/mob/living/L = O
		if(isanimal(L))
			var/mob/living/simple_animal/A = L
			if (!A.dextrous)
				return
		if(L.mobility_flags & MOBILITY_MOVE)
			climb_structure(user)
			return
	if(!istype(O, /obj/item) || user.get_active_held_item() != O)
		return
	if(!user.dropItemToGround(O))
		return
	if (O.loc != src.loc)
		step(O, get_dir(O, src))

/obj/structure/proc/do_climb(atom/movable/A)
	// this is done so that climbing onto something doesn't ignore other dense objects on the same turf
	if(climbable)
		density = FALSE
		. = step(A,get_dir(A,src.loc))
		density = TRUE

/obj/structure/ex_act(severity, target, epicenter, devastation_range, heavy_impact_range, light_impact_range, flame_range)
	if(QDELETED(src))
		return
	var/fodist = 0
	if(!isnull(epicenter))
		fodist = get_dist(src, epicenter)
	var/fdist = max(0, flame_range)
	var/brute_loss = 0
	switch(severity)
		if(EXPLODE_DEVASTATE)
			var/ddist = max(0, devastation_range)
			brute_loss = (1500 + 250 * ddist) - (250 * fodist)
			if(fodist == 0)
				brute_loss *= 2
			brute_loss = max(0, brute_loss)

		if(EXPLODE_HEAVY)
			var/hdist = max(0, heavy_impact_range)
			brute_loss = (20 + 8 * hdist) - (8 * fodist)
			brute_loss = max(0, brute_loss)

		if(EXPLODE_LIGHT)
			var/ldist = max(0, light_impact_range)
			brute_loss = (8 + 3 * ldist) - (3 * fodist)
			brute_loss = max(0, brute_loss)
		else
			return

	var/extra_integrity = 0
	switch(severity)
		if(EXPLODE_DEVASTATE) extra_integrity = 1500
		if(EXPLODE_HEAVY)     extra_integrity = 0
		if(EXPLODE_LIGHT)     extra_integrity = 0

	var/hard_cap = max_integrity
	switch(severity)
		if(EXPLODE_DEVASTATE)
			hard_cap = max_integrity //still hits hard doors and windows hard yes yes
		if(EXPLODE_HEAVY)
			hard_cap = min(round(max_integrity * 0.25), 20) //some shit has 50 hps and some shit like doors 1500. I dont want one bomb to nuke 10000 windows around coz its annoying
		if(EXPLODE_LIGHT)
			hard_cap = min(round(max_integrity * 0.10), 10) 

	var/total_damage = round(CLAMP(brute_loss + extra_integrity, 0, hard_cap)) 
	if(total_damage > 0 && !QDELETED(src))
		take_damage(total_damage, BRUTE, "blunt", 0)

	if(fdist && !QDELETED(src))
		var/stacks = max(0, (fdist - fodist) * 2)
		if(stacks > 0)
			fire_act(stacks)
	if(!QDELETED(src) && !density)
		..()

/obj/structure/proc/climb_structure(mob/living/user)
	src.add_fingerprint(user)
	var/adjusted_climb_time = climb_time
	if(user.restrained()) //climbing takes twice as long when restrained.
		adjusted_climb_time *= 2
	if(!ishuman(user))
		adjusted_climb_time = 0 //simple mobs instantly climb
	if(HAS_TRAIT(user, TRAIT_FREERUNNING)) //do you have any idea how fast I am???
		adjusted_climb_time *= 0.8
	adjusted_climb_time -= user.STASPD * 2
	adjusted_climb_time = max(adjusted_climb_time, 0)
//	if(adjusted_climb_time)
//		user.visible_message(span_warning("[user] starts climbing onto [src]."), span_warning("I start climbing onto [src]..."))
	structureclimber = user
	if(do_mob(user, user, adjusted_climb_time))
		if(src.loc) //Checking if structure has been destroyed
			if(do_climb(user))
				user.visible_message(span_warning("[user] climbs onto [src]."), \
									span_notice("I climb onto [src]."))
				log_combat(user, src, "climbed onto")
//				if(climb_offset)
//					user.set_mob_offsets("structure_climb", _x = 0, _y = climb_offset)
				if(climb_stun)
					user.Stun(climb_stun)
				if(climb_sound)
					playsound(src, climb_sound, 100)
				. = 1
			else
				to_chat(user, span_warning("I fail to climb onto [src]."))
	structureclimber = null

// You can path over a dense structure if it's climbable.
/obj/structure/CanAStarPass(ID, to_dir, caller)
	. = climbable || ..()

/obj/structure/examine(mob/user)
	. = ..()
	if(!(resistance_flags & INDESTRUCTIBLE))
		if(obj_broken)
			. += span_notice("It appears to be broken.")
		var/examine_status = examine_status(user)
		if(examine_status)
			. += examine_status

/obj/structure/proc/examine_status(mob/user) //An overridable proc, mostly for falsewalls.
	if(max_integrity)
		var/healthpercent = (obj_integrity/max_integrity) * 100
		switch(healthpercent)
			if(50 to 99)
				return  "It looks slightly damaged."
			if(25 to 50)
				return  "It appears heavily damaged."
			if(1 to 25)
				return  span_warning("It's falling apart!")
