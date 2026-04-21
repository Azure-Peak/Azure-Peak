/obj/structure/roguemachine/contractledger
	name = "Grand Contract Ledger"
	desc = "A massive ledger book with gilded edges, sitting atop a pedestal with the Mercenary's Guild banner. Its myriad enchanted pages are filled with various contracts and bounties issued by Mercenary's Guild, with arcane scripts that appears and fades as contracts are issued and completed."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "contractledger"
	density = TRUE
	anchored = TRUE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER
	layer = GAME_PLANE_UPPER
	/// Turf south of the ledger, marked with a drop-here decal. Retrieval-quest items carry a
	/// component that consumes them on any tile bearing this decal.
	var/input_point

/obj/structure/roguemachine/contractledger/Initialize()
	. = ..()
	input_point = locate(x, y - 1, z)
	var/obj/effect/decal/marker_export/marker = new(get_turf(input_point))
	marker.desc = "Drop retrieval-quest items here to turn them in."
	marker.layer = ABOVE_OBJ_LAYER
	SSquestpool.registered_ledgers += src

/obj/structure/roguemachine/contractledger/Destroy()
	SSquestpool.registered_ledgers -= src
	return ..()

/obj/structure/roguemachine/contractledger/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("<b>Left click</b> to open the Grand Contract Ledger, where you can sign new contracts and abandon ones you hold.")
	. += span_info("To <b>turn in</b> a completed contract, click the ledger while holding the quest scroll.")
	. += span_info("Retrieval-quest items should be <b>dropped onto the marked tile</b> in front of the ledger.")
	. += span_info("Abandoning a contract forfeits its deposit to the treasury and places you under a brief guild cooldown before you may abandon another.")

/obj/structure/roguemachine/contractledger/attackby(obj/item/P, mob/living/carbon/human/user, params)
	. = ..()
	if(istype(P, /obj/item/paper/scroll/quest))
		turn_in_contract(user, P)
		return
	return

/obj/structure/roguemachine/contractledger/attack_hand(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	ui_interact(user)

/obj/structure/roguemachine/contractledger/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/contractledger/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ContractLedger")
		ui.open()

/obj/structure/roguemachine/contractledger/ui_data(mob/user)
	var/list/data = list()
	var/datum/job/mob_job = user?.job ? SSjob.GetJob(user.job) : null
	data["is_handler"] = !!mob_job?.is_quest_giver
	data["balance"] = SStreasury.get_balance(user)
	data["active_max"] = mob_job?.max_active_quests || QUEST_MAX_ACTIVE_PER_PLAYER
	data["active_count"] = count_user_active_contracts(user)
	data["pool"] = build_pool_listing()
	data["active"] = build_active_listing(user)
	data["regions"] = build_region_listing()
	data["tax_rate"] = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
	data["guild_cut_rate"] = GUILD_REFERRAL_FEE_PCT
	data["is_innkeeper"] = user?.job == "Innkeeper"
	if(data["is_innkeeper"])
		data["rumor_points"] = round(SStreasury.rumor_points, 0.1)
		data["rumor_costs"] = GLOB.rumor_point_costs.Copy()
		data["rumor_regions_by_type"] = build_rumor_regions_by_type()
		data["rumor_destinations"] = build_rumor_destinations()
		data["rumor_log"] = SStreasury.rumor_log
	return data

/obj/structure/roguemachine/contractledger/proc/build_region_listing()
	var/list/known = list()
	for(var/datum/threat_region/TR as anything in SSregionthreat.threat_regions)
		known += TR.region_name
	return known

/obj/structure/roguemachine/contractledger/proc/build_pool_listing()
	var/list/listing = list()
	for(var/datum/quest/Q as anything in SSquestpool.pool)
		var/expected_count = Q.progress_required
		var/threat_bands = 0
		if(istype(Q, /datum/quest/kill))
			var/datum/quest/kill/KQ = Q
			threat_bands = KQ.threat_bands_cleared
		listing += list(list(
			"ref" = REF(Q),
			"title" = Q.title || "Unnamed Contract",
			"type" = Q.quest_type,
			"difficulty" = Q.quest_difficulty,
			"reward" = Q.reward_amount,
			"deposit" = Q.deposit_amount,
			"area" = Q.target_spawn_area,
			"region" = Q.region,
			"objective" = Q.get_objective_text(),
			"expected_count" = expected_count,
			"threat_bands" = threat_bands,
			"levy_exempt" = Q.levy_exempt,
			"is_rumor" = Q.source == QUEST_SOURCE_RUMOR,
		))
	return listing

/obj/structure/roguemachine/contractledger/proc/build_active_listing(mob/user)
	var/list/listing = list()
	var/datum/weakref/user_ref = WEAKREF(user)
	for(var/obj/item/paper/scroll/quest/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q)
			continue
		if(Q.quest_receiver_reference != user_ref)
			continue
		listing += list(list(
			"ref" = REF(Q),
			"title" = Q.title || "Unnamed Contract",
			"type" = Q.quest_type,
			"difficulty" = Q.quest_difficulty,
			"area" = Q.target_spawn_area,
			"region" = Q.region,
			"progress_current" = Q.progress_current,
			"progress_required" = Q.progress_required,
			"complete" = Q.complete,
		))
	return listing

/obj/structure/roguemachine/contractledger/proc/count_user_active_contracts(mob/user)
	var/datum/weakref/user_ref = WEAKREF(user)
	var/count = 0
	for(var/obj/item/paper/scroll/quest/scroll in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(!Q || Q.complete)
			continue
		if(Q.quest_receiver_reference == user_ref)
			count++
	return count

/obj/structure/roguemachine/contractledger/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/user = usr
	if(!user?.Adjacent(src))
		return TRUE
	switch(action)
		if("sign")
			sign_contract(user, params["ref"])
			return TRUE
		if("abandon")
			abandon_by_ref(user, params["ref"])
			return TRUE
		if("print_active")
			var/datum/job/mob_job = user?.job ? SSjob.GetJob(user.job) : null
			if(mob_job?.is_quest_giver)
				print_contracts(user)
			return TRUE
		if("compose_rumor")
			compose_rumor_from_tgui(user, params)
			return TRUE
