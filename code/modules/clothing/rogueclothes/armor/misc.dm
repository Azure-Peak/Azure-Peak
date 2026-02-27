//................ Corset.................... //
/obj/item/clothing/suit/roguetown/armor/corset
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "corset"
	desc = "A leather binding to constrict one's figure... and lungs."
	icon_state = "corset"
	armor_class = ARMOR_CLASS_LIGHT
	body_parts_covered = CHEST
	salvage_result = /obj/item/natural/hide/cured
	sewrepair = TRUE
	salvage_amount = 1
	
/obj/item/clothing/suit/roguetown/armor/longcoat
	name = "longcoat"
	desc = "A padded longcoat meant to keep you warm in the frigid winters"
	icon_state = "longcoat"
	color = CLOTHING_BLACK
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_CLOAK
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL
	allowed_sex = list(MALE, FEMALE)

/obj/item/clothing/suit/roguetown/armor/longcoat/brown
	color = "#997C4F"

/obj/item/clothing/suit/roguetown/armor/longcoat/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/cloak)

/obj/item/clothing/suit/roguetown/armor/leather/vest/black
	color = "#3c3a38"

/obj/item/clothing/suit/roguetown/armor/workervest
	name = "striped tunic"
	desc = "This cheap tunic is often used by sturdy laborous men and women."
	icon_state = "workervest"
	armor = null
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	body_parts_covered = COVERAGE_VEST
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	sleevetype = null
	sleeved = null
	nodismemsleeves = TRUE
	boobed = TRUE

/obj/item/clothing/suit/roguetown/armor/workervest/Initialize()
	color = pick("#94b4b6", "#ba8f9e", "#bd978c", "#92bd8c", "#c7c981")
	..()

/obj/item/clothing/suit/roguetown/armor/silkcoat
	name = "silk coat"
	desc = "A padded dressing made from the finest silks."
	icon_state = "bliaut"
	color = null
	armor = ARMOR_SPELLSINGER
	prevent_crits = PREVENT_CRITS_NONE
	blocksound = SOFTHIT
	slot_flags = ITEM_SLOT_ARMOR
	blade_dulling = DULLING_BASHCHOP
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	sleevetype = "shirt"
	max_integrity = ARMOR_INT_CHEST_CIVILIAN
	sellprice = 50
	armor_class = ARMOR_CLASS_LIGHT
	allowed_sex = list(MALE, FEMALE)
	allowed_race = CLOTHED_RACES_TYPES


/obj/item/clothing/suit/roguetown/armor/silkcoat/Initialize()
	. = ..()
	color = pick(CLOTHING_PURPLE, null,CLOTHING_GREEN, CLOTHING_RED)
