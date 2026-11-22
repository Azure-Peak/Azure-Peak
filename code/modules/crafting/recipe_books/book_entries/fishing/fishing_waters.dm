#define FISHING_GUIDE_COMMON_SHARE 20
#define FISHING_GUIDE_UNCOMMON_SHARE 8

/datum/book_entry/fishing/water
	abstract_type = /datum/book_entry/fishing/water
	category = "Water Types"
	var/datum/fish_source/source_type

/datum/book_entry/fishing/water/still
	name = "Still Water"
	source_type = /datum/fish_source/water
	book_priority = 90

/datum/book_entry/fishing/water/pond
	name = "Duckweed Pond"
	source_type = /datum/fish_source/pond
	book_priority = 89

/datum/book_entry/fishing/water/cleanshallow
	name = "Clean Shallows"
	source_type = /datum/fish_source/cleanshallow
	book_priority = 88

/datum/book_entry/fishing/water/river
	name = "Flowing River"
	source_type = /datum/fish_source/river
	book_priority = 87

/datum/book_entry/fishing/water/murk
	name = "Murk River"
	source_type = /datum/fish_source/river/murk
	book_priority = 86

/datum/book_entry/fishing/water/swamp
	name = "Murky Swamp"
	source_type = /datum/fish_source/swamp
	book_priority = 85

/datum/book_entry/fishing/water/deep_swamp
	name = "Deep Swamp Waters"
	source_type = /datum/fish_source/swamp/deep
	book_priority = 84

/datum/book_entry/fishing/water/ocean
	name = "Shallow Ocean"
	source_type = /datum/fish_source/ocean
	book_priority = 83

/datum/book_entry/fishing/water/deep_ocean
	name = "Deep Ocean"
	source_type = /datum/fish_source/ocean/deep
	book_priority = 82

/datum/book_entry/fishing/water/darkwater
	name = "Darkwater"
	source_type = /datum/fish_source/ocean/abyssal
	book_priority = 81

/datum/book_entry/fishing/water/sewer
	name = "Filthy Sewers"
	source_type = /datum/fish_source/sewer
	book_priority = 80

/datum/book_entry/fishing/water/inner_book_html(mob/user)
	var/datum/fish_source/source = GLOB.preset_fish_sources[source_type]
	var/list/shown = list()
	var/fish_weight = 0
	for(var/path in source.fish_table)
		if(!ispath(path, /obj/item/reagent_containers/food/snacks/fish))
			continue
		var/obj/item/reagent_containers/food/snacks/fish/fish = path
		if(!(initial(fish.fish_flags) & FISH_FLAG_SHOW_IN_CATALOG))
			continue
		shown += path
		fish_weight += source.fish_table[path]

	var/html = "<div>"
	if(!length(shown))
		html += "<p>Nothing worth showing here.</p></div>"
		return html

	var/cell = "style='padding: 4px 14px; border-bottom: 1px dashed #6b5a3e; text-align: left; vertical-align: top;'"
	html += "<table style='border-collapse: collapse; margin-top: 8px;'>"
	html += "<tr><th [cell]>Name</th><th [cell]>Rarity</th><th [cell]>Bites</th><th [cell]>Notes</th></tr>"
	for(var/path in shown)
		var/obj/item/reagent_containers/food/snacks/fish/fish = path
		html += "<tr><td [cell]>[capitalize(initial(fish.name))]</td><td [cell]>[rarity_label(source, path, fish_weight)]</td><td [cell]>[bait_label(path)]</td><td [cell]>[notes_label(path)]</td></tr>"
	html += "</table></div>"
	return html

/datum/book_entry/fishing/water/proc/rarity_label(datum/fish_source/source, path, fish_weight)
	if(source.is_limited(path))
		return source.fish_counts[path] > 1 ? "Prized" : "Rare"
	var/share = 100 * source.fish_table[path] / fish_weight
	if(share >= FISHING_GUIDE_COMMON_SHARE)
		return "Common"
	if(share >= FISHING_GUIDE_UNCOMMON_SHARE)
		return "Uncommon"
	return "Scarce"

/datum/book_entry/fishing/water/proc/bait_label(path)
	var/static/list/dish_names = list(
		"[DISH_MEAT]" = "meat",
		"[DISH_POULTRY]" = "poultry",
		"[DISH_SEAFOOD]" = "seafood",
		"[DISH_VEGETABLE]" = "vegetables",
		"[DISH_FRUIT]" = "fruit",
		"[DISH_BREAD]" = "bread",
		"[DISH_DAIRY]" = "dairy",
		"[DISH_EGG]" = "eggs",
		"[DISH_HONEY]" = "honey",
	)
	var/list/names = list()
	var/list/favourites = SSfishing.fish_properties[path][FISH_PROPERTIES_FAV_BAIT]
	for(var/identifier in favourites)
		if(ispath(identifier))
			var/atom/bait = identifier
			names += initial(bait.name)
			continue
		if(!islist(identifier))
			continue
		var/list/special = identifier
		if(special[FISH_BAIT_TYPE] != FISH_BAIT_FOODTYPE)
			continue
		var/flags = special[FISH_BAIT_VALUE]
		for(var/flag_key in dish_names)
			if(flags & text2num(flag_key))
				names += dish_names[flag_key]
	return length(names) ? english_list(names) : "anything"

/datum/book_entry/fishing/water/proc/notes_label(path)
	var/list/notes = list()
	var/list/traits = SSfishing.fish_properties[path][FISH_PROPERTIES_TRAITS]
	for(var/trait_path in traits)
		var/datum/fish_trait/trait = GLOB.fish_traits[trait_path]
		notes += "<span title='[html_encode(trait.catalog_description)]' style='border-bottom: 1px dotted; cursor: help;'>[trait.name]</span>"
	return length(notes) ? notes.Join(", ") : ""

#undef FISHING_GUIDE_COMMON_SHARE
#undef FISHING_GUIDE_UNCOMMON_SHARE
