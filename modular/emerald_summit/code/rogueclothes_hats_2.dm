// Emerald Summit port — extracted from modular_stonehedge/code/modules/clothing/rogueclothes/hats.dm
// Armor lists translated from ES's 0-100 percentages to Valmorian's tier defines:
// the padded hood sits at hardened-leather level, the studded hood matches studded body armor.

/obj/item/clothing/head/roguetown/helmet/leather/armorhood
	name = "padded leather hood"
	desc = "A padded leather hood with buckles."
	icon = 'modular/emerald_summit/icons/stonehedge_head.dmi'
	mob_overlay_icon = 'modular/emerald_summit/icons/stonehedge_head_onmob.dmi'
	icon_state = "studhood"
	item_state = "studhood"
	flags_inv =	HIDEHAIR|HIDEEARS|HIDEFACE
	slot_flags = ITEM_SLOT_NECK|ITEM_SLOT_HEAD
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES|NECK
	armor = ARMOR_LEATHER
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	overarmor = FALSE

/obj/item/clothing/head/roguetown/helmet/leather/armorhood/advanced
	name = "studded leather hood"
	desc = "A thick studded leather hood with buckles."
	icon_state = "studhood" //make into new sprite
	item_state = "studhood"
	max_integrity = 280
	armor = ARMOR_BRIGANDINE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_CHOP, BCLASS_SMASH) //studded armor values with stab prot too

/obj/item/clothing/head/roguetown/helmet/leather/armorhood/AdjustClothes(mob/user)
	if(loc == user)
		if(adjustable == CAN_CADJUST)
			adjustable = CADJUSTED
			if(toggle_icon_state)
				icon_state = "[initial(icon_state)]_t"
			flags_inv = null
			body_parts_covered = NECK
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				H.update_inv_head()
				H.update_inv_neck()
		else if(adjustable == CADJUSTED)
			ResetAdjust(user)
			flags_inv =	initial(flags_inv)
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/human/H = user
					H.update_inv_head()
					H.update_inv_neck()
		// The legacy toggle only moved the static body_parts_covered, so a hood pulled down to the
		// neck still "covered" the head/face for armor, surgery and drinking checks (which read
		// body_parts_covered_dynamic). Sync the live coverage to match.
		body_parts_covered_dynamic = body_parts_covered

/obj/item/clothing/head/roguetown/helmet/leather/armorhood/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	overarmor = !overarmor
	to_chat(user, span_info("I [overarmor ? "wear \the [src] under my hair" : "wear \the [src] over my hair"]."))
	if(overarmor)
		alternate_worn_layer = HOOD_LAYER //Below Hair Layer
		flags_inv &= ~HIDE_HEADTOP
	else
		alternate_worn_layer = BACK_LAYER //Above Hair Layer
		if(adjustable == CAN_CADJUST)
			flags_inv = initial(flags_inv)
	var/mob/living/carbon/human/H = user
	H.update_inv_head()
	H.update_inv_wear_mask()
	H.update_inv_neck()
