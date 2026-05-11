// If there's ever more than 10 drinks maybe split this file OK?
/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals
	name = "fresh rosa petals"
	desc = "Crushed rosa petals with humor-balancing properties, yearing to be further dried to draw out its flavor."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "rosamatter"
	tastes = list("mild sweetness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/medicine/antidote = 1) //Extraordinarily minor.
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried
	name = "dried rosa petals"
	desc = "Dried rosa petals, fit for brewing a delicious tea with humor-balancing properties. Combining it with some pumpkin spice should help to elevate its fragrance even more."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "rosamatter_dried"
	tastes = list("mild sweetness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/medicine/antidote = 1)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_spiced
	name = "spiced rosa petals"
	desc = "A palmful of smells so delightfully rich, destined to be distilled into a damn fine cup of humor-balancing tea."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "rosamatter_spiced"
	tastes = list("mild sweetness" = 1, "a mouthful of cough-inducing powderiness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2, /datum/reagent/medicine/antidote = 1)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/coffeebeans
	name = "coffee beans"
	desc = "Freshly extracted coffee beans, with a hard texture. Should be roasted first."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "coffeebeans"
	tastes = list("unpleasant bitterness" = 1)
	bitesize = 1
	seed = /obj/item/seeds/coffee
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	cooked_type = /obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted
	name = "roasted coffee beans"
	desc = "Roasted coffee beans, with a much deeper flavor. Can be used to brew coffee. The variant grown in Azuria can be brewed without being ground."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "coffeebeans_roasted"
	tastes = list("rich caramel smoothness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/coffeebeans_spiced
	name = "spiced coffee beans"
	desc = "Roasted coffee beans, nestled atop a bed of fragrant pumpkin spice. It looks perfect for brewing a particularly rich kettle of coffee."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "coffeebeans_spiced"
	tastes = list("rich caramel smoothness" = 1, "a mouthful of cough-inducing powderiness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	name = "dried tea leaves"
	desc = "Dried tea leaves. Edible. Seeds can be extracted from them. Needs to be processed in a millstone." 
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "teadry"
	tastes = list("bitterness" = 1)
	seed = /obj/item/seeds/tea
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
	mill_result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground

/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground
	name = "ground tea leaves"
	desc = "Ground tea leaves that can be used to brew tea, or further combined with pumpkin spice."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "teaground"
	tastes = list("bitterness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_spiced
	name = "spiced tea leaves"
	desc = "A blend of coarsely-ground tea leaves and pumpkin spice, perfect for brewing the most relaxing drinks in all of Psydonia."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "teaground_spiced"
	tastes = list("bitterness" = 1, "a mouthful of cough-inducing powderiness" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/chocolate_spiced
	name = "spiced chocolate"
	desc = "A spiced sliver of heaven, awaiting to be brewed into a velvetly rich drink."
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "chocolate_spiced"
	bitesize = 2
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("sugary richness" = 1, "a mouthful of cough-inducing powderiness" = 1)
	faretype = FARE_LAVISH
	rotprocess = null
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/chocolate_spiced/On_Consume(mob/living/eater)
	if(islupian(eater) || isvulp(eater))
		to_chat(eater, span_warning("The spiced chocolate tastes delicious but my stomach churns violently!"))
		if(iscarbon(eater))
			var/mob/living/carbon/C = eater
			C.add_nausea(120) // enough to trigger vomiting
		eater.adjustToxLoss(5)
	return ..()
