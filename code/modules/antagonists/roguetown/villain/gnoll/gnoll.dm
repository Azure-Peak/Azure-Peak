/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor
	slot_flags = null
	name = "gnoll skin"
	desc = "an impenetrable hide of graggar's fury"
	mob_overlay_icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon_state = "berserker"
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	//slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	armor = ARMOR_WWOLF
	prevent_crits = PREVENT_CRITS_ALL
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 550
	item_flags = DROPDEL
	repair_time = 15 SECONDS
	interrupt_damount = 35

/datum/outfit/job/roguetown/gnoll/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor
