/datum/action/cooldown/spell/enlarge
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Enlarge Person"
	desc = "For a time, enlarges your target to a giant hulking version of themselves capable of bashing into doors. Does not work on folk who are already large."
	fluff_desc = "Despite its lack of practical combat utility, the spell of Enlarge is surprisingly popular and over 70% of male mages are known to be able to recite its incantation rapidly even if it is not prepared for the dae, according to a survey of the Grenzelhoftian Celestial War Academy's student body."
	button_icon_state = "enlarge"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Dilatare!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	charge_then_click = TRUE
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/enlarge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/carbon/target = cast_on
	if(HAS_TRAIT(target, TRAIT_BIGGUY))
		to_chat(H, span_warning("They're too big to enlarge!"))
		return FALSE

	ADD_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
	target.transform = target.transform.Scale(1.25, 1.25)
	target.transform = target.transform.Translate(0, (0.25 * 16))
	target.update_transform()
	to_chat(target, span_warning("I feel taller than usual, and like I could run through a door!"))
	target.visible_message("[target]'s body grows in size!")
	addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 60 SECONDS)
	return TRUE

/datum/action/cooldown/spell/enlarge/proc/remove_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_BIGGUY, MAGIC_TRAIT)
	target.transform = target.transform.Translate(0, -(0.25 * 16))
	target.transform = target.transform.Scale(1/1.25, 1/1.25)
	target.update_transform()
	to_chat(target, span_warning("I feel smaller all of a sudden."))
	target.visible_message("[target]'s body shrinks quickly!")
