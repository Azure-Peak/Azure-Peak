/obj/item/storage/belt/rogue/pouch
	name = "pouch"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt."
	icon = 'icons/roguetown/clothing/storage.dmi'
	mob_overlay_icon = null
	icon_state = "pouch"
	item_state = "pouch"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("whips", "lashes")
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE
	resistance_flags = FIRE_PROOF
	grid_height = 64
	grid_width = 32
	component_type = /datum/component/storage/concrete/roguetown/coin_pouch

/obj/item/storage/belt/rogue/pouch/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return

	if(!istype(target, /obj/item/roguecoin))
		return

	var/obj/item/roguecoin/target_coin = target

	if(QDELETED(target_coin) || target_coin.quantity <= 0) // Verify target coin still exists and has a valid quantity
		return

	var/datum/component/storage/storage_comp = GetComponent(/datum/component/storage)
	if(!storage_comp)
		return

	var/original_target_quantity = target_coin.quantity 	// Store original quantity for verification
	var/coins_to_collect = original_target_quantity

	// First, try to find existing coin stacks of the same type that aren't full
	for(var/obj/item/roguecoin/pouch_coin in storage_comp.contents())
		// Skip if not the same type of coin
		if(pouch_coin.base_type != target_coin.base_type)
			continue

		// Skip if this stack is already full
		if(pouch_coin.quantity >= 20)
			continue

		var/space_available = 20 - pouch_coin.quantity // Calculate how many coins we can add to this stack
		var/coins_to_add = min(coins_to_collect, space_available)

		// Merge coins into the existing stack
		pouch_coin.set_quantity(pouch_coin.quantity + coins_to_add)
		coins_to_collect -= coins_to_add

		if(coins_to_collect <= 0) // If we've collected all coins, break out
			break

	while(coins_to_collect > 0) // If we still have coins to collect, try to create new stacks in the pouch
		var/obj/item/roguecoin/new_coin = new target_coin.type() // Create a new coin stack to insert into the pouch
		var/coins_for_new_stack = min(coins_to_collect, 20)
		new_coin.set_quantity(coins_for_new_stack)
		new_coin.heads_tails = target_coin.heads_tails

		// Try to insert the new coin into storage
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_coin, null, TRUE, TRUE))
			// Storage is full or can't accept the item, clean up and stop
			qdel(new_coin)
			break

		coins_to_collect -= coins_for_new_stack // Successfully added, reduce coins to collect

	// Calculate how many coins were actually collected
	var/coins_collected = original_target_quantity - coins_to_collect

	// If we collected some coins, update the target
	if(coins_collected > 0)
		target_coin.set_quantity(coins_to_collect)

		// If target is now empty, delete it
		if(target_coin.quantity <= 0)
			to_chat(user, span_notice("I collect [coins_collected] coin[coins_collected > 1 ? "s" : ""] into [src]."))
			qdel(target_coin)
		else
			to_chat(user, span_notice("I collect [coins_collected] coin[coins_collected > 1 ? "s" : ""] into [src]. [coins_to_collect] coin[coins_to_collect > 1 ? "s" : ""] remain[coins_to_collect == 1 ? "s" : ""]."))

		playsound(loc, 'sound/foley/coins1.ogg', 100, TRUE, -2)
	else
		// No coins were collected (storage full)
		to_chat(user, span_warning("[src] is too full to collect any more coins!"))

//Special pouch for merchants / stewards, holds a lot of coin stacks but nothing else.
/obj/item/storage/belt/rogue/pouch/merchant
	name = "merchant pouch"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt. Specifically constructed by the Guild to carry mammon efficiently; and nothing else."
	icon_state = "pouch_merchant"
	item_state = "pouch_merchant"
	sellprice = 50
	grid_height = 64
	grid_width = 32
	component_type = /datum/component/storage/concrete/roguetown/coin_pouch/merchant

/obj/item/storage/belt/rogue/pouch/merchant/coins/Initialize() //Same as coins/rich
	. = ..()
	var/obj/item/roguecoin/silver/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	if(prob(50))
		H = new(loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				qdel(H)

/obj/item/storage/belt/rogue/pouch/cloth
	name = "cloth pouch"
	desc = "Usually used for holding small amount of coins."
	icon_state = "clothpouch"
	component_type = /datum/component/storage/concrete/roguetown/coin_pouch/cloth

/obj/item/storage/belt/rogue/pouch/coins

/obj/item/storage/belt/rogue/pouch/coins/mid/Initialize()
	. = ..()
	var/obj/item/roguecoin/silver/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	var/obj/item/roguecoin/copper/pile/C = new(loc)
	if(istype(C))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, C, null, TRUE, TRUE))
			qdel(C)

/obj/item/storage/belt/rogue/pouch/coins/poor/Initialize()
	. = ..()
	var/obj/item/roguecoin/copper/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	if(prob(50))
		H = new(loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				qdel(H)

/obj/item/storage/belt/rogue/pouch/coins/rich/Initialize()
	. = ..()
	var/obj/item/roguecoin/silver/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	if(prob(50))
		H = new(loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				qdel(H)

/obj/item/storage/belt/rogue/pouch/coins/veryrich/Initialize()
	. = ..()
	var/obj/item/roguecoin/gold/pile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)
	if(prob(50))
		H = new(loc)
		if(istype(H))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
				qdel(H)

/obj/item/storage/belt/rogue/pouch/coins/virtuepouch/Initialize()
	. = ..()
	var/obj/item/roguecoin/gold/virtuepile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)

/obj/item/storage/belt/rogue/pouch/coins/readyuppouch/Initialize()
	. = ..()
	var/obj/item/roguecoin/silver/pile/readyuppile/H = new(loc)
	if(istype(H))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, H, null, TRUE, TRUE))
			qdel(H)

/obj/item/storage/belt/rogue/pouch/food/PopulateContents()
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)
