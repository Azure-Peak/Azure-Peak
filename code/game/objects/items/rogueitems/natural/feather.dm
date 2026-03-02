
/obj/item/natural/feather
	name = "feather"
	icon_state = "feather"
	possible_item_intents = list(/datum/intent/use)
	desc = "A fluffy feather."
	force = 0
	throwforce = 0
	obj_flags = null
	firefuel = null
	resistance_flags = FLAMMABLE
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HEAD|ITEM_SLOT_HIP
	body_parts_covered = null
	experimental_onhip = TRUE
	max_integrity = 20
	muteinmouth = TRUE
	spitoutmouth = FALSE
	w_class = WEIGHT_CLASS_TINY

/obj/item/natural/feather/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click a scroll, manuscript, book, or piece of parchment to write on it. A minimal amount of the Literacy skill is required to read.")
	. += span_info("Left-click an item - such as a weapon, chestplate, or anything else - to give it a custom name and description.")
	. += span_info("Custom names'll still show the original item's name in smaller parentheses, while custom descriptions'll completely overwrite the original item's description.")
	. += span_info("Certain helmets can be given a plume by left-clicking them with a feather, or by accessing the helmet's cosmetic inventory via shift-clicking and placing the feather inside.")

//reproduces some code from pens so that we can utilize feathers for renaming objects

/obj/item/natural/feather/afterattack(obj/O, mob/living/user, proximity)
	. = ..()
	if(isobj(O) && proximity && (O.obj_flags & UNIQUE_RENAME))
		var/penchoice = input(user, "What would you like to edit?", "Rename or change description?") as null|anything in list("Rename","Change description")
		if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
			return
		if(penchoice == "Rename")
			var/input = stripped_input(user,"What do you want to name \the [O.name]?", ,"", MAX_NAME_LEN)
			var/oldname = O.name
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			if(!input)
				return
			if(oldname == input)
				to_chat(user, span_notice("I changed \the [O.name] to... well... \the [O.name]."))
			else
				O.name = "[input] ([initial(O.name)])"
				to_chat(user, span_notice("\The [oldname] has been successfully been renamed to \the [input]."))
				O.renamedByPlayer = TRUE

		if(penchoice == "Change description")
			var/input = stripped_input(user,"Describe \the [O.name] here", ,"", 250)
			if(QDELETED(O) || !user.canUseTopic(O, BE_CLOSE))
				return
			O.desc = input
			to_chat(user, span_notice("I have successfully changed \the [O.name]'s description."))
