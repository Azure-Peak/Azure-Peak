/datum/action/cooldown/spell/vheslyn
	background_icon = 'icons/mob/actions/vheslynspells.dmi'
	button_icon = 'icons/mob/actions/vheslynspells.dmi'
	spell_color = GLOW_COLOR_GRAGGAR

	ignore_armor_penalty = TRUE
	attunement_school = null

	primary_resource_type = SPELL_COST_STAMINA

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/arcane

// Phase Roll - brief phasing roll inspired by the dagger special, albeit with some tweaks to make it super obvious.
/obj/effect/proc_holder/spell/self/vheslyn/vheslyn_phase_roll
	name = "Phase Roll"
	desc = "Invoke Daemonic void energies to phase through flesh and steel alyke."
	action_icon = 'icons/mob/actions/vheslynspells.dmi'
	overlay_icon = 'icons/mob/actions/vheslynspells.dmi'
	overlay_state = "phaseroll"
	recharge_time = 30 SECONDS
	clothes_req = FALSE
	invocations = list("UN'MAKAR'SAR'IN!", "LE'SELIA WRL'LD!", "I'RISIA TAK'ATI' HELL!") //Unmake my flesh, let me slip the world, I'll take you to hell - gibberish-ified
	invocation_type = "shout"
	sound = 'sound/magic/diminish1.ogg'
	releasedrain = 10 //Light cost but its falloff opens you to a free hit through parries.
	range = 0

/obj/effect/proc_holder/spell/self/vheslyn/vheslyn_phase_roll/cast(list/targets, mob/user)
	. = ..()
	if(!isliving(user))
		revert_cast()
		return FALSE

	var/mob/living/living_user = user
	living_user.apply_status_effect(/datum/status_effect/buff/vheslyn_phase_roll)
	return TRUE
