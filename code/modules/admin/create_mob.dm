
/datum/admins/proc/create_mob(mob/user)
	var/static/create_mob_html
	if (!create_mob_html)
		var/mobjs = null
		mobjs = jointext(typesof(/mob), ";")
		create_mob_html = file2text('html/create_object.html')
		create_mob_html = replacetext(create_mob_html, "Create Object", "Create Mob")
		create_mob_html = replacetext(create_mob_html, "null /* object types */", "\"[mobjs]\"")
		create_mob_html = replacetext(create_mob_html, "<input type=\"submit\" value=\"spawn\">", \
			"<input type=\"checkbox\" name=\"disable_ai\" value=\"1\"> Disable AI<br><br><input type=\"submit\" value=\"spawn\">")

	user << browse(create_panel_helper(create_mob_html), "window=create_mob;size=550x475")

/proc/randomize_human(mob/living/carbon/human/H, include_gender = FALSE)
	set waitfor = 0
	if(include_gender)
		H.gender = pick(MALE, FEMALE)
	H.real_name = random_unique_name(H.gender)
	H.name = H.real_name
	H.skin_tone = random_skin_tone()
	H.eye_color = random_eye_color()
	H.dna.blood_type = random_blood_type()

	H.update_body()
	H.update_hair()
	H.update_body_parts()
