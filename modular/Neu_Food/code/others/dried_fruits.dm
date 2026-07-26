
// -------------- RAISINS, SWEETGLASS ------------------
/obj/item/reagent_containers/food/snacks/rogue/raisins
	cuisine = CUISINE_RANESHENI
	dish_type = DISH_FRUIT
	name = "raisins"
	desc = "Jackberries that've been pruned of their juiciness, and turned into flavorful nuggets. Like the humble hardtack, so \
	too will these raisins outlast their creators.  When combined with honey and doused in a pot of boiling fat, it can birth \
	'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "raisins5"
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried jackberries" = 1, "shriveled bursts of sweetness" = 1)
	faretype = FARE_POOR
	eat_effect = null
	rotprocess = null
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

//

/obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry
	name = "dried raspberries"
	desc = "Dried raspberries that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried raspberries" = 1, "shriveled bursts of tartness" = 1)
	color = "#FF2A00"

/obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry
	name = "dried strawberries"
	desc = "Dried strawberries that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried strawberries" = 1, "shriveled bursts of sweetness" = 1)
	color = "#FF2A00"

/obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry
	name = "dried blackberries"
	desc = "Dried blackberries that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried blackberries" = 1, "shriveled bursts of sour-sweetness" = 1)
	color = "#339AB7"

/obj/item/reagent_containers/food/snacks/rogue/raisins/plum
	name = "dried plums"
	desc = "Dried plums that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried plums" = 1, "shriveled bursts of honey-sweetness" = 1)
	color = "#FF4F86"

/obj/item/reagent_containers/food/snacks/rogue/raisins/pear
	name = "dried pears"
	desc = "Dried pears that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried pears" = 1, "shriveled bursts of tarty-honeyiness" = 1)
	color = "#EAB14F"

/obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine
	name = "dried tangerines"
	desc = "Dried tangerines that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried tangerines" = 1, "shriveled bursts of tarty-sweetness" = 1)
	color = "#FF9321"

/obj/item/reagent_containers/food/snacks/rogue/raisins/lemon
	name = "dried lemons"
	desc = "Dried lemons that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried lemons" = 1, "shriveled bursts of tarty-sourness" = 1)
	color = "#FFBD30"

/obj/item/reagent_containers/food/snacks/rogue/raisins/lime
	name = "dried limes"
	desc = "Dried limes that've been pruned of their juiciness, and turned into flavorful nuggets that'll last forever. When combined with honey and \
	doused in a pot of boiling fat, it can birth 'sweetglass'; a shatteringly sweet candy, popular amongst the elders and children-of-nobility."
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("dried limes" = 1, "shriveled bursts of sour-tartiness" = 1)
	color = "#C3DB91"

//

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass
	cuisine = NONE
	dish_type = DISH_FRUIT|DISH_SWEET
	name = "sweetglass"
	desc = "A palmful of crystallized dried raisins, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	icon_state = "sweetglass5"
	bitesize = 5
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
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
	name = "raspberry sweetglass"
	desc = "A palmful of crystallized dried raspberries, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#FF2A00"
	tastes = list("glassy raspberries" = 1, "sugary shards of tartness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/strawberry
	name = "strawberry sweetglass"
	desc = "A palmful of crystallized dried strawberries, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#FF2A00"
	tastes = list("glassy strawberries" = 1, "sugary shards of sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/blackberry
	name = "blackberry sweetglass"
	desc = "A palmful of crystallized dried blackberries, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#339AB7"
	tastes = list("glassy blackberries" = 1, "sugary shards of sour-sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/plum
	name = "plum sweetglass"
	desc = "A palmful of crystallized dried plums, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#FF4F86"
	tastes = list("glassy plums" = 1, "sugary shards of honey-sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/pear
	name = "pear sweetglass"
	desc = "A palmful of crystallized dried pears, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#EAB14F"
	tastes = list("glassy pears" = 1, "sugary shards of tarty-honeyiness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/tangerine
	name = "tangerine sweetglass"
	desc = "A palmful of crystallized dried tangerines, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#FF9321"
	tastes = list("glassy tangerines" = 1, "sugary shards of tarty-sweetness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lemon
	name = "lemon sweetglass"
	desc = "A palmful of crystallized dried lemons, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#FFBD30"
	tastes = list("glassy lemons" = 1, "sugary shards of tarty-sourness" = 1)

/obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lime
	name = "lime sweetglass"
	desc = "A palmful of crystallized dried limes, popular amongst the elders and children-of-nobility. Their tendancy to only \
	spoil under very specific circumstances makes it a favored treat for those traveling afar; so long as they can afford it, of course."
	color = "#C3DB91"
	tastes = list("glassy limes" = 1, "sugary shards of sour-tartiness" = 1)

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
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL * 3)
	tastes = list("raisin" = 1, "pumpkin" = 1, "dry paper" = 1)
	rotprocess = null
