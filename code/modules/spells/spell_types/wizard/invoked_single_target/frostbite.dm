// Spell is disabled because of snap freeze + frost bolt existing at the same time
/obj/effect/proc_holder/spell/invoked/frostbite
	name = "Frostbite"
	desc = "Freeze your enemy with an icy blast that does low damage, but reduces the target's Speed for a considerable length of time."
	overlay_state = "null"
	releasedrain = 50
	chargetime = 8
	recharge_time = 25 SECONDS
	range = 7
	warnie = "spellwarning"
	movement_interrupt = FALSE
	no_early_release = FALSE
	chargedloop = null
	sound = 'sound/magic/whiteflame.ogg'
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = TRUE
	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	invocations = list("Congelationis!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_LOW
	cost = 3
	gesture_required = TRUE // Offensive spell
	human_req = TRUE // Combat spell

/obj/effect/proc_holder/spell/invoked/frostbite/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		target.apply_status_effect(/datum/status_effect/buff/frostbite/) //apply debuff
		target.adjustFireLoss(12) //damage
		target.adjustBruteLoss(12)
