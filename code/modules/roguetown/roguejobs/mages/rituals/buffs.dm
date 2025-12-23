/datum/runeritual/knowledge
	name = "knowledge gain"
	tier = 1
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 1)

/datum/runeritual/knowledge/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE

/datum/runeritual/buff
	blacklisted = TRUE
	tier = 1
	var/buff

/datum/runeritual/buff/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE

/datum/runeritual/buff/strength
	name = "arcane augmentation of strength"
	buff = /datum/status_effect/buff/magic/strength
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 2,/obj/item/magic/elemental/shard = 2)

/datum/runeritual/buff/lesserstrength
	name = "lesser arcane augmentation of strength"
	buff = /datum/status_effect/buff/magic/strength_lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/elemental/mote = 2,/obj/item/magic/manacrystal = 1)

/datum/runeritual/buff/constitution
	name = "fortify constitution"
	buff = /datum/status_effect/buff/magic/constitution
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 2, /obj/item/magic/obsidian = 4)

/datum/runeritual/buff/lesserconstitution
	name = "lesser fortify constitution"
	buff = /datum/status_effect/buff/magic/constitution_lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 1, /obj/item/magic/obsidian = 2)

/datum/runeritual/buff/speed
	name = "haste"
	buff = /datum/status_effect/buff/magic/speed
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/artifact = 2, /obj/item/magic/leyline = 2)

/datum/runeritual/buff/lesserspeed
	name = "lesser haste"
	buff = /datum/status_effect/buff/magic/speed_lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/artifact = 1, /obj/item/magic/leyline = 1)

/datum/runeritual/buff/perception
	name = "arcane eyes"
	buff = /datum/status_effect/buff/magic/perception
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/reagent_containers/food/snacks/grown/manabloom = 2, /obj/item/magic/infernal/fang = 1)

/datum/runeritual/buff/lesserperception
	name = "lesser arcane eyes"
	buff = /datum/status_effect/buff/magic/perception_lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/reagent_containers/food/snacks/grown/manabloom = 1, /obj/item/magic/infernal/ash = 2)

/datum/runeritual/buff/willpower
	name = "vitalized willpower"
	buff = /datum/status_effect/buff/magic/willpower
	tier = 2
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/obsidian = 2, /obj/item/magic/iridescentscale = 1)

/datum/runeritual/buff/lesserwillpower
	name = "lesser vitalized willpower"
	buff = /datum/status_effect/buff/magic/willpower_lesser
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/obsidian = 2, /obj/item/magic/fairydust = 2)

/datum/runeritual/buff/nightvision
	name = "darksight"
	buff = /datum/status_effect/buff/darkvision
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 2, /obj/item/magic/iridescentscale = 1, /obj/item/magic/elemental/shard = 1)
