/obj/item/reagent_containers/powder/flour/cornmeal
	name = "cornmeal"
	desc = "Coarsely ground maize, golden and sweet-smelling."
	icon = 'modular/Neu_Food/icons/raw/raw_corn.dmi'
	icon_state = "corn_flour"

/obj/item/reagent_containers/powder/flour/cornmeal/make_wet()
	name = "wet cornmeal"
	desc = "Moistened cornmeal, ready to be kneaded into masa."
	water_added = TRUE
	icon_state = "wet_flour"

/obj/item/reagent_containers/powder/flour/cornmeal/attack_hand(mob/living/user)
	if(water_added)
		playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
		if(do_after(user, short_cooktime, target = src))
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			new /obj/item/reagent_containers/food/snacks/rogue/corndough_base(loc)
			qdel(src)
	else
		..()

/obj/item/reagent_containers/food/snacks/rogue/corndough_base
	name = "unfinished corn dough"
	desc = "A rough ball of moistened cornmeal. A little bit more cornmeal will bind it into a corndough."
	icon = 'modular/Neu_Food/icons/raw/raw_corn.dmi'
	icon_state = "corndough_1"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/corndough
	name = "corn dough"
	desc = "Golden corn dough."
	icon = 'modular/Neu_Food/icons/raw/raw_corn.dmi'
	icon_state = "corndough_2"
	w_class = WEIGHT_CLASS_NORMAL
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cornbread

/obj/item/reagent_containers/food/snacks/rogue/corndough_honey
	name = "honeyed corn dough"
	desc = "Corn dough infused with honey, ready for the oven."
	icon = 'modular/Neu_Food/icons/raw/raw_corn.dmi'
	icon_state = "corndoughhoney"
	w_class = WEIGHT_CLASS_NORMAL
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cornbread_honey

/obj/item/reagent_containers/food/snacks/rogue/corn_flatdough
	name = "corn flatbread"
	desc = "Corn dough pressed flat, ready to fry into frybread."
	icon = 'modular/Neu_Food/icons/raw/raw_corn.dmi'
	icon_state = "corn_flat"
	w_class = WEIGHT_CLASS_NORMAL
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/cornfrybread

/obj/item/reagent_containers/food/snacks/rogue/corn_ball
	name = "corn dough ball"
	desc = "A pinched ball of corn dough, ready for the pan."
	icon = 'modular/Neu_Food/icons/raw/raw_corn.dmi'
	icon_state = "corn_ball"
	w_class = WEIGHT_CLASS_NORMAL
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/corn_ball_cooked
