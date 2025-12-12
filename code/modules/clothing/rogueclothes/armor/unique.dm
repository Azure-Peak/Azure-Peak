/obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe
	slot_flags = ITEM_SLOT_ARMOR
	name = "spellsinger robes"
	desc = "A set of reinforced, leather-padded robes worn by spellblades."
	body_parts_covered = COVERAGE_FULL
	armor = ARMOR_SPELLSINGER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	armor_class = ARMOR_CLASS_LIGHT
	icon_state = "spellcasterrobe"
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	sleeved = null
	color = null
	r_sleeve_status = SLEEVE_NORMAL
	l_sleeve_status = SLEEVE_NORMAL

/obj/item/clothing/suit/roguetown/armor/basiceast
	name = "simple dobo robe"
	desc = "A dirty dobo robe with white lapels. Can be upgraded through the use of a tailor to increase its integrity and protection."
	icon_state = "eastsuit3"
	item_state = "eastsuit3"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	body_parts_covered = COVERAGE_FULL
	armor = ARMOR_SPELLSINGER
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_BLUNT, BCLASS_CHOP, BCLASS_SMASH)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = TRUE
	nodismemsleeves = TRUE
	sellprice = 20
	armor_class = ARMOR_CLASS_LIGHT
	allowed_race = NON_DWARVEN_RACE_TYPES
	flags_inv = HIDEBOOB|HIDECROTCH

//less integrity than a leather cuirass, incredibly weak to blunt damage - great against slash - standard leather value against stab
//the intent for these armors is to create specific weaknesses/strengths for people to play with

/obj/item/clothing/suit/roguetown/armor/basiceast/crafteast
	name = "decorated dobo robe"
	desc = "A dobo robe with a red tassel. Leather inlays are sewn in. It looks sturdier than a simple robe."
	icon_state = "eastsuit2"
	item_state = "eastsuit2"
	armor = ARMOR_LEATHER_STUDDED // Makes it the equivalence of studded with less integrity and better armor 
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM

//craftable variation of eastsuit, essentially requiring the presence of a tailor with relevant materials
//still weak against blunt

/obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit
	name = "old dobo robe"
	desc = "The scars on your body were once stories of strength and bravado."
	icon_state = "eastsuit1"
	item_state = "eastsuit1"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/sleeves_armor.dmi'
	armor = ARMOR_LEATHER_STUDDED 
	max_integrity = ARMOR_INT_CHEST_LIGHT_MEDIUM


/obj/item/clothing/suit/roguetown/armor/basiceast/captainrobe
	name = "foreign robes"
	desc = "Flower-styled robes, said to have been infused with magical protection. The Merchant Guild says that this is from the southern Kazengite region."
	icon_state = "eastsuit4"
	item_state = "eastsuit4"
	armor = ARMOR_LEATHER_STUDDED
	max_integrity = ARMOR_INT_CHEST_LIGHT_MASTER + 25 // Head Honcho gets a buff
	sellprice = 25

// this robe spawns on a role that offers no leg protection nor further upgrades to the loadout, in exchange for better roundstart gear

/obj/item/clothing/suit/roguetown/armor/plate/elven_plate
	name = "woad elven plate"
	desc = "Woven by song and tool of the oldest elven druids. It still creaks and weeps with forlorn reminiscence of a bygone era. It looks like only Elves can fit in it."
	allowed_race = list(/datum/species/elf/wood, /datum/species/human/halfelf, /datum/species/elf/dark, /datum/species/elf)
	armor = list("blunt" = 100, "slash" = 20, "stab" = 130, "piercing" = 40, "fire" = 0, "acid" = 0)
	prevent_crits = list(BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PICK, BCLASS_SMASH)
	body_parts_covered = COVERAGE_FULL
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfchest"
	item_state = "welfchest"
	anvilrepair = /datum/skill/craft/carpentry
	smeltresult = /obj/item/rogueore/coal
	smelt_bar_num = 4
	blocksound = SOFTHIT
	armor_class = ARMOR_CLASS_MEDIUM

/obj/item/clothing/suit/roguetown/armor/plate/elven_plate/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/item_equipped_movement_rustle, SFX_WOOD_ARMOR, 10)
