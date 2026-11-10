////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/// Note: When adding food items with dummy parents, make sure to add
/// the parent to the exclusion list in code/__HELPERS/unsorted.dm's
/// get_random_food proc.
////////////////////////////////////////////////////////////////////////////////

/obj/item/reagent_containers/food
	possible_transfer_amounts = list()
	volume = 50	//Sets the default container amount for all food items.
	reagent_flags = INJECTABLE
	resistance_flags = FLAMMABLE
	destroy_sound
	var/food_quality = NONE // GROSS / TOXIC, checked against species food preferences. What the dish is lives in dish_type on snacks
	var/last_check_time
	var/in_container = FALSE //currently just stops "was bitten X times!" messages on canned food
	var/fat_yield = 0 // How much tallow / oil can be rendered from this
	grid_width = 32
	grid_height = 32

/obj/item/reagent_containers/food/Initialize(mapload)
	. = ..()
	if(!mapload)
		pixel_x = rand(-5, 5)
		pixel_y = rand(-5, 5)

/obj/item/reagent_containers/food/proc/checkLiked(fraction, mob/M)
	if(last_check_time + 50 < world.time)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(!HAS_TRAIT(H, TRAIT_AGEUSIA) && !HAS_TRAIT(H, TRAIT_NASTY_EATER))
				if(food_quality & H.dna.species.toxic_food)
					to_chat(H,span_warning("What the hell was that thing?!"))
					H.adjust_disgust(25 + 30 * fraction)
				else if(food_quality & H.dna.species.disliked_food)
					to_chat(H,span_notice("That didn't taste very good..."))
					H.adjust_disgust(11 + 15 * fraction)
				else if(food_quality & H.dna.species.liked_food)
					to_chat(H,span_notice("I love this taste!"))
					H.adjust_disgust(-5 + -2.5 * fraction)
			else
				if(food_quality & H.dna.species.toxic_food)
					to_chat(H, span_warning("I don't feel so good..."))
					H.adjust_disgust(25 + 30 * fraction)

