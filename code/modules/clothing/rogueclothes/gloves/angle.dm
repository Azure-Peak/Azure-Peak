/obj/item/clothing/gloves/roguetown/angle
	name = "heavy leather gloves"
	desc = "A pair of heavy leather gloves, padded with the fur of a forest-dwelling beaste. The lengthened cuffs help to catch unseen bites from prowling monsters; a blessing, when even a single gnash can spread curses-most-foul."
	icon_state = "angle"
	armor = ARMOR_LEATHER_GOOD
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER
	sellprice = 12
	blade_dulling = DULLING_BASHCHOP
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	salvage_result = /obj/item/natural/fur
	color = "#7f829d"

/obj/item/clothing/gloves/roguetown/angle/ComponentInitialize()
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_FENCERDEXTERITY)
	AddComponent(/datum/component/armour_filtering/positive, TRAIT_HONORBOUND)

/obj/item/clothing/gloves/roguetown/angle/grenzelgloves
	name = "grenzelhoft gloves"
	desc = "Regal gloves of Grenzelhoftian design; more a fashion statement than actual protection."
	icon_state = "grenzelgloves"
	item_state = "grenzelgloves"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	color = "#ffffff"

/obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	name = "forge gauntlets"
	color = "#ffffff"

/obj/item/clothing/gloves/roguetown/angle/grenzelgloves/freifechter
	name = "fencing gloves"
	desc = "A pair of hardened leather gloves used by fencers who aren't exactly convinced of losing a finger to a particularly strong feder cut. The inside is padded for extra durability."
	max_integrity = ARMOR_INT_SIDE_HARDLEATHER + 50

/obj/item/clothing/gloves/roguetown/angle/pontifex
	name = "rune-scrybed wrappings"
	desc = "Paper and cloth bandages enscrybed with powerful naledian runes. They do an ample job of protecting their user's hands in combat."
	icon_state = "clothwraps"
	item_state = "clothwraps"
	color = "#ffffff"
