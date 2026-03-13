/obj/effect/proc_holder/spell/targeted/transfix_neu
	name = "Transfix"
	overlay_state = "transfix"

	associated_skill = /datum/skill/magic/blood

	range = 7
	chargetime = 0
	releasedrain = 100
	recharge_time = 15 SECONDS

	/// Ignore crosses and give a different message
	var/powerful = FALSE
	/// Willpower divisor from INT
	var/int_divisor = 3.3
	/// Faces of blood die
	var/blood_dice = 9
	/// Faces of will die
	var/will_dice = 6

	var/transfix_msg

/obj/effect/proc_holder/spell/targeted/transfix_neu/choose_targets(mob/user = usr)
	var/list/selection = list()
	for(var/mob/living/carbon/human/target in get_hearers_in_view(6, usr))
		if(!target.mind || target.stat != CONSCIOUS)
			continue
		if(target.mind.has_antag_datum(/datum/antagonist/vampire))
			continue
		selection += target

	if(!selection.len)
		revert_cast(user)
		return

	perform(selection, user=user)

/obj/effect/proc_holder/spell/targeted/transfix_neu/cast(list/targets, mob/user = usr)
	if(!length(targets))
		to_chat(user, span_warning("There are no mortals nearby..."))
		revert_cast(user)
		return

	transfix_msg = input(user, "Soothe them. Dominate them. Speak and they will succumb.", "Transfix") as message|null
	if(!transfix_msg || length(transfix_msg) < 10)
		to_chat(user, span_userdanger("This not enough to ensnare their mind!"))
		revert_cast()
		return

	if(!powerful)
		var/mob/selected = input(user, "Ensnare the mind of which mortal?", "Transfix") as null|anything in targets
		if(QDELETED(src) || QDELETED(user) || QDELETED(selected))
			revert_cast(user)
			return
		targets = list(selected)

	var/bloodskill = user.get_skill_level(/datum/skill/magic/blood)
	var/bloodroll = roll(bloodskill, blood_dice)
	user.say(transfix_msg, forced = "spell ([name])")
	if(powerful)
		user.visible_message("<font color='red'>[user]'s eyes glow a ghastly red as they project their will outwards!</font>")

	for(var/mob/living/carbon/human/target as anything in targets)
		var/current_will_dice = will_dice
		if(target.cmode)
			current_will_dice += 1

		var/willpower = round(target.STAINT / int_divisor, 1)
		var/willroll = roll(willpower, current_will_dice)

		// If the vampire failed badly
		var/knowledgable = (willroll - bloodroll) >= 3

		if(!powerful)
			for(var/obj/item/clothing/neck/roguetown/psicross/silver/I in target.contents) //Subpath fix.
				var/extra = "!"
				if(knowledgable)
					extra = ", I sense the caster was [user]!"
				to_chat(target, "<font color='white'>The silver psycross shines and protect me from unholy magic[extra]</font>")
				to_chat(user, span_userdanger("[target] has my BANE! It causes me to fail to ensnare their mind!"))
				break

		if(bloodroll >= willroll)
			target.drowsyness = min(target.drowsyness + 50, 150)
			switch(target.drowsyness)
				if(0 to 50)
					to_chat(target, "You feel like a curtain is coming over your mind.")
					to_chat(user, "The mind of [target] gives way slightly.")
					target.Slowdown(20)
				if(51 to 90)
					to_chat(target, "Your eyelids force themselves shut as you feel intense lethargy.")
					to_chat(user, "[target] will not be able to resist much more.")
					target.eyesclosed = TRUE
					target.become_blind("eyelids")
					if(target.hud_used)
						for(var/atom/movable/screen/eye_intent/eyet in target.hud_used.static_inventory)
							eyet.update_icon(target)
					target.Slowdown(50)
				if(91 to INFINITY)
					to_chat(target, span_userdanger("You can't take it anymore. Your legs give out as you fall into the dreamworld."))
					to_chat(user, "[target] is mine now.")
					target.eyesclosed = TRUE
					target.become_blind("eyelids")
					if(target.hud_used)
						for(var/atom/movable/screen/eye_intent/eyet in target.hud_used.static_inventory)
							eyet.update_icon(target)
					target.Slowdown(50)
					addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living, Sleeping), 1 MINUTES), 5 SECONDS)
			continue

		if(!powerful)
			var/holypower = target.get_skill_level(/datum/skill/magic/holy)
			var/magicpower = round(target.get_skill_level(/datum/skill/magic/arcane) * 0.6, 1)
			var/roll = roll(1 + holypower + magicpower, 5)
			if(roll > bloodroll)
				to_chat(target, "I feel like the unholy magic came from [user]. I should use my magic or miracles on them.")

		to_chat(user, span_userdanger("I fail to ensnare the mind of [target]!"))
		to_chat(target, span_userdanger("Something is wrong in this place."))
