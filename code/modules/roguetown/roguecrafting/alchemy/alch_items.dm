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
	sellprice = 1

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
