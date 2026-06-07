
// -------------- RAISINS, GIBLETS, SWEETGLASS ------------------
/obj/item/reagent_containers/food/snacks/rogue/raisins
	name = "raisins"
	desc = "Jackberries that've been pruned of their juiciness, and turned into flavorful nuggets. Like the humble hardtack, so \
	too will these raisins outlast their creators.  When combined with honey and doused in a pot of boiling fat, it can birth \
	'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "raisins5"
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried jackberries" = 1, "shriveled bursts of sweetness" = 1)
	faretype = FARE_POOR
	eat_effect = null
	rotprocess = null
	process_step = 1
	foodtype = FRUIT

/obj/item/reagent_containers/food/snacks/rogue/raisins/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "raisins4"
	if(bitecount == 2)
		icon_state = "raisins3"
	if(bitecount == 3)
		icon_state = "raisins2"
	if(bitecount == 4)
		icon_state = "raisins1"

/obj/item/reagent_containers/food/snacks/rogue/raisins/CheckParts(list/parts_list, datum/crafting_recipe/R)
	..()
	for(var/obj/item/reagent_containers/food/snacks/M in parts_list)
		color = M.filling_color
		if(M.reagents)
			M.reagents.remove_reagent(/datum/reagent/consumable/nutriment, M.reagents.total_volume)
			M.reagents.trans_to(src, M.reagents.total_volume)
		qdel(M)

/obj/item/reagent_containers/food/snacks/rogue/raisins/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Coating the fruitied giblets with honey."))
		if(do_after(user, short_cooktime, target = src))
			name = "slathered jackberry giblets"
			desc = "Jackberried giblets, slathered in sweetness and awaiting to be baptized in a pot of boiling fat."
			icon_state = "honeyraisins"
			faretype = FARE_FINE
			color = null
			tastes = list("overpoweringly honeyed" = 1, "a burst of sweetness" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
			bitesize = 1
			process_step = 2
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass
			update_icon()
			qdel(I)
			return

//

/obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry
	name = "raspberried giblets"
	desc = "Raspberried giblets that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried raspberries" = 1, "shriveled bursts of tartness" = 1)
	color = "#FF2A00"

/obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Coating the fruitied giblets with honey."))
		if(do_after(user, short_cooktime, target = src))
			name = "slathered raspberry giblets"
			desc = "Raspberried giblets, slathered in sweetness and awaiting to be baptized in a pot of boiling fat."
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("overpoweringly honeyed" = 1, "a burst of sweetness" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/raspberry
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry
	name = "strawberried giblets"
	desc = "Strawberried giblets that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried strawberries" = 1, "shriveled bursts of sweetness" = 1)
	color = "#FF2A00"

/obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Coating the fruitied giblets with honey."))
		if(do_after(user, short_cooktime, target = src))
			name = "slathered strawberry giblets"
			desc = "Strawberried giblets, slathered in sweetness and awaiting to be baptized in a pot of boiling fat."
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("overpoweringly honeyed" = 1, "a burst of sweetness" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/strawberry
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry
	name = "blackberried giblets"
	desc = "Blackberried giblets that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried blackberries" = 1, "shriveled bursts of sour-sweetness" = 1)
	color = "#339AB7"

/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Coating the fruitied giblets with honey."))
		if(do_after(user, short_cooktime, target = src))
			name = "slathered blackberry giblets"
			desc = "Blackberried giblets, slathered in sweetness and awaiting to be baptized in a pot of boiling fat."
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("overpoweringly honeyed" = 1, "a burst of sweetness" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/blackberry
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/plum
	name = "plummic giblets"
	desc = "Plummic giblets that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried plums" = 1, "shriveled bursts of honey-sweetness" = 1)
	color = "#FF4F86"

/obj/item/reagent_containers/food/snacks/rogue/raisins/plum/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Coating the fruitied giblets with honey."))
		if(do_after(user, short_cooktime, target = src))
			name = "slathered plummic giblets"
			desc = "Plummic giblets, slathered in sweetness and awaiting to be baptized in a pot of boiling fat."
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("overpoweringly honeyed" = 1, "a burst of sweetness" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/plum
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/pear
	name = "peared giblets"
	desc = "Peared giblets that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried pears" = 1, "shriveled bursts of tarty-honeyiness" = 1)
	color = "#EAB14F"

/obj/item/reagent_containers/food/snacks/rogue/raisins/pear/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Coating the fruitied giblets with honey."))
		if(do_after(user, short_cooktime, target = src))
			name = "slathered peared giblets"
			desc = "Peared giblets, slathered in sweetness and awaiting to be baptized in a pot of boiling fat."
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("overpoweringly honeyed" = 1, "a burst of sweetness" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/pear
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine
	name = "tangerined giblets"
	desc = "Tangerined giblets that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried tangerines" = 1, "shriveled bursts of tarty-sweetness" = 1)
	color = "#FF9321"

/obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Coating the fruitied giblets with honey."))
		if(do_after(user, short_cooktime, target = src))
			name = "slathered tangerined giblets"
			desc = "Tangerined giblets, slathered in sweetness and awaiting to be baptized in a pot of boiling fat."
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("overpoweringly honeyed" = 1, "a burst of sweetness" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/tangerine
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/lemon
	name = "lemony giblets"
	desc = "Lemony giblets that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried lemons" = 1, "shriveled bursts of tarty-sourness" = 1)
	color = "#FFBD30"

/obj/item/reagent_containers/food/snacks/rogue/raisins/lemon/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Coating the fruitied giblets with honey."))
		if(do_after(user, short_cooktime, target = src))
			name = "slathered lemony giblets"
			desc = "Lemony giblets, slathered in sweetness and awaiting to be baptized in a pot of boiling fat."
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("overpoweringly honeyed" = 1, "a burst of sweetness" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lemon
			update_icon()
			qdel(I)
			return

/obj/item/reagent_containers/food/snacks/rogue/raisins/lime
	name = "limey giblets"
	desc = "Limey giblets that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried limes" = 1, "shriveled bursts of sour-tartiness" = 1)
	color = "#C3DB91"

/obj/item/reagent_containers/food/snacks/rogue/raisins/lime/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(process_step != 1)
			return
		to_chat(user, span_notice("Coating the fruitied giblets with honey."))
		if(do_after(user, short_cooktime, target = src))
			name = "slathered limey giblets"
			desc = "Limey giblets, slathered in sweetness and awaiting to be baptized in a pot of boiling fat."
			icon_state = "honeyraisins"
			color = null
			bitesize = 1
			process_step = 2
			faretype = FARE_FINE
			tastes = list("overpoweringly honeyed" = 1, "a burst of sweetness" = 1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
			deep_fried_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lime
			update_icon()
			qdel(I)
			return

//

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass
	name = "sweetglass"
	desc = "A palmful of crystallized jackberry-giblets, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	icon_state = "sweetglass5"
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR * 2)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("glassy jackberries" = 1, "sugary shards of sweetness" = 1)
	faretype = FARE_LAVISH
	color = "#A060FF" //Placeholder until someone wants to twiddle it for themselves. Should be fine, otherwise.
	eat_effect = /datum/status_effect/buff/sweet
	foodtype = FRUIT

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "sweetglass4"
	if(bitecount == 2)
		icon_state = "sweetglass3"
	if(bitecount == 3)
		icon_state = "sweetglass2"
	if(bitecount == 4)
		icon_state = "sweetglass1"

//

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/raspberry
	name = "raspberried sweetglass"
	desc = "A palmful of crystallized raspberry-giblets, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#FF2A00"
	tastes = list("glassy raspberries" = 1, "sugary shards of tartness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/strawberry
	name = "strawberried sweetglass"
	desc = "A palmful of crystallized strawberry-giblets, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#FF2A00"
	tastes = list("glassy strawberries" = 1, "sugary shards of sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/blackberry
	name = "blackberried sweetglass"
	desc = "A palmful of crystallized blackberry-giblets, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#339AB7"
	tastes = list("glassy blackberries" = 1, "sugary shards of sour-sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/plum
	name = "plummic sweetglass"
	desc = "A palmful of crystallized plum-giblets, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#FF4F86"
	tastes = list("glassy plums" = 1, "sugary shards of honey-sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/pear
	name = "peared sweetglass"
	desc = "A palmful of crystallized pear-giblets, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#EAB14F"
	tastes = list("glassy pears" = 1, "sugary shards of tarty-honeyiness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/tangerine
	name = "tangerine sweetglass"
	desc = "A palmful of crystallized tangerine-giblets, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#FF9321"
	tastes = list("glassy tangerines" = 1, "sugary shards of tarty-sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lemon
	name = "lemony sweetglass"
	desc = "A palmful of crystallized lemon-giblets, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#FFBD30"
	tastes = list("glassy lemons" = 1, "sugary shards of tarty-sourness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lime
	name = "limey sweetglass"
	desc = "A palmful of crystallized lemon-giblets, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#C3DB91"
	tastes = list("glassy lemons" = 1, "sugary shards of sour-tartiness" = 1)

// -------------- Trail-mix -----------------
/obj/item/reagent_containers/food/snacks/rogue/trailmix
	name = "trail-mix"
	desc = "A collection of dried and long lasting snacks tucked into a neat package to be indulged in as needed. Favorite of rangers due to its simplicity and availability."
	icon = 'modular/Neu_food/icons/cookware/ration.dmi'
	icon_state = "ration_large"//Prob give it'S own subtype later
	eat_effect = null
	fried_type = null
	bitesize = 7
	slice_batch = FALSE
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS * 3)
	tastes = list("raisin" = 1, "pumpkin" = 1, "dry paper" = 1)
	rotprocess = null
