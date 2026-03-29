

/obj/item/recipe_book
	icon = 'icons/roguetown/items/books.dmi'

	grid_width = 32
	grid_height = 32
	firefuel = 5 MINUTES
	var/list/types = list()
	var/mob/current_reader
	var/open
	var/base_icon_state
	var/can_spawn = TRUE
	/// If TRUE, this book appears in the encyclopedia but not on random bookshelves.
	var/wiki_only = FALSE
	var/wiki_name
	/// Which section this book appears in on the OOC Guidebook. "Crafting Recipes" or "Guides".
	var/wiki_section = "Crafting Recipes"
	resistance_flags = FLAMMABLE

/obj/item/recipe_book/dropped(mob/user, silent)
	. = ..()
	if(current_reader)
		SStgui.close_user_uis(current_reader, GLOB.recipe_wiki)
		current_reader = null

/// Called when this book is opened from the encyclopedia. Return TRUE to override default recipe list behavior.
/obj/item/recipe_book/proc/open_wiki_entry(mob/user)
	return FALSE

/obj/item/recipe_book/attack_self(mob/user)
	. = ..()
	current_reader = user
	var/datum/recipe_wiki/wiki = get_recipe_wiki()
	wiki.show_to_user(user, types, name, type)

/obj/item/recipe_book/getonmobprop(tag)
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
