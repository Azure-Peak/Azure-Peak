// -------------- SALUMOI (dwarven smoked sausage) -----------------
/obj/item/reagent_containers/food/snacks/rogue/meat/salami
	name = "salumoi"
	desc = "A salted sausage, said to last for ten yils before spoiling. As the legend goes, dwarven caravans used this 'travel food' to create the first sandwich: a slice of bread, crowned with this sliceable meat."
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "salumoi5"
	eat_effect = null
	fried_type = null
	slices_num = 4
	bitesize = 7
	slice_batch = FALSE
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice
	tastes = list("salted meat" = 1)
	rotprocess = null
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/salami/update_icon()
	if(slices_num)
		icon_state = "salumoi[slices_num]"
	else
		icon_state = "salumoi_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/salami/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 4
		if(bitecount == 4)
			slices_num = 3
		if(bitecount == 5)
			slices_num = 2
		if(bitecount == 6)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice
	eat_effect = null
	slices_num = 0
	name = "salumoi"
	icon_state = "salumoi_slice"
	faretype = FARE_NEUTRAL
	fried_type = null
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	bitesize = 2
	tastes = list("salted meat" = 1)

// -------------- COPPIETTE (dried meat) -----------------
/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette
	eat_effect = null
	name = "coppiette"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "jerk5"
	desc = "Dried mincesticks, prepared similarly to saloumi. While tougher to chew, it's certainly not as dry or firm as hardtack."
	faretype = FARE_POOR
	fried_type = null
	bitesize = 5
	slice_path = null
	tastes = list("salted meat" = 1)
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)

/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "jerk4"
	if(bitecount == 2)
		icon_state = "jerk3"
	if(bitecount == 3)
		icon_state = "jerk2"
	if(bitecount == 4)
		icon_state = "jerk1"

/obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette
	eat_effect = null
	name = "lemony stickets"
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "lemonstick5"
	desc = "'At times the world may seem an unfriendly and sinister place, but believe that there is much more good in it than \
	bad. All you have to do is look hard enough - and what might seem to be a series of unfortunate events may in fact be the \
	first steps of a refreshingly new journey.'"
	faretype = FARE_POOR
	fried_type = null
	bitesize = 5
	slice_path = null
	tastes = list("lip-puckering sweetness" = 1, "an unfortunate aftertaste of burnt wood" = 1)
	rotprocess = null
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)

/obj/item/reagent_containers/food/snacks/rogue/lemoncoppiette/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "lemonstick4"
	if(bitecount == 2)
		icon_state = "lemonstick3"
	if(bitecount == 3)
		icon_state = "lemonstick2"
	if(bitecount == 4)
		icon_state = "lemonstick1"

// -------------- SALO (salted fat) -----------------
/obj/item/reagent_containers/food/snacks/fat/salo
	name = "salo"
	desc = "Salted pork fat, slabbed and ready for a slicing. A classic amongst the peasantry's pantry, when leaner cuts of meat are scarce. Quite delicious if watered down."
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "salo4"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_CHUNKY)
	bitesize = 6
	slice_path = /obj/item/reagent_containers/food/snacks/fat/salo/slice
	faretype = FARE_IMPOVERISHED
	slices_num = 4
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	eat_effect = null

/obj/item/reagent_containers/food/snacks/fat/salo/update_icon()
	if(slices_num)
		icon_state = "salo[slices_num]"
	else
		icon_state = "salo_slice"

/obj/item/reagent_containers/food/snacks/fat/salo/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/fat/salo/slice
	name = "salo"
	icon_state = "saloslice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)

// ------------ PEMMICAN - BROTHBRICK --------------
/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique
	name = "brothbrique"
	desc = "A melding of dried meat, berries, and tallow that has fueled Psydonia's expeditioneers for centuries. It is \
	denser - and arguably less appetizing - than most foodstuffs, but consequently unrivaled in terms of sheer nutritional \
	mirth. Traditionally sliced and dropped into boiling water, in order to make a quick-yet-robust broth."
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "brothbrique4"
	eat_effect = null
	fried_type = null
	slices_num = 4
	bitesize = 6
	slice_batch = FALSE
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_CHUNKY * 2)
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/slice
	tastes = list("salted meat" = 1, "dried berries" = 1, "a slightly greasy aftertaste" = 1)
	rotprocess = null
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/update_icon()
	if(slices_num)
		icon_state = "brothbrique[slices_num]"
	else
		icon_state = "brothbrique_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 5)
			slices_num = 2
		if(bitecount == 7)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/meat/brothbrique/slice
	name = "slice of brothbrique"
	icon_state = "brothbrique_slice"
	bitesize = 3
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)

// ------------ HELLFIRE STEW - SALO N' TACK --------------
/obj/item/reagent_containers/food/snacks/balefire
	name = "salotack"
	desc = "Thick, salted biscuits and thicker, saltier slabs of pork fat, and a sprinkling of pepper; a match made in paradise. A spicier but heartier variant of the brothbrique, \
	its portions can be further divvied up with a knife and stewed into a remarkably hearty broth."
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "balefire4"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_CHUNKY * 2)
	bitesize = 4
	slice_path = /obj/item/reagent_containers/food/snacks/balefire/slice
	faretype = FARE_NEUTRAL
	slices_num = 4
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	eat_effect = null

/obj/item/reagent_containers/food/snacks/balefire/update_icon()
	if(slices_num)
		icon_state = "balefire[slices_num]"
	else
		icon_state = "balefire_slice"

/obj/item/reagent_containers/food/snacks/balefire/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/balefire/slice
	name = "piece of salotack"
	desc = "A salted cracker and a slice of pork fat, smothered in pepper. An adventurer can afford the tyme to sit down and stew this into a \
	hearty meal; for most other soldiers-of-fortune, however, they might just have to settle with gnashing it on the go."
	icon_state = "balefire_slice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT * 2)

// -------------- DRIED FISH FILET -----------------
/obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet
	name = "dried fish filet"
	desc = "A slab of aquatic meat, salted harder than the living thing was. A staple of any traveler alongside coastal regions, make sure to pack enough water with it."
	icon = 'modular/Neu_Food/icons/others/preserved_meat.dmi'
	icon_state = "dried_fish_filet"
	eat_effect = null
	fried_type = null
	bitesize = 3
	faretype = FARE_POOR
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
	tastes = list("salted fish" = 1)
	rotprocess = null
