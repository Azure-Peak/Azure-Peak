/datum/action/cooldown/spell/convert_heretic
	name = "Convert to Ecclesiarchy"
	desc = "Initiate a lengthy ritual to convert a willing excommunicate, apostate, or cursed soul into your faith."
	fluff_desc = "In the end, this was always a matter of faith. Not all Ecclesiarchs are thieves, madmen, cannibals, or tyrants; they are simply those who learned too early that humanity must shape the future of this dying world. Divinity was never meant to remain outside mortal hands."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "convert_heretic"
	invocations = list("Close your eyes and open your mind, this world is decaying but you shall be its last hope.")
	invocation_type = INVOCATION_WHISPER
	sound = 'sound/magic/bless.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 100
	secondary_resource_type = SPELL_COST_DEVOTION
	secondary_resource_cost = 100
	cooldown_time = 20 MINUTES
	charge_required = TRUE
	charge_time = 10 SECONDS
	associated_skill = /datum/skill/magic/holy
	associated_stat = null
	self_cast_possible = FALSE

/datum/action/cooldown/spell/convert_heretic/arcyne
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 125
	invocations = list("Claude oculos, aperi mentem. Ex ruina spes surgi, mundus cadit, tu spes renova.")

/datum/action/cooldown/spell/convert_heretic/free
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 125
	invocations = list("Welcome to the righteous path. The future belongs to us.")
	
/datum/action/cooldown/spell/convert_heretic/is_valid_target(atom/cast_on)
	return ishuman(cast_on)

/datum/action/cooldown/spell/convert_heretic/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	var/mob/living/carbon/human/target = cast_on

	if(!HAS_TRAIT(user, TRAIT_HERESIARCH))
		to_chat(user, span_warning("You lack the knowledge for this ritual."))
		reset_spell_cooldown()
		return FALSE

	if(target.cmode)
		reset_spell_cooldown()
		return FALSE

	if(HAS_TRAIT(target, TRAIT_HERESIARCH))
		to_chat(user, span_warning("[target] is already serving the greater good."))
		reset_spell_cooldown()
		return FALSE

	if(alert(target, "[user.real_name] is trying to convert you to their patron, [user.patron.name]. Do you accept?", "Conversion Request", "Yes", "No") != "Yes")
		to_chat(user, span_warning("[target] refused your offer of conversion."))
		reset_spell_cooldown()
		return FALSE

	var/absolvable = FALSE
	if(HAS_TRAIT(target, TRAIT_EXCOMMUNICATED))
		absolvable = TRUE

	if(target.has_status_effect(/datum/status_effect/debuff/apostasy))
		target.remove_status_effect(/datum/status_effect/debuff/apostasy)
		absolvable = TRUE

	if(target.real_name in GLOB.apostasy_players)
		GLOB.apostasy_players -= target.real_name
		absolvable = TRUE
	if(target.real_name in GLOB.excommunicated_players)
		GLOB.excommunicated_players -= target.real_name
		absolvable = TRUE

	if(!absolvable)
		to_chat(user, span_warning("[target] doesn't bear the church's marks of shame!"))
		return FALSE

	target.remove_status_effect(/datum/status_effect/debuff/apostasy)
	target.remove_status_effect(/datum/status_effect/debuff/excomm)
	target.remove_stress(/datum/stressevent/apostasy)
	target.remove_stress(/datum/stressevent/excommunicated)

	for(var/datum/curse/C in target.curses)
		target.remove_curse(C)

	var/saved_level = CLERIC_T0
	var/saved_max_progression = CLERIC_T1
	var/saved_devotion_gain = CLERIC_REGEN_MINOR

	if(target.devotion)
		saved_level = target.devotion.level
		saved_devotion_gain = target.devotion.passive_devotion_gain
		saved_max_progression = target.devotion.max_progression

		if(target.patron != user.patron)
			for(var/datum/action/cooldown/spell/S in target.devotion.granted_spells)
				target.mind.RemoveSpell(S)

		target.devotion.Destroy()

	target.patron = new user.patron.type()
	to_chat(target, span_userdanger("Your soul now belongs to [user.patron.name]!"))

	var/datum/devotion/new_devotion = new /datum/devotion(target, target.patron)
	target.devotion = new_devotion
	new_devotion.grant_miracles(target, saved_level, saved_devotion_gain, saved_max_progression)

	ADD_TRAIT(target, TRAIT_HERESIARCH, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_EXCOMMUNICATED, TRAIT_GENERIC)
	ADD_TRAIT(target, TRAIT_ZURCH, TRAIT_GENERIC)
	to_chat(user, span_danger("You've converted [target.name] to [user.patron.name]!"))
	to_chat(target, span_danger("You feel ancient powers lifting divine burdens from your soul..."))

	return TRUE


