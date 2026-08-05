/* This file contains standalone items for debug purposes. */

/obj/item/debug/human_spawner
	name = "human spawner"
	desc = ""
	icon = 'icons/obj/guns/magic.dmi'
	icon_state = "nothingwand"
	item_state = "wand"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	w_class = WEIGHT_CLASS_SMALL
	var/datum/species/selected_species
	var/valid_species = list()

/obj/item/debug/human_spawner/afterattack(atom/target, mob/user, proximity)
	..()
	if(isturf(target))
		var/mob/living/carbon/human/H = new /mob/living/carbon/human(target)
		if(selected_species)
			H.set_species(selected_species)

/obj/item/debug/human_spawner/attack_self(mob/user)
	..()
	var/choice = input("Select a species", "Human Spawner", null) in GLOB.species_list
	selected_species = GLOB.species_list[choice]


//is anybody actually using this file? anyway
/obj/item/debug/vheslynevent
	name = "devil trigger"
	desc = "Frustration is getting bigger, bang, bang, bang..."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scrying"
	item_state = "scrying"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/debug/vheslynevent/attack_self(mob/user)
	. = ..()
	if(SSticker.sunscorched == 1)
		message_admins("[user] tried to trigger Vheslynblot, but can't, because it already started. How did this happen?! Tell Tea!")
		log_admin("[user] tried to trigger Vheslynblot, but can't, because it already started. How did this happen?! Tell Tea!")
		return
	if(!isliving(user))
		message_admins("[user] tried to trigger Vheslynblot, but can't, because they are dead. How did this happen?! Tell Tea!")
		log_admin("[user] tried to trigger Vheslynblot, but can't, because they are dead. How did this happen?! Tell Tea!")
		return
	var/mob/living/sunscorcher = user
	message_admins("Vheslynblot triggered by [user]!")
	log_admin("Vheslynblot triggered by [user]!")
	SSticker.sunscorch(sunscorcher)
