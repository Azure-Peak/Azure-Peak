/datum/action/cooldown/spell/raise_deadite
	name = "Raise Deadite"
	desc = "Infuse the target with quick acting Rot, raising them as a deadite. They will not be friendly to you."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "raisedead"
	sound = 'sound/magic/whiteflame.ogg'

	click_to_activate = TRUE
	cast_range = 1

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_SUMMON

	invocations = list("Vivere Putrescere!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 6 SECONDS
	charge_drain = 1
	charge_slowdown = 2
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	point_cost = 3
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	zizo_spell = TRUE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/raise_deadite/cast(atom/cast_on)
	. = ..()
	if(!ishuman(cast_on))
		to_chat(owner, span_notice("They can not be risen!"))
		reset_spell_cooldown()
		return FALSE

	var/mob/living/carbon/human/M = cast_on
	if(!HAS_TRAIT(M, TRAIT_ZOMBIE_IMMUNE) && M.mind)
		if(M.stat < DEAD && !M.InCritical())
			to_chat(owner, span_notice("They aren't dead enough yet!"))
			reset_spell_cooldown()
			return FALSE
		else
			playsound(get_turf(M), 'sound/magic/magnet.ogg', 80, TRUE, soundping = TRUE)
			owner.visible_message("[owner] mutters an incantation and [M] twitches with unnatural life!")
			M.blood_volume = BLOOD_VOLUME_NORMAL
			M.setOxyLoss(0, updating_health = FALSE, forced = TRUE)
			M.setToxLoss(0, updating_health = FALSE, forced = TRUE)
			M.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
			M.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
			M.heal_wounds(INFINITY)
			M.zombie_check_can_convert()
			var/datum/antagonist/zombie/Z = M.mind.has_antag_datum(/datum/antagonist/zombie)
			if(Z)
				Z.wake_zombie(TRUE)
			M.emote("scream")
			return TRUE
	else
		to_chat(owner, span_notice("They can not be risen!"))
		reset_spell_cooldown()
		return FALSE
