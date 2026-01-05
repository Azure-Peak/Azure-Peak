// Currently the only multi-behavior quirk & the only interaction quirk
// May refactor territorial to be similar later
/datum/flesh_quirk/hoarder
	name = "Hoarder"
	description = "Acquires valuables, demands valuables, hates thieves."
	quirk_type = QUIRK_INTERACT | QUIRK_BEHAVIOR | QUIRK_ENVIRONMENT

	var/value_current = 3
	var/value_increment = 2
	var/value_cap = 20

	var/theft_cooldown = 6 MINUTES
	var/next_theft = 6 MINUTES

	color = "#cd7f32"
	required_item = /obj/item/alch/benedictus
	calibration_required = 3

/datum/flesh_quirk/hoarder/apply_behavior_quirk(score, mob/speaker, message, datum/component/chimeric_heart_beast/beast)
	// if happy, may not demand another item
	if(score >= 75 && prob(85))
		return score
	else
		if(prob(60))
			beast.satisfied = FALSE
		return score

/datum/flesh_quirk/hoarder/apply_environment_quirk(list/visible_turfs, datum/component/chimeric_heart_beast/beast)
	if(world.time < next_theft)
		return

	var/withdrawal_amount = calculate_withdrawal_amount(beast.language_tier)
	var/success = SStreasury.withdraw_money_treasury(withdrawal_amount, beast.heart_beast)

	if(success)
		convert_mammon_to_coins(withdrawal_amount, beast)
		next_theft = world.time + (theft_cooldown * beast.language_tier)
		// Might satisfy itself when stealing
		if(prob(5 * beast.language_tier))
			beast.satisfied = TRUE
		beast.heart_beast.visible_message(span_warning("Tendrils from [beast.heart_beast] root into the ground and pull out a glittering pile of coins!"))
	else
		// Treasury is empty or can't fulfill the request
		// Will try to steal again sooner
		next_theft = world.time + (theft_cooldown / 4)
		beast.heart_beast.visible_message(span_warning("Tendrils from [beast.heart_beast] root into the ground, but come up empty."))

/datum/flesh_quirk/hoarder/proc/calculate_withdrawal_amount(language_tier)
	var/base_min = 10
	var/base_max = 50
	var/tier_multiplier = language_tier

	var/min_amt = base_min * tier_multiplier
	var/max_amt = base_max * tier_multiplier

	// Generate a random number within the range, then round it to the nearest multiple of 5
	var/raw_amt = rand(min_amt, max_amt)
	var/final_amt
	var/multiple
	if(raw_amt > 100)
		multiple = 10
	else
		multiple = 5

	final_amt = round(raw_amt / multiple) * multiple
	return final_amt

/datum/flesh_quirk/hoarder/proc/convert_mammon_to_coins(amt, datum/component/chimeric_heart_beast/beast)
	if(!amt || amt < 1 || !beast)
		return

	var/obj/item/heart_item = beast.heart_beast
	var/turf/T = get_turf(heart_item)
	if(!T)
		return

	var/remaining_mammon = amt
	var/list/coins_to_spawn = list()

	if(remaining_mammon > 100)
		var/gold_count = floor(remaining_mammon / 10)
		coins_to_spawn[ /obj/item/roguecoin/gold ] = gold_count
		remaining_mammon -= gold_count * 10

	if(remaining_mammon > 20)
		var/silver_count = floor(remaining_mammon / 5)
		coins_to_spawn[ /obj/item/roguecoin/silver ] = silver_count
		remaining_mammon -= silver_count * 5

	if(remaining_mammon >= 1)
		coins_to_spawn[ /obj/item/roguecoin/copper ] = remaining_mammon

	var/turf/center_turf = T
	var/turf/T_left = locate(center_turf.x - 1, center_turf.y - 1, center_turf.z)
	var/turf/T_center = locate(center_turf.x, center_turf.y - 1, center_turf.z)
	var/turf/T_right = locate(center_turf.x + 1, center_turf.y - 1, center_turf.z)
	var/list/possible_locs = list(T_left, T_center, T_right)
	var/turf/new_loc = pick(possible_locs)

	// Spawn the stacks and apply the component
	for(var/coin_type in coins_to_spawn)
		var/coin_count = coins_to_spawn[coin_type]
		if(coin_count >= 1)
			var/obj/item/roguecoin/new_stack = new coin_type(T, coin_count)
			new_stack.AddComponent(/datum/component/hoarded_item, beast)
			new_stack.forceMove(new_loc)

	playsound(T, 'sound/misc/coindispense.ogg', 100, FALSE, -1)

/datum/flesh_quirk/hoarder/apply_item_interaction_quirk(obj/item/I, mob/user, datum/component/chimeric_heart_beast/beast)
	var/datum/component/hoarded_item/existing = I.GetComponent(/datum/component/hoarded_item)
	if(existing)
		beast.heart_beast.visible_message(span_warning("[beast.heart_beast] refuses the item!"))
		return FALSE

	// It can, and will get all the coin it wants itself, this is to challenge players
	if(istype(I, /obj/item/roguecoin))
		beast.heart_beast.visible_message(span_warning("[beast.heart_beast] seems to find the raw coin boring!"))
		return FALSE

	if(I.sellprice < value_current)
		beast.heart_beast.visible_message(span_warning("[beast.heart_beast] seems unimpressed!"))
		return FALSE

	beast.happiness = min(beast.happiness + (beast.max_happiness * 0.20), beast.max_happiness)
	value_current = min(value_current + value_increment, value_cap)

	I.AddComponent(/datum/component/hoarded_item, beast)
	beast.heart_beast.visible_message(span_notice("[beast.heart_beast] hoards the item with its tentacles."))

	// We'll calculate this each time just in case someone silly moves the heartbeast (please don't move the blorbo D:)
	var/turf/center_turf = get_turf(beast.heart_beast)
	var/turf/T_left = locate(center_turf.x - 1, center_turf.y - 1, center_turf.z)
	var/turf/T_center = locate(center_turf.x, center_turf.y - 1, center_turf.z)
	var/turf/T_right = locate(center_turf.x + 1, center_turf.y - 1, center_turf.z)
	var/list/possible_locs = list(T_left, T_center, T_right)
	var/turf/new_loc = pick(possible_locs)
	user.transferItemToLoc(I, new_loc, TRUE)
	beast.satisfied = TRUE

	return TRUE

/datum/flesh_quirk/hoarder/proc/handle_thief(obj/item/I, mob/living/user, datum/component/chimeric_heart_beast/beast)
	if(beast.happiness < (beast.max_happiness * 0.75))
		user.apply_status_effect(/datum/status_effect/territorial_rage, beast.heart_beast)
		beast.heart_beast.visible_message(span_userdanger("Tendrils from [beast.heart_beast] lash out at [user]!"))
	else
		beast.happiness = max(beast.happiness - (beast.max_happiness * 0.10), 0)
		beast.heart_beast.visible_message(span_userdanger("[beast.heart_beast] begrudingly relinquishes the item."))

/datum/component/hoarded_item
	var/datum/component/chimeric_heart_beast/heart_component
	var/datum/flesh_quirk/hoarder/hoarder_quirk
	var/mob/living/current_holder

/datum/component/hoarded_item/Initialize(datum/component/chimeric_heart_beast/heart)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	heart_component = heart
	RegisterSignal(parent, COMSIG_ITEM_PICKUP, .proc/on_pickup)
	RegisterSignal(parent, COMSIG_MOVABLE_MOVED, .proc/on_moved)
	RegisterSignal(parent, COMSIG_MOVABLE_POST_THROW, .proc/on_post_throw)

	// Find the hoarder quirk in the heart component
	hoarder_quirk = heart_component.active_quirks[/datum/flesh_quirk/hoarder]

	if(!hoarder_quirk)
		return COMPONENT_INCOMPATIBLE

/datum/component/hoarded_item/proc/on_pickup(datum/source, mob/user)
	SIGNAL_HANDLER
	var/obj/item/I = parent
	if(get_dist(I, heart_component.heart_beast) > 3)
		hoarder_quirk.handle_thief(I, user, heart_component)
		qdel(src)
		return

	current_holder = user
	RegisterSignal(current_holder, COMSIG_MOVABLE_MOVED, .proc/on_holder_moved)

/datum/component/hoarded_item/proc/on_moved(datum/source, atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER
	var/obj/item/I = parent

	if(is_item_stolen(I))
		var/mob/living/thief = find_culprit(I)

		if(thief)
			hoarder_quirk.handle_thief(I, thief, heart_component)
		qdel(src)
		return TRUE
	return FALSE

/datum/component/hoarded_item/proc/on_holder_moved(datum/source, atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	SIGNAL_HANDLER
	var/obj/item/I = parent

	// it's a good safety check
	if(I.loc != current_holder)
		UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED, .proc/on_holder_moved)
		current_holder = null
		return

	if(get_dist(source, heart_component.heart_beast) > 3)
		hoarder_quirk.handle_thief(I, current_holder, heart_component)
		UnregisterSignal(current_holder, COMSIG_MOVABLE_MOVED, .proc/on_holder_moved)
		qdel(src)

/datum/component/hoarded_item/proc/on_post_throw(datum/source, datum/thrownthing/TT, spin)
	SIGNAL_HANDLER
	var/obj/item/I = parent
	var/mob/living/thief = TT.thrower 

	if(isliving(thief))
		hoarder_quirk.handle_thief(I, thief, heart_component)
		qdel(src)
		return TRUE
	return FALSE

/datum/component/hoarded_item/proc/is_item_stolen(obj/item/I)
	if(get_dist(I, heart_component.heart_beast) > 3)
		return TRUE

	if(istype(I.loc, /obj/item/storage))
		return TRUE

	if(istype(I.loc, /obj/structure/closet))
		return TRUE
	
	// Further checks are handled by the movable on the mob itself
	return FALSE

/datum/component/hoarded_item/proc/find_culprit(obj/item/I)
	if(istype(I.loc, /obj/item/storage/roguebag))
		var/obj/item/storage/roguebag/bag = I.loc

		// The thief is the person holding the bag
		if(isliving(bag.loc))
			return bag.loc

	else if(istype(I.loc, /obj/structure/closet))
		var/obj/structure/closet/closet = I.loc

		// The thief is the nearest living mob within 1 tile of the closet.
		var/list/potential_targets = list()
		for(var/mob/living/L in range(1, closet))
			if(L.stat != DEAD)
				potential_targets += L
		if(potential_targets.len)
			return pick(potential_targets)

	var/turf/current_turf = get_turf(I)
	if(current_turf)
		var/list/potential_targets = list()
		for(var/atom/movable/A in range(2, current_turf))
			if(isliving(A))
				var/mob/living/L = A
				if(L.stat != DEAD)
					potential_targets += A
		if(potential_targets.len)
			return pick(potential_targets)

	return null
