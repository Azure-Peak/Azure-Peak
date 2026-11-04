/obj/item/proc/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	if(HAS_TRAIT(src, TRAIT_OMNI_BAIT))
		return 1
	var/catch_multiplier = 1

	var/list/properties = SSfishing.fish_properties[isfish(fish) ? fish.type : fish]
	//Bait matching likes doubles the chance
	var/list/fav_bait = properties[FISH_PROPERTIES_FAV_BAIT]
	for(var/bait_identifer in fav_bait)
		if(is_matching_bait(src, bait_identifer))
			catch_multiplier *= 2
	//Bait matching dislikes
	var/list/disliked_bait = properties[FISH_PROPERTIES_BAD_BAIT]
	for(var/bait_identifer in disliked_bait)
		if(is_matching_bait(src, bait_identifer))
			catch_multiplier *= 0.5
	return catch_multiplier

/obj/item/fishing/bait
	name = "rolled bait"
	desc = "A ball of something fish want, rolled to sit on a hook."
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "mixedbait"
	w_class = WEIGHT_CLASS_SMALL
	grid_width = 32
	grid_height = 32
	isbait = TRUE
	var/consumable = FALSE
	var/weighted = FALSE

/obj/item/fishing/bait/Initialize(mapload)
	. = ..()
	add_traits(list(TRAIT_FISHING_BAIT, TRAIT_BAIT_ALLOW_FISHING_DUD, TRAIT_OMNI_BAIT), INNATE_TRAIT)
	if(!consumable)
		ADD_TRAIT(src, TRAIT_BAIT_UNCONSUMABLE, INNATE_TRAIT)

///Called for every fish subtype by the fishing subsystem when initializing, to populate the list of fish that can be caught with this bait.
/obj/item/fishing/bait/proc/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	return TRUE

/obj/item/fishing/bait/examine_more(mob/user)
	. = ..()
	if(!HAS_TRAIT(user, TRAIT_EXPERT_FISHER))
		return

	var/list/known_fishes = list()
	for(var/obj/item/reagent_containers/food/snacks/fish/fish_type as anything in SSfishing.bait_catchables[type])
		if(initial(fish_type.fish_flags) & FISH_FLAG_SHOW_IN_CATALOG)
			known_fishes += capitalize(initial(fish_type.name))

	if(!length(known_fishes))
		return

	. += span_info("Fish this bait can catch: [english_list(known_fishes)].")

///Check if the fish is in the list of catchable fish for this bait. Return value is a multiplier.
/obj/item/fishing/bait/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = 0
	var/is_instance = istype(fish)
	var/list/fish_properties = SSfishing.fish_properties[is_instance ? fish.type : fish]
	if(is_type_in_list(src, fish_properties[FISH_PROPERTIES_FAV_BAIT]))
		multiplier += FISHING_BAIT_FAVOURITE_WEIGHT
	if(is_instance)
		if(is_catchable_fish(fish, fish_properties))
			multiplier += FISHING_BAIT_CATCHABLE_WEIGHT
	else if(fish in SSfishing.bait_catchables[type])
		multiplier += FISHING_BAIT_CATCHABLE_WEIGHT
	return multiplier

/obj/item/fishing/bait/meat
	name = "red bait"
	desc = "A small amount of meat, rolled into a ball. Tends to attract eels."
	icon_state = "meatbait"
	icon = 'icons/roguetown/items/fishing.dmi'
	consumable = TRUE
	bait_flag = DISH_MEAT

/obj/item/fishing/bait/meat/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	if(/datum/fish_trait/vegan in fish.fish_traits)
		return FALSE
	return TRUE

/obj/item/fishing/bait/meat/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	if(/datum/fish_trait/carnivore in fish.fish_traits)
		multiplier *= FISHING_BAIT_RED_CARNIVORE_MULT

	return multiplier

/obj/item/fishing/bait/dough
	name = "doughy bait"
	desc = "A small amount of dough, rolled into a ball. Tends to attract carps."
	icon = 'icons/roguetown/items/food.dmi'
	icon_state = "doughslice"
	icon = 'icons/roguetown/items/food.dmi'
	consumable = TRUE
	bait_flag = DISH_BREAD

/obj/item/fishing/bait/dough/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	if(/datum/fish_trait/carnivore in fish.fish_traits)
		return FALSE
	return TRUE

/obj/item/fishing/bait/dough/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	if(/datum/fish_trait/vegan in fish.fish_traits)
		multiplier *= FISHING_BAIT_DOUGH_HERBIVORE_MULT

	return multiplier

/obj/item/fishing/bait/gray
	name = "gray bait"
	desc = "A small amount of dough and meat, rolled into a ball. Attracts a little bit of everything."
	icon_state = "mixedbait"
	icon = 'icons/roguetown/items/fishing.dmi'
	consumable = TRUE
	bait_flag = DISH_BREAD | DISH_MEAT

/obj/item/fishing/bait/speckled
	name = "speckled bait"
	desc = "A complex blend of meat, flour, and berries rolled into a ball. Its smell scares off smaller fish."
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "speckledbait"
	consumable = TRUE
	bait_flag = DISH_BREAD | DISH_MEAT | DISH_FRUIT

/obj/item/fishing/bait/speckled/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	// Catches most things, excluding tiny fish
	if(fish.size < fish.average_size * 0.5)
		return FALSE
	return TRUE

/obj/item/fishing/bait/speckled/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	if(fish.size < fish.average_size * 0.9)
		multiplier *= FISHING_BAIT_SPECKLED_SMALL_MULT

	return multiplier

/obj/item/fishing/bait/shell
	name = "shell bait"
	desc = "Fish mince mixed with a crushed oyster's shell, used to lure shell-fishes of the bottom out of their dwelling. It is weighted to sink to the bottom."
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "mixedbait"
	color = "#cfc6ad"
	consumable = TRUE
	weighted = TRUE
	bait_flag = DISH_MEAT

/obj/item/fishing/bait/shell/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()
	if(multiplier <= 0)
		return multiplier

	if(/datum/fish_trait/heavy in fish.fish_traits)
		multiplier *= FISHING_BAIT_SHELL_DEMERSAL_MULT

	return multiplier

/obj/item/fishing/bait/deluxe
	name = "enchanted bait"
	desc = "A ball of unknown ingredients, formulated by Abyssorian priests. Rarely catches something truly special."
	icon = 'icons/roguetown/items/fishing.dmi'
	icon_state = "deluxebait"
	consumable = TRUE
	bait_quality = TRAIT_GREAT_QUALITY_BAIT

/obj/item/fishing/bait/deluxe/is_catchable_fish(obj/item/reagent_containers/food/snacks/fish/fish, list/fish_properties)
	return TRUE

/obj/item/fishing/bait/deluxe/check_bait(obj/item/reagent_containers/food/snacks/fish/fish)
	var/multiplier = ..()

	if(prob(FISHING_BAIT_ENCHANTED_CHANCE))
		multiplier *= FISHING_BAIT_ENCHANTED_MULT

	return multiplier
