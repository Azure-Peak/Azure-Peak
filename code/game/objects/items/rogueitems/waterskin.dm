/obj/item/reagent_containers/glass/bottle/waterskin
	name = "waterskin"
	desc = "A leather waterskin."
	icon_state = "waterskin"
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(5, 10)
	volume = 75 // 3 cups
	dropshrink = 1
	sellprice = 10
	closed = FALSE
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_BACK
	obj_flags = CAN_BE_HIT
	reagent_flags = OPENCONTAINER
	w_class =  WEIGHT_CLASS_NORMAL
	drinksounds = list('sound/items/drink_bottle (1).ogg','sound/items/drink_bottle (2).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	sewrepair = TRUE
	desc_uncorked = "A leather waterskin. The cap on the mouth is off."

/obj/item/reagent_containers/glass/bottle/waterskin/milk // Filled subtype used by the cheesemaker
	list_reagents = list(/datum/reagent/consumable/milk = 64)

/obj/item/reagent_containers/glass/bottle/waterskin/purifier
	name = "purifying waterskin"
	desc = "Bronze tubes spiral about from the mouth of this waterskin in complex, dizzying patterns."
	icon_state = "water-purifier"
	desc_uncorked = "Bronze tubes spiral about from the mouth of this waterskin in complex, dizzying patterns. The cap on the mouth is off."
	var/filtered_reagents = list(/datum/reagent/water/gross) // List of liquids it turns into drinkable water

/obj/item/reagent_containers/glass/bottle/waterskin/purifier/onfill(obj/target, mob/user, silent = FALSE)
	. = ..()
	cleanwater(user, silent)

/obj/item/reagent_containers/glass/bottle/waterskin/purifier/proc/cleanwater(mob/living/carbon/human/user, silent = FALSE)
	// If there is dirty water inside the device, clean it!
	if (hasdirtywater())
		for (var/datum/reagent/R in reagents.reagent_list)
			if(R.type in filtered_reagents)
				var/amt2clean = reagents.get_reagent_amount(R.type)
				reagents.remove_all_type(R, amt2clean)
				reagents.add_reagent(/datum/reagent/water, amt2clean)
		if (!silent)
			playsound(user, 'sound/items/waterfilter.ogg', 40, TRUE)
			to_chat(user, span_hear("I hear whizzing clockwork and gurgling water within [src]."))
			if (prob(25))
				new /obj/effect/temp_visual/small_smoke(user.loc)
				user.visible_message(span_notice("A cloud of steam momentarily envelops [user]!"), span_notice("The device sputters and spews a cloud of steam." + span_warning(" How annoying!")))


/obj/item/reagent_containers/glass/bottle/waterskin/purifier/proc/hasdirtywater()
	for (var/datum/reagent/R in reagents.reagent_list)
		if(R.type in filtered_reagents)
			return TRUE
	return FALSE

/obj/item/reagent_containers/glass/bottle/waterskin/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum, do_splash = TRUE)
	return
