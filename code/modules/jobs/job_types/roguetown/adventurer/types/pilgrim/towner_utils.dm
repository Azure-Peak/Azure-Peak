////////
//LEVY//
////////

// CTRL + SHIFT + RMB -- Combat Callout!

/// Point at a target and shout a context-sensitive callout. Only works if there is more than one TRAIT_LEVY around you.
/mob/proc/callout_point(atom/A)
	if(!client || !mind)
		return

	if(istype(A, /obj/effect/temp_visual/point))
		return

	if(!linepoint(A))
		return

	if(world.time < mob_timers["contact_callout"] + 10 SECONDS)
		return

	var/nearby_levies = 0
	for(var/mob/living/carbon/human/H in view(8, src))
		if(H == src)
			continue

		if(HAS_TRAIT(H, TRAIT_LEVY))
			nearby_levies++

	if(!nearby_levies)
		return

	mob_timers["contact_callout"] = world.time

	var/contact_desc = A.name

	if(ishuman(A))
		var/mob/living/carbon/human/H = A

		var/list/trait_parts = list()
		var/stature_name

		var/list/d_list = H.get_mob_descriptors_unknown(FALSE, src)

		for(var/desc_type in d_list)
			var/datum/mob_descriptor/D = MOB_DESCRIPTOR(desc_type)

			if(D.slot == MOB_DESCRIPTOR_SLOT_STATURE)
				stature_name = D.name

				if(findtext(stature_name, "/"))
					var/list/split = splittext(stature_name, "/")

					if(length(split) >= 2)
						stature_name = (H.gender == FEMALE) ? split[2] : split[1]

			else if(D.slot == MOB_DESCRIPTOR_SLOT_TRAIT)
				trait_parts += D.name

		var/list/final_parts = list()

		for(var/trait_name in trait_parts)
			final_parts += trait_name

		if(stature_name)
			final_parts += stature_name

		if(H.stat != CONSCIOUS)
			final_parts += "fallen"

		contact_desc = length(final_parts) ? jointext(final_parts, " ") : "someone"

	var/dist = get_dist(src, A)
	var/dir_text = dir2text(get_dir(src, A))

	var/msg

	// Valuable loot
	if(istype(A, /obj/item/rogueore/gold) || istype(A, /obj/item/rogueore/silver) || istype(A, /obj/item/roguegem))
		msg = "Shiny! [dist] [dist == 1 ? "pace" : "paces"] [dir_text]!"

	// Living targets
	else if(ismob(A))
		var/zone_name = lowertext(parse_zone(zone_selected))

		if(cmode)
			var/list/aggressive = list(
				"[capitalize(contact_desc)]! Get 'em!",
				"[capitalize(contact_desc)]! On 'em!",
				"[capitalize(contact_desc)]! Bring 'em down!",
				"[capitalize(contact_desc)]! There!",
				"[capitalize(contact_desc)]! Kill the bastard!",
				"[capitalize(contact_desc)]! Flank 'em!",
			)

			msg = pick(aggressive)

			if(zone_name)
				msg += " Go for the [uppertext(zone_name)]!"

		else
			if(isliving(A))
				var/mob/living/L = A

				if(L.stat != CONSCIOUS)
					if(L.resting)
						msg = "[capitalize(contact_desc)], DOWN and OUT, [dist] [dist == 1 ? "pace" : "paces"] [dir_text]!"
				else if(L.resting)
					msg = "[capitalize(contact_desc)], DOWN, [dist] [dist == 1 ? "pace" : "paces"] [dir_text]!"
				else
					msg = "[capitalize(contact_desc)], [dist] [dist == 1 ? "pace" : "paces"] [dir_text]!"

	// Ground
	else if(isturf(A))
		var/turf/T = A

		if(cmode)
			msg = "Move there! [dist] [dist == 1 ? "pace" : "paces"] [dir_text]!"
		else
			msg = "[capitalize(T.name)], [dist] [dist == 1 ? "pace" : "paces"] [dir_text]!"

	// Objects
	else
		var/object_name = capitalize(A.name)

		if(cmode)
			msg = "[object_name]! Break that! [dist] [dist == 1 ? "pace" : "paces"] [dir_text]!"
		else
			msg = "[object_name], [dist] [dist == 1 ? "pace" : "paces"] [dir_text]!"

	if(msg)
		say_verb(msg)
