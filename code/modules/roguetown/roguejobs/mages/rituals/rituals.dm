/datum/runeritual/other
	abstract_type = /datum/runeritual/other
	category = "Other"

/datum/runeritual/other/wall
	name = "lesser arcyne wall"
	tier = 1
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/elemental/mote = 1)

/datum/runeritual/other/wall/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(!locate(/obj/effect/decal/cleanable/roguerune/arcyne/wall) in loc)
		to_chat(user, span_warning("The wall matrix has been destroyed! The ritual fizzles."))
		return FALSE
	return 1

/datum/runeritual/other/wall/t2
	name = "greater arcyne wall"
	tier = 2
	required_atoms = list(/obj/item/magic/elemental/shard = 1)

/datum/runeritual/other/wall/t2/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(!locate(/obj/effect/decal/cleanable/roguerune/arcyne/wall) in loc)
		to_chat(user, span_warning("The wall matrix has been destroyed! The ritual fizzles."))
		return FALSE
	return 2

/datum/runeritual/other/wall/t3
	name = "arcyne fortress"
	tier = 3
	required_atoms = list(/obj/item/magic/infernal/core = 1, /obj/item/magic/fae/heartwoodcore = 1, /obj/item/magic/elemental/fragment = 1)

// Teleportation no longer uses a ritual — the matrix invoke handles everything directly.
// Cost is 400 energy per passenger (100 per chant phase x 4 phases), no material cost.