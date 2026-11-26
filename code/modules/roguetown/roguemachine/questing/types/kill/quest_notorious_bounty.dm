/datum/quest/kill/notorious_bounty
	quest_type = QUEST_NOTORIOUS_BOUNTY
	chronicle_order = QUEST_CHRONICLE_ORDER_NOTORIOUS_BOUNTY
	pool_kind = QUEST_POOL_KILL
	pool_weight = QUEST_POOL_WEIGHT_NOTORIOUS_BOUNTY
	rumor_cost = RUMOR_COST_TRIVIAL // Let innkeeper hand it out for cheap
	eligible_regions = list(
		THREAT_REGION_AZURE_GROVE,
		THREAT_REGION_TERRORBOG,
		THREAT_REGION_AZUREAN_COAST,
		THREAT_REGION_MOUNT_DECAP,
		THREAT_REGION_UNDERDARK,
	)
	quest_difficulty = QUEST_DIFFICULTY_NOTORIOUS
	tp_budget = QUEST_TP_BUDGET_NOTORIOUS_GOONS
	threat_bands_cleared = QUEST_BANDS_NOTORIOUS
	fellowship_reward_rate = QUEST_FELLOWSHIP_REWARD_PER_EXTRA
	solo_pay_share = NOTORIOUS_BOUNTY_SOLO_SHARE
	hunt_duration = NOTORIOUS_BOUNTY_HUNT_TIMER
	hunt_overtime_max = 0
	hunt_warn_text = "before the outlaw escapes"
	hunt_timeout_text = "<b>The outlaw has escaped.</b> The scroll crumbles to ash."
	foes_pickable = FALSE
	var/boss_name
	var/datum/weakref/boss_ref
	var/turf/leash_origin
	var/datum/weakref/fellowship_ref
	var/list/goon_refs = list()
	var/list/marked_hunters = list()
	var/hunter_mark_key
	var/hunter_marks_seeded = FALSE
	var/hunt_engaged = FALSE
	var/engaged_ticks = 0
	var/boss_paid = FALSE
	var/takeover_resolved = FALSE
	var/hunt_tick_id
	var/party_down_since = 0
	var/gang_settled = FALSE
	var/ground_active = FALSE
	var/ground_tick_id
	var/list/bound_hunters = list()

/datum/quest/kill/notorious_bounty/Destroy()
	stop_hunt_tick()
	end_ground()
	if(!complete && !failed)
		release_boss()
		despawn_gang()
		despawn_live_hunt_mobs()
	clear_hunter_marks()
	clear_boss_marker()
	return ..()

/datum/quest/kill/notorious_bounty/mark_complete()
	..()
	stop_hunt_tick()
	end_ground()
	clear_hunter_marks()
	clear_boss_marker()
	INVOKE_ASYNC(src, PROC_REF(settle_won_hunt))

/datum/quest/kill/notorious_bounty/proc/settle_won_hunt()
	if(despawn_gang())
		announce_to_party("<b>The gang scatters.</b>")
	hunt_engaged = TRUE
	succour_fallen_hunters()

/datum/quest/kill/notorious_bounty/on_first_pop()
	var/obj/effect/landmark/quest_spawner/landmark = pending_landmark_ref?.resolve()
	settle_fellowship_arrival(landmark)
	spawn_gang(landmark)
	. = ..()
	if(complete || hunt_tick_id)
		return
	scroll_whispers = FALSE
	hunt_tick_id = addtimer(CALLBACK(src, PROC_REF(hunt_tick)), NOTORIOUS_BOUNTY_HUNT_TICK, TIMER_STOPPABLE | TIMER_LOOP)

/datum/quest/kill/notorious_bounty/fail_hunt(message)
	if(complete || failed)
		return
	stop_hunt_tick()
	end_ground()
	release_boss()
	succour_fallen_hunters()
	despawn_gang()
	return ..()

/datum/quest/kill/notorious_bounty/proc/stop_hunt_tick()
	if(!hunt_tick_id)
		return
	deltimer(hunt_tick_id)
	hunt_tick_id = null

/datum/quest/kill/notorious_bounty/proc/hunt_tick()
	if(complete || failed)
		stop_hunt_tick()
		return
	var/mob/living/boss = boss_ref?.resolve()
	if(!QDELETED(boss) && boss.client)
		if(boss.stat == DEAD)
			release_dead_boss(boss)
		refresh_hunter_marks()
		count_engaged_tick(boss)
	whisper_boss_location()
	check_hunt_engaged(boss)
	check_party_wipe()

/datum/quest/kill/notorious_bounty/proc/check_party_wipe()
	var/list/party = ground_active ? get_bound_hunters() : null
	if(!length(party))
		party = get_hunting_party()
	if(!length(party))
		return
	for(var/mob/living/M as anything in party)
		if(M.stat == CONSCIOUS && !M.mind?.has_antag_datum(/datum/antagonist/zombie))
			party_down_since = 0
			return
	if(!party_down_since)
		party_down_since = world.time
	if(world.time - party_down_since < NOTORIOUS_BOUNTY_PARTY_DOWN_GRACE)
		return
	hunt_engaged = TRUE
	fail_hunt("<b>The hunting party has fallen.</b> The scroll crumbles to ash.")

/datum/quest/kill/notorious_bounty/proc/get_bound_hunters()
	. = list()
	var/list/party = get_hunting_party()
	for(var/datum/weakref/W as anything in bound_hunters)
		var/mob/living/M = W.resolve()
		if(M in party)
			. += M

/datum/quest/kill/notorious_bounty/can_claim(mob/living/user)
	if(!SSquestpool.debug_mode && party_has_notorious(user))
		return FALSE
	return ..()

/datum/quest/kill/notorious_bounty/claim_failure_reason(mob/living/user)
	if(party_has_notorious(user))
		return "[user.current_fellowship ? "Your fellowship already has" : "You already have"] a Notorious Bounty. Finish it before signing another."
	return ..()

/datum/quest/kill/notorious_bounty/proc/party_has_notorious(mob/living/user)
	if(!istype(user))
		return FALSE
	var/list/party = list(user)
	if(user.current_fellowship)
		party |= user.current_fellowship.get_members()
	for(var/obj/item/quest_writ/scroll as anything in GLOB.quest_scrolls)
		var/datum/quest/kill/notorious_bounty/Q = scroll.assigned_quest
		if(!istype(Q) || Q == src || Q.complete || Q.failed)
			continue
		if(length(Q.get_hunting_party() & party))
			return TRUE
	return FALSE

/datum/quest/kill/notorious_bounty/on_claim(mob/user)
	. = ..()
	var/mob/living/claimant = user
	if(istype(claimant) && claimant.current_fellowship)
		fellowship_ref = WEAKREF(claimant.current_fellowship)

/datum/quest/kill/notorious_bounty/preview(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	bind_landmark(landmark)
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
	boss_name = faction.generate_boss_name(target_mob_type)
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
	. = "Slay the target, but be warned! They are rumored to be a truly formidable opponent! Bringing two is recommended."
	if(!takeover_resolved)
		. += " If a ghost possesses the outlaw, the reward rises by [NOTORIOUS_BOUNTY_PLAYER_BONUS_SOLO] mammon alone and [NOTORIOUS_BOUNTY_PLAYER_BONUS] in a fellowship. If not, their gang arrives and it rises by [NOTORIOUS_BOUNTY_NPC_BONUS_SOLO] alone and [NOTORIOUS_BOUNTY_NPC_BONUS] in a fellowship."
	if(!takeover_resolved || ground_active)
		. += " Once you enter the battleground, you must stay within it."

/datum/quest/kill/notorious_bounty/get_additional_reward(turf/origin_turf, turf/target_turf)
	if(!target_mob_type)
		return 0
	var/boss_threat = initial(target_mob_type.threat_point) || 0
	return (boss_threat * QUEST_NOTORIOUS_BOUNTY_THREAT_MULT) + kill_tp_reward(projected_gang_tp(max(1, fellowship_extras))) + (faction?.notorious_bounty_amount || 0)

/datum/quest/kill/notorious_bounty/proc/projected_gang_tp(extras)
	if(extras <= 0)
		return 0
	return scaled_threat_budget() + scaled_threat_budget(extra_escort_tp(extras - 1))

/datum/quest/kill/notorious_bounty/scaled_threat_budget(budget = tp_budget)
	. = round(budget * veteran_threat_mult())
	var/max_tp = faction?.max_threat_point()
	if(max_tp > 0)
		. = min(., round(QUEST_KILL_MAX_MOBS * max_tp))

/datum/quest/kill/notorious_bounty/group_threat_mult(extras)
	var/boss_tp = target_mob_type ? (initial(target_mob_type.threat_point) || 0) : 0
	if(extras <= 0 || boss_tp <= 0)
		return 1
	return 1 + (tp_budget + extra_escort_tp(extras - 1)) / boss_tp

/datum/quest/kill/notorious_bounty/group_reward_mult(extras)
	if(extras <= 0)
		return solo_pay_share
	return ..(extras - 1)

/datum/quest/kill/notorious_bounty/proc/extra_escort_tp(extras)
	return max(0, extras) * NOTORIOUS_BOUNTY_ESCORT_TP_PER_EXTRA

/datum/quest/kill/notorious_bounty/proc/spawn_gang(obj/effect/landmark/quest_spawner/landmark)
	if(gang_settled)
		return
	gang_settled = TRUE
	if(fellowship_extras <= 0 || QDELETED(landmark))
		return
	spawn_goons(landmark, tp_budget, NOTORIOUS_BOUNTY_GOON_CAP)
	var/escort_extras = fellowship_extras - 1
	if(escort_extras > 0)
		spawn_goons(landmark, extra_escort_tp(escort_extras), escort_extras * NOTORIOUS_BOUNTY_ESCORT_CAP_PER_EXTRA)

/datum/quest/kill/notorious_bounty/estimate_mob_count()
	return 1

/datum/quest/kill/notorious_bounty/materialize(obj/effect/landmark/quest_spawner/landmark)
	if(!landmark)
		return FALSE
	if(!faction)
		return FALSE
	spawn_boss(landmark)
	progress_required = 1
	addtimer(CALLBACK(src, PROC_REF(apply_boss_name)), QUEST_BOSS_RENAME_DELAY)
	addtimer(CALLBACK(src, PROC_REF(preserve_boss_corpse)), QUEST_BOSS_RENAME_DELAY)
	return TRUE

/datum/quest/kill/notorious_bounty/proc/spawn_boss(obj/effect/landmark/quest_spawner/landmark)
	var/mob/living/boss = spawn_hidden_mob(landmark, target_mob_type, effect_type = /obj/effect/quest_spawn/notorious, dust_corpse = FALSE)
	if(!boss)
		return
	grant_darkvision(boss)
	boss_ref = WEAKREF(boss)
	leash_origin = get_turf(boss)

/datum/quest/kill/notorious_bounty/proc/spawn_goons(obj/effect/landmark/quest_spawner/landmark, budget, cap, immediate = FALSE)
	var/saved_budget = tp_budget
	var/saved_extras = fellowship_extras
	tp_budget = budget
	fellowship_extras = max(0, fellowship_extras - 1)
	var/list/to_spawn = compose_warband()
	tp_budget = saved_budget
	fellowship_extras = saved_extras
	if(length(to_spawn) > cap)
		to_spawn.Cut(cap + 1)
	for(var/goon_type in to_spawn)
		var/mob/living/goon = spawn_hidden_mob(landmark, goon_type, is_target = FALSE, effect_type = immediate ? null : /obj/effect/quest_spawn)
		if(!goon)
			continue
		grant_darkvision(goon)
		goon_refs += WEAKREF(goon)
		total_spawned_tp += initial_threat_point(goon.type)

/datum/quest/kill/notorious_bounty/proc/spawn_reinforcements()
	var/obj/effect/landmark/quest_spawner/landmark = pending_landmark_ref?.resolve()
	if(QDELETED(landmark))
		return
	var/solo = fellowship_extras <= 0
	spawn_goons(landmark, solo ? NOTORIOUS_BOUNTY_REINFORCE_TP_SOLO : NOTORIOUS_BOUNTY_REINFORCE_TP, solo ? NOTORIOUS_BOUNTY_REINFORCE_CAP_SOLO : NOTORIOUS_BOUNTY_REINFORCE_CAP, immediate = TRUE)
	var/npc_bonus = solo ? NOTORIOUS_BOUNTY_NPC_BONUS_SOLO : NOTORIOUS_BOUNTY_NPC_BONUS
	reward_amount += npc_bonus
	quest_scroll?.update_quest_text()
	announce_to_bearer("<b>The outlaw's gang arrives.</b> The reward for [boss_name] grows by [npc_bonus] mammon.")

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
	var/list/candidates = pollGhostCandidates("A hunting party is after [boss_name || "a notorious outlaw"]. Will you play the outlaw and fight them off?", ROLE_NOTORIOUS_BOUNTY, null, null, NOTORIOUS_BOUNTY_POLL_TIME, POLL_IGNORE_NOTORIOUS_BOUNTY, poll_width = NOTORIOUS_BOUNTY_POLL_WIDTH, poll_height = NOTORIOUS_BOUNTY_POLL_HEIGHT)
	if(QDELETED(boss) || boss.stat == DEAD || boss.client || complete || failed)
		return
	takeover_resolved = TRUE
	// Only true dead mobs (observers, lobby) - a spirit's key belongs to a body elsewhere.
	var/list/eligible = list()
	for(var/mob/dead/M in candidates)
		if(M.key)
			eligible += M
	if(!length(eligible))
		spawn_reinforcements()
		notify_spectators(boss)
		return
	var/mob/dead/chosen = pick(eligible)
	if(istype(chosen, /mob/dead/new_player))
		var/mob/dead/new_player/N = chosen
		N.close_spawn_windows()
	boss.key = chosen.key
	if(boss.client && boss.ai_controller)
		QDEL_NULL(boss.ai_controller)
	temper_player_boss(boss)
	RegisterSignal(boss, COMSIG_LIVING_DEATH, PROC_REF(on_player_boss_death))
	// Prevent the mob from getting instaambushed
	boss.ambushable = FALSE
	REMOVE_TRAIT(boss, TRAIT_NPC_EXAMINE, list(TRAIT_GENERIC, INNATE_TRAIT))
	ADD_TRAIT(boss, TRAIT_TEMPO, TRAIT_GENERIC)
	boss.adjust_skillrank(/datum/skill/misc/tracking, 6, TRUE) //You should be able to hunt your hunters back!
	boss.adjust_skillrank(/datum/skill/misc/climbing, 4, TRUE)
	boss.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
	boss.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
	// Signals to hunters that a player has taken the reins.
	boss.add_filter("notorious_bounty_outline", 1, list("type" = "drop_shadow", "color" = "#ffee00", "size" = 0.1))
	boss.update_sight()
	refresh_hunter_marks()
	start_ground()
	var/player_bonus = fellowship_extras > 0 ? NOTORIOUS_BOUNTY_PLAYER_BONUS : NOTORIOUS_BOUNTY_PLAYER_BONUS_SOLO
	reward_amount += player_bonus
	quest_scroll?.update_quest_text()
	announce_to_bearer("<b>[boss_name] has been warned of you.</b> The reward rises by [player_bonus] mammon.")
	to_chat(boss, span_danger("You are [boss_name]. Someone signed a contract for your head and the hunting party is on its way."))
	to_chat(boss, span_danger("You cannot leave this ground. Fight them [DisplayTimeText(timeleft(hunt_timer_id), 1)] to earn [NOTORIOUS_BOUNTY_TRIUMPH] TRIUMPH. Success or failure does not matter, only that you have fought in glorious combat."))
	to_chat(boss, span_boldnotice("You may kill them. Do not remove them from the round. Follow escalation rules. You may join any fight your gang has already started."))
	to_chat(boss, span_boldnotice("Your hunters are marked. [describe_hunting_party()]"))
	var/turf/boss_turf = get_turf(boss)
	var/mob/living/bearer = quest_receiver_reference?.resolve()
	var/datum/fellowship/F = bearer?.current_fellowship
	var/mob/living/party_leader = F?.get_leader()
	message_admins("[key_name_admin(boss)] has taken over notorious bounty '[boss_name]' at [ADMIN_COORDJMP(boss_turf)] ([region]), fighting a fellowship led by [party_leader ? key_name_admin(party_leader) : "an unknown party"].")
	notify_spectators(boss)

/datum/quest/kill/notorious_bounty/proc/notify_spectators(mob/living/boss)
	if(QDELETED(boss) || boss.stat == DEAD)
		return
	var/area_name = get_area_name(boss, TRUE)
	notify_ghosts("A hunting party has found [boss_name || "a notorious outlaw"][area_name ? " in [area_name]" : ""].", source = boss, action = NOTIFY_ORBIT, header = "Notorious Bounty", ignore_key = POLL_IGNORE_NOTORIOUS_BOUNTY)

/datum/quest/kill/notorious_bounty/proc/temper_player_boss(mob/living/carbon/human/boss)
	if(istype(boss, /mob/living/carbon/human/species/goblin/npc/large))
		return
	for(var/stat_key in MOBSTATS)
		var/excess = boss.get_stat_level(stat_key) - NOTORIOUS_BOUNTY_PLAYER_STAT_CAP
		if(excess > 0)
			boss.change_stat(stat_key, -excess)
	for(var/skill_type in subtypesof(/datum/skill/combat))
		var/cap = NOTORIOUS_BOUNTY_PLAYER_COMBAT_SKILL_CAP
		switch(skill_type)
			if(/datum/skill/combat/shields)
				cap = NOTORIOUS_BOUNTY_PLAYER_SHIELD_SKILL_CAP
			if(/datum/skill/combat/wrestling)
				cap = NOTORIOUS_BOUNTY_PLAYER_BRAWL_SKILL_CAP
			if(/datum/skill/combat/unarmed)
				if(!HAS_TRAIT(boss, TRAIT_CIVILIZEDBARBARIAN))
					cap = NOTORIOUS_BOUNTY_PLAYER_BRAWL_SKILL_CAP
		boss.adjust_skillrank_down_to(skill_type, cap, TRUE)
	for(var/skill_type in subtypesof(/datum/skill/magic))
		boss.adjust_skillrank_down_to(skill_type, NOTORIOUS_BOUNTY_PLAYER_MAGIC_SKILL_CAP, TRUE)

/datum/quest/kill/notorious_bounty/proc/start_ground()
	if(ground_active || !leash_origin)
		return
	ground_active = TRUE
	var/mob/living/boss = boss_ref?.resolve()
	if(boss)
		boss.AddComponent(/datum/component/battleground_bound, leash_origin, NOTORIOUS_BOUNTY_LEASH_RANGE)
	bind_hunters()
	ground_tick_id = addtimer(CALLBACK(src, PROC_REF(bind_hunters)), NOTORIOUS_BOUNTY_GROUND_TICK, TIMER_STOPPABLE | TIMER_LOOP)

/datum/quest/kill/notorious_bounty/proc/end_ground()
	if(!ground_active)
		return
	ground_active = FALSE
	if(ground_tick_id)
		deltimer(ground_tick_id)
		ground_tick_id = null
	unbind(boss_ref?.resolve())
	for(var/datum/weakref/W as anything in bound_hunters)
		unbind(W.resolve())
	bound_hunters.Cut()

/datum/quest/kill/notorious_bounty/proc/unbind(mob/living/M)
	var/datum/component/battleground_bound/leash = M?.GetComponent(/datum/component/battleground_bound)
	if(leash?.center == leash_origin)
		qdel(leash)

/datum/quest/kill/notorious_bounty/proc/bind_hunters()
	var/list/party = get_hunting_party()
	for(var/datum/weakref/W as anything in bound_hunters.Copy())
		var/mob/living/M = W.resolve()
		if(M in party)
			continue
		bound_hunters -= W
		unbind(M)
	for(var/mob/living/M as anything in party)
		if(M.stat == DEAD)
			continue
		var/datum/weakref/W = WEAKREF(M)
		if((W in bound_hunters) || M.GetComponent(/datum/component/battleground_bound) || !in_ground(M, NOTORIOUS_BOUNTY_DRAW_IN_RANGE))
			continue
		if(!in_ground(M))
			draw_in(M)
		bound_hunters += W
		M.AddComponent(/datum/component/battleground_bound, leash_origin, NOTORIOUS_BOUNTY_LEASH_RANGE)
		to_chat(M, span_warning("You have entered the battleground. You cannot leave until the fight is over."))

/datum/quest/kill/notorious_bounty/proc/in_ground(atom/A, range = NOTORIOUS_BOUNTY_LEASH_RANGE)
	var/turf/T = get_turf(A)
	return T && is_in_zweb(T.z, leash_origin.z) && max(abs(T.x - leash_origin.x), abs(T.y - leash_origin.y)) <= range

/datum/quest/kill/notorious_bounty/proc/draw_in(mob/living/M)
	var/turf/dest = leash_origin
	for(var/turf/T as anything in get_line(get_turf(M), leash_origin))
		if(in_ground(T) && isopenturf(T) && !istype(T, /turf/open/transparent/openspace) && !is_blocked_turf(T, TRUE))
			dest = T
			break
	if(M.buckled)
		M.buckled.unbuckle_mob(M, TRUE)
	M.forceMove(dest)

/datum/quest/kill/notorious_bounty/proc/release_boss()
	var/mob/living/boss = boss_ref?.resolve()
	if(QDELETED(boss) || boss.stat == DEAD || !boss.client)
		return
	if(!pay_out_boss(boss) && !hunt_engaged)
		to_chat(boss, span_warning("The hunters never came for you."))
	to_chat(boss, span_warning("The hunt is over. You escape to safety."))
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
	to_chat(boss, span_userdanger("Your lyfe and notoriety end here. Your spirit drifts away..."))
	INVOKE_ASYNC(src, PROC_REF(pay_out_boss), boss)
	addtimer(CALLBACK(src, PROC_REF(release_dead_boss), boss), NOTORIOUS_BOUNTY_DEATH_RELEASE)

/datum/quest/kill/notorious_bounty/proc/release_dead_boss(mob/living/boss)
	if(QDELETED(boss))
		boss = boss_ref?.resolve()
	if(QDELETED(boss) || !boss.client || boss.stat != DEAD)
		return
	pay_out_boss(boss)
	UnregisterSignal(boss, COMSIG_LIVING_DEATH)
	clear_hunter_marks()
	clear_boss_marker()
	to_chat(boss, span_warning("Your spirit slips free. Watch the last of the hunt, or move to Necra's embrace and dream of a new lyfe."))
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

/datum/quest/kill/notorious_bounty/proc/announce_to_party(msg)
	for(var/mob/living/M as anything in get_hunting_party())
		to_chat(M, span_notice(msg))

/datum/quest/kill/notorious_bounty/announce_to_bearer(msg)
	announce_to_party(msg)

/datum/quest/kill/notorious_bounty/proc/whisper_boss_location()
	var/mob/living/boss = boss_ref?.resolve()
	if(QDELETED(boss) || boss.stat == DEAD || QDELETED(quest_scroll))
		return
	for(var/mob/living/M as anything in get_hunting_party())
		if(M.stat == DEAD)
			continue
		quest_scroll.update_compass(M)
		var/message = quest_scroll.last_compass_direction
		if(quest_scroll.last_z_level_hint)
			message += " ([quest_scroll.last_z_level_hint])"
		to_chat(M, span_info("The scroll whispers to you: [boss_name || "the outlaw"] is[message]."))

/datum/quest/kill/notorious_bounty/proc/describe_hunting_party()
	var/mob/living/bearer = quest_receiver_reference?.resolve()
	var/list/names = list()
	for(var/mob/living/M as anything in get_hunting_party())
		names += (M == bearer) ? "[M.real_name] (contract holder)" : M.real_name
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
		. = TRUE
	goon_refs.Cut()

/datum/quest/kill/notorious_bounty/proc/check_hunt_engaged(mob/living/boss)
	if(hunt_engaged || QDELETED(boss))
		return
	hunt_engaged = hunter_in_range(boss)

/datum/quest/kill/notorious_bounty/proc/count_engaged_tick(mob/living/boss)
	if(boss.stat == DEAD || !boss.client || boss.client.inactivity >= NOTORIOUS_BOUNTY_HUNT_TICK)
		return
	if(hunter_in_range(boss))
		engaged_ticks++

/datum/quest/kill/notorious_bounty/proc/hunter_in_range(mob/living/boss)
	var/turf/boss_turf = get_turf(boss)
	if(!boss_turf)
		return FALSE
	for(var/mob/living/M as anything in get_hunting_party())
		var/turf/hunter_turf = get_turf(M)
		if(!hunter_turf || hunter_turf.z != boss_turf.z)
			continue
		if(get_dist(hunter_turf, boss_turf) <= NOTORIOUS_BOUNTY_ENGAGE_RANGE)
			return TRUE
	return FALSE

/datum/quest/kill/notorious_bounty/proc/succour_fallen_hunters()
	if(!hunt_engaged || !leash_origin)
		return
	for(var/mob/living/M as anything in get_hunting_party())
		if(QDELETED(M) || M.stat == CONSCIOUS)
			continue
		var/turf/hunter_turf = get_turf(M)
		if(!hunter_turf)
			continue
		if(max(abs(hunter_turf.x - leash_origin.x), abs(hunter_turf.y - leash_origin.y)) > NOTORIOUS_BOUNTY_LEASH_RANGE)
			continue
		if(M.stat == DEAD)
			if(ishuman(M) && !M.get_bodypart(BODY_ZONE_HEAD))
				reattach_head(M)
			if(M.mind?.current != M)
				continue
			M.grab_ghost(force = TRUE)
			M.revive(full_heal = TRUE, admin_revive = TRUE)
			to_chat(M, span_boldnotice("The scroll spends the last of its magicka dragging you back from Necra's door. You draw breath again."))
			continue
		M.fully_heal()
		to_chat(M, span_boldnotice("The scroll spends the last of its magicka keeping you breathing. You come to."))

/datum/quest/kill/notorious_bounty/proc/reattach_head(mob/living/carbon/human/M)
	var/mob/living/brain/B = M.last_mind?.current
	if(!istype(B))
		return FALSE
	var/obj/item/bodypart/head/H = B.loc
	if(!istype(H) || QDELETED(H) || H.owner || !H.brain)
		return FALSE
	if(ismob(H.loc))
		var/mob/holder = H.loc
		holder.temporarilyRemoveItemFromInventory(H, TRUE)
	return H.attach_limb(M)

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

//TODO(flavor): Boss outlasted the hunt and is paid. Should land as a win.
/datum/quest/kill/notorious_bounty/proc/pay_out_boss(mob/living/boss)
	if(boss_paid || engaged_ticks < NOTORIOUS_BOUNTY_ENGAGED_TICKS)
		return FALSE
	if(QDELETED(boss) || !boss.client)
		return FALSE
	boss_paid = TRUE
	var/turf/boss_turf = get_turf(boss)
	var/fell = boss.stat == DEAD
	if(fell)
		to_chat(boss, span_danger("<b>You fought them them and fell in glorious battle. You earn [NOTORIOUS_BOUNTY_TRIUMPH] TRIUMPH.</b>"))
	else
		to_chat(boss, span_danger("<b>The hunting party could not end you. You escape to safety and earn [NOTORIOUS_BOUNTY_TRIUMPH] TRIUMPH.</b>"))
	boss.adjust_triumphs(NOTORIOUS_BOUNTY_TRIUMPH, TRUE, fell ? "notorious bounty: fought and died" : "notorious bounty: survived the hunters")
	message_admins("[key_name_admin(boss)] [fell ? "fought and died in" : "outlasted"] notorious bounty '[boss_name]' at [ADMIN_COORDJMP(boss_turf)] ([region]).")
	return TRUE

/datum/quest/kill/notorious_bounty/faction_fits(datum/quest_faction/F, datum/threat_region/TR)
	return ..() && length(F.get_playable_boss_types())
