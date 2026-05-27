// Phase Roll - brief phasing roll inspired by the dagger special, albeit with some tweaks to make it super obvious.
/obj/effect/proc_holder/spell/self/vheslyn_phase_roll
	name = "Phase Roll"
	desc = "Invoke Daemonic void energies to phase through flesh and steel alyke."
	action_icon = 'icons/mob/actions/vheslynspells.dmi'
	overlay_icon = 'icons/mob/actions/vheslynspells.dmi'

	background_icon = 'icons/mob/actions/vheslynspells.dmi'
	button_icon = 'icons/mob/actions/vheslynspells.dmi'
	overlay_state = "phaseroll"
	recharge_time = 30 SECONDS
	invocations = list("UN'MAKAR'SAR'IN!", "LE'SELIA WRL'LD!", "I'RISIA TAK'ATI' HELL!") //Unmake my flesh, let me slip the world, I'll take you to hell - gibberish-ified
	invocation_type = "shout"
	sound = pick('sound/magic/diminish1.ogg', 'sound/magic/diminish2.ogg', 'sound/magic/diminish3.ogg', 'sound/magic/diminish4.ogg')
	releasedrain = 10 //Light cost but its falloff opens you to a free hit through parries.
	miracle = FALSE
	antimagic_allowed = FALSE
	range = 0

/obj/effect/proc_holder/spell/self/vheslyn_phase_roll/cast(list/targets, mob/user)
	. = ..()
	if(!isliving(user))
		revert_cast()
		return FALSE

	var/mob/living/living_user = user
	living_user.apply_status_effect(/datum/status_effect/buff/vheslyn_phase_roll)
	return TRUE
