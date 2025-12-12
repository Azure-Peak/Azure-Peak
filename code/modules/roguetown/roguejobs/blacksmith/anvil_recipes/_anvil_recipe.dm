/datum/anvil_recipe
	abstract_type = /datum/anvil_recipe
	var/name
	var/category = "Misc"
	var/list/additional_items = list()
	var/material_quality = 0 // Quality of the bar(s) used. Accumulated per added ingot.
	var/num_of_materials = 1 // Total number of materials used. Quality divided among them.
	var/skill_quality = 0 // Accumulated per hit based on calculations, will decide final result.
	var/appro_skill = /datum/skill/craft/blacksmithing
	var/atom/req_bar
	var/atom/req_blade
	var/using_blade = FALSE
	var/atom/movable/created_item
	var/createditem_num = 1 // How many units to make.
	var/craftdiff = 0
	var/needed_item
	var/needed_item_text
	var/quality_mod = 0
	var/progress
	var/max_progress = 100
	var/i_type
	var/bar_health = 100 // Current material bar health, reduced by failures. At 0 HP it is deleted.
	var/numberofhits = 0 // Increased every time you hit the bar, the more you have to hit the bar the less quality of the product.
	var/numberofbreakthroughs = 0 // How many good hits we got on the metal, advances recipes 50% faster, reduces number of hits total, and restores bar_health
	var/datum/parent
	// Whether this recipe will be hidden from recipe books
	var/hides_from_books = FALSE
	// Whether this recipe bypasses the no-dupe-smeltresult test
	var/bypass_dupe_test = FALSE

/datum/anvil_recipe/New(datum/P, using_blade = FALSE, ...)
	. = ..()

/datum/anvil_recipe/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=new_recipe;size=500x810")

/datum/anvil_recipe/proc/generate_html(mob/user)
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
		    <h1>[icon2html(new created_item, user)][name]</h1>
			<h4>DESCRIPTION: [initial(created_item.desc)]</h4>
			<div>
		"}
	var/obj/item/clothing/suit/roguetown/armor/bookarmor = initial(new created_item)
	var/obj/item/rogueweapon/bookweapon = initial(created_item)

	if(!(bookarmor.armor == "")&&!isnull(bookarmor.armor) )
		var/obj/item/clothing/C = initial(new created_item)
		if(C.body_parts_covered)
			html += "\n<b>COVERAGE: </b>"
			html += " | "
			if(C.body_parts_covered == C.body_parts_covered_dynamic)
				for(var/zone in body_parts_covered2organ_names(C.body_parts_covered))
					html += "<b>[capitalize(zone)]</b> | "
			else
				var/list/zones = list()
				//We have some part peeled, so we turn the printout into precise mode and highlight the missing coverage.
				for(var/zoneorg in body_parts_covered2organ_names(C.body_parts_covered, precise = TRUE))
					zones += zoneorg
				for(var/zonedyn in body_parts_covered2organ_names(C.body_parts_covered_dynamic, precise = TRUE))
					html += "<b>[capitalize(zonedyn)]</b> | "
					if(zonedyn in zones)
						zones.Remove(zonedyn)
				for(var/zone in zones)			
					html += "<b><font color = '#470000'>[capitalize(zone)]</font></b> | "
			html += "<br>"
		if(C.body_parts_inherent)
			html += "<b>CANNOT BE PEELED: </b>"
			var/list/inherentList = body_parts_covered2organ_names(C.body_parts_inherent)
			if(length(inherentList) == 1)
				html += "<b><font color = '#000833'>[capitalize(inherentList[1])]</font></b><br>"
			else
				html += "| "
				for(var/zone in inherentList)
					html += "<b><font color = '#000833'>[capitalize(zone)]</b></font> | "
			html += "<br>"
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

	if(appro_skill == /datum/skill/craft/engineering) // SNOWFLAKE!!!
		html += "in Engineering<br>"

	html += {"<div>
		      <strong>Requirements</strong>
			  <br>"}

	html += "[icon2html(new req_bar, user)] Start with [initial(req_bar.name)] on an anvil.<br>"
	html += "Hammer the material.<br>"
	for(var/atom/path as anything in additional_items)
		html += "[icon2html(new path, user)] then add [initial(path.name)]<br>"
		html += "Hammer the material.<br>"

	html += {"
		</div>
		<div>
		"}

	if(createditem_num > 1)
		html += "<strong class=class='scroll'>and then you get</strong> <br> [createditem_num] [icon2html(new created_item, user)]  [initial(created_item.name)]<br>"
	else
		html += "<strong class=class='scroll'>and then you get</strong> <br> [icon2html(new created_item, user)]   [initial(created_item.name)]<br>"

	if(created_item.sellprice)
		html += "<strong class=class='scroll'>You can sell this for [created_item.sellprice] mammons at a normal quality</strong> <br>"
	else
		html += "<strong class=class='scroll'>This is worthless for export</strong> <br>"

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html
