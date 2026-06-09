//Ventriloquism! Make things speak!

/mob/living/carbon/human/proc/ventriloquate()
	set name = "Ventriloquism"
	set category = "Japes"
	
	var/obj/item/grabbing/I = get_active_held_item()
	if(!I)
		to_chat(src, span_warning("I need to be holding or grabbing something!"))
		return
	var/message = input(usr, "What do you want to ventriloquate?", "Ventriloquism!") as text | null
	if(!message)
		return
	I.say(message)
	log_admin("[key_name(usr)] ventriloquated [I] at [AREACOORD(I)] to say \"[message]\"")

// Ear Trick! Pull objects from behind someone's ear by the will of Xylix!

/mob/living/carbon/human/proc/ear_trick()
	set name = "Ear Trick"
	set category = "Japes"

	var/obj/item/grabbing/I = get_active_held_item()
	var/mob/living/carbon/human/H
	var/obj/item/japery_obj
	japery_obj = get_japery()
	var/obj/item/J = new japery_obj(get_turf(H))


	if(!istype(I) || !ishuman(I.grabbed))
		return
	H = I.grabbed
	if(H == src)
		to_chat(src, span_warning("I know what's behind my own ears!"))
		return
	if(mob_timers["lasttrick"])
		if(world.time < mob_timers["lasttrick"] + 20 SECONDS)
			to_chat(src, span_warning("I need a moment before I can do another trick!"))
			return
	qdel(I)
	src.put_in_hands(J)
	src.visible_message(span_notice("[src] reaches behind [H]'s ear with a grin, shaking their closed hand for a moment before revealing [J] held in it!"))
	mob_timers["lasttrick"] = world.time

/mob/living/carbon/human/proc/get_japery()
	var/japery_list = list(/obj/item/roguecoin/copper,
		/obj/item/roguecoin/silver,
		/obj/item/natural/dirtclod,
		/obj/item/natural/worms,
		/obj/item/natural/thorn,
		/obj/item/natural/stone,
		/obj/item/natural/poo,
		/obj/item/natural/feather,
		/obj/item/natural/worms/leech,
		)
	
	var/japery = pick(japery_list)
	return japery
