/obj/item/clothing/head/roguetown
	name = "hat"
	desc = ""
	icon = 'icons/roguetown/clothing/head.dmi'
	icon_state = "top_hat"
	item_state = "that"
	body_parts_covered = HEAD|HAIR
	body_parts_inherent = HEAD
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	dynamic_hair_suffix = "+generic"
	bloody_icon_state = "helmetblood"
	experimental_onhip = FALSE
	/// Override if we want to always respect our inv flags if the helm is in a mask slot.
	var/mask_override = FALSE
	experimental_inhand = TRUE
	var/hidesnoutADJ = FALSE
	/// Tracks if we're currently over or under the armor layer. Mainly used for the feedback message.
	var/overarmor = TRUE
	throw_on_break = TRUE

/obj/item/clothing/head/roguetown/get_detail_state(base_state)
	if(!base_state)
		return base_state
	if(findtext(base_state, "_s_t"))
		return replacetext(base_state, "_s_t", "_t")
	if(copytext(base_state, -2) == "_s")
		return copytext(base_state, 1, -2)
	return base_state

/obj/item/clothing/head/roguetown/equipped(mob/user, slot)
	. = ..()
	user.update_fov_angles()
	if(slot != SLOT_HEAD && !mask_override)
		flags_inv = null
	else
		flags_inv = adjust_inv_flags(initial(flags_inv))
	restore_snout()

/obj/item/clothing/head/roguetown/dropped(mob/user)
	. = ..()
	user.update_fov_angles()

/obj/item/clothing/head/roguetown/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Middle-clicking headwear cycles ears/horns/hair visual.")

/obj/item/clothing/head/roguetown/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	cycle_headtop(user)

/obj/item/clothing/head/roguetown/proc/cycle_headtop(mob/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/organ/ears = H.getorganslot(ORGAN_SLOT_EARS)
	var/obj/item/organ/horns = H.getorganslot(ORGAN_SLOT_HORNS) || H.getorganslot(ORGAN_SLOT_FRILLS)
	var/hasears = ears?.accessory_type
	var/hashorns = horns?.accessory_type
	var/list/steps = list(HIDE_HEADTOP)
	if(hasears)
		steps += HIDEHAIR
	if(hashorns)
		steps += HIDE_HEADTOP|SHOWHORNS
	if(hasears && hashorns)
		steps += HIDEHAIR|SHOWHORNS
	steps += NONE
	var/next = steps[(steps.Find(flags_inv & (HIDE_HEADTOP|SHOWHORNS)) % length(steps)) + 1]
	flags_inv = (flags_inv & ~(HIDE_HEADTOP|SHOWHORNS)) | next
	switch(next)
		if(HIDE_HEADTOP)
			to_chat(user, span_info("I tuck my hair[hasears ? (hashorns ? ", ears and horns" : " and ears") : (hashorns ? " and horns" : "")] under \the [src]."))
		if(HIDEHAIR)
			to_chat(user, span_info("I free my ears from under \the [src]."))
		if(HIDE_HEADTOP|SHOWHORNS)
			to_chat(user, span_info("I [hasears ? "tuck my ears back and " : ""]free my horns from under \the [src]."))
		if(HIDEHAIR|SHOWHORNS)
			to_chat(user, span_info("I free my ears and horns from under \the [src]."))
		else
			to_chat(user, span_info("I pull my hair out from under \the [src]."))
	persist_inv_flags(HIDE_HEADTOP|SHOWHORNS)
	user.update_inv_head()
