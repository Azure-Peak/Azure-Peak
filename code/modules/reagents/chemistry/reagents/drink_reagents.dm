

/////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////// DRINKS BELOW, Beer is up there though, along with cola. Cap'n Pete's Cuban Spiced Rum////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Rougetown Reagents - Ported from Dreamkeep
/datum/reagent/consumable/acorn_powder
	name = "Acorn Powder"
	description = "A bitter fine powder."
	color = "#dcb137"
	quality = DRINK_VERYGOOD
	taste_description = "bitter earthy-ness"

/datum/reagent/consumable/acorn_powder/on_mob_life(mob/living/carbon/M)
	M.energy_add(8)
	..()

/datum/reagent/consumable/Acoffee
	drink_type = DRINKTYPE_CAFFEINE
	name = "Acorn Coffee"
	description = "A nice bitter stimulating brew"
	color = "#800000"
	quality = DRINK_VERYGOOD
	taste_description = "robust earthy-ness"
	metabolization_rate = 0.2 * REAGENTS_METABOLISM
	overdose_threshold = null
	var/hydration = 8

// Add variables to track initial and consumed amounts
/mob/living/carbon/var/initial_acoffee_amount = 0 // Tracks the initial amount of Acorn Coffee when consumed
/mob/living/carbon/var/metabolized_acoffee = 0 // Tracks the total amount of Acorn Coffee metabolized

/datum/reagent/consumable/Acoffee/on_mob_life(mob/living/carbon/M)
	// Initialize the initial amount when first consumed
	if(M.initial_acoffee_amount == 0)
		M.initial_acoffee_amount = M.reagents.get_reagent_amount(src)

	// Calculate the current amount and the amount metabolized in this cycle
	var current_amount = M.reagents.get_reagent_amount(src)
	var metabolized_now = (M.initial_acoffee_amount - current_amount) * metabolization_rate

	// Update the total metabolized amount
	M.metabolized_acoffee += metabolized_now
	// Update the initial amount for the next cycle
	M.initial_acoffee_amount = current_amount

	// Apply the effects of Acorn Coffee
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			H.adjust_hydration(hydration)
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+10, BLOOD_VOLUME_NORMAL)
	M.energy_add(8)
	M.dizziness = max(0, M.dizziness - 5)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.SetSleeping(0, FALSE)

	// Remove the sleepytime status effect after 12u of Acorn Coffee has metabolized
	if(M.metabolized_acoffee >= 12)
		if(M.has_status_effect(/datum/status_effect/debuff/sleepytime))
			M.remove_status_effect(/datum/status_effect/debuff/sleepytime)
			M.remove_stress(/datum/stressevent/sleepytime)
			M.mind.sleep_adv.advance_cycle()

	..()

/datum/chemical_reaction/alch/acoffee
	name = "coffee-acorn"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/Acoffee
	required_temp = 374
	results = list(/datum/reagent/consumable/Acoffee = 6)
	required_reagents = list(/datum/reagent/consumable/acorn_powder = 1, /datum/reagent/water = 5)

/datum/chemical_reaction/alch/acoffee/on_reaction(mob/user, obj/item/reagent_containers/container, total_volume)
	. = ..()
	if(container)
		// Remove all leftover water
		container.reagents.del_reagent(/datum/reagent/water)

/datum/reagent/consumable/milk
	name = "Milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF" // rgb: 223, 223, 223
	taste_description = "milk"
	glass_icon_state = "glass_white"
	glass_name = "glass of milk"
	glass_desc = ""

/datum/reagent/consumable/milk/on_mob_life(mob/living/carbon/M)
	if(M.getBruteLoss() && prob(20))
		M.heal_bodypart_damage(1,0, 0)
		. = 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!HAS_TRAIT(H, TRAIT_NOHUNGER))
			H.adjust_hydration(10)
		if(H.blood_volume < BLOOD_VOLUME_NORMAL)
			H.blood_volume = min(H.blood_volume+10, BLOOD_VOLUME_NORMAL)
	..()
