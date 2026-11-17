/datum/intent/unarmed/claw/mineral
	name = "mineral claw"
	blade_class = BCLASS_CHOP
	animname = ATTACK_EFFECT_CLAW
	damfactor = 1.5
	clickcd = CLICK_CD_QUICK
	animname = "chop"

/mob/living/carbon/human/do_attack_animation_at(atom/A, visual_effect_icon, wiggle = TRUE, datum/intent/used_intent)
	if(istype(used_intent, /datum/intent/unarmed/claw/mineral) || istype(used_intent, /datum/intent/unarmed/claw))
		visual_effect_icon = ATTACK_EFFECT_CLAW
	return ..()

/datum/action/cooldown/spell/mineral_claws
	name = "Mineral Claws"
	desc = "Painfully shed some minerals from your arms and form claws from your fingers. Using this again will make them crumble without causing further damages."
	button_icon_state = "claws"
	sound = null
	cooldown_time = 2 SECONDS
	spell_requirements = NONE
	antimagic_flags = NONE
	charge_required = FALSE
	click_to_activate = FALSE
	self_cast_possible = TRUE
	var/claw_intent = /datum/intent/unarmed/claw/mineral
	/// Brute damage dealt to each arm when the claws form.
	var/extend_damage = 15
	/// Whether the claws are currently out.
	var/claws_out = FALSE
	/// The intent the claws replaced, put back when they crumble.
	var/replaced_intent = null

/datum/action/cooldown/spell/mineral_claws/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/mob/living/carbon/human/user = owner
	if(claws_out)
		return // Always allow retracting.
	if(!user.cmode)
		to_chat(user, span_warning("I am not roused enough, I need more adrenaline pumping..."))
		return . | SPELL_CANCEL_CAST
	if(!user.get_bodypart(BODY_ZONE_L_ARM) && !user.get_bodypart(BODY_ZONE_R_ARM))
		to_chat(user, span_warning("You could say I'm quite... disarmed."))
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/mineral_claws/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(claws_out)
		retract_claws(user)
		user.emote("growl")
		user.visible_message(span_necrosis("[user] calms down, the claws become dust alongside their extra weight..."),
			span_necrosis("I calm down, my claws disintegrate and my body becomes more lithe..."))
		REMOVE_TRAIT(user, TRAIT_MINERALCLAWS, "mineral_claws")
		REMOVE_TRAIT(user, TRAIT_WEAPONLESS, "mineral_claws")
		REMOVE_TRAIT(user, TRAIT_NORUN, "mineral_claws")
		return
	extend_claws(user)
	user.emote("roar")
	user.visible_message(span_necrosis("[user] roars like a fell creature, heavy claws form from their fingers!"),
		span_necrosis("I roar, forming my digits into menacing, heavy claws!"))
	ADD_TRAIT(user, TRAIT_MINERALCLAWS, "mineral_claws")
	ADD_TRAIT(user, TRAIT_WEAPONLESS, "mineral_claws")
	ADD_TRAIT(user, TRAIT_NORUN, "mineral_claws")

/datum/action/cooldown/spell/mineral_claws/proc/extend_claws(mob/living/carbon/human/user)
	var/list/intents = user.base_intents.Copy()
	replaced_intent = null
	var/swapped = FALSE
	for(var/i in 1 to length(intents))
		if(ispath(intents[i], /datum/intent/unarmed/punch))
			replaced_intent = intents[i]
			intents[i] = claw_intent
			swapped = TRUE
			break
	if(!swapped)
		intents += claw_intent
	user.base_intents = intents
	user.update_a_intents()

	// Forming the claws hurts both arms.
	for(var/zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		var/obj/item/bodypart/arm = user.get_bodypart(zone)
		if(arm)
			user.apply_damage(extend_damage, BRUTE, arm)
	claws_out = TRUE

/datum/action/cooldown/spell/mineral_claws/proc/retract_claws(mob/living/carbon/human/user)
	var/list/intents = user.base_intents.Copy()
	var/claw_index = intents.Find(claw_intent)
	if(claw_index)
		if(replaced_intent)
			intents[claw_index] = replaced_intent
		else
			intents.Cut(claw_index, claw_index + 1)
	user.base_intents = intents
	user.update_a_intents()
	replaced_intent = null
	claws_out = FALSE

/// If the virtue is removed while claws are out, put the punch back.
/datum/action/cooldown/spell/mineral_claws/Remove(mob/living/remove_from)
	if(claws_out && ishuman(remove_from))
		retract_claws(remove_from)
	return ..()

/datum/action/cooldown/spell/natural_claws
	name = "Natural Claws"
	desc = "Unfurl your natural claws, turning your fingers into dangerous weapons. Use this again to hide them away."
	button_icon_state = "claws"
	sound = null
	cooldown_time = 2 SECONDS
	spell_requirements = NONE
	antimagic_flags = NONE
	charge_required = FALSE
	click_to_activate = FALSE
	self_cast_possible = TRUE
	var/claw_intent = /datum/intent/unarmed/claw
	/// Whether the claws are currently out.
	var/claws_out = FALSE
	/// The intent the claws replaced, put back when they are hidden.
	var/replaced_intent = null

/datum/action/cooldown/spell/natural_claws/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/mob/living/carbon/human/user = owner
	if(claws_out)
		return
	if(!user.cmode)
		to_chat(user, span_warning("I am not roused enough to unfurl my claws..."))
		return . | SPELL_CANCEL_CAST
	if(!user.get_bodypart(BODY_ZONE_L_ARM) && !user.get_bodypart(BODY_ZONE_R_ARM))
		to_chat(user, span_warning("You could say I'm quite... disarmed."))
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/natural_claws/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(claws_out)
		retract_claws(user)
		user.emote("growl")
		user.visible_message(span_red("[user] relaxes, hiding away their claws..."),
			span_red("I relax, hiding my claws away..."))
		REMOVE_TRAIT(user, TRAIT_NATURALCLAWS, "natural_claws")
		REMOVE_TRAIT(user, TRAIT_WEAPONLESS, "natural_claws")
		return
	extend_claws(user)
	user.emote("roar")
	user.visible_message(span_red("[user] unfurls their fists, revealing a set of dangerous natural weapons!"),
		span_red("I unfurl my claws, revealing my natural weapons!"))
	ADD_TRAIT(user, TRAIT_NATURALCLAWS, "natural_claws")
	ADD_TRAIT(user, TRAIT_WEAPONLESS, "natural_claws")

/datum/action/cooldown/spell/natural_claws/proc/extend_claws(mob/living/carbon/human/user)
	var/list/intents = user.base_intents.Copy()
	replaced_intent = null
	var/swapped = FALSE
	for(var/i in 1 to length(intents))
		if(ispath(intents[i], /datum/intent/unarmed/punch))
			replaced_intent = intents[i]
			intents[i] = claw_intent
			swapped = TRUE
			break
	if(!swapped)
		intents += claw_intent
	user.base_intents = intents
	user.update_a_intents()
	claws_out = TRUE

/datum/action/cooldown/spell/natural_claws/proc/retract_claws(mob/living/carbon/human/user)
	var/list/intents = user.base_intents.Copy()
	var/claw_index = intents.Find(claw_intent)
	if(claw_index)
		if(replaced_intent)
			intents[claw_index] = replaced_intent
		else
			intents.Cut(claw_index, claw_index + 1)
	user.base_intents = intents
	user.update_a_intents()
	replaced_intent = null
	claws_out = FALSE

/// If the virtue is removed while claws are out, put the punch back.
/datum/action/cooldown/spell/natural_claws/Remove(mob/living/remove_from)
	if(claws_out && ishuman(remove_from))
		retract_claws(remove_from)
	return ..()
