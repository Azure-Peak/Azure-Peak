/datum/quest
	var/title = ""
	var/datum/weakref/quest_giver_reference
	var/quest_giver_name = ""
	var/datum/weakref/quest_receiver_reference
	var/quest_receiver_name = ""
	var/quest_type = ""
	var/quest_difficulty = ""
	var/reward_amount = 0
	var/deposit_amount = 0
	var/complete = FALSE

	/// Where this contract originated. See QUEST_SOURCE_* defines.
	var/source = QUEST_SOURCE_HANDLER
	/// world.time when the quest was created. Used by SSquestpool to expire stale listings.
	var/created_at = 0
	/// GLOB.dayspassed at creation - IC date captured for scroll display.
	var/issued_day = 0

	/// Progress tracking
	var/progress_current = 0
	var/progress_required = 1

	/// Target item type for fetch quests
	var/obj/item/target_item_type
	/// Target item type for courier quests
	var/obj/item/target_delivery_item
	/// Target mob type for kill quests
	var/mob/living/target_mob_type
	/// Location for courier quests
	var/area/rogue/indoors/town/target_delivery_location
	/// Location name for kill/clear quests
	var/target_spawn_area = ""

	/// Scroll icon state
	var/quest_icon = "scroll_quest"

	/// Fallback reference to the spawned scroll
	var/obj/item/quest_writ/quest_scroll
	/// Weak reference to the quest scroll
	var/datum/weakref/quest_scroll_ref
	/// List of weakrefs to actual quest items/mobs for reducing overhead of compass.
	var/list/datum/weakref/tracked_atoms = list()
	/// Landmark picked at preview time; materialize() spawns content around it when claimed.
	var/datum/weakref/pending_landmark_ref
	/// Threat region this quest's content lives in. Captured from the landmark at preview time.
	var/region = ""
	/// Quest faction id (see QUEST_FACTION_* defines). Captured at preview for kill / bounty quests.
	var/faction_id
	/// Resolved faction datum for the run. Non-null for kill / bounty quests.
	var/datum/quest_faction/faction
	/// Minimum fellowship size required to sign this quest. 0 means solo-allowed. Only the
	/// signer pays the take-cooldown cost; fellowship-mates are free labor.
	var/required_fellowship_size = 0
	/// If TRUE, the crown levy is skipped at turn-in. Stamped by a Steward on specific contracts
	/// as a personal favor, or set at preview by Module 6 towner-to-towner bounties.
	/// TODO: Implement new taxation mechanics — Module 3/6 will add the stamping UI and towner
	/// bounty path. Levy rate itself also needs revisiting under the new treasury design.
	var/levy_exempt = FALSE
	/// TRUE if the Steward issued this as a free-labor Directive (no funding, zero reward,
	/// hand-carried only, not promotable to the public noticeboard).
	var/is_directive = FALSE
	/// Weakrefs to this quest's `/obj/effect/quest_spawn` pods — used to pop the whole encounter at once.
	var/list/datum/weakref/spawners = list()
	var/list/rolled_crimes
	var/sacral_hook = FALSE
	var/oath_breach = FALSE
	var/condemnation_variant = ""
	var/band_leader_name = ""
	var/writ_type = WRIT_TYPE_OUTLAWRY
	var/circumstance_text = ""

/datum/quest/Destroy()
	// Clean up mobs with quest components
	for(var/mob/living/M in GLOB.mob_list)
		var/datum/component/quest_object/Q = M.GetComponent(/datum/component/quest_object)
		if(Q && Q.quest_ref?.resolve() == src)
			M.remove_filter("quest_item_outline")
			qdel(Q)

	for(var/datum/weakref/tracked_weakref in tracked_atoms)
		var/atom/target_atom = tracked_weakref.resolve()
		if(QDELETED(target_atom))
			continue

		// Only delete the item if it's part of a fetch or courier quest
		if(quest_type == QUEST_RETRIEVAL && istype(target_atom, target_item_type))
			qdel(target_atom)
		else if(quest_type == QUEST_COURIER && istype(target_atom, target_delivery_item))
			qdel(target_atom)

		tracked_atoms -= tracked_weakref
		qdel(tracked_weakref)

	// Clean up references
	quest_scroll = null
	if(quest_scroll_ref)
		var/obj/item/quest_writ/Q = quest_scroll_ref.resolve()
		if(Q && !QDELETED(Q))
			Q.assigned_quest = null
			qdel(Q)
		quest_scroll_ref = null
		
	return ..()

/datum/quest/proc/add_tracked_atom(atom/movable/to_track)
	tracked_atoms += WEAKREF(to_track)

/// Lightweight pre-generation: pick templates and set display fields, but DO NOT mutate the
/// world. Called by SSquestpool.generate_one so pool contracts don't spawn mobs/items until
/// someone claims them. Subtypes override to set target_mob_type, target_item_type, etc.
/datum/quest/proc/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	pending_landmark_ref = WEAKREF(landmark)
	target_spawn_area = get_area_name(get_turf(landmark))
	region = landmark.region
	return TRUE

/// Called by subtypes at end of preview() once faction / target / etc. are set.
/datum/quest/proc/finalize_preview_title()
	if(!title)
		title = get_title()
	if(!rolled_crimes && faction)
		faction.compose_preamble(src)
	if(!circumstance_text)
		circumstance_text = roll_circumstance()

/datum/quest/proc/roll_circumstance()
	switch(writ_type)
		if(WRIT_TYPE_RECOVERY)
			return pick_recovery_circumstance()
		if(WRIT_TYPE_CARRIAGE)
			return pick_carriage_circumstance()
	return ""

/datum/quest/proc/get_named_target()
	return null

/datum/quest/proc/get_recovery_shipment_name()
	return null

/// Registers a quest_spawn pod so pop_all_spawners() can trigger the whole encounter at once.
/datum/quest/proc/register_spawner(obj/effect/quest_spawn/spawner)
	spawners += WEAKREF(spawner)

/// Materializes every live spawner belonging to this quest. Called when any one of them triggers.
/datum/quest/proc/pop_all_spawners()
	for(var/datum/weakref/ref in spawners)
		var/obj/effect/quest_spawn/spawner = ref.resolve()
		if(QDELETED(spawner) || !spawner.contained_atom)
			continue
		spawner.reveal_contained()
	spawners.Cut()

/// World-mutating generation: spawn mobs, items, parcels. Called by SSquestpool.claim when the
/// contract is actually signed. Subtypes override to do their specific spawns.
/datum/quest/proc/materialize(obj/effect/landmark/quest_spawner/landmark)
	return TRUE

/// Get the quest title - override in subtypes for dynamic titles
/datum/quest/proc/get_title()
	return title

/// Get objective text for scroll display
/datum/quest/proc/get_objective_text()
	return "Complete the objective."

/// Hook for subtypes that need to stream live fields into the TGUI scroll view (e.g.
/// blockade's wave timer). Subtypes mutate the passed list. Base does nothing.
/datum/quest/proc/populate_scroll_ui_data(list/data)
	return

/// Static counterpart. Subtypes must pair changes with quest_scroll?.update_quest_text().
/datum/quest/proc/populate_scroll_ui_static_data(list/data)
	return

/// Check if quest objectives are complete
/datum/quest/proc/check_completion()
	return progress_current >= progress_required

/// Called when progress is updated. progress_current lives in ui_data and streams via
/// the next TGUI tick — no need to push static data on every kill.
/datum/quest/proc/on_progress_update()
	if(check_completion())
		mark_complete()

/// Mark quest as complete
/datum/quest/proc/mark_complete()
	complete = TRUE
	quest_scroll?.update_quest_text()

// Flat "you showed up" base, same for every quest regardless of difficulty. Difficulty
// expresses itself through tp_budget (kill types) and distance/items (courier/retrieval).
/datum/quest/proc/get_base_reward()
	return QUEST_REWARD_BASE_FLAT

/datum/quest/proc/get_additional_reward(turf/origin_turf, turf/target_turf)
	return 0

/datum/quest/proc/calculate_reward(turf/origin_turf, turf/target_turf)
	var/base = get_base_reward()
	var/additional = get_additional_reward(origin_turf, target_turf)
	return base + additional

/// Calculate deposit based on difficulty
/datum/quest/proc/calculate_deposit()
	switch(quest_difficulty)
		if(QUEST_DIFFICULTY_EASY)
			return QUEST_DEPOSIT_EASY
		if(QUEST_DIFFICULTY_MEDIUM)
			return QUEST_DEPOSIT_MEDIUM
		if(QUEST_DIFFICULTY_HARD)
			return QUEST_DEPOSIT_HARD
	return 0

/// Get icon for scroll based on difficulty
/datum/quest/proc/get_scroll_icon()
	switch(quest_difficulty)
		if(QUEST_DIFFICULTY_EASY)
			return "scroll_quest_low"
		if(QUEST_DIFFICULTY_MEDIUM)
			return "scroll_quest_mid"
		if(QUEST_DIFFICULTY_HARD)
			return "scroll_quest_high"
	return quest_icon

/// Get target location for compass - returns turf of nearest tracked atom
/datum/quest/proc/get_target_location()
	var/turf/user_turf = quest_scroll ? get_turf(quest_scroll) : null
	if(!user_turf)
		return null

	var/turf/closest
	var/min_dist = INFINITY

	for(var/datum/weakref/ref in tracked_atoms)
		var/atom/A = ref.resolve()
		if(!A || QDELETED(A))
			continue

		var/turf/A_turf = get_turf(A)
		if(!A_turf)
			continue

		var/dist = get_dist(user_turf, A_turf)
		if(dist < min_dist)
			min_dist = dist
			closest = A_turf

	return closest

/// Check if a user can claim this quest - override for restrictions
/datum/quest/proc/can_claim(mob/living/user)
	if(required_fellowship_size > 0)
		var/datum/fellowship/F = user?.current_fellowship
		if(!F)
			return FALSE
		if(length(F.get_members()) < required_fellowship_size)
			return FALSE
	return TRUE

/// Human-readable reason why can_claim failed, shown to the user at sign time.
/datum/quest/proc/claim_failure_reason(mob/living/user)
	if(required_fellowship_size > 0)
		var/datum/fellowship/F = user?.current_fellowship
		if(!F)
			return "This contract requires a Fellowship of [required_fellowship_size]."
		if(length(F.get_members()) < required_fellowship_size)
			return "Your Fellowship is too small - requires [required_fellowship_size] members."
	return "You cannot sign that contract."

/// Called when quest is claimed by a user
/datum/quest/proc/on_claim(mob/user)
	quest_receiver_reference = WEAKREF(user)
	quest_receiver_name = user.real_name
