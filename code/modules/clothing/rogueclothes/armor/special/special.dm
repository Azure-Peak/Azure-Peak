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

	attachment_component = FALSE

/datum/outfit/job/roguetown/gnoll
	var/shard_threshold = 46
	var/shard_repair_value = 25
	var/max_fury_stacks = 150
	var/vamp_armor_skin = /obj/item/clothing/suit/roguetown/armor/vampiric/gnoll
	var/vamp_armor_chest = /obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/chest
	var/vamp_armor_limb = /obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/extremities

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll
	name = "gnoll skin"
	desc = "An impenetrable hide of Graggar's fury."
	mob_overlay_icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	icon_state = "berserker"
	sewrepair = FALSE
	item_flags = DROPDEL
	armor = ARMOR_GNOLL_STANDARD
	body_parts_covered = null

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/Initialize(mapload)
	..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/dropped(mob/living/carbon/human/user)
	..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/chest
	name = "berserker's hearthide"
	desc = "You shed all, knowing He would protect you."
	body_parts_covered = CHEST
	body_parts_inherent = CHEST
	max_integrity = 475

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/extremities
	slot_flags = ITEM_SLOT_ARMOR
	name = "berserker's hide extremities"
	desc = "\"SOD THE HAND, AIM FOR THE NECK!\""
	body_parts_covered = FULL_BODY_NO_CHEST
	body_parts_inherent = FULL_BODY_NO_CHEST
	max_integrity = 375

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/knight
	icon_state = "knight"

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/chest/knight
	name = "knight's hearthide"
	desc = "His blood burns so that yours may keep warm."
	max_integrity = 800
	armor = ARMOR_GNOLL_STRONG

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/extremities/knight
	name = "knight's hide extremities"
	desc = "Fire took all. But it was returned, manifold."
	max_integrity = 700
	armor = ARMOR_GNOLL_STRONG

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/extremities/impure
	icon_state = null
	max_integrity = 400
	armor = ARMOR_GNOLL_WEAK
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/templar
	icon_state = "templar"

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/chest/templar
	name = "templar's hearthide"
	desc = "The flesh is pierced, but the word is whole."
	max_integrity = 600

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/extremities/templar
	name = "templar's hide extremities"
	desc = "Drop the brand. Take off the maille. Forsake the banner."
	max_integrity = 500

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/shaman
	icon_state = "shaman"

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/chest/shaman
	name = "shaman's hearthide"
	desc = "Doubt vanishes. He has made you."
	max_integrity = 400
	armor = ARMOR_GNOLL_WEAK

/obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/extremities/shaman
	name = "shaman's hide extremities"
	desc = "Where He walks, you walk. There is no other way."
	max_integrity = 300
	armor = ARMOR_GNOLL_WEAK
