/obj/item/storage/belt/rogue/pouch
	name = "pouch"
	desc = "A small sack with a drawstring that allows it to be worn around the neck. Or at the hips, provided you have a belt."
	icon = 'icons/roguetown/clothing/storage.dmi'
	mob_overlay_icon = null
	icon_state = "pouch"
	item_state = "pouch"
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_CLOAK
	w_class = WEIGHT_CLASS_NORMAL
	attack_verb = list("whips", "lashes")
	max_integrity = 300
	equip_sound = 'sound/blank.ogg'
	content_overlays = FALSE
	bloody_icon_state = "bodyblood"
	sewrepair = TRUE
	resistance_flags = FIRE_PROOF
	experimental_inhand = TRUE
	experimental_onhip = TRUE
	grid_height = 64
	grid_width = 32
	component_type = /datum/component/storage/concrete/roguetown/coin_pouch
	var/mammon_min = 0
	var/mammon_max = 0
	var/mammon_step = 1
	var/max_coin_value = COIN_VALUE_GOLD

/obj/item/storage/belt/rogue/pouch/PopulateContents()
	. = ..()
	populate_mammons()

/obj/item/storage/belt/rogue/pouch/proc/populate_mammons()
	var/mammons = roll_pouch_mammons()
	if(mammons > 0)
		spawn_mammons(mammons, src, max_coin_value)

/obj/item/storage/belt/rogue/pouch/proc/roll_pouch_mammons()
	if(mammon_max <= 0)
		return 0
	return roll_mammons(mammon_min, mammon_max, mammon_step)

/obj/item/storage/belt/rogue/pouch/proc/roll_tier_piles(tier, piles, bonus_pile_chance = 0)
	. = 0
	for(var/i in 1 to piles)
		. += roll_coin_tier(tier)
	if(prob(bonus_pile_chance))
		. += roll_coin_tier(tier)

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

	var/original_target_quantity = target_coin.quantity	// Store original quantity for verification
	var/coins_to_collect = original_target_quantity

	// First, try to find existing coin stacks of the same type that aren't full
	for(var/obj/item/roguecoin/pouch_coin in storage_comp.contents())
		// Skip if not the same type of coin
		if(pouch_coin.base_type != target_coin.base_type)
			continue

		// Skip if this stack is already full
		if(pouch_coin.quantity >= MAX_COIN_STACK_SIZE)
			continue

		var/space_available = MAX_COIN_STACK_SIZE - pouch_coin.quantity // Calculate how many coins we can add to this stack
		var/coins_to_add = min(coins_to_collect, space_available)

		// Merge coins into the existing stack
		pouch_coin.set_quantity(pouch_coin.quantity + coins_to_add)
		coins_to_collect -= coins_to_add

		if(coins_to_collect <= 0) // If we've collected all coins, break out
			break

	while(coins_to_collect > 0) // If we still have coins to collect, try to create new stacks in the pouch
		var/obj/item/roguecoin/new_coin = new target_coin.type() // Create a new coin stack to insert into the pouch
		var/coins_for_new_stack = min(coins_to_collect, MAX_COIN_STACK_SIZE)
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

/obj/item/storage/belt/rogue/pouch/merchant/coins //Same as coins/rich
	max_coin_value = COIN_VALUE_SILVER

/obj/item/storage/belt/rogue/pouch/merchant/coins/roll_pouch_mammons()
	return roll_tier_piles(/obj/effect/spawner/coins/small, 2, 50)

/obj/item/storage/belt/rogue/pouch/cloth
	name = "cloth pouch"
	desc = "Usually used for holding small amount of coins."
	icon_state = "clothpouch"
	component_type = /datum/component/storage/concrete/roguetown/coin_pouch/cloth

/obj/item/storage/belt/rogue/pouch/coins
	preload = TRUE

/obj/item/storage/belt/rogue/pouch/coins/PopulateContents()
	for(var/path in populate_contents)
		var/obj/item/new_item = SSwardrobe.provide_type(path, loc)
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))
			new_item.inventory_flip(null, TRUE)
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, new_item, null, TRUE, TRUE))

				SSwardrobe.recycle_object(new_item)
	populate_mammons()

/obj/item/storage/belt/rogue/pouch/coins/get_types_to_preload()
	. = list()
	for(var/obj/item/roguecoin/coin_type as anything in GLOB.coin_denominations)
		if(initial(coin_type.sellprice) <= max_coin_value)
			. += coin_type

/obj/item/storage/belt/rogue/pouch/coins/poor
	max_coin_value = COIN_VALUE_COPPER

/obj/item/storage/belt/rogue/pouch/coins/poor/roll_pouch_mammons()
	return max(roll_coin_tier(/obj/effect/spawner/coins/handful), 10) + roll_tier_piles(/obj/effect/spawner/coins/handful, 0, 50)

/obj/item/storage/belt/rogue/pouch/coins/mid
	max_coin_value = COIN_VALUE_SILVER

/obj/item/storage/belt/rogue/pouch/coins/mid/roll_pouch_mammons()
	return roll_coin_tier(/obj/effect/spawner/coins/small) + roll_coin_tier(/obj/effect/spawner/coins/handful)

/obj/item/storage/belt/rogue/pouch/coins/rich
	max_coin_value = COIN_VALUE_SILVER

/obj/item/storage/belt/rogue/pouch/coins/rich/roll_pouch_mammons()
	return roll_tier_piles(/obj/effect/spawner/coins/small, 2, 50)

/obj/item/storage/belt/rogue/pouch/coins/veryrich/roll_pouch_mammons()
	return roll_tier_piles(/obj/effect/spawner/coins/medium, 2, 50)

/obj/item/storage/belt/rogue/pouch/coins/aspirantpouch // Fixed 200 mammons for aspirants which is a good psychological number to buy 1 merc's service
	mammon_min = 200
	mammon_max = 200

/obj/item/storage/belt/rogue/pouch/coins/bigandfat
	mammon_min = 800
	mammon_max = 800

/obj/item/storage/belt/rogue/pouch/coins/virtuepouch
	mammon_min = 80
	mammon_max = 120
	mammon_step = 10

/obj/item/storage/belt/rogue/pouch/coins/readyuppouch // 20 mammons combine with starting pouch to buy something
	mammon_min = 20
	mammon_max = 20
	max_coin_value = COIN_VALUE_SILVER

/obj/item/storage/belt/rogue/pouch/coins/wretchpouch // 50 mammons, to avoid being dead broke when latejoining
	mammon_min = 50
	mammon_max = 50
	max_coin_value = COIN_VALUE_SILVER

/obj/item/storage/belt/rogue/pouch/coins/munitioneerpouch //for muntineer, exclusely to speed up them aquiring materials w/ out having to benefit town by selling to them or lose the arms race against the guild.
	mammon_min = 80
	mammon_max = 80
	max_coin_value = COIN_VALUE_SILVER

/obj/item/storage/belt/rogue/pouch/coins/aalloy

/obj/item/storage/belt/rogue/pouch/coins/aalloy/get_types_to_preload()
	var/list/to_preload = list()
	to_preload += /obj/item/roguecoin/aalloy/pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/aalloy/PopulateContents()
	. = ..()
	var/obj/item/roguecoin/aalloy/pile/A = SSwardrobe.provide_type(/obj/item/roguecoin/aalloy/pile, loc)
	if(istype(A))
		if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, TRUE, TRUE))
			SSwardrobe.recycle_object(A)

/obj/item/storage/belt/rogue/pouch/coins/aalloy/mid

/obj/item/storage/belt/rogue/pouch/coins/aalloy/mid/get_types_to_preload()
	var/list/to_preload = list()
	to_preload += /obj/item/roguecoin/aalloy/pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/aalloy/mid/PopulateContents()
	. = ..()
	for(var/i in 1 to 2) //hilarious
		var/obj/item/roguecoin/aalloy/pile/A = SSwardrobe.provide_type(/obj/item/roguecoin/aalloy/pile, loc)
		if(istype(A))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, TRUE, TRUE))
				SSwardrobe.recycle_object(A)

/obj/item/storage/belt/rogue/pouch/coins/aalloy/rich

/obj/item/storage/belt/rogue/pouch/coins/aalloy/rich/get_types_to_preload()
	var/list/to_preload = list()
	to_preload += /obj/item/roguecoin/aalloy/pile
	return to_preload

/obj/item/storage/belt/rogue/pouch/coins/aalloy/rich/PopulateContents()
	. = ..()
	for(var/i in 1 to 3) //hilarious
		var/obj/item/roguecoin/aalloy/pile/A = SSwardrobe.provide_type(/obj/item/roguecoin/aalloy/pile, loc)
		if(istype(A))
			if(!SEND_SIGNAL(src, COMSIG_TRY_STORAGE_INSERT, A, null, TRUE, TRUE))
				SSwardrobe.recycle_object(A)

/obj/item/storage/belt/rogue/pouch/food/PopulateContents()
	new /obj/item/reagent_containers/food/snacks/rogue/crackerscooked(src)

/obj/item/storage/belt/rogue/pouch/healing

/obj/item/storage/belt/rogue/pouch/healing/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/healthpot(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical/water(src)
	new /obj/item/needle(src)

/obj/item/storage/belt/rogue/pouch/alchemy

/obj/item/storage/belt/rogue/pouch/alchemy/PopulateContents()
	new /obj/item/reagent_containers/glass/bottle/alchemical(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical(src)
	new /obj/item/reagent_containers/glass/bottle/alchemical(src)
	new /obj/item/needle(src)

/obj/item/storage/belt/rogue/pouch/zigarrete
	name = "zig box"
	desc = "Used to hold someone's zigs and flints."
	icon_state = "smokebox"
	item_state = "smokebox"
	component_type = /datum/component/storage/concrete/roguetown/zig_box
	dropshrink = 0.5

/obj/item/storage/belt/rogue/pouch/zigarrete/nicotine/PopulateContents()
	new /obj/item/clothing/mask/cigarette/rollie/nicotine(src)
	new /obj/item/clothing/mask/cigarette/rollie/nicotine(src)
	new /obj/item/clothing/mask/cigarette/rollie/nicotine(src)
	new /obj/item/clothing/mask/cigarette/rollie/nicotine(src)
	new /obj/item/clothing/mask/cigarette/rollie/nicotine(src)
	new /obj/item/clothing/mask/cigarette/rollie/nicotine(src)

/obj/item/storage/belt/rogue/pouch/zigarrete/cannabis/PopulateContents()
	new /obj/item/clothing/mask/cigarette/rollie/cannabis(src)
	new /obj/item/clothing/mask/cigarette/rollie/cannabis(src)
	new /obj/item/clothing/mask/cigarette/rollie/cannabis(src)
	new /obj/item/clothing/mask/cigarette/rollie/cannabis(src)
	new /obj/item/clothing/mask/cigarette/rollie/cannabis(src)
	new /obj/item/clothing/mask/cigarette/rollie/cannabis(src)

/obj/item/storage/belt/rogue/pouch/triumphlunch
	name = "pouched luncheon"
	desc = "A pouch that's been packed for a particularly peckish pilgrim. </br>'I wonder what's for dinner.. !'"
	populate_contents = list(
	/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge,
	/obj/item/reagent_containers/food/snacks/rogue/handpie/meat,
	/obj/item/reagent_containers/glass/bottle/rogue/triumphbeer,
	)

/obj/item/storage/belt/rogue/pouch/bombs

/obj/item/storage/belt/rogue/pouch/bombs/PopulateContents()
	new /obj/item/bomb/noshard(src)
	new /obj/item/bomb/noshard(src)
	new /obj/item/bomb/noshard(src)

/obj/item/storage/belt/rogue/pouch/tailorscrap
	name = "pouch of tailorscrap"
	desc = "A pouch of iron scrap pieces, perfect for reinforcing leather equipment. Now, where'd you place that hammer.. ?"
	populate_contents = list(
	/obj/item/scrap,
	/obj/item/scrap,
	/obj/item/scrap,
	/obj/item/scrap,
	)
