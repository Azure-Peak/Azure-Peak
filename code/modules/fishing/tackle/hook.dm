/obj/item/fishing/hook
	attachtype = "hook"
	/// A bitfield of traits that this fishing hook has, checked by fish traits and the minigame
	var/fishing_hook_traits
	/// icon state added to main rod icon when this hook is equipped
	var/rod_overlay_icon_state = "hook_overlay"


/**
 * Simple getter proc for hooks to implement special hook bonuses for
 * certain `fish_type` (or FISHING_DUD), additive. Is applied after
 * `get_hook_bonus_multiplicative()`.
 */
/obj/item/fishing/hook/proc/get_hook_bonus_additive(fish_type)
	return FISHING_DEFAULT_HOOK_BONUS_ADDITIVE


/**
 * Simple getter proc for hooks to implement special hook bonuses for
 * certain `fish_type` (or FISHING_DUD), multiplicative. Is applied before
 * `get_hook_bonus_additive()`.
 */
/obj/item/fishing/hook/proc/get_hook_bonus_multiplicative(fish_type)
	return FISHING_DEFAULT_HOOK_BONUS_MULTIPLICATIVE

///Check if tha target can be caught by the hook
/obj/item/fishing/hook/proc/can_be_hooked(atom/target)
	return isitem(target)

///Any special effect when hooking a target that's not managed by the fishing rod.
/obj/item/fishing/hook/proc/hook_attached(atom/target, obj/item/fishingrod/rod)
	return

/**
 * Is there a reason why this hook couldn't fish in target_fish_source?
 * If so, return the denial reason as a string, otherwise return `null`.
 *
 * Arguments:
 * * target_fish_source - The /datum/fish_source we're trying to fish in.
 */
/obj/item/fishing/hook/proc/reason_we_cant_fish(datum/fish_source/target_fish_source)
	return null

/**
 * Helper proc to get the size ratio of a fish compared to its average
 * Returns a value like 0.8 (80% of average), 1.0 (average), 1.5 (150% of average)
 */
/obj/item/fishing/hook/proc/get_fish_size_ratio(fish_type_or_instance)
	if(!isfish(fish_type_or_instance))
		return 1.0

	var/obj/item/reagent_containers/food/snacks/fish/fish = fish_type_or_instance
	var/average = fish.average_size

	if(average <= 0)
		return 1.0

	return fish.size / average


/obj/item/fishing/hook/wooden
	name = "wooden gorge fishing hook"
	desc = "A fishing hook consisting of a small piece of wood, carved to points on both end. A simple fishing hook, more likely to fall out. Struggles with larger specimens."
	icon_state = "gorgehook"

/obj/item/fishing/hook/wooden/get_hook_bonus_additive(fish_type)
	return FISHING_HOOK_WOODEN_ADDITIVE

/obj/item/fishing/hook/wooden/get_hook_bonus_multiplicative(fish_type)
	var/multiplier = ..()

	if(!isfish(fish_type))
		return multiplier

	var/size_ratio = get_fish_size_ratio(fish_type)

	if(size_ratio >= FISHING_HOOK_WOODEN_HUGE_RATIO)
		multiplier *= FISHING_HOOK_WOODEN_HUGE_MULT
	else if(size_ratio >= FISHING_HOOK_WOODEN_LARGE_RATIO)
		multiplier *= FISHING_HOOK_WOODEN_LARGE_MULT

	return multiplier

/obj/item/fishing/hook/thorn
	name = "thorn fishing hook"
	desc = "A fishing hook carved out of a thorn. The barbs kill the fish, but prevent it from ever getting away."
	icon_state = "thornhook"
	fishing_hook_traits = FISHING_HOOK_NO_ESCAPE|FISHING_HOOK_KILL

/obj/item/fishing/hook/iron
	name = "iron fishing hook"
	desc = "An iron fishing hook. Reliable and weighted, making the bait less likely to bounce off the water bottom."
	icon_state = "ironhook"
	fishing_hook_traits = FISHING_HOOK_WEIGHTED
	rod_overlay_icon_state = "hook_weighted_overlay"

/obj/item/fishing/hook/deluxe
	name = "carved minnow hook"
	desc = "An elaborate hook in the shape of a minnow with two carved hook on either end. Scares off smaller fishes but attracts larger and more valuable one. It is designed to stay put in the water column, allowing a fisherman to manipulate it precisely to catch a fish."
	icon_state = "deluxehook"
	fishing_hook_traits = FISHING_HOOK_BIDIRECTIONAL

/obj/item/fishing/hook/deluxe/get_hook_bonus_multiplicative(fish_type)
	var/multiplier = ..()

	if(!isfish(fish_type))
		return multiplier

	var/size_ratio = get_fish_size_ratio(fish_type)

	if(size_ratio < FISHING_HOOK_MINNOW_RUNT_RATIO)
		multiplier *= FISHING_HOOK_MINNOW_RUNT_MULT
	else if(size_ratio < FISHING_HOOK_MINNOW_SMALL_RATIO)
		multiplier *= FISHING_HOOK_MINNOW_SMALL_MULT
	else if(size_ratio < FISHING_HOOK_MINNOW_BELOW_RATIO)
		multiplier *= FISHING_HOOK_MINNOW_BELOW_MULT
	else if(size_ratio >= FISHING_HOOK_MINNOW_BIG_RATIO)
		multiplier *= FISHING_HOOK_MINNOW_BIG_MULT

	return multiplier
