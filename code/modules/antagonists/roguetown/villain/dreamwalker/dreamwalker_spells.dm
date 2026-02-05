
/obj/effect/proc_holder/spell/invoked/mark_target
	name = "Mark Target"
	desc = "Marks a random target for pursuit. Track them, extract metal from their mind with the -TRACK- spell you'll gain to complete your vision. Hit them with a dream weapon to summon them to you later."
	releasedrain = 75
	chargedrain = 1
	chargetime = 1.5 SECONDS
	recharge_time = 25 MINUTES
	overlay_state = "dream_mark"
	invocations = list("Dream... manifest my vision, bend to my will.")
	invocation_type = "whisper"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	associated_skill = /datum/skill/magic/arcane

	// Define roles that are considered valid targets
	// Generally combat ready roles connected to a larger faction.
	var/static/list/valid_target_roles = list(
		"Orthodoxist",
		"Absolver",
		"Templar",
		"Sergeant",
		"Men-at-arms",
		"Knight",
		"Squire",
		"Mercenary",
		"Warden",
	)

	var/mob/living/marked_target = null
	var/obj/effect/proc_holder/spell/invoked/track_mark/tracking_spell = null

/obj/effect/proc_holder/spell/invoked/mark_target/Destroy()
	remove_mark()
	return ..()

/obj/effect/proc_holder/spell/invoked/mark_target/cast(list/targets, mob/user)
	var/mob/living/target = targets[1]

	var/datum/component/dreamwalker_mark/mark_component = user.GetComponent(/datum/component/dreamwalker_mark)
	if(!mark_component)
		mark_component = user.AddComponent(/datum/component/dreamwalker_mark)

	// Uncomment below for debugging purposes.
	// if(target == user || ishuman(target))
	// 	to_chat(user, span_warning("You mark [target] for testing purposes!"))
	// 	if(marked_target)
	// 		remove_mark()
	// 	// Apply new mark
	// 	marked_target = target
	// 	tracking_spell = new()
	// 	tracking_spell.marked_target = marked_target
	// 	tracking_spell.parent_spell = src
	// 	user.mind.AddSpell(tracking_spell)
	// 	mark_component.set_marked_target(marked_target)
	// 	return TRUE

	var/list/valid_targets = get_valid_targets(user)
	if(!length(valid_targets))
		to_chat(user, span_warning("No valid targets found."))
		revert_cast()
		return
	target = pick(valid_targets)
	to_chat(user, span_notice("The spell seeks out a worthy target..."))

	// Remove previous mark if it exists
	if(marked_target)
		remove_mark()
	// Apply new mark
	marked_target = target
	tracking_spell = new()
	tracking_spell.marked_target = marked_target
	tracking_spell.parent_spell = src
	user.mind.AddSpell(tracking_spell)
	mark_component.set_marked_target(marked_target)

	if(marked_target != user)
		to_chat(user, span_warning("[user] traces a glowing symbol in the air marking [marked_target]."), 
							 span_notice("You mark [marked_target] for pursuit."))

	return TRUE

/obj/effect/proc_holder/spell/invoked/mark_target/proc/get_valid_targets(mob/user)
	var/list/valid_targets = list()
	
	for(var/mob/living/carbon/human/player in GLOB.player_list)
		if(player == user || player.stat == DEAD || !player.mind || !player.client || player == marked_target)
			continue
		if(player.mind.assigned_role in valid_target_roles)
			valid_targets += player
	return valid_targets

/obj/effect/proc_holder/spell/invoked/mark_target/proc/is_valid_target(mob/living/target)
	if(!ishuman(target) || target.stat == DEAD || !target.mind || !target.client)
		return FALSE
	return (target.mind.assigned_role in valid_target_roles)

/obj/effect/proc_holder/spell/invoked/mark_target/proc/remove_mark()
	if(marked_target)
		marked_target = null
	if(tracking_spell && usr && usr.mind)
		usr.mind.RemoveSpell(tracking_spell)
		tracking_spell = null

/obj/effect/proc_holder/spell/invoked/track_mark
	name = "Track Marked Target"
	desc = "Track your mark. They must be downed for you to extract metal. Cast this spell whilst adjacent to do so."
	recharge_time = 2 SECONDS
	var/mob/living/marked_target = null
	var/obj/effect/proc_holder/spell/invoked/mark_target/parent_spell = null
	releasedrain = 75
	chargedrain = 1
	chargetime = 0
	overlay_state = "dream_track"
	invocations = list("Dream... Find them.")
	invocation_type = "whisper"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 1
	associated_skill = /datum/skill/magic/arcane

/obj/effect/proc_holder/spell/invoked/track_mark/cast(list/targets, mob/user)
	if(!marked_target)
		to_chat(user, span_warning("The mark has faded!"))
		user.mind.RemoveSpell(src)
		return

	var/turf/user_turf = get_turf(user)
	var/turf/target_turf = get_turf(marked_target)

	if(user_turf.z != target_turf.z)
		// Different z-level
		var/z_direction = "unknown"
		if(user_turf.z > target_turf.z)
			z_direction = "below"
		else
			z_direction = "above"

		to_chat(user, span_notice("The target is on a level [z_direction] you."))
	else
		// Same z-level
		var/distance = get_dist(user, marked_target)
		var/direction = get_dir(user, marked_target)

		if(distance == 0)
			to_chat(user, span_notice("The target is here!"))
		else
			var/direction_text = dir2text(direction)
			to_chat(user, span_notice("The target is [distance] tiles away to the [direction_text]."))

	// Check if the target is downed and adjacent
	if(user.Adjacent(marked_target) && !(marked_target.mobility_flags & MOBILITY_STAND) && !marked_target.buckled)
		to_chat(user, span_notice("The target is vulnerable. You begin to pull metal from their mind..."))

		if(do_after(user, 1 SECONDS, target = marked_target))
			// Small stun to stop our target from messing with the ingot
			marked_target.Stun(10)
			// Create an ingot
			new /obj/item/ingot/sylveric(get_turf(user))
			marked_target.apply_status_effect(/datum/status_effect/debuff/dreamfiend_curse)
			to_chat(user, span_notice("You successfully manifest an ingot of strange metal using your target's psyche."))

			// Remove the mark
			if(parent_spell)
				parent_spell.remove_mark()
			user.mind.RemoveSpell(src)
		else
			to_chat(user, span_warning("You were interrupted."))

/obj/effect/proc_holder/spell/invoked/jaunt
	name = "Dream Jaunt"
	desc = "Teleports you to a random coastal area after a short channel, leaving a temporary portal behind. You may be followed."
	chargedrain = 0
	chargetime = 2 SECONDS
	recharge_time = 15 MINUTES
	invocation_type = "whisper"
	invocations = list("Whisper of the dream...")
	movement_interrupt = FALSE
	charging_slowdown = 1
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "dream_jaunt"

/obj/effect/proc_holder/spell/invoked/jaunt/cast(list/targets, mob/user)
	var/turf/original_turf = get_turf(user)
	if(!original_turf)
		revert_cast()
		return

	// Find destination area
	var/static/list/possible_areas = list(
		/area/rogue/outdoors/beach,
		/area/rogue/outdoors/beach/north,
		/area/rogue/outdoors/beach/south
	)
	var/area/destination_area = GLOB.areas_by_type[pick(possible_areas)]
	if(!destination_area)
		revert_cast()
		return

	// Find safe turfs in destination area
	var/list/safe_turfs = list()
	for(var/turf/T in get_area_turfs(destination_area))
		if(istype(T, /turf/open/water/ocean/deep))
			continue
		if(T.density)
			continue
		var/valid = TRUE
		for(var/atom/movable/AM in T)
			if(AM.density && AM.anchored)
				valid = FALSE
				break
		if(valid)
			safe_turfs += T

	if(!safe_turfs.len)
		revert_cast()
		return

	var/turf/destination = pick(safe_turfs)
	
	// Create portal at origin
	var/obj/structure/portal_jaunt/portal = new(original_turf)
	portal.linked_turf = destination

	// Teleport user
	if(do_teleport(user, destination))
		// Create return portal at destination
		return TRUE

	qdel(portal)
	revert_cast()
	return FALSE

// Summon marked target spell
/obj/effect/proc_holder/spell/invoked/summon_marked
	name = "Summon Marked"
	desc = "Summons your marked target to your location, leaving a temporary portal behind. Requires the target to be marked for at least 10 minutes."
	chargedrain = 0
	chargetime = 1.5 SECONDS
	recharge_time = 30 SECONDS
	invocation_type = "whisper"
	invocations = list("I invoke the dream connection, come to me!")
	movement_interrupt = FALSE
	charging_slowdown = 1
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "dream_summon"

/obj/effect/proc_holder/spell/invoked/summon_marked/cast(list/targets, mob/user)
	var/datum/component/dreamwalker_mark/mark_component = user.GetComponent(/datum/component/dreamwalker_mark)
	if(!mark_component || !mark_component.marked_target)
		to_chat(user, span_warning("You have no target marked for summoning!"))
		revert_cast()
		return

	// Check if we can summon (10 minutes have passed)
	if(!mark_component.can_summon())
		revert_cast()
		return

	var/mob/living/target = mark_component.marked_target

	if(!target.has_status_effect(/datum/status_effect/dream_mark))
		to_chat(user, span_warning("Your connection with [target] has faded!"))
		revert_cast()
		return

	if(target.stat == DEAD)
		to_chat(user, span_warning("[target] is dead and cannot be summoned!"))
		revert_cast()
		return

	to_chat(target, span_userdanger("YOU CAN FEEL THE DREAMWALKER BEGIN TO SUMMON YOU BY FORCE."))
	if(!do_after(user, 20 SECONDS, FALSE, user))
		to_chat(user, span_warning("You must stand still to summon your target!"))
		// Counts as a finished spellcast to make it impossible to spam your target with messages...
		return TRUE

	var/turf/original_turf = get_turf(target)
	var/turf/destination = get_turf(user)

	if(!original_turf || !destination)
		revert_cast()
		return

	// Create portal at target's original location
	var/obj/structure/portal_jaunt/portal = new(original_turf)
	portal.linked_turf = destination

	// Teleport target
	if(do_teleport(target, destination))
		to_chat(user, span_warning("You summon [target] to your location!"))
		to_chat(target, span_userdanger("You're violently pulled through the dream realm to [user]'s location!"))
		// Reset mark after teleport.
		target.remove_status_effect(/datum/status_effect/dream_mark)
		mark_component.marked_target = null
		return TRUE

	qdel(portal)
	revert_cast()
	return FALSE


/obj/effect/proc_holder/spell/invoked/dream_bind
	name = "Dream Bind"
	desc = "Bind a dream item to your soul, allowing you to summon it at will. Cast on a dream item to bind it, or cast on anything else to summon your bound item."
	chargedrain = 0
	chargetime = 0.5 SECONDS
	recharge_time = 10 SECONDS
	invocation_type = "whisper"
	invocations = list("From dream to hand...")
	movement_interrupt = FALSE
	charging_slowdown = 0
	associated_skill = /datum/skill/magic/arcane
	var/obj/item/bound_item = null
	overlay_state = "dream_bind"

/obj/effect/proc_holder/spell/invoked/dream_bind/cast(list/targets, mob/user)
	var/atom/target = targets[1]

	// If targeting a dream item, bind it
	if(istype(target, /obj/item))
		var/obj/item/dream_item = target
		if(dream_item.item_flags & DREAM_ITEM)
			bound_item = dream_item
			to_chat(user, span_notice("You bind [bound_item] to your soul. You can now summon it at will."))
			return TRUE

	// If not targeting a dream item, try to summon the bound item
	if(!bound_item)
		to_chat(user, span_warning("You don't have any dream item bound!"))
		revert_cast()
		return

	if(bound_item.loc == user) // Already in inventory
		to_chat(user, span_notice("[bound_item] is already in your possession."))
		return

	// Check if the item still exists
	if(QDELETED(bound_item))
		to_chat(user, span_warning("Your bound item has been destroyed!"))
		bound_item = null
		revert_cast()
		return

	// Summon the item to the user's hand
	bound_item.forceMove(get_turf(user))
	user.put_in_hands(bound_item)
	to_chat(user, span_notice("You summon [bound_item] to your hand."))
	return TRUE

//Dream meditation
/obj/effect/proc_holder/spell/invoked/dream_trance
	name = "Dream Trance"
	desc = "Draw dream energy into your being to banish any fatigue."
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	invocation_type = "whisper"
	invocations = list("Humm...")
	movement_interrupt = TRUE
	charging_slowdown = 0
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "dream_lotus"

/obj/effect/proc_holder/spell/invoked/dream_trance/cast(list/targets, mob/user)
	var/mob/living/carbon/human/H = user

	to_chat(user, span_info("I begin meditating."))
	while(TRUE)
		if(do_after(H, 15 SECONDS, FALSE, H))
			H.energy_add(0.2 * H.max_energy)
			H.apply_status_effect(/datum/status_effect/buff/healing, 5)
		else
			to_chat(user, span_info("I must remain still to focus energies and recover."))
			break
