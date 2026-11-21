/datum/action/cooldown/spell/murkling_shapeshift
	name = "Murkling Shapeshift"
	desc = "Reshape your body, molding your outer layer of ooze anew."
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "mirror"
	click_to_activate = FALSE
	primary_resource_type = SPELL_COST_NONE
	primary_resource_cost = 0
	sound = null
	invocations = list()
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 0
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/murkling_shapeshift/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/murkling = owner
	if(!istype(murkling) || !istype(murkling.dna?.species, /datum/species/ooze))
		return FALSE
	perform_murkling_shapeshift(murkling)
	return TRUE

/proc/murkling_accessory_colors(accessory_type, mob/living/carbon/human/murkling)
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	if(!accessory || !murkling?.dna)
		return
	var/body_color = sanitize_hexcolor(murkling.dna.features["mcolor"], 6, TRUE)
	var/list/colors = list()
	for(var/color_index in 1 to accessory.color_keys)
		colors += body_color
	return color_list_to_string(colors)

/proc/perform_murkling_shapeshift(mob/living/carbon/human/H)
	if(!istype(H) || !istype(H.dna?.species, /datum/species/ooze))
		return

	var/list/choices = list("Ears", "Eye Color", "Facial Hairstyle", "Hairstyle", "Penis", "Tail", "Testicles", "Vagina", "Wings")
	var/chosen = input(H, "Change what?", "Appearance") as null|anything in choices
	if(!chosen)
		return

	H.visible_message(
		span_notice("[H]'s body ripples and begins to reshape."),
		span_notice("Your body ripples and begins to reshape."),
	)
	playsound(H, 'sound/foley/gross.ogg', 50, TRUE)
	if(!do_after(H, 5 SECONDS) || !istype(H.dna?.species, /datum/species/ooze))
		H.visible_message(
			span_notice("[H]'s body settles back into its usual shape."),
			span_notice("Your body settles back into its usual shape."),
		)
		return

	var/should_update = FALSE
	switch(chosen)
		if("Ears")
			var/list/valid_ears = list("none")
			for(var/ears_path in subtypesof(/datum/sprite_accessory/ears))
				var/datum/sprite_accessory/ears/ear_type = new ears_path()
				valid_ears[ear_type.name] = ears_path

			var/new_style = input(H, "Choose your ears", "Ears Customization") as null|anything in valid_ears
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
					if(ears)
						ears.Remove(H)
						qdel(ears)
						should_update = TRUE
				else
					var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
					if(!ears)
						ears = new()
						ears.Insert(H, TRUE, FALSE)
					ears.accessory_type = valid_ears[new_style]
					ears.accessory_colors = murkling_accessory_colors(ears.accessory_type, H)
					should_update = TRUE

		if("Eye Color")
			var/new_eye_color = color_pick_sanitized(H, "Choose your eye color", "Eye Color", H.eye_color)
			if(new_eye_color)
				new_eye_color = sanitize_hexcolor(new_eye_color, 6, TRUE)
				var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
				if(eyes)
					eyes.Remove(H)
					eyes.eye_color = new_eye_color
					eyes.Insert(H, TRUE, FALSE)
				H.eye_color = new_eye_color
				H.dna.features["eye_color"] = new_eye_color
				H.dna.update_ui_block(DNA_EYE_COLOR_BLOCK)
				should_update = TRUE

		if("Facial Hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/slime)
			var/list/valid_facial_hairstyles = list()
			for(var/facial_type in facial_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/facial/facial = new facial_type()
				valid_facial_hairstyles[facial.name] = facial_type

			var/new_style = input(H, "Choose your facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/facial/current_facial
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break

					if(current_facial)
						var/datum/customizer_entry/hair/facial/facial_entry = new()
						facial_entry.hair_color = current_facial.hair_color
						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(valid_facial_hairstyles[new_style], murkling_accessory_colors(valid_facial_hairstyles[new_style], H), H)
						facial_choice.customize_feature(new_facial, H, null, facial_entry)
						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						H.update_hair()
						should_update = TRUE

		if("Hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid/slime)
			var/list/valid_hairstyles = list()
			for(var/hair_type in hair_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/head/hair = new hair_type()
				valid_hairstyles[hair.name] = hair_type

			var/new_style = input(H, "Choose your hairstyle", "Hair Styling") as null|anything in valid_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						if(hasvar(current_hair, "hair_dye_gradient"))
							hair_entry.dye_gradient = current_hair.hair_dye_gradient
						if(hasvar(current_hair, "hair_dye_color"))
							hair_entry.dye_color = current_hair.hair_dye_color

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(valid_hairstyles[new_style], murkling_accessory_colors(valid_hairstyles[new_style], H), H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)
						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						H.update_hair()
						should_update = TRUE

		if("Penis")
			var/list/valid_penis_types = list("none")
			for(var/penis_path in subtypesof(/datum/sprite_accessory/penis))
				var/datum/sprite_accessory/penis/penis_type = new penis_path()
				valid_penis_types[penis_type.name] = penis_path

			var/new_style = input(H, "Choose your penis type", "Penis Customization") as null|anything in valid_penis_types
			if(new_style)
				var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
				if(new_style == "none")
					if(penis)
						penis.Remove(H)
						qdel(penis)
						should_update = TRUE
				else
					if(!penis)
						penis = new()
						penis.Insert(H, TRUE, FALSE)
					penis.accessory_type = valid_penis_types[new_style]
					penis.accessory_colors = murkling_accessory_colors(penis.accessory_type, H)
					should_update = TRUE

		if("Tail")
			var/list/valid_tails = list("none")
			for(var/tail_path in subtypesof(/datum/sprite_accessory/tail))
				var/datum/sprite_accessory/tail/tail_type = new tail_path()
				valid_tails[tail_type.name] = tail_path

			var/new_style = input(H, "Choose your tail", "Tail Customization") as null|anything in valid_tails
			if(new_style)
				var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
				if(new_style == "none")
					if(tail)
						tail.Remove(H)
						qdel(tail)
						should_update = TRUE
				else
					if(!tail)
						tail = new /obj/item/organ/tail/anthro()
						tail.Insert(H, TRUE, FALSE)
					tail.accessory_type = valid_tails[new_style]
					tail.accessory_colors = murkling_accessory_colors(tail.accessory_type, H)
					should_update = TRUE

		if("Testicles")
			var/list/valid_testicle_types = list("none")
			for(var/testicle_path in subtypesof(/datum/sprite_accessory/testicles))
				var/datum/sprite_accessory/testicles/testicles_type = new testicle_path()
				valid_testicle_types[testicles_type.name] = testicle_path

			var/new_style = input(H, "Choose your testicles type", "Testicles Customization") as null|anything in valid_testicle_types
			if(new_style)
				var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
				if(new_style == "none")
					if(testicles)
						testicles.Remove(H)
						qdel(testicles)
						should_update = TRUE
				else
					if(!testicles)
						testicles = new()
						testicles.Insert(H, TRUE, FALSE)
					testicles.accessory_type = valid_testicle_types[new_style]
					testicles.accessory_colors = murkling_accessory_colors(testicles.accessory_type, H)
					should_update = TRUE

		if("Vagina")
			var/list/valid_vagina_types = list("none", "human", "hairy", "spade", "furred", "gaping", "cloaca")
			var/new_style = input(H, "Choose your vagina type", "Vagina Customization") as null|anything in valid_vagina_types
			if(new_style)
				var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
				if(new_style == "none")
					if(vagina)
						vagina.Remove(H)
						qdel(vagina)
						should_update = TRUE
				else
					if(!vagina)
						vagina = new()
						vagina.Insert(H, TRUE, FALSE)
					vagina.accessory_type = valid_vagina_types[new_style]
					vagina.accessory_colors = murkling_accessory_colors(vagina.accessory_type, H)
					should_update = TRUE

		if("Wings")
			var/list/valid_wings = list("none")
			for(var/wings_path in subtypesof(/datum/sprite_accessory/wings))
				var/datum/sprite_accessory/wings/wing_type = new wings_path()
				valid_wings[wing_type.name] = wings_path

			var/new_style = input(H, "Choose your wings", "Wings Customization") as null|anything in valid_wings
			if(new_style)
				var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
				if(new_style == "none")
					if(wings)
						wings.Remove(H)
						qdel(wings)
						should_update = TRUE
				else
					if(!wings)
						wings = new()
						wings.Insert(H, TRUE, FALSE)
					wings.accessory_type = valid_wings[new_style]
					wings.accessory_colors = murkling_accessory_colors(wings.accessory_type, H)
					should_update = TRUE

	if(should_update)
		H.update_hair()
		H.update_body()
		H.update_body_parts()
		H.visible_message(
			span_notice("[H]'s body settles into its new shape."),
			span_notice("Your body settles into its new shape."),
		)
	else
		H.visible_message(
			span_notice("[H]'s body stops shifting without changing shape."),
			span_notice("Your body stops shifting without changing shape."),
		)
