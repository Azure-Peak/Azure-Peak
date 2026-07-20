/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter //thanks to ket for other abyssor clothing sprites
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "rainfall robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles rainfall."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "rain"
	icon = 'icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_painter_sea
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "sea robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles the waves of the great blue."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "sea"
	icon = 'icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/shirt/robe/abyssor_leader
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT|ITEM_SLOT_CLOAK
	name = "sylveric robe"
	desc = "A long robe formed of many layers of thin, light fabric; designed not to become over-heavy \
	while waterlogged. \
	This robe is commonly worn by exalted abyssorites that follow the path of the dream painter. \
	Said to have been dyed with paints from his dream in a pattern that resembles the woes of His dream."
	body_parts_covered = CHEST|GROIN|ARMS|LEGS|VITALS
	icon_state = "leaderrobe"
	icon = 'icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/abyssor.dmi'
	boobed = TRUE
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/head/roguetown/roguehood/abyssor_painter
	name = "quicksilver hood"
	desc = "A hood worn by the followers of Abyssor, with a unique spiral wrapping. How do they even see out of this? \
	It's said out of the many pigments of the dream, the most potent resembles quicksilver. \
	Hoods like these are designed to capture the fumes that are given off by the silvery paint... after completing certain rites."
	color = null
	icon_state = "silverhood"
	item_state = "silverhood"
	icon = 'icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/abyssor.dmi'
	body_parts_covered = NECK
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	dynamic_hair_suffix = ""
	edelay_type = 1
	adjustable = CAN_CADJUST
	toggle_icon_state = TRUE
	max_integrity = 180
	salvage_result = /obj/item/natural/cloth
	salvage_amount = 1

/obj/item/clothing/head/roguetown/helmet/heavy/abyssor_painter
	name = "sylveric helmet"
	desc = "Much like the accompanying robes, this sylveric-based creation serves to obscure the wearer. \
	Whether to hide the wearer's horrifically mutated visage as per the rumors surrounding the enigmatic voice of Abyssor. \
	Or to hide a less than imposing, dashing dark elf that would undermine the painter's authority. \
	It doesn't seem to be as sturdy as a dreamwalker's creations. \
	Somehow it allows the wearer to view through it clearly, though the thin, flakey metal hardly seems protective as a result."
	icon = 'icons/roguetown/clothing/special/abyssor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/abyssor.dmi'
	icon_state = "leaderhelm"
	flags_inv = HIDEFACE|HIDESNOUT|HIDEEARS|HIDEHAIR
	body_parts_covered = FULL_HEAD
	adjustable = CANT_CADJUST
	smeltresult = null
	// Given it's dream-metal, allows dreamwalkers to repair this... should they pilfer it.
	item_flags = DREAM_ITEM
	armor_class = ARMOR_CLASS_LIGHT
	max_integrity = ARMOR_INT_HELMET_HARDLEATHER
	armor = ARMOR_PADDED
	block2add = null

/obj/item/clothing/head/roguetown/helmet/heavy/abyssor_painter/attack_self(mob/user)
	..()
	if(icon_state == "leaderhelm")
		icon_state = "leaderhelm_f"
		to_chat(user, span_notice("You adjust [src] into a sleek configuration."))
	else
		icon_state = "leaderhelm"
		to_chat(user, span_notice("You adjust [src] back to its standard configuration."))

	update_icon()
	if(loc == user && ishuman(user))
		var/mob/living/carbon/human/H = user
		H.update_inv_head()
