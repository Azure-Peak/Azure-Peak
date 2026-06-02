/*
/proc/attempt_initiate_surgery(obj/item/I, mob/living/M, mob/user)
	if(!istype(M))
		return

	var/mob/living/carbon/C
	var/obj/item/bodypart/affecting
	var/selected_zone = user.zone_selected

	if(iscarbon(M))
		C = M
		affecting = C.get_bodypart(check_zone(selected_zone))

	var/datum/surgery/current_surgery

	for(var/datum/surgery/S in M.surgeries)
		if(S.location == selected_zone)
			current_surgery = S

	if(!current_surgery)
		var/list/all_surgeries = GLOB.surgeries_list.Copy()
		var/list/available_surgeries = list()

		for(var/datum/surgery/S in all_surgeries)
			if(!S.possible_locs.Find(selected_zone))
				continue
			if(affecting)
				if(!S.requires_bodypart)
					continue
				if(S.requires_bodypart_type && affecting.status != S.requires_bodypart_type)
					continue
				if(S.requires_real_bodypart && affecting.is_pseudopart)
					continue
			else if(C && S.requires_bodypart) //mob with no limb in surgery zone when we need a limb
				continue
			if(S.lying_required && (M.mobility_flags & MOBILITY_STAND))
				continue
			if(!S.can_start(user, M))
				continue
			for(var/path in S.target_mobtypes)
				if(istype(M, path))
					available_surgeries[S.name] = S
					break

		if(!available_surgeries.len)
			return

		var/P = input("Begin which procedure?", "Surgery", null, null) as null|anything in sortList(available_surgeries)
		if(P && user && user.Adjacent(M) && (I in user))
			var/datum/surgery/S = available_surgeries[P]

			for(var/datum/surgery/other in M.surgeries)
				if(other.location == selected_zone)
					return //during the input() another surgery was started at the same location.

			//we check that the surgery is still doable after the input() wait.
			if(C)
				affecting = C.get_bodypart(check_zone(selected_zone))
			if(affecting)
				if(!S.requires_bodypart)
					return
				if(S.requires_bodypart_type && affecting.status != S.requires_bodypart_type)
					return
			else if(C && S.requires_bodypart)
				return
			if(S.lying_required && (M.mobility_flags & MOBILITY_STAND))
				return
			if(!S.can_start(user, M))
				return

			if(S.ignore_clothes || get_location_accessible(M, selected_zone))
				var/datum/surgery/procedure = new S.type(M, selected_zone, affecting)
				user.visible_message(span_notice("[user] drapes [I] over [M]'s [parse_zone(selected_zone)] to prepare for surgery."), \
					span_notice("I drape [I] over [M]'s [parse_zone(selected_zone)] to prepare for \an [procedure.name]."))

				log_combat(user, M, "operated on", null, "(OPERATION TYPE: [procedure.name]) (TARGET AREA: [selected_zone])")
			else
				to_chat(user, span_warning("I need to expose [M]'s [parse_zone(selected_zone)] first!"))

	else if(!current_surgery.step_in_progress)
		attempt_cancel_surgery(current_surgery, I, M, user)

	return TRUE

/proc/attempt_cancel_surgery(datum/surgery/S, obj/item/I, mob/living/M, mob/user)
	var/selected_zone = user.zone_selected
	if(S.status == 1)
		M.surgeries -= S
		user.visible_message(span_notice("[user] removes [I] from [M]'s [parse_zone(selected_zone)]."), \
			span_notice("I remove [I] from [M]'s [parse_zone(selected_zone)]."))
		qdel(S)
	else if(S.can_cancel)
		var/required_tool_type = TOOL_CAUTERY
		var/obj/item/close_tool = user.get_inactive_held_item()
		var/is_robotic = S.requires_bodypart_type == BODYPART_ROBOTIC
		if(is_robotic)
			required_tool_type = TOOL_SCREWDRIVER
		if(close_tool?.tool_behaviour == required_tool_type || iscyborg(user))
			if (ishuman(M))
				var/mob/living/carbon/human/H = M
				H.bleed_rate = max( (H.bleed_rate - 3), 0)
			M.surgeries -= S
			user.visible_message(span_notice("[user] closes [M]'s [parse_zone(selected_zone)] with [close_tool] and removes [I]."), \
				span_notice("I close [M]'s [parse_zone(selected_zone)] with [close_tool] and remove [I]."))
			qdel(S)
		else
			to_chat(user, span_warning("I need to hold a [is_robotic ? "screwdriver" : "cautery"] in your inactive hand to stop [M]'s surgery!"))
*/

/proc/get_location_accessible(mob/victim, location = BODY_ZONE_CHEST, grabs = FALSE, skipundies = TRUE)
	var/covered_locations = NONE	//based on body_parts_covered
	if(iscarbon(victim))
		var/mob/living/carbon/carbon_victim = victim
		if(grabs)
			for(var/obj/item/grabbing/grab in carbon_victim.grabbedby)
				if(grab.sublimb_grabbed == location)
					return TRUE
		for(var/obj/item/equipped_item in carbon_victim.get_equipped_items(include_pockets = FALSE, include_beltslots = FALSE))
			if(zone2covered(location, equipped_item.body_parts_covered_dynamic) && equipped_item.surgery_cover)
				return FALSE
		if(ishuman(carbon_victim))
			var/mob/living/carbon/human/human_victim = carbon_victim
			if(!skipundies)
				if(human_victim.underwear)
					covered_locations |= GROIN
			if(zone2covered(location, covered_locations))
				return FALSE
	return TRUE

/proc/zone2covered(location, covered_locations)
	switch(location)
		if(BODY_ZONE_HEAD)
			if(covered_locations & HEAD)
				return TRUE
		if(BODY_ZONE_PRECISE_EARS)
			if(covered_locations & EARS)
				return TRUE
		if(BODY_ZONE_PRECISE_SKULL)
			if(covered_locations & HAIR)
				return TRUE
		if(BODY_ZONE_PRECISE_NOSE)
			if(covered_locations & NOSE)
				return TRUE
		if(BODY_ZONE_PRECISE_NECK)
			if(covered_locations & NECK)
				return TRUE
		if(BODY_ZONE_PRECISE_L_EYE)
			if(covered_locations & LEFT_EYE)
				return TRUE
		if(BODY_ZONE_PRECISE_R_EYE)
			if(covered_locations & RIGHT_EYE)
				return TRUE
		if(BODY_ZONE_PRECISE_MOUTH)
			if(covered_locations & MOUTH)
				return TRUE
		if(BODY_ZONE_CHEST)
			if(covered_locations & CHEST)
				return TRUE
		if(BODY_ZONE_PRECISE_STOMACH)
			if(covered_locations & VITALS)
				return TRUE
		if(BODY_ZONE_PRECISE_GROIN)
			if(covered_locations & GROIN)
				return TRUE
		if(BODY_ZONE_L_ARM)
			if(covered_locations & ARM_LEFT)
				return TRUE
		if(BODY_ZONE_R_ARM)
			if(covered_locations & ARM_RIGHT)
				return TRUE
		if(BODY_ZONE_L_LEG)
			if(covered_locations & LEG_LEFT)
				return TRUE
		if(BODY_ZONE_R_LEG)
			if(covered_locations & LEG_RIGHT)
				return TRUE
		if(BODY_ZONE_PRECISE_L_HAND)
			if(covered_locations & HAND_LEFT)
				return TRUE
		if(BODY_ZONE_PRECISE_R_HAND)
			if(covered_locations & HAND_RIGHT)
				return TRUE
		if(BODY_ZONE_PRECISE_L_FOOT)
			if(covered_locations & FOOT_LEFT)
				return TRUE
		if(BODY_ZONE_PRECISE_R_FOOT)
			if(covered_locations & FOOT_RIGHT)
				return TRUE

	return FALSE
