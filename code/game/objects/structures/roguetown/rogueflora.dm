#define SEARCHTIME 12 // Standard search cooldown = 1.2 seconds
//newtree

/obj/structure/flora/roguetree
	name = "old tree"
	desc = "An old wicked tree that not even elves could love."
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "t1"
	opacity = 1
	density = 1
	max_integrity = 200
	blade_dulling = DULLING_CUT
	pixel_x = -16
	layer = 4.81
	plane = GAME_PLANE_UPPER
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/woodhit.ogg'
	debris = list(/obj/item/grown/log/tree/stick = 2)
	static_debris = list(/obj/item/grown/log/tree = 1)
	alpha = 200
	var/stump_type = /obj/structure/flora/roguetree/stump

/obj/structure/flora/roguetree/attack_right(mob/user)
	handle_special_items_retrieval(user, src)

/obj/structure/flora/roguetree/attacked_by(obj/item/I, mob/living/user)
	var/was_destroyed = obj_destroyed
	. = ..()
	if(.)
		if(!was_destroyed && obj_destroyed)
			record_featured_stat(FEATURED_STATS_TREE_FELLERS, user)
			record_round_statistic(STATS_TREES_CUT)

/obj/structure/flora/roguetree/spark_act()
	fire_act()

/obj/structure/flora/roguetree/Initialize()
	. = ..()

/*
	if(makevines)
		var/turf/target = get_step_multiz(src, UP)
		if(istype(target, /turf/open/transparent/openspace))
			target.ChangeTurf(/turf/open/floor/rogue/shroud)
			var/makecanopy = FALSE
			for(var/D in GLOB.cardinals)
				if(!makecanopy)
					var/turf/NT = get_step(src, D)
					for(var/obj/structure/flora/roguetree/R in NT)
						if(R.makevines)
							makecanopy = TRUE
							break
			if(makecanopy)
				for(var/D in GLOB.cardinals)
					var/turf/NT = get_step(target, D)
					if(NT)
						if(istype(NT, /turf/open/transparent/openspace) || istype(NT, /turf/open/floor/rogue/shroud))
							NT.ChangeTurf(/turf/closed/wall/shroud)
							for(var/X in GLOB.cardinals)
								var/turf/NA = get_step(NT, X)
								if(NA)
									if(istype(NA, /turf/open/transparent/openspace))
										NA.ChangeTurf(/turf/open/floor/rogue/shroud)
*/

	if(istype(loc, /turf/open/floor/rogue/grass))
		var/turf/T = loc
		T.ChangeTurf(/turf/open/floor/rogue/dirt)

/obj/structure/flora/roguetree/obj_destruction(damage_flag)
	if(stump_type)
		new stump_type(loc)
	playsound(src, 'sound/misc/treefall.ogg', 100, FALSE)
	. = ..()


/obj/structure/flora/roguetree/Initialize()
	. = ..()
	icon_state = "t[rand(1,16)]"

/obj/structure/flora/roguetree/evil/Initialize()
	. = ..()
	icon_state = "wv[rand(1,2)]"
	soundloop = new(src, FALSE)
	soundloop.start()

/obj/structure/flora/roguetree/evil/Destroy()
	soundloop.stop()
	if(controller)
		controller.endvines()
		controller.tree = null
	controller = null
	. = ..()

/obj/structure/flora/roguetree/evil
	var/datum/looping_sound/boneloop/soundloop
	var/datum/vine_controller/controller

/obj/structure/flora/roguetree/wise
	name = "sacred tree"
	desc = "A blessed primordial tree, ancient beyond years. Said to be the very embodiment of the Tree Father himself—whose presence alone imbues druids with wild energies."
	icon_state = "mystical"
	max_integrity = 400
	var/activated = FALSE
	var/cooldown = FALSE
	var/retaliation_messages = list(
		"LEAVE FOREST ALONE!",
		"DENDOR PROTECTS!",
		"NATURE'S WRATH!",
		"BEGONE, INTERLOPER!"
	)

/obj/structure/flora/roguetree/wise/Initialize()
	. = ..()
	icon_state = "mystical"

/obj/structure/flora/roguetree/wise/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(activated && !cooldown)
		retaliate(user)


/obj/structure/flora/roguetree/wise/proc/retaliate(mob/living/target)
	if(cooldown || !istype(target) || !activated)
		return

	cooldown = TRUE
	addtimer(VARSET_CALLBACK(src, cooldown, FALSE), 5 SECONDS)

	var/message = pick(retaliation_messages)
	say(span_danger("[message]"))

	var/atom/throw_target = get_edge_target_turf(src, get_dir(src, target))
	target.throw_at(throw_target, 4, 2)
	target.adjustBruteLoss(8)

/obj/structure/flora/roguetree/wise/examine(mob/user)
	. = ..()
	SEND_SOUND(usr, sound(null))
	playsound(user, 'sound/music/tree.ogg', 80)

/obj/structure/flora/roguetree/wise/druids/take_damage(damage_amount, damage_type = BRUTE || BURN, damage_flag, sound_effect = TRUE)
	. = ..()
	SEND_GLOBAL_SIGNAL(COMSIG_SACRED_TREE_DAMAGED, src, damage_amount)

/obj/structure/flora/roguetree/burnt
	name = "burnt tree"
	desc = "Maybe lightning, maybe war, took the life of this once lively tree."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "t1"
	stump_type = /obj/structure/flora/roguetree/stump/burnt
	pixel_x = -32

/obj/structure/flora/roguetree/burnt/Initialize()
	. = ..()
	icon_state = "t[rand(1,4)]"

/obj/structure/flora/roguetree/stump/burnt
	name = "tree stump"
	desc = "This stump is burnt. Maybe someone was trying to get coal the easy way."
	icon_state = "st1"
	icon = 'icons/roguetown/misc/96x96.dmi'
	stump_type = null
	pixel_x = -32

/obj/structure/flora/roguetree/stump/burnt/Initialize()
	. = ..()
	icon_state = "st[rand(1,2)]"

/obj/structure/flora/roguetree/stump/pine
	name = "pine stump"
	icon_state = "dead4"
	icon = 'icons/obj/flora/pines.dmi'
	static_debris = list(/obj/item/rogueore/coal/charcoal = 1)
	stump_type = null
	pixel_x = -32

/obj/structure/flora/roguetree/stump/pine/Initialize()
	. = ..()
	icon_state = "dead[rand(4,5)]"

/obj/structure/flora/roguetree/underworld
	name = "screaming tree"
	desc = "Human faces everywhere."
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "screaming1"
	opacity = 1
	density = 1

/obj/structure/flora/roguetree/underworld/Initialize()
	. = ..()
	icon_state = "screaming[rand(1,3)]"

/obj/structure/flora/roguetree/stump
	name = "tree stump"
	desc = "Someone cut this tree down."
	icon_state = "t1stump"
	opacity = 0
	pass_flags = LETPASSTHROW
	max_integrity = 100
	climbable = TRUE
	climb_time = 0
	layer = TABLE_LAYER
	plane = GAME_PLANE
	blade_dulling = DULLING_CUT
	// debris = list(/obj/item/grown/log/tree/stick = 1) // Removed for lumberjacking/handcart upgrade PR
	static_debris = list(/obj/item/grown/log/tree/small = 1)
	alpha = 255
	pixel_x = -16
	climb_offset = 14
	stump_type = FALSE

/obj/structure/flora/roguetree/stump/Initialize()
	. = ..()
	icon_state = "t[rand(1,4)]stump"

/obj/structure/flora/roguetree/stump/log
	name = "ancient log"
	desc = "The rotten remains of a tree that suffered nature's cruelty ages ago."
	icon_state = "log1"
	opacity = 0
	max_integrity = 200
	blade_dulling = DULLING_CUT
	static_debris = list(/obj/item/grown/log/tree = 1)
	climb_offset = 14
	stump_type = FALSE

/obj/structure/flora/roguetree/stump/log/Initialize()
	. = ..()
	icon_state = "log[rand(1,2)]"


//newbushes

/obj/structure/flora/roguegrass
	name = "grass"
	desc = "Green, soft, and lively."
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "grass1"
	attacked_sound = "plantcross"
	destroy_sound = "plantcross"
	max_integrity = 2
	blade_dulling = DULLING_CUT
	debris = list(/obj/item/natural/fibers = 1)


/obj/structure/flora/roguegrass/spark_act()
	fire_act()

/obj/structure/flora/roguegrass/Initialize()
	update_icon()
	AddComponent(/datum/component/roguegrass)
	. = ..()

/obj/structure/flora/roguegrass/update_icon()
	icon_state = "grass[rand(1, 6)]"

/obj/structure/flora/roguegrass/water
	name = "grass"
	desc = "This grass is sodden and muddy."
	icon_state = "swampgrass"
	max_integrity = 5

/obj/structure/flora/roguegrass/water/reeds
	name = "reeds"
	desc = "This plant thrives in water, and shelters dangers."
	icon_state = "reeds"
	opacity = 1
	max_integrity = 10
	layer = 4.1
	blade_dulling = DULLING_CUT

/obj/structure/flora/roguegrass/water/update_icon()
	dir = pick(GLOB.cardinals)

/datum/component/roguegrass/Initialize()
	RegisterSignal(parent, list(COMSIG_MOVABLE_CROSSED), PROC_REF(Crossed))

/datum/component/roguegrass/proc/Crossed(datum/source, atom/movable/AM)
	var/atom/A = parent

	if(isliving(AM))
		var/mob/living/L = AM
		if(L.is_flying()) //you won't rustle things if you're flying above them
			return
		if(L.m_intent == MOVE_INTENT_SNEAK)
			return
		else
			if(!(HAS_TRAIT(L, TRAIT_AZURENATIVE) && L.m_intent != MOVE_INTENT_RUN))
				playsound(A.loc, "plantcross", 100, FALSE, -1)
			var/oldx = A.pixel_x
			animate(A, pixel_x = oldx+1, time = 0.5)
			animate(pixel_x = oldx-1, time = 0.5)
			animate(pixel_x = oldx, time = 0.5)
			L.consider_ambush()
	return


/obj/structure/flora/roguegrass/bush
	name = "bush"
	desc = "A bush. It's crawling with spiders, but maybe there’s something useful inside..."
	icon_state = "bush2"
	layer = ABOVE_ALL_MOB_LAYER
	var/res_replenish
	blade_dulling = DULLING_CUT
	max_integrity = 35
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1)
	var/list/looty = list()
	var/bushtype

/obj/structure/flora/roguegrass/bush/Initialize()
	if(prob(88) && isnull(bushtype))
		bushtype = pickweight(list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue=5,
					/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison=3,
					/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed=1))
	loot_replenish()
	pixel_x += rand(-3,3)
	return ..()

/obj/structure/flora/roguegrass/bush/proc/loot_replenish()
	if(bushtype)
		looty += bushtype
	if(prob(66))
		looty += /obj/item/natural/thorn
	looty += /obj/item/natural/fibers


/obj/structure/flora/roguegrass/bush/Crossed(atom/movable/AM)
	..()
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.m_intent == MOVE_INTENT_RUN && (L.mobility_flags & MOBILITY_STAND))
			if(!ishuman(L))
				to_chat(L, span_warning("I'm cut on a thorn!"))
				L.apply_damage(5, BRUTE)

			else
				var/mob/living/carbon/human/H = L
				if(prob(20))
					if(!HAS_TRAIT(src, TRAIT_PIERCEIMMUNE))
//						H.throw_alert("embeddedobject", /atom/movable/screen/alert/embeddedobject)
						var/obj/item/bodypart/BP = pick(H.bodyparts)
						var/obj/item/natural/thorn/TH = new(src.loc)
						BP.add_embedded_object(TH, silent = TRUE)
						BP.receive_damage(10)
						to_chat(H, span_danger("\A [TH] impales my [BP.name]!"))
				else
					var/obj/item/bodypart/BP = pick(H.bodyparts)
					to_chat(H, span_warning("A thorn [pick("slices","cuts","nicks")] my [BP.name]."))
					BP.receive_damage(10)

/obj/structure/flora/roguegrass/bush/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 50, FALSE, -1)
		if(do_after(L, SEARCHTIME, target = src))
			if(!looty.len && (world.time > res_replenish))
				loot_replenish()
			if(prob(50) && looty.len)
				if(looty.len == 1)
					res_replenish = world.time + 8 MINUTES
				var/obj/item/B = pick_n_take(looty)
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message(span_notice("[user] finds [B] in [src]."))
					return
			user.visible_message(span_warning("[user] searches through [src]."))
			if(looty.len)
				attack_hand(user)
			if(!looty.len)
				to_chat(user, span_warning("Picked clean... I should try later."))
/obj/structure/flora/roguegrass/bush/update_icon()
	icon_state = "bush[rand(2, 4)]"

/obj/structure/flora/roguegrass/bush/CanAStarPass(ID, travel_dir, caller)
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		if(mover.pass_flags & PASSGRILLE)
			return TRUE
	if(travel_dir == dir)
		return FALSE // just don't even try, not even if you can climb it
	return ..()

/obj/structure/flora/roguegrass/bush/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGRILLE))
		return 1
	if(get_dir(loc, target) == dir)
		return 0
	return 1

/obj/structure/flora/roguegrass/bush/westleach
	name = "westleach bush"
	desc = "Large, red leaves peek out of it with an alluring aroma."
	icon_state = "bush1"

/obj/structure/flora/roguegrass/bush/westleach/update_icon()
	return

/obj/structure/flora/roguegrass/bush/westleach/loot_replenish()
	. = ..()
	if(prob(50))
		looty += /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed

/obj/structure/flora/roguegrass/bush/westleach/Initialize()
	bushtype = /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed
	return ..()

/obj/structure/flora/roguegrass/bush/wall
	name = "great bush"
	desc = "A bush. This one’s roots are thick enough to block the way."
	opacity = TRUE
	density = TRUE
	climbable = FALSE
	icon_state = "bushwall1"
	max_integrity = 150
	debris = list(/obj/item/natural/fibers = 1, /obj/item/grown/log/tree/stick = 1, /obj/item/natural/thorn = 1)
	attacked_sound = 'sound/misc/woodhit.ogg'

/obj/structure/flora/roguegrass/bush/wall/Initialize()
	. = ..()
	icon_state = "bushwall[pick(1,2)]"

/obj/structure/flora/roguegrass/bush/wall/update_icon()
	return

/obj/structure/flora/roguegrass/bush/wall/tall
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "tallbush1"
	opacity = 1
	pixel_x = -16
	debris = null
	static_debris = null

/obj/structure/flora/roguegrass/bush/wall/tall/Initialize()
	. = ..()
	icon_state = "tallbush[pick(1,2)]"


/obj/structure/flora/rogueshroom
	name = "mushroom"
	desc = "Mushrooms are the only happy beings in this land."
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	icon_state = "mush1"
	opacity = 0
	density = 0
	max_integrity = 120
	blade_dulling = DULLING_CUT
	pixel_x = -16
	layer = 4.81
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/treefall.ogg'
	static_debris = list( /obj/item/grown/log/tree/small = 1)
	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER
	dir = SOUTH
	var/random_mush_zone = TRUE

/obj/structure/flora/rogueshroom/attack_right(mob/user)
	handle_special_items_retrieval(user, src)

/obj/structure/flora/rogueshroom/Initialize()
	. = ..()
	if(random_mush_zone)
		icon_state = "mush[rand(1,5)]"
	if(icon_state == "mush5")
		static_debris = list(/obj/item/natural/thorn=1, /obj/item/grown/log/tree/small = 1)
	pixel_x += rand(8,-8)
	var/static/list/loc_connections = list(COMSIG_ATOM_EXIT = PROC_REF(on_exit))
	AddElement(/datum/element/connect_loc, loc_connections)

/obj/structure/flora/rogueshroom/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSGRILLE))
		return 1
	if(get_dir(loc, target) == dir)
		return 0
	return 1

/obj/structure/flora/rogueshroom/CanAStarPass(ID, travel_dir, caller)
	if(ismovableatom(caller))
		var/atom/movable/mover = caller
		if(mover.pass_flags & PASSGRILLE)
			return TRUE
	if(travel_dir == dir)
		return FALSE // just don't even try, not even if you can climb it
	return ..()

/obj/structure/flora/rogueshroom/proc/on_exit(datum/source, atom/movable/leaving, atom/new_location)
	SIGNAL_HANDLER
	if(get_dir(leaving.loc, new_location) == dir)
		leaving.Bump(src)
		return COMPONENT_ATOM_BLOCK_EXIT

/obj/structure/flora/rogueshroom/fire_act(added, maxstacks)
	if(added <= 5)
		return
	return ..()

/obj/structure/flora/rogueshroom/obj_destruction(damage_flag)
	new /obj/structure/flora/shroomstump(loc, initial(icon_state), icon)
	. = ..()


/obj/structure/flora/shroomstump
	name = "shroom stump"
	desc = "It was a very happy shroom. Not anymore."
	icon_state = "mush1stump"
	opacity = 0
	max_integrity = 100
	climbable = TRUE
	climb_time = 0
	density = TRUE
	icon = 'icons/roguetown/misc/foliagetall.dmi'
	plane = GAME_PLANE
	layer = TABLE_LAYER
	blade_dulling = DULLING_CUT
	static_debris = null
	debris = null
	alpha = 255
	pixel_x = -16
	climb_offset = 14
	attacked_sound = 'sound/misc/woodhit.ogg'
	destroy_sound = 'sound/misc/treefall.ogg'

/obj/structure/flora/shroomstump/Initialize(mapload, new_icon_state, new_icon)
	. = ..()
	if(new_icon)
		icon = new_icon
	if(new_icon_state)
		icon_state = "[new_icon_state]stump"

/obj/structure/roguerock
	name = "rock"
	desc = "A rock protuding from the ground."
	icon_state = "rock1"
	icon = 'icons/roguetown/misc/foliage.dmi'
	opacity = 0
	max_integrity = 50
	climbable = TRUE
	climb_time = 30
	density = TRUE
	layer = TABLE_LAYER
	blade_dulling = DULLING_BASH
	static_debris = null
	debris = null
	alpha = 255
	climb_offset = 14
	destroy_sound = 'sound/foley/smash_rock.ogg'
	attacked_sound = 'sound/foley/hit_rock.ogg'
	static_debris = list(/obj/item/natural/stone = 1)

/obj/structure/roguerock/Initialize()
	. = ..()
	icon_state = "rock[rand(1,4)]"

//Thorn bush

/obj/structure/flora/roguegrass/thorn_bush
	name = "thorn bush"
	desc = "A thorny bush. Watch your step!"
	icon_state = "thornbush"
	layer = ABOVE_ALL_MOB_LAYER
	blade_dulling = DULLING_CUT
	max_integrity = 35
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/thorn = 3, /obj/item/grown/log/tree/stick = 1)

/obj/structure/flora/roguegrass/thorn_bush/update_icon()
	icon_state = "thornbush"
//WIP

// fyrituis bush -- STONEKEEP PORT
/obj/structure/flora/roguegrass/pyroclasticflowers
	name = "odd group of flowers"
	desc = "A cluster of dangerously combustible flowers."
	icon_state = "pyroflower1"
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 1
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/fibers = 1)
	max_integrity = 9999 // From base 1. So antag don't get to destroy it easily :).
	var/list/looty = list()
	var/bushtype
	var/res_replenish

/obj/structure/flora/roguegrass/pyroclasticflowers/update_icon()
	icon_state = "pyroflower[rand(1,3)]"

/obj/structure/flora/roguegrass/pyroclasticflowers/Initialize()
	. = ..()
	if(prob(88))
		bushtype = pickweight(list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1))
	loot_replenish2()
	pixel_x += rand(-3,3)

/obj/structure/flora/roguegrass/pyroclasticflowers/proc/loot_replenish2()
	if(bushtype)
		looty += bushtype
	if(prob(66))
		looty += /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius

// pyroflower cluster looting
/obj/structure/flora/roguegrass/pyroclasticflowers/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 80, FALSE, -1)
		if(do_after(L, SEARCHTIME, target = src))
			if(!looty.len && (world.time > res_replenish))
				loot_replenish2()
			if(prob(50) && looty.len)
				if(looty.len == 1)
					res_replenish = world.time + 8 MINUTES
				var/obj/item/B = pick_n_take(looty)
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message("<span class='notice'>[user] finds [B] in [src].</span>")
					return
			user.visible_message("<span class='warning'>[user] searches through [src].</span>")
			if(!looty.len)
				to_chat(user, "<span class='warning'>Picked clean... I should try later.</span>")

// swarmpweed bush -- STONEKEEP PORT
/obj/structure/flora/roguegrass/swampweed
	name = "bunch of swampweed"
	desc = "A green root known to, when smoked, elicit a strong euphoric response. A common alternative to alcohol \
	for those who wish to escape their woes, or to simply have an enjoyable evening."
	icon_state = "swampweed1"
	layer = ABOVE_ALL_MOB_LAYER
	max_integrity = 1
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/fibers = 1)
	var/list/looty = list()
	var/bushtype
	var/res_replenish

/obj/structure/flora/roguegrass/swampweed/Initialize()
	. = ..()
	icon_state = "swampweed[rand(1,3)]"
	if(prob(88))
		bushtype = pickweight(list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1))
	loot_replenish3()
	pixel_x += rand(-3,3)

/obj/structure/flora/roguegrass/swampweed/proc/loot_replenish3()
	if(bushtype)
		looty += bushtype
	if(prob(66))
		looty += /obj/item/reagent_containers/food/snacks/grown/rogue/swampweed

/obj/structure/flora/roguegrass/swampweed/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 80, FALSE, -1)
		if(do_after(L, SEARCHTIME, target = src))
			if(!looty.len && (world.time > res_replenish))
				loot_replenish3()
			if(prob(50) && looty.len)
				if(looty.len == 1)
					res_replenish = world.time + 8 MINUTES
				var/obj/item/B = pick_n_take(looty)
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					if(HAS_TRAIT(user, TRAIT_WOODWALKER))
						var/obj/item/C = new B.type(user.loc)
						user.put_in_hands(C)
					user.visible_message("<span class='notice'>[user] finds [HAS_TRAIT(user, TRAIT_WOODWALKER) ? "two of " : ""][B] in [src].</span>")
					return
			user.visible_message("<span class='warning'>[user] searches through [src].</span>")
			if(!looty.len)
				to_chat(user, "<span class='warning'>Picked clean... I should try later.</span>")

/obj/structure/flora/roguegrass/pumpkin
	name = "bunch of wild pumpkins"
	desc = "Wild pumpkins overgrown with vines."
	icon_state = "pumpkin1"
	max_integrity = 1
	climbable = FALSE
	dir = SOUTH
	debris = list(/obj/item/natural/fibers = 2)
	var/list/looty = list(/obj/item/natural/shellplant/pumpkin, /obj/item/natural/fibers)

/obj/structure/flora/roguegrass/pumpkin/Initialize()
	. = ..()
	icon_state = "pumpkin[rand(1,2)]"
	if(prob(78))
		looty += /obj/item/natural/shellplant/pumpkin
	if(prob(32))
		looty += /obj/item/natural/shellplant/pumpkin
	if(prob(24))
		looty += /obj/item/natural/fibers
	if(prob(7))
		looty += /obj/item/natural/shellplant/pumpkin
	pixel_x += rand(-3,3)
	pixel_y += rand(0,6)

/obj/structure/flora/roguegrass/pumpkin/attack_hand(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		user.changeNext_move(CLICK_CD_INTENTCAP)
		playsound(src.loc, "plantcross", 80, FALSE, -1)
		if(do_after(L, SEARCHTIME, target = src))
			if(looty.len && prob(75))
				var/obj/item/B = pick_n_take(looty)
				if(B)
					B = new B(user.loc)
					user.put_in_hands(B)
					user.visible_message("<span class='notice'>[user] finds [B] in [src].</span>")
					if(!looty.len)
						to_chat(user, "<span class='warning'>There is nothing else to find.</span>")
						qdel(src)
					return
			user.visible_message("<span class='warning'>[user] searches through [src].</span>")

// cute underdark mushrooms from dreamkeep
// now with some scary mushrooms to rectify sins against pixelart

/obj/structure/flora/rogueshroom/happy
	name = "corpse fungus"
	icon_state = "scarymush"
	icon = 'icons/roguetown/misc/foliagemushroom48x64.dmi'
	desc = "This mushroom looks alive and thinking, giving you mush to think about."
	random_mush_zone = FALSE
	max_integrity = 240
	pixel_x = -8
	var/mush_light_range = 3
	var/mush_light_power = 3
	var/mush_light_color = "#850707"
	var/int_req = 14
	var/trait_required = TRAIT_WOODSMAN
	var/special_examine = "Upon closer inspection, the pulsing rhythm of its cap matches a humen heartbeat. You recall these grow atop corpses, mimicing the cadence of that specific person."
	var/list/abyssal_screams = list(
		'sound/mobs/abyssal/abyssal_attack.ogg',
		'sound/mobs/abyssal/abyssal_attack2.ogg',
		'sound/mobs/abyssal/abyssal_aggro.ogg',
		'sound/mobs/abyssal/abyssal_pain.ogg',
		'sound/mobs/abyssal/abyssal_teleport.ogg',
		'sound/misc/murderbeast.ogg'
	)
	static_debris = list(/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 1)
	var/rare_mush_bonus_drop = /obj/item/reagent_containers/powder/ozium
	var/mush_animate = TRUE
	var/mush_scream = TRUE

/obj/structure/flora/rogueshroom/happy/Initialize()
	. = ..()
	if(mush_animate)
		animate(src, icon_state = "[icon_state]animated", delay = rand(1, 100), loop = -1, time = 10)

/obj/structure/flora/rogueshroom/happy/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir)
	. = ..()
	if(damage_amount > 0 && mush_scream)
		playsound(src, pick(abyssal_screams), 80, FALSE)

/obj/structure/flora/rogueshroom/happy/obj_destruction(damage_flag)
	playsound(src, pick(abyssal_screams), 100, FALSE)
	if(prob(7) && rare_mush_bonus_drop)
		new rare_mush_bonus_drop(loc)
	. = ..()

/obj/structure/flora/rogueshroom/happy/examine(mob/living/user)
	. = ..()
	if(user.STAINT >= int_req && int_req || HAS_TRAIT(user, TRAIT_WOODSMAN))
		. += span_infection("\n[special_examine]")

/obj/structure/flora/rogueshroom/happy/white
	name = "marrow-cap"
	icon_state = "scarymush1"
	desc = "You swear these mushrooms weren't so vile, it's as if Baotha herself lifted the veil."
	mush_light_range = 4
	mush_light_power = 2
	mush_light_color = "#e2e2e2"
	int_req = 0
	special_examine = "You recall the gathering of wildsmasters recently. It hasn't been long, but these mushrooms were always believed to be happy and colorful. The spores of this one are rumoured to be the cause, it's like... they collectively made a decision top stop fooling humenkind."
	static_debris = list(/obj/item/natural/fibers = 1,
						 /obj/item/grown/log/tree/small = 1)
	rare_mush_bonus_drop = /mob/living/simple_animal/hostile/rogue/mirespider_lurker/mushroom
	mush_animate = FALSE

/obj/structure/flora/rogueshroom/happy/fat
	name = "canker stool"
	icon_state = "scarymush2"
	desc = "A pale mushroom with weeping sores. You feel strangely watched."
	mush_light_range = 0
	mush_light_power = 0
	mush_light_color = null
	int_req = 20
	max_integrity = 480
	special_examine = "To the world of academics, it appears as if this mushroom has many eyes, one in each sore. Yet, upon dissection, it is as if the eyes have melted away."
	static_debris = list(/obj/item/grown/log/tree = 1)
	rare_mush_bonus_drop = /obj/item/rogueore/iron
	mush_animate = TRUE

/obj/structure/flora/rogueshroom/happy/angel
	name = "grieving angel"
	icon_state = "angelmush"
	desc = "each of these mushrooms is believed to have sprouted out of angel tears in the long past"
	mush_light_range = 3
	mush_light_power = 3
	mush_light_color = "#e2e2e2"
	int_req = 10
	special_examine = "This mushroom has an identical appearance to a highly murderous mushroom, called the weeping angel, but luckily that one isn't native to Azure."
	static_debris = null
	mush_animate = FALSE

/obj/structure/flora/rogueshroom/happy/random

/obj/structure/flora/rogueshroom/happy/random/Initialize()
	. = ..()
	var/list/mushroom_types = list(
		/obj/structure/flora/rogueshroom/happy       = 2499,
		/obj/structure/flora/rogueshroom/happy/white = 2499,
		/obj/structure/flora/rogueshroom/happy/fat   = 2499,
		/obj/structure/flora/rogueshroom/happy/angel = 2499,
		/obj/structure/flora/rogueshroom/happy/metal = 1,
	)
	var/mushroom_type = pickweight(mushroom_types)
	new mushroom_type(loc)
	qdel(src)

/obj/structure/flora/rogueshroom/happy/New(loc)
	..()
	if(mush_light_power > 0)
		set_light(mush_light_range, mush_light_range, mush_light_power, l_color = mush_light_color)

/obj/structure/flora/rogueshroom/happy/metal
	name = "metallic mushroom"
	icon_state = "metal"
	icon = 'icons/roguetown/misc/foliagemushroom60x64.dmi'
	desc = "An incomprehensible metal mushroom. It has a strange sheen. It seems nigh indestructible, but stubbornness can fell anything."
	max_integrity = 3250
	pixel_x = -14
	blade_dulling = DULLING_PICK
	special_examine = "Huh, strange."
	mush_light_range = 0
	mush_light_power = 0
	mush_light_color = null
	int_req = 20
	mush_animate = FALSE
	static_debris = list(/obj/item/rogueore/lithmyc = 1)
	mush_scream = FALSE

/obj/structure/flora/mushroomcluster
	name = "mushroom cluster"
	desc = "A cluster of mushrooms native to the underdark."
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "mushroomcluster"
	density = TRUE

/obj/structure/flora/mushroomcluster/cute
	desc = "A large cluster of mushrooms with a strange glow."
	icon_state = "mushroomcluster_old"

/obj/structure/flora/mushroomcluster/New(loc)
	..()
	set_light(1.5, 1.5, 1.5, l_color ="#5D3FD3")

/obj/structure/flora/tinymushrooms
	name = "small mushroom cluster"
	desc = "A cluster of tiny mushrooms native to the underdark."
	icon = 'icons/roguetown/misc/foliage.dmi'
	icon_state = "tinymushrooms"

/obj/structure/flora/tinymushrooms/cute
	desc = "A cluster of tiny mushrooms that are growing in a suspicious circle shape."
	icon_state = "tinymushrooms_old"

/obj/structure/flora/roguetree/pine
	name = "pine tree"
	icon_state = "pine1"
	desc = "A mighty conifer tree, standing proud. A familiar sight in cold and mountainous climates, \
	and highly sought after for their resin."
	icon = 'icons/obj/flora/pines.dmi'
	pixel_w = -24
	density = 0
	max_integrity = 100
	static_debris = list(/obj/item/grown/log/tree = 2)
	stump_type = null

/obj/structure/flora/roguetree/pine/Initialize()
	. = ..()
	icon_state = "pine[rand(1, 4)]"

/obj/structure/flora/roguetree/pine/burn()
	new /obj/structure/flora/roguetree/pine/dead(get_turf(src))
	qdel(src)

/obj/structure/flora/roguetree/pine/dead
	name = "burnt pine tree"
	desc = "Charred bark and ashen needles."
	icon_state = "dead1"
	max_integrity = 50
	static_debris = list(/obj/item/rogueore/coal/charcoal = 1)
	resistance_flags = FIRE_PROOF
	stump_type = /obj/structure/flora/roguetree/stump/pine

/obj/structure/flora/roguetree/pine/dead/Initialize()
	. = ..()
	icon_state = "dead[rand(1, 3)]"

#undef SEARCHTIME
