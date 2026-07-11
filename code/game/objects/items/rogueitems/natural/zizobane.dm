/obj/structure/zizo_bane
	name = "Zizo's bane"
	desc = "A small purple mushroom that has been growing in areas of rot."
	icon = 'icons/obj/flora/rogueflora.dmi'
	icon_state = "zizo_bane"
	density = FALSE
	anchored= TRUE
	var/time_delay = 0
	light_system = MOVABLE_LIGHT
	max_integrity = 30
	blade_dulling = DULLING_CUT
	resistance_flags = FLAMMABLE
	light_outer_range = 2
	light_inner_range = 1
	light_power = 1.5
	light_color = "#be3ebe"

/obj/structure/zizo_bane/Initialize(mapload)
	. = ..()
	var/matrix/M = matrix()
	M.Scale(0.6, 0.6)
	transform = M

/obj/structure/zizo_bane/Crossed(atom/movable/arrived)
	if(time_delay < world.time)
		if(isliving(arrived))
			var/mob/living/L = arrived
			if(L.is_flying())
				return
			if(L.m_intent == MOVE_INTENT_SNEAK)
				return
			if(!L.badluck()) // only the unlucky (FOR < 10) misstep hard enough to set it off
				return
			var/oldx = pixel_x
			animate(src, pixel_x = oldx + 1, time = 0.5)
			animate(src, pixel_x = oldx - 1, time = 0.5)
			animate(src, pixel_x = oldx, time = 0.5)
			make_gas()
			time_delay = world.time + 20 SECONDS

/obj/structure/zizo_bane/obj_destruction(damage_flag)
	make_gas() // burst its spores when smashed apart
	return ..()

/obj/structure/zizo_bane/proc/make_gas()
	visible_message(span_warningbig("A cloud of spores burst up from \the [src]!"))
	var/datum/effect_system/smoke_spread/zizosleep/S = new
	playsound(get_turf(src), "sound/items/mushroom_step.ogg", 100)
	S.set_up(2, loc)
	S.start()

/obj/structure/zizo_bane/attack_hand(mob/living/carbon/human/user)
	playsound(src.loc, "plantcross", 80, FALSE, -1)
	user.visible_message(span_warning("[user] starts plucking out \the [src] from the earth."))
	if(do_after(user, 3 SECONDS, target = src))
		var/obj/item/reagent_containers/food/snacks/zizo_bane/z =  new /obj/item/reagent_containers/food/snacks/zizo_bane/ (get_turf(src))
		user.put_in_active_hand(z)
		qdel(src)
	
/obj/item/reagent_containers/food/snacks/zizo_bane
	name = "Zizo's bane"
	desc = "A small purple mushroom that has been growing in areas of rot."
	icon = 'icons/obj/flora/rogueflora.dmi'
	icon_state = "zizo_bane"
	filling_color = "#772681"
	bitesize = 1
	foodtype = VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/sleep_powder = 5)
	tastes = list("numbing mintiness" = 1,"purpliness" = 1)
	eat_effect = /datum/status_effect/debuff/knockout
	mill_result = /obj/item/alch/sleep_powder
	grind_results = list(/datum/reagent/consumable/nutriment = 5)
	rotprocess = 30 MINUTES
