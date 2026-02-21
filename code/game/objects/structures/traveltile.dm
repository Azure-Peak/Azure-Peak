
/obj/structure/fluff/testportal
	name = "portal"
	icon_state = "shitportal"
	icon = 'icons/roguetown/misc/structure.dmi'
	density = FALSE
	anchored = TRUE
	layer = BELOW_MOB_LAYER
	max_integrity = 0
	var/aportalloc = "a"

/obj/structure/fluff/testportal/Initialize()
	name = aportalloc
	..()

/obj/structure/fluff/testportal/attack_hand(mob/user)
	var/fou
	for(var/obj/structure/fluff/testportal/T in shuffle(GLOB.testportals))
		if(T.aportalloc == aportalloc)
			if(T == src)
				continue
			to_chat(user, "<b>I teleport to [T].</b>")
			playsound(src, 'sound/misc/portal_enter.ogg', 100, TRUE)
			user.forceMove(T.loc)
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>There is no portal connected to this. Report it as a bugs.</b>")
	. = ..()


/obj/structure/fluff/traveltile
	name = "travel"
	icon_state = "travel"
	icon = 'icons/turf/roguefloor.dmi'
	density = FALSE
	anchored = TRUE
	layer = ABOVE_OPEN_TURF_LAYER
	max_integrity = 0
	var/aportalid = "REPLACETHIS"
	var/aportalgoesto = "REPLACETHIS"
	var/aallmig
	var/required_trait = null
	var/list/required_jobs = null
	var/travel_time = 5 SECONDS
	var/travel_message = "I begin to travel..."
	var/travel_deny_message = "It is a dead end."
	var/travel_access_hint = null
	var/watchable = TRUE

/obj/structure/fluff/traveltile/Initialize()
	GLOB.traveltiles += src
	. = ..()

/obj/structure/fluff/traveltile/Destroy()
	GLOB.traveltiles -= src
	. = ..()

/obj/structure/fluff/traveltile/proc/return_connected_turfs()
	if(!aportalgoesto)
		return list()

	var/list/travels = list()
	for(var/obj/structure/fluff/traveltile/travel in shuffle(GLOB.traveltiles))
		if(travel == src)
			continue
		if(travel.aportalid != aportalgoesto)
			continue
		travels |= get_turf(travel)
	return travels

/obj/structure/fluff/traveltile/attack_ghost(mob/dead/observer/user)
	if(!aportalgoesto)
		return
	var/fou
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			user.forceMove(T.loc)
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>It is a dead end.</b>")

/atom/movable
	var/recent_travel = 0

/obj/structure/fluff/traveltile/attack_hand(mob/user)
	var/fou
	if(!aportalgoesto)
		return
	if(!isliving(user))
		return
	var/mob/living/L = user
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			if(!try_living_travel(T, L))
				return
			fou = TRUE
			break
	if(!fou)
		to_chat(user, "<b>It is a dead end.</b>")
	. = ..()

/obj/structure/fluff/traveltile/Crossed(atom/movable/AM)
	. = ..()
	var/fou
	if(!aportalgoesto)
		return
	if(!isliving(AM))
		return
	var/mob/living/L = AM
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			if(!try_living_travel(T, L))
				return
			fou = TRUE
			break
	if(!fou)
		to_chat(AM, "<b>It is a dead end.</b>")

/obj/structure/fluff/traveltile/proc/try_living_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	if(!can_go(L))
		return FALSE
	if(L.pulledby)
		return FALSE
	to_chat(L, "<b>[travel_message]</b>")
	if(do_after(L, travel_time, needhand = FALSE, target = src))
		if(L.pulledby)
			to_chat(L, span_warning("I can't go, something's holding onto me."))
			return FALSE
		perform_travel(T, L)
		return TRUE
	return FALSE

/obj/structure/fluff/traveltile/proc/perform_travel(obj/structure/fluff/traveltile/T, mob/living/L)
	if(watchable && !L.restrained(ignore_grab = TRUE)) // heavy-handedly prevents using prisoners to metagame camp locations. pulledby would stop this but prisoners can also be kicked/thrown into the tile repeatedly
		for(var/mob/living/carbon/human/H in hearers(6,src))
			if(H == L)
				continue
			if(!H.IsUnconscious() && H.stat == CONSCIOUS && !HAS_TRAIT(H, TRAIT_PARALYSIS) && !HAS_TRAIT(H, required_trait) && !HAS_TRAIT(H, TRAIT_BLIND))
				to_chat(H, "<b>I watch [L.name? L : "someone"] go through a well-hidden entrance.</b>")
				if(!(H.m_intent == MOVE_INTENT_SNEAK))
					to_chat(L, "<b>[H.name ? H : "Someone"] watches me pass through the entrance.</b>")
				ADD_TRAIT(H, required_trait, TRAIT_GENERIC)

	var/atom/movable/pullingg = L.pulling

	L.recent_travel = world.time
	if(pullingg)
		pullingg.recent_travel = world.time
		pullingg.forceMove(T.loc)

	L.forceMove(T.loc)

	if(pullingg)
		L.start_pulling(pullingg, supress_message = TRUE)

	return

/obj/structure/fluff/traveltile/proc/has_access(atom/movable/AM)
	if(required_jobs && ishuman(AM))
		var/mob/living/carbon/human/H = AM
		return (H.job in required_jobs)
	if(required_trait && isliving(AM))
		return HAS_TRAIT(AM, required_trait)
	return TRUE

/obj/structure/fluff/traveltile/proc/can_go(atom/movable/AM)
	if(AM.recent_travel)
		if(world.time < AM.recent_travel + 15 SECONDS)
			return FALSE
	if(!has_access(AM))
		to_chat(AM, "<b>[travel_deny_message]</b>")
		return FALSE
	if(isliving(AM))
		var/mob/living/L = AM
		if(world.time > L.last_client_interact + 0.3 SECONDS)
			return FALSE
	return TRUE

/obj/structure/fluff/traveltile/examine(mob/user)
	. = ..()
	if(travel_access_hint && has_access(user))
		. += span_info(travel_access_hint)

/obj/structure/fluff/traveltile/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Shift-right-click to peer through to the other side.")

/obj/structure/fluff/traveltile/ShiftRightClick(mob/user)
	if(!isliving(user))
		return FALSE
	var/mob/living/L = user
	if(!L.client)
		return TRUE
	if(L.client.perspective != MOB_PERSPECTIVE)
		L.stop_looking()
		return TRUE
	if(!L.can_look_up())
		return TRUE
	if(!can_go(L))
		return TRUE
	var/list/destinations = return_connected_turfs()
	if(!length(destinations))
		to_chat(L, "<b>It is a dead end.</b>")
		return TRUE
	var/turf/destination = destinations[1]
	if(L.m_intent != MOVE_INTENT_SNEAK)
		L.visible_message(span_info("[L] peers through [src]."))
	var/ttime = 10
	if(L.STAPER > 5)
		ttime = 10 - (L.STAPER - 5)
		if(ttime < 0)
			ttime = 0
	if(!do_after(L, ttime, target = src))
		return TRUE
	L.reset_perspective(destination)
	L.update_cone_show()
	return TRUE

/obj/structure/fluff/traveltile/bandit
	required_trait = TRAIT_BANDITCAMP
/obj/structure/fluff/traveltile/vampire
	required_trait = TRAIT_VAMPMANSION
/obj/structure/fluff/traveltile/wretch
	required_trait = TRAIT_ZURCH //I'd tie this to trait_outlaw but unfortunately the heresiarch virtue exists so we're making a new trait instead.
/obj/structure/fluff/traveltile/drow
	required_trait = TRAIT_CAVEDWELLER	
/obj/structure/fluff/traveltile/dungeon
	name = "gate"
	desc = "This gate's enveloping darkness is so opressive you dread to step through it."
	icon = 'icons/roguetown/misc/portal.dmi'
	icon_state = "portal"
	density = FALSE
	anchored = TRUE
	max_integrity = 0
	bound_width = 96
	appearance_flags = NONE
	opacity = FALSE

/obj/structure/fluff/traveltile/eventarea

/obj/structure/fluff/traveltile/eventarea/multiz
	aportalgoesto = "MultizEventOut"
	aportalid = "MultizEventIn"

/obj/structure/fluff/traveltile/bathhouse_passage
	name = "suspicious passage"
	desc = "A crevice in the wall. It looks like it leads somewhere."
	required_trait = "bathhouse_passage_seen"
	required_jobs = list("Bathmaster", "Bathhouse Attendant")
	travel_time = 30 SECONDS // If there's an active chase you basically cannot use it to escape quickly
	travel_message = "I begin to squeeze through the passage..."
	travel_deny_message = "You're not supple enough to use this passage."
	watchable = FALSE
	travel_access_hint = "A tight passage that leads between the bathhouse and the northern coast, with many twists and turns - only a bathhouse staff member can fit through it. It takes a while to travel through, and is a popular route for smuggling goods in and out of town."
