/datum/abyssal_ritual/cultivate_dream_seed
	name = "Cultivate Dream Seed"
	desc = "Condenses raw abyssal fluctuations into a physical seed capable of growing anchor pylons."
	base_channel_time = 50

	required_ingredients = list(
		/obj/item/dream_material/dream_spike = 3
	)
	reward_items = list(
		/obj/item/dream_material/dream_seed = 1
	)
	invocation_phases  = list(
		"#Depth coral, bloom for us."
	)

/datum/abyssal_ritual/cultivate_dream_seed/on_success(obj/structure/roguemachine/dream_pool/P, mob/living/leader, list/mob/living/channelers)
	P.visible_message(span_purple("The surrounding dreamspikes dissolve into the pool, rushing into the center vortex before solidifying into a glowing seed!"))
	return ..()

/datum/abyssal_ritual/seed_transmutation/fortune
	name = "Transmute Seed of Fortune"
	desc = "Infuses a basic dream seed with gleaming rings to manifest wealth and luck."
	required_ingredients = list(
		/obj/item/dream_material/dream_seed = 1,
		/obj/item/dream_material/dream_ring = 2
	)
	reward_items = list(
		/obj/item/dream_material/dream_seed/fortune = 1
	)
	invocation_phases = list(
		"#Depths full of lost fortunes, dredge up some treasures."
	)

/datum/abyssal_ritual/seed_transmutation/perception
	name = "Transmute Seed of Perception"
	desc = "Infuses a basic dream seed with spiraling eels to grants heightened awareness."
	required_ingredients = list(
		/obj/item/dream_material/dream_seed = 1,
		/obj/item/dream_material/dream_fishes = 2
	)
	reward_items = list(
		/obj/item/dream_material/dream_seed/perception = 1
	)
	invocation_phases = list(
		"#Open eyes of the deep, see through the dark water."
	)

/datum/abyssal_ritual/seed_transmutation/stealth
	name = "Transmute Seed of Stealth"
	desc = "Infuses a basic dream seed with glittering effigies to bind the shadows."
	required_ingredients = list(
		/obj/item/dream_material/dream_seed = 1,
		/obj/item/dream_material/dream_effigy = 2
	)
	reward_items = list(
		/obj/item/dream_material/dream_seed/sneaky = 1
	)
	invocation_phases = list(
		"#The abyss swallows light, leaving nothing behind."
	)

/datum/abyssal_ritual/seed_transmutation/strength
	name = "Transmute Seed of Strength"
	desc = "Infuses a basic dream seed with wronged stars to channel crushing force."
	required_ingredients = list(
		/obj/item/dream_material/dream_seed = 1,
		/obj/item/dream_material/dream_star = 1
	)
	reward_items = list(
		/obj/item/dream_material/dream_seed/strength = 1
	)
	invocation_phases = list(
		"#Crush them beneath the weight of ten thousand leagues."
	)

/datum/abyssal_ritual/seed_transmutation/speed
	name = "Transmute Seed of Speed"
	desc = "Infuses a basic dream seed with distant shards to hasten movements."
	required_ingredients = list(
		/obj/item/dream_material/dream_seed = 1,
		/obj/item/dream_material/dream_shards = 1
	)
	reward_items = list(
		/obj/item/dream_material/dream_seed/speed = 1
	)
	invocation_phases = list(
		"#Currents flow fast, rip through the waves like a phantom."
	)

/datum/abyssal_ritual/imagine_parchment
	name = "Imagine Parchment"
	desc = "Through hundreds of years of abyssorite experience and out of vital necessity, The Thallacite lends some of its power to let any abyssorite imagine.. parchment."
	base_channel_time = 100

	required_ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet = 3
	)
	reward_items = list(
		/obj/item/dream_material/parchment_raw = 3
	)
	invocation_phases  = list(
		"Abyssor, hwja'ajaba!",
		"Iä! Iä! Abyssor fhtagn!"
	)

/datum/abyssal_ritual/imagine_parchment/on_success(obj/structure/roguemachine/dream_pool/P, mob/living/leader, list/mob/living/channelers)
	P.visible_message(span_purple("The materials stretch out and dry into a thin, tough looking material. Parchment.. It resembles a strange, leathery texture, like the hide of a foreign creature."))
	return ..()

/datum/abyssal_ritual/imagine_parchment/silver
	name = "Imagine Silvery Parchment"
	desc = "Parchment laced with silvery paint, not actual silver. It can contain some of the most common visions in writing."

	required_ingredients = list(
		/obj/item/dream_material/parchment_raw = 4
	)
	reward_items = list(
		/obj/item/dream_material/parchment_silver = 3
	)

/datum/abyssal_ritual/imagine_parchment/silver_alt
	name = "Imagine Silvery Parchment (dream materials)"
	desc = "An alternative method that utilizes gleaming rings to easily silverize a sheet of raw parchment."
	required_ingredients = list(
		/obj/item/dream_material/parchment_raw = 1,
		/obj/item/dream_material/dream_ring = 2
	)
	reward_items = list(
		/obj/item/dream_material/parchment_silver = 2
	)

/datum/abyssal_ritual/imagine_parchment/gold
	name = "Imagine Golden Parchment"
	desc = "Finely treated parchment that simulates a gold flake appearance. Capable of transcribing stranger, more enigmatic visions."
	required_ingredients = list(
		/obj/item/dream_material/parchment_silver = 1,
		/obj/item/dream_material/dream_ring = 3
	)
	reward_items = list(
		/obj/item/dream_material/parchment_gold = 2
	)

/datum/abyssal_ritual/imagine_parchment/dream
	name = "Imagine Dreamy Parchment"
	desc = "The pinnacle of abyssal calligraphy. Studded with Sylveric, the metal of dreams. It can contain primal dreams from Abyssor's core thoughts."
	base_channel_time = 150
	required_ingredients = list(
		/obj/item/dream_material/parchment_gold = 1,
		/obj/item/dream_material/dream_fishes = 2
	)
	reward_items = list(
		/obj/item/dream_material/parchment_dream = 1
	)
	invocation_phases  = list(
		"Abyssor, hwja'ajaba!",
		"Iä! Iä! Abyssor fhtagn!",
		"The deep rises to my call!",
		"By the salt and the tide, awaken!"
	)

/datum/abyssal_ritual/communal_viscosity
	name = "Commune Umbral Gift"
	desc = "Whispers abyssal truths into the minds of all nearby channelers. Grants the 'Gift of Umbral Paint' spell to any conscious individual present who does not already possess it."
	base_channel_time = 300

	required_ingredients = list(
		/obj/item/dream_material/dream_spike = 2,
		/obj/item/dream_material/dream_ring = 1
	)

	invocation_phases = list(
		"Drink deep from indigo tides...",
		"Let the ink of the depths stain your thoughts!",
		"Awaken, supplicants of the abyss!"
	)
	success_sound = 'sound/magic/abyssor_splash.ogg'

/datum/abyssal_ritual/communal_viscosity/can_commence_ritual(obj/structure/roguemachine/dream_pool/P, mob/living/leader)
	var/list/turf/outer_rim = P.get_outer_rim_turfs()
	var/list/mob/living/eligible_targets = list()

	for(var/mob/living/M in range(2, P))
		if(M.stat != CONSCIOUS)
			continue
		if(M == leader || (get_turf(M) in outer_rim))
			if(!M.mind?.has_spell(/datum/action/cooldown/spell/umbral_viscosity) && !M.mind?.has_spell(/datum/action/cooldown/spell/umbral_viscosity/single_use))
				eligible_targets += M

	if(!length(eligible_targets))
		to_chat(leader, span_warning("The vortex finds no minds requiring the Umbral Gift here! The ritual refuses to begin."))
		return FALSE

	return TRUE

/datum/abyssal_ritual/communal_viscosity/on_success(obj/structure/roguemachine/dream_pool/P, mob/living/leader, list/mob/living/channelers)
	..()

	var/list/turf/outer_rim = P.get_outer_rim_turfs()
	var/dolphins_blessed = 0

	for(var/mob/living/M in range(2, P))
		if(M.stat != CONSCIOUS)
			continue
		if(M == leader || (get_turf(M) in outer_rim))
			if(!M.mind?.has_spell(/datum/action/cooldown/spell/umbral_viscosity) && !M.mind?.has_spell(/datum/action/cooldown/spell/umbral_viscosity/single_use))
				var/datum/action/cooldown/spell/umbral_viscosity/single_use/B = new /datum/action/cooldown/spell/umbral_viscosity/single_use()
				M.mind.AddSpell(B, M)
				to_chat(M, span_purple("An oily vision washes over your mind! You have been gifted the Umbral Paint."))
				M.visible_message(span_purple("[M]'s eyes momentarily flash a dark, ink-like purple."))
				dolphins_blessed++

	P.visible_message(span_purple("The pool fountains violently, embedding [dolphins_blessed] soul\s with abyssal gifts!"))
	return TRUE
