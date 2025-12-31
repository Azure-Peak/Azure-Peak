
/obj/structure/roguewindow
	name = "window"
	desc = "A glass window."
	icon = 'icons/roguetown/misc/roguewindow.dmi'
	icon_state = "window-solid"
	layer = TABLE_LAYER
	density = TRUE
	anchored = TRUE
	opacity = FALSE
	max_integrity = 200
	integrity_failure = 0.5
	var/base_state = "window-solid"
	var/lockdir = 0
	var/brokenstate = 0
	blade_dulling = DULLING_BASHCHOP
	pass_flags = LETPASSTHROW
	climb_time = 20
	climb_offset = 10
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	break_sound = "glassbreak"
	destroy_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'

/obj/structure/roguewindow/Initialize()
	update_icon()
	..()

/obj/structure/roguewindow/obj_destruction(damage_flag)
	..()

/obj/structure/roguewindow/attacked_by(obj/item/I, mob/living/user)
	..()
	if(obj_broken || obj_destroyed)
		var/obj/effect/track/structure/new_track = SStracks.get_track(/obj/effect/track/structure, get_turf(src))
		message_admins("Window [obj_destroyed ? "destroyed" : "broken"] by [user?.real_name] using [I] [ADMIN_JMP(src)]")
		log_admin("Window [obj_destroyed ? "destroyed" : "broken"] by [user?.real_name] at X:[src.x] Y:[src.y] Z:[src.z] in area: [get_area(src)]")
		new_track.handle_creation(user)

/obj/structure/roguewindow/update_icon()
	if(brokenstate)
		icon_state = "[base_state]br"
		return
	icon_state = "[base_state]"

/obj/structure/roguewindow/openclose/OnCrafted(dirin)
	dirin = turn(dirin, 180)
	lockdir = dirin
	. = ..(dirin)

/obj/structure/roguewindow/stained
	desc = "A stained glass window bearing religious imagery." // Basic template, if any more subtypes are added.
	icon_state = null
	base_state = null
	opacity = TRUE
	max_integrity = 200 
	integrity_failure = 0.5

/obj/structure/roguewindow/stained/silver
	desc = "A stained glass window bearing the cross of Psydon, the Weeping God, creator of the world. \
	Either as a venerated martyr or a still-living deity, His imagery features often in both churches of the Ten \
	and those of the Otavan Orthodoxy. Despite their differences, they share a common origin."
	icon_state = "stained-silver"
	base_state = "stained-silver"

/obj/structure/roguewindow/stained/yellow
	desc = "A stained glass window bearing the symbolism of Astrata, the Tyrant Sister Sun that reigns over the Divine \
	Pantheon of Ten. Her uniquely vaunted position earns her symbol's common usage in all churches of the Ten, whereas \
	She is reduced to the status of a saint by the Otavan Orthodoxy."
	icon_state = "stained-yellow"
	base_state = "stained-yellow"

/obj/structure/roguewindow/stained/zizo
	desc = "A stained glass window bearing an inverted cross of Psydon, usually used as a symbol of the Ascendant Goddess Zizo, \
	Lady of Progress, Harbinger of Undeath, and a deity condemned in almost realm of the world. All the same, Her followers \
	construct such intricate things in Her honor, even knowing that they may so soon be shattered."
	icon_state = "stained-zizo"
	base_state = "stained-zizo"

/obj/structure/roguewindow/openclose
	icon_state = "woodwindowdir"
	base_state = "woodwindow"
	opacity = TRUE
	max_integrity = 200
	integrity_failure = 0.5

/obj/structure/roguewindow/openclose/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right clicking on the window will open or close it.")

/obj/structure/roguewindow/openclose/OnCrafted(dirin)
	dir = turn(dirin, 180)
	lockdir = dir

/obj/structure/roguewindow/openclose/Initialize()
	..()
	lockdir = dir
	icon_state = base_state

/obj/structure/roguewindow/openclose/reinforced
	desc = "A glass window. This one looks reinforced with a metal mesh."
	icon_state = "reinforcedwindowdir"
	base_state = "reinforcedwindow"
	max_integrity = 800
	integrity_failure = 0.1

/obj/structure/roguewindow/openclose/reinforced/OnCrafted(dirin)
	dir = turn(dirin, 180)
	lockdir = dir

/obj/structure/roguewindow/openclose/reinforced/Initialize()
	..()
	lockdir = dir
	icon_state = base_state

/obj/structure/roguewindow/openclose/reinforced/brick
	desc = "A glass window. This one looks reinforced with a metal frame."
	icon_state = "brickwindowdir"
	base_state = "brickwindow"
	max_integrity = 1000	//Better than reinforced by a bit; metal frame.

/obj/structure/roguewindow/openclose/reinforced/brick/OnCrafted(dirin)
	dir = turn(dirin, 180)
	lockdir = dir

/obj/structure/roguewindow/openclose/reinforced/brick/Initialize()
	..()
	lockdir = dir
	icon_state = base_state

/obj/structure/roguewindow/harem1
	name = "harem window"
	icon_state = "harem1-solid"
	base_state = "harem1-solid"

/obj/structure/roguewindow/harem2
	name = "harem window"
	icon_state = "harem2-solid"
	base_state = "harem2-solid"
	opacity = TRUE

/obj/structure/roguewindow/harem3
	name = "harem window"
	icon_state = "harem3-solid"
	base_state = "harem3-solid"

/obj/structure/roguewindow/openclose/Initialize()
	lockdir = dir
	icon_state = base_state
	GLOB.TodUpdate += src
	..()

/obj/structure/roguewindow/openclose/Destroy()
	GLOB.TodUpdate -= src
	return ..()

/obj/structure/roguewindow/openclose/update_tod(todd)
	update_icon()

/obj/structure/roguewindow/openclose/update_icon()
	var/isnight = FALSE
	if(GLOB.tod == "night")
		isnight = TRUE
	if(brokenstate)
		if(isnight)
			icon_state = "[base_state]br"
		else
			icon_state = "w-[base_state]br"
		return
	if(climbable)
		if(isnight)
			icon_state = "[base_state]op"
		else
			icon_state = "w-[base_state]op"
	else
		if(isnight)
			icon_state = "[base_state]"
		else
			icon_state = "w-[base_state]"

/obj/structure/roguewindow/openclose/attack_right(mob/user)
	if(get_dir(src,user) == lockdir)
		if(brokenstate)
			to_chat(user, span_warning("It's broken, that would be foolish."))
			return
		if(climbable)
			close_up(user)
		else
			open_up(user)
	else
		to_chat(user, span_warning("The window doesn't close from this side."))

/obj/structure/roguewindow/proc/open_up(mob/user)
	visible_message(span_info("[user] opens [src]."))
	playsound(src, 'sound/foley/doors/windowup.ogg', 100, FALSE)
	climbable = TRUE
	opacity = FALSE
	update_icon()

/obj/structure/roguewindow/proc/force_open()
	playsound(src, 'sound/foley/doors/windowup.ogg', 100, FALSE)
	climbable = TRUE
	opacity = FALSE
	update_icon()

/obj/structure/roguewindow/proc/close_up(mob/user)
	visible_message(span_info("[user] closes [src]."))
	playsound(src, 'sound/foley/doors/windowdown.ogg', 100, FALSE)
	climbable = FALSE
	opacity = TRUE
	update_icon()


/obj/structure/roguewindow/CanAStarPass(ID, to_dir, caller)
	. = ..()
	var/atom/movable/mover = caller
	if(!. && istype(mover) && (mover.pass_flags & PASSTABLE) && climbable)
		return TRUE

/obj/structure/roguewindow/CanPass(atom/movable/mover, turf/target)
	if(istype(mover) && (mover.pass_flags & PASSTABLE) && climbable)
		return 1
	if(isliving(mover))
		if(mover.throwing)
			if(!climbable)
				if(!iscarbon(mover))
					take_damage(10)
				else
					var/mob/living/carbon/dude = mover
					var/base_damage = 20
					take_damage(base_damage * (dude.STASTR / 10))
			if(brokenstate || climbable)
				if(ishuman(mover))
					var/mob/living/carbon/human/dude = mover
					if(prob(100 - clamp((dude.get_skill_level(/datum/skill/misc/athletics) + dude.get_skill_level(/datum/skill/misc/climbing)) * 10 - (!dude.is_jumping * 30), 10, 100)))
						var/obj/item/bodypart/head/head = dude.get_bodypart(BODY_ZONE_HEAD)
						head.receive_damage(20)
						dude.Stun(5 SECONDS)
						dude.Knockdown(5 SECONDS)
						dude.add_stress(/datum/stressevent/hithead)
						dude.visible_message(
							span_warning("[dude] hits their head as they fly through the window!"),
							span_danger("I hit my head on the window frame!"))
				return 1
	else if(isitem(mover))
		var/obj/item/I = mover
		if(I.throwforce >= 10)
			take_damage(I.throwforce)
			if(brokenstate)
				return 1
		else
			return !density
	return ..()

/obj/structure/roguewindow/attackby(obj/item/W, mob/user, params)
	return ..()

/obj/structure/roguewindow/attack_paw(mob/living/user)
	attack_hand(user)

/obj/structure/roguewindow/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(brokenstate)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(HAS_TRAIT(user, TRAIT_BASHDOORS))
		src.take_damage(15)
		return
	src.visible_message(span_info("[user] knocks on [src]."))
	add_fingerprint(user)
	playsound(src, 'sound/misc/glassknock.ogg', 100)

/obj/structure/roguewindow/obj_break(damage_flag)
	if(!brokenstate)
		attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
		log_admin("Window broken at X:[src.x] Y:[src.y] Z:[src.z] in area: [get_area(src)]")
		loud_message("A loud crash of a window getting broken rings out", hearing_distance = 14)
		new /obj/item/natural/glass_shard (get_turf(src))
		new /obj/effect/decal/cleanable/debris/glassy(get_turf(src))
		climbable = TRUE
		brokenstate = TRUE
		opacity = FALSE
	update_icon()
	..()
