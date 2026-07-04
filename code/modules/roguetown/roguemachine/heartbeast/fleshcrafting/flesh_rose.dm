/obj/item/black_rose
	icon = 'icons/mob/actions/pestraspells.dmi'
	icon_state = "rot"
	name = "black rose"
	desc = "A sickly-sweet scented rose. Like honeyed rotten meat. Its dim petals seem laced with a black ooze that retreats away from your fingers."
	w_class = WEIGHT_CLASS_SMALL
	var/effect_desc = "You know this can be implanted with the cure rot miracle within a follower of Pestra. It protects her followers."

/obj/item/black_rose/examine(mob/user)
	. = ..()
	if(iscarbon(user))
		var/mob/living/carbon/c = user
		if(c.patron.type == /datum/patron/divine/pestra)
			. += span_info(effect_desc)
