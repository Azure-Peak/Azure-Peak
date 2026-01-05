/turf/closed
	name = ""
	layer = CLOSED_TURF_LAYER
	opacity = 1
	density = TRUE
	blocks_air = TRUE
	baseturfs = list(/turf/open/floor/rogue/naturalstone, /turf/open/transparent/openspace)
	plane = WALL_PLANE
	var/above_floor
	var/wallpress = TRUE
	var/wallclimb = FALSE
	var/climbdiff = 0

/turf/closed/basic/New()//Do not convert to Initialize
	SHOULD_CALL_PARENT(FALSE)
	//This is used to optimize the map loader
	return

/turf/closed/MouseDrop_T(atom/movable/O, mob/user)
	. = ..()
	if(!wallpress)
		return
	if(user == O && isliving(O))
		var/mob/living/L = O
		if(isanimal(L))
			var/mob/living/simple_animal/A = L
			if (!A.dextrous)
				return
		if(L.mobility_flags & MOBILITY_MOVE)
			wallpress(L)
			return

/turf/closed/proc/wallpress(mob/living/user)
	if(user.wallpressed)
		return
	if(user.is_shifted)
		return
	if(!(user.mobility_flags & MOBILITY_STAND))
		return
	var/dir2wall = get_dir(user,src)
	if(!(dir2wall in GLOB.cardinals))
		return
	user.wallpressed = dir2wall
	user.update_wallpress_slowdown()
	user.visible_message(span_info("[user] leans against [src]."))
	switch(dir2wall)
		if(NORTH)
			user.setDir(SOUTH)
			user.set_mob_offsets("wall_press", _x = 0, _y = 20)
		if(SOUTH)
			user.setDir(NORTH)
			user.set_mob_offsets("wall_press", _x = 0, _y = -10)
		if(EAST)
			user.setDir(WEST)
			user.set_mob_offsets("wall_press", _x = 12, _y = 0)
		if(WEST)
			user.setDir(EAST)
			user.set_mob_offsets("wall_press", _x = -12, _y = 0)

/turf/closed/proc/wallshove(mob/living/user)
	if(user.wallpressed)
		return
	if(!(user.mobility_flags & MOBILITY_STAND))
		return
	var/dir2wall = get_dir(user,src)
	if(!(dir2wall in GLOB.cardinals))
		return
	user.wallpressed = dir2wall
	user.update_wallpress_slowdown()
	switch(dir2wall)
		if(NORTH)
			user.setDir(NORTH)
			user.set_mob_offsets("wall_press", _x = 0, _y = 20)
		if(SOUTH)
			user.setDir(SOUTH)
			user.set_mob_offsets("wall_press", _x = 0, _y = -10)
		if(EAST)
			user.setDir(EAST)
			user.set_mob_offsets("wall_press", _x = 12, _y = 0)
		if(WEST)
			user.setDir(WEST)
			user.set_mob_offsets("wall_press", _x = -12, _y = 0)

/mob/living/proc/update_wallpress_slowdown()
	if(wallpressed)
		add_movespeed_modifier("wallpress", TRUE, 100, override = TRUE, multiplicative_slowdown = 3)
	else
		remove_movespeed_modifier("wallpress")

/turf/closed/Bumped(atom/movable/AM)
	..()
	if(density)
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			if(H.dir == get_dir(H,src) && H.m_intent == MOVE_INTENT_RUN && (H.mobility_flags & MOBILITY_STAND))
				H.Immobilize(10)
				H.apply_damage(15, BRUTE, "head", H.run_armor_check("head", "blunt", damage = 15))
				H.toggle_rogmove_intent(MOVE_INTENT_WALK, TRUE)
				playsound(src, "genblunt", 100, TRUE)
				H.visible_message(span_warning("[H] runs into [src]!"), span_warning("I run into [src]!"))
				addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, Knockdown), 10), 10)

/turf/closed/Initialize()
	. = ..()
	if(above_floor)
		var/turf/open/transparent/openspace/target = get_step_multiz(src, UP)
		if(istype(target))
			target.ChangeTurf(above_floor)

/turf/closed/Destroy()
	if(above_floor)
		var/turf/above = get_step_multiz(src, UP)
		if(above)
			if(istype(above, above_floor))
				var/count
				for(var/D in GLOB.cardinals)
					var/turf/T = get_step(above, D)
					if(T)
						var/turf/closed/C = get_step_multiz(T, DOWN)
						if(istype(C))
							count++
					if(count >= 2)
						break
				if(count < 2)
					above.ScrapeAway()
	. = ..()

/turf/closed/attack_paw(mob/user)
	return attack_hand(user)

/turf/closed/attack_hand(mob/user)
	if(wallclimb)
		if(isliving(user))
			var/mob/living/L = user
			var/climbsound = 'sound/foley/climb.ogg'
			if(L.stat != CONSCIOUS)
				return
			var/turf/target = get_step_multiz(user, UP)
			if(!istype(target, /turf/open/transparent/openspace))
				to_chat(user, span_warning("I can't climb here."))
				return
			if(!L.can_zTravel(target, UP))
				to_chat(user, span_warning("I can't climb there."))
				return
			target = get_step_multiz(src, UP)
			if(!target || istype(target, /turf/closed) || istype(target, /turf/open/transparent/openspace))
				target = get_step_multiz(user.loc, UP)
				if(!target || !istype(target, /turf/open/transparent/openspace))
					to_chat(user, span_warning("I can't climb here."))
					return
			for(var/obj/structure/F in target)
				if(F && (F.density && !F.climbable))
					to_chat(user, span_warning("I can't climb here."))
					return
			var/used_time = 0
			if(L.mind)
				var/myskill = L.get_skill_level(/datum/skill/misc/climbing)
				var/obj/structure/table/TA = locate() in L.loc
				if(TA)
					myskill += 1
				else
					var/obj/structure/chair/CH = locate() in L.loc
					if(CH)
						myskill += 1
					var/obj/structure/wallladder/WL = locate() in L.loc
					if(WL)
						if(get_dir(WL.loc,src) == WL.dir)
							myskill += 8
							climbsound = 'sound/foley/ladder.ogg'

				if(myskill < climbdiff)
					to_chat(user, span_warning("I'm not capable of climbing this wall."))
					return
				used_time = max(70 - (myskill * 10) - (L.STASPD * 3), 30)
			if(user.m_intent != MOVE_INTENT_SNEAK)
				playsound(user, climbsound, 100, TRUE)
			user.visible_message(span_warning("[user] starts to climb [src]."), span_warning("I start to climb [src]..."))
			if(do_after(L, used_time, target = src))
				var/pulling = user.pulling
				var/mob/living/carbon/human/climber = user
				var/baseline_stamina_cost = 30 // have to disable stamina regen while on wall bruh in energystamina.dm
				var/climbing_skill = max(climber.get_skill_level(/datum/skill/misc/climbing), SKILL_LEVEL_NOVICE)
				var/stamina_cost_final = round((baseline_stamina_cost / climbing_skill), 1)
				if(ismob(pulling))
					user.pulling.forceMove(target)
				var/climber_armor_class = climber.highest_ac_worn()
				if((climber_armor_class <= ARMOR_CLASS_LIGHT) && !(ismob(pulling))) // if our armour is not light or none OR we are pulling someone we eat shit and die and can't climb vertically at all, except for 'vaulting' aka we got a sold turf we can walk on in front of us
					user.movement_type |= FLYING
				L.stamina_add(stamina_cost_final)
				user.forceMove(target)
				user.movement_type &= ~FLYING
				if(istype(user.loc, /turf/open/transparent/openspace)) // basically only apply this slop after we moved. if we are hovering on the openspace turf, then good, we are doing an 'active climb' instead of the usual vaulting action
					var/climber2wall_dir = get_dir(climber, src)
					climber.wallpressed = climber2wall_dir
					switch(climber2wall_dir)// we are pressed against the wall after all that shit and are facing it, also hugging it too bcoz sou
						if(NORTH)
							climber.setDir(NORTH)
							climber.set_mob_offsets("wall_press", _x = 0, _y = 20)
						if(SOUTH)
							climber.setDir(SOUTH)
							climber.set_mob_offsets("wall_press", _x = 0, _y = -10)
						if(EAST)
							climber.setDir(EAST)
							climber.set_mob_offsets("wall_press", _x = 12, _y = 0)
						if(WEST)
							climber.setDir(WEST)
							climber.set_mob_offsets("wall_press", _x = -12, _y = 0)
					L.apply_status_effect(/datum/status_effect/debuff/climbing_lfwb, stamina_cost_final)
				user.start_pulling(pulling,supress_message = TRUE)
				if(user.m_intent != MOVE_INTENT_SNEAK)
					playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
				if(L.mind)
					L.mind.add_sleep_experience(/datum/skill/misc/climbing, (L.STAINT/2), FALSE)
				return TRUE
	else
		..()

/turf/closed/examine(mob/user)
	. = ..()
	if(wallclimb)
		var/skill = user.get_skill_level(/datum/skill/misc/climbing)
		if(skill >= climbdiff)
			. += span_info("I <b>can</b> climb this wall.")
			if(skill == 6)
				. += span_info("I <b>can</b> move along the ledge here.")
			else if(skill > climbdiff)
				. += span_info("I <b>can</b> move along the ledge here.")
			else
				. += span_info("I <b>cannot</b> move along the ledge here.")
		else if(abs(skill - climbdiff) == 1)
			. += span_info("I cannot climb this wall, but I could with the help of a table or a chair.")
			. += span_info("I <b>cannot</b> move along the ledge here.")
		else
			. += span_info("I <b>cannot</b> climb this wall.")
	else
		. += span_info("This wall cannot be climbed.")

/turf/closed/attack_ghost(mob/dead/observer/user)
	if(!user.Adjacent(src))
		return
	var/turf/target = get_step_multiz(user, UP)
	if(!target)
		to_chat(user, span_warning("I can't go there."))
		return
	if(!istype(target, /turf/open/transparent/openspace))
		to_chat(user, span_warning("I can't go there."))
		return
	user.forceMove(target)
	to_chat(user, span_warning("I crawl up the wall."))
	. = ..()

/turf/closed/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	return FALSE

/turf/closed/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSCLOSEDTURF))
		return TRUE
	return ..()

/turf/closed/proc/feel_turf(mob/living/user)
	to_chat(user, span_notice("I start feeling around [src]"))
	if(!do_after(user, 1.5 SECONDS, src))
		return

	for(var/obj/structure/lever/hidden/lever in contents)
		lever.feel_button(user)

/turf/closed/indestructible
	name = "wall"
	icon = 'icons/turf/walls.dmi'
	explosion_block = 50

/turf/closed/indestructible/TerraformTurf(path, new_baseturf, flags, defer_change = FALSE, ignore_air = FALSE)
	return

/turf/closed/indestructible/acid_act(acidpwr, acid_volume, acid_id)
	return 0

/turf/closed/indestructible/Melt()
	to_be_destroyed = FALSE
	return src

/turf/closed/indestructible/sandstone
	name = "sandstone wall"
	desc = ""
	icon = 'icons/turf/walls/sandstone_wall.dmi'
	icon_state = "sandstone"
	baseturfs = /turf/closed/indestructible/sandstone
	smooth = SMOOTH_TRUE

/turf/closed/indestructible/oldshuttle/corner
	icon_state = "corner"

/turf/closed/indestructible/splashscreen
	name = ""
	icon = 'icons/default_title.dmi'
	icon_state = ""
	layer = FLY_LAYER
	bullet_bounce_sound = null

/turf/closed/indestructible/splashscreen/New()
	SStitle.splash_turf = src
	if(SStitle.icon)
		icon = SStitle.icon
	..()

/turf/closed/indestructible/splashscreen/vv_edit_var(var_name, var_value)
	. = ..()
	if(.)
		switch(var_name)
			if("icon")
				SStitle.icon = icon

/turf/closed/indestructible/riveted
	icon = 'icons/turf/walls/riveted.dmi'
	icon_state = "riveted"
	smooth = SMOOTH_TRUE

/turf/closed/indestructible/abductor
	icon_state = "alien1"

/turf/closed/indestructible/opshuttle
	icon_state = "wall3"

/turf/closed/indestructible/fakeglass/Initialize()
	. = ..()
	icon_state = null //set the icon state to null, so our base state isn't visible
	underlays += mutable_appearance('icons/obj/structures.dmi', "grille") //add a grille underlay
	underlays += mutable_appearance('icons/turf/floors.dmi', "plating") //add the plating underlay, below the grille

/turf/closed/indestructible/opsglass/Initialize()
	. = ..()
	icon_state = null
	underlays += mutable_appearance('icons/obj/structures.dmi', "grille")
	underlays += mutable_appearance('icons/turf/floors.dmi', "plating")

/turf/closed/indestructible/rock
	name = "granite"
	desc = ""
	icon = 'icons/turf/mining.dmi'
	icon_state = "rock2"

/turf/closed/indestructible/rock/snow
	name = "mountainside"
	desc = ""
	icon = 'icons/turf/walls.dmi'
	icon_state = "snowrock"
	bullet_sizzle = TRUE
	bullet_bounce_sound = null

/turf/closed/indestructible/rock/snow/ice
	name = "iced rock"
	desc = ""
	icon = 'icons/turf/walls.dmi'
	icon_state = "icerock"

/turf/closed/indestructible/paper
	name = "thick paper wall"
	desc = ""
	icon = 'icons/turf/walls.dmi'
	icon_state = "paperwall"

/turf/closed/indestructible/necropolis
	name = "necropolis wall"
	desc = ""
	icon = 'icons/turf/walls.dmi'
	icon_state = "necro"
	explosion_block = 50
	baseturfs = /turf/closed/indestructible/necropolis

/turf/closed/indestructible/necropolis/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "necro1"
	return TRUE

/turf/closed/indestructible/riveted/boss
	name = "necropolis wall"
	desc = ""
	icon = 'icons/turf/walls/boss_wall.dmi'
	icon_state = "wall"
	canSmoothWith = list(/turf/closed/indestructible/riveted/boss, /turf/closed/indestructible/riveted/boss/see_through)
	explosion_block = 50
	baseturfs = /turf/closed/indestructible/riveted/boss

/turf/closed/indestructible/riveted/boss/see_through
	opacity = FALSE

/turf/closed/indestructible/riveted/boss/get_smooth_underlay_icon(mutable_appearance/underlay_appearance, turf/asking_turf, adjacency_dir)
	underlay_appearance.icon = 'icons/turf/floors.dmi'
	underlay_appearance.icon_state = "basalt"
	return TRUE
