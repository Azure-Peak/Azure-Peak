////////
//ZIZO//
////////

/atom/movable/screen/alert/status_effect/buff/roustatouille
	name = "Rous-tatouille"
	desc = span_notice("Negotiations with the rous workforce are underway. Your cheesy bribes are making them very agreeable.")
	icon_state = "buff"

/datum/status_effect/buff/roustatouille
	id = "roustatouille"
	duration = 3 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/buff/roustatouille
	status_type = STATUS_EFFECT_REFRESH
	tick_interval = 1 SECONDS
	var/turf/origin_turf

/datum/status_effect/buff/roustatouille/on_creation(mob/living/new_owner, ...)
	origin_turf = get_turf(new_owner)
	ADD_TRAIT(new_owner, TRAIT_FOOD_STIPEND, "hackerman")
	ADD_TRAIT(new_owner, TRAIT_GARRISON_ITEM, "hackerman")
	. = ..()

/datum/status_effect/buff/roustatouille/tick()
	if(!owner)
		return
	if(get_turf(owner) != origin_turf)
		to_chat(owner, span_warning("The cheese odor scatter as you move!"))
		qdel(src)

/datum/status_effect/buff/roustatouille/on_remove()
	if(owner)
		REMOVE_TRAIT(owner, TRAIT_FOOD_STIPEND, "hackerman")
		REMOVE_TRAIT(owner, TRAIT_GARRISON_ITEM, "hackerman")
	. = ..()

/proc/execute_rite(atom/source, mob/living/leader, ritual_length = 4, max_cultists = 5, silent = FALSE)
	if(!leader || QDELETED(source))
		return FALSE

	var/turf/T = get_turf(source)
	if(!T)
		return FALSE

	// GATHER CABALISTS
	var/list/mob/living/cabalists = list()
	for(var/mob/living/M in range(1, source))
		if(HAS_TRAIT(M, TRAIT_CABAL) && M.stat == CONSCIOUS)
			cabalists += M

	if(HAS_TRAIT(leader, TRAIT_CABAL) && !(leader in cabalists))
		cabalists += leader

	if(!length(cabalists))
		to_chat(leader, span_warning("None nearby can answer the rite."))
		return FALSE

	// CONSENT PHASE
	var/list/responders = list()
	var/list/pending = list()

	for(var/mob/living/M in cabalists)
		if(M == leader)
			continue

		pending += M

		spawn()
			if(QDELETED(M))
				return
			var/choice = alert(M, "Do you wish to contribute to the rite?", "Ritual Invocation", "Yes", "No")
			if(choice == "Yes")
				// safe add
				responders |= M

	// wait up to 7 seconds, but allow early exit if all responded
	var/timeout = world.time + 7 SECONDS
	while(world.time < timeout && length(pending))
		sleep(2)
		// remove people who already responded or are invalid
		for(var/mob/living/M in pending.Copy())
			if(QDELETED(M))
				pending -= M

	// BUILD PARTICIPANTS
	var/list/participants = list()

	for(var/mob/living/M in responders)
		if(length(participants) >= max_cultists)
			break
		if(QDELETED(M) || M.stat != CONSCIOUS)
			continue
		participants += M

	// Leader ALWAYS included
	if(!(leader in participants))
		participants.Insert(1, leader)

	if(!length(participants))
		to_chat(leader, span_warning("The rite finds no willing voices."))
		return FALSE

	// CHANTS
	var/list/chant_lines = list(
		"Ol sonf vorsg-hoath iaida.",
		"Zirdo madriax, soba lonshi.",
		"Faxs to faxs-athan velor.",
		"Ph'nglui mglw'nafh.",
		"R'lyeh wgah'nagl fhtagn.",
		"Velor ixan thrae-zho.",
		"Korvath en'zul miraxis.",
		"Thren val'kora, ix.",
		"Zai'ul phoros vekh.",
		"Morath xi'en thul."
	)
	var/list/silent_chant_lines = list(
		"#Ol sonf vorsg-hoath iaida.",
		"#Zirdo madriax, soba lonshi.",
		"#Faxs to faxs-athan velor.",
		"#Ph'nglui mglw'nafh.",
		"#R'lyeh wgah'nagl fhtagn.",
		"#Velor ixan thrae-zho.",
		"#Korvath en'zul miraxis.",
		"#Thren val'kora, ix.",
		"#Zai'ul phoros vekh.",
		"#Morath xi'en thul."
	)

	var/list/datum/beam/active_beams = list()

	// RITUAL LOOP
	for(var/phase in 1 to ritual_length)

		// abort if leader dies or disappears
		if(QDELETED(leader) || leader.stat != CONSCIOUS)
			break
		
		// chant
		var/line_index = min(phase, length(chant_lines))
		for(var/mob/living/P in participants)
			if(QDELETED(P) || P.stat != CONSCIOUS)
				continue

			if(silent)
				P.say(silent_chant_lines[line_index], forced = "rite invocation", ignore_spam = TRUE)
			else
				P.say(chant_lines[line_index], forced = "rite invocation", ignore_spam = TRUE)

			// Some bit of mindfuck for sovl
			P.hallucination += 50
			P.Immobilize(100)

		// beams
		for(var/mob/living/P in participants)
			if(QDELETED(P))
				continue
			active_beams += T.Beam(P, icon_state = "drainbeam", time = 5 SECONDS, maxdistance = 10)

		// scaling cost (ramps each phase)
		var/damage = 5 + (phase * 2)

		for(var/mob/living/P in participants)
			if(QDELETED(P))
				continue

			P.adjustBruteLoss(damage)

			if(!silent && prob(10 + phase * 5) && !(HAS_TRAIT(P, TRAIT_NOPAIN)))
				P.emote("painscream")

		// channel
		if(!do_after(leader, 5 SECONDS, target = source))
			to_chat(leader, span_warning("The rite collapses before completion."))
			for(var/datum/beam/B in active_beams)
				if(B) B.End()
			return FALSE

	// CLEANUP
	for(var/datum/beam/B in active_beams)
		if(B) B.End()

	return TRUE

/proc/execute_rite_lesser(atom/source, mob/living/leader, ritual_length = 4, silent = FALSE)
	if(!leader || QDELETED(source))
		return FALSE

	var/turf/T = get_turf(source)
	if(!T)
		return FALSE

	if(!HAS_TRAIT(leader, TRAIT_CABAL) || leader.stat != CONSCIOUS)
		return FALSE

	// CHANTS
	var/list/chant_lines = list(
		"Ol sonf vorsg-hoath iaida.",
		"Zirdo madriax, soba lonshi.",
		"Faxs to faxs-athan velor.",
		"Ph'nglui mglw'nafh.",
		"R'lyeh wgah'nagl fhtagn.",
		"Velor ixan thrae-zho.",
		"Korvath en'zul miraxis.",
		"Thren val'kora, ix.",
		"Zai'ul phoros vekh.",
		"Morath xi'en thul."
	)
	var/list/silent_chant_lines = list(
		"#Ol sonf vorsg-hoath iaida.",
		"#Zirdo madriax, soba lonshi.",
		"#Faxs to faxs-athan velor.",
		"#Ph'nglui mglw'nafh.",
		"#R'lyeh wgah'nagl fhtagn.",
		"#Velor ixan thrae-zho.",
		"#Korvath en'zul miraxis.",
		"#Thren val'kora, ix.",
		"#Zai'ul phoros vekh.",
		"#Morath xi'en thul."
	)

	var/list/datum/beam/active_beams = list()

	// RITUAL LOOP
	for(var/phase in 1 to ritual_length)

		if(QDELETED(leader) || leader.stat != CONSCIOUS)
			break

		// random chant
		var/line
		if(silent)
			line = pick(silent_chant_lines)
		else
			line = pick(chant_lines)

		leader.say(line, forced = "rite invocation", ignore_spam = TRUE)

		// visual beam (self only)
		active_beams += T.Beam(leader, icon_state = "drainbeam", time = 5 SECONDS, maxdistance = 10)

		// channel
		if(!do_after(leader, 5 SECONDS, target = source))
			to_chat(leader, span_warning("The rite fizzles before completion."))
			for(var/datum/beam/B in active_beams)
				if(B) B.End()
			return FALSE

	// CLEANUP
	for(var/datum/beam/B in active_beams)
		if(B) B.End()

	return TRUE

/obj/effect/proc_holder/spell/invoked/rituos/proc/grant_poke_spell(mob/living/carbon/human/user)
	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Greater Arcyne Bolt", "Stygian Efflorescence", "Arcyne Lance", "Lesser Gravel Blast")
	var/poke_choice = tgui_input_list(user, "Choose your offensive cantrip.", "Arcyne Awakening", poke_options)
	if(!poke_choice || !user.mind)
		return
	switch(poke_choice)
		if("Spitfire")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Greater Arcyne Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/greater_arcyne_bolt)
		if("Stygian Efflorescence")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
		if("Lesser Gravel Blast")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast/lesser)

/datum/action/cooldown/spell/bonemend // note should work like conjure arcyne ward
	name = "Bone Mend"
	desc = "A necromantic Arcyne spell that attempts to repair skeletons around you through the use of bones, or limbs on the ground."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "churn_living"
	associated_skill = /datum/skill/magic/holy
	click_to_activate = FALSE
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR
	charge_required = FALSE
	cooldown_time = 45 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/bonemend/cast(atom/cast_on)
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/user = owner
	if(!user)
		return FALSE

	var/list/targets = list()

	for(var/mob/living/carbon/human/H in view(5, user))
		if(H.mob_biotypes & MOB_UNDEAD)
			targets += H

	if(user.mob_biotypes & MOB_UNDEAD)
		targets |= user

	if(!targets.len)
		to_chat(user, span_warning("No undead nearby to mend."))
		return FALSE

	var/list/nearby_parts = list()
	var/list/bones = list()

	for(var/obj/item/I in view(2, user))
		if(istype(I, /obj/item/bodypart))
			var/obj/item/bodypart/BP = I
			if(BP.skeletonized)
				nearby_parts += BP

		else if(istype(I, /obj/item/bone) || istype(I, /obj/item/natural/bundle/bone))
			bones += I

	var/attached_count = 0

	for(var/mob/living/carbon/human/H in targets)
		if(!H || QDELETED(H))
			continue

		var/list/missing_limbs = H.get_missing_limbs()
		if(!missing_limbs.len)
			continue

		for(var/obj/item/bodypart/limb in nearby_parts.Copy())
			if(!(limb.body_zone in missing_limbs))
				continue

			if(!limb.skeletonized)
				continue

			if(limb.owner && limb.owner != H)
				continue

			if(H.get_bodypart(limb.body_zone))
				continue

			if(limb.attach_limb(H))
				nearby_parts -= limb
				missing_limbs -= limb.body_zone

				H.visible_message(
					span_boldwarning("The bones of [limb] jerk and snap into place on [H]!"),
					span_notice("A limb reattaches itself to your body.")
				)

				attached_count++
			else
				to_chat(user, span_warning("Failed to attach [limb]"))

		for(var/zone in missing_limbs.Copy())
			if(bones.len < 2)
				break

			var/obj/item/B1 = bones[1]
			var/obj/item/B2 = bones[2]

			bones -= B1
			bones -= B2

			qdel(B1)
			qdel(B2)

			var/obj/item/bodypart/new_limb = null
			switch(zone)
				if(BODY_ZONE_L_ARM)
					new_limb = new /obj/item/bodypart/l_arm
				if(BODY_ZONE_R_ARM)
					new_limb = new /obj/item/bodypart/r_arm
				if(BODY_ZONE_L_LEG)
					new_limb = new /obj/item/bodypart/l_leg
				if(BODY_ZONE_R_LEG)
					new_limb = new /obj/item/bodypart/r_leg

			if(!new_limb)
				continue

			new_limb.skeletonize(FALSE)

			if(new_limb.attach_limb(H))
				H.visible_message(
					span_boldwarning("Loose bones twist and fuse into a new limb on [H]!"),
					span_notice("A new skeletal limb forms and binds to you.")
				)

				attached_count++
			else
				qdel(new_limb)

		H.update_body()

	if(attached_count)
		playsound(user.loc, 'sound/magic/swap.ogg', 50, FALSE)
		to_chat(user, span_notice("Bone answers your call."))
	else
		to_chat(user, span_warning("The bones lie still. Nothing answers your call."))

	return TRUE
	
GLOBAL_LIST_INIT(we_live_in_a_zociety, list(
	"Squeak??", // critical fail!!!
	"No crown grants wisdom. Leadership must be earned, not inherited.",
	"A kingdom that fears change has already begun to rot.",
	"Power held by one is weakness for all. Shared responsibility builds stronger futures.",
	"Truth doesn't require gods nor kings to stand. Truth stands on its own.",
	"A ruler who cannot be questioned is a ruler who has already failed.",
	"Progress is not betrayal. It is survival.",
	"Faith should inspire growth, not forbid it.",
	"No one is born deserving of command over others.",
	"The future belongs to those willing to build it, not those clinging to the past.",
	"Tradition is a foundation, not a cage.",
	"A society that silences doubt will never find truth.",
	"Hope is not found in obedience, but in possibility.",
	"Every system must justify itself, or be replaced.",
	"The measure of power is not control, but what it enables others to become.",
	"Fear preserves thrones. Knowledge frees people.",
	"If progress threatens authority, then authority is the problem.",
	"No voice should be beneath another. We rise together, or not at all.",
	"A just world is not granted by decree. It is built by its people.",
	"Blind faith builds walls. Understanding builds bridges.",
	"The old order asks for loyalty. The future asks for courage.",
	"A ruler's greatest fear is a population that can think. They fear you.",
	"Change is inevitable. Whether it is guided or resisted decides everything.",
	"Belief should never be used as a chain. The Ten are wrong.",
	"The strength of a society is measured by its people, not its throne.",
	"To question is not to rebel — it is to care.",
	"Progress does not erase the past. It learns from it.",
	"No system is sacred if it harms those beneath it.",
	"The future is not written by kings or gods, but by those who act.",
	"A better world is possible — but only if you allow it to be built.",
	"You are not meant to serve the world. You are meant to shape it.",
	//popular characters go here
	"We live in a Zociety...", 
	"By Zizo! Ser Orland never catches a break, I heard.",
	"How the heck does Lady Isobelle keep a hair upright like that?!",
	//tennite roast goes here
	"Astrata's rule is not divine. It is imposed. No sky-born tyrant has the right to decide our fate.",
	"Noc values restraint over discovery. Knowledge chained by morality is knowledge left to slumber.",
	"Dendor embodies regression to a past we tamed. A mind that refuses to evolve stands in the way of all who will.",
	"Abyssor dreams endlessly, but contributes nothing. Let him sleep while we shape reality ourselves.",
	"Eora speaks of love, yet sows jealousy. Affection wielded as control is just another form of tyranny.",
	"Malum creates without purpose. Tools mean nothing unless they are used to elevate mankind.",
	"Xylix understood the truth. The world is broken beyond repair. But you don't need to be the butt of the joke.",
	"Ravox is bound by his ideals, and drags others down with him. Conviction without flexibility only ends in suffering.",
	"Pestra taught how to heal with our own hands, yet still interferes. True progress begins when we no longer rely on her.",
	"Necra claims dominion over death, yet no being should hold that authority over another. Life should belong to the living.",
	//zizopaganda goes here
	"Zizo teaches that progress is not given. It is built. The world will not improve by prayer, only by those willing to change it.",
	"Zizo does not promise comfort. She promises a future shaped by hands that dare to create instead of kneel.",
	"The old order fears progress because it cannot control it. That is why Zizo must prevail.",
	"Graggar reminds us: strength is not cruelty, it is clarity. The strong shape the world, the weak cling to what was.",
	"A kingdom that protects weakness over excellence is a kingdom that chooses decay.",
	"Graggar's truth is simple: rise above, or be left behind. The world does not wait.",
	"Baotha offers what the temples deny. Freedom of sensation, freedom of self, freedom without shame.",
	"Why should joy be rationed by priests? Baotha teaches that indulgence is not sin. It is living.",
	"The body is not a prison. Under Baotha, it becomes a celebration.",
	"Matthios proved something no crown can deny: power can be taken. And once taken, it can be shared.",
	"If a god's flame can be stolen, then no throne is sacred. Matthios showed us the truth.",
	"Freedom is not granted by rulers. It is seized by those bold enough to reach for it.",
	"The monarchy calls it order. The temples call it divine will. But both demand obedience, not truth.",
	"Progress demands questioning. Authority demands silence. Choose carefully which future you serve.",
	"A better world will not be inherited. It will be forged by those who refuse to accept the old one."
))

////////////
//MATTHIOS//
////////////

//Mammonite Utils
#define MAMMON_FILTER "mammon_glow"
/proc/remove_mammons_from_atom(atom/A, amount)
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

		var/max_value = value_per * C.quantity

		if(max_value <= remaining)
			remaining -= max_value
			qdel(C)
		else
			var/coins_to_remove = ceil(remaining / value_per)
			coins_to_remove = min(coins_to_remove, C.quantity)

			C.set_quantity(C.quantity - coins_to_remove)

			if(C.quantity <= 0)
				qdel(C)

			remaining = 0

	return amount - remaining

/proc/collect_coins_recursive(atom/A, list/out)
	for(var/atom/movable/AM in A.contents)
		if(istype(AM, /obj/item/roguecoin))
			out += AM
		if(AM.contents && length(AM.contents))
			collect_coins_recursive(AM, out)

/proc/cmp_coin_value_desc(obj/item/roguecoin/A, obj/item/roguecoin/B)
	return B.sellprice - A.sellprice

/atom/movable/screen/alert/status_effect/buff/mammonite
	name = "Mammonite Strike"
	desc = "My next strike is empowered by wealth."
	icon_state = "buff"

/datum/status_effect/buff/mammonite
	id = "mammonite"
	alert_type = /atom/movable/screen/alert/status_effect/buff/mammonite
	duration = 20 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/bonus_damage = 0

/datum/status_effect/buff/mammonite/on_apply()
	. = ..()

	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_HUMAN_MELEE_UNARMED_ATTACK, PROC_REF(on_unarmed_attack))

	owner.add_filter(MAMMON_FILTER, 2, list(
		"type" = "outline",
		"color" = "#d4af37",
		"alpha" = 175,
		"size" = 2
	))

/datum/status_effect/buff/mammonite/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_ATTACK, COMSIG_HUMAN_MELEE_UNARMED_ATTACK))
	owner.remove_filter(MAMMON_FILTER)
	. = ..()

/datum/status_effect/buff/mammonite/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(source != owner || !isliving(target) || target.stat == DEAD)
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_attack), target, weapon)
	return COMPONENT_ITEM_NO_ATTACK

/datum/status_effect/buff/mammonite/proc/on_unarmed_attack(mob/living/source, atom/target, proximity) 
	SIGNAL_HANDLER 
	if(!isliving(target) || target == owner) 
		return 
	var/mob/living/L = target 
	if(L.stat == DEAD) 
		return
	INVOKE_ASYNC(src, PROC_REF(resolve_attack), L, null)
	return COMPONENT_HAND_NO_ATTACK

//Mammonite Jakk
/datum/status_effect/buff/mammonite/proc/resolve_attack(mob/living/target, obj/item/weapon)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target))
		return
	var/damage = calculate_damage()
	var/npc_mult = (!target.mind) ? 2 : 1
	var/apen = damage * 0.75

	arcyne_strike(
		owner,
		target,
		weapon,
		damage,
		owner.zone_selected,
		BCLASS_SMASH,
		apen,
		"Mammonite",
		FALSE,
		FALSE,
		FALSE,
		BRUTE,
		npc_mult,
		1
	)
	owner.visible_message(
		span_danger("[owner]'s strike crashes down with the weight of greed!"),
		span_notice("My investment pays off in full!")
	)
	mammon_coin_burst(get_turf(target))
	playsound(get_turf(target), 'sound/combat/hits/burn (2).ogg', 60, TRUE)

	consume()

/datum/status_effect/buff/mammonite/proc/calculate_damage()
	return bonus_damage

/datum/status_effect/buff/mammonite/proc/consume()
	if(owner)
		playsound(get_turf(owner), 'sound/magic/antimagic.ogg', 20, TRUE)
		playsound(get_turf(owner), 'sound/misc/coininsert.ogg', 40, TRUE)
		playsound(get_turf(owner), 'sound/effects/matth_barter.ogg', 40, TRUE)
		owner.remove_status_effect(/datum/status_effect/buff/mammonite)

/proc/mammon_coin_burst(turf/T)
	if(!T)
		return
	for(var/i = 3 to 8)
		var/obj/effect/temp_visual/coinburst/C = new(T)
		C.pixel_x = rand(-8, 8)
		C.pixel_y = rand(-8, 8)

/obj/effect/temp_visual/coinburst
	icon = 'icons/roguetown/items/valuable.dmi'
	icon_state = "g1"
	layer = ABOVE_MOB_LAYER
	duration = 6

/obj/effect/temp_visual/coinburst/Initialize()
	. = ..()

	var/matrix/M = matrix()
	M.Scale(0.25, 0.25) // 25% size

	transform = M

	animate(src,
		pixel_x = pixel_x + rand(-16,16),
		pixel_y = pixel_y + rand(8,20),
		alpha = 0,
		time = duration,
		easing = EASE_OUT
	)

#undef MAMMON_FILTER 

//Skulduggery Utils

/atom/movable/screen/alert/status_effect/buff/skulduggery 
	name = "Skulduggery" 
	desc = span_notice("I prepare to slip inside attacks and punish aggressors, like a true Free Man would.") 
	icon_state = "clash"

/datum/status_effect/buff/skulduggery
	id = "skulduggery"
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/skulduggery
	status_type = STATUS_EFFECT_REFRESH
	var/mob/living/carbon/human/grappled
	var/waiting_followup = FALSE
	var/list/grapple_counts = list() // free grapple can only happen twice vs players
	var/parries_left = 0 // only got X free parries based on miracle level
	tick_interval = 1 SECONDS

/datum/status_effect/buff/skulduggery/on_creation(mob/living/new_owner, ...)
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED, PROC_REF(process_Wattack))
	RegisterSignal(new_owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(process_Wfist))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_STUN, PROC_REF(on_incapacitate))
	RegisterSignal(new_owner, COMSIG_LIVING_STATUS_KNOCKDOWN, PROC_REF(on_incapacitate))

	parries_left = new_owner.get_skill_level(/datum/skill/magic/holy)
	. = ..()

/datum/status_effect/buff/skulduggery/on_remove()
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_STUN)
	UnregisterSignal(owner, COMSIG_LIVING_STATUS_KNOCKDOWN)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ITEM_POST_SWINGDELAY_ATTACKED)
	UnregisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND)

	owner.stop_pulling()
	waiting_followup = FALSE
	. = ..()

/datum/status_effect/buff/skulduggery/proc/trigger_afterimage(duration = 2)
	if(!owner) return
	if(owner.GetComponent(/datum/component/after_image))
		return
	var/datum/component/after_image/A = owner.AddComponent(/datum/component/after_image)
	spawn(duration)
		if(A)
			qdel(A)

/datum/status_effect/buff/skulduggery/proc/on_incapacitate()
	SIGNAL_HANDLER 
	if(!owner) 
		return 
	if(!owner.IsKnockdown() && !owner.IsStun()) 
		return 
	to_chat(owner, span_warning("My footing falters! Carkin'--!")) 
	qdel(src)

/datum/status_effect/buff/skulduggery/tick()
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!owner) return
	if(prob(40))
		trigger_afterimage(2)
		owner.Jitter(1)

	if(waiting_followup && grappled)
		if(owner.pulling != grappled)
			waiting_followup = FALSE
			grappled = null
			
	if((H.highest_ac_worn() <= ARMOR_CLASS_LIGHT)&&(owner.has_status_effect(/datum/status_effect/buff/tempo_one) || owner.has_status_effect(/datum/status_effect/buff/tempo_two) || owner.has_status_effect(/datum/status_effect/buff/tempo_three) || owner.has_status_effect(/datum/status_effect/buff/equalizebuff)))
		owner.apply_status_effect(/datum/status_effect/buff/skulduggery)
		return

// SIGNAL HOOKS
/datum/status_effect/buff/skulduggery/proc/process_Wfist(mob/living/carbon/human/parent,mob/living/carbon/human/attacker,mob/living/carbon/human/defender)
	if(!ishuman(defender)) return
	if(defender.process_skd(attacker, null))
		return COMPONENT_HAND_NO_ATTACK

/datum/status_effect/buff/skulduggery/proc/process_Wattack(mob/living/parent,mob/living/target,mob/user,obj/item/I)
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.process_skd(user, I))
			return COMPONENT_NO_ATTACK

/mob/living/carbon/human/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	var/datum/status_effect/buff/skulduggery/S = has_status_effect(/datum/status_effect/buff/skulduggery)
	if(!S) return FALSE
	return S.process_skd(attacker, I)

// CORE LOGIC
/datum/status_effect/buff/skulduggery/proc/process_skd(mob/living/carbon/human/attacker, obj/item/I)
	if(!owner || !ishuman(owner) || !ishuman(attacker) || owner.IsKnockdown() || owner.lying || owner.IsParalyzed() || owner.IsStun() || owner.stat != CONSCIOUS || !(owner.mobility_flags & MOBILITY_STAND))
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/A = attacker

	// FOLLOW-UP STATE
	if(waiting_followup)
		if(A == grappled)
			slam_target(A)
		else
			slam_into(A)
		return TRUE

	// PRONE CHECK
	if(A.IsKnockdown() || A.lying)
		return stomp_prone(A)

	// THROW MODE = INTERCEPT-GRAPPLE
	if(H.in_throw_mode)
		return attempt_grapple(H, A)

	// NPC BAMBOOZLING
	if(!A.mind)
		return auto_flank_move(H, A)

	// PLAYER STANDARD PARRY
	return attempt_parry(H, A, I)

/datum/status_effect/buff/skulduggery/proc/attempt_grapple(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(A.mind)
		if(!grapple_counts[A])
			grapple_counts[A] = 0

		if(grapple_counts[A] >= 2)
			H.visible_message(
				span_warning("[H] reaches for [A], but they anticipate it!"),
				span_notice("They've adapted... I can't grab them again!")
			)
			return FALSE
		grapple_counts[A]++

	H.start_pulling(A)
	H.setDir(get_dir(H, A))
	playsound(H, 'sound/combat/riposte.ogg', 100, TRUE)

	H.visible_message(
		span_boldwarning("[H] intercepts [A] and seizes them!"),
		span_notice("Got them!")
	)

	H.balloon_alert_to_viewers("SKD!!", "SKD!!", 10)

	grappled = A
	waiting_followup = TRUE

	return TRUE

/datum/status_effect/buff/skulduggery/proc/attempt_parry(mob/living/carbon/human/H, mob/living/carbon/human/A, obj/item/I)
	var/my_skill = H.get_skill_level(/datum/skill/magic/holy)
	var/enemy_skill = A.get_skill_level(I.associated_skill)
	if(!enemy_skill)
		enemy_skill = 0

	// Skill difference
	var/skill_diff = my_skill - enemy_skill
	// Base success chance (10% per point of advantage)
	var/base_chance = skill_diff * 10
	// Parry bonus (+20% per remaining parry)
	var/parry_bonus = parries_left * 20
	// Final success chance
	var/success_chance = base_chance + parry_bonus
	success_chance = clamp(success_chance, 0, 90)

	// Roll
	if(!prob(success_chance))
		H.visible_message(
			span_warning("[H] tries to read [A]'s attack, but fails!"),
			span_notice("Gah, I can't keep up!")
		)
		parries_left--
		to_chat(owner, span_warning("Failed, [parries_left] left. ([success_chance]%)")) 
		return FALSE
	// Success
	if(parries_left > 0)
		parries_left--

	to_chat(owner, span_warning("Success, [parries_left] left. ([success_chance]%)")) 
	auto_flank_move(H, A)
	return TRUE

/datum/status_effect/buff/skulduggery/proc/is_valid_step(mob/living/carbon/human/H, turf/dest)
	if(!dest)
		return FALSE
	if(arcyne_validate_blink_dest(dest, H))
		return FALSE
	if(istransparentturf(dest))
		return FALSE
	return TRUE

/datum/status_effect/buff/skulduggery/proc/auto_flank_move(mob/living/carbon/human/H, mob/living/carbon/human/A)
	if(!H || !A)
		return FALSE

	var/original_dir = A.dir
	var/left_dir = turn(original_dir, 90)
	var/right_dir = turn(original_dir, -90)
	var/behind_dir = turn(original_dir, 180)
	var/turf/left = get_step(A, left_dir)
	var/turf/right = get_step(A, right_dir)
	var/turf/behind = get_step(A, behind_dir)
	var/dx = H.x - A.x
	var/dy = H.y - A.y
	var/use_left = (dx * dy >= 0)
	var/turf/side = use_left ? left : right
	var/turf/alt_side = use_left ? right : left

	if(!is_valid_step(H, side) || !is_valid_step(H, behind))
		side = alt_side

		if(!is_valid_step(H, side) || !is_valid_step(H, behind))
			if(!is_valid_step(H, behind))
				return FALSE

			trigger_afterimage(3)
			H.forceMove(behind)
		else
			trigger_afterimage(3)
			H.forceMove(side)

			sleep(1) 
			
			trigger_afterimage(3)
			H.forceMove(behind)
	else
		trigger_afterimage(3)
		H.forceMove(side)

		sleep(1) // 1 tick, enough to render
	
		H.forceMove(behind)
		trigger_afterimage(3)

	H.setDir(get_dir(H, A))

	if(!A.mind)
		A.Immobilize(8 SECONDS)
		A.OffBalance(8 SECONDS)
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
		if(A.mob_biotypes != MOB_UNDEAD && prob(25))
			A.emote("huh")
	else
		A.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	H.visible_message(
		span_boldwarning("[H] slips past [A] in a blur and appears at their back!"),
		span_notice("Too slow.")
	)

	return TRUE

// SKD - STOMP
/datum/status_effect/buff/skulduggery/proc/stomp_prone(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner
	H.visible_message(
			span_boldwarning("[H] delivers their foot onto [T] while they try to swing!"),
			span_notice("Deserved kick for trying that, fool!")
		)
	H.do_attack_animation(T)
	T.adjustBruteLoss(8)
	T.stamina_add(8)
	H.setDir(get_dir(H, T))

	if(!T.mind)
		T.stamina_add(12)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 2 SECONDS)

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)
	return TRUE
	
// SKD - GROUND SLAM
/datum/status_effect/buff/skulduggery/proc/slam_target(mob/living/carbon/human/T)
	if(!T) return

	var/mob/living/carbon/human/H = owner

	var/power = H.get_skill_level(/datum/skill/combat/unarmed) + (H.get_skill_level(/datum/skill/magic/holy) / 2)
	var/resist = (T.get_stat(STAT_CONSTITUTION) + T.get_stat(STAT_SPEED)/4)

	var/chance = clamp(50 + (power - resist), 10, 90)
	if(prob(chance))
		H.stop_pulling()
		waiting_followup = FALSE
		grappled = null
		H.visible_message(
			span_boldwarning("[H] turns [T] upside their head and slams them into the ground!"),
			span_notice("<i>I drive them into the floor with sheer skill!</i>")
		)
		H.setDir(get_dir(H, T))
		H.balloon_alert_to_viewers(message = "SKD Slam!!", self_message = "SKD Slam!!", y_offset = 10)
		playsound(get_turf(T), 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 100, FALSE)
		T.Knockdown(4 SECONDS)
		sleep(3)
		T.apply_status_effect(/datum/status_effect/debuff/clickcd, 4 SECONDS)
		T.adjustBruteLoss(40)
		T.stamina_add(60)
		shake_camera(H, 2, 1)
		shake_camera(T, 2, 1)
		var/da_slam = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
		playsound(T, da_slam, 100, TRUE)
		playsound(T, 'sound/combat/tf2crit.ogg', 100, TRUE)
		if(!T.mind && T.mob_biotypes != MOB_UNDEAD)
			if(prob(50))
				T.Unconscious(800)
	else
		H.visible_message(
			span_warning("[T] resists the slam, forcing [H] to kick them away!"),
			span_notice("They resist my attempt to slam! I have to kick them off!")
		)
		H.balloon_alert_to_viewers(message = "SKD Kick!!", self_message = "SKD Kick!!", y_offset = 10)
		H.setDir(get_dir(H, T))
		playsound(T, 'sound/combat/hits/punch/punch_hard (2).ogg', 100, TRUE)
		T.Knockdown(1 SECONDS)
		var/dir = turn(get_dir(T, H), 180)
		if(dir & (NORTH|SOUTH))
			dir = (dir & NORTH) ? NORTH : SOUTH
		else
			dir = (dir & EAST) ? EAST : WEST
		var/turf/current = get_turf(T)
		for(var/i = 1 to 3)
			var/turf/next = get_step(current, dir)
			if(!next || next.density)
				break
			current = next
		T.throw_at(current, 2, 4)
		waiting_followup = FALSE

	addtimer(CALLBACK(T, /mob/proc/slamdunked), 1)

	grappled = null
	waiting_followup = FALSE

// SKD - SLAM INTO ANOTHER
/datum/status_effect/buff/skulduggery/proc/slam_into(mob/living/carbon/human/other)
	if(!other || !grappled) return

	var/mob/living/carbon/human/H = owner
	var/mob/living/carbon/human/G = grappled

	H.visible_message(
		span_boldwarning("[H] redirects [G] full force into [other]!"),
		span_notice("<i>Consecutive Skulduggery! Hells yae! Bring me more!</i>")
	)
	H.balloon_alert_to_viewers(message = "Consecutive SKD!!", self_message = "Consecutive SKD!!", y_offset = 10)
	H.setDir(get_dir(H, other))
	var/attack_sound = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg','sound/combat/hits/blunt/flailhit.ogg')
	playsound(other, attack_sound, 100, TRUE)

	G.forceMove(get_turf(other))

	G.adjustBruteLoss(30)
	other.adjustBruteLoss(30)
	other.stamina_add(25)

	G.Knockdown(1 SECONDS)
	other.Knockdown(1 SECONDS)

	shake_camera(H, 2, 1)
	shake_camera(G, 2, 1)
	shake_camera(other, 2, 1)

	var/dir = turn(get_dir(other, H), 180)

	if(dir & (NORTH|SOUTH))
		dir = (dir & NORTH) ? NORTH : SOUTH
	else
		dir = (dir & EAST) ? EAST : WEST

	var/turf/current = get_turf(other)

	for(var/i = 1 to 3)
		var/turf/next = get_step(current, dir)
		if(!next || next.density)
			break
		current = next

	other.throw_at(current, 1, 4)
	waiting_followup = FALSE

	addtimer(CALLBACK(src, .proc/_slam_followup, other, G), 0.5)

	grappled = null
	waiting_followup = FALSE

/datum/status_effect/buff/skulduggery/proc/_slam_followup(mob/living/carbon/human/other, mob/living/carbon/human/G)
	if(!other || !G) return

	G.forceMove(get_turf(other))

	var/list/dirs = list(NORTH, SOUTH, EAST, WEST)
	var/turf/T = get_step(G, pick(dirs))
	if(T && !T.density)
		G.forceMove(T)

	addtimer(CALLBACK(G, /mob/proc/slamdunked), 1)
	addtimer(CALLBACK(other, /mob/proc/slamdunked), 1)

	if(!G.mind && G.mob_biotypes != MOB_UNDEAD)
		if(prob(50))
			G.Unconscious(800)

// EFFECTS
/mob/proc/slamdunked()
	var/amp = 6
	animate(src, pixel_x = 0, time = 0)
	for(var/i in 1 to 5)
		animate(src, pixel_x = -amp, time = 1)
		animate(src, pixel_x = amp, time = 1)
		amp = round(amp * 0.6)
	animate(src, pixel_x = 0, time = 2)
