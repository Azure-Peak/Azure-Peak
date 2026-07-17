/datum/abyssal_ritual/cultivate_dream_seed
	name = "Cultivate Dream Seed"
	desc = "Condenses raw abyssal fluctuations into a physical seed capable of growing anchor pylons."
	base_channel_time = 50
	
	required_ingredients = list(
		/obj/item/dream_material/dream_spike = 3
	)

/datum/abyssal_ritual/cultivate_dream_seed/on_success(obj/structure/roguemachine/dream_pool/P, mob/living/leader, list/mob/living/channelers)
	P.visible_message(span_purple("The surrounding dreamspikes dissolve into liquid light, rushing into the center vortex before solidifying into a glowing seed!"))
	new /obj/item/dream_material/dream_seed/(get_turf(leader))
	playsound(P, 'sound/magic/whale.ogg', 100, TRUE)
	return TRUE
