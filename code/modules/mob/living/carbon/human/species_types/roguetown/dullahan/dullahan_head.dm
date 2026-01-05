/obj/item/bodypart/head/dullahan/
	attach_wound = null
	var/list/head_items = list()

// Support dropping yourself on a detached head. Check sexcon_helpers for original code with docs.
/obj/item/bodypart/head/dullahan/MiddleMouseDrop_T(atom/movable/dragged, mob/living/user)
	var/mob/living/carbon/human/target = src.original_owner
	if(user.mmb_intent)
		return ..()
	// Maybe call target.MiddleMouseDrop_T() instead, may have side effects and so opted not to.

	if(!istype(dragged))
		return
	if(dragged != user)
		return
	if(!user.can_do_sex())
		to_chat(user, "<span class='warning'>I can't do this.</span>")
		return
	if(!user.client.prefs.sexable)
		to_chat(user, "<span class='warning'>I don't want to touch [target]. (Your ERP preference, in the options)</span>")
		return
	if(!target.client || !target.client.prefs)
		to_chat(user, span_warning("[target] is simply not there. I can't do this."))
		log_combat(user, target, "tried ERP menu against d/ced")
		return
	if(!target.client.prefs.sexable) // Don't bang someone that doesn't want it.
		to_chat(user, "<span class='warning'>[target] doesn't want to be touched. (Their ERP preference, in the options)</span>")
		to_chat(target, "<span class='warning'>[user] failed to touch you. (Your ERP preference, in the options)</span>")
		log_combat(user, target, "tried unwanted ERP menu against")
		return
	user.start_sex_session(target)

// Attach head.
/obj/item/bodypart/head/dullahan/melee_attack_chain(mob/living/carbon/human/user, mob/living/carbon/human/target, params)
	if(!ishuman(target))
		return ..()

	if(user.cmode || user.zone_selected != BODY_ZONE_HEAD)
		return ..()

	var/datum/species/dullahan/target_species = target.dna.species
	if(!target_species.headless)
		return ..()

	if(src.original_owner != target)
		if(user == target)
			to_chat(user, span_notice("This is not my head!"))
		else
			to_chat(user, span_notice("That is not [target]'s head!"))
		return ..()

	if(user == target)
		user.visible_message(span_notice("[user] begins putting on [user.p_their()] head..."), \
			span_notice("I begin putting on my head..."))
	else
		target.visible_message(span_notice("[user] begins putting on [target]'s head for them..."), \
			span_notice("[user] is putting on my head for me..."))
		to_chat(user, span_notice("I try to put [user]'s head on for them..."))

	if(do_after(user, 3, target = target))
		attach_limb(target)

		user.update_a_intents()

		var/obj/item/organ/dullahan_vision/vision = target.getorganslot(ORGAN_SLOT_HUD)
		vision.viewing_head = FALSE
		target.reset_perspective()

// Remove head.
/datum/species/dullahan/help(mob/living/carbon/human/user, mob/living/carbon/human/target, datum/martial_art/attacker_style)
	// Only do it if the precise selection is the head, to avoid mistakes.
	if(target != user || user.zone_selected != BODY_ZONE_HEAD) 
		return ..()

	if(headless)
		return ..()

	var/obj/item/equipped_nodrop = get_nodrop_head()
	if(equipped_nodrop)
		to_chat(user, span_notice("The [equipped_nodrop.name] keeps the binds of my neck stuck together!"))
		return ..()

	user.visible_message(span_notice("[user] begins taking off [user.p_their()] head..."), \
		span_notice("I begin taking off my head..."))
	if(do_after(user, 3, target = user))
		my_head.drop_limb(FALSE)

		if(QDELETED(my_head))
			return ..()

		user.put_in_active_hand(my_head)

		var/obj/item/organ/dullahan_vision/vision = user.getorganslot(ORGAN_SLOT_HUD)
		vision.viewing_head = TRUE

		user.reset_perspective(my_head)

// Stop powergamers from putting their heads in containers for free.
/obj/item/bodypart/head/dullahan/on_enter_storage(datum/component/storage/concrete/S)
	. = ..()
	var/mob/living/carbon/human/human = original_owner
	var/obj/item/organ/dullahan_vision/vision = human.getorganslot(ORGAN_SLOT_HUD)
	vision.become_blind()

/obj/item/bodypart/head/dullahan/on_exit_storage(datum/component/storage/concrete/S)
	. = ..()
	var/mob/living/carbon/human/human = original_owner
	var/obj/item/organ/dullahan_vision/vision = human.getorganslot(ORGAN_SLOT_HUD)
	vision.cure_blind()

/obj/item/bodypart/head/dullahan/proc/update_vision_cone()
	original_owner.update_fov_angles()
	original_owner.update_vision_cone()

/obj/item/bodypart/head/dullahan/forceMove(atom/destination)
	// We tell the code to reset the perspective later than it should. Didn't work otherwise.
	var/reset_perspective = FALSE
	if(src.loc && ishuman(src.loc) && original_owner && src.loc != original_owner)
		var/mob/living/carbon/human/parent = src.loc
		UnregisterSignal(parent, COMSIG_ATOM_DIR_CHANGE)
		reset_perspective = TRUE
		// Biting someone while being held. They dropped us, drop the bite.
		if(istype(original_owner.mouth, /obj/item/grabbing/bite/))
			qdel(original_owner.mouth)

	if(ishuman(destination) && original_owner && destination != original_owner)
		var/mob/living/carbon/human/new_parent = destination
		RegisterSignal(new_parent, COMSIG_ATOM_DIR_CHANGE, PROC_REF(update_vision_cone), override = TRUE)
		original_owner.reset_perspective(new_parent)

	var/obj/item/organ/dullahan_vision/vision = original_owner.getorganslot(ORGAN_SLOT_HUD)
	if(vision)
		if(istype(destination, /obj/structure/closet) || istype(destination, /obj/item/storage/))
			vision.become_blind()
		else
			vision.cure_blind()

	. = ..()

	if(reset_perspective)
		if(vision.viewing_head)
			original_owner.reset_perspective(src)
		else
			original_owner.reset_perspective()

// Stop organs from decaying.
// Detached bodyparts don't rot, organs do.
/obj/item/bodypart/head/dullahan/Entered(obj/item/organ/arrived, atom/old_loc, list/atom/old_locs)
	. = ..()
	if(!isorgan(arrived))
		return
	arrived.organ_flags |= ORGAN_FROZEN

/obj/item/bodypart/head/dullahan/Exited(obj/item/organ/gone, direction)
	. = ..()
	if(!isorgan(gone))
		return
	gone.organ_flags &= ~ORGAN_FROZEN

// Relay food items. Band-aid implementation. Allows body to be fed despite not having a head. May be seen as a feature.
/obj/item/bodypart/head/dullahan/attackby(obj/item/reagent_containers/food/item, mob/living/user)
	if(istype(item, /obj/item/reagent_containers/food/) && ishuman(user))
		item.attack(original_owner, user)
	else
		..()

// Kills Dullahan if their brain is dropped from the head. Same in organ_manipulation.
// Could track in forceMove() but this seems more reliable. Change would not take much.
/obj/item/bodypart/head/dullahan/drop_organs(mob/user, violent_removal)
	. = ..()
	if(!(original_owner.status_flags & GODMODE))
		original_owner.death()

/obj/item/bodypart/head/dullahan/attach_limb(mob/living/carbon/human/user)
	var/mob/living/carbon/human/user_dullahan = original_owner ? original_owner : user
	var/datum/species/dullahan/user_species = user_dullahan.dna.species
	user_species.soul_light_off()
	user_species.headless = FALSE

	for(var/item_slot in head_items)
		var/obj/item/worn_item = head_items[item_slot]
		if(worn_item)
			user_dullahan.equip_to_slot(worn_item, text2num(item_slot))
	head_items = list()
	return ..()

/obj/item/bodypart/head/dullahan/proc/insert_worn_items()
	// Sorry. Roguetown hardcodes variables and I don't want to do that.
	var/list/worn_items = list(
		"[SLOT_HEAD]" = owner.get_item_by_slot(SLOT_HEAD),
		"[SLOT_WEAR_MASK]" = owner.get_item_by_slot(SLOT_WEAR_MASK),
		/*
			"[SLOT_GLASSES]" = owner.get_item_by_slot(SLOT_GLASSES),
			"[SLOT_NECK]" = owner.get_item_by_slot(SLOT_NECK),
			"[SLOT_MOUTH]" = owner.get_item_by_slot(SLOT_MOUTH),
		*/
	)
	head_items = list()
	for(var/item_slot in worn_items)
		var/obj/item/worn_item = worn_items[item_slot]
		if(worn_item)
			owner.dropItemToGround(worn_item, force = TRUE)

			if(istype(worn_item, /obj/item/clothing/head/hooded) || HAS_TRAIT(worn_item, TRAIT_NODROP) || QDELETED(worn_item))
				continue
			head_items[item_slot] = worn_item
			worn_item.forceMove(src)

/obj/item/bodypart/head/dullahan/drop_limb(special)
	var/mob/living/carbon/human/user = original_owner
	var/datum/species/dullahan/user_species = user.dna.species

	user_species.soul_light_on(user)
	user_species.headless = TRUE

	// Handle grabs when voluntarily removing head
	// Ensure grabbedby is a list so it can be properly .Cut()'d
	grabbedby = SANITIZE_LIST(grabbedby)
	if(grabbedby)
		for(var/obj/item/grabbing/grab in grabbedby)
			if(grab.grab_state != GRAB_AGGRESSIVE)
				continue

			var/mob/living/carbon/human = grab.grabbee
			var/hand_index = human.get_held_index_of_item(grab)
			human.dropItemToGround(grab)

			// Handle worn items
			if(!special)
				insert_worn_items()

			// Call parent drop_limb without the grab handling
			. = ..()

			human.put_in_hand(src, hand_index)

			// Clear the grabbedby list properly
			grabbedby.Cut()
			return

		// Clear all grabs if no aggressive grab.
		grabbedby.Cut()

	if(!special)
		insert_worn_items()

	. = ..()

/obj/item/bodypart/head/dullahan/update_icon_dropped()
	var/list/standing = get_limb_icon(1)
	if(!standing.len)
		icon_state = initial(icon_state)//no overlays found, we default back to initial icon.
		return
	for(var/image/I in standing)
		I.pixel_x += px_x
		I.pixel_y += px_y
	add_overlay(standing)

/obj/item/bodypart/head/dullahan/get_limb_icon(dropped, hideaux = FALSE)
	cut_overlays()
	var/list/standing = ..()

	. = standing
	var/hidden_slots = NONE
	var/obj/item/head_item = head_items["[SLOT_HEAD]"]
	if(head_item)
		hidden_slots |= head_item.flags_inv
		if(transparent_protection)
			hidden_slots |= head_item.transparent_protection
		var/mutable_appearance/head_overlay = head_item.build_worn_icon(default_layer = HEAD_LAYER, default_icon_file = 'icons/roguetown/clothing/onmob/head.dmi')
		. += head_overlay

	var/obj/item/wear_mask = head_items["[SLOT_WEAR_MASK]"]
	if(wear_mask)
		if(!(hidden_slots & HIDEMASK))
			var/mutable_appearance/mask_overlay = wear_mask.build_worn_icon(default_layer = MASK_LAYER, default_icon_file = 'icons/mob/clothing/mask.dmi')
			. += mask_overlay

/obj/item/bodypart/head/dullahan/dismember(dam_type = BRUTE, bclass = BCLASS_CUT, mob/living/user, zone_precise = src.body_zone, damage = 0, vorpal = FALSE)
	if(!owner)
		return FALSE
	var/mob/living/carbon/C = owner
	if(user && (body_zone == BODY_ZONE_HEAD))
		if(zone_precise != BODY_ZONE_PRECISE_NECK)
			return FALSE
	if(C.status_flags & GODMODE)
		return FALSE
	if(HAS_TRAIT(C, TRAIT_NODISMEMBER))
		return FALSE

	playsound(C, pick(dismemsound), 50, FALSE, -1)
	C.visible_message(span_danger("<B>[C] is EASILY DECAPITATED!</B>"))

	//C.emote("painscream") // Should we still scream? Decapitations would happen quite often.
	//src.add_mob_blood(C)

	// Ensure grabbedby is a list so it can be properly .Cut()'d
	grabbedby = SANITIZE_LIST(grabbedby)
	if(grabbedby)
		if(dam_type != BURN)
			for(var/obj/item/grabbing/grab in grabbedby)
				if(grab.grab_state != GRAB_AGGRESSIVE)
					continue

				var/mob/living/carbon/human = grab.grabbee
				var/hand_index = human.get_held_index_of_item(grab)
				human.dropItemToGround(grab)
				drop_limb(FALSE)
				human.put_in_hand(src, hand_index)

				grabbedby.Cut()
				// Returns to not throw the head.
				return TRUE

		grabbedby.Cut()

	drop_limb(FALSE)
	if(dam_type == BURN)
		burn()
		return TRUE

	var/obj/item/organ/dullahan_vision/vision = original_owner.getorganslot(ORGAN_SLOT_HUD)
	if(vision)
		vision.viewing_head = TRUE

	var/turf/location = C.loc
	if(istype(location))
		C.add_splatter_floor(location)
	var/direction = pick(GLOB.cardinals)
	var/t_range = rand(2,max(throw_range/2, 2))
	var/turf/target_turf = get_turf(src)
	for(var/i in 1 to t_range-1)
		var/turf/new_turf = get_step(target_turf, direction)
		if(!new_turf)
			break
		target_turf = new_turf
		if(new_turf.density)
			break
	throw_at(target_turf, throw_range, throw_speed)
	return TRUE

// This sucks.
// Removes neck injuries as a trade for easy decapitations.
/obj/item/bodypart/head/dullahan/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	var/static/list/eyestab_zones = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)
	var/static/list/tonguestab_zones = list(BODY_ZONE_PRECISE_MOUTH)
	var/static/list/nosestab_zones = list(BODY_ZONE_PRECISE_NOSE)
	var/static/list/earstab_zones = list(BODY_ZONE_PRECISE_EARS)
	var/static/list/knockout_zones = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_SKULL)
	var/list/attempted_wounds = list()
	var/used
	var/total_dam = get_damage()
	var/damage_dividend = (total_dam / max_damage)
	var/resistance = HAS_TRAIT(owner, TRAIT_CRITICAL_RESISTANCE)
	var/from_behind = FALSE
	if(user && (owner.dir == turn(get_dir(owner,user), 180)))
		from_behind = TRUE
	if(user && dam)
		if(user.goodluck(2))
			dam += 10
	if((bclass in GLOB.dislocation_bclasses) && (total_dam >= max_damage))
		used = round(damage_dividend * 20 + (dam / 3))
	if(bclass in GLOB.fracture_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(HAS_TRAIT(src, TRAIT_BRITTLE))
			used += 20
		if(user)
			if(istype(user.rmb_intent, /datum/rmb_intent/strong) || (user.m_intent == MOVE_INTENT_SNEAK))
				used += 10
		if(!owner.stat && !resistance && (zone_precise in knockout_zones) && (bclass != BCLASS_CHOP && bclass != BCLASS_PIERCE) && prob(used))
			owner.next_attack_msg += " <span class='crit'><b>Critical hit!</b> [owner] is knocked out[from_behind ? " FROM BEHIND" : ""]!</span>"
			owner.flash_fullscreen("whiteflash3")
			owner.Unconscious(5 SECONDS + (from_behind * 10 SECONDS))
			if(owner.client)
				winset(owner.client, "outputwindow.output", "max-lines=1")
				winset(owner.client, "outputwindow.output", "max-lines=100")
		var/dislocation_type
		var/fracture_type = /datum/wound/fracture/head
		var/necessary_damage = 0.9
		if(resistance)
			fracture_type = /datum/wound/fracture
		else if(zone_precise == BODY_ZONE_PRECISE_SKULL)
			fracture_type = /datum/wound/fracture/head/brain
		else if(zone_precise== BODY_ZONE_PRECISE_EARS)
			fracture_type = /datum/wound/fracture/head/ears
			necessary_damage = 0.8
		else if(zone_precise == BODY_ZONE_PRECISE_NOSE)
			fracture_type = /datum/wound/fracture/head/nose
			necessary_damage = 0.7
		else if(zone_precise == BODY_ZONE_PRECISE_MOUTH)
			fracture_type = /datum/wound/fracture/mouth
			necessary_damage = 0.7
		if(prob(used) && (damage_dividend >= necessary_damage))
			if(dislocation_type)
				attempted_wounds += dislocation_type
			attempted_wounds += fracture_type
	if(bclass in GLOB.artery_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(user)
			if(bclass == BCLASS_CHOP)
				if(istype(user.rmb_intent, /datum/rmb_intent/strong))
					used += 10
			else
				if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
					used += 10
		var/artery_type = /datum/wound/artery
		if(prob(used))
			attempted_wounds += artery_type
			if((bclass in GLOB.stab_bclasses) && !resistance)
				if(zone_precise in earstab_zones)
					var/obj/item/organ/ears/my_ears = owner.getorganslot(ORGAN_SLOT_EARS)
					if(!my_ears || has_wound(/datum/wound/facial/ears))
						attempted_wounds += /datum/wound/fracture/head/ears
					else
						attempted_wounds += /datum/wound/facial/ears
				else if(zone_precise in eyestab_zones)
					var/obj/item/organ/my_eyes = owner.getorganslot(ORGAN_SLOT_EYES)
					if(!my_eyes || (has_wound(/datum/wound/facial/eyes/left) && has_wound(/datum/wound/facial/eyes/right)))
						attempted_wounds += /datum/wound/fracture/head/eyes
					else if(my_eyes)
						if(zone_precise == BODY_ZONE_PRECISE_R_EYE)
							attempted_wounds += /datum/wound/facial/eyes/right
						else if(zone_precise == BODY_ZONE_PRECISE_L_EYE)
							attempted_wounds += /datum/wound/facial/eyes/left
				else if(zone_precise in tonguestab_zones)
					var/obj/item/organ/tongue/tongue_up_my_asshole = owner.getorganslot(ORGAN_SLOT_TONGUE)		//..hello?
					if(!tongue_up_my_asshole || has_wound(/datum/wound/facial/tongue))
						attempted_wounds += /datum/wound/fracture/mouth
					else
						attempted_wounds += /datum/wound/facial/tongue
				else if(zone_precise in nosestab_zones)
					if(has_wound(/datum/wound/facial/disfigurement/nose))
						attempted_wounds +=/datum/wound/fracture/head/nose
					else
						attempted_wounds += /datum/wound/facial/disfigurement/nose
				else if(zone_precise in knockout_zones)
					attempted_wounds += /datum/wound/fracture/head/brain

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				GLOB.azure_round_stats[STATS_CRITS_MADE]++
			return applied
	return FALSE

// This also sucks.
/obj/item/bodypart/head/dullahan/send_speech(message, message_range = 6, obj/source = src, bubble_type = null, list/spans, datum/language/message_language=null, message_mode, original_message)
	var/static/list/eavesdropping_modes = list(MODE_WHISPER = TRUE, MODE_WHISPER_CRIT = TRUE)
	var/eavesdrop_range = 0
	var/Zs_too = FALSE
	var/Zs_all = FALSE
	var/Zs_yell = FALSE
	var/listener_has_ceiling	= TRUE
	var/speaker_has_ceiling		= TRUE

	var/turf/speaker_turf = get_turf(src)
	var/turf/speaker_ceiling = get_step_multiz(speaker_turf, UP)
	if(speaker_ceiling)
		if(istransparentturf(speaker_ceiling))
			speaker_has_ceiling = FALSE
	if(eavesdropping_modes[message_mode])
		eavesdrop_range = EAVESDROP_EXTRA_RANGE
	if(message_mode != MODE_WHISPER)
		Zs_too = TRUE
		if(say_test(message) == "2")	//CIT CHANGE - ditto
			message_range += 10
			Zs_yell = TRUE
		if(say_test(message) == "3")	//Big "!!" shout
			Zs_all = TRUE
	// AZURE EDIT: thaumaturgical loudness (from orisons)
	if (original_owner.has_status_effect(/datum/status_effect/thaumaturgy))
		spans |= SPAN_REALLYBIG
		var/datum/status_effect/thaumaturgy/buff = locate() in original_owner.status_effects
		message_range += (5 + buff.potency) // maximum 12 tiles extra, which is a lot!
		for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
			if (prob(buff.potency * 3) && S.speaking) // 3% chance per holy level, per SCOM for it to shriek your message in town wherever you are
				S.verb_say = "shrieks in terror"
				S.verb_exclaim = "shrieks in terror"
				S.verb_yell = "shrieks in terror"
				S.say(message, spans = list("info", "reallybig"))
				S.verb_say = initial(S.verb_say)
				S.verb_exclaim = initial(S.verb_exclaim)
				S.verb_yell = initial(S.verb_yell)
		original_owner.remove_status_effect(/datum/status_effect/thaumaturgy)
	// AZURE EDIT END
	var/list/listening = get_hearers_in_view(message_range+eavesdrop_range, source)
	var/list/the_dead = list()
	for(var/_M in GLOB.player_list)
		var/mob/M = _M
		var/atom/movable/tocheck = M
		if(isdullahan(M))
			var/mob/living/carbon/human/target = M
			var/datum/species/dullahan/target_species = target.dna.species
			tocheck = target_species.headless ? target_species.my_head : M
		if(!M)
			continue
		if(!M.client)
			continue
		if(get_dist(tocheck, src) > message_range) //they're out of range of normal hearing
			if(M.client.prefs)
				if(eavesdropping_modes[message_mode] && !(M.client.prefs.chat_toggles & CHAT_GHOSTWHISPER)) //they're whispering and we have hearing whispers at any range off
					continue
				if(!(M.client.prefs.chat_toggles & CHAT_GHOSTEARS)) //they're talking normally and we have hearing at any range off
					continue
		if(!is_in_zweb(src.z,tocheck.z))
			continue
		listening |= M
		the_dead[M] = TRUE
	log_seen(src, null, listening, original_message, SEEN_LOG_SAY)

	var/eavesdropping
	var/eavesrendered
	if(eavesdrop_range)
		eavesdropping = stars(message)
		eavesrendered = compose_message(src, message_language, eavesdropping, , spans, message_mode)

	var/rendered = compose_message(src, message_language, message, , spans, message_mode)
	for(var/_AM in listening)
		var/atom/movable/AM = _AM
		var/turf/listener_turf = get_turf(AM)
		var/turf/listener_ceiling = get_step_multiz(listener_turf, UP)
		if(listener_ceiling)
			listener_has_ceiling = TRUE
			if(istransparentturf(listener_ceiling))
				listener_has_ceiling = FALSE
		if((!Zs_too && !isobserver(AM)) || message_mode == MODE_WHISPER)
			if(AM.z != src.loc.z)
				continue
		if(Zs_too && AM.z != src.loc.z && !Zs_all)
			if(!Zs_yell && !HAS_TRAIT(AM, TRAIT_KEENEARS))
				if(listener_turf.z < speaker_turf.z && listener_has_ceiling)	//Listener is below the speaker and has a ceiling above them
					continue
				if(listener_turf.z > speaker_turf.z && speaker_has_ceiling)		//Listener is above the speaker and the speaker has a ceiling above
					continue
				if(listener_has_ceiling && speaker_has_ceiling)	//Both have a ceiling, on different z-levels -- no hearing at all
					continue
			else
				if(abs((listener_turf.z - speaker_turf.z)) >= 2)	//We're yelling with only one "!", and the listener is 2 or more z levels above or below us.
					continue
			var/listener_obstructed = TRUE
			var/speaker_obstructed = TRUE
			if(src != AM && !Zs_yell && !HAS_TRAIT(AM, TRAIT_KEENEARS))	//We always hear ourselves. Zs_yell will allow a "!" shout to bypass walls one z level up or below.
				if(!speaker_has_ceiling && isliving(AM))
					var/mob/living/M = AM
					for(var/mob/living/MH in viewers(world.view, speaker_ceiling))
						if(M == MH && MH.z == speaker_ceiling?.z)
							speaker_obstructed = FALSE

				if(!listener_has_ceiling)
					for(var/mob/living/ML in viewers(world.view, listener_ceiling))
						if(ML == src && ML.z == listener_ceiling?.z)
							listener_obstructed = FALSE
				if(listener_obstructed && speaker_obstructed)
					continue
		var/highlighted_message
		var/keenears
		if(ishuman(AM))
			var/mob/living/carbon/human/H = AM
			keenears = HAS_TRAIT(H, TRAIT_KEENEARS)
			var/name_to_highlight = H.nickname
			if(name_to_highlight && name_to_highlight != "" && name_to_highlight != "Please Change Me")	//We don't need to highlight an unset or blank one.
				highlighted_message = replacetext_char(message, name_to_highlight, "<b><font color = #[H.highlight_color]>[name_to_highlight]</font></b>")
		var/atom/movable/tocheck = AM
		if(isdullahan(AM))
			var/mob/living/carbon/human/target = AM
			var/datum/species/dullahan/target_species = target.dna.species
			tocheck = target_species.headless ? target_species.my_head : AM

		if(eavesdrop_range && get_dist(source, tocheck) > message_range+keenears && !(the_dead[AM]))
			AM.Hear(eavesrendered, src, message_language, eavesdropping, , spans, message_mode, original_message)
		else if(highlighted_message)
			AM.Hear(rendered, src, message_language, highlighted_message, , spans, message_mode, original_message)
		else
			AM.Hear(rendered, src, message_language, message, , spans, message_mode, original_message)
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_LIVING_SAY_SPECIAL, src, message)

/obj/item/bodypart/head/dullahan/say_mod(input, message_mode)
	if(message_mode == MODE_WHISPER)
		. = verb_whisper
	else if(message_mode == MODE_WHISPER_CRIT)
		. = "[verb_whisper] in [p_their()] last breath"
	else if(original_owner.stuttering)
		. = "stammers"
	else if(original_owner.derpspeech)
		. = "gibbers"
	else if(message_mode == MODE_SING)
		. = verb_sing
	else
		. = ..()

// Head inventory.
/obj/item/bodypart/head/dullahan/proc/show_inv(mob/user)
	var/close = user.is_holding(src) || get_turf(src) == get_turf(user)
	if(!close)
		return

	var/hidden_slots = NONE
	var/obj/item/head_item = head_items["[SLOT_HEAD]"]
	if(head_item)
		hidden_slots |= head_item.flags_inv
		if(transparent_protection)
			hidden_slots |= head_item.transparent_protection

	var/obj/item/wear_mask = head_items["[SLOT_WEAR_MASK]"]
	var/list/dat = list()

	dat += "<table>"

	dat += "<tr><td><A href='?src=[REF(src)];item=[SLOT_HEAD]'>[(head_item && !(head_item.item_flags & ABSTRACT)) ? head_item : "<font color=grey>Head</font>"]</A></td></tr>"

	if(hidden_slots & HIDEMASK)
		dat += "<tr><td><font color=grey>Obscured</font></td></tr>"
	else
		dat += "<tr><td><A href='?src=[REF(src)];item=[SLOT_WEAR_MASK]'>[(wear_mask && !(wear_mask.item_flags & ABSTRACT)) ? wear_mask : "<font color=grey>Mask</font>"]</A></td></tr>"

	dat += "<tr><td><hr></td></tr>"

	dat += {"</table>"}
	var/datum/browser/popup = new(user, "obj[REF(src)]", "[src]", 220, 250)
	popup.set_content(dat.Join())
	popup.open()

/obj/item/bodypart/head/dullahan/Topic(href, href_list)
	var/mob/user = usr
	var/close = user.is_holding(src) || get_turf(src) == get_turf(user)

	if(href_list["item"] && close)
		var/obj/item/target_item = head_items[href_list["item"]]
		if(target_item)
			if(!(target_item.item_flags & ABSTRACT))
				dropped_unequip(href_list["item"], user)
				return
		else
			dropped_equip(href_list["item"], user)
			return

/obj/item/bodypart/head/dullahan/proc/dropped_unequip(slot, mob/user)
	var/obj/item/target_item = head_items[slot]
	var/close = user.is_holding(src) || get_turf(src) == get_turf(user)

	if(!close || !target_item)
		return

	visible_message(span_warning("[user] tries to remove [src]'s [target_item]."))
	to_chat(user, span_danger("I try to remove [src]'s [target_item]..."))

	if(do_after(user, target_item.strip_delay, target = src))
		if(target_item && (user.is_holding(src) || get_turf(src) == get_turf(user)))
			user.put_in_hands(target_item)
			head_items[slot] = null
			update_icon_dropped()
	if(user.is_holding(src) || get_turf(src) == get_turf(user))
		show_inv(user)

/obj/item/bodypart/head/dullahan/proc/dropped_equip(slot, mob/user)
	var/obj/item/target_item = user.get_active_held_item()
	if(target_item && (HAS_TRAIT(target_item, TRAIT_NODROP)))
		to_chat(src, span_warning("I can't put \the [target_item.name] on [src], it's stuck to my hand!"))
		return

	if((slot != "[SLOT_WEAR_MASK]" && slot != "[SLOT_HEAD]") || istype(target_item, /obj/item/clothing/head/hooded))
		return
	if((slot == "[SLOT_WEAR_MASK]" && !(target_item.slot_flags & ITEM_SLOT_MASK)) || (slot == "[SLOT_HEAD]" && !(target_item.slot_flags & ITEM_SLOT_HEAD)))
		return FALSE

	if(head_items[slot])
		return

	var/close = user.is_holding(src) || get_turf(src) == get_turf(user)
	if(!close)
		return

	visible_message(span_notice("[user] tries to put [target_item] on [src]."))
	to_chat(user, span_notice("I try to put [target_item] on [src]..."))

	if(do_after(user, target_item.equip_delay_other, target = src))
		if(target_item && (user.is_holding(src) || get_turf(src) == get_turf(user)))
			user.dropItemToGround(target_item, force = TRUE)
			head_items[slot] = target_item
			target_item.forceMove(src)
			update_icon_dropped()
	if(user.is_holding(src) || get_turf(src) == get_turf(user))
		show_inv(user)
