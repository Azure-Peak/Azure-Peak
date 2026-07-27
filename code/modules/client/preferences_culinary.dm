
GLOBAL_LIST_INIT(culinary_cuisines, list(
	"North Imperial" = CUISINE_NORTH_IMPERIAL,
	"South Imperial" = CUISINE_SOUTH_IMPERIAL,
	"Otavais" = CUISINE_OTAVAIS,
	"Northern" = CUISINE_NORTHERN,
	"Etruscan" = CUISINE_ETRUSCAN,
	"Southeastern" = CUISINE_SOUTHEASTERN,
	"Ranesheni" = CUISINE_RANESHENI,
))

GLOBAL_LIST_INIT(culinary_dishes, list(
	"Meat" = DISH_MEAT,
	"Poultry" = DISH_POULTRY,
	"Seafood" = DISH_SEAFOOD,
	"Vegetable" = DISH_VEGETABLE,
	"Fruit" = DISH_FRUIT,
	"Bread" = DISH_BREAD,
	"Dairy" = DISH_DAIRY,
	"Pastry" = DISH_PASTRY,
	"Pie" = DISH_PIE,
	"Sweet" = DISH_SWEET,
	"Egg" = DISH_EGG,
	"Noodles" = DISH_NOODLES,
))

GLOBAL_LIST_INIT(culinary_drinks, list(
	"Wine" = DRINKTYPE_WINE,
	"Rice Wine" = DRINKTYPE_RICEWINE,
	"Ale & Beer" = DRINKTYPE_ALE,
	"Spirits" = DRINKTYPE_SPIRIT,
	"Mead" = DRINKTYPE_MEAD,
	"Cider" = DRINKTYPE_CIDER,
	"Tea & Coffee" = DRINKTYPE_CAFFEINE,
	"Juices" = DRINKTYPE_JUICE,
))

/proc/culinary_flag_name(list/options, flag)
	if(!flag)
		return "None"
	for(var/label in options)
		if(options[label] == flag)
			return label
	return "None"

/proc/culinary_flag_valid(list/options, flag)
	if(!flag)
		return TRUE
	for(var/label in options)
		if(options[label] == flag)
			return TRUE
	return FALSE

/proc/culinary_flags_names(list/options, flags)
	var/list/names = list()
	for(var/label in options)
		if(options[label] & flags)
			names += label
	return names

/datum/preferences/proc/get_culinary_axis_options(axis)
	switch(axis)
		if("cuisine")
			return GLOB.culinary_cuisines
		if("dish")
			return GLOB.culinary_dishes
		if("drink")
			return GLOB.culinary_drinks

/datum/preferences/proc/sanitize_culinary_preferences()
	if(!culinary_flag_valid(GLOB.culinary_cuisines, favorite_cuisine))
		favorite_cuisine = NONE
	if(!culinary_flag_valid(GLOB.culinary_dishes, favorite_dish))
		favorite_dish = NONE
	if(!culinary_flag_valid(GLOB.culinary_drinks, favorite_drink))
		favorite_drink = NONE

/datum/preferences/proc/set_culinary_axis(axis, flag)
	var/list/options = get_culinary_axis_options(axis)
	if(!options)
		return
	if(!culinary_flag_valid(options, flag))
		return
	switch(axis)
		if("cuisine")
			favorite_cuisine = flag
		if("dish")
			favorite_dish = flag
		if("drink")
			favorite_drink = flag

/datum/preferences/proc/handle_culinary_topic(mob/user, href_list)
	switch(href_list["preference"])
		if("culinary_axis")
			show_culinary_axis_ui(user, href_list["axis"])
		if("culinary_set")
			set_culinary_axis(href_list["axis"], text2num(href_list["flag"]))
			user << browse(null, "window=culinary_selection")
			show_culinary_ui(user)

/datum/preferences/proc/show_culinary_ui(mob/user)
	var/list/dat = list()
	dat += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"
	dat += "Pick the food, cuisine and drinks your character loves. Only fine or lavish food, nice drink or better counts for the mood boost.<hr>"
	dat += "<b>Cuisine:</b> <a href='byond://?_src_=prefs;preference=culinary_axis;axis=cuisine;task=change_culinary_preferences'>[culinary_flag_name(GLOB.culinary_cuisines, favorite_cuisine)]</a><br>"
	dat += "<b>Favourite Dish:</b> <a href='byond://?_src_=prefs;preference=culinary_axis;axis=dish;task=change_culinary_preferences'>[culinary_flag_name(GLOB.culinary_dishes, favorite_dish)]</a><br>"
	dat += "<b>Favourite Drink:</b> <a href='byond://?_src_=prefs;preference=culinary_axis;axis=drink;task=change_culinary_preferences'>[culinary_flag_name(GLOB.culinary_drinks, favorite_drink)]</a><br>"
	var/datum/browser/popup = new(user, "culinary_customization", "<div align='center'>Culinary Preferences</div>", 400, 400)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/show_culinary_axis_ui(mob/user, axis)
	var/list/options = get_culinary_axis_options(axis)
	if(!options)
		return
	var/title
	switch(axis)
		if("cuisine")
			title = "Select Cuisine"
		if("dish")
			title = "Select Favourite Dish"
		if("drink")
			title = "Select Favourite Drink"
	var/list/dat = list()
	dat += "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"
	dat += "<a href='byond://?_src_=prefs;preference=culinary_set;axis=[axis];flag=0;task=change_culinary_preferences'>None</a><br>"
	for(var/label in options)
		dat += "<a href='byond://?_src_=prefs;preference=culinary_set;axis=[axis];flag=[options[label]];task=change_culinary_preferences'>[label]</a><br>"
	var/datum/browser/popup = new(user, "culinary_selection", "<div align='center'>[title]</div>", 280, 480)
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/preferences/proc/apply_culinary_preferences(mob/living/carbon/human/character)
	character.favorite_cuisine = favorite_cuisine
	character.favorite_dish = favorite_dish
	character.favorite_drink = favorite_drink
