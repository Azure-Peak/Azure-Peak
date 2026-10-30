//Dirt decals were not targetable directly as of writing this. If they ever are, best move this to /obj/effect/decal/cleanable/coom/
/turf/open/floor/onbite(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(L.stat != CONSCIOUS)
			return
		if(iscarbon(user))
			var/mob/living/carbon/C = user
			if(!C.lying)
				return
			if(C.is_mouth_covered())
				return
		for(var/obj/effect/decal/cleanable/coom/C in src)
			playsound(user, pick('sound/misc/mat/guymouth (1).ogg','sound/misc/mat/guymouth (2).ogg','sound/misc/mat/guymouth (3).ogg','sound/misc/mat/guymouth (4).ogg','sound/misc/mat/guymouth (5).ogg'), 100, FALSE, ignore_walls = FALSE)
			user.visible_message("<span class='love'>[user] starts cleaning [src].</span>")
			if(do_after(L, 25, target = src))
				playsound(user, pick('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg'), 100, FALSE, ignore_walls = FALSE)
				user.visible_message("<span class='love'>[user] cleaned [src] diligently.</span>")
				qdel(C)
			return
		return
	..()
