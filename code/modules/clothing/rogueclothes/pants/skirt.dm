
/obj/item/clothing/under/roguetown/skirt
	name = "skirt"
	desc = "Long, flowing, and modest."
	icon_state = "skirt"
	item_state = "skirt"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/pants.dmi'
	sleevetype = "skirt"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_pants.dmi'
	alternate_worn_layer = (SHIRT_LAYER)
	salvage_amount = 1

/obj/item/clothing/under/roguetown/skirt/random
	name = "skirt"

/obj/item/clothing/under/roguetown/skirt/random/Initialize()
	color = pick("#6b5445", "#435436", "#704542", "#79763f", CLOTHING_BLUE)
	..()

/obj/item/clothing/under/roguetown/skirt/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Shift-right click while targeting either leg to tear a sleeve off, which can be used to bandage wounds in an emergency.")
	. += span_info("The chance to successfully tear a sleeve off scales with your character's Strength.")

/obj/item/clothing/under/roguetown/skirt/blue
	color = CLOTHING_BLUE

/obj/item/clothing/under/roguetown/skirt/green
	color = CLOTHING_GREEN

/obj/item/clothing/under/roguetown/skirt/red
	color = CLOTHING_RED

/obj/item/clothing/under/roguetown/skirt/brown
	color = CLOTHING_BROWN

/obj/item/clothing/under/roguetown/skirt/black
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/skirt/desert
	name = "desert skirt"
	desc = "At least it cools me off, but what of the modesty?"
	icon_state = "desertskirt"
	item_state = "desertskirt"

/obj/item/clothing/under/roguetown/skirt/baotha
	name = "saccharine fauldcoat"
	desc = "Only did Belladona's haze clear, once She heard Eora's gasps and Ravox's fright; what else could She've done besides fleeing the heavens?"
	armor = ARMOR_PADDED
	icon_state = "baothaskirt"
	chunkcolor = "#6d1c87"
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_LIGHT
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 150
	body_parts_covered = GROIN | LEGS
	smeltresult = /obj/item/ingot/component/baotha

/obj/item/clothing/under/roguetown/skirt/baotha/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_DEPRAVED, "SKIRT")
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/under/roguetown/skirt/baotha/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/under/roguetown/skirt/baotha/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_ALARMING, HERESYDESC_BAOTHA_ARMOR)

/obj/item/clothing/under/roguetown/skirt/courtphysician
	name = "sanguine skirt"
	desc = "An elegant velvet skirt that does you no good when running to someones aid."
	icon_state = "docskirt"
	item_state = "docskirt"
	icon = 'icons/roguetown/clothing/special/courtphys.dmi'
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_courtphys.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/courtphys.dmi'
	detail_tag = "_detail"
	detail_color = CLOTHING_RED
	alternate_worn_layer = (SHIRT_LAYER)
	salvage_result = /obj/item/natural/silk

/obj/item/clothing/under/roguetown/skirt/courtphysician/Initialize()
	. = ..()
	update_icon()

/obj/item/clothing/under/roguetown/skirt/courtphysician/update_icon()
	cut_overlays()
	if(get_detail_tag())
		var/mutable_appearance/pic = mutable_appearance(icon(icon, "[icon_state][detail_tag]"))
		pic.appearance_flags = RESET_COLOR
		if(get_detail_color())
			pic.color = get_detail_color()
		add_overlay(pic)

/obj/item/clothing/under/roguetown/skirt/gambeson
	name = "gambesoned kilt"
	desc = "Long, flowing, and modest; and more importantly, quilted for protection."
	icon_state = "patkilt"
	item_state = "patkilt"
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_LEG_LEATHER
	blocksound = SOFTUNDERHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	body_parts_covered = GROIN | LEGS
	cold_protection = 10
	color = "#ad977d"
	chunkcolor = "#978151"
	var/shiftable = TRUE
	var/shifted = FALSE

/obj/item/clothing/under/roguetown/skirt/gambeson/attack_right(mob/user)
	if(!shiftable)
		return
	if(shifted)
		if(alert("Would you like to wear your gambesoned kilt normally? This restores the new greyscaled style.",, "Yes", "No") != "No")
			icon_state = "patkilt"
			color = "#976E6B"
			update_icon()
			shifted = FALSE
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_pants()
			return
	else
		if(alert("Would you like to wear your gambesoned kilt traditionally? This restores the original coloration.",, "Yes", "No") != "No")
			icon_state = "patkiltold"
			color = null
			update_icon()
			shifted = TRUE
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_pants()
			return

/obj/item/clothing/under/roguetown/skirt/gambeson/light
	name = "light gambesoned kilt"
	desc = "Long, flowing, and modest; a light padding lines the undercarriage, providing milder protection and warmth."
	icon_state = "patkilt"
	item_state = "patkilt"
	armor = ARMOR_PADDED_BAD
	max_integrity = ARMOR_INT_LEG_LEATHER - 50
	shiftable = FALSE

/obj/item/clothing/under/roguetown/skirt/gambeson/heavy
	name = "padded gambesoned kilt"
	desc = "Long, flowing, and modest; thickly padded, yet surprisingly unfettered in terms of agility."
	icon_state = "patkilt"
	item_state = "patkilt"
	armor = ARMOR_PADDED
	max_integrity = ARMOR_INT_LEG_HARDLEATHER
	color = "#976E6B"
	shiftable = TRUE
	shifted = FALSE

/obj/item/clothing/under/roguetown/skirt/gambeson/heavy/attack_right(mob/user)
	if(!shiftable)
		return
	if(shifted)
		if(alert("Would you like to wear your padded gambesoned kilt normally? This restores the new greyscaled style.",, "Yes", "No") != "No")
			icon_state = "patkilt"
			color = "#976E6B"
			update_icon()
			shifted = FALSE
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_pants()
			return
	else
		if(alert("Would you like to wear your padded gambesoned kilt traditionally? This restores the original coloration.",, "Yes", "No") != "No")
			icon_state = "patkiltold"
			color = null
			update_icon()
			shifted = TRUE
			if(user)
				if(ishuman(user))
					var/mob/living/carbon/H = user
					H.update_inv_pants()
			return
