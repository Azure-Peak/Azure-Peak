//PUZZLE BOXES

//easy


/obj/item/mundane/puzzlebox/easy
	name = "\improper wooden puzzle-box"
	desc = "A puzzle box."
	icon = 'icons/obj/items/mundanities.dmi'
	icon_state = "wood_box"
	var/fluff_desc = "Wow."
	var/list/finished_ckeys = list()
	var/dice_roll = null
	var/alert = null
	sellprice = 5

	grid_width = 32
	grid_height = 32

/obj/item/mundane/puzzlebox/easy/Initialize()
	. = ..()
	dice_roll = rand(6,15)
	fluff_desc = pick("It, frankly, looks rather depressing.","I can see an engraving of Psydon sending the Comet Syon on the side.","It doesn't look so difficult.","It's dusty and boring.","Why do I want to play with this for hours?","I could probably get a vagrant to solve this.","It looks like it was made for fools.")
	desc += "[fluff_desc]"


/obj/item/mundane/puzzlebox/easy/attack_self(mob/living/user)
	var/ckey = user.ckey
	if(ckey in finished_ckeys)
		to_chat(user, span_warning("I've already tried my hand at [src]."))
		return
	playsound(src.loc, 'sound/items/wood_sharpen.ogg', 75, TRUE)
	playsound(src.loc, 'sound/items/visor.ogg', 75, TRUE)
	if (alert(user, "My fingers trace the outside of this box. It looks of average difficulty. Do I try to solve it?", "ROGUETOWN", "Yes", "No") != "Yes")
		return
	if(do_after(user,70, target = src))
		if((dice_roll) <= user.STAINT)
			to_chat(user, span_notice("I solve [src] fairly easily. I feel rather satisfied."))
			user.add_stress(/datum/stressevent/puzzle_easy)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lock.ogg', 75, TRUE)
		else
			to_chat(user, span_warning("I can't solve \the [src]. Cack! Frustrated, I leave it alone."))
			user.add_stress(/datum/stressevent/puzzle_fail)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lockrattle.ogg', 75, TRUE)


//medium

/obj/item/mundane/puzzlebox/medium
	name = "\improper ebony puzzle-box"
	icon = 'icons/obj/items/mundanities.dmi'
	icon_state = "ebon_box"
	var/fluff_desc = null
	var/list/finished_ckeys = list()
	var/dice_roll = null
	var/alert = null
	sellprice = 15

	grid_width = 32
	grid_height = 32

/obj/item/mundane/puzzlebox/medium/Initialize()
	. = ..()
	dice_roll = rand(6,20)
	fluff_desc = pick("Its surface shines with polished ebony.","I can see an engraving of a Snow-Elf on the side.","It looks like it could challenge an average man.","I wish my personality was like this box's.","Why do I want to play with this for hours?","I could probably sell this to a wizard's apprentice.","It looks...sufficient.")
	desc += "[fluff_desc]"

/obj/item/mundane/puzzlebox/medium/attack_self(mob/living/user)
	var/ckey = user.ckey
	if(ckey in finished_ckeys)
		to_chat(user, span_warning("I've already tried my hand at [src]."))
		return
	playsound(src.loc, 'sound/items/wood_sharpen.ogg', 75, TRUE)
	playsound(src.loc, 'sound/items/visor.ogg', 75, TRUE)
	if (alert(user, "My fingers trace the outside of this box. It looks of average difficulty. Do I try to solve it?", "ROGUETOWN", "Yes", "No") != "Yes")
		return
	if(do_after(user,70, target = src))
		if((dice_roll) <= user.STAINT)
			to_chat(user, span_notice("I solve [src] fairly easily. I feel rather satisfied."))
			user.add_stress(/datum/stressevent/puzzle_medium)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lock.ogg', 75, TRUE)
		else
			to_chat(user, span_warning("I can't solve [src]. Frustrated, I leave it alone."))
			user.add_stress(/datum/stressevent/puzzle_fail)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lockrattle.ogg', 75, TRUE)


//impossible. before you look at this and screech - even the highest int bonus jobs in the game start with a 0% chance assuming worst roll from this to beat this thing
//the only job that can 'consistently' crack this is archivist, who starts with a 30%-ish chance, assuming worst roll from this. but then ur stuck playing archivist so ??? stat-packs help, but you'll still end up worse off tbh


/obj/item/mundane/puzzlebox/impossible //literally nearly impossible to solve - if you do, you get a fairly lengthy buff and a stat boost.
	name = "\improper royal puzzle-box"
	icon = 'icons/obj/items/mundanities.dmi'
	icon_state = "grimace_box"
	var/fluff_desc = null
	var/list/finished_ckeys = list()
	var/dice_roll = null
	sellprice = 150

	grid_width = 32
	grid_height = 32

/obj/item/mundane/puzzlebox/impossible/Initialize()
	. = ..()
	dice_roll = rand(11,20)
	fluff_desc = pick("It, frankly, looks nearly impossible.","Its centerpiece is that of Astrata banishing a heretic from this world.","Without doubt, this is rather befuddling.","It looks arcane and nearly-impossible.","Why do I feel like I could try for hours and not succeed at this?","Even a bored archivist would probably have trouble with this one.","It looks nearly impossible.")
	desc += "[fluff_desc]"

/obj/item/mundane/puzzlebox/impossible/attack_self(mob/living/user)
	var/ckey = user.ckey
	if(ckey in finished_ckeys)
		to_chat(user, span_warning("I've already tried my hand at [src]."))
		return
	playsound(src.loc, 'sound/items/wood_sharpen.ogg', 75, TRUE)
	playsound(src.loc, 'sound/items/visor.ogg', 75, TRUE)
	if (alert(user, "My fingers trace the outside of this box. It looks nearly impossible. Do I try to solve it?", "ROGUETOWN", "Yes", "No") != "Yes")
		return
	if(do_after(user,100, target = src))
		if((dice_roll) + 4 <= user.STAINT)
			to_chat(user, span_notice("After much deliberation, I solve \the [src]!"))
			user.add_stress(/datum/stressevent/puzzle_impossible)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lockrattle.ogg', 75, TRUE)
			to_chat(user, span_notice("As I pop open \the [src], I feel a tingling wave run from my head to my feet. A piece of an azure crystal tumbles out. When I grab it, it's gone- and I suddenly feel invigorated."))
			user.STAINT += rand(1,5)
			user.STASTR += rand(1,5)
			user.STASPD += rand(1,5)
			user.STACON += rand(1,5)
			user.STAWIL += rand(1,5)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lock.ogg', 75, TRUE)
			playsound(src.loc, 'sound/items/visor.ogg', 75, TRUE)
		else
			to_chat(user, span_warning("I can't even start to solve [src]. Feeling like an absolute fool, I put it aside."))
			user.add_stress(/datum/stressevent/puzzle_fail)
			finished_ckeys += ckey
			playsound(src.loc, 'sound/foley/doors/lockrattle.ogg', 75, TRUE)


// food cans

/obj/item/reagent_containers/food/snacks/canned
	name = "corrugated tinpot"
	desc = "Corrugated tinplate concealing tinfood."
	icon = 'icons/obj/items/tincans.dmi'
	icon_state = "acan_s"
	sellprice = 70
	var/can_sealed = 1
	var/menu_item = 1
	tastes = null
	bitesize = 1
	list_reagents = null
	bitesize = 5
	rotprocess = null
	drop_sound = 'sound/foley/dropsound/shovel_drop.ogg'

/obj/item/reagent_containers/food/snacks/canned/Initialize()


	menu_item = pick(1,2,3,4,5) //get the meal. rand does not work for this and i have no idea why.
	switch(menu_item)
		if(1)
			list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS, /datum/reagent/drug/space_drugs = 2, /datum/reagent/berrypoison = 1)
			tastes = list("salty bitter syrup" = 2, "bad mushrooms" = 1)
		if(2)
			list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE, /datum/reagent/medicine/stronghealth = 1, /datum/reagent/water/salty = 3)
			tastes = list("overpoweringly salty rous meat" = 2)
		if(3)
			list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE, /datum/reagent/medicine/stronghealth = 3, /datum/reagent/water/salty = 3)
			tastes = list("cabbit meat" = 1, "thin stew" = 1)
		if(4)
			list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE, /datum/reagent/medicine/stronghealth = 3, /datum/reagent/medicine/strongmana = 3, /datum/reagent/water/salty = 3)
			tastes = list("salt" = 2, "saiga meat" = 1, "vegetables" = 1)
		if(5)
			list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD, /datum/reagent/medicine/stronghealth = 6, /datum/reagent/medicine/strongmana = 6)
			tastes = list("hearty meat stew" = 1, "fresh vegetables" = 1)
	. = ..()


/obj/item/reagent_containers/food/snacks/canned/proc/name_desc() //rename and new description upon opening
	name = "saltpot"
	desc += " It has been opened, revealing a salty-smelling mush on the inside. Somehow still seems like it'll last forever."


/obj/item/reagent_containers/food/snacks/canned/attackby(obj/A, mob/living/user, loc, params)

	if(src.can_sealed == 0)
		to_chat(user, span_warning("It's already open!"))

	if(src.can_sealed == 1)

//		if(A.type in subtypesof(/obj/item/rogueweapon/huntingknife)) //knife
		if(istype(A, /obj/item/rogueweapon/huntingknife))
			to_chat(user, span_notice("I dig in the blade and start opening the top of the container..."))
			playsound(src.loc, 'sound/items/canned_food_open.ogg', 75, TRUE)
			if(do_after(user,50, target = src))
				update_icon()
				src.name_desc()
				src.can_sealed = 0
				update_icon()
				to_chat(user, span_notice("The scent of salty food hits my nostrils as I tear the flimsy top off of the saltpot."))
				return

//		if(A.type in subtypesof(/obj/item/natural/stone)) //in case someone wants to bash it open with a BOULDER i guess
		if(istype(A, /obj/item/natural/stone))
			to_chat(user, span_notice("I start messily bashing the can open..."))
			playsound(src.loc, 'sound/items/canned_food_open.ogg', 75, TRUE)
			if(do_after(user,70, target = src))
				src.name_desc()
				src.can_sealed = 0
				update_icon()
				to_chat(user, span_notice("The scent of salty food hits my nostrils as I bash the saltpot open."))
				return

		else
			to_chat(user, span_warning("I can't open \the [src] with this..."))
			return FALSE


/obj/item/reagent_containers/food/snacks/canned/update_icon()

	if(can_sealed == 0)
		icon_state = "acan"

	else
		icon_state = "acan_s"




/obj/item/reagent_containers/food/snacks/canned/attack(mob/living/M, mob/living/user, def_zone)

	if(src.can_sealed == 1)
		return

	if(bitecount == 4)
		to_chat(user, span_warning("Empty."))
		sellprice = 10 //u ate da FOOD
		return
	..()

/obj/item/reagent_containers/food/snacks/canned/On_Consume()

	if(bitecount == 4) //if it empty, throw up da empty sprite
		icon_state = "acan_e"
		name = "empty saltpot"
		desc = "Corrugated tinplate and disgusting-smelling slime."
