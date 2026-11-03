//wip wip wup

/datum/intent/style
	name = "style"
	desc = "Target the head or skull of someone to begin styling their hair."
	icon_state = "instyle"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/proc/perform_mirror_styling(mob/living/user, mob/living/carbon/human/H, atom/source)
	var/list/options = list("hairstyle", "facial hairstyle")
	var/chosen = input(user, "What would you like to style?", "Hair Styling") as null|anything in options
	if(!chosen)
		return

	switch(chosen)
		if("hairstyle")
			var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
			var/list/valid_hairstyles = list()
			for(var/hair_type in hair_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/head/hair = new hair_type()
				valid_hairstyles[hair.name] = hair_type

			var/new_style = input(user, "Choose their hairstyle", "Hair Styling") as null|anything in valid_hairstyles
			if(!new_style)
				return

			user.visible_message(
				span_notice("[user] begins styling [H]'s hair..."),
				span_notice("You begin styling [H == user ? "your" : "[H]'s"] hair...")
			)

			if(!do_after(user, 30 SECONDS, target = H))
				to_chat(user, span_warning("The styling was interrupted!"))
				return

			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head || !head.bodypart_features)
				return

			var/datum/bodypart_feature/hair/head/current_hair = null
			for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
				current_hair = hair_feature
				break
			if(!current_hair)
				return

			var/datum/customizer_entry/hair/hair_entry = new()
			hair_entry.hair_color = current_hair.hair_color

			// Preserve gradients and their colors.
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

			playsound(source, 'sound/items/flint.ogg', 50, TRUE)
			user.visible_message(
				span_notice("[user] finishes styling [H]'s hair."),
				span_notice("You finish styling [H == user ? "your" : "[H]'s"] hair.")
			)

		if("facial hairstyle")
			if(H.gender != MALE)
				to_chat(user, span_warning("[H == user ? "You don't" : "They don't"] have facial hair to style!"))
				return

			var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
			var/list/valid_facial_hairstyles = list()
			for(var/facial_type in facial_choice.sprite_accessories)
				var/datum/sprite_accessory/hair/facial/facial = new facial_type()
				valid_facial_hairstyles[facial.name] = facial_type

			var/new_style = input(user, "Choose their facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
			if(!new_style)
				return

			user.visible_message(
				span_notice("[user] begins styling [H]'s facial hair..."),
				span_notice("You begin styling [H == user ? "your" : "[H]'s"] facial hair...")
			)
			if(!do_after(user, 60 SECONDS, target = H))
				to_chat(user, span_warning("The styling was interrupted!"))
				return

			var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
			if(!head || !head.bodypart_features)
				return

			var/datum/bodypart_feature/hair/facial/current_facial = null
			for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
				current_facial = facial_feature
				break
			if(!current_facial)
				return

			var/datum/customizer_entry/hair/facial/facial_entry = new()
			facial_entry.hair_color = current_facial.hair_color
			facial_entry.accessory_type = current_facial.accessory_type

			var/datum/bodypart_feature/hair/facial/new_facial = new()
			new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
			facial_choice.customize_feature(new_facial, H, null, facial_entry)

			head.remove_bodypart_feature(current_facial)
			head.add_bodypart_feature(new_facial)
			H.update_hair()

			playsound(source, 'sound/items/flint.ogg', 50, TRUE)
			user.visible_message(
				span_notice("[user] finishes styling [H]'s facial hair."),
				span_notice("You finish styling [H == user ? "your" : "[H]'s"] facial hair.")
			)
	return TRUE

/obj/structure/mirror
	name = "mirror"
	desc = "Mirror, mirror, on the wall..."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "mirror"
	density = FALSE
	anchored = TRUE
	max_integrity = 200
	integrity_failure = 0.9
	break_sound = "glassbreak"
	attacked_sound = 'sound/combat/hits/onglass/glasshit.ogg'
	pixel_y = 32

/obj/structure/mirror/fancy
	icon_state = "fancymirror"
	pixel_y = 32

/obj/structure/mirror/Initialize(mapload)
	. = ..()
	if(icon_state == "mirror_broke" && !obj_broken)
		obj_break(null, mapload)

/obj/structure/mirror/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(obj_broken || !Adjacent(user))
		return

	if(!HAS_TRAIT(H, TRAIT_MIRROR_MAGIC) && !HAS_TRAIT(H, TRAIT_EDIT_DESCRIPTORS))
		to_chat(H, span_warning("You look into the mirror but see only your normal reflection."))
		if(HAS_TRAIT(user, TRAIT_BEAUTIFUL))
			H.add_stress(/datum/stressevent/beautiful)
			to_chat(H, span_smallgreen("I look great!"))
			// Apply Xylix buff when examining someone with the beautiful trait
			if(HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy))
				H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
				to_chat(H, span_info("My beauty brings a smile to my face, and fortune to my steps!"))
		if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
			to_chat(H, span_warning("Another reminder of my own horrid visage."))
			H.add_stress(/datum/stressevent/unseemly)
		return
	else
		perform_mirror_transform(H)

/obj/structure/mirror/attack_right(mob/user)
	if(type != /obj/structure/mirror && type != /obj/structure/mirror/fancy)
		return ..()
	if(obj_broken || !ishuman(user) || !user.Adjacent(src))
		return
	var/mob/living/carbon/human/H = user
	perform_mirror_styling(H, H, src)
	return

/obj/structure/mirror/get_mechanics_examine(mob/user)
	. = ..()
	if(type == /obj/structure/mirror || type == /obj/structure/mirror/fancy)
		. += span_info("Right-click the mirror to style your hair.")

/obj/structure/mirror/examine_status(mob/user)
	if(obj_broken)
		return list() // no message spam
	return ..()

/obj/structure/mirror/obj_break(damage_flag, mapload)
	if(!obj_broken && !(flags_1 & NODECONSTRUCT_1))
		icon_state = "[icon_state]1"
		if(!mapload)
			new /obj/item/natural/glass_shard (get_turf(src))
		obj_broken = TRUE
	..()

/obj/structure/mirror/deconstruct(disassembled = TRUE)
//	if(!(flags_1 & NODECONSTRUCT_1))
//		if(!disassembled)
//			new /obj/item/shard( src.loc )
	..()

/obj/structure/mirror/welder_act(mob/living/user, obj/item/I)
	..()
	if(user.used_intent.type == INTENT_HARM)
		return FALSE

	if(!obj_broken)
		return TRUE

	if(!I.tool_start_check(user, amount=0))
		return TRUE

	to_chat(user, span_notice("I begin repairing [src]..."))
	if(I.use_tool(src, user, 10, volume=50))
		to_chat(user, span_notice("I repair [src]."))
		obj_broken = 0
		icon_state = initial(icon_state)
		desc = initial(desc)

	return TRUE


/obj/structure/mirror/magic
	name = "magic mirror"
	desc = ""
	icon_state = "magic_mirror"
	var/list/choosable_races = list()

/obj/structure/mirror/magic/New()
	if(!choosable_races.len)
		for(var/speciestype in subtypesof(/datum/species))
			var/datum/species/S = speciestype
			if(initial(S.changesource_flags) & MIRROR_MAGIC)
				choosable_races += initial(S.id)
		choosable_races = sortList(choosable_races)
	..()

/obj/structure/mirror/magic/lesser/New()
	var/list/selectable_species = get_selectable_species()
	choosable_races = selectable_species.Copy()
	..()

/obj/structure/mirror/magic/badmin/New()
	for(var/speciestype in subtypesof(/datum/species))
		var/datum/species/S = speciestype
		if(initial(S.changesource_flags) & MIRROR_BADMIN)
			choosable_races += initial(S.id)
	..()

/obj/structure/mirror/magic/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/should_update = FALSE

	var/choice = input(user, "Something to change?", "Magical Grooming") as null|anything in list("name", "race", "gender", "hair", "eyes", "accessory", "face detail")

	if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return

	switch(choice)
		if("name")
			var/newname = copytext(sanitize_name(input(H, "Who are we again?", "Name change", H.name) as null|text),1,MAX_NAME_LEN)

			if(!newname)
				return
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			H.real_name = newname
			H.name = newname
			if(H.dna)
				H.dna.real_name = newname
			if(H.mind)
				H.mind.name = newname

		if("race")
			var/newrace
			var/racechoice = input(H, "What are we again?", "Race change") as null|anything in choosable_races
			newrace = GLOB.species_list[racechoice]

			if(!newrace)
				return
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			H.set_species(newrace, icon_update=0)

			if(H.dna.species.use_skintones)
				var/new_s_tone = input(user, "Choose your skin tone:", "Race change")	as null|anything in GLOB.skin_tones
				if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
					return

				if(new_s_tone)
					H.skin_tone = new_s_tone
					H.dna.update_ui_block(DNA_SKIN_TONE_BLOCK)

			if(MUTCOLORS in H.dna.species.species_traits)
				var/new_mutantcolor = input(user, "Choose your skin color:", "Race change","#"+H.dna.features["mcolor"]) as color|null
				if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
					return
				if(new_mutantcolor)
					var/temp_hsv = RGBtoHSV(new_mutantcolor)

					if(ReadHSV(temp_hsv)[3] >= ReadHSV("#7F7F7F")[3]) // mutantcolors must be bright
						H.dna.features["mcolor"] = sanitize_hexcolor(new_mutantcolor)

					else
						to_chat(H, span_notice("Invalid color. Your color is not bright enough."))

			H.update_body()
			H.update_hair()
			H.update_body_parts()

		if("hair")
			var/hairchoice = alert(H, "Hairstyle or hair color?", "Change Hair", "Style", "Color")
			if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return
			if(hairchoice == "Style") //So you just want to use a mirror then?
				..()
			else
				var/new_hair_color = input(H, "Choose your hair color", "Hair Color","#"+H.hair_color) as color|null
				if(!user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
					return
				if(new_hair_color)
					H.hair_color = sanitize_hexcolor(new_hair_color)
					H.facial_hair_color = H.hair_color
					H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
				if(H.gender == "male")
					var/new_face_color = input(H, "Choose your facial hair color", "Hair Color","#"+H.facial_hair_color) as color|null
					if(new_face_color)
						H.facial_hair_color = sanitize_hexcolor(new_face_color)
						H.dna.update_ui_block(DNA_FACIAL_HAIR_COLOR_BLOCK)
				H.update_hair()

		if("eyes")
			var/new_eye_color = color_pick_sanitized(user, "Choose your eye color", "Eye Color", H.eye_color)
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

		if("accessory")
			var/datum/customizer_choice/bodypart_feature/accessory/accessory_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/accessory)
			var/list/valid_accessories = list("none")
			for(var/accessory_type in accessory_choice.sprite_accessories)
				var/datum/sprite_accessory/accessory/acc = new accessory_type()
				valid_accessories[acc.name] = accessory_type

			var/new_style = input(user, "Choose your accessory", "Accessory Styling") as null|anything in valid_accessories
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

		if("face detail")
			var/datum/customizer_choice/bodypart_feature/face_detail/face_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/face_detail)
			var/list/valid_details = list("none")
			for(var/detail_type in face_choice.sprite_accessories)
				var/datum/sprite_accessory/face_detail/detail = new detail_type()
				valid_details[detail.name] = detail_type

			var/new_detail = input(user, "Choose your face detail", "Face Detail") as null|anything in valid_details
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

	if(should_update)
		H.update_body()

/obj/structure/mirror/magic/proc/curse(mob/living/user)
	return

/obj/item/handmirror
	name = "hand mirror"
	desc = "Mirror, mirror, in my hand, who's the fairest in the land?"
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "handmirror"
	possible_item_intents = list(/datum/intent/use, /datum/intent/style)
	grid_width = 32
	grid_height = 64
	dropshrink = 0.8

/obj/item/handmirror/attack(mob/living/M, mob/living/user)
	if(user.used_intent.type == /datum/intent/style)
		if(!ishuman(M))
			return TRUE
		if(user.zone_selected != BODY_ZONE_HEAD && user.zone_selected != BODY_ZONE_PRECISE_SKULL)
			return TRUE
		var/mob/living/carbon/human/H = M
		perform_mirror_styling(user, H, src)
		return TRUE
	return ..()

/obj/item/handmirror/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Use the 'STYLE' intent while targeting someone's head or skull to style their hair.")

/obj/item/handmirror/attack_self(mob/user)
	if(!ishuman(user))
		return

	var/mob/living/carbon/human/H = user

	if(HAS_TRAIT(H, TRAIT_MIRROR_MAGIC) || HAS_TRAIT(H, TRAIT_EDIT_DESCRIPTORS))
		to_chat(H, span_info("You tilt your jaw from side to side, concentrating on the glamoring magicks limning your form..."))
		if(do_after(H, 3 SECONDS))
			perform_mirror_transform(H)
		return

	if(HAS_TRAIT(user, TRAIT_BEAUTIFUL))
		H.add_stress(/datum/stressevent/beautiful)
		H.visible_message(span_notice("[H] admires [H.p_their()] reflection in [src]."), span_smallgreen("I look great!"))
	if(HAS_TRAIT(H, TRAIT_BEAUTIFUL_UNCANNY))
		if(prob(50) && !H.has_stress_event(/datum/stressevent/uncanny) && !H.has_stress_event(/datum/stressevent/beautiful))
			H.add_stress(/datum/stressevent/beautiful)
			H.visible_message(span_notice("[H] admires [H.p_their()] reflection in [src]."), span_smallgreen("I look great.. From this angle."))
		else
			if(!H.has_stress_event(/datum/stressevent/beautiful) && !H.has_stress_event(/datum/stressevent/uncanny))
				H.add_stress(/datum/stressevent/uncanny)
				H.visible_message(span_notice("[H] admires [H.p_their()] reflection in [src]."), span_warning("I look like a monster from this angle..."))
	if(HAS_TRAIT(H, TRAIT_UNSEEMLY))
		to_chat(H, span_warning("Another reminder of my own horrid visage."))
		H.add_stress(/datum/stressevent/unseemly)
	// Apply Xylix buff when examining someone with the beautiful trait
	if(HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy) && H.has_stress_event(/datum/stressevent/beautiful))
		H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
		to_chat(H, span_info("My beauty brings a smile to my face, and fortune to my steps!"))
	return
