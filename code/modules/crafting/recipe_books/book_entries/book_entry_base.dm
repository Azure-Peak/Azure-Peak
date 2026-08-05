/datum/book_entry
	abstract_type = /datum/book_entry
	var/name = "Generic Information"
	var/category = "Knowledge"
	var/book_priority = 0


/datum/book_entry/proc/generate_html(mob/user)
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
		    <div>
		"}
	html += inner_book_html(user)

	html += {"
		</div>
		</div>
	</body>
	</html>
	"}
	return html

/datum/book_entry/proc/show_menu(mob/user)
	user << browse(generate_html(user),"window=recipe;size=500x810")

/datum/book_entry/proc/inner_book_html(mob/user)
