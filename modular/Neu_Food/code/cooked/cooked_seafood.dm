// Cooked seafood. Not including special meals.
/obj/item/reagent_containers/food/snacks/rogue/fryfish
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood.dmi'
	trash = null
	list_reagents = list(/datum/reagent/consumable/nutriment = 10)
	tastes = list("fish" = 1)
	name = "cooked fish"
	faretype = FARE_POOR
	desc = "A charred fish, crisped to perfection."
	icon_state = "carpcooked"
	foodtype = MEAT
	warming = 5 MINUTES
	dropshrink = 0.6

/obj/item/reagent_containers/food/snacks/rogue/fryfish/carp
	name = "cooked carp"
	desc = "A charred and crisped carp. With a mild flavor and firm texture. Fit for the poor."
	icon_state = "carpcooked"
	faretype = FARE_IMPOVERISHED

/obj/item/reagent_containers/food/snacks/rogue/fryfish/clownfish
	name = "cooked clownfish"
	desc = "A cooked clownfish, its former vibrant colors gone."
	icon_state = "clownfishcooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/angler
	name = "cooked anglerfish"
	desc = "A cooked anglerfish, with a sweet and dense flavor that is sure to please."
	icon_state = "anglercooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/eel
	name = "cooked eel"
	desc = "A cooked eel. With its rich flavor and flaky texture, it's a delicacy."
	icon_state = "eelcooked"
	faretype = FARE_NEUTRAL
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/jelliedeel

/obj/item/reagent_containers/food/snacks/rogue/fryfish/sole
	name = "cooked sole"
	desc = "A cooked sole, with a mild flavor and flaky texture. Fit for the poor."
	icon_state = "solecooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/sole/attackby(obj/item/M, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE
	update_cooktime(user)
	if(istype(M, /obj/item/reagent_containers/food/snacks/butterslice))
		to_chat(user, "You start buttering the sole.")
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/buttersole(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(M)
			qdel(src)
	else
		to_chat(user, span_warning("You need to put [src] on a table to knead in the spice."))

/obj/item/reagent_containers/food/snacks/rogue/fryfish/cod
	name = "cooked cod"
	desc = "A cooked cod, with a mild flavor and flaky texture. Quite popular."
	icon_state = "codcooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/cod/attackby(obj/item/I, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers))
		if(!I.reagents.has_reagent(/datum/reagent/consumable/ethanol/beer, 1))
			to_chat(user, "There's not enough ale to pour over this cod.")
			return TRUE
		to_chat(user, "You start pouring the ale over the hot cod.")
		playsound(get_turf(user), 'modular/Creechers/sound/milking1.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			if(!I.reagents.has_reagent(/datum/reagent/consumable/ethanol/beer, 1))
				to_chat(user, "There's not enough ale to pour over this cod.")
				return TRUE
			I.reagents.remove_reagent(/datum/reagent/consumable/ethanol/beer, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/alecod(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(src)
	else
		to_chat(user, span_warning("You need to put [src] on a table to knead in the spice."))

/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster
	name = "cooked lobster"
	desc = "A cooked lobster. It has a rich and sweet flavor, but not much meat. On its own it is considered\
	food for the poor, but buttered or peppered it is a delicacy."
	icon_state = "lobstercooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	var/found_table = locate(/obj/structure/table) in src.loc
	if(!found_table)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE
	if(istype(I, /obj/item/reagent_containers/peppermill))
		var/obj/item/reagent_containers/peppermill/mill = I
		if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
			to_chat(user, "There's not enough black pepper to make anything with.")
			return TRUE
		mill.icon_state = "peppermill_grind"
		to_chat(user, "You start rubbing the lobster with black pepper.")
		playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
				to_chat(user, "There's not enough black pepper to make anything with.")
				return TRUE
			mill.reagents.remove_reagent(/datum/reagent/consumable/blackpepper, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/pepperlobsta(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "You start buttering the lobster.")
			if(do_after(user,short_cooktime, target = src))
				user.mind.add_sleep_experience(/datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal(loc)
				qdel(I)
				qdel(src)
	else
		to_chat(user, span_warning("You need to put [src] on a table to knead in the spice."))

/obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon
	name = "cooked salmon"
	desc = "A cooked salmon. Less terrifying now that it is cooked. It has rich and oily flesh, making it quite popular once spiced."
	icon_state = "salmoncooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon/attackby(obj/item/M, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE
	update_cooktime(user)
	if(istype(M, /obj/item/alch/mentha))
		to_chat(user, "You start crushing mentha upon the salmon.")
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/dendorsalmon(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(M)
			qdel(src)
	if(istype(M, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
		to_chat(user, "You start crushing berries upon the salmon.")
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/berrysalmon(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(M)
			qdel(src)

	else
		to_chat(user, span_warning("You need to put [src] on a table to knead in the spice."))

/obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice
	name = "cooked plaice"
	desc = "A cooked plaice. With a mild and sweet flavor. Popular with the rich."
	icon_state = "plaicecooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/plaice/attackby(obj/item/M, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE
	update_cooktime(user)
	if(istype(M, /obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced))
		to_chat(user, "You start placing onions under the plaice.")
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/onionplaice(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(M)
			qdel(src)
	else
		to_chat(user, span_warning("You need to put [src] on a table to knead in the spice."))

/obj/item/reagent_containers/food/snacks/rogue/fryfish/mudskipper
	name = "cooked mudskipper"
	desc = "A cooked mudskipper. With a fishy and earthy flavor. Popular amongst vagrants."
	icon_state = "mudskippercooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/bass
	name = "cooked seabass"
	desc = "A cooked seabass. With a firm texture, seabass goes well with spices and sauces."
	icon_state = "seabasscooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/bass/attackby(obj/item/M, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE
	update_cooktime(user)
	if(istype(M, /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove))
		to_chat(user, "You start crushing garlick upon the bass.")
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/garlickbass(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(M)
			qdel(src)
	else
		to_chat(user, span_warning("You need to put [src] on a table to knead in the spice."))

/obj/item/reagent_containers/food/snacks/rogue/fryfish/sunny
	name = "cooked sunny"
	desc = "A cooked sunny. With tender and flaky flesh."
	icon_state = "sunnycooked"
	faretype = FARE_POOR

/obj/item/reagent_containers/food/snacks/rogue/fryfish/clam
	name = "cooked clam"
	desc = "A cooked clam. With a sweet and briny flavor, clams are often used in soup."
	icon_state = "clamcooked"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/clam/attackby(obj/item/I, mob/living/user, params)
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("I need to use a table."))
		return FALSE
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers))
		if(!I.reagents.has_reagent(/datum/reagent/consumable/milk, 1))
			to_chat(user, "There's not enough milk to pour over these clams.")
			return TRUE
		to_chat(user, "You start pouring the milk over the hot clams.")
		playsound(get_turf(user), 'modular/Creechers/sound/milking1.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			if(!I.reagents.has_reagent(/datum/reagent/consumable/milk, 1))
				to_chat(user, "There's not enough milk to pour over these clams.")
				return TRUE
			I.reagents.remove_reagent(/datum/reagent/consumable/milk, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/milkclam(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(src)
	else
		to_chat(user, span_warning("You need to put [src] on a table to knead in the spice."))

/obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp
	name = "cooked shrimp"
	desc = "A cooked shrimp. Firm and springy with a natural hint of saltiness."
	icon_state = "shrimpcooked"
	faretype = FARE_NEUTRAL
	name = "cooked shrimp"
	tastes = list("shrimp" = 1)

/obj/item/reagent_containers/food/snacks/rogue/fryfish/crab
	name = "cooked crab"
	desc = "A cooked crab. With a sweet and rich flavor. Often laboriously made into crab cakes."
	icon_state = "crabcooked"
	faretype = FARE_NEUTRAL
	name = "cooked crab"
	tastes = list("crab" = 1)

/obj/item/reagent_containers/food/snacks/rogue/fryfish/salmon/black_headed
	name = "black-headed salmon"
	icon_state = "salmon_black"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/flounder
	name = "flounder"
	icon_state = "flounder"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_shrimp
	name = "swamp shrimp"
	icon_state = "swamp_shrimp"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/swamp_mother
	name = "swamp mother"
	icon_state = "swamp_mother"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/black_bass
	name = "black bass"
	icon_state = "black_bass"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/zizo_abberation
	name = "zizo abberation"
	icon_state = "zizo_abberation"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/sturgeon
	name = "sturgeon"
	icon_state = "sturgeon"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/mackerel
	name = "mackerel"
	icon_state = "mackerel"
	faretype = FARE_NEUTRAL

/obj/item/reagent_containers/food/snacks/rogue/fryfish/beaksnapper
	name = "beaksnapper"
	icon_state = "beaksnapper"
	faretype = FARE_NEUTRAL
