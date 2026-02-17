/datum/runeritual/knowledge
	name = "knowledge gain"
	tier = 1
	blacklisted = FALSE
	required_atoms = list(/obj/item/magic/manacrystal = 1)

/datum/runeritual/knowledge/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	return TRUE

