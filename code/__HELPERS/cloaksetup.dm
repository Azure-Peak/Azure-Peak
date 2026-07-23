/mob/proc/cloak_and_title_setup()
	if(!client)
		addtimer(CALLBACK(src, PROC_REF(cloak_and_title_setup)), 50)
		return
	var/list/allowed_cloaks
	var/name_index
	switch(src.mind.assigned_role)
		if("Knight")
			name_index = "knight's"
			allowed_cloaks = list(
			"Jupon" = 			/obj/item/clothing/cloak/tabard/stabard/surcoat/guard,
			"Surcoat" = 	/obj/item/clothing/cloak/tabard/stabard/guard,
			"Hood" = 		/obj/item/clothing/cloak/tabard/stabard/guardhood,
			"Tabard" = 	/obj/item/clothing/cloak/tabard/retinue,
			"Cape" = 			/obj/item/clothing/cloak/cape/guard,
			)
		if("Squire")
			name_index = "squire's"
			allowed_cloaks = list(
			"Jupon" = 			/obj/item/clothing/cloak/tabard/stabard/surcoat/guard,
			"Surcoat" = 	/obj/item/clothing/cloak/tabard/stabard/guard,
			"Hood" = 		/obj/item/clothing/cloak/tabard/stabard/guardhood,
			"Tabard" =		/obj/item/clothing/cloak/tabard/retinue,
			"Cape" = 			/obj/item/clothing/cloak/cape/guard,
			)
		if("Man at Arms")
			name_index = "man-at-arms"
			allowed_cloaks = list(
			"Jupon" = 			/obj/item/clothing/cloak/tabard/stabard/surcoat/guard,
			"Surcoat" = 			/obj/item/clothing/cloak/tabard/stabard/guard,
			"Hood" = 		/obj/item/clothing/cloak/tabard/stabard/guardhood,
			)
		if("Sergeant")
			name_index = "sergeant"
			allowed_cloaks = list(
			"Jupon" = 			/obj/item/clothing/cloak/tabard/stabard/surcoat/guard,
			"Surcoat" = 			/obj/item/clothing/cloak/tabard/stabard/guard,
			"Hood" = 		/obj/item/clothing/cloak/tabard/stabard/guardhood,
			"Cape" = 			/obj/item/clothing/cloak/cape/guard,
			)

	var/choive_key = input(src, "Choose your cloak.", "IDENTIFY YOURSELF") as anything in allowed_cloaks
	var/typepath = allowed_cloaks[choive_key]
	var/obj/item/clothing/cloak/cloak_choice = new typepath(src)
	var/list/namesplit = splittext(src.real_name, " ")
	if(src.mind.assigned_role == "Knight")
		cloak_choice.name = "[name_index] [cloak_choice.name] ([namesplit[2]])"
	else
		cloak_choice.name = "[name_index] [cloak_choice.name] ([namesplit[1]])"
	src.equip_to_slot_or_del(cloak_choice, SLOT_CLOAK)
