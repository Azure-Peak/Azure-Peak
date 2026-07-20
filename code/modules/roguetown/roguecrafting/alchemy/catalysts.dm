/obj/item/alch/catalyst
	name = "basic catalyst"
	desc = "You should not be seeing this."
	var/list/enabled_recipes	// list of recipe datum paths that the catalyst allows one to craft

/datum/catalyst_recipe
	var/name = "basic catalyst"			// should be the same as the catalyst name
	var/path = /obj/item/alch/catalyst	// catalyst to create
	var/seed_item						// item used to start creating the catalyst. MUST BE UNIQUE
	var/difficulty = 5					// steps in the process. 5 is default, 4-7 the sane range. any less and it's trivial, any more and it feels unfair
	var/list/correct_steps				// don't touch this one it's randomized on roundstart

/obj/item/alch/catalyst/florid
	name = "florid catalyst"
	desc = "A rodlike object made of an enigmatic material. Mostly rigid, it bends slightly under pressure. It feels cold to the touch, yet subtly alyve."
	enabled_recipes = subtypesof(/datum/transmutation_recipe/florid) // it's uncanny how easy it is
