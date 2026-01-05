
/datum/crafting_recipe
	abstract_type = /datum/crafting_recipe
	var/name = "" //in-game display name
	var/reqs[] = list() //type paths of items consumed associated with how many are needed
	var/blacklist[] = list() //type paths of items explicitly not allowed as an ingredient
	var/result[] = list() //type path of item resulting from this craft
	/// String defines of items needed but not consumed. Lazy list.
	var/list/tool_behaviors
	var/tools[] = list() //type paths of items needed but not consumed
	var/time = 0 //time in deciseconds
	var/parts[] = list() //type paths of items that will be placed in the result
	var/chem_catalysts[] = list() //like tools but for reagents
	var/category = "Misc" // Where it shows in the recipe books
	var/subcategory = CAT_NONE
	var/always_availible = FALSE //Set to FALSE if it needs to be learned first.
	var/ontile = FALSE		//crafted on our tile instead of in front of us
	var/req_table = FALSE
	var/skillcraft = /datum/skill/craft/crafting
	var/verbage_simple = "craft"
	var/verbage = "crafts"
	var/craftsound = 'sound/foley/bandage.ogg'
	var/subtype_reqs = FALSE
	var/structurecraft = null
	var/buildsame = FALSE //allows palisades to be built on top of each other just not the same dir
	var/wallcraft = FALSE
	var/diagonal = FALSE //allows diagonal structures to have their direction chosen.
	var/craftdiff = 1
	var/sellprice = 0
	/// Whether this recipe will be hidden from recipe books
	var/hides_from_books = FALSE 
	/// Whether this recipe will transmit a message in a 7x7 column around the source.
	var/loud = FALSE
	//crafting diff, every diff removes 25% chance to craft
	var/required_tech_node = null // String ID of required tech node, or null if no tech required
	var/tech_unlocked = TRUE // Set to TRUE when the required tech is unlocked
	var/ignoredensity = FALSE //used on objects that we want to build into walls or atop other structures
 	// If TRUE, this recipe will be skipped by the nodupe tests
	var/bypass_dupe_test = FALSE
/*
/datum/crafting_recipe/example
	name = ""
	result = /obj/item/stuff
	reqs = list(/obj/item/gun = 1)
	parts = list(/obj/item/gun = 1)
	tools = list(TOOL_WELDER, TOOL_SCREWDRIVER, TOOL_WIRECUTTER)
	time = 5 SECONDS
	category = CAT_NONE
	subcategory = CAT_NONE
*/

/datum/crafting_recipe/proc/generate_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client
	user << browse_rsc('html/book.png')
	var/uncrafted_sellprice = 0
	//var/atom/movable/created_item
	//var/obj/structure/created_structure
	//var/obj/machinery/created_machinery
	var/obj/created_stuff
	var/turf/created_stationary
	if(islist(result))
		var/list/result_list = result
		if(result_list.len)
			//created_item = result[1]
			//created_machinery = result[1]
			created_stuff = result[1]
			if(istype(/atom/movable, result[1]))
				var/atom/movable/AM = result[1]
				if(AM.sellprice)
					uncrafted_sellprice = AM.sellprice
	if(ispath(result, /obj))
		var/atom/movable/AM = result
		created_stuff = result
		created_stationary = result
		if(AM.sellprice)
			uncrafted_sellprice = AM.sellprice
	if(ispath(result, /turf))
		var/atom/movable/AM = result
		created_stationary = result
		if(AM.sellprice)
			uncrafted_sellprice = AM.sellprice
	var/final_sellprice = sellprice || uncrafted_sellprice
	var/html 
	if (!isnull(created_stuff))
		html = {"
			<!DOCTYPE html>
			<html lang="en">
			<meta charset='UTF-8'>
			<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
			<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
			<body>
			<div>
				<h1>[icon2html(created_stuff, user)][name]</h1>
				<h4>DESCRIPTION: [initial(created_stuff.desc)]</h4>
				<div>
			"}
	if (!isnull(created_stationary))
		html = {"
			<!DOCTYPE html>
			<html lang="en">
			<meta charset='UTF-8'>
			<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
			<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>
			<body>
			<div>
				<h1>[icon2html(created_stationary, user)][name]</h1>
				<h4>DESCRIPTION: [initial(created_stationary.desc)]</h4>
				<div>
			"}
	var/obj/item/clothing/suit/roguetown/armor/bookarmor = initial(created_stuff)
	var/obj/item/rogueweapon/bookweapon = initial(created_stuff)

	if(!(bookarmor?.armor == "")&&!isnull(bookarmor?.armor) )
		var/obj/item/clothing/C = initial(created_stuff)
		if(C.body_parts_covered)
			html += "\n<b>COVERAGE: </b>"
			html += " | "
			for(var/zone in body_parts_covered2organ_names(body_parts_covered2organ_names(C.body_parts_covered)))
				html += "<b>[capitalize(zone)]</b> | "
			html += "<br>"
		if(!C.prevent_crits)
			html += "\n<b>CRIT SUSCEPTIBLE!</b>"
		html += "INTEGRITY: [bookarmor.max_integrity]<br>"
		if(bookarmor.armor_class == ARMOR_CLASS_HEAVY)
			html += "<b>AC: </b>HEAVY<br>"
		if(bookarmor.armor_class == ARMOR_CLASS_MEDIUM)
			html += "<b>AC: </b>MEDIUM<br>"
		if(bookarmor.armor_class == ARMOR_CLASS_LIGHT)
			html += "<b>AC: </b> LIGHT<br>"
	else if (!isnull(bookweapon) && bookweapon.force>1)
		html += "Combat Properties<br>"
		if(bookweapon.minstr)
			html += "\n<b>MIN.STR:</b> [bookweapon.minstr]<br>"
		
		if(bookweapon.force)
			html += "\n<b>FORCE:</b> [bookweapon.force]<br>"
		if(bookweapon.gripped_intents && !bookweapon.wielded)
			if(bookweapon.force_wielded)
				html += "\n<b>WIELDED FORCE:</b> [bookweapon.force_wielded]<br>"

		if(bookweapon.wbalance)
			html += "\n<b>BALANCE: </b>"
			if(bookweapon.wbalance == WBALANCE_HEAVY)
				html += "Heavy<br>"
			if(bookweapon.wbalance == WBALANCE_SWIFT)
				html += "Swift<br>"
			

		if(bookweapon.wlength != WLENGTH_NORMAL)
			html += "\n<b>LENGTH:</b> "
			switch(bookweapon.wlength)
				if(WLENGTH_SHORT)
					html += "Short<br>"
				if(WLENGTH_LONG)
					html += "Long<br>"
				if(WLENGTH_GREAT)
					html += "Great<br>"

		if(bookweapon.alt_intents)
			html += "\n<b>GRIP: ALT-GRIP (right click while in hand)</b><br>"
		if(bookweapon.gripped_intents)
			html += "\n<b>TWO-HANDED: Yes</b><br>"

		var/shafttext = get_blade_dulling_text(bookweapon, verbose = TRUE)
		if(shafttext)
			html += "\n<b>SHAFT:</b> [shafttext] <br>"

		if(bookweapon.twohands_required)
			html += "\n<b>BULKY</b><br>"
		if(bookweapon.can_parry)
			html += "\n<b>DEFENSE:</b> [bookweapon.wdefense]<br>"
		if(bookweapon.associated_skill && bookweapon.associated_skill.name)
			html += "\n<b>SKILL:</b> [bookweapon.associated_skill.name]<br>"
		
		if(bookweapon.intdamage_factor != 1 && bookweapon.force >= 5)
			html += "\n<b>INTEGRITY DAMAGE:</b> [bookweapon.intdamage_factor * 100]%<br>"

	if(craftdiff > 0)
		html += "<h1></h1>For those of [SSskills.level_names_plain[craftdiff]] skills<br>"
	else
		html += "<h1></h1>Suitable for all skills<br>"	

	html += {"<div>
		      <strong>Requirements</strong>
			  <br>"}

	for(var/path as anything in reqs)
		var/count = reqs[path]
		if(ispath(path, /datum/reagent))
			var/datum/reagent/R = path
			html += "- [FLOOR(count, 1)] [UNIT_FORM_STRING(FLOOR(count, 1))] of [initial(R.name)]<br>"
		else if(ispath(path, /obj)) // Prevent a runtime from happening w/ datum atm until it is
			var/atom/atom = path
			if(subtype_reqs)
				html += "- [count] of any [initial(atom.name)]<br>"
			else
				html += "- [count] [initial(atom.name)]<br>"

	html += {"
		</div>
		<div>
		"}

	if(length(tools))
		html += {"
		<br>
		<div>
		    <strong>Required Tools</strong>
			<br>
			  "}
		for(var/atom/path as anything in tools)
			if(subtype_reqs)
				html += "[icon2html(new path, user)] any [initial(path.name)]<br>"
			else
				html += "[icon2html(new path, user)] [initial(path.name)]<br>"
		html += {"
			</div>
		<div>
		"}

	if(length(chem_catalysts))
		html += {"
		<br>
		<div>
		    <strong>Required Liquids</strong>
			<br>
			  "}
		for(var/atom/path as anything in chem_catalysts)
			var/count = chem_catalysts[path]
			html += "[FLOOR(count, 1)] [UNIT_FORM_STRING(FLOOR(count, 1))] of [initial(path.name)]<br>"
		html += {"
			</div>
		<div>
		"}

	if(structurecraft)
		var/obj/structure = structurecraft
		html += "<strong class=class='scroll'>start the process next to a</strong> <br>[icon2html(new structurecraft, user)] <br> [initial(structure.name)]<br>"
	if(req_table)
		html += "<strong class=class='scroll'>start the process next to a table</strong> <br>"
	if(wallcraft)
		html += "<strong class=class='scroll'>start the process next to a wall</strong> <br>"

	if(final_sellprice)
		html += "<strong class=class='scroll'>You can sell this for [final_sellprice] mammons at a normal quality</strong> <br>"
	else(
		html += "<strong class=class='scroll'>This is worthless for export</strong> <br>"
	)

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/crafting_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=new_recipe;size=500x810")
