/mob/living/carbon/human/proc/select_skeleton_features()
	var/mob/living/carbon/human/H = src
	if(!H)
		return

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		to_chat(H, span_warning("You have no head to modify!"))
		return

	// 1. Skull Customization (using the Accessory bodypart feature)
	var/list/valid_skulls = list("Human" = null)
	for(var/skull_path in subtypesof(/datum/sprite_accessory/snout/skeleton))
		var/datum/sprite_accessory/skull = new skull_path()
		valid_skulls[skull.name] = skull_path

	var/skull_choice = input(H, "Choose your skull structure", "Skull Customization") as null|anything in valid_skulls
	if(skull_choice)
		// Remove any existing accessory feature
		for(var/datum/bodypart_feature/accessory/old_acc in head.bodypart_features)
			head.remove_bodypart_feature(old_acc)
			break

		if(skull_choice != "Human")
			var/datum/bodypart_feature/accessory/new_acc = new()
			new_acc.set_accessory_type(valid_skulls[skull_choice], "#FFFFFF", H)
			var/datum/sprite_accessory/SA = SPRITE_ACCESSORY(new_acc.accessory_type)
			if(SA)
				new_acc.accessory_colors = SA.get_default_colors(color_key_source_list_from_carbon(H))
			head.add_bodypart_feature(new_acc)

	// 2. Tail Customization
	var/list/valid_tails = list("none" = "none")
	for(var/tail_path in subtypesof(/datum/sprite_accessory/tail/skeleton))
		var/datum/sprite_accessory/tail/T = new tail_path()
		valid_tails[T.name] = tail_path

	var/tail_choice = input(H, "Choose your tail", "Tail Customization") as null|anything in valid_tails
	if(tail_choice)
		var/obj/item/organ/tail/tail_organ = H.getorganslot(ORGAN_SLOT_TAIL)
		if(tail_choice == "none")
			if(tail_organ)
				tail_organ.Remove(H)
				qdel(tail_organ)
		else
			if(!tail_organ)
				tail_organ = new /obj/item/organ/tail/anthro()
				tail_organ.Insert(H, TRUE, FALSE)
			tail_organ.accessory_type = valid_tails[tail_choice]
			var/datum/sprite_accessory/tail/tail_type = SPRITE_ACCESSORY(tail_organ.accessory_type)
			tail_organ.accessory_colors = tail_type.get_default_colors(color_key_source_list_from_carbon(H))

	// Force visual update
	H.update_hair()
	H.update_body()
	H.update_body_parts()
