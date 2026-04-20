
/datum/admins/proc/create_mob(mob/user)
	var/static/create_mob_html
	if (!create_mob_html)
		var/mobjs = null
		mobjs = jointext(typesof(/mob), ";")
		create_mob_html = file2text('html/create_object.html')
		create_mob_html = replacetext(create_mob_html, "Create Object", "Create Mob")
		create_mob_html = replacetext(create_mob_html, "null /* object types */", "\"[mobjs]\"")

		var/faction_options = "<option value=\"\">- default (keep mob's native faction) -</option>"
		for(var/faction in GLOB.gm_spawn_factions)
			faction_options += "<option value=\"[faction]\">[faction]</option>"
		faction_options += "<option value=\"__custom__\">- custom (see text box) -</option>"

		var/faction_block = {"<input type="checkbox" name="disable_ai" value="1"> Disable AI &nbsp; <input type="checkbox" name="dust_on_death" value="1"> Dust on death &nbsp; <input type="checkbox" name="dust_leave_head" value="1"> Dust, leave head &nbsp; <input type="checkbox" name="dust_delete_gear" value="1"> Dust, delete gear<br>
Faction: <select name="faction_preset" style="width:250px">[faction_options]</select><br>
Custom faction: <input type="text" name="faction_custom" value="" style="width:250px"> (used only if Custom is selected)<br><br>
<input type="submit" value="spawn">"}

		create_mob_html = replacetext(create_mob_html, "<input type=\"submit\" value=\"spawn\">", faction_block)

	user << browse(create_panel_helper(create_mob_html), "window=create_mob;size=600x525")

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
