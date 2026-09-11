/turf/open/floor/rogue
	desc = ""
	canSmoothWith = null
	smooth = SMOOTH_FALSE
	var/smooth_icon = null
	var/prettifyturf = FALSE
	icon = 'icons/turf/roguefloor.dmi'
	baseturfs = list(/turf/open/transparent/openspace)
	neighborlay = ""
	/// If set, SSseason ChangeTurf()s this into winter_type during Winter, the same way it does
	/// grass - the sibling of water's freeze_type, for ground/path turfs whose winter look needs
	/// to be a real type rather than just a different sprite. That distinction matters here
	/// specifically because dirt carries real per-instance state (mud, blood, an active dig hole)
	/// that a plain icon_state swap either can't touch or actively fights with (its mud dry-out
	/// code resets icon_state to a fixed default with no idea a season is involved) - a subtype
	/// sidesteps that by making the Winter look the turf's own compile-time default, the same way
	/// "dirt" already is for the non-Winter one.
	var/winter_type
	/// The reverse of winter_type - set on the Winter form, pointing back to what it thaws to.
	var/summer_type

/turf/open/floor/rogue/break_tile()
	return //unbreakable

/turf/open/floor/rogue/burn_tile()
	return //unburnable

/turf/open/floor/rogue/Initialize(mapload)
	if(smooth_icon)
		icon = smooth_icon
	. = ..()
	if(winter_type || summer_type)
		GLOB.seasonal_icon_turfs |= src

// Shared by every rogue floor turf rather than just the seasonal grass/snow family - removing
// something that was never in the list is a harmless no-op, and this way SSseason's tracking
// can never go stale no matter what a turf gets changed into.
/turf/open/floor/rogue/Destroy()
	GLOB.seasonal_grass_turfs -= src
	GLOB.seasonal_water_turfs -= src
	GLOB.seasonal_icon_turfs -= src
	return ..()

/turf/open/floor/rogue/ruinedwood
	icon_state = "wooden_floor"
	name = "wooden floorboards"
	desc = "Interlocking wooden floorboards scratched with thousands of steps."
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/woodland.wav'
//	smooth = SMOOTH_MORE
//	canSmoothWith = list(/turf/closed/mineral/rogue, /turf/closed/mineral, /turf/closed/wall/mineral/rogue/stonebrick, /turf/closed/wall/mineral/rogue/wood, /turf/closed/wall/mineral/rogue/wooddark, /turf/closed/wall/mineral/rogue/decowood, /turf/closed/wall/mineral/rogue/decostone, /turf/closed/wall/mineral/rogue/stone, /turf/closed/wall/mineral/rogue/stone/moss, /turf/open/floor/rogue/cobble, /turf/open/floor/rogue/dirt, /turf/open/floor/rogue/grass)
	neighborlay = "dirtedge"

/turf/open/floor/rogue/ruinedwood/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/ruinedwood/turned
	icon_state = "wooden_floort"
	name = "wooden floorboards"
	desc = "Interlocking wooden floorboards scratched with thousands of steps."

/turf/open/floor/rogue/ruinedwood/spiral
	icon_state = "weird1"
	name = "wooden floorboards"
	desc = "Interlocking wooden floorboards."
/turf/open/floor/rogue/ruinedwood/chevron
	icon_state = "weird2"
	name = "floorboards"
	desc = "Interlocking wooden floorboards."

/turf/open/floor/rogue/ruinedwood/platform
	name = "platform"
	desc = "A destructible platform."
	damage_deflection = 8
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/turf/open/floor/rogue/ruinedwood/platform/turf_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/hay
	icon_state = "hay"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0

/turf/open/floor/rogue/twig
	name = "twig flooring"
	desc = "Bundles of twigs have been laid flat against the ground. They creak and crackle with the slightest weight."
	icon_state = "twig"
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0

/turf/open/floor/rogue/twig/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/twig/platform
	name = "twig platform"
	desc = "A destructible platform."
	damage_deflection = 4
	max_integrity = 100		//It's fucking twig.
	break_sound = 'sound/combat/hits/onwood/destroywalldoor.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')

/turf/open/floor/rogue/twig/platform/turf_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/wood
	smooth_icon = 'icons/turf/floors/wood.dmi'
	icon_state = "wooden_floor2"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	smooth = SMOOTH_MORE
	landsound = 'sound/foley/jumpland/woodland.wav'
	canSmoothWith = list(/turf/open/floor/rogue/wood,/turf/open/floor/carpet)

/turf/open/floor/rogue/wood/nosmooth //these are here so we can put wood floors next to each other but not have them smooth
	name = "wooden floorboards"
	desc = "Polished wooden floorboards scuffed by scratches and a persistent layer of grime."
	icon_state = "wooden_floor"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue/wood/nosmooth,/turf/open/floor/carpet)

/turf/open/floor/rogue/woodturned
	smooth_icon = 'icons/turf/floors/wood_turned.dmi'
	icon_state = "wooden_floor2t"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue/woodturned,/turf/open/floor/carpet)
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/rogue/woodturned/nosmooth
	name = "wooden floorboards"
	desc = "Polished wooden floorboards scuffed by scratches and a persistent layer of grime."
	icon_state = "wooden_floort"
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue/woodturned/nosmooth,/turf/open/floor/carpet)

/turf/open/floor/rogue/rooftop
	name = "roof"
	desc = "Overlapping wooden shingles protect the building and its inhabitants from the rain."
	icon_state = "roof-arw"
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE

/turf/open/floor/rogue/rooftop/north
	dir = 1

/turf/open/floor/rogue/rooftop/east
	dir = 4

/turf/open/floor/rogue/rooftop/west
	dir = 8


/turf/open/floor/rogue/rooftop/Initialize(mapload)
	. = ..()
	icon_state = "roof"

/turf/open/floor/rogue/rooftop/green
	icon_state = "roofg-arw"

/turf/open/floor/rogue/rooftop/green/Initialize(mapload)
	. = ..()
	icon_state = "roofg"

/turf/open/floor/rogue/rooftop/green/north
	dir = 1

/turf/open/floor/rogue/rooftop/green/east
	dir = 4

/turf/open/floor/rogue/rooftop/green/west
	dir = 8

/turf/open/floor/rogue/rooftop/green/corner1
	icon_state = "roofgc1-arw"

/turf/open/floor/rogue/rooftop/green/corner1/Initialize(mapload)
	. = ..()
	icon_state = "roofgc1"

/turf/open/floor/rogue/rooftop/green/corner1/dirone
	dir = 1

/turf/open/floor/rogue/rooftop/green/corner1/dirfour
	dir = 4


/turf/open/floor/rogue/rooftop/green/corner1/direight
	dir = 8


/turf/open/floor/rogue/rooftop/green/corner1/dirfive
	dir = 5

/turf/open/floor/rogue/rooftop/green/corner1/dirnine
	dir = 9

/turf/open/floor/rogue/rooftop/green/corner1/dirsix
	dir = 6


/turf/open/floor/rogue/rooftop/green/corner1/dirten
	dir = 10


/turf/open/floor/rogue/AzureSand
	name = "sand"
	desc = "Warm sand that, sadly, has been mixed with dirt."
	icon_state = "grimshart"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/AzureSand,)
	neighborlay = "grimshartedge"

/turf/open/floor/rogue/AzureSand/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/AzureSand/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/snow
	name = "snow"
	desc = "A gentle blanket of snow."
	icon_state = "snow"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/frozen_water,)
	neighborlay = "snowedge"
	spread_chance = 0

/turf/open/floor/rogue/snow/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/snow/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/snow/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/obj/item/I = new /obj/item/natural/dirtclod/snow(src)
		if(L.put_in_active_hand(I))
			L.visible_message(span_warning("[L] picks up some snow."))
			ChangeTurf(/turf/open/floor/rogue/snowpatchy, flags = CHANGETURF_INHERIT_AIR)
		else
			qdel(I)

	. = ..()

/turf/open/floor/rogue/snow/attackby(obj/item/C, mob/user, params)
	if(istype(C, /obj/item/natural/dirtclod/snow))
		for(var/elements in contents)
			if(!istype(elements, /obj/effect/decal/cleanable/blood/footprints/mud))
				continue
			QDEL_NULL(elements)
			to_chat(user, span_notice("You pad out any footprints in [src].."))
			qdel(C)

	. = ..()

/turf/open/floor/rogue/snow/Crossed(atom/movable/O)
	..()
	if(!ishuman(O))
		return
	var/mob/living/carbon/human/H = O
	if(HAS_TRAIT(H, TRAIT_LIGHT_STEP))
		return
	update_icon()
	if(water_level)
		START_PROCESSING(SSwaterlevel, src)

/turf/open/floor/rogue/snowrough
	name = "rough snow"
	desc = "A rugged blanket of snow."
	icon_state = "snowrough"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/frozen_water,)
	neighborlay = "snowroughedge"
	spread_chance = 0

/turf/open/floor/rogue/snowrough/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/snowrough/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/snowpatchy
	name = "patchy snow"
	desc = "Half-melted snow revealing the hardy grass underneath."
	icon_state = "snowpatchy_grass"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/frozen_water,)
	neighborlay = "snowpatchy_grassedge"

/turf/open/floor/rogue/snowpatchy/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/grasscold
	name = "tundra grass"
	desc = "Grass, frigid and touched by winter."
	icon_state = "grass_cold"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/frozen_water,)
	neighborlay = "grass_coldedge"
	winter_type = /turf/open/floor/rogue/grasscold/winter

/turf/open/floor/rogue/grasscold/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/grasscold/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/// Mapper-placed flavor grass (grassred/grassyel/grasscold) isn't part of SSseason's normal
/// spring/summer/autumn color-cycling - a battlefield's red grass or a wheat field's yellow grass
/// is meant to keep its own identity the rest of the year. But leaving it untouched through Winter
/// specifically read as wrong (a pristine patch sitting in the middle of a snowed-over map), so it
/// gets the same Winter-only ChangeTurf() pair everything else in this file does - full "snow"
/// look, reverting to its own original color come thaw.
/turf/open/floor/rogue/grasscold/winter
	icon_state = "snow"
	neighborlay = "snowedge"
	winter_type = null
	summer_type = /turf/open/floor/rogue/grasscold

/turf/open/floor/rogue/grassred
	name = "red grass"
	desc = "Grass, ripe with Dendor's blood."
	icon_state = "grass_red"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "grass_rededge"
	winter_type = /turf/open/floor/rogue/grassred/winter

/turf/open/floor/rogue/grassred/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/grassred/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/// See /turf/open/floor/rogue/grasscold/winter for why this exists.
/turf/open/floor/rogue/grassred/winter
	icon_state = "snow"
	neighborlay = "snowedge"
	winter_type = null
	summer_type = /turf/open/floor/rogue/grassred

/turf/open/floor/rogue/grassyel
	name = "yellow grass"
	desc = "Grass, blessed by Astrata's light."
	icon_state = "grass_yel"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "grass_yeledge"
	winter_type = /turf/open/floor/rogue/grassyel/winter

/turf/open/floor/rogue/grassyel/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()

/turf/open/floor/rogue/grassyel/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/// See /turf/open/floor/rogue/grasscold/winter for why this exists.
/turf/open/floor/rogue/grassyel/winter
	icon_state = "snow"
	neighborlay = "snowedge"
	winter_type = null
	summer_type = /turf/open/floor/rogue/grassyel

/turf/open/floor/rogue/grass
	name = "grass"
	desc = "Grass, sodden with mud and bogwater."
	icon_state = "grass"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/frozen_water,)
	neighborlay = "grassedge"

	spread_chance = 15
	burn_power = 6

/turf/open/floor/rogue/grass/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	GLOB.seasonal_grass_turfs |= src
	. = ..()
	if(!mapload)
		// Map-loaded turfs get caught by SSseason's own startup sweep - only newly spawned
		// (runtime) grass needs to catch up immediately. Deferred a tick since ChangeTurf()
		// destroys and recreates src, which would be unsafe to do from within our own Initialize().
		addtimer(CALLBACK(SSseason, TYPE_PROC_REF(/datum/controller/subsystem/season, apply_season_to_turf), src), 0)

/turf/open/floor/rogue/grass/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/dirt/ambush
	name = "dirt"
	desc = "The dirt is pocked with the scars of countless wars."
	icon_state = "dirt"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	slowdown = 1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)
	neighborlay = "dirtedge"
	muddy = FALSE
	bloodiness = 20
	dirt_amt = 3
	spread_chance = 8

/turf/open/floor/rogue/dirt
	name = "dirt"
	desc = "The dirt is pocked with the scars of countless wars."
	icon_state = "dirt"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_GRASS
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	slowdown = 1
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/AzureSand)
	neighborlay = "dirtedge"
	winter_type = /turf/open/floor/rogue/dirt/winter
	var/muddy = FALSE
	var/bloodiness = 20
	var/obj/structure/closet/dirthole/holie
	var/dirt_amt = 3

/turf/open/floor/rogue/dirt/get_slowdown(mob/user)
	. = ..()
	var/negate_slowdown = FALSE

	if((isliving(user))&&(user?.movement_type == FLYING))
		negate_slowdown = TRUE
	if(HAS_TRAIT(user, TRAIT_LONGSTRIDER))
		negate_slowdown = TRUE

	if(negate_slowdown)
		. -= 2
	return max(., 0)


/turf/open/floor/rogue/dirt/attack_right(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		var/obj/item/I = new /obj/item/natural/dirtclod(src)
		if(L.put_in_active_hand(I))
			L.visible_message(span_warning("[L] picks up some dirt."))
			dirt_amt--
			if(dirt_amt <= 0)
				src.ChangeTurf(/turf/open/floor/rogue/dirt/road, flags = CHANGETURF_INHERIT_AIR)
		else
			qdel(I)
	.=..()

/turf/open/floor/rogue/dirt/Destroy()
	if(holie)
		QDEL_NULL(holie)
	return ..()


/turf/open/floor/rogue/dirt/Crossed(atom/movable/O)
	..()
	if(ishuman(O))
		var/mob/living/carbon/human/H = O
		if(H.shoes && !HAS_TRAIT(H, TRAIT_LIGHT_STEP))
			var/obj/item/clothing/shoes/S = H.shoes
			if(!istype(S) || !S.can_be_bloody)
				return
			var/add_blood = 0
			if(bloodiness >= BLOOD_GAIN_PER_STEP)
				add_blood = BLOOD_GAIN_PER_STEP
			else
				add_blood = bloodiness
			S.bloody_shoes[BLOOD_STATE_MUD] = min(MAX_SHOE_BLOODINESS,S.bloody_shoes[BLOOD_STATE_MUD]+add_blood)
			S.blood_state = BLOOD_STATE_MUD
			update_icon()
			H.update_inv_shoes()
		if(water_level)
			START_PROCESSING(SSwaterlevel, src)

/turf/open/floor/rogue/dirt/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/dirt/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()
	update_water()

/turf/open/floor/rogue/dirt/update_water()
	water_level = max(water_level-10,0)
	if(water_level > 10) //this would be a switch on normal tiles
		color = "#95776a"
	else
		color = null
	return TRUE

/turf/open/floor/rogue/dirt/road/update_water()
	water_level = max(water_level-10,0)
	for(var/D in GLOB.cardinals)
		var/turf/TU = get_step(src, D)
		if(istype(TU, /turf/open/water))
			if(!muddy)
				become_muddy()
			return TRUE //stop processing
	if(water_level > 10) //this would be a switch on normal tiles
		if(!muddy)
			become_muddy()
//flood process goes here to spread to other turfs etc
//	if(water_level > 250)
//		return FALSE
	if(muddy)
		if(water_level <= 0)
			water_level = 0
			muddy = FALSE
			slowdown = initial(slowdown)
			icon_state = initial(icon_state)
			name = initial(name)
			footstep = initial(footstep)
			barefootstep = initial(barefootstep)
			clawfootstep = initial(clawfootstep)
			heavyfootstep = initial(heavyfootstep)
			track_prob = initial(track_prob) //Hearthstone port.
	return TRUE

/turf/open/floor/rogue/dirt/proc/become_muddy()
	if(!muddy)
		water_level = max(water_level-100,0)
		muddy = TRUE
		icon_state = "mud[rand (1,3)]"
		name = "mud"
		slowdown = 1
		footstep = FOOTSTEP_MUD
		barefootstep = FOOTSTEP_MUD
		heavyfootstep = FOOTSTEP_MUD
		track_prob = 20 //Hearthstone port.
		bloodiness = 20

/turf/open/floor/rogue/dirt/road
	name = "dirt"
	desc = "The dirt is pocked with the scars of countless steps."
	icon_state = "road"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/AzureSand,)
	neighborlay = "roadedge"
	winter_type = /turf/open/floor/rogue/dirt/road/winter
	slowdown = 0

/turf/open/floor/rogue/dirt/road/attack_right(mob/user)
	return

/turf/open/floor/rogue/dirt/road/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/// The Winter form of plain dirt - a real subtype rather than an icon swap so that mud, blood,
/// water saturation and an active dig hole (see /turf/open/floor/rogue/dirt's vars) all keep
/// working exactly as they do the rest of the year, with the season only changing what the
/// "clean" look underneath resolves to. become_muddy()/update_water()'s `initial(icon_state)`
/// dry-out correctly lands on "snow" here, the same way it lands on "dirt" on the summer type -
/// no separate season-awareness needed in that code at all. Base sprite *and* edge family are
/// both plain snow's ("snow"/"snowedge") rather than a dedicated "snowdirt" set - a dirt path in
/// Winter is meant to be indistinguishable from the snow around it, and mixing edge art from a
/// different sheet than the base tile produced a visibly jagged seam.
/turf/open/floor/rogue/dirt/winter
	icon_state = "snow"
	neighborlay = "snowedge"
	winter_type = null
	summer_type = /turf/open/floor/rogue/dirt

/// See /turf/open/floor/rogue/dirt/winter - same reasoning, for dirt/road specifically. Base
/// sprite and edge family are both snowrough's ("snowrough"/"snowroughedge").
/turf/open/floor/rogue/dirt/road/winter
	icon_state = "snowrough"
	neighborlay = "snowroughedge"
	winter_type = null
	summer_type = /turf/open/floor/rogue/dirt/road

/turf/open/floor/rogue/sand
	name = "sand"
	desc = "Fine grains shift and hiss softly beneath your step."
	icon = 'icons/turf/sand.dmi'
	icon_state = "sand"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SAND
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_SAND
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	baseturfs = /turf/open/floor/rogue/sand
	slowdown = 0

/turf/open/floor/rogue/sand/Initialize(mapload)
	. = ..()
	if(prob(15))
		icon_state = "sand[rand(1,4)]"

/turf/open/floor/rogue/hay
	name = "hay"
	desc = "Dried grass strewn across the floor. It's not the worst thing to sleep on."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "hay"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/dirtland.wav'
	slowdown = 0

/turf/proc/roguesmooth(adjacencies)
	var/list/New
	var/holder

	cut_overlay(neighborlay_list)
	neighborlay_list = null

	var/usedturf
	if(adjacencies & N_NORTH)
		usedturf = get_step(src, NORTH)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-n"
				LAZYADD(New, holder)
				LAZYADD(neighborlay_list, holder)
			else if(T.neighborlay)
				holder = "[T.neighborlay]-n"
				LAZYADD(New, holder)
				LAZYADD(neighborlay_list, holder)
	if(adjacencies & N_SOUTH)
		usedturf = get_step(src, SOUTH)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-s"
				LAZYADD(New, holder)
				LAZYADD(neighborlay_list, holder)
			else if(T.neighborlay)
				holder = "[T.neighborlay]-s"
				LAZYADD(New, holder)
				LAZYADD(neighborlay_list, holder)
	if(adjacencies & N_WEST)
		usedturf = get_step(src, WEST)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-w"
				LAZYADD(New, holder)
				LAZYADD(neighborlay_list, holder)
			else if(T.neighborlay)
				holder = "[T.neighborlay]-w"
				LAZYADD(New, holder)
				LAZYADD(neighborlay_list, holder)
	if(adjacencies & N_EAST)
		usedturf = get_step(src, EAST)
		if(isturf(usedturf))
			var/turf/T = usedturf
			if(neighborlay_override)
				holder = "[neighborlay_override]-e"
				LAZYADD(New, holder)
				LAZYADD(neighborlay_list, holder)
			else if(T.neighborlay)
				holder = "[T.neighborlay]-e"
				LAZYADD(New, holder)
				LAZYADD(neighborlay_list, holder)

	if(New)
		add_overlay(New)
	return New

/turf/open/floor/rogue/underworld/space
	name = "void"
	desc = ""
	icon_state = "undervoid"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dark_ice)
	slowdown = 50

/turf/open/floor/rogue/underworld/space/dense
	density = TRUE

/turf/open/floor/rogue/underworld/space/sparkle_quiet
	name = "void"
	desc = ""
	icon_state = "undervoid2"

/turf/open/floor/rogue/underworld/space/sparkle_quiet/dense
	density = TRUE

/turf/open/floor/rogue/underworld/space/quiet
	name = "void"
	desc = ""
	icon_state = "undervoid3"

/turf/open/floor/rogue/underworld/space/quiet/dense
	density = TRUE

/turf/open/floor/rogue/underworld/road
	name = "ash"
	desc = "Smells like burnt wood."
	icon_state = "ash"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue, /turf/closed/mineral, /turf/closed/wall/mineral)
	slowdown = 0

/turf/open/floor/rogue/underworld/road/Initialize(mapload)
	. = ..()
	dir = rand(0,8)

/turf/open/floor/rogue/volcanic
	name = "solidified lava"
	desc = "Once, it burned anything it touched with the hatred of hell itself. Now a hardened black crust crunches beneath your feet."
	icon_state = "lavafloor"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_SAND
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	clawfootstep = FOOTSTEP_SAND
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/dirtland.wav'
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dirt/road,/turf/open/floor/rogue/dirt)
	neighborlay = "lavedge"

/turf/open/floor/rogue/volcanic/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	. = ..()


/turf/open/floor/rogue/blocks
	icon_state = "blocks"
	name = "stone flooring"
	desc = "These rough stone slabs have been arranged in a neat grid for a rustic yet tidy charm."
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/blocks/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/blocks/flipped
	dir = 8

/turf/open/floor/rogue/blocks/stonered
	icon_state = "stoneredlarge"
	name = "large red tiles"
	desc = "Large red earthen tiles carefully set in a pleasantly symmetrical pattern."
/turf/open/floor/rogue/blocks/stonered/tiny
	icon_state = "stoneredtiny"
	name = "square red tiles"
	desc = "Small square earthen tiles carefully arranged in a somewhat plain pattern."

/turf/open/floor/rogue/blocks/green
	icon_state = "greenblocks"

/turf/open/floor/rogue/blocks/bluestone
	icon_state = "bluestone2"

/turf/open/floor/rogue/blocks/newstone
	icon_state = "newstone2"

/turf/open/floor/rogue/blocks/newstone/alt
	icon_state = "bluestone"

/turf/open/floor/rogue/blocks/paving
	icon_state = "paving"
/turf/open/floor/rogue/blocks/paving/vert
	icon_state = "paving-t"

/turf/open/floor/rogue/blocks/platform
	name = "platform"
	desc = "A destructible platform."
	damage_deflection = 10
	max_integrity = 800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')

/turf/open/floor/rogue/blocks/platform/turf_destruction(damage_flag)
	. = ..()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/greenstone
	icon_state = "greenstone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	icon = 'icons/turf/greenstone.dmi'

/turf/open/floor/rogue/greenstone/runed
	icon_state = "greenstoneruned"

/turf/open/floor/rogue/greenstone/glyph1
	icon_state = "glyph1"

/turf/open/floor/rogue/greenstone/glyph2
	icon_state = "glyph2"

/turf/open/floor/rogue/greenstone/glyph3
	icon_state = "glyph3"

/turf/open/floor/rogue/greenstone/glyph4
	icon_state = "glyph4"

/turf/open/floor/rogue/greenstone/glyph5
	icon_state = "glyph5"

/turf/open/floor/rogue/greenstone/glyph6
	icon_state = "glyph6"

/turf/open/floor/rogue/hexstone
	icon_state = "hexstone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/open/floor/rogue/herringbone,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/hexstone/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/hexstone/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

//Church floors

/turf/open/floor/rogue/churchmarble
	icon_state = "church_marble"
	name = "marble flooring"
	desc = "Polished marble tiling clacks softly with every footstep. A prized material for vaunted halls."
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/open/floor/rogue/herringbone,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/churchmarble/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/churchmarble/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/church
	icon_state = "church"
	name = "polished tile floor"
	desc = "Glazed tiling that has withstood the decades with barely a scratch despite the steady accumulation of dirt and grime."
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/open/floor/rogue/herringbone,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/church/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/church/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/churchbrick
	icon_state = "church_brick"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/open/floor/rogue/herringbone,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/churchbrick/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/churchbrick/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/churchrough
	icon_state = "church_rough"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/open/floor/rogue/herringbone,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/churchrough/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/churchrough/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)
//
/turf/open/floor/rogue/herringbone
	icon_state = "herringbone"
	name = "stone herringbone flooring"
	desc = "These stone bricks have been carefully arranged in a rather pleasing pattern."
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	neighborlay = "herringedge"
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/herringbone,
						/turf/open/floor/rogue/blocks,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/herringbone/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/herringbone/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/obj/effect/decal/herringbone
	name = "herringbone flooring"
	desc = "These stone bricks have been carefully arranged in a rather pleasing pattern."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "herringedge"
	mouse_opacity = 0

/obj/effect/decal/wood/herringbone
	name = "herringbone flooring"
	desc = "thin planks of wood carefully arranged in a rather pleasing pattern."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "herringbonewoodedge"
	mouse_opacity = 0

/obj/effect/decal/wood/herringbone2
	name = "herringbone flooring"
	desc = "Thin planks of wood carefully arranged in a rather pleasing pattern."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "herringbonewood2edge"
	mouse_opacity = 0

/turf/open/floor/rogue/ruinedwood/herringbone
	name = "wooden herringbone flooring"
	desc = "Thin planks of wood carefully arranged in a rather pleasing pattern."
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/woodland.wav'
	icon_state = "herringbonewood"

/turf/open/floor/rogue/ruinedwood/herringbone_clear
	name = "wooden herringbone flooring"
	desc = "Thin planks of wood carefully arranged in a rather pleasing pattern."
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/woodland.wav'
	icon_state = "herringbonewood2"

/turf/open/floor/rogue/wood/herringbone
	footstep = FOOTSTEP_WOOD
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_WOOD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	tiled_dirt = FALSE
	landsound = 'sound/foley/jumpland/woodland.wav'
	icon_state = "herringbonewood2"

/turf/open/floor/rogue/cobble
	icon_state = "cobblestone1"
	name = "cobblestone"
	desc = "Stone bricks carefully inlaid upon the ground for a more refined and resilient path."
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	neighborlay = "cobbleedge"
	winter_type = /turf/open/floor/rogue/cobble/winter
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,
						/turf/open/floor/rogue/AzureSand)

/turf/open/floor/rogue/cobble/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/cobble/Initialize(mapload)
	. = ..()
	icon_state = "cobblestone[rand(1,3)]"

/// See /turf/open/floor/rogue/dirt/winter for why this is a subtype rather than an icon swap -
/// cobble itself has no per-instance state to lose, but the same mechanism is used everywhere for
/// consistency (one code path in SSseason, not two).
/turf/open/floor/rogue/cobble/winter
	neighborlay = "snowcobbleedge"
	winter_type = null
	summer_type = /turf/open/floor/rogue/cobble

/turf/open/floor/rogue/cobble/winter/Initialize(mapload)
	. = ..()
	icon_state = "snowcobblestone[rand(1,3)]"

/turf/open/floor/rogue/cobble/mossy
	name = "mossy cobblestone"
	desc = "Dirt and moss have crept between the gaps of this stone-brick flooring."
	icon_state = "mossystone1"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
	neighborlay = "mossystone_edges"
	// Overrides the winter_type inherited from /cobble - there's no "snow-mossy" sprite, and
	// without this override mossy cobblestone would silently ChangeTurf() into plain
	// /cobble/winter every Winter, quietly losing its mossy name/desc/look for the season.
	winter_type = /turf/open/floor/rogue/cobble/mossy/winter
	smooth = SMOOTH_TRUE
	canSmoothWith = list(/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/cobble/mossy/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/cobble/mossy/Initialize(mapload)
	. = ..()
	icon_state = "mossystone[rand(1,3)]"

/// No dedicated "snow-mossy" sprite exists yet, so this reuses plain cobble's snowcobblestone
/// family rather than leaving mossy cobblestone with no Winter look at all.
/turf/open/floor/rogue/cobble/mossy/winter
	neighborlay = "snowcobbleedge"
	winter_type = null
	summer_type = /turf/open/floor/rogue/cobble/mossy

/turf/open/floor/rogue/cobble/mossy/winter/Initialize(mapload)
	. = ..()
	icon_state = "snowcobblestone[rand(1,3)]"

/obj/effect/decal/mossy
	name = "mossy brick floor"
	desc = "dirt and moss have crept between the gaps of this stone-brick flooring."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "mossyedge"
	mouse_opacity = 0

/obj/effect/decal/cobble/mossy
	name = "mossy brick floor"
	desc = "Dirt and moss have crept between the gaps of this stone-brick flooring. Rather fitting for an outdoor garden; not so much for a home."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "mossystone_edges"
	mouse_opacity = 0

/obj/effect/decal/edge
	name = "stone edge"
	desc = "A piece of stone used to border city roads."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "border"
	mouse_opacity = 0

/obj/effect/decal/edge_corner
	name = "stone edge corner"
	desc = "A piece of stone used to border city roads."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "border_corner"
	mouse_opacity = 0

/turf/open/floor/rogue/cobblerock
	icon_state = "cobblerock"
	name = "cobbled rock path"
	desc = "A crude path of lumpy rocks that allows feet and cart wheels alike to escape the treacherous mud."
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/stoneland.wav'
//	neighborlay = "cobblerock"
	winter_type = /turf/open/floor/rogue/cobblerock/winter
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral)

/turf/open/floor/rogue/cobblerock/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/cobblerock/no_smooth
	smooth = SMOOTH_FALSE

/// See /turf/open/floor/rogue/dirt/winter for why this is a subtype rather than an icon swap.
/// cobblerock's own neighborlay is disabled (see above) so there's no edge family to swap here.
/turf/open/floor/rogue/cobblerock/winter
	icon_state = "snowcobblerock"
	winter_type = null
	summer_type = /turf/open/floor/rogue/cobblerock

/obj/effect/decal/cobbleedge
	name = "old cobble path"
	desc = "Erosion and time have worn this path to half-scattered rocks slowly sinking back into the earth."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "cobblestone_edges"
	mouse_opacity = 0

/obj/effect/decal/carpet
	name = "exotic rug"
	desc = "Dazzling symmetrical patterns flow with an old culture's style."
	pixel_w = -16
	pixel_z = -17
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "kover"

/obj/effect/decal/carpet/kover_darkred
	name = "rustic red rug"
	desc = "Dazzling symmetrical patterns flow with an old culture's style."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "kover_darkred"

/obj/effect/decal/carpet/kover_purple
	name = "rustic purple rug"
	desc = "Dazzling symmetrical patterns flow with an old culture's style."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "kover_purple"

/obj/effect/decal/carpet/kover_black
	name = "rustic black carpet"
	desc = "Dazzling symmetrical patterns flow with an old culture's style."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "kover_black"

/obj/effect/decal/carpet/square
	name = "green carpet"
	desc = "Soft green carpeting that reminds you of grassy meadows."
	pixel_w = -16
	pixel_z = -16
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "greencarpet"

/obj/effect/decal/carpet/square/black
	name = "black carpet"
	desc = "As black as the night sky during a storm."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "blackcarpet"

/obj/structure/giantfur
	name = "giant fur"
	desc = "Pelt of some gigantic animal, made into a mat."
	icon = 'icons/roguetown/misc/96x96.dmi'
	icon_state = "fur"
	density = FALSE
	anchored = TRUE

/obj/structure/giantfur/small // the irony
	name = "fur pelt"
	desc = "Pelt of a young animal, made into a mat."
	icon_state = "fur_alt"

/turf/open/floor/rogue/tile
	icon_state = "chess"
	desc = "Feet march across a grid of plots and schemes."
	landsound = 'sound/foley/jumpland/tileland.wav'
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	footstepstealth = TRUE
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/tile/masonic
	icon_state = "masonic"
/turf/open/floor/rogue/tile/masonic/single
	icon_state = "masonicsingle"
/turf/open/floor/rogue/tile/masonic/inverted
	icon_state = "masonicsingleinvert"
/turf/open/floor/rogue/tile/masonic/spiral
	icon_state = "masonicspiral"

/turf/open/floor/rogue/tile/bath
	name = "bath tiles"
	desc = "A special waterproof flooring suited for baths and pools. Slippery when wet."
	icon_state = "bathtile"


/turf/open/floor/rogue/tile/brick
	icon_state = "bricktile"

/turf/open/floor/rogue/tile/bfloorz
	icon_state = "bfloorz"

/turf/open/floor/rogue/tile/tilerg
	icon_state = "tilerg"

/turf/open/floor/rogue/tile/checker
	icon_state = "linoleum"

/turf/open/floor/rogue/tile/checkeralt
	icon_state = "tile"

/turf/open/floor/rogue/tile/brownbrick
	icon_state = "brown"

/turf/open/floor/rogue/tile/harem
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "harem"

/turf/open/floor/rogue/tile/harem1
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "harem1"

/turf/open/floor/rogue/tile/harem2
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "harem2"

/turf/open/floor/rogue/concrete
	icon_state = "concretefloor1"
	name = "slab flooring"
	desc = "Solid stone slabs have been carefully carved and laid to rest with nary a hair's breadth between them."
	landsound = 'sound/foley/jumpland/stoneland.wav'
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/concrete/Initialize(mapload)
	. = ..()
	icon_state = "concretefloor[rand(1,2)]"
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/concrete/bronze
	color = "#ff9100"

/turf/open/floor/rogue/metal
	icon_state = "plating1"
	desc = "Covered in the tell-tale nicks of thousands of hammer-blows, this metal flooring clangs beneath your feet with every step."
	landsound = 'sound/foley/jumpland/metalland.wav'
	footstep = FOOTSTEP_PLATING
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	footstepstealth = TRUE
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/metal/Initialize(mapload)
	. = ..()
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/metal/barograte
	icon_state = "barograte"
/turf/open/floor/rogue/metal/barograte/open
	icon_state = "barograteopen"

/turf/open/floor/rogue/carpet
	icon_state = "carpet"
	desc = "Plush fabric softens your step. Did you remember to wipe your shoes?"
	landsound = 'sound/foley/jumpland/carpetland.wav'
	footstep = FOOTSTEP_CARPET
	barefootstep = FOOTSTEP_SOFT_BAREFOOT
	clawfootstep = FOOTSTEP_SOFT_BAREFOOT
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/closed/mineral/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral/rogue/stonebrick,
						/turf/closed/wall/mineral/rogue/wood,
						/turf/closed/wall/mineral/rogue/wooddark,
						/turf/closed/wall/mineral/rogue/stone,
						/turf/closed/wall/mineral/rogue/stone/moss,
						/turf/open/floor/rogue/cobble,
						/turf/open/floor/rogue/dirt,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grassred,
						/turf/open/floor/rogue/grassyel,
						/turf/open/floor/rogue/grasscold,
						/turf/open/floor/rogue/snowpatchy,
						/turf/open/floor/rogue/snow,
						/turf/open/floor/rogue/snowrough,)

/turf/open/floor/rogue/carpet/lord
	icon_state = ""

/turf/open/floor/rogue/carpet/lord/Initialize(mapload)
	. = ..()
	if(GLOB.lordprimary)
		lordcolor(GLOB.lordprimary,GLOB.lordsecondary)
	GLOB.lordcolor += src

/turf/open/floor/rogue/carpet/lord/Destroy()
	GLOB.lordcolor -= src
	return ..()

/turf/open/floor/rogue/carpet/lord/lordcolor(primary,secondary)
	if(!primary || !secondary)
		return
	var/mutable_appearance/M = mutable_appearance(icon, "[icon_state]_primary", -(layer+0.1))
	M.color = primary
	add_overlay(M)

/turf/open/floor/rogue/carpet/lord/center
	icon_state = "carpet_c"

/turf/open/floor/rogue/carpet/lord/center/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	..()

/turf/open/floor/rogue/carpet/lord/left
	icon_state = "carpet_l"

/turf/open/floor/rogue/carpet/lord/right
	icon_state = "carpet_r"

/turf/open/floor/rogue/shroud
	name = "treetop"
	icon_state = "treetop1"
	landsound = 'sound/foley/jumpland/dirtland.wav'
	footstep = null
	barefootstep = null
	clawfootstep = null
	heavyfootstep = null
	slowdown = 4

/turf/open/floor/rogue/shroud/Entered(atom/movable/AM, atom/oldLoc)
	..()
	if((isliving(AM))&&(!AM.movement_type == FLYING)) //if we're flying over something we shouldn't be making noise.
		if(istype(oldLoc, type))
			playsound(AM, "plantcross", 100, TRUE)

/turf/open/floor/rogue/shroud/Initialize(mapload)
	. = ..()
	icon_state = "treetop[rand(1,2)]"
	dir = pick(GLOB.cardinals)

/turf/open/floor/rogue/naturalstone
	name = "rough stone ground"
	desc = "Rough stone that's been exposed to the air either through erosion or the swing of a pickaxe. A few patchy lichens eke out a living between the cracks."
	icon_state = "digstone"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue,
						/turf/closed/mineral,
						/turf/closed/wall/mineral)

/turf/open/floor/rogue/naturalstone/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/dark_ice
	name = "black ice"
	desc = "A deep black rock glazed over with unnaturally cold ice."
	icon_state = "blackice"
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.wav'
	smooth = SMOOTH_MORE
	canSmoothWith = list(/turf/open/floor/rogue, /turf/open/floor/rogue/underworld)

/turf/open/floor/rogue/dark_ice/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/dark_ice/regular
	name = "ice"
	desc = "Cold, cold ice. Don't you want to look further within?"

/turf/open/floor/rogue/dark_ice/regular/turf_destruction(damage_flag)
	. = ..()
	visible_message(span_danger("[src] splinters and breaks away!"))
	playsound(src, 'sound/foley/waterenter.ogg', 100, FALSE)
	ChangeTurf(/turf/open/water/pond, flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/dark_ice/regular/Entered(atom/movable/AM)
	..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/H = AM
	if(HAS_TRAIT(H, TRAIT_LIGHT_STEP) || H.m_intent == MOVE_INTENT_SNEAK)
		return
	if(prob(25))
		to_chat(H, span_warning("[src] under you begins to crack!"))
		addtimer(CALLBACK(src, PROC_REF(ice_crack)), 2 SECONDS, TIMER_UNIQUE)
		return
	if(prob(40))
		var/list/possible_turfs = list()
		for(var/turf/T in range(1, H))
			if(T.density)
				continue
			possible_turfs += T
		H.forceMove(pick(possible_turfs))
		to_chat(H, span_warning("You slip on [src]!"))

/turf/open/floor/rogue/dark_ice/regular/proc/ice_crack()
	for(var/mob/living/target in contents)
		target.Knockdown(SHOVE_KNOCKDOWN_HUMAN)
	turf_destruction("blunt")
	return

// --- Seasonal ice ------------------------------------------------------------------------
// SSseason lays these over freezable /turf/open/water in Mid/Late Winter via freeze_over(),
// which pushes the original water type onto baseturfs - so thaw() is just a ScrapeAway() back
// to whatever subtype was actually there. Only ice with seasonal_freeze set thaws; anything a
// mapper places by hand is permanent, mirroring how SSseason ignores mapped grass variants.
//
// The depth rule, which is what the sprites encode: water_level 2 freezes solid (ice / light
// bogice), water_level 3 freezes thin (darkice / dark brownice). Darker and more saturated
// means more water underneath, means it can give way.
/turf/open/floor/rogue/frozen_water
	name = "ice"
	desc = "The shallows have frozen over, milky and clouded with trapped air."
	icon_state = "ice"
	layer = MID_TURF_LAYER
	footstep = FOOTSTEP_STONE
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY
	landsound = 'sound/foley/jumpland/grassland.wav'
	slowdown = 0
	smooth = SMOOTH_TRUE
	// Deliberately one-directional: snow/snowrough/snowpatchy list frozen_water so snow draws an
	// ice edge onto itself at the border, but ice doesn't list them back, so it never draws a
	// snow edge onto itself in turn - two overlapping edge overlays there produced visible
	// artifacts. grass/grasscold stay listed since that pairing isn't the one that looked wrong.
	canSmoothWith = list(/turf/open/floor/rogue/frozen_water,
						/turf/open/floor/rogue/grass,
						/turf/open/floor/rogue/grasscold,)
	neighborlay = "ice"
	/// Set by freeze_over(). Only seasonally-frozen ice thaws again - mapped ice is permanent.
	var/seasonal_freeze = FALSE
	/// Ice over water_level 3. Cracks and drops you through.
	var/thin_ice = FALSE
	/// Clean ice is slick. Bog crust is not - it's hummocked and rimed, you crunch through it.
	var/slippery_ice = TRUE

/turf/open/floor/rogue/frozen_water/cardinal_smooth(adjacencies)
	roguesmooth(adjacencies)

/turf/open/floor/rogue/frozen_water/examine(mob/user)
	. = ..()
	if(thin_ice)
		. += span_warning("It creaks. There is a lot of water under this.")

/// Melts back to whatever water this was laid over. Returns the new turf, or null if this ice
/// wasn't seasonal (mapper-placed) and shouldn't thaw at all.
/turf/open/floor/rogue/frozen_water/proc/thaw()
	if(!seasonal_freeze)
		return null
	return ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

/turf/open/floor/rogue/frozen_water/turf_destruction(damage_flag)
	. = ..()
	// Drop through to the water on our baseturf stack. Ice mapped straight onto the ground
	// has nothing underneath to fall into, so leave it be rather than scraping to bedrock.
	if(length(baseturfs) <= 1)
		return
	visible_message(span_danger("[src] splinters and gives way!"))
	playsound(src, 'sound/foley/waterenter.ogg', 100, FALSE)
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)

// Chopping or picking a hole in the ice puts the water back for the rest of the round -
// SSseason only re-freezes on a season change, so a hole you cut stays a hole. This is what
// keeps the fisher employed in winter: getfishingloot()'s freshwater list wants a real
// /turf/open/water underfoot, and the thaw-through leaves exactly the subtype that was there.
/turf/open/floor/rogue/frozen_water/attackby(obj/item/C, mob/user, params)
	if(length(baseturfs) > 1 && (istype(user.used_intent, /datum/intent/axe/chop) || istype(user.used_intent, /datum/intent/pick)))
		playsound(src, 'sound/foley/hit_rock.ogg', 100, TRUE)
		user.visible_message(span_notice("[user] starts cutting a hole in [src]."), span_notice("I start cutting a hole in [src]."))
		if(do_after(user, 5 SECONDS, target = src))
			user.changeNext_move(CLICK_CD_MELEE)
			turf_destruction("blunt")
		return
	. = ..()

/turf/open/floor/rogue/frozen_water/proc/ice_crack()
	for(var/mob/living/target in contents)
		target.Knockdown(SHOVE_KNOCKDOWN_HUMAN)
	turf_destruction("blunt")

/turf/open/floor/rogue/frozen_water/Entered(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/H = AM
	if(H.is_floor_hazard_immune())
		return
	if(HAS_TRAIT(H, TRAIT_LIGHT_STEP) || H.m_intent == MOVE_INTENT_SNEAK)
		return
	if(thin_ice && prob(25))
		to_chat(H, span_warning("The [src] under me begins to crack!"))
		addtimer(CALLBACK(src, PROC_REF(ice_crack)), 2 SECONDS, TIMER_UNIQUE)
		return
	if(slippery_ice && prob(20))
		var/list/possible_turfs = list()
		for(var/turf/T in range(1, H))
			if(T == src || T.density)
				continue
			possible_turfs += T
		if(!length(possible_turfs))
			return
		H.forceMove(pick(possible_turfs))
		to_chat(H, span_warning("I slip on [src]!"))

/turf/open/floor/rogue/frozen_water/deep
	name = "thin ice"
	desc = "Dark blue ice over deep water. You can see straight down through it."
	icon_state = "darkice"
	neighborlay = "darkice"
	thin_ice = TRUE

/turf/open/floor/rogue/frozen_water/mire
	name = "frozen mire"
	desc = "The bog has set into a rimed, hummocked crust, dead reeds still standing through it."
	icon_state = "bogice"
	neighborlay = "bogice"
	slowdown = 1
	slippery_ice = FALSE

/turf/open/floor/rogue/frozen_water/mire/deep
	name = "thin mire crust"
	desc = "A dark, sodden crust over deep bog. It sags underfoot."
	icon_state = "brownice"
	neighborlay = "brownice"
	thin_ice = TRUE
