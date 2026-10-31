/obj/item/reagent_containers/food/snacks/fish
	/// Flags for fish variables that would otherwise be TRUE/FALSE
	var/fish_flags = FISH_FLAG_SHOW_IN_CATALOG

	/// Required fluid type for this fish to live.
	var/required_fluid_type = FISH_FLUID_FRESHWATER

	// Fishing related properties

	/**
	 * List of fish trait types, these may modify probabilty/difficulty depending on rod/user properties
	 * or dictate how the fish behaves or some of its qualities.
	 */
	var/list/fish_traits = list()

	/// path to datums that dictate how the fish moves during the fishing minigame
	var/fish_movement_type = /datum/fish_movement

	/// Base additive modifier to fishing difficulty
	var/fishing_difficulty_modifier = 0

	/**
	 * Bait identifiers that make catching this fish easier and more likely
	 * Bait identifiers: Path | Trait | list("Type"="Foodtype","Value"= dish_type flag like [DISH_MEAT])
	 */
	var/list/favorite_bait = list()

	/**
	 * Bait identifiers that make catching this fish harder and less likely
	 * Bait identifiers: Path | Trait | list("Type"="Foodtype","Value"= dish_type flag like [DISH_MEAT])
	 */
	var/list/disliked_bait = list()

	/// Size in hands. Null until update_size_and_weight is called. Number of fillets scale with it.
	var/size
	/// Average size for this fish type in hands. Will be used as gaussian distribution with 20% deviation for fishing, bought fish are always standard size
	var/average_size = 5
	/// Temporarily stores the new size of the fish from randomize_size_and_weight() to be used by update_size_weight() later, so that it can be deferred.
	var/temp_size
	/// The maximum size this fish can reach, calculated the first time update_size_and_weight() is called.
	var/maximum_size

	/// Weight in pounds. Null until update_size_and_weight is called.
	var/weight
	/// Average weight for this fish type in pounds
	var/average_weight = 2
	/// Temporarily stores the new weight of the fish from randomize_size_and_weight() to be used by update_size_weight() later, so that it can be deferred.
	var/temp_weight
	/// The maximum weight this fish can reach, calculated the first time update_size_and_weight() is called.
	var/maximum_weight

	///The general deviation from the average weight and size this fish has in the wild
	var/weight_size_deviation = 0.2
	/// Price multiplier from traits, applied on top of the rarity multiplier whenever the price is recalculated.
	var/price_mult = 1

	/**
	 * An identifier for this fish used to track progress for fish caught between rounds in
	 * a way that's resilient to repathing (and removing paths). Only catchable fish need it.
	 * Once set, the value shouldn't be changed, so don't make typos.
	 */
	var/fish_id
	///Used to redirect to another fish path so that catching this fish unlocks its entry instead.
	var/obj/item/reagent_containers/food/snacks/fish/fish_id_redirect_path

	var/matrix/base_transform

/**
 * This proc takes a base size, base weight and deviation arguments to generate new size and weight through a gaussian distribution (bell curve)
 * Mainly used to determinate the size and weight of caught fish.
 */
/obj/item/reagent_containers/food/snacks/fish/proc/randomize_size_and_weight(base_size = average_size, base_weight = average_weight, deviation = weight_size_deviation, update = TRUE)
	var/size_deviation = 0.4 * base_size
	temp_size = round(clamp(gaussian(base_size, size_deviation), average_size * 1/MAX_FISH_DEVIATION_COEFF, average_size * MAX_FISH_DEVIATION_COEFF), FISH_MEASURE_PRECISION)
	var/expected_weight = base_weight * ((temp_size / base_size) ** FISH_WEIGHT_LENGTH_POWER)
	var/weight_deviation = FISH_WEIGHT_JITTER * expected_weight
	temp_weight = round(max(gaussian(expected_weight, weight_deviation), FISH_MEASURE_PRECISION), FISH_MEASURE_PRECISION)
	set_max_size_and_weight(temp_size, temp_weight, force = TRUE)
	if(update)
		update_size_and_weight(temp_size, temp_weight)
	var/size_ratio = temp_size / average_size
	var/weight_ratio = temp_weight / average_weight

	// Scale the visual size based on actual size/weight vs average
	// Use average of size and weight ratios for balanced scaling
	var/scale_ratio = (size_ratio + weight_ratio) / 2

	var/visual_scale = clamp(0.5 + (scale_ratio * 0.5), 0.5, FISH_MAX_VISUAL_SCALE)

	base_transform = matrix()
	base_transform.Scale(visual_scale)
	update_transform()


/obj/item/reagent_containers/food/snacks/fish/update_transform()
	. = ..()
	if(!base_transform || !isturf(loc))
		return
	var/matrix/M = matrix(base_transform)
	if(dropshrink)
		M.Scale(dropshrink, dropshrink)
	transform = M

///Set the maximum size and weight a fish can reach from base size and weight args.
///Always updates if called from randomize_size_and_weight (force = TRUE), otherwise only sets if uninitialized.
/obj/item/reagent_containers/food/snacks/fish/proc/set_max_size_and_weight(base_size, base_weight, force = FALSE)
	if(!maximum_size || force)
		maximum_size = min(base_size * 2, average_size * MAX_FISH_DEVIATION_COEFF)
	if(!maximum_weight || force)
		maximum_weight = min(base_weight * 2, average_weight * MAX_FISH_DEVIATION_COEFF)

///Updates weight and size, along with weight class and number of fillets you can get.
/obj/item/reagent_containers/food/snacks/fish/proc/update_size_and_weight(new_size = average_size, new_weight = average_weight)
	if(!size)
		set_max_size_and_weight(new_size, new_weight)

	size = new_size

	weight = new_weight

	slices_num = max(round(size / average_size * initial(slices_num), 1), 1)
	update_rarity()

/obj/item/reagent_containers/food/snacks/fish/examine(mob/user)
	. = ..()
	if(!size)
		return
	var/length_text = size < 1 ? "[round(size * FISH_INCHES_PER_HAND, 0.5)] inches" : "[round(size, 0.1)] hands"
	var/weight_text = weight < 1 ? "[round(weight * FISH_OUNCES_PER_POUND, 0.5)] ounces" : "[round(weight, 0.1)] pounds"
	. += span_notice("It is [length_text] long and weighs some [weight_text].")
	var/fillet_text = "It can be chopped into [slices_num] [slices_num == 1 ? "fillet" : "fillets"]"
	var/extra = slices_num - initial(slices_num)
	if(extra > 0)
		fillet_text += ", [extra] more than the usual due to its rarity"
	else if(extra < 0)
		fillet_text += ", [-extra] fewer than the usual"
	. += span_notice("[fillet_text].")

/obj/item/reagent_containers/food/snacks/fish/proc/apply_traits()
	for(var/fish_trait_type in fish_traits)
		var/datum/fish_trait/trait = GLOB.fish_traits[fish_trait_type]
		trait.apply_to_fish(src)

/obj/item/reagent_containers/food/snacks/fish/vv_edit_var(var_name, var_value)
	switch(var_name)
		if(NAMEOF(src, size))
			if(!isnum(var_value) || var_value == 0)
				return FALSE
			update_size_and_weight(var_value, weight)
		if(NAMEOF(src, weight))
			if(!isnum(var_value) || var_value == 0)
				return FALSE
			update_size_and_weight(size, var_value)
		else
			return ..()

	return TRUE

/// fish dies when its integrity reaches 50%
/obj/item/reagent_containers/food/snacks/fish/obj_break(damage_flag)
	. = ..()
	deconstruct()
	SEND_SIGNAL(src, COMSIG_FISH_STATUS_CHANGED)
