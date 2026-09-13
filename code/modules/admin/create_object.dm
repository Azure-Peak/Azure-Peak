/datum/admins/proc/create_panel_helper(template)
	var/final_html = replacetext(template, "/* ref src */", "[REF(src)];[HrefToken()]")
	final_html = replacetext(final_html,"/* hreftokenfield */","[HrefTokenFormField()]")
	return final_html

/datum/admins/proc/create_object(mob/user)
	var/static/create_object_html = null
	if (!create_object_html)
		var/objectjs = null
		objectjs = jointext(typesof(/obj), ";")

		var/objectnames = null
		var/list/object_name_list = list()
		for (var/obj/object as anything in typesof(/obj))
			// Null and empty names won't display; semicolon names will mess up the generated JS...
			if (object.name && object.name != "" && object.name != ";")
				object_name_list.Add(object.name)
			else
				// ...so display an appropriate "name" rather than removing the entry.
				// We want these arrays to be the same length!
				object_name_list.Add("(NO NAME)")
		objectnames = jointext(object_name_list, ";")
		objectnames = replacetext(objectnames, "\"", "\\\"") // Some names have quotation marks in them, so escape them...

		create_object_html = file2text('html/create_object.html')
		create_object_html = replacetext(create_object_html, "null /* object types */", "\"[objectjs]\"")
		create_object_html = replacetext(create_object_html, "null /* object names */", "\"[objectnames]\"")

	user << browse(create_panel_helper(create_object_html), "window=create_object;size=425x475")

/datum/admins/proc/quick_create_object(mob/user)
	var/static/list/create_object_forms = list(
	/obj, /obj/structure, /obj/machinery, /obj/effect,
	/obj/item, /obj/item/clothing, /obj/item,
	/obj/item/reagent_containers, /obj/item/gun)

	var/path = input(user, "Select the path of the object you wish to create.", "Path", /obj) in sortList(create_object_forms, GLOBAL_PROC_REF(cmp_typepaths_asc))
	var/html_form = create_object_forms[path]

	if (!html_form)
		var/objectjs = jointext(typesof(path), ";")

		var/objectnames = null
		var/list/object_name_list = list()
		for (var/obj/object as anything in typesof(path))
			// Null and empty names won't display; semicolon names will mess up the generated JS...
			if (object.name && object.name != "" && object.name != ";")
				object_name_list.Add(object.name)
			else
				// ...so display an appropriate "name" rather than removing the entry.
				// We want these arrays to be the same length!
				object_name_list.Add("(NO NAME)")
		objectnames = jointext(object_name_list, ";")
		objectnames = replacetext(objectnames, "\"", "\\\"") // Some names have quotation marks in them, so escape them...

		html_form = file2text('html/create_object.html')
		html_form = replacetext(html_form, "Create Object", "Create [path]")
		html_form = replacetext(html_form, "null /* object types */", "\"[objectjs]\"")
		html_form = replacetext(html_form, "null /* object names */", "\"[objectnames]\"")
		create_object_forms[path] = html_form

	user << browse(create_panel_helper(html_form), "window=qco[path];size=425x475")
