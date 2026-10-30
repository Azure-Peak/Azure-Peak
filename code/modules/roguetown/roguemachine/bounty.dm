/obj/structure/roguemachine/bounty
	name = "EXCIDIUM"
	desc = "A device hungering for flesh and souls of the wicked. While favored by Astratan orders and tolerated by Ravoxian sects, it is seen as nothing more than a barbaric implement for turbulent tymes by anyone else. This one lets you meditate upon those who need to be brought to justice."
	icon = 'icons/roguetown/topadd/statue1.dmi'
	icon_state = "baldguy"
	density = FALSE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	max_integrity = 999999

/obj/structure/roguemachine/bounty/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Click to interact with the bounty system.")
	. += span_info("You can consult active bounties and print a list. Authorized officials can set or remove bounties for their faction.")
	. += span_info("Setting a bounty costs mammon from your bank account.")

/datum/bounty
	var/target
	var/target_race
	var/gender
	var/target_body_type
	var/target_body_prefix
	var/target_height
	var/target_voice_prefix
	var/amount
	var/reason
	var/employer
	var/faction
	var/unremovable = FALSE

	/// Whats displayed when consulting the bounties
	var/banner

/obj/structure/roguemachine/bounty/attack_hand(mob/user)

	if(!ishuman(user)) return

	// We need to check the user's bank account later
	var/mob/living/carbon/human/H = user

	// Main Menu
	var/list/choices = list("Consult Bounties", "Print List of Bounties")
	if(get_bounty_faction_for_user(H))
		choices += "Print Key of Absolution"
	var/selection = input(user, "The Excidium listens", src) as null|anything in choices

	switch(selection)

		if("Consult Bounties")
			consult_bounties(H)

		if("Print List of Bounties")
			print_bounty_scroll(H)

		if("Print Key of Absolution")
			print_castifico_key(H)

/obj/structure/roguemachine/bounty/attackby(obj/item/P, mob/user, params)

	if(!(ishuman(user))) return

///Shows all active bounties to the user.
/obj/structure/roguemachine/bounty/proc/consult_bounties(mob/living/carbon/human/user)
	ui_interact(user)

/obj/structure/roguemachine/bounty/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/bounty/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Bounty", "Active Bounties")
		ui.open()

/obj/structure/roguemachine/bounty/ui_data(mob/user)
	return get_bounty_tgui_data(user)

/obj/structure/roguemachine/bounty/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	return handle_bounty_ui_action(src, action, params, usr)

/proc/get_bounty_tgui_data(mob/user)
	var/list/data = list()
	var/list/bounties = list()
	for(var/datum/bounty/saved_bounty in GLOB.head_bounties)
		var/bounty_faction = saved_bounty.faction || get_bounty_faction_for_employer(saved_bounty.employer)
		if(!bounty_faction)
			continue
		var/display_reason = html_decode(saved_bounty.reason)
		display_reason = replacetext(display_reason, "<BR>", "\n")
		bounties += list(list(
			"ref" = "\ref[saved_bounty]",
			"target" = saved_bounty.target,
			"employer" = saved_bounty.employer,
			"faction" = bounty_faction,
			"unremovable" = saved_bounty.unremovable,
			"amount" = saved_bounty.amount,
			"reason" = display_reason,
			"race" = "[saved_bounty.target_race]",
			"height" = saved_bounty.target_height,
			"body_type" = saved_bounty.target_body_type,
			"body" = saved_bounty.target_body_prefix,
			"voice" = saved_bounty.target_voice_prefix,
		))
	data["bounties"] = bounties
	var/faction = get_bounty_faction_for_user(user)
	data["can_manage"] = faction ? TRUE : FALSE
	data["manage_faction"] = faction || ""
	var/list/known_targets = list()
	data["balance"] = 0
	data["has_account"] = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mind?.known_people?.len)
			for(var/mob/living/carbon/human/known_person in GLOB.human_list)
				if(known_person.real_name in H.mind.known_people)
					known_targets += known_person.real_name
		data["has_account"] = SStreasury.has_account(H)
		if(data["has_account"])
			data["balance"] = SStreasury.get_balance(H)
	data["known_targets"] = known_targets
	return data

/proc/get_bounty_faction_for_user(mob/user)
	if(!ishuman(user))
		return
	if(user == SSticker.rulermob || user == SSticker.regentmob)
		return "crown"
	switch(user.job)
		if("Marshal", "Hand")
			return "crown"
		if("Bishop", "Martyr")
			return "church"
		if("Templar")
			if(!bounty_faction_has_primary_leader(list("Bishop", "Martyr")))
				return "church"
		if("Inquisitor", "Absolver")
			return "inquisition"
		if("Orthodoxist")
			if(!bounty_faction_has_primary_leader(list("Inquisitor", "Absolver")))
				return "inquisition"

/proc/bounty_faction_has_primary_leader(list/primary_jobs)
	for(var/mob/living/carbon/human/leader in GLOB.human_list)
		if(leader.job in primary_jobs)
			return TRUE
	return FALSE

/proc/get_bounty_faction_for_employer(employer)
	switch(employer)
		if("The Justiciary of Azuria")
			return "crown"
		if("The Grenzelhoftian Holy See")
			return "church"
		if("The Otavan Orthodoxy")
			return "inquisition"

/proc/get_bounty_for_target_faction(target_name, faction)
	for(var/datum/bounty/saved_bounty in GLOB.head_bounties)
		var/bounty_faction = saved_bounty.faction || get_bounty_faction_for_employer(saved_bounty.employer)
		if(saved_bounty.target == target_name && bounty_faction == faction)
			return saved_bounty

/proc/handle_bounty_ui_action(atom/movable/source, action, list/params, mob/user)
	if(!ishuman(user))
		return FALSE
	if(istype(source, /obj/item/bountyscroll))
		to_chat(user, span_warning("The scroll only displays active bounties."))
		return TRUE
	var/mob/living/carbon/human/H = user
	var/faction = get_bounty_faction_for_user(user)
	if(!faction)
		to_chat(user, span_warning("You are not authorized to manage bounties."))
		return TRUE
	var/faction_name
	switch(faction)
		if("crown")
			faction_name = "The Crown"
		if("church")
			faction_name = "The Church"
		if("inquisition")
			faction_name = "The Inquisition"

	switch(action)
		if("set_bounty")
			var/target_name = params["target"]
			if(!H.mind || !(target_name in H.mind.known_people))
				to_chat(user, span_warning("You may only set bounties on people you know."))
				return TRUE
			var/mob/living/carbon/human/target
			for(var/mob/living/carbon/human/known_person in GLOB.human_list)
				if(known_person.real_name == target_name)
					target = known_person
					break
			if(!target)
				to_chat(user, span_warning("That target is no longer available."))
				return TRUE

			var/datum/bounty/existing_bounty = get_bounty_for_target_faction(target.real_name, faction)
			var/amount = text2num(params["amount"])
			var/minimum_amount = existing_bounty ? 1 : 100
			if(amount < minimum_amount || amount > 500 || round(amount) != amount)
				to_chat(user, span_warning("Bounty amount must be a whole number between [minimum_amount] and 500 mammon."))
				return TRUE
			if(existing_bounty && existing_bounty.amount + amount > 500)
				to_chat(user, span_warning("The combined bounty cannot exceed 500 mammon."))
				return TRUE
			if(!SStreasury.has_account(user))
				to_chat(user, span_warning("You have no bank account."))
				return TRUE
			if(SStreasury.get_balance(user) < amount)
				to_chat(user, span_warning("Insufficient funds."))
				return TRUE

			var/reason = params["reason"]
			if(!istext(reason) || !length(trim(reason)))
				to_chat(user, span_warning("A reason is required."))
				return TRUE

			amount = round(amount)
			var/datum/fund/user_account = SStreasury.get_account(user)
			if(!SStreasury.burn(user_account, amount, "bounty placement - [target.real_name]", LEDGER_CITIZEN_CONTRACT_PAID))
				to_chat(user, span_warning("Insufficient funds."))
				return TRUE

			var/list/d_list = target.get_mob_descriptors()
			var/descriptor_height = build_coalesce_description_nofluff(d_list, target, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
			var/descriptor_body = build_coalesce_description_nofluff(d_list, target, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
			var/descriptor_voice = build_coalesce_description_nofluff(d_list, target, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
			add_bounty(target.real_name, target.dna.species, target.gender, descriptor_height, descriptor_body, descriptor_voice, amount, reason, user.real_name, faction)
			playsound(source, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
			source.say("The Excidium hungers for [target].")
			if(existing_bounty)
				scom_announce("[faction_name]'s bounty on [target] has increased by [amount] mammon to [existing_bounty.amount] mammon.")
			else
				scom_announce("[faction_name] has posted a bounty of [amount] mammon for [target].")
			message_admins("[ADMIN_LOOKUPFLW(user)] has set a bounty on [ADMIN_LOOKUPFLW(target)] with the reason of: '[reason]'")
			return TRUE

		if("remove_bounty")
			var/datum/bounty/removing_bounty = locate(params["ref"]) in GLOB.head_bounties
			if(!removing_bounty || removing_bounty.unremovable)
				to_chat(user, span_warning("That bounty cannot be removed."))
				return TRUE
			var/bounty_faction = removing_bounty.faction || get_bounty_faction_for_employer(removing_bounty.employer)
			if(bounty_faction != faction)
				to_chat(user, span_warning("You may only remove bounties from your faction."))
				return TRUE

			var/target_name = removing_bounty.target
			GLOB.head_bounties -= removing_bounty
			scom_announce("[faction_name]'s bounty posting on [target_name] has been removed.")
			message_admins("[ADMIN_LOOKUPFLW(user)] has removed the bounty on [ADMIN_LOOKUPFLW(target_name)]")
			return TRUE

	return FALSE

/proc/add_bounty(target_realname, race, gender, descriptor_height, descriptor_body, descriptor_voice, amount, reason, employer_name, bounty_faction = null, unremovable = FALSE)
	var/resolved_faction = bounty_faction || get_bounty_faction_for_employer(employer_name)
	var/datum/bounty/existing_bounty = get_bounty_for_target_faction(target_realname, resolved_faction)
	if(existing_bounty)
		existing_bounty.amount = min(existing_bounty.amount + amount, 500)
		existing_bounty.reason += "\n[html_encode(reason)]"
		existing_bounty.unremovable = existing_bounty.unremovable || unremovable
		existing_bounty.banner = ""
		compose_bounty(existing_bounty)
		return existing_bounty

	var/datum/bounty/new_bounty = new /datum/bounty
	new_bounty.amount = min(amount, 500)
	new_bounty.target = target_realname
	new_bounty.reason = html_encode(reason)
	new_bounty.employer = employer_name
	new_bounty.faction = resolved_faction
	new_bounty.unremovable = unremovable
	new_bounty.target_race = race
	new_bounty.target_height = LOWER_TEXT(descriptor_height)
	if(descriptor_body == "Average" || descriptor_body == "Athletic")
		var/bro_unreal = "an "
		new_bounty.target_body_prefix = LOWER_TEXT(bro_unreal += descriptor_body)
	else
		var/bro_real = "a "
		new_bounty.target_body_prefix = LOWER_TEXT(bro_real += descriptor_body)
	if(descriptor_voice == "Ordinary" || descriptor_voice == "Androgynous")
		var/bro_unreal = "an "
		new_bounty.target_voice_prefix = LOWER_TEXT(bro_unreal += descriptor_voice)
	else
		var/bro_real = "a "
		new_bounty.target_voice_prefix = LOWER_TEXT(bro_real += descriptor_voice)
	if(gender == MALE)
		new_bounty.target_body_type = "masculine"
	else
		new_bounty.target_body_type = "feminine"
	compose_bounty(new_bounty)
	GLOB.head_bounties += new_bounty

///Composes a random bounty banner based on the given bounty info.
///@param new_bounty:	The bounty datum.
/proc/compose_bounty(datum/bounty/new_bounty)
	new_bounty.banner += "'[new_bounty.employer]' hath offered to pay '[new_bounty.amount]' mammon for the capture of '[new_bounty.target]'.<BR>"
	new_bounty.banner += "By reason of the following: '[new_bounty.reason]'.<BR>"
	new_bounty.banner += "They belong to the '[new_bounty.target_race]' race.<BR>"
	new_bounty.banner += "Going by the following description: they are of '[new_bounty.target_height]' height, of a '[new_bounty.target_body_type]' build and they have '[new_bounty.target_body_prefix]' physique. They speak with '[new_bounty.target_voice_prefix]' voice.<BR>"
	new_bounty.banner += "--------------<BR>"

/obj/structure/roguemachine/bounty/proc/print_bounty_scroll(mob/living/carbon/human/user)
	if(!GLOB.head_bounties.len)
		say("No bounties are currently active.")
		return

	var/cost = 100
	var/choice = alert(user, "Print a continuously updated list of active bounties for [cost] mammon?", "Print Bounty Scroll", "Yes", "No")
	if(choice != "Yes")
		return

	if(!SStreasury.has_account(user))
		say("You have no bank account.")
		return

	if(SStreasury.get_balance(user) < cost)
		say("Insufficient funds. [cost] mammon required.")
		return

	SStreasury.transfer(SStreasury.get_account(user), SStreasury.discretionary_fund, cost, "bounty scroll fee", null, LEDGER_CROWN_REV_OTHER)

	new /obj/item/bountyscroll(get_turf(src))
	playsound(src, 'sound/items/scroll_open.ogg', 100, TRUE)
	visible_message(span_notice("The [src] prints out a weathered scroll."))
	say("Your scroll is ready.")

/obj/structure/roguemachine/bounty/proc/print_castifico_key(mob/living/carbon/human/user)
	var/faction = get_bounty_faction_for_user(user)
	if(!faction)
		to_chat(user, span_warning("You are not authorized to issue keys of absolution."))
		return

	var/cost = 50
	var/choice = alert(user, "Print a key of absolution for [cost] mammon?", "Print Key of Absolution", "Yes", "No")
	if(choice != "Yes")
		return

	if(!SStreasury.has_account(user))
		to_chat(user, span_warning("You have no bank account."))
		return

	var/datum/fund/user_account = SStreasury.get_account(user)
	if(SStreasury.get_balance(user) < cost)
		to_chat(user, span_warning("Insufficient funds. [cost] mammon required."))
		return
	if(!SStreasury.transfer(user_account, SStreasury.discretionary_fund, cost, "castifico key fee", null, LEDGER_CROWN_REV_OTHER))
		to_chat(user, span_warning("The Excidium could not process the payment."))
		return

	var/obj/item/castifico_key/key = new(get_turf(src))
	key.faction = faction
	key.desc = "A key issued by the [faction], made to unlock castifico collars issued by the same faction."
	playsound(src, 'sound/items/scroll_open.ogg', 100, TRUE)
	visible_message(span_notice("The [src] produces a key of absolution."))
	say("Your key is ready.")

/obj/item/bountyscroll
	name = "enchanted bounty scroll"
	desc = "A weathered scroll enchanted to list the active bounties from the Excidium."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scroll_prep"
	w_class = WEIGHT_CLASS_TINY
	slot_flags = null
	var/open = FALSE
	dropshrink = 0.6

/obj/item/bountyscroll/attack_self(mob/user)
	if(!open)
		attack_right(user)
	ui_interact(user)

/obj/item/bountyscroll/rmb_self(mob/user, keybind = FALSE)
	attack_right(user)
	return

/obj/item/bountyscroll/attack_right(mob/user)
	if(open)
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(src, 'sound/items/scroll_close.ogg', 100, FALSE)
		SStgui.close_uis(src)
	else
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(src, 'sound/items/scroll_open.ogg', 100, FALSE)
	update_icon_state()
	user.update_inv_hands()

/obj/item/bountyscroll/update_icon_state()
	icon_state = open ? "scrollred" : "scroll_prep"

/obj/item/bountyscroll/ui_state(mob/user)
	return GLOB.hold_or_view_state

/obj/item/bountyscroll/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Bounty", "Active Bounties")
		ui.open()

/obj/item/bountyscroll/ui_data(mob/user)
	var/list/data = get_bounty_tgui_data(user)
	data["can_manage"] = FALSE
	return data

/obj/item/bountyscroll/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	return handle_bounty_ui_action(src, action, params, usr)

/obj/structure/chair/freedomchair
	name = "LIBERTAS"
	desc = "A chair-shaped machine normally used to place cursed collars onto a prisoner's neck. \
	This one's been tampered with, and now does the opposite - re-purposed to remove those wretched iron collars."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "evilchair"
	blade_dulling = DULLING_BASH
	color = "#F75D59"
	item_chair = null
	anchored = TRUE

/obj/structure/chair/freedomchair/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Buckle a collared prisoner to the chair, then right-click to remove their castifico collar.")
	. += span_info("Using this will leave the subject's body weakened for some time. Dying during this time will leave them unrevivable.")
	. += span_info("Crafted versions are unstable and will explode when used on a prisoner.")

/obj/structure/chair/freedomchair/crafted
	desc = "A machine shaped like a chair and normally used to place cursed collars onto a prisoner's neck. This one's clearly been tampered with and looks suspicious."

/obj/structure/chair/freedomchair/crafted/attack_right(mob/living/carbon/human/A)
	var/mob/living/carbon/human/M = null
	for(var/l in buckled_mobs)
		M = l
	if(!ismob(M))
		say("CANNOT BEGIN WITHOUT SUBJECT BUCKLED.")
		return
	if(!ishuman(M))
		say("ENTITY IS NOT HUMAN. ABORT. ABORT.")
		return
	if(!M.buckled)
		say("SUBJECT... NOT PROPERLY SECURED...")
		return
	if(!do_after(A, 3 SECONDS, TRUE, M))
		return

	playsound(src.loc, 'sound/items/pickgood1.ogg', 100, TRUE, -1)
	M.Paralyze(3 SECONDS)

	var/obj/item/clothing/neck/old_mask = M.get_item_by_slot(SLOT_NECK)
	if(old_mask)
		if(istype(old_mask, /obj/item/clothing/neck/roguetown/collar/prisoner))
			say("ERROR: UNLAWFUL SYSTEM TAMPERING DETECTED... ENGAGING SELF DESTRUCT...")
			sleep(1 SECONDS)
			explosion(src, light_impact_range = 1, flame_range = 1)
			M.dropItemToGround(old_mask, TRUE)
			qdel(src)
	else
		say("ANALYSIS COMPLETE. NO CURSED COLLAR FOUND. ABORT.")
		return

/obj/structure/chair/freedomchair/attack_right(mob/living/carbon/human/A)
	var/mob/living/carbon/human/M = null
	for(var/l in buckled_mobs)
		M = l
	if(!ismob(M))
		say("CANNOT BEGIN WITHOUT SUBJECT BUCKLED.")
		return
	if(!ishuman(M))
		say("ENTITY IS NOT HUMAN. ABORT. ABORT.")
		return
	if(!M.buckled)
		say("SUBJECT... NOT PROPERLY SECURED...")
		return
	if(!do_after(A, 3 SECONDS, TRUE, M))
		return

	playsound(src.loc, 'sound/items/pickgood1.ogg', 100, TRUE, -1)
	M.Paralyze(3 SECONDS)

	var/obj/item/clothing/neck/old_mask = M.get_item_by_slot(SLOT_NECK)
	if(old_mask)
		if(istype(old_mask, /obj/item/clothing/neck/roguetown/collar/prisoner))
			say("COLLAR DISCARDED. FREEDOM, AT LAST...")
			M.dropItemToGround(old_mask, TRUE)
			M.apply_status_effect(/datum/status_effect/debuff/devitalised)
			M.apply_status_effect(/datum/status_effect/debuff/permadeath)
			M.play_permadeath_indicator()
	else
		say("ANALYSIS COMPLETE. NO CURSED COLLAR FOUND. ABORT.")
		return

/obj/structure/chair/arrestchair
	name = "CASTIFICO"
	desc = "A crude metal chair with clasps to hold down any rapscallion the EXCIDIUM deems worthy of punishment. A simple pull of a lever is all it takes."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "evilchair"
	blade_dulling = DULLING_BASH
	item_chair = null
	anchored = TRUE
	var/submission = TRUE
	var/bounty_faction
	max_integrity = 999999

/obj/structure/chair/arrestchair/crown
	name = "CROWN CASTIFICO"
	bounty_faction = "crown"

/obj/structure/chair/arrestchair/church
	name = "CHURCH CASTIFICO"
	bounty_faction = "church"

/obj/structure/chair/arrestchair/inquisition
	name = "INQUISITION CASTIFICO"
	bounty_faction = "inquisition"

/obj/structure/chair/arrestchair/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Buckle a bounty target to the chair, then right-click to process them.")
	if(bounty_faction)
		. += span_info("This CASTIFICO only claims bounties posted by [bounty_faction].")
	. += span_info("If they have an active bounty, they will be fitted with a pacification collar and you will receive a reward.")
	. += span_info("The target can submit or resist. Resisting is fatal.")
	. += span_info("Outlaws cannot operate this machine.")

/obj/structure/chair/arrestchair/attack_right(mob/living/carbon/human/A)
	. = ..()
	submission = TRUE
	var/mob/living/carbon/human/M = null
	for(var/l in buckled_mobs)
		M = l
		if(HAS_TRAIT(A, TRAIT_OUTLAW))
			var/def_zone = "[(A.active_hand_index == 2) ? "r" : "l" ]_arm"
			playsound(A, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
			loc.visible_message(span_warning("The castifico snaps at [A]'s hand!"))
			to_chat(A, span_danger("The machine wants YOU!"))
			A.flash_fullscreen("redflash3")
			A.Stun(10)
			A.apply_damage(10, BRUTE, def_zone)
			A.emote("whimper", forced = TRUE)
			return
	if(!ismob(M))
		say("Unable to comply without a subject. Aborting...")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!ishuman(M))
		say("Subject is not human. Aborting...")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!M.buckled)
		say("Subject is not properly secured. Aborting...")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/obj/item/bodypart/head/headcheck
	headcheck = M.get_bodypart(check_zone(BODY_ZONE_HEAD))
	if(!headcheck)
		say("Subject is missing cranium. Aborting...")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!do_after(A, 5 SECONDS, TRUE, M))
		return

	playsound(src.loc, 'sound/items/beartrap.ogg', 100, TRUE, -1)
	M.Paralyze(3 SECONDS)

	var/correct_head = FALSE
	var/reward_amount = 0

	for(var/datum/bounty/b in GLOB.head_bounties)
		var/bounty_entry_faction = b.faction || get_bounty_faction_for_employer(b.employer)
		if(bounty_faction && b.target == M.real_name && bounty_entry_faction == bounty_faction)
			correct_head = TRUE
			reward_amount += b.amount
			GLOB.head_bounties -= b

	say(pick(list("Processing subject...", "Commencing PUNISHMENT routine...", "Restoring ORDER...")))

	sleep(1 SECONDS)

	if(M.stat == DEAD)
		reward_amount = reward_amount / 2
		say("Subject is deceased. Rewarding half of posted bounty amount.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		sleep(1 SECONDS)

	INVOKE_ASYNC(src, PROC_REF(giveup), M)
	say("Assessing value of lyfe...")
	sleep(10 SECONDS)

	var/list/headcrush = list('sound/combat/fracture/headcrush (2).ogg', 'sound/combat/fracture/headcrush (3).ogg', 'sound/combat/fracture/headcrush (4).ogg')
	playsound(src, pick_n_take(headcrush), 100, FALSE, -1)
	M.emote("scream")
	M.apply_damage(50, BRUTE, BODY_ZONE_HEAD, FALSE)
	sleep(1 SECONDS)
	playsound(src, pick(headcrush), 100, FALSE, -1)
	M.emote("agony")
	M.apply_damage(50, BRUTE, BODY_ZONE_HEAD, FALSE)

	sleep(2 SECONDS)

	if(correct_head)
		say("A bounty has been sated.")
		budget2change(reward_amount, A, putinhands = FALSE)

		var/obj/item/clothing/neck/old_mask = M.get_item_by_slot(SLOT_NECK)
		if(old_mask)
			M.dropItemToGround(old_mask, TRUE)
		var/obj/item/clothing/neck/roguetown/collar/prisoner/prisonmask = new(get_turf(M))
		prisonmask.issuing_faction = bounty_faction
		prisonmask.name = "[bounty_faction] castifico collar"
		M.equip_to_slot_or_del(prisonmask, SLOT_NECK, TRUE)
		playsound(src.loc, 'sound/items/beartrap.ogg', 100, TRUE, -1)
	else
		say("This head carries no reward, you fool.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)

	if(!submission)
		if(M.Adjacent(src))
			say("Resistance detected...")
			src.Shake()
			var/obj/item/bodypart/head/victim_head = M.get_bodypart(BODY_ZONE_HEAD)
			message_admins("[M.real_name] was killed by the EXCIDIUM.")
			log_admin("[M.real_name] was killed by the EXCIDIUM.")
			playsound(src, 'sound/combat/vite.ogg', 100, FALSE, -1)
			M.emote("superagony")
			M.visible_message(span_warningbig("The CASTIFICO begins GRUESOMELY SHAVING OUT every bit and ounce of [M]'s FLESH on their HEAD, leaving only a grinning, bleeding skull behind. Justice has been served."))
			victim_head.skeletonize()
			submission = TRUE
	else
		M.Unconscious(15 SECONDS)
		sleep(2 SECONDS)
		playsound(src, 'sound/combat/vite.ogg', 100, FALSE, -1)
	unbuckle_all_mobs()

/obj/structure/chair/arrestchair/proc/giveup(mob/living/carbon/human/M)
	if(alert(M, "Submit to the collar, or resist and die? You have 10 seconds to decide.", "CHOICE OF LYFE", "Submit", "Perish") == "Perish")
		message_admins("[M.real_name] chose to die to the EXCIDIUM.")
		log_admin("[M.real_name] opted to die to the EXCIDIUM.")
		if(M.Adjacent(src))	//No buffering this for later
			submission = FALSE

/obj/item/castifico_key
	name = "key of absolution"
	desc = "A key issued by a faction of the realm, made to unlock that faction's castifico collars."
	icon = 'icons/roguetown/items/keys.dmi'
	icon_state = "castikey"
	dropshrink = 0.75
	w_class = WEIGHT_CLASS_TINY
	force = 0
	throwforce = 0
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH|ITEM_SLOT_NECK
	var/faction
	var/unlock_time = 5 SECONDS

/obj/item/castifico_key/proc/can_unlock_collar(obj/item/clothing/neck/roguetown/collar/prisoner/collar)
	return faction && collar.issuing_faction == faction

/obj/item/castifico_key/proc/get_unlock_time(mob/user)
	return unlock_time

/obj/item/castifico_key/proc/play_unlock_sound(atom/target, silent_pick)
	var/sound_volume = silent_pick ? 2 : 5
	playsound(target, pick('sound/items/pickgood1.ogg', 'sound/items/pickgood2.ogg'), sound_volume, TRUE)

/obj/item/castifico_key/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)
		return

	var/mob/living/carbon/human/recipient
	var/obj/item/clothing/neck/roguetown/collar/prisoner/collar
	if(istype(target, /obj/item/clothing/neck/roguetown/collar/prisoner))
		collar = target
		if(ishuman(collar.loc))
			recipient = collar.loc
	else if(ishuman(target))
		recipient = target
		var/obj/item/neck_item = recipient.get_item_by_slot(SLOT_NECK)
		if(istype(neck_item, /obj/item/clothing/neck/roguetown/collar/prisoner))
			collar = neck_item
	if(!recipient || !collar || recipient.get_item_by_slot(SLOT_NECK) != collar)
		to_chat(user, span_warning("The castifico collar must be worn to unlock it."))
		return

	if(!can_unlock_collar(collar))
		to_chat(user, span_warning("This key cannot unlock a collar issued by another faction."))
		return

	var/unlock_duration = get_unlock_time(user)
	var/list/sound_timer_ids = list()
	if(istype(src, /obj/item/castifico_key/liberation))
		var/silent_pick = HAS_TRAIT(user, TRAIT_SILENT_LOCKPICK)
		recipient.visible_message(span_warning("[user] begins picking at [recipient]'s castifico collar..."))
		play_unlock_sound(recipient, silent_pick)
		for(var/sound_time = 3 SECONDS; sound_time < unlock_duration; sound_time += 3 SECONDS)
			sound_timer_ids += addtimer(CALLBACK(src, PROC_REF(play_unlock_sound), recipient, silent_pick), sound_time, TIMER_STOPPABLE)
	else
		recipient.visible_message(span_warning("[user] begins unlocking [recipient]'s castifico collar..."))
	var/unlock_completed = do_after(user, unlock_duration, TRUE, recipient)
	for(var/timer_id in sound_timer_ids)
		deltimer(timer_id)
	if(!unlock_completed)
		return
	if(QDELETED(src))
		return
	if(recipient.get_item_by_slot(SLOT_NECK) != collar || !can_unlock_collar(collar))
		to_chat(user, span_warning("The collar is no longer secured for unlocking."))
		return

	recipient.visible_message(span_notice("[user] uses [src] to unlock [recipient]'s collar. The key snaps in the lock and breaks."))
	playsound(recipient, 'sound/items/pickgood1.ogg', 75, TRUE)
	recipient.dropItemToGround(collar, TRUE)
	qdel(src)

/obj/item/castifico_key/get_mechanics_examine(mob/user)
	. = ..()
	if(!istype(src, /obj/item/castifico_key/liberation))
		var/key_faction = faction || "a faction of the realm"
		. += span_info("A single-use key for removing castifico collars. Use it on someone wearing a collar issued by [key_faction].")

/obj/item/castifico_key/liberation
	name = "key of liberation"
	desc = "A profane instrument fashioned to undo the shackles of the condemned and downtrodden."
	icon_state = "liberkey" //Shitty placeholder coder sprite edit. If someone re-sprites this later I'll love you forever.
	color = "#FF69B4"
	unlock_time = 25 SECONDS

/obj/item/castifico_key/liberation/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("A single-use lockpick designed for removing castifico collars, regardless of the faction they belong to.")
	. += span_info("The lockpick makes noise while in use. Unlock speed scales with lockpicking skill.")

/obj/item/castifico_key/liberation/can_unlock_collar(obj/item/clothing/neck/roguetown/collar/prisoner/collar)
	return TRUE

/obj/item/castifico_key/liberation/get_unlock_time(mob/user)
	var/pickskill = user.get_skill_level(/datum/skill/misc/lockpicking)
	return max(6 SECONDS, unlock_time - pickskill * 3 SECONDS)
