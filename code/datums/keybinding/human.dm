/datum/keybinding/human
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/human/down(client/user)
	if(!iscarbon(user.mob))
		return FALSE
	return TRUE

// Left commented because quick equip can put items into slots that are not in the UI, blame Roguetown.
/* /datum/keybinding/human/quick_equip
	hotkey_keys = list() // Keeping it empty lets the user set their own keybind since E is used
	name = "quick_equip"
	full_name = "Quick Equip"
	description = "Quickly puts an item in the best slot available"

/datum/keybinding/human/quick_equip/down(client/user)
	var/mob/living/carbon/human/H = user.mob
	H.quick_equip()
	return TRUE */

/datum/keybinding/human/quick_equipbelt
	hotkey_keys = list("ShiftB")
	name = "quick_equipbelt"
	full_name = "Quick equip belt"
	description = "Put held thing in belt or take out most recent thing from belt"

/datum/keybinding/human/quick_equipbelt/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbelt()
	return TRUE

/datum/keybinding/human/quick_equipcloak
    hotkey_keys = list("ShiftN")
    name = "quick_equipcloak"
    full_name = "Quick equip cloak"
    description = "Put held thing in cloak or take out most recent thing from cloak"

/datum/keybinding/human/quick_equipcloak/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipcloak()
	return TRUE

/datum/keybinding/human/bag_equip_backl
	hotkey_keys = list("ShiftQ")
	name = "bag_equip_backl"
	full_name = "Bag Equip Left"
	description = "Put held item in the left backpack slot or take out the most recent item from the left backpack slot"

/datum/keybinding/human/bag_equip_backl/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbag(SLOT_BACK_R) // These fucking shits are reversed in the UI, so keep it like this for symmetry
	return TRUE

/datum/keybinding/human/bag_equip_backr
	hotkey_keys = list("ShiftE")
	name = "bag_equip_backr"
	full_name = "Bag Equip Right"
	description = "Put held item in the right backpack slot or take out the most recent item from the right backpack slot"

/datum/keybinding/human/bag_equip_backr/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbag(SLOT_BACK_L) // These fucking shits are reversed in the UI, so keep it like this for symmetry
	return TRUE

/datum/keybinding/human/bag_equip_beltl
	hotkey_keys = list("AltQ")
	name = "bag_equip_beltl"
	full_name = "Belt Equip Left"
	description = "Put held item in the left belt slot or take out the most recent item from the left belt slot"

/datum/keybinding/human/bag_equip_beltl/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbag(SLOT_BELT_R)
	return TRUE

/datum/keybinding/human/bag_equip_beltr
	hotkey_keys = list("AltE")
	name = "bag_equip_beltr"
	full_name = "Belt Equip Right"
	description = "Put held item in the right belt slot or take out the most recent item from the right belt slot"

/datum/keybinding/human/bag_equip_beltr/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.smart_equipbag(SLOT_BELT_L)
	return TRUE

/datum/keybinding/human/fixeye
	hotkey_keys = list("F")
	name = "fix_eye"
	full_name = "Fixed Eye"
	description = "Focus in a direction."

/datum/keybinding/human/fixeye/down(client/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/H = user.mob
	H.toggle_eye_intent(H)
	return TRUE
