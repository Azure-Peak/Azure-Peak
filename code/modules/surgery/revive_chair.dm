#define WEATHER_RAIN "rain"

// The immovable chair structure
/obj/structure/chair/frankenstein
	name = "Fulmenor chair"
	desc = "A nightmarish contraption of pipes, and sparking electrodes. It seems permanently fixed to the ground. Affectionately known as the ZRONK device."
	icon = 'icons/roguetown/misc/struc48x48.dmi'
	icon_state = "frankenchair0"
	anchored = TRUE
	density = FALSE
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	max_integrity = 10000
	item_chair = null // Cannot be picked up
	buildstacktype = null
	buildstackamount = 0

	// Chair state variables
	var/charge = 0
	var/max_charge = 100
	var/brew_required = 48
	var/current_brew = 0
	var/max_brew = 96
	var/chair_skill_level = 4

	var/static/list/brew_overlays = list(
		"low" = "frankenbrew_low",
		"medium" = "frankenbrew_med",
		"high" = "frankenbrew_high"
	)
	var/brew_color = "#00ff15"
	var/brew_alpha = 200
	var/cranking = FALSE
	pixel_x = -8

/obj/structure/chair/frankenstein/zizo
	chair_skill_level = 2
	current_brew = 48

/obj/structure/chair/frankenstein/Initialize()
	. = ..()
	update_icon()

/obj/structure/chair/frankenstein/update_icon()
	cut_overlays()

	// Add fluid overlay if there's brew
	if(current_brew > 0)
		var/brew_percent = current_brew / max_brew
		var/overlay_state

		// Select appropriate overlay based on fill level
		if(brew_percent < 0.33)
			overlay_state = brew_overlays["low"]
		else if(brew_percent < 0.66)
			overlay_state = brew_overlays["medium"]
		else
			overlay_state = brew_overlays["high"]

		// Create and apply overlay
		var/mutable_appearance/fluid_overlay = mutable_appearance(icon, overlay_state)
		fluid_overlay.color = brew_color
		fluid_overlay.alpha = brew_alpha
		add_overlay(fluid_overlay)

	// Add charge effects if charged
	if(charge > 0)
		var/charge_percent = charge / max_charge
		var/charge_alpha = 55 + 200 * charge_percent
		var/mutable_appearance/charge_overlay = mutable_appearance(icon, "frankenspark")
		charge_overlay.alpha = charge_alpha
		add_overlay(charge_overlay)

/obj/structure/chair/frankenstein/attackby(obj/item/I, mob/user)
	if(!ishuman(user))
		to_chat(user, span_warning("I have no idea how to operate this."))
	var/mob/living/carbon/human/H = user
	// Handle filling with brew containers
	if(istype(I, /obj/item/reagent_containers))
		var/obj/item/reagent_containers/container = I

		// Check if container has our special brew
		if(container.reagents.has_reagent(/datum/reagent/frankenbrew, 1))
			if(current_brew >= max_brew)
				to_chat(user, span_warning("[src] is completely full!"))
				return

			// Calculate how much we can transfer
			var/remaining_capacity = max_brew - current_brew
			var/available_brew = container.reagents.get_reagent_amount(/datum/reagent/frankenbrew)

			if(available_brew <= 0)
				to_chat(user, span_warning("[container] is empty!"))
				return

			// Animate filling
			user.visible_message(
				span_notice("[user] begins filling [src] with [container]."), 
				span_notice("You begin filling [src] with [container].")
			)

			var/skill_mod = get_user_skill(H)
			var/transferred = 0
			var/transfer_amount = 3
			var/transfer_time = 1.5 SECONDS * skill_mod

			while(remaining_capacity > 0 && available_brew > 0)
				// Check if we can continue
				if(!user.Adjacent(src) || !container)
					break

				// Calculate actual transfer for this iteration
				var/actual_transfer = min(transfer_amount, remaining_capacity, available_brew)

				// Short transfer animation
				if(!do_after(user, transfer_time, target = src))
					break

				// Transfer fluid
				container.reagents.remove_reagent(/datum/reagent/frankenbrew, actual_transfer)
				current_brew += actual_transfer
				transferred += actual_transfer
				remaining_capacity = max_brew - current_brew
				available_brew = container.reagents.get_reagent_amount(/datum/reagent/frankenbrew)

				// Update appearance
				update_icon()
				playsound(src, 'sound/items/drink_bottle (2).ogg', 30, TRUE)

			if(transferred > 0)
				to_chat(user, span_notice("You transfer [transferred] units of elixir to [src]. It now has [current_brew]/[max_brew] units."))
			else
				to_chat(user, span_warning("You were interrupted while filling [src]."))

			update_icon()
			return TRUE
		else
			to_chat(user, span_warning("This container doesn't have the special brew!"))
			return
	return ..()

/obj/structure/chair/frankenstein/examine(mob/user)
	. = ..()
	. += span_info("Fluid level: [current_brew]/[max_brew] units")
	. += span_info("Charge level: [charge]/[max_charge]")
	. += span_info("Useful leaflet: To charge, use the crank affixed on the right.")
	. += span_info("There's a big juicy lever in the middle on the backside that looks enticing to pull.")

	if(current_brew > 0)
		. += span_notice("The fluid tank contains a glowing green liquid.")
	else
		. += span_warning("The fluid tank is empty.")

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.patron.type == /datum/patron/divine/pestra || H.patron.type == /datum/patron/inhumen/zizo)
			. += span_info("You recall that these chairs are often shipped in enigmatic black crates marked with white crosses. The components are assembled by mysterious beaked figures on site, and taking it apart again seems like an impossible task.")

// Special brew reagent
/datum/reagent/frankenbrew
	name = "Reanimation Elixir"
	description = "A volatile chemical mixture that helps the deceased conduct electricity."
	color = "#00ff15"
	taste_description = "lightning and regret"

/obj/item/reagent_containers/glass/bottle/frankenbrew
	name = "vial of Reanimation Elixir"
	desc = "A volatile chemical mixture that helps the deceased conduct electricity. Looks expensive..."
	list_reagents = list(/datum/reagent/frankenbrew = 48)

/obj/item/reagent_containers/glass/bottle/frankenbrew/third
	list_reagents = list(/datum/reagent/frankenbrew = 16)

/obj/structure/chair/frankenstein/proc/start_cranking_animation()
	if(cranking)
		return
	cranking = TRUE
	icon_state = "frankenchair_crank"
	update_icon()

/obj/structure/chair/frankenstein/proc/stop_cranking_animation()
	cranking = FALSE
	icon_state = "frankenchair0"
	update_icon()

/obj/structure/chair/frankenstein/proc/get_user_skill(mob/living/carbon/human/user)
	var/medical_skill = user.get_skill_level(/datum/skill/misc/medicine)
	var/skill_mod = 1.0

	switch(medical_skill)
		if(0 to 3)
			skill_mod = 4.0
		if(4)
			skill_mod = 1.0
		if(5)
			skill_mod = 0.9
		if(6)
			skill_mod = 0.8

	return skill_mod

/obj/structure/chair/frankenstein/attack_right(mob/user)
	if(!ishuman(user))
		to_chat(user, span_warning("I have no idea how to operate this."))
	var/mob/living/carbon/human/H = user

	if(cranking)
		to_chat(user, span_warning("Someone is already cranking [src]!"))
		return

	if(charge >= max_charge)
		to_chat(user, span_warning("[src] is already fully charged!"))
		return

	// Start cranking
	user.visible_message(
		span_notice("[user] begins cranking [src]."), 
		span_notice("You start cranking [src]...")
	)

	start_cranking_animation()

	var/cranks = 0
	var/skill_mod = get_user_skill(H)
	var/crank_time = 2 SECONDS * skill_mod
	var/charge_per_crank = 10

	while(charge < max_charge && do_after(user, crank_time, target = src))
		// Add charge
		charge = min(charge + charge_per_crank, max_charge)
		cranks++
		update_icon()

		// Play sound
		playsound(src, 'sound/misc/click.ogg', 50, 1)

		// Check if we reached max charge
		if(charge >= max_charge)
			break

	stop_cranking_animation()

	if(cranks > 0)
		to_chat(user, span_notice("You crank [src] [cranks] times."))
	else
		to_chat(user, span_warning("You stop cranking it."))

	return TRUE

/obj/structure/chair/frankenstein/MiddleClick(mob/user)
	if(!ishuman(user))
		return ..()

	var/mob/living/carbon/human/H = user

	// Check medical skill requirement
	if(H.get_skill_level(/datum/skill/misc/medicine) < chair_skill_level)
		to_chat(H, span_warning("I don't have the medical expertise to operate this device!"))
		return

	// Check if chair is occupied
	var/mob/living/carbon/occupant
	for(var/mob/living/carbon/C in get_turf(src))
		if(C != user)
			occupant = C
			break

	if(!occupant)
		to_chat(H, span_warning("The chair needs an occupant to perform reanimation!"))
		return

	// Check resources
	if(current_brew < brew_required)
		to_chat(H, span_warning("Insufficient fluid!"))
		return
	if(charge < max_charge)
		to_chat(H, span_warning("Insufficient charge!"))
		return

	// Check if occupant is valid
	if(!occupant.check_revive(user))
		return

	// Prompt ghost
	to_chat(occupant, span_ghostalert("You sense powerful energies attempting to pull you back to your body!"))
	var/alert_result = alert(occupant, "They are calling for you. Are you ready?", "Reanimation", "I need to wake up", "Don't let me go")

	// Verify occupant is still valid
	if(occupant.stat != DEAD || occupant.loc != get_turf(src) || !occupant.buckled)
		to_chat(H, span_warning("The subject is no longer properly buckled to the chair!"))
		return

	if(alert_result != "I need to wake up")
		to_chat(H, span_warning("[occupant] refuses to return."))
		return

	// Animation and sound
	playsound(src, 'sound/magic/lightning.ogg', 100, TRUE)
	do_sparks(8, TRUE, occupant)
	occupant.visible_message(span_danger("Bolts of electricity course through [occupant]!"))

	// Revive process
	occupant.adjustOxyLoss(-occupant.getOxyLoss())
	if(occupant.revive(full_heal = FALSE))
		// Restore consciousness
		occupant.grab_ghost(force = TRUE)
		occupant.emote("gasp")
		occupant.Jitter(100)
		occupant.electrocute_act(100, src, 1)
		occupant.visible_message(span_notice("[occupant] jerks awake with a gasp!"), 
								span_userdanger("You awaken with agonizing pain as unnatural energy courses through your veins!"))
		current_brew -= brew_required
		charge = 0
		update_icon()

		// Apply debuffs
		occupant.apply_status_effect(/atom/movable/screen/alert/status_effect/debuff/revived)

	return TRUE

#undef WEATHER_RAIN
