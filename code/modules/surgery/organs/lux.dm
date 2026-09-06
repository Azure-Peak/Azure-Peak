/obj/item/organ/lux
	name = "lux gland"
	desc = "A faintly glowing gland, warm to the touch. The vessel of one's lyfe-essence."
	icon_state = "appendix"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LUX
	attack_verb = list("smothered", "smeared")

	medical_organ = TRUE
	healing_factor = 0
	decay_factor = 0

	/// Maximum augmentation budget (animal-organ implant cost) a fully healthy lux can host.
	var/augment_capacity = 100
	/// Currently consumed augmentation budget (sum of implanted animal-organ costs).
	var/augment_used = 0
	/// Trait management source for lux-driven traits.
	var/static/lux_source = "lux_organ"

/obj/item/organ/lux/proc/effective_capacity()
	switch(injury)
		if(ORGAN_INJURY_MINOR)
			return round(augment_capacity * 0.75)
		if(ORGAN_INJURY_SEVERE)
			return round(augment_capacity * 0.4)
		if(ORGAN_INJURY_DEAD)
			return 0
	return augment_capacity

/obj/item/organ/lux/proc/remaining_capacity()
	return effective_capacity() - augment_used

/obj/item/organ/lux/proc/on_overaugment()
	return

/obj/item/organ/lux/on_injury_changed()
	if(!owner)
		return
	if(injury == ORGAN_INJURY_DEAD)
		ADD_TRAIT(owner, TRAIT_DNR, lux_source)
	else
		REMOVE_TRAIT(owner, TRAIT_DNR, lux_source)
	switch(injury)
		if(ORGAN_INJURY_MINOR)
			to_chat(owner, span_warning("My inner light dims; I feel a little less... whole."))
		if(ORGAN_INJURY_SEVERE)
			to_chat(owner, span_danger("My lux flickers wildly - the world warps and crawls at the edges of my sight!"))
		if(ORGAN_INJURY_DEAD)
			to_chat(owner, span_userdanger("My lux gutters out. My hold on this lyfe is broken."))
		if(ORGAN_INJURY_NONE)
			to_chat(owner, span_info("My inner light steadies and warms."))

/obj/item/organ/lux/apply_injury_effects()
	if(!owner)
		return
	if(injury == ORGAN_INJURY_SEVERE)
		owner.hallucination = max(owner.hallucination, 20)
	if(remaining_capacity() < 0)	//capacity shrank with injury - let the augment system react
		on_overaugment()

/obj/item/organ/lux/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	if(M)	//missing lux behaves like a dead lux: the body is beyond revival
		ADD_TRAIT(M, TRAIT_DNR, lux_source)
	return ..()
