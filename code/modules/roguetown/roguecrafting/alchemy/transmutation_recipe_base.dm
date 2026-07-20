/datum/transmutation_recipe
	abstract_type = /datum/transmutation_recipe
	var/name = ""									// you know what this does
	var/snowflake_desc								// if set, adds a line to the guidebook entry - for if the recipe has special conditions like argyropoeia needing nite-time
	var/category = "Basic Transmutation"			// one of these per catalyst, please!
	var/obj/item/catalyst = /obj/item/alch/catalyst	// the actual catalyst item required
	var/skill_required = SKILL_LEVEL_JOURNEYMAN		// unlike normal crafting which does a weird %age thing this is just a hard req; also, usually making the catalyst will be the actual skill gate
	var/list/materia_aspects = list()				// aspects of materia required for the craft. _usually_ you should only have one of these but fancy hybrid alchemical-artifice infusions might break that rule later
	var/list/input_items = list()					// the actual recipe inputs, path = quantity
	var/list/output_items = list()					// you'll never guess
	var/list/cached_display_data					// tgui stuff
	var/subtype_reqs = TRUE							// whether or not the recipe accepts subtypes. set to false if you run into inheritance issues

/// returning FALSE here allows the recipe to proceed; returning a message will instead fail with that message
/datum/transmutation_recipe/proc/execution_blocked(mob/user)
	return FALSE

/proc/can_transmute(mob/user) // exact condition may be changed later
	return HAS_TRAIT(user, TRAIT_ALCHEMY_EXPERT)

/datum/transmutation_recipe/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	user << browse_rsc('html/book.png')
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
		<body>
		  <div>
		    <h1>[name]</h1>
		"}

	html += "Requires [SSskills.level_names_plain[skill_required]] level of skills<br>"

	html += "Requires \a [catalyst::name], which is not consumed.<br>"

	if(snowflake_desc)
		html += "[snowflake_desc]<br>"

	if(input_items.len)
		html += "<div><strong>Consumes:</strong><br>"
		for(var/path as anything in input_items)
			var/count = input_items[path]
			if(ispath(path, /obj/item))
				var/obj/item/ingredient = path
				html += "[FLOOR(count, 1)]x [ingredient::name]<br>"
		html += "</div>"

	if(materia_aspects.len)
		html += "<div><strong>Requires any item(s) with the following aspect[(materia_aspects.len > 1) ? "s" : ""]:</strong><br>"
		for(var/path as anything in materia_aspects)
			if(ispath(path, /datum/materia_aspect))
				var/datum/materia_aspect/aspect = path
				html += "[SPAN_TOOLTIP(aspect::desc, aspect::name)]<br>" // note: this tooltip does not fucking work and i have no idea why
		html += "</div>"

	if(output_items.len)
		html += "<div><strong>Produces:</strong><br>"
		for(var/path as anything in output_items)
			var/count = output_items[path]
			if(ispath(path, /obj/item))
				var/obj/item/result = path
				html += "[FLOOR(count, 1)]x [result::name]<br>"
		html += "</div>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/transmutation_recipe/proc/build_display_cache()
	var/list/data = list()
	data["name"] = name
	data["ref"] = "[REF(src)]"
	data["path"] = type
	data["catalyst"] = catalyst::name

	var/input_text = ""
	for(var/a in input_items)
		var/atom/A = a
		input_text += " [input_items[A]] [initial(A.name)],"
	if(input_text)
		input_text = copytext(input_text, 1, length(input_text))
	data["input_text"] = input_text

	var/output_text = ""
	for(var/a in output_items)
		var/atom/A = a
		output_text += " [output_items[A]] [A::name],"
	if(output_text)
		output_text = copytext(output_text, 1, length(output_text))
	data["output_text"] = output_text

	var/list/materia_display = list()
	for(var/a in materia_aspects)
		var/datum/materia_aspect/aspect = a
		materia_display[aspect::name] = aspect::desc
	data["materia_reqs"] = materia_display

	if(skill_required)
		data["craftingdifficulty"] = "[SSskills.level_names_plain[skill_required]]."

	cached_display_data = data
