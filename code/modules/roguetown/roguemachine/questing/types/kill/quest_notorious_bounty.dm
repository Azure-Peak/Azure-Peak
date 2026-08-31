/datum/quest/kill/notorious_bounty
	quest_type = QUEST_NOTORIOUS_BOUNTY
	quest_difficulty = QUEST_DIFFICULTY_NOTORIOUS
	tp_budget = QUEST_TP_BUDGET_NOTORIOUS_GOONS
	threat_bands_cleared = QUEST_BANDS_NOTORIOUS
	required_fellowship_size = 2
	var/boss_name
	var/datum/weakref/boss_ref
	var/turf/leash_origin
	var/datum/weakref/fellowship_ref
	var/list/goon_refs = list()
	var/list/marked_hunters = list()
	var/hunter_mark_key
	var/hunter_marks_seeded = FALSE
	var/hunt_engaged = FALSE
	var/boss_paid = FALSE

/datum/quest/kill/notorious_bounty/Destroy()
	clear_hunter_marks()
	clear_boss_marker()
	return ..()

/datum/quest/kill/notorious_bounty/mark_complete()
	..()
	clear_hunter_marks()
	clear_boss_marker()

/datum/quest/kill/notorious_bounty/on_hunt_timeout()
	if(complete)
		return ..()
	pay_out_boss(boss_ref?.resolve())
	succour_fallen_hunters()
	despawn_gang()
	return ..()

/datum/quest/kill/notorious_bounty/on_claim(mob/user)
	. = ..()
	var/mob/living/claimant = user
	if(istype(claimant) && claimant.current_fellowship)
		fellowship_ref = WEAKREF(claimant.current_fellowship)

/datum/quest/kill/notorious_bounty/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	pending_landmark_ref = WEAKREF(landmark)
	target_spawn_area = get_area_name(get_turf(landmark))
	region = landmark.region
	var/datum/threat_region/TR = SSregionthreat.get_region(region)
	if(!TR)
		return FALSE
	faction = pick_region_faction_for(TR)
	if(!faction)
		return FALSE
	faction_id = faction.id
	var/list/boss_pool = faction.get_playable_boss_types()
	if(!length(boss_pool))
		return FALSE
	target_mob_type = pickweight(boss_pool)
	boss_name = faction.generate_boss_name()
	progress_required = 1
	finalize_preview_title()
	return TRUE

/datum/quest/kill/notorious_bounty/get_named_target()
	return boss_name

/datum/quest/kill/notorious_bounty/get_title()
	if(title)
		return title
	if(!boss_name)
		return "Bring down a notorious outlaw"
	return "Bring down [boss_name]"


/datum/quest/kill/notorious_bounty/get_objective_text()
	return "Slay the target, but be warned! They are rumored to be a truly formidable opponent!"

/datum/quest/kill/notorious_bounty/get_additional_reward(turf/origin_turf, turf/target_turf)
	if(!target_mob_type)
		return 0
	var/boss_threat = initial(target_mob_type.threat_point) || 0
	var/goon_threat = (total_spawned_tp > 0) ? total_spawned_tp : tp_budget
	return (boss_threat * QUEST_NOTORIOUS_BOUNTY_THREAT_MULT) + (goon_threat * QUEST_KILL_THREAT_MULT)

/datum/quest/kill/notorious_bounty/estimate_mob_count()
	return 1

/datum/quest/kill/notorious_bounty/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!faction)
		return FALSE
	spawn_boss(landmark)
	spawn_goons(landmark, tp_budget, NOTORIOUS_BOUNTY_GOON_CAP)
	progress_required = 1
	// Rename after a delay so subtype after_creation() timers don't clobber it.
	addtimer(CALLBACK(src, PROC_REF(apply_boss_name)), 2 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(preserve_boss_corpse)), 2 SECONDS)
	return TRUE

/datum/quest/kill/notorious_bounty/proc/spawn_boss(obj/effect/landmark/quest_spawner/landmark)
	var/turf/spawn_turf = landmark.get_safe_spawn_turf()
	if(!spawn_turf)
		return
	var/obj/effect/quest_spawn/notorious/spawn_effect = new /obj/effect/quest_spawn/notorious(spawn_turf)
	var/mob/living/boss = new target_mob_type(spawn_effect)
	boss.faction |= "quest"
	if(faction?.faction_tag)
		boss.faction |= faction.faction_tag
	boss.mark_contract_spawned(dust_corpse = FALSE)
	grant_darkvision(boss)
	boss.AddComponent(/datum/component/quest_object/kill, src)
	ADD_TRAIT(boss, TRAIT_FRESHSPAWN, "[type]")
	addtimer(TRAIT_CALLBACK_REMOVE(boss, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
	spawn_effect.contained_atom = boss
	spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
	register_spawner(spawn_effect)
	add_tracked_atom(boss)
	boss_ref = WEAKREF(boss)

/datum/quest/kill/notorious_bounty/proc/spawn_goons(obj/effect/landmark/quest_spawner/landmark, budget, cap, immediate = FALSE)
	var/saved_budget = tp_budget
	tp_budget = budget
	var/list/to_spawn = compose_warband()
	tp_budget = saved_budget
	if(length(to_spawn) > cap)
		to_spawn.Cut(cap + 1)
	for(var/goon_type in to_spawn)
		var/turf/spawn_turf = landmark.get_safe_spawn_turf()
		if(!spawn_turf)
			continue
		var/mob/living/goon
		if(immediate)
			goon = new goon_type(spawn_turf)
		else
			var/obj/effect/quest_spawn/spawn_effect = new /obj/effect/quest_spawn(spawn_turf)
			goon = new goon_type(spawn_effect)
			spawn_effect.contained_atom = goon
			spawn_effect.AddComponent(/datum/component/quest_object/mob_spawner, src)
			register_spawner(spawn_effect)
		goon.faction |= "quest"
		if(faction?.faction_tag)
			goon.faction |= faction.faction_tag
		goon.mark_contract_spawned()
		grant_darkvision(goon)
		ADD_TRAIT(goon, TRAIT_FRESHSPAWN, "[type]")
		addtimer(TRAIT_CALLBACK_REMOVE(goon, TRAIT_FRESHSPAWN, "[type]"), 60 SECONDS)
		goon_refs += WEAKREF(goon)
		total_spawned_tp += initial(goon.threat_point) || 0

/datum/quest/kill/notorious_bounty/proc/spawn_reinforcements()
	var/obj/effect/landmark/quest_spawner/landmark = pending_landmark_ref?.resolve()
	if(QDELETED(landmark))
		return
	spawn_goons(landmark, NOTORIOUS_BOUNTY_REINFORCE_TP, NOTORIOUS_BOUNTY_REINFORCE_CAP, immediate = TRUE)
	reward_amount += NOTORIOUS_BOUNTY_NPC_BONUS
	quest_scroll?.update_quest_text()
	announce_to_bearer("<b>The outlaw's gang arrives.</b> The bounty on [boss_name] grows by [NOTORIOUS_BOUNTY_NPC_BONUS] mammons.")

/datum/quest/kill/notorious_bounty/proc/preserve_boss_corpse()
	var/mob/living/M = boss_ref?.resolve()
	if(QDELETED(M))
		return
	REMOVE_TRAIT(M, TRAIT_DUSTABLE, TRAIT_GENERIC)
	REMOVE_TRAIT(M, TRAIT_DUST_DELETE_GEAR, TRAIT_GENERIC)
	REMOVE_TRAIT(M, TRAIT_DUST_LEAVE_HEAD, TRAIT_GENERIC)

/datum/quest/kill/notorious_bounty/proc/apply_boss_name()
	var/mob/living/M = boss_ref?.resolve()
	if(QDELETED(M))
		return
	M.real_name = boss_name
	M.name = boss_name

/datum/quest/kill/notorious_bounty/proc/offer_boss_control(mob/living/carbon/human/boss)
	if(QDELETED(boss) || boss.stat == DEAD || boss.client || complete || failed)
		return
	var/list/candidates = pollGhostCandidates("A hunting party stalks [boss_name || "a notorious bounty"]! Will you take up the mantle of the hunted and defend yourself?", ROLE_NOTORIOUS_BOUNTY, null, null, NOTORIOUS_BOUNTY_POLL_TIME, POLL_IGNORE_NOTORIOUS_BOUNTY, poll_width = NOTORIOUS_BOUNTY_POLL_WIDTH, poll_height = NOTORIOUS_BOUNTY_POLL_HEIGHT)
	if(QDELETED(boss) || boss.stat == DEAD || boss.client || complete || failed)
		return
	// Only true dead mobs (observers, lobby) - a spirit's key belongs to a body elsewhere.
	var/list/eligible = list()
	for(var/mob/dead/M in candidates)
		if(M.key)
			eligible += M
	if(!length(eligible))
		spawn_reinforcements()
		return
	var/mob/dead/chosen = pick(eligible)
	if(istype(chosen, /mob/dead/new_player))
		var/mob/dead/new_player/N = chosen
		N.close_spawn_windows()
	boss.key = chosen.key
	RegisterSignal(boss, COMSIG_LIVING_DEATH, PROC_REF(on_player_boss_death))
	// Prevent the mob from getting instaambushed
	boss.ambushable = FALSE
	REMOVE_TRAIT(boss, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(boss, TRAIT_TEMPO, TRAIT_GENERIC)
	boss.adjust_skillrank(/datum/skill/misc/tracking, 6, TRUE) //You should be able to hunt your hunters back!
	boss.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	boss.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	boss.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	// Signals to hunters that a player has taken the reins.
	boss.add_filter("notorious_bounty_outline", 1, list("type" = "drop_shadow", "color" = "#ffee00", "size" = 0.1))
	leash_origin = get_turf(boss)
	unlock_boss_gear(boss)
	boss.update_sight()
	refresh_hunter_marks()
	reward_amount += NOTORIOUS_BOUNTY_PLAYER_BONUS
	quest_scroll?.update_quest_text()
	announce_to_bearer("<b>[boss_name] has been warned of you.</b> The bounty rises by [NOTORIOUS_BOUNTY_PLAYER_BONUS] mammons.")
	to_chat(boss, span_danger("You are [boss_name]. Someone signed a writ for your head and the hunting party is on its way."))
	to_chat(boss, span_danger("You cannot leave this ground. Hold out [NOTORIOUS_BOUNTY_CONTROL_TIME / (1 MINUTES)] minutes, or break them, and you are paid [NOTORIOUS_BOUNTY_SURVIVAL_TRIUMPH] TRIUMPH. Hiding pays nothing - they have to come at you and fail."))
	to_chat(boss, span_boldnotice("Kill them if you must, but do not round-remove them. Follow escalation rules. You may join any fight your gang has already started."))
	to_chat(boss, span_boldnotice("Your hunters are marked. [describe_hunting_party()]"))
	var/turf/boss_turf = get_turf(boss)
	var/mob/living/bearer = quest_receiver_reference?.resolve()
	var/datum/fellowship/F = bearer?.current_fellowship
	var/mob/living/party_leader = F?.get_leader()
	message_admins("[key_name_admin(boss)] has taken over notorious bounty '[boss_name]' at [ADMIN_COORDJMP(boss_turf)] ([region]), fighting a fellowship led by [party_leader ? key_name_admin(party_leader) : "an unknown party"].")
	addtimer(CALLBACK(src, PROC_REF(release_boss)), NOTORIOUS_BOUNTY_CONTROL_TIME)
	leash_boss()

/datum/quest/kill/notorious_bounty/proc/leash_boss()
	var/mob/living/boss = boss_ref?.resolve()
	if(QDELETED(boss))
		return
	if(boss.stat == DEAD)
		release_dead_boss(boss)
		return
	var/turf/T = get_turf(boss)
	if(T && leash_origin && (T.z != leash_origin.z || get_dist(T, leash_origin) > NOTORIOUS_BOUNTY_LEASH_RANGE))
		boss.forceMove(leash_origin)
		to_chat(boss, span_userdanger("An unknown force drags you back. Stand and fight."))
	check_hunt_engaged(boss)
	refresh_hunter_marks()
	addtimer(CALLBACK(src, PROC_REF(leash_boss)), NOTORIOUS_BOUNTY_LEASH_INTERVAL)

/datum/quest/kill/notorious_bounty/proc/release_boss()
	var/mob/living/boss = boss_ref?.resolve()
	if(QDELETED(boss) || boss.stat == DEAD || !boss.client)
		return
	if(!pay_out_boss(boss))
		to_chat(boss, span_warning("The hunters never came for you."))
	succour_fallen_hunters()
	to_chat(boss, span_warning("The writ is over. You escapes back to safety."))
	clear_hunter_marks()
	clear_boss_marker()
	boss.ghostize(FALSE)
	ADD_TRAIT(boss, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)

/datum/quest/kill/notorious_bounty/proc/on_player_boss_death(datum/source, gibbed)
	SIGNAL_HANDLER
	var/mob/living/boss = source
	if(QDELETED(boss) || !boss.client)
		return
	if(gibbed)
		INVOKE_ASYNC(src, PROC_REF(release_dead_boss), boss)
		return
	to_chat(boss, span_userdanger("Your lyfe and notoriety ends here. Your spirit wists away..."))
	addtimer(CALLBACK(src, PROC_REF(release_dead_boss), boss), NOTORIOUS_BOUNTY_DEATH_RELEASE)

/datum/quest/kill/notorious_bounty/proc/release_dead_boss(mob/living/boss)
	if(QDELETED(boss))
		boss = boss_ref?.resolve()
	if(QDELETED(boss) || !boss.client || boss.stat != DEAD)
		return
	UnregisterSignal(boss, COMSIG_LIVING_DEATH)
	clear_hunter_marks()
	clear_boss_marker()
	to_chat(boss, span_warning("You spirit slips free. Watch the last of the hunt, or move to Necra's embrace and dream of a new lyfe."))
	message_admins("[key_name_admin(boss)] was released from notorious bounty '[boss_name]' after dying to the hunting party")
	boss.ghostize(FALSE)
	ADD_TRAIT(boss, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)

/datum/quest/kill/notorious_bounty/proc/get_hunting_party()
	var/list/party = list()
	var/mob/living/bearer = quest_receiver_reference?.resolve()
	if(!QDELETED(bearer))
		party |= bearer
	var/datum/fellowship/F = fellowship_ref?.resolve()
	if(!F && bearer?.current_fellowship)
		F = bearer.current_fellowship
		fellowship_ref = WEAKREF(F)
	if(F)
		for(var/mob/living/M as anything in F.get_members())
			if(!QDELETED(M))
				party |= M
	return party

/datum/quest/kill/notorious_bounty/proc/describe_hunting_party()
	var/mob/living/bearer = quest_receiver_reference?.resolve()
	var/list/names = list()
	for(var/mob/living/M as anything in get_hunting_party())
		names += (M == bearer) ? "[M.real_name] (writ-bearer)" : M.real_name
	if(!length(names))
		return "None of them have shown themselves yet."
	return "They are [english_list(names)]."

/datum/quest/kill/notorious_bounty/proc/refresh_hunter_marks()
	var/mob/living/boss = boss_ref?.resolve()
	if(QDELETED(boss) || !boss.client || complete || failed)
		clear_hunter_marks()
		return
	if(!hunter_mark_key)
		hunter_mark_key = "notorious_hunter_[REF(src)]"
	var/list/party = get_hunting_party()
	var/list/kept = list()
	for(var/datum/weakref/W as anything in marked_hunters)
		var/mob/living/M = W.resolve()
		if(QDELETED(M))
			continue
		if(M in party)
			kept += W
			continue
		M.remove_alt_appearance(hunter_mark_key)
	marked_hunters = kept
	for(var/mob/living/M as anything in party)
		if(LAZYACCESS(M.alternate_appearances, hunter_mark_key))
			continue
		var/image/mark = image('icons/mob/hud.dmi', M, "fugitive_hunter")
		mark.appearance_flags = RESET_COLOR|RESET_TRANSFORM
		M.add_alt_appearance(/datum/atom_hud/alternate_appearance/basic/onePerson, hunter_mark_key, mark, boss)
		marked_hunters += WEAKREF(M)
		if(hunter_marks_seeded)
			to_chat(boss, span_boldnotice("[M.real_name] has joined the hunt for you."))
	hunter_marks_seeded = TRUE

/datum/quest/kill/notorious_bounty/proc/clear_hunter_marks()
	if(!hunter_mark_key)
		return
	for(var/datum/weakref/W as anything in marked_hunters)
		var/mob/living/M = W.resolve()
		if(!QDELETED(M))
			M.remove_alt_appearance(hunter_mark_key)
	marked_hunters.Cut()

/datum/quest/kill/notorious_bounty/proc/despawn_gang()
	for(var/datum/weakref/W as anything in goon_refs)
		var/mob/living/M = W.resolve()
		if(QDELETED(M) || M.stat == DEAD)
			continue
		if(M.client)
			M.ghostize(FALSE)
		qdel(M)
	goon_refs.Cut()

/datum/quest/kill/notorious_bounty/proc/check_hunt_engaged(mob/living/boss)
	if(hunt_engaged || QDELETED(boss))
		return
	var/turf/boss_turf = get_turf(boss)
	if(!boss_turf)
		return
	for(var/mob/living/M as anything in get_hunting_party())
		var/turf/hunter_turf = get_turf(M)
		if(!hunter_turf || hunter_turf.z != boss_turf.z)
			continue
		if(get_dist(hunter_turf, boss_turf) > NOTORIOUS_BOUNTY_ENGAGE_RANGE)
			continue
		hunt_engaged = TRUE
		return

/datum/quest/kill/notorious_bounty/proc/succour_fallen_hunters()
	if(!hunt_engaged || !leash_origin)
		return
	for(var/mob/living/M as anything in get_hunting_party())
		if(QDELETED(M) || M.stat == CONSCIOUS)
			continue
		var/turf/hunter_turf = get_turf(M)
		if(!hunter_turf || hunter_turf.z != leash_origin.z)
			continue
		if(get_dist(hunter_turf, leash_origin) > NOTORIOUS_BOUNTY_LEASH_RANGE)
			continue
		if(M.stat == DEAD)
			M.revive(full_heal = TRUE, admin_revive = TRUE)
			to_chat(M, span_boldnotice("The writ spends the last of its magicka dragging you back from Necra's door. You draw breath again."))
			continue
		M.fully_heal()
		to_chat(M, span_boldnotice("The writ spends the last of its magicka keeping you breathing. You come to."))

/datum/quest/kill/notorious_bounty/proc/grant_darkvision(mob/living/M)
	if(QDELETED(M))
		return
	ADD_TRAIT(M, TRAIT_DARKVISION, "[type]")
	M.update_sight()

/datum/quest/kill/notorious_bounty/proc/clear_boss_marker()
	var/mob/living/boss = boss_ref?.resolve()
	if(QDELETED(boss))
		return
	boss.remove_filter("notorious_bounty_outline")

/datum/quest/kill/notorious_bounty/proc/unlock_boss_gear(mob/living/carbon/human/boss)
	if(!istype(boss))
		return
	for(var/obj/item/gear in boss.get_equipped_items() + boss.held_items)
		var/datum/component/item_on_drop/unlock/lock = gear.GetComponent(/datum/component/item_on_drop/unlock)
		if(!lock)
			continue
		REMOVE_TRAIT(gear, TRAIT_NODROP, lock.lock_source)
		qdel(lock)

//TODO(flavor): Boss outlasted the hunt and is paid. Should land as a win.
/datum/quest/kill/notorious_bounty/proc/pay_out_boss(mob/living/boss)
	if(boss_paid || !hunt_engaged)
		return FALSE
	if(QDELETED(boss) || !boss.client || boss.stat == DEAD)
		return FALSE
	boss_paid = TRUE
	var/turf/boss_turf = get_turf(boss)
	to_chat(boss, span_danger("<b>The hunting party came for you and could not finish you. You escape to safety - [NOTORIOUS_BOUNTY_SURVIVAL_TRIUMPH] TRIUMPH is yours.</b>"))
	boss.adjust_triumphs(NOTORIOUS_BOUNTY_SURVIVAL_TRIUMPH, TRUE, "notorious bounty: outlasted the hunt")
	message_admins("[key_name_admin(boss)] outlasted notorious bounty '[boss_name]' at [ADMIN_COORDJMP(boss_turf)] ([region]).")
	return TRUE
