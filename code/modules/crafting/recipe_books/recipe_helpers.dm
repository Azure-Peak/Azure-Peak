/// Shared helper procs for the recipe book and OOC wiki systems.

/proc/get_recipe_category(path)
	if(!ispath(path))
		return null
	if(ispath(path, /datum/hag_boon))
		var/datum/hag_boon/B = path
		if(initial(B.hag_curse))
			return "Curses"
		var/pts = initial(B.points)
		if(pts >= 50) return "Greater Boons"
		return "Minor Boons"
	var/datum/temp_recipe
	var/category

	if(ispath(path, /datum/crafting_recipe))
		temp_recipe = new path()
		var/datum/crafting_recipe/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/anvil_recipe))
		temp_recipe = new path()
		var/datum/anvil_recipe/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/book_entry))
		temp_recipe = new path()
		var/datum/book_entry/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/alch_grind_recipe))
		temp_recipe = new path()
		var/datum/alch_grind_recipe/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/alch_cauldron_recipe))
		temp_recipe = new path()
		var/datum/alch_cauldron_recipe/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/brewing_recipe))
		temp_recipe = new path()
		var/datum/brewing_recipe/r = temp_recipe
		category = r.category
	else if(ispath(path, /datum/runeritual))
		temp_recipe = new path()
		var/datum/runeritual/r = temp_recipe
		category = r.category
	else if(ispath(path, /obj/effect/proc_holder/spell))
		var/tier = initial(path:spell_tier)
		category = "Tier [tier]"
		return category
	else if(ispath(path, /datum/action/cooldown/spell))
		var/datum/action/cooldown/spell/S = path
		category = "Tier [initial(S.spell_tier)]"
		return category

	if(temp_recipe)
		qdel(temp_recipe)
	return category

/proc/should_hide_recipe(path)
	if(ispath(path, /datum/hag_boon))
		return !initial(path:hag_is_valid)
	if(ispath(path, /datum/crafting_recipe))
		var/datum/crafting_recipe/recipe = path
		if(initial(recipe.hides_from_books))
			return TRUE
	if(ispath(path, /datum/anvil_recipe))
		var/datum/anvil_recipe/recipe = path
		if(initial(recipe.hides_from_books))
			return TRUE
	if(ispath(path, /datum/runeritual))
		var/datum/runeritual/ritual = path
		if(initial(ritual.blacklisted))
			return TRUE
	return FALSE

/proc/gather_recipe_categories(list/types)
	var/list/categories = list("All")
	for(var/atom/path as anything in types)
		if(is_abstract(path))
			for(var/atom/sub_path as anything in subtypesof(path))
				if(is_abstract(sub_path))
					continue
				var/category = get_recipe_category(sub_path)
				if(category && !(category in categories))
					categories += category
		else
			var/category = get_recipe_category(path)
			if(category && !(category in categories))
				categories += category
	categories = sortTim(categories, GLOBAL_PROC_REF(cmp_text_asc))
	if("All" in categories)
		categories -= "All"
		categories.Insert(1, "All")
	return categories

/proc/generate_recipe_detail_html(path, mob/user)
	if(!ispath(path))
		return "<div class='recipe-content'><p>Invalid recipe selected.</p></div>"

	var/html = "<div class='recipe-content'>"
	var/recipe_name = "Unknown Recipe"
	var/recipe_html = ""

	var/datum/temp_recipe
	if(ispath(path, /datum/hag_boon))
		var/datum/hag_boon/B = path
		html += "<h2>[initial(B.name)]</h2>"
		html += "<p class='description'>[initial(B.desc)]</p>"
		html += "<hr>"
		html += "<div class='boon-stats'>"
		html += "<b>Cost:</b> [initial(B.points)] Points<br>"
		html += "<b>Transmutable:</b> [initial(B.transmutable) ? "Yes" : "No"]<br>"
		if(initial(B.hag_curse))
			html += "<span class='boldwarning'>This is a Curse.</span>"
		html += "</div>"
		html += "</div>"
		return html
	if(ispath(path, /datum/crafting_recipe))
		temp_recipe = new path()
		var/datum/crafting_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/anvil_recipe))
		temp_recipe = new path()
		var/datum/anvil_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/book_entry))
		temp_recipe = new path()
		var/datum/book_entry/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/alch_grind_recipe))
		temp_recipe = new path()
		var/datum/alch_grind_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/alch_cauldron_recipe))
		temp_recipe = new path()
		var/datum/alch_cauldron_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/brewing_recipe))
		temp_recipe = new path()
		var/datum/brewing_recipe/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/runeritual))
		temp_recipe = new path()
		var/datum/runeritual/r = temp_recipe
		recipe_name = initial(r.name)
		recipe_html = r.generate_html(user)
	else if(ispath(path, /datum/action/cooldown/spell))
		recipe_name = initial(path:name)
		recipe_html = generate_cooldown_spell_wiki_html(path)
	else if(ispath(path, /obj/effect/proc_holder/spell))
		var/obj/effect/proc_holder/spell/temp_spell = new path()
		recipe_name = temp_spell.name
		recipe_html = temp_spell.generate_wiki_html(user)
		qdel(temp_spell)
		var/miracle_html = generate_miracle_granted_html(path)
		if(miracle_html)
			recipe_html += miracle_html

	if(temp_recipe)
		qdel(temp_recipe)

	if(recipe_html && recipe_html != "")
		html += recipe_html
	else
		html += "<h2 class='recipe-title'>[recipe_name]</h2>"
		html += "<p>No detailed information available.</p>"

	html += "</div>"
	return html

/// Generate wiki HTML for new cooldown spell types using initial() values only (no instantiation needed).
/proc/generate_cooldown_spell_wiki_html(spell_path)
	var/datum/action/cooldown/spell/S = spell_path
	var/s_name = initial(S.name)
	var/s_desc = initial(S.desc)
	var/s_tier = initial(S.spell_tier)
	var/s_cast_range = initial(S.cast_range)
	var/s_cooldown = initial(S.cooldown_time) / 10
	var/s_charge_time = initial(S.charge_time)
	var/s_charge_required = initial(S.charge_required)
	var/s_primary_cost = initial(S.primary_resource_cost)
	var/s_primary_type = initial(S.primary_resource_type)
	var/s_invocation_type = initial(S.invocation_type)
	var/s_self_cast = initial(S.self_cast_possible)
	var/s_click = initial(S.click_to_activate)

	var/s_range
	if(s_self_cast && !s_click)
		s_range = "Self"
	else
		s_range = "[s_cast_range] tiles"

	var/s_invoc_label = "None"
	switch(s_invocation_type)
		if(INVOCATION_SHOUT)
			s_invoc_label = "Shout"
		if(INVOCATION_WHISPER)
			s_invoc_label = "Whisper"
		if(INVOCATION_EMOTE)
			s_invoc_label = "Emote"

	var/s_cost = "[s_primary_cost] stamina"
	if(s_primary_type == SPELL_COST_DEVOTION)
		s_cost = "[s_primary_cost] devotion"
	else if(s_primary_type == SPELL_COST_NONE)
		s_cost = "None"

	var/s_charge = "None"
	if(s_charge_required && s_charge_time)
		s_charge = "[s_charge_time / 10]s"

	var/s_damage = ""
	var/displayed = initial(S.displayed_damage)
	if(!displayed && ispath(spell_path, /datum/action/cooldown/spell/projectile))
		var/datum/action/cooldown/spell/projectile/P = spell_path
		var/proj_type = initial(P.projectile_type)
		if(proj_type)
			displayed = initial(proj_type:damage)
	if(displayed)
		s_damage = "<tr><th>Damage</th><td>[displayed]</td></tr>"

	var/html = {"
		<h2>[s_name]</h2>
		[s_desc ? "<div class='recipe-desc'>[s_desc]</div>" : ""]
		<table>
			<tr><th>Tier</th><td>[s_tier]</td></tr>
			[s_damage]
			<tr><th>Cost</th><td>[s_cost]</td></tr>
			<tr><th>Range</th><td>[s_range]</td></tr>
			<tr><th>Charge Time</th><td>[s_charge]</td></tr>
			<tr><th>Cooldown</th><td>[s_cooldown]s</td></tr>
			<tr><th>Invocation Type</th><td>[s_invoc_label]</td></tr>
		</table>
	"}
	return html

