/obj/item/organ/dullahan_vision
	name = "Revenant Vision"
	actions_types = list(/datum/action/item_action/organ_action/use)
	slot = ORGAN_SLOT_HUD
	organ_flags = ORGAN_SURGERY_HIDDEN | ORGAN_INTERNAL_ONLY
	var/viewing_head = FALSE
	/// The last unmodified tint.
	var/last_tint = 0

/obj/item/organ/dullahan_vision/proc/get_eyes()
	RETURN_TYPE(/obj/item/organ/eyes)
	var/mob/living/carbon/human/user = owner
	if(!isdullahan(user))
		return

	var/datum/species/dullahan/user_species = user.dna.species
	var/obj/item/bodypart/head/dullahan/user_head = user_species.my_head
	var/obj/item/organ/eyes/user_eyes = user_head.eyes
	return user_eyes

// get_total_tint automatically blinds us if we're viewing the body. 
// While viewing the head the tint needs to be updated manually.
/obj/item/organ/dullahan_vision/proc/become_blind()
	var/mob/living/carbon/human/human = owner
	var/obj/item/organ/eyes/user_eyes = get_eyes()
	if(!user_eyes)
		return

	if(user_eyes.tint <= 100)
		last_tint = user_eyes.tint
		user_eyes.tint = 200
	human.update_fov_angles()
	human.update_sight()

/obj/item/organ/dullahan_vision/proc/cure_blind()
	var/mob/living/carbon/human/human = owner
	var/obj/item/organ/eyes/user_eyes = get_eyes()
	if(!user_eyes)
		return
	if(user_eyes.tint >= 100)
		user_eyes.tint = last_tint
	human.update_fov_angles()
	human.update_sight()

/obj/item/organ/dullahan_vision/ui_action_click(owner)
	var/mob/living/carbon/human/user = owner

	if(!isdullahan(user))
		return

	var/datum/species/dullahan/user_species = user.dna.species
	if(!user_species.headless)
		return

	var/obj/item/bodypart/head/dullahan/head = user_species.my_head

	//Body view (default, curse border) <-> looking through the head (clean).
	if(viewing_head)
		viewing_head = FALSE
		user.reset_perspective()
	else
		viewing_head = TRUE
		user.reset_perspective(head)
	// get_total_tint() keys off viewing_head; without a recompute the old vision state
	// (computed while the flag pointed the other way) simply persists.
	user.update_sight()
