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
