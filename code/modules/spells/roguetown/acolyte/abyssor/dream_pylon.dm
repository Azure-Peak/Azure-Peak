/obj/structure/dream_pylon
	name = "painted pylon"
	desc = "A strange pulsing pylon that seems to be made out of thick, solidified swirls of abyssal paints."
	icon = 'icons/obj/structures/abyssor_pylon.dmi'
	icon_state = "pylon"
	anchored = TRUE
	density = TRUE
	resistance_flags = FIRE_PROOF | ACID_PROOF
	max_integrity = 500

	/// Tracks the active overlay object currently attached to the pylon
	var/obj/effect/pylon_overlay/active_overlay
	/// The typepath of the status effect infusion currently hosted inside this pylon
	var/datum/status_effect/infusion/infusion_payload = /datum/status_effect/infusion/intelligence
	/// Current amount of abyssal energy stored
	var/charge = 100
	/// Max capability reservoir
	var/max_charge = 100
	/// Cost per extraction
	var/charge_cost_per_use = 25
	/// Color hex applied to the central core overlay and player outlines
	var/pylon_color
	/// Whether this pylon can currently be topped up by a replenishment miracle. Resets when infusion changes.
	var/can_recharge = TRUE

/obj/structure/dream_pylon/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Dream pylons with a floating ball of dream energies can be interacted with to receive a buff.")
	. += span_info("Buffs from pylons rapidly decay when out of their range, the pylon will glow red when out of range.")
	. += span_info("You can only benefit from one pylon at a time.")
	. += span_info("You can interact with a pylon to return a buff prematurely.")
	. += span_info("Pylons can be infused by skilled painter abyssorites to restore some charge, once per seed.")
	. += span_info("Inserting a new dream seed will fully recharge a pylon, and allow it to be recharged via infusion again.")

/obj/structure/dream_pylon/Initialize(mapload)
	. = ..()
	update_pylon_appearance()

/obj/structure/dream_pylon/Destroy()
	if(active_overlay)
		qdel(active_overlay)
		active_overlay = null
	return ..()

/obj/structure/dream_pylon/proc/update_pylon_appearance()
	if(charge < charge_cost_per_use)
		set_pylon_overlay(null, null)
	else
		var/chosen_state = pylon_color ? "ball_grey" : "ball"
		set_pylon_overlay('icons/obj/structures/abyssor_pylon.dmi', chosen_state)

/obj/structure/dream_pylon/examine(mob/user)
	. = ..()
	if(charge <= 0 || !infusion_payload)
		. += "\n<span class='warning'>Its central core looks completely hollowed out, awaiting an infusion.</span>"
	else
		var/amount_of_charges = floor(charge / charge_cost_per_use)
		var/infusion_name = initial(infusion_payload.id)
		var/message = (amount_of_charges > 0) ? amount_of_charges : "No"
		. += "\n<span class='notice'>It is imbued with the essence of <b>[infusion_name]</b>. It appears to have <b>[message]</b> uses left.</span>"

/obj/structure/dream_pylon/proc/set_pylon_overlay(new_icon, new_icon_state)
	if(active_overlay)
		cut_overlay(active_overlay)
		qdel(active_overlay)
		active_overlay = null

	if(!new_icon || !new_icon_state)
		return

	var/obj/effect/pylon_overlay/O = new(src)
	O.icon = new_icon
	O.icon_state = new_icon_state
	if(pylon_color)
		O.color = pylon_color
	active_overlay = O
	add_overlay(active_overlay)

/obj/effect/pylon_overlay
	name = "ball"
	desc = "oOOoOOooOOo I'm a spooky abyssal ball OooOoOooooo pondering my orb."
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_OBJ_LAYER

/obj/structure/dream_pylon/interact(mob/living/user)
	if(!istype(user) || user.stat != CONSCIOUS)
		return

	var/datum/status_effect/infusion/existing_effect
	for(var/datum/status_effect/infusion/I in user.status_effects)
		existing_effect = I
		break

	if(existing_effect)
		var/obj/structure/dream_pylon/target_pylon = existing_effect.pylon_ref?.resolve()
		if(target_pylon == src && existing_effect.type == infusion_payload)
			src.visible_message(span_notice("[user] touches [src], rendering their active infusion back into the structure."))
			existing_effect.refund_charge()
			return
		else
			to_chat(user, span_warning("You are already attuned to a pylon's infusion! Clear your mind first."))
			return

	if(charge < charge_cost_per_use)
		to_chat(user, span_warning("The pylon doesn't have enough residual charge left to manifest an infusion."))
		return

	charge = max(0, charge - charge_cost_per_use)
	user.apply_status_effect(infusion_payload, src)
	src.visible_message(span_purple("[user] absorbs a pulsing splash of paint from [src]!"))
	update_pylon_appearance()

/obj/structure/dream_pylon/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/dream_material/dream_seed))
		if(!do_after(user, 1 SECONDS))
			to_chat(user, span_warning("I was interrupted!"))
			return
		var/obj/item/dream_material/dream_seed/seed = I
		seed.apply_to_pylon(src, user)
		return TRUE

	return ..()

/obj/structure/dream_pylon/proc/set_infusion(datum/status_effect/infusion/new_infusion, new_max_charge, new_charge, new_color)
	infusion_payload = new_infusion
	max_charge = new_max_charge
	charge = new_charge
	pylon_color = new_color
	can_recharge = TRUE
	update_pylon_appearance()
