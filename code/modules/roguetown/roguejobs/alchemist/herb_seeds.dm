/obj/item/herbseed
	name = "herb seeds"
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "seeds"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FLAMMABLE
	possible_item_intents = list(/datum/intent/use)
	var/makes_herb = null
	var/seed_identity = "unknown"

/obj/item/herbseed/Initialize(mapload)
	name = "herb seeds"
	. = ..()

/obj/item/herbseed/examine(mob/user)
	. = ..()
	var/show_real_identity = FALSE
	if(isliving(user))
		var/mob/living/living = user
		if(HAS_TRAIT(living, TRAIT_SEEDKNOW) || HAS_TRAIT(living,TRAIT_LEGENDARY_ALCHEMIST))
			show_real_identity = TRUE
		// Alchemy seeds, so they would know them
		else if(living.get_skill_level(/datum/skill/craft/alchemy) >= 2 || living.get_skill_level(/datum/skill/labor/farming) >= 2)
			show_real_identity = TRUE
	else
		show_real_identity = TRUE
	if(show_real_identity)
		. += span_info("I can tell these are [seed_identity]")

/obj/item/herbseed/attack_turf(turf/T, mob/living/user)
	var/obj/structure/soil/soil = get_soil_on_turf(T)
	if(soil)
		try_plant_seed(user, soil)
		return
	else if(istype(T, /turf/open/floor/rogue/dirt))
		to_chat(user, span_notice("I begin making a mound for the seeds..."))
		if(do_after(user, get_herb_do_time(user, 5 SECONDS), target = src))
			apply_farming_fatigue(user, 30)
			soil = get_soil_on_turf(T)
			if(!soil)
				soil = new /obj/structure/soil(T)
		return
	. = ..()

/obj/item/herbseed/proc/try_plant_seed(mob/living/user, obj/structure/soil/soil)
	if(soil.plant)
		to_chat(user, span_warning("There is already something planted in \the [soil]!"))
		return
	to_chat(user, span_notice("I plant \the [src] in \the [soil]. I should check back later when \the [src] has grown."))
	addtimer(CALLBACK(src,TYPE_PROC_REF(/obj/item/herbseed,become_plant),soil,makes_herb),7.5 MINUTES)
	soil.desc += span_info(" Something appears to be planted here, but I cannot descern what.")
	src.forceMove(soil)
	return

/obj/item/herbseed/proc/become_plant(obj/structure/soil/soil,to_make)
	if(ispath(to_make))
		var/obj/structure/flora/roguegrass/herb/newplant = new to_make
		newplant.forceMove(get_turf(soil))
		newplant.pixel_x += rand(-3,3)
		soil.visible_message(span_info("[soil] suddenly bursts away to reveal \the [newplant]!"))
	else
		soil.visible_message(span_info("[soil] suddenly collapses, leaving nothing behind..."))
	qdel(soil)
	return

/obj/item/herbseed/atropa
	name = "atropa seeds"
	seed_identity = "atropa seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/atropa

/obj/item/herbseed/matricaria
	name = "matricaria seeds"
	seed_identity = "matricaria seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/matricaria

/obj/item/herbseed/symphitum
	name = "symphitum seeds"
	seed_identity = "symphitum seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/symphitum

/obj/item/herbseed/taraxacum
	name = "taraxacum seeds"
	seed_identity = "taraxacum seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/taraxacum

/obj/item/herbseed/euphrasia
	name = "euphrasia seeds"
	seed_identity = "euphrasia seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/euphrasia

/obj/item/herbseed/paris
	name = "paris seeds"
	seed_identity = "paris seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/paris

/obj/item/herbseed/calendula
	name = "calendula seeds"
	seed_identity = "calendula seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/calendula

/obj/item/herbseed/mentha
	name = "mentha seeds"
	seed_identity = "mentha seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/mentha

/obj/item/herbseed/urtica
	name = "urtica seeds"
	seed_identity = "urtica seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/urtica

/obj/item/herbseed/salvia
	name = "salvia seeds"
	seed_identity = "salvia seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/salvia

/obj/item/herbseed/hypericum
	name = "hypericum seeds"
	seed_identity = "hypericum seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/hypericum

/obj/item/herbseed/benedictus
	name = "benedictus seeds"
	seed_identity = "benedictus seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/benedictus

/obj/item/herbseed/valeriana
	name = "valeriana seeds"
	seed_identity = "valeriana seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/valeriana

/obj/item/herbseed/artemisia
	name = "artemisia seeds"
	seed_identity = "artemisia seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/artemisia

/obj/item/herbseed/rosa
	name = "rosa seeds"
	seed_identity = "rosa seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/rosa

/obj/item/herbseed/manabloom
	name = "manabloom seeds"
	seed_identity = "manabloom seeds"
	makes_herb = /obj/structure/flora/roguegrass/herb/manabloom
