GLOBAL_LIST_EMPTY(biggates)

/obj/structure/gate
	name = "gate"
	desc = "A strong steel gate decorated ornately with vivid images. Something important \
	must be behind it."
	icon = 'icons/roguetown/misc/gate.dmi'
	icon_state = "gate1"
	density = TRUE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	max_integrity = 5000
	bound_width = 96
	appearance_flags = NONE
	opacity = TRUE
	var/base_state = "gate"
	var/isSwitchingStates = FALSE
	var/list/turfsy = list()
	var/list/blockers = list()
	var/gid
	attacked_sound = list('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/sheet (2).ogg')
	var/obj/structure/attached_to

/obj/structure/gate/preopen
	icon_state = "gate0"

/obj/structure/gate/preopen/Initialize()
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(open))

/obj/structure/gate/bars
	desc = "A large portculis, designed to close vertically and to be extremely difficult to break \
	through. When you aren't sure if you'll win a fight, try putting three inches of steel \
	between you and your enemy."
	icon_state = "bar1"
	base_state = "bar"
	opacity = FALSE

/obj/structure/gate/bars/Initialize()
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(close))

/obj/structure/gate/bars/preopen
	icon_state = "bar0"

/obj/structure/gate/bars/preopen/Initialize()
	. = ..()
	INVOKE_ASYNC(src, PROC_REF(open))

/obj/gblock
	name = ""
	desc = ""
	icon = null
	density = TRUE
	mouse_opacity = 0
	opacity = TRUE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF

/obj/structure/gate/Initialize()
	. = ..()
	update_icon()
	var/turf/T = loc
	turfsy += T
	T = get_step(T, EAST)
	turfsy += T
	T = get_step(T, EAST)
	turfsy += T
	if(initial(opacity))
		for(var/turf/blocker_tile in turfsy)
			var/G = new /obj/gblock(blocker_tile)
			blockers += G
	GLOB.biggates += src

/obj/structure/gate/Destroy()
	for(var/A in blockers)
		qdel(A)
	if(attached_to)
		var/obj/structure/winch/W = attached_to
		W.attached_gate = null
	GLOB.biggates -= src
	..()

/obj/structure/gate/update_icon()
	cut_overlays()
	icon_state = "[base_state][density]"
	if(!density && !isSwitchingStates)
		add_overlay(mutable_appearance(icon, "[base_state]0_part", ABOVE_MOB_LAYER))
	else
		add_overlay(mutable_appearance(icon, "[base_state]1_part", ABOVE_MOB_LAYER))

/obj/structure/gate/proc/toggle()
	if(density)
		open()
	else
		close()

/obj/structure/gate/proc/open()
	if(isSwitchingStates || !density)
		return
	isSwitchingStates = TRUE
	playsound(src, 'sound/misc/gate.ogg', 100, extrarange = 5)
	flick("[base_state]_opening",src)
	layer = initial(layer)
	sleep(15)
	density = FALSE
	opacity = FALSE
	for(var/obj/gblock/B in blockers)
		B.opacity = FALSE
		B.density = FALSE
	isSwitchingStates = FALSE
	update_icon()


/obj/structure/gate/proc/close()
	if(isSwitchingStates || density)
		return
	isSwitchingStates = TRUE
	update_icon()
	layer = ABOVE_MOB_LAYER
	playsound(src, 'sound/misc/gate.ogg', 100, extrarange = 5)
	flick("[base_state]_closing",src)
	sleep(10)
	for(var/turf/T in turfsy)
		for(var/mob/living/L in T)
			var/def_zone = BODY_ZONE_CHEST
			if(iscarbon(L))
				var/mob/living/carbon/C = L
				if(C.mobility_flags & MOBILITY_STAND)
					def_zone = pick(BODY_ZONE_CHEST, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
				else
					def_zone = BODY_ZONE_HEAD
			var/obj/item/bodypart/BP = L.get_bodypart(def_zone)
			if(BP)
				L.visible_message(span_boldwarning("[src] comes crashing down on [L]'s [BP]!"), \
						span_userdanger("[src] crushes my [BP]!"))
				L.emote("agony")
				BP.add_wound(/datum/wound/fracture)
				BP.update_disabled()
				L.apply_damage(90, BRUTE, def_zone)
				L.Paralyze(80)
	density = initial(density)
	opacity = initial(opacity)
	layer = initial(layer)
	for(var/obj/gblock/B in blockers)
		B.opacity = TRUE
		B.density = TRUE
	isSwitchingStates = FALSE
	update_icon()

/obj/structure/winch
	name = "winch"
	desc = "A gatekeeper's only, and most important responsibility."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "winch"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	var/gid
	var/obj/structure/gate/attached_gate

/obj/structure/winch/Initialize()
	. = ..()
	return INITIALIZE_HINT_LATELOAD

/obj/structure/winch/Destroy()
	if(attached_gate)
		var/obj/structure/gate/W = attached_gate
		W.attached_to = null
	..()

/obj/structure/winch/LateInitialize()
	for(var/obj/structure/gate/G in GLOB.biggates)
		if(G.gid == gid)
			attached_gate = G
			G.attached_to = src

/obj/structure/winch/attack_hand(mob/user)
	. = ..()
	if(!attached_gate)
		to_chat(user, span_warning("The chain is not attached to anything."))
		return
	if(attached_gate.isSwitchingStates)
		return
	if(isliving(user))
		var/mob/living/L = user
		L.changeNext_move(CLICK_CD_INTENTCAP)
		var/used_time = 105 - (L.STASTR * 10)
		user.visible_message(span_warning("[user] cranks the winch."))
		playsound(src, 'sound/foley/winch.ogg', 100, extrarange = 3)
		if(do_after(user, used_time, target = user))
			attached_gate.toggle()

/obj/structure/gate/psy_vault
	name = "\improper HIS vault"
	redstone_id = "swamp_psy_dungeon_hour"
	max_integrity = 9999

/obj/structure/gate/psy_vault/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(open)), 1 HOURS)
