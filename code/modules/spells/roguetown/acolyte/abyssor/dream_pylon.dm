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

/obj/structure/dream_pylon/Initialize(mapload)
	. = ..()
	set_pylon_overlay('icons/obj/structures/abyssor_pylon.dmi', "ball")

/obj/structure/dream_pylon/Destroy()
	if(active_overlay)
		qdel(active_overlay)
		active_overlay = null
	return ..()

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

	var/datum/status_effect/infusion/existing_effect = user.has_status_effect(infusion_payload)
	if(existing_effect)
		var/obj/structure/dream_pylon/target_pylon = existing_effect.pylon_ref?.resolve()
		if(target_pylon == src)
			src.visible_message("<span class='notice'>[user] touches [src], rendering their active infusion back into the structure.</span>")
			existing_effect.refund_charge()
			return
		else
			to_chat(user, "<span class='warning'>You are already attuned to a different pylon's infusion! Clear your mind first.</span>")
			return

	if(charge < charge_cost_per_use)
		to_chat(user, "<span class='warning'>The pylon doesn't have enough residual charge left to manifest an infusion.</span>")
		return

	charge = max(0, charge - charge_cost_per_use)
	user.apply_status_effect(infusion_payload, src)
	src.visible_message("<span class='purple'>[user] absorbs a pulsing splash of paint from [src]!</span>")
	update_pylon_appearance()

/obj/structure/dream_pylon/proc/update_pylon_appearance()
	if(charge < charge_cost_per_use)
		set_pylon_overlay(null, null)
	else
		set_pylon_overlay('icons/obj/structures/abyssor_pylon.dmi', "ball")
