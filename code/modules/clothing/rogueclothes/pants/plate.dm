/obj/item/clothing/under/roguetown/platelegs
	name = "steel plate chausses"
	desc = "Reinforced armor to protect the legs."
	gender = PLURAL
	icon_state = "plate_legs"
	item_state = "plate_legs"
//	adjustable = CAN_CADJUST
	sewrepair = FALSE
	armor = ARMOR_PLATE
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_LEG_STEEL_PLATE
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	r_sleeve_status = SLEEVE_NOMOD
	l_sleeve_status = SLEEVE_NOMOD
	smelt_bar_num = 2
	resistance_flags = FIRE_PROOF
	armor_class = ARMOR_CLASS_HEAVY

/obj/item/clothing/under/roguetown/platelegs/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP)

/obj/item/clothing/under/roguetown/platelegs/iron
	name = "iron plate chausses"
	desc = "Reinforced armor to protect the legs."
	icon_state = "iplate_legs"
	item_state = "iplate_legs"
	max_integrity = ARMOR_INT_LEG_IRON_PLATE
	smeltresult = /obj/item/ingot/iron

/obj/item/clothing/under/roguetown/platelegs/aalloy
	name = "decrepit plate chausses"
	desc = "Frayed bronze plates, shingled over chausses of rotting leather-and-maille. Voided bowels are all that remains of its former legionnaire."
	icon_state = "ancientplate_legs"
	max_integrity = ARMOR_INT_LEG_DECREPIT_PLATE
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null

/obj/item/clothing/under/roguetown/platelegs/paalloy
	name = "ancient plate chausses"
	desc = "Polished gilbranze plates, layered atop silken chausses. Only the few who had embraced undeath were spared from Zizo's ascension; now, they command the undying legionnaires who march forth to sunder creation in Her name."
	icon_state = "ancientplate_legs"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/clothing/under/roguetown/platelegs/graggar
	name = "vicious leggings"
	desc = "Plate chausses which stir with the innate violence driving our world"
	icon_state = "graggarplatelegs"
	armor = ARMOR_ASCENDANT
	max_integrity = ARMOR_INT_LEG_STEEL_PLATE // Good good resistances, but less crit resist than the other ascendant armors. In trade, we can take off our pants to repair, and they are medium rather than heavy.
	armor = ARMOR_CLASS_MEDIUM

/obj/item/clothing/under/roguetown/platelegs/graggar/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "ARMOR", "RENDERED ASUNDER")

/obj/item/clothing/under/roguetown/platelegs/matthios
	max_integrity = ARMOR_INT_LEG_ANTAG
	name = "gilded leggings"
	desc = "But my outside to behold:"
	icon_state = "matthioslegs"
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PICK)
	armor = ARMOR_ASCENDANT

/obj/item/clothing/under/roguetown/platelegs/matthios/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	AddComponent(/datum/component/cursed_item, TRAIT_COMMIE, "ARMOR")

/obj/item/clothing/under/roguetown/platelegs/matthios/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)


/obj/item/clothing/under/roguetown/platelegs/zizo
	max_integrity = ARMOR_INT_LEG_ANTAG
	name = "avantyne garments"
	desc = "Leg garments worn by true anointed of the Dame of Progress. In Her name."
	icon_state = "zizocloth"
	armor = ARMOR_ASCENDANT
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_SMASH, BCLASS_PICK)

/obj/item/clothing/under/roguetown/platelegs/zizo/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "ARMOR")

/obj/item/clothing/under/roguetown/platelegs/zizo/dropped(mob/living/carbon/human/user)
	. = ..()
	if(QDELETED(src))
		return
	qdel(src)

/obj/item/clothing/under/roguetown/platelegs/zizo/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_PLATE_STEP)

/obj/item/clothing/under/roguetown/platelegs/skirt
	name = "steel plate tassets"
	desc = "A set of hanging plates of steel to protect the hips and thighs without too much burden."
	gender = PLURAL
	icon_state = "plate_skirt"
	item_state = "plate_skirt"
	body_parts_covered = GROIN
	armor_class = ARMOR_CLASS_LIGHT
