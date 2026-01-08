/obj/item/bodypart
	/// List of /datum/wound instances affecting this bodypart
	var/list/datum/wound/wounds
	/// List of items embedded in this bodypart
	var/list/obj/item/embedded_objects = list()
	/// Bandage, if this ever hard dels thats fucking silly lol
	var/obj/item/bandage

/// Checks if we have any embedded objects whatsoever
/obj/item/bodypart/proc/has_embedded_objects()
	return length(embedded_objects)

/// Checks if we have an embedded object of a specific type
/obj/item/bodypart/proc/has_embedded_object(path, specific = FALSE)
	if(!path)
		return
	for(var/obj/item/embedder as anything in embedded_objects)
		if((specific && embedder.type != path) || !istype(embedder, path))
			continue
		return embedder

/// Checks if an object is embedded in us
/obj/item/bodypart/proc/is_object_embedded(obj/item/embedder)
	if(!embedder)
		return FALSE
	return (embedder in embedded_objects)

/// Returns all wounds on this limb that can be sewn
/obj/item/bodypart/proc/get_sewable_wounds()
	var/list/woundies = list()
	for(var/datum/wound/wound as anything in wounds)
		if(wound == null)
			listclearnulls(wounds) //Putting this somewhere useful but low intensity
			continue
		if(!wound.can_sew)
			continue
		woundies += wound
	return woundies

/// Returns the first wound of the specified type on this bodypart
/obj/item/bodypart/proc/has_wound(path, specific = FALSE)
	if(!path)
		return
	for(var/datum/wound/wound as anything in wounds)
		if((specific && wound.type != path) || !istype(wound, path))
			continue
		return wound

/// Heals wounds on this bodypart by the specified amount
/obj/item/bodypart/proc/heal_wounds(heal_amount)
	if(!length(wounds))
		return FALSE
	if(HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || owner.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
		return
	var/healed_any = FALSE
	for(var/datum/wound/wound as anything in wounds)
		if(heal_amount <= 0)
			continue
		var/amount_healed = wound.heal_wound(heal_amount)
		heal_amount -= amount_healed
		healed_any = TRUE
	return healed_any

/// Adds a wound to this bodypart, applying any necessary effects
/obj/item/bodypart/proc/add_wound(datum/wound/wound, silent = FALSE, crit_message = FALSE)
	if(!wound || !owner || (owner.status_flags & GODMODE))
		return
	if(ispath(wound, /datum/wound))
		var/datum/wound/primordial_wound = GLOB.primordial_wounds[wound]
		if(!primordial_wound.can_apply_to_bodypart(src))
			return
		wound = new wound()
	else if(!istype(wound))
		return
	else if(!wound.can_apply_to_bodypart(src))
		qdel(wound)
		return
	if(!wound.apply_to_bodypart(src, silent, crit_message))
		qdel(wound)
		return
	return wound

/// Removes a wound from this bodypart, removing any associated effects
/obj/item/bodypart/proc/remove_wound(datum/wound/wound)
	if(ispath(wound))
		wound = has_wound(wound)
	if(!istype(wound))
		return FALSE
	. = wound.remove_from_bodypart()
	if(.)
		qdel(wound)

/// Check to see if we can apply a bleeding wound on this bodypart
/obj/item/bodypart/proc/can_bloody_wound()
	if(skeletonized)
		return FALSE
	if(!is_organic_limb())
		return FALSE
	if(NOBLOOD in owner?.dna?.species?.species_traits)
		return FALSE
	return TRUE

/// Returns the total bleed rate on this bodypart
/obj/item/bodypart/proc/get_bleed_rate()
	var/bleed_rate = bleeding
	if(bandage && !HAS_BLOOD_DNA(bandage))
		process_bandage(bleed_rate)
		var/obj/item/natural/cloth/cloth = bandage
		bleed_rate *= cloth.bandage_effectiveness
		if(bleed_rate <= 1) //if the bleeding is below this after being bandaged, bleeding stops completely, but the bandage still takes damage
			return 0
		return bleed_rate
	/*
	for(var/datum/wound/wound in wounds)
		if(istype(wound, /datum/wound))
			bleed_rate += wound.bleed_rate*/
	for(var/obj/item/embedded as anything in embedded_objects)
		if(!embedded.embedding.embedded_bloodloss)
			continue
		bleed_rate += embedded.embedding.embedded_bloodloss

	grabbedby = SANITIZE_LIST(grabbedby)
	for(var/obj/item/grabbing/grab in grabbedby)
		bleed_rate *= grab.bleed_suppressing
	bleed_rate = max(round(bleed_rate, 0.1), 0)

	// temporarily disabling below because it is niche use and a LOT of performance drain
	/*var/surgery_flags = get_surgery_flags()
	if(surgery_flags & SURGERY_CLAMPED)
		return min(bleed_rate, 0.5)*/
	return bleed_rate

/// Called after a bodypart is attacked so that wounds and critical effects can be applied
/obj/item/bodypart/proc/bodypart_attacked_by(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE, armor, obj/item/weapon)
	RETURN_TYPE(/datum/wound)
	if(!bclass || !dam || !owner || (owner.status_flags & GODMODE))
		return null
	var/do_crit = TRUE
	var/acheck_dflag
	switch(bclass)
		if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_TWIST, BCLASS_PUNCH)
			acheck_dflag = "blunt"
		if(BCLASS_CHOP, BCLASS_CUT, BCLASS_LASHING, BCLASS_PUNISH)
			acheck_dflag = "slash"
		if(BCLASS_PICK, BCLASS_STAB)
			acheck_dflag = "stab"
		if(BCLASS_PIERCE)
			acheck_dflag = "piercing"
	armor = owner.run_armor_check(zone_precise, acheck_dflag, damage = 0)
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		if(human_owner.checkcritarmor(zone_precise, bclass))
			do_crit = FALSE
		if(owner.mind && (get_damage() <= (max_damage * CRIT_DISMEMBER_DAMAGE_THRESHOLD))) //No crits unless the damage is maxed out.
			do_crit = FALSE // We used to check if they are buckled or lying down but being grounded is a big enough advantage.
	if(user)
		if(user.goodluck(2))
			dam += 10
		if(istype(user.rmb_intent, /datum/rmb_intent/weak) || bclass == BCLASS_PEEL)
			do_crit = FALSE

	var/datum/wound/dynwound = manage_dynamic_wound(bclass, dam, armor)

	if(do_crit)
		var/datum/component/silverbless/psyblessed = weapon?.GetComponent(/datum/component/silverbless)
		var/sundering = HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && istype(weapon) && weapon?.is_silver && psyblessed?.is_blessed
		var/crit_attempt = try_crit(sundering ? BCLASS_SUNDER : bclass, dam, user, zone_precise, silent, crit_message)
		if(crit_attempt)
			if(ishuman(owner))
				var/mob/living/carbon/human/human_owner = owner
				human_owner.hud_used?.stressies?.flick_pain(TRUE)
			return crit_attempt
	if(ishuman(owner))
		var/mob/living/carbon/human/human_owner = owner
		human_owner.hud_used?.stressies?.flick_pain(FALSE)
	return dynwound

/obj/item/bodypart/proc/manage_dynamic_wound(bclass, dam, armor)
	var/woundtype
	switch(bclass)
		if(BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PUNCH, BCLASS_TWIST)
			woundtype = /datum/wound/dynamic/bruise
		if(BCLASS_BITE)
			woundtype = /datum/wound/dynamic/bite
		if(BCLASS_CHOP, BCLASS_CUT)
			woundtype = /datum/wound/dynamic/slash
		if(BCLASS_STAB)
			woundtype = /datum/wound/dynamic/puncture
		if(BCLASS_PICK, BCLASS_PIERCE)
			woundtype = /datum/wound/dynamic/gouge
		if(BCLASS_LASHING)
			woundtype = /datum/wound/dynamic/lashing
		if(BCLASS_PUNISH)
			woundtype = /datum/wound/dynamic/punish
		else	//Wrong bclass type for wounds, skip adding this.
			return
	var/datum/wound/dynwound = has_wound(woundtype)
	if(!isnull(dynwound))
		dynwound.upgrade(dam, armor)
	else
		if(ispath(woundtype) && woundtype)
			if(!isnull(woundtype))
				var/datum/wound/newwound = add_wound(woundtype)
				dynwound = newwound
				if(newwound && !isnull(newwound))	//don't even ask - Free
					owner.visible_message(span_red("A new [newwound.name] appears on [owner]'s [lowertext(bodyzone2readablezone(bodypart_to_zone(newwound.bodypart_owner)))]!"))
					newwound.upgrade(dam, armor)
	return dynwound

/// Behemoth of a proc used to apply a wound after a bodypart is damaged in an attack
/obj/item/bodypart/proc/try_crit(bclass = BCLASS_BLUNT, dam, mob/living/user, zone_precise = src.body_zone, silent = FALSE, crit_message = FALSE)
	if(!bclass || !dam || (owner.status_flags & GODMODE))
		return FALSE
	var/list/attempted_wounds = list()
	var/used
	var/total_dam = get_damage()
	var/damage_dividend = (total_dam / max_damage)

	if(user && dam)
		if(user.goodluck(2))
			dam += 10
	if((bclass == BCLASS_PUNCH) && (user && dam))
		if(user && HAS_TRAIT(user, TRAIT_CIVILIZEDBARBARIAN))
			dam += 15
	if(bclass in GLOB.dislocation_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
			used += 10
		if(prob(used))
			if(HAS_TRAIT(src, TRAIT_BRITTLE))
				attempted_wounds += /datum/wound/fracture
			else
				attempted_wounds += /datum/wound/dislocation
	if(bclass in GLOB.fracture_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(user)
			if(istype(user.rmb_intent, /datum/rmb_intent/strong))
				used += 10
		if(HAS_TRAIT(src, TRAIT_BRITTLE))
			used += 10
		if(prob(used))
			if(damage_dividend >= 0.6)
				attempted_wounds += /datum/wound/fracture		//More sevre wound
			else
				attempted_wounds += /datum/wound/dislocation	//Less sevre wound
	if(bclass in GLOB.artery_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(user)
			if((bclass in GLOB.artery_strong_bclasses) && istype(user.rmb_intent, /datum/rmb_intent/strong))
				used += 10
			else if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
				used += 10
		if(prob(used))
			attempted_wounds += /datum/wound/artery
	if(bclass in GLOB.whipping_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
			dam += 10
		if(HAS_TRAIT(src, TRAIT_CRITICAL_WEAKNESS))
			attempted_wounds += /datum/wound/artery		//basically does sword-tier wounds.
		if(prob(used))
			attempted_wounds += /datum/wound/scarring
	if((bclass in GLOB.sunder_bclasses))
		if(HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			used = round(damage_dividend * 20 + (dam / 2))
			if(prob(used))
				attempted_wounds += /datum/wound/sunder

	// Check if critical resistance applies
	var/has_crit_attempt = length(attempted_wounds)
	if(!has_crit_attempt)
		return FALSE

	if(owner.try_resist_critical())
		if(crit_message)
			owner.next_attack_msg.Cut()
			owner.next_attack_msg += span_crit(" Critical resistance! [owner] resists a wound!</span>")
		return TRUE

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE

/obj/item/bodypart/chest/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	if(!bclass || !dam || (owner.status_flags & GODMODE))
		return FALSE
	var/list/attempted_wounds = list()
	var/used
	var/total_dam = get_damage()
	var/damage_dividend = (total_dam / max_damage)
	if(user && dam)
		if(user.goodluck(2))
			dam += 10
	if((bclass in GLOB.cbt_classes) && (zone_precise == BODY_ZONE_PRECISE_GROIN))
		var/cbt_multiplier = 1
		if(user && HAS_TRAIT(user, TRAIT_NUTCRACKER))
			cbt_multiplier = 2
		if(prob(round(dam/5) * cbt_multiplier))
			attempted_wounds += /datum/wound/cbt
		if(prob(dam * cbt_multiplier))
			owner.emote("groin", TRUE)
			owner.Stun(10)
	if((bclass in GLOB.fracture_bclasses) && (zone_precise != BODY_ZONE_PRECISE_STOMACH))
		used = round(damage_dividend * 20 + (dam / 3))
		if(user && istype(user.rmb_intent, /datum/rmb_intent/strong))
			used += 10
		if(HAS_TRAIT(src, TRAIT_BRITTLE))
			used += 10
		var/fracture_type = /datum/wound/fracture/chest
		if(zone_precise == BODY_ZONE_PRECISE_GROIN)
			if(damage_dividend >= 0.7)
				fracture_type = /datum/wound/fracture/groin	//Paralyzes lower body
		if(prob(used))
			attempted_wounds += fracture_type
	if(bclass in GLOB.artery_bclasses)
		used = round(damage_dividend * 20 + (dam / 4))
		if(user)
			if((bclass in GLOB.artery_strong_bclasses) && istype(user.rmb_intent, /datum/rmb_intent/strong))
				used += 10
			else if(istype(user.rmb_intent, /datum/rmb_intent/aimed))
				used += 10
		if(prob(used))
			if(zone_precise == BODY_ZONE_PRECISE_STOMACH)
				attempted_wounds += /datum/wound/slash/disembowel
			if(owner.has_wound(/datum/wound/fracture/chest) || (bclass in GLOB.artery_heart_bclasses) || HAS_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS))
				attempted_wounds += /datum/wound/artery/chest
			else
				attempted_wounds += /datum/wound/artery
	if(bclass in GLOB.whipping_bclasses)
		used = round(damage_dividend * 20 + (dam / 4))
		if(user)
			if(istype(user.rmb_intent, /datum/rmb_intent/strong))
				dam += 10
		if(prob(used))
			if(HAS_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS))
				attempted_wounds += /datum/wound/artery/chest
			else
				attempted_wounds += /datum/wound/scarring
	if(bclass in GLOB.sunder_bclasses)
		if(HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			used = round(damage_dividend * 20 + (dam / 2))
			if(prob(used))
				attempted_wounds += list(/datum/wound/sunder/chest)

	// Check if critical resistance applies
	var/has_crit_attempt = length(attempted_wounds)
	if(!has_crit_attempt)
		return FALSE

	if(owner.try_resist_critical())
		if(crit_message)
			owner.next_attack_msg.Cut()
			owner.next_attack_msg += span_crit(" Critical resistance! [owner] resists a wound!</span>")
		return TRUE

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE

/obj/item/bodypart/head/try_crit(bclass, dam, mob/living/user, zone_precise, silent = FALSE, crit_message = FALSE)
	var/static/list/eyestab_zones = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)
	var/static/list/tonguestab_zones = list(BODY_ZONE_PRECISE_MOUTH)
	var/static/list/nosestab_zones = list(BODY_ZONE_PRECISE_NOSE)
	var/static/list/earstab_zones = list(BODY_ZONE_PRECISE_EARS)
	var/static/list/knockout_zones = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_SKULL)
	var/list/attempted_wounds = list()
	var/used
	var/total_dam = get_damage()
	var/damage_dividend = (total_dam / max_damage)
	var/from_behind = FALSE
	var/try_knockout = FALSE
	if(user && (owner.dir == turn(get_dir(owner,user), 180)))
		from_behind = TRUE
	if(user && dam)
		if(user.goodluck(2))
			dam += 10
	if((bclass in GLOB.dislocation_bclasses) && (total_dam >= max_damage))
		used = round(damage_dividend * 20 + (dam / 3))
		if(prob(used))
			if(HAS_TRAIT(src, TRAIT_BRITTLE))
				attempted_wounds += /datum/wound/fracture/neck
			else
				attempted_wounds += /datum/wound/dislocation/neck
	if(bclass in GLOB.fracture_bclasses)
		used = round(damage_dividend * 20 + (dam / 3))
		if(HAS_TRAIT(src, TRAIT_BRITTLE))
			used += 20
		if(user)
			if(istype(user.rmb_intent, /datum/rmb_intent/strong) || (user.m_intent == MOVE_INTENT_SNEAK))
				used += 10
		if(!owner.stat && (zone_precise in knockout_zones) && (bclass != BCLASS_CHOP && bclass != BCLASS_PIERCE) && prob(used))
			try_knockout = TRUE
		var/dislocation_type
		var/fracture_type = /datum/wound/fracture/head
		var/necessary_damage = 0.9
		if(zone_precise == BODY_ZONE_PRECISE_SKULL)
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
		else if(zone_precise == BODY_ZONE_PRECISE_NECK)
			fracture_type = /datum/wound/fracture/neck
			dislocation_type = /datum/wound/dislocation/neck
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
		if(zone_precise == BODY_ZONE_PRECISE_NECK)
			artery_type = /datum/wound/artery/neck
		if(prob(used))
			attempted_wounds += artery_type
			if(bclass in GLOB.stab_bclasses)
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
	if(bclass in GLOB.sunder_bclasses)
		if(HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			used = round(damage_dividend * 20 + (dam / 2), 1)
			if(prob(used))
				attempted_wounds += /datum/wound/sunder/head

	var/has_crit_attempt = length(attempted_wounds) || try_knockout
	if(!has_crit_attempt)
		return FALSE

	var/resist_msg = " [owner] resists"
	if(attempted_wounds && try_knockout)
		resist_msg += " a wound and a knockout!</span>"
	else if(attempted_wounds)
		resist_msg += " a wound!</span>"
	else if(try_knockout)
		resist_msg += " a knockout!</span>"

	if(owner.try_resist_critical())
		if(crit_message)
			owner.next_attack_msg.Cut()
			owner.next_attack_msg += span_crit(" Critical resistance!" + resist_msg)
		return TRUE

	// We want to apply knockout AFTER resistance check so you don't need two rolls to resist.
	if(try_knockout)
		owner.next_attack_msg += " <span class='crit'><b>Critical hit!</b> [owner] is knocked out[from_behind ? " FROM BEHIND" : ""]!</span>"
		owner.flash_fullscreen("whiteflash3")
		owner.Unconscious(5 SECONDS + (from_behind * 10 SECONDS))
		if(owner.client)
			winset(owner.client, "outputwindow.output", "max-lines=1")
			winset(owner.client, "outputwindow.output", "max-lines=100")

	for(var/wound_type in shuffle(attempted_wounds))
		var/datum/wound/applied = add_wound(wound_type, silent, crit_message)
		if(applied)
			if(user?.client)
				record_round_statistic(STATS_CRITS_MADE)
			return applied
	return FALSE

/// Embeds an object in this bodypart
/obj/item/bodypart/proc/add_embedded_object(obj/item/embedder, silent = FALSE, crit_message = FALSE, ranged = FALSE)
	if(!embedder || !can_embed(embedder))
		return FALSE
	if(owner && ((owner.status_flags & GODMODE) || HAS_TRAIT(owner, TRAIT_PIERCEIMMUNE)))
		return FALSE
	if(istype(embedder, /obj/item/natural/worms/leech))
		record_round_statistic(STATS_LEECHES_EMBEDDED)
	LAZYADD(embedded_objects, embedder)
	embedder.is_embedded = TRUE
	embedder.forceMove(src)
	if(owner)
		embedder.add_mob_blood(owner)
		if (!silent)
			if(!ranged)
				playsound(owner, 'sound/combat/newstuck.ogg', 100, vary = TRUE)
			if (owner.has_status_effect(/datum/status_effect/buff/ozium))
				owner.emote ("exhales")
			if (owner.has_status_effect(/datum/status_effect/buff/drunk) && !owner.has_status_effect(/datum/status_effect/buff/ozium))
				owner.emote("pain")
			if (!owner.has_status_effect(/datum/status_effect/buff/drunk) && !owner.has_status_effect(/datum/status_effect/buff/ozium))
				owner.emote("embed")
		if(crit_message)
			owner.next_attack_msg += " <span class='userdanger'>[embedder] runs through [owner]'s [src]!</span>"
			if(ranged)
				playsound(owner, 'sound/combat/brutal_impalement.ogg', 100, vary = TRUE)
		update_disabled()
		if(embedder.is_silver && HAS_TRAIT(owner, TRAIT_SILVER_WEAK) && !owner.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			var/datum/component/silverbless/psyblessed = embedder.GetComponent(/datum/component/silverbless)
			owner.adjust_fire_stacks(1, psyblessed?.is_blessed ? /datum/status_effect/fire_handler/fire_stacks/sunder/blessed : /datum/status_effect/fire_handler/fire_stacks/sunder)
			to_chat(owner, span_danger("the [embedder] in your body painfully jostles!"))
	return TRUE

/// Removes an embedded object from this bodypart
/obj/item/bodypart/proc/remove_embedded_object(obj/item/embedder)
	if(!embedder)
		return FALSE
	if(ispath(embedder))
		embedder = has_embedded_object(embedder)
	if(!istype(embedder) || !is_object_embedded(embedder))
		return FALSE
	LAZYREMOVE(embedded_objects, embedder)
	embedder.is_embedded = FALSE
	var/drop_location = owner?.drop_location() || drop_location()
	if(drop_location)
		embedder.forceMove(drop_location)
	else
		qdel(embedder)
	if(owner)
		if(!owner.has_embedded_objects())
			owner.clear_alert("embeddedobject")
		update_disabled()
	return TRUE

/obj/item/bodypart/proc/try_bandage(obj/item/new_bandage)
	if(!new_bandage)
		return FALSE
	bandage = new_bandage
	new_bandage.forceMove(src)
	return TRUE

/obj/item/bodypart/proc/process_bandage(bleed_rate)
	if(!bandage)
		return FALSE
	var/obj/item/natural/cloth/cloth = bandage
	if(istype(cloth) && cloth.medicine_quality)
		if(cloth.medicine_amount >= 0)
			heal_wounds(cloth.medicine_quality * 1)
			heal_damage(cloth.medicine_quality * 1, cloth.medicine_quality * 1, 0, null, FALSE)
			cloth.medicine_amount -= 0.25
		else
			cloth.medicine_amount = 0
			cloth.medicine_quality = 0
			cloth.detail_color = null
			cloth.desc = initial(cloth.desc)
			cloth.update_icon()
	if(!bleed_rate)
		return FALSE
	var/bandage_health = 1
	if(istype(cloth))
		cloth.bandage_health -= bleed_rate
		bandage_health = cloth.bandage_health
	if(bandage_health <= 0)
		return bandage_expire()
	return FALSE

/obj/item/bodypart/proc/bandage_expire()
	if(!owner)
		return FALSE
	if(!bandage)
		return FALSE
	if(owner.stat != DEAD)
		owner.visible_message(span_warning("Blood soaks through the bandage on [owner]'s [name]."), span_warning("Blood soaks through the bandage on my [name]."), vision_distance = 3)
	return bandage.add_mob_blood(owner)

/obj/item/bodypart/proc/remove_bandage()
	if(!bandage)
		return FALSE
	var/drop_location = owner?.drop_location() || drop_location()
	if(drop_location)
		bandage.forceMove(drop_location)
	else
		qdel(bandage)
	bandage = null
	owner?.update_damage_overlays()
	return TRUE

/// Applies a temporary paralysis effect to this bodypart
/obj/item/bodypart/proc/temporary_crit_paralysis(duration = 60 SECONDS, brittle = TRUE)
	if(HAS_TRAIT(src, TRAIT_BRITTLE))
		return FALSE
	ADD_TRAIT(src, TRAIT_PARALYSIS, CRIT_TRAIT)
	if(brittle)
		ADD_TRAIT(src, TRAIT_BRITTLE, CRIT_TRAIT)
	addtimer(CALLBACK(src, PROC_REF(remove_crit_paralysis)), duration)
	if(owner)
		update_disabled()
	return TRUE

/// Removes the temporary paralysis effect from this bodypart
/obj/item/bodypart/proc/remove_crit_paralysis()
	REMOVE_TRAIT(src, TRAIT_PARALYSIS, CRIT_TRAIT)
	REMOVE_TRAIT(src, TRAIT_BRITTLE, CRIT_TRAIT)
	if(owner)
		update_disabled()
	return TRUE

/// Returns surgery flags applicable to this bodypart
/obj/item/bodypart/proc/get_surgery_flags()
	// oh sweet mother of christ what the FUCK is this. this is called EVERY TIME BLEED RATE IS CHECKED.
	var/returned_flags = NONE
	if(can_bloody_wound())
		returned_flags |= SURGERY_BLOODY
	for(var/datum/wound/slash/incision/incision in wounds)
		if(incision.is_sewn())
			continue
		returned_flags |= SURGERY_INCISED
		break
	var/static/list/retracting_behaviors = list(
		TOOL_RETRACTOR,
		TOOL_CROWBAR,
		TOOL_IMPROVISED_RETRACTOR,
	)
	var/static/list/clamping_behaviors = list(
		TOOL_HEMOSTAT,
		TOOL_WIRECUTTER,
		TOOL_IMPROVISED_HEMOSTAT,
	)
	for(var/obj/item/embedded as anything in embedded_objects)
		if((embedded.tool_behaviour in retracting_behaviors) || embedded.embedding?.retract_limbs)
			returned_flags |= SURGERY_RETRACTED
		if((embedded.tool_behaviour in clamping_behaviors) || embedded.embedding?.clamp_limbs)
			returned_flags |= SURGERY_CLAMPED
	if(has_wound(/datum/wound/dislocation))
		returned_flags |= SURGERY_DISLOCATED
	if(has_wound(/datum/wound/fracture))
		returned_flags |= SURGERY_BROKEN
	if(has_wound(/datum/wound/slash/vein))
		returned_flags |= SURGERY_CUTVEIN
	for(var/datum/wound/puncture/drilling/drilling in wounds)
		if(drilling.is_sewn())
			continue
		returned_flags |= SURGERY_DRILLED
	if(skeletonized)
		returned_flags |= SURGERY_INCISED | SURGERY_RETRACTED | SURGERY_DRILLED //ehh... we have access to whatever organ is there
	return returned_flags

/* Check for critical resistance and trigger its effects.
	Return TRUE if critical resistance was triggered, false if it don't work
*/
/mob/living/proc/try_resist_critical()
	var/resistance = HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE)
	if(!resistance)
		return FALSE

	var/crit_resist_tracker = has_status_effect(/datum/status_effect/debuff/crit_resistance_cd)

	if(!crit_resist_tracker)
		apply_status_effect(/datum/status_effect/debuff/crit_resistance_cd)
		return TRUE // One chance were used and it was added
	else
		var/datum/status_effect/debuff/crit_resistance_cd/crit_resist_tracker_actual = crit_resist_tracker
		// Iterate stack by 1 and then see if we can crit this hit
		return !crit_resist_tracker_actual.try_crit()
