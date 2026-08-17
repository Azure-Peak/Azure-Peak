/obj/item/dream_material
	name = "dream item"
	desc = "you shouldn't see this."
	w_class = WEIGHT_CLASS_TINY
	icon =	'icons/roguetown/misc/dream_materials.dmi'

// Tier 1
/obj/item/dream_material/dream_spike
	name = "effervescent spike"
	desc = "A spike that seems to boil internally with patterns that are out of this world. It seems brittle."
	icon_state = "spike"

/obj/item/dream_material/parchment_raw
	name = "imagined parchment"
	desc = "Parchment treated with an Abyssorian secret. Said to provoke mild imagery of that which is written."
	icon_state = "paper"

/obj/item/dream_material/dream_ring
	name = "gleaming ring"
	desc = "A ring that seems oddly shiny for something that's hardly metallic in nature. It feels like a piece of coral, in a way. It seems brittle."
	icon_state = "ring"

// Tier 2
/obj/item/dream_material/dream_effigy
	name = "glittering effigy"
	desc = "An effigy said to have been made by a creature of the dream. Seems workable."
	icon_state = "effigy"

/obj/item/dream_material/dream_fishes
	name = "spiraling eels"
	desc = "A collection of eels inanimate, at least until you try to move one of their members. They seem to hold tight to formation. The materials appear workable."
	icon_state = "fishes"

/obj/item/dream_material/dream_blade
	name = "shattered blade"
	desc = "A collection of shards that form a blade. Yet it refuses to be put back together, as if the material itself decided it rather remains broken. Seems workable."
	icon_state = "blade"

// Tier 3
/obj/item/dream_material/dream_shards
	name = "distant shards"
	desc = "These shards appear close at first, but looking at them makes them creep away in the distance. Yet they fit in your palm, how can they be near and faraway at the same time? Seems exquisite."
	icon_state = "shards"

/obj/item/dream_material/dream_star
	name = "wronged star"
	desc = "Holding this star fills the head with whispers. It tells tales, how it used to shine in the sky but then it saw what a mess we're making of the place. It crashed down on its own accord from the great dream's sky. 'I can fix it, if you'll allow me.' Seems exquisite."
	icon_state = "star"

// Tierless
/obj/item/dream_material/parchment_silver
	name = "quicksilver parchment"
	desc = "A piece of parchment treated with a quicksilver like paint. The paint binds visions, or so they say."
	icon_state = "tier1_open"

/obj/item/dream_material/parchment_gold
	name = "auric parchment"
	desc = "A piece of parchment treated with a flakey, gold-like substance. Said to hold greater visions without warping the words."
	icon_state = "tier2_open"

/obj/item/dream_material/parchment_dream
	name = "sylveric parchment"
	desc = "A piece of parchment treated with sylveric based paint. The stuff of dreams. Said to muddy present, past and future, so that it may appear to us... In a dream."
	icon_state = "tier3_open"

/obj/item/dream_material/dream_seed
	name = "seed of intelligence"
	desc = "A crystalline, pulsating seed that radiates a faint, mesmerizing deep-sea glow. Suitable for cultivating or recharging dream pylons."
	icon_state = "seed"

	/// How many charges this seed restores when used on a pylon (or starting charge when creating one)
	var/charge_grant = 100
	/// The max charge capacity this seed configures on the target pylon
	var/max_charge_grant = 100
	/// The status effect infusion typepath this seed conveys
	var/datum/status_effect/infusion/infusion_type = /datum/status_effect/infusion/intelligence
	/// Color hex code applied to the seed, pylon overlay, and outline filters.
	var/pylon_color
	/// The geyser pylon structure type spawned by this seed (if this is a geyser seed)
	var/obj/structure/dream_pylon/geyser/pylon_type
	/// The trail/paint type associated with this geyser seed
	var/obj/effect/ink_trail/trail_type
	/// Amount of puddles differing from the default to override on geyser pylons.
	var/ink_puddle_spawn_amount

/obj/item/dream_material/dream_seed/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Dream seeds can be used to plant dream pylons, these yield buffs that decay slowly as long as the user remains in range.")
	. += span_info("Can be used on already established pylons to recharge them.")

/obj/item/dream_material/dream_seed/Initialize(mapload)
	. = ..()
	if(pylon_color)
		icon_state = "seed_grey"
		color = pylon_color

/obj/item/dream_material/dream_seed/proc/apply_to_pylon(obj/structure/dream_pylon/P, mob/user)
	// Geyser Seed Logic
	if(pylon_type)
		if(!istype(P, /obj/structure/dream_pylon/geyser))
			to_chat(user, span_warning("[src] can only be used on geyser pylons!"))
			return FALSE

		var/obj/structure/dream_pylon/geyser/G = P

		// Recharging the exact same geyser type
		if(G.trail_type == trail_type)
			if(G.charge >= G.max_charge)
				to_chat(user, span_warning("[G] is already fully charged!"))
				return FALSE

			G.charge = min(G.max_charge, G.charge + charge_grant)
			G.update_pylon_appearance()
			to_chat(user, span_notice("You channel [src] into [G], replenishing its charge."))
			qdel(src)
			return TRUE

		// Reconfigure existing geyser in-place
		G.set_geyser_type(trail_type, max_charge_grant, charge_grant, pylon_color, ink_puddle_spawn_amount)
		to_chat(user, span_notice("You reconfigure [G] using the essence of [src]!"))
		qdel(src)
		return TRUE

	// Standard Infusion Seed Logic
	if(istype(P, /obj/structure/dream_pylon/geyser))
		to_chat(user, span_warning("[src] cannot be used on a geyser pylon!"))
		return FALSE

	if(P.infusion_payload == infusion_type)
		if(P.charge >= P.max_charge)
			to_chat(user, span_warning("[P] is already fully charged!"))
			return FALSE

		P.charge = min(P.max_charge, P.charge + charge_grant)
		P.update_pylon_appearance()
		to_chat(user, span_notice("You channel [src] into [P], replenishing its charge."))
	else
		P.set_infusion(infusion_type, max_charge_grant, charge_grant, pylon_color)
		to_chat(user, span_notice("You overwrite the core of [P] with the essence of [src]!"))

	qdel(src)
	return TRUE

/obj/item/dream_material/dream_seed/attack_self(mob/user)
	. = ..()
	plant_pylon(user)

/obj/item/dream_material/dream_seed/proc/plant_pylon(mob/user)
	var/turf/T = get_step(user, user.dir)
	if(!T || !isopenturf(T) || T.density)
		to_chat(user, span_warning("You need an open space in front of you to plant a dream pylon!"))
		return

	for(var/obj/structure/S in T)
		if(S.density)
			to_chat(user, span_warning("Something is in the way."))
			return

	for(var/obj/machinery/M in T)
		if(M.density)
			to_chat(user, span_warning("Something is in the way."))
			return

	if(!do_after(user, 6.5 SECONDS))
		to_chat(user, span_warning("I was interrupted!"))
		return

	to_chat(user, span_purple("You channel energy through [src], manifesting a pylon..."))

	if(pylon_type)
		var/obj/structure/dream_pylon/geyser/G = new pylon_type(T)
		G.charge = charge_grant
		G.max_charge = max_charge_grant
		G.update_pylon_appearance()
	else
		var/obj/structure/dream_pylon/P = new /obj/structure/dream_pylon(T)
		P.set_infusion(infusion_type, max_charge_grant, charge_grant, pylon_color)

	qdel(src)

/obj/item/dream_material/dream_seed/perception
	name = "seed of perception"
	charge_grant = 75
	max_charge_grant = 75
	infusion_type = /datum/status_effect/infusion/perception
	pylon_color = "#017514"

/obj/item/dream_material/dream_seed/fortune
	name = "seed of fortune"
	charge_grant = 125
	max_charge_grant = 125
	infusion_type = /datum/status_effect/infusion/fortune
	pylon_color = "#bdb001"

/obj/item/dream_material/dream_seed/strength
	name = "seed of strength"
	charge_grant = 50
	max_charge_grant = 50
	infusion_type = /datum/status_effect/infusion/strength
	pylon_color = "#b8681d"

/obj/item/dream_material/dream_seed/speed
	name = "seed of speed"
	charge_grant = 50
	max_charge_grant = 50
	infusion_type = /datum/status_effect/infusion/speed
	pylon_color = "#1db891"

/obj/item/dream_material/dream_seed/sneaky
	name = "seed of stealth"
	charge_grant = 100
	max_charge_grant = 100
	infusion_type = /datum/status_effect/infusion/ambush_trait
	pylon_color = "#001611"

/obj/item/dream_material/dream_seed/geyser
	name = "geyser seed"
	desc = "A crystalline seed bursting with raw paint energy. Suitable for cultivating or modifying geyser pylons."
	infusion_type = null
	pylon_color = "#333749"
	pylon_type = /obj/structure/dream_pylon/geyser
	trail_type = /obj/effect/ink_trail
	charge_grant = 300
	max_charge_grant = 300

/obj/item/dream_material/dream_seed/geyser/healing
	name = "soothing geyser seed"
	desc = "A crystalline seed radiating a warm, soothing green."
	pylon_color = "#b6e6b6"
	pylon_type = /obj/structure/dream_pylon/geyser/healing
	trail_type = /obj/effect/ink_trail/healing
	ink_puddle_spawn_amount = 12
	charge_grant = 150
	max_charge_grant = 150

/obj/item/dream_material/dream_seed/geyser/invigorating
	name = "invigorating geyser seed"
	desc = "A crystalline seed humming with brilliant blue."
	pylon_color = "#3a86ff"
	pylon_type = /obj/structure/dream_pylon/geyser/invigorating
	trail_type = /obj/effect/ink_trail/invigorating
	charge_grant = 125
	max_charge_grant = 125

/obj/item/dream_material/dream_seed/geyser/spiked
	name = "spiked geyser seed"
	desc = "A dark, ominous seed oozing crimson paint."
	pylon_color = "#580000"
	pylon_type = /obj/structure/dream_pylon/geyser/spiked
	trail_type = /obj/effect/ink_trail/evil
	ink_puddle_spawn_amount = 15
	charge_grant = 100
	max_charge_grant = 100

/obj/effect/spawner/lootdrop/roguetown/dream_material
	name = "dream material spawner"
	icon_state = "cot"
	lootcount = 1
	loot = list(
		/obj/item/dream_material/parchment_raw = 50,
		/obj/item/dream_material/parchment_silver = 25,
	)

// Tier 1 Dream Materials Spawner
/obj/effect/spawner/lootdrop/roguetown/dream_material/tier1
	name = "tier 1 dream material spawner"
	loot = list(
		/obj/item/dream_material/dream_spike = 40,
		/obj/item/dream_material/parchment_raw = 30,
		/obj/item/dream_material/dream_ring = 30
	)

// Tier 2 Dream Materials Spawner
/obj/effect/spawner/lootdrop/roguetown/dream_material/tier2
	name = "tier 2 dream material spawner"
	loot = list(
		/obj/item/dream_material/dream_effigy = 40,
		/obj/item/dream_material/dream_fishes = 30,
		/obj/item/dream_material/dream_blade = 30
	)

// Tier 3 Dream Materials Spawner
/obj/effect/spawner/lootdrop/roguetown/dream_material/tier3
	name = "tier 3 dream material spawner"
	loot = list(
		/obj/item/dream_material/dream_shards = 50,
		/obj/item/dream_material/dream_star = 50
	)

// Dream Seeds Spawner
/obj/effect/spawner/lootdrop/roguetown/dream_material/seeds
	name = "dream seed spawner"
	loot = list(
		/obj/item/dream_material/dream_seed = 20, // Intelligence
		/obj/item/dream_material/dream_seed/perception = 20,
		/obj/item/dream_material/dream_seed/fortune = 20,
		/obj/item/dream_material/dream_seed/strength = 15,
		/obj/item/dream_material/dream_seed/speed = 15,
		/obj/item/dream_material/dream_seed/sneaky = 10
	)

// Geyser Seeds Spawner
/obj/effect/spawner/lootdrop/roguetown/dream_material/geyser
	name = "geyser dream seed spawner"
	loot = list(
		/obj/item/dream_material/dream_seed/geyser = 5,
		/obj/item/dream_material/dream_seed/geyser/healing = 25,
		/obj/item/dream_material/dream_seed/geyser/invigorating = 25,
		/obj/item/dream_material/dream_seed/geyser/spiked = 15
	)

// Parchments Spawner
/obj/effect/spawner/lootdrop/roguetown/dream_material/parchment
	name = "dream parchment spawner"
	loot = list(
		/obj/item/dream_material/parchment_silver = 60,
		/obj/item/dream_material/parchment_gold = 30,
		/obj/item/dream_material/parchment_dream = 10
	)
