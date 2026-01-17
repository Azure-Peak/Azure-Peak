/obj/structure/roguemachine/bounty
	name = "EXCIDIUM"
	desc = "A device hungering for flesh and souls of the wicked. While favored by Astratan orders and tolerated by Ravoxian sects, it is seen as nothing more than a barbaric implement for turbulent tymes by anyone else. This one allows to meditate upon those who need to be brought to justice."
	icon = 'icons/roguetown/topadd/statue1.dmi'
	icon_state = "baldguy"
	density = FALSE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	max_integrity = 999999

/datum/bounty
	var/target
	var/target_race
	var/gender
	var/target_body_type
	var/target_body
	var/target_body_prefix
	var/target_height
	var/target_voice
	var/target_voice_prefix
	var/amount
	var/reason
	var/employer

	/// Whats displayed when consulting the bounties
	var/banner
	///Is this a bandit bounty?
	var/bandit

/obj/structure/roguemachine/bounty/attack_hand(mob/user)

	if(!ishuman(user)) return

	// We need to check the user's bank account later
	var/mob/living/carbon/human/H = user

	// Main Menu
	var/list/choices = list("Consult Bounties", "Set Bounty", "Print List of Bounties", "Remove Bounty")
	var/selection = input(user, "The Excidium listens", src) as null|anything in choices

	switch(selection)

		if("Consult Bounties")
			consult_bounties(H)

		if("Set Bounty")
			set_bounty(H)

		if("Print List of Bounties")
			print_bounty_scroll(H)

		if("Remove Bounty")
			remove_bounty(H)

/obj/structure/roguemachine/bounty/attackby(obj/item/P, mob/user, params)

	if(!(ishuman(user))) return

///Shows all active bounties to the user.
/obj/structure/roguemachine/bounty/proc/consult_bounties(mob/living/carbon/human/user)
	var/bounty_found = FALSE
	var/consult_menu
	consult_menu += "<center>BOUNTIES<BR>"
	consult_menu += "--------------<BR>"
	for(var/datum/bounty/saved_bounty in GLOB.head_bounties)
		consult_menu += saved_bounty.banner
		bounty_found = TRUE

	if(bounty_found)
		var/datum/browser/popup = new(user, "BOUNTIES", "", 500, 300)
		popup.set_content(consult_menu)
		popup.open()
	else
		say("No bounties are currently active.")

/obj/structure/roguemachine/bounty/proc/remove_bounty(mob/living/carbon/human/user)
	var/list/bounty_list = list()

	for(var/datum/bounty/removable_bounties in GLOB.head_bounties)
		if(removable_bounties.employer == user.real_name)
			bounty_list += removable_bounties.target

	if(!bounty_list.len)
		say("You have no active bounty listings to remove.")
		return

	var/target_name = input(user, "Whose name shall be struck from the wanted list?", src) as null|anything in bounty_list
	if(!target_name)
		return

	say("Removing [target_name] from bounty list...")

	for(var/datum/bounty/removing_bounty in GLOB.head_bounties)
		if(removing_bounty.target == target_name && user.real_name == removing_bounty.employer)
			GLOB.head_bounties -= removing_bounty
			scom_announce("The bounty posting on [target_name] has been removed.")
			message_admins("[ADMIN_LOOKUPFLW(user)] has removed the bounty on [ADMIN_LOOKUPFLW(target_name)]")
			return
	say("Error. Bounty no longer active.") 

///Sets a bounty on a target player through user input.
///@param user: The player setting the bounty.
/obj/structure/roguemachine/bounty/proc/set_bounty(mob/living/carbon/human/user)
	var/list/eligible_players = list()

	if(user.mind.known_people.len)
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.real_name in user.mind.known_people)
				eligible_players[H.real_name] = H
	else
		to_chat(user, span_warning("I don't know anyone."))
		return

	var/choice = input(user, "Whose name shall be etched on the wanted list?", src) as null|anything in eligible_players
	if(isnull(choice))
		say("No target selected.")
		return

	var/mob/living/carbon/human/target = eligible_players[choice]

	var/amount = input(user, "How many mammons shall be stained red for their demise?", src) as null|num
	if(isnull(amount))
		say("Invalid amount.")
		return
	if(amount < 100)
		say("Insufficient amount. Bounty must be at least 100 mammon.")
		return
	if(amount > 500)
		say("Insufficient amount. Bounties cannot be more than 500 mammon.")
		return

	// Has user a bank account?
	if(!(user in SStreasury.bank_accounts))
		say("You have no bank account.")
		return

	// Has user enough money?
	if(SStreasury.bank_accounts[user] < amount)
		say("Insufficient balance funds.")
		return

	var/reason = input(user, "For what sins do you summon the hounds of hell?", src) as null|text
	if(isnull(reason) || reason == "")
		say("No reason given.")
		return

	var/confirm = input(user, "Do you dare unleash this darkness upon the world? Your name will be known.", src) as null|anything in list("Yes", "No")
	if(isnull(confirm) || confirm == "No") return

	// Deduct money from user
	SStreasury.bank_accounts[user] -= round(amount)

	//Deduct royal tax from amount
	var/royal_tax = round(amount * 0.1)
	SStreasury.treasury_value += royal_tax
	SStreasury.log_entries += "+[royal_tax] to treasury (bounty tax)"

	amount -= royal_tax

	var/race = target.dna.species
	var/gender = target.gender
	var/list/d_list = target.get_mob_descriptors()
	var/descriptor_height = build_coalesce_description_nofluff(d_list, target, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, target, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, target, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")

	// Finally create bounty
	add_bounty(target.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, amount, FALSE, reason, user.real_name)

	//Announce it locally and on scomm
	playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
	var/bounty_announcement = "The Excidium hungers for [target]."
	say(bounty_announcement)
	scom_announce(bounty_announcement)

	message_admins("[ADMIN_LOOKUPFLW(user)] has set a bounty on [ADMIN_LOOKUPFLW(target)] with the reason of: '[reason]'")

/proc/add_bounty(target_realname, race, gender, descriptor_height, descriptor_body, descriptor_voice, amount, bandit_status, reason, employer_name)
	var/datum/bounty/new_bounty = new /datum/bounty
	new_bounty.amount = amount
	new_bounty.target = target_realname
	new_bounty.bandit = bandit_status
	new_bounty.reason = reason
	new_bounty.employer = employer_name
	new_bounty.target_race = race
	new_bounty.target_height = lowertext(descriptor_height)
	new_bounty.target_body = lowertext(descriptor_body)
	if(descriptor_body == "Average" || descriptor_body == "Athletic")
		var/bro_unreal = "an "
		new_bounty.target_body_prefix = lowertext(bro_unreal += descriptor_body)
	else
		var/bro_real = "a "
		new_bounty.target_body_prefix = lowertext(bro_real += descriptor_body)
	if(descriptor_voice == "Ordinary" || descriptor_voice == "Androgynous")
		var/bro_unreal = "an "
		new_bounty.target_voice_prefix = lowertext(bro_unreal += descriptor_voice)
	else
		var/bro_real = "a "
		new_bounty.target_voice_prefix = lowertext(bro_real += descriptor_voice)
	if(gender == MALE)
		new_bounty.target_body_type = "masculine"
	else
		new_bounty.target_body_type = "feminine"
	compose_bounty(new_bounty)
	GLOB.head_bounties += new_bounty

///Composes a random bounty banner based on the given bounty info.
///@param new_bounty:  The bounty datum.
/proc/compose_bounty(datum/bounty/new_bounty)
	new_bounty.banner += "'[new_bounty.employer]' hath offered to pay '[new_bounty.amount]' mammons for the capture of '[new_bounty.target]'.<BR>"
	new_bounty.banner += "By reason of the following: '[new_bounty.reason]'.<BR>"
	new_bounty.banner += "They are belonging to the '[new_bounty.target_race]' race.<BR>"
	new_bounty.banner += "Going by the following description: they are of '[new_bounty.target_height]' height, of a '[new_bounty.target_body_type]' build and they have '[new_bounty.target_body_prefix]' physique. They speak with '[new_bounty.target_voice_prefix]' voice.<BR>"
	new_bounty.banner += "--------------<BR>"

/obj/structure/roguemachine/bounty/proc/print_bounty_scroll(mob/living/carbon/human/user)
	if(!GLOB.head_bounties.len)
		say("No bounties are currently active.")
		return

	var/cost = 50
	var/choice = alert(user, "Print a continously updated list of active bounties for [cost] mammons?", "Print Bounty Scroll", "Yes", "No")
	if(choice != "Yes")
		return

	if(!(user in SStreasury.bank_accounts))
		say("You have no bank account.")
		return

	if(SStreasury.bank_accounts[user] < cost)
		say("Insufficient funds. [cost] mammons required.")
		return

	SStreasury.bank_accounts[user] -= cost
	SStreasury.treasury_value += cost
	SStreasury.log_entries += "+[cost] to treasury (bounty scroll fee)"

	var/obj/item/paper/scroll/bounty/scroll = new(get_turf(src))
	scroll.update_bounty_text()
	playsound(src, 'sound/items/scroll_open.ogg', 100, TRUE)
	visible_message(span_notice("The [src] prints out a weathered scroll."))
	say("Your scroll is ready.")

/obj/item/paper/scroll/bounty
	name = "enchanted bounty scroll"
	desc = "A weathered scroll enchanted to list the active bounties from the Excidium."
	icon_state = "scroll"
	open = FALSE

/obj/item/paper/scroll/bounty/examine(mob/user)
	. = ..()
	if(open)
		update_bounty_text()

/obj/item/paper/scroll/bounty/proc/update_bounty_text()
	var/scroll_text = "<center>WANTED BY THE EXCIDIUM</center><br><br>"

	for(var/datum/bounty/saved_bounty in GLOB.head_bounties)
		scroll_text += saved_bounty.banner
		scroll_text += "<br>"

	info = scroll_text

/obj/structure/chair/freedomchair
	name = "LIBERTAS"
	desc = "A chair-shaped machine normally used to place cursed masks onto a prisoner's head. This one's been tampered with, and now does the opposite - re-purposed to remove those wretched iron masks."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "evilchair"
	blade_dulling = DULLING_BASH
	color = "#F75D59"
	item_chair = null
	anchored = TRUE

/obj/structure/chair/freedomchair/crafted
	desc = "A chair-shaped machine normally used to place cursed masks onto a prisoner's head. This one's clearly been tampered with, and looks suspicious."

/obj/structure/chair/freedomchair/crafted/attack_right(mob/living/carbon/human/A)
	var/mob/living/carbon/human/M = null
	for(var/l in buckled_mobs)
		M = l
	if(!ismob(M))
		say("CANNOT BEGIN WITHOUT SUBJECT BUCKLED.")
		return
	if(!ishuman(M))
		say("NON-HUMAN ENTITY. ABORT. ABORT.")
		return
	if(!M.buckled)
		say("SUBJECT... NOT PROPERLY SECURED...")
		return
	if(!do_after(A, 3 SECONDS, TRUE, M))
		return

	playsound(src.loc, 'sound/items/pickgood1.ogg', 100, TRUE, -1)
	M.Paralyze(3 SECONDS)

	var/obj/item/clothing/mask/old_mask = M.get_item_by_slot(SLOT_WEAR_MASK)
	if(old_mask)
		if(istype(old_mask, /obj/item/clothing/mask/rogue/facemask/prisoner))
			say("ERROR: UNLAWFUL SYSTEM TAMPERING DETECTED... ENGAGING SELF DESTRUCT...")
			sleep(1 SECONDS)
			explosion(src, light_impact_range = 1, flame_range = 1)
			M.dropItemToGround(old_mask, TRUE)
			qdel(src)
	else
		say("ANALYSIS COMPLETE. NO CURSED MASK FOUND. ABORT.")
		return

/obj/structure/chair/freedomchair/attack_right(mob/living/carbon/human/A)
	var/mob/living/carbon/human/M = null
	for(var/l in buckled_mobs)
		M = l
	if(!ismob(M))
		say("CANNOT BEGIN WITHOUT SUBJECT BUCKLED.")
		return
	if(!ishuman(M))
		say("NON-HUMAN ENTITY. ABORT. ABORT.")
		return
	if(!M.buckled)
		say("SUBJECT... NOT PROPERLY SECURED...")
		return
	if(!do_after(A, 3 SECONDS, TRUE, M))
		return

	playsound(src.loc, 'sound/items/pickgood1.ogg', 100, TRUE, -1)
	M.Paralyze(3 SECONDS)

	var/obj/item/clothing/mask/old_mask = M.get_item_by_slot(SLOT_WEAR_MASK)
	if(old_mask)
		if(istype(old_mask, /obj/item/clothing/mask/rogue/facemask/prisoner))
			say("MASK DISCARDED. FREEDOM, AT LAST...")
			M.dropItemToGround(old_mask, TRUE)
	else
		say("ANALYSIS COMPLETE. NO CURSED MASK FOUND. ABORT.")
		return

/obj/structure/chair/arrestchair
	name = "CASTIFICO"
	desc = "A crude metal chair with clasps to hold down any rapscallion the EXCIDIUM deems worthy of punishment. Simple pull of a lever is all it takes."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "evilchair"
	blade_dulling = DULLING_BASH
	item_chair = null
	anchored = TRUE
	var/submission = TRUE
	max_integrity = 999999

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
			A.emote("whimper")
			return
	if(!ismob(M))
		say("Unable to comply without a subject. Aborting...")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!ishuman(M))
		say("Subject is non-human entity. Aborting...")
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
		if(b.target == M.real_name)
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
		budget2change((reward_amount))

		var/obj/item/clothing/mask/old_mask = M.get_item_by_slot(SLOT_WEAR_MASK)
		if(old_mask)
			M.dropItemToGround(old_mask, TRUE)
		var/obj/item/clothing/mask/rogue/facemask/prisoner/prisonmask = new(get_turf(M))
		prisonmask.bounty_amount = reward_amount
		M.equip_to_slot_or_del(prisonmask, SLOT_WEAR_MASK, TRUE)
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
			victim_head.skeletonize()
			submission = TRUE
	else
		M.Unconscious(15 SECONDS)
		sleep(2 SECONDS)
		playsound(src, 'sound/combat/vite.ogg', 100, FALSE, -1)
	unbuckle_all_mobs()

/obj/structure/chair/arrestchair/proc/giveup(mob/living/carbon/human/M)
	if(alert(M, "Do you submit to the Mask, or do you die? You have 10 seconds to decide.", "CHOICE OF LYFE", "Submit", "Perish") == "Perish")
		message_admins("[M.real_name] chose to die to the EXCIDIUM.")
		log_admin("[M.real_name] opted to die to the EXCIDIUM.")
		if(M.Adjacent(src))	//No buffering this for later
			submission = FALSE

/obj/structure/chair/arrestchair/proc/budget2change(budget, mob/user, specify)
	var/turf/T
	if(!user || (!ismob(user)))
		T = get_turf(src)
	else
		T = get_turf(user)
	if(!budget || budget <= 0)
		return
	budget = floor(budget)
	var/type_to_put
	var/zenars_to_put
	if(specify)
		switch(specify)
			if("GOLD")
				zenars_to_put = budget/10
				type_to_put = /obj/item/roguecoin/gold
			if("SILVER")
				zenars_to_put = budget/5
				type_to_put = /obj/item/roguecoin/silver
			if("BRONZE")
				zenars_to_put = budget
				type_to_put = /obj/item/roguecoin/copper
	else
		var/highest_found = FALSE
		var/zenars = floor(budget/10)
		if(zenars)
			budget -= zenars * 10
			highest_found = TRUE
			type_to_put = /obj/item/roguecoin/gold
			zenars_to_put = zenars
		zenars = floor(budget/5)
		if(zenars)
			budget -= zenars * 5
			if(!highest_found)
				highest_found = TRUE
				type_to_put = /obj/item/roguecoin/silver
				zenars_to_put = zenars
			else
				new /obj/item/roguecoin/silver(T, zenars)
		if(budget >= 1)
			if(!highest_found)
				type_to_put = /obj/item/roguecoin/copper
				zenars_to_put = budget
			else
				new /obj/item/roguecoin/copper(T, budget)
	if(!type_to_put || zenars_to_put < 1)
		return
	new type_to_put(T, floor(zenars_to_put))
	playsound(T, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
