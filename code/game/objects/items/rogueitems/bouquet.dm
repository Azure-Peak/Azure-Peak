// BOUQUETS & FLOWER CROWNS

/obj/item/bouquet
	name = ""
	desc = ""
	icon = 'icons/roguetown/items/misc.dmi' 
	icon_state = ""
	item_state = ""

	grid_width = 32
	grid_height = 64

/obj/item/bouquet/rosa
	name = "rosa bouquet"
	desc = "Affections bundled together in string."
	item_state = "bouquet_rosa"
	icon_state = "bouquet_rosa"

/obj/item/bouquet/salvia
	name = "salvia bouquet"
	desc = ""
	item_state = "bouquet_salvia"
	icon_state = "bouquet_salvia"

/obj/item/bouquet/matricaria
	name = "matricaria bouquet"
	desc = ""
	item_state = "bouquet_matricaria"
	icon_state = "bouquet_matricaria"

/obj/item/bouquet/calendula
	name = "calendula bouquet"
	desc = ""
	item_state = "bouquet_calendula"
	icon_state = "bouquet_calendula"

/obj/item/flowercrown
	name = "flowercrown"
	desc = "A carefully woven crown of fresh flowers, yet to wilt. Headwear beloved \
	by Eorans and all pining romantics."
	icon = 'icons/roguetown/clothing/head.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'
	alternate_worn_layer = 8.9 //On top of helmet
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_MASK
	body_parts_covered = null
	icon_state = ""
	item_state = ""
	experimental_inhand = FALSE

	grid_width = 64
	grid_height = 32

/obj/item/flowercrown/rosa
	name = "crown of rosa"
	desc = ""
	item_state = "rosa_crown"
	icon_state = "rosa_crown"

/obj/item/flowercrown/salvia
	name = "crown of salvia"
	item_state = "salvia_crown"
	icon_state = "salvia_crown"

/obj/item/flowercrown/matricaria
	name = "crown of matricaria"
	item_state = "matricaria_crown"
	icon_state = "matricaria_crown"

/obj/item/flowercrown/calendula
	name = "crown of calendula"
	item_state = "calendula_crown"
	icon_state = "calendula_crown"

/obj/item/flowercrown/manabloom
	name = "crown of manabloom"
	desc = "A crown formed of manabloom flowers. Often worn by those who find themselves in need of a \
	deeper attunement to the arcyne; a favourite of young apprentices and faltering old masters both."
	item_state = "manabloom_crown"
	icon_state = "manabloom_crown"

/obj/item/flowercrown/briar
	name = "crown of briar thorns"
	desc = "A circlet of thorns often worn by devout followers of Dendor. Designed to dig \
	into the flesh just enough to ground the wearer's sanity."
	item_state = "briar_crown"
	icon_state = "briar_crown"

/obj/item/flowercrown/briar/pickup(mob/living/user)
	. = ..()
	to_chat(user, span_warning ("The thorns prick me."))
	user.adjustBruteLoss(4)
