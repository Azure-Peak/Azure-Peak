/datum/brewing_recipe/fyritiusnectar
	name = "Fyritius Gruit"
	category = "Other"
	bottle_name = "fyritius nectar"
	bottle_desc = "A bottle of fyritius nectar, warm to the touch and smells like a smoker."
	reagent_to_brew = /datum/reagent/toxin/fyritiusnectar
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 6)
	brewed_amount = 3 // 150u. More than if you juiced the flowers with a pestle, but actually requires skill.
	brew_time = 1 MINUTES
	sell_value = 60

/datum/brewing_recipe/fyrmenty
	name = "Fyrmenty"
	category = "Grain"
	bottle_name = "fyrmenty"
	bottle_desc = "A bottle of an exotic herbal grain alcohol. It seems to retain the heat of the fyritius, but lacks the literal burn. Very, very flammable."
	reagent_to_brew = /datum/reagent/consumable/ethanol/fyrmenty
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/fyrmenty
	pre_reqs = /datum/reagent/toxin/fyritiusnectar
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2,
						/obj/item/reagent_containers/food/snacks/grown/oat = 4)
	brewed_amount = 3 // Solely bc it can be made into bottle bombs. Roughly similar in price as making them with alchemy.
	brew_time = 2 MINUTES
	sell_value = 90
	heat_required = 380

/obj/item/reagent_containers/glass/bottle/brewing_bottle/attackby(obj/item/I, mob/living/user, params) // For making bottle bombs as a chef main.
	..()
	update_cooktime(user)
	if(istype(I, /obj/item/natural/cloth))
		if(!reagents.has_reagent(/datum/reagent/consumable/ethanol/fyrmenty, 50))
			to_chat(user, span_warning("Not enough to wick the cloth with."))
			return
		to_chat(user, span_warning("Stuffing cloth down the bottle..."))
		playsound(src, pick('sound/foley/waterwash (1).ogg','sound/foley/waterwash (2).ogg'), 100, FALSE)
		if(do_after(user,3 SECONDS, target = src))
			new /obj/item/bomb(user.loc)
			qdel(src)
			qdel(I)
