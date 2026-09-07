/datum/alch_grind_recipe
	var/name = "generic grind recipe"
	var/category = "Grinding"
	var/picky = TRUE // if TRUE: the item path MUST MATCH, and cannot be a subtype.
	var/obj/item/valid_input = null //the typepath that, when ground, makes an output
	var/list/valid_outputs = list() //List of [Itempath = amnt?1] to be created always
	var/list/bonus_chance_outputs = list() //List of [Itempath = chance/100] to create sometimes.
	abstract_type = /datum/alch_grind_recipe

/datum/alch_grind_recipe/proc/generate_html(mob/user)
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

	html += "Put [initial(valid_input.name)] in an Alchemical Mortar.<br>"
	html += "Grind with a pestle to create:<br>"

	if(valid_outputs.len)
		html += "<div><strong>Guaranteed Outputs</strong><br>"
		for(var/path as anything in valid_outputs)
			var/count = valid_outputs[path]
			if(ispath(path, /obj))
				var/atom/atom = path
				html += "- [count] [initial(atom.name)]<br>"
		html += "</div>"

	if(bonus_chance_outputs.len)
		html += "<div><strong>Bonus Outputs</strong><br>"
		for(var/path as anything in bonus_chance_outputs)
			var/chance = bonus_chance_outputs[path]
			if(ispath(path, /obj))
				var/atom/atom = path
				html += "- [initial(atom.name)] (Chance: [chance]%)<br>"
		html += "</div>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/alch_grind_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=new_recipe;size=500x810")
