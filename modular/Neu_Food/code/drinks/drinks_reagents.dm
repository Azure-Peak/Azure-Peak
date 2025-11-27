/datum/reagent/water/rosewater
	name = "Rose Tea"
	description = "Steeped rose petals with mild regeneration."
	reagent_state = LIQUID
	color = "#f398b6"
	taste_description = "floral sweetness"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/water/rosewater/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5  * REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

// Reagents system don't have the idea of solute and solvent so we need a type for each
/datum/reagent/consumable/caffeine/
	name = "Caffeine"
	description = "Why are you seeing this?"
	hydration_factor = 5
	overdose_threshold = 60

/datum/reagent/consumable/caffeine/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(5) // 1/6th of mana pot
	M.apply_status_effect(/datum/status_effect/buff/vigorized)

/datum/reagent/consumable/caffeine/overdose_process(mob/living/carbon/M)
	. = ..()
	M.Jitter(2)
	if(prob(5))
		M.heart_attack()
	
/datum/reagent/consumable/caffeine/coffee
	name = "Coffee"
	description = "Coffee beans brewed into a hot drink. With a hint of bitterness. Rejuvenating."
	reagent_state = LIQUID
	color = "#482000"
	taste_description = "caramelized bitterness" // coffee has so many flavors I am going for one
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/consumable/caffeine/tea
	name = "Tea"
	description = "Tea leaves brewed into a hot drink. Slight hint of bitterness. Smooth."
	reagent_state = LIQUID
	color = "#508141" // Deeper green to make it look better
	taste_description = "smooth grassiness" // Yeah, uh.
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/consumable/poppy_milk
	name = "Poppy Milk"
	description = "Infused liquid of the Poppy, this one leaves your mouth and mind numb after drinking. Drinking more than a cup might not be good for your health..."
	reagent_state = LIQUID
	color = "#dbd7d5"
	taste_description = "instant numbness"
	metabolization_rate = REAGENTS_METABOLISM
	overdose_threshold = 25 // one cup is safe, anything more and it's an OD
	alpha = 173

/datum/reagent/consumable/poppy_milk/on_mob_life(mob/living/carbon/M)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction()
	M.apply_status_effect(/datum/status_effect/buff/ozium)
	..()

/datum/reagent/consumable/poppy_milk/overdose_process(mob/living/M)
	M.adjustToxLoss(3, 0)
	..()
	. = 1

// Tea ported from Vanderlin from Misc Fixes PR #862
/datum/reagent/consumable/golden_calendula_tea
	name = "Golden Calendula Tea"
	description = "A refreshing tea, great to soothe wounds and relieve fatigue."
	color = "#b38e17"
	taste_description = "herbal flavor"

/datum/reagent/consumable/golden_calendula_tea/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(5)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+5, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1) //at a metabolism of .5 U a tick this translates to 120WHP healing with 20 U Most wounds are unsewn 15-100. This is powerful on single wounds but rapidly weakens at multi wounds.
	if(volume > 0.99)
		M.adjustBruteLoss(-0.75  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.75  * REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.25, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1  * REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.75  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/soothing_valerian_tea
	name = "Soothing Valerian Tea"
	description = "A refreshing tea, great to ease fatigue and relieve stress."
	color = "#3b9146"
	quality = DRINK_FANTASTIC
	taste_description = "herbal flavor"

/datum/reagent/consumable/soothing_valerian_tea/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(3)
	..()
