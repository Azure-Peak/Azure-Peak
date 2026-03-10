
/obj/effect/proc_holder/spell/invoked/tame_undead
	name = "Tame Undead"
	desc = "Oftentymes, husks and shamblers walk aimlessly - uncertain of their future. They need not look further, any longer. \
	Requires the target to be within four tiles. Works on undead animals, too."
	overlay_state = "raiseskele"
	range = 4
	warnie = "sydwarning"
	recharge_time = 60 SECONDS
	releasedrain = 40
	chargetime = 5 SECONDS
	charging_slowdown = 1
	gesture_required = TRUE
	chargedloop = /datum/looping_sound/invokegen
	no_early_release = TRUE

/obj/effect/proc_holder/spell/invoked/tame_undead/cast(list/targets, mob/living/user)
	..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]

	if(!(target.mob_biotypes & MOB_UNDEAD))
		to_chat(user, span_warning("[target]'s soul is not Hers, yet. I cannot do anything."))
		revert_cast()
		return FALSE
	
	if(target.mind)
		to_chat(user, span_warning("[target]'s mind resists your goadings. It will not do."))
		revert_cast()
		return FALSE

	target.faction |= list("cabal", "[user.mind.current.real_name]_faction")
	target.visible_message(span_notice("[target] turns its head to pay heed to [user]!"))
	if(!target.ai_controller)
		target.ai_controller = /datum/ai_controller/undead
		target.InitializeAIController()
		if(issimple(target))
			var/mob/living/simple_animal/simple_target = target
			simple_target.tamed()

	return TRUE
