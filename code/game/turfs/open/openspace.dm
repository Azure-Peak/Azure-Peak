GLOBAL_DATUM_INIT(openspace_backdrop_one_for_all, /atom/movable/openspace_backdrop, new)

/atom/movable/openspace_backdrop
	name			= "openspace_backdrop"

	anchored		= TRUE

	icon            = 'icons/turf/floors.dmi'
	icon_state      = "grey"
	plane           = OPENSPACE_BACKDROP_PLANE
	mouse_opacity 	= MOUSE_OPACITY_TRANSPARENT
	layer           = SPLASHSCREEN_LAYER
	//I don't know why the others are aligned but I shall do the same.
	vis_flags		= VIS_INHERIT_ID

/atom/movable/openspace_backdrop/Initialize()
	. = ..()
//	filters += filter(type = "blur", size = 3)

/turf/open/transparent/openspace
	name = "open space"
	desc = "My eyes can see far down below."
	icon_state = "openspace"
	baseturfs = /turf/open/transparent/openspace
	CanAtmosPassVertical = ATMOS_PASS_YES
//	appearance_flags = KEEP_TOGETHER
	//mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	var/can_cover_up = TRUE
	var/can_build_on = TRUE
	dynamic_lighting = 1
	canSmoothWith = list(/turf/closed/mineral,/turf/closed/wall/mineral/rogue, /turf/open/floor/rogue)
	smooth = SMOOTH_MORE
	neighborlay_override = "staticedge"

/turf/open/transparent/openspace/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/transparent/openspace/roguesmooth(adjacencies)
	var/list/Yeah = ..()
	for(var/O in Yeah)
		var/mutable_appearance/M = mutable_appearance(icon, O)
		M.layer = SPLASHSCREEN_LAYER + 0.01
		M.plane = OPENSPACE_BACKDROP_PLANE + 0.01
		add_overlay(M)

/turf/open/transparent/openspace/airless

/turf/open/transparent/openspace/debug/update_multiz()
	..()
	return TRUE

///No bottom level for openspace.
/turf/open/transparent/openspace/show_bottom_level()
	return FALSE

/turf/open/transparent/openspace/Initialize() // handle plane and layer here so that they don't cover other obs/turfs in Dream Maker
	. = ..()
	dynamic_lighting = 1
	vis_contents += GLOB.openspace_backdrop_one_for_all //Special grey square for projecting backdrop darkness filter on it.

/turf/open/transparent/openspace/zAirIn()
	return TRUE

/turf/open/transparent/openspace/zAirOut()
	return TRUE

/turf/open/transparent/openspace/zPassIn(atom/movable/A, direction, turf/source)
	if(direction == DOWN)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_DOWN)
				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_IN_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/transparent/openspace/zPassOut(atom/movable/A, direction, turf/destination)
	if(A.anchored)
		return FALSE
	if(HAS_TRAIT(A, TRAIT_I_AM_INVISIBLE_ON_A_BOAT))
		return FALSE
	if(direction == DOWN)

		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_DOWN)

				return FALSE
		return TRUE
	if(direction == UP)
		for(var/obj/O in contents)
			if(O.obj_flags & BLOCK_Z_OUT_UP)
				return FALSE
		return TRUE
	return FALSE

/turf/open/transparent/openspace/can_traverse_safely(atom/movable/traveler)
	var/turf/destination = GET_TURF_BELOW(src)
	if(!destination)
		return TRUE // this shouldn't happen, but if it does we can't fall
	if(!traveler.can_zTravel(destination, DOWN, src)) // something is blocking their fall!
		return TRUE
	if(!traveler.can_zFall(src, DOWN, destination)) // they can't fall!
		return TRUE
	return FALSE

/turf/open/transparent/openspace/can_traverse_safely(atom/movable/traveler)
	return FALSE

/turf/open/transparent/openspace/proc/CanCoverUp()
	return can_cover_up

/turf/open/transparent/openspace/proc/CanBuildHere()
	return can_build_on

/turf/open/transparent/openspace/attack_paw(mob/user)
	return attack_hand(user)

/turf/open/transparent/openspace/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/turf/target = get_step_multiz(src, DOWN)
		if(!target)
			to_chat(user, span_warning("I can't climb there."))
			return
		if(!user.can_zTravel(target, DOWN, src))
			to_chat(user, span_warning("I can't climb here."))
			return
		if(user.m_intent != MOVE_INTENT_SNEAK)
			playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
		user.visible_message(span_warning("[user] starts to climb down."), span_warning("I start to climb down."))
		var/climber2wall_dir = get_dir(src, L)
		if(do_after(L, (HAS_TRAIT(L, TRAIT_WOODWALKER) ? 15 : 30), target = src))
			if(user.m_intent != MOVE_INTENT_SNEAK)
				playsound(user, 'sound/foley/climb.ogg', 100, TRUE)
			var/pulling = user.pulling
			var/mob/living/carbon/human/climber = user
			var/baseline_stamina_cost = 30
			var/climb_gear_bonus = 1
			if((istype(climber.backr, /obj/item/clothing/climbing_gear)) || (istype(climber.backl, /obj/item/clothing/climbing_gear)))
				climb_gear_bonus = 2
			var/climbing_skill = max(climber.get_skill_level(/datum/skill/misc/climbing), SKILL_LEVEL_NOVICE)
			var/stamina_cost_final = round(((baseline_stamina_cost / climbing_skill) / climb_gear_bonus), 1)
			if(ismob(pulling))
				user.pulling.forceMove(target)
			var/climber_armor_class = climber.highest_ac_worn()
			if((climber_armor_class <= ARMOR_CLASS_LIGHT) && !(ismob(pulling))) // if our armour is not light or none OR we are pulling someone we eat shit and die and can't climb vertically at all, except for 'vaulting' aka we got a sold turf we can walk on in front of us
				user.movement_type |= FLYING
			L.stamina_add(stamina_cost_final)
			user.forceMove(target)
			user.movement_type &= ~FLYING
			if(istype(user.loc, /turf/open/transparent/openspace)) // basically only apply this slop after we moved. if we are hovering on the openspace turf, then good, we are doing an 'active climb' instead of the usual vaulting action
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

/////////////////////////////////////////////////////////////////////////////////
///LIFEWEB-LIKE CLIMBING, DRAG AND DROP URSELF ONTO AN OPENSPACE TURF CHUDDIE///
///////////////////////////////////////////////////////////////////////////////

/turf/open/transparent/openspace/MouseDrop_T(atom/movable/O, mob/user)
	. = ..()
	if(user == O && isliving(O))
		var/mob/living/L = O
		if(isanimal(L))
			var/mob/living/simple_animal/A = L
			if (!A.dextrous)
				return
		if(L.mobility_flags & MOBILITY_MOVE)
			wallpress(L)
			return

/turf/open/transparent/openspace/proc/wallpress(mob/living/user) // only cardinals, correct chat
	var/turf/climb_target = src
	var/mob/living/carbon/human/climber = user // https://discord.com/channels/1389349752700928050/1389452066493169765/1413195734441922580
	if(!(climber.stat != CONSCIOUS))
		if(!(climber.movement_type == FLYING)) // if you fly then fuck off
			var/pulling = climber.pulling
			if(ismob(pulling)) // if you are grabbing someone then fuck off, could forceMove() both grabber and the grabee for fun doe
				climber.visible_message(span_info("I can't get a good grip while dragging someone."))
				return
			if(!(climber.mobility_flags & MOBILITY_STAND))
				climber.visible_message(span_info("I can't get a good grip while prone."))
				return
			var/wall2wall_dir
			var/list/adjacent_wall_list = get_adjacent_turfs(climb_target) // get and add to the list turfs centered around climb_target (turf we drag mob to) in CARDINAL (NORTH, SOUTH, WEST, EAST) directions
			var/list/adjacent_wall_list_final = list()
			var/turf/wall_for_message
			var/climbing_skill = max(climber.get_skill_level(/datum/skill/misc/climbing), SKILL_LEVEL_NOVICE)
			var/adjacent_wall_diff
			var/climb_gear_bonus = 1 // bonus is defined here, we might use it for calculations still, like giving you +1 effective skill for climbing purposes, but rn it it's only used to halve your stamina costs
			for(var/turf/closed/adjacent_wall in adjacent_wall_list) // we add any turf that is a wall, aka /turf/closed/...
				adjacent_wall_diff = adjacent_wall.climbdiff
				if(!(climbing_skill == 6))
					adjacent_wall_diff += 1
				if((adjacent_wall.wallclimb) && (climbing_skill >= adjacent_wall_diff)) // if the wall has a climbable var TRUE and we got the skill, then we do the following shit
					adjacent_wall_list_final += adjacent_wall
					wall_for_message = pick(adjacent_wall_list_final) // if we are shimmying between 2 climbable walls, then we just pick one along which our sprite and message will be adjusted
					wall2wall_dir = get_dir(climb_target, wall_for_message)
			if(!adjacent_wall_list_final.len) // if there are no /turf/closed WALLS or none of the WALLS have wallclimb set to TRUE, then the list will be empty so we can't climb there
				to_chat(climber, span_warningbig("I can't climb there!"))
			else
				var/list/cloth_wipe_sfx = list('sound/foley/cloth_wipe (1).ogg',
				'sound/foley/cloth_wipe (2).ogg',
				'sound/foley/cloth_wipe (3).ogg'
				)
				var/sfx_vol = (100 - (climbing_skill * 10))
				var/climb_along_delay = round(max(20 - (climbing_skill * 2) - (climber.STASPD/3), 5), 1)
				var/climber_armor_class
				var/baseline_stamina_cost = 15
				if(climber.m_intent == MOVE_INTENT_SNEAK)
					climb_along_delay = climb_along_delay * 1.5
				if(do_after(climber, climb_along_delay, wall_for_message))
					climber.visible_message(span_info("[climber] climbs along [wall_for_message]..."))
					climber_armor_class = climber.highest_ac_worn()
					if(!(climber_armor_class <= ARMOR_CLASS_LIGHT))
						climber.visible_message(span_danger("The armor weighs me down!")) // if you can actually shuffle along the wall but wearing heavy armor, you get a grip on it... but fall, as a little treat
					else
						climber.movement_type = FLYING // the way this works is that we only really ever fall if we enter the open space turf with GROUND move type, otherwise we can just hover over indefinetely
					if((istype(climber.backr, /obj/item/clothing/climbing_gear)) || (istype(climber.backl, /obj/item/clothing/climbing_gear)))
						climb_gear_bonus = 2
					var/stamina_cost_final = round(((baseline_stamina_cost / climbing_skill) / climb_gear_bonus), 1)
					climber.stamina_add(stamina_cost_final) // eat some of climber's stamina when we move onto the next tile
					climber.apply_status_effect(/datum/status_effect/debuff/climbing_lfwb) // continious drain of STAMINA and checks to remove the status effect if we are on solid stuff or branches
					climber.forceMove(climb_target) // while our MOVEMENT TYPE is FLYING, we move onto next tile and can't fall cos of the flying
					climber.movement_type = GROUND // if we move and it's an empty space tile, we fall. otherwise we either just walk into a wall along which we climb and don't fall, or walk onto a solid turf, like... floor or water
					if(climber.m_intent != MOVE_INTENT_SNEAK)
						playsound(climber, 'sound/foley/climb.ogg', sfx_vol)
					else
						playsound(climber, pick(cloth_wipe_sfx), 100, TRUE)
					climber.update_wallpress_slowdown()
					climber.wallpressed = wall2wall_dir // we set our wallpressed flag to TRUE and regain blue bar somewhat, might wanna remove dat idk
					switch(wall2wall_dir)// we are pressed against the wall after all that shit and are facing it, also hugging it too bcoz sou
						if(NORTH)
							climber.setDir(NORTH)
							climber.set_mob_offsets("wall_press", _x = 0, _y = 20)
						if(SOUTH)
							climber.setDir(SOUTH)
							climber.set_mob_offsets("wall_press", _x = 0, _y = -10)
	//						climber.visible_message(span_info("SOUTH")) // debug msg
						if(EAST)
							climber.setDir(EAST)
							climber.set_mob_offsets("wall_press", _x = 12, _y = 0)
						if(WEST)
							climber.setDir(WEST)
							climber.set_mob_offsets("wall_press", _x = -12, _y = 0)
					if(climber.mind)
						climber.mind.add_sleep_experience(/datum/skill/misc/climbing, (climber.STAINT/2), FALSE)

/turf/open/transparent/openspace/attack_ghost(mob/dead/observer/user)
	var/turf/target = get_step_multiz(src, DOWN)
	if(!user.Adjacent(src))
		return
	if(!target)
		to_chat(user, span_warning("I can't go there."))
		return
	user.forceMove(target)
	to_chat(user, span_warning("I glide down."))
	. = ..()

/turf/open/transparent/openspace/attackby(obj/item/C, mob/user, params)
	..()
	if(!CanBuildHere())
		return

/turf/open/transparent/openspace/bullet_act(obj/projectile/P)
	if(!P.arcshot)
		return ..()
	var/turf/target = get_step_multiz(src, DOWN)
	if(target)
		P.forceMove(target)
		P.original = target
		P.process_hit(target, P.select_target(target))
		return BULLET_ACT_TURF
