/obj/structure/flagpole
	name = "flagpole"
	icon = 'icons/roguetown/misc/flagpole.dmi'
	icon_state = "flagpole"
	desc = "An artificed flagpole. It responds to distant signals to show which of the town's important figures are currently active..."
	density = TRUE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

/obj/structure/flagpole/Initialize(mapload)
	. = ..()
	SSrogueinfo.all_flags += src

/obj/structure/flagpole/Destroy()
	SSrogueinfo.all_flags -= src
	return ..()

/obj/structure/flagpole/proc/update_single_role(role_name, is_visible)
	var/icon_state_name = "[role_name]"
	var/image/I = image(icon, icon_state_name)

	if(is_visible)
		add_overlay(I)
	else
		cut_overlay(I)
	update_desc()

/obj/structure/flagpole/proc/update_desc()
	var/list/active_names = list()
	for(var/role in SSrogueinfo.role_visibility)
		if(SSrogueinfo.role_visibility[role])
			active_names += role

	desc = active_names.len ? "Flags flying: [english_list(active_names)]." : "[initial(desc)]"

/obj/structure/flagpole/examine(mob/user)
	. = ..()

	var/list/active_roles = list()
	for(var/role in SSrogueinfo.role_visibility)
		if(SSrogueinfo.role_visibility[role])
			active_roles += role

	if(!active_roles.len)
		return

	var/dropdown_html = "<details><summary><b>View Active Flag Details</b></summary>"

	for(var/role in active_roles)
		var/list/data = SSrogueinfo.role_data[role]
		var/role_desc = data ? data["desc"] : "No description available."
		var/role_note = data ? data["note"] : "No custom notes."

		dropdown_html += "<details style='margin-left: 10px;'>"
		dropdown_html += "<summary>[capitalize(role)]</summary>"
		dropdown_html += "<p><em>Info:</em> [role_desc]</p>"
		dropdown_html += "<p><em>Note:</em> [role_note]</p>"
		dropdown_html += "</details>"

	dropdown_html += "</details>"

	. += dropdown_html

/obj/item/mini_flagpole
	name = "freeform miniature flagpole"
	icon = 'icons/roguetown/misc/flagpole_mini.dmi'
	icon_state = "flagpole"
	desc = "Used to signify your presence in town. Middle click to set a custom notice on the flagpoles in town, use to raise your flag or lower it."

	w_class = WEIGHT_CLASS_TINY
	var/controlled_role = "freeform1"
	var/flag_color = "#ffffff"
	var/mutable_appearance/flag_overlay
	var/list/authorized_jobs = list()

/obj/item/mini_flagpole/proc/can_use(mob/user)
	if(!length(authorized_jobs))
		return TRUE

	if(!iscarbon(user))
		return FALSE

	var/user_job = user.job
	if(user_job in authorized_jobs)
		return TRUE

	to_chat(user, span_alert("You do not have the power to manipulate this flagpole."))
	return FALSE

/obj/item/mini_flagpole/proc/update_visuals()
	flag_overlay = mutable_appearance(icon, "flag")
	flag_overlay.color = flag_color

	var/active = SSrogueinfo.role_visibility[controlled_role]

	if(active)
		add_overlay(flag_overlay)
	else
		cut_overlay(flag_overlay)

/obj/item/mini_flagpole/attack_self(mob/user)
	if(!can_use(user))
		return
	var/new_status = !SSrogueinfo.role_visibility[controlled_role]

	if(SSrogueinfo.set_role_visibility(controlled_role, new_status))
		update_visuals()
		to_chat(user, "You set the [controlled_role] flag to [new_status ? "raised" : "lowered"].")

/obj/item/mini_flagpole/MiddleClick(mob/user, params)
	. = ..()
	if(!can_use(user))
		return

	if(!istype(user))
		return
	var/new_note = tgui_input_text(user, "Enter a new custom note for the [controlled_role]:", "Update Role Note", "", MAX_MESSAGE_LEN)
	
	if(!new_note)
		return

	if(SSrogueinfo.role_data[controlled_role])
		SSrogueinfo.role_data[controlled_role]["note"] = new_note
		to_chat(user, span_notice("You have updated the custom note for [controlled_role]."))
	else
		to_chat(user, span_alert("Error: No data entry found for [controlled_role]."))

/obj/item/mini_flagpole/freeform2
	name = "freeform miniature flagpole"
	controlled_role = "freeform2"
	flag_color = "#ffffff"

/obj/item/mini_flagpole/blacksmith
	name = "blacksmith miniature flagpole"
	controlled_role = "blacksmith"
	flag_color = "#808080" // Gray
	authorized_jobs = list("Guildsman", "Guildmaster")

/obj/item/mini_flagpole/artificer
	name = "artificer miniature flagpole"
	controlled_role = "artificer"
	flag_color = "#B87333" // Copper
	authorized_jobs = list("Guildsman", "Guildmaster")

/obj/item/mini_flagpole/steward
	name = "steward miniature flagpole"
	controlled_role = "steward"
	flag_color = "#FFD700" // Gold
	authorized_jobs = list("Steward", "Clerk")

/obj/item/mini_flagpole/duke
	name = "duke miniature flagpole"
	controlled_role = "duke"
	flag_color = "#007FFF" // Azure

/obj/item/mini_flagpole/apothecary
	name = "apothecary miniature flagpole"
	controlled_role = "apothecary"
	flag_color = "#A9A9A9" // Dark Gray
	authorized_jobs = list("Head Physician", "Apothecary", "Keeper")

/obj/item/mini_flagpole/church
	name = "church miniature flagpole"
	controlled_role = "church"
	flag_color = "#00FFFF" // Cyan
	authorized_jobs = list("Bishop", "Keeper", "Templar", "Druid", "Acolyte", "Sexton", "Head Physician", "Apothecary")

/obj/item/mini_flagpole/fisher
	name = "fisher miniature flagpole"
	controlled_role = "fisher"
	flag_color = "#006400" // Dark Green
	authorized_jobs = list("Towner")

/obj/item/mini_flagpole/university
	name = "university miniature flagpole"
	controlled_role = "university"
	flag_color = "#000080" // Deep Marine Blue

/obj/item/mini_flagpole/innkeeper
	name = "innkeeper miniature flagpole"
	controlled_role = "innkeeper"
	flag_color = "#800020" // Burgundy
	authorized_jobs = list("Towner", "Innkeeper", "Tapster", "Cook")

/obj/item/mini_flagpole/tailor
	name = "tailor miniature flagpole"
	controlled_role = "tailor"
	flag_color = "#FFFFFF" // Bright White
	authorized_jobs = list("Tailor")

/obj/item/mini_flagpole/bathhouse
	name = "bathhouse miniature flagpole"
	controlled_role = "bathhouse"
	flag_color = "#800080" // Purple
	authorized_jobs = list("Bathhouse Attendant", "Bathmaster")

/obj/item/mini_flagpole/merchant
	name = "merchant miniature flagpole"
	controlled_role = "merchant"
	flag_color = "#C0C0C0" // Silver
	authorized_jobs = list("Merchant", "Shophand")
