/obj/item/reagent_containers/glass/bottle/alchemical
	name = "alchemical vial"
	desc = "A cute bottle that can hold three swigs of liquid, which is useful for both miserly business practices and preventing accidental overdosing. This one lacks a cork."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "vial_bottle"
	amount_per_transfer_from_this = 10
	amount_per_gulp = 10
	possible_transfer_amounts = list(10)
	volume = 30
	fill_icon_thresholds = list(0, 33, 66, 100)
	w_class = WEIGHT_CLASS_TINY
	experimental_onhip = TRUE
	experimental_inhand = TRUE
	grid_height = 32 // Takes 1x1 area

// Shitty copy paste override until bottle code refactored
/obj/item/reagent_containers/glass/bottle/alchemical/update_icon(dont_fill=FALSE)
	if(QDELING(src) || QDELETED(src) || !reagents)
		return

	if(!fill_icon_thresholds || dont_fill)
		return

	cut_overlays()
	underlays.Cut()

	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon)

		var/percent = round((reagents.total_volume / volume) * 100)
		for(var/i in 1 to fill_icon_thresholds.len)
			var/threshold = fill_icon_thresholds[i]
			var/threshold_end = (i == fill_icon_thresholds.len) ? INFINITY : fill_icon_thresholds[i+1]
			if(threshold <= percent && percent < threshold_end)
				filling.icon_state = "vial_fluid_[fill_icon_thresholds[i]]"
				break

		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		underlays += filling

	if(closed)
		add_overlay("vial_cork")

/obj/item/alch/catalyzation_reagent
	name = "catalyzation reagent"
	icon_state = "runedust"
	desc = "An alchemical powder essential for the process of transmuting seed items into stable catalysts."
	gender = PLURAL

/obj/item/storage/roguebag/trans
	populate_contents = list( // sack of twelve. why do we do this like this sfklgdsjaf
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent,
		/obj/item/alch/catalyzation_reagent
	)

/obj/item/alchemical_bathbomb
	name = "alchemical diffuser"
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "irondust" // placeholder
	desc = "A strange ball of powder, tightly-packed to remain solid until exposed to water. When tossed into a bath or hot spring, infuses the water with its alchemical properties, soothing and healing any within."
	var/effect_desc = "herbal"	// change this to change what the bath tells people it is. "The water's herbal infusion..." by default, so you can change it to like... floral, or something more specific
	var/boost = 1 				// bonus to the strength of the bathing buff. bathing is so anti-gamer that this is probably unimpactful but it is flavor, so.
	var/duration = 15 MINUTES	// how long the infusion lasts. remember that a full bath takes 2 minutes, so don't set this much shorter!
	materia = list(/datum/materia_aspect/water, /datum/materia_aspect/herb)

/obj/item/alchemical_bathbomb/rosa
	effect_desc = "floral" // that's it that's the only change. well besides a new icon when one exists

/obj/item/alchemical_bathbomb/Initialize()
	. = ..()
	desc += "<br><br>This one has a [effect_desc] scent."

/obj/item/alchemical_bathbomb/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Throw or left click this on a hot spring or bath tile to apply its effects. It spreads to all connected tiles of the same type, and lasts for [floor(duration / (1 MINUTES))] minutes.")

/obj/item/alchemical_bathbomb/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	var/turf/turf = get_turf(hit_atom)
	if(istype(turf, /turf/open/water/bath))
		apply_to_turf(turf)
	var/obj/structure/hotspring/bath = locate(/obj/structure/hotspring) in turf
	if(bath)
		apply_to_struc(bath)

/obj/item/alchemical_bathbomb/attack_turf(turf/T, mob/living/user, multiplier)
	. = ..()
	if(istype(T, /turf/open/water/bath))
		apply_to_turf(T)

/obj/item/alchemical_bathbomb/attack_obj(obj/O, mob/living/user)
	. = ..()
	if(istype(O, /obj/structure/hotspring))
		apply_to_struc(O)

// when you slap a hot spring or bath, or toss the bomb onto one of those two, the bathbomb spreads to all connected tiles and applies its component
/obj/item/alchemical_bathbomb/proc/apply_to_struc(obj/structure/hotspring/target)
	var/list/tiles_to_check = list(get_turf(target))
	var/list/checked_tiles = list()
	var/turf/cur_tile
	var/obj/structure/hotspring/spring
	while(length(tiles_to_check))
		cur_tile = tiles_to_check[1]
		checked_tiles += cur_tile
		tiles_to_check -= cur_tile
		spring = locate(/obj/structure/hotspring) in cur_tile
		if(spring)
			spring.AddComponent(/datum/component/bath_infusion, effect_desc, duration, boost)
			for(var/direc in GLOB.cardinals)
				var/turf/test = get_step(cur_tile, direc)
				if(!checked_tiles.Find(test))
					tiles_to_check += test
	target.visible_message(span_blue("\The [src] bubbles and fizzes as it hits \the [target], dissolving completely. \A [effect_desc] scent wafts from the pool!"))
	qdel(src)

// this check is separate because it's slightly more performant and therefore we want to use it when possible
/obj/item/alchemical_bathbomb/proc/apply_to_turf(turf/open/water/bath/target)
	var/list/tiles_to_check = list(target)
	var/list/checked_tiles = list()
	var/turf/cur_tile
	while(length(tiles_to_check))
		cur_tile = tiles_to_check[1]
		checked_tiles += cur_tile
		tiles_to_check -= cur_tile
		if(istype(cur_tile, /turf/open/water/bath))
			cur_tile.AddComponent(/datum/component/bath_infusion, effect_desc, duration, boost)
			for(var/direc in GLOB.cardinals)
				var/turf/test = get_step(cur_tile, direc)
				if(!checked_tiles.Find(test))
					tiles_to_check += test
	target.visible_message(span_blue("\The [src] bubbles and fizzes as it hits \the [target], dissolving completely. \A [effect_desc] scent wafts from the pool!"))
	qdel(src)

/obj/item/soap/alch
	name = "soothing soap"
	desc = "An alchemical soap infused with Eora's sacred herbs. Has a slight restorative effect."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "soap"
	lefthand_file = 'icons/mob/inhands/equipment/custodial_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/equipment/custodial_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	item_flags = NOBLUDGEON
	uses = 10 // since it has a mechanical effect (albeit a mild one), it's limited in dura
	materia = list(/datum/materia_aspect/water, /datum/materia_aspect/herb)

/obj/item/soap/alch/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/slippery, 80)

/obj/item/soap/alch/afterattack(atom/target, mob/user, proximity)
	var/turf/bathspot = get_turf(target)
	if(ishuman(target) && (istype(bathspot, /turf/open/water/bath) || locate(/obj/structure/hotspring) in bathspot))
		return
	if(!proximity || !check_allowed_items(target, target_self=1))
		return
	if(istype(target, /obj/effect/decal/cleanable))
		user.visible_message(span_notice("[user] begins to scrub \the [target.name] out with [src]."), span_warning("I begin to scrub \the [target.name] out with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, span_notice("I scrub \the [target.name] out."))
			qdel(target)
			decreaseUses(user)

	else if(ishuman(target) && user.zone_selected == BODY_ZONE_PRECISE_MOUTH)
		var/mob/living/carbon/human/H = user
		user.visible_message(span_warning("\the [user] washes \the [target]'s mouth out with [src.name]!"), span_notice("I wash \the [target]'s mouth out with [src.name]!")) //washes mouth out with soap sounds better than 'the soap' here			if(user.zone_selected == "mouth")
		H.lip_style = null //removes lipstick
		H.update_body()
		decreaseUses(user)
		return
	else if(istype(target, /obj/structure/roguewindow))
		user.visible_message(span_notice("[user] begins to clean \the [target.name] with [src]..."), span_notice("I begin to clean \the [target.name] with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			to_chat(user, span_notice("I clean \the [target.name]."))
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			target.set_opacity(initial(target.opacity))
			decreaseUses(user)
	else
		user.visible_message(span_notice("[user] begins to clean \the [target.name] with [src]..."), span_notice("I begin to clean \the [target.name] with [src]..."))
		if(do_after(user, src.cleanspeed, target = target))
			if(ishuman(target))
				var/mob/living/carbon/human/H = target
				H.apply_status_effect(/datum/status_effect/buff/healing/soap)
			wash_atom(target,CLEAN_MEDIUM)
			to_chat(user, span_notice("I clean \the [target.name]."))
			for(var/obj/effect/decal/cleanable/C in target)
				qdel(C)
			target.remove_atom_colour(WASHABLE_COLOUR_PRIORITY)
			SEND_SIGNAL(target, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_MEDIUM)
			decreaseUses(user)
	return

#define TRAIT_SOURCE_EORAN_SOAP "alchsoap"

/obj/item/soap/alch/attack(mob/target, mob/user)
	var/turf/bathspot = get_turf(target)
	if(!istype(bathspot, /turf/open/water/bath) && !locate(/obj/structure/hotspring) in bathspot)
		return
	if(ishuman(target))
		visible_message(span_info("[user] begins washing [target] with the [src]."))
		if(do_after(user, 50))
			wash_atom(target,CLEAN_MEDIUM)
			var/mob/living/carbon/human/H = target
			H.apply_status_effect(/datum/status_effect/buff/healing/soap) 	// lasts 10 seconds, heals slowly. strictly worse than other options in most cases but it's flavorful
			if(HAS_TRAIT(user, TRAIT_GOODLOVER)) 					// for reference weak red is about equal to 1.75 healstrength. healing soap has 0.5. lesser miracle is 1
				visible_message(span_info("[user] expertly cleans and soothes [target] with the [src]."))
				to_chat(target, span_love("I feel so relaxed and clean!"))
				target.add_stress(/datum/stressevent/bathcleaned)
			else
				visible_message(span_info("[user] tries their best to scrub [target] with the [src]."))
				to_chat(target, span_warning("That's a bit nicer, I guess."))
				target.add_stress(/datum/stressevent/bath)
			to_chat(target, span_blue("I feel a sense of calm wash over me."))
			ADD_TRAIT(target, TRAIT_EORAN_CALM, TRAIT_SOURCE_EORAN_SOAP) // you get an hour of freakout protection, as a treat; note that this is not the "actually removes stress" trait it just stops you from screaming
			addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(___TraitRemove), target, TRAIT_EORAN_CALM, TRAIT_SOURCE_EORAN_SOAP), 1 HOURS)
			uses -= 1
			if(uses == 0)
				qdel(src)

#undef TRAIT_SOURCE_EORAN_SOAP
/obj/item/mutation_reagent
	name = "transformative reagent"
	desc = "A moderately-unstable catalyst for transformation. When applied to an herb bush, transforms it into something new - what exactly is unpredictable."
	materia = list(/datum/materia_aspect/change, /datum/materia_aspect/herb)
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "transisdust" // placeholder
	var/list/results = list( // adds up to  96% normal herbs, 4% fyritius
		/obj/structure/flora/roguegrass/herb/atropa = 6,
		/obj/structure/flora/roguegrass/herb/matricaria = 6,
		/obj/structure/flora/roguegrass/herb/symphitum = 6,
		/obj/structure/flora/roguegrass/herb/taraxacum = 6,
		/obj/structure/flora/roguegrass/herb/euphrasia = 6,
		/obj/structure/flora/roguegrass/herb/paris = 6,
		/obj/structure/flora/roguegrass/herb/calendula = 6,
		/obj/structure/flora/roguegrass/herb/mentha = 6,
		/obj/structure/flora/roguegrass/herb/urtica = 6,
		/obj/structure/flora/roguegrass/herb/salvia = 6,
		/obj/structure/flora/roguegrass/herb/hypericum = 6,
		/obj/structure/flora/roguegrass/herb/benedictus = 6,
		/obj/structure/flora/roguegrass/herb/valeriana = 6,
		/obj/structure/flora/roguegrass/herb/artemisia = 6,
		/obj/structure/flora/roguegrass/herb/rosa = 6,
		/obj/structure/flora/roguegrass/swampweed = 6,
		/obj/structure/flora/roguegrass/pyroclasticflowers = 4 // rare treat
	)

/obj/item/mutation_reagent/attack_obj(obj/O, mob/living/user)
	. = ..()
	var/obj/structure/flora/roguegrass/herb/bush = O
	if(!istype(bush))
		to_chat(user, span_warning("I don't think that will do anything beneficial."))
		return
	if(istype(bush, /obj/structure/flora/roguegrass/herb/manabloom)) // manabloom is mapping-only and too limited to allow people to delete
		to_chat(user, span_warning("The arcyne energies in [bush] would make this process too dangerous for even me."))
		return
	var/obj/structure/flora/roguegrass/result = pickweight(results)
	if(result)
		var/obj/instantiated = new result(O.loc)
		O.visible_message(span_notice("\The [O] wilts and writhes, transforming into \a [instantiated]!"))
		instantiated.add_fingerprint(user)
		qdel(O)
		qdel(src)
		return
