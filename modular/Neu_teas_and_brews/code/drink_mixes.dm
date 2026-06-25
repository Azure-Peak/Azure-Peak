//defines for tea mix items, a workaround pots using only one input
/obj/item/reagent_containers/food/snacks/mix_taraxamint
	name = "Taraxacum-Mentha tea mix"
	desc = "A tea mix consisting of smothered herbs of Taraxacum and Mentha"
	icon = 'modular/Neu_teas_and_brews/icons/obj/tea_mixes.dmi'
	icon_state = "mix_taraxamint"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("overwhelming bitterness and mint" = 1)
	faretype = FARE_IMPOVERISHED
	eat_effect = null
	rotprocess = null
	foodtype = GROSS

/obj/item/reagent_containers/food/snacks/mix_utricasalvia
	name = "Urtica-Salvia tea mix"
	desc = "A tea mix consisting of smothered herbs of Urtica and Salvia"
	icon = 'modular/Neu_teas_and_brews/icons/obj/tea_mixes.dmi'
	icon_state = "mix_utricasalvia"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("overwhelming bitterness, wood and stinging" = 1)
	faretype = FARE_IMPOVERISHED
	eat_effect = null
	rotprocess = null
	foodtype = GROSS

/obj/item/reagent_containers/food/snacks/mix_sbiten
	name = "Sbiten honey mix"
	desc = "a brick of crystallized honey, infused with spices for extra comfort"
	icon = 'modular/Neu_teas_and_brews/icons/obj/tea_mixes.dmi'
	icon_state = "sbiten_brick"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("overwhelming bitterness, wood and stinging" = 1)
	faretype = FARE_FINE //because its a yammy honey
	eat_effect = null
	rotprocess = null
	foodtype = SUGAR

//NOT REALLY A TEA, but it kinda expands on smoking options and is a derivative of, so I think its kinda coolish
// also maybe in future someone will make tea bricks to use in the teapots and etc
/obj/item/reagent_containers/food/snacks/grown/tar_brick
	name = "Westleach Tar Brick"
	desc = "A brick of dark-brown tar made by separating boiled leaf residue from water, used by the travellers and the poor as a substitute for a quality leaf smokes. Use a knife to slice a piece off to smoke, you may try to smoke whole thing too however..."
	icon = 'modular/Neu_teas_and_brews/icons/obj/tar_brick.dmi'
	icon_state = "Tar_Brick4"
	bitesize = 6
	slice_path = /obj/item/reagent_containers/food/snacks/grown/tar_slice
	faretype = FARE_IMPOVERISHED
	slices_num = 4
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	dry = TRUE
	pipe_reagents = list(/datum/reagent/drug/nicotine = 120) //500 cigarettes
	eat_effect = /datum/status_effect/debuff/badmeal
	extra_eat_effect = /datum/status_effect/debuff/rotfood
	list_reagents = list(/datum/reagent/drug/nicotine = 5, /datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/bad_food = 5)
	grind_results = list(/datum/reagent/drug/nicotine = 20)

/obj/item/reagent_containers/food/snacks/grown/tar_brick/update_icon()
	if(slices_num)
		icon_state = "tar_brick[slices_num]"
	else
		icon_state = "tar_slice"

/obj/item/reagent_containers/food/snacks/grown/tar_brick/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 1)
			slices_num = 3
		if(bitecount == 2)
			slices_num = 2
		if(bitecount == 3)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/grown/tar_slice //the thing you are ACTUALLY supposed to smoke
	name = "Westleach Tar slice"
	icon = 'modular/Neu_teas_and_brews/icons/obj/tar_brick.dmi'
	icon_state = "tar_slice"
	bitesize = 1
	slices_num = FALSE
	slice_path = FALSE
	dry = TRUE
	eat_effect = /datum/status_effect/debuff/badmeal
	extra_eat_effect = /datum/status_effect/debuff/rotfood
	pipe_reagents = list(/datum/reagent/drug/nicotine = 30) 
	list_reagents = list(/datum/reagent/drug/nicotine = 5, /datum/reagent/consumable/nutriment = 1, /datum/reagent/toxin/bad_food = 1)
	grind_results = list(/datum/reagent/drug/nicotine = 10)
