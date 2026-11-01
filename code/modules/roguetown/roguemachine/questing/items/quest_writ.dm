GLOBAL_LIST_EMPTY(quest_scrolls)

/proc/get_scroll_quests()
	. = list()
	for(var/obj/item/quest_writ/scroll as anything in GLOB.quest_scrolls)
		if(scroll.assigned_quest)
			. += scroll.assigned_quest

/proc/get_held_quests(mob/user)
	. = list()
	var/datum/weakref/user_ref = WEAKREF(user)
	for(var/obj/item/quest_writ/scroll as anything in GLOB.quest_scrolls)
		var/datum/quest/Q = scroll.assigned_quest
		if(Q?.quest_receiver_reference == user_ref)
			. += Q

/proc/find_quest_by_ref(ref)
	var/datum/quest/Q = locate(ref)
	if(!istype(Q) || QDELETED(Q))
		return null
	if(Q in SSquestpool.pool)
		return Q
	var/obj/item/quest_writ/scroll = Q.quest_scroll_ref?.resolve()
	return scroll?.assigned_quest == Q ? Q : null

#define WHISPER_COOLDOWN 10 SECONDS

/obj/item/quest_writ
	name = "enchanted contract scroll"
	desc = "A scroll often called a \"whispering scroll\". It whispers the target's location to its holder while the target lives. When they die, it marks itself.\n\
	The magical protections make it resistant to damage and tampering. It will only whisper when carried on the person of the contract holder."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "scroll_quest_closed"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FIRE_PROOF | LAVA_PROOF | INDESTRUCTIBLE | UNACIDABLE
	max_integrity = 1000
	armor = ARMOR_INDESTRUCTIBLE
	var/base_icon_state = "scroll_quest"
	var/datum/quest/assigned_quest
	var/claim_in_progress = FALSE
	var/last_compass_direction = ""
	var/last_z_level_hint = ""
	var/last_whisper = 0
	var/opened = FALSE

/obj/item/quest_writ/Initialize(mapload)
	. = ..()
	if(assigned_quest)
		assigned_quest.quest_scroll = src
	update_icon_state()
	START_PROCESSING(SSprocessing, src)
	GLOB.quest_scrolls += src

/obj/item/quest_writ/Destroy()
	GLOB.quest_scrolls -= src
	if(assigned_quest)
		qdel(assigned_quest)
		assigned_quest = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/quest_writ/update_icon_state()
	if(opened)
		icon_state = "[base_icon_state]_info"
	else
		icon_state = "[base_icon_state]_closed"

/obj/item/quest_writ/process()
	if(world.time > last_whisper + WHISPER_COOLDOWN)
		last_whisper = world.time
		target_whisper()

/obj/item/quest_writ/proc/try_hand_claim(mob/user)
	if(claim_in_progress)
		return FALSE
	claim_in_progress = TRUE
	. = do_hand_claim(user)
	claim_in_progress = FALSE

/obj/item/quest_writ/proc/do_hand_claim(mob/user)
	var/datum/quest/Q = assigned_quest
	if(Q.quest_giver_name && Q.quest_giver_name == user.real_name && !Q.issuer_may_claim && !SSquestpool.debug_mode)
		to_chat(user, span_warning("You can't take a contract you issued."))
		return FALSE
	if(!SStreasury.has_account(user))
		to_chat(user, span_warning("You have no bank account. Register with a Meister first."))
		return FALSE
	Q.lock_fellowship(user)
	if(!Q.materialized)
		var/obj/effect/landmark/quest_spawner/landmark = Q.pending_landmark_ref?.resolve()
		if(!landmark || !Q.materialize(landmark))
			to_chat(user, span_warning("Odd. It appears no landmark is available for this contract!"))
			return FALSE
		Q.materialized = TRUE
	Q.on_claim(user)
	to_chat(user, span_notice(Q.hand_claim_message))
	log_quest(user.ckey, user.mind, user, "Sign [Q.quest_type] (hand-delivered)")
	update_quest_text()
	return TRUE

/obj/item/quest_writ/proc/get_carrying_bearer()
	var/mob/living/bearer = assigned_quest?.quest_receiver_reference?.resolve()
	if(bearer && get(src, /mob/living) == bearer)
		return bearer
	return null

/obj/item/quest_writ/proc/target_whisper()
	if(!assigned_quest || assigned_quest.complete)
		return
	var/mob/living/quest_bearer = get_carrying_bearer()
	if(opened && quest_bearer)
		update_compass(quest_bearer)
		var/message = "[last_compass_direction]"
		if(last_z_level_hint)
			message += " ([last_z_level_hint])"
		to_chat(quest_bearer, span_info("The scroll whispers to you: the target is[message]."))

/obj/item/quest_writ/examine(mob/user)
	. = ..()
	if(!assigned_quest)
		return
	if(!assigned_quest.quest_receiver_reference)
		. += span_notice("This contract hasn't been claimed yet. Open it to claim it for yourself!")
	else if(assigned_quest.complete)
		. += span_notice("\nThis contract is complete! Return it to the Contract Ledger to claim your reward.")
	else
		. += span_notice("\nThis contract is still in progress.")

/obj/item/quest_writ/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(P.get_sharpness())
		to_chat(user, span_warning("The enchanted scroll resists your attempts to tear it."))
		return
	if(istype(P, /obj/item/paper))
		to_chat(user, span_warning("The magical energies prevent you from combining this with other scrolls."))
		return
	if(istype(P, /obj/item/clothing/ring/signet/psy))
		to_chat(user, span_warning("The scroll can only be stamped with a signet ring bearing the Grand Duke's symbol."))
		return
	if(istype(P, /obj/item/clothing/ring/signet))
		var/obj/item/clothing/ring/signet/S = P
		if(S.tallowed && S.tallow_color == "black")
			S.tallowed = FALSE
			S.update_icon()
			stamp_with_signet(P, user)
			return
		else if(S.tallowed && S.tallow_color != "black")
			to_chat(user, span_warning("I need to use blacktallow to seal this properly."))
			return
		else
			to_chat(user, span_warning("The ring hasn't been waxed."))
			return
	..()

/obj/item/quest_writ/proc/stamp_with_signet(obj/item/clothing/ring/signet/ring, mob/living/carbon/human/user)
	if(!assigned_quest)
		to_chat(user, span_warning("This scroll bears no active contract to stamp."))
		return
	if(!(user.job in GLOB.crown_authority_roles))
		to_chat(user, span_warning("Only Crown officials can stamp a scroll in the Crown's name."))
		return
	if(assigned_quest.levy_exempt)
		to_chat(user, span_warning("This contract already bears the levy exempt stamp."))
		return
	assigned_quest.levy_exempt = TRUE
	update_quest_text()
	playsound(src, 'sound/items/inqslip_sealed.ogg', 75, TRUE, 4)
	log_game("[key_name(user)] stamped quest \"[assigned_quest.title || assigned_quest.quest_type]\" as LEVY EXEMPT via signet ring.")
	to_chat(user, span_notice("You press the signet into the scroll and the Crown's seal glows. This contract is now levy exempt."))

/obj/item/quest_writ/proc/get_quest_assignees(mob/user)
	var/list/assignees = list()
	var/mob/quest_receiver = assigned_quest?.quest_receiver_reference?.resolve()
	if(quest_receiver)
		assignees += quest_receiver
	return assignees

/obj/item/quest_writ/fire_act(exposed_temperature, exposed_volume)
	return

/obj/item/quest_writ/extinguish()
	return

/obj/item/quest_writ/attack_self(mob/user)
	if(!assigned_quest)
		return ..()

	if(!assigned_quest.quest_receiver_reference && !try_hand_claim(user))
		return

	opened = TRUE
	update_icon_state()
	refresh_compass(user)
	ui_interact(user)

/obj/item/quest_writ/rmb_self(mob/user, keybind = FALSE)
	if(!assigned_quest || !opened)
		return
	opened = FALSE
	update_icon_state()
	SStgui.close_uis(src)
	to_chat(user, span_notice("You roll the scroll shut. The whispering ceases."))

/obj/item/quest_writ/ui_state(mob/user)
	return GLOB.hold_or_view_state

/obj/item/quest_writ/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "QuestScroll")
		ui.open()

/obj/item/quest_writ/ui_static_data(mob/user)
	var/list/data = list()
	if(!assigned_quest)
		data["empty"] = TRUE
		return data
	var/datum/quest/Q = assigned_quest
	var/datum/quest_faction/F = Q.faction
	data["title"] = Q.get_title()
	data["realm_name"] = SSticker.realm_name
	data["ruler_title"] = SSticker.rulertype
	data["issued_by"] = Q.quest_giver_name
	data["issued_to"] = Q.quest_receiver_name
	data["issued_on"] = Q.issued_day ? get_ic_date_short_as_string(Q.issued_day) : null
	data["named_target"] = Q.get_named_target()
	data["band_leader"] = Q.band_leader_name
	data["faction_category"] = F?.category
	data["faction_group_word"] = F?.group_word
	data["faction_name_singular"] = F?.name_singular
	data["faction_name_plural"] = F?.name_plural
	data["faction_progress_noun"] = F?.progress_noun || "foes"
	data["crimes"] = Q.rolled_crimes
	data["sacral_invoked"] = Q.sacral_hook
	data["oath_breach"] = Q.oath_breach
	data["condemnation"] = Q.condemnation_variant
	data["writ_type"] = Q.writ_type
	data["circumstance"] = Q.circumstance_text
	data["pickup_region"] = Q.target_spawn_area
	data["target_region"] = Q.region
	data["delivery_destination"] = Q.target_delivery_location ? initial(Q.target_delivery_location.name) : null
	data["delivery_item"] = Q.target_delivery_item ? initial(Q.target_delivery_item.name) : null
	data["fetch_item"] = Q.target_item_type ? initial(Q.target_item_type.name) : null
	data["fetch_item_plural"] = Q.target_item_plural
	data["fetch_count"] = Q.progress_required
	data["recovery_shipment"] = Q.get_recovery_shipment_name()
	data["levy_rate"] = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
	data["guild_cut_rate"] = Q.guild_cut_rate
	data["progress_required"] = Q.progress_required
	data["shows_commission_seal"] = Q.shows_commission_seal
	data["is_towner"] = Q.source == QUEST_SOURCE_TOWNER
	Q.populate_scroll_ui_static_data(data)
	return data

/obj/item/quest_writ/ui_data(mob/user)
	var/list/data = list()
	if(!assigned_quest)
		return data
	refresh_compass(user)
	data["compass_direction"] = last_compass_direction
	data["z_hint"] = last_z_level_hint
	data["objective"] = assigned_quest.get_objective_text()
	data["reward"] = assigned_quest.reward_amount
	data["fellowship_size"] = length(assigned_quest.fellowship_roster)
	data["fellowship_extras"] = assigned_quest.fellowship_extras
	data["fellowship_split"] = assigned_quest.fellowship_split_payout
	data["fellowship_threat_pct"] = round((assigned_quest.fellowship_threat_mult - 1) * 100)
	data["fellowship_reward_pct"] = round((assigned_quest.fellowship_reward_mult - 1) * 100)
	data["progress_current"] = assigned_quest.progress_current
	data["complete"] = assigned_quest.complete
	data["levy_exempt"] = assigned_quest.levy_exempt
	assigned_quest.populate_scroll_ui_data(data)
	return data

/obj/item/quest_writ/proc/update_quest_text()
	SStgui.update_uis(src)

/obj/item/quest_writ/proc/refresh_compass(mob/user)
	if(!assigned_quest || assigned_quest.complete)
		return FALSE
	update_compass(user)
	return last_compass_direction ? TRUE : FALSE

/obj/item/quest_writ/proc/update_compass(mob/user)
	if(!assigned_quest || assigned_quest.complete)
		return

	var/turf/user_turf = user ? get_turf(user) : get_turf(src)
	if(!user_turf)
		last_compass_direction = " hidden from the scroll"
		last_z_level_hint = ""
		return

	last_compass_direction = " Searching for target..."
	last_z_level_hint = ""

	var/turf/target_turf = assigned_quest.get_target_location()
	if(!target_turf)
		last_compass_direction = " nowhere to be found"
		last_z_level_hint = ""
		return

	if(target_turf.z != user_turf.z)
		var/z_diff = abs(target_turf.z - user_turf.z)
		last_z_level_hint = target_turf.z > user_turf.z ? \
			"[z_diff] level\s above you" : \
			"[z_diff] level\s below you"

	var/dx = target_turf.x - user_turf.x
	var/dy = target_turf.y - user_turf.y
	var/distance = round(sqrt(dx*dx + dy*dy))

	var/direction_text = get_precise_direction_between(user_turf, target_turf)
	if(!direction_text)
		direction_text = "unknown direction"

	var/distance_text
	switch(distance)
		if(0 to 7)
			distance_text = " nearby"
		if(8 to 14)
			distance_text = " very close"
		if(15 to 40)
			distance_text = " close"
		if(41 to 100)
			distance_text = ""
		if(101 to INFINITY)
			distance_text = " far away"

	last_compass_direction = "[distance_text] ([distance] paces) to the [direction_text]"
	if(!last_z_level_hint)
		last_z_level_hint = "on this level"

#undef WHISPER_COOLDOWN
