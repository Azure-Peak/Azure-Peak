GLOBAL_LIST_EMPTY(quest_scrolls)

#define WHISPER_COOLDOWN 10 SECONDS
/obj/item/paper/scroll/quest
	name = "enchanted contract scroll"
	desc = "A scroll oft known as a \"whispering scroll\". Enchanted with magicks to make it whisper to its bearer when opened the location of its target.\n\
	The magical protections make it resistant to damage and tampering. It will only whisper when carried on the person of the contract bearer."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "scroll_quest"
	var/base_icon_state = "scroll_quest"
	var/datum/quest/assigned_quest
	var/last_compass_direction = ""
	var/last_z_level_hint = ""
	var/last_whisper = 0 // Last time the scroll whispered to the user
	resistance_flags = FIRE_PROOF | LAVA_PROOF | INDESTRUCTIBLE | UNACIDABLE
	max_integrity = 1000
	armor = ARMOR_INDESTRUCTIBLE

/obj/item/paper/scroll/quest/Initialize()
	. = ..()
	if(assigned_quest)
		assigned_quest.quest_scroll = src
	update_quest_text()
	START_PROCESSING(SSprocessing, src)
	GLOB.quest_scrolls += src

/obj/item/paper/scroll/quest/Destroy()
	GLOB.quest_scrolls -= src
	if(assigned_quest)
		// Return deposit if scroll is destroyed before completion
		if(!assigned_quest.complete)
			var/refund = assigned_quest.calculate_deposit()

			// First try to return to quest giver if available
			var/mob/giver = assigned_quest.quest_giver_reference?.resolve()
			if(giver && SStreasury.has_account(giver))
				SStreasury.transfer(SStreasury.discretionary_fund, SStreasury.get_account(giver), refund, "contract scroll refund to [giver.real_name]")
			// Otherwise try quest receiver
			else if(assigned_quest.quest_receiver_reference)
				var/mob/receiver = assigned_quest.quest_receiver_reference.resolve()
				if(receiver && SStreasury.has_account(receiver))
					SStreasury.transfer(SStreasury.discretionary_fund, SStreasury.get_account(receiver), refund, "contract scroll refund to [receiver.real_name]")

		// Clean up the quest
		qdel(assigned_quest)
		assigned_quest = null
	STOP_PROCESSING(SSprocessing, src)
	return ..()

/obj/item/paper/scroll/quest/update_icon_state()
	if(open)
		icon_state = info ? "[base_icon_state]_info" : "[base_icon_state]"
	else
		icon_state = "[base_icon_state]_closed"


/obj/item/paper/scroll/quest/process()
	if(world.time > last_whisper + WHISPER_COOLDOWN)
		last_whisper = world.time
		target_whisper()

/obj/item/paper/scroll/quest/proc/target_whisper()
	if(!assigned_quest || assigned_quest.complete || !assigned_quest.quest_receiver_reference)
		return
	var/obj/itemloc = src.loc
	var/mob/quest_bearer = assigned_quest.quest_receiver_reference?.resolve()
	// I should refactor this out at some point
	if(!istype(itemloc, /mob/living))
		while(!istype(itemloc, /mob/living))
			if(isnull(itemloc))
				return
			itemloc = itemloc.loc
			if(istype(itemloc, /turf))
				return
	if(itemloc != quest_bearer)
		return
	if(open && quest_bearer)
		update_compass(quest_bearer)
		var/message = ""
		message = "[last_compass_direction]"
		if(last_z_level_hint)
			message += " ([last_z_level_hint])"
		to_chat(quest_bearer, span_info("The scroll whispers to you, the target is[message]"))

/obj/item/paper/scroll/quest/examine(mob/user)
	. = ..()
	if(!assigned_quest)
		return
	if(!assigned_quest.quest_receiver_reference)
		. += span_notice("This contract hasn't been claimed yet. Open it to claim it for yourself!")
	else if(assigned_quest.complete)
		. += span_notice("\nThis contract is complete! Return it to the Notice Board to claim your reward.")
		. += span_info("\nPlace it on the marked area next to the book.")
	else
		. += span_notice("\nThis contract is still in progress.")

/obj/item/paper/scroll/quest/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(P.get_sharpness())
		to_chat(user, span_warning("The enchanted scroll resists your attempts to tear it."))
		return
	if(istype(P, /obj/item/paper)) // Prevent merging with other papers/scrolls
		to_chat(user, span_warning("The magical energies prevent you from combining this with other scrolls."))
		return
	if(istype(P, /obj/item/clothing/ring/signet))
		stamp_with_signet(P, user)
		return
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!open)
			to_chat(user, span_warning("You need to open the scroll first."))
			return
		if(!assigned_quest)
			to_chat(user, span_warning("This contract scroll doesn't accept modifications."))
			return
	..()

/obj/item/paper/scroll/quest/proc/stamp_with_signet(obj/item/clothing/ring/signet/ring, mob/living/carbon/human/user)
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

/obj/item/paper/scroll/quest/proc/get_quest_assignees(var/mob/user, var/include_giver = FALSE)
	var/list/assignees = list()

	var/mob/quest_receiver = assigned_quest?.quest_receiver_reference?.resolve()
	if(quest_receiver)
		assignees += quest_receiver

	if(include_giver)
		var/mob/quest_giver = assigned_quest?.quest_giver_reference?.resolve()
		if(quest_giver)
			assignees += quest_giver

	return assignees

/obj/item/paper/scroll/quest/fire_act(exposed_temperature, exposed_volume)
	return // Immune to fire

/obj/item/paper/scroll/quest/extinguish()
	return // No fire to extinguish

/obj/item/paper/scroll/quest/read(mob/user)
	refresh_compass(user)
	return ..()

/obj/item/paper/scroll/quest/attack_self(mob/user)
	if(!assigned_quest)
		return ..()

	// Claim-on-first-open if unclaimed and the opener isn't the issuer.
	if(!assigned_quest.quest_receiver_reference)
		if(assigned_quest.quest_giver_name && assigned_quest.quest_giver_name == user.real_name)
			to_chat(user, span_warning("You cannot take a contract you yourself issued."))
			return
		assigned_quest.quest_receiver_reference = WEAKREF(user)
		assigned_quest.quest_receiver_name = user.real_name
		to_chat(user, span_notice("You claim this contract for yourself!"))
		update_quest_text()

	open = TRUE
	update_icon_state()
	refresh_compass(user)
	ui_interact(user)

/obj/item/paper/scroll/quest/ui_state(mob/user)
	return GLOB.hold_or_view_state

/obj/item/paper/scroll/quest/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "QuestScroll")
		ui.open()

/obj/item/paper/scroll/quest/ui_static_data(mob/user)
	var/list/data = list()
	if(!assigned_quest)
		data["empty"] = TRUE
		return data
	data["title"] = assigned_quest.get_title()
	data["type"] = assigned_quest.quest_type
	data["difficulty"] = assigned_quest.quest_difficulty
	data["issued_by"] = assigned_quest.quest_giver_name || "The Mercenary's Guild"
	data["issued_to"] = assigned_quest.quest_receiver_name || "whoever it may concern"
	data["issued_on"] = assigned_quest.issued_day ? get_ic_date_short_as_string(assigned_quest.issued_day) : null
	data["objective"] = assigned_quest.get_objective_text()
	data["location_fields"] = assigned_quest.get_location_fields()
	data["reward"] = assigned_quest.reward_amount
	data["progress_required"] = assigned_quest.progress_required
	data["is_rumor"] = assigned_quest.source == QUEST_SOURCE_RUMOR
	data["is_defense"] = assigned_quest.source == QUEST_SOURCE_DEFENSE
	return data

/obj/item/paper/scroll/quest/ui_data(mob/user)
	var/list/data = list()
	if(!assigned_quest)
		return data
	refresh_compass(user)
	data["compass_direction"] = last_compass_direction
	data["z_hint"] = last_z_level_hint
	data["progress_current"] = assigned_quest.progress_current
	data["complete"] = assigned_quest.complete
	data["levy_exempt"] = assigned_quest.levy_exempt
	return data

/obj/item/paper/scroll/quest/proc/update_quest_text()
	if(!assigned_quest)
		return

	var/scroll_text = "<center>HELP NEEDED</center><br>"
	scroll_text += "<center><b>[assigned_quest.get_title()]</b></center><br>"
	scroll_text += "<b>Issued by:</b> [assigned_quest.quest_giver_name ? "[assigned_quest.quest_giver_name]" : "The Mercenary's Guild"].<br>"
	scroll_text += "<b>Issued to:</b> [assigned_quest.quest_receiver_name ? assigned_quest.quest_receiver_name : "whoever it may concern"].<br>"
	scroll_text += "<b>Type:</b> [assigned_quest.quest_type] contract.<br>"
	scroll_text += "<b>Difficulty:</b> [assigned_quest.quest_difficulty].<br><br>"

	if(last_compass_direction)
		scroll_text += "<b>Direction:</b> The target is[last_compass_direction]. "
		if(last_z_level_hint)
			scroll_text += " ([last_z_level_hint])"
		scroll_text += "<br>"

	scroll_text += "<b>Objective:</b> [assigned_quest.get_objective_text()]<br>"

	// Show progress if applicable
	if(assigned_quest.progress_required > 1)
		scroll_text += "<b>Progress:</b> [assigned_quest.progress_current]/[assigned_quest.progress_required]<br>"

	scroll_text += "<b>Location:</b> [assigned_quest.get_location_text()]<br>"
	scroll_text += "<br><b>Reward:</b> [assigned_quest.reward_amount] mammon upon completion<br>"

	if(assigned_quest.complete)
		scroll_text += "<br><center><b>CONTRACT COMPLETE</b></center>"
		scroll_text += "<br><b>Return this scroll to the Notice Board to claim your reward!</b>"
		scroll_text += "<br><i>Place it on the marked area next to the book.</i>"
	else
		scroll_text += "<br><i>The magic in this scroll will update as you progress.</i>"

	if(assigned_quest.levy_exempt)
		scroll_text += "<br><br><center><i>By Royal Seal and Ducal Prerogative, the bearer of this contract is held exempt from the Crown's Levy upon its reward.</i></center>"

	info = scroll_text
	update_icon()

/obj/item/paper/scroll/quest/proc/refresh_compass(mob/user)
	if(!assigned_quest || assigned_quest.complete)
		return FALSE

	// Update compass with precise directions
	update_compass(user)

	// Only update text if we have a valid direction
	if(last_compass_direction)
		update_quest_text()
		return TRUE

	return FALSE

/obj/item/paper/scroll/quest/proc/update_compass(mob/user)
	if(!assigned_quest || assigned_quest.complete)
		return

	var/turf/user_turf = user ? get_turf(user) : get_turf(src)
	if(!user_turf)
		last_compass_direction = " No signal detected"
		last_z_level_hint = ""
		return

	// Reset compass values
	last_compass_direction = " Searching for target..."
	last_z_level_hint = ""

	// Get target location from quest datum
	var/turf/target_turf = assigned_quest.get_target_location()
	if(!target_turf)
		last_compass_direction = " location unknown"
		last_z_level_hint = ""
		return

	// We want the target to know z level differences but verticality exists
	// We don't want to frustrate player by forcing them to track on the same z level
	// Especially cuz of how many transitions exist
	if(target_turf.z != user_turf.z)
		var/z_diff = abs(target_turf.z - user_turf.z)
		last_z_level_hint = target_turf.z > user_turf.z ? \
			"[z_diff] level\s above you" : \
			"[z_diff] level\s below you"

	// Calculate direction from user to target
	var/dx = target_turf.x - user_turf.x  // EAST direction
	var/dy = target_turf.y - user_turf.y  // NORTH direction
	var/distance = sqrt(dx*dx + dy*dy)

	// If very close, don't show direction
	if(distance <= 7)
		last_compass_direction = " is nearby"
		last_z_level_hint = ""
		return

	// Get precise direction text
	var/direction_text = get_precise_direction_between(user_turf, target_turf)
	if(!direction_text)
		direction_text = "unknown direction"

	// Determine distance description
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
