/obj/item/seeds
	name = "seeds"
	icon = 'icons/obj/hydroponics/seeds.dmi'
	icon_state = "seed"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	possible_item_intents = list(/datum/intent/use)
	var/plant_def_type
	var/seed_identity = "some seed"

	var/cooking = 0
	var/cooktime = 20 SECONDS
	var/burning = 0
	var/burntime = 3 MINUTES

	var/burned_color = "#302d2d"
	var/cooked_smell = /datum/pollutant/food/roasted_seeds
	var/cooked_type = /obj/item/reagent_containers/food/snacks/roastseeds

/obj/item/seeds/Initialize()
	. = ..()
	if(plant_def_type)
		var/datum/plant_def/def = GLOB.plant_defs[plant_def_type]
		color = def.seed_color

/obj/item/seeds/examine(mob/user)
	. = ..()
	var/show_real_identity = FALSE
	if(isliving(user))
		var/mob/living/living = user
		// Seed knowers, know the seeds (druids and such)
		if(HAS_TRAIT(living, TRAIT_SEEDKNOW))
			show_real_identity = TRUE
		// Journeyman farmers know them too
		else if(living.get_skill_level(/datum/skill/labor/farming) >= 2)
			show_real_identity = TRUE
	else
		show_real_identity = TRUE
	if(show_real_identity)
		. += span_info("I can tell these are [seed_identity]")

/obj/item/seeds/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = get_soil_on_turf(T)
	if(soil)
		try_plant_seed(user, soil)
		return
	else if(istype(T, /turf/open/floor/rogue/dirt))
		if(!(user.get_skill_level(/datum/skill/labor/farming) >= SKILL_LEVEL_JOURNEYMAN))
			to_chat(user, span_notice("I don't know enough to work without a tool."))
			return
		to_chat(user, span_notice("I begin making a mound for the seeds..."))
		if(do_after(user, get_farming_do_time(user, 10 SECONDS), target = src))
			apply_farming_fatigue(user, 30)
			soil = get_soil_on_turf(T)
			if(!soil)
				soil = new /obj/structure/soil(T)
		return
	. = ..()

/obj/item/seeds/proc/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.plant)
		to_chat(user, span_warning("There is already something planted in \the [soil]!"))
		return
	if(!plant_def_type)
		return
	to_chat(user, span_notice("I plant \the [src] in \the [soil]."))
	soil.insert_plant(GLOB.plant_defs[plant_def_type])
	qdel(src)

// Cook a seed, burninput is separate so that burning doesn't scale up with skills. Based on 'snacks.dm'
/obj/item/seeds/cooking(input as num, burninput, atom/A)
	if(!input)
		return
	if(cooktime)
		var/added_input = input
		if(cooking < cooktime)
			cooking = cooking + added_input
			if(cooking >= cooktime)
				return heating_act(A)
			return
	burning(burninput)

/obj/item/seeds/heating_act(atom/A)
	if(istype(A,/obj/machinery/light/rogue/oven))
		var/obj/item/result
		if(cooked_type)
			result = new cooked_type(A)
			if(cooked_smell)
				result.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)
		else
			result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
		initialize_cooked_seed(result, 1)
		return result
	if(istype(A,/obj/machinery/light/rogue/hearth) || istype(A,/obj/machinery/light/rogue/firebowl) || istype(A,/obj/machinery/light/rogue/campfire) || istype(A,/obj/machinery/light/rogue/hearth/mobilestove))
		var/obj/item/result
		if(cooked_type)
			result = new cooked_type(A)
			if(cooked_smell)
				result.AddComponent(/datum/component/temporary_pollution_emission, cooked_smell, 20, 5 MINUTES)
		else
			result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
		initialize_cooked_seed(result, 1)
		return result
	var/obj/item/result = new /obj/item/reagent_containers/food/snacks/badrecipe(A)
	initialize_cooked_seed(result, 1)
	return result

/obj/item/seeds/burning(input as num)
	if(!input)
		return
	if(burntime)
		burning = burning + input
		if(burning >= burntime)
			name = "burned [name]"
			color = burned_color
		if(burning > (burntime * 2))
			burn()

/obj/item/seeds/proc/initialize_cooked_seed(obj/item/seeds/S, cooking_efficiency = 1)
	if(reagents)
		reagents.trans_to(S, reagents.total_volume)

/obj/item/seeds/wheat
	seed_identity = "wheat seeds"
	plant_def_type = /datum/plant_def/wheat

/obj/item/seeds/wheat/oat
	seed_identity = "oat seeds"
	plant_def_type = /datum/plant_def/oat

/obj/item/seeds/rice
	seed_identity = "rice seeds"
	plant_def_type = /datum/plant_def/rice

/obj/item/seeds/apple
	seed_identity = "apple seeds"
	plant_def_type = /datum/plant_def/tree/apple

/obj/item/seeds/pear
	seed_identity = "pear seeds"
	plant_def_type = /datum/plant_def/tree/pear

/obj/item/seeds/lemon
	seed_identity = "lemon seeds"
	plant_def_type = /datum/plant_def/tree/lemon

/obj/item/seeds/lime
	seed_identity = "lime seeds"
	plant_def_type = /datum/plant_def/tree/lime

/obj/item/seeds/tangerine
	seed_identity = "tangerine seeds"
	plant_def_type = /datum/plant_def/tree/tangerine

/obj/item/seeds/plum
	seed_identity = "plum seeds"
	plant_def_type = /datum/plant_def/tree/plum

/obj/item/seeds/strawberry
	seed_identity = "strawberry seeds"
	plant_def_type = /datum/plant_def/bush/strawberry

/obj/item/seeds/blackberry
	seed_identity = "blackberry seeds"
	plant_def_type = /datum/plant_def/bush/blackberry

/obj/item/seeds/raspberry
	seed_identity = "raspberry seeds"
	plant_def_type = /datum/plant_def/bush/raspberry

/obj/item/seeds/tomato
	seed_identity = "tomato seeds"
	plant_def_type = /datum/plant_def/bush/tomato

/obj/item/seeds/nut
	seed_identity = "rocknut seeds"
	plant_def_type = /datum/plant_def/nut

/obj/item/seeds/sugarcane
	seed_identity = "sugarcane seeds"
	plant_def_type = /datum/plant_def/sugarcane

/obj/item/seeds/pipeweed
	seed_identity = "westleach leaf seeds"
	plant_def_type = /datum/plant_def/pipeweed

/obj/item/seeds/swampweed
	seed_identity = "swampweed seeds"
	plant_def_type = /datum/plant_def/swampweed

/obj/item/seeds/berryrogue
	seed_identity = "berry seeds"
	plant_def_type = /datum/plant_def/bush/berry

/obj/item/seeds/berryrogue/poison
	seed_identity = "berry seeds"
	plant_def_type = /datum/plant_def/bush/berry_poison

/obj/item/seeds/turnip
	seed_identity = "turnip seeds"
	plant_def_type = /datum/plant_def/turnip

/obj/item/seeds/sunflower
	seed_identity = "sunflower seeds"
	plant_def_type = /datum/plant_def/sunflower
	cooked_type = /obj/item/reagent_containers/food/snacks/roastseeds/sunflower

/obj/item/seeds/onion
	seed_identity = "onion seeds"
	plant_def_type = /datum/plant_def/onion

/obj/item/seeds/cabbage
	seed_identity = "cabbage seeds"
	plant_def_type = /datum/plant_def/cabbage

/obj/item/seeds/potato
	seed_identity = "potato seeds"
	plant_def_type = /datum/plant_def/potato

/obj/item/seeds/fyritius
    seed_identity = "fyritius seeds"
    plant_def_type = /datum/plant_def/fyritiusflower

/obj/item/seeds/poppy
	seed_identity = "poppy seeds"
	plant_def_type = /datum/plant_def/poppy

/obj/item/seeds/garlick
	seed_identity = "garlick seeds"
	plant_def_type = /datum/plant_def/garlick

/obj/item/seeds/coffee
	seed_identity = "coffee seeds"
	plant_def_type = /datum/plant_def/coffee

/obj/item/seeds/tea
	seed_identity = "tea seeds"
	plant_def_type = /datum/plant_def/tea

/obj/item/seeds/pumpkin
	seed_identity = "pumpkin seeds"
	plant_def_type = /datum/plant_def/pumpkin
	cooked_type = /obj/item/reagent_containers/food/snacks/roastseeds/pumpkin