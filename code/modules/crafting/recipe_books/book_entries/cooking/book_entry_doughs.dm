/datum/book_entry/cooking_flour
	name = "Flour"
	category = FOOD_CAT_DOUGHS
	book_priority = 1

/datum/book_entry/cooking_flour/inner_book_html(mob/user)
	var/html = "<div>"
	html += "<p>Flour is the root of every dough. Grind wheat or oat grains in a millstone to produce it.</p>"
	html += "<p>Then, add water to flour with any container, knead the unfinished dough by hand by left clicking with an empty hand, then add one more flour to the dough.</p>"
	html += "</div>"
	return html
