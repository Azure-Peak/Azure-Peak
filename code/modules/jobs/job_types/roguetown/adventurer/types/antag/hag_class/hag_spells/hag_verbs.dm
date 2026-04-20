/mob/living/carbon/human/proc/commune_with_roots()
	set name = "Commune with Roots"
	set category = "Hag"
	set desc = "Press your feet to the soil to hear the Mossmother's heartbeat."

	// Just in case.
	if(stat || !HAS_TRAIT(src, TRAIT_ANCIENT_HAG))
		return

	to_chat(src, span_notice("You press your feet to the earth, seeking the Mother's pulse..."))
	
	if(do_after(src, 1 SECONDS, target = src))
		var/obj/structure/roguemachine/mossmother/closest_tree
		var/min_dist = INFINITY
		var/turf/my_turf = get_turf(src)

		for(var/obj/structure/roguemachine/mossmother/tree in GLOB.hag_trees)
			var/turf/tree_turf = get_turf(tree)
			if(!tree_turf) 
				continue

			var/dist = get_dist_euclidean(my_turf, tree_turf)
			if(dist < min_dist)
				min_dist = dist
				closest_tree = tree

		if(closest_tree)
			var/turf/tree_turf = get_turf(closest_tree)
			var/area/tree_area = get_area(closest_tree)

			if(tree_turf.z != my_turf.z)
				var/z_dir = (tree_turf.z > my_turf.z) ? "above" : "deep below"
				to_chat(src, span_notice("The pulse of a Heartroot tree thrums from [z_dir] you, somewhere in [tree_area.name]."))
			else
				var/dir_text = dir2text(get_dir(src, closest_tree))
				var/dist_tiles = get_dist(my_turf, tree_turf)
				if(dist_tiles <= 2)
					to_chat(src, span_boldnotice("The Heartroot is right here!"))
				else if(dist_tiles < 15)
					to_chat(src, span_notice("A strong, wet thrumming comes from the [dir_text]. A tree grows nearby in [tree_area.name]."))
				else
					to_chat(src, span_notice("You feel a faint, ancient vibration to the [dir_text]... somewhere far off in [tree_area.name]."))

			src.playsound_local(src.loc, 'sound/magic/heartbeat.ogg', 75, TRUE)
		else
			to_chat(src, span_warning("The earth is hollow and silent. You are beyond the reach of the Mossmother."))
