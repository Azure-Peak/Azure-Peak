/obj/item/dream_material
	name = "dream item"
	desc = "you shouldn't see this."
	w_class = WEIGHT_CLASS_TINY
	icon =  'icons/roguetown/misc/dream_materials.dmi'

// Tier 1
/obj/item/dream_material/dream_spike
	name = "effervescent spike"
	icon_state = "spike"

/obj/item/dream_material/parchment_raw
	name = "imagined parchment"
	icon_state = "paper"

/obj/item/dream_material/dream_ring
	name = "gleaming ring"
	icon_state = "ring"

// Tier 2
/obj/item/dream_material/dream_effigy
	name = "glittering effigy"
	icon_state = "effigy"

/obj/item/dream_material/dream_fishes
	name = "spiraling eels"
	icon_state = "fishes"

/obj/item/dream_material/dream_blade
	name = "shattered blade"
	icon_state = "blade"

// Tier 3
/obj/item/dream_material/dream_shards
	name = "distant shards"
	icon_state = "shards"

/obj/item/dream_material/dream_star
	name = "wronged star"
	icon_state = "star"

// Tierless
/obj/item/dream_material/parchment_silver
	name = "imagined parchment"
	icon_state = "tier1_open"

/obj/item/dream_material/parchment_gold
	name = "imagined parchment"
	icon_state = "tier2_open"

/obj/item/dream_material/parchment_dream
	name = "imagined parchment"
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
	if(P.infusion_payload == infusion_type)
		if(P.charge >= P.max_charge)
			to_chat(user, "<span class='warning'>[P] is already fully charged!</span>")
			return FALSE

		P.charge = min(P.max_charge, P.charge + charge_grant)
		P.update_pylon_appearance()
		to_chat(user, "<span class='notice'>You channel [src] into [P], replenishing its charge.</span>")
	else
		P.set_infusion(infusion_type, max_charge_grant, charge_grant, pylon_color)
		to_chat(user, "<span class='notice'>You overwrite the core of [P] with the essence of [src]!</span>")

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

	if(!do_after(user, 10 SECONDS))
		to_chat(user, span_warning("I was interrupted!"))
		return

	to_chat(user, "<span class='purple'>You channel energy through [src], manifesting a pulsating pylon...</span>")

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

// Parchments Spawner
/obj/effect/spawner/lootdrop/roguetown/dream_material/parchment
	name = "dream parchment spawner"
	loot = list(
		/obj/item/dream_material/parchment_silver = 60,
		/obj/item/dream_material/parchment_gold = 30,
		/obj/item/dream_material/parchment_dream = 10
	)
