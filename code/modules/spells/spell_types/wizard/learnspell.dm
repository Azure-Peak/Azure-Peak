/datum/action/cooldown/spell/learnspell
	name = "Attempt to learn a new spell"
	desc = "Weave a new spell"
	button_icon_state = "book1"

	click_to_activate = FALSE
	self_cast_possible = TRUE

	charge_required = FALSE
	cooldown_time = 1 SECONDS

	primary_resource_type = SPELL_COST_NONE

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	spell_impact_intensity = SPELL_IMPACT_NONE

/datum/action/cooldown/spell/learnspell/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user) || !user.mind)
		return FALSE
	if(!user.mind.has_remaining_aspect_picks())
		return FALSE
	var/datum/aspect_picker/picker = new(user, TRUE, user.mind.mage_aspect_config)
	picker.ui_interact(user)
	return TRUE
