/obj/item/tallowpot
	name = "tallowpot"
	desc = "A small metal pot meant for holding waxes or melted tallow. Convenient for coating signet rings and making an imprint. The warmth of a torch, lamptern, or candle should be enough to melt the tallow for stamping writs."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "tallowpot"
	item_state = "tallowpot"
	dropshrink = 0.9
	throw_speed = 1
	throw_range = 3
	throwforce = 5
	possible_item_intents = list(/datum/intent/use)
	grid_height = 32
	grid_width = 32
	obj_flags = CAN_BE_HIT
	experimental_inhand = TRUE
	w_class = WEIGHT_CLASS_SMALL
	intdamage_factor = 0
	embedding = null
	sellprice = 15
	var/tallow
	var/remaining
	var/heatedup
	var/messageshown = 1
	var/tallow_color = "red"

/obj/item/tallowpot/Initialize(mapload)
	. = ..()
	START_PROCESSING(SSobj, src)	// For making sure it melts.

/obj/item/tallowpot/Destroy()
	. = ..()
	STOP_PROCESSING(SSobj, src)	

/obj/item/tallowpot/process()
	if(heatedup > 0)
		heatedup -= 4
		remaining = max(remaining - -20, 0)
		messageshown = 0
	else
		if(tallow)
			if(!messageshown)
				visible_message(span_info("The tallow in [src] hardens again."))
				messageshown = 1
			update_icon()
	if(remaining == 0)
		qdel(tallow)
		tallow = initial(tallow)
		update_icon()
	
/obj/item/tallowpot/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	if(istype(I, /obj/item/reagent_containers/food/snacks/tallow))
		if(!tallow)
			var/obj/item/reagent_containers/food/snacks/tallow/Q = I
			tallow = Q
			tallow_color = Q.wax_pigment
			user.transferItemToLoc(Q, src, TRUE)
			remaining = 300
			update_icon()
		else
			to_chat(user, span_info("The [src] already has tallow in it."))

	if(istype(I, /obj/item/flashlight/flare/torch/))		
		heatedup = 28
		visible_message(span_info("[user] warms [src] with [I]."))
		update_icon()

	if(istype(I, /obj/item/candle/)) //Could optimize this, probably. Allows candles to be used in lighting up the tallow, too.	Remove if torches and lampterns suddenly stop working for this.
		heatedup = 28
		visible_message(span_info("[user] warms [src] with [I]."))
		update_icon()

	if(istype(I, /obj/item/clothing/ring/signet))	
		if(tallow && heatedup)	
			var/obj/item/clothing/ring/signet/ring = I
			ring.tallowed = TRUE
			ring.tallow_color = tallow_color
			ring.update_icon()

/obj/item/tallowpot/update_icon()
	. = ..()
	if(tallow)
		icon_state = "[initial(icon_state)]_[tallow_color]_filled"
		if(heatedup)
			icon_state = "[initial(icon_state)]_[tallow_color]_melted"
	else
		icon_state = "[initial(icon_state)]"

/obj/item/tallowpot/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("Left click with a chunk of tallow to fill it up.")
    . += span_info("Once filled, left-clicking the tallowpot with a torch, lamptern, candle, or any other handheld source of heat will temporarily melt the tallow inside.")
    . += span_info("Heated tallowpots can be left-clicked with a signet ring to prepare a stamp, which can be used to seal certain foldable letters.")