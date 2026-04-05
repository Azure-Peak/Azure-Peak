/* Spellbook
Intended to be a reward or a goal for pure mage, allowing them to rebind their aspect spells.
*/

/obj/item/book/spellbook
	var/open = FALSE
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "spellbookbrown_0"
	slot_flags = ITEM_SLOT_HIP
	grid_width = 32
	grid_height = 32
	var/base_icon_state = "spellbookbrown"
	unique = TRUE
	firefuel = 2 MINUTES
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	force = 5
	associated_skill = /datum/skill/misc/reading
	possible_item_intents = list(/datum/intent/use)
	name = "\improper tome of the arcyne"
	desc = "A crackling, glowing book, filled with runes and symbols that hurt the mind to stare at. Can be used to rebind aspect spells."
	var/picked // if the book has had it's style picked or not
	var/born_of_rock = FALSE // was a magical stone used to make it instead of a gem

/obj/item/book/spellbook/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/book/spellbook/examine(mob/user)
	. = ..()
	. += span_notice("Reading it allows you to rebind your aspect spells.")

/obj/item/book/spellbook/attack_self(mob/user)
	if(!open)
		attack_right(user)
		return
	..()
	user.update_inv_hands()

/obj/item/book/spellbook/rmb_self(mob/user)
	attack_right(user)
	return

// Override
/obj/item/book/spellbook/read(mob/user)
	change_spells()
	return FALSE

/obj/item/book/spellbook/proc/change_spells(mob/user = usr)
	var/datum/mind/user_mind = user.mind
	if(!user_mind)
		return
	if(!LAZYLEN(user_mind.mage_aspect_config))
		to_chat(user, span_warning("I lack the arcyne training to make use of this."))
		return
	var/datum/aspect_picker/picker = new(user, FALSE, user_mind.mage_aspect_config)
	picker.ui_interact(user)

/obj/item/book/spellbook/attack_right(mob/user)
	if(!picked)
		var/list/designlist = list("green", "yellow", "brown", "steel", "gem", "skin", "mimic", "wyrdbark", "sunfire", "abyssal", "cinder", "vessel", "edgebound", "sovereign")
		var/the_time = world.time
		var/design = tgui_input_list(user, "Select a design.","Spellbook Design", designlist)
		if(!design)
			return
		if(world.time > (the_time + 30 SECONDS))
			return
		base_icon_state = "spellbook[design]"
		update_icon()
		picked = TRUE
		switch(design) //super lazy but idrc
			if ("green")
				return
			if ("yellow")
				return
			if ("brown") //preserve default name and desc for the basic options
				return
			if ("steel")
				desc = "A metallic tome adorned with alignments of runes and alchemical symbols. Can be used to unbind spells."
			if ("gem")
				desc = "The pages form a window to the breadth of the stars. Can be used to unbind spells."
			if ("skin")
				desc = "Profane symbols adorn this spellbook- is that blood dripping off the pages? Can be used to unbind spells."
			if ("mimic")
				desc = "This book seems to be reading you, instead. Can be used to unbind spells."
			if ("wyrdbark")
				desc = "Formed of heartwood and fae magics, leaves flutter about when it opens. Can be used to unbind spells."
			if ("sunfire")
				desc = "Astrata's radiance pours freely from this book's enchanted parchment. Can be used to unbind spells."
			if ("abyssal")
				desc = "Frigid and numb to the touch; you feel so much smaller just looking at it. Can be used to unbind spells."
			if ("cinder")
				desc = "Wafting smoke and smoldering crackles come from the papyrus, though it never catches alight. Can be used to unbind spells."
			if ("vessel")
				desc = "A stoppered bottle of ink that forms into a fully-fledged tome when uncorked. Can be used to unbind spells."
				name = "\improper arcyne vessel" //calling it 'vessel tome' is weird as fuck
				return
			if ("edgebound")
				desc = "Harsh, sturdy, and practical; can a war-mage ask for more? Can be used to unbind spells."
			if ("sovereign")
				desc = "Regal and opulent, you feel a stronge urge to call this tome some title of reverence. Can be used to unbind spells."
		name = "\improper [design] tome"
		return
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	curpage = 1
	update_icon()
	user.update_inv_hands()

/obj/item/book/spellbook/update_icon()
	icon_state = "[base_icon_state]_[open]"

/// Book slapcrafting

/obj/item/spellbook_unfinished
	var/pages_left = 4
	name = "bound scrollpaper"
	dropshrink = 0.6
	icon = 'icons/roguetown/items/books.dmi'
	icon_state ="basic_book_0"
	desc = "Thick scroll paper bound at the spine. It lacks pages."
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/spellbook_unfinished/pre_arcyne
	name = "tome in waiting"
	icon_state = "spellbook_unfinished"
	desc = "A fully bound tome of scroll paper. It's lacking a certain arcyne energy. Crush a gem or a magical stone over it to complete it."
	grid_width = 32
	grid_height = 32


/obj/item/spellbook_unfinished/pre_arcyne/attackby(obj/item/P, mob/living/carbon/human/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/roguegem))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				if(isarcyne(user))
					playsound(loc, 'sound/spellbooks/crystal.ogg', 100, TRUE)
					user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder seeps into the [src]."), \
						span_notice("I run my arcyne energy into the crystal. It shatters and seeps into the cover of the tome! Runes and symbols of an unknowable language cover its pages now..."))
					var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
					newbook.desc += " Traces of [P] dust linger in its margins."
					qdel(P)
					qdel(src)
				else
					if(prob(1))
						playsound(loc, 'sound/spellbooks/crystal.ogg', 100, TRUE)
						user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder seeps into the [src]."), \
							span_notice("By the Ten! That gem just exploded -- and my useless tome is filled with gleaming energy and strange letters!"))
						var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
						newbook.desc += " Traces of [P] dust linger in its margins."
						qdel(P)
						qdel(src)
					else
						playsound(loc, 'sound/spellbooks/icicle.ogg', 100, TRUE)
						user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder just kind of sits on top of the [src]. Awkward."), \
							span_notice("... why and how did I just crush this gem into a worthless scroll-book? What a WASTE of mammon!"))
						qdel(P)
					return ..()
		else
			to_chat(user, "<span class='warning'>You need to put [src] on a table to work on it.</span>")
	else if (istype(P, /obj/item/natural/stone))
		var/obj/item/natural/stone/the_rock = P
		if (the_rock.magic_power)
			if(isturf(loc) && (found_table))
				var/crafttime = ((130 - the_rock.magic_power) - ((user.get_skill_level(/datum/skill/magic/arcane))*5))
				if(do_after(user, crafttime, target = src))
					if (isarcyne(user))
						playsound(loc, 'sound/spellbooks/crystal.ogg', 100, TRUE)
						user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder seeps into the [src]."), \
							span_notice("I join my arcyne energy with that of the magical stone in my hands, which shudders briefly before dissolving into motes of ash. Runes and symbols of an unknowable language cover its pages now..."))
						to_chat(user, span_notice("...yet even for an enigma of the arcyne, these characters are unlike anything I've seen before. They're going to be -much- harder to understand..."))
						var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
						newbook.born_of_rock = TRUE
						newbook.desc += " Traces of multicolored stone limn its margins."
						qdel(P)
						qdel(src)
					else
						if (prob(the_rock.magic_power)) // for reference, this is never higher than 15 and usually significantly lower
							playsound(loc, 'sound/spellbooks/crystal.ogg', 100, TRUE)
							user.visible_message(span_warning("[user] carefully sets down [the_rock] upon [src]. Nothing happens for a moment or three, then suddenly, the glow surrounding the stone becomes as liquid, seeps down and soaks into the tome!"), \
							span_notice("I knew this stone was special! Its colourful magick has soaked into my tome and given me gift of mystery!"))
							to_chat(user, span_notice("...what in the world does any of this scribbling possibly mean?"))
							var/obj/item/book/spellbook/newbook = new /obj/item/book/spellbook(loc)
							newbook.born_of_rock = TRUE
							newbook.desc += " Traces of multicolored stone limn its margins."
							qdel(P)
							qdel(src)
						else
							user.visible_message(span_warning("[user] sets down [the_rock] upon the surface of [src] and watches expectantly. Without warning, the rock violently pops like a squashed gourd!"), \
							span_notice("No! My precious stone! It musn't have wanted to share its mysteries with me..."))
							user.electrocute_act(5, src)
							qdel(P)
		else
			to_chat(user, span_notice("This is a mere rock - it has no arcyne potential. Bah!"))
			return ..()
	else
		return ..()

