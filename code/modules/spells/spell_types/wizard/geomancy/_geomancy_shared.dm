/obj/structure/earthen_wall
	name = "earthen wall"
	desc = "A wall of conjured stone. It will crumble in time."
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "basalt1"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	density = TRUE
	opacity = TRUE
	max_integrity = 300
	var/timeleft = 10 SECONDS

/obj/structure/earthen_wall/Initialize()
	. = ..()
	if(timeleft)
		QDEL_IN(src, timeleft)
