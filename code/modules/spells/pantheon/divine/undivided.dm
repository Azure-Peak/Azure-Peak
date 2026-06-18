//I am not copypasting it across every single miracle, sorry chud
/datum/action/cooldown/spell/undivided
	background_icon = 'icons/mob/actions/undividedmiracles.dmi'
	button_icon = 'icons/mob/actions/undividedmiracles.dmi'
	spell_color = GLOW_COLOR_UNDIVIDED

	ignore_armor_penalty = TRUE

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE

	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/////////////////////////////////////////
// T0 - Enkindle - Undivided Ignition. //
/////////////////////////////////////////

/datum/action/cooldown/spell/astrata/ignition/undivided
	name = "Enkindle"
	background_icon = 'icons/mob/actions/undividedmiracles.dmi'
	button_icon = 'icons/mob/actions/undividedmiracles.dmi'
	button_icon_state = "enkindle"
	spell_color = GLOW_COLOR_UNDIVIDED

	cast_range = SPELL_RANGE_GROUND - 2

	primary_resource_cost = SPELLCOST_MIRACLE_MINOR + 5

	secondary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	cooldown_time = 15 SECONDS

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// T0 - Twinned Gaze - Removes vision cone for duration as well grants night vision on high enough level. //
////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Astrata + Noc

/datum/action/cooldown/spell/undivided/twinned_gaze
	name = "Twinned Gaze"
	desc = "Removes the limit on your vision, letting you see behind you for a time, as well varying degrees of night vision. Duration & Darksight scales off holy skill and time of dae."
	fluff_desc = "Astrata's gift altered by Noc's meddling piercing through dae and nite with ease, rival siblings sharing Their powers to lowly mortals in hopes that they succeed in their duty."
	button_icon_state = "twinned_gaze"
	sound = 'sound/magic/undivided_bless.ogg'
	glow_intensity = 0

	click_to_activate = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE + 5 //Undivided miracles ALWAYS cost more

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Zwillingslichter, leitet meinen Blick.")//(Twin lights, guide my gaze)
	invocation_type = INVOCATION_WHISPER

	charge_required = FALSE
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/undivided/twinned_gaze/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
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

///////////////////
// T1 - Miracle  //
///////////////////

/datum/action/cooldown/spell/miracle/heal/undivided
	name = "Greater Miracle"
	desc = "Blesses the target with minor health regeneration. If casted in conjunction with the 'Fortify' blessing, its healing power is greatly \
	increased. Most healing Miracles cannot affect devoted Psydonians."
	fluff_desc = "Within Their realm disease and ailments hold no sway over the devout, even the deepest wound shall soon come apart in Their light."
	background_icon = 'icons/mob/actions/undividedmiracles.dmi'
	button_icon = 'icons/mob/actions/undividedmiracles.dmi'
	primary_resource_cost = SPELLCOST_MIRACLE

//////////////////////////////////////////////////////////////////////////////////
// T1 - Recuperation - Restore ENERGY to a target and provide restoration buff. //
//////////////////////////////////////////////////////////////////////////////////
//Malum + Pestra

/datum/action/cooldown/spell/undivided/recuperation
	name = "Recuperation"
	desc = "Restores the targets Energy and provides brief regeneration to it. Twice as effective on target other than yourself."
	fluff_desc = "Behind every great work is a hard-working master, dilligent and patient yet not immune from intricacies of lyfe. Even Malum has once fallen to such after losing His hammer, exhausted and weak he was nursed back to health by Pestra so that even he may continue on. Now Their shared gift fuels the forges of Psydonia for no great work shall go unfinished so long as They maintain vigil."
	button_icon_state = "calming_respite"
	sound = 'sound/magic/undivided_recuperation.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR - 10

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Setzt euer großartiges Werk fort.") //(Continue your great work/s)
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/undivided/recuperation/cast(atom/cast_on)
	. = ..()
	var/const/energytoregen = 50

	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if (!isliving(spelltarget))
		show_visible_message(owner, "You can only cast this on living beings.")
		return FALSE
	if (spelltarget == H)
		spelltarget.energy_add(energytoregen * (owner.get_skill_level(associated_skill)))//200 for templar, 300 for acolyte
		spelltarget.apply_status_effect(/datum/status_effect/buff/recuperation)
		show_visible_message(owner, "As [owner] intones the incantation, vibrant flames swirl around them.", "As you intone the incantation, vibrant flames swirl around you. You feel refreshed.")
	else if (H.energy > (energytoregen * 2))
		owner.energy_add(-(energytoregen * (owner.get_skill_level(associated_skill))))
		spelltarget.energy_add((energytoregen * (owner.get_skill_level(associated_skill))) * 2)
		spelltarget.apply_status_effect(/datum/status_effect/buff/recuperation/other)
		show_visible_message(spelltarget, "As [owner] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards [spelltarget].", "As [owner] intones the incantation, vibrant flames swirl around them, a dance of energy flowing towards you. You feel refreshed.")

/atom/movable/screen/alert/status_effect/buff/recuperation
	name = "Recuperation"
	desc = "A brief respite for my ailments."
	icon_state = "recuperation"

#define RECUPERATION_BASE_FILTER "recuperation"

/datum/status_effect/buff/recuperation
	id = "recuperation"
	alert_type = /atom/movable/screen/alert/status_effect/buff/recuperation
	duration = 10 SECONDS
	var/healing_on_tick = 5
	var/outline_colour = "#2e8d8d"

/datum/status_effect/buff/recuperation/other
	duration = 20 SECONDS

/datum/status_effect/buff/recuperation/on_apply()
	var/filter = owner.get_filter(RECUPERATION_BASE_FILTER)
	if (!filter)
		owner.add_filter(RECUPERATION_BASE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 90, "size" = 1))
	return TRUE

/datum/status_effect/buff/recuperation/tick()
	if(HAS_TRAIT(owner, TRAIT_IRONMAN))
		return
	var/stamheal = healing_on_tick
	if(!owner.cmode)
		stamheal *= 2
	owner.energy_add(stamheal)
	owner.adjust_bodytemperature(8)

/datum/status_effect/buff/recuperation/on_remove()
	owner.remove_filter(RECUPERATION_BASE_FILTER)

#undef RECUPERATION_BASE_FILTER

////////////////////////////////////////////////////////////
// T2 - Perseverance- Seal wounds and calm down a person. //
////////////////////////////////////////////////////////////
//Ravox + Eora

/datum/action/cooldown/spell/undivided/perseverance
	name = "Perseverance"
	desc = "Slows down bleed rate of living beings as well calming them down."
	fluff_desc = "Born of an union between compassion of Eora and persistance of Ravox, the couple heeds pleas of dying warriors as well the innocents lost to ravages of war offering them but a mote of respite and chance at lyfe."
	button_icon_state = "perseverance"
	sound = 'sound/magic/undivided_perserverance.ogg'
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND - 2
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR + 10

	secondary_resource_cost = SPELLCOST_STAT_BUFF - 5

	invocations = list("Die Götter fordern dich auf weiterzukämpfen!") //("The gods demand you to fight on!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/undivided/perseverance/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/spelltarget = cast_on

	var/woundpain_modifier = (0.15 + (0.1 * (owner.get_skill_level(associated_skill))))

	if (!isliving(spelltarget))
		show_visible_message(owner, "You can only cast this on living beings.")
		return FALSE
	else
		spelltarget.visible_message(span_info("Warmth radiates from [spelltarget] as their wounds seal over!"), span_notice("The pain from my wounds fade as warmth radiates from my soul!"))
		if(iscarbon(spelltarget))
			var/mob/living/carbon/C = spelltarget
			var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(owner.zone_selected))
			if(spelltarget.mind)
				spelltarget.add_stress(/datum/stressevent/perseverance)
			if(affecting)
				for(var/datum/wound/bleeder in affecting.wounds)
					bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * woundpain_modifier)
					if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
						var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
						bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference))
				return TRUE
		else if(HAS_TRAIT(spelltarget, TRAIT_SIMPLE_WOUNDS))
			for(var/datum/wound/bleeder in spelltarget.simple_wounds)
				bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * woundpain_modifier)
				if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
					var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
					bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference))
				return TRUE

/datum/stressevent/perseverance
	timer = 2 MINUTES 
	stressadd = -4 //Should be enough to offset the bleed
	desc = span_undivided("A mere respite from the horrors.")

////////////////////////////////////////////////////////////
// T2 - Divine Inspiration - Select your pack of miracles.//
////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/undivided/undivided_spellpack
	name = "Divine Inspiration"
	desc = "Allows you to pick out miracles from three different sets - Generalist (3 choices) Acolyte (2 choices) Templar (2 choices)."
	fluff_desc = "They protect against the enroaching darkness, when He abandoned us we wept a thousand tears in His name. They liberated us from the sorrow, gave us a path to absolution denied to us - for this we will be grateful and obedient to Their machinations."
	button_icon_state = "inspiration"
	sound = 'sound/magic/undivided_bless.ogg'
	glow_intensity = 0

	click_to_activate = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// var we use to flag we are currently choosing a bundle.
	var/choosing_bundle = FALSE
	var/chosen_bundle
	var/list/miracle_generalist_bundle = list(
		/datum/action/cooldown/spell/noc/inspiration::name					= /datum/action/cooldown/spell/noc/inspiration,
		/obj/effect/proc_holder/spell/invoked/spiderspeak::name				= /obj/effect/proc_holder/spell/invoked/spiderspeak,
		/datum/action/cooldown/spell/noc/invisibility::name					= /datum/action/cooldown/spell/noc/invisibility,
		/obj/effect/proc_holder/spell/targeted/blesscrop::name				= /obj/effect/proc_holder/spell/targeted/blesscrop,
		/obj/effect/proc_holder/spell/invoked/eora_blessing::name			= /obj/effect/proc_holder/spell/invoked/eora_blessing,
		/datum/action/cooldown/spell/arcyne_forge/miracle::name				= /datum/action/cooldown/spell/arcyne_forge/miracle,
	)
	var/list/miracle_acolyte_bundle = list(
		/obj/effect/proc_holder/spell/invoked/diagnose::name			= /obj/effect/proc_holder/spell/invoked/diagnose,
		/datum/action/cooldown/spell/noc/blindness::name				= /datum/action/cooldown/spell/noc/blindness,
		/obj/effect/proc_holder/spell/invoked/bless_food::name			= /obj/effect/proc_holder/spell/invoked/bless_food,
		/obj/effect/proc_holder/spell/invoked/avert::name				= /obj/effect/proc_holder/spell/invoked/avert,
		/obj/effect/proc_holder/spell/invoked/attach_bodypart::name		= /obj/effect/proc_holder/spell/invoked/attach_bodypart,
	)
	var/list/miracle_templar_bundle = list(
		/obj/effect/proc_holder/spell/invoked/abyssor_undertow::name 		= /obj/effect/proc_holder/spell/invoked/abyssor_undertow,
		/datum/action/cooldown/spell/ravox/withstand::name 					= /datum/action/cooldown/spell/ravox/withstand,
		/obj/effect/proc_holder/spell/invoked/heatmetal::name 				= /obj/effect/proc_holder/spell/invoked/heatmetal,
		/datum/action/cooldown/spell/noc/enlightenment::name 				= /datum/action/cooldown/spell/noc/enlightenment,
		/obj/effect/proc_holder/spell/invoked/vendetta::name 				= /obj/effect/proc_holder/spell/invoked/vendetta,
	)

/datum/action/cooldown/spell/undivided/undivided_spellpack/cast(atom/cast_on)
	. = ..()
	
	if(choosing_bundle)
		return FALSE
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choosing_bundle = TRUE
		choice = alert(owner, "What type of miracles did the Divines bless you with?", "CHOOSE PATH", "Generalist", "Acolyte", "Templar")
		chosen_bundle = choice
		choosing_bundle = FALSE
	switch(choice)
		if("Generalist")
			add_spells(owner, miracle_generalist_bundle, choice_count = 3)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Acolyte")
			add_spells(owner, miracle_acolyte_bundle, choice_count = 2)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Templar")
			add_spells(owner, miracle_templar_bundle, choice_count = 2)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/undivided/undivided_spellpack/proc/add_spells(mob/owner, list/spells, choice_count = 1, grant_all = FALSE)
	for(var/spell_type in spells)
		if(owner?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			var/choice = input(owner, "Choose a spell! Choices remaining: [choice_count_visual]") as anything in spells
			if(!isnull(choice))
				var/picked_spell = spells[choice]
				var/obj/effect/proc_holder/spell/new_spell = new picked_spell
				owner?.mind.AddSpell(new_spell)
				choice_count_visual--
				spells.Remove(choice)
	else
		for(var/spell_type in spells)
			var/obj/effect/proc_holder/spell/new_spell = new spell_type
			owner?.mind.AddSpell(new_spell)
	if(!length(spells))
		owner.mind?.RemoveSpell(src.type)

/////////////////////////////////////////////////////////////////////////////////////////////////////
// T3 - Gallows Humor - Moodnuke a target with any negative stress being double for quite a while. //
/////////////////////////////////////////////////////////////////////////////////////////////////////
//Necra + Xylix

/datum/action/cooldown/spell/undivided/gallow_humor
	name = "Gallows Humor"
	desc = "Share a terrible secret of lyfe with your target, reducing their Fortune and stressing them out."
	fluff_desc = "Psydonia is a place of many joys but underneath the facade lies true terror, lying in wait for another to stumble upon it. During his antics in the underworld Xylix stumbled upon one such horror, deep within realm of Necra laid great archive from times of Psydon filled to the brim with knowledge not meant for the eyes of mortals. Ignoring warnings given by Noc he bestowed such a gift towards his followers in hopes they use it well, for one only underestimates the poet once."
	button_icon_state = "gallows"
	sound = 'sound/magic/undivided_mockery.ogg'
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_NONE//Handled on coast

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/undivided/gallow_humor/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(!isliving(spelltarget))
		show_visible_message(owner, "You can only cast this on living beings.")
		return FALSE
	owner.visible_message("<font color='cyan'>[owner] whispers something to [spelltarget].</font>")
	playsound(get_turf(spelltarget), 'sound/magic/undivided_gallows.ogg', 70, FALSE)
	if(spelltarget.anti_magic_check(TRUE, TRUE))
		return FALSE
	if(spell_guard_check(spelltarget, TRUE))
		spelltarget.visible_message(span_warning("[spelltarget] shrugs off the mockery!"))
		return TRUE
	if(!spelltarget.can_hear()) // Vicious mockery requires people to be able to hear you.
		return FALSE
	spelltarget.apply_status_effect(/datum/status_effect/debuff/gallowshumor)
	spelltarget.add_stress(/datum/stressevent/gallowshumor)
	SEND_SIGNAL(owner, COMSIG_VICIOUSLY_MOCKED, spelltarget)
	record_round_statistic(STATS_PEOPLE_MOCKED)
	return TRUE

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
	stressadd = 10 //Hop Tuah
	desc = span_undivided("NO NO NO!")

/datum/status_effect/debuff/gallowshumor/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_MIRACLE)
	owner.update_stress()

/datum/status_effect/debuff/gallowshumor/on_remove()
	REMOVE_TRAIT(owner, TRAIT_BAD_MOOD, TRAIT_MIRACLE)
	owner.update_stress()
	return ..()

//////////////////////////////////////////////////////////////////////////////////////////
// T3 - Undivided Fortify - Heals and damages undead like actual one, bit worse though. //
//////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/miracle/fortify/undivided
	name = "Bolster"
	background_icon = 'icons/mob/actions/undividedmiracles.dmi'
	button_icon = 'icons/mob/actions/undividedmiracles.dmi'
	button_icon_state = "bolster"

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR - 10

	secondary_resource_cost = SPELLCOST_MINOR_SKILL

	sound = 'sound/magic/heal_new.ogg'
	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/holycharging.ogg'

///////////////////////////////////////////////////////////////////////////////////
// T4 - Ten United - Select your pack of miracles. This is for acolytes/heretics //
///////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/undivided/undivided_battlecry
	name = "Ten United"
	desc = "Rally the faithful to fight by your side, providing a buff (CONSTITUTION 2, WILLPOWER 2, FORTUNE 4) to Divine worshippers. Inhumen and Psydonites are left out, deadites suffer Daze (PERCEPTION -1, INTELLIGENCE -2, SPEED -1) within the radius."
	fluff_desc = "From one whole they were created, molded by eachother into the beings they are now, alone they would wither away and die by enroaching darkness."
	button_icon_state = "united"
	sound = 'sound/magic/battle_cry_undivided.ogg'
	glow_intensity = GLOW_INTENSITY_VERY_HIGH

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_AURA

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR + 40

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_STAT_BUFF + 20

	invocations = list("United we stand!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 6 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/undivided/undivided_battlecry/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	for(var/mob/living/carbon/target in view(cast_range, get_turf(owner)))
		if(istype(target.patron, /datum/patron/divine))
			target.apply_status_effect(/datum/status_effect/buff/ten_united)
			continue
		if(istype(target.patron, /datum/patron/old_god) || istype(target.patron, /datum/patron/inhumen)) 
			to_chat(target, span_undivided("The divine light leaves me as abruptly as it came."))
			continue
		if(!owner.faction_check_mob(target))
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
	desc = span_undivided("WE STAND TOGETHER!")
	icon_state = "ten_united"
