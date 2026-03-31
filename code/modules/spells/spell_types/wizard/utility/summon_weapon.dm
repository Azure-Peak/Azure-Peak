/obj/effect/proc_holder/spell/targeted/summonweapon
	name = "Summon Weapon"
	desc = "Summon an imbued weapon."
	clothes_req = FALSE
	range = -1
	include_user = TRUE
	recharge_time = 1 MINUTES
	chargedloop = /datum/looping_sound/invokegen
	action_icon_state = "summons"
	invocations = list("Evoca Telum")
	invocation_type = "whisper"
	spell_tier = 2 
	cost = 1 // 1 Cost, I don't think this is amazing enough utility. Maybe.
	var/obj/marked_item

/obj/effect/proc_holder/spell/targeted/summonweapon/cast(list/targets,mob/user = usr)
	for(var/mob/living/L in targets)
		var/list/hand_items = list(L.get_active_held_item(),L.get_inactive_held_item())
		var/message
		if(!marked_item) //linking item to the spell
			message = "<span class='notice'>"
			for(var/obj/item/rogueweapon/item in hand_items)
				if(item.item_flags & ABSTRACT)
					continue
				if(SEND_SIGNAL(item, COMSIG_ITEM_MARK_RETRIEVAL) & COMPONENT_BLOCK_MARK_RETRIEVAL)
					continue
				if(HAS_TRAIT(item, TRAIT_NODROP))
					message += "Though it feels redundant, "
				marked_item = 		item
				message += "You imbue [item] for summoning.</span>"
				name = "Summon [item]"
				break

			if(!marked_item)
				if(hand_items)
					message = span_warning("I aren't holding anything that can be imbued to summon!")
				else
					message = span_warning("I must hold the desired weapon in my hands to imbue it for summoning!")

		else if(marked_item && (marked_item in hand_items)) //unlinking item to the spell
			message = span_notice("I remove the imbuement on [marked_item] to use elsewhere.")
			name = "Instant Summons"
			marked_item = 		null

		else if(marked_item && QDELETED(marked_item)) //the item was destroyed at some point
			message = span_warning("I sense my imbued weapon has been destroyed!")
			name = "summon weapon"
			marked_item = 		null

		else	//Getting previously marked item
			var/obj/item/rogueweapon/item_to_retrieve = marked_item

			var/infinite_recursion = 0 //I don't want to know how someone could put something inside itself but these are wizards so let's be safe
			while(!isturf(item_to_retrieve.loc) && infinite_recursion < 10) //if it's in something you get the whole thing.
				if(isitem(item_to_retrieve.loc))
					var/obj/item/I = item_to_retrieve.loc
					if(I.item_flags & ABSTRACT) //Being able to summon abstract things because your item happened to get placed there is a no-no
						break
				if(ismob(item_to_retrieve.loc)) //If its on someone, properly drop it
					var/mob/M = item_to_retrieve.loc
					M.dropItemToGround(item_to_retrieve)
					if(iscarbon(M)) //Edge case housekeeping
						var/mob/living/carbon/C = M
						for(var/X in C.bodyparts)
							var/obj/item/bodypart/part = X
							if(item_to_retrieve in part.embedded_objects)
								part.remove_embedded_object(item_to_retrieve)
								to_chat(C, span_warning("The [item_to_retrieve] that was embedded in your [part.name] has mysteriously vanished. How fortunate!"))
								break
					if(!isturf(item_to_retrieve.loc))
						item_to_retrieve = item_to_retrieve.loc

				infinite_recursion += 1

			if(!item_to_retrieve)
				return

			if(item_to_retrieve.loc)
				item_to_retrieve.loc.visible_message(span_warning("The [item_to_retrieve.name] suddenly disappears!"))
			if(!L.put_in_hands(item_to_retrieve))
				item_to_retrieve.forceMove(L.drop_location())
				item_to_retrieve.loc.visible_message(span_warning("The [item_to_retrieve.name] suddenly appears!"))
				playsound(get_turf(L), 'sound/blank.ogg', 50, TRUE)
			else
				item_to_retrieve.loc.visible_message(span_warning("The [item_to_retrieve.name] suddenly appears in [L]'s hand!"))
				playsound(get_turf(L), 'sound/blank.ogg', 50, TRUE)


		if(message)
			to_chat(L, message)
