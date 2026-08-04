/obj/item/clothing/suit/roguetown/armor/vampiric
	name = "vampiric armour"
	desc = "Abstract parent. Contact developer if you see this."
	icon_state = null
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	unenchantable = TRUE

	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'

	resistance_flags = FIRE_PROOF
	body_parts_covered = COVERAGE_FULL
	body_parts_inherent = COVERAGE_FULL
	flags_inv = null
	surgery_cover = FALSE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	armor_class = ARMOR_CLASS_LIGHT
	blocksound = SOFTUNDERHIT
	armor = ARMOR_PADDED

/datum/outfit/job/roguetown/gnoll
	var/shard_threshold = 46
	var/shard_repair_value = 25
	var/max_fury_stacks = 150
	var/vamp_armor_type = /obj/item/clothing/suit/roguetown/armor/vampiric/gnoll

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll
	name = "gnoll skin"
	desc = "an impenetrable hide of graggar's fury"
	mob_overlay_icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon_state = "berserker"
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	sewrepair = FALSE
	item_flags = DROPDEL
	armor = ARMOR_GNOLL_STANDARD
	max_integrity = 475

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/knight
	icon_state = "knight"
	max_integrity = 800
	armor = ARMOR_GNOLL_STRONG

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/impure
	icon_state = null
	max_integrity = 400
	armor = ARMOR_GNOLL_WEAK

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/templar
	icon_state = "templar"
	max_integrity = 600
	armor = ARMOR_GNOLL_STANDARD

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/shaman
	icon_state = "shaman"
	max_integrity = 400
	armor = ARMOR_GNOLL_WEAK
