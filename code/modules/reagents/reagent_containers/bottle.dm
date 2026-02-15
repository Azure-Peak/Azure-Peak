//Not to be confused with /obj/item/reagent_containers/food/drinks/bottle
GLOBAL_LIST_INIT(wisdoms, world.file2list("strings/rt/wisdoms.txt"))

/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A glass bottle with a cork."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clear_bottle1"
	amount_per_transfer_from_this = 10
	amount_per_gulp = 5
	possible_transfer_amounts = list(10)
	volume = 50
	fill_icon_thresholds = list(0, 25, 50, 75, 100)
	dropshrink = 0.8
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	obj_flags = CAN_BE_HIT|UNIQUE_RENAME
	spillable = FALSE
	var/closed = TRUE
	reagent_flags = TRANSPARENT
	w_class = WEIGHT_CLASS_NORMAL
	drinksounds = list('sound/items/drink_bottle (1).ogg','sound/items/drink_bottle (2).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	experimental_onhip = TRUE
	debris = list(/obj/item/natural/glass_shard = 1)
	var/desc_uncorked = "An open bottle. Hopefully the cork is nearby."
	var/fancy		// for bottles with custom descriptors that you don't want to change when bottle manipulated
	var/glass_on_impact = FALSE // If TRUE, bottle will generate glass shard on impact. Otherwise it won't.

/obj/item/reagent_containers/glass/bottle/update_icon(dont_fill=FALSE)
	if(!fill_icon_thresholds || dont_fill)
		return

	cut_overlays()
	underlays.Cut()

	if(reagents.total_volume)
		var/fill_name = fill_icon_state? fill_icon_state : icon_state
		var/mutable_appearance/filling = mutable_appearance('icons/obj/reagentfillings.dmi', "[fill_name][fill_icon_thresholds[1]]")

		var/percent = round((reagents.total_volume / volume) * 100)
		for(var/i in 1 to fill_icon_thresholds.len)
			var/threshold = fill_icon_thresholds[i]
			var/threshold_end = (i == fill_icon_thresholds.len)? INFINITY : fill_icon_thresholds[i+1]
			if(threshold <= percent && percent < threshold_end)
				filling.icon_state = "[fill_name][fill_icon_thresholds[i]]"
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		underlays += filling

	if(closed)
		add_overlay("[icon_state]cork")

/obj/item/reagent_containers/glass/bottle/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right click to manipulate its cork. Uncorked bottles can be drank from, but will spill their contents if stored away without being recorked.")
	. += span_info("Examining an uncorked bottle while targeting the nose allows you to smell whatever's inside.")
	. += span_info("Thrown bottles will always shatter on impact.")

/obj/item/reagent_containers/glass/bottle/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum, do_splash = TRUE)
	playsound(loc, 'sound/combat/hits/onglass/glassbreak (4).ogg', 100)
	shatter(get_turf(src))
	..()

/obj/item/reagent_containers/glass/bottle/proc/shatter(turf/T)
	if(istransparentturf(T))
		shatter(GET_TURF_BELOW(T))
		return 
	glass_on_impact && new /obj/item/natural/glass_shard(get_turf(T))
	new /obj/effect/decal/cleanable/debris/glassy(get_turf(T))
	qdel(src)

/obj/item/reagent_containers/glass/bottle/proc/toggle_cork(mob/user)
	closed = !closed
	user.changeNext_move(CLICK_CD_RAPID, override = TRUE)
	if(closed)
		reagent_flags = TRANSPARENT
		reagents.flags = reagent_flags
		to_chat(user, span_notice("You carefully press the cork back into the mouth of [src]."))
		spillable = FALSE
		GLOB.weather_act_upon_list -= src
		if(!fancy)
			desc = "A bottle with a cork."
	else
		reagent_flags = OPENCONTAINER
		reagents.flags = reagent_flags
		playsound(user.loc,'sound/items/uncork.ogg', 100, TRUE)
		to_chat(user, span_notice("You thumb off the cork from [src]."))
		desc = desc_uncorked
		spillable = TRUE
		GLOB.weather_act_upon_list |= src
		if(!fancy)
			desc = "An open bottle. Hopefully a cork is nearby."
	update_icon()

/obj/item/reagent_containers/glass/bottle/rmb_self(mob/user)
	. = ..()
	toggle_cork(user)

/obj/item/reagent_containers/glass/bottle/attack_self(mob/user)
	. = ..()
	toggle_cork(user)

/obj/item/reagent_containers/glass/bottle/Initialize()
	. = ..()
	if(!icon_state)
		icon_state = "clear_bottle1"
	if(icon_state == "clear_bottle1")
		icon_state = "clear_bottle[rand(1,4)]"
	update_icon()
