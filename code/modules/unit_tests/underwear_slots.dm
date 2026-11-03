// Keep regression tests on the real equip, customization, rendering and stripping paths.
/datum/unit_test/underwear_slot_roundtrip/Run()
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human/species/human/northern)
	H.gender = MALE
	var/list/garments = list(
		/obj/item/clothing/undies = SLOT_UNDER_BOTTOM,
		/obj/item/clothing/undies/bikini_bottom = SLOT_UNDER_BOTTOM,
		/obj/item/clothing/bra = SLOT_UNDER_TOP,
		/obj/item/clothing/undershirt = SLOT_UNDERSHIRT,
		/obj/item/clothing/legwears = SLOT_SOCKS,
		/obj/item/clothing/armsleeves = SLOT_ARMSLEEVES,
		/obj/item/clothing/garter = SLOT_GARTER,
		/obj/item/clothing/choker = SLOT_CHOKER,
		/obj/item/earring = SLOT_EARRING_L,
	)
	for(var/garment_type in garments)
		var/slot = garments[garment_type]
		var/obj/item/I = allocate(garment_type)
		TEST_ASSERT(I.fits_slot(slot), "[garment_type] does not match its intended slot")
		TEST_ASSERT(!I.fits_slot(SLOT_PANTS), "[garment_type] leaked into the legacy pants bitfield")
		TEST_ASSERT(H.equip_to_slot_if_possible(I, slot, bypass_equip_delay_self = TRUE), "Could not equip [garment_type]")
		TEST_ASSERT_EQUAL(H.get_item_by_slot(slot), I, "Slot lookup returned a different item")
		TEST_ASSERT(I in H.get_equipped_items(), "Equipped item missing from visibility/inventory enumeration")
		TEST_ASSERT(H.dropItemToGround(I), "Could not remove [garment_type]")
		TEST_ASSERT_NULL(H.get_item_by_slot(slot), "Slot reference survived unequip")
	TEST_ASSERT_NULL(H.overlays_standing[UNDERWEAR_BOT_LAYER], "Underwear overlay survived unequip")
	TEST_ASSERT_NULL(H.overlays_standing[UNDERWEAR_TOP_LAYER], "Bra overlay survived unequip")
	TEST_ASSERT_NULL(H.overlays_standing[LEGWEAR_LAYER], "Stocking overlay survived unequip")
	var/obj/item/earring/right = allocate(/obj/item/earring)
	TEST_ASSERT(H.equip_to_slot_if_possible(right, SLOT_EARRING_R, bypass_equip_delay_self = TRUE), "Right earring slot was not handled")
	TEST_ASSERT_EQUAL(H.earring_r, right, "Right earring entered the wrong slot")
	var/mob/living/carbon/human/giver = allocate(/mob/living/carbon/human/species/human/northern)
	var/obj/item/clothing/undies/transferred = allocate(/obj/item/clothing/undies)
	TEST_ASSERT(giver.put_in_hands(transferred), "Could not prepare direct clothing interaction")
	TEST_ASSERT(transferred.equip_from_hands(giver, H, SLOT_UNDER_BOTTOM), "Direct equip failed")
	TEST_ASSERT_EQUAL(H.underwear, transferred, "Direct equip did not set the recipient slot")
	TEST_ASSERT(!giver.is_holding(transferred), "Direct equip left a ghost item in the giver's hand")
	TEST_ASSERT_EQUAL(transferred.loc, H, "Direct equip did not move the item to its wearer")
	TEST_ASSERT_EQUAL(SLOT_BACK, 21, "Legacy back slot ID changed")
	TEST_ASSERT_NOTEQUAL(SLOT_BACK, SLOT_UNDER_BOTTOM, "Underwear aliases the legacy back slot")

/datum/unit_test/underwear_customization/Run()
	var/list/accessories = list(
		/datum/sprite_accessory/underwear/briefs = SLOT_UNDER_BOTTOM,
		/datum/sprite_accessory/underwear/panties = SLOT_UNDER_BOTTOM,
		/datum/sprite_accessory/underwear/braies = SLOT_UNDER_BOTTOM,
		/datum/sprite_accessory/underwear/briefs/eoran = SLOT_UNDER_BOTTOM,
		/datum/sprite_accessory/underwear/bikini = SLOT_UNDER_BOTTOM,
		/datum/sprite_accessory/underwear/bandages = SLOT_UNDER_BOTTOM,
		/datum/sprite_accessory/underwear/leotard = SLOT_UNDERSHIRT,
		/datum/sprite_accessory/underwear/athletic_leotard = SLOT_UNDERSHIRT,
		/datum/sprite_accessory/underwear/bikini_top = SLOT_UNDER_TOP,
	)
	for(var/accessory_type in accessories)
		var/mob/living/carbon/human/dummy/H = allocate(/mob/living/carbon/human/dummy)
		H.set_species(/datum/species/human/northern)
		H.gender = MALE
		var/datum/bodypart_feature/underwear/feature = new
		feature.set_accessory_type(accessory_type, "#557799", H)
		TEST_ASSERT_NULL(H.underwear, "Setting accessory metadata prematurely populated the inventory")
		H.add_bodypart_feature(feature)
		var/obj/item/garment = H.get_item_by_slot(accessories[accessory_type])
		TEST_ASSERT_NOTNULL(garment, "[accessory_type] did not produce equipped clothing")
		TEST_ASSERT_EQUAL(garment.color, feature.accessory_colors, "Customizer color was lost")
		TEST_ASSERT(garment.icon_state in icon_states(garment.icon), "Customizer garment has no inventory sprite")
		if(istype(garment, /obj/item/undies))
			var/mutable_appearance/piece = H.overlays_standing[UNDERWEAR_BOT_LAYER]
			TEST_ASSERT_NOTNULL(piece, "Legacy underwear did not reach the overlay cache")
			TEST_ASSERT(length(piece.overlays), "Legacy underwear hid its own accessory sprite")
		var/count = 0
		for(var/obj/item/clothing/I in H.contents)
			if(I.extra_slot_flags)
				count++
		TEST_ASSERT_EQUAL(count, 1, "Customizer created duplicate/untracked garments")
		var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
		TEST_ASSERT(!(feature in chest.bodypart_features), "Old body feature rendered alongside worn clothing")
		H.delete_equipment()
		TEST_ASSERT_NULL(H.get_item_by_slot(accessories[accessory_type]), "Preview dummy retained clothing after cleanup")
		qdel(feature)

	var/mob/living/carbon/human/dummy/wearer = allocate(/mob/living/carbon/human/dummy)
	wearer.set_species(/datum/species/human/northern)
	wearer.gender = MALE
	var/datum/bodypart_feature/legwear/socks_feature = new
	socks_feature.set_accessory_type(/datum/sprite_accessory/legwear/stockings/silk, "#557799", wearer)
	wearer.add_bodypart_feature(socks_feature)
	TEST_ASSERT(istype(wearer.legwear_socks, /obj/item/clothing/legwears/silk), "Legwear preference did not equip the selected stockings")
	TEST_ASSERT_EQUAL(wearer.legwear_socks.color, socks_feature.accessory_colors, "Stocking customizer color was lost")
	qdel(socks_feature)

/datum/unit_test/underwear_rendering/Run()
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human/species/human/northern)
	H.gender = MALE
	var/obj/item/clothing/bra/bikini/top = allocate(/obj/item/clothing/bra/bikini)
	for(var/size in 0 to 6)
		var/mutable_appearance/piece = top.build_worn_icon(default_layer = UNDERWEAR_TOP_LAYER, female = TRUE, breast_size = size)
		TEST_ASSERT(piece.icon_state in icon_states(piece.icon), "Bikini top size [size] produced a missing sprite")
		TEST_ASSERT_EQUAL(piece.layer, -UNDERWEAR_TOP_LAYER, "Bra uses the wrong render layer")
	var/obj/item/clothing/undies/bottom = allocate(/obj/item/clothing/undies)
	TEST_ASSERT(H.equip_to_slot_if_possible(bottom, SLOT_UNDER_BOTTOM, bypass_equip_delay_self = TRUE), "Could not equip underwear for render test")
	var/mutable_appearance/piece = H.overlays_standing[UNDERWEAR_BOT_LAYER]
	TEST_ASSERT_NOTNULL(piece, "Equipping underwear did not populate its overlay cache")
	TEST_ASSERT(piece.icon_state in icon_states(piece.icon), "Equipped underwear has a missing icon state")
	TEST_ASSERT_EQUAL(piece.layer, -UNDERWEAR_BOT_LAYER, "Underwear has an incorrect render layer")
	TEST_ASSERT(BODYPARTS_LAYER > UNDERWEAR_BOT_LAYER && UNDERWEAR_BOT_LAYER > PANTS_LAYER, "Underwear must render above skin and below trousers")
	TEST_ASSERT_NOTEQUAL(BACK_BEHIND_LAYER, BODY_BEHIND_LAYER, "Back and body overlays share a cache index")
	TEST_ASSERT(UNDER_ARMOR_CACHE_INDEX <= TOTAL_LAYERS, "Overlay cache is too short")

/mob/living/carbon/human/dummy/underwear_strip_test
	gender = MALE

/mob/living/carbon/human/dummy/underwear_strip_test/show_inv(mob/user, extra_only = FALSE)
	return // No browser client is attached to the unit test mobs.

/datum/unit_test/underwear_stripping/Run()
	var/mob/living/carbon/human/dummy/underwear_strip_test/target = allocate(/mob/living/carbon/human/dummy/underwear_strip_test)
	target.set_species(/datum/species/human/northern)
	target.gender = MALE
	var/mob/living/carbon/human/actor = allocate(/mob/living/carbon/human/species/human/northern)
	var/obj/item/clothing/undies/bottom = allocate(/obj/item/clothing/undies)
	TEST_ASSERT(target.equip_to_slot_if_possible(bottom, SLOT_UNDER_BOTTOM, bypass_equip_delay_self = TRUE), "Could not prepare strip target")
	var/html = target.get_inventory_panel(actor, TRUE)
	TEST_ASSERT(findtext(html, "item=[SLOT_UNDER_BOTTOM]"), "Strip panel did not emit the numeric underwear slot ID")
	var/obj/item/clothing/cover = allocate(/obj/item/clothing)
	cover.flags_inv = HIDECROTCH
	target.equip_to_slot(cover, SLOT_PANTS, TRUE)
	TEST_ASSERT(target.is_inventory_slot_obscured(SLOT_UNDER_BOTTOM), "Outer clothing did not block underwear access")
	actor.stripPanelUnequip(bottom, target, SLOT_UNDER_BOTTOM, TRUE)
	TEST_ASSERT_EQUAL(target.underwear, bottom, "Covered underwear could be stripped")
	target.dropItemToGround(cover, TRUE)
	TEST_ASSERT(!target.is_inventory_slot_obscured(SLOT_UNDER_BOTTOM), "Underwear obscured its own slot")
	target.cmode = FALSE
	actor.enhanced_strip = TRUE
	actor.stripPanelUnequip(bottom, target, SLOT_UNDER_BOTTOM, TRUE)
	TEST_ASSERT_NULL(target.underwear, "Strip panel did not clear the underwear slot")
	TEST_ASSERT_NULL(target.overlays_standing[UNDERWEAR_BOT_LAYER], "Strip panel left the underwear sprite behind")
	TEST_ASSERT_EQUAL(bottom.loc, get_turf(target), "Stripped garment was not dropped")
