/datum/triumph_buy/pick_any_class
	name = "No Advanced Class Restrictions"
	desc = "Get a single run of any advanced class from any job! You must join as any job that has advanced classes to begin with. WARNING: PREPARE FOR UNFORESEEN CONSEQUENCES."
	triumph_buy_id = TRIUMPH_BUY_ANY_CLASS
	triumph_cost = 5
	category = TRIUMPH_CAT_CHARACTER
	visible_on_active_menu = FALSE
	manual_activation = TRUE

/datum/triumph_buy/pick_any_class/on_buy()
	. = ..()
	if(!SSrole_class_handler.special_session_queue[ckey_of_buyer])
		SSrole_class_handler.special_session_queue[ckey_of_buyer] = list()

	var/datum/advclass/pick_everything/turbo_slop
	if(!SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id])
		turbo_slop = new()
		turbo_slop.maximum_possible_slots = 1
		SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id] = turbo_slop
	else
		turbo_slop = SSrole_class_handler.special_session_queue[ckey_of_buyer][triumph_buy_id]
		turbo_slop.maximum_possible_slots += 1

/datum/triumph_buy/pick_any_class/on_removal()
	. = ..()
	if(SSrole_class_handler.special_session_queue[ckey_of_buyer])
		SSrole_class_handler.special_session_queue[ckey_of_buyer].Remove(triumph_buy_id)

/datum/advclass/pick_everything
	name = "Pick-Classes"
	tutorial = "This will open up another menu when you spawn allowing you to pick from any class as long as its not disabled."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	maximum_possible_slots = 0

	outfit = null

/datum/advclass/pick_everything/post_equip(mob/living/carbon/human/H)
	..()
	var/list/possible_classes = list()
	for(var/datum/advclass/CHECKS in SSrole_class_handler.sorted_class_categories[CTAG_ALLCLASS])
		if(CTAG_DISABLED in CHECKS.category_tags)
			continue
		possible_classes += CHECKS

	var/datum/advclass/C = input(H.client, "What is my class?", "Adventure") as null|anything in possible_classes
	if(!C)
		C = pick(possible_classes)
	C.equipme(H)
