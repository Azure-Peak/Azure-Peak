/datum/food_recipe
	abstract_type = /datum/food_recipe
	var/name = "Generic Recipe"
	/// What item is used to start a recipe, e.g a piece of raw steak
	var/base_item = null
	/// Ingredients in order of completion
	var/list/ingredients = list()
	/// Resulting item
	var/result_type = null
	/// Legacy flag: Use cook_method for new recipes instead. If TRUE, it sets fried_type and cooked_type
	var/needs_cooking = FALSE
	/// One of COOK_BAKE, COOK_FRY, COOK_DEEPFRY, COOK_BOIL. Set what station is used to finish cooking the item
	var/cook_method = null
	/// How many copies of result_type to spawn
	var/result_amount = 1
	/// Where the recipe must be performed. Null for anywhere
	var/required_station = /obj/structure/table
	/// Excluded from the encyclopedia's top-level list (surfaced only inline under a parent dish).
	var/hidden = FALSE
	/// step_visuals[i] = list(icon_file, icon_state). Icon used after Step 1
	var/list/step_visuals = list()
	/// How long it takes to add items
	var/time_per_step = 2 SECONDS
	/// Experience per step per int
	var/experience_per_step = 0.5
	/// Economy bucket used by the pricing engine.
	var/display_category = ITEM_CAT_FOODSTUFF_FRESH
	/// Encyclopedia sidebar bucket. One of the FOOD_CAT_* defines.
	var/book_category = FOOD_CAT_COMBINATION

/datum/food_recipe/proc/step_accepts(entry, obj/item/I)
	if(!entry || !I)
		return FALSE
	if(ispath(entry, /datum/reagent))
		var/amt = ingredients[entry]
		return (I.reagents && I.reagents.has_reagent(entry, amt))
	if(islist(entry)) // any-of group: accept if I is any listed type
		for(var/p in entry)
			if(istype(I, p))
				return TRUE
		return FALSE
	return istype(I, entry)

/datum/food_recipe/proc/step_label(entry)
	if(ispath(entry, /datum/reagent))
		var/datum/reagent/R = entry
		return "[ingredients[entry]]dr of [initial(R.name)]"
	if(islist(entry))
		var/list/names = list()
		for(var/atom/p as anything in entry)
			names += initial(p.name)
		return "one of: [names.Join(", ")]"
	var/atom/A = entry
	if(ingredients[entry] == COOKSTEP_TOOL)
		return "[initial(A.name)] (tool)"
	return initial(A.name)

/datum/food_recipe/proc/render_step_li(entry, mob/user)
	if(ispath(entry, /datum/reagent))
		var/amt = ingredients[entry]
		var/datum/reagent/R = entry
		return "<li>Add [amt] [UNIT_FORM_STRING(amt)] of [initial(R.name)]</li>"
	if(islist(entry)) // any-of group
		var/list/options = list()
		for(var/atom/opt as anything in entry)
			options += "[icon2html(new opt, user)] [initial(opt.name)]"
		return "<li>Add one of: [options.Join(", ")]</li>"
	if(ingredients[entry] == COOKSTEP_TOOL) // non-consumed tool
		var/atom/A = entry
		return "<li>Use [icon2html(new A, user)] [initial(A.name)]</li>"
	var/atom/A = entry
	return "<li>Add [icon2html(new A, user)] [initial(A.name)]</li>"

/datum/food_recipe/proc/cook_step_li()
	switch(cook_method)
		if(COOK_BAKE)
			return "<li><b>Bake</b> it in an oven</li>"
		if(COOK_FRY)
			return "<li><b>Fry</b> it in a pan over a hearth</li>"
		if(COOK_DEEPFRY)
			return "<li><b>Deep-fry</b> it in a pot of hot oil</li>"
		if(COOK_BOIL)
			return "<li><b>Boil</b> it in a pot of water</li>"
	if(needs_cooking)
		return "<li><b>Cook</b> it over a hearth, or in an oven</li>"
	return ""

/datum/food_recipe/proc/build_journey(mob/user, depth = 0)
	var/list/steps = list()
	var/atom/base = base_item
	if(depth < 10)
		var/datum/food_recipe/pre = SScooking?.get_producing_recipe(base_item)
		if(pre && pre.hidden && pre != src)
			var/list/pre_data = pre.build_journey(user, depth + 1)
			base = pre_data["base"]
			steps += pre_data["steps"]
	for(var/i in 1 to length(ingredients))
		steps += render_step_li(ingredients[i], user)
	return list("base" = base, "steps" = steps)

/datum/food_recipe/proc/generate_html(mob/user)
	var/html = "<h2>[name]</h2>"

	var/list/journey = build_journey(user)
	var/atom/base = journey["base"]
	if(base)
		html += "<p><b>Start with:</b> [icon2html(new base, user)] [initial(base.name)]</p>"

	var/list/steps = journey["steps"]
	var/cook_li = cook_step_li()
	if(cook_li)
		steps += cook_li
	if(length(steps))
		html += "<h3>Then, in order:</h3><ul>[steps.Join()]</ul>"

	var/atom/result = result_type
	if(result)
		html += "<p><b>Produces:</b> [icon2html(new result, user)] [initial(result.name)]</p>"
		var/result_details = describe_food_result(result)
		if(result_details)
			html += result_details

	html += "<p>Each step takes about [time_per_step / 10] seconds before cooking skill modifiers.</p>"

	if(SScooking?.recipe_index && result_type)
		var/list/follow_ups = SScooking.recipe_index[result_type]
		if(length(follow_ups))
			var/list/names = list()
			for(var/datum/food_recipe/F in follow_ups)
				if(!F.hidden)
					names += F.name
			if(length(names))
				html += "<h3>Can be further prepared into:</h3><ul>"
				for(var/n in names)
					html += "<li>[n]</li>"
				html += "</ul>"

	return html

/proc/food_nutrition_units(atom/food_path)
	if(!ispath(food_path, /obj/item/reagent_containers/food/snacks))
		return 0
	var/obj/item/reagent_containers/food/snacks/proto = food_path
	var/total = 0
	var/list/declared = initial(proto.list_reagents)
	if(islist(declared))
		total += declared[/datum/reagent/consumable/nutriment] || 0
	var/list/bonus = initial(proto.bonus_reagents)
	if(islist(bonus))
		total += bonus[/datum/reagent/consumable/nutriment] || 0
	return total

/proc/describe_food_result(atom/result_path)
	if(!ispath(result_path, /obj/item/reagent_containers/food/snacks))
		return ""
	var/obj/item/reagent_containers/food/snacks/proto = new result_path()
	var/list/lines = list()

	switch(proto.faretype)
		if(FARE_IMPOVERISHED)
			lines += "Quality: Impoverished (fit for the desperate)."
		if(FARE_POOR)
			lines += "Quality: Poor (fit for the poor)."
		if(FARE_NEUTRAL)
			lines += "Quality: Neutral (decent food)."
		if(FARE_FINE)
			lines += "Quality: Fine."
		if(FARE_LAVISH)
			lines += "Quality: Lavish."

	var/nutriment_total = 0
	var/list/declared_reagents = proto.list_reagents
	if(islist(declared_reagents))
		nutriment_total += declared_reagents[/datum/reagent/consumable/nutriment] || 0
	var/list/declared_bonus = proto.bonus_reagents
	if(islist(declared_bonus))
		nutriment_total += declared_bonus[/datum/reagent/consumable/nutriment] || 0
	if(nutriment_total > 0)
		lines += "Nutrition: [nutrition_unit_label(nutriment_total)] ([nutriment_total] units)."

	var/list/other_reagents = list()
	if(islist(declared_reagents))
		for(var/r_path in declared_reagents)
			if(r_path == /datum/reagent/consumable/nutriment)
				continue
			var/datum/reagent/R = r_path
			other_reagents += "[initial(R.name)] ([declared_reagents[r_path]]u)"
	if(length(other_reagents))
		lines += "Also contains: [other_reagents.Join(", ")]."

	var/buff_desc = describe_food_effect(proto.eat_effect)
	if(buff_desc)
		lines += "Effect on eating: [buff_desc]."
	var/extra_desc = describe_food_effect(proto.extra_eat_effect)
	if(extra_desc)
		lines += "Bonus effect: [extra_desc]."

	var/atom/slice_target = proto.slice_path
	if(slice_target)
		var/count = proto.slices_num || 1
		var/slice_nutri = food_nutrition_units(slice_target)
		var/slice_extra = slice_nutri > 0 ? " ([nutrition_unit_label(slice_nutri)] each)" : ""
		lines += "Can be cut into [count] x [initial(slice_target.name)][slice_extra]."

	qdel(proto)

	if(!length(lines))
		return ""
	return "<p>[lines.Join("<br>")]</p>"

/proc/describe_food_effect(effect_path)
	if(!ispath(effect_path, /datum/status_effect))
		return null
	var/datum/status_effect/S = effect_path
	var/label
	var/alert_path = initial(S.alert_type)
	if(ispath(alert_path, /atom))
		var/atom/A = alert_path
		label = initial(A.name)
	if(!label)
		label = initial(S.id) || "[effect_path]"

	var/list/parts = list("<b>[label]</b>")
	var/duration = initial(S.duration)
	if(duration && duration > 0)
		parts += "for [duration_label(duration)]"
	return parts.Join(" ")

/proc/duration_label(deciseconds)
	var/seconds = deciseconds / 10
	if(seconds >= 60)
		var/minutes = round(seconds / 60)
		return "[minutes] minute[minutes == 1 ? "" : "s"]"
	return "[seconds] seconds"

/proc/nutrition_unit_label(amount)
	if(amount >= NUTRITION_FIVE_MEALS)
		return "five meals or more"
	if(amount >= NUTRITION_THREE_AND_HALF_MEALS)
		return "three-and-a-half meals"
	if(amount >= NUTRITION_TWO_AND_HALF_MEALS)
		return "two-and-a-half meals"
	if(amount >= NUTRITION_TWO_MEALS)
		return "two meals"
	if(amount >= NUTRITION_MEAL_AND_HALF)
		return "a meal and a half"
	if(amount >= NUTRITION_MEAL_AND_QUARTER)
		return "a meal and a quarter"
	if(amount >= NUTRITION_FULL_MEAL)
		return "a full meal"
	if(amount >= NUTRITION_THREE_QUARTER_MEAL)
		return "three-quarters of a meal"
	if(amount >= NUTRITION_HALF_MEAL)
		return "half a meal"
	if(amount >= NUTRITION_QUARTER_MEAL)
		return "a quarter of a meal"
	return "a small bite"

