/obj/item/organ/bone
	name = "bone"
	desc = "NYAHHAHAHAAHAHAH"
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "bone"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_CHEST

	healing_factor = 0
	decay_factor = 0

	/// Current fracture tier (BONE_FRACTURE_NONE/MINOR/MAJOR).
	var/fracture = BONE_FRACTURE_NONE
	/// Organ slots this bone shields. A MAJOR fracture exposes these organs to organ-crits.
	var/list/protects
	/// Click-cooldown penalty (ds) this bone is currently applying to its owner, so it can be removed cleanly.
	var/click_penalty = 0
	/// If TRUE (ribcage/skull), a MAJOR fracture makes moving around hurt.
	var/move_hurts = FALSE

/obj/item/organ/bone/proc/get_pain()
	return 0

/obj/item/organ/bone/proc/is_minor_fracture()
	return fracture == BONE_FRACTURE_MINOR

/obj/item/organ/bone/proc/is_major_fracture()
	return fracture == BONE_FRACTURE_MAJOR

/obj/item/organ/bone/proc/is_fractured()
	return fracture != BONE_FRACTURE_NONE

/obj/item/organ/bone/proc/set_fracture(new_state, force = FALSE)
	if(new_state == fracture)
		return
	// Crits can only escalate; only surgery (force) may mend a bone.
	if(!force && new_state < fracture)
		return
	fracture = new_state
	on_fracture_changed()
	apply_fracture_effects()
	update_injury_appearance()

/obj/item/organ/bone/update_injury_appearance()
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			paint_wound_wash(COLOR_ORGAN_WOUND_MINOR)
		if(BONE_FRACTURE_MAJOR)
			paint_wound_wash(COLOR_ORGAN_WOUND_SEVERE)
		else
			paint_wound_wash(null)

/obj/item/organ/bone/proc/mend()
	set_fracture(BONE_FRACTURE_NONE, force = TRUE)

/obj/item/organ/bone/proc/fracture_from_hit(big_hit = FALSE)
	if(owner)
		if(HAS_TRAIT(owner, TRAIT_FRAIL_BONES))
			big_hit = TRUE
		else if(HAS_TRAIT(owner, TRAIT_TOUGH_BONES))
			if(prob(60))
				return
			big_hit = FALSE
	switch(fracture)
		if(BONE_FRACTURE_NONE)
			set_fracture(big_hit ? BONE_FRACTURE_MAJOR : BONE_FRACTURE_MINOR)
		if(BONE_FRACTURE_MINOR)
			set_fracture(BONE_FRACTURE_MAJOR)

/obj/item/organ/bone/proc/on_fracture_changed()
	if(!owner)
		return
	clear_fracture_effects()
	apply_fracture_state()
	if(move_hurts && is_major_fracture())
		RegisterSignal(owner, COMSIG_MOVABLE_MOVED, PROC_REF(on_owner_moved), override = TRUE)
	owner.update_disabled_bodyparts()

/obj/item/organ/bone/proc/on_owner_moved(datum/source)
	SIGNAL_HANDLER
	if(!owner || owner.stat)
		return
	owner.stamina_add(3)
	if(prob(20))
		INVOKE_ASYNC(owner, TYPE_PROC_REF(/mob, emote), "painmoan")

/obj/item/organ/bone/proc/clear_fracture_effects()
	if(!owner)
		return
	UnregisterSignal(owner, COMSIG_MOVABLE_MOVED)
	if(click_penalty)
		owner.next_move_adjust -= click_penalty
		click_penalty = 0

/obj/item/organ/bone/proc/apply_fracture_state()
	return

/obj/item/organ/bone/proc/apply_fracture_effects()
	return

/obj/item/organ/bone/on_life()
	if(isnull(owner))
		return
	if(is_fractured())
		apply_fracture_effects()
		if(is_minor_fracture() && prob(MINOR_ORGAN_RECOVERY_PROB) && owner.is_recuperating())
			set_fracture(BONE_FRACTURE_NONE, force = TRUE)

/obj/item/organ/bone/Insert(mob/living/carbon/M, special = 0, drop_if_replaced = TRUE)
	. = ..()
	clear_fracture_effects()
	for(var/guarded_slot in protects)
		var/obj/item/organ/guarded = owner?.getorganslot(guarded_slot)
		guarded?.exposed = FALSE

/obj/item/organ/bone/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	if(owner)
		if(special)
			clear_fracture_effects()
		else
			set_fracture(BONE_FRACTURE_MAJOR)
			for(var/guarded_slot in protects)
				var/obj/item/organ/guarded = owner.getorganslot(guarded_slot)
				guarded?.exposed = TRUE
	return ..()

/obj/item/organ/bone/enter_wardrobe()
	fracture = initial(fracture)
	return ..()


/obj/item/organ/bone/skull
	name = "skull"
	desc = "A skull, the hard casing for the brain."
	icon_state = "bone"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_BONE_SKULL
	protects = list(ORGAN_SLOT_BRAIN)
	move_hurts = TRUE

/obj/item/organ/bone/nose
	name = "nasal bone"
	desc = "The slender bones of the nose and eye sockets."
	icon_state = "bone"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_BONE_NOSE
	protects = list(ORGAN_SLOT_EYES)

/obj/item/organ/bone/jaw
	name = "jawbone"
	desc = "A mandible, anchor of the tongue and teeth."
	icon_state = "bone"
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_BONE_JAW
	protects = list(ORGAN_SLOT_TONGUE)

/obj/item/organ/bone/ribcage
	name = "ribcage"
	desc = "A cage of ribs guarding the chest's vital organs."
	icon_state = "bone"	//no distinct ribcage sprite - generic bone (distinguished by name)
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BONE_RIBCAGE
	protects = list(ORGAN_SLOT_LUNGS, ORGAN_SLOT_HEART, ORGAN_SLOT_LUX)
	move_hurts = TRUE

/obj/item/organ/bone/spine
	name = "spine"
	desc = "A column of vertebrae."
	icon_state = "bone"
	zone = BODY_ZONE_PRECISE_NECK
	slot = ORGAN_SLOT_BONE_SPINE
	protects = null

/obj/item/organ/bone/arm
	name = "arm bone"
	icon_state = "bone"
	zone = BODY_ZONE_L_ARM
	slot = ORGAN_SLOT_BONE_L_ARM

/obj/item/organ/bone/arm/right
	zone = BODY_ZONE_R_ARM
	slot = ORGAN_SLOT_BONE_R_ARM

/obj/item/organ/bone/leg
	name = "leg bone"
	icon_state = "bone"
	zone = BODY_ZONE_L_LEG
	slot = ORGAN_SLOT_BONE_L_LEG

/obj/item/organ/bone/leg/right
	zone = BODY_ZONE_R_LEG
	slot = ORGAN_SLOT_BONE_R_LEG


// LEG - Minor: additive slowdown. Major: paralyses the leg.
/obj/item/organ/bone/leg/clear_fracture_effects()
	..()
	if(!owner)
		return
	var/move_id = (zone == BODY_ZONE_R_LEG) ? MOVESPEED_ID_FRACTURE_RIGHT_LEG : MOVESPEED_ID_FRACTURE_LEFT_LEG
	var/para_trait = (zone == BODY_ZONE_R_LEG) ? TRAIT_PARALYSIS_R_LEG : TRAIT_PARALYSIS_L_LEG
	owner.remove_movespeed_modifier(move_id)
	REMOVE_TRAIT(owner, para_trait, slot)

/obj/item/organ/bone/leg/apply_fracture_state()
	if(!owner)
		return
	var/move_id = (zone == BODY_ZONE_R_LEG) ? MOVESPEED_ID_FRACTURE_RIGHT_LEG : MOVESPEED_ID_FRACTURE_LEFT_LEG
	var/para_trait = (zone == BODY_ZONE_R_LEG) ? TRAIT_PARALYSIS_R_LEG : TRAIT_PARALYSIS_L_LEG
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			owner.add_movespeed_modifier(move_id, multiplicative_slowdown = FRACTURED_ADD_SLOWDOWN)
			to_chat(owner, span_warning("My leg throbs - I can barely put weight on it."))
		if(BONE_FRACTURE_MAJOR)
			ADD_TRAIT(owner, para_trait, slot)
			to_chat(owner, span_userdanger("My leg gives out beneath me - I cannot stand!"))

// ARM - Minor: heavier click cooldown on everything. Major: paralyses the arm (can't hold/use).
/obj/item/organ/bone/arm/clear_fracture_effects()
	..()
	if(!owner)
		return
	var/para_trait = (zone == BODY_ZONE_R_ARM) ? TRAIT_PARALYSIS_R_ARM : TRAIT_PARALYSIS_L_ARM
	REMOVE_TRAIT(owner, para_trait, slot)

/obj/item/organ/bone/arm/apply_fracture_state()
	if(!owner)
		return
	var/para_trait = (zone == BODY_ZONE_R_ARM) ? TRAIT_PARALYSIS_R_ARM : TRAIT_PARALYSIS_L_ARM
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			click_penalty = 3
			owner.next_move_adjust += click_penalty
			to_chat(owner, span_warning("My arm aches - it answers my commands slow and clumsy."))
		if(BONE_FRACTURE_MAJOR)
			ADD_TRAIT(owner, para_trait, slot)
			to_chat(owner, span_userdanger("My arm hangs limp and useless - I can grip nothing with it!"))

// SPINE - Minor: scrambles movement (drunk-walk, topped up each tick). Major: full paralysis.
/obj/item/organ/bone/spine/clear_fracture_effects()
	..()
	if(!owner)
		return
	REMOVE_TRAIT(owner, TRAIT_PARALYSIS, slot)
	REMOVE_TRAIT(owner, TRAIT_NOPAIN, slot)

/obj/item/organ/bone/spine/apply_fracture_state()
	if(!owner)
		return
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			to_chat(owner, span_warning("My spine sparks with wrong signals - my body lurches where I don't intend!"))
		if(BONE_FRACTURE_MAJOR)
			ADD_TRAIT(owner, TRAIT_PARALYSIS, slot)
			ADD_TRAIT(owner, TRAIT_NOPAIN, slot)
			to_chat(owner, span_userdanger("My spine snaps - the world below my neck goes still!"))

/obj/item/organ/bone/spine/apply_fracture_effects()
	if(!owner)
		return
	if(fracture == BONE_FRACTURE_MINOR)
		owner.confused = max(owner.confused, 10)

// RIBCAGE - Minor: extra pain (hurts more than any other fracture). Major: opens chest organ-crits.
/obj/item/organ/bone/ribcage/get_pain()
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			return 50
		if(BONE_FRACTURE_MAJOR)
			return 35
	return 0

/obj/item/organ/bone/ribcage/apply_fracture_state()
	if(!owner)
		return
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			to_chat(owner, span_warning("My ribs grate against each other - it hurts to so much as breathe."))
		if(BONE_FRACTURE_MAJOR)
			to_chat(owner, span_userdanger("My ribcage caves in - my chest lies open to a killing blow!"))

// SKULL (protects brain) - pain, plus blurred/disoriented vision applied additively with the brain in. Major: opens brain organ-crits.
/obj/item/organ/bone/skull/get_pain()
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			return 50
		if(BONE_FRACTURE_MAJOR)
			return 35
	return 0

/obj/item/organ/bone/skull/apply_fracture_state()
	if(!owner)
		return
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			to_chat(owner, span_warning("My skull throbs - my sight swims and my head spins."))
		if(BONE_FRACTURE_MAJOR)
			to_chat(owner, span_userdanger("My skull caves in - my brain lies open to a killing blow!"))

// NOSE (protects eyes) - Minor: pain. Major: disfigurement + opens eye organ-crits.
/obj/item/organ/bone/nose/get_pain()
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			return 40
		if(BONE_FRACTURE_MAJOR)
			return 25
	return 0

/obj/item/organ/bone/nose/clear_fracture_effects()
	..()
	if(!owner)
		return
	REMOVE_TRAIT(owner, TRAIT_DISFIGURED, slot)
	REMOVE_TRAIT(owner, TRAIT_MISSING_NOSE, slot)

/obj/item/organ/bone/nose/apply_fracture_state()
	if(!owner)
		return
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			to_chat(owner, span_warning("My nose breaks with a sickening crunch."))
		if(BONE_FRACTURE_MAJOR)
			ADD_TRAIT(owner, TRAIT_DISFIGURED, slot)
			ADD_TRAIT(owner, TRAIT_MISSING_NOSE, slot)
			to_chat(owner, span_userdanger("My eye sockets shatter, my face left a ruin - my eyes lie open to a killing blow!"))

// JAW (protects tongue) - Minor: pain. Major: no biting, gargled speech, eating/drinking can fail
// (jaw_disrupts_eating) + opens tongue organ-crits.
/obj/item/organ/bone/jaw/get_pain()
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			return 40
		if(BONE_FRACTURE_MAJOR)
			return 25
	return 0

/obj/item/organ/bone/jaw/clear_fracture_effects()
	..()
	if(!owner)
		return
	REMOVE_TRAIT(owner, TRAIT_NO_BITE, slot)
	REMOVE_TRAIT(owner, TRAIT_GARGLE_SPEECH, slot)

/obj/item/organ/bone/jaw/apply_fracture_state()
	if(!owner)
		return
	switch(fracture)
		if(BONE_FRACTURE_MINOR)
			to_chat(owner, span_warning("My jaw breaks - it aches to work my mouth at all."))
		if(BONE_FRACTURE_MAJOR)
			ADD_TRAIT(owner, TRAIT_NO_BITE, slot)
			ADD_TRAIT(owner, TRAIT_GARGLE_SPEECH, slot)
			to_chat(owner, span_userdanger("My jaw is shattered - my tongue lies open to a killing blow!"))
