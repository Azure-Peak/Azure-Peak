GLOBAL_LIST_INIT_TYPED(preset_fish_sources, /datum/fish_source, init_subtypes_w_path_keys(/datum/fish_source, list()))

// Each region on the map have a regional fish sources, so that fishers are encouraged to move region once the local fish population is depleted, instead of the global per water tile type pool being depleted like the original, so we can account for multiple fishers.
GLOBAL_LIST_EMPTY(regional_fish_sources)

/proc/get_regional_fish_source(source_path, area/region)
	var/key = "[source_path]-[region?.type]"
	var/datum/fish_source/source = GLOB.regional_fish_sources[key]
	if(!source)
		source = new source_path
		GLOB.regional_fish_sources[key] = source
	return source

/**
 * When adding new fishable rewards to a table/counts, you can specify an icon to show in place of the
 * generic fish icon in the minigame UI should the user have the TRAIT_REVEAL_FISH trait, by adding it to
 * this list.
 *
 * A lot of the icons here may be a tad inaccurate, but since we're limited to the free font awesome icons we
 * have access to, we got to make do.
 */
GLOBAL_LIST_INIT(specific_fish_icons, generate_specific_fish_icons())

/proc/generate_specific_fish_icons()
	var/list/return_list = zebra_typecacheof(list(
		/obj/item/reagent_containers/food/snacks/fish = FISH_ICON_DEF,
		/obj/item/reagent_containers/food/snacks/fish/crab = FISH_ICON_CRAB,
		/obj/item/reagent_containers/food/snacks/fish/lobster = FISH_ICON_CRAB,
		/obj/item/roguegem/oyster = FISH_ICON_GEM,
		/mob/living = FISH_ICON_HOSTILE,
	))

	return return_list

/**
 * Where the fish actually come from - every fishing spot has one assigned but multiple fishing holes
 * can share single source, ie single shared one for ocean/lavaland river
 */
/datum/fish_source
	/**
	 * Fish catch weight table - these are relative weights
	 * Keys are fish type paths, values are base weights
	 */
	var/list/fish_table = list()
	/// If a key from fish_table is present here, that fish is availible in limited quantity and is reduced by one on successful fishing
	var/list/fish_counts = list()
	/// Any limited quantity stuff in this list will be readded to the counts after a while
	var/list/fish_count_regen = list()
	/// A list of stuff that's currently waiting to be readded to fish_counts
	var/list/currently_on_regen
	/// Text shown as baloon alert when you roll a dud in the table
	var/duds = list("it was nothing", "the hook is empty")
	/// Baseline difficulty for fishing in this spot. THIS IS ADDED TO THE DEFAULT DIFFICULTY OF THE MINIGAME (15)
	var/fishing_difficulty = FISHING_DEFAULT_DIFFICULTY
	/// How the spot type is described in fish catalog section about fish sources, will be skipped if null
	var/catalog_description
	/// Background image name from /datum/asset/simple/fishing_minigame
	var/background = "background_default"
	///When linked to a fishing portal, this will be the icon_state of this option in the radial menu
	var/radial_state = "default"
	///When selected by the fishing portal, this will be the icon_state of the overlay shown on the machine.
	var/overlay_state = "portal_aquarium"
	///If set, this overrides the upper and lower bounds of how long you should wait during the waiting phase of the minigame.
	var/list/wait_time_range

	///List of multipliers used to make fishes more common compared to everything else depending on bait quality, indexed from best to worst.
	var/static/weight_result_multiplier = list(
		TRAIT_GREAT_QUALITY_BAIT = 9,
		TRAIT_GOOD_QUALITY_BAIT = 3.5,
		TRAIT_BASIC_QUALITY_BAIT = 2,
	)
	///List of exponents used to level out the table weight differences between fish depending on bait quality.
	var/static/weight_leveling_exponents = list(
		TRAIT_GREAT_QUALITY_BAIT = 0.7,
		TRAIT_GOOD_QUALITY_BAIT = 0.55,
		TRAIT_BASIC_QUALITY_BAIT = 0.4,
	)
	///Extra multiplier on the weight of valuable (prized) fish by bait quality.
	var/static/prized_pull_multiplier = list(
		TRAIT_GREAT_QUALITY_BAIT = 4,
		TRAIT_GOOD_QUALITY_BAIT = 2,
		TRAIT_BASIC_QUALITY_BAIT = 1,
	)

	//If set, fish types native to this source won't die if left on these turfs.
	var/list/associated_safe_turfs
	//list of subtypes of associated safe turfs that are NOT safe
	var/list/safe_turfs_blacklist

	/// Pool of generated fish instances for this roll (fish instance -> original path)
	var/list/obj/item/reagent_containers/food/snacks/fish/generated_fish_pool
	/// fish_counts as they were at creation, so stock can be read as a share of full.
	var/list/full_counts

/datum/fish_source/New()
	if(!SSfishing.initialized && associated_safe_turfs) //This is only needed during world init
		associated_safe_turfs = typecacheof(associated_safe_turfs)
		if(safe_turfs_blacklist)
			associated_safe_turfs -= typecacheof(safe_turfs_blacklist)
	full_counts = fish_counts.Copy()
	for(var/path in fish_counts)
		if(!(path in fish_table))
			stack_trace("path [path] found in the 'fish_counts' list but not in the 'fish_table'")
	for(var/path in fish_table)
		if(ispath(path, /obj/item/reagent_containers/food/snacks/fish) && isnull(fish_counts[path]))
			stack_trace("fish [path] in the 'fish_table' of [type] has no stock in 'fish_counts'; use FISH_STOCK_UNLIMITED for common fish")
	if(wait_time_range && length(wait_time_range) != 2)
		stack_trace("wait_time_range for [type] is set but has length different than two")
	for(var/path in fish_counts) //we give anything unique an auto 30 min regen, that way if the round is extended you still get content.
		if (is_limited(path) && !(path in fish_count_regen))
			fish_count_regen[path] = 30 MINUTES

/// Whether this result has a real stock that depletes. False for unlisted results and FISH_STOCK_UNLIMITED.
/datum/fish_source/proc/is_limited(path)
	var/stock = fish_counts[path]
	return !isnull(stock) && stock != FISH_STOCK_UNLIMITED

/// Whether this result is limited and currently out of stock.
/datum/fish_source/proc/is_exhausted(path)
	return is_limited(path) && fish_counts[path] <= 0

/// Share of the prized fish stock still in the water, 0 to 1. Null when the water has no prized fish. Fish with a stock of one are left out, or a water would read as fished out the moment its one sturgeon is taken.
/datum/fish_source/proc/prized_stock_ratio()
	var/full = 0
	var/left = 0
	for(var/path in fish_counts)
		if(!ispath(path, /obj/item/reagent_containers/food/snacks/fish) || !is_limited(path) || full_counts[path] <= 1)
			continue
		full += full_counts[path]
		left += max(fish_counts[path], 0)
	if(!full)
		return null
	return left / full

/datum/fish_source/proc/stock_description()
	var/ratio = prized_stock_ratio()
	if(isnull(ratio))
		return "There is nothing prized to be had here."
	if(ratio >= FISHING_STOCK_TEEMING_RATIO)
		return "These waters are teeming with prized fishes."
	if(ratio >= FISHING_STOCK_LOW_RATIO)
		return "These waters have been fished nearly bare."
	return "These waters are fished out."

/datum/fish_source/Destroy()
	cleanup_generated_fish()
	return ..()

/// Cleans up any generated fish instances from the pool
/datum/fish_source/proc/cleanup_generated_fish()
	if(!generated_fish_pool)
		return
	for(var/obj/item/reagent_containers/food/snacks/fish/fish in generated_fish_pool)
		if(!QDELETED(fish))
			qdel(fish)
	generated_fish_pool = null

/datum/fish_source/proc/release_generated_fish(obj/item/reagent_containers/food/snacks/fish/fish)
	if(!generated_fish_pool?[fish])
		return
	generated_fish_pool -= fish
	if(!QDELETED(fish))
		qdel(fish)

/// Generates a randomized fish instance from a path for filtering/checking
/datum/fish_source/proc/generate_fish_instance(fish_path)
	if(!ispath(fish_path, /obj/item/reagent_containers/food/snacks/fish))
		return null

	var/obj/item/reagent_containers/food/snacks/fish/fish = new fish_path()
	fish.randomize_size_and_weight()

	// Store in pool for cleanup and tracking
	if(!generated_fish_pool)
		generated_fish_pool = list()
	generated_fish_pool[fish] = fish_path

	return fish

/// Gets the original path of a generated fish instance
/datum/fish_source/proc/get_fish_path(atom/fish_or_path)
	if(isfish(fish_or_path))
		// Check if it's one of our generated instances
		if(generated_fish_pool?[fish_or_path])
			return generated_fish_pool[fish_or_path]
		return fish_or_path.type
	return fish_or_path

///Called when src is set as the fish source of a fishing spot component
/datum/fish_source/proc/on_fishing_spot_init(datum/component/fishing_spot/spot)
	return

///Called whenever a fishing spot with this fish source attached is deleted
/datum/fish_source/proc/on_fishing_spot_del(datum/component/fishing_spot/spot)

/// Can we fish in this spot at all. Returns DENIAL_REASON or null if we're good to go
/datum/fish_source/proc/reason_we_cant_fish(obj/item/fishingrod/rod, mob/fisherman, atom/parent)
	return rod.reason_we_cant_fish(src)

/// Called below above proc, in case the fishing source has anything to do that isn't denial
/datum/fish_source/proc/on_start_fishing(obj/item/fishingrod/rod, mob/fisherman, atom/parent)
	return

///Comsig proc from the fishing minigame for 'calculate_difficulty'
/datum/fish_source/proc/calculate_difficulty_minigame(datum/fishing_challenge/challenge, reward_path, obj/item/fishingrod/rod, mob/fisherman, list/difficulty_holder)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	difficulty_holder[1] += calculate_difficulty(reward_path, rod, fisherman)

	// Difficulty modifier added by the fisher's skill level
	if(!(challenge.special_effects & FISHING_MINIGAME_RULE_NO_EXP))
		var/skill_level = fisherman.get_skill_level(/datum/skill/labor/fishing)

		switch(skill_level)
			if(0)
				difficulty_holder[1] += 1
			if(1)
				difficulty_holder[1] += 0
			if(2)
				difficulty_holder[1] += -1
			if(3)
				difficulty_holder[1] += -3
			if(4)
				difficulty_holder[1] += -5
			if(5)
				difficulty_holder[1] += -7
			if(6)
				difficulty_holder[1] += -10


/**
 * Calculates the difficulty of the minigame:
 *
 * This includes the source's fishing difficulty, that of the fish, the rod,
 * favorite and disliked baits, fish traits and the fisherman skill.
 *
 * For non-fish, it's just the source's fishing difficulty minus the fisherman skill.
 */
/datum/fish_source/proc/calculate_difficulty(result, obj/item/fishingrod/rod, mob/fisherman)
	. = fishing_difficulty

	if(HAS_TRAIT(fisherman, TRAIT_EXPERT_FISHER))
		. += EXPERT_FISHER_DIFFICULTY_MOD

	// Difficulty modifier added by the rod
	. += rod.difficulty_modifier

	// If it's a fish instance from our pool, use it directly
	var/obj/item/reagent_containers/food/snacks/fish/caught_fish
	var/temporary_fish = FALSE
	if(isfish(result) && generated_fish_pool?[result])
		caught_fish = result
	else if(!ispath(result, /obj/item/reagent_containers/food/snacks/fish))
		// In the future non-fish rewards can have variable difficulty calculated here
		return
	else
		// Generate a temporary instance for difficulty calculation
		caught_fish = generate_fish_instance(result)
		if(!caught_fish)
			return
		temporary_fish = TRUE

	var/result_path = get_fish_path(result)

	// Baseline fish difficulty
	. += caught_fish.fishing_difficulty_modifier

	var/list/fish_properties = SSfishing.fish_properties[result_path]
	if(rod.baited)
		var/obj/item/bait = rod.baited
		//Fav bait makes it easier
		var/list/fav_bait = fish_properties[FISH_PROPERTIES_FAV_BAIT]
		for(var/bait_identifer in fav_bait)
			if(is_matching_bait(bait, bait_identifer))
				. += FAV_BAIT_DIFFICULTY_MOD
		//Disliked bait makes it harder
		var/list/disliked_bait = fish_properties[FISH_PROPERTIES_BAD_BAIT]
		for(var/bait_identifer in disliked_bait)
			if(is_matching_bait(bait, bait_identifer))
				. += DISLIKED_BAIT_DIFFICULTY_MOD

	// Matching/not matching fish traits and equipment
	var/list/fish_traits = caught_fish.fish_traits

	var/additive_mod = 0
	var/multiplicative_mod = 1
	for(var/fish_trait in fish_traits)
		var/datum/fish_trait/trait = GLOB.fish_traits[fish_trait]
		var/list/mod = trait.difficulty_mod(rod, fisherman)
		additive_mod += mod[ADDITIVE_FISHING_MOD]
		multiplicative_mod *= mod[MULTIPLICATIVE_FISHING_MOD]

	. += additive_mod
	. *= multiplicative_mod

	if(temporary_fish)
		release_generated_fish(caught_fish)


///Comsig proc from the fishing minigame for 'roll_reward'
/datum/fish_source/proc/roll_reward_minigame(datum/source, obj/item/fishingrod/rod, mob/fisherman, atom/location, list/rewards)
	SIGNAL_HANDLER
	SHOULD_NOT_OVERRIDE(TRUE)
	rewards += roll_reward(rod, fisherman, location)

/// Returns a fish instance or another special value which we use for dispensing a reward later.
/datum/fish_source/proc/roll_reward(obj/item/fishingrod/rod, mob/fisherman, atom/location)
	var/list/table = get_modified_fish_table(rod, fisherman, location)
	var/result = pickweight(table) || FISHING_DUD
	for(var/candidate in table)
		if(candidate != result && isfish(candidate))
			release_generated_fish(candidate)
	return result

/// Rolls the table for catches made without a rod, weighted as if it is baitless. Used for things like spears to avoid it overpowering baited rod with minigame. Returns a path or FISHING_DUD.
/datum/fish_source/proc/roll_simple_reward(atom/location)
	var/list/table = get_fish_table(location)
	for(var/result in table)
		if(!ispath(result, /obj/item/reagent_containers/food/snacks/fish))
			continue
		var/weight = round(table[result] * FISH_WEIGHT_MULT_WITHOUT_BAIT, 1)
		if(weight > 0)
			table[result] = weight
		else
			table -= result
	return pickweight(table) || FISHING_DUD

/// Roll only fish and creatures, for miracle compulsion. Returns a path or FISHING_DUD.
/datum/fish_source/proc/roll_compelled_reward(atom/location)
	var/list/table = get_fish_table(location)
	for(var/result in table)
		if(result == FISHING_DUD)
			continue
		if((ispath(result, /obj/item/reagent_containers/food/snacks/fish) || ispath(result, /mob/living)) && !is_limited(result))
			continue
		table -= result
	return pickweight(table) || FISHING_DUD

/**
 * Used to register signals or add traits and the such right after conditions have been cleared
 * and before the minigame starts.
 */
/datum/fish_source/proc/pre_challenge_started(obj/item/fishingrod/rod, mob/user, datum/fishing_challenge/challenge)
	return

///Proc called when the challenge is interrupted within the fish source code.
/datum/fish_source/proc/interrupt_challenge(reason)
	SEND_SIGNAL(src, COMSIG_FISHING_SOURCE_INTERRUPT_CHALLENGE, reason)

/**
 * Proc called when the COMSIG_MOB_COMPLETE_FISHING signal is sent.
 * Check if we've succeeded. If so, write into memory and dispense the reward.
 */
/datum/fish_source/proc/on_challenge_completed(mob/user, datum/fishing_challenge/challenge, success)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)
	UnregisterSignal(user, COMSIG_MOB_COMPLETE_FISHING)
	if(!success)
		release_generated_fish(challenge.reward_path)
		return
	var/atom/movable/reward = dispense_reward(challenge.reward_path, user, challenge.location, challenge)
	SEND_SIGNAL(challenge.used_rod, COMSIG_FISHING_ROD_CAUGHT_FISH, reward, user)
	challenge.used_rod.on_reward_caught(reward, user)
	release_generated_fish(challenge.reward_path)

/// Gives out the reward if possible.
/datum/fish_source/proc/dispense_reward(reward_path, mob/fisherman, atom/fishing_spot, datum/fishing_challenge/challenge)
	if(ispath(reward_path, /mob/living) && HAS_TRAIT(fisherman, TRAIT_EXPERT_FISHER))
		fisherman.balloon_alert(fisherman, "UH OH!")
		to_chat(fisherman, span_warning("Something is wrong with this catch. I should get back!"))
		playsound(fisherman, 'sound/misc/notice (2).ogg', 60)
		addtimer(CALLBACK(src, PROC_REF(simple_dispense_reward), reward_path, get_turf(fisherman), fishing_spot), FISHING_HOSTILE_WARNING_DELAY)
		return
	var/count_key = get_fish_path(reward_path)
	var/atom/movable/reward = simple_dispense_reward(reward_path, get_turf(fisherman), fishing_spot)
	if(!reward) //balloon alert instead
		fisherman.balloon_alert(fisherman, pick(duds))
		return
	if(isfish(reward) && challenge)
		challenge.apply_catch_quality(reward)
	if(isfish(reward) && is_exhausted(count_key))
		to_chat(fisherman, span_smallred("That was the last [initial(reward.name)] in these waters for a while."))
	if(isitem(reward)) //Try to put it in hand
		INVOKE_ASYNC(fisherman, TYPE_PROC_REF(/mob, put_in_hands), reward)
	else if(istype(reward, /obj/effect/spawner)) // Do not attempt to forceMove() a spawner. It will break things, and the spawned item should already be at the mob's turf by now.
		fisherman.balloon_alert(fisherman, "caught something!")
		return
	fisherman.balloon_alert(fisherman, "caught [reward]!")
	to_chat(fisherman, span_notice("I caught \a [reward]."))
	return reward

///Simplified version of dispense_reward that doesn't need a fisherman.
/datum/fish_source/proc/simple_dispense_reward(reward_path, atom/spawn_location, atom/fishing_spot)
	if(isnull(reward_path))
		return null

	if(!spend_reward_count(reward_path))
		return null

	var/atom/movable/reward = spawn_reward(reward_path, spawn_location, fishing_spot)
	SEND_SIGNAL(src, COMSIG_FISH_SOURCE_REWARD_DISPENSED, reward)
	return reward

/datum/fish_source/proc/spend_reward_count(reward_path)
	var/count_key = get_fish_path(reward_path)
	if(!is_limited(count_key))
		return TRUE
	if(fish_counts[count_key] <= 0)
		return FALSE
	fish_counts[count_key] -= 1
	var/regen_time = fish_count_regen?[count_key]
	if(regen_time)
		LAZYADDASSOC(currently_on_regen, count_key, 1)
		if(currently_on_regen[count_key] == 1)
			addtimer(CALLBACK(src, PROC_REF(regen_count), count_key), regen_time)
	return TRUE

/datum/fish_source/proc/regen_count(reward_path)
	if(!LAZYACCESS(currently_on_regen, reward_path))
		return
	fish_counts[reward_path] += 1
	currently_on_regen[reward_path] -= 1
	if(currently_on_regen[reward_path] <= 0)
		LAZYREMOVE(currently_on_regen, reward_path)
		return
	var/regen_time = fish_count_regen[reward_path]
	addtimer(CALLBACK(src, PROC_REF(regen_count), reward_path), regen_time)

/// Spawns a reward from a fish instance or path right where the fisherman is. Part of the dispense_reward() logic.
/datum/fish_source/proc/spawn_reward(reward_path, atom/spawn_location, atom/fishing_spot)
	if(reward_path == FISHING_DUD)
		return

	// If it's one of our generated fish instances, move it to the world
	if(isfish(reward_path) && generated_fish_pool?[reward_path])
		var/obj/item/reagent_containers/food/snacks/fish/fish = reward_path
		// Remove from pool so it doesn't get cleaned up
		generated_fish_pool -= fish
		fish.forceMove(spawn_location)
		fish.update_transform()
		return fish

	if(ismovable(reward_path))
		var/atom/movable/reward = reward_path
		reward.forceMove(spawn_location)
		return reward
	if(!ispath(reward_path, /atom/movable))
		CRASH("Unsupported /datum path [reward_path] passed to fish_source/proc/spawn_reward()")
	var/atom/movable/reward = new reward_path(spawn_location)
	if(isfish(reward))
		var/obj/item/reagent_containers/food/snacks/fish/caught_fish = reward
		caught_fish.randomize_size_and_weight()
	return reward

/// Returns the fish table, with the unavailable items from fish_counts removed.
/datum/fish_source/proc/get_fish_table(atom/location)
	var/list/table = fish_table.Copy()
	for(var/result in table)
		if(is_exhausted(result))
			table -= result
	return table

/// Builds a fish weights table modified by bait/rod/user properties
/datum/fish_source/proc/get_modified_fish_table(obj/item/fishingrod/rod, mob/fisherman, atom/location)
	var/obj/item/bait = rod.baited
	///An exponent used to level out the table weight differences between fish depending on bait quality.
	var/leveling_exponent = 0
	///Multiplier used to make fishes more common compared to everything else.
	var/result_multiplier = 1
	///Multiplier on counted fish only.
	var/prized_multiplier = 1
	var/skill_level = fisherman ? min(fisherman.get_skill_level(/datum/skill/labor/fishing), SKILL_LEVEL_LEGENDARY) : SKILL_LEVEL_NONE
	var/skill_prized_multiplier = fishing_skill_prized_mult(skill_level)

	var/list/base_table = get_fish_table(location)
	var/list/final_table = list()

	if(bait)
		for(var/trait in weight_result_multiplier)
			if(HAS_TRAIT(bait, trait))
				result_multiplier = weight_result_multiplier[trait]
				leveling_exponent = weight_leveling_exponents[trait]
				prized_multiplier = prized_pull_multiplier[trait]
				break

	if(HAS_TRAIT(rod, TRAIT_ROD_REMOVE_FISHING_DUD))
		base_table -= FISHING_DUD

	// Generate fish instances and build the weighted table
	for(var/result in base_table)
		var/weight = base_table[result]
		var/obj/item/reagent_containers/food/snacks/fish/fish = generate_fish_instance(result)

		// Apply hook bonuses first
		weight *= rod.hook.get_hook_bonus_multiplicative(fish || result)
		weight += rod.hook.get_hook_bonus_additive(fish || result)

		// Handle living mobs
		if(ispath(result, /mob/living))
			if(bait && (HAS_TRAIT(bait, TRAIT_GOOD_QUALITY_BAIT) || HAS_TRAIT(bait, TRAIT_GREAT_QUALITY_BAIT)))
				weight = round(weight * result_multiplier, 1)
				if(weight > 0)
					final_table[result] = weight
				continue

		if(fish)
			if(bait)
				weight = round(weight * result_multiplier, 1)
				if(is_limited(result))
					weight = round(weight * prized_multiplier, 1)
				var/mult = bait.check_bait(fish)
				weight = round(weight * mult, 1)
				if(mult > 1 && HAS_TRAIT(bait, TRAIT_BAIT_ALLOW_FISHING_DUD))
					final_table -= FISHING_DUD
			else
				weight = round(weight * FISH_WEIGHT_MULT_WITHOUT_BAIT, 1) //Fishing without bait is not going to be easy
			if(is_limited(result))
				weight = round(weight * skill_prized_multiplier, 1)

			// Apply fish trait modifiers using the actual fish instance
			weight = get_fish_trait_catch_mods(weight, fish, rod, fisherman, location)

			if(weight > 0)
				// Use the fish instance as the key instead of the path
				final_table[fish] = weight
			else
				release_generated_fish(fish)
		else
			// Non-fish items
			if(weight > 0)
				final_table[result] = weight

	if(final_table[FISHING_DUD])
		final_table[FISHING_DUD] = max(round(final_table[FISHING_DUD] * fishing_skill_dud_mult(skill_level), 1), 1)

	if(leveling_exponent)
		level_out_fish(final_table, leveling_exponent)

	return final_table

///A proc that levels out the weights of various fish, leading to rarer fishes being more common.
/datum/fish_source/proc/level_out_fish(list/table, exponent)
	var/highest_fish_weight
	var/list/collected_fish_weights = list()
	for(var/fishable in table)
		if(!isfish(fishable))
			continue
		var/fish_weight = table[fishable]
		collected_fish_weights[fishable] = fish_weight
		if(fish_weight > highest_fish_weight)
			highest_fish_weight = fish_weight

	for(var/fish in collected_fish_weights)
		var/difference = highest_fish_weight - collected_fish_weights[fish]
		if(!difference)
			continue
		table[fish] += round(difference**exponent, 1)

/datum/fish_source/proc/get_fish_trait_catch_mods(weight, obj/item/reagent_containers/food/snacks/fish/fish, obj/item/fishingrod/rod, mob/user, atom/location)
	if(!fish)
		return weight

	var/multiplier = 1
	var/list/fish_traits = fish.fish_traits
	var/result_path = get_fish_path(fish)

	for(var/fish_trait in fish_traits)
		var/datum/fish_trait/trait = GLOB.fish_traits[fish_trait]
		var/list/mod = trait.catch_weight_mod(rod, user, location, result_path)
		weight += mod[ADDITIVE_FISHING_MOD]
		multiplier *= mod[MULTIPLICATIVE_FISHING_MOD]

	return round(weight * multiplier, 1)

///returns true if this fishing spot has fish that are shown in the catalog.
/datum/fish_source/proc/has_known_fishes(atom/location)
	for(var/reward in get_fish_table(location))
		if(!ispath(reward, /obj/item/reagent_containers/food/snacks/fish))
			continue
		var/obj/item/reagent_containers/food/snacks/fish/prototype = reward
		if(initial(prototype.fish_flags) & FISH_FLAG_SHOW_IN_CATALOG)
			return TRUE
	return FALSE

///Add a string with the names of catchable fishes to the examine text.
/datum/fish_source/proc/get_catchable_fish_names(mob/user, atom/location, list/examine_text)
	var/list/known_fishes = list()

	var/obj/item/fishingrod/rod = user.get_active_held_item()
	var/list/final_table
	if(!istype(rod) || !rod.hook)
		rod = null
	else
		final_table = get_modified_fish_table(rod, user, location)

	var/total_weight = 0
	var/list/rodless_weights = list()
	var/total_rod_weight = 0
	var/list/rod_weights = list()
	var/list/table = get_fish_table(location)
	for(var/reward in table)
		var/weight = table[reward]
		if(!ispath(reward, /obj/item/reagent_containers/food/snacks/fish))
			continue

		var/obj/item/reagent_containers/food/snacks/fish/prototype = reward
		if(!(initial(prototype.fish_flags) & FISH_FLAG_SHOW_IN_CATALOG))
			continue

		if(rod)
			// Find the matching fish instance in the final table
			var/final_weight = 0
			for(var/fish_instance in final_table)
				if(isfish(fish_instance) && get_fish_path(fish_instance) == reward)
					final_weight = final_table[fish_instance]
					break

			total_weight += weight
			total_rod_weight += final_weight
			rodless_weights[reward] = weight
			rod_weights[reward] = final_weight
		else
			known_fishes += capitalize(initial(prototype.name))

	if(rod)
		for(var/reward in rodless_weights)
			var/percent_weight = rodless_weights[reward] / total_weight
			var/percent_rod_weight = rod_weights[reward] / total_rod_weight
			var/obj/item/reagent_containers/food/snacks/fish/prototype = reward
			var/init_name = capitalize(initial(prototype.name))
			var/ratio = percent_rod_weight ? percent_weight/percent_rod_weight : INFINITY
			if(ratio < 0.3)
				init_name = span_bold("<u>[init_name]</u>")
			else if(ratio < 0.9)
				init_name = span_bold(init_name)
			else if(ratio > 1.1)
				init_name = span_italics(init_name)
			known_fishes += init_name

		for(var/candidate in final_table)
			if(isfish(candidate))
				release_generated_fish(candidate)

	if(!length(known_fishes))
		return

	examine_text += span_info("Fish in these waters: [english_list(known_fishes)].")
	if(rod)
		examine_text += span_tinynoticeital("Bolded are likelier to catch with my current setup, underlined far likelier, italics unlikely.")
