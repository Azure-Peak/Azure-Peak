////////////////////////////////////////////////////////////////////////////////////////////////////////////
// T? - Twinned Gaze - Removes vision cone for duration as well grants night vision on high enough level. //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Astrata + Noc

/obj/effect/proc_holder/spell/self/twinned_gaze
	name = "Twinned Gaze"
	desc = "Removes the limit on your vision, letting you see behind you for a time, as well night vision if skilled enough. Duration scales off holy skill and time of dae."
	overlay_state = "twinned_gaze"
	base_icon_state = "regalyscroll"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	sound = 'sound/magic/astrata_choir.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	invocations = "Guide my path hallowed ones."
	invocation_type = "shout"
	recharge_time = 90 SECONDS
	devotion_cost = 30
	miracle = TRUE

/obj/effect/proc_holder/spell/self/twinned_gaze/cast(list/targets, mob/user)
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	var/skill_level = H.get_skill_level(associated_skill)
	H.apply_status_effect(/datum/status_effect/buff/twinned_gaze, skill_level)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/twinned_gaze
	name = "Twinned Gaze"
	desc = "They grant me clarity, allowing me to see evil clearly."
	icon_state = "twinned_gaze"

/datum/status_effect/buff/twinned_gaze
	id = "twinnedgaze"
	alert_type = /atom/movable/screen/alert/status_effect/buff/twinned_gaze
	duration = 20 SECONDS
	var/skill_level = 0
	status_type = STATUS_EFFECT_REPLACE

/datum/status_effect/buff/twinned_gaze/on_creation(mob/living/new_owner, slevel)
	// Only store skill level here
	skill_level = slevel
	.=..()

/datum/status_effect/buff/twinned_gaze/on_apply()
	// Reset base values because the miracle can 
	// now actually be recast at high enough skill and during day time
	// This is a safeguard because buff code makes my head hurt
	duration = 20 SECONDS

	if(skill_level > SKILL_LEVEL_JOURNEYMAN)
		ADD_TRAIT(owner, TRAIT_DARKVISION, "twinnedgaze")	

	if(GLOB.tod == "day" || GLOB.tod == "night")
		duration *= 2

	duration *= skill_level

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = TRUE
		H.hide_cone()
		H.update_cone_show()

	to_chat(owner, span_info("They grant me clarity in time of need!"))

	return ..()

/datum/status_effect/buff/twinned_gaze/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = FALSE
		H.hide_cone()
		H.update_cone_show()
	REMOVE_TRAIT(owner, TRAIT_DARKVISION, "twinnedgaze")

/////////////////////////////////////////////////////////////////////////////////
// T? - Calming Respite - Restore ENERGY to a target and provide healing buff. //
/////////////////////////////////////////////////////////////////////////////////
//Malum + Pestra

/obj/effect/proc_holder/spell/invoked/calmingrespite
	name = "Calming Respite"
	desc = "Restores the targets Energy and provides healing buff. Twice as effective on someone else."
	action_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_icon = 'icons/mob/actions/malummiracles.dmi'
	overlay_state = "vigorousexchange"
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	warnie = "sydwarning"
	movement_interrupt = FALSE
	no_early_release = TRUE
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/items/bsmithfail.ogg'
	invocations = list("Through toil and devotion, let your vigor be restored by their hand!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 3 MINUTES
	chargetime = 2 SECONDS
	miracle = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/invokegen
	devotion_cost = 30

/obj/effect/proc_holder/spell/invoked/calmingrespite/cast(list/targets, mob/living/carbon/user = usr)
	. = ..()
	var/const/starminatoregen = 250 // How much stamina should the spell give back to the caster.
	var/mob/target = targets[1]
	if (!iscarbon(target)) 
		return
	if (target == user)
		target.energy_add(starminatoregen)
		//apply_status_effect(/datum/status_effect/buff/healing)//Should probably be less
		show_visible_message(usr, "As [user] intones the incantation, vibrant flames swirl around them.", "As you intone the incantation, vibrant flames swirl around you. You feel refreshed.")
	else if (user.energy > (starminatoregen * 2))
		user.energy_add(-(starminatoregen * 2))
		target.energy_add(starminatoregen * 2)
		//apply_status_effect(/datum/status_effect/buff/healing)//Should probably be less
		show_visible_message(target, "As [user] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards [target].", "As [user] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards you. You feel refreshed.")


/////////////////////////////////////////////////////////
// T? - Press On - Seal wounds and calm down a person. //
/////////////////////////////////////////////////////////
//Ravox + Eora

/obj/effect/proc_holder/spell/invoked/perseverance
	name = "Perseverance"
	desc = "Seals wounds of living beings and calms them down."
	action_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	overlay_state = "persistence"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	sound = 'sound/magic/timestop.ogg'
	invocations = list("Let their love fill you whole!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 50

/obj/effect/proc_holder/spell/invoked/perseverance/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
/*		if(target.mob_biotypes & MOB_UNDEAD)
			if(spell_guard_check(target, TRUE))
				target.visible_message(span_warning("[target] resists Ravox's judgment!"))
				return TRUE
			if(ishuman(target)) //BLEED AND PAIN
				var/mob/living/carbon/human/human_target = target
				var/datum/physiology/phy = human_target.physiology
				phy.bleed_mod *= 1.2
				phy.pain_mod *= 1.2
				addtimer(CALLBACK(src, PROC_REF(restore_modifiers), phy), 19 SECONDS)
				human_target.visible_message(span_danger("[target]'s wounds become inflamed as their vitality is sapped away!"), span_userdanger("Ravox inflames my wounds and weakens my body!"))
				return TRUE
			return FALSE
*/
		target.visible_message(span_info("Warmth radiates from [target] as their wounds seal over!"), span_notice("The pain from my wounds fade as warmth radiates from my soul!"))

		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
			if(target.mind)
				target.add_stress(/datum/stressevent/presson)
			if(affecting)
				for(var/datum/wound/bleeder in affecting.wounds)
					bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25)
					if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
						var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
						bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference))
		else if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
			for(var/datum/wound/bleeder in target.simple_wounds)
				bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25)
				if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
					var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
					bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference))
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/perseverance/proc/restore_modifiers(datum/physiology/physiology)
	if(!physiology)
		return

	physiology.bleed_mod /= 1.5
	physiology.pain_mod /= 1.5

//////////////////////////////////////////////////////////////////////////////////////
// T? - Gallows Humor - Moodnuke a target with slight slap on the wrist to FORTUNE. //
//////////////////////////////////////////////////////////////////////////////////////
//Necra + Xylix

/obj/effect/proc_holder/spell/invoked/gallowshumor
	name = "Gallows Humor"
	desc = "Shake a target to their core."
	overlay_icon = 'icons/mob/actions/xylixmiracles.dmi'
	action_icon = 'icons/mob/actions/xylixmiracles.dmi'
	overlay_state = "mockery"
	releasedrain = 50
	associated_skill = /datum/skill/misc/music
	recharge_time = 2 MINUTES
	range = 5 //Say it to their face
	chargetime = 3 SECONDS //All churns come with a delay
	sound = 'sound/magic/timestop.ogg'
	invocations = list("begins uncontrollably giggling.")
	invocation_type = "emote"
	movement_interrupt = FALSE
	no_early_release = TRUE
	chargedloop = /datum/looping_sound/invokegen

/obj/effect/proc_holder/spell/invoked/gallowshumor/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/magic/mockery.ogg', 40, FALSE)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.anti_magic_check(TRUE, TRUE))
			return FALSE
		if(spell_guard_check(target, TRUE))
			target.visible_message(span_warning("[target] shrugs off the mockery!"))
			return TRUE
		if(!target.can_hear()) // Vicious mockery requires people to be able to hear you.
			revert_cast()
			return FALSE
		target.apply_status_effect(/datum/status_effect/debuff/gallowshumor)
		target.add_stress(/datum/stressevent/gallowshumor)
		SEND_SIGNAL(user, COMSIG_VICIOUSLY_MOCKED, target)
		record_round_statistic(STATS_PEOPLE_MOCKED)
		return TRUE
	revert_cast()
	return FALSE

/datum/status_effect/debuff/gallowshumor
	id = "gallowshumor"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/gallowshumor
	duration = 1 MINUTES
	effectedstats = list(STATKEY_LCK = -2)

/atom/movable/screen/alert/status_effect/debuff/gallowshumor
	name = "Gallows Humor"
	desc = "<span class='warning'>THAT CHILLED ME TO MY CORE!</span>\n"
	icon_state = "mockery"


////////////////////////////////////////////////////////////
// T3 - Divine Inspiration - Select your pack of miracles.//
////////////////////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/undivided_miracle_bundle
	name = "Divine Inspiration"
	desc = "Allows you to learn a set of empowering or utility miracles."
	base_icon_state = "wisescroll"
	miracle = TRUE
	devotion_cost = 200
	recharge_time = 25 MINUTES
	chargetime = 0
	chargedrain = 0
	range = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	var/chosen_bundle
	var/list/miracle_utility_bundle = list(
		/obj/effect/proc_holder/spell/invoked/diagnose,
		/obj/effect/proc_holder/spell/invoked/moondream,
		/obj/effect/proc_holder/spell/invoked/conjure_tool,
		/obj/effect/proc_holder/spell/targeted/locate_dead
	)
	var/list/miracle_buff_bundle = list(
		/obj/effect/proc_holder/spell/invoked/eora_blessing,
		/obj/effect/proc_holder/spell/self/wise_moon,
		/obj/effect/proc_holder/spell/invoked/bless_food,
		/obj/effect/proc_holder/spell/invoked/avert
	)

/obj/effect/proc_holder/spell/self/undivided_miracle_bundle/cast(list/targets, mob/user)
	. = ..()
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choice = alert(user, "What type of miracles did the Ten bless you with?", "CHOOSE PATH", "Utility", "Buffs")
		chosen_bundle = choice
	switch(choice)
		if("Utility")
			add_spells(user, miracle_utility_bundle, grant_all = TRUE)
			user.mind?.RemoveSpell(src.type)
		if("Buffs")
			add_spells(user, miracle_buff_bundle, grant_all = TRUE)
			user.mind?.RemoveSpell(src.type)
		else
			revert_cast()

/obj/effect/proc_holder/spell/self/undivided_miracle_bundle/proc/add_spells(mob/user, list/spells, choice_count = 1, grant_all = FALSE)
	for(var/spell_type in spells)
		if(user?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			var/choice = input(user, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in spells
			if(!isnull(choice))
				var/picked_spell = spells[choice]
				var/obj/effect/proc_holder/spell/new_spell = new picked_spell
				user?.mind.AddSpell(new_spell)
				choice_count_visual--
				spells.Remove(choice)
	else
		for(var/spell_type in spells)
			var/obj/effect/proc_holder/spell/new_spell = new spell_type
			user?.mind.AddSpell(new_spell)
	if(!length(spells))
		user.mind?.RemoveSpell(src.type)

//////////////////////////////////////////////////////////////////////////////////////////
// T3 - Undivided Fortify - Heals and damages undead like actual one, bit worse though. //
//////////////////////////////////////////////////////////////////////////////////////////

/obj/effect/proc_holder/spell/invoked/heal/undivided
	name = "Bolster"
	releasedrain = 40
	recharge_time = 30 SECONDS
	chargedloop = /datum/looping_sound/invokeholy
	chargetime = 1 SECONDS

///////////////////////////////////////////////////////////////////////////////////
// T4 - Ten United - Select your pack of miracles. This is for acolytes/heretics //
///////////////////////////////////////////////////////////////////////////////////
/*
/obj/effect/proc_holder/spell/self/undivided_acolyte_miracle_bundle
	name = "Ten United"
	desc = "Allows you to learn a set of high tier miracles."
	base_icon_state = "wisescroll"
	miracle = TRUE
	devotion_cost = 200
	recharge_time = 25 MINUTES
	chargetime = 0
	chargedrain = 0
	range = 0
	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy
	var/chosen_miracles
	var/list/miracle_tierthree_bundle = list(
		/obj/effect/proc_holder/spell/invoked/call_mossback,
		/obj/effect/proc_holder/spell/invoked/revive,
		/obj/effect/proc_holder/spell/invoked/hammerfall,
		/obj/effect/proc_holder/spell/invoked/cure_rot,
		/obj/effect/proc_holder/spell/invoked/persistence,
		/obj/effect/proc_holder/spell/targeted/touch/parlor_trick,
	)
	var/list/miracle_tierfour_bundle = list(
		/obj/effect/proc_holder/spell/invoked/abyssal_infusion,
		/obj/effect/proc_holder/spell/invoked/immolation,
		/obj/effect/proc_holder/spell/invoked/sunstrike,
		/obj/effect/proc_holder/spell/self/howl/call_of_the_moon,
		/obj/effect/proc_holder/spell/invoked/craftercovenant,
		/obj/effect/proc_holder/spell/invoked/deaths_door,
		/obj/effect/proc_holder/spell/invoked/pomegranate,
		/obj/effect/proc_holder/spell/invoked/abscond
	)

/obj/effect/proc_holder/spell/self/undivided_miracle_bundle_acolyte/cast(list/targets, mob/user)
	. = ..()
	var/choice = chosen_miracles
	if(!chosen_miracles)
		choice = alert(user, "What type of miracles did the Ten bless you with?", "CHOOSE PATH", "TIER III", "TIER IV")
		chosen_miracles = choice
	switch(choice)
		if("TIER III")
			add_spells(user, miracle_tierthree_bundle, choice_count = 2)
			user.mind?.RemoveSpell(src.type)
		if("TIER IV")
			add_spells(user, miracle_tierfour_bundle, choice_count = 1)
			user.mind?.RemoveSpell(src.type)
		else
			revert_cast()

/obj/effect/proc_holder/spell/self/undivided_miracle_bundle_acolyte/proc/add_spells(mob/user, list/spells, choice_count = 1, grant_all = FALSE)
	for(var/spell_type in spells)
		if(user?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			var/choice = input(user, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in spells
			if(!isnull(choice))
				var/picked_spell = spells[choice]
				var/obj/effect/proc_holder/spell/new_spell = new picked_spell
				user?.mind.AddSpell(new_spell)
				choice_count_visual--
				spells.Remove(choice)
	else
		for(var/spell_type in spells)
			var/obj/effect/proc_holder/spell/new_spell = new spell_type
			user?.mind.AddSpell(new_spell)
	if(!length(spells))
		user.mind?.RemoveSpell(src.type)
*/
