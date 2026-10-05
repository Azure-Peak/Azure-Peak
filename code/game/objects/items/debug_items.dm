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
	var/choice = input(user, "Select a species", "Human Spawner", null) in GLOB.species_list
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

/obj/item/debug/skeleton_preference_wand
	name = "skeleton debug wand"
	desc = ""
	icon = 'icons/obj/guns/magic.dmi'
	icon_state = "pharoah_sceptre"
	w_class = WEIGHT_CLASS_SMALL

// make skeleton
/obj/item/debug/skeleton_preference_wand/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	if(isturf(target))
		new /mob/living/carbon/human/species/skeleton/npc/no_equipment(target)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.become_skeleton()

/obj/item/debug/skeleton_preference_wand/rmb_self(mob/user, keybind)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.select_skeleton_features()

/obj/item/debug/skeleton_preference_wand/MiddleClick(mob/user, params)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		H.choose_skeleton_pronouns_and_body()

/obj/item/debug/skeleton_preference_wand/get_mechanics_examine(mob/user)
	. = ..()
	+ = span_info("This is a DEBUG OBJECT. You should not see it if you are in regular gameplay.")
	+ = span_info("Click on a turf to spawn a mindless skelelon with no equipment. It's AI will be enabled.")
	+ = span_info("Click on any type of carbon/human to turn them into a skeleton.")
	+ = span_info("MMB the wand to apply your skeleton body-pronoun prefs.")
	+ = span_info("Right-click the wand to apply your skeleton head-tail prefs.")

