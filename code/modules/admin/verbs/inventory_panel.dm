/datum/admins/proc/show_inventory_panel(mob/living/M)
	log_admin("[key_name(usr)] opened inventory panel for [key_name(M)]")
	
	if(!M)
		to_chat(usr, "<span class='warning'>I seem to be selecting a mob that doesn't exist anymore.</span>")
		return
	
	var/body = "<html><head><title>Inventory Panel - [M.name]</title>"
	body += "<style>"
	body += "table { border-collapse: collapse; width: 100%; }"
	body += "th, td { border: 1px solid black; padding: 5px; text-align: left; }"
	body += "th { background-color: #ddd; }"
	body += "</style>"
	body +="</head>"
	body += "<body>"
	
	body += "<b>Inventory Panel: [M.name]</b><br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=repair_all'>Repair All</A> | "
	body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=refresh'>Refresh</A>"
	body += "<br><br>"
	
	var/list/all_items = list()
	
	// Add held items
	for(var/obj/item/I in M.held_items)
		if(I && !(I in all_items))
			all_items += I
	
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/obj/item/I in H.get_equipped_items(TRUE))
			// Only include equipable items: clothing, weapons, armor
			if(istype(I, /obj/item/clothing) || istype(I, /obj/item/rogueweapon) || I.slot_flags)
				if(!(I in all_items))
					all_items += I
	
	body += "<b>Equipment:</b><br>"
	
	if(all_items.len)
		body += "<table><tr><th>Icon</th><th>Item</th><th>Integrity</th><th>Actions</th></tr>"
		for(var/obj/item/I in all_items)
			var/integrity_percent = 100
			
			if(I.obj_integrity && I.max_integrity)
				integrity_percent = round((I.obj_integrity / I.max_integrity) * 100)
			
			body += "<tr>"
			body += "<td><img src='data:image/png;base64,[icon2base64(icon(I.icon, I.icon_state))]' width=32 height=32></td>"
			body += "<td>"
			body += "<A href='?_src_=vars;[HrefToken()];Vars=[REF(I)]'>[I.name]</A>"
			
			// Check if item has contents
			if(I.contents.len > 0)
				body += " <A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=view_contents;item=[REF(I)]'>(Contents)</A>"
			
			body += "</td>"
			body += "<td>[I.obj_integrity] / [I.max_integrity] ([integrity_percent]%)"
			// Sharpness info below integrity if item has sharpness
			if(I.max_blade_int > 0)
				var/sharpness_percent = round((I.blade_int / I.max_blade_int) * 100)
				body += "<br>Sharpness: [I.blade_int] / [I.max_blade_int] ([sharpness_percent]%)"
			body += "</td>"
			body += "<td>"
			body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=repair_item;item=[REF(I)]'>Repair</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=drop_item;item=[REF(I)]'>Drop</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=destroy_item;item=[REF(I)]'>Delete</A>"
			body += "</td>"
			body += "</tr>"
		body += "</table>"
	else
		body += "No equipment found<br>"
	
	body += "</body></html>"

	usr << browse(body, "window=adminplayeropts-inventory[REF(M)];size=760x600")

/datum/admins/proc/show_item_contents_panel(mob/living/M, obj/item/container)
	if(!M || !container)
		return
	
	var/body = "<html><head><title>Contents - [container.name]</title>"
	body += "<style>"
	body += "table { border-collapse: collapse; width: 100%; }"
	body += "th, td { border: 1px solid black; padding: 5px; text-align: left; }"
	body += "th { background-color: #ddd; }"
	body += "</style>"
	body += "</head>"
	body += "<body>"
	
	body += "<b>Contents of: [container.name]</b><br><br>"
	body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=view_contents;item=[REF(container)]'>Refresh</A>"
	body += "<br><br>"
	
	if(container.contents.len > 0)
		body += "<table><tr><th>Icon</th><th>Item</th><th>Integrity</th><th>Actions</th></tr>"
		for(var/obj/O in container.contents)
			var/integrity_percent = 100
			var/integrity_text = "N/A"
			
			if(istype(O, /obj/item))
				var/obj/item/I = O
				if(I.obj_integrity && I.max_integrity)
					integrity_percent = round((I.obj_integrity / I.max_integrity) * 100)
					integrity_text = "[I.obj_integrity] / [I.max_integrity] ([integrity_percent]%)"
			
			body += "<tr>"
			body += "<td><img src='data:image/png;base64,[icon2base64(icon(O.icon, O.icon_state))]' width=32 height=32></td>"
			body += "<td>"
			body += "<A href='?_src_=vars;[HrefToken()];Vars=[REF(O)]'>[O.name]</A>"
			
			// If this item also has contents, show contents button
			if(istype(O, /obj/item) && O.contents.len > 0)
				body += " <A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=view_contents;item=[REF(O)]'>(Contents)</A>"
			
			body += "</td>"
			body += "<td>[integrity_text]"
			// Sharpness info below integrity if item has sharpness
			if(istype(O, /obj/item))
				var/obj/item/I = O
				if(I.max_blade_int > 0)
					var/sharpness_percent = round((I.blade_int / I.max_blade_int) * 100)
					body += "<br>Sharpness: [I.blade_int] / [I.max_blade_int] ([sharpness_percent]%)"
			body += "</td>"
			body += "<td>"
			if(istype(O, /obj/item))
				var/obj/item/I = O
				if(I.max_integrity)
					body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=repair_item;item=[REF(O)]'>Repair</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=drop_item;item=[REF(O)]'>Drop</A> | "
			body += "<A href='?_src_=holder;[HrefToken()];target=[REF(M)];inventory_action=destroy_item;item=[REF(O)]'>Delete</A>"
			body += "</td>"
			body += "</tr>"
		body += "</table>"
	else
		body += "This container is empty.<br>"
	
	body += "</body></html>"
	
	usr << browse(body, "window=adminplayeropts-contents[REF(container)];size=760x600")


/datum/admins/proc/handle_inventory_panel_topic(href_list)
	if(!check_rights(R_ADMIN))
		return FALSE
	
	if(!href_list["inventory_action"])
		return FALSE
	
	var/mob/living/target = locate(href_list["target"])
	if(!target || !isliving(target))
		to_chat(usr, span_warning("Target no longer exists!"))
		return TRUE
	
	switch(href_list["inventory_action"])
		if("repair_all")
			var/repaired_count = 0
			for(var/obj/item/I in target.held_items)
				if(I && I.obj_integrity < I.max_integrity)
					if(I.obj_broken)
						I.obj_fix(null, TRUE)
					else
						I.obj_integrity = I.max_integrity
					I.update_icon()
					repaired_count++
				// Also restore sharpness
				if(I && I.max_blade_int > 0 && I.blade_int < I.max_blade_int)
					I.blade_int = I.max_blade_int
			
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				for(var/obj/item/I in H.GetAllContents())
					if(I.obj_integrity < I.max_integrity)
						if(I.obj_broken)
							I.obj_fix(null, TRUE)
						else
							I.obj_integrity = I.max_integrity
						I.update_icon()
						repaired_count++
					// Also restore sharpness
					if(I.max_blade_int > 0 && I.blade_int < I.max_blade_int)
						I.blade_int = I.max_blade_int
			
			to_chat(usr, span_notice("Repaired [repaired_count] items for [target.name]."))
			to_chat(target, span_notice("Your equipment has been magically repaired!"))
			message_admins("[key_name_admin(usr)] repaired all equipment for [key_name_admin(target)].")
			log_admin("[key_name(usr)] repaired all equipment for [key_name(target)].")
			show_inventory_panel(target)
		
		if("damage_all")
			var/damaged_count = 0
			for(var/obj/item/I in target.held_items)
				if(I && I.max_integrity)
					I.obj_integrity = I.max_integrity * 0.5
					I.update_icon()
					damaged_count++
			
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				for(var/obj/item/I in H.GetAllContents())
					if(I.max_integrity)
						I.obj_integrity = I.max_integrity * 0.5
						I.update_icon()
						damaged_count++
			
			to_chat(usr, span_notice("Damaged [damaged_count] items for [target.name]."))
			to_chat(target, span_warning("Your equipment suddenly feels weaker!"))
			message_admins("[key_name_admin(usr)] damaged all equipment for [key_name_admin(target)].")
			log_admin("[key_name(usr)] damaged all equipment for [key_name(target)].")
			show_inventory_panel(target)
		
		if("destroy_all")
			if(alert(usr, "Really destroy ALL equipment for [target.name]?", "Confirm", "Yes", "No") != "Yes")
				show_inventory_panel(target)
				return TRUE
			
			var/destroyed_count = 0
			for(var/obj/item/I in target.held_items)
				if(I)
					qdel(I)
					destroyed_count++
			
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				for(var/obj/item/I in H.GetAllContents())
					qdel(I)
					destroyed_count++
			
			to_chat(usr, span_notice("Destroyed [destroyed_count] items for [target.name]."))
			to_chat(target, span_danger("All your equipment disintegrates!"))
			message_admins("[key_name_admin(usr)] destroyed all equipment for [key_name_admin(target)].")
			log_admin("[key_name(usr)] destroyed all equipment for [key_name(target)].")
			show_inventory_panel(target)
		
		if("repair_item")
			var/obj/item/I = locate(href_list["item"])
			if(I && I.max_integrity)
				if(I.obj_broken)
					I.obj_fix(null, TRUE)
				else
					I.obj_integrity = I.max_integrity
				// Also restore sharpness
				if(I.max_blade_int > 0)
					I.blade_int = I.max_blade_int
				I.update_icon()
				to_chat(usr, span_notice("Repaired [I.name]."))
				message_admins("[key_name_admin(usr)] repaired [I.name] for [key_name_admin(target)].")
				log_admin("[key_name(usr)] repaired [I.name] for [key_name(target)].")
				// Check if item is in a container, if so refresh contents panel
				if(I.loc && istype(I.loc, /obj/item))
					show_item_contents_panel(target, I.loc)
				else
					show_inventory_panel(target)
		
		if("drop_item")
			var/obj/item/I = locate(href_list["item"])
			if(I)
				var/item_name = I.name
				var/obj/container = I.loc
				// Unequip if worn/held
				if(ishuman(target))
					var/mob/living/carbon/human/H = target
					H.dropItemToGround(I, force = TRUE)
				else if(isliving(target))
					var/mob/living/L = target
					L.dropItemToGround(I, force = TRUE)
				else
					I.forceMove(get_turf(target))
				to_chat(usr, span_notice("Dropped [item_name]."))
				to_chat(target, span_warning("Your [item_name] falls to the ground!"))
				message_admins("[key_name_admin(usr)] dropped [item_name] for [key_name_admin(target)].")
				log_admin("[key_name(usr)] dropped [item_name] for [key_name(target)].")
				// Check if item was in a container, if so refresh contents panel
				if(container && istype(container, /obj/item))
					show_item_contents_panel(target, container)
				else
					show_inventory_panel(target)
		
		if("damage_item")
			var/obj/item/I = locate(href_list["item"])
			if(I && I.max_integrity)
				I.obj_integrity = max(I.max_integrity * 0.25, 1)
				I.update_icon()
				to_chat(usr, span_notice("Damaged [I.name]."))
				message_admins("[key_name_admin(usr)] damaged [I.name] for [key_name_admin(target)].")
				log_admin("[key_name(usr)] damaged [I.name] for [key_name(target)].")
				show_inventory_panel(target)
		
		if("destroy_item")
			var/obj/item/I = locate(href_list["item"])
			if(I)
				var/item_name = I.name
				var/obj/container = I.loc
				qdel(I)
				to_chat(usr, span_notice("Destroyed [item_name]."))
				to_chat(target, span_warning("Your [item_name] disintegrates!"))
				message_admins("[key_name_admin(usr)] destroyed [item_name] for [key_name_admin(target)].")
				log_admin("[key_name(usr)] destroyed [item_name] for [key_name(target)].")
				// Check if item was in a container, if so refresh contents panel
				if(container && istype(container, /obj/item))
					show_item_contents_panel(target, container)
				else
					show_inventory_panel(target)
		
		if("view_contents")
			var/obj/item/I = locate(href_list["item"])
			if(I)
				show_item_contents_panel(target, I)
		
		if("refresh")
			show_inventory_panel(target)
		
		if("close")
			return TRUE
	
	return TRUE

/datum/admins/proc/admin_show_inventory(mob/living/M in GLOB.mob_list)
	set name = "Show Inventory Panel"
	set category = "-GameMaster-"

	if(!check_rights(R_ADMIN))
		return

	show_inventory_panel(M)

/client/proc/show_inventory_panel(mob/M)
	holder?.show_inventory_panel(M)
