/obj/item/clothing/cloak/stabard/warband
	name = "foreign surcote"
	desc = "A tabard bearing a foreign Lord's heraldic colors."
	color = CLOTHING_BLACK
	detail_tag = "_box"
	detail_color = CLOTHING_YELLOW


//////////////////
////////////////////////// PLACEHOLDER ITEMS
//////////////////

/obj/item/clothing/cloak/half/purple
	color = CLOTHING_PURPLE

/obj/item/clothing/cloak/forrestercloak/snow/alt
	name = "heartbreaker's shroud"
	desc = "A heavy cloak. When worn, a numbing comfort settles over one's nerves."
	color = CLOTHING_PURPLE

/obj/item/clothing/cloak/thrall
	name = "witch's shortcloak"
	icon_state = "shortcloak"
	item_state = "shortcloak"
	desc = "A cloak spun from fine silks and crowned by a mantlet of downy feathers."
	color = "#1c1c1c"
	detail_color = "#3a1816"
	alternate_worn_layer = 50
	layer = 30
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	detail_tag = "_detail"

/obj/item/clothing/cloak/thrall/warlord
	detail_color = CLOTHING_BLACK

/obj/item/clothing/cloak/poncho/invader
	color = "#232B1E"
	detail_color = "#14100c"

/obj/item/clothing/head/roguetown/wizhat/green/alt
	color = "#333333"

/obj/item/clothing/suit/roguetown/shirt/robe/tabardblack/alt
	color = "#808080"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/rival
	color = "#2b292e"


/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/down/blue
	color = "#4756d8"

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/down/yellow
	color = "#c1b144"

/obj/item/clothing/shoes/roguetown/boots/armor/iron/layman
	desc = ""
	color = "#f7bf6e"

/obj/item/clothing/mask/rogue/facemask/goldmask/layman
	name = "layman's mask"
	color = "#dddddd"
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_HELMET_IRON
	alternate_worn_layer = UNDER_CLOAK_LAYER
	slot_flags = ITEM_SLOT_HEAD	
	flags_inv = HIDEFACE|HIDESNOUT|HIDEHAIR
	flags_cover = HEADCOVERSEYES
	body_parts_covered = HEAD|EARS|HAIR|NOSE|EYES

/obj/item/clothing/mask/rogue/facemask/goldmask/layman/alt
	color = "#808080"


/obj/item/clothing/suit/roguetown/armor/plate/half/iron/layman
	name = "bronze breastplate"
	desc = ""
	color = "#f7bf6e"

/obj/item/clothing/wrists/roguetown/bracers/iron/layman
	name = "bronze bracers"
	desc = ""
	color = "#f7bf6e"

/obj/item/clothing/gloves/roguetown/plate/iron/layman
	name = "bronze gauntlets"
	desc = ""
	color = "#f7bf6e"


/obj/item/clothing/neck/roguetown/bevor/iron/layman
	name = "bronze bevor"
	desc = ""
	alternate_worn_layer = 32
	color = "#f7bf6e"

/obj/item/clothing/suit/roguetown/armor/leather/cuirass/stalker
	color = "#3a1816"

/obj/item/clothing/head/roguetown/roguehood/shalal/thrall
	name = "layman's headscarf"
	desc = ""
	color = "#3a1816"
	icon_state = "shalal_t"
	item_state = "shalal_t"
	alternate_worn_layer = 6
	layer = 6
	armor = ARMOR_PADDED_GOOD
	max_integrity = ARMOR_INT_HELMET_CLOTH
	adjustable = CAN_CADJUST
	sewrepair = TRUE
	mask_override = TRUE
	overarmor = FALSE

/obj/item/clothing/mask/rogue/duelmask/keeper
	color = "#2b292e"
	detail_color = "#264d26"
	desc = ""

/obj/item/clothing/neck/roguetown/bevor/keeper
	color = "#2b292e"

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/keeper
	color = "#5b4338"

/obj/item/clothing/cloak/thief_cloak/keeper
	color = "#5b4338"

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/prophet
	color = "#3d4a57"

/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/keeper
	name = "versekeeper's shawl"
	desc = ""
	naledicolor = FALSE
	color = "#644e43"
	shiftable = FALSE

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/down


/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/down/Initialize()
	. = ..()
	var/datum/component/adjustable_clothing/adjust_component = GetComponent(/datum/component/adjustable_clothing)
	if(adjust_component)
		adjust_component.toggle_open(src)

/obj/item/clothing/head/roguetown/helmet/heavy/sheriff/prophet
	color = "#a3b3c2"

/obj/item/clothing/cloak/matron/prophet
	name = "prophet's shroud"
	desc = "It's a shroud. All-concealing, all-protecting."
	body_parts_covered = COVERAGE_FULL
	armor = ARMOR_LEATHER_STUDDED
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)

/obj/item/clothing/cloak/prophet
	name = "prophet's shortcloak"
	desc = "A shortcloak spun from old, tainted cloth."
	color = "#3d4a57"
	detail_color = "#3d4a57"
	icon_state = "shortcloak"
	item_state = "shortcloak"
	alternate_worn_layer = CLOAK_BEHIND_LAYER
	slot_flags = ITEM_SLOT_BACK_R|ITEM_SLOT_CLOAK
	boobed = TRUE
	sleeved = 'icons/roguetown/clothing/onmob/cloaks.dmi'
	sleevetype = "shirt"
	nodismemsleeves = TRUE
	detail_tag = "_detail"

/obj/item/clothing/under/roguetown/skirt/black
	color = CLOTHING_BLACK

/obj/item/clothing/head/roguetown/witchhat/thrall
	color = "#b2b2b2"

/obj/item/clothing/suit/roguetown/shirt/undershirt/priest/thrall
	color ="#904d4d"

/obj/item/clothing/suit/roguetown/shirt/tunic/silktunic/thrall
	color = "#808080"

/obj/item/clothing/head/roguetown/roguehood/ringleader
	color = "#704542"


/obj/item/clothing/head/roguetown/roguehood/ringleader/Initialize()
	. = ..()
	var/datum/component/adjustable_clothing/adjust_component = GetComponent(/datum/component/adjustable_clothing)
	if(adjust_component)
		adjust_component.toggle_open(src)


/obj/item/storage/belt/rogue/leather/battleskirt/ringleader
	color = "#704542"

/obj/item/clothing/wrists/roguetown/bracers/copper/cultist
	color = "#8a8a8a"
	
/////////////// expressly for NPCs

/obj/item/clothing/head/roguetown/helmet/kettle/jingasa/npc
	detail_color = CLOTHING_RED

/obj/item/clothing/suit/roguetown/armor/brigandine/haraate/npc
	detail_color = CLOTHING_RED

/obj/item/clothing/gloves/roguetown/plate/kote/npc
	detail_color = CLOTHING_RED

/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/npc
	color = CLOTHING_RED

/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun/npc
	detail_color = CLOTHING_RED

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/npc
	color = CLOTHING_BLACK

/obj/item/clothing/under/roguetown/trou/leather/pontifex/npc
	color = CLOTHING_BLACK

/obj/item/clothing/wrists/roguetown/allwrappings/npc
	color = CLOTHING_BLACK


