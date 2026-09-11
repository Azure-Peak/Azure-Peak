/datum/book_entry/cooking_deepfry
	name = "Deep Frying"
	category = FOOD_CAT_DEEPFRIED
	book_priority = 1

/datum/book_entry/cooking_deepfry/inner_book_html(mob/user)
	var/html = "<div>"
	html += "<p>Melt tallow or fat in a pot - 5dr per piece, 20dr from fat. The pot must contain <b>no water</b>, only tallow / fat.</p>"
	html += "<p>Once melted, drop the food into the pot and it will start frying. Each fry consumes 5dr of tallow.</p>"
	html += "</div>"
	return html
