/obj/structure/roguemachine/mossmother
	name = "Mossmother"
	desc = "One of the most sacred of trees. The very heart of the bog, its roots extend across every single inch of land drenched by maddened waters. Its moss is said to have magical properties."
	icon = 'icons/roguetown/items/hag/hag_tree.dmi'
	icon_state = "mossmother"
	density = TRUE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	pixel_y = -30
	pixel_x = -27

	var/list/hag_stock = list()
	var/list/public_stock = list()
	var/harvesting = FALSE
	var/mother_tree = TRUE

/obj/structure/roguemachine/mossmother/travel
	name = "Heartroot tree"
	desc = "No one knows why, but these trees seem nigh indestructible. You feel uneasy looking at this monstrosity of roots and bark."
	icon_state = "tree"
	mother_tree = FALSE

/obj/structure/roguemachine/mossmother/Initialize(mapload)
	. = ..()
	GLOB.hag_trees += src
	public_stock[/obj/item/alch/hag_moss/sorrow] = 2
	public_stock[/obj/item/alch/hag_moss/mercy] = 2

	if(mother_tree)
		hag_stock[/obj/item/alch/hag_moss/sorrow] = 5
		hag_stock[/obj/item/alch/hag_moss/fury] = 3
		hag_stock[/obj/item/alch/hag_moss/mercy] = 5
		hag_stock[/obj/item/alch/hag_moss/grief] = 0
		hag_stock[/obj/item/alch/hag_moss/envy] = 0
		hag_stock[/obj/item/alch/hag_moss/lullaby] = 0
	else
		hag_stock[/obj/item/alch/hag_moss/sorrow] = 1

/obj/structure/roguemachine/mossmother/Destroy()
	GLOB.hag_trees -= src
	return ..()

/obj/structure/roguemachine/mossmother/proc/get_contents(is_hag = FALSE)
	var/list/source = is_hag ? hag_stock : public_stock
	var/title = is_hag ? "THE VEIL OF ROOTS" : "COMMON BLOSSOMS"

	var/contents = "<center>[title]<BR>--------------<BR>"
	for(var/path in source)
		var/count = source[path]
		var/name = initial(path:name)
		contents += "[name] ([count]): <a href='?src=[REF(src)];harvest=[path];hag=[is_hag]'>[count > 0 ? "REAP" : "BARREN"]</a><BR>"
	return contents + "</center>"

/obj/structure/roguemachine/mossmother/Topic(href, href_list)
	if(..()) return
	if(!usr.canUseTopic(src, BE_CLOSE)) return

	// Teleportation Execution
	if(href_list["teleport_to"])
		var/obj/structure/roguemachine/mossmother/target = locate(href_list["teleport_to"]) in GLOB.hag_trees
		do_teleport(usr, target)
		return

	// Travel Menu Opening
	if(href_list["action"] == "travel")
		handle_travel(usr)
		return

	// Harvest Menu Opening (Public or Hag)
	if(href_list["action"] == "public" || href_list["action"] == "hag")
		var/is_hag = (href_list["action"] == "hag")
		var/datum/browser/popup = new(usr, "moss_window", (is_hag ? "THE VEIL OF ROOTS" : "COMMON BLOSSOMS"), 400, 500)
		popup.set_content(get_contents(is_hag))
		popup.open()
		return

	// Actual Harvesting
	if(href_list["harvest"])
		var/path = text2path(href_list["harvest"])
		var/is_hag = text2num(href_list["hag"])
		var/list/stock = is_hag ? hag_stock : public_stock
		
		if(harvesting || stock[path] <= 0) return

		harvesting = TRUE
		to_chat(usr, span_notice("You begin to carefully knit the moss from the roots..."))
		
		if(do_after(usr, 3 SECONDS, target = src))
			if(stock[path] > 0)
				stock[path]--
				new path(get_turf(src))
				to_chat(usr, span_notice("You successfully pluck the moss."))
		
		harvesting = FALSE
		// Refresh the specific window
		var/datum/browser/popup = new(usr, "moss_window", (is_hag ? "THE VEIL OF ROOTS" : "COMMON BLOSSOMS"), 400, 500)
		popup.set_content(get_contents(is_hag))
		popup.open()

/obj/structure/roguemachine/mossmother/attack_hand(mob/living/user)
	if(..()) 
		return

	if(harvesting)
		to_chat(user, span_warning("The Mossmother is unresponsive; the roots are still knitting."))
		return

	var/contents = "<center>THE MOSSMOTHER<BR>--------------<BR>"
	contents += "<a href='?src=[REF(src)];action=public'>[span_danger("Reap Common Blossoms")]</a><BR>"

	if(HAS_TRAIT(user, TRAIT_ANCIENT_HAG))
		contents += "<a href='?src=[REF(src)];action=hag'>[span_danger("Reap Mother's Blood")]</a><BR>"
		contents += "<a href='?src=[REF(src)];action=travel'>[span_boldnotice("Walk the Roots")]</a><BR>"
	else if(!GLOB.hag_wards.len)
		contents += "<a href='?src=[REF(src)];action=travel'>[span_boldnotice("Walk the Roots")]</a><BR>"
	contents += "</center>"
	var/datum/browser/popup = new(user, "mossmother", "The Mossmother", 300, 300)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/mossmother/proc/handle_travel(mob/living/user)
	if(HAS_TRAIT(user, TRAIT_ANCIENT_HAG))
		var/datum/component/hag_curio_tracker/tracker = user.GetComponent(/datum/component/hag_curio_tracker)

		if(tracker && !tracker.hag_teleport_check())
			to_chat(user, span_warning("Your soul is still too frayed from your last return to walk the deep roots. Wait a bit longer..."))
			return

		var/dat = "<center>THE DEEP ROOTS<BR>--------------<BR>"
		for(var/obj/structure/roguemachine/mossmother/tree in GLOB.hag_trees)
			if(tree == src)
				continue
			var/area/A = get_area(tree)
			dat += "<a href='?src=[REF(src)];teleport_to=[REF(tree)]'>[A ? A.name : "Unknown Thicket"]</a><BR>"

		dat += "</center>"
		var/datum/browser/popup = new(user, "root_travel", "Root Travel", 300, 400)
		popup.set_content(dat)
		popup.open()
		return

	// Mortal logic (Wards are gone)
	var/area/my_area = get_area(src)
	if(istype(my_area, /area/rogue/indoors/shelter/bog_hag))
		// They are IN the hut, send them to a random exit
		var/list/exits = list()
		for(var/obj/structure/roguemachine/mossmother/T in GLOB.hag_trees)
			if(!istype(get_area(T), /area/rogue/indoors/shelter/bog_hag))
				exits += T

		if(exits.len)
			do_teleport(user, pick(exits), is_mortal = TRUE)
	else
		// They are OUTSIDE, send them to the hut
		for(var/obj/structure/roguemachine/mossmother/T in GLOB.hag_trees)
			if(istype(get_area(T), /area/rogue/indoors/shelter/bog_hag))
				do_teleport(user, T, is_mortal = TRUE)
				break

/obj/structure/roguemachine/mossmother/proc/do_teleport(mob/living/user, obj/structure/roguemachine/mossmother/target, is_mortal = FALSE)
	if(!target || !user || !user.Adjacent(src))
		return

	var/wait_time = is_mortal ? 20 SECONDS : 10 SECONDS
	user.visible_message(span_notice("[user] begins to sink into the mossy roots of [src]..."), \
						 span_notice("You begin to dissolve into the network of roots, seeking the path to [get_area(target)]."))

	// Long do_after to allow interruption.
	if(do_after(user, wait_time, target = src))
		if(!target || !user.Adjacent(src))
			return

		var/turf/destination = get_step(target, SOUTH)
		if(!destination || destination.is_blocked_turf())
			destination = get_turf(target)

		user.forceMove(destination)
		user.visible_message(span_notice("[user] emerges from the roots of [target]."), \
							 span_boldnotice("The roots spit you back out into [get_area(target)]."))

/obj/item/alch/hag_moss
	name = "Generic moss"
	desc = "A bloom of moss."
	icon_state = "moss_blank"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'

/obj/item/alch/hag_moss/sorrow
	name = "Mother's sorrow"
	desc = "A blossom of green moss. Said to induce melancholy when consumed by mothers-to-be, have-been, and would've-been."
	icon_state = "moss"

/obj/item/alch/hag_moss/fury
	name = "Mother's fury"
	desc = "A blossom of red moss. It cuts the throat when consumed, it burns and irritates the skin when touched. No one would dare cut down a mossmother, lest the very air be choked by her fury."
	color = "#610202"

/obj/item/alch/hag_moss/mercy
	name = "Mother's mercy"
	desc = "A blossom of pale, glowing moss. Holding it parts the trees, it is as if home, hearth, and a warm meal surround you at once."
	color = "#E0FFD1"

/obj/item/alch/hag_moss/grief
	name = "Mother's grief"
	desc = "A blossom of dark, velvet moss. Looking at it makes the silence louder, until it is deafening."
	color = "#2C2C2C"

/obj/item/alch/hag_moss/envy
	name = "Mother's envy"
	desc = "A blossom of bile-colored moss. It hisses when it touches metal and dissolves organic matter into a nutrient-rich slurry for the Mossmother's roots."
	color = "#A4C639"

/obj/item/alch/hag_moss/lullaby
	name = "Mother's lullaby"
	desc = "A blossom of deep indigo moss."
	color = "#301a3a"

/obj/item/alch/hag_moss/lullaby/examine(mob/user)
	. = ..()
	. += "<br><span class='italic'>You recall a childhood rhyme regarding this bloom...</span>"
	. += "<br>[span_notice("Smell too deep, fall asleep,")]"
	. += "[span_warning("Into the soil, quiet and steep.")]"
	. += "<br>[span_danger("Hear her hum a hollow strain,")]"
	. += "[span_boldnotice("To wash away your fear and pain.")]"

/obj/item/alch/hag_moss/pride
	name = "Mother's pride"
	desc = "A golden blossom of moss. It feels like a treasure in your hand, something to cherish until the end of your days."
	color = "#ffc400"

/obj/item/alch/hag_moss/enchanted
	name = "Enchanted Moss"
	var/boon_path // The path of the boon this moss grants essence for

/obj/item/alch/hag_moss/enchanted/Initialize(mapload)
	. = ..()
	// Letting color properly init first.
	spawn(1)
		apply_glow()

/obj/item/alch/hag_moss/enchanted/proc/apply_glow()
	src.add_filter("moss_glow", 1, list("type" = "outline", "color" = color, "size" = 1))

// Test mosses, don't make these craftable.
/obj/item/alch/hag_moss/enchanted/rotting
	name = "Rotting Moss"
	boon_path = /datum/hag_boon/curse/rotting_touch
	color = "#4b5320"

/obj/item/alch/hag_moss/enchanted/soaked
	name = "Soaked Moss"
	boon_path = /datum/hag_boon/buff/curse/waterlogged
	color = "#203653"

/obj/item/alch/hag_moss/enchanted/dreamy
	name = "Dreamy Moss"
	boon_path = /datum/hag_boon/buff/curse/slumber
	color = "#b105a8"

// Proper mosses
/obj/item/alch/hag_moss/enchanted/deathless
	name = "Stormy Moss"
	boon_path = /datum/hag_boon/buff/storm_rebirth
	color = "#fffb00"

/obj/item/alch/hag_moss/enchanted/deathless
	name = "Corrosive Moss"
	boon_path = /datum/hag_boon/trait/wyrd_labourer
	color = "#683700"

/obj/item/alch/hag_moss/enchanted/crawling
	name = "Crawling Moss"
	boon_path = /datum/hag_boon/spell/spider_speak
	color = "#0e0b09"

/obj/item/alch/hag_moss/enchanted/caring
	name = "Caring Moss"
	boon_path = /datum/hag_boon/spell/twist_food
	color = "#ff0cff"

/obj/item/alch/hag_moss/enchanted/rooted
	name = "Rooted Moss"
	boon_path = /datum/hag_boon/buff/natural_communion
	color = "#019715"

/obj/item/alch/hag_moss/enchanted/creeping
	name = "Creeping Moss"
	boon_path = /datum/hag_boon/buff/creeping_moss
	color = "#74b945"

/obj/item/alch/hag_moss/enchanted/gilded
	name = "Gilded Moss"
	boon_path = /datum/hag_boon/spell/find_riches
	color = "#eca202"

/obj/item/alch/hag_moss/enchanted/drowned
	name = "Drowned Moss"
	boon_path = /datum/hag_boon/spell/banish
	color = "#037981"

// Trait mosses
/obj/item/alch/hag_moss/enchanted/random
	name = "Unstable Moss"
	/// The master list of all valid trait boons, built once on startup.
	var/static/list/trait_pool

/obj/item/alch/hag_moss/enchanted/random/Initialize(mapload)
	. = ..()
	if(!trait_pool)
		trait_pool = list()
		for(var/path in typesof(/datum/hag_boon/trait))
			var/datum/hag_boon/trait/dummy = path
			if(initial(dummy.hag_curse) || path == /datum/hag_boon/trait) 
				continue
			trait_pool += path

	var/list/valid_options = list()
	for(var/path in trait_pool)
		var/p_val = initial(path:points)
		if(is_in_range(p_val))
			valid_options += path

	if(length(valid_options))
		boon_path = pick(valid_options)
		name = "[initial(boon_path:name)] Moss"
	else
		stack_trace("Hag Moss at [get_turf(src)] failed to find a trait in its point range!")
		qdel(src)

/obj/item/alch/hag_moss/enchanted/random/proc/is_in_range(val)
	return FALSE

// --- The Three Tiers ---

/obj/item/alch/hag_moss/enchanted/random/low
	name = "Faded Moss"
	color = "#a9a9a9"

/obj/item/alch/hag_moss/enchanted/random/low/is_in_range(val)
		return val <= 50

/obj/item/alch/hag_moss/enchanted/random/mid
	name = "Lustrous Moss"
	color = "#3db1ff"

/obj/item/alch/hag_moss/enchanted/random/mid/is_in_range(val)
		return val >= 51 && val <= 75

/obj/item/alch/hag_moss/enchanted/random/high
	name = "Prismatic Moss"
	color = "#ff3de1"

/obj/item/alch/hag_moss/enchanted/random/high/is_in_range(val)
		return val >= 76
