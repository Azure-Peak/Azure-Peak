/obj/item/clothing/undershirt
	name = "sheer body"
	desc = "Something to cover yourself with."
	icon = 'icons/obj/items/clothes/undershirt.dmi'
	gendered = TRUE
	mob_overlay_icon = 'icons/obj/items/clothes/on_mob/undershirt.dmi'
	icon_state = "solid"
	item_state = "solid"
	w_class = WEIGHT_CLASS_SMALL
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	blade_dulling = DULLING_CUT
	max_integrity = 200
	integrity_failure = 0.1
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	slot_flags = NONE
	extra_slot_flags = EXTRA_SLOT_UNDERSHIRT
	flags_inv = HIDEBOOB
	boobed = TRUE
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null
	/// Areas that must be accessible to put on or remove this one-piece garment.
	var/strip_zones = CHEST | GROIN
	var/worn_offset = OFFSET_SHIRT
	var/worn_offset_f = OFFSET_SHIRT_F

/obj/item/clothing/undershirt/attack(mob/M, mob/user, def_zone)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.undershirt)
			if(H.is_inventory_slot_obscured(SLOT_UNDERSHIRT, src))
				return
			user.visible_message(span_notice("[user] tries to put [src] on [H]..."))
			if(do_after(user, 50, target = H))
				equip_from_hands(user, H, SLOT_UNDERSHIRT)

/obj/item/clothing/undershirt/leotard
	name = "leotard"
	icon_state = "leotard"
	item_state = "leotard"
	boob_sized = TRUE
	boobed = FALSE
	flags_inv = HIDECROTCH | HIDEBOOB

/obj/item/clothing/undershirt/athletic_leotard
	name = "athletic leotard"
	icon_state = "athletic_leotard"
	item_state = "athletic_leotard"
	boobed = FALSE
	flags_inv = HIDECROTCH | HIDEBOOB

/obj/item/clothing/undershirt/solid_half
	name = "sheer half-body"
	icon_state = "solid-half"
	item_state = "solid-half"
	strip_zones = CHEST

/obj/item/clothing/undershirt/fullbody
	name = "full-body suit"
	desc = "Leaves both everything and nothing to imagination."
	icon_state = "full"
	item_state = "full"
	flags_inv = HIDECROTCH | HIDEBOOB
	sleeved = 'icons/obj/items/clothes/on_mob/helpers/undershirt.dmi'
	nodismemsleeves = FALSE
	sleevetype = "shirt"

/obj/item/clothing/undershirt/silk
	salvage_result = /obj/item/natural/silk
	name = "silk body"
	icon_state = "silk"
	item_state = "silk"

/obj/item/clothing/undershirt/silk_half
	salvage_result = /obj/item/natural/silk
	name = "silk half-body"
	icon_state = "silk-half"
	item_state = "silk-half"
	strip_zones = CHEST

/obj/item/clothing/undershirt/mesh
	salvage_result = /obj/item/natural/fibers
	name = "mesh body"
	icon_state = "mesh"
	item_state = "mesh"

/obj/item/clothing/undershirt/mesh_half
	salvage_result = /obj/item/natural/fibers
	name = "mesh half-body"
	icon_state = "mesh-half"
	item_state = "mesh-half"
	strip_zones = CHEST

/obj/item/clothing/undershirt/net
	salvage_result = /obj/item/natural/fibers
	name = "net body"
	icon_state = "net"
	item_state = "net"

/obj/item/clothing/undershirt/net_half
	salvage_result = /obj/item/natural/fibers
	name = "net half-body"
	icon_state = "net-half"
	item_state = "net-half"
	strip_zones = CHEST

/obj/item/clothing/undershirt/bandages
	name = "body bandages"
	desc = "Cloth bandages wrapped around the chest and hips."
	icon_state = "bandages"
	item_state = "bandages"
	boobed = FALSE
	flags_inv = HIDECROTCH | HIDEBOOB
	worn_offset = OFFSET_UNDERWEAR_BOTTOM
	worn_offset_f = OFFSET_UNDERWEAR_BOTTOM_F

/datum/crafting_recipe/roguetown/sewing/bandages_underwear
	category = "Underwear"
	name = "bandages (underwear)"
	result = list(/obj/item/clothing/undershirt/bandages)
	reqs = list(/obj/item/natural/cloth/bandage = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/undershirt
	name = "Sheer Body"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt)
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undershirt/leotard
	name = "Leotard"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt/leotard)
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undershirt/athletic_leotard
	name = "Athletic Leotard"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt/athletic_leotard)
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undershirt/solid_half
	name = "Sheer Half-Body"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt/solid_half)
	reqs = list(/obj/item/natural/cloth = 1, /obj/item/natural/fibers = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undershirt/fullbody
	name = "Full-Body Suit"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt/fullbody)
	reqs = list(/obj/item/natural/cloth = 3, /obj/item/natural/fibers = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/sewing/undershirt/silk
	name = "Silk Body"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt/silk)
	reqs = list(/obj/item/natural/silk = 2, /obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/undershirt/silk_half
	name = "Silk Half-Body"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt/silk_half)
	reqs = list(/obj/item/natural/silk = 1, /obj/item/natural/fibers = 1)
	craftdiff = 5

/datum/crafting_recipe/roguetown/sewing/undershirt/mesh
	name = "Mesh Body"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt/mesh)
	reqs = list(/obj/item/natural/fibers = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undershirt/mesh_half
	name = "Mesh Half-Body"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt/mesh_half)
	reqs = list(/obj/item/natural/fibers = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undershirt/net
	name = "Net Body"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt/net)
	reqs = list(/obj/item/natural/fibers = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/undershirt/net_half
	name = "Net Half-Body"
	category = "Underwear"
	result = list(/obj/item/clothing/undershirt/net_half)
	reqs = list(/obj/item/natural/fibers = 2)
	craftdiff = 3
