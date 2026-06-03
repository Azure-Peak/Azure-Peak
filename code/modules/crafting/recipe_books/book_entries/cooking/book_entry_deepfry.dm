/datum/book_entry/cooking_deepfry
	name = "Deep Frying"
	category = "Instructions"

/datum/book_entry/cooking_deepfry/inner_book_html(mob/user)
	var/html = "<div>"
	html += "<p>Melt tallow or fat in a pot - 5dr per piece, 20dr from fat. The pot must contain <b>no water</b>, only tallow / fat.</p>"
	html += "<p>Once melted, click the pot with the food you want to deep fry. Each fry consumes 5dr of tallow.</p>"
	html += "<p>This is distinct SS13 deep frying. Only the items listed below can be deep fried.</p>"

	html += "<h3>Prepared Deep Fries</h3>"
	html += "<p>The breaded recipes below require a tenderized base, an egg, and a coating of toastcrumbs before they hit the oil. Tenderize raw meat or a raw sausage on a table with a rolling pin; crack the egg over the result; coat with toastcrumbs; then deep fry.</p>"
	html += "<ul>"
	html += "<li><b>Nitzel</b> - Tenderize any non-spider raw meat, then bread and deep fry. Grants +1 willpower and +1 constitution for ten minutes.</li>"
	html += "<li><b>Schnitzel</b> - Tenderize spider meat, then bread and deep fry. Grants +1 willpower and +1 constitution for ten minutes.</li>"
	html += "<li><b>Tender Frybird</b> - Tenderize raw poultry, then bread and deep fry.</li>"
	html += "<li><b>Wiener Nitzel</b> - Tenderize a raw sausage with a rolling pin, then bread and deep fry.</li>"
	html += "<li><b>Squire's Delight</b> - Crack an egg over a full block of butter, coat with toastcrumbs, then deep fry. Grants +1 willpower and +1 constitution for ten minutes.</li>"
	html += "</ul>"

	html += "<h3>Direct Deep Fries</h3>"
	html += "<p>The following are deep fried directly from a single prepared ingredient:</p>"
	html += deep_fry_simple_table()

	html += "</div>"
	return html

/proc/deep_fry_simple_table()
	var/list/seen = list()
	var/list/rows = list()
	for(var/snack_path in typesof(/obj/item/reagent_containers/food/snacks) - /obj/item/reagent_containers/food/snacks)
		var/obj/item/reagent_containers/food/snacks/source = snack_path
		var/source_name = initial(source.name)
		if(!source_name)
			continue
		var/result_path = initial(source.deep_fried_type)
		if(!result_path || result_path == snack_path)
			continue
		var/atom/result = result_path
		var/result_name = initial(result.name)
		var/key = "[source_name]||[result_name]"
		if(seen[key])
			continue
		seen[key] = TRUE
		rows += "<tr><td>[source_name]</td><td>&rarr; [result_name]</td></tr>"
	if(!length(rows))
		return "<p>Nothing applicable found.</p>"
	return "<table border='1' cellpadding='3'>[rows.Join("")]</table>"
