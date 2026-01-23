// Pre-creates mutable appearances for icons during init and avoids rsc access during gameplay

// Global cache
GLOBAL_LIST_EMPTY(pregenerated_icon_cache)

SUBSYSTEM_DEF(iconcache)
	name = "Icon Cache"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_OVERLAY

/obj/item/var/list/cached_appearances

/obj/item/proc/cache_key(tag, behind = FALSE, mirrored = FALSE, blood = FALSE, extra_index = "")
	return "[type]_[icon_state][extra_index][blood ? "_b" : ""]_[tag]_[behind ? "behind" : "front"]_[mirrored ? "mirrored" : "normal"]"

/obj/item/proc/pregenerate_all_appearances()
	cached_appearances = list()

	var/list/tags_to_generate = list()

	if(experimental_inhand)
		tags_to_generate += "gen"
		if(gripped_intents)
			tags_to_generate += "wielded"

	if(experimental_onhip && (slot_flags & ITEM_SLOT_BELT))
		tags_to_generate += "onbelt"
	if(experimental_onback && (slot_flags & ITEM_SLOT_BACK))
		tags_to_generate += "onback"

	if(!experimental_inhand && (slot_flags & (ITEM_SLOT_HANDS | ITEM_SLOT_BELT | ITEM_SLOT_BACK)))
		tags_to_generate += "gen"

	for(var/tag in tags_to_generate)
		var/list/prop = getonmobprop(tag)
		if(!prop)
			continue

		for(var/behind in list(FALSE, TRUE))
			for(var/mirrored in list(FALSE, TRUE))
				for(var/blood in list(FALSE, TRUE))
					var/cache_key = cache_key(tag, behind, mirrored, blood)
					if(!cached_appearances[cache_key])
						cached_appearances[cache_key] = generate_mutable_appearance(tag, prop, behind, mirrored, blood)

/obj/item/proc/generate_mutable_appearance(tag, prop, behind = FALSE, mirrored = FALSE, blood = FALSE)
	var/used_index = icon_state
	var/extra_index = get_extra_onmob_index()
	if(extra_index)
		used_index += extra_index
	if(blood)
		used_index += "_b"

	var/icon/generated_icon = generateonmob(tag, prop, behind, mirrored, used_index)
	if(!generated_icon)
		return null

	return mutable_appearance(generated_icon)

/obj/item/proc/get_cached_appearance(tag, prop, behind = FALSE, mirrored = FALSE)
	// Initialize cache if needed
	if(!cached_appearances)
		cached_appearances = list()

	var/blood = HAS_BLOOD_DNA(src)
	var/cache_key = cache_key(tag, behind, mirrored, blood)

	var/mutable_appearance/cached = cached_appearances[cache_key]
	if(!cached)
		// Get properties on demand if not provided for some reason
		if(!prop)
			prop = getonmobprop(tag)

		if(prop)
			cached = generate_mutable_appearance(tag, prop, behind, mirrored, blood)
			if(cached)
				cached_appearances[cache_key] = cached

	return cached
