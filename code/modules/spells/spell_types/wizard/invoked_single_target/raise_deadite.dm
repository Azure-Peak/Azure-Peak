/obj/effect/proc_holder/spell/invoked/raise_deadite
	name = "Raise Deadite"
	desc = "Infuse the target with quick acting Rot, raising them as a deadite. They will not be friendly to you."
	cost = 3
	xp_gain = TRUE
	releasedrain = 60
	chargedrain = 1
	chargetime = 60
	recharge_time = 30 SECONDS
	warnie = "spellwarning"
	school = "transmutation"
	overlay_state = "raisedead"
	no_early_release = TRUE
	movement_interrupt = FALSE
	spell_tier = 2
	invocations = list("Vivere Putrescere!")
	invocation_type = "shout"
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/raise_deadite/cast(list/targets, mob/user)
	. = ..()
	for(var/mob/living/carbon/human/M in targets)
		if(!HAS_TRAIT(M, TRAIT_ZOMBIE_IMMUNE) && ishuman(M) && M.mind)
			if (M.stat < DEAD && !M.InCritical())
				to_chat(user, span_notice("They aren't dead enough yet!"))
				revert_cast()
			else
				playsound(get_turf(M), 'sound/magic/magnet.ogg', 80, TRUE, soundping = TRUE)
				user.visible_message("[user] mutters an incantation and [M] twitches with unnatural life!")
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
		else
			to_chat(user, span_notice("They can not be risen!"))
			revert_cast()

	return
