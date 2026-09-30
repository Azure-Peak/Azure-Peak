// SAIGA-TAUR GEAR //
// Equippable barding and tabards sized for a saiga-taur's body (icons/roguetown/clothing/onmob/64x32/saiga_barding.dmi),
// restricted to /obj/item/bodypart/taur/horse wearers, mirroring how /obj/item/clothing/shoes/roguetown/horseshoes is restricted.

/obj/item/clothing/suit/roguetown/armor/saiga_barding
	name = "saiga barding"
	desc = "Protective covering, cut and fitted for a saiga-taur's body."
	icon = 'icons/roguetown/clothing/special/saiga_gear.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/64x32/saiga_barding.dmi'
	slot_flags = ITEM_SLOT_ARMOR
	clothing_flags = TAUR_COMPATIBLE
	body_parts_covered = COVERAGE_TORSO
	nodismemsleeves = TRUE
	sewrepair = TRUE
	blocksound = SOFTHIT
	pickup_sound = 'sound/foley/equip/equip_armor.ogg'
	equip_sound = 'sound/foley/equip/equip_armor.ogg'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	// "fullbod" (barding drapes the whole body) or "caparison" (a lighter saddle-blanket look) - purely cosmetic, toggled by middle-clicking the worn barding
	var/barding_style = "fullbod"

/obj/item/clothing/suit/roguetown/armor/saiga_barding/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning)
	var/mob/living/equipped_to_mob = equipper || M
	var/obj/item/bodypart/taur/taur = equipped_to_mob.get_taur_tail()
	if(!istype(taur, /obj/item/bodypart/taur/horse))
		if(!disable_warning)
			to_chat(M, span_warning("[src] can only be worn by a saiga-taur."))
		return FALSE
	return ..()

/obj/item/clothing/suit/roguetown/armor/saiga_barding/build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, icon/clip_mask)
	var/state_to_use = override_state
	if(!state_to_use)
		state_to_use = (barding_style == "caparison") ? "[icon_state]_cap" : icon_state
	// clip_mask exists to cut away normal humanoid clothing where it would overlap the horse body -
	// the exact opposite of what we want here, since this barding is drawn to cover that body. Skip it.
	var/mutable_appearance/image = ..(default_layer, default_icon_file, isinhands, femaleuniform, state_to_use, female, customi, sleeveindex, boobed_overlay, null)
	image.pixel_x = -16
	return image

/obj/item/clothing/suit/roguetown/armor/saiga_barding/MiddleClick(mob/user)
	barding_style = (barding_style == "caparison") ? "fullbod" : "caparison"
	to_chat(user, span_notice("I adjust [src] to a[(barding_style == "caparison") ? " caparison" : " full-bodied"] style."))
	if(ismob(loc))
		var/mob/M = loc
		M.update_inv_armor()

/obj/item/clothing/suit/roguetown/armor/saiga_barding/cloth
	name = "cloth saiga barding"
	desc = "Protective covering, cut and fitted for a saiga-taur's body. Simple quilted cloth - offers no notable protection, more sight than shield."
	icon_state = "saiga_barding_cloth"
	armor = ARMOR_CLOTHING
	armor_class = ARMOR_CLASS_NONE
	material_category = ARMOR_MAT_LEATHER
	max_integrity = ARMOR_INT_CHEST_CIVILIAN

/obj/item/clothing/suit/roguetown/armor/saiga_barding/leather
	name = "leather saiga barding"
	desc = "Protective covering, cut and fitted for a saiga-taur's body. Cured leather, tough and flexible."
	icon_state = "saiga_barding_leather"
	armor = ARMOR_LEATHER
	armor_class = ARMOR_CLASS_LIGHT
	material_category = ARMOR_MAT_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_BASE
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/suit/roguetown/armor/saiga_barding/padded
	name = "padded saiga barding"
	desc = "Protective covering, cut and fitted for a saiga-taur's body. A thick padded coat, warding off blunt blows."
	icon_state = "saiga_barding_padded"
	armor = ARMOR_PADDED
	armor_class = ARMOR_CLASS_LIGHT
	material_category = ARMOR_MAT_LEATHER
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM

/obj/item/clothing/suit/roguetown/armor/saiga_barding/chain
	name = "chainmail saiga barding"
	desc = "Protective covering, cut and fitted for a saiga-taur's body. Dozens of interlinked steel rings, turning back blades."
	icon_state = "saiga_barding_chain"
	armor = ARMOR_MAILLE
	armor_class = ARMOR_CLASS_MEDIUM
	material_category = ARMOR_MAT_CHAINMAIL
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/suit/roguetown/armor/saiga_barding/chain/iron
	name = "iron chainmail saiga barding"
	desc = "Protective covering, cut and fitted for a saiga-taur's body. Interlinked iron rings - inexpensive, and robust enough for it."
	icon_state = "saiga_barding_ichain"
	max_integrity = ARMOR_INT_CHEST_MEDIUM_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/saiga_barding/chain/bronze
	name = "bronze chainmail saiga barding"
	desc = "Protective covering, cut and fitted for a saiga-taur's body. Rings of bronze, no match for steel but uniquely resistant to flame."
	icon_state = "saiga_barding_bchain"
	armor = ARMOR_BRONZE
	max_integrity = ARMOR_INT_CHEST_MEDIUM_BRONZE
	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/suit/roguetown/armor/saiga_barding/plate
	name = "plate saiga barding"
	desc = "Protective covering, cut and fitted for a saiga-taur's body. Segmented steel plates, a bulwark against the fiercest of blows."
	icon_state = "saiga_barding_plate"
	armor = ARMOR_PLATE
	armor_class = ARMOR_CLASS_HEAVY
	material_category = ARMOR_MAT_PLATE
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel

/obj/item/clothing/suit/roguetown/armor/saiga_barding/plate/iron
	name = "iron plate saiga barding"
	desc = "Protective covering, cut and fitted for a saiga-taur's body. Segmented iron plates - inexpensive, yet robust."
	icon_state = "saiga_barding_iplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_IRON
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/suit/roguetown/armor/saiga_barding/plate/bronze
	name = "bronze plate saiga barding"
	desc = "Protective covering, cut and fitted for a saiga-taur's body. Plates of bronze, no match for steel but uniquely resistant to flame."
	icon_state = "saiga_barding_bplate"
	armor = ARMOR_BRONZE
	max_integrity = ARMOR_INT_CHEST_PLATE_BRONZE
	smeltresult = /obj/item/ingot/bronze

/////////////////////
// SAIGA TABARD    //
/////////////////////

/obj/item/clothing/cloak/tabard/saiga
	name = "saiga tabard"
	desc = "A tabard cut to drape over a saiga-taur's frame."
	icon = 'icons/roguetown/clothing/special/saiga_gear.dmi'
	icon_state = "saiga_tabard"
	item_state = "saiga_tabard"

/obj/item/clothing/cloak/tabard/saiga/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning)
	var/mob/living/equipped_to_mob = equipper || M
	var/obj/item/bodypart/taur/taur = equipped_to_mob.get_taur_tail()
	if(!istype(taur, /obj/item/bodypart/taur/horse))
		if(!disable_warning)
			to_chat(M, span_warning("[src] can only be worn by a saiga-taur."))
		return FALSE
	return ..()

// The torso portion still renders as a normal humanoid tabard (inherited mob_overlay_icon) - there's no saiga-specific torso sprite.
// /mob/living/carbon/human/proc/build_taur_tabard_overlay() (see update_icons.dm) drapes the actual saiga-shaped tabard graphic over the horse body.
/obj/item/clothing/cloak/tabard/saiga/build_worn_icon(default_layer, default_icon_file, isinhands, femaleuniform, override_state, female, customi, sleeveindex, boobed_overlay, icon/clip_mask)
	return ..(default_layer, default_icon_file, isinhands, femaleuniform, "tabard", female, customi, sleeveindex, boobed_overlay, clip_mask)
