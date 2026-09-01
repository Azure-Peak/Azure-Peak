/// SPELL DATUMS

/obj/effect/proc_holder/spell/invoked/resurrect/matthios
	name = "Rekindled Exchange"
	desc = "Uses primordial fyre to revive the target and reenact the Free God's First Transaction, putting them in a long-lasting debt to Him. The debt is periodically paid with their mammon."
	debuff_type = null
	alt_required_items = list()
	required_items = list()
	sound = 'sound/magic/slimesquish.ogg'
	chargedloop = /datum/looping_sound/invokeascendant
	harms_undead = FALSE
	recharge_time = 2 MINUTES //Anastasis Equivalent
	overlay_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	overlay_state = "revival"
	action_icon_state = "revival"
	action_icon = 'icons/mob/actions/matthiosmiracles.dmi'
	required_structure = /obj/structure/fluff/psycross/matthios
	matthios = TRUE // is this true?!

#define MATTHIOS_DEBT_MIN 150
#define MATTHIOS_DEBT_MAX 250

/obj/effect/proc_holder/spell/invoked/resurrect/matthios/cast(list/targets, mob/living/carbon/human/user)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/carbon/human/target = targets[1]
	// Find any nearby cross.
	var/obj/structure/fluff/psycross/found_cross
	for(var/obj/structure/fluff/psycross/C in view(1, target))
		found_cross = C
		break
	if(!found_cross)
		to_chat(user, span_warning("You see no holy nor profane cross through which to work this exchange."))
		return FALSE
	var/is_matthios = istype(found_cross, /obj/structure/fluff/psycross/matthios)
	var/is_astrata = istype(found_cross, /obj/structure/fluff/psycross/astrata)
	var/list/options = list("Charity", "Debt")

	if(is_matthios) // matthios cross lets you trade lux instead of money as a third option
		options += "Waiver"
	else if(is_astrata) // astrata cross forces you to only be charitable, its harder to hold an exchange under that gaze
		options = list("Charity")

	var/choice = input(user, "Choose the transaction.", name) as anything in options
	if(choice == "Waiver") // pay off debts with lux, any around you first, otherwise, devitalize self
		var/obj/item/reagent_containers/lux/found_lux
		for(var/obj/item/reagent_containers/lux/L in view(1, user))
			found_lux = L
			break
		if(!found_lux)
			for(var/obj/item/reagent_containers/lux_moss/M in view(1, user))
				found_lux = M
				break
		if(found_lux)
			qdel(found_lux)
			to_chat(user, span_nicegreen("The Lux is consumed for this exchange, accounting no debts with Him!"))
			return TRUE
		if(user.has_status_effect(/datum/status_effect/debuff/devitalised))
			to_chat(user, span_warning("Your Lux is too faint to be used as a waiver right now."))
			return FALSE
		user.apply_status_effect(/datum/status_effect/debuff/devitalised)
		to_chat(user, span_userdanger("You waiver your very Lux for this exchange, accounting no debts with Him!"))
		return TRUE

	var/debt = rand(MATTHIOS_DEBT_MIN, MATTHIOS_DEBT_MAX)
	if(target.patron in ALL_INHUMEN_PATRONS) // discount for the homies
		debt *= 0.5
	else if(HAS_TRAIT(target, TRAIT_NOBLE)) // we HATE nobles, but they can pay this off anyway so shrug
		debt *= 3
	debt = round(debt)

	if(choice == "Charity") // we shoulder the L, mammon goes to matthios
		user.apply_status_effect(/datum/status_effect/debuff/matthios_debt, debt, user)
		to_chat(user, span_userdanger("You shoulder the burden of resurrection yourself. Matthios records your debt."))
		to_chat(target, span_nicegreen("Warm sanctity wraps around your rekindled soul. Someone else has paid your toll."))
		return TRUE
	if(choice == "Debt") // they shoulder the L, mammon goes to caster
		target.apply_status_effect(/datum/status_effect/debuff/matthios_debt, debt, user)
		to_chat(user, span_nicegreen("You leave the burden where it belongs. Matthios smiles upon your bargain."))
		if(target.patron in ALL_INHUMEN_PATRONS)
			to_chat(target, span_userdanger("Your soul returns, as courtesy of the Free God!"))
		else
			to_chat(target, span_userdanger("Your soul returns, but it feels as if your Patron demands compensation..?"))
		return TRUE
	return FALSE

/atom/movable/screen/alert/status_effect/debuff/matthios_debt
	name = "Hoarding Compulsion"
	desc = "I need more mammon to tithe my beloved Patron, for I owe them my lyfe! I must hoard more mammon until they are satisfied..."
	icon_state = "pom_regret"

/atom/movable/screen/alert/status_effect/debuff/matthios_debt/examine_ui(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	inspec += "<br>[desc]"
	var/mob/living/L = user
	if(L)
		var/datum/status_effect/debuff/matthios_debt/D = L.has_status_effect(/datum/status_effect/debuff/matthios_debt)
		if(D)
			inspec += "<br><span class='boldwarning'>Need... [D.debt_remaining] more mammon...</span>"
	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")

/datum/status_effect/debuff/matthios_debt
	id = "matthios_debt"
	duration = 60 MINUTES
	tick_interval = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/debuff/matthios_debt
	var/debt_remaining = 0
	var/total_debt = 0
	var/mob/living/carbon/human/debtor
	var/mob/living/carbon/human/creditor

/datum/status_effect/debuff/matthios_debt/on_creation(mob/living/carbon/human/new_owner, debt_amount, mob/living/carbon/human/source)
	debtor = new_owner
	creditor = source
	debt_remaining = max(0, debt_amount)
	total_debt = debt_remaining
	..()

/datum/status_effect/debuff/matthios_debt/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	if(debt_remaining <= 0)
		return FALSE
	to_chat(owner, span_userdanger("You feel a strange compulsion to hoard... I need... [debt_remaining] mammon..."))
	return TRUE

/datum/status_effect/debuff/matthios_debt/tick()
	if(!debtor || QDELETED(debtor))
		qdel(src)
		return
	if(debt_remaining <= 0)
		qdel(src)
		return
	var/paid = remove_debt_mammon(debtor, debt_remaining)
	if(paid <= 0)
		return
	debt_remaining = max(0, debt_remaining - paid)
	if(creditor && !QDELETED(creditor))
		if(creditor != debtor)
			mint_matthios_payment(creditor, paid)
	if(debt_remaining <= 0)
		to_chat(debtor, span_nicegreen("The odd burden of compulsion lifts from your soul. You feel... free? It's a good feeling."))
		qdel(src)

/datum/status_effect/debuff/matthios_debt/proc/mint_matthios_payment(mob/living/carbon/human/H, amount)
	if(!H || amount <= 0)
		return
	if(SStreasury.has_account(H))
		SStreasury.mint(SStreasury.get_account(H), amount, "Meister reports an e3#rr@o#r?!")
		return
	for(var/obj/item/matthios_canister/firstlaw/C in H.contents)
		if(!C || QDELETED(C))
			continue
		C.stored_value += amount
		return
	var/obj/item/matthios_canister/firstlaw/C = new()
	C.stored_value = amount
	H.put_in_hands(C)

/proc/remove_debt_mammon(atom/A, amount) // tightest check i can muster for this
	if(!A || amount <= 0)
		return 0
	var/remaining = amount
	var/list/coins = list()
	collect_coins_recursive(A, coins)
	coins = sortTim(coins, /proc/cmp_coin_value_desc)
	for(var/obj/item/roguecoin/C in coins)
		if(remaining <= 0)
			break
		if(QDELETED(C))
			continue
		var/value_per = C.sellprice
		if(value_per <= 0)
			continue
		var/quantity = C.quantity
		if(quantity <= 0)
			continue
		var/stack_value = value_per * quantity
		if(stack_value <= remaining)
			remaining -= stack_value
			qdel(C)
			continue
		var/coins_to_remove = ceil(remaining / value_per)
		coins_to_remove = min(coins_to_remove, quantity)
		C.set_quantity(quantity - coins_to_remove)
		var/removed_value = coins_to_remove * value_per
		remaining -= removed_value
		if(C.quantity <= 0)
			qdel(C)
	if(remaining > 0 && ishuman(A))
		var/mob/living/carbon/human/H = A
		var/datum/fund/account = SStreasury.get_account(H)
		if(account)
			var/from_bank = min(remaining, account.balance)
			if(from_bank > 0)
				if(SStreasury.burn(account, from_bank, "Meister reports an e3#rr@o#r?!"))
					remaining -= from_bank
	return max(0, amount - remaining)

#undef MATTHIOS_DEBT_MIN
#undef MATTHIOS_DEBT_MAX

/obj/effect/proc_holder/spell/invoked/resurrect/graggar
	name = "Blood for Graggar"
	desc = "You cannot dominate the dead. Place GRAGGAR'S EYES upon a fallen mortal, granting them the\
	chance to fight again... for a price. Their intelligence will be drained for some time, or until\
	they slay an orcish challenger from His realm."
	debuff_type = /datum/status_effect/debuff/graggar_challenge
	alt_required_items = list(/obj/item/organ/heart = 1)
	required_items = list(/obj/item/organ/heart = 1)
	sound = 'sound/magic/slimesquish.ogg'
	chargedloop = /datum/looping_sound/invokeascendant
	harms_undead = FALSE
	overlay_icon = 'icons/mob/actions/graggarmiracles.dmi'
	overlay_state = "revival"
	action_icon_state = "revival"
	action_icon = 'icons/mob/actions/graggarmiracles.dmi'
	required_structure = /obj/structure/fluff/psycross/graggar

/obj/effect/proc_holder/spell/invoked/resurrect/baotha
	name = "Drive the Thorns Deep"
	desc = "Revives the target by afflicting them with a lasting addiction."
	debuff_type = /datum/status_effect/debuff/baotha_addiction
	alt_required_items = list(/obj/item/natural/thorn = 3)
	required_items = list(/obj/item/natural/thorn = 7)
	sound = 'sound/magic/slimesquish.ogg'
	chargedloop = /datum/looping_sound/invokeascendant
	harms_undead = FALSE
	overlay_icon = 'icons/mob/actions/baothamiracles.dmi'
	overlay_state = "revival"
	action_icon_state = "revival"
	action_icon = 'icons/mob/actions/baothamiracles.dmi'
	required_structure = /obj/structure/fluff/psycross/baotha
	req_items = list() // temp. baothans dont have a holy symbol. apparently one is being commed so this is just the stopgap.

/obj/effect/proc_holder/spell/invoked/resurrect/zizo
	name = "Hollow Rebirth"
	desc = "Revive a fallen subject while siphoning their potential and destroying some of their Lux as a toll. You gain their strength, whilst they gain a second chance.\
	If they die, you will lose their stolen strength."
	sound = 'sound/magic/slimesquish.ogg'
	chargedloop = /datum/looping_sound/invokeascendant
	harms_undead = FALSE
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "revival"
	action_icon_state = "revival"
	recharge_time = 5 MINUTES // halved compared to others
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	// We apply zizo's revival differently from this point onward
	zizo = TRUE
	debuff_type = null
	required_structure = /obj/structure/fluff/psycross/zizocross

/// - GRAGGAR ///

/// CHALLENGE PORTAL

/obj/structure/primal_rift
	name = "primal rift"
	desc = "A jagged tear in reality smelling of blood."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "shitportal"
	color = "#570f04"
	anchored = TRUE
	density = FALSE
	max_integrity = 600

	/// Who is our cowardice target
	var/mob/living/target
	var/orc_count = 0
	/// Orcs to spawn, let's keep this at one because carbon orcs are wicked.
	var/max_orcs = 1
	/// When has our cowardice target been out of range for too long?
	var/out_of_range_since = 0
	var/lifetime = 15 MINUTES

/obj/structure/primal_rift/Initialize(mapload)
	. = ..()
	spawn_orcs()

	// Auto-delete after 15 minutes
	addtimer(CALLBACK(src, PROC_REF(expire)), lifetime)
	START_PROCESSING(SSobj, src)

/obj/structure/primal_rift/process()
	if(!target || QDELETED(target) || target.stat == DEAD)
		return
	var/dist = get_dist(src, target)
	if(dist > 7)
		// First time crossing the line? Log it and warn once.
		if(!out_of_range_since)
			out_of_range_since = world.time
			to_chat(target, span_userdanger("The rift pulses angrily! Return to the challenge immediately or face the consequences!"))
			return

		// Has it been 5 seconds since that first warning?
		if(world.time >= out_of_range_since + 5 SECONDS)
			trigger_consequences()
	else
		// They are back in range. Reset the tracking.
		out_of_range_since = 0

/obj/structure/primal_rift/proc/spawn_orcs()
	var/turf/T = get_turf(src)
	for(var/i in 1 to max_orcs)
		var/mob/living/carbon/human/species/orc/npc/O = new(T)
		O.visible_message(span_danger("[O] step out of the rift, axes drawn!"))
		O.AddComponent(/datum/component/rift_bound, src)
		orc_count++

/datum/component/rift_bound
	var/obj/structure/primal_rift/linked_portal

/datum/component/rift_bound/Initialize(obj/structure/primal_rift/rift)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	linked_portal = rift
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/rift_bound/proc/on_death()
	SIGNAL_HANDLER
	if(linked_portal)
		linked_portal.orc_died()
	qdel(src)

/obj/structure/primal_rift/proc/orc_died()
	orc_count--
	if(orc_count <= 0)
		visible_message(span_notice("With its champions defeated, the primal rift collapses."))
		target?.remove_status_effect(/datum/status_effect/debuff/graggar_challenge)
		qdel(src)

/obj/structure/primal_rift/proc/expire()
	visible_message(span_warning("The primal rift destabilizes and vanishes into nothingness."))
	qdel(src)

/obj/structure/primal_rift/proc/trigger_consequences()
	to_chat(target, span_boldannounce("Graggar punishes your cowardice!"))
	var/datum/status_effect/debuff/graggar_challenge/G = target.has_status_effect(/datum/status_effect/debuff/graggar_challenge)
	if(G)
		G.trigger_failure_consequences(target)
		target.remove_status_effect(/datum/status_effect/debuff/graggar_challenge)
	qdel(src)

/obj/structure/primal_rift/Destroy()
	target?.remove_status_effect(/datum/status_effect/debuff/graggar_challenge)
	STOP_PROCESSING(SSobj, src)
	return ..()

/// STATUS EFFECT

/atom/movable/screen/alert/status_effect/graggar_challenge
	name = "Blood debt"
	desc = "Graggar demands blood be spilt in exchange for his mercy! Summon the rift! Prove yourself! Cowardice is not an option!"
	icon_state = "pom_regret"

/datum/status_effect/debuff/graggar_challenge
	id = "graggar_challenge"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/graggar_challenge
	var/creation_time
	var/failure_time = 15 MINUTES

	effectedstats = list(
		STATKEY_INT = -10 // Graggar values brawn over brain
	)

/datum/status_effect/debuff/graggar_challenge/on_apply()
	. = ..()
	creation_time = world.time
	to_chat(owner, span_userdanger("Your mind feels clouded by a primal bloodlust. Graggar demands a challenge! Summon the rift before your time runs out!"))

	// Grant the summoning spell
	var/obj/effect/proc_holder/spell/invoked/summon_rift/S = new(owner)
	owner.mind?.AddSpell(S)

/datum/status_effect/debuff/graggar_challenge/on_remove()
	// If the duration ran out naturally (didn't get cleared by the rift)
	if(world.time >= (creation_time + failure_time - 5))
		to_chat(owner, span_userdanger("You failed to prove your worth to Graggar!"))
		trigger_failure_consequences(owner)

	// Cleanup the spell if they still have it
	for(var/obj/effect/proc_holder/spell/invoked/summon_rift/S in owner.mind?.spell_list)
		owner.mind.RemoveSpell(S)
		qdel(S)
	. = ..()

/datum/status_effect/debuff/graggar_challenge/proc/trigger_failure_consequences(mob/living/carbon/human/H)
	if(!istype(H))
		return

	to_chat(H, span_boldannounce("Your bones snap under the weight of your own cowardice!"))
	playsound(H, 'sound/combat/fracture/fracturedry (1).ogg', 100, TRUE)

	// Apply fractures to arms. I'd break legs too but we have to account for player error. (like summoning the rift whilst you're in the rimboe)
	var/list/limbs = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM)
	for(var/zone in limbs)
		var/obj/item/bodypart/BP = H.get_bodypart(zone)
		if(BP)
			BP.add_wound(/datum/wound/fracture/no_bleed)

/// Helper spell

/obj/effect/proc_holder/spell/invoked/summon_rift
	name = "Summon Primal Rift"
	desc = "Challenge the rift-born to clear your blood-debt. Must be cast on a nearby floor. Make sure to kill all foes, Graggar will not tolerate further acts of mercy."
	invocation_type = "shout"
	invocations = list("GRAGGAR, WITNESS ME!")
	recharge_time = 5 SECONDS
	chargetime = 0.1 SECONDS
	var/summoned = FALSE
	// Let's make it hard to cheese this with a death trap box or something
	range = 2

/obj/effect/proc_holder/spell/invoked/summon_rift/cast(list/targets, mob/living/user)
	if(summoned)
		to_chat(user, span_warning("The rift was already summoned!"))
		revert_cast()
		return FALSE

	var/turf/T = targets[1]
	if(!isturf(T) || T.density)
		to_chat(user, span_warning("The rift needs solid ground to tear open!"))
		revert_cast()
		return FALSE

	user.visible_message(span_warning("[user] slams their fist into the ground, tearing a crimson hole in reality!"))
	var/obj/structure/primal_rift/R = new(T)
	R.target = user
	summoned = TRUE
	return TRUE

/// - Baotha ///

/datum/stressevent/baotha_withdrawal_severe
	timer = 999 MINUTES
	stressadd = 10
	desc = span_userdanger("Everything is loud and grey. Where is the dust?!")

/datum/status_effect/debuff/baotha_addiction
	id = "baotha_addiction"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/baotha_addiction
	var/last_sniff_time = 0
	var/withdrawal_active = FALSE
	var/message_cooldown = 2 MINUTES
	var/current_cooldown = 0
	var/list/regret_msgs = list(
		span_italics("The face of someone you failed drifts through your vision, their expression frozen in disappointment."),
		span_warning("A sudden, cold weight settles in your chest as you remember a door you should never have opened."),
		span_userdanger("The air tastes like copper and old dust. You can almost hear the screams from that day again."),
		span_italics("You feel a phantom touch on your shoulder—a hand that belonged to someone long since gone."),
		span_warning("A memory of a choice made in haste burns in your mind like a hot coal."),
		span_italics("A voice that sounds like a dying fire whispers, 'You could have saved them.'")
	)

/datum/status_effect/debuff/baotha_addiction/proc/send_creepy_message()
	var/mob/living/L = owner
	if(!L)
		return
	to_chat(L, pick(regret_msgs))

/datum/status_effect/debuff/baotha_addiction/on_apply()
	. = ..()
	// We apply withdrawals immediately
	last_sniff_time = world.time - (5 MINUTES)
	current_cooldown = world.time + message_cooldown
	RegisterSignal(owner, COMSIG_DRUG_SNIFFED, PROC_REF(on_sniff))

/datum/status_effect/debuff/baotha_addiction/proc/on_sniff()
	SIGNAL_HANDLER
	last_sniff_time = world.time
	if(withdrawal_active)
		stop_withdrawal()

/datum/status_effect/debuff/baotha_addiction/process(delta_time)
	if(world.time > last_sniff_time + 5 MINUTES)
		if(!withdrawal_active)
			start_withdrawal()
	else
		if(withdrawal_active)
			stop_withdrawal()

	if(world.time >= current_cooldown)
		send_creepy_message()
		current_cooldown = world.time + message_cooldown

/datum/status_effect/debuff/baotha_addiction/proc/start_withdrawal()
	withdrawal_active = TRUE
	owner.apply_status_effect(/datum/status_effect/debuff/baotha_withdrawal_stats)
	var/mob/living/carbon/human/H = owner
	H.add_stress(/datum/stressevent/baotha_withdrawal_severe)
	to_chat(owner, span_userdanger("The craving for dust becomes unbearable..."))

/datum/status_effect/debuff/baotha_addiction/proc/stop_withdrawal()
	withdrawal_active = FALSE
	owner.remove_status_effect(/datum/status_effect/debuff/baotha_withdrawal_stats)
	var/mob/living/carbon/human/H = owner
	H.remove_stress(/datum/stressevent/baotha_withdrawal_severe)
	to_chat(owner, span_nicegreen("The sweet sting of the drugs calms your nerves. Relief."))

/datum/status_effect/debuff/baotha_addiction/on_remove()
	UnregisterSignal(owner, COMSIG_DRUG_SNIFFED)
	stop_withdrawal()
	. = ..()

/datum/status_effect/debuff/baotha_withdrawal_stats
	id = "baotha_withdrawal_stats"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/baotha_withdrawal
	// Mild debuff because it's mixed with a mood debuff!
	effectedstats = list(
		STATKEY_STR = -1,
		STATKEY_PER = -1
	)

/atom/movable/screen/alert/status_effect/baotha_addiction
	name = "Endless Addiction"
	desc = "Baotha's gifts come with a price. Your body now craves drugs. Tick tock..."

/atom/movable/screen/alert/status_effect/baotha_withdrawal
	name = "Withdrawal"
	desc = "You are weak, slow, and miserable. Sniff something quickly to restore your strength!"

/// - Zizo ///

/obj/effect/proc_holder/spell/invoked/resurrect/zizo/cast(list/targets, mob/living/carbon/human/user)
	var/list/stat_pool = list(STATKEY_STR, STATKEY_SPD, STATKEY_CON, STATKEY_WIL, STATKEY_INT, STATKEY_PER, STATKEY_LCK)
	var/list/tithe_distribution = list()

	for(var/S in stat_pool)
		tithe_distribution[S] = 0

	// Distribute 7 points - max 2 per stat
	var/budget = 7
	var/list/active_pool = stat_pool.Copy()
	while(budget > 0 && length(active_pool))
		var/picked_stat = pick(active_pool)
		tithe_distribution[picked_stat]++
		budget--
		if(tithe_distribution[picked_stat] >= 2)
			active_pool -= picked_stat

	// Parent call
	. = ..()

	// check if parent returns TRUE
	if(.)
		var/mob/living/carbon/human/target = targets[1]

		user.apply_status_effect(/datum/status_effect/buff/zizo_tithe, tithe_distribution, target)
		target.apply_status_effect(/datum/status_effect/debuff/zizo_drain, tithe_distribution)

		var/found_zizo_cross = FALSE

		for(var/atom/A in oview(1, target))
			if(istype(A, /obj/structure/fluff/psycross/zizocross))
				found_zizo_cross = TRUE
				break

			if(istype(A, /turf))
				var/turf/T = A
				for(var/obj/O in T.contents)
					if(istype(O, /obj/structure/fluff/psycross/zizocross))
						found_zizo_cross = TRUE
						break

			if(found_zizo_cross)
				break

		// A proper Zizo cross stabilizes the rite and prevents undeath complications
		if(found_zizo_cross)
			to_chat(target, span_warning("Your stolen Lux writhes violently, but the unholy cross steadies your Lux before undeath can fully take hold."))
		else
			if(!target.has_status_effect(/datum/status_effect/debuff/zizo_temp_undeath) || !HAS_TRAIT(target, TRAIT_SILVER_BLESSED))
				target.apply_status_effect(/datum/status_effect/debuff/zizo_temp_undeath)
				to_chat(target, span_userdanger("You feel your rekindled Lux torn from within, leaving you hollowed as undeath threatens to gnaw at your fading soul."))
			else
				playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
				to_chat(target, span_userdanger("Your fading Lux collapses inward far too soon. Flesh sloughs from bone as undeath tightens its grip upon you."))
				target.apply_status_effect(/datum/status_effect/debuff/devitalised)

		to_chat(user, span_nicegreen("You wrench the victim's rekindled Lux into yourself, leaving them hollowed and starving for life."))

/atom/movable/screen/alert/status_effect/debuff/zizo_temp_undeath
	name = "Embrace of Zizo"
	desc = "You feel your very essence struggling against the hold of Undeath... Your mind is beseethed with dark, evil thoughts, and all you feel is hunger..."

/datum/status_effect/debuff/zizo_temp_undeath
	id = "zizo_temp_undeath"
	duration = 15 MINUTES
	tick_interval = 1 MINUTES // every minute, starve, if you manage to fill your belly, duration is reduced by 5 minutes
	alert_type = /atom/movable/screen/alert/status_effect/debuff/zizo_temp_undeath

/datum/status_effect/debuff/zizo_temp_undeath/on_creation()
	. = ..()
	to_chat(owner, span_warning("Hungry... Hungry... HUNGRY. I AM STARVING. I NEED TO EAT. I NEED TO EAT!"))
	ADD_TRAIT(owner, TRAIT_ROTMAN, "zizo_temp_undeath")
	ADD_TRAIT(owner, TRAIT_NASTY_EATER, "zizo_temp_undeath")
	ADD_TRAIT(owner, TRAIT_STRONGBITE, "zizo_temp_undeath")
	to_chat(owner, span_necrosis("My limbs... I am rotten under my skin. Anything can remove them-- Anything can reattach them...?"))
	ADD_TRAIT(owner, TRAIT_EASYDISMEMBER, "zizo_temp_undeath")
	ADD_TRAIT(owner, TRAIT_LIMBATTACHMENT, "zizo_temp_undeath")
	ADD_TRAIT(owner, TRAIT_SILVER_WEAK, "zizo_temp_undeath")
	ADD_TRAIT(owner, TRAIT_DEATHLESS, "zizo_temp_undeath")
	ADD_TRAIT(owner, TRAIT_ZOMBIE_IMMUNE, "zizo_temp_undeath")
	to_chat(owner, span_boldred("THIS WORLD IS WRONG. EVERYTHING IS WRONG. WE LIVE IN A CORPSE. THE DECAYING CORPSE OF A DEAD GOD!"))
	ADD_TRAIT(owner, TRAIT_PSYCHOSIS, "zizo_temp_undeath")
	ADD_TRAIT(owner, TRAIT_NOMOOD, "zizo_temp_undeath")

/datum/status_effect/debuff/zizo_temp_undeath/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	if(H.stat == DEAD)
		return
	var/very_hongry = pick("HUNGRY...", "Hungry...", "Hungry! Hungry!",	"I NEED TO EAT!", "I'm STARVING!!", "Need to eat... anything... I'll eat anything. I'm so hungry.")
	if(H.nutrition >= NUTRITION_LEVEL_FED)
		duration -= 5 MINUTES
		to_chat(owner, span_warning("You feel some of your Lux react to being full... your reserves drain rapidly and your stomach quickly empties."))
		to_chat(owner, span_green("I am recovering faster..."))

	to_chat(owner, span_warning(very_hongry))
	H.nutrition = 0

/datum/status_effect/debuff/zizo_temp_undeath/on_remove()
	. = ..()
	to_chat(owner, span_boldgreen("...You feel the corroded part of your Lux finally recover, giving you some well-deserved clarity back. What the hell was that?"))
	REMOVE_TRAIT(owner, TRAIT_ROTMAN, "zizo_temp_undeath")
	REMOVE_TRAIT(owner, TRAIT_NASTY_EATER, "zizo_temp_undeath")
	REMOVE_TRAIT(owner, TRAIT_STRONGBITE, "zizo_temp_undeath")
	REMOVE_TRAIT(owner, TRAIT_EASYDISMEMBER, "zizo_temp_undeath")
	REMOVE_TRAIT(owner, TRAIT_LIMBATTACHMENT, "zizo_temp_undeath")
	REMOVE_TRAIT(owner, TRAIT_SILVER_WEAK, "zizo_temp_undeath")
	REMOVE_TRAIT(owner, TRAIT_DEATHLESS, "zizo_temp_undeath")
	REMOVE_TRAIT(owner, TRAIT_ZOMBIE_IMMUNE, "zizo_temp_undeath")
	REMOVE_TRAIT(owner, TRAIT_PSYCHOSIS, "zizo_temp_undeath")
	REMOVE_TRAIT(owner, TRAIT_NOMOOD, "zizo_temp_undeath")

/atom/movable/screen/alert/status_effect/debuff/zizo_drain
	name = "Syphoned Lux"
	desc = "Half of your very rekindled Lux has been syphoned away and the leftovers profaned..."

/atom/movable/screen/alert/status_effect/buff/zizo_tithe
	name = "Lux Syphon"
	desc = "You are invigorated with the rekindled Lux of another. A thousand more, and perhaps you will reach Her first step to Ascension."

// THE BOON - Caster
/datum/status_effect/buff/zizo_tithe
	id = "zizo_tithe"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/zizo_tithe
	var/mob/living/carbon/human/victim

/datum/status_effect/buff/zizo_tithe/on_creation(mob/living/new_owner, list/distribution, mob/living/carbon/human/H)
	for(var/S in distribution)
		effectedstats[S] = distribution[S]
	victim = H
	RegisterSignal(victim, COMSIG_LIVING_DEATH, PROC_REF(cancel_early))
	return ..()

/datum/status_effect/buff/zizo_tithe/on_remove()
	if(victim)
		UnregisterSignal(victim, COMSIG_LIVING_DEATH)
	. = ..()

/datum/status_effect/buff/zizo_tithe/proc/cancel_early()
	SIGNAL_HANDLER

	var/mob/living/carbon/human/caster = owner
	var/mob/living/carbon/human/target = victim

	if(caster)
		caster.remove_status_effect(/datum/status_effect/buff/zizo_tithe)

	if(target)
		target.remove_status_effect(/datum/status_effect/debuff/zizo_drain)
		target.remove_status_effect(/datum/status_effect/debuff/zizo_temp_undeath)

// THE DRAIN - Victim
/datum/status_effect/debuff/zizo_drain
	id = "zizo_drain"
	duration = 15 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/zizo_drain

/datum/status_effect/debuff/zizo_drain/on_creation(mob/living/new_owner, list/distribution)
	for(var/S in distribution)
		effectedstats[S] = -distribution[S]
	return ..()
