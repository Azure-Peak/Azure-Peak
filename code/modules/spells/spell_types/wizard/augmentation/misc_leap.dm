// Leap - empowers a target's legs to jump up floor levels for a short time.
/datum/action/cooldown/spell/leap
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Leap"
	desc = "Empower a target's legs to allow them to leap to great heights for 20 seconds. Does not prevent fall damage."
	button_icon_state = "leap"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Saltus!")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	charge_then_click = TRUE
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/leap/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/carbon/target = cast_on

	if(HAS_TRAIT(target, TRAIT_ZJUMP))
		to_chat(H, span_warning("They're already able to jump that high!"))
		return FALSE

	ADD_TRAIT(target, TRAIT_ZJUMP, MAGIC_TRAIT)
	to_chat(target, span_warning("My legs feel stronger! I feel like I can jump up high!"))
	addtimer(CALLBACK(src, PROC_REF(remove_buff), target), 20 SECONDS)
	return TRUE

/datum/action/cooldown/spell/leap/proc/remove_buff(mob/living/carbon/target)
	if(QDELETED(target))
		return
	REMOVE_TRAIT(target, TRAIT_ZJUMP, MAGIC_TRAIT)
	to_chat(target, span_warning("My legs feel remarkably weaker."))
	target.Immobilize(5)
