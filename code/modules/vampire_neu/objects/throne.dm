/obj/structure/vampthrone
	name = "The Blood Throne"
	desc = "A big ominous throne, decorated with crimson and velvet silk lain upon an enchanted gilbranze chair of magnificence. It radiates opulance and elegance yet shimmers with unnatural presence."
	icon = 'icons/roguetown/misc/vthrone.dmi'
	icon_state = "throne"
	density = FALSE
	can_buckle = TRUE
	pixel_x = -32
	max_integrity = 999999
	buckle_lying = FALSE
	obj_flags = NONE

/obj/structure/vampthrone/examine(mob/user) //Some small neat lore-ish text, I didn't have to. This thing isn't even mapped in but hey, you gotta feel badass with this thing or else it ain't got aura.
	. = ..()
	if(user.mind?.has_antag_datum(/datum/antagonist/vampire/lord))
		. += span_bloody("These were always your lands to rule, let no dull-blooded or otherwise believe not. This throne was once one to rule these lands, now it will be the one that rules this world. Show them how a lord gets it done.")

/obj/structure/roguethrone/post_buckle_mob(mob/living/M)
	..()
	density = TRUE
	M.set_mob_offsets("bed_buckle", _x = 0, _y = 8)

/obj/structure/roguethrone/post_unbuckle_mob(mob/living/M)
	..()
	density = FALSE
	M.reset_offsets("bed_buckle")
