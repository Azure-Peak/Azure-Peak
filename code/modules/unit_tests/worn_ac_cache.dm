/datum/unit_test/worn_ac_cache/Run()
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human)
	TEST_ASSERT_EQUAL(H.highest_ac_worn(), ARMOR_CLASS_NONE, "Naked human should have no AC")
	TEST_ASSERT_EQUAL(H.highest_ac_worn(check_hands = TRUE), ARMOR_CLASS_NONE, "Naked human should have no AC in hands")

	var/obj/item/clothing/body_armor = allocate(/obj/item/clothing/head/roguetown/helmet)
	body_armor.armor_class = ARMOR_CLASS_HEAVY
	H.equip_to_slot(body_armor, SLOT_ARMOR, TRUE)
	TEST_ASSERT_EQUAL(H.wear_armor, body_armor, "Armor did not reach the armor slot")
	TEST_ASSERT_EQUAL(H.highest_ac_worn(), ARMOR_CLASS_HEAVY, "Worn heavy armor not counted")
	TEST_ASSERT_EQUAL(H.highest_ac_worn(FALSE, FALSE), ARMOR_CLASS_HEAVY, "check_helmet = FALSE should still count body armor")
	TEST_ASSERT(!H.check_armor_skill(), "Untrained human should fail check_armor_skill in heavy armor")
	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	TEST_ASSERT(H.check_armor_skill(), "Heavy-trained human should pass check_armor_skill in heavy armor")

	var/obj/item/clothing/helmet = allocate(/obj/item/clothing/head/roguetown/helmet)
	helmet.armor_class = ARMOR_CLASS_MEDIUM
	H.equip_to_slot(helmet, SLOT_HEAD, TRUE)
	TEST_ASSERT_EQUAL(H.head, helmet, "Helmet did not reach the head slot")
	H.dropItemToGround(body_armor, TRUE)
	TEST_ASSERT_NULL(H.wear_armor, "Armor slot should be empty after drop")
	TEST_ASSERT_EQUAL(H.highest_ac_worn(), ARMOR_CLASS_MEDIUM, "Worn helmet not counted after armor drop")
	TEST_ASSERT_EQUAL(H.highest_ac_worn(FALSE, FALSE), ARMOR_CLASS_NONE, "check_helmet = FALSE should exclude the helmet")

	var/obj/item/clothing/held = allocate(/obj/item/clothing/head/roguetown/helmet)
	held.armor_class = ARMOR_CLASS_HEAVY
	H.put_in_hands(held, forced = TRUE)
	TEST_ASSERT(H.is_holding(held), "Held clothing did not reach the hands")
	TEST_ASSERT_EQUAL(H.highest_ac_worn(check_hands = TRUE), ARMOR_CLASS_HEAVY, "Held clothing not counted with check_hands")
	TEST_ASSERT_EQUAL(H.highest_ac_worn(), ARMOR_CLASS_MEDIUM, "Held clothing should not count without check_hands")
	H.dropItemToGround(held, TRUE)
	TEST_ASSERT_EQUAL(H.highest_ac_worn(check_hands = TRUE), ARMOR_CLASS_MEDIUM, "Hands should not count after drop")

	qdel(helmet)
	TEST_ASSERT_EQUAL(H.highest_ac_worn(), ARMOR_CLASS_NONE, "Deleted worn helmet should not count")

	var/obj/item/clothing/second_armor = allocate(/obj/item/clothing/head/roguetown/helmet)
	second_armor.armor_class = ARMOR_CLASS_MEDIUM
	H.equip_to_slot(second_armor, SLOT_SHIRT, TRUE)
	TEST_ASSERT_EQUAL(H.highest_ac_worn(), ARMOR_CLASS_MEDIUM, "Worn shirt armor not counted")
	H.transferItemToLoc(second_armor, run_loc_floor_bottom_left, TRUE)
	TEST_ASSERT_NULL(H.wear_shirt, "Shirt slot should be empty after transfer")
	TEST_ASSERT_EQUAL(H.highest_ac_worn(), ARMOR_CLASS_NONE, "Transferred armor should not count")
