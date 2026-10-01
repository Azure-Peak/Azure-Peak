

/////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////The old header is gone, take that. Its drinky time.///////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//Roguetown Reagents - Ported from Dreamkeep
/datum/reagent/consumable/acorn_powder
	cuisine = CUISINE_NORTHERN
	drink_type = DRINKTYPE_CAFFEINE
	name = "acorn powder"
	description = "A bitter fine powder."
	color = "#dcb137"
	quality = DRINK_VERYGOOD
	taste_description = "bitter earthy-ness"

/datum/reagent/consumable/acorn_powder/on_mob_life(mob/living/carbon/M)
	M.energy_add(8)
	..()

/datum/reagent/consumable/Acoffee
	cuisine = CUISINE_NORTHERN
	drink_type = DRINKTYPE_CAFFEINE
	name = "acorn coffee"
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
		if(M.blood_volume < BLOOD_VOLUME_NORMAL && volume > 0.99)
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
	name = "milk"
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
		if(H.blood_volume < BLOOD_VOLUME_NORMAL && volume > 0.99)
			H.blood_volume = min(H.blood_volume+10, BLOOD_VOLUME_NORMAL)
	..()


//additions for the drink mixing
//base liquids - juiced in mortar and pestle

/datum/reagent/consumable/juice
	name = "juice"
	drink_type = DRINKTYPE_JUICE
	quality = DRINK_GOOD
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = null
	reagent_state = LIQUID
	hydration_factor = 10

/datum/reagent/consumable/juice/lemon
	cuisine = CUISINE_ETRUSCAN
	name = "Lemon juice"
	description = "An extremely tangy liquified lemon."
	color = "#FFFF00"
	quality = DRINK_NICE
	taste_description = "extreme tangy-ness"
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	hydration_factor = 8

/datum/reagent/consumable/juice/lime
	cuisine = CUISINE_RANESHENI
	name = "Lime juice"
	description = "An extremely tangy liquified lime."
	color = "#00FF00"
	quality = DRINK_NICE
	taste_description = "extreme tangy-ness"
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	hydration_factor = 8

/datum/reagent/consumable/juice/tomato
	cuisine = CUISINE_ETRUSCAN
	name = "Tomato juice"
	description = "A liquified tomato, thinner than tomato sauce, commonly used for mixed drinks."
	color = "#CD5320"
	quality = DRINK_NICE
	taste_description = "pure unfiltered tomato"
	metabolization_rate = 0.8 * REAGENTS_METABOLISM
	hydration_factor = 8

/datum/reagent/consumable/juice/strawberry
	cuisine = CUISINE_NORTH_IMPERIAL
	name = "Strawberry juice"
	description = "An extremely sweet liquified strawberry."
	color = "#9A1B00"
	quality = DRINK_NICE
	taste_description = "extreme strawberry"

/datum/reagent/consumable/juice/pear
	cuisine = CUISINE_SOUTHEASTERN
	name = "Pear juice"
	description = "A slightly tart and bittersweet pale juice from a pear."
	color = "#D2B48C"
	taste_description = "tarty sweetness"

/datum/reagent/consumable/juice/plum
	cuisine = CUISINE_SOUTHEASTERN
	name = "Plum juice"
	description = "A very tart and bittersweet dark juice from a plum."
	color = "#8B008B"
	taste_description = "very tart with a little sweet"

/datum/reagent/consumable/juice/blackberry
	cuisine = CUISINE_NORTH_IMPERIAL|CUISINE_OTAVAIS
	name = "Blackberry juice"
	description = "A slightly tart and sweet dark juice from a blackberry."
	color = "#272C3F"
	taste_description = "slightly tart and very sweet"

/datum/reagent/consumable/juice/raspberry
	cuisine = CUISINE_SOUTHEASTERN
	name = "Raspberry juice"
	description = "A slightly tart and sweet red juice from a raspberry."
	color = "#A01600"
	taste_description = "slightly tart and a bit sweet"

/datum/reagent/consumable/juice/jackberry
	cuisine = CUISINE_SOUTH_IMPERIAL
	name = "Jackberry juice"
	description = "Juiced jackberries, the most azurian juice.."
	color = "#4A3D63"
	taste_description = "certainly not poisoned..."

/datum/reagent/consumable/juice/pomegranate
	cuisine = CUISINE_SOUTH_IMPERIAL
	name = "Pomegranate juice"
	description = "Blessed by Eora this juice is the most romantic of all juices."
	color = "#B3163A"
	taste_description = "juicy and slightly bitter viscous liquid"
	hydration_factor = 20

/datum/reagent/consumable/juice/orange
	cuisine = CUISINE_SOUTH_IMPERIAL
	name = "Orange juice"
	description = "A tangy and energizing juice of a tangerine."
	color = "#FFA500"
	taste_description = "citrussy sweetness."
	hydration_factor = 12

//drink mixes - post reagent reaction

/datum/reagent/consumable/virgin_drink
	name = "virgin drink"
	drink_type = DRINKTYPE_VIRGIN
	quality = DRINK_VERYGOOD
	metabolization_rate = 0.5 * REAGENTS_METABOLISM
	overdose_threshold = null
	reagent_state = LIQUID
	hydration_factor = 15

/datum/reagent/consumable/virgin_drink/lemonade
	cuisine = CUISINE_ETRUSCAN
	name = "Lemonade"
	description = "A sweet and slightly tangy joy to the senses. Tastes like summer."
	color = "#FFFEEE"
	taste_description = "sweet tangy-ness"
	hydration_factor = 14

/datum/chemical_reaction/alch/lemonade
	name = "Lemonade"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/virgin_drink/lemonade
	results = list(/datum/reagent/consumable/virgin_drink/lemonade = 3)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/consumable/juice/lemon = 1, /datum/reagent/consumable/sugar = 1)

/datum/reagent/consumable/virgin_drink/strawberry_lemonade
	cuisine = CUISINE_RANESHENI
	name = "Strawberry Lemonade"
	description = "A sweet, fruity, and slightly tangy joy to the senses. Tastes like a romantic summer."
	color = "#FFD1C9"
	quality = DRINK_FANTASTIC
	taste_description = "a sweet strawberry and lemon mix."

/datum/chemical_reaction/alch/strawlemonade
	name = "strawberry lemonade"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/virgin_drink/strawberry_lemonade
	results = list(/datum/reagent/consumable/virgin_drink/strawberry_lemonade = 2)
	required_reagents = list(/datum/reagent/consumable/juice/strawberry = 1, /datum/reagent/consumable/virgin_drink/lemonade = 1)

/datum/reagent/consumable/virgin_drink/abyssors_rest
	cuisine = CUISINE_RANESHENI
	name = "Abyssor's rest"
	description = "A soft mix of chamomilesque herbs, honey, and a little mint. You should probably not take this in the field."
	color = "#9FC4D6"
	quality = DRINK_GOOD
	taste_description = "a soft and minty herbacious mix."
	metabolization_rate = 1 * REAGENTS_METABOLISM

/datum/reagent/consumable/virgin_drink/abyssors_rest/on_mob_metabolize(mob/living/carbon/M)
	M.apply_status_effect(/datum/status_effect/debuff/knockout)
	..()

/datum/chemical_reaction/alch/abyssorsrest
	name = "Abyssor's rest"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/virgin_drink/abyssors_rest
	results = list(/datum/reagent/consumable/virgin_drink/abyssors_rest = 4)
	required_reagents = list(/datum/reagent/medicine/trait/sleepdraught = 1, /datum/reagent/sleep_powder = 1, /datum/reagent/consumable/caffeine/tea = 1, /datum/reagent/consumable/honey = 1)

/datum/reagent/consumable/virgin_drink/fruit_punch
	cuisine = CUISINE_NORTH_IMPERIAL|CUISINE_SOUTH_IMPERIAL|CUISINE_OTAVAIS|CUISINE_NORTHERN|CUISINE_ETRUSCAN|CUISINE_SOUTHEASTERN|CUISINE_RANESHENI
	name = "Fruit punch"
	description = "A testament to true peace, the most refreshing mix of all the fruits."
	color = "#8A0B0B"
	quality = DRINK_FANTASTIC
	taste_description = "an overwhelming fruitiness."
	hydration_factor = 20

/datum/chemical_reaction/alch/fruitpunch
	name = "Fruit punch"
	mix_sound = 'sound/items/fillbottle.ogg'
	id = /datum/reagent/consumable/virgin_drink/fruit_punch
	results = list(/datum/reagent/consumable/virgin_drink/fruit_punch = 10)
	required_reagents = list(/datum/reagent/consumable/juice/strawberry = 1, /datum/reagent/consumable/juice/lemon = 1, /datum/reagent/consumable/juice/lime = 1, /datum/reagent/consumable/juice/pear = 1, /datum/reagent/consumable/juice/plum = 1, /datum/reagent/consumable/juice/blackberry = 1, /datum/reagent/consumable/juice/raspberry = 1, /datum/reagent/consumable/juice/jackberry = 1, /datum/reagent/consumable/juice/orange = 1)
