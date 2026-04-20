/obj/effect/proc_holder/spell/invoked/eyebite
	name = "Eyebite"
	desc = "Manipulate the shadows within a chosen target's eye into jagged, gnashing teeth. </br>Temporarily blinds the chosen target, while moderately damaging them."
	overlay_state = "raiseskele"
	releasedrain = 30
	chargetime = 15
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/items/beartrap.ogg'
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE // Offensive spell
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	miracle = FALSE
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/eyebite/cast(list/targets, mob/living/user)
	..()
	if(!isliving(targets[1]))
		return FALSE
	var/mob/living/carbon/target = targets[1]
	target.visible_message(span_info("A loud crunching sound has come from [target]!"), span_userdanger("I feel arcane teeth biting into my eyes!"))
	target.adjustBruteLoss(30)
	target.blind_eyes(2)
	target.blur_eyes(10)
	return TRUE
