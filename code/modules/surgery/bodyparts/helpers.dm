
/mob/living/proc/get_bodypart(zone)
	return

// Proposed change: Use check_zone instead of doing two loops.
/mob/living/carbon/get_bodypart(zone)
	RETURN_TYPE(/obj/item/bodypart)
	if(!zone)
		zone = BODY_ZONE_CHEST
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(bodypart.body_zone == zone)
			return bodypart
		for(var/subzone in bodypart.subtargets)
			if(subzone != zone)
				continue
			return bodypart

/mob/living/proc/get_bodypart_shallow(zone)
	return

/mob/living/carbon/get_bodypart_shallow(zone)
	RETURN_TYPE(/obj/item/bodypart)
	if(!zone)
		zone = BODY_ZONE_CHEST
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(bodypart.body_zone == zone)
			return bodypart

/mob/living/carbon/proc/get_bodypart_complex(list/zones)
	if(!length(zones))
		zones = list(BODY_ZONE_CHEST)
	var/list/targets = list()
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		if(bodypart.body_zone in zones)
			targets += bodypart
		else
			for(var/subzone in bodypart.subtargets)
				if(!(subzone in zones))
					continue
				targets += bodypart
				break
	if(length(targets))
		return pick(targets)

/mob/living/carbon/has_hand_for_held_index(i, extra_checks)
	if(!isnum(i) || i <= 0 || i > length(hand_bodyparts)) //Delinefortune: if they have no hands, this will return FALSE and nothing going to happen
		return FALSE

	var/obj/item/bodypart/L = hand_bodyparts[i]
	if(L && !L.disabled)
		if(extra_checks)
			if(!L.fingers || HAS_TRAIT(L, TRAIT_FINGERLESS))
				return FALSE
		return L
	return FALSE

/mob/proc/has_left_hand(check_disabled = TRUE)
	return TRUE

/mob/living/carbon/has_left_hand(check_disabled = TRUE)
	for(var/obj/item/bodypart/L in hand_bodyparts)
		if(L.held_index % 2)
			if(!check_disabled || !L.disabled)
				return TRUE
	return FALSE



/mob/proc/has_right_hand(check_disabled = TRUE)
	return TRUE

/mob/living/carbon/has_right_hand(check_disabled = TRUE)
	for(var/obj/item/bodypart/L in hand_bodyparts)
		if(!(L.held_index % 2))
			if(!check_disabled || !L.disabled)
				return TRUE
	return FALSE



//Limb numbers
/mob/proc/get_num_arms(check_disabled = TRUE)
	return 2

/mob/living/carbon/get_num_arms(check_disabled = TRUE)
	. = 0
	for(var/obj/item/bodypart/affecting as anything in bodyparts)
		if(affecting.body_part == ARM_RIGHT || affecting.body_part == ARM_LEFT)
			if(!check_disabled || !affecting.disabled)
				.++

//sometimes we want to ignore that we don't have the required amount of arms.
/mob/proc/get_arm_ignore()
	return 0

/mob/proc/get_num_legs(check_disabled = TRUE)
	return 2

/mob/living/carbon/get_num_legs(check_disabled = TRUE)
	. = 0
	for(var/obj/item/bodypart/affecting as anything in bodyparts)
		if(affecting.body_part & (LEG_RIGHT | LEG_LEFT))
			if(!check_disabled || !affecting.disabled)
				if((affecting.body_part & LEGS) == LEGS)
					. += 2
				else
					.++

//sometimes we want to ignore that we don't have the required amount of legs.
/mob/proc/get_leg_ignore()
	return FALSE


/mob/living/carbon/human/get_leg_ignore()
	if(movement_type & (FLYING | FLOATING))
		return TRUE
	return FALSE

/mob/living/proc/get_missing_limbs()
	return list()

/mob/living/carbon/get_missing_limbs()
	RETURN_TYPE(/list)
	var/list/full = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)

	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		full -= bodypart.body_zone
		for(var/subzone in bodypart.subtargets)
			full -= subzone

	return full

/mob/living/proc/get_disabled_limbs()
	return list()

/mob/living/carbon/get_disabled_limbs()
	var/list/full = list(
		BODY_ZONE_HEAD,
		BODY_ZONE_CHEST,
		BODY_ZONE_R_ARM,
		BODY_ZONE_L_ARM,
		BODY_ZONE_R_LEG,
		BODY_ZONE_L_LEG,
	)
	var/list/disabled = list()
	for(var/zone in full)
		var/obj/item/bodypart/affecting = get_bodypart(zone)
		if(affecting && affecting.disabled)
			disabled += zone
	return disabled

/mob/living/proc/get_taur_tail()
	RETURN_TYPE(/obj/item/bodypart/taur)
	return null

/mob/living/carbon/get_taur_tail()
	for(var/X in bodyparts)
		var/obj/item/bodypart/affecting = X
		if(affecting.body_zone == BODY_ZONE_TAUR)
			return affecting
	return null

//Helper for quickly creating a new limb - used by augment code in species.dm spec_attacked_by
/mob/living/carbon/proc/newBodyPart(zone, robotic, fixed_icon)
	var/obj/item/bodypart/L
	switch(zone)
		if(BODY_ZONE_L_ARM)
			L = SSwardrobe.provide_type(/obj/item/bodypart/l_arm)
		if(BODY_ZONE_R_ARM)
			L = SSwardrobe.provide_type(/obj/item/bodypart/r_arm)
		if(BODY_ZONE_HEAD)
			L = SSwardrobe.provide_type(/obj/item/bodypart/head)
		if(BODY_ZONE_L_LEG)
			L = SSwardrobe.provide_type(/obj/item/bodypart/l_leg)
		if(BODY_ZONE_R_LEG)
			L = SSwardrobe.provide_type(/obj/item/bodypart/r_leg)
		if(BODY_ZONE_CHEST)
			L = SSwardrobe.provide_type(/obj/item/bodypart/chest)
	if(L)
		L.update_limb(fixed_icon, src)
		if(robotic)
			L.change_bodypart_status(BODYPART_ROBOTIC)
	. = L

/mob/living/carbon/monkey/newBodyPart(zone, robotic, fixed_icon)
	var/obj/item/bodypart/L
	switch(zone)
		if(BODY_ZONE_L_ARM)
			L = SSwardrobe.provide_type(/obj/item/bodypart/l_arm/monkey)
		if(BODY_ZONE_R_ARM)
			L = SSwardrobe.provide_type(/obj/item/bodypart/r_arm/monkey)
		if(BODY_ZONE_HEAD)
			L = SSwardrobe.provide_type(/obj/item/bodypart/head/monkey)
		if(BODY_ZONE_L_LEG)
			L = SSwardrobe.provide_type(/obj/item/bodypart/l_leg/monkey)
		if(BODY_ZONE_R_LEG)
			L = SSwardrobe.provide_type(/obj/item/bodypart/r_leg/monkey)
		if(BODY_ZONE_CHEST)
			L = SSwardrobe.provide_type(/obj/item/bodypart/chest/monkey)
	if(L)
		L.update_limb(fixed_icon, src)
		if(robotic)
			L.change_bodypart_status(BODYPART_ROBOTIC)
	. = L

/mob/living/carbon/proc/Digitigrade_Leg_Swap(swap_back)
	var/body_plan_changed = FALSE
	for(var/X in bodyparts)
		var/obj/item/bodypart/O = X
		var/obj/item/bodypart/N
		if((!O.use_digitigrade && swap_back == FALSE) || (O.use_digitigrade && swap_back == TRUE))
			if(O.body_part == LEG_LEFT)
				if(swap_back == TRUE)
					N = new /obj/item/bodypart/l_leg
				else
					N = new /obj/item/bodypart/l_leg/digitigrade
			else if(O.body_part == LEG_RIGHT)
				if(swap_back == TRUE)
					N = new /obj/item/bodypart/r_leg
				else
					N = new /obj/item/bodypart/r_leg/digitigrade
		if(!N)
			continue
		body_plan_changed = TRUE
		O.drop_limb(1)
		qdel(O)
		N.attach_limb(src)
	if(body_plan_changed && ishuman(src))
		var/mob/living/carbon/human/H = src
		if(H.wear_pants)
			var/obj/item/clothing/under/U = H.wear_pants
			if(U.mutantrace_variation)
				if(swap_back)
					U.adjusted = NORMAL_STYLE
				else
					U.adjusted = DIGITIGRADE_STYLE
				H.update_inv_w_uniform()
		if(H.shoes && !swap_back)
			H.dropItemToGround(H.shoes)

/mob/living/carbon/proc/ensure_not_taur()
	var/needs_new_legs = FALSE
	for(var/X in bodyparts)
		var/obj/item/bodypart/O = X
		if(O.body_zone == BODY_ZONE_TAUR)
			O.drop_limb(1)
			qdel(O)
			needs_new_legs = TRUE

	if(needs_new_legs)
		var/obj/item/bodypart/N
		N = new /obj/item/bodypart/l_leg
		N.attach_limb(src)

		N = new /obj/item/bodypart/r_leg
		N.attach_limb(src)

	// make sure we unapply our clipmasks
	regenerate_icons()
	set_resting(FALSE)

/mob/living/carbon/proc/Taurize(taur_type = /obj/item/bodypart/taur/horse, color = "#ffffff")
	for(var/X in bodyparts)
		var/obj/item/bodypart/O = X
		// drop taur tails too
		if(O.body_part == LEG_LEFT || O.body_part == LEG_RIGHT || O.body_zone == BODY_ZONE_TAUR)
			O.drop_limb(1)
			qdel(O)
	
	var/obj/item/bodypart/taur/T = new taur_type()
	T.taur_color = color
	T.attach_limb(src)

	if(shoes)
		dropItemToGround(shoes)

	// make sure we apply our clipmasks
	regenerate_icons()
	set_resting(FALSE)
