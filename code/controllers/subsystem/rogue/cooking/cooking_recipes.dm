/datum/food_recipe
	var/name = "Generic Recipe"
	/// What item is used to start a recipe, e.g a piece of raw steak
	var/base_item = null
	/// Ingredients in order of completion
	var/list/ingredients = list()
	/// Resulting item
	var/result_type = null
	/// Whether or not this needs to be cooked
	var/needs_cooking = FALSE
	/// How long it takes to add items
	var/time_per_step = 2 SECONDS
	/// Experience per step per int
	var/experience_per_step = 0.5
