/datum/crafting_recipe/roguetown/survival/skullmask
	name = "skull mask"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/mask/rogue/skullmask
	reqs = list(
		/obj/item/natural/bone = 3,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 10
	verbage_simple = "craft"
	verbage = "crafted"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/wickercloak
	name = "wicker cloak"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/cloak/wickercloak
	reqs = list(
		/obj/item/natural/dirtclod = 1,
		/obj/item/grown/log/tree/stick = 5,
		/obj/item/natural/fibers = 3,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/antlerhood
	name = "antlerhood"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/head/roguetown/antlerhood
	reqs = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/bone = 2,
		)
	sellprice = 12
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/tribalrags
	name = "tribal rags"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/suit/roguetown/shirt/tribalrag
	reqs = list(
		/obj/item/natural/hide = 1,
		/obj/item/natural/fibers = 1,
		)
	sellprice = 6
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/sewing
	verbage_simple = "sew"
	verbage = "sews"
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/collar
	name = "collar"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/collar
	reqs = list(/obj/item/natural/hide/cured = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/bell_collar
	name = "bell collar"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/collar/bell_collar
	reqs = list(
		/obj/item/natural/hide/cured = 1,
		/obj/item/jingle_bells = 1,
		)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/feldcollar
	name = "feldcollar"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/collar/feldcollar
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/surgcollar
	name = "surgcollar"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/collar/surgcollar
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/survival/goodluckcharm
	name = "cabbit's foot luck charm"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/luckcharm // +1 fortune when worn
	reqs = list(
		/obj/item/natural/rabbitsfoot = 1,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0

// BOUQUETS & CROWNS

/datum/crafting_recipe/roguetown/survival/bouquet_rosa
	name = "rosa bouquet"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/bouquet/rosa
	reqs = list(
		/obj/item/alch/rosa = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/bouquet_salvia
	name = "salvia bouquet"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/bouquet/salvia
	reqs = list(
		/obj/item/alch/salvia = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/bouquet_matricaria
	name = "matricaria bouquet"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/bouquet/matricaria
	reqs = list(
		/obj/item/alch/matricaria = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/bouquet_calendula
	name = "calendula bouquet"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/bouquet/calendula
	reqs = list(
		/obj/item/alch/calendula = 4,
		/obj/item/natural/fibers = 2,
		/obj/item/paper/scroll = 1,
		)
	craftdiff = 0
	verbage_simple = "arranged"
	verbage = "arranges"

/datum/crafting_recipe/roguetown/survival/flowercrown_rosa
	name = "rosa crown"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/flowercrown/rosa
	reqs = list(
		/obj/item/alch/rosa = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

/datum/crafting_recipe/roguetown/survival/flowercrown_salvia
	name = "salvia crown"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/flowercrown/salvia
	reqs = list(
		/obj/item/alch/salvia = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

/datum/crafting_recipe/roguetown/survival/flowercrown_matricaria
	name = "matricaria crown"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/flowercrown/matricaria
	reqs = list(
		/obj/item/alch/matricaria = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

/datum/crafting_recipe/roguetown/survival/flowercrown_calendula
	name = "calendula crown"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/flowercrown/calendula
	reqs = list(
		/obj/item/alch/calendula = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

/datum/crafting_recipe/roguetown/survival/flowercrown_manabloom
	name = "manabloom crown"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/flowercrown/manabloom
	reqs = list(
		/obj/item/reagent_containers/food/snacks/grown/manabloom = 4,
		/obj/item/natural/fibers = 2,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

/datum/crafting_recipe/roguetown/survival/flowercrown_briar
	name = "briar thorn crown"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/flowercrown/briar
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/natural/thorn = 4,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

/datum/crafting_recipe/roguetown/survival/briarthorns
	name = "briar thorns"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/head/roguetown/briarthorns
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/natural/thorn = 4,
		)
	craftdiff = 0
	verbage_simple = "tied"
	verbage = "ties"

// Amulet
/datum/crafting_recipe/roguetown/survival/pearlcross
	name = "amulet (pearls)"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/pearl
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl = 3,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/bpearlcross
	name = "amulet (blue pearls)"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/bpearl
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl/blue = 3,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/survival/shellnecklace
	name = "shell necklace"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/shell
	reqs = list(
		/obj/item/oystershell = 5,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/shellbracelet
	name = "shell bracelet"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/shell/bracelet
	reqs = list(
		/obj/item/oystershell = 3,
		/obj/item/natural/fibers = 1,
		)

/datum/crafting_recipe/roguetown/survival/abyssoramulet
	name = "amulet of abyssor"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/abyssor
	reqs = list(
		/obj/item/natural/fibers = 1,
		/obj/item/pearl/blue = 1,
		)

/datum/crafting_recipe/roguetown/survival/woodcross
	name = "wooden psycross"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodreformcross
	name = "wooden reformist psycross"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/reform/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodzcross
	name = "wooden inverted psycross"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/inhumen/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodmatthioscross
	name = "wooden amulet of Matthios"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodgraggarcross
	name = "wooden amulet of Graggar"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodbaothacross
	name = "wooden amulet of Baotha"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodtencross
	name = "wooden amulet of Ten"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/undivided/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodastratacross
	name = "wooden amulet of Astrata"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/astrata/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodnoccross
	name = "wooden amulet of Noc"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/noc/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodabyssorcross
	name = "wooden amulet of Abyssor"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/abyssor/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/wooddendorcross
	name = "wooden amulet of Dendor"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/dendor/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodnecracross
	name = "wooden amulet of Necra"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/necra/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodpestracross
	name = "wooden amulet of Pestra"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/pestra/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodravoxcross
	name = "wooden amulet of Ravox"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/ravox/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodmalumcross
	name = "wooden amulet of Malum"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/malum/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodeoracross
	name = "wooden amulet of Eora"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/eora/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/woodxylixcross
	name = "wooden amulet of Xylix"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/neck/roguetown/psicross/xylix/wood
	reqs = list(
		/obj/item/natural/fibers = 2,
		/obj/item/grown/log/tree/stick = 2,
		)

/datum/crafting_recipe/roguetown/survival/autumnwoadarmor
	name = "autumnwoad elven plate, imbuement"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate/autumn
	reqs = list(
		/obj/item/natural/fibers = 3,
		/obj/item/grown/log/tree/stick = 3,
		/obj/item/clothing/suit/roguetown/armor/plate/elven_plate/autumn/light = 1,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/cured/essence = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/survival/autumnwoadhelmet
	name = "autumnwoad elven helm, imbuement"
	display_category = ITEM_CAT_GARMENT_COMMON
	category = "Clothes"
	result = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/autumn
	reqs = list(
		/obj/item/natural/fibers = 3,
		/obj/item/grown/log/tree/stick = 3,
		/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/autumn/light = 1,
		/obj/item/grown/log/tree/small = 1,
		/obj/item/natural/cured/essence = 1,
		)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1
