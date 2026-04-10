// Raw veggies. Sliced variant or something please just put the rest in produce.dm
// Don't define the same shit twice holy shit.
// please don't include fruits that's in raw_fruits.dm

/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	name = "sliced onion"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "onion_sliced"
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	cooked_smell = /datum/pollutant/food/fried_onion

/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced
	name = "shredded cabbage"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "cabbage_sliced"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	cooked_smell = /datum/pollutant/food/fried_cabbage

/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced
	name = "potato cuts"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "potato_sliced"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	cooked_smell = /datum/pollutant/food/baked_potato

/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	name = "cucumber slice"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "cucumber_slices" // TG Sprite, replace it
	desc = ""
	tastes = list("crunchy freshness" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	name = "garlick clove"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "garlic_clove"
	faretype = FARE_POOR
	desc = "A clove of garlick, fit for stewage. Don't eat this."
	tastes = list("pungent savoriness" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/water/blessed = 2)

/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/powder/rocknut))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("Mixing garlick with the rocknut powder..."))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/pesto(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/pesto(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("You need to put [src] on a table to mix the pesto!"))

/obj/item/reagent_containers/food/snacks/veg/turnip_sliced
	name = "cleaned turnip"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "turnip_sliced"

/obj/item/reagent_containers/food/snacks/rogue/pesto
	name = "pesto"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "pesto"
	desc = "A luxurious local blend of rocknut, oil, and garlick. A blend invented by immigrants from Navarno. It's best served in a noodle dish as to not overwelm the Azurian palate."
	tastes = list("fresh nutty savoriness" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/water/blessed = 1, /datum/reagent/drug/nicotine = 1, /datum/reagent/consumable/acorn_powder = 4)
