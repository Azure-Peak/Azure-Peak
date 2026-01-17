/*
		Component used in place of AdjustClothes() proc where it's meant to be a toggle between two simple states with changes in basic flags.
		It hooks into attack_right and toggles between states, swapping flags, FOV fields and coverage as needed.
		Note: The component assumes the item's default state (sprite & flags wise) is "ON". IE visor closed, hood on, coif on, mask on etc.
		Make sure to adjust your inv flags & body coverage accordingly.
*/
/datum/component/adjustable_clothing
	///Body coverage zones (For armor) it should have when open. body_coverage_dynamic will take these.
	var/flags_open
	///flags_inv the object will have if toggled open.
	var/flags_inv_open
	///flags_cover the object will have if toggled open. This is NOT armor. This is for covering your mouth for eating / face for identity, etc.
	var/flags_cover_open
	///Dynamic variable that keeps track of any missing coverage zones and applies them to either applicable state. Do not change this.
	var/flags_removed
	///Sound to be played on toggle.
	var/toggle_sound
	///Whether the object is toggled open or not. Defaults to FALSE aka it's "closed".
	var/toggled_open = FALSE
	///The block2add the item is meant to have on toggle.
	var/fov_open = null
	///Inv. update flags
	var/update_flags

/datum/component/adjustable_clothing/Initialize(arg_open_flags, arg_inv_flags, arg_cover_flags, arg_sound, arg_fov, arg_update_flags)
	if(!isclothing(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_RIGHT, PROC_REF(on_attack_right))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	flags_open = arg_open_flags
	flags_inv_open = arg_inv_flags
	flags_cover_open = arg_cover_flags
	toggle_sound = arg_sound
	fov_open = arg_fov
	update_flags = arg_update_flags

/datum/component/adjustable_clothing/proc/on_attack_right(mob/user)
	var/obj/item/clothing/clothing_parent = parent
	var/mob/living/carbon/human/human_wearer
	if(ishuman(clothing_parent.loc))
		human_wearer = clothing_parent.loc
	else if(istype(clothing_parent.loc, /obj/item/clothing/head))
		var/obj/item/clothing/head/hat = clothing_parent.loc
		if(ishuman(hat.loc))
			human_wearer = hat.loc
	if(!human_wearer)
		return
	if(clothing_parent.adjustable != CAN_CADJUST)
		return
	if(toggled_open)	//We're open, so we'll close
		toggle_closed(clothing_parent)
	else
		toggle_open(clothing_parent)
	if(toggle_sound)
		playsound(get_turf(clothing_parent), toggle_sound, 50, TRUE, -1)
	clothing_parent.update_icon()
	update_inv(human_wearer)
	human_wearer.update_fov_angles()

//We force it closed to make sure we can't equip an opened item if one IS on the ground somehow.
/datum/component/adjustable_clothing/proc/on_equip(datum/source, mob/user, slot)
	var/obj/item/clothing/C = parent
	if(!ishuman(C.loc))
		return
	toggle_closed(C, forced = TRUE)
	var/mob/living/carbon/human/H = C.loc
	H.update_fov_angles()

//We force it closed to make sure an opened item cannot be dropped.
//In both of these cases it's to prevent fringe bugs with coverage.
/datum/component/adjustable_clothing/proc/on_drop(datum/source, mob/user)
	var/obj/item/clothing/C = parent
	if(!ishuman(C.loc))
		return
	toggle_closed(C, forced = TRUE)
	var/mob/living/carbon/human/H = C.loc
	H.update_fov_angles()

/datum/component/adjustable_clothing/proc/toggle_open(obj/item/clothing/C, forced = FALSE)
	if(!forced)	//We skip this if we're equipping or dropping the item to prevent coverage glitches.
		if(!(C.body_parts_covered_dynamic == C.body_parts_covered))	//Our coverage does not match.
			flags_removed = (C.body_parts_covered - C.body_parts_covered_dynamic)	//We store the difference.
		else if(C.body_parts_covered_dynamic == C.body_parts_covered && C.body_parts_covered_dynamic & flags_removed)	//We match AND _dynamic has our stored flags. Means the coverage was repaired.
			flags_removed = null
	C.body_parts_covered_dynamic = flags_open
	C.body_parts_covered_dynamic &= ~flags_removed
	C.flags_inv = flags_inv_open
	C.flags_cover = flags_cover_open
	C.block2add = fov_open
	C.icon_state = "[initial(C.icon_state)]_t"
	toggled_open = TRUE

/datum/component/adjustable_clothing/proc/toggle_closed(obj/item/clothing/C, forced = FALSE)
	if(!forced)
		if(!(C.body_parts_covered_dynamic == flags_open))
			flags_removed = flags_open - C.body_parts_covered_dynamic
		else if(C.body_parts_covered_dynamic == flags_open && C.body_parts_covered_dynamic & flags_removed)
			flags_removed = null
	C.body_parts_covered_dynamic = C.body_parts_covered
	C.body_parts_covered_dynamic &= ~flags_removed
	C.flags_inv = initial(C.flags_inv)
	C.flags_cover = initial(C.flags_cover)
	C.block2add = initial(C.block2add)
	C.icon_state = "[initial(C.icon_state)]"
	toggled_open = FALSE

/datum/component/adjustable_clothing/proc/update_inv(mob/living/carbon/human/H)
	if(update_flags & (UPD_HEAD|UPD_MASK|UPD_NECK))
		H.update_inv_head()
		H.update_inv_wear_mask()
		H.update_inv_neck()
		return
	if(update_flags & (UPD_HEAD|UPD_MASK))
		H.update_inv_head()
		H.update_inv_wear_mask()
		return
	if(update_flags & (UPD_MASK|UPD_NECK))
		H.update_inv_wear_mask()
		H.update_inv_neck()
		return
	if(update_flags & UPD_HEAD)
		H.update_inv_head()
		return
	if(update_flags & UPD_NECK)
		H.update_inv_neck()
		return
	if(update_flags & UPD_MASK)
		H.update_inv_wear_mask()
		return
