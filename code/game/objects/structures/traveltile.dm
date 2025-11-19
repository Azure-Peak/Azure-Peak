
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
//  var/last_client_interact = 0  // See mob_defines.dm.

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
	if(istype(L, /mob/living/carbon/human/species/human/northern/grunt))
		return FALSE
	if(!can_go(L))
		return FALSE
	if(L.pulledby)
		return FALSE
	to_chat(L, "<b>I begin to travel...</b>")
	if(do_after(L, 50, needhand = FALSE, target = src))
		if(L.pulledby)
			to_chat(L, span_warning("I can't go, something's holding onto me."))
			return FALSE
		perform_travel(T, L)
		return TRUE
	return FALSE

/obj/structure/fluff/traveltile/proc/perform_travel(obj/structure/fluff/traveltile/T, mob/living/carbon/human/L)
	var/list/friends_to_teleport = list()
	if(!L.restrained(ignore_grab = TRUE)) // heavy-handedly prevents using prisoners to metagame camp locations. pulledby would stop this but prisoners can also be kicked/thrown into the tile repeatedly
		for(var/mob/living/carbon/human/H in hearers(6,src))
			if(!HAS_TRAIT(H, required_trait) && !HAS_TRAIT(H, TRAIT_BLIND))
				to_chat(H, "<b>I watch [L.name? L : "someone"] go through a well-hidden entrance.</b>")
				if(!(H.m_intent == MOVE_INTENT_SNEAK))
					to_chat(L, "<b>[H.name ? H : "Someone"] watches me pass through the entrance.</b>")
				ADD_TRAIT(H, required_trait, TRAIT_GENERIC)
			if(H in L.friends)
				friends_to_teleport += H

	var/atom/movable/pullingg = L.pulling

	L.recent_travel = world.time
	if(pullingg)
		pullingg.recent_travel = world.time
		pullingg.forceMove(T.loc)

	L.forceMove(T.loc)

	if(pullingg)
		L.start_pulling(pullingg, supress_message = TRUE)

	for(var/mob/living/carbon/human/npc in friends_to_teleport)
		if(npc.stat != DEAD)
			npc.forceMove(T.loc)


	return

/obj/structure/fluff/traveltile/proc/can_go(atom/movable/AM)
	. = TRUE
	if(AM.recent_travel)
		if(world.time < AM.recent_travel + 15 SECONDS)
			. = FALSE
	if(. && required_trait && isliving(AM))
		var/mob/living/L = AM
		if(HAS_TRAIT(L, required_trait))
			if(world.time > L.last_client_interact + 0.3 SECONDS)
				return FALSE // we will only be travelling of our own volition (anti-afk-abuse)
			return TRUE
		else
			to_chat(L, "<b>It is a dead end.</b>")
			return FALSE

/obj/structure/fluff/traveltile/bandit
	required_trait = TRAIT_BANDITCAMP
/obj/structure/fluff/traveltile/vampire
	required_trait = TRAIT_VAMPMANSION
/obj/structure/fluff/traveltile/wretch
	required_trait = TRAIT_ZURCH //I'd tie this to trait_outlaw but unfortunately the heresiarch virtue exists so we're making a new trait instead.
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

/obj/structure/fluff/traveltile/warband
	name = "travel"
	var/warband_ID = 0
	var/atom/movable/screen/warband/manager/linked_warband

/obj/structure/fluff/traveltile/warband/Initialize()
	..()
	SSwarbands.warband_machines += src
	src.color = null	// different colors in the editor for visual clarity, but they should appear normal in game

/obj/structure/fluff/traveltile/warband/azure_to_intermission

/obj/structure/fluff/traveltile/warband/intermission_to_azure
	color = "#a32121"

/obj/structure/fluff/traveltile/warband/intermission_to_outskirts
	color = "#ff8b2c"


/obj/structure/fluff/traveltile/warband/outskirts_to_intermission
	color = "#28d2d8"

/obj/structure/fluff/traveltile/warband/outskirts_to_camp
	color = "#6135ff"

/obj/structure/fluff/traveltile/warband/camp_to_outskirts
	color = "#ff35f5"
	var/locked = TRUE
	var/obj/effect/landmark/chosen_landmark




/obj/structure/fluff/traveltile/warband/camp_to_outskirts/attack_hand(mob/user)
	. = ..()
	if(linked_warband.outskirts_established)
		return
	else
		if(user.mind.special_role == "Warlord's Envoy")
			var/readycheck = input(user, "The road ahead could be dangerous, and I won't be able to return immediately. I should recall any essentials in my MEMORIES.") in list("I am ready", "Cancel")
			if(readycheck == "I am ready")
				if(chosen_landmark)
					to_chat(user, span_warning("The Rot prevented a simple walk down Azuria's main road. This is the safest route from my Warcamp."))
					to_chat(user, span_warning("Before I decide to return, I should SCOUT A PATH."))
					user.loc = src.chosen_landmark.loc
					user.visible_message(span_bold("[user] emerges from a hidden path!"))
					return
		if(user.mind.warband_ID != src.warband_ID) // if they don't match the warband ID, we assume they rebelled VERY early into the round (for some reason) and just let them leave
			if(chosen_landmark)
				user.loc = src.chosen_landmark.loc
				return

