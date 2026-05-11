/datum/alch_cauldron_recipe
	abstract_type = /datum/alch_cauldron_recipe // This is an abstract type, it should not be instantiated directly.
	var/name = "" //The name of the recipe, kinda there just in case.
	var/category = "Potions"
	var/smells_like = "nothing" //cauldron emits this smell when done, and alchemists can sniff ingredients to find what they do
	var/skill_required = SKILL_LEVEL_APPRENTICE // Minimum skill to create this recipe successfully (It just won't mix otherwise) - Minimum Apprentice 
	var/list/output_reagents = list() //list of paths of new reagents to create in the cauldron. Remember, 1 oz is 3 units! [reagent = amnt]
	var/list/output_items = list() //List of paths for new items that should be created, [path = chance to be created]

/datum/alch_cauldron_recipe/proc/generate_html(mob/user)
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
	
	html += "Boil 90+ drams of water in a Cauldron.<br>"

	html += "Add at least two ingredients with the smell of [smells_like]<br>"

	if(output_reagents.len)
		html += "<div><strong>Creates:</strong><br>"
		for(var/path as anything in output_reagents)
			var/count = output_reagents[path]
			if(ispath(path, /datum/reagent))
				var/datum/reagent/R = path
				html += "[FLOOR(count, 1)] [UNIT_FORM_STRING(FLOOR(count, 1))] of [initial(R.name)]<br>"
		html += "</div>"

	if(output_items.len)
		html += "<div><strong>Guaranteed Outputs</strong><br>"
		for(var/path as anything in output_items)
			var/count = output_items[path]
			if(ispath(path, /obj))
				var/atom/atom = path
				html += "- [count] [initial(atom.name)]<br>"
		html += "</div>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/alch_cauldron_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=new_recipe;size=500x810")
