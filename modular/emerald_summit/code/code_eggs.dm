// Emerald Summit map-compat alias. ES's repo extracted Neu_Farming's egg under this bare
// typepath, and dun_world_2.dmm places 31 of them - but every recipe, the chicken laying,
// hatching and rot logic key off /snacks/rogue/egg, so mapped eggs failed every istype().
// Rather than editing the map, the ES path is now simply a child of the real egg: identical
// behavior inherited wholesale, and istype(egg, /snacks/rogue/egg) holds.
/obj/item/reagent_containers/food/snacks/egg
	parent_type = /obj/item/reagent_containers/food/snacks/rogue/egg
