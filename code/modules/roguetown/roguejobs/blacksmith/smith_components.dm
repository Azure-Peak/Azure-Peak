/datum/component/anvil_quenchable
	var/obj/item/ingot/associated_ingot

/datum/component/anvil_quenchable/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/forging
	var/datum/anvil_recipe/current_recipe
	var/progress = 0
	var/forging_stage = FORGING_STAGE_READY
	var/skill_quality = 0
	var/material_quality = 0
	var/bar_health = 100
	var/numberofhits = 0
	var/numberofbreakthroughs = 0
	var/needed_item
	var/needed_item_text
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/forging/Initialize(recipe_path)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

	if(recipe_path)
		set_recipe(recipe_path)

	// Register signals from the anvil and hammer that will act on this component
	RegisterSignal(parent, COMSIG_ITEM_PLACED_ON_ANVIL, .proc/on_placed_on_anvil)
	RegisterSignal(parent, COMSIG_ITEM_REMOVED_FROM_ANVIL, .proc/on_removed_from_anvil)
	RegisterSignal(parent, COMSIG_ITEM_HAMMERED_ON_ANVIL, .proc/on_hammered_on_anvil)
	RegisterSignal(parent, COMSIG_ITEM_ADDED_TO_FORGING, .proc/on_item_added_to_forging)
	RegisterSignal(parent, COMSIG_ITEM_QUENCHED, .proc/on_quenched)

/datum/component/forging/proc/on_quenched(obj/item/source, mob/living/user, turf/used_turf)
	SIGNAL_HANDLER
	handle_creation(used_turf, user)

/datum/component/forging/proc/set_recipe(recipe_path)
	var/datum/anvil_recipe/original_recipe = locate(recipe_path) in GLOB.anvil_recipes
	if(!original_recipe)
		return
	current_recipe = new original_recipe.type()
	if(current_recipe)
		if(istype(parent, /obj/item/blade))
			current_recipe.using_blade = TRUE
			if(current_recipe.additional_items.len > 0)
				for(var/i in 1 to current_recipe.additional_items.len)
					var/path = current_recipe.additional_items[i]
					// Make sure we're ONLY removing ingots, nothing else
					if(ispath(path, /obj/item/ingot))
						current_recipe.additional_items.Cut(i, i+1)
						break // Only remove ONE ingot
		else
			current_recipe.using_blade = FALSE
		material_quality = current_recipe.material_quality
		progress = 0
		forging_stage = FORGING_STAGE_ACTIVE

/datum/component/forging/proc/on_placed_on_anvil(datum/source, obj/machinery/anvil/anvil)
	SIGNAL_HANDLER
	forging_stage = FORGING_STAGE_ACTIVE
	to_chat(usr, span_notice("You place [parent] on the anvil, ready for forging."))

/datum/component/forging/proc/on_removed_from_anvil(datum/source, obj/machinery/anvil/anvil)
	SIGNAL_HANDLER
	forging_stage = FORGING_STAGE_READY
	to_chat(usr, span_notice("You remove [parent] from the anvil."))

/datum/component/forging/proc/on_hammered_on_anvil(datum/source, obj/machinery/anvil/anvil, mob/user, obj/item/hammer, breakthrough = FALSE)
	SIGNAL_HANDLER
	if(forging_stage != FORGING_STAGE_ACTIVE || !current_recipe)
		return

	var/success = advance_recipe(user, breakthrough)

	if(success)
		if(needed_item)
			to_chat(user, span_notice("\The [parent] needs a [needed_item_text] to continue."))

		// Check if recipe is complete
		if(progress >= current_recipe.max_progress && !needed_item)
			complete_forging(user, anvil)

/datum/component/forging/proc/on_item_added_to_forging(datum/source, obj/item/added_item, mob/user)
	SIGNAL_HANDLER
	if(!needed_item || !istype(added_item, needed_item))
		return FALSE

	needed_item = null
	needed_item_text = null
	progress = 0 // Reset progress for next stage

	to_chat(user, span_notice("You add \the [added_item] to \the [parent]."))
	qdel(added_item) // Consume the added item

	return TRUE

/datum/component/forging/proc/advance_recipe(mob/living/user, breakthrough = FALSE)
	var/moveup = 1
	var/proab = 0 // Probability to not spoil the bar
	var/skill_level = user.get_skill_level(current_recipe.appro_skill)

	if(progress >= current_recipe.max_progress && !needed_item)
		to_chat(user, span_info("It's ready."))
		user.visible_message(span_warning("[user] strikes the bar!"))
		return TRUE
	if(needed_item)
		to_chat(user, span_info("Now it's time to add a [needed_item_text]."))
		user.visible_message(span_warning("[user] strikes the bar!"))
		return FALSE
	if(current_recipe.using_blade)
		// Blades are partially pre-formed, so easier to work with
		proab += 10 // +10% success chance when using blades
		if(breakthrough)
			moveup *= 1.2 // Blades respond better to good strikes

	// Calculate probability of a successful strike, based on smith's skill level
	if(!skill_level && !current_recipe.craftdiff)
		proab = 35
	else if(skill_level < current_recipe.craftdiff) //Way out of your league, buddy.
		proab = 10
	else
		proab = min(45 * skill_level, 100)

	// Roll the dice to see if the hit actually causes to accumulate progress
	if(prob(proab))
		moveup += round((skill_level * 6 * user.STASTR/10) * (breakthrough ? 1.5 : 1))
		moveup -= current_recipe.craftdiff
		progress = min(progress + moveup, current_recipe.max_progress)
		numberofhits += 1
	else
		moveup = 0
		numberofhits += 1 // Increase regardless of success

	// This step is finished, check if more items are needed and restart the process
	if(progress >= current_recipe.max_progress && current_recipe.additional_items.len)
		needed_item = pick(current_recipe.additional_items)
		var/obj/item/I = needed_item
		needed_item_text = initial(I.name)
		current_recipe.additional_items -= needed_item
		progress = 0

	if(!moveup)
		user.mind?.add_sleep_experience(current_recipe.appro_skill, user.STAINT/(current_recipe.craftdiff+3), FALSE) //Pity XP
		if(!prob(proab)) // Roll again, this time negatively, for consequences.
			user.visible_message(span_warning("[user] ruins the bar!"))
			skill_quality -= 1 // The more you fuck up, the less quality the end result will be.
			bar_health -= current_recipe.craftdiff // Difficulty of the recipe adds to how critical the failure is

			switch(skill_level)
				if(0)
					bar_health -= 25 // 4 strikes and you're out, buddy.
				if(1 to 3)
					bar_health -= floor(20 / skill_level)
				if(4)
					bar_health -= 5
				if(5 to 6)
					if(user.badluck(4)) // Unlucky, not unskilled.
						bar_health -= current_recipe.craftdiff

			if(bar_health <= 0)
				user.visible_message(span_danger("[user] destroys the bar!"))
				qdel(parent)
			return FALSE
		else
			user.visible_message(span_warning("[user] fumbles the bar!"))
			return FALSE

	else
		if(user.mind)
			skill_quality += (rand(skill_level*12, skill_level*14) * moveup)
			user.mind.add_sleep_experience(current_recipe.appro_skill, user.STAINT/(current_recipe.craftdiff+1), FALSE)

		if(breakthrough)
			user.visible_message(span_deadsay("[user] deftly strikes the bar!"))
			if(bar_health < 100)
				bar_health += 20 // Correcting the mistakes, ironing the kinks. Low chance, so rewarding.
		else
			user.visible_message(span_info("[user] strikes the bar!"))

		if(progress >= current_recipe.max_progress && !current_recipe.additional_items.len)
			return TRUE
		return TRUE

/datum/component/forging/proc/complete_forging(mob/living/user, obj/machinery/anvil/anvil)
	forging_stage = FORGING_STAGE_COMPLETE
	var/if_created = FALSE

	if(current_recipe.using_blade)
		handle_creation(get_turf(parent), user)
		if_created = TRUE
	else
		// Make the item quenchable for final processing
		parent.AddComponent(/datum/component/anvil_quenchable, current_recipe, parent)
		to_chat(user, span_notice("[parent] is ready to be quenched in a water bin."))

	// Clean up anvil
	if(if_created)
		anvil.current_workpiece = null
	anvil.update_icon()

/datum/component/forging/proc/handle_creation(turf/create_turf, mob/living/user)
	// Calculate the quality once (copied from original anvil_recipe)
	numberofhits = ceil(numberofhits / current_recipe.num_of_materials)
	if(numberofbreakthroughs)
		numberofhits -= numberofbreakthroughs
	material_quality = floor(material_quality/current_recipe.num_of_materials)-4
	skill_quality = floor((skill_quality/current_recipe.num_of_materials)/1500)+material_quality
	skill_quality -= floor(numberofhits * 0.25)

	var/modifier
	switch(skill_quality)
		if(BLACKSMITH_LEVEL_MIN to BLACKSMITH_LEVEL_SPOIL)
			modifier = 0.3
		if(BLACKSMITH_LEVEL_AWFUL)
			modifier = 0.5
		if(BLACKSMITH_LEVEL_CRUDE)
			modifier = 0.8
		if(BLACKSMITH_LEVEL_ROUGH)
			modifier = 0.9
		if(BLACKSMITH_LEVEL_COMPETENT)
			modifier = 1
		if(BLACKSMITH_LEVEL_FINE)
			modifier = 1.1
		if(BLACKSMITH_LEVEL_FLAWLESS)
			modifier = 1.2
		if(BLACKSMITH_LEVEL_LEGENDARY to BLACKSMITH_LEVEL_MAX)
			modifier = 1.3
			record_round_statistic(STATS_MASTERWORKS_FORGED)

	if(!modifier)
		return

	// Create all the items
	for(var/i = 1 to current_recipe.createditem_num)
		var/obj/item/I = new current_recipe.created_item(create_turf)
		// Apply the quality to each item
		I.name = initial(I.name) // Reset the name first
		if(modifier != 1)
			switch(modifier)
				if(0.3)
					I.name = "ruined [I.name]"
				if(0.5)
					I.name = "awful [I.name]"
				if(0.8)
					I.name = "crude [I.name]"
				if(0.9)
					I.name = "rough [I.name]"
				if(1.1)
					I.name = "fine [I.name]"
				if(1.2)
					I.name = "flawless [I.name]"
				if(1.3)
					I.name = "masterwork [I.name]"
					I.polished = 4
					I.AddComponent(/datum/component/metal_glint)

		I.sellprice *= modifier
		if(istype(I, /obj/item/lockpick))
			var/obj/item/lockpick/L = I
			L.picklvl = modifier

	// Clean up the original workpiece
	qdel(parent)
