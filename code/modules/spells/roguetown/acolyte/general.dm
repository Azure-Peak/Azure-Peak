#define BASE_HEALING_PER_TICK 3
#define MAX_BONUS_HEAL 0.5

/datum/action/cooldown/spell/miracle
	background_icon = 'icons/mob/actions/genericmiracles.dmi'
	button_icon = 'icons/mob/actions/genericmiracles.dmi'
//Spell color doesn't matter, these don't come with any visual effects
	glow_intensity = 0

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	ignore_armor_penalty = TRUE

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	//required_items = list(/obj/item/clothing/neck/roguetown/psicross)//Any cross will do it's generic

////////////////////
// MIRACLE - HEAL //
////////////////////

/datum/action/cooldown/spell/miracle/heal
	name = "Miracle"
	desc = "Blesses the target with minor health regeneration. If casted in conjunction with the 'Fortify' blessing, its healing power is greatly \
	increased. Most healing Miracles cannot affect devoted Psydonians.\
	<br><br><b>Patron Conditions:</b>\
	<ul>\
	<li><b>Abyssor:</b> +60% healing when the target is standing in water.</li>\
	<li><b>Astrata:</b> +80% healing during daytime. Up to +100% if the target has the Noble trait (does not stack with daytime).</li>\
	<li><b>Dendor:</b> Up to +80% from nearby natural objects (grass, trees, mushrooms, soil). Each wise tree grants an additional +60%.</li>\
	<li><b>Eora:</b> +100% if the target is a pacifist. +60% if the caster is also a pacifist. Up to +160% total.</li>\
	<li><b>Malum:</b> Up to +100% scaling with nearby fire sources (torches, campfires, hearths, candles, forges).</li>\
	<li><b>Necra:</b> +100% when the target is below 25% health. +50% if the caster has Necran Mists active. Up to +150% total.</li>\
	<li><b>Noc:</b> +40% healing during nighttime.</li>\
	<li><b>Pestra:</b> +40% when the target is laying down (not buckled). Also restores blood and heals toxin damage.</li>\
	<li><b>Ravox:</b> +40% if the target is using a strong attack intent. +20% if holding a weapon. +80% with blood restoration if cast on self while at low blood (30s cooldown). Up to +140% total.</li>\
	<li><b>Xylix:</b> 50% chance of a random +40% to +100% bonus.</li>\
	<li><b>Undivided:</b> Always +80% with no conditions.</li>\
	<li><b>Baotha:</b> +20% if the target is drunk or on drugs. +20% if experiencing withdrawal. Up to +80% additional from wound pain and bleeding. Up to +120% total.</li>\
	<li><b>Graggar:</b> Up to +100% scaling with nearby blood decals.</li>\
	<li><b>Matthios:</b> +100% if the target has the Freeman trait.</li>\
	<li><b>Zizo:</b> Up to +200% scaling with nearby bones and bone bundles.</li>\
	</ul>"
	fluff_desc = "The lyfeline of any devotee, channeling restorative energies of their worshipped diety within mortal realm."
	button_icon_state = "heal"
	sound = 'sound/magic/heal.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_MINOR

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_NONE

	charge_required = FALSE
	cooldown_time = 15 SECONDS

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/miracle/heal/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(!isliving(spelltarget))
		return FALSE

	if(HAS_TRAIT(spelltarget, TRAIT_PSYDONITE))
		spelltarget.visible_message(span_artery("[spelltarget] stirs for a moment, the miracle dissipates."), span_artery("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
		owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		playsound(spelltarget, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		return FALSE

	if(HAS_TRAIT(spelltarget, TRAIT_BLACKBLOOD))
		spelltarget.visible_message(span_artery("[spelltarget] stirs in discomfort, the miracle dissipates."), span_artery("A dull warmth spreads through your body, only to fade as quickly as it arrived."))
		owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		playsound(spelltarget, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		spelltarget.emote("pain")
		return FALSE

	if(HAS_TRAIT(spelltarget, TRAIT_IRONMAN))
		spelltarget.visible_message(span_artery("[target] doesn't seem to be organic, the miracle dissipates."), span_artery("A dull warmth never meets your non-existent heart, it fades as quickly as it arrives."))
		owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		playsound(spelltarget, 'sound/magic/PSY.ogg', 100, FALSE, -1)

	if(spelltarget.has_status_effect(/datum/status_effect/buff/healing))
		to_chat(owner, span_warning("They are already under the effects of a healing aura!"))
		return FALSE

	owner.Beam(spelltarget,icon_state="lichbeam",time=1 SECONDS)

	if(H.patron?.undead_hater && (spelltarget.mob_biotypes & MOB_UNDEAD))
		// We simply do nothing to avoid healing being used to vamp/skelly check!
		var/message_out_undead = span_info("Healing energies envelop [spelltarget]!")
		var/message_self_undead = span_notice("I am bathed in healing choral hymns!")
		spelltarget.visible_message(message_out_undead, message_self_undead)
		return TRUE

	var/conditional_buff = FALSE
	var/situational_bonus = 1
	var/is_inhumen = FALSE

	// Edit - This is overwritten near the end of the proc to prevent metagaming.
	var/message_out = span_info("A choral sound comes from above and [target] is healed!")
	var/message_self = span_notice("I am bathed in healing choral hymns!")

	H.patron.on_lesser_heal(owner, spelltarget, &message_out, &message_self, &conditional_buff, &situational_bonus, &is_inhumen)

	var/healing = BASE_HEALING_PER_TICK

	if(conditional_buff)
		to_chat(owner, "Channeling my patron's power is easier in these conditions!")
		healing += min(MAX_BONUS_HEAL, situational_bonus)

	if(!ishuman(spelltarget))
		spelltarget.apply_status_effect(/datum/status_effect/buff/healing, healing, is_inhumen)
		return TRUE

	var/no_embeds = TRUE
	var/list/embeds = spelltarget.get_embedded_objects()

	for(var/object in embeds)
		if(istype(object, /obj/item/natural/worms/leech)) // Leeches and surgical cheeles are made an exception.
			continue

		no_embeds = FALSE
		break

	if(!no_embeds)
		spelltarget.visible_message("The wounds tear and rip around the embedded objects!", "Agonising pain shoots through your body as magycks try to sew around the embedded objects!")
		spelltarget.adjustBruteLoss(20)
		playsound(spelltarget, 'sound/combat/dismemberment/dismem (2).ogg', 100)
		spelltarget.emote("agony")
		return

	spelltarget.apply_status_effect(/datum/status_effect/buff/healing, healing)

	// Edit - Overwriting the outgoing message here to prevent metagaming faith via message.
	// Not getting rid of the messages in the code, we might want them for something else later.
	message_out = span_info("Healing energies envelop [spelltarget]!")
	if(HAS_TRAIT(owner, TRAIT_DECEIVING_MEEKNESS))
		message_self = "Healing energies envelop me!"
	spelltarget.visible_message(message_out, message_self)
	return TRUE

///////////////////////
// MIRACLE - FORTIFY //
///////////////////////

/datum/action/cooldown/spell/miracle/fortify
	name = "Fortify"
	desc = "Amplifies all incoming sources of healing for the chosen target. Combining this with the 'Miracle' blessing allows for the mending \
	of more extreme injuries. </br>Most healing Miracles cannot affect devoted Psydonians."
	fluff_desc = "The lyfeline of any devotee, channeling restorative energies of their worshipped diety within mortal realm."
	button_icon_state = "fortify"
	sound = 'sound/magic/heal.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_NONE

	charge_required = FALSE
	cooldown_time = 45 SECONDS

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/miracle/fortify/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(!isliving(spelltarget))
		return FALSE

	if(HAS_TRAIT(spelltarget, TRAIT_PSYDONITE))
		spelltarget.visible_message(span_artery("[spelltarget] stirs for a moment, the miracle dissipates."), span_artery("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
		owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		playsound(spelltarget, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		return FALSE

	if(HAS_TRAIT(spelltarget, TRAIT_BLACKBLOOD))
		spelltarget.visible_message(span_artery("[spelltarget] stirs in pain, the miracle dissipates."), span_artery("You feel a dull pain spreading through your body, only to fade as quickly as it arrived."))
		owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		playsound(spelltarget, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		spelltarget.emote("pain")
		return FALSE

	if(HAS_TRAIT(spelltarget, TRAIT_IRONMAN))
		spelltarget.visible_message(span_artery("[target] doesn't seem to be organic, the miracle dissipates."), span_artery("A dull warmth never meets your non-existent heart, it fades as quickly as it arrives."))
		owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		playsound(spelltarget, 'sound/magic/PSY.ogg', 100, FALSE, -1)
		return FALSE

	owner.Beam(spelltarget,icon_state="lichbeam",time=1 SECONDS)

	if(H.patron?.undead_hater && (spelltarget.mob_biotypes & MOB_UNDEAD)) //positive energy harms the undead
		spelltarget.visible_message(span_danger("[spelltarget] is burned by holy light!"), span_userdanger("I'm burned by holy light!"))
		spelltarget.adjustFireLoss(25)
		spelltarget.fire_act(1,10)
		return TRUE

	spelltarget.visible_message(span_info("A wreath of gentle light passes over [spelltarget]!"), span_notice("I'm bathed in holy light!"))
	if(iscarbon(spelltarget) && !spelltarget.has_status_effect(/datum/status_effect/buff/fortify))
		spelltarget.apply_status_effect(/datum/status_effect/buff/fortify)
	else
		spelltarget.adjustBruteLoss(-25)
		spelltarget.adjustFireLoss(-25)
		spelltarget.adjustOxyLoss(-15)

	return TRUE

////////////////////////////
// MIRACLE - INTERVENTION //
////////////////////////////

/datum/action/cooldown/spell/miracle/intervention
	name = "Intervention"
	desc = "Blesses the chosen target's limb, healing all damage and wounds present on it. This can fix ruptured arteries, broken bones, and \
	anything short of complete dismemberment. </br>Most healing Miracles cannot affect devoted Psydonians."
	fluff_desc = "The most devout of Priests are taught in the old ways, able to reverse mortal wounds in blink of an eye where others would fail."
	button_icon_state = "woundheal"
	sound = 'sound/magic/woundheal.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/delay = 4.5 SECONDS	//Reduced to 1.5 seconds with Legendary

/datum/action/cooldown/spell/miracle/intervention/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/HU = owner
	if(!istype(HU))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(ishuman(spelltarget))

		var/mob/living/carbon/human/target = spelltarget
		var/def_zone = check_zone(owner.zone_selected)
		var/obj/item/bodypart/affecting = target.get_bodypart(def_zone)

		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE

		if(!affecting)
			return FALSE
		if(length(affecting.embedded_objects))
			var/no_embeds = TRUE
			for(var/object in affecting.embedded_objects)
				if(!istype(object, /obj/item/natural/worms/leech))	//Leeches and surgical cheeles are made an exception.
					no_embeds = FALSE
			if(!no_embeds)
				to_chat(owner, span_warning("We cannot seal wounds with objects inside this limb!"))
				return FALSE
		if(!do_after(owner, (delay - (0.5 SECONDS * HU.get_skill_level(associated_skill)))))
			to_chat(owner, span_warning("We were interrupted!"))
			return FALSE
		var/foundwound = FALSE
		if(length(affecting.wounds))
			for(var/datum/wound/wound in affecting.wounds)
				if(!isnull(wound) && wound.healable_by_miracles)
					wound.heal_wound(wound.whp)
					foundwound = TRUE
					owner.visible_message(("<font color = '#488f33'>[capitalize(wound.name)] oozes a clear fluid and closes shut, forming into a sore bruise!</font>"))
					affecting.add_wound(/datum/wound/bruise/woundheal)
			if(foundwound)
				playsound(target, 'sound/magic/woundheal_crunch.ogg', 100, TRUE)
			affecting.change_bodypart_status(BODYPART_ORGANIC, heal_limb = TRUE)
			affecting.update_disabled()
			return TRUE
		else
			to_chat(owner, span_warning("The limb is free of wounds."))
			return FALSE
	return FALSE

//////////////////////////////////
// MIRACLE - LYFEBLOOD TRANSFER //
//////////////////////////////////

/datum/action/cooldown/spell/miracle/bloodmiracle
	name = "Lyfeblood Transfer"
	desc = "Transfers blood from the caster to the chosen target at a steady rate, staving off the lethal effects of blood loss. The amount of \
	blood transfered with each heartbeat scales with the caster's Holy skill. </br>Most healing Miracles cannot affect devoted Psydonians."
	fluff_desc = "Manipulation of lyfeblood is often seen as heretical and taboo thanks to its association with Lyckers & Liches. Due to its usefulness however this technique is one of the few sanctioned to be taught across Psydonia."
	button_icon_state = "bloodheal"
	sound = 'sound/magic/bloodheal.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND - 2
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocation_type = INVOCATION_NONE

	charge_required = FALSE
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_NO_MOVE

	var/blood_price = 5
	var/blood_vol_restore = 7.5 //30 every 2 seconds.
	var/vol_per_skill = 1	//54 with legendary
	var/delay = 0.5 SECONDS

/datum/action/cooldown/spell/miracle/bloodmiracle/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/UH = owner
	if(!istype(UH))
		return FALSE

	var/mob/living/spelltarget = cast_on
	var/mob/living/carbon/human/target = spelltarget//This is awful but it's what you get

	if(ishuman(spelltarget))
		if(NOBLOOD in UH.dna?.species?.species_traits)
			to_chat(UH, span_warning("I have no blood to provide."))
			return FALSE

		if(target.blood_volume >= BLOOD_VOLUME_NORMAL)
			to_chat(UH, span_warning("Their lyfeblood is at capacity. There is no need."))
			return FALSE
			
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			owner.playsound_local(owner, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE

		UH.visible_message(span_warning("Tiny strands of red link between [UH] and [target], blood being transferred!"))
		playsound(UH, 'sound/magic/bloodheal_start.ogg', 100, TRUE)
		var/user_skill = UH.get_skill_level(associated_skill)
		var/user_informed = FALSE
		switch(user_skill)	//Bleeding happens every life(), which is every 2 seconds. Multiply these numbers by 4 to get the "bleedrate" equivalent values.
			if(SKILL_LEVEL_APPRENTICE)
				blood_price = 3.75
			if(SKILL_LEVEL_JOURNEYMAN)
				blood_price = 2.5
			if(SKILL_LEVEL_EXPERT)
				blood_price = 2
			if(SKILL_LEVEL_MASTER)
				blood_price = 1.625
			if(SKILL_LEVEL_LEGENDARY)
				blood_price = 1.25
		if(user_skill > SKILL_LEVEL_NOVICE)
			blood_vol_restore += vol_per_skill * user_skill
		var/max_loops = round(UH.blood_volume / blood_price, 1) * 2	// x2 just in case the user is trying to fill themselves up while using it.
		var/datum/beam/bloodbeam = owner.Beam(target,icon_state="blood",time=(max_loops * 5))
		for(var/i in 1 to max_loops)
			if(UH.blood_volume > (BLOOD_VOLUME_SURVIVE / 2))
				if(do_after(UH, delay))
					target.blood_volume = min((target.blood_volume + blood_vol_restore), BLOOD_VOLUME_NORMAL)
					UH.blood_volume = max((UH.blood_volume - blood_price), 0)
					if(target.blood_volume >= BLOOD_VOLUME_NORMAL && !user_informed)
						to_chat(UH, span_info("They're at a healthy blood level, but I can keep going."))
						user_informed = TRUE
				else
					UH.visible_message(span_warning("Severs the bloodlink from [target]!"))
					bloodbeam.End()
					return TRUE
			else
				UH.visible_message(span_warning("Severs the bloodlink from [target]!"))
				bloodbeam.End()
				return TRUE
		bloodbeam.End()
		return TRUE
	return FALSE

#undef BASE_HEALING_PER_TICK
#undef MAX_BONUS_HEAL

/////////////////////////////////
// MIRACLE - SACRED ASCENDANCE //
/////////////////////////////////

/datum/action/cooldown/spell/miracle/bishop_pack
	name = "Sacred Ascendance"
	desc = "Allows you to select miracles out of packs Focus (1 T4) or Diversity (2 T3) from static list."
	fluff_desc = "They protect against the enroaching darkness, when He abandoned us we wept a thousand tears in His name. They liberated us from the sorrow, gave us a path to absolution denied to us - for this we will be grateful and obedient to Their machinations."
	button_icon_state = "spellpack"
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
	var/list/miracle_bishop_t4 = list(
		/obj/effect/proc_holder/spell/invoked/abyssal_infusion::name		= /obj/effect/proc_holder/spell/invoked/abyssal_infusion,
		/obj/effect/proc_holder/spell/invoked/immolation::name				= /obj/effect/proc_holder/spell/invoked/immolation,
		/obj/effect/proc_holder/spell/self/howl/call_of_the_moon::name		= /obj/effect/proc_holder/spell/self/howl/call_of_the_moon,
		/obj/effect/proc_holder/spell/invoked/pomegranate::name				= /obj/effect/proc_holder/spell/invoked/pomegranate,
		//Malum lacks one for the time being.
		/obj/effect/proc_holder/spell/invoked/deaths_door::name				= /obj/effect/proc_holder/spell/invoked/deaths_door,
		//Noc gets one after the rework passes.
		//Pestra has actually nothing, son 😢
		//Ravox will get something else.
		/datum/action/cooldown/spell/undivided/undivided_battlecry::name	= /datum/action/cooldown/spell/undivided/undivided_battlecry,
		/obj/effect/proc_holder/spell/invoked/abscond::name					= /obj/effect/proc_holder/spell/invoked/abscond
	)
	var/list/miracle_bishop_t3 = list(
		/obj/effect/proc_holder/spell/invoked/call_dreamfiend::name			= /obj/effect/proc_holder/spell/invoked/call_dreamfiend,
		/datum/action/cooldown/spell/astrata/firecloak::name				= /datum/action/cooldown/spell/astrata/firecloak,
		/obj/effect/proc_holder/spell/invoked/eoracurse::name				= /obj/effect/proc_holder/spell/invoked/eoracurse,
		/datum/action/cooldown/spell/malum_blessing::name					= /datum/action/cooldown/spell/malum_blessing,
		/obj/effect/proc_holder/spell/invoked/bless_cross::name				= /obj/effect/proc_holder/spell/invoked/bless_cross,
		/datum/action/cooldown/spell/noc/moonscorch::name					= /datum/action/cooldown/spell/noc/moonscorch, //Not getting spellpack under any circumstance.
		//Pestra has actually nothing, son 😢
		/datum/action/cooldown/spell/ravox/battlecry::name					= /datum/action/cooldown/spell/ravox/battlecry,
		/datum/action/cooldown/spell/undivided/gallow_humor::name			= /datum/action/cooldown/spell/undivided/gallow_humor,
		/obj/effect/proc_holder/spell/targeted/touch/parlor_trick::name		= /obj/effect/proc_holder/spell/targeted/touch/parlor_trick
	)

/datum/action/cooldown/spell/miracle/bishop_pack/cast(atom/cast_on)
	. = ..()

	if(choosing_bundle)
		return FALSE
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choosing_bundle = TRUE
		choice = alert(owner, "Which path did your studies lead you down?", "CHOOSE PATH", "Focus - T4", "Diversity - T3")
		chosen_bundle = choice
		choosing_bundle = FALSE
	switch(choice)
		if("Focus - T4")
			add_spells(owner, miracle_bishop_t4, choice_count = 1)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Diversity - T3")
			add_spells(owner, miracle_bishop_t3, choice_count = 2)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/miracle/bishop_pack/proc/add_spells(mob/owner, list/spells, choice_count = 1, grant_all = FALSE)
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
