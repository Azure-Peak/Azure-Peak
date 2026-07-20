// FLORID RECIPES: turn plants into other plants
/datum/transmutation_recipe/florid
	abstract_type = /datum/transmutation_recipe/florid
	name = "Base Florid Recipe"
	category = "Florid Transmutation"
	catalyst = /obj/item/alch/catalyst/florid

/datum/transmutation_recipe/florid/fiber_to_grain
	name = "Fiber Sanguination"
	materia_aspects = list(/datum/materia_aspect/plant)
	input_items = list(/obj/item/natural/fibers = 4)
	output_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)

/datum/transmutation_recipe/florid/grain_to_fibers
	name = "Grain Raefication"
	materia_aspects = list(/datum/materia_aspect/air)
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)
	output_items = list(/obj/item/natural/fibers = 3)

// TERRAN RECIPES: earthen material recipes, not including metals
/datum/transmutation_recipe/terran
	abstract_type = /datum/transmutation_recipe/terran
	name = "Base Terran Recipe"
	category = "Terran Transmutation"
	catalyst = /obj/item/alch/catalyst/terran

/datum/transmutation_recipe/terran/stone
	name = "Clay Petrification"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/natural/clay = 2)
	output_items = list(/obj/item/natural/rock = 2) // you need either 3 clay or 2 clay and a rock for this - so you get 2 outputs, still a loss

/datum/transmutation_recipe/terran/clay
	name = "Stone Plasticization" // from plasticity, the "defining mechanical property of clay" (thanks wikipedia)
	materia_aspects = list(/datum/materia_aspect/water)
	input_items = list(/obj/item/natural/rock = 2)
	output_items = list(/obj/item/natural/clay = 2)

/datum/transmutation_recipe/terran/coal
	name = "Stone Carbonization"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/natural/rock = 3) // old recipe was 4 rocks to 1 coal, you can do this in the same - adds up with their sellprices
	output_items = list(/obj/item/rogueore/coal = 1)

// AENEIC RECIPES: metal recipes, not including silver or gold
/datum/transmutation_recipe/aeneic
	abstract_type = /datum/transmutation_recipe/aeneic
	name = "Base Aeneic Recipe"
	category = "Aeneic Transmutation"
	catalyst = /obj/item/alch/catalyst/aeneic

/datum/transmutation_recipe/aeneic/iron
	name = "Ferropoeia" // is this mixing greek and latin? yes. deal with it
	materia_aspects = list(/datum/materia_aspect/metal)
	input_items = list(/obj/item/rogueore/coal = 2) // need iron to make iron, so this is effectively the old 2 coal : 1 iron ratio which adds up given their sellprices
	output_items = list(/obj/item/rogueore/iron = 2)

/datum/transmutation_recipe/aeneic/copper
	name = "Chalkóspoeia" // this one is entirely greek, because i like making nerds uncomfortable
	materia_aspects = list(/datum/materia_aspect/change)
	input_items = list(/obj/item/natural/stone = 4) // 4 stone 1 clay = 6 mammon, same sellprice as 1 copper ore
	output_items = list(/obj/item/rogueore/copper = 1)

/datum/transmutation_recipe/aeneic/tin
	name = "Kassiteropoeia" // tee hee
	materia_aspects = list(/datum/materia_aspect/mundane)
	input_items = list(/obj/item/natural/stone = 6) // tin ore is 7 so you need to feed it more rocks, dirt price assumed to be 1 mam since it's like a rock [citation needed]
	output_items = list(/obj/item/rogueore/tin = 1)

// CHRYSOPOEIA: a great work, creating alchemical gold; catalyst is difficult to make
/datum/transmutation_recipe/chrysopoeia
	name = "Chrysopoeia"
	category = "Chrysopoeic Transmutation"
	catalyst = /obj/item/alch/catalyst/chrysopoeic
	materia_aspects = list(/datum/materia_aspect/solar)	// this _technically_ creates value - 32 sellprice of iron, 10 for the zenar for solar materia
	input_items = list(/obj/item/rogueore/iron = 4)		// means you get 8 mammons out of nothing, except you can't buy iron that cheap so it's not econ exploit
	output_items = list(/obj/item/rogueore/gold = 1) 	// the actual use of this is gilbranze production for high-level artifice in mgl3pt2

// ARGYROPOEIA: an explicitly Noccite work, the catalyst is _impossible_ to create. it's adminspawn-only for now
// and will remain an extremely rare Noccite artifact once a way to obtain it is added in part 2 of mgl3
/datum/transmutation_recipe/argyopoeia
	name = "Argyropoeia"
	category = "Argyopoeic Transmutation"
	snowflake_desc = "Can only be performed at nite."
	catalyst = /obj/item/alch/catalyst/argyopoeic
	materia_aspects = list(/datum/materia_aspect/lunar)
	input_items = list(/obj/item/rogueore/gold = 2)		// you are actively losing value here since gold is 50 mams each and silver is 80 not to mention the materia cost
	output_items = list(/obj/item/rogueore/silver = 1)

/datum/transmutation_recipe/argyopoeia/execution_blocked(mob/user) // also you can only do it at nite because noccite ritual and whatnot
	if(GLOB.tod != "night")
		return "This work of Noc may only be performed while His light shines."
	return FALSE

// NIGREDO: lit. 'blackening'. the first stage of the great work, its recipes follow a theme of decomposition and are irreversable
/datum/transmutation_recipe/nigredo
	abstract_type = /datum/transmutation_recipe/nigredo
	name = "Base Nigredo Recipe"
	category = "Nigredic Transmutation"
	catalyst = /obj/item/alch/catalyst/nigredo
	materia_aspects = list(/datum/materia_aspect/fire) // most of these recipes use ignis so we set it here

/datum/transmutation_recipe/nigredo/viscera
	name = "Protein Decomposition"
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef = 2)
	output_items = list(/obj/item/alch/viscera = 1) // alchemical meatgrinder, how miraculous

/datum/transmutation_recipe/nigredo/moreviscera
	name = "Mass Protein Decomposition"
	input_items = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef = 6)
	output_items = list(/obj/item/alch/viscera = 3) // i guess we had two of these recipes for some reason?

// ALBEDO: lit 'whitening'. the second stage of the great work, its recipes follow a theme of purification and are irreversable
/datum/transmutation_recipe/albedo
	abstract_type = /datum/transmutation_recipe/albedo
	name = "Base Albedo Recipe"
	category = "Albedic Transmutation"
	catalyst = /obj/item/alch/catalyst/albedo
	materia_aspects = list(/datum/materia_aspect/lunar) // best representation of purity we have - adds a ~5m tax at minimum to most of these recipes

/datum/transmutation_recipe/albedo/cinnabar // enchanters love this one simple trick
	name = "Cinnabar Purification"
	input_items = list(/obj/item/rogueore/iron = 1, /obj/item/rogueore/coal = 1) // 8 + 4 = 12, +5m materia tax = 17, higher than buying from stockpile
	output_items = list(/obj/item/rogueore/cinnabar = 1)

/datum/transmutation_recipe/albedo/salt
	name = "Fat Salination" // usually means applying salt to something, but also refers to the increase of salt content in soil!
	materia_aspects = list(/datum/materia_aspect/water)
	input_items = list(/obj/item/ash = 1, /obj/item/reagent_containers/food/snacks/fat = 1) // this arguably creates value but it's not mass-producable - much less worth your time than selling random things to the navigator
	output_items = list(/obj/item/reagent_containers/powder/salt = 1)

/datum/transmutation_recipe/albedo/altsalt
	name = "Mince Salination"
	materia_aspects = list(/datum/materia_aspect/water)
	input_items = list(/obj/item/ash = 1, /obj/item/reagent_containers/food/snacks/rogue/meat/mince = 1)
	output_items = list(/obj/item/reagent_containers/powder/salt = 1)

// XANTHOSIS: lit 'yellowing'. the third stage of the great work, its recipes folow a theme of enhancement and are irreversable
/datum/transmutation_recipe/xanthosis
	abstract_type = /datum/transmutation_recipe/xanthosis
	name = "Base Xanthosis Recipe"
	category = "Xanthotic Transmutation"
	catalyst = /obj/item/alch/catalyst/xanthosis

/datum/transmutation_recipe/xanthosis/coal
	name = "Coal Platonization"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/alch/coaldust = 1)
	output_items = list(/obj/item/rogueore/coal = 1) // all dust ungrinding recipes are value-negative because of the materia cost

/datum/transmutation_recipe/xanthosis/iron
	name = "Iron Platonization"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/alch/irondust = 1)
	output_items = list(/obj/item/rogueore/iron = 1) // all dust ungrinding recipes are value-negative because of the materia cost

/datum/transmutation_recipe/xanthosis/gold
	name = "Gold Platonization"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/alch/golddust = 1)
	output_items = list(/obj/item/rogueore/gold = 1) // all dust ungrinding recipes are value-negative because of the materia cost

/datum/transmutation_recipe/xanthosis/silver
	name = "Silver Platonization"
	materia_aspects = list(/datum/materia_aspect/earth)
	input_items = list(/obj/item/alch/silverdust = 1)
	output_items = list(/obj/item/rogueore/silver = 1) // all dust ungrinding recipes are value-negative because of the materia cost

// RUBEDO: lit 'reddening'. the final stage of the great work, its recipes unite the spiritual and physical to create potent alchemical reagents with a divine resonance
/datum/transmutation_recipe/rubedo
	abstract_type = /datum/transmutation_recipe/rubedo
	name = "Base Rubedo Recipe"
	category = "Rubedic Transmutation"
	catalyst = /obj/item/alch/catalyst/rubedo

/datum/transmutation_recipe/rubedo/nitevision
	name = "Moonlight Distillation"
	materia_aspects = list(/datum/materia_aspect/lunar)
	input_items = list(/obj/item/alch/mentha = 1, /obj/item/alch/matricaria = 1) // per potion ingredients, plus the lunar aspect = noc potion
	output_items = list(/obj/item/alch/reagent_nitevision = 1)
