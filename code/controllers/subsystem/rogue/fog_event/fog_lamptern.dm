/obj/item/lantern/fog_repelling
	name = "blessed fog lamptern"
	desc = "A specialized iron lamptern filled with sanctified oil. It projects a minor holy ward. Fuel burns faster when moving through the fog."
	icon = 'icons/roguetown/items/lighting.dmi'
	icon_state = "lamp_ghost"
	item_state = "lamp"
	w_class = WEIGHT_CLASS_NORMAL
	slot_flags = ITEM_SLOT_HIP

	var/fuel = 1000
	var/max_fuel = 1000
	var/range = 5
	var/active = FALSE
	var/mob/living/carbon/human/holder

/obj/item/lantern/fog_repelling/empty
	fuel = 0

/obj/item/lantern/fog_repelling/examine(mob/user)
	. = ..()
	if(fuel <= 0)
		. += span_warning("The glass is soot-stained and the reservoir is bone dry.")
		return

	var/fuel_ratio = fuel / max_fuel
	switch(fuel_ratio)
		if(0.9 to 1.1)
			. += span_notice("The oil sloshes near the top of the glass; it is nearly full.")
		if(0.6 to 0.9)
			. += span_notice("The golden oil within is at a healthy level.")
		if(0.3 to 0.6)
			. += span_warning("The oil is getting low. The wick may soon go dry.")
		if(0.05 to 0.3)
			. += span_danger("The oil is barely a puddle at the bottom. It won't last much longer.")
		else
			. += span_danger("The wick is sputtering in the last drops of sanctified oil!")

/obj/item/lantern/fog_repelling/attack_self(mob/living/user)
	if(fuel <= 0)
		to_chat(user, span_warning("[src] refuses to light, it needs more sanctified oil."))
		return

	if(!isliving(user))
		to_chat(user, span_warning("[src] refuses to light, you have no soul."))
		return
	active = !active
	if(active)
		to_chat(user, span_notice("You light the [src]. A soft, protective glow surrounds you."))
		set_light(l_outer_range = range, l_power = 2, l_color = "#fff2aa")
		icon_state = "[initial(icon_state)]-on" // Ensure you have this state
		user.apply_status_effect(/datum/status_effect/buff/fog_ward_caster, range, -1, FALSE)
		start_tracking(user)
	else
		to_chat(user, span_notice("You extinguish the [src]."))
		set_light(0)
		icon_state = initial(icon_state)
		user.remove_status_effect(/datum/status_effect/buff/fog_ward_caster)
		stop_tracking()
	update_icon()

/obj/item/lantern/fog_repelling/proc/consume_fuel(mob/living/user)
	if(!active)
		return

	var/area/A = get_area(user)
	// burns more fuel if moving through UNPROTECTED areas.
	if(A && !A.fog_protected)
		fuel -= 2
	else
		fuel--
	if(fuel <= 0)
		extinguish(user)

/obj/item/lantern/fog_repelling/extinguish(mob/living/user)
	active = FALSE
	set_light(0)
	icon_state = initial(icon_state)
	if(isliving(user))
		to_chat(user, span_warning("The [src] flickers once and goes cold as the fuel runs out."))
		user.remove_status_effect(/datum/status_effect/buff/fog_ward_caster)
	stop_tracking()
	update_icon()

/obj/item/lantern/fog_repelling/proc/start_tracking(mob/living/user)
	if(!ishuman(user) || holder == user)
		return
	holder = user
	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/consume_fuel)

/obj/item/lantern/fog_repelling/proc/stop_tracking()
	if(holder)
		UnregisterSignal(holder, COMSIG_MOVABLE_MOVED)
		holder = null

/obj/item/lantern/fog_repelling/equipped(mob/living/user, slot)
	. = ..()
	if(!isliving(user))
		return
	if(active && (slot == ITEM_SLOT_HANDS || slot == SLOT_BELT_L || slot == SLOT_BELT_R ))
		start_tracking(user)
	else
		user.remove_status_effect(/datum/status_effect/buff/fog_ward_caster)
		extinguish()
		stop_tracking()

/obj/item/lantern/fog_repelling/Destroy()
	stop_tracking()
	return ..()

/obj/item/lantern/fog_repelling/Moved(atom/OldLoc, Dir)
	. = ..()

	if(holder)
		if(loc != holder  || istype(loc, /obj/item/storage/backpack) || istype(loc, /obj/structure/closet))
			to_chat(holder, span_warning("The protective light of [src] fades as it leaves your person!"))
			holder.remove_status_effect(/datum/status_effect/buff/fog_ward_caster)
			extinguish()
			stop_tracking()

/datum/reagent/sanctified_oil
	name = "Sanctified Oil"
	description = "A shimmering, golden oil blessed by a higher power. It burns with a pure, fog-repelling light."
	color = "#fff2aa"
	taste_description = "incense and warm sunlight"

// The Bottle
/obj/item/reagent_containers/glass/bottle/sanctified_oil
	name = "bottle of sanctified oil"
	desc = "A sturdy glass bottle containing sanctified oil. One bottle is enough to completely fill a fog lantern."
	list_reagents = list(/datum/reagent/sanctified_oil = 48)

/obj/item/lantern/fog_repelling/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = I
		if(!container.reagents.has_reagent(/datum/reagent/sanctified_oil))
			to_chat(user, span_warning("[container] doesn't contain sanctified oil!"))
			return
		if(fuel >= max_fuel)
			to_chat(user, span_warning("[src] is already full!"))
			return

		// 1 unit of reagent = 25 units of fuel
		var/oil_to_fuel_ratio = 25 
		var/available_reagent = container.reagents.get_reagent_amount(/datum/reagent/sanctified_oil)

		var/units_needed = CEILING((max_fuel - fuel) / oil_to_fuel_ratio, 1)
		var/transfer_amount = min(available_reagent, units_needed)

		if(transfer_amount > 0)
			user.visible_message(span_notice("[user] carefully refills [src]."), \
								 span_notice("You refill [src] with sanctified oil."))

			container.reagents.remove_reagent(/datum/reagent/sanctified_oil, transfer_amount)
			fuel = min(fuel + (transfer_amount * oil_to_fuel_ratio), max_fuel)
			
			playsound(src, 'sound/items/drink_bottle (2).ogg', 50, TRUE)
			update_icon()
		return TRUE

	return ..()
