/obj/effect/proc_holder/spell/invoked/mirror_transform  // Changed from targeted to invoked
	name = "Mirror Transform"
	desc = "Temporarily grants you the ability to use mirrors to change your appearance."
	clothes_req = FALSE
	charge_type = "recharge"
	associated_skill = /datum/skill/magic/arcane
	cost = 1 // Trash spell
	xp_gain = TRUE
	// Fix invoked spell variables
	releasedrain = 35
	chargedrain = 1  // Fixed from chargeddrain to chargedrain
	chargetime = 10
	recharge_time = 300 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 1
	invocations = list("Effingo")
	invocation_type = "whisper"
	hide_charge_effect = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/wind
	overlay_state = "mirror"

/obj/effect/proc_holder/spell/invoked/mirror_transform/cast(list/targets, mob/user)  // Changed to match invoked spell pattern
	if(!isliving(targets[1]))
		return
	var/mob/living/carbon/human/H = targets[1]
	if(!istype(H))
		return

	ADD_TRAIT(H, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
	H.visible_message(span_notice("[H]'s reflection shimmers briefly."), span_notice("You feel a connection to mirrors forming..."))
	
	addtimer(CALLBACK(src, PROC_REF(remove_mirror_magic), H), 5 MINUTES)
	return TRUE  // Return TRUE for successful cast

/obj/effect/proc_holder/spell/invoked/mirror_transform/proc/remove_mirror_magic(mob/living/carbon/human/H)
	if(!QDELETED(H))
		REMOVE_TRAIT(H, TRAIT_MIRROR_MAGIC, TRAIT_GENERIC)
		to_chat(H, span_warning("Your connection to mirrors fades away."))

/proc/perform_mirror_transform(mob/living/carbon/human/H)
	// Handles the actual appearance changing part of the spell. For reasons unknown to man, this previously lived exclusively on the mirror object.
	if (!H)
		return
	var/should_update = FALSE
	var/list/choices = list("Accessory", "Breast Quantity", "Breast Size", "Ears", "Ear Color One", "Ear Color Two", "Eye Color", "Facial Hairstyle", "Facial Hair Color", "Face Detail", "Hairstyle", "Hair Primary Color", "Hair Secondary Gradient", "Hair Secondary Natural Color", "Hair Third Gradient", "Hair Third Dye Color", "Horns", "Horn Color", "Penis", "Penis Size", "Tail", "Tail Color One", "Tail Color Two", "Testicles", "Testicle Size", "Vagina", "Wings", "Wing Color")
	var/chosen = input(H, "Change what?", "Appearance") as null|anything in choices

	if(!chosen)
		return

	switch(chosen)
		if("Hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_hairstyles = list()
			for(var/hair_type in hair_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/head/hair = new hair_type()
				valid_hairstyles[hair.name] = hair_type

			var/new_style = input(H, "Choose your hairstyle", "Hair Styling") as null|anything in valid_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color

						if(istype(current_hair, /datum/bodypart_feature/hair/head))
							hair_entry.natural_gradient = current_hair.natural_gradient
							hair_entry.natural_color = current_hair.natural_color
							if(hasvar(current_hair, "hair_dye_gradient"))
								hair_entry.dye_gradient = current_hair.hair_dye_gradient
							if(hasvar(current_hair, "hair_dye_color"))
								hair_entry.dye_color = current_hair.hair_dye_color

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)

						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						H.update_hair()
						should_update = TRUE

		if("Hair Primary Color")
			var/new_hair_color = color_pick_sanitized(H, "Choose your hair color", "Primary Hair Color", H.hair_color)
			if(new_hair_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

					var/datum/customizer_entry/hair/hair_entry = new()
					hair_entry.hair_color = sanitize_hexcolor(new_hair_color, 6, TRUE)

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/bodypart_feature/hair/head/new_hair = new()

						new_hair.set_accessory_type(current_hair.accessory_type, null, H)

						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						H.hair_color = hair_entry.hair_color
						H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)

						H.dna.species.handle_body(H)
						H.update_body()
						H.update_hair()
						H.update_body_parts()
						should_update = TRUE

		if("Facial Hair Color")
			var/new_facial_hair_color = color_pick_sanitized(H, "Choose your facial hair color", "Facial Hair Color", H.facial_hair_color)
			if(new_facial_hair_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)

					var/datum/customizer_entry/hair/facial/facial_entry = new()

					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break

					if(current_facial)
						facial_entry.hair_color = sanitize_hexcolor(new_facial_hair_color, 6, TRUE)
						facial_entry.accessory_type = current_facial.accessory_type

						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(current_facial.accessory_type, null, H)
						facial_choice.customize_feature(new_facial, H, null, facial_entry)

						H.facial_hair_color = facial_entry.hair_color
						H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
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
				H.update_body_parts()
				should_update = TRUE

		if("Hair Secondary Gradient")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type

			var/new_style = input(H, "Choose your natural gradient", "Secondary Natural Hair Gradient") as null|anything in valid_gradients
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = valid_gradients[new_style]
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("Hair Secondary Natural Color")
			var/new_gradient_color = color_pick_sanitized(H, "Choose your natural gradient color", "Secondary Natural Hair Gradient Color", H.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

					var/datum/customizer_entry/hair/hair_entry = new()

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("Hair Third Gradient")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_gradients = list()
			for(var/gradient_type in GLOB.hair_gradients)
				valid_gradients[gradient_type] = gradient_type

			var/new_style = input(H, "Choose your dye gradient", "Hair Third Dye Gradient") as null|anything in valid_gradients
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						var/datum/customizer_entry/hair/hair_entry = new()
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = valid_gradients[new_style]
						hair_entry.dye_color = current_hair.hair_dye_color
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("Hair Third Dye Color")
			var/new_gradient_color = color_pick_sanitized(H, "Choose your third gradient hair color", "Third Hair Gradient Color", H.hair_color)
			if(new_gradient_color)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)

					var/datum/customizer_entry/hair/hair_entry = new()

					var/datum/bodypart_feature/hair/head/current_hair = null
					for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
						current_hair = hair_feature
						break

					if(current_hair)
						hair_entry.hair_color = current_hair.hair_color
						hair_entry.natural_gradient = current_hair.natural_gradient
						hair_entry.natural_color = current_hair.natural_color
						hair_entry.dye_gradient = current_hair.hair_dye_gradient
						hair_entry.dye_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
						hair_entry.accessory_type = current_hair.accessory_type

						var/datum/bodypart_feature/hair/head/new_hair = new()
						new_hair.set_accessory_type(current_hair.accessory_type, null, H)
						hair_choice.customize_feature(new_hair, H, null, hair_entry)

						head.remove_bodypart_feature(current_hair)
						head.add_bodypart_feature(new_hair)
						should_update = TRUE

		if("Facial Hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
			var/list/valid_facial_hairstyles = list()
			for(var/facial_type in facial_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/facial/facial = new facial_type()
				valid_facial_hairstyles[facial.name] = facial_type

			var/new_style = input(H, "Choose your facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					var/datum/bodypart_feature/hair/facial/current_facial = null
					for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
						current_facial = facial_feature
						break

					if(current_facial)
						// Create a new facial hair entry with the SAME color as the current facial hair
						var/datum/customizer_entry/hair/facial/facial_entry = new()
						facial_entry.hair_color = current_facial.hair_color

						// Create the new facial hair with the new style but preserve color
						var/datum/bodypart_feature/hair/facial/new_facial = new()
						new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)

						// Apply all the color data from the entry
						facial_choice.customize_feature(new_facial, H, null, facial_entry)

						head.remove_bodypart_feature(current_facial)
						head.add_bodypart_feature(new_facial)
						H.update_hair()
						should_update = TRUE

		if("Accessory")
			var/datum/customizer_choice/bodypart_feature/accessory/accessory_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/accessory)
			var/list/valid_accessories = list("none")
			for(var/accessory_type in accessory_choice.sprite_accessories)
				var/datum/sprite_accessory/accessory/acc = new accessory_type()
				valid_accessories[acc.name] = accessory_type

			var/new_style = input(H, "Choose your accessory", "Accessory Styling") as null|anything in valid_accessories
			if(new_style)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing accessory if any
					for(var/datum/bodypart_feature/accessory/old_acc in head.bodypart_features)
						head.remove_bodypart_feature(old_acc)
						break

					// Add new accessory if not "none"
					if(new_style != "none")
						var/datum/bodypart_feature/accessory/accessory_feature = new()
						accessory_feature.set_accessory_type(valid_accessories[new_style], H.hair_color, H)
						head.add_bodypart_feature(accessory_feature)
					should_update = TRUE

		if("Face Detail")
			var/datum/customizer_choice/bodypart_feature/face_detail/face_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/face_detail)
			var/list/valid_details = list("none")
			for(var/detail_type in face_choice.sprite_accessories)
				var/datum/sprite_accessory/face_detail/detail = new detail_type()
				valid_details[detail.name] = detail_type

			var/new_detail = input(H, "Choose your face detail", "Face Detail") as null|anything in valid_details
			if(new_detail)
				var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
				if(head && head.bodypart_features)
					// Remove existing face detail if any
					for(var/datum/bodypart_feature/face_detail/old_detail in head.bodypart_features)
						head.remove_bodypart_feature(old_detail)
						break

					// Add new face detail if not "none"
					if(new_detail != "none")
						var/datum/bodypart_feature/face_detail/detail_feature = new()
						detail_feature.set_accessory_type(valid_details[new_detail], H.hair_color, H)
						head.add_bodypart_feature(detail_feature)
					should_update = TRUE

		if("Penis")
			var/list/valid_penis_types = list("none")
			for(var/penis_path in subtypesof(/datum/sprite_accessory/penis))
				var/datum/sprite_accessory/penis/penis = new penis_path()
				valid_penis_types[penis.name] = penis_path

			var/new_style = input(H, "Choose your penis type", "Penis Customization") as null|anything in valid_penis_types
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
					if(penis)
						penis.Remove(H)
						qdel(penis)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
					if(!penis)
						penis = new()
						penis.Insert(H, TRUE, FALSE)
					penis.accessory_type = valid_penis_types[new_style]
					var/datum/sprite_accessory/penis/penis_type = SPRITE_ACCESSORY(penis.accessory_type)
					penis.accessory_colors = penis_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("Testicles")
			var/list/valid_testicle_types = list("none")
			for(var/testicle_path in subtypesof(/datum/sprite_accessory/testicles))
				var/datum/sprite_accessory/testicles/testicles = new testicle_path()
				valid_testicle_types[testicles.name] = testicle_path

			var/new_style = input(H, "Choose your testicles type", "Testicles Customization") as null|anything in valid_testicle_types
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
					if(testicles)
						testicles.Remove(H)
						qdel(testicles)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
					if(!testicles)
						testicles = new()
						testicles.Insert(H, TRUE, FALSE)
					testicles.accessory_type = valid_testicle_types[new_style]
					var/datum/sprite_accessory/testicles/testicles_type = SPRITE_ACCESSORY(testicles.accessory_type)
					testicles_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("Breast Quantity")
			var/list/valid_breast_types = list("none")
			for(var/breast_path in subtypesof(/datum/sprite_accessory/breasts))
				var/datum/sprite_accessory/breasts/breasts = new breast_path()
				valid_breast_types[breasts.name] = breast_path

			var/new_style = input(H, "Choose your breast type", "Breast Customization") as null|anything in valid_breast_types

			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
					if(breasts)
						breasts.Remove(H)
						qdel(breasts)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
					if(!breasts)
						breasts = new()
						breasts.Insert(H, TRUE, FALSE)

					breasts.accessory_type = valid_breast_types[new_style]
					var/datum/sprite_accessory/breasts/breasts_type = SPRITE_ACCESSORY(breasts.accessory_type)
					breasts.accessory_colors = breasts_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("Vagina")
			var/list/valid_vagina_types = list("none", "human", "hairy", "spade", "furred", "gaping", "cloaca")
			var/new_style = input(H, "Choose your vagina type", "Vagina Customization") as null|anything in valid_vagina_types

			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
					if(vagina)
						vagina.Remove(H)
						qdel(vagina)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/vagina/vagina = H.getorganslot(ORGAN_SLOT_VAGINA)
					if(!vagina)
						vagina = new()
						vagina.Insert(H, TRUE, FALSE)
					vagina.accessory_type = valid_vagina_types[new_style]

					var/new_color = color_pick_sanitized(H, "Choose your vagina color", "Vagina Color", vagina.color || H.dna.features["mcolor"])
					if(new_color)
						vagina.color = sanitize_hexcolor(new_color, 6, TRUE)
					else
						var/datum/sprite_accessory/vagina/vag_type = SPRITE_ACCESSORY(vagina.accessory_type)
						vagina.color = vag_type.get_default_colors(color_key_source_list_from_carbon(H))

					H.update_body()
					should_update = TRUE

		if("Breast Size")
			var/list/breast_sizes = list("Flat", "Slight", "Small", "Moderate", "Large", "Generous", "Heavy", "Massive", "Heaping", "Obscene")
			var/new_size = input(H, "Choose your breast size", "Breast Size") as null|anything in breast_sizes
			if(new_size)
				var/obj/item/organ/breasts/breasts = H.getorganslot(ORGAN_SLOT_BREASTS)
				if(breasts)
					var/size_num
					switch(new_size)
						if("Flat")
							size_num = 0
						if("Slight")
							size_num = 1
						if("Small")
							size_num = 2
						if("Moderate")
							size_num = 3
						if("Large")
							size_num = 4
						if("Generous")
							size_num = 5
						if("Heavy")
							size_num = 6
						if("Massive")
							size_num = 7
						if("Heaping")
							size_num = 8
						if("Obscene")
							size_num = 9

					breasts.breast_size = size_num
					H.update_body()
					should_update = TRUE

		if("Penis Size")
			var/list/penis_sizes = list("small", "average", "large")
			var/new_size = input(H, "Choose your penis size", "Penis Size") as null|anything in penis_sizes
			if(new_size)
				var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
				if(penis)
					var/size_num
					switch(new_size)
						if("small")
							size_num = 1
						if("average")
							size_num = 2
						if("large")
							size_num = 3

					penis.penis_size = size_num
					H.update_body()
					should_update = TRUE

		if("Testicle Size")
			var/list/testicle_sizes = list("small", "average", "large")
			var/new_size = input(H, "Choose your testicle size", "Testicle Size") as null|anything in testicle_sizes
			if(new_size)
				var/obj/item/organ/testicles/testicles = H.getorganslot(ORGAN_SLOT_TESTICLES)
				if(testicles)
					var/size_num
					switch(new_size)
						if("small")
							size_num = 1
						if("average")
							size_num = 2
						if("large")
							size_num = 3

					testicles.ball_size = size_num
					H.update_body()
					should_update = TRUE

		if("Tail")
			var/list/valid_tails = list("none")
			for(var/tail_path in subtypesof(/datum/sprite_accessory/tail))
				var/datum/sprite_accessory/tail/tail = new tail_path()
				valid_tails[tail.name] = tail_path

			var/new_style = input(H, "Choose your tail", "Tail Customization") as null|anything in valid_tails
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(tail)
						tail.Remove(H)
						qdel(tail)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
					if(!tail)
						tail = new /obj/item/organ/tail/anthro()
						tail.Insert(H, TRUE, FALSE)
					tail.accessory_type = valid_tails[new_style]
					var/datum/sprite_accessory/tail/tail_type = SPRITE_ACCESSORY(tail.accessory_type)
					tail.accessory_colors = tail_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("Tail Color One")
			var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/new_color = color_pick_sanitized(H, "Choose your primary tail color", "Tail Color One", "#FFFFFF")
				if(new_color)
					tail.Remove(H)
					var/list/colors = list()
					if(tail.accessory_colors)
						colors = color_string_to_list(tail.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(colors)
					tail.Insert(H, TRUE, FALSE)
					H.dna.features["tail_color"] = colors[1]  // Update DNA features
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a tail!"))

		if("Tail Color Two")
			var/obj/item/organ/tail/tail = H.getorganslot(ORGAN_SLOT_TAIL)
			if(tail)
				var/new_color = color_pick_sanitized(H, "Choose your secondary tail color", "Tail Color Two", "#FFFFFF")
				if(new_color)
					tail.Remove(H)
					var/list/colors = list()
					if(tail.accessory_colors)
						colors = color_string_to_list(tail.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					tail.accessory_colors = color_list_to_string(colors)
					tail.Insert(H, TRUE, FALSE)
					H.dna.features["tail_color2"] = colors[2]  // Update DNA features
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a tail!"))
		if("Ears")
			var/list/valid_ears = list("none")
			for(var/ears_path in subtypesof(/datum/sprite_accessory/ears))
				var/datum/sprite_accessory/ears/ears = new ears_path()
				valid_ears[ears.name] = ears_path

			var/new_style = input(H, "Choose your ears", "Ears Customization") as null|anything in valid_ears
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
					if(ears)
						ears.Remove(H)
						qdel(ears)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
					if(!ears)
						ears = new /obj/item/organ/ears()
						ears.Insert(H, TRUE, FALSE)
					ears.accessory_type = valid_ears[new_style]
					var/datum/sprite_accessory/ears/ears_type = SPRITE_ACCESSORY(ears.accessory_type)
					ears.accessory_colors = ears_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("Ear Color One")
			var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/new_color = color_pick_sanitized(H, "Choose your primary ear color", "Ear Color One", "#FFFFFF")
				if(new_color)
					ears.Remove(H)
					var/list/colors = list()
					if(ears.accessory_colors)
						colors = color_string_to_list(ears.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(colors)
					ears.Insert(H, TRUE, FALSE)
					H.dna.features["ears_color"] = colors[1]  // Update DNA features
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have ears!"))

		if("Ear Color Two")
			var/obj/item/organ/ears/ears = H.getorganslot(ORGAN_SLOT_EARS)
			if(ears)
				var/new_color = color_pick_sanitized(H, "Choose your secondary ear color", "Ear Color Two", "#FFFFFF")
				if(new_color)
					ears.Remove(H)
					var/list/colors = list()
					if(ears.accessory_colors)
						colors = color_string_to_list(ears.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[2] = sanitize_hexcolor(new_color, 6, TRUE)
					ears.accessory_colors = color_list_to_string(colors)
					ears.Insert(H, TRUE, FALSE)
					H.dna.features["ears_color2"] = colors[2]  // Update DNA features
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have a ears!"))
				
		if("Horns")
			var/list/valid_horns = list("none")
			for(var/horns_path in subtypesof(/datum/sprite_accessory/horns))
				var/datum/sprite_accessory/horns/horns = new horns_path()
				valid_horns[horns.name] = horns_path

			var/new_style = input(H, "Choose your horns", "Horns Customization") as null|anything in valid_horns
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
					if(horns)
						horns.Remove(H)
						qdel(horns)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
					if(!horns)
						horns = new /obj/item/organ/horns()
						horns.Insert(H, TRUE, FALSE)
					horns.accessory_type = valid_horns[new_style]
					var/datum/sprite_accessory/horns/horns_type = SPRITE_ACCESSORY(horns.accessory_type)
					horns.accessory_colors = horns_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("Horn Color")
			var/obj/item/organ/horns/horns = H.getorganslot(ORGAN_SLOT_HORNS)
			if(horns)
				var/new_color = color_pick_sanitized(H, "Choose your primary ear color", "Ear Color One", "#FFFFFF")
				if(new_color)
					horns.Remove(H)
					var/list/colors = list()
					if(horns.accessory_colors)
						colors = color_string_to_list(horns.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					horns.accessory_colors = color_list_to_string(colors)
					horns.Insert(H, TRUE, FALSE)
					H.dna.features["horns_color"] = colors[1]  // Update DNA features
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have horns!"))

		if("Wings")
			var/list/valid_wings = list("none")
			for(var/wings_path in subtypesof(/datum/sprite_accessory/wings))
				var/datum/sprite_accessory/wings/wings = new wings_path()
				valid_wings[wings.name] = wings_path

			var/new_style = input(H, "Choose your wings", "Wings Customization") as null|anything in valid_wings
			if(new_style)
				if(new_style == "none")
					var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
					if(wings)
						wings.Remove(H)
						qdel(wings)
						H.update_body()
						should_update = TRUE
				else
					var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
					if(!wings)
						wings = new /obj/item/organ/wings()
						wings.Insert(H, TRUE, FALSE)
					wings.accessory_type = valid_wings[new_style]
					var/datum/sprite_accessory/wings/wings_type = SPRITE_ACCESSORY(wings.accessory_type)
					wings.accessory_colors = wings_type.get_default_colors(color_key_source_list_from_carbon(H))
					H.update_body()
					should_update = TRUE

		if("Wing Color")
			var/obj/item/organ/wings/wings = H.getorganslot(ORGAN_SLOT_WINGS)
			if(wings)
				var/new_color = color_pick_sanitized(H, "Choose your primary wing color", "Wing Color One", "#FFFFFF")
				if(new_color)
					wings.Remove(H)
					var/list/colors = list()
					if(wings.accessory_colors)
						colors = color_string_to_list(wings.accessory_colors)
					if(!length(colors))
						colors = list("#FFFFFF", "#FFFFFF") // Default colors if none set
					colors[1] = sanitize_hexcolor(new_color, 6, TRUE)
					wings.accessory_colors = color_list_to_string(colors)
					wings.Insert(H, TRUE, FALSE)
					H.dna.features["wings_color"] = colors[1]  // Update DNA features
					H.update_body()
					should_update = TRUE
			else
				to_chat(H, span_warning("You don't have wings!"))

	if(should_update)
		H.update_hair()
		H.update_body()
		H.update_body_parts()
