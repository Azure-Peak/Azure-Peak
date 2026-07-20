/datum/transmutation_recipe
	abstract_type = /datum/transmutation_recipe
	var/name = ""									// you know what this does
	var/category = "Basic Transmutation"			// one of these per catalyst, please!
	var/catalyst = /obj/item/alch/catalyst			// the actual catalyst item required
	var/skill_required = SKILL_LEVEL_JOURNEYMAN		// unlike normal crafting which does a weird %age thing this is just a hard req; also, usually making the catalyst will be the actual skill gate
	var/list/materia_aspects = list()				// aspects of materia required for the craft. _usually_ you should only have one of these but fancy hybrid alchemical-artifice infusions might break that rule later
	var/list/input_items = list()					// the actual recipe inputs, path = quantity
	var/list/output_items = list()					// you'll never guess

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

	if(input_items.len)
		html += "<div><strong>Consumes:</strong><br>"
		for(var/path as anything in input_items)
			var/count = input_items[path]
			if(ispath(path, /obj/item))
				var/obj/item/ingredient = path
				html += "[FLOOR(count, 1)] [UNIT_FORM_STRING(FLOOR(count, 1))] of [ingredient::name]<br>"
		html += "</div>"

	if(materia_aspects.len)
		html += "<div><strong>Requires any item(s) with the following aspect[(materia_aspects.len > 1) ? "s" : ""]:</strong><br>"
		for(var/path as anything in materia_aspects)
			if(ispath(path, /datum/materia_aspect))
				var/datum/materia_aspect/aspect = path
				html += "- [SPAN_TOOLTIP_DANGEROUS_HTML(aspect::name, aspect::desc)]<br>"
		html += "</div>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/transmutation_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=new_recipe;size=500x810")
