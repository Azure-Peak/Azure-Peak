/obj/structure/roguemachine/hag_cauldron
	name = "Hag's Cauldron"
	desc = "A rusted, iron pot caked in ancient grime. It smells of wet earth and copper."
	icon = 'icons/roguetown/misc/alchemy.dmi'
	icon_state = "hagdron0"
	density = TRUE
	anchored = TRUE

	var/mode = null
	/// The item used to prime the cauldron
	var/obj/item/stored_core = null
	var/list/item_values = list(
		/obj/item/rogueweapon = 10,
		/obj/item/clothing = 5
	)

	/// Synthesis recipe list
	var/list/synth_recipes = list(
		// GILDED ITEMS
		/obj/item/rogueweapon/sword/decorated = /obj/item/hag_catalyst/synth_base/gilded,
		/obj/item/rogueweapon/huntingknife/idagger/steel/decorated = /obj/item/hag_catalyst/synth_base/gilded,
		// REGULAR STEEL - SWORDS
		/obj/item/rogueweapon/sword = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/sword/long = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/sword/long/broadsword/steel = /obj/item/hag_catalyst/synth_base,
		// REGULAR STEEL - DAGGERS
		/obj/item/rogueweapon/huntingknife/chefknife = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/huntingknife/chefknife/cleaver = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/huntingknife/combat = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/huntingknife/idagger/steel = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/huntingknife/idagger/steel/rondel = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/huntingknife/throwingknife/steel = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/huntingknife/scissors/steel = /obj/item/hag_catalyst/synth_base,
		// REGULAR STEEL - BLUNT WEAPONS
		/obj/item/rogueweapon/mace/steel = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/mace/steel/morningstar = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/mace/cudgel/flanged = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/mace/warhammer/steel = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/mace/goden/steel = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/mace/maul/grand = /obj/item/hag_catalyst/synth_base,
		// REGULAR STEEL - FLAILS
		/obj/item/rogueweapon/flail/sflail = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/flail/peasantwarflail/iron = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/flail/militia = /obj/item/hag_catalyst/synth_base,
		// REGULAR STEEL - GREATSWORDS
		/obj/item/rogueweapon/greatsword = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/greatsword/iron = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/greatsword/zwei = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/greatsword/grenz = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/greatsword/grenz/flamberge = /obj/item/hag_catalyst/synth_base,
		// REGULAR STEEL - ESTOC
		/obj/item/rogueweapon/estoc = /obj/item/hag_catalyst/synth_base,
		// REGULAR STEEL - POLEARMS
		/obj/item/rogueweapon/spear = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/spear/partizan = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/spear/boar = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/spear/billhook = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/halberd = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/halberd/glaive = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/halberd/bardiche = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/eaglebeak = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/eaglebeak/lucerne = /obj/item/hag_catalyst/synth_base,
		// REGULAR STEEL - QUARTERSTAFFS (Steel-tipped variants)
		/obj/item/rogueweapon/woodstaff/quarterstaff/steel = /obj/item/hag_catalyst/synth_base,
		// REGULAR STEEL - FISHING SPEARS (Steel variants)
		/obj/item/rogueweapon/fishspear = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/spear/trident = /obj/item/hag_catalyst/synth_base,
		// REGULAR STEEL - AXES
		/obj/item/rogueweapon/stoneaxe/woodcut = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/stoneaxe/woodcut/steel = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/stoneaxe/woodcut/pick = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/stoneaxe/woodcut/wardenpick = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/stoneaxe/battle = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/stoneaxe/handaxe = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/stoneaxe/hurlbat = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/greataxe = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/greataxe/steel = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/greataxe/steel/knight = /obj/item/hag_catalyst/synth_base,
		/obj/item/rogueweapon/greataxe/steel/doublehead = /obj/item/hag_catalyst/synth_base
	)

/obj/item/hag_catalyst/varnish_base
	name = "Strange Varnish"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	icon_state = "varnish"
	desc = "The label depicts dipping a sword into a cauldron."

/obj/item/hag_catalyst/synth_base
	name = "Odd Catalyst"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	icon_state = "catalyst"
	desc = "The label depicts dipping a bundle of sticks into a cauldron."

/obj/item/hag_catalyst/synth_base/gilded
	name = "Wyrd Catalyst"
	icon = 'icons/roguetown/items/hag/hag_items.dmi'
	icon_state = "catalyst_gold"
	desc = "The label depicts dipping a bundle of sticks into a cauldron."

/obj/structure/roguemachine/hag_cauldron/proc/update_icon_overlaps()
	cut_overlays()
	if(mode)
		var/mutable_appearance/filling = mutable_appearance(icon, "cauldron_boiling")
		if(mode == "varnish")
			filling.color = "#4b0082"
		else
			filling.color = "#1a3616"
		add_overlay(filling)

/obj/structure/roguemachine/hag_cauldron/attackby(obj/item/I, mob/user, params)
	if(!iscarbon(user))
		return ..()

	var/mob/living/carbon/C = user
	if(!C.cmode)
		if(!mode)
			return prime_cauldron(I, user)

		if(mode == "varnish")
			return handle_varnish(I, user)

		if(mode == "synthesis")
			return handle_synthesis(I, user)

	return ..()

/obj/structure/roguemachine/hag_cauldron/proc/prime_cauldron(obj/item/I, mob/user)
	var/new_mode = null
	var/msg = ""

	if(istype(I, /obj/item/hag_catalyst/varnish_base))
		new_mode = "varnish"
		msg = span_notice("You swirl the varnish into the cauldron. It begins to shimmer with a predatory sheen.")
	else if(istype(I, /obj/item/hag_catalyst/synth_base))
		new_mode = "synthesis"
		msg = span_notice("The cauldron's contents turn thick and fibrous as you add the synthesis mulch.")

	if(new_mode && user.transferItemToLoc(I, src))
		mode = new_mode
		stored_core = I
		to_chat(user, msg)
		update_icon_overlaps()
		return TRUE
	return FALSE

/obj/structure/roguemachine/hag_cauldron/proc/handle_varnish(obj/item/I, mob/user)
	if(is_item_enchanted(I))
		to_chat(user, span_warning("[I] is already saturated with hag's power! To add more would shatter it."))
		return FALSE

	to_chat(user, span_notice("You begin dipping [I] into the viscous varnish..."))
	if(!do_after(user, 3 SECONDS, target = src))
		return FALSE

	var/points = 1
	for(var/path in item_values)
		if(istype(I, path))
			points = item_values[path]
			break

	I.AddComponent(/datum/component/hag_enchanted_item, points)
	to_chat(user, span_warning("You pull [I] from the sludge, now enchanted with a hag's boon."))
	consume_core()
	return TRUE

/obj/structure/roguemachine/hag_cauldron/proc/is_item_enchanted(obj/item/I)
	if(I.GetComponent(/datum/component/hag_enchanted_item))
		return TRUE
	return FALSE

/obj/structure/roguemachine/hag_cauldron/proc/handle_synthesis(obj/item/I, mob/user)
	if(!istype(I, /obj/item/natural/bundle/stick))
		return FALSE

	var/obj/item/natural/bundle/stick/S = I
	if(S.amount < 5)
		to_chat(user, span_warning("You need at least 5 sticks to bind a synthesis."))
		return FALSE

	var/list/name_to_path = list()
	for(var/path in synth_recipes)
		if(stored_core.type == synth_recipes[path])
			var/obj/item/temp = path
			name_to_path[initial(temp.name)] = path

	var/selection = input(user, "What shall you knit from the sticks?", "Synthesis") as null|anything in name_to_path
	if(!selection)
		return FALSE

	var/res_path = name_to_path[selection]
	to_chat(user, span_notice("You begin knitting the sticks into a [selection] within the brew..."))

	if(!do_after(user, 5 SECONDS, target = src))
		return FALSE

	var/obj/item/artifact = new res_path(drop_location())

	// Point calculation
	var/points = 1
	for(var/path in item_values)
		if(istype(artifact, path))
			points = item_values[path]
			break
	points = (points > 1) ? CEILING(points / 2, 1) : 1

	artifact.AddComponent(/datum/component/hag_enchanted_item, points)

	if(S.amount == 6)
		new /obj/item/grown/log/tree/stick(get_turf(user))
	S.use(5)

	user.visible_message(span_warning("[user] pulls a freshly formed [artifact.name] from the cauldron!"))
	consume_core()
	return TRUE

/obj/structure/roguemachine/hag_cauldron/MiddleClick(mob/user, params)
	. = ..()
	if(!isliving(user))
		return
	if(!mode || !stored_core)
		return
	
	to_chat(user, span_notice("You begin scooping the core back out of the cauldron..."))
	if(do_after(user, 2 SECONDS, target = src))
		stored_core.forceMove(drop_location())
		if(!user.put_in_hands(stored_core))
			to_chat(user, span_notice("You set [stored_core] on the ground."))
		
		mode = null
		stored_core = null
		update_icon_overlaps()
		to_chat(user, span_notice("The cauldron returns to a dull, empty iron."))

/obj/structure/roguemachine/hag_cauldron/Destroy()
	if(stored_core)
		qdel(stored_core)
	return ..()

/obj/structure/roguemachine/hag_cauldron/proc/consume_core()
	if(stored_core)
		qdel(stored_core)
	mode = null
	update_icon_overlaps()
