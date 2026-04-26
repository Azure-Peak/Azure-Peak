GLOBAL_LIST_EMPTY(quest_scrolls)

#define WHISPER_COOLDOWN 10 SECONDS

/obj/item/quest_writ
	name = "enchanted contract scroll"
	desc = "A scroll oft known as a \"whispering scroll\". Enchanted to whisper the target's location to its bearer while they yet live, and to mark itself silently upon their death - so the bearer need bring no head, no hand, no token of proof beyond the writ itself.\n\
	The magical protections make it resistant to damage and tampering. It will only whisper when carried on the person of the contract bearer."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "scroll_quest_closed"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = FIRE_PROOF | LAVA_PROOF | INDESTRUCTIBLE | UNACIDABLE
	max_integrity = 1000
	armor = ARMOR_INDESTRUCTIBLE
	var/base_icon_state = "scroll_quest"
	var/datum/quest/assigned_quest
	var/last_compass_direction = ""
	var/last_z_level_hint = ""
	var/last_whisper = 0
	var/opened = FALSE

/obj/item/quest_writ/Initialize()
	. = ..()
	if(assigned_quest)
		assigned_quest.quest_scroll = src
	update_icon_state()
	START_PROCESSING(SSprocessing, src)
	GLOB.quest_scrolls += src

/obj/item/quest_writ/Destroy()
	GLOB.quest_scrolls -= src
	if(assigned_quest)
		if(!assigned_quest.complete)
			var/refund = assigned_quest.calculate_deposit()
			var/mob/giver = assigned_quest.quest_giver_reference?.resolve()
			if(giver && SStreasury.has_account(giver))
				SStreasury.transfer(SStreasury.discretionary_fund, SStreasury.get_account(giver), refund, "contract scroll refund to [giver.real_name]")
			else if(assigned_quest.quest_receiver_reference)
				var/mob/receiver = assigned_quest.quest_receiver_reference.resolve()
				if(receiver && SStreasury.has_account(receiver))
					SStreasury.transfer(SStreasury.discretionary_fund, SStreasury.get_account(receiver), refund, "contract scroll refund to [receiver.real_name]")
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

/obj/item/quest_writ/proc/target_whisper()
	if(!assigned_quest || assigned_quest.complete || !assigned_quest.quest_receiver_reference)
		return
	var/atom/itemloc = src.loc
	var/mob/quest_bearer = assigned_quest.quest_receiver_reference?.resolve()
	if(!istype(itemloc, /mob/living))
		while(!istype(itemloc, /mob/living))
			if(isnull(itemloc))
				return
			itemloc = itemloc.loc
			if(istype(itemloc, /turf))
				return
	if(itemloc != quest_bearer)
		return
	if(opened && quest_bearer)
		update_compass(quest_bearer)
		var/message = "[last_compass_direction]"
		if(last_z_level_hint)
			message += " ([last_z_level_hint])"
		to_chat(quest_bearer, span_info("The scroll whispers to you, the target is[message]"))

/obj/item/quest_writ/examine(mob/user)
	. = ..()
	if(!assigned_quest)
		return
	if(!assigned_quest.quest_receiver_reference)
		. += span_notice("This contract hasn't been claimed yet. Open it to claim it for yourself!")
	else if(assigned_quest.complete)
		. += span_notice("\nThis contract is complete! Return it to the Contract Ledger to claim your reward.")
		. += span_info("\nPlace it on the marked area or put it on the ledger.")
	else
		. += span_notice("\nThis contract is still in progress.")

/obj/item/quest_writ/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(P.get_sharpness())
		to_chat(user, span_warning("The enchanted scroll resists your attempts to tear it."))
		return
	if(istype(P, /obj/item/paper))
		to_chat(user, span_warning("The magical energies prevent you from combining this with other scrolls."))
		return
	if(istype(P, /obj/item/clothing/ring/signet))
		stamp_with_signet(P, user)
		return
	..()

/obj/item/quest_writ/proc/stamp_with_signet(obj/item/clothing/ring/signet/ring, mob/living/carbon/human/user)
	if(!assigned_quest)
		to_chat(user, span_warning("The scroll bears no active contract to stamp."))
		return
	if(!(user.job in list("Steward", "Clerk", "Grand Duke")))
		to_chat(user, span_warning("Only a Steward, Clerk, or the Grand Duke may stamp a writ in the Crown's name."))
		return
	if(assigned_quest.levy_exempt)
		to_chat(user, span_warning("This contract already bears the levy-exempt stamp."))
		return
	assigned_quest.levy_exempt = TRUE
	update_quest_text()
	playsound(src, 'sound/items/inqslip_sealed.ogg', 75, TRUE, 4)
	log_game("[key_name(user)] stamped quest \"[assigned_quest.title || assigned_quest.quest_type]\" as LEVY EXEMPT via signet ring.")
	to_chat(user, span_notice("You press the signet into the scroll. The Crown's seal glows faintly - this contract is now levy-exempt."))

/obj/item/quest_writ/proc/get_quest_assignees(mob/user, include_giver = FALSE)
	var/list/assignees = list()
	var/mob/quest_receiver = assigned_quest?.quest_receiver_reference?.resolve()
	if(quest_receiver)
		assignees += quest_receiver
	if(include_giver)
		var/mob/quest_giver = assigned_quest?.quest_giver_reference?.resolve()
		if(quest_giver)
			assignees += quest_giver
	return assignees

/obj/item/quest_writ/fire_act(exposed_temperature, exposed_volume)
	return

/obj/item/quest_writ/extinguish()
	return

/obj/item/quest_writ/attack_self(mob/user)
	if(!assigned_quest)
		return ..()

	if(!assigned_quest.quest_receiver_reference)
		if(assigned_quest.quest_giver_name && assigned_quest.quest_giver_name == user.real_name)
			to_chat(user, span_warning("You cannot take a contract you yourself issued."))
			return
		assigned_quest.quest_receiver_reference = WEAKREF(user)
		assigned_quest.quest_receiver_name = user.real_name
		to_chat(user, span_notice("You claim this contract for yourself!"))
		update_quest_text()

	opened = TRUE
	update_icon_state()
	refresh_compass(user)
	ui_interact(user)

/obj/item/quest_writ/rmb_self(mob/user)
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
	data["delivery_destination"] = Q.target_delivery_location ? initial(Q.target_delivery_location.name) : null
	data["delivery_item"] = Q.target_delivery_item ? initial(Q.target_delivery_item.name) : null
	data["fetch_item"] = Q.target_item_type ? initial(Q.target_item_type.name) : null
	data["fetch_count"] = Q.progress_required
	data["recovery_shipment"] = Q.get_recovery_shipment_name()
	data["reward"] = Q.reward_amount
	data["levy_rate"] = SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY)
	data["progress_required"] = Q.progress_required
	data["is_rumor"] = Q.source == QUEST_SOURCE_RUMOR
	data["is_defense"] = Q.source == QUEST_SOURCE_DEFENSE
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
		last_compass_direction = " No signal detected"
		last_z_level_hint = ""
		return

	last_compass_direction = " Searching for target..."
	last_z_level_hint = ""

	var/turf/target_turf = assigned_quest.get_target_location()
	if(!target_turf)
		last_compass_direction = " location unknown"
		last_z_level_hint = ""
		return

	if(target_turf.z != user_turf.z)
		var/z_diff = abs(target_turf.z - user_turf.z)
		last_z_level_hint = target_turf.z > user_turf.z ? \
			"[z_diff] level\s above you" : \
			"[z_diff] level\s below you"

	var/dx = target_turf.x - user_turf.x
	var/dy = target_turf.y - user_turf.y
	var/distance = sqrt(dx*dx + dy*dy)

	if(distance <= 7)
		last_compass_direction = " is nearby"
		last_z_level_hint = ""
		return

	var/direction_text = get_precise_direction_between(user_turf, target_turf)
	if(!direction_text)
		direction_text = "unknown direction"

	var/distance_text
	switch(distance)
		if(0 to 14)
			distance_text = " very close"
		if(15 to 40)
			distance_text = " close"
		if(41 to 100)
			distance_text = ""
		if(101 to INFINITY)
			distance_text = " far away"

	last_compass_direction = "[distance_text] to the [direction_text]"
	if(!last_z_level_hint)
		last_z_level_hint = "on this level"

#undef WHISPER_COOLDOWN
