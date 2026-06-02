/obj/structure/shisha
	name = "shisha pipe"
	desc = "A traditional shisha pipe."
	icon = 'icons/roguetown/misc/64x64.dmi'
	icon_state = "zbuski"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASH
	max_integrity = 300

	/// Ref to our mouthpiece. Not a weakref since we subscribe to its COMSIG_QDELETING and clear it manually.
	var/obj/item/hookah_mouthpiece/mouthpiece = null

/obj/structure/shisha/Initialize()
	. = ..()
	mouthpiece = new /obj/item/hookah_mouthpiece(src)
	RegisterSignal(mouthpiece, COMSIG_QDELETING, PROC_REF(on_mouhtpiece_delete))
	create_reagents(60)

/obj/structure/shisha/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(istype(I, /obj/item/reagent_containers/powder)) // Accepts all powders. Flour included.
		var/obj/item/reagent_containers/powder/powder = I
		if(!powder.reagents?.total_volume)
			to_chat(user, span_notice("[I] is useless for shisha."))
			return

		if(reagents.maximum_volume < reagents.total_volume + powder.reagents.total_volume)
			to_chat(user, span_notice("[src] is already tightly packed."))
			return

		to_chat(user, span_notice("I pack [src] with [powder]."))
		powder.reagents.trans_to(reagents, powder.reagents.total_volume, transfered_by = user)
		user.dropItemToGround(powder)
		qdel(powder)

	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown))
		var/obj/item/reagent_containers/food/snacks/grown/tobacco = I
		if(!tobacco.pipe_reagents?.len)
			to_chat(user, span_notice("[I] is useless for shisha."))
			return

		var/new_reagents_amt = 0
		for(var/id in tobacco.pipe_reagents)
			new_reagents_amt += tobacco.pipe_reagents[id]
		if(reagents.maximum_volume < reagents.total_volume + new_reagents_amt)
			to_chat(user, span_notice("[src] is already tightly packed."))
			return

		to_chat(user, span_notice("I pack [src] with [tobacco]."))
		reagents.add_reagent_list(tobacco.pipe_reagents)
		user.dropItemToGround(tobacco)
		qdel(tobacco)

	else if(I == mouthpiece)
		reattach_mouthpiece()

/obj/structure/shisha/attack_hand(mob/user)
	. = ..()
	if(.)
		return

	if(mouthpiece?.loc == src)
		user.put_in_active_hand(mouthpiece)
		to_chat(user, span_notice("You grab \the [src]'s [mouthpiece]."))
		return TRUE
	else
		to_chat(user, span_notice("\The [src] is already in use!"))
		return TRUE

/// Called when mouthpiece needs to be reattached, either by user's click or drop.
/obj/structure/shisha/proc/reattach_mouthpiece()
	if(mouthpiece.loc == src)
		return

	var/mob/living/smoker = mouthpiece.loc
	if(istype(smoker))
		smoker.dropItemToGround(mouthpiece, TRUE, TRUE)

	mouthpiece.forceMove(src)

/// Called when a mouthpiece emits COMSIG_QDELETING. Re-instances shisha's mouthpiece.
/obj/structure/shisha/proc/on_mouhtpiece_delete()
	SIGNAL_HANDLER
	UnregisterSignal(mouthpiece, COMSIG_QDELETING)
	mouthpiece = null
	mouthpiece = new /obj/item/hookah_mouthpiece(src)
	RegisterSignal(mouthpiece, COMSIG_QDELETING, PROC_REF(on_mouhtpiece_delete))

/obj/structure/shisha/Destroy()
	if(mouthpiece)
		UnregisterSignal(mouthpiece, COMSIG_QDELETING)
		QDEL_NULL(mouthpiece)
	return ..()

/obj/structure/shisha/hookah
	name = "shisha pipe"
	desc = "A traditional shisha pipe."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "hookah"
	anchored = FALSE

/obj/item/hookah_mouthpiece
	name = "hookah mouthpiece"
	desc = "Pestra knows how many tongues this thing has seen so far."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "mouthpiece"
	force = 5 // To hit someone with it.
	possible_item_intents = list(/datum/intent/smoke, INTENT_GENERIC)
	/// weakref to the hookah this mouthpiece is attached to
	var/datum/weakref/parent_hookah = null
	/// Ref to our smoker to prevent them from walking far away & holding a hookah hose
	var/mob/smoker_user = null

/datum/intent/smoke
	name = "smoke"
	icon_state = "insmoke"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	misscost = 0
	no_attack = TRUE

/obj/item/hookah_mouthpiece/Initialize(mapload)
	. = ..()
	if(istype(loc, /obj/structure/shisha))
		parent_hookah = WEAKREF(loc)

/obj/item/hookah_mouthpiece/equipped(mob/user, slot, initial)
	. = ..()
	smoker_user = user
	RegisterSignal(smoker_user, COMSIG_MOVABLE_MOVED, PROC_REF(on_smoker_moved))

/obj/item/hookah_mouthpiece/dropped(mob/user)
	. = ..()
	if(smoker_user)
		UnregisterSignal(smoker_user, COMSIG_MOVABLE_MOVED)
		smoker_user = null
	var/obj/structure/shisha/master_structure = parent_hookah?.resolve()
	if(!master_structure)
		qdel(src)
		return

	master_structure.reattach_mouthpiece()

/obj/item/hookah_mouthpiece/attack(mob/M, mob/user, obj/target)
	. = ..()
	if(user.used_intent.type == /datum/intent/smoke)
		var/obj/structure/shisha/shisha = parent_hookah?.resolve()
		if(!istype(shisha) || !istype(user) || !(shisha.reagents?.total_volume))
			return

		playsound(get_turf(shisha), 'sound/foley/shisha_gurgle.ogg', rand(70, 100), FALSE, -1)
		if(!do_after_mob(user, list(shisha), 2 SECONDS, required_mobility_flags = MOBILITY_USE) || QDELETED(shisha) || QDELETED(src))
			return

		if(!istype(user))
			return

		if(!(shisha.reagents?.total_volume))
			return

		var/smoke_amount = shisha.reagents.maximum_volume / shisha.reagents.total_volume
		shisha.reagents.reaction(user, INGEST, min(REAGENTS_METABOLISM / smoke_amount, 1))
		if(!shisha.reagents.trans_to(user, smoke_amount))
			shisha.reagents.remove_any(smoke_amount)

		var/turf/my_turf = get_turf(user)
		my_turf.pollute_turf(/datum/pollutant/smoke, 5)
		return FALSE

/// Called when a mob holding this item moves. If we are too far away from parent shisha - it snaps back.
/obj/item/hookah_mouthpiece/proc/on_smoker_moved(mob/living/moved, dir)
	SIGNAL_HANDLER
	var/obj/structure/shisha/parent_shisha = parent_hookah?.resolve()
	if(get_dist(moved, parent_shisha) > 2)
		to_chat(moved, span_notice("[src] flies out of my hands! I walked too far away from [parent_shisha]."))
		moved.dropItemToGround(src, TRUE, TRUE)

/obj/item/hookah_mouthpiece/Destroy()
	if(smoker_user)
		UnregisterSignal(smoker_user, COMSIG_MOVABLE_MOVED)
	smoker_user = null
	parent_hookah = null
	return ..()

/obj/item/portable_hookah
	name = "handheld shisha pipe"
	desc = "A smaller, portable version of a traditional shisha. Perfect for smoking on the move."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "shisha_hand"
	w_class = WEIGHT_CLASS_NORMAL
	possible_item_intents = list(/datum/intent/smoke, INTENT_GENERIC)
	slot_flags = ITEM_SLOT_HIP
	light_system = MOVABLE_LIGHT
	light_outer_range = 1
	light_color = "#f5a885"
	light_on = FALSE
	var/lit = FALSE

	grid_height = 64
	grid_width = 64

/obj/item/portable_hookah/Initialize(mapload)
	. = ..()
	create_reagents(20)

/obj/item/portable_hookah/attackby(obj/item/I, mob/user, params)
	if(!lit && (I.get_temperature() >= FIRE_MINIMUM_TEMPERATURE_TO_SPREAD))
		light_shisha(user)
		return

	if(istype(I, /obj/item/reagent_containers/powder))
		var/obj/item/reagent_containers/powder/powder = I
		if(!powder.reagents?.total_volume)
			to_chat(user, span_notice("[I] is useless for shisha."))
			return

		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, span_notice("[src] is already tightly packed."))
			return

		to_chat(user, span_notice("I pack [src] with [powder]."))
		powder.reagents.trans_to(reagents, powder.reagents.total_volume, transfered_by = user)
		user.dropItemToGround(powder)
		qdel(powder)
		return

	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown))
		var/obj/item/reagent_containers/food/snacks/grown/tobacco = I
		if(!tobacco.pipe_reagents?.len)
			to_chat(user, span_notice("[I] is useless for shisha."))
			return

		var/new_reagents_amt = 0
		for(var/id in tobacco.pipe_reagents)
			new_reagents_amt += tobacco.pipe_reagents[id]
		if(reagents.total_volume >= reagents.maximum_volume)
			to_chat(user, span_notice("[src] is already tightly packed."))
			return

		to_chat(user, span_notice("I pack [src] with [tobacco]."))
		reagents.add_reagent_list(tobacco.pipe_reagents)
		user.dropItemToGround(tobacco)
		qdel(tobacco)
		return

	return ..()

/obj/item/portable_hookah/attack(mob/M, mob/user, obj/target)
	if(user.used_intent.type == /datum/intent/smoke)
		if(!lit)
			to_chat(user, span_warning("[src] is not lit! You need a flame to light it."))
			return
		if(!reagents?.total_volume)
			to_chat(user, span_warning("[src] is empty! There's nothing to smoke."))
			return

		playsound(get_turf(src), 'sound/foley/shisha_gurgle.ogg', rand(50, 70), FALSE, -1)
		
		if(!do_after(user, 2 SECONDS, target = user) || QDELETED(src) || !lit)
			return

		if(!reagents?.total_volume)
			return

		var/smoke_amount = reagents.maximum_volume / reagents.total_volume
		reagents.reaction(user, INGEST, min(REAGENTS_METABOLISM / smoke_amount, 1))
		if(!reagents.trans_to(user, smoke_amount))
			reagents.remove_any(smoke_amount)

		var/turf/my_turf = get_turf(user)
		if(my_turf)
			my_turf.pollute_turf(/datum/pollutant/smoke, 3)

		to_chat(user, span_notice("You take a pleasant puff from \the [src]."))

		if(!reagents.total_volume)
			to_chat(user, span_warning("\The [src] goes out as the smoking mix burns out."))
			extinguish()

	else
		if(lit)
			user.visible_message(span_notice("[user] extinguishes \the [src]."), span_notice("You extinguish \the [src]."))
			extinguish()
		else
			to_chat(user, span_notice("[src] is already cold. Use a heat source on it to light it up."))

/obj/item/portable_hookah/proc/light_shisha(mob/user)
	if(lit)
		return
	if(!reagents?.total_volume)
		if(user)
			to_chat(user, span_warning("You can't light \the [src] while it's empty! Pack it first."))
		return

	lit = TRUE
	set_light_on(TRUE)
	icon_state = "shisha_hand_lit"
	playsound(src.loc, 'sound/items/firelight.ogg', 100)
	if(user)
		user.visible_message(span_notice("[user] lights \the [src] with a satisfying hiss."), span_notice("You light \the [src]. Candle flame is so romantic."))
	update_icon()

/obj/item/portable_hookah/extinguish()
	if(!lit)
		return
	lit = FALSE
	set_light_on(FALSE)
	icon_state = "shisha_hand"
	playsound(src.loc, 'sound/items/firesnuff.ogg', 100)
	update_icon()

/obj/item/portable_hookah/fire_act(added, maxstacks)
	if(!lit)
		light_shisha()
		return TRUE
	return ..()

/obj/item/portable_hookah/spark_act()
	if(!lit)
		light_shisha()
		return TRUE
	return ..()
