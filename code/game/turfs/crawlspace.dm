/turf/open/floor/rogue/crawl_space
	name = "crawlspace"
	desc = "Too small to pass without crawling."
	icon = 'icons/turf/roguefloor.dmi'
	icon_state = "crawlspace_1"
	neighborlay = "dirtedge"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/rogue/crawl_space/Initialize(mapload) //shitcode shitcode shitcode shitco
	. = ..()
	if(!icon_state == "crawlspace4")
		icon_state = "crawlspace_[rand(1, 3)]"

/turf/open/floor/rogue/crawl_space/CanPass(atom/movable/mover, turf/target)
	if(!..(mover, target))
		return FALSE
	if(isliving(mover))
		var/mob/living/L = mover
		if(!iscarbon(L))
			return TRUE
		if(L.mobility_flags & MOBILITY_STAND)
			if(L.client)
				to_chat(L, span_warning("I must crawl to fit in [src]."))
			return FALSE
	return TRUE
