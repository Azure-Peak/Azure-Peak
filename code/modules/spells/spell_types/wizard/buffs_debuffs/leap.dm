/obj/effect/proc_holder/spell/invoked/leap
	name = "Leap"
	desc = "You empower your target's legs to allow them to leap to great heights. This allows your target to jump up floor levels, however does not prevent the damage from falling down one."
	cost = 2
	releasedrain = SPELLCOST_UTILITY_BUFF
	chargedrain = 1
	chargetime = 1 SECONDS
	recharge_time = 2 MINUTES
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	gesture_required = TRUE // Mobility spell
	spell_tier = 2
	invocations = list("Saltus!")
	invocation_type = "whisper"
	hide_charge_effect = TRUE
	charging_slowdown = 3
	chargedloop = /datum/looping_sound/wind
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "rune5"
	range = 7

/obj/effect/proc_holder/spell/invoked/leap/cast(list/targets, mob/user = usr)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target,TRAIT_ZJUMP))
			to_chat(user, "<span class='warning'>They're already able to jump that high!</span>")
			revert_cast()
			return
		ADD_TRAIT(target, TRAIT_ZJUMP, MAGIC_TRAIT)
		to_chat(target, span_warning("My legs feel stronger! I feel like I can jump up high!"))
		addtimer(CALLBACK(src, PROC_REF(remove_buff), target), wait = 20 SECONDS)
		return TRUE
	

/obj/effect/proc_holder/spell/invoked/leap/proc/remove_buff(mob/living/carbon/target)
	REMOVE_TRAIT(target, TRAIT_ZJUMP, MAGIC_TRAIT)
	to_chat(target, span_warning("My legs feel remarkably weaker."))
	target.Immobilize(5)
