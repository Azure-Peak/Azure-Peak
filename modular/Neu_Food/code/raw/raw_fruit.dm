/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced
	name = "apple slice"
	icon = 'modular/Neu_Food/icons/raw/raw_fruit.dmi'
	icon_state = "apple_sliced"
	desc = "A neatly sliced bit of apple. Nicer to eat. Refined, even."
	faretype = FARE_FINE
	tastes = list("airy apple" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced
	name = "pumpkin slice"
	icon = 'modular/Neu_Food/icons/raw/raw_fruit.dmi'
	icon_state = "pumpkin_sliced"
	desc = "A neatly sliced bit of pumpkin. Typically cooked first."
	faretype = FARE_POOR
	tastes = list("pumpkin" = 1)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	rotprocess = SHELFLIFE_LONG

//

/obj/item/reagent_containers/food/snacks/grown/apple/gold
	seed = null //Ungrowable(?). Can be changed if someone wishes.
	name = "ambrosia"
	desc = "A golden apple, by any other name. You can see your own reflection in the golden apple's surface, as the fingers cradling it adopt a pleasant numbness."
	icon_state = "gapple"
	sellprice = 55 //Unsellable to the Hordemaster, but barterable as raw wealth - otherwise.
	faretype = FARE_FINE
	tastes = list("divinely crisp sweetness" = 1)
	trash = /obj/item/trash/gapplecore
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold
	slices_num = 3
	rotprocess = null
	eat_effect = /datum/status_effect/buff/snackbuff
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD, /datum/reagent/medicine/stronghealth = 12)

/obj/item/reagent_containers/food/snacks/grown/apple/gold/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 155, "size" = 1))

/obj/item/reagent_containers/food/snacks/grown/apple/gold/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/inhumen/matthios)
			. += span_rose("A fruit from the heavens, courageously plucked by Matthios while escaping with Astrata's divine fire.. or so, they say. Eating it will not only be quite tasty, but help mend my lesser wounds as well.")

/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold
	name = "sliceed ambrosia"
	icon_state = "gapple_sliced"
	desc = "A golden apple, parted into perfectly symmetrical thirds. Opulance has never tasted so sweet!"
	faretype = FARE_LAVISH
	rotprocess = null
	tastes = list("a sliver of divine sweetness" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD, /datum/reagent/medicine/stronghealth = 6)

/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 155, "size" = 1))

/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced/gold/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/inhumen/matthios)
			. += span_rose("Sliced fruit from the heavens, courageously plucked by Matthios while escaping with Astrata's divine fire.. or so, they say. Eating it will not only be quite tasty, but help mend my lesser wounds as well.")

/obj/item/trash/gapplecore
	name = "cored ambrosia"
	desc = "Hey, who turned out the lights? I thought the feast was just getting started!"
	icon_state = "gapplecore"
	icon = 'icons/roguetown/items/produce.dmi'

/obj/item/trash/gapplecore/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 77, "size" = 1))

/obj/item/trash/gapplecore/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/inhumen/matthios)
			. += span_rose("The remains of a heavenly fruit, courageously plucked by Matthios while escaping with Astrata's divine fire.. or so, they say. Such fruits're said to refresh and heal mortals more than any other morsel. </br>I can fetch more by bargaining with the Hoardmaster and those most-devout to greed.")

/obj/item/reagent_containers/food/snacks/grown/apple/gold/On_Consume(mob/living/eater)
	..()
	if(ishuman(eater))
		var/mob/living/carbon/human/H = eater
		if(!(H.real_name in bitten_names))
			bitten_names += H.real_name

/obj/item/reagent_containers/food/snacks/grown/apple/gold/blockproj(mob/living/carbon/human/H)

	if(prob(98))
		H.visible_message(span_notice("[H] is saved by the golden apple!"))
		H.dropItemToGround(H.head)
		return 1
	else
		H.dropItemToGround(H.head)
		return 0

/obj/item/reagent_containers/food/snacks/grown/apple/gold/equipped(mob/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.head == src)

			equippedloc = H.loc
			START_PROCESSING(SSobj, src)

/obj/item/reagent_containers/food/snacks/grown/apple/gold/process()
	. = ..()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.head == src)
			if(equippedloc != H.loc)
				H.dropItemToGround(H.head)

//
