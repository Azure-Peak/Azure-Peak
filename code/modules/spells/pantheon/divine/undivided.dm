////////////////////////////////////////////////////////////////////////////////////////////////////////////
// T0 - Twinned Gaze - Removes vision cone for duration as well grants night vision on high enough level. //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Astrata + Noc

/obj/effect/proc_holder/spell/self/twinned_gaze
	name = "Twinned Gaze"
	desc = "Removes the limit on your vision, letting you see behind you for a time, as well varying degrees of night vision. Duration & Darksight scales off holy skill and time of dae."
	action_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_state = "twinned_gaze"

	recharge_time = 2 MINUTES
	releasedrain = 10
	miracle = TRUE
	devotion_cost = 30

	sound = 'sound/magic/undivided_bless.ogg'
	invocation_type = INVOCATION_SHOUT
	invocations = "Zwillingslichter, geleitet meinen Blick." //(Twin lights, guide my gaze)

	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

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
	duration = 15 SECONDS
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
	duration = 15 SECONDS


	if(skill_level > SKILL_LEVEL_EXPERT)
		ADD_TRAIT(owner, TRAIT_NITEVISION, TRAIT_GAZE)
	else if(skill_level >= SKILL_LEVEL_APPRENTICE)
		ADD_TRAIT(owner, TRAIT_DARKVISION, TRAIT_GAZE)

	if(GLOB.tod == "day" || GLOB.tod == "night")
		duration *= 2

	duration *= skill_level

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = TRUE
		H.hide_cone()
		H.update_cone_show()

	return ..()

/datum/status_effect/buff/twinned_gaze/on_remove()
	. = ..()
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.viewcone_override = FALSE
		H.hide_cone()
		H.update_cone_show()
	if(HAS_TRAIT(owner, TRAIT_NITEVISION))
		REMOVE_TRAIT(owner, TRAIT_NITEVISION, TRAIT_GAZE)
	else
		REMOVE_TRAIT(owner, TRAIT_DARKVISION, TRAIT_GAZE)


/////////////////////////////////////////
// T0 - Enkindle - Undivided Ignition. //
/////////////////////////////////////////

/obj/effect/proc_holder/spell/invoked/ignition/undivided
	name = "Enkindle"
	action_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_state = "enkindle"
	base_icon_state = "spell"

	recharge_time = 15 SECONDS
	releasedrain = 25
	range = 7
	devotion_cost = 20

	invocations = list("Entflamme.") //(Kindle)

//////////////////////////////////////////////////////////////////////////////////
// T1 - Recuperation - Restore ENERGY to a target and provide restoration buff. //
//////////////////////////////////////////////////////////////////////////////////
//Malum + Pestra

/obj/effect/proc_holder/spell/invoked/recuperation
	name = "Recuperation"
	desc = "Restores the targets Energy and provides brief regeneration to it. Twice as effective on target other than yourself."
	action_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_state = "calming_respite"

	recharge_time = 3 MINUTES
	releasedrain = 20

	miracle = TRUE
	devotion_cost = 50

	chargetime = 1 SECONDS
	chargedloop = /datum/looping_sound/invokeholy
	warnie = "sydwarning"

	sound = 'sound/magic/undivided_recuperation.ogg'
	invocations = list("Setzt eurer großartiges Werk fort!") //(Continue your great work/s)

	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/recuperation/cast(list/targets, mob/living/user)
	. = ..()
	var/const/energytoregen = 50
	var/mob/living/carbon/target = targets[1]
	if (!iscarbon(target)) 
		return
	if (target == user)
		target.energy_add(energytoregen * (user.get_skill_level(associated_skill)))//200 for templar, 300 for acolyte
		target.apply_status_effect(/datum/status_effect/buff/recuperation)
		show_visible_message(usr, "As [user] intones the incantation, vibrant flames swirl around them.", "As you intone the incantation, vibrant flames swirl around you. You feel refreshed.")
	else if (user.energy > (energytoregen * 2))
		user.energy_add(-(energytoregen * (user.get_skill_level(associated_skill))))
		target.energy_add((energytoregen * (user.get_skill_level(associated_skill))) * 2)
		target.apply_status_effect(/datum/status_effect/buff/recuperation/other)
		show_visible_message(target, "As [user] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards [target].", "As [user] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards you. You feel refreshed.")

/atom/movable/screen/alert/status_effect/buff/recuperation
	name = "Recuperation"
	desc = "A brief respite for my ailments."
	icon_state = "recuperation"

#define RECUPERATION_BASE_FILTER "recuperation"

/datum/status_effect/buff/recuperation
	id = "recuperation"
	alert_type = /atom/movable/screen/alert/status_effect/buff/recuperation
	duration = 5 SECONDS
	var/healing_on_tick = 5
	var/outline_colour = "#2e8d8d"

/datum/status_effect/buff/recuperation/other
	duration = 10 SECONDS

/datum/status_effect/buff/recuperation/eoran
	duration = 1 MINUTES
	healing_on_tick = 2
	outline_colour = "#EEBBBB"

/datum/status_effect/buff/recuperation/on_apply()
	var/filter = owner.get_filter(RECUPERATION_BASE_FILTER)
	if (!filter)
		owner.add_filter(RECUPERATION_BASE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 90, "size" = 1))
	return TRUE

/datum/status_effect/buff/recuperation/tick()
	if(owner.construct)
		return
	var/stamheal = healing_on_tick
	if(!owner.cmode)
		stamheal *= 2
	owner.energy_add(stamheal)
	owner.adjust_bodytemperature(8)

/datum/status_effect/buff/recuperation/on_remove()
	owner.remove_filter(RECUPERATION_BASE_FILTER)

#undef RECUPERATION_BASE_FILTER

////////////////////////////////////////////////////////////////////////////
// T1 - Rending Strike - Slow down a target, same as Ravox divine strike. //
////////////////////////////////////////////////////////////////////////////
//Heretic + pick from pack

/obj/effect/proc_holder/spell/self/divine_strike/undivided
	name = "Rending Strike"
	action_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_state = "smite"

	releasedrain = 10
	devotion_cost = 40

	invocations = list("Geleitet meine Hand!") //("Guide my hand!")

////////////////////////////////////////////////////////////
// T2 - Perseverance- Seal wounds and calm down a person. //
////////////////////////////////////////////////////////////
//Ravox + Eora

/obj/effect/proc_holder/spell/invoked/perseverance
	name = "Perseverance"
	desc = "Slows down bleed rate of living beings as well calming them down."
	action_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_state = "perseverance"

	recharge_time = 40 SECONDS
	releasedrain = 40
	range = 5
	miracle = TRUE
	devotion_cost = 40

	chargetime = 2 SECONDS
	chargedloop = /datum/looping_sound/invokeholy
	warnie = "sydwarning"

	sound = 'sound/magic/undivided__perserverance.ogg'
	invocations = list("Die Göttlichen fordern dich auf weiterzukämpfen!") //("The gods demand you to fight on!")

	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/perseverance/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		target.visible_message(span_info("Warmth radiates from [target] as their wounds seal over!"), span_notice("The pain from my wounds fade as warmth radiates from my soul!"))

		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(user.zone_selected))
			if(target.mind)
				target.add_stress(/datum/stressevent/perseverance)
			if(affecting)
				for(var/datum/wound/bleeder in affecting.wounds)
					bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.2)
					if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
						var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
						bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference))
		else if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
			for(var/datum/wound/bleeder in target.simple_wounds)
				bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.2)
				if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
					var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
					bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference))
		return TRUE
	return FALSE

/datum/stressevent/perseverance
	timer = 2 MINUTES 
	stressadd = -4 //Should be enough to offset the bleed
	desc = span_boldgreen("I am soothed from the ravages of war.")

////////////////////////////////////////////////////////////
// T2 - Divine Inspiration - Select your pack of miracles.//
////////////////////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/undivided_miracle_bundle
	name = "Divine Inspiration"
	desc = "Allows you to pick out miracles from three different sets - Generalist (3 choices) Acolyte (2 choices) Templar (2 choices)."
	action_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_state = "inspiration"

	recharge_time = 25 MINUTES//Doesn't matter it's one time use
	range = 0
	miracle = TRUE
	devotion_cost = 100	

	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

	var/chosen_bundle
	var/list/miracle_generalist_bundle = list(
		/obj/effect/proc_holder/spell/self/astrata_fireresist::name			= /obj/effect/proc_holder/spell/self/astrata_fireresist,
		/obj/effect/proc_holder/spell/invoked/spiderspeak::name				= /obj/effect/proc_holder/spell/invoked/spiderspeak,
		/obj/effect/proc_holder/spell/invoked/invisibility/miracle::name	= /obj/effect/proc_holder/spell/invoked/invisibility/miracle,
		/obj/effect/proc_holder/spell/targeted/blesscrop::name				= /obj/effect/proc_holder/spell/targeted/blesscrop,
		/obj/effect/proc_holder/spell/invoked/eora_blessing::name			= /obj/effect/proc_holder/spell/invoked/eora_blessing,
		/datum/action/cooldown/spell/arcyne_forge/miracle::name				= /datum/action/cooldown/spell/arcyne_forge/miracle,
	)
	var/list/miracle_acolyte_bundle = list(
		/obj/effect/proc_holder/spell/invoked/diagnose::name			= /obj/effect/proc_holder/spell/invoked/diagnose,
		/obj/effect/proc_holder/spell/self/blindnessorsilence::name		= /obj/effect/proc_holder/spell/self/blindnessorsilence,
		/obj/effect/proc_holder/spell/invoked/moondream::name			= /obj/effect/proc_holder/spell/invoked/moondream,
		/obj/effect/proc_holder/spell/invoked/bless_food::name			= /obj/effect/proc_holder/spell/invoked/bless_food,
		/obj/effect/proc_holder/spell/invoked/avert::name				= /obj/effect/proc_holder/spell/invoked/avert,
		/obj/effect/proc_holder/spell/invoked/attach_bodypart::name		= /obj/effect/proc_holder/spell/invoked/attach_bodypart,
	)
	var/list/miracle_templar_bundle = list(
		/obj/effect/proc_holder/spell/invoked/abyssor_undertow::name 		= /obj/effect/proc_holder/spell/invoked/abyssor_undertow,
		/obj/effect/proc_holder/spell/self/balance_immune::name 			= /obj/effect/proc_holder/spell/self/balance_immune,
		/obj/effect/proc_holder/spell/invoked/heatmetal::name 				= /obj/effect/proc_holder/spell/invoked/heatmetal,
		/obj/effect/proc_holder/spell/self/wise_moon::name 					= /obj/effect/proc_holder/spell/self/wise_moon,
		/obj/effect/proc_holder/spell/self/divine_strike/undivided::name 	= /obj/effect/proc_holder/spell/self/divine_strike/undivided,
		/obj/effect/proc_holder/spell/invoked/vendetta::name 				= /obj/effect/proc_holder/spell/invoked/vendetta,
	)

/obj/effect/proc_holder/spell/self/undivided_miracle_bundle/cast(list/targets, mob/user)
	. = ..()
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choice = alert(user, "What type of miracles did the Ten bless you with?", "CHOOSE PATH", "Generalist", "Acolyte", "Templar")
		chosen_bundle = choice
	switch(choice)
		if("Generalist")
			add_spells(user, miracle_generalist_bundle, choice_count = 3)
			user.mind?.RemoveSpell(src.type)
		if("Acolyte")
			add_spells(user, miracle_acolyte_bundle, choice_count = 2)
			user.mind?.RemoveSpell(src.type)
		if("Templar")
			add_spells(user, miracle_templar_bundle, choice_count = 2)
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
			var/choice = input(user, "Choose a spell! Choices remaining: [choice_count_visual]") as anything in spells
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

//////////////////////////////////////////////////////////////////////////////////////
// T3 - Gallows Humor - Moodnuke a target with slight slap on the wrist to FORTUNE. //
//////////////////////////////////////////////////////////////////////////////////////
//Necra + Xylix

/obj/effect/proc_holder/spell/invoked/gallowshumor
	name = "Gallows Humor"
	desc = "Share a terrible secret of lyfe with your target, reducing their Fortune and stressing them out."
	action_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_state = "gallows"

	recharge_time = 2 MINUTES
	releasedrain = 20
	range = 5 //Say it to their face
	miracle = TRUE
	devotion_cost = 50

	chargetime = 1 SECONDS
	chargedloop = /datum/looping_sound/invokeholy

	sound = 'sound/magic/undivided_mockery.ogg'
	invocation_type = INVOCATION_EMOTE
	invocations = list("cackles uncontrollably.")

	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/gallowshumor/cast(list/targets, mob/user = usr)
	playsound(get_turf(user), 'sound/magic/undivided_gallows.ogg', 70, FALSE)
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
	duration = 2 MINUTES

/atom/movable/screen/alert/status_effect/debuff/gallowshumor
	name = "Gallows Humor"
	desc = "<span class='warning'>THAT CHILLED ME TO MY CORE!</span>\n"
	icon_state = "gallows"

/datum/stressevent/gallowshumor
	timer = 10 MINUTES 
	stressadd = 5
	desc = span_boldred("NO NO NO!")

/datum/status_effect/debuff/gallowshumor/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_MIRACLE)

/datum/status_effect/debuff/gallowshumor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_MIRACLE)
	owner.update_stress()
	return ..()

//////////////////////////////////////////////////////////////////////////////////////////
// T3 - Undivided Fortify - Heals and damages undead like actual one, bit worse though. //
//////////////////////////////////////////////////////////////////////////////////////////

/obj/effect/proc_holder/spell/invoked/heal/undivided
	name = "Bolster"
	action_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_state = "bolster"

	recharge_time = 30 SECONDS
	releasedrain = 40

	sound = 'sound/magic/heal_new.ogg'
	chargetime = 1 SECONDS
	chargedloop = /datum/looping_sound/invokeholy

///////////////////////////////////////////////////////////////////////////////////
// T4 - Ten United - Select your pack of miracles. This is for acolytes/heretics //
///////////////////////////////////////////////////////////////////////////////////

/obj/effect/proc_holder/spell/self/ten_united
	name = "Ten United"
	desc = "Rally the faithful to fight by your side, providing a buff (CONSTITUTION 2, WILLPOWER 2, FORTUNE 4) to Divine worshippers. Inhumen and Psydonites are left out, deadites suffer Daze (PERCEPTION -1, INTELLIGENCE -2, SPEED -1) within the radius."
	action_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_icon = 'icons/mob/actions/undividedmiracles.dmi'
	overlay_state = "united"

	recharge_time = 6 MINUTES
	releasedrain = 30
	range = 5
	miracle = TRUE
	devotion_cost = 40

	sound = 'sound/magic/battle_cry_undivided.ogg'
	invocation_type = INVOCATION_SHOUT
	invocations = list("WE STAND TOGETHER!", "UNITED WE WILL PREVAIL!", "DRIVE THE FIENDS BACK!!")

	req_items = list(/obj/item/clothing/neck/roguetown/psicross)
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/self/ten_united/cast(list/targets,mob/living/user = usr)
	for(var/mob/living/carbon/target in view(range, get_turf(user)))
		if(istype(target.patron, /datum/patron/divine))
			target.apply_status_effect(/datum/status_effect/buff/ten_united)
			continue
		if(istype(target.patron, /datum/patron/old_god) || istype(target.patron, /datum/patron/inhumen)) 
			to_chat(target, span_danger("The divine light leaves me as abruptly as it came.."))
			continue
		if(!user.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			target.apply_status_effect(/datum/status_effect/debuff/dazed/smite)
			continue
	return TRUE

/datum/status_effect/buff/ten_united
	id = "ten_united"
	alert_type = /atom/movable/screen/alert/status_effect/buff/ten_united
	duration = 3 MINUTES// T4 and carries no debuff with it
	effectedstats = list(STATKEY_CON = 2, STATKEY_WIL = 2, STATKEY_LCK = 4)

/atom/movable/screen/alert/status_effect/buff/ten_united
	name = "Undivided Camaraderie"
	desc = span_bloody("WE STAND TOGETHER!")
	icon_state = "ten_united"
