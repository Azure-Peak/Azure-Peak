#define CTYPE_GOLD "g"
#define CTYPE_SILV "s"
#define CTYPE_COPP "c"
#define CTYPE_ICOIN "i"
#define CTYPE_ANCIENT "a"
#define MAX_COIN_STACK_SIZE 20

/obj/item/roguecoin
	name = ""
	desc = ""
	icon = 'icons/roguetown/items/valuable.dmi'
	icon_state = ""
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	slot_flags = ITEM_SLOT_MOUTH
	dropshrink = 0.2
	drop_sound = 'sound/foley/coinphy (1).ogg'
	sellprice = 0
	static_price = TRUE
	simpleton_price = TRUE
	var/flip_cd
	var/heads_tails = TRUE
	var/last_merged_heads_tails = TRUE
	var/base_type //used for compares
	var/quantity = 1
	var/plural_name
	var/rigged_outcome = 0 //1 for heads, 2 for tails
	resistance_flags = FIRE_PROOF

/obj/item/roguecoin/Initialize(mapload, coin_amount)
	. = ..()
	if(coin_amount >= 1)
		set_quantity(floor(coin_amount))

/obj/item/roguecoin/getonmobprop(tag)
	. = ..()
	if(tag != "gen")
		return
	return list("shrink" = 0.10, "sx" = -6, "sy" = 6, "nx" = 6, "ny" = 7, "wx" = 0, "wy" = 5, "ex" = -1, "ey" = 7, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -50, "sturn" = 40, "wturn" = 50, "eturn" = -50, "nflip" = 0, "sflip" = 8, "wflip" = 8, "eflip" = 0)

/obj/item/roguecoin/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	playsound(loc, 'sound/foley/coins1.ogg', 100, TRUE, -2)
	..() 

/obj/item/roguecoin/get_real_price()
	return sellprice * quantity

/obj/item/roguecoin/proc/set_quantity(new_quantity)
	quantity = new_quantity
	update_icon()
	update_transform()

/obj/item/roguecoin/examine(mob/user)
	. = ..()
	if(quantity > 1)
		. += span_info("\Roman [quantity] coins.")

/obj/item/roguecoin/proc/merge(obj/item/roguecoin/G, mob/user)
	if(!G)
		return
	if(G.base_type != base_type)
		return

	var/amt_to_merge = min(G.quantity, MAX_COIN_STACK_SIZE - quantity)
	if(amt_to_merge <= 0)
		return
	set_quantity(quantity + amt_to_merge)
	last_merged_heads_tails = G.heads_tails

	G.set_quantity(G.quantity - amt_to_merge)
	rigged_outcome = 0
	G.rigged_outcome = 0
	if(user && G.quantity <= 0)
		user.doUnEquip(G)
		user.update_inv_hands()
	if(G.quantity <= 0)
		qdel(G)
	playsound(loc, 'sound/foley/coins1.ogg', 100, TRUE, -2)

/obj/item/roguecoin/attack_right(mob/user)
	if(user.get_active_held_item())
		return ..()
	if(quantity == 1)
		if(HAS_TRAIT(user, TRAIT_BLACKLEG))
			switch(alert(user, "What will you rig the next coin flip to?","XYLIX","Heads","Tails","Play fair"))
				if("Heads")
					rigged_outcome = 1
				if("Tails")
					rigged_outcome = 2
				if("Play fair")
					rigged_outcome = 0
		return
	var/obj/item/roguecoin/new_coin = new type()
	new_coin.set_quantity(1)
	set_quantity(quantity - 1)
	new_coin.heads_tails = last_merged_heads_tails
	user.put_in_hands(new_coin)
	playsound(loc, 'sound/foley/coinphy (2).ogg', 100, TRUE, -2)

/obj/item/roguecoin/attack_hand(mob/user)
	if(user.get_inactive_held_item() == src && quantity > 1)
		var/amt_text = " (1 to [quantity])"
		if(quantity == 1)
			amt_text = ""
		var/amount = input(user, "How many [plural_name] to split?[amt_text]", null, round(quantity/2, 1)) as null|num
		amount = clamp(amount, 0, quantity)
		amount = round(amount, 1) // no taking non-integer coins
		if(!amount)
			return
		if(amount >= quantity)
			return ..()
		var/obj/item/roguecoin/new_coins = new type()
		new_coins.set_quantity(amount)
		new_coins.heads_tails = last_merged_heads_tails
		set_quantity(quantity - amount)

		user.put_in_hands(new_coins)
		playsound(loc, 'sound/foley/coins1.ogg', 100, TRUE, -2)
		return
	..()


/obj/item/roguecoin/attack_self(mob/living/user)
	if(quantity > 1 || !base_type)
		return
	if(world.time < flip_cd + 30)
		return
	flip_cd = world.time
	playsound(user, 'sound/foley/coinphy (1).ogg', 100, FALSE)
	if(prob(50))
		user.visible_message(span_info("[user] flips the coin. Heads!"))
		heads_tails = TRUE
	else
		user.visible_message(span_info("[user] flips the coin. Tails!"))
		heads_tails = FALSE
	update_icon()


/obj/item/roguecoin/inqcoin/attack_self(mob/living/user)
	if(quantity > 1 || !base_type)
		return
	if(world.time < flip_cd + 30)
		return
	flip_cd = world.time
	playsound(user, 'sound/foley/coinphy (1).ogg', 100, FALSE)	
	if(prob(50))
		user.visible_message(span_info("[user] flips the coin. ENDVRE!"))
		heads_tails = TRUE
	else
		user.visible_message(span_info("[user] flips the coin. LYVE!"))
		heads_tails = FALSE
	update_icon()

/obj/item/roguecoin/update_icon()
	..()
	if(quantity > 1)
		drop_sound = 'sound/foley/coins1.ogg'
	else
		drop_sound = 'sound/foley/coinphy (1).ogg'

	if(quantity == 1)
		name = initial(name)
		desc = initial(desc)
		icon_state = "[base_type][heads_tails]"
		dropshrink = 0.2
		slot_flags = ITEM_SLOT_MOUTH
		return

	name = plural_name
	desc = ""
	dropshrink = 1
	slot_flags = null
	switch(quantity)
		if(2)
			dropshrink = 0.2 // this is just like the single coin, gotta shrink it
			icon_state = "[base_type]m"
			if(heads_tails == last_merged_heads_tails)
				icon_state = "[base_type][heads_tails]1"
		if(3)
			icon_state = "[base_type]2"
		if(4 to 5)
			icon_state = "[base_type]3"
		if(6 to 10)
			icon_state = "[base_type]5"
		if(11 to 15)
			icon_state = "[base_type]10"
		if(16 to INFINITY)
			icon_state = "[base_type]15"


/obj/item/roguecoin/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/roguecoin))
		var/obj/item/roguecoin/G = I
		if(item_flags & IN_STORAGE)
			merge(G, user)
		else
			G.merge(src, user)
		return
	return ..()

//OTAVAN MARQUE - WORTHLESS TO ANYONE BUT INQ.
/obj/item/roguecoin/inqcoin
	name = "otavan marque"
	desc = "A blessed silver coin finished with a unique wash of black dye, bearing the post-kingdom Psycross. Kingsfield has denied the existence of such a coin when queried, as such coinage is rumoured to be used internally by Otava's inquisitorial sects."
	icon_state = "i1"
	sellprice = 0
	base_type = CTYPE_ICOIN
	plural_name = "otavan marques"	

/obj/item/roguecoin/inqcoin/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("By loading these coins into a HERMES, I can access the MARQUETTE; a discrete variant of the GOLDFACE, capable of supplying the Inquisition with whatever's needed.")
    . += span_info("The MARQUETTE exclusively accepts these coins as payment. Purchased supplies are dropped off inside the Inquisition's abode.")
    . += span_info("More coins can be obtained by filling INDEXERS, pairing them with signed ACCUSATIONS or CONFESSIONS, and sending them through the HERMES.")

//GOLD
/obj/item/roguecoin/gold
	name = "zenar"
	desc = "A gold coin bearing the symbol of the Taurus and the pre-kingdom psycross. These were in the best condition of the provincial gold mints, the rest were melted down."
	icon_state = "g1"
	sellprice = 10
	base_type = CTYPE_GOLD
	plural_name = "zenarii"


// SILVER
/obj/item/roguecoin/silver
	name = "ziliqua"
	desc = "An ancient silver coin still in use due to their remarkable ability to last the ages."
	icon_state = "s1"
	sellprice = 5
	base_type = CTYPE_SILV
	plural_name = "ziliquae"

// COPPER
/obj/item/roguecoin/copper
	name = "zenny"
	desc = "A brand-new bronze coin minted by the capital in an effort to be rid of the financial use of silver."
	icon_state = "c1"
	sellprice = 1
	base_type = CTYPE_COPP
	plural_name = "zennies"

// ANCIENT
/obj/item/roguecoin/aalloy
	name = "psilen"
	desc = "A coin of polished gilbranze, beheld to a fallen kingdom that hadn't endured the passage of tyme. </br>Most sophisticated machines won't recognize its value, but keen-eyed Merchants and Stewards might still pay a fair sum for such a relic."
	icon_state = "a1"
	sellprice = 3 //Dungeon-specific coinage - valued by historians, collectors, and smelters. 
	base_type = CTYPE_ANCIENT
	plural_name = "psila"

/obj/item/roguecoin/inqcoin/pile/Initialize()
	. = ..()
	set_quantity(rand(4,19))

/obj/item/roguecoin/aalloy/pile/Initialize()
	. = ..()
	set_quantity(rand(4,19))

/obj/item/roguecoin/copper/pile/Initialize()
	. = ..()
	set_quantity(rand(4,19))

/obj/item/roguecoin/silver/pile/Initialize()
	. = ..()
	set_quantity(rand(4,19))	

/obj/item/roguecoin/silver/pile/readyuppile/Initialize()
	. = ..()
	set_quantity(4) // 20 mammons combine with starting pouch to buy something

/obj/item/roguecoin/gold/pile/Initialize()
	. = ..()
	set_quantity(rand(4,19))

/obj/item/roguecoin/gold/virtuepile/Initialize()
	. = ..()
	set_quantity(rand(8,12))

#undef CTYPE_GOLD
#undef CTYPE_SILV
#undef CTYPE_COPP
#undef CTYPE_ANCIENT
#undef CTYPE_ICOIN
#undef MAX_COIN_STACK_SIZE
