/// SPELL DATUMS

/obj/effect/proc_holder/spell/invoked/resurrect/matthios
	name = "Rekindled Exchange"
	desc = "Revives the target by invoking a deal with Matthios. In exchange for their lyfe returned, they will be placed\
	in a lasting debt to Him. Any coins within their hands will be spent paying off said debt. Blood for gold."
	debuff_type = /datum/status_effect/debuff/debt_indicator
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

/// - MATTHIOS - ///

#define NOBLE_MULTIPLIER 2.5

/datum/component/debt_collector
	var/debt_remaining = 0
	/// There's a couple instances where on_equip() is called twice incorrectly. I'm applying a small cooldown to prevent abuse of this...
	var/next_payment_time = 0

/datum/component/debt_collector/Initialize(start_debt = 200)
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/H = parent
	if(HAS_TRAIT(H, TRAIT_NOBLE))
		debt_remaining = start_debt * NOBLE_MULTIPLIER
	else
		debt_remaining = start_debt
	RegisterSignal(parent, COMSIG_MOB_EQUIPPED_ITEM, .proc/on_equip)

/datum/component/debt_collector/proc/on_equip(mob/living/carbon/human/H, obj/item/I, slot)
	SIGNAL_HANDLER

	if(slot != ITEM_SLOT_HANDS)
		return

	if(world.time < next_payment_time)
		return

	// Set the cooldown immediately to "lock" this tick
	next_payment_time = world.time + 1

	// Only interact with standard currency, so no marques or psila
	if(istype(I, /obj/item/roguecoin/gold) || istype(I, /obj/item/roguecoin/silver) || istype(I, /obj/item/roguecoin/copper))
		addtimer(CALLBACK(src, .proc/process_payment, H, I), 1)

/datum/component/debt_collector/proc/process_payment(mob/living/carbon/human/H, obj/item/roguecoin/C)
	var/total_real_value = C.get_real_price()
	if(debt_remaining <= 0)
		clear_debt(H)
		return

	if(total_real_value > debt_remaining)
		var/refund_budget = total_real_value - debt_remaining
		refund_budget = max(0, floor(refund_budget))
		to_chat(H, span_warning("A golden hand claims [C] and manifest the remainder."))

		qdel(C)
		// We need a delay to stop the old coin pile from merging with the refund prematurely. Delay one tick :D
		// I love coin code!!
		spawn(1)
			budget2change(refund_budget, H)

		debt_remaining = 0
		clear_debt(H)

	else
		debt_remaining -= total_real_value
		to_chat(H, span_warning("As you grasp [C], [total_real_value] worth of debt vanishes. Remaining: [debt_remaining]."))
		playsound(H, 'sound/foley/coins1.ogg', 50, TRUE)
		qdel(C)
		if(debt_remaining <= 0)
			clear_debt(H)

/datum/component/debt_collector/proc/clear_debt(mob/living/carbon/human/H)
	to_chat(H, span_nicegreen("The weight of your debt has lifted!"))
	H.remove_status_effect(/datum/status_effect/debuff/debt_indicator)
	qdel(src)

#undef NOBLE_MULTIPLIER

/atom/movable/screen/alert/status_effect/debuff/debt_indicator
	name = "Indentured Spirit"
	desc = "A spiritual debt weighs heavy on your soul, sapping your vitality. Standard coins you touch are consumed to appease Matthios."
	icon_state = "pom_regret"

/atom/movable/screen/alert/status_effect/debuff/debt_indicator/examine_ui(mob/user)
	var/list/inspec = list("----------------------")
	inspec += "<br><span class='notice'><b>[name]</b></span>"
	if(desc)
		inspec += "<br>[desc]"

	// Find the component to show the live debt count
	var/datum/component/debt_collector/DC = user.GetComponent(/datum/component/debt_collector)
	if(DC)
		inspec += "<br><span class='boldwarning'>Current Debt: [DC.debt_remaining] mammon.</span>"

	// Stat penalties logic from the base proc
	for(var/S in attached_effect?.effectedstats)
		if(attached_effect.effectedstats[S] > 0)
			inspec += "<br><span class='purple'>[S]</span> \Roman [attached_effect.effectedstats[S]]"
		else if(attached_effect.effectedstats[S] < 0)
			var/newnum = attached_effect.effectedstats[S] * -1
			inspec += "<br><span class='danger'>[S]</span> \Roman [newnum]"

	inspec += "<br>----------------------"
	to_chat(user, "[inspec.Join()]")

/datum/status_effect/debuff/debt_indicator
	id = "debt_indicator"
	// You should pay off the debt!
	duration = 45 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/debuff/debt_indicator
	effectedstats = list(
		STATKEY_STR = -2,
		STATKEY_SPD = -4,
		STATKEY_CON = -2
	)

/datum/status_effect/debuff/debt_indicator/on_apply()
	. = ..()
	owner.AddComponent(/datum/component/debt_collector, 200)
	to_chat(owner, span_userdanger("A cold, crushing weight settles over your limbs... you are indentured."))

/datum/status_effect/debuff/debt_indicator/on_remove()
	. = ..()
	to_chat(owner, span_nicegreen("The crushing weight lifts from your soul. You are free!"))

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
	addtimer(CALLBACK(src, .proc/expire), lifetime)
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
	RegisterSignal(parent, COMSIG_LIVING_DEATH, .proc/on_death)

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
	RegisterSignal(owner, COMSIG_DRUG_SNIFFED, .proc/on_sniff)

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

/datum/status_effect/buff/zizo_tithe/on_creation(mob/living/new_owner, list/distribution, var/mob/living/carbon/human/H)
	for(var/S in distribution)
		effectedstats[S] = distribution[S]
	victim = H
	RegisterSignal(victim, COMSIG_LIVING_DEATH, .proc/cancel_early)
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

/obj/effect/proc_holder/spell/invoked/resurrect/matthios/cast(list/targets, mob/living/carbon/human/user)
	. = ..()

	if(!.)
		return FALSE

	var/mob/living/carbon/human/target = targets[1]

	var/obj/structure/fluff/psycross/found_cross
	var/astrata_cross = FALSE

	for(var/atom/A in oview(1, target))
		if(istype(A, /obj/structure/fluff/psycross/matthios))
			found_cross = A
			break

		if(istype(A, /obj/structure/fluff/psycross/astrata))
			found_cross = A
			astrata_cross = TRUE
			break

		if(istype(A, /turf))
			var/turf/T = A

			for(var/obj/O in T.contents)
				if(istype(O, /obj/structure/fluff/psycross/matthios))
					found_cross = O
					break

				if(istype(O, /obj/structure/fluff/psycross/astrata))
					found_cross = O
					astrata_cross = TRUE
					break

		if(found_cross)
			break

	var/datum/component/debt_collector/user_dc = user.GetComponent(/datum/component/debt_collector)
	var/user_indebted = FALSE

	if(user_dc && user_dc.debt_remaining > 0)
		user_indebted = TRUE

	if(astrata_cross)
		if(user_indebted)
			user.visible_message(span_boldwarning("[user]'s counterfeit sanctity shatters beneath Astrata's gaze! HERETIC!"))

			new /obj/effect/temp_visual/explosion(user)
			playsound(user, 'sound/magic/churn.ogg', 50)
			playsound(user, 'sound/misc/explode/explosion.ogg', 50)

			user.adjust_fire_stacks(15)
			user.ignite_mob()

			if(found_cross)
				found_cross.visible_message(span_userdanger("[found_cross] erupts with blinding solar fury! Astrata is NOT happy!!"))

			to_chat(user, span_userdanger("Matthios turns his back on you, as Astrata sees right through your profane act!"))
			to_chat(target, span_nicegreen("Warm sanctity wraps around your rekindled soul, but not so warmly upon another. What a surprise to be back to."))

			return TRUE

		var/cost = rand(100, 150)
		var/paid = pay_matthios_mammon(user, cost)

		if(paid >= cost)
			to_chat(user, span_nicegreen("You quietly trade with Matthios into veiling the miracle from Astrata's divine scrutiny."))
			to_chat(target, span_nicegreen("Warm sanctity wraps around your rekindled soul. It feels great to be back."))

			return TRUE

		var/unpaid = max(0, cost - paid)

		user.apply_status_effect(/datum/status_effect/debuff/debt_indicator)

		user_dc = user.GetComponent(/datum/component/debt_collector)

		if(user_dc)
			user_dc.debt_remaining += unpaid
		else
			user.AddComponent(/datum/component/debt_collector, unpaid)

		to_chat(user, span_userdanger("Your hoard proves lighter than your ambition. Matthios accepts what little you managed to offer, but the remainder settles quietly under YOUR name."))
		to_chat(target, span_nicegreen("Warm sanctity wraps around your rekindled soul. It feels great to be back."))

		return TRUE

	if(found_cross && !astrata_cross)
		var/mode = input(user, "Choose the transaction.", name) as anything in list("Charity","Debt")

		if(mode == "Charity")
			var/cost = rand(70, 140)

			if(HAS_TRAIT(target, TRAIT_FREEMAN))
				cost = round(cost / 3)

			var/paid = pay_matthios_mammon(user, cost)

			if(paid < cost)
				var/unpaid = cost - paid

				user.apply_status_effect(/datum/status_effect/debuff/debt_indicator)

				user_dc = user.GetComponent(/datum/component/debt_collector)

				if(user_dc)
					user_dc.debt_remaining += unpaid
				else
					user.AddComponent(/datum/component/debt_collector, unpaid)

				to_chat(user, span_userdanger("You attempt to purchase their absolution outright, but Matthios notices the missing balance. The remainder becomes YOUR debt."))

			else
				to_chat(user, span_nicegreen("You fully shoulder the burden of resurrection yourself. Matthios leaves the revived soul untouched."))
				to_chat(target, span_nicegreen("You rise strangely free of obligation, as if someone else paid your toll."))

			return TRUE

		if(mode == "Debt")
			var/final_debt = rand(150,200)

			if(HAS_TRAIT(target, TRAIT_FREEMAN))
				final_debt = round(final_debt / 3)

			to_chat(user, span_userdanger("Matthios smiles upon your respectful bargain and greed!"))

			var/discount_cap = round(final_debt / 2)
			var/stolen = pay_matthios_mammon(target, discount_cap)

			if(stolen > 0)
				budget2change(stolen, get_turf(user))
				final_debt = max(0, final_debt - stolen)
				playsound(user, 'sound/effects/matth_barter.ogg', 100, TRUE)
				to_chat(user, span_nicegreen("[stolen] mammon materializes before you... Your sanctioned cut of the transaction."))
				to_chat(target, span_userdanger("Part of your remaining wealth is forcefully extracted to sweeten Matthios' bargain."))

			target.apply_status_effect(/datum/status_effect/debuff/debt_indicator)

			var/datum/component/debt_collector/target_dc = target.GetComponent(/datum/component/debt_collector)

			if(target_dc)
				target_dc.debt_remaining += final_debt
			else
				target.AddComponent(/datum/component/debt_collector, final_debt)

			to_chat(target, span_userdanger("Your soul returns and your eyes open, as you feel a growing compulsion toward touching mammon..."))

			return TRUE

	if(user_indebted)
		to_chat(user, span_boldwarning("You invoke an unsanctioned miracle while already indebted. Matthios' patience snaps completely."))
		to_chat(target, span_userdanger("NO, MATTHIOS!! O' LORD!! WAIT! I'LL PAY, I'LL PA--!!"))

		new /obj/effect/temp_visual/explosion(user)
		playsound(user, 'sound/magic/churn.ogg', 50)
		playsound(user, 'sound/misc/explode/explosion.ogg', 50)

		user.death()

		for(var/mob/living/carbon/human/H in list(user, target))
			H.apply_status_effect(/datum/status_effect/debuff/debt_indicator)

			var/datum/component/debt_collector/DC = H.GetComponent(/datum/component/debt_collector)

			if(DC)
				DC.debt_remaining += 200
			else
				H.AddComponent(/datum/component/debt_collector, 200)

		to_chat(target, span_userdanger("You are alive again... purchased through catastrophe, desperation, and divine impatience."))

		return TRUE

	for(var/mob/living/carbon/human/H in list(user, target))
		H.apply_status_effect(/datum/status_effect/debuff/debt_indicator)

		var/datum/component/debt_collector/DC = H.GetComponent(/datum/component/debt_collector)

		if(DC)
			DC.debt_remaining += 200
		else
			H.AddComponent(/datum/component/debt_collector, 200)

	to_chat(user, span_userdanger("Without sacred sanction, the miracle runs wild. Both souls are seized by His ledger."))
	to_chat(target, span_userdanger("Your soul returns, burdened by an unsanctioned bargain struck improperly."))

	return TRUE

/obj/effect/proc_holder/spell/invoked/resurrect/proc/pay_matthios_mammon(mob/living/carbon/human/H, amount)
	if(!H || amount <= 0)
		return 0

	if(!SStreasury.has_account(H))
		SStreasury.create_bank_account(H, 0)

	var/bank = SStreasury.get_balance(H)
	var/onhand = get_mammons_in_atom(H)

	var/remaining = amount
	var/paid = 0

	var/drained_onhand = min(onhand, remaining)

	if(drained_onhand > 0)
		var/removed = remove_mammons_from_atom(H, drained_onhand)
		paid += removed
		remaining -= removed

	if(remaining > 0)
		var/from_bank = min(bank, remaining)

		if(from_bank > 0)
			SStreasury.burn(SStreasury.get_account(H), from_bank, "matthios_transaction")
			paid += from_bank
			remaining -= from_bank

	return paid
