/obj/item/clothing
	name = "clothing"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT | UNIQUE_RENAME
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	///What level of bright light protection item has.
	var/flash_protect = FLASH_PROTECTION_NONE
	var/tint = 0				//Sets the item's level of visual impairment tint, normally set to the same as flash_protect
	var/up = 0					//but separated to allow items to protect but not impair vision, like space helmets
	var/visor_flags = 0			//flags that are added/removed when an item is adjusted up/down
	var/visor_flags_inv = 0		//same as visor_flags, but for flags_inv
	var/visor_flags_cover = 0	//same as above, but for flags_cover
//what to toggle when toggled with weldingvisortoggle()
	var/visor_vars_to_toggle = VISOR_FLASHPROTECT | VISOR_TINT | VISOR_VISIONFLAGS | VISOR_DARKNESSVIEW | VISOR_INVISVIEW
	lefthand_file = 'icons/mob/inhands/clothing_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/clothing_righthand.dmi'
	var/alt_desc = null
	var/toggle_message = null
	var/alt_toggle_message = null
	var/active_sound = null
	var/toggle_cooldown = null
	var/cooldown = 0

	var/emote_environment = -1
	var/prevent_crits = PREVENT_CRITS_MOST
	var/clothing_flags = NONE
	var/stack_fovs = FALSE

	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1
	fiber_salvage = TRUE

	var/toggle_icon_state = TRUE //appends _t to our icon state when toggled

	//Var modification - PLEASE be careful with this I know who you are and where you live
	var/list/user_vars_to_edit //VARNAME = VARVALUE eg: "name" = "butts"
	var/list/user_vars_remembered //Auto built by the above + dropped() + equipped()

	var/pocket_storage_component_path

	//These allow head/mask items to dynamically alter the user's hair
	// and facial hair, checking hair_extensions.dmi and facialhair_extensions.dmi
	// for a state matching hair_state+dynamic_hair_suffix
	// THESE OVERRIDE THE HIDEHAIR FLAGS
	var/dynamic_hair_suffix = ""//head > mask for head hair
	var/dynamic_fhair_suffix = ""//mask > head for facial hair
	edelay_type = 0
	var/list/allowed_sex = list(MALE,FEMALE)
	var/list/allowed_race = CLOTHED_RACES_TYPES
	var/immune_to_genderswap = FALSE
	var/armor_class = ARMOR_CLASS_NONE

	sellprice = 1
	var/naledicolor = FALSE
	var/chunkcolor = "#5e5e5e"

/obj/item
	var/blocking_behavior
	var/wetness = 0
	var/block2add
	var/detail_tag
	var/altdetail_tag
	var/detail_color
	var/altdetail_color
	var/boobed_detail = TRUE
	var/sleeved_detail = TRUE
	var/list/original_armor //For restoring broken armor

/obj/item/clothing/New()
	..()

/obj/item/clothing/examine(mob/user)
	. = ..()
	if(torn_sleeve_number)
		if(torn_sleeve_number == 1)
			. += span_notice("It has one torn sleeve.")
		else
			. += span_notice("Both its sleeves have been torn!")

	if(cold_protection)
		. += span_info("It looks like it will protect me from the <b>cold</b>.")
	if(heat_protection)
		. += span_info("It looks like it will protect me from the <b>heat</b>.")

/obj/item/proc/get_detail_tag() //this is for extra layers on clothes
	return detail_tag

/obj/item/proc/get_altdetail_tag() //this is for extra layers on clothes
	return altdetail_tag

/obj/item/proc/get_detail_color() //this is for extra layers on clothes
	return detail_color

/obj/item/proc/get_altdetail_color() //this is for extra layers on clothes
	return altdetail_color

/obj/item/clothing/ShiftRightClick(mob/user, params)
	..()
	var/mob/living/L = user
	var/altheld //Is the user pressing alt?
	var/list/modifiers = params2list(params)
	if(modifiers["alt"])
		altheld = TRUE
	if(!isliving(user))
		return
	if(nodismemsleeves)
		return
	if(altheld)
		if(user.zone_selected == l_sleeve_zone)
			if(l_sleeve_status == SLEEVE_ROLLED)
				l_sleeve_status = SLEEVE_NORMAL
				if(l_sleeve_zone == BODY_ZONE_L_ARM)
					body_parts_covered |= ARM_LEFT
				if(l_sleeve_zone == BODY_ZONE_L_LEG)
					body_parts_covered |= LEG_LEFT
			else
				if(l_sleeve_zone == BODY_ZONE_L_ARM)
					body_parts_covered &= ~ARM_LEFT
				if(l_sleeve_zone == BODY_ZONE_L_LEG)
					body_parts_covered &= ~LEG_LEFT
				l_sleeve_status = SLEEVE_ROLLED
		else if(user.zone_selected == r_sleeve_zone)
			if(r_sleeve_status == SLEEVE_ROLLED)
				if(r_sleeve_zone == BODY_ZONE_R_ARM)
					body_parts_covered |= ARM_RIGHT
				if(r_sleeve_zone == BODY_ZONE_R_LEG)
					body_parts_covered |= LEG_RIGHT
				r_sleeve_status = SLEEVE_NORMAL
			else
				if(r_sleeve_zone == BODY_ZONE_R_ARM)
					body_parts_covered &= ~ARM_RIGHT
				if(r_sleeve_zone == BODY_ZONE_R_LEG)
					body_parts_covered &= ~LEG_RIGHT
				r_sleeve_status = SLEEVE_ROLLED
	else
		if(user.zone_selected == r_sleeve_zone)
			if(r_sleeve_status == SLEEVE_NOMOD)
				return
			if(r_sleeve_status == SLEEVE_TORN)
				to_chat(user, span_info("It's torn away."))
				return
			if(!do_after(user, 20, target = user))
				return
			if(prob(L.STASTR * 8))
				torn_sleeve_number += 1
				r_sleeve_status = SLEEVE_TORN
				user.visible_message(span_notice("[user] tears [src]."))
				playsound(src, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				if(r_sleeve_zone == BODY_ZONE_R_ARM)
					body_parts_covered &= ~ARM_RIGHT
				if(r_sleeve_zone == BODY_ZONE_R_LEG)
					body_parts_covered &= ~LEG_RIGHT
				var/obj/item/Sr = new salvage_result(get_turf(src))
				Sr.color = color
				user.put_in_hands(Sr)
			else
				user.visible_message(span_warning("[user] tries and fails to tear [src]."), span_warning("You try and fail to tear [src]."))
				return
		if(user.zone_selected == l_sleeve_zone)
			if(l_sleeve_status == SLEEVE_NOMOD)
				return
			if(l_sleeve_status == SLEEVE_TORN)
				to_chat(user, span_info("It's torn away."))
				return
			if(!do_after(user, 20, target = user))
				return
			if(prob(L.STASTR * 8))
				torn_sleeve_number += 1
				l_sleeve_status = SLEEVE_TORN
				user.visible_message(span_notice("[user] tears [src]."))
				playsound(src, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				if(l_sleeve_zone == BODY_ZONE_L_ARM)
					body_parts_covered &= ~ARM_LEFT
				if(l_sleeve_zone == BODY_ZONE_L_LEG)
					body_parts_covered &= ~LEG_LEFT
				var/obj/item/Sr = new salvage_result(get_turf(src))
				Sr.color = color
				user.put_in_hands(Sr)
			else
				user.visible_message(span_warning("[user] tries and fails to tear [src]."), span_warning("You try and fail to tear [src]."))
				return
	if(loc == L)
		L.regenerate_clothes()


/obj/item/clothing/mob_can_equip(mob/M, mob/equipper, slot, disable_warning = 0)
	. = ..()
	if(!.)
		return FALSE
	var/list/allowed_sexes = list()
	if(length(allowed_sex))
		allowed_sexes |= allowed_sex
	var/mob/living/carbon/human/H
	if(ishuman(M))
		H = M
		if(!immune_to_genderswap && H.dna?.species?.gender_swapping)
			if(MALE in allowed_sex)
				allowed_sexes -= MALE
				allowed_sexes += FEMALE
			if(FEMALE in allowed_sex)
				allowed_sexes -= FEMALE
				allowed_sexes += MALE
	if(slot_flags & slotdefine2slotbit(slot))
		if(!length(allowed_sexes) || (M.gender in allowed_sex))
			if(length(allowed_race) && H)
				if(H.dna.species.type in allowed_race)
					return TRUE
				return FALSE
			return TRUE
		return FALSE

/obj/item/clothing/Initialize()
	if(CHECK_BITFIELD(clothing_flags, VOICEBOX_TOGGLABLE))
		actions_types += /datum/action/item_action/toggle_voice_box
	. = ..()
	if(ispath(pocket_storage_component_path))
		LoadComponent(pocket_storage_component_path)

/obj/item/clothing/MouseDrop(atom/over_object)
	. = ..()
	var/mob/M = usr

	if(!M.incapacitated() && loc == M && istype(over_object, /atom/movable/screen/inventory/hand))
		var/atom/movable/screen/inventory/hand/H = over_object
		if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
			add_fingerprint(usr)

/obj/item/reagent_containers/food/snacks/clothing
	name = "temporary moth clothing snack item"
	desc = ""
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	tastes = list("dust" = 1, "lint" = 1)
	foodtype = CLOTH

/obj/item/clothing/attack(mob/living/M, mob/living/user, def_zone)
	if(user.used_intent.type != INTENT_HARM && ismoth(M))
		var/obj/item/reagent_containers/food/snacks/clothing/clothing_as_food = new
		clothing_as_food.name = name
		if(clothing_as_food.attack(M, user, def_zone))
			take_damage(15, sound_effect=FALSE)
		qdel(clothing_as_food)
	else if(M.on_fire)
		if(user == M)
			return
		user.changeNext_move(CLICK_CD_MELEE)
		M.visible_message(span_warning("[user] pats out the flames on [M] with [src]!"))
		M.adjust_fire_stacks(-2, /datum/status_effect/fire_handler/fire_stacks/divine)
		M.adjust_fire_stacks(-2)
		M.adjust_fire_stacks(-2, /datum/status_effect/fire_handler/fire_stacks/sunder)
		M.adjust_fire_stacks(-2, /datum/status_effect/fire_handler/fire_stacks/sunder/blessed)
		take_damage(10, BURN, "fire")
	else
		return ..()


/*	if(damaged_clothes && istype(W, /obj/item/stack/sheet/cloth))
		var/obj/item/stack/sheet/cloth/C = W
		C.use(1)
		update_clothes_damaged_state(FALSE)
		obj_integrity = max_integrity
		to_chat(user, span_notice("I fix the damage on [src] with [C]."))
		return 1*/
	return ..()

/obj/item/clothing/Destroy()
	user_vars_remembered = null //Oh god somebody put REFERENCES in here? not to worry, we'll clean it up
	return ..()

/obj/item/clothing/dropped(mob/user)
	..()
	if(!istype(user))
		return
	if(LAZYLEN(user_vars_remembered))
		for(var/variable in user_vars_remembered)
			if(variable in user.vars)
				if(user.vars[variable] == user_vars_to_edit[variable]) //Is it still what we set it to? (if not we best not change it)
					user.vars[variable] = user_vars_remembered[variable]
		user_vars_remembered = initial(user_vars_remembered) // Effectively this sets it to null.

/obj/item/clothing/equipped(mob/user, slot)
	..()
	if (!istype(user))
		return
	if(slot_flags & slotdefine2slotbit(slot)) //Was equipped to a valid slot for this item?
		if (LAZYLEN(user_vars_to_edit))
			for(var/variable in user_vars_to_edit)
				if(variable in user.vars)
					LAZYSET(user_vars_remembered, variable, user.vars[variable])
					user.vv_edit_var(variable, user_vars_to_edit[variable])

/obj/item/clothing/examine(mob/user)
	. = ..()
//	switch (max_heat_protection_temperature)
//		if (400 to 1000)
/*			. += "[src] offers the wearer limited protection from fire."
		if (1001 to 1600)
			. += "[src] offers the wearer some protection from fire."
		if (1601 to 35000)
			. += "[src] offers the wearer robust protection from fire."
	if(damaged_clothes)
		. += span_warning("It looks damaged!")
	var/datum/component/storage/pockets = GetComponent(/datum/component/storage)
	if(pockets)
		var/list/how_cool_are_your_threads = list("<span class='notice'>")
		if(pockets.attack_hand_interact)
			how_cool_are_your_threads += "[src]'s storage opens when clicked.\n"
		else
			how_cool_are_your_threads += "[src]'s storage opens when dragged to myself.\n"
		if (pockets.can_hold?.len) // If pocket type can hold anything, vs only specific items
			how_cool_are_your_threads += "[src] can store [pockets.max_items] <a href='?src=[REF(src)];show_valid_pocket_items=1'>item\s</a>.\n"
		else
			how_cool_are_your_threads += "[src] can store [pockets.max_items] item\s that are [weightclass2text(pockets.max_w_class)] or smaller.\n"
		if(pockets.quickdraw)
			how_cool_are_your_threads += "You can quickly remove an item from [src] using Alt-Click.\n"
		if(pockets.silent)
			how_cool_are_your_threads += "Adding or removing items from [src] makes no noise.\n"
		how_cool_are_your_threads += "</span>"
		. += how_cool_are_your_threads.Join()
*/

/obj/item/clothing/obj_break(damage_flag)
	original_armor = armor
	var/list/armorlist = armor.getList()
	for(var/x in armorlist)
		if(armorlist[x] > 0)
			armorlist[x] = 0
	..()

/obj/item/clothing/obj_fix(mob/user, full_repair = TRUE)
	..()
	armor = original_armor

/*
SEE_SELF  // can see self, no matter what
SEE_MOBS  // can see all mobs, no matter what
SEE_OBJS  // can see all objs, no matter what
SEE_TURFS // can see all turfs (and areas), no matter what
SEE_PIXELS// if an object is located on an unlit area, but some of its pixels are
          // in a lit area (via pixel_x,y or smooth movement), can see those pixels
BLIND     // can't see anything
*/

/proc/generate_female_clothing(index,t_color,icon,type)
	var/icon/female_clothing_icon	= icon("icon"=icon, "icon_state"=t_color)
	var/icon/female_s				= icon("icon"='icons/mob/clothing/under/masking_helpers.dmi', "icon_state"="[(type == FEMALE_UNIFORM_FULL) ? "female_full" : "female_top"]")
	female_clothing_icon.Blend(female_s, ICON_MULTIPLY)
	female_clothing_icon 			= fcopy_rsc(female_clothing_icon)
	GLOB.female_clothing_icons[index] = female_clothing_icon

/proc/generate_dismembered_clothing(index, t_color, icon, sleeveindex, sleevetype)

	if(sleevetype)
		var/icon/dismembered		= icon("icon"=icon, "icon_state"=t_color)
		var/icon/r_mask				= icon("icon"='icons/roguetown/clothing/onmob/helpers/dismemberment.dmi', "icon_state"="r_[sleevetype]")
		var/icon/l_mask				= icon("icon"='icons/roguetown/clothing/onmob/helpers/dismemberment.dmi', "icon_state"="l_[sleevetype]")
		switch(sleeveindex)
			if(1)
				dismembered.Blend(r_mask, ICON_MULTIPLY)
				dismembered.Blend(l_mask, ICON_MULTIPLY)
			if(2)
				dismembered.Blend(l_mask, ICON_MULTIPLY)
			if(3)
				dismembered.Blend(r_mask, ICON_MULTIPLY)
		dismembered 			= fcopy_rsc(dismembered)

		GLOB.dismembered_clothing_icons[index] = dismembered

/obj/item/clothing/under/verb/toggle()
	set name = "Adjust Suit Sensors"
	set hidden = 1
	set src in usr
	if(!usr.client.holder)
		return
	var/mob/M = usr
	if (istype(M, /mob/dead/))
		return
	if (!can_use(M))
		return
	if(src.has_sensor == LOCKED_SENSORS)
		to_chat(usr, "The controls are locked.")
		return 0
	if(src.has_sensor == BROKEN_SENSORS)
		to_chat(usr, "The sensors have shorted out!")
		return 0
	if(src.has_sensor <= NO_SENSORS)
		to_chat(usr, "This suit does not have any sensors.")
		return 0

	var/list/modes = list("Off", "Binary vitals", "Exact vitals", "Tracking beacon")
	var/switchMode = input("Select a sensor mode:", "Suit Sensor Mode", modes[sensor_mode + 1]) in modes
	if(get_dist(usr, src) > 1)
		to_chat(usr, span_warning("I have moved too far away!"))
		return
	sensor_mode = modes.Find(switchMode) - 1

	if (src.loc == usr)
		switch(sensor_mode)
			if(0)
				to_chat(usr, span_notice("I disable my suit's remote sensing equipment."))
			if(1)
				to_chat(usr, span_notice("My suit will now only report whether you are alive or dead."))
			if(2)
				to_chat(usr, span_notice("My suit will now only report my exact vital lifesigns."))
			if(3)
				to_chat(usr, span_notice("My suit will now report my exact vital lifesigns as well as my coordinate position."))

/obj/item/clothing/under/AltClick(mob/user)
	if(..())
		return 1

	if(!istype(user) || !user.canUseTopic(src, BE_CLOSE, ismonkey(user)))
		return
	else
		if(attached_accessory)
			remove_accessory(user)
		else
			rolldown()

/obj/item/clothing/under/verb/jumpsuit_adjust()
	set name = "Adjust Jumpsuit Style"
	set category = null
	set src in usr
	rolldown()

/obj/item/clothing/under/proc/rolldown()
	if(!can_use(usr))
		return
	if(!can_adjust)
		to_chat(usr, span_warning("I cannot wear this suit any differently!"))
		return
	if(toggle_jumpsuit_adjust())
		to_chat(usr, span_notice("I adjust the suit to wear it more casually."))
	else
		to_chat(usr, span_notice("I adjust the suit back to normal."))
	if(ishuman(usr))
		var/mob/living/carbon/human/H = usr
		H.update_inv_w_uniform()
		H.update_body()

/obj/item/clothing/under/proc/toggle_jumpsuit_adjust()
	if(adjusted == DIGITIGRADE_STYLE)
		return
	adjusted = !adjusted
	if(adjusted)
		if(fitted != FEMALE_UNIFORM_TOP)
			fitted = NO_FEMALE_UNIFORM
		if(!alt_covers_chest) // for the special snowflake suits that expose the chest when adjusted
			body_parts_covered &= ~CHEST
	else
		fitted = initial(fitted)
		if(!alt_covers_chest)
			body_parts_covered |= CHEST
	return adjusted

/obj/item/clothing/proc/weldingvisortoggle(mob/user) //proc to toggle welding visors on helmets, masks, goggles, etc.
	if(!can_use(user))
		return FALSE

	visor_toggling()

	to_chat(user, span_notice("I adjust \the [src] [up ? "up" : "down"]."))

	if(iscarbon(user))
		var/mob/living/carbon/C = user
		C.head_update(src, forced = 1)
	for(var/X in actions)
		var/datum/action/A = X
		A.UpdateButtonIcon()
	return TRUE

/obj/item/clothing/proc/visor_toggling() //handles all the actual toggling of flags
	up = !up
	clothing_flags ^= visor_flags
	flags_inv ^= visor_flags_inv
	flags_cover ^= initial(flags_cover)
	icon_state = "[initial(icon_state)][up ? "up" : ""]"
	if(visor_vars_to_toggle & VISOR_FLASHPROTECT)
		flash_protect ^= initial(flash_protect)
	if(visor_vars_to_toggle & VISOR_TINT)
		tint ^= initial(tint)

/obj/item/clothing/head/helmet/space/plasmaman/visor_toggling() //handles all the actual toggling of flags
	up = !up
	clothing_flags ^= visor_flags
	flags_inv ^= visor_flags_inv
	icon_state = "[initial(icon_state)]"
	if(visor_vars_to_toggle & VISOR_FLASHPROTECT)
		flash_protect ^= initial(flash_protect)
	if(visor_vars_to_toggle & VISOR_TINT)
		tint ^= initial(tint)

/obj/item/clothing/proc/can_use(mob/user)
	if(user && ismob(user))
		if(!user.incapacitated())
			return 1
	return 0

/obj/item/clothing/proc/step_action() //this was made to rewrite clown shoes squeaking
	SEND_SIGNAL(src, COMSIG_CLOTHING_STEP_ACTION)

/obj/item/clothing/take_damage(damage_amount, damage_type = BRUTE, damage_flag, sound_effect, attack_dir, armor_penetration)
	var/newdam = run_obj_armor(damage_amount, damage_type, damage_flag, attack_dir, armor_penetration)
	var/eff_maxint = max_integrity - (max_integrity * integrity_failure)
	var/eff_currint = max(obj_integrity - (max_integrity * integrity_failure), 0)
	var/ratio =	(eff_currint / eff_maxint)
	var/ratio_newinteg = (eff_currint - newdam) / eff_maxint
	var/text
	var/y_offset
	var/chunkicon
	var/sfx
	if(ratio > 0.75 && ratio_newinteg < 0.75)
		text = "Armor <br><font color = '#8aaa4d'>marred</font>"
		sfx = 'sound/combat/armor_degrade1.ogg'
		chunkicon = "chunkfall1"
		y_offset = -5
	if(ratio > 0.5 && ratio_newinteg < 0.5)
		text = "Armor <br><font color = '#d4d36c'>damaged</font>"
		sfx = 'sound/combat/armor_degrade2.ogg'
		chunkicon = "chunkfall2"
		y_offset = 15
	if(ratio > 0.25 && ratio_newinteg < 0.25)
		text = "Armor <br><font color = '#a8705a'>sundered</font>"
		sfx = 'sound/combat/armor_degrade3.ogg'
		chunkicon = "chunkfall3"
		y_offset = 30
	if(text)
		if(isliving(loc))
			var/mob/living/L = loc
			if(L.last_integ_sound < world.time)
				playsound(src, sfx, 100, TRUE)
				L.last_integ_sound = world.time + INT_NOISE_DELAY
			new /obj/effect/temp_visual/armor_chunk(get_turf(src), 0.7 SECONDS, chunkcolor, chunkicon)
		filtered_balloon_alert(TRAIT_COMBAT_AWARE, text, -20, y_offset)
	. = ..()


/obj/proc/generate_tooltip(examine_text, showcrits)
	return examine_text

/obj/item/clothing/generate_tooltip(examine_text, showcrits)
	if(!armor)	// No armor
		return examine_text

	// Fake armor
	if(armor.getRating("slash") == 0 && armor.getRating("stab") == 0 && armor.getRating("blunt") == 0 && armor.getRating("piercing") == 0)
		return examine_text

	var/str
	str += "[colorgrade_rating("🔨 BLUNT ", armor.blunt, elaborate = TRUE)] | "
	str += "[colorgrade_rating("🪓 SLASH ", armor.slash, elaborate = TRUE)]"
	str += "<br>"
	str += "[colorgrade_rating("🗡️ STAB ", armor.stab, elaborate = TRUE)] | "
	str += "[colorgrade_rating("🏹 PIERCE ", armor.piercing, elaborate = TRUE)] "

	if(showcrits)
		if(!prevent_crits)
			str += "<text-align: center>"
			str += "<b><font color = '#aa2121'>CRIT SUSCEPTIBLE!</font></b>"
		else if(prevent_crits == PREVENT_CRITS_ALL)
			str += "<text-align: center>"
			str += "<b><font color = '#6890a7'>PICK RESISTANT</font></b>"

	//This makes it appear darker than the rest of examine text. Draws the cursor to it like to a Wetsquires.rt link.
	examine_text = "<font color = '#808080'>[examine_text]</font>"
	return SPAN_TOOLTIP_DANGEROUS_HTML(str, examine_text)

/obj/item/clothing/proc/get_armor_integ()
	var/eff_maxint = max_integrity - (max_integrity * integrity_failure)
	var/eff_currint = max(obj_integrity - (max_integrity * integrity_failure), 0)
	var/ratio =	(eff_currint / eff_maxint)
	switch(ratio)
		if(0.75 to 1)
			return null
		if(0.5 to 0.74)
			return VISMSG_ARMOR_INT_STAGEONE
		if(0.25 to 0.49)
			return VISMSG_ARMOR_INT_STAGETWO
		if(0 to 0.24)
			return VISMSG_ARMOR_INT_STAGETHREE
