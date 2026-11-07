/obj/effect/spawner/coins
	name = "coins"
	icon = 'icons/roguetown/helpers/spawnerhelpers.dmi'
	icon_state = "money"
	var/mammon_min = 0
	var/mammon_max = 0
	var/mammon_step = 1
	var/max_coin_value = COIN_VALUE_GOLD

/obj/effect/spawner/coins/Initialize(mapload)
	. = ..()
	var/list/coins = spawn_coin_tier(type, loc)
	if(isturf(loc))
		for(var/obj/item/roguecoin/stack as anything in coins)
			stack.pixel_x = pixel_x
			stack.pixel_y = pixel_y
	return INITIALIZE_HINT_QDEL

/obj/effect/spawner/coins/tiny
	mammon_min = 10
	mammon_max = 10

/obj/effect/spawner/coins/handful
	mammon_min = 4
	mammon_max = 19
	max_coin_value = COIN_VALUE_COPPER

/obj/effect/spawner/coins/small
	mammon_min = 20
	mammon_max = 95
	mammon_step = COIN_VALUE_SILVER
	max_coin_value = COIN_VALUE_SILVER

/obj/effect/spawner/coins/medium
	mammon_min = 40
	mammon_max = 190
	mammon_step = 10

/obj/effect/spawner/coins/large
	mammon_min = 200
	mammon_max = 200

/proc/roll_coin_tier(obj/effect/spawner/coins/tier)
	return roll_mammons(initial(tier.mammon_min), initial(tier.mammon_max), initial(tier.mammon_step))

/proc/spawn_coin_tier(obj/effect/spawner/coins/tier, atom/destination)
	return spawn_mammons(roll_coin_tier(tier), destination, initial(tier.max_coin_value))
