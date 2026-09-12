/obj/effect/proc_holder/spell/invoked/fleshcraft
	name = "Fleshcraft"
	desc = "Reshape flesh through divine craft."
	overlay_icon = 'icons/mob/actions/pestraspells.dmi'
	overlay_state = "fleshcraft"
	action_icon = 'icons/mob/actions/pestraspells.dmi'
	action_icon_state = "fleshcraft"
	clothes_req = FALSE
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 1
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/gore/flesh_eat_03.ogg'
	spell_tier = 1
	invocations = list("begins contorting with a sickening crack.")
	invocation_type = "emote"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 25
	recharge_time = 20 SECONDS
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	miracle = TRUE
	cost = 3
	cast_without_targets = FALSE

/obj/effect/proc_holder/spell/invoked/fleshcraft/cast(list/targets, mob/user)
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/caster = user

	if(!targets || !length(targets))
		to_chat(caster, span_warning("You need to choose flesh to reshape."))
		return FALSE

	if(!ishuman(targets[1]))
		to_chat(caster, span_warning("You need living human flesh to reshape."))
		return FALSE

	var/mob/living/carbon/human/target = targets[1]

	if(get_dist(caster, target) > 1)
		to_chat(caster, span_warning("They are too far away."))
		return FALSE

	if(!(target == user))
		var/consent = alert(target, "[user] offers a reshape. Accept?", "Fleshcraft", "Yes", "No")
		if(consent != "Yes" || QDELETED(target))
			to_chat(user, span_warning("The reshape was rejected."))
			revert_cast()
			return FALSE

	return perform_fleshcraft_transform(target, caster)

/proc/perform_fleshcraft_transform(mob/living/carbon/human/target, mob/living/carbon/human/caster)
	if(!target || !caster)
		return FALSE

	if(QDELETED(target) || QDELETED(caster))
		return FALSE

	if(!ishuman(target) || !ishuman(caster))
		return FALSE

	if(get_dist(caster, target) > 1)
		to_chat(caster, span_warning("They are too far away."))
		return FALSE

	var/list/choices = get_fleshcraft_transform_choices()
	var/chosen = input(caster, "Change what?", "Fleshcraft") as null|anything in choices

	if(!chosen)
		to_chat(caster, span_warning("You stop shaping the flesh."))
		return FALSE

	if(QDELETED(target) || QDELETED(caster))
		return FALSE

	if(get_dist(caster, target) > 1)
		to_chat(caster, span_warning("They are too far away."))
		return FALSE

	if(target == caster)
		caster.visible_message(span_notice("[caster]'s flesh begins to soften and shift."), span_notice("You begin reshaping your flesh..."))
	else
		caster.visible_message(span_notice("[caster] begins reshaping [target]'s flesh."), span_notice("You begin reshaping [target]'s flesh..."))
		to_chat(target, span_notice("Your flesh begins to crawl beneath your skin..."))

	if(!do_after(caster, 10 SECONDS, target = target))
		to_chat(caster, span_warning("Your fleshcraft is interrupted."))
		if(!QDELETED(target) && target != caster)
			to_chat(target, span_warning("The fleshcraft fails."))
		return FALSE

	if(QDELETED(target) || QDELETED(caster))
		return FALSE

	if(get_dist(caster, target) > 1)
		to_chat(caster, span_warning("[target] moved too far away."))
		to_chat(target, span_warning("The fleshcraft fails as you move too far away."))
		return FALSE

	return perform_fleshcraft_transform_choice(target, caster, chosen)

/proc/get_fleshcraft_transform_choices()
	return list(
		"reset appearance",
		"hairstyle",
		"facial hairstyle",
		"accessory",
		"face detail",
		"crest",
		"horns",
		"horn color",
		"ears",
		"ear color one",
		"ear color two",
		"tail",
		"tail color one",
		"tail color two",
		"tail feature",
		"tail feature color",
		"wings",
		"wing color one",
		"wing color two",
		"frills",
		"frill color",
		"antennas",
		"antenna color",
		"snout",
		"snout color",
		"head feature",
		"head feature color",
		"neck feature",
		"neck feature color",
		"back feature",
		"back feature color",
		"descriptors",
		"hair color",
		"facial hair color",
		"eye color",
		"skin color",
		"mutant color",
		"mutant color 2",
		"mutant color 3",
		"natural gradient",
		"natural gradient color",
		"dye gradient",
		"dye gradient color",
		"penis",
		"penis color",
		"penis color 2",
		"testicles",
		"testicles color",
		"breasts",
		"breasts color",
		"vagina",
		"vagina color",
		"breast size",
		"penis size",
		"testicle size"
	)

/proc/perform_fleshcraft_transform_choice(mob/living/carbon/human/H, mob/living/carbon/human/chooser, chosen)
	if(!H || !chooser || !chosen)
		return FALSE

	if(QDELETED(H) || QDELETED(chooser))
		return FALSE

	if(!ishuman(H) || !ishuman(chooser))
		return FALSE

	var/should_update = FALSE

	switch(chosen)
		if("reset appearance")
			should_update = fleshcraft_reset_appearance(H, chooser)

		if("hairstyle")
			should_update = fleshcraft_change_head_hair(H, chooser)

		if("hair color")
			should_update = fleshcraft_change_head_hair_color(H, chooser)

		if("facial hairstyle")
			should_update = fleshcraft_change_facial_hair(H, chooser)

		if("facial hair color")
			should_update = fleshcraft_change_facial_hair_color(H, chooser)

		if("eye color")
			should_update = fleshcraft_change_eye_color(H, chooser)

		if("skin color")
			should_update = fleshcraft_change_simple_color_feature(H, chooser, "skin_tone", "Choose skin color", "Skin Color")

		if("mutant color")
			should_update = fleshcraft_change_dna_color_feature(H, chooser, "mcolor", "Choose mutant color", "Mutant Color")

		if("mutant color 2")
			should_update = fleshcraft_change_dna_color_feature(H, chooser, "mcolor2", "Choose mutant color 2", "Mutant Color 2")

		if("mutant color 3")
			should_update = fleshcraft_change_dna_color_feature(H, chooser, "mcolor3", "Choose mutant color 3", "Mutant Color 3")

		if("natural gradient")
			should_update = fleshcraft_change_hair_gradient(H, chooser, TRUE)

		if("natural gradient color")
			should_update = fleshcraft_change_hair_gradient_color(H, chooser, TRUE)

		if("dye gradient")
			should_update = fleshcraft_change_hair_gradient(H, chooser, FALSE)

		if("dye gradient color")
			should_update = fleshcraft_change_hair_gradient_color(H, chooser, FALSE)

		if("accessory")
			should_update = fleshcraft_change_head_feature(H, chooser, /datum/customizer_choice/bodypart_feature/accessory, /datum/bodypart_feature/accessory, /datum/sprite_accessory/accessory, "Choose accessory", "Accessory Styling")

		if("face detail")
			should_update = fleshcraft_change_head_feature(H, chooser, /datum/customizer_choice/bodypart_feature/face_detail, /datum/bodypart_feature/face_detail, /datum/sprite_accessory/face_detail, "Choose face detail", "Face Detail")

		if("crest")
			should_update = fleshcraft_change_head_feature(H, chooser, /datum/customizer_choice/bodypart_feature/crest, /datum/bodypart_feature/crest, /datum/sprite_accessory/crests, "Choose crest", "Crest Styling")

		if("descriptors")
			should_update = fleshcraft_change_descriptor(H, chooser)

		if("horns")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_HORNS, /obj/item/organ/horns, /datum/sprite_accessory/horns, "Choose horns", "Horns Customization")

		if("horn color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_HORNS, "Choose horn color", "Horn Color", 1)

		if("ears")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_EARS, /obj/item/organ/ears, /datum/sprite_accessory/ears, "Choose ears", "Ears Customization")

		if("ear color one")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_EARS, "Choose primary ear color", "Ear Color One", 1, "ears_color")

		if("ear color two")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_EARS, "Choose secondary ear color", "Ear Color Two", 2, "ears_color2")

		if("tail")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_TAIL, /obj/item/organ/tail/anthro, /datum/sprite_accessory/tail, "Choose tail", "Tail Customization")

		if("tail color one")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_TAIL, "Choose primary tail color", "Tail Color One", 1, "tail_color")

		if("tail color two")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_TAIL, "Choose secondary tail color", "Tail Color Two", 2, "tail_color2")

		if("tail feature")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_TAIL_FEATURE, /obj/item/organ/tail_feature, /datum/sprite_accessory/tail_feature, "Choose tail feature", "Tail Feature Customization")

		if("tail feature color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_TAIL_FEATURE, "Choose tail feature color", "Tail Feature Color", 1)

		if("wings")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_WINGS, /obj/item/organ/wings, /datum/sprite_accessory/wings, "Choose wings", "Wings Customization")

		if("wing color one")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_WINGS, "Choose primary wing color", "Wing Color One", 1)

		if("wing color two")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_WINGS, "Choose secondary wing color", "Wing Color Two", 2)

		if("frills")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_FRILLS, /obj/item/organ/frills, /datum/sprite_accessory/frills, "Choose frills", "Frills Customization")

		if("frill color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_FRILLS, "Choose frill color", "Frill Color", 1)

		if("antennas")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_ANTENNAS, /obj/item/organ/antennas, /datum/sprite_accessory/antenna, "Choose antennas", "Antennas Customization")

		if("antenna color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_ANTENNAS, "Choose antenna color", "Antenna Color", 1)

		if("snout")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_SNOUT, /obj/item/organ/snout, /datum/sprite_accessory/snout, "Choose snout", "Snout Customization")

		if("snout color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_SNOUT, "Choose snout color", "Snout Color", 1)

		if("head feature")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_HEAD_FEATURE, /obj/item/organ/head_feature, /datum/sprite_accessory/head_feature, "Choose head feature", "Head Feature Customization")

		if("head feature color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_HEAD_FEATURE, "Choose head feature color", "Head Feature Color", 1)

		if("neck feature")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_NECK_FEATURE, /obj/item/organ/neck_feature, /datum/sprite_accessory/neck_feature, "Choose neck feature", "Neck Feature Customization")

		if("neck feature color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_NECK_FEATURE, "Choose neck feature color", "Neck Feature Color", 1)

		if("back feature")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_BACK_FEATURE, /obj/item/organ/back_feature, /datum/sprite_accessory/back_feature, "Choose back feature", "Back Feature Customization")

		if("back feature color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_BACK_FEATURE, "Choose back feature color", "Back Feature Color", 1)

		if("penis")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_PENIS, /obj/item/organ/penis, /datum/sprite_accessory/penis, "Choose penis type", "Penis Customization")

		if("penis color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_PENIS, "Choose primary penis color", "Penis Color", 1)

		if("penis color 2")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_PENIS, "Choose secondary penis color", "Penis Color 2", 2)

		if("penis size")
			should_update = fleshcraft_change_size(H, chooser, ORGAN_SLOT_PENIS, "Choose penis size", "Penis Size", "penis_size", list("small" = 1, "average" = 2, "large" = 3))

		if("testicles")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_TESTICLES, /obj/item/organ/testicles, /datum/sprite_accessory/testicles, "Choose testicles type", "Testicles Customization")

		if("testicles color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_TESTICLES, "Choose testicles color", "Testicles Color", 1)

		if("testicle size")
			should_update = fleshcraft_change_size(H, chooser, ORGAN_SLOT_TESTICLES, "Choose testicle size", "Testicle Size", "ball_size", list("small" = 1, "average" = 2, "large" = 3))

		if("breasts")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_BREASTS, /obj/item/organ/breasts, /datum/sprite_accessory/breasts, "Choose breast type", "Breast Customization")

		if("breasts color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_BREASTS, "Choose breasts color", "Breasts Color", 1)

		if("breast size")
			should_update = fleshcraft_change_size(H, chooser, ORGAN_SLOT_BREASTS, "Choose breast size", "Breast Size", "breast_size", list("Flat" = 0, "Slight" = 1, "Small" = 2, "Moderate" = 3, "Large" = 4, "Generous" = 5, "Heavy" = 6, "Massive" = 7, "Heaping" = 8, "Obscene" = 9))

		if("vagina")
			should_update = fleshcraft_change_accessory_organ(H, chooser, ORGAN_SLOT_VAGINA, /obj/item/organ/vagina, /datum/sprite_accessory/vagina, "Choose vagina type", "Vagina Customization")

		if("vagina color")
			should_update = fleshcraft_change_organ_color(H, chooser, ORGAN_SLOT_VAGINA, "Choose vagina color", "Vagina Color", 1)

	if(should_update)
		H.update_hair()
		H.update_body()
		H.update_body_parts()
		return TRUE

	return FALSE

/proc/fleshcraft_reset_appearance(mob/living/carbon/human/H, mob/living/carbon/human/chooser)
	if(!H.client || !H.client.prefs)
		to_chat(chooser, span_warning("They do not have character preferences saved."))
		return FALSE

	if(H.client.prefs.real_name != H.real_name)
		to_chat(chooser, span_warning("You can only reset someone to the appearance of the character they are currently playing."))
		return FALSE

	var/confirm = alert(chooser, "Reset [H]'s appearance to match their character preferences? This will reapply physical features, colors, and descriptors but will not change name, skills, or abilities.", "Reset Appearance", "Yes", "No")
	if(confirm != "Yes")
		return FALSE

	if(!H.client || !H.client.prefs)
		return FALSE

	if(H.client.prefs.real_name != H.real_name)
		to_chat(chooser, span_warning("You can only reset someone to the appearance of the character they are currently playing."))
		return FALSE

	var/original_name = H.real_name
	var/original_age = H.age

	H.client.prefs.copy_to(H, icon_updates = FALSE, roundstart_checks = FALSE, character_setup = TRUE)

	H.real_name = original_name
	H.name = original_name
	H.dna.real_name = original_name
	if(H.mind)
		H.mind.name = original_name
	H.age = original_age

	H.update_body()
	H.update_hair()
	H.update_body_parts(TRUE)

	to_chat(H, span_notice("Your flesh has been reset to match your character preferences."))
	if(H != chooser)
		to_chat(chooser, span_notice("[H]'s appearance has been reset."))
	return TRUE

/proc/fleshcraft_change_head_hair(mob/living/carbon/human/H, mob/living/carbon/human/chooser)
	var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
	var/list/valid_hairstyles = list()
	for(var/hair_type in hair_choice.sprite_accessories)
		var/datum/sprite_accessory/hair/head/hair = new hair_type()
		valid_hairstyles[hair.name] = hair_type

	var/new_style = input(chooser, "Choose hairstyle for [H]", "Hair Styling") as null|anything in valid_hairstyles
	if(!new_style)
		return FALSE

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head || !head.bodypart_features)
		return FALSE

	var/datum/bodypart_feature/hair/head/current_hair = null
	for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
		current_hair = hair_feature
		break

	if(!current_hair)
		return FALSE

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
	return TRUE

/proc/fleshcraft_change_head_hair_color(mob/living/carbon/human/H, mob/living/carbon/human/chooser)
	var/new_hair_color = color_pick_sanitized(chooser, "Choose hair color for [H]", "Hair Color", H.hair_color)
	if(!new_hair_color)
		return FALSE

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head || !head.bodypart_features)
		return FALSE

	var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
	var/datum/customizer_entry/hair/hair_entry = new()
	hair_entry.hair_color = sanitize_hexcolor(new_hair_color, 6, TRUE)

	var/datum/bodypart_feature/hair/head/current_hair = null
	for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
		current_hair = hair_feature
		break

	if(!current_hair)
		return FALSE

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
	return TRUE

/proc/fleshcraft_change_facial_hair(mob/living/carbon/human/H, mob/living/carbon/human/chooser)
	var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
	var/list/valid_facial_hairstyles = list()
	for(var/facial_type in facial_choice.sprite_accessories)
		var/datum/sprite_accessory/hair/facial/facial = new facial_type()
		valid_facial_hairstyles[facial.name] = facial_type

	var/new_style = input(chooser, "Choose facial hairstyle for [H]", "Hair Styling") as null|anything in valid_facial_hairstyles
	if(!new_style)
		return FALSE

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head || !head.bodypart_features)
		return FALSE

	var/datum/bodypart_feature/hair/facial/current_facial = null
	for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
		current_facial = facial_feature
		break

	if(!current_facial)
		return FALSE

	var/datum/customizer_entry/hair/facial/facial_entry = new()
	facial_entry.hair_color = current_facial.hair_color

	var/datum/bodypart_feature/hair/facial/new_facial = new()
	new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
	facial_choice.customize_feature(new_facial, H, null, facial_entry)

	head.remove_bodypart_feature(current_facial)
	head.add_bodypart_feature(new_facial)
	H.update_hair()
	return TRUE

/proc/fleshcraft_change_facial_hair_color(mob/living/carbon/human/H, mob/living/carbon/human/chooser)
	var/new_facial_hair_color = color_pick_sanitized(chooser, "Choose facial hair color for [H]", "Facial Hair Color", H.facial_hair_color)
	if(!new_facial_hair_color)
		return FALSE

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head || !head.bodypart_features)
		return FALSE

	var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
	var/datum/customizer_entry/hair/facial/facial_entry = new()

	var/datum/bodypart_feature/hair/facial/current_facial = null
	for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
		current_facial = facial_feature
		break

	if(!current_facial)
		return FALSE

	facial_entry.hair_color = sanitize_hexcolor(new_facial_hair_color, 6, TRUE)
	facial_entry.accessory_type = current_facial.accessory_type

	var/datum/bodypart_feature/hair/facial/new_facial = new()
	new_facial.set_accessory_type(current_facial.accessory_type, null, H)
	facial_choice.customize_feature(new_facial, H, null, facial_entry)

	H.facial_hair_color = facial_entry.hair_color
	H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
	head.remove_bodypart_feature(current_facial)
	head.add_bodypart_feature(new_facial)
	return TRUE

/proc/fleshcraft_change_eye_color(mob/living/carbon/human/H, mob/living/carbon/human/chooser)
	var/new_eye_color = color_pick_sanitized(chooser, "Choose eye color for [H]", "Eye Color", H.eye_color)
	if(!new_eye_color)
		return FALSE

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
	return TRUE

/proc/fleshcraft_change_simple_color_feature(mob/living/carbon/human/H, mob/living/carbon/human/chooser, var_name, prompt, title)
	var/current_color = H.vars[var_name]
	var/new_color = color_pick_sanitized(chooser, "[prompt] for [H]", title, current_color)
	if(!new_color)
		return FALSE

	H.vars[var_name] = new_color
	H.update_body()
	return TRUE

/proc/fleshcraft_change_dna_color_feature(mob/living/carbon/human/H, mob/living/carbon/human/chooser, feature_key, prompt, title)
	var/current_color = H.dna.features[feature_key] || "#FFFFFF"
	var/new_color = color_pick_sanitized(chooser, "[prompt] for [H]", title, current_color)
	if(!new_color)
		return FALSE

	H.dna.features[feature_key] = new_color
	H.update_body()
	return TRUE

/proc/fleshcraft_change_hair_gradient(mob/living/carbon/human/H, mob/living/carbon/human/chooser, natural = TRUE)
	var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
	var/list/valid_gradients = list()
	for(var/gradient_type in GLOB.hair_gradients)
		valid_gradients[gradient_type] = gradient_type

	var/new_style = input(chooser, "Choose [natural ? "natural" : "dye"] gradient for [H]", "Hair Gradient") as null|anything in valid_gradients
	if(!new_style)
		return FALSE

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head || !head.bodypart_features)
		return FALSE

	var/datum/bodypart_feature/hair/head/current_hair = null
	for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
		current_hair = hair_feature
		break

	if(!current_hair)
		return FALSE

	var/datum/customizer_entry/hair/hair_entry = new()
	hair_entry.hair_color = current_hair.hair_color
	hair_entry.natural_gradient = current_hair.natural_gradient
	hair_entry.natural_color = current_hair.natural_color
	hair_entry.dye_gradient = current_hair.hair_dye_gradient
	hair_entry.dye_color = current_hair.hair_dye_color
	hair_entry.accessory_type = current_hair.accessory_type

	if(natural)
		hair_entry.natural_gradient = valid_gradients[new_style]
	else
		hair_entry.dye_gradient = valid_gradients[new_style]

	var/datum/bodypart_feature/hair/head/new_hair = new()
	new_hair.set_accessory_type(current_hair.accessory_type, null, H)
	hair_choice.customize_feature(new_hair, H, null, hair_entry)

	head.remove_bodypart_feature(current_hair)
	head.add_bodypart_feature(new_hair)
	return TRUE

/proc/fleshcraft_change_hair_gradient_color(mob/living/carbon/human/H, mob/living/carbon/human/chooser, natural = TRUE)
	var/new_gradient_color = color_pick_sanitized(chooser, "Choose [natural ? "natural" : "dye"] gradient color for [H]", "[natural ? "Natural" : "Dye"] Gradient Color", H.hair_color)
	if(!new_gradient_color)
		return FALSE

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head || !head.bodypart_features)
		return FALSE

	var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
	var/datum/customizer_entry/hair/hair_entry = new()

	var/datum/bodypart_feature/hair/head/current_hair = null
	for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
		current_hair = hair_feature
		break

	if(!current_hair)
		return FALSE

	hair_entry.hair_color = current_hair.hair_color
	hair_entry.natural_gradient = current_hair.natural_gradient
	hair_entry.natural_color = current_hair.natural_color
	hair_entry.dye_gradient = current_hair.hair_dye_gradient
	hair_entry.dye_color = current_hair.hair_dye_color
	hair_entry.accessory_type = current_hair.accessory_type

	if(natural)
		hair_entry.natural_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)
	else
		hair_entry.dye_color = sanitize_hexcolor(new_gradient_color, 6, TRUE)

	var/datum/bodypart_feature/hair/head/new_hair = new()
	new_hair.set_accessory_type(current_hair.accessory_type, null, H)
	hair_choice.customize_feature(new_hair, H, null, hair_entry)

	head.remove_bodypart_feature(current_hair)
	head.add_bodypart_feature(new_hair)
	return TRUE

/proc/fleshcraft_change_head_feature(mob/living/carbon/human/H, mob/living/carbon/human/chooser, customizer_choice_path, feature_path, accessory_root, prompt, title)
	var/datum/customizer_choice/bodypart_feature/feature_choice = CUSTOMIZER_CHOICE(customizer_choice_path)
	var/list/valid_features = list("none")
	for(var/accessory_type in feature_choice.sprite_accessories)
		var/datum/sprite_accessory/A = new accessory_type()
		valid_features[A.name] = accessory_type

	var/new_style = input(chooser, "[prompt] for [H]", title) as null|anything in valid_features
	if(!new_style)
		return FALSE

	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(!head || !head.bodypart_features)
		return FALSE

	for(var/datum/bodypart_feature/old_feature in head.bodypart_features)
		if(istype(old_feature, feature_path))
			head.remove_bodypart_feature(old_feature)
			break

	if(new_style != "none")
		var/datum/bodypart_feature/new_feature = new feature_path()
		new_feature.set_accessory_type(valid_features[new_style], H.hair_color, H)
		head.add_bodypart_feature(new_feature)

	return TRUE

/proc/fleshcraft_change_descriptor(mob/living/carbon/human/H, mob/living/carbon/human/chooser)
	var/list/descriptor_categories = list()
	for(var/choice_type in typesof(/datum/descriptor_choice))
		if(is_abstract(choice_type))
			continue
		var/datum/descriptor_choice/choice = DESCRIPTOR_CHOICE(choice_type)
		descriptor_categories[choice.name] = choice_type

	var/chosen_category = input(chooser, "Which descriptor category for [H]?", "Descriptor Category") as null|anything in descriptor_categories
	if(!chosen_category)
		return FALSE

	var/datum/descriptor_choice/chosen_choice = DESCRIPTOR_CHOICE(descriptor_categories[chosen_category])
	if(!chosen_choice)
		return FALSE

	var/list/descriptor_options = list()
	for(var/desc_type in chosen_choice.descriptors)
		var/datum/mob_descriptor/desc = MOB_DESCRIPTOR(desc_type)
		descriptor_options[desc.name] = desc_type

	var/chosen_descriptor_name = input(chooser, "Choose [H]'s [chosen_category]", "[chosen_category] Selection") as null|anything in descriptor_options
	if(!chosen_descriptor_name)
		return FALSE

	var/new_descriptor_type = descriptor_options[chosen_descriptor_name]
	var/datum/mob_descriptor/new_desc = MOB_DESCRIPTOR(new_descriptor_type)
	if(H.mob_descriptors)
		for(var/old_desc_type in H.mob_descriptors)
			var/datum/mob_descriptor/old_desc = MOB_DESCRIPTOR(old_desc_type)
			if(old_desc.slot == new_desc.slot)
				H.remove_mob_descriptor(old_desc_type)
				break

	H.add_mob_descriptor(new_descriptor_type)
	to_chat(H, span_notice("Your [chosen_category] has been changed to [chosen_descriptor_name]."))
	if(H != chooser)
		to_chat(chooser, span_notice("[H]'s [chosen_category] has been changed to [chosen_descriptor_name]."))
	return TRUE

/proc/fleshcraft_change_accessory_organ(mob/living/carbon/human/H, mob/living/carbon/human/chooser, organ_slot, organ_path, accessory_root, prompt, title)
	var/list/valid_types = list("none")
	for(var/accessory_path in subtypesof(accessory_root))
		var/datum/sprite_accessory/A = new accessory_path()
		valid_types[A.name] = accessory_path

	var/new_style = input(chooser, "[prompt] for [H]", title) as null|anything in valid_types
	if(!new_style)
		return FALSE

	if(new_style == "none")
		var/obj/item/organ/O = H.getorganslot(organ_slot)
		if(O)
			O.Remove(H)
			qdel(O)
			H.update_body()
			return TRUE
		return FALSE

	var/obj/item/organ/O = H.getorganslot(organ_slot)
	if(!O)
		O = new organ_path()
		O.Insert(H, TRUE, FALSE)

	O.accessory_type = valid_types[new_style]
	O.build_colors_for_accessory(null)
	H.update_body()
	return TRUE

/proc/fleshcraft_change_organ_color(mob/living/carbon/human/H, mob/living/carbon/human/chooser, organ_slot, prompt, title, color_index = 1, dna_feature_key = null)
	var/obj/item/organ/O = H.getorganslot(organ_slot)
	if(!O)
		to_chat(chooser, span_warning("[H] does not have that organ."))
		return FALSE

	var/list/current_colors = list()
	if(O.accessory_colors)
		current_colors = color_string_to_list(O.accessory_colors)

	var/fallback = H.dna.features["mcolor"] || H.skin_tone || "#FFFFFF"
	while(length(current_colors) < color_index)
		current_colors += fallback

	var/new_color = color_pick_sanitized(chooser, "[prompt] for [H]", title, current_colors[color_index])
	if(!new_color)
		return FALSE

	O.Remove(H)
	current_colors[color_index] = sanitize_hexcolor(new_color, 6, TRUE)
	O.accessory_colors = color_list_to_string(current_colors)
	O.Insert(H, TRUE, FALSE)

	if(dna_feature_key)
		H.dna.features[dna_feature_key] = current_colors[color_index]

	H.update_body()
	return TRUE

/proc/fleshcraft_change_size(mob/living/carbon/human/H, mob/living/carbon/human/chooser, organ_slot, prompt, title, var_name, list/size_map)
	var/obj/item/organ/O = H.getorganslot(organ_slot)
	if(!O)
		to_chat(chooser, span_warning("[H] does not have that organ."))
		return FALSE

	var/new_size = input(chooser, "[prompt] for [H]", title) as null|anything in size_map
	if(!new_size)
		return FALSE

	O.vars[var_name] = size_map[new_size]
	H.update_body()
	return TRUE
