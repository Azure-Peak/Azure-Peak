/datum/unit_test/renegade/Run()
	var/mob/living/carbon/human/H = allocate(/mob/living/carbon/human)
	H.mind_initialize()

	var/obj/item/roguecoin/aalloy/stack = allocate(/obj/item/roguecoin/aalloy, run_loc_floor_bottom_left, 5)
	var/obj/item/roguecoin/aalloy/single = allocate(/obj/item/roguecoin/aalloy, run_loc_floor_bottom_left, 1)
	TEST_ASSERT(!stack.mob_can_equip(H, null, SLOT_MOUTH, TRUE), "A non-Renegade fit a psila stack in their mouth")
	TEST_ASSERT(single.mob_can_equip(H, null, SLOT_MOUTH, TRUE), "A non-Renegade could not mouth a single psilen")
	TEST_ASSERT(!findtext(jointext(single.examine(H), ""), "Flip the coin"), "A non-Renegade saw the Renegade psila examine")

	var/datum/antagonist/renegade/R = H.mind.add_antag_datum(/datum/antagonist/renegade)
	TEST_ASSERT_NOTNULL(R, "Renegade datum was not added")
	TEST_ASSERT_NOTNULL(R.boons, "Renegade has no Boon Menu")
	var/list/vheslie_items = list()
	for(var/path in SSmerchant.supply_packs)
		var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
		if(!PA.not_in_public && (PA.group in VHESLIE_CATEGORIES))
			vheslie_items |= PA.contains
	var/list/dupes = list()
	for(var/datum/renegade_boon/B as anything in R.boons.boon_list)
		for(var/item in B.contains)
			if(item in vheslie_items)
				dupes |= "[B.name] ([item])"
	TEST_ASSERT(!length(dupes), "Renegade boons duplicate Vheslie goods: [english_list(dupes)]")
	var/obj/item/roguecoin/aalloy/purse = locate() in H.held_items
	TEST_ASSERT_NOTNULL(purse, "Renegade was not handed a starting purse")
	TEST_ASSERT_EQUAL(purse.quantity, RENEGADE_STARTING_PSILA, "Starting purse holds the wrong amount")
	TEST_ASSERT(stack.mob_can_equip(H, null, SLOT_MOUTH, TRUE), "A Renegade could not mouth a psila stack")
	TEST_ASSERT(findtext(jointext(single.examine(H), ""), "Flip the coin"), "A Renegade did not see the Renegade psila examine")

	H.dropItemToGround(purse, TRUE)
	H.equip_to_slot(purse, SLOT_MOUTH, TRUE)
	TEST_ASSERT_EQUAL(H.mouth, purse, "Purse did not reach the mouth")

	var/datum/renegade_boon/hood = locate(/datum/renegade_boon/disguise/hood) in R.boons.boon_list
	R.boons.buy(H, hood.type)
	TEST_ASSERT_EQUAL(purse.quantity, RENEGADE_STARTING_PSILA - hood.cost, "Boon price was not taken from the mouth")
	TEST_ASSERT_EQUAL(R.spent, hood.cost, "Spent psila was not tracked")
	TEST_ASSERT(hood.name in R.bought, "Bought boon was not tracked")
	var/obj/item/clothing/head/roguetown/roguehood/black/bought = locate() in H.held_items
	TEST_ASSERT_NOTNULL(bought, "Single-item boon was not put in hand")
	qdel(bought)

	var/datum/renegade_boon/poison = locate(/datum/renegade_boon/poison/strong) in R.boons.boon_list
	purse.set_quantity(poison.cost - 1)
	R.boons.buy(H, poison.type)
	TEST_ASSERT_EQUAL(purse.quantity, poison.cost - 1, "A boon was sold for too little psila")

	var/datum/supply_pack/pack
	for(var/path in SSmerchant.supply_packs)
		var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
		if(!PA.not_in_public && (PA.group in VHESLIE_CATEGORIES))
			pack = PA
			break
	TEST_ASSERT_NOTNULL(pack, "No Vheslie pack found")
	purse.set_quantity(max(1, CEILING(pack.cost / RENEGADE_PSILEN_WORTH, 1)))
	var/list/before = run_loc_floor_bottom_left.contents.Copy() | H.held_items
	R.boons.buy(H, pack.type)
	TEST_ASSERT(QDELETED(purse), "Spending the whole stack did not use it up")
	TEST_ASSERT_NULL(H.mouth, "Mouth not emptied after spending the whole stack")
	for(var/atom/movable/A in (run_loc_floor_bottom_left.contents | H.held_items) - before)
		if(A != H)
			qdel(A)

	H.mind.remove_antag_datum(/datum/antagonist/renegade)
