//Not to be confused with /obj/item/reagent_containers/food/drinks/bottle
GLOBAL_LIST_INIT(wisdoms, world.file2list("strings/rt/wisdoms.txt"))

/obj/item/reagent_containers/glass/bottle
	name = "bottle"
	desc = "A glass bottle."
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
	closed = TRUE
	reagent_flags = TRANSPARENT
	w_class = WEIGHT_CLASS_NORMAL
	drinksounds = list('sound/items/drink_bottle (1).ogg','sound/items/drink_bottle (2).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	experimental_onhip = TRUE
	debris = list(/obj/item/natural/glass_shard = 1)
	var/desc_uncorked = " It is open. Hopefully a cork is nearby."
	var/glass_on_impact = FALSE // If TRUE, bottle will generate glass shard on impact. Otherwise it won't.

/obj/item/reagent_containers/glass/bottle/update_icon(dont_fill=FALSE)
	if(!fill_icon_thresholds || dont_fill)
		return

	cut_overlays()
	underlays.Cut()

	if(reagents?.total_volume)
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
		add_overlay("[icon_state]_cork")

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
		do_close(user)
	else
		do_open(user)

/obj/item/reagent_containers/glass/bottle/proc/do_close(mob/user, no_msg = FALSE, no_snd = FALSE)
	if(user)
		if(!no_snd)
			playsound(user.loc,'sound/items/recork.ogg', 100, TRUE)
		if(!no_msg)
			to_chat(user, span_smallnotice("I carefully press the cork back into the mouth of [src]."))
	reagent_flags = TRANSPARENT
	reagents.flags = reagent_flags
	spillable = FALSE
	GLOB.weather_act_upon_list -= src
	desc = initial(desc)
	update_icon()

/obj/item/reagent_containers/glass/bottle/proc/do_open(mob/user, no_msg = FALSE, no_snd = FALSE)
	if(user)
		if(!no_snd)
			playsound(user.loc, 'sound/items/uncork.ogg', 100, TRUE)
		if(!no_msg)
			to_chat(user, span_smallnotice("I thumb off the cork from [src]."))
	reagent_flags = OPENCONTAINER
	reagents.flags = reagent_flags
	desc = initial(desc) + desc_uncorked
	spillable = TRUE
	GLOB.weather_act_upon_list |= src
	update_icon()

/obj/item/reagent_containers/glass/bottle/on_enter_storage(datum/component/storage/concrete/S, mob/M)
	. = ..()
	warn_opened(M, S)

/obj/item/reagent_containers/glass/bottle/proc/warn_opened(mob/user, datum/component/storage/concrete/storage)
	if(closed)
		return
	if(storage.does_not_spill)
		return
	if(!reagents.total_volume)
		return

	if(istype(user))
		if(!user.mob_timers["bottleopen_warn"] || (world.time > (user.mob_timers["bottleopen_warn"] + 0.3 SECONDS)))
			to_chat(user, span_warning("I store [src] uncorked."))
			user.mob_timers["bottleopen_warn"] = world.time
	return

/obj/item/reagent_containers/glass/bottle/rmb_self(mob/user, keybind = FALSE)
	. = ..()
	toggle_cork(user)

/obj/item/reagent_containers/glass/bottle/attack_self(mob/user)
	. = ..()
	toggle_cork(user)

/obj/item/reagent_containers/glass/bottle/attack_right(mob/user)
	. = ..()
	if(item_flags & IN_STORAGE)
		/*
		Currently the bottle underlay and the tetris.dm underlay (from Vanderlin inventory) do *not* play nice
		if you trigger bottle icon updates. They'll gladly interfere with each other's underlays if you update one or the other.

		This is just a half-assed bandage fix, and certainly not perfect. You can still transfer liquids in stored open bottles,
		which deletes the inventory's underlay for that item until you refresh the inventory view.
		*/
		to_chat(user, span_warning("I need to take [src] out first!"))
		return
	toggle_cork(user)

/obj/item/reagent_containers/glass/bottle/examine()
	. = ..()
	if(closed)
		. += span_notice("It is sealed with a cork.")
	else
		. += span_notice("It is open. Hopefully a cork is nearby.")

/obj/item/reagent_containers/glass/bottle/Initialize(mapload)
	. = ..()
	if(!icon_state)
		icon_state = "clear_bottle1"
	if(icon_state == "clear_bottle1")
		icon_state = "clear_bottle[rand(1,4)]"
	update_icon()

/obj/item/reagent_containers/glass/carafe
	name = "carafe"
	desc = "A bulbous container with a flared lip, most often used for serving water and wine amongst guests."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clear_carafe"
	w_class = WEIGHT_CLASS_SMALL
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10)
	volume = 100
	fill_icon_thresholds = list(0, 25, 50, 75, 100)
	obj_flags = CAN_BE_HIT
	spillable = TRUE
	reagent_flags = OPENCONTAINER
	w_class = WEIGHT_CLASS_NORMAL
	drinksounds = list('sound/items/drink_gen (2).ogg','sound/items/drink_gen (3).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	poursounds = list('sound/items/fillbottle.ogg')
	gripped_intents = list(INTENT_POUR)

/obj/item/reagent_containers/glass/carafe/update_icon(dont_fill=FALSE)
	if(!fill_icon_thresholds || dont_fill)
		return

	cut_overlays()
	underlays.Cut()

	if(reagents?.total_volume)
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

/obj/item/reagent_containers/glass/carafe/silver
	name = "silver carafe"
	desc = "A shining silver container with a flared lip, most often used for serving water and wine amongst nobility."
	icon_state = "silver_carafe"
	is_silver = TRUE
	is_lesser_silver = TRUE
	force = 10
	throwforce = 15
	fill_icon_thresholds = list(0, 50, 100)

/obj/item/reagent_containers/glass/carafe/gold
	name = "golden carafe"
	desc = "An opulent golden container with a flared lip, most often used for serving water and wine amongst royalty."
	icon_state = "gold_carafe"
	force = 10
	throwforce = 15
	fill_icon_thresholds = list(0, 50, 100)

/obj/item/reagent_containers/glass/carafe/porcelain
	name = "porcelain carafe"
	desc = "A humble porcelain carafe with a flared lip, most often used for serving water and wine amongst the commonfolk."
	icon_state = "claycarafebaked"
	throwforce = 20 // Ow!

/obj/item/reagent_containers/glass/carafe/glass
	name = "glass carafe"
	desc = "A bulbous container with a flared lip, most often used for serving water and wine amongst guests."

/obj/item/reagent_containers/glass/carafe/glass/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum, do_splash = TRUE)
	playsound(loc, 'sound/combat/hits/onglass/glassbreak (4).ogg', 100)
	shatter(get_turf(src))
	..()

/obj/item/reagent_containers/glass/carafe/glass/proc/shatter(turf/T)
	if(istransparentturf(T))
		shatter(GET_TURF_BELOW(T))
		return
	new /obj/item/natural/glass_shard(get_turf(T))
	new /obj/effect/decal/cleanable/debris/glassy(get_turf(T))
	qdel(src)


