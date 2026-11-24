#define QDEL_LIST_CONTENTS(L) if(L) { for(var/I in L) qdel(I); L.Cut(); }
/obj/effect/decal/cleanable/roguerune	// basis for all rituals
	name = "ritualrune"
	desc = "Strange symbols pulse upon the ground..."
	anchored = TRUE
	icon = 'icons/obj/rune.dmi'
	icon_state = "6"
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER
	color = null
	var/magictype = "arcyne"//"arcyne", "divine", "druid", "blood"
	var/runesize = 0	//Used to determine range of the rune. Should correspond to rune size. EX: 32x32 and 96x96 should be size 1. Increase each size by one for every tile radius increase after.
	var/invoker_name = "basic rune"

	/// The description of the ritual rune shown to those who have knowledge to examine it
	var/invoker_desc = "a basic rune with no function."

	/// This is said by those when the rune is invoked.
	var/invocation = "Invoco!"
	/// Used for some runes, this is for when you want a rune to not be usable when in use.
	var/rune_in_use = FALSE

	/// Used when you want to keep track of who erased the rune
	var/log_when_erased = FALSE
	/// Whether this rune can be scribed or if it's admin only / special spawned / whatever
	var/can_be_scribed = TRUE
	/// Whether this rune requires a nearby leyline to be scribed
	var/requires_leyline = FALSE
	/// How long the rune takes to erase
	var/erase_time = 1.5 SECONDS
	/// How long the rune takes to create
	var/scribe_delay = 4 SECONDS
	/// If a rune cannot be speed boosted while scribing on certain turfs
	var/no_scribe_boost = FALSE
	/// If a rune provides a bonus to a spell, or spellbook reading.
	var/spellbonus = 0
	/// Hhow much damage you take doing it
	var/scribe_damage = 0.1
	/// How much damage invokers take when invoking it
	var/invoke_damage = 0
	/// If the rune requires a keyword when scribed
	var/req_keyword = FALSE
	/// The actual keyword for the rune
	var/keyword
	/// Global proc to call while the rune is being created
	var/started_creating
	/// Global proc to call if the rune fails to be created
	var/failed_to_create
	var/active = FALSE
	/// Tier var is used for 'tier' of rune, if the rune has tiers. EX: Summoning runes. If it doesn't have tiers, set tier to 0.
	var/tier = 1
	/// ritual result is the result of a ritual!
	var/ritual_result
	//atoms in ranges
	var/list/atom/movable/atoms_in_range	//list for atoms in range of rune
	var/datum/runeritual/pickritual		//selected
	var/list/selected_atoms
	var/list/rituals = list()

/proc/isarcyne(mob/living/carbon/human/A)
	return istype(A) && A.mind && (A.get_skill_level(/datum/skill/magic/arcane) > SKILL_LEVEL_NONE)	//checks if person has arcane skill

/proc/isdivine(mob/living/carbon/human/A)
	return istype(A) && A.mind && (A.get_skill_level(/datum/skill/magic/holy) > SKILL_LEVEL_NONE)	//checks if person has holy/divine skill

/proc/isdruid(mob/living/carbon/human/A)
	return istype(A) && A.mind && (A.get_skill_level(/datum/skill/magic/druidic) > SKILL_LEVEL_NONE)	//checks if person has druidic skill

/proc/isblood(mob/living/carbon/human/A)
	return istype(A) && A.mind && (A.get_skill_level(/datum/skill/magic/blood) > SKILL_LEVEL_NONE)		//checks if person has blood magic skill

GLOBAL_LIST_INIT(rune_types, generate_rune_types())
GLOBAL_LIST_INIT(t1rune_types, generate_t1rune_types())
GLOBAL_LIST_INIT(t2rune_types, generate_t2rune_types())
GLOBAL_LIST_INIT(t3rune_types, generate_t3rune_types())
GLOBAL_LIST_INIT(t4rune_types, generate_t4rune_types())

/// Returns an associated list of rune types. [rune.cultist_name] = [typepath]
/proc/generate_rune_types()
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/roguerune/rune as anything in subtypesof(/obj/effect/decal/cleanable/roguerune))
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.name)] = rune // Uses the invoker name for displaying purposes
	return runes

/proc/generate_t1rune_types()
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/roguerune/rune as anything in subtypesof(/obj/effect/decal/cleanable/roguerune))
		if(rune.tier > 1)
			continue
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.name)] = rune // Uses the invoker name for displaying purposes
	return runes
/proc/generate_t2rune_types()
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/roguerune/rune as anything in subtypesof(/obj/effect/decal/cleanable/roguerune))
		if(rune.tier > 2)
			continue
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.name)] = rune // Uses the invoker name for displaying purposes
	return runes
/proc/generate_t3rune_types()
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/roguerune/rune as anything in subtypesof(/obj/effect/decal/cleanable/roguerune))
		if(rune.tier > 3)
			continue
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.name)] = rune // Uses the invoker name for displaying purposes
	return runes

/proc/generate_t4rune_types()
	RETURN_TYPE(/list)
	var/list/runes = list()
	for(var/obj/effect/decal/cleanable/roguerune/rune as anything in subtypesof(/obj/effect/decal/cleanable/roguerune))
		if(!initial(rune.can_be_scribed))
			continue
		runes[initial(rune.name)] = rune // Uses the invoker name for displaying purposes
	return runes


/obj/effect/decal/cleanable/roguerune/Initialize(mapload, set_keyword)
	. = ..()
	if(set_keyword)
		keyword = set_keyword

/obj/effect/decal/cleanable/roguerune/proc/do_invoke_glow()
	set waitfor = FALSE
	animate(src, transform = matrix()*2, alpha = 0, time = 5, flags = ANIMATION_END_NOW) //fade out
	sleep(0.5 SECONDS)
	animate(src, transform = matrix(), alpha = 255, time = 0, flags = ANIMATION_END_NOW)

/obj/effect/decal/cleanable/roguerune/proc/fail_invoke()
	//This proc contains the effects of a rune if it is not invoked correctly, through either invalid wording or not enough cultists. By default, it's just a basic fizzle.
	visible_message(span_warning("The markings pulse with a small flash of light, then fall dark."))
	var/oldcolor = color
	color = rgb(255, 0, 0)
	animate(src, color = oldcolor, time = 5)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/atom, update_atom_colour)), 0.5 SECONDS)

/// Clears lingering references from invoke() to prevent hard deletes.
/obj/effect/decal/cleanable/roguerune/proc/invoke_cleanup()
	selected_atoms = null
	ritual_result = null
	if(pickritual)
		qdel(pickritual)
		pickritual = null

/obj/effect/decal/cleanable/roguerune/attack_hand(mob/living/user)
	if(rune_in_use)
		to_chat(user, span_notice("Someone is already using this rune."))
		return

	rune_in_use = TRUE

	if(!can_invoke(user))
		rune_in_use = FALSE
		fail_invoke()
		return

	// Build descriptions for tooltip display in the selection list, including invoker requirements
	var/list/ritual_descriptions = list()
	for(var/ritual_name in rituals)
		var/datum/runeritual/ritual_path = rituals[ritual_name]
		var/rdesc = initial(ritual_path.desc)
		var/rinvokers = initial(ritual_path.req_invokers)
		if(rinvokers > 1)
			rdesc = "[rdesc] (Requires [rinvokers] invokers)"
		if(rdesc)
			ritual_descriptions[ritual_name] = rdesc

	var/ritualnameinput = tgui_input_list(user, "Rituals", "", rituals, descriptions = ritual_descriptions)
	var/datum/runeritual/pickritual1 = rituals[ritualnameinput]

	if(!pickritual1)
		rune_in_use = FALSE
		return

	if(initial(pickritual1.tier) > tier)
		to_chat(user, span_hierophant_warning("Your ritual rune is not strong enough to perform this ritual."))
		rune_in_use = FALSE
		return

	// Collect invokers and check ritual requirements
	var/ritual_req = initial(pickritual1.req_invokers)
	var/list/invokers = collect_invokers(user, ritual_req)
	if(length(invokers) < ritual_req)
		to_chat(user, span_danger("This ritual requires [ritual_req] invokers. You need [ritual_req - length(invokers)] more nearby."))
		rune_in_use = FALSE
		fail_invoke()
		return

	invoke(invokers, pickritual1)
	return ..()

/obj/effect/decal/cleanable/roguerune/proc/can_invoke(mob/living/user)
	return TRUE

/// Collects eligible invokers near the rune. Always includes the user; searches for additional invokers if needed.
/obj/effect/decal/cleanable/roguerune/proc/collect_invokers(mob/living/user, req_count = 1)
	var/list/invokers = list()
	if(user)
		invokers += user
	if(req_count > 1)
		for(var/mob/living/invoker in range(runesize, src))
			if(invoker == user)
				continue
			if(!invoker.can_speak())
				continue
			if(invoker.stat != CONSCIOUS)
				continue
			if(magictype == "arcyne" && isarcyne(invoker))
				invokers += invoker
			else if(magictype == "divine" && isdivine(invoker))
				invokers += invoker
			else if(magictype == "druid" && isdruid(invoker))
				invokers += invoker
			else if(magictype == "blood" && isblood(invoker))
				invokers += invoker
	return invokers

/obj/effect/decal/cleanable/roguerune/proc/invoke(list/invokers, datum/runeritual/ritual)		//Generic invoke proc. This will be defined on every rune, along with effects.If you want to make an object, or provide a buff, do so through this proc., have both here.
	rune_in_use = FALSE
	atoms_in_range = list()
	for(var/atom/close_atom as anything in range(runesize, src))
		if(iswallturf(close_atom))
			to_chat(usr, span_hierophant_warning("Ritual failed, [src] is blocked by [close_atom]!"))
			fail_invoke()
			invoke_cleanup()
			return
		if(!ismovable(close_atom))
			continue
		if(isitem(close_atom))
			var/obj/item/close_item = close_atom
			if(close_item.item_flags & ABSTRACT) //woops sacrificed your own head
				continue
		if(close_atom.invisibility)
			continue
		if(close_atom == usr)
			continue
		if(close_atom == src)
			continue
		atoms_in_range += close_atom
	pickritual = new ritual
	if(!islist(pickritual.required_atoms))
		invoke_cleanup()
		return

	// A copy of our requirements list.
	// We decrement the values of to determine if enough of each required item is present.

	var/list/requirements_list = pickritual.required_atoms.Copy()
	var/list/banned_atom_types = pickritual.banned_atom_types.Copy()
	// A list of all atoms we've selected to use in this recipe.
	selected_atoms = list()
	for(var/atom/nearby_atom as anything in atoms_in_range)
		// Go through all of our required atoms
		if(istype(nearby_atom, /obj/item/reagent_containers))
			var/obj/item/reagent_containers/RC = nearby_atom
			if(RC.is_drainable())
				for(var/req_type in requirements_list)
					var/datum/reagent/A = RC.reagents.get_reagent(req_type)
					if(A && A.volume >= 15)
						requirements_list[req_type] -= A.volume
						selected_atoms |= nearby_atom

		for(var/req_type in requirements_list)
			// We already have enough of this type, skip
			if(requirements_list[req_type] <= 0)
				continue
			// If req_type is a list of types, check all of them for one match.
			if(islist(req_type))
				if(!(is_type_in_list(nearby_atom, req_type)))
					continue
			else if(!istype(nearby_atom, req_type))
				continue
			// if list has items, check if the strict type is banned.
			if(length(banned_atom_types))
				if(nearby_atom.type in banned_atom_types)
					continue
			// This item is a valid type. Add it to our selected atoms list.
			selected_atoms |= nearby_atom
			requirements_list[req_type]--
	var/list/what_are_we_missing = list()
	for(var/req_type in requirements_list)
		var/number_of_things = requirements_list[req_type]
		// <= 0 means it's fulfilled, skip
		if(number_of_things <= 0)
			continue
		// > 0 means it's unfilfilled - the ritual has failed, we should tell them why
		// Lets format the thing they're missing and put it into our list
		var/formatted_thing = "[number_of_things] "
		if(islist(req_type))
			var/list/req_type_list = req_type
			var/list/req_text_list = list()
			for(var/atom/possible_type as anything in req_type_list)
				req_text_list += pickritual.parse_required_item(possible_type)
			formatted_thing += english_list(req_text_list, and_text = "or")

		else
			formatted_thing = pickritual.parse_required_item(req_type)

		what_are_we_missing += formatted_thing
	if(length(what_are_we_missing))
		// Let them know it screwed up
		to_chat(usr, span_hierophant_warning("Ritual failed, missing components!"))
		// Then let them know what they're missing
		to_chat(usr, span_hierophant_warning("You are missing [english_list(what_are_we_missing)] in order to complete the ritual \"[pickritual.name]\"."))
		fail_invoke()
		invoke_cleanup()
		return FALSE

	playsound(usr, 'sound/magic/teleport_diss.ogg', 75, TRUE)

	ritual_result = pickritual.on_finished_recipe(usr, selected_atoms, loc)

	atoms_in_range.Cut()

	return TRUE

/obj/effect/decal/cleanable/roguerune/arcyne	//arcane
	name = "Arcane ritual rune"
	desc = "subtype used for arcane rituals- you should not be seeing this."
	magictype = "arcyne"
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/roguerune/arcyne/attack_hand(mob/living/user)
	if(!can_use_arcyne_rune(user))
		to_chat(user, span_warning("You aren't able to understand the words of [src]."))
		return
	. = ..()

/obj/effect/decal/cleanable/roguerune/arcyne/proc/can_use_arcyne_rune(mob/living/user)
	return HAS_TRAIT(user, TRAIT_LEYLINE_ATTUNEMENT) && !HAS_TRAIT(user, TRAIT_CHUNKYFINGERS)



/obj/effect/decal/cleanable/roguerune/arcyne/enchantment
	name = "imbuement array"
	desc = "arcane symbols pulse upon the ground..."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "imbuement"
	tier = 3
	runesize = 1
	pixel_x = -32 //So the big ol' 96x96 sprite shows up right
	pixel_y = -32
	invocation = "Virtutem Infunde!"
	layer = SIGIL_LAYER
	can_be_scribed = TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/enchantment/New()
	. = ..()
	rituals += GLOB.t3enchantmentrunerituallist

/obj/effect/decal/cleanable/roguerune/arcyne/enchantment/can_use_arcyne_rune(mob/living/user)
	return HAS_TRAIT(user, TRAIT_LEYLINE_ATTUNEMENT)

/obj/effect/decal/cleanable/roguerune/arcyne/enchantment/invoke(list/invokers, datum/runeritual/runeritual)
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	invoke_cleanup()

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,	span_italics("[src] saps your strength!"))
	do_invoke_glow()

/obj/effect/decal/cleanable/roguerune/arcyne/enchantment/greater	//used for better quality of learning, grants temporary 2 minute INT bonus.
	name = "greater imbuement array"
	desc = "arcane symbols pulse upon the ground..."
	icon = 'icons/effects/160x160.dmi'
	icon_state = "imbuement"
	tier = 4
	runesize = 2
	pixel_x = -64 //So the big ol' 96x96 sprite shows up right
	pixel_y = -64
	invocation = "Magnam Virtutem Infunde!"

/obj/effect/decal/cleanable/roguerune/arcyne/enchantment/greater/New()
	. = ..()
	rituals.Cut()
	rituals += GLOB.t4enchantmentrunerituallist

// Binding Array — consumes realm materials to bind a single creature to your service.
/obj/effect/decal/cleanable/roguerune/arcyne/binding
	name = "binding array"
	desc = "arcane symbols twist inward upon themselves, forming a cage of power..."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "empowerment"
	tier = 0
	runesize = 1
	pixel_x = -32
	pixel_y = -32
	invocation = "Vinculum Formare!"
	layer = SIGIL_LAYER
	can_be_scribed = TRUE
	var/busy = FALSE
	var/atom/movable/summoned_thing // can be an /obj/effect or a mob proper so this is the best parent type

/obj/effect/decal/cleanable/roguerune/arcyne/binding/New()
	. = ..()
	rituals += GLOB.familiarbindingrituallist

/obj/effect/decal/cleanable/roguerune/arcyne/binding/Destroy()
	// destroy the rune without a player in the mob - sorry, it's gone now
	if(summoned_thing && !QDELETED(summoned_thing))
		QDEL_NULL(summoned_thing)
	return ..()

/obj/effect/decal/cleanable/roguerune/arcyne/binding/get_mechanics_examine(mob/user)
	. = ..()
	if(isarcyne(user))
		. += span_info("Use the rune to select a rite. Some rites require the circle to be near a leyline.")
		. += span_info("For rites that summon a familiar, left-click the circle with an empty hand afterwards to attempt to draw in a player to control it.")
		. += span_info("The player that clicks the circle will be considered the familiar's owner. They do not have to be a mage, and it does not have to be you.")
		. += span_info("If you need to cancel a binding attempt, right-click the circle to delete the mob and refund the costs.")

/obj/effect/decal/cleanable/roguerune/arcyne/binding/attack_hand(mob/living/user)
	if(!summon_mob(user) && !summoned_thing)
		. = ..()

/obj/effect/decal/cleanable/roguerune/arcyne/binding/proc/summon_mob(mob/living/user)
	if(summoned_thing && ishuman(user))
		if(busy)
			to_chat(user, span_warning("I am already attempting to bind this familiar! I must have patience..."))
			return
		if(QDELETED(summoned_thing))
			to_chat(user, span_warning("The containment has already faded."))
			summoned_thing = null
			return
		for(var/mob/living/carbon/human/species/familiar/existing_fam in GLOB.alive_mob_list + GLOB.dead_mob_list)
			if(existing_fam.familiar_summoner == user)
				to_chat(user, span_warning("You can only bind one familiar at once!"))
				return FALSE
		var/plane
		if(isfamiliar(summoned_thing))
			var/mob/living/carbon/human/species/familiar/S = summoned_thing
			plane = S.planar_origin
		else
			var/obj/effect/planar_rift/R = summoned_thing
			plane = R.planar_origin
		if(plane == "void")
			to_chat(user, span_notice("You begin attempting to awaken your creation's mind..."))
		else
			to_chat(user, span_notice("You reach across the veil, attempting to draw in the familiar's mind..."))
		busy = TRUE
		var/mob/living/carbon/human/species/familiar/F = awaken_familiar(user, plane, "familiar", loc)
		if(F)
			QDEL_NULL(summoned_thing)
			busy = FALSE
			playsound(user, 'sound/magic/teleport_diss.ogg', 75, TRUE)
			do_invoke_glow()
			clear_obstacles(user)
			var/tutorial = null
			if(istype(F,/mob/living/carbon/human/species/familiar/fae))
				tutorial = "You are a familiar: a lesser being drawn from the outer planes. The faewyld is a primal place, and those that grow beyond their station are often pruned... for those of little power like yourself, the mortal realm is a safer place to grow. Serve your summoner, learn from this realm, and return stronger."
			else if(istype(F,/mob/living/carbon/human/species/familiar/infernal))
				tutorial = "You are a familiar: a lesser being drawn from the outer planes. The hells are a brutal place, and those with ambition beyond their ability are often culled... for those of little power like yourself, the mortal realm is a safer place to refuel. Serve your summoner, learn from this realm, and return stronger... or at least, let them think that is your intent. In truth, you are a being of malevolence, and once you gain sufficient power to control them, you are under no obligation to refrain from acting on your malice." // t2 infernals can possess and act against their summoner. daemonbinding is, as it turns out, a bad idea!
			else if(istype(F,/mob/living/carbon/human/species/familiar/elemental))
				tutorial = "You are a familiar: a lesser being drawn from the outer planes. The depths are an unchanging place, and pebbles that stick up are eroded down... for those of little power like yourself, the mortal realm is a safer place to accumulate. Serve your summoner, learn from this realm, and return stronger."
			else
				tutorial = "You are a Void Drakeling: a being entirely new to this world, and all others. A fragment of draconic power torn from elsewhere, if you are ever to become as strong as what you were once part of, you must sate this hunger. Serve your creator, and be voracious; planar beings shall be the fuel for your ascension."
			spawn(5 SECONDS) // stagger these...
				to_chat(F, span_notice(tutorial))
			if(F.tutorial_message)
				spawn(10 SECONDS) // ...to avoid them being caught up in chat spam
					to_chat(F, F.tutorial_message)
			return F
		else
			// nobody has valid familiar prefs. woe!
			to_chat(user, span_warning("No valid familiar candidate found!"))
			busy = FALSE
			return FALSE
	sleep(2 SECONDS)
	return FALSE

/obj/effect/decal/cleanable/roguerune/arcyne/binding/attack_right(mob/user)
	. = ..()
	if(summoned_thing && (input(user,"Would you like to cancel this summoning attempt?","Fallback","No") as anything in list("Yes","No") | null)=="Yes")
		busy = FALSE
		if(istype(summoned_thing, /mob/living/carbon/human/species/familiar/void))
			var/static/list/refund_costs = list(/obj/item/magic/artifact = 1, /obj/item/magic/voidstone = 2, /obj/item/magic/leyline = 1)
			for(var/index in refund_costs)
				for(var/i in 1 to refund_costs[index])
					new index(loc)
		QDEL_NULL(summoned_thing)

/obj/effect/decal/cleanable/roguerune/arcyne/binding/proc/clear_obstacles(mob/living/user)
	for(var/turf/closed/wall/anticheese in range(loc, runesize))
		anticheese.visible_message(span_warning("[anticheese] crumbles under the force of the releasing wards."))
		anticheese.ChangeTurf(/turf/open/floor/rogue/blocks)

/obj/effect/decal/cleanable/roguerune/arcyne/binding/invoke(list/invokers, datum/runeritual/runeritual)
	if(!..())
		return
	if(ritual_result)
		summoned_thing = ritual_result
		pickritual.cleanup_atoms(selected_atoms)
	invoke_cleanup()

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		var/datum/runeritual/binding/bindingritual = runeritual
		if(bindingritual.invocation)
			living_invoker.say(bindingritual.invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker, span_italics("[src] saps your strength!"))
	do_invoke_glow()

/obj/effect/decal/cleanable/roguerune/arcyne/wall
	name = "wall accession matrix"
	desc = "arcane symbols litter the ground- is that a wall of some sort?"
	icon_state = "wall"
	tier = 2
	invocation = "Murus Surgat!"
	can_be_scribed = TRUE
	color = "#184075"
	var/list/barriers = list()

/obj/effect/decal/cleanable/roguerune/arcyne/wall/New()
	. = ..()
	rituals += GLOB.t2wallrunerituallist

/obj/effect/decal/cleanable/roguerune/arcyne/wall/Destroy()
	QDEL_LIST_CONTENTS(barriers)
	barriers = null
	return ..()

/obj/effect/decal/cleanable/roguerune/arcyne/wall/attack_hand(mob/living/user)
	if(active)
		QDEL_LIST_CONTENTS(barriers)
		to_chat(user, span_warning("You deactivate the [src]!"))
		playsound(usr, 'sound/magic/teleport_diss.ogg', 75, TRUE)
		active = FALSE
		return
	. = ..()
/obj/effect/decal/cleanable/roguerune/arcyne/wall/invoke(list/invokers, datum/runeritual/runeritual)
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return
	if(pickritual.tier == 1)
		var/mob/living/user = usr
		var/turf/target_turf = get_step(get_step(src, user.dir), user.dir)
		var/turf/target_turf_two = get_step(target_turf, turn(user.dir, 90))
		var/turf/target_turf_three = get_step(target_turf, turn(user.dir, -90))
		var/turf/target_turf_four = get_step(target_turf_two, turn(user.dir, 90))
		var/turf/target_turf_five = get_step(target_turf_three, turn(user.dir, -90))
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_two)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_two, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_three)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_three, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_four)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_four, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_five)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_five, user)
			src.barriers += newbarrier
		active = TRUE
	else
		var/mob/living/user = usr
		var/turf/target_turf = get_step(get_step(src, user.dir), user.dir)
		var/turf/target_turf_two = get_step(target_turf, turn(user.dir, 90))
		var/turf/target_turf_three = get_step(target_turf, turn(user.dir, -90))
		var/turf/target_turf_four = get_step(target_turf_two, turn(user.dir, 90))
		var/turf/target_turf_five = get_step(target_turf_three, turn(user.dir, -90))
		var/turf/target_turfline2 = get_step(target_turf, user.dir)
		var/turf/target_turfline2_two = get_step(target_turfline2, turn(user.dir, 90))
		var/turf/target_turfline2_three = get_step(target_turfline2, turn(user.dir, -90))
		var/turf/target_turfline2_four = get_step(target_turfline2_two, turn(user.dir, 90))
		var/turf/target_turfline2_five = get_step(target_turfline2_three, turn(user.dir, -90))
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_two)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_two, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_three)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_three, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_four)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_four, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turf_five)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turf_five, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turfline2)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turfline2, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turfline2_two)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turfline2_two, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turfline2_three)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turfline2_three, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turfline2_four)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turfline2_four, user)
			src.barriers += newbarrier
		if(!locate(/obj/structure/arcyne_wall/caster) in target_turfline2_five)
			var/obj/structure/arcyne_wall/caster/newbarrier = new(target_turfline2_five, user)
			src.barriers += newbarrier
		active = TRUE

	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	invoke_cleanup()

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,	span_italics("[src] saps your strength!"))
	do_invoke_glow()

/obj/effect/decal/cleanable/roguerune/arcyne/verglas
	name = "verglas accession matrix"
	desc = "arcane symbols litter the ground- a slick sheen of frost spreads from the sigil."
	icon_state = "wall"
	tier = 2
	invocation = "Glacies Surgat!"
	can_be_scribed = TRUE
	color = GLOW_COLOR_ICE
	var/field_radius = 3 // Slippery sliddery (Match spell for ice rink fight)
	var/list/field = list()

/obj/effect/decal/cleanable/roguerune/arcyne/verglas/New()
	. = ..()
	rituals += GLOB.verglasrunerituallist

/obj/effect/decal/cleanable/roguerune/arcyne/verglas/Destroy()
	QDEL_LIST_CONTENTS(field)
	field = null
	return ..()

/obj/effect/decal/cleanable/roguerune/arcyne/verglas/attack_hand(mob/living/user)
	if(active)
		QDEL_LIST_CONTENTS(field)
		to_chat(user, span_warning("You deactivate the [src]!"))
		playsound(usr, 'sound/magic/teleport_diss.ogg', 75, TRUE)
		active = FALSE
		return
	. = ..()

/obj/effect/decal/cleanable/roguerune/arcyne/verglas/invoke(list/invokers, datum/runeritual/runeritual)
	if(!..())
		return
	var/turf/centerpoint = get_turf(src)
	var/mob/living/user = usr
	if(istype(user))
		var/turf/front = centerpoint
		for(var/i in 1 to field_radius + 1)
			var/turf/next = get_step(front, user.dir)
			if(!next)
				break
			front = next
		centerpoint = front
	playsound(centerpoint, 'sound/spellbooks/crystal.ogg', 80, TRUE)
	for(var/turf/T in get_hear(field_radius, centerpoint))
		if(T.density)
			continue
		if(istype(T, /turf/open/water))
			continue
		if(locate(/obj/effect/verglas) in T)
			continue
		field += new /obj/effect/verglas(T, 0)
	active = TRUE

	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	invoke_cleanup()

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,	span_italics("[src] saps your strength!"))
	do_invoke_glow()

/obj/effect/decal/cleanable/roguerune/arcyne/wallgreater
	name = "fortress accession matrix"
	desc = "A massive sigil- is that a wall in the center?"
	icon = 'icons/effects/160x160.dmi'
	icon_state = "wall"
	tier = 3
	invocation = "Arx Firma Surgat!"
	runesize = 2
	pixel_x = -64 //So the big ol' 96x96 sprite shows up right
	pixel_y = -64
	pixel_z = 0
	can_be_scribed = TRUE
//	var/id = "arcyne_fortress"
	var/datum/map_template/template
	var/fortress = /datum/map_template/arcyne_fortress
	var/list/barriers = list()

/obj/effect/decal/cleanable/roguerune/arcyne/wallgreater/New()
	. = ..()
	rituals += GLOB.t4wallrunerituallist

/obj/effect/decal/cleanable/roguerune/arcyne/wallgreater/proc/get_template(/datum/map_template/arcyne_fortress/fortress)

	var/datum/map_template/temporary = new fortress
	template = SSmapping.map_templates[temporary.id]
	if(!template)
		WARNING("Shelter template ([template.id]) not found!")
		qdel(src)


/obj/effect/decal/cleanable/roguerune/arcyne/wallgreater/invoke(list/invokers, datum/runeritual/ritual)
	if(!..())	//VERY important. Calls parent and checks if it fails. parent/invoke has all the checks for ingredients
		return
	if(QDELETED(src))
		return
	var/turf/deploy_location = get_turf(src)
	get_template(template)

	template.load(deploy_location, centered = TRUE)
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	invoke_cleanup()

	for(var/atom/invoker in invokers)
		if(!isliving(invoker))
			continue
		var/mob/living/living_invoker = invoker
		if(invocation)
			living_invoker.say(invocation, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		if(invoke_damage)
			living_invoker.apply_damage(invoke_damage, BRUTE)
			to_chat(living_invoker,	span_italics("[src] saps your strength!"))
	do_invoke_glow()

// Summoning circles — draw near a leyline to trigger encounters.
// Tier determines what creatures can be summoned from the leyline.
// Chalk: T1-T3. Dagger: All tiers.
/obj/effect/decal/cleanable/roguerune/arcyne/summoning
	name = "lesser matrix of summoning"
	desc = "A lesser circle of arcyne power, channeling the energy of the leyline to breach the veil between the material plane and the other and bring forth creechurs."
	icon_state = "summon"
	invocation = "Evoca et Constringe!"
	max_integrity = -1
	resistance_flags = INDESTRUCTIBLE | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	tier = 1
	can_be_scribed = TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/New()
	. = ..()
	rituals += GLOB.t1summoningrunerituallist

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/invoke(list/invokers, datum/runeritual/runeritual)
	if(!..())
		return
	// Chanting is handled in the ritual's on_finished_recipe, not here.
	if(ritual_result)
		pickritual.cleanup_atoms(selected_atoms)
	invoke_cleanup()
	do_invoke_glow()

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/ex_act(severity, target)
	return

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/mid
	name = "ordinary matrix of summoning"
	desc = "An ordinary circle of arcyne power, capable of reaching into the second dimension of the veil and bringing forth more powerful creechurs."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "summonmid"
	runesize = 1
	tier = 2
	pixel_x = -32
	pixel_y = -32
	pixel_z = 0
	can_be_scribed = TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/mid/New()
	. = ..()
	rituals.Cut()
	rituals += GLOB.t2summoningrunerituallist

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/adv
	name = "greater sealed matrix of summoning"
	desc = "A greater summoning circle, and the strongest a singular mage can sustain with the lyfeforce from their body, capable of summoning truly terrifying beasts."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "summonadv"
	runesize = 1
	tier = 3
	pixel_x = -32
	pixel_y = -32
	pixel_z = 0
	can_be_scribed = TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/adv/New()
	. = ..()
	rituals.Cut()
	rituals += GLOB.t3summoningrunerituallist

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/max
	name = "grand warded matrix of summoning"
	desc = "A grand summoning circle capable of summoning the strongest and most powerful of creechurs modern mages can manage to reach."
	icon = 'icons/effects/96x96.dmi'
	icon_state = "summonmax"
	runesize = 1
	tier = 5
	pixel_x = -32
	pixel_y = -32
	pixel_z = 0
	can_be_scribed = TRUE

/obj/effect/decal/cleanable/roguerune/arcyne/summoning/max/New()
	. = ..()
	rituals.Cut()
	rituals += GLOB.t4summoningrunerituallist

/obj/effect/decal/cleanable/roguerune/divine	//To be used for divine rituals.
	magictype = "divine"
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/roguerune/divine/attack_hand(mob/living/user)
	if(!isdivine(user))
		to_chat(user, span_warning("You aren't able to understand the words of [src]."))
		return
	. = ..()


/obj/effect/decal/cleanable/roguerune/druid		//to be used with druid magick
	magictype = "druid"
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/roguerune/druid/attack_hand(mob/living/user)
	if(!isdruid(user))
		to_chat(user, span_warning("You aren't able to understand the words of [src]."))
		return
	. = ..()

/obj/effect/decal/cleanable/roguerune/blood		//to be used with blood magick
	magictype = "blood"
	can_be_scribed = FALSE

/obj/effect/decal/cleanable/roguerune/blood/attack_hand(mob/living/user)
	if(!isblood(user))
		to_chat(user, span_warning("You aren't able to understand the words of [src]."))
		return
	. = ..()

#undef QDEL_LIST_CONTENTS
