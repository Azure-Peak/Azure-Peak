/obj/item/pestle
	name = "pestle"
	desc = "A small, round-end stone tool oft used by physicians to crush and mix medicine."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "pestle"
	force = 7
	dropshrink = 0.9
	experimental_inhand = FALSE

	grid_width = 32
	grid_height = 64

/obj/item/reagent_containers/glass/mortar
	name = "alchemical mortar"
	desc = "A small, thick-walled stone bowl made for grinding things up inside."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "mortar"
	dropshrink = 0.75
	amount_per_transfer_from_this = 10
	volume = 100
	experimental_inhand = FALSE
	reagent_flags = OPENCONTAINER|REFILLABLE|DRAINABLE
	spillable = TRUE
	var/obj/item/to_grind

	grid_width = 64
	grid_height = 32

/obj/item/reagent_containers/glass/mortar/examine()
	. += ..()
	if(to_grind)
		. += ("[to_grind] is inside the mortar.")
	. += span_notice("Left click with a pestle to grind the item inside into alchemical ingredients. Middle Click with a pestle to grind or juice them. Right click to remove it.")

/obj/item/reagent_containers/glass/mortar/attack_right(mob/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(to_grind)
		to_chat(user, "<span class='notice'>I remove [to_grind] from the mortar.</span>")
		if(!user.put_in_hands(to_grind))
			to_chat(user, span_warning("My hands are full! I drop [to_grind] on the ground"))
		to_grind = null
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
	if(!to_grind)
		to_chat(user, "<span class='warning'>There's nothing to grind.</span>")
		return
	if((!to_grind.juice_results && !to_grind?.grind_results?.len)) // A lot of reagents are grindable but empty
		to_chat(user, "<span class='warning'>You don't think that will work!</span>")
		return
	if(to_grind.juice_results) //prioritize juicing
		to_grind.on_juice()
		reagents.add_reagent_list(to_grind.juice_results)
		to_chat(user, span_notice("I juice [to_grind] into a fine liquid."))
		if(to_grind.reagents) //food and pills
			to_grind.reagents.trans_to(src, to_grind.reagents.total_volume, transfered_by = user)
			onfill(to_grind, user, silent = FALSE)
		QDEL_NULL(to_grind)
		return
	if(to_grind.grind_results.len) // grind, if there's a grind result
		to_grind.on_grind()
		reagents.add_reagent_list(to_grind.grind_results)
		to_chat(user, span_notice("I break [to_grind] into powder."))
		QDEL_NULL(to_grind)
		return

/obj/item/reagent_containers/glass/mortar/attackby(obj/item/I, mob/living/carbon/human/user)
	if(istype(I,/obj/item/pestle))
		if(!to_grind)
			to_chat(user, "<span class='warning'>There's nothing to grind.</span>")
			return
		var/datum/alch_grind_recipe/foundrecipe = find_recipe()
		if(foundrecipe == null)
			to_chat(user, "<span class='warning'>You don't think that will work!</span>")
			return
		user.visible_message("<span class='info'>[user] begins grinding up [to_grind].</span>")
		playsound(loc, 'sound/foley/mortarpestle.ogg', 100, FALSE)
		if(do_after(user, 10, target = src))
			for(var/output in foundrecipe.valid_outputs)
				for(var/i in 1 to foundrecipe.valid_outputs[output])
					new output(get_turf(src))
			if(foundrecipe.bonus_chance_outputs.len > 0)
				for(var/i in 1 to foundrecipe.bonus_chance_outputs.len)
					if(foundrecipe.bonus_chance_outputs[foundrecipe.bonus_chance_outputs[i]] >= roll(1,100))
						var/obj/item/bonusduck = foundrecipe.bonus_chance_outputs[i]
						new bonusduck(get_turf(user))
			if(istype(to_grind,/obj/item/rogueore) || istype(to_grind,/obj/item/ingot))
				user.flash_fullscreen("whiteflash")
				var/datum/effect_system/spark_spread/S = new()
				var/turf/front = get_turf(src)
				S.set_up(1, 1, front)
				S.start()
			QDEL_NULL(to_grind)
			if(user.mind)
				user.adjust_experience(/datum/skill/craft/alchemy, user.STAINT, FALSE)
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
	if(to_grind)
		to_chat(user, "<span class='warning'>[src] is full!</span>")
		return
	var/recipe = find_recipe(I)
	if(recipe == null && I.grind_results == null && I.juice_results == null)
		to_chat(user, "<span class='warning'>[I] can't be ground!!</span>")
		return
	if(!user.transferItemToLoc(I,src))
		to_chat(user, "<span class='warning'>[I] is stuck to my hand!</span>")
		return
	if(!istype(I,/obj/item/pestle) && !to_grind && user.transferItemToLoc(I,src))
		to_chat(user, "<span class='info'>I add [I] to [src].</span>")
		to_grind = I
		return
	..()

///Looks through all the alch grind recipes to find what it should create, returns the correct one.
/obj/item/reagent_containers/glass/mortar/proc/find_recipe(obj/item/check_item = to_grind)
	for(var/datum/alch_grind_recipe/grindRec in GLOB.alch_grind_recipes)
		if(grindRec.picky)
			if(check_item.type == grindRec.valid_input)
				return grindRec
		else
			if(istype(check_item,grindRec.valid_input))
				return grindRec
	return null
