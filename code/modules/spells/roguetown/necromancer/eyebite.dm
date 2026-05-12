/datum/action/cooldown/spell/eyebite
	name = "Eyebite"
	desc = "Manipulate the shadows within a chosen target's eye into jagged, gnashing teeth. Temporarily blinds the chosen target, while moderately damaging them."
	button_icon = 'icons/mob/actions/actions_spells.dmi'
	button_icon_state = "blind"
	cast_range = 7
	sound = 'sound/items/beartrap.ogg'
	primary_resource_cost = 30
	primary_resource_type = SPELL_COST_STAMINA
	charge_required = TRUE
	charge_time = 15
	associated_skill = /datum/skill/magic/arcane
	cooldown_time = 15 SECONDS
	spell_requirements = SPELL_REQUIRES_SAME_Z
	self_cast_possible = FALSE
	zizo_spell = TRUE

/datum/action/cooldown/spell/eyebite/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/eyebite/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/target = cast_on
	target.visible_message(span_info("A loud crunching sound has come from [target]!"), span_userdanger("I feel arcane teeth biting into my eyes!"))
	target.adjustBruteLoss(30)
	target.blind_eyes(2)
	target.blur_eyes(10)
	return TRUE
