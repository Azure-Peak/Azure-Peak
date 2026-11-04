/obj/item/pestle
	name = "pestle"
	desc = "A small, round-end stone tool oft used by physicians to crush and mix medicine."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "pestle"
	force = 7
	dropshrink = 0.9
	experimental_inhand = TRUE
	w_class = WEIGHT_CLASS_SMALL

	grid_width = 32
	grid_height = 32

/obj/item/reagent_containers/glass/mortar
	name = "alchemical mortar"
	desc = "A small, thick-walled stone bowl made for grinding things up inside."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "mortar"
	dropshrink = 0.75
	amount_per_transfer_from_this = 10
	volume = 100
	experimental_inhand = TRUE
	reagent_flags = OPENCONTAINER|REFILLABLE|DRAINABLE
	spillable = TRUE
	var/list/obj/item/to_grind = list()

	grid_width = 32
	grid_height = 32

/obj/item/reagent_containers/glass/mortar/examine()
	. += ..()
	if(length(to_grind))
		. += ("[english_list(to_grind)] [length(to_grind) == 1 ? "is" : "are"] inside the mortar ([length(to_grind)]/[MORTAR_MAX_ITEMS]).")
	. += span_notice("Left click with a pestle to grind the items inside into alchemical ingredients. Middle Click with a pestle to grind or juice them. Right click to remove one. Click it with a container that cannot hold reagents to dump its grindable or juiceable contents in.")

/obj/item/reagent_containers/glass/mortar/Exited(atom/movable/gone, direction)
	. = ..()
	to_grind -= gone

/obj/item/reagent_containers/glass/mortar/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(length(to_grind))
		var/obj/item/removed = to_grind[length(to_grind)]
		to_chat(user, "<span class='notice'>I remove [removed] from the mortar.</span>")
		if(!user.put_in_hands(removed))
			to_chat(user, span_warning("My hands are full! I drop [removed] on the ground"))
			removed.forceMove(get_turf(src))
		return
	to_chat(user, "<span class='notice'>It's empty.</span>")

/obj/item/reagent_containers/glass/mortar/MiddleClick(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	var/pestle = H.get_active_held_item()
	if(!istype(pestle, /obj/item/pestle))
		to_chat(user, "<span class='warning'>You need a pestle to grind!</span>")
		return
	if(!length(to_grind))
		to_chat(user, "<span class='warning'>There's nothing to grind.</span>")
		return
	var/list/juiced = list()
	var/list/ground = list()
	var/too_full = FALSE
	for(var/obj/item/item as anything in to_grind.Copy())
		var/list/results = item.juice_results || item.grind_results //prioritize juicing
		if(!length(results))
			continue
		if(reagents.total_volume + counterlist_sum(results) > reagents.maximum_volume)
			too_full = TRUE
			continue
		if(item.juice_results)
			item.on_juice()
			juiced += item.name
		else
			item.on_grind()
			ground += item.name
		reagents.add_reagent_list(results)
		qdel(item)
	if(length(juiced))
		to_chat(user, span_notice("I juice [english_list(juiced)] into a fine liquid."))
	if(length(ground))
		to_chat(user, span_notice("I break [english_list(ground)] into powder."))
	if(too_full)
		to_chat(user, span_warning("[src] is too full!"))
	else if(!length(juiced) && !length(ground))
		to_chat(user, "<span class='warning'>You don't think that will work!</span>")

/obj/item/reagent_containers/glass/mortar/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I,/obj/item/pestle))
		if(!length(to_grind))
			to_chat(user, "<span class='warning'>There's nothing to grind.</span>")
			return
		var/found_recipe = FALSE
		for(var/obj/item/item as anything in to_grind.Copy())
			var/datum/alch_grind_recipe/foundrecipe = find_recipe(item)
			if(!foundrecipe)
				continue
			found_recipe = TRUE
			user.visible_message("<span class='info'>[user] begins grinding up [item].</span>")
			playsound(loc, 'sound/foley/mortarpestle.ogg', 100, FALSE)
			if(!do_after(user, 10, target = src))
				return
			if(QDELETED(item) || item.loc != src)
				continue
			for(var/output in foundrecipe.valid_outputs)
				for(var/i in 1 to foundrecipe.valid_outputs[output])
					new output(get_turf(src))
			if(foundrecipe.bonus_chance_outputs.len > 0)
				for(var/i in 1 to foundrecipe.bonus_chance_outputs.len)
					if(foundrecipe.bonus_chance_outputs[foundrecipe.bonus_chance_outputs[i]] >= roll(1,100))
						var/obj/item/bonusduck = foundrecipe.bonus_chance_outputs[i]
						new bonusduck(get_turf(user))
			if(istype(item,/obj/item/rogueore) || istype(item,/obj/item/ingot))
				user.flash_fullscreen("whiteflash")
				var/datum/effect_system/spark_spread/S = new()
				var/turf/front = get_turf(src)
				S.set_up(1, 1, front)
				S.start()
			qdel(item)
			if(user.mind)
				add_sleep_experience(user, /datum/skill/craft/alchemy, user.STAINT)
		if(!found_recipe)
			to_chat(user, "<span class='warning'>You don't think that will work!</span>")
		return
	if(istype(I ,/obj/item/reagent_containers/glass))
		if(user.used_intent.type == INTENT_POUR) //Something like a glass. Player probably wants to transfer TO it.

			if(!I.reagents.total_volume)
				to_chat(user, span_warning("[I] is empty!"))
				return

			if(reagents.holder_full())
				to_chat(user, span_warning("[src] is full."))
				return
			user.visible_message(span_notice("[user] pours [I] into [src]."), \
							span_notice("I pour [I] into [src]."))
			if(user.m_intent != MOVE_INTENT_SNEAK)
				if(poursounds)
					playsound(user.loc,pick(poursounds), 100, TRUE)
			for(var/i in 1 to 10)
				if(do_after(user, 8, target = src))
					if(!I.reagents.total_volume)
						break
					if(reagents.holder_full())
						break
					if(!I.reagents.trans_to(src, amount_per_transfer_from_this, transfered_by = user))
						reagents.reaction(src, TOUCH, amount_per_transfer_from_this)
					onfill(I, user, silent = TRUE)
				else
					break
			return

		if(is_drainable() && (user.used_intent.type == /datum/intent/fill)) //A dispenser. Transfer FROM it TO us.

			if(!reagents.total_volume)
				to_chat(user, span_warning("[src] is empty!"))
				return

			if(I.reagents.holder_full())
				to_chat(user, span_warning("[I] is full."))
				return
			if(user.m_intent != MOVE_INTENT_SNEAK)
				if(fillsounds)
					playsound(user.loc,pick(fillsounds), 100, TRUE)
			user.visible_message(span_notice("[user] fills [I] with [src]."), \
								span_notice("I fill [I] with [src]."))
			for(var/i in 1 to 10)
				if(do_after(user, 8, target = src))
					if(I.reagents.holder_full())
						break
					if(!reagents.total_volume)
						break
					reagents.trans_to(I, amount_per_transfer_from_this, transfered_by = user)
				else
					break

			return
	var/datum/component/storage/dumped_storage = I.GetComponent(/datum/component/storage)
	if(dumped_storage && !istype(I, /obj/item/reagent_containers))
		storage_contents_dump_act(dumped_storage, user)
		return
	if(length(to_grind) >= MORTAR_MAX_ITEMS)
		to_chat(user, "<span class='warning'>[src] is full!</span>")
		return
	if(!can_grind(I))
		to_chat(user, "<span class='warning'>[I] can't be ground!!</span>")
		return
	if(!user.transferItemToLoc(I,src))
		to_chat(user, "<span class='warning'>[I] is stuck to my hand!</span>")
		return
	to_grind += I
	to_chat(user, "<span class='info'>I add [I] to [src].</span>")

/obj/item/reagent_containers/glass/mortar/get_dumping_location(datum/component/storage/source, mob/user)
	return src

/obj/item/reagent_containers/glass/mortar/storage_contents_dump_act(datum/component/storage/src_object, mob/user)
	if(src_object.parent == src)
		return FALSE
	var/added = 0
	for(var/obj/item/item in src_object.contents())
		if(length(to_grind) >= MORTAR_MAX_ITEMS)
			break
		if(!can_grind(item))
			continue
		if(!src_object.remove_from_storage(item, src))
			continue
		to_grind += item
		added++
	if(!added)
		if(length(to_grind) >= MORTAR_MAX_ITEMS)
			to_chat(user, "<span class='warning'>[src] is full!</span>")
		else
			to_chat(user, "<span class='warning'>Nothing in [src_object.parent] can be ground.</span>")
		return FALSE
	to_chat(user, "<span class='info'>I dump [added] item\s from [src_object.parent] into [src].</span>")
	return TRUE

/obj/item/reagent_containers/glass/mortar/proc/can_grind(obj/item/I)
	return find_recipe(I) || I.grind_results || I.juice_results

///Looks through all the alch grind recipes to find what it should create, returns the correct one.
/obj/item/reagent_containers/glass/mortar/proc/find_recipe(obj/item/check_item)
	for(var/datum/alch_grind_recipe/grindRec in GLOB.alch_grind_recipes)
		if(grindRec.picky)
			if(check_item.type == grindRec.valid_input)
				return grindRec
		else
			if(istype(check_item,grindRec.valid_input))
				return grindRec
	return null
