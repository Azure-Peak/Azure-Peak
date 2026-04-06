GLOBAL_LIST_EMPTY(quest_scrolls)
/obj/item/paper/scroll/quest
	name = "enchanted contract scroll"
	desc = "A scroll oft known as a \"whispering scroll\". Its enchantment remembers the contract's target and the proper map, but directional tracking must be read through a linked compass.\n\
	The magical protections make it resistant to damage and tampering."
	icon = 'code/modules/roguetown/roguemachine/questing/questing.dmi'
	icon_state = "scroll_quest"
	var/base_icon_state = "scroll_quest"
	var/datum/quest/assigned_quest
	var/last_target_map_text = ""
	resistance_flags = FIRE_PROOF | LAVA_PROOF | INDESTRUCTIBLE | UNACIDABLE
	max_integrity = 1000
	armor = list("blunt" = 100, "slash" = 100, "stab" = 100, "piercing" = 100, "fire" = 100, "acid" = 100)

/obj/item/paper/scroll/quest/Initialize()
	. = ..()
	if(assigned_quest)
		assigned_quest.quest_scroll = src
	update_quest_text()
	GLOB.quest_scrolls += src

/obj/item/paper/scroll/quest/Destroy()
	GLOB.quest_scrolls -= src
	if(assigned_quest)
		if(!assigned_quest.complete)
			var/refund = assigned_quest.deposit_amount || assigned_quest.calculate_deposit(assigned_quest.reward_amount)
			if(refund > 0)
				var/mob/giver = assigned_quest.quest_giver_reference?.resolve()
				if(giver && (giver in SStreasury.bank_accounts))
					SStreasury.bank_accounts[giver] += refund
					SStreasury.treasury_value -= refund
					SStreasury.log_entries += "-[refund] from treasury (contract scroll destroyed refund to giver [giver.real_name])"
				else if(assigned_quest.quest_receiver_reference)
					var/mob/receiver = assigned_quest.quest_receiver_reference.resolve()
					if(receiver && (receiver in SStreasury.bank_accounts))
						SStreasury.bank_accounts[receiver] += refund
						SStreasury.treasury_value -= refund
						SStreasury.log_entries += "-[refund] from treasury (contract scroll destroyed refund to receiver [receiver.real_name])"

		qdel(assigned_quest)
		assigned_quest = null
	return ..()

/obj/item/paper/scroll/quest/update_icon_state()
	. = ..()
	if(open)
		icon_state = info ? "[base_icon_state]_info" : "[base_icon_state]"
	else
		icon_state = "[base_icon_state]_closed"

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
	if(istype(P, /obj/item/quest_compass))
		var/obj/item/quest_compass/quest_compass = P
		quest_compass.link_to_scroll(src, user)
		return
	if(istype(P, /obj/item/paper)) // Prevent merging with other papers/scrolls
		to_chat(user, span_warning("The magical energies prevent you from combining this with other scrolls."))
		return
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!open)
			to_chat(user, span_warning("You need to open the scroll first."))
			return
		if(!assigned_quest)
			to_chat(user, span_warning("This contract scroll doesn't accept modifications."))
			return
	..()

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
	update_quest_text()
	return ..()

/obj/item/paper/scroll/quest/attack_self(mob/user)
	. = ..()
	if(.)
		return

	// Only do claim logic if unclaimed
	if(!assigned_quest || assigned_quest.quest_receiver_reference)
		update_quest_text()
		return

	// Claim the quest
	assigned_quest.quest_receiver_reference = WEAKREF(user)
	assigned_quest.quest_receiver_name = user.real_name

	to_chat(user, span_notice("You claim this contract for yourself!"))
	update_quest_text()

/obj/item/paper/scroll/quest/AltClick(mob/user)
	. = ..()
	to_chat(user, span_notice("The scroll remembers the route, but you must claim a quest compass from the Grand Contract Ledger and link it manually."))

/obj/item/paper/scroll/quest/proc/update_quest_text()
	if(!assigned_quest)
		return

	var/compass_hint_text = "Claim a quest compass from the Grand Contract Ledger, then use it on this scroll."
	var/scroll_text = "<center>HELP NEEDED</center><br>"
	scroll_text += "<center><b>[assigned_quest.get_title()]</b></center><br>"
	scroll_text += "<b>Issued by:</b> [assigned_quest.quest_giver_name ? "[assigned_quest.quest_giver_name]" : "The Mercenary's Guild"].<br>"
	scroll_text += "<b>Issued to:</b> [assigned_quest.quest_receiver_name ? assigned_quest.quest_receiver_name : "whoever it may concern"].<br>"
	scroll_text += "<b>Group:</b> [assigned_quest.contract_group].<br>"
	scroll_text += "<b>Type:</b> [assigned_quest.quest_type] contract.<br>"
	scroll_text += "<b>Threat:</b> [assigned_quest.get_tier_label()].<br><br>"

	scroll_text += "<b>Objective:</b> [assigned_quest.get_objective_text()]<br>"

	// Show progress if applicable
	if(assigned_quest.progress_required > 1)
		scroll_text += "<b>Progress:</b> [assigned_quest.progress_current]/[assigned_quest.progress_required]<br>"

	var/current_map_text = assigned_quest.get_target_map_text(get_turf(src))
	if(!assigned_quest.complete || !last_target_map_text || findtext(current_map_text, "Error:") != 1)
		last_target_map_text = current_map_text
	scroll_text += "<b>Map:</b> [last_target_map_text]<br>"
	scroll_text += "<b>Location:</b> [assigned_quest.get_location_text()]<br>"
	scroll_text += "<br><b>Reward:</b> [assigned_quest.reward_amount] amna upon completion<br>"

	if(assigned_quest.complete)
		scroll_text += "<br><center><b>CONTRACT COMPLETE</b></center>"
		scroll_text += "<br><b>Return this scroll to the Notice Board to claim your reward!</b>"
		scroll_text += "<br><i>Place it on the marked area next to the book.</i>"
		if(assigned_quest.quest_giver_reference)
			scroll_text += "<br><br><i>Return this to [assigned_quest.quest_giver_name] for increased pay!</i>"
		else
			scroll_text += "<br><br><i>Consider getting in touch with a Merchant, Banker, or Steward for your next quest for increased pay!</i>"
	else
		scroll_text += "<br><i>The magic in this scroll will update as you progress.</i>"
		if(assigned_quest.quest_giver_reference)
			scroll_text += "<br><br><i>Returning this to [assigned_quest.quest_giver_name] upon completion will yield increased pay!</i>"
		else
			scroll_text += "<br><br><i>Consider getting in touch with a Merchant, Banker, or Steward for your next quest for increased pay!</i>"
		scroll_text += "<br><i>[compass_hint_text]</i>"

	info = scroll_text
	update_icon()