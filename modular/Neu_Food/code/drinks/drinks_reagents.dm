/datum/reagent/consumable/rosewater
	name = "rosa tea"
	description = "Steeped rosa petals with mild health regeneration and antidotal properties."
	cuisine = CUISINE_SOUTH_IMPERIAL
	drink_type = DRINKTYPE_CAFFEINE
	quality = DRINK_VERYGOOD
	hydration_factor = 5
	reagent_state = LIQUID
	color = "#f398b6"
	taste_description = "floral sweetness"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/consumable/rosewater/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.5	* REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.1, 0)
		M.adjustToxLoss(-2, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/consumable/rosewater_spiced
	name = "spiced rosa tea"
	description = "Spiced rose petals that help to reinvigorate the body's humors, providing modest health regeneration and antidotal properties."
	cuisine = CUISINE_SOUTH_IMPERIAL
	drink_type = DRINKTYPE_CAFFEINE
	quality = DRINK_FANTASTIC
	hydration_factor = 5
	reagent_state = LIQUID
	color = "#F2638C"
	taste_description = "floral spiciness"
	overdose_threshold = 0
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173

/datum/reagent/consumable/rosewater_spiced/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(0.8	* REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.46	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.46	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.2, 0)
		M.adjustToxLoss(-3, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

// Reagents system don't have the idea of solute and solvent so we need a type for each
/datum/reagent/consumable/caffeine/
	drink_type = DRINKTYPE_CAFFEINE
	name = "caffeine"
	description = "Why are you seeing this?"
	hydration_factor = 5
	overdose_threshold = 60
	brew_buff = /datum/status_effect/buff/brew/vigorized

/datum/reagent/consumable/caffeine/on_mob_metabolize(mob/living/L)
	. = ..()
	apply_brew(L, TRUE)

/datum/reagent/consumable/caffeine/on_mob_life(mob/living/carbon/M)
	. = ..()
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(5) // 1/6th of mana pot
	apply_brew(M)
	M.sate_addiction(/datum/charflaw/addiction/caffiend)

/datum/reagent/consumable/caffeine/overdose_process(mob/living/carbon/M)
	. = ..()
	M.Jitter(2)
	if(prob(5))
		M.heart_attack()

/datum/reagent/consumable/caffeine/coffee
	cuisine = CUISINE_RANESHENI
	name = "coffee"
	description = "Coffee beans brewed into a hot drink. With a hint of bitterness. Rejuvenating."
	reagent_state = LIQUID
	color = "#482000"
	taste_description = "caramelized bitterness" // coffee has so many flavors I am going for one
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 200
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/caffeine/coffee/milk
	cuisine = CUISINE_ETRUSCAN
	name = "etruccino"
	description = "Milk added to a wonderfully brewed coffee, savory and smooth."
	reagent_state = LIQUID
	color = "#7a5f49"
	taste_description = "savory caramelization"
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 200
	quality = DRINK_FANTASTIC

/datum/chemical_reaction/alch/etruccino
	name = "Etruccino"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/caffeine/coffee/milk
	results = list(/datum/reagent/consumable/caffeine/coffee/milk = 2)
	required_reagents = list(/datum/reagent/consumable/caffeine/coffee = 1, /datum/reagent/consumable/milk = 1)

/datum/reagent/consumable/caffeine/coffee/milk/on_mob_life(mob/living/carbon/M) // milk is good for your bones or something idk
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.15, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/consumable/caffeine/coffee/cheese // cheese is milk right?
	cuisine = CUISINE_ETRUSCAN
	name = "lumpy etruccino"
	description = "A thing of coffee with... with cheese in it. What. Who thought cheese was milk?"
	reagent_state = LIQUID
	color = "#aa894c"
	taste_description = "savory... lumpy caramelization- is that cheese?"
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 200
	quality = DRINK_GOOD // it made the coffee worse

/datum/chemical_reaction/alch/lumpyetruccino
	name = "Lumpy Etruccino"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/caffeine/coffee/cheese
	results = list(/datum/reagent/consumable/caffeine/coffee/cheese = 2)
	required_reagents = list(/datum/reagent/consumable/caffeine/coffee = 1, /datum/reagent/consumable/soup/stew/cheese = 1)

/datum/reagent/consumable/caffeine/coffee_spiced
	cuisine = CUISINE_RANESHENI
	name = "spiced coffee"
	description = "Spiced offee beans brewed into a hot drink, with a hint of bitterness. Modestly rejuvenating."
	reagent_state = LIQUID
	color = "#8C4221"
	taste_description = "caramelized spiciness"
	metabolization_rate = 0.5
	alpha = 200
	quality = DRINK_FANTASTIC

/datum/reagent/consumable/caffeine/coffee_spiced/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.15, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/consumable/caffeine/tea
	cuisine = CUISINE_SOUTHEASTERN
	name = "tea"
	description = "Tea leaves brewed into a hot drink. Slight hint of bitterness. Smooth."
	reagent_state = LIQUID
	color = "#508141" // Deeper green to make it look better
	taste_description = "smooth grassiness" // Yeah, uh.
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	quality = DRINK_VERYGOOD

/datum/reagent/consumable/caffeine/tea/milk
	cuisine = CUISINE_SOUTHEASTERN
	name = "milk tea"
	description = "A hot tea mixture with the savoryness of milk added to it. Very refreshing."
	reagent_state = LIQUID
	color = "#768b70" // Deeper green to make it look better
	taste_description = "smooth, savory grassiness" // Yeah, uh.
	metabolization_rate = REAGENTS_METABOLISM
	alpha = 173
	quality = DRINK_FANTASTIC

/datum/chemical_reaction/alch/milktea
	name = "Milk Tea"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/caffeine/tea/milk
	results = list(/datum/reagent/consumable/caffeine/tea/milk = 2)
	required_reagents = list(/datum/reagent/consumable/caffeine/tea = 1, /datum/reagent/consumable/milk = 1)

/datum/reagent/consumable/caffeine/tea/milk/on_mob_life(mob/living/carbon/M) // milk is good for your bones or something idk
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.15, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/consumable/caffeine/tea_spiced
	cuisine = CUISINE_SOUTHEASTERN
	name = "spiced tea"
	description = "Spiced tea leaves brewed into a hot drink. Slight hint of bitterness. Smoothly rejuvinating."
	reagent_state = LIQUID
	color = "#788C41" // Deeper green to make it look better
	taste_description = "spiced grassiness"
	metabolization_rate = 0.5
	alpha = 173
	quality = DRINK_GOOD

/datum/reagent/consumable/caffeine/tea_spiced/on_mob_life(mob/living/carbon/M)
	. = ..()
	if (M.mob_biotypes & MOB_BEAST)
		M.adjustFireLoss(-0.1	* REAGENTS_EFFECT_MULTIPLIER)
	else
		M.adjustBruteLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustFireLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustOxyLoss(-0.15, 0)
		var/list/our_wounds = M.get_wounds()
		if (LAZYLEN(our_wounds))
			var/upd = M.heal_wounds(1)
			if (upd)
				M.update_damage_overlays()

/datum/reagent/consumable/poppy_milk
	name = "poppy milk"
	description = "Infused liquid of the Poppy, this one leaves your mouth and mind numb after drinking. Drinking more than a cup might not be good for your health..."
	reagent_state = LIQUID
	color = "#dbd7d5"
	taste_description = "instant numbness"
	metabolization_rate = REAGENTS_METABOLISM
	overdose_threshold = 25 // one cup is safe, anything more and it's an OD
	alpha = 200
	quality = DRINK_NICE

/datum/reagent/consumable/poppy_milk/on_mob_life(mob/living/carbon/M)
	M.sate_addiction(/datum/charflaw/addiction/junkie)
	M.apply_status_effect(/datum/status_effect/buff/ozium)
	..()

/datum/reagent/consumable/poppy_milk/overdose_process(mob/living/M)
	M.adjustToxLoss(3, 0)
	..()
	. = 1

// Tea ported from Vanderlin from Misc Fixes PR #862
/datum/reagent/consumable/golden_calendula_tea
	drink_type = DRINKTYPE_CAFFEINE
	cuisine = CUISINE_SOUTHEASTERN
	name = "Golden Calendula Tea"
	description = "A refreshing tea, great to soothe wounds and relieve fatigue."
	color = "#b38e17"
	taste_description = "herbal flavor"
	quality = DRINK_VERYGOOD
	alpha = 173

/datum/reagent/consumable/golden_calendula_tea/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(5)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+5, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1) //at a metabolism of .5 U a tick this translates to 120WHP healing with 20 U Most wounds are unsewn 15-100. This is powerful on single wounds but rapidly weakens at multi wounds.
	if(volume > 0.99)
		M.adjustBruteLoss(-0.75	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.75	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.25, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -1	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.75	* REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/chocolate
	cuisine = CUISINE_OTAVAIS
	name = "hot chocolate"
	description = "Lovingly smooth, velvety, and rich. Provides a modest portion of health regeneration, and minor stamina regeneration."
	color = "#3F291C"
	taste_description = "a throat-clinging sweetness, paired with a rich and warming aftertaste"
	quality = DRINK_GOOD
	alpha = 250

/datum/reagent/consumable/chocolate/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(1)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+1, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.15, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.3	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.3	* REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/spiced_chocolate
	cuisine = CUISINE_RANESHENI
	name = "spiced chocolate"
	description = "Impossibly smooth, velvety, and rich. Provides a generous portion of health regeneration, and minor stamina regeneration."
	color = "#6D472F"
	taste_description = "an impossible blemd of richness, sweetness, and a hint of throat-tingling spiciness"
	quality = DRINK_VERYGOOD
	alpha = 250

/datum/reagent/consumable/spiced_chocolate/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(2)
	if(M.blood_volume < BLOOD_VOLUME_NORMAL)
		M.blood_volume = min(M.blood_volume+2, BLOOD_VOLUME_MAXIMUM)
	var/list/wCount = M.get_wounds()
	if(wCount.len > 0)
		M.heal_wounds(1)
	if(volume > 0.99)
		M.adjustBruteLoss(-0.5	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustFireLoss(-0.5	* REAGENTS_EFFECT_MULTIPLIER, 0)
		M.adjustOxyLoss(-0.15, 0)
		M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -0.5	* REAGENTS_EFFECT_MULTIPLIER)
		M.adjustCloneLoss(-0.5	* REAGENTS_EFFECT_MULTIPLIER, 0)
	..()

/datum/reagent/consumable/soothing_valerian_tea
	drink_type = DRINKTYPE_CAFFEINE
	cuisine = CUISINE_SOUTHEASTERN
	name = "Soothing Valerian Tea"
	description = "A refreshing tea, great to ease fatigue and relieve stress."
	color = "#3b9146"
	quality = DRINK_FANTASTIC
	taste_description = "herbal flavor"
	alpha = 173

/datum/reagent/consumable/soothing_valerian_tea/on_mob_life(mob/living/carbon/M)
	if(!HAS_TRAIT(M,TRAIT_INFINITE_STAMINA))
		M.energy_add(3)
	..()
