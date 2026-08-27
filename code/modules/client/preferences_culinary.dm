
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

/datum/preferences/proc/apply_culinary_preferences(mob/living/carbon/human/character)
	character.favorite_cuisine = favorite_cuisine
	character.favorite_dish = favorite_dish
	character.favorite_drink = favorite_drink
