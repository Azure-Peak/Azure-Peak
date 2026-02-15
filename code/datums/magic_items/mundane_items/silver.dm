/datum/magic_item/mundane/silver
	name = "Silver"
	description = "It is made of silver, shiny and pure."
	var/last_used

/datum/magic_item/mundane/silver/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(world.time < src.last_used + 100)
		return
	. = ..()
	if(ishuman(target))
		var/mob/living/H = target
		if(HAS_TRAIT(H, TRAIT_SILVER_WEAK) && !H.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
			H.visible_message("<font color='white'>The silver sunders [target]!</font>")
			to_chat(H, span_userdanger("Silver rebukes my presence! My vitae smolders, and my powers wane!"))
			H.adjust_fire_stacks(2, /datum/status_effect/fire_handler/fire_stacks/sunder)

/datum/magic_item/mundane/silver/on_equip(obj/item/i, mob/living/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_SILVER_WEAK) && !user.has_status_effect(STATUS_EFFECT_ANTIMAGIC))
		var/datum/antagonist/vampire/V_lord = user.mind?.has_antag_datum(/datum/antagonist/vampire)
		if(V_lord.generation >= GENERATION_METHUSELAH)
			return

		to_chat(user, span_userdanger("I can't pick up the silver, it is my BANE!"))
		user.Knockdown(10)
		user.Paralyze(10)
		user.adjustFireLoss(25)
		user.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder)

/datum/magic_item/mundane/silver/on_pickup(var/obj/item/i, var/mob/living/user)
	var/mob/living/carbon/human/H = user
	if(H.mind)
		var/datum/antagonist/vampire/V_lord = H.mind.has_antag_datum(/datum/antagonist/vampire)
		var/datum/antagonist/werewolf/W = H.mind.has_antag_datum(/datum/antagonist/werewolf/)
		if(ishuman(H))
			if(V_lord.generation < GENERATION_METHUSELAH)
				to_chat(H, span_userdanger("I can't pick up the silver, it is my BANE!"))
				H.Knockdown(10)
				H.Paralyze(10)
				H.adjustFireLoss(25)
				H.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder)
				H.ignite_mob()
			if(W && W.transformed == TRUE)
				to_chat(H, span_userdanger("I can't pick up the silver, it is my BANE!"))
				H.Knockdown(10)
				H.Paralyze(10)
				H.adjustFireLoss(25)
				H.adjust_fire_stacks(3, /datum/status_effect/fire_handler/fire_stacks/sunder)
				H.ignite_mob()
