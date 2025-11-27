//pseudo ranged or melee ability, invocation on mmb


/obj/effect/proc_holder/spell/invoked
	name = "invoked spell"
	range = 7
	selection_type = "range"
	no_early_release = TRUE
	recharge_time = 30
	charge_type = "recharge"
	invocation_type = "shout"
	var/active_sound
	var/entropy = FALSE //Use for bad spells

/obj/effect/proc_holder/spell/update_icon()
	if(!action)
		return
	action.button_icon_state = "[base_icon_state][active]"
	if(overlay_state)
		action.overlay_state = overlay_state
	action.name = name
	action.UpdateButtonIcon()

/obj/effect/proc_holder/spell/invoked/Click()
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!can_cast(user))
		start_recharge()
		deactivate(user)
		return
	if(active)
		deactivate(user)
	else
		if(active_sound)
			user.playsound_local(user,active_sound,100,vary = FALSE)
		active = TRUE
		add_ranged_ability(user, null, TRUE)
		on_activation(user)
	update_icon()
	if(entropy)
		entropyadd(user)
	start_recharge()

/obj/effect/proc_holder/spell/invoked/deactivate(mob/living/user) //Deactivates the currently active spell (icon click)
	..()
	active = FALSE
	remove_ranged_ability(null)
	on_deactivation(user)

/obj/effect/proc_holder/spell/invoked/proc/on_activation(mob/user)
	return

/obj/effect/proc_holder/spell/invoked/proc/on_deactivation(mob/user)
	return

/obj/effect/proc_holder/spell/invoked/InterceptClickOn(mob/living/caller, params, atom/target) 
	. = ..()
	if(.)
		return FALSE
	if(!can_cast(caller) || !cast_check(FALSE, ranged_ability_user))
		return FALSE
	var/client/client = caller.client
	var/percentage_progress = client?.chargedprog
	var/charge_progress = client?.progress // This is in seconds, same unit as chargetime
	var/goal = src.get_chargetime() //if we have no chargetime then we can freely cast (and no early release flag was not set)
	if(src.no_early_release) //This is to stop half-channeled spells from casting as the repeated-casts somehow bypass into this function.
		if(percentage_progress < 100 && charge_progress < goal)//Conditions for failure: a) not 100% progress, b) charge progress less than goal
			to_chat(usr, span_warning("[src.name] was not finished charging! It fizzles."))
			src.revert_cast()
			return FALSE
	if(perform(list(target), TRUE, user = ranged_ability_user))
		return TRUE

/obj/effect/proc_holder/spell/invoked/projectile
	var/projectile_type = /obj/projectile/magic/teleport
	var/list/projectile_var_overrides = list()
	var/projectile_amount = 1	//Projectiles per cast.
	var/current_amount = 0	//How many projectiles left.
	var/projectiles_per_fire = 1		//Projectiles per fire. Probably not a good thing to use unless you override ready_projectile().
	gesture_required = TRUE // All projectiles are offensive and should be locked to not handcuff

/obj/effect/proc_holder/spell/invoked/projectile/proc/ready_projectile(obj/projectile/P, atom/target, mob/user, iteration)
	return

/obj/effect/proc_holder/spell/invoked/projectile/cast(list/targets, mob/living/user)
	. = ..()
	var/target = targets[1]
	var/turf/T = user.loc
	var/turf/U = get_step(user, user.dir) // Get the tile infront of the move, based on their direction
	if(!isturf(U) || !isturf(T))
		return FALSE
	fire_projectile(user, target)
	update_icon()
	start_recharge()
	if(entropy)
		entropyadd(user)
	return TRUE

/obj/effect/proc_holder/spell/invoked/projectile/proc/fire_projectile(mob/living/user, atom/target)
	current_amount--
	for(var/i in 1 to projectiles_per_fire)
		var/obj/projectile/P = new projectile_type(user.loc)
		if(istype(P, /obj/projectile/magic/bloodsteal))
			var/obj/projectile/magic/bloodsteal/B = P
			B.sender = user
		P.def_zone = user.zone_selected
		// Accuracy modification code, same as bow rebalance PR
		P.accuracy += (user.STAINT - 9) * 4
		P.bonus_accuracy += (user.STAINT - 8) * 3
		if(user.mind)
			P.bonus_accuracy += (user.get_skill_level(associated_skill) * 5) // +5% per level
		P.firer = user
		P.preparePixelProjectile(target, user)
		for(var/V in projectile_var_overrides)
			if(P.vars[V])
				P.vv_edit_var(V, projectile_var_overrides[V])
		ready_projectile(P, target, user, i)
		P.fire()
	return TRUE

/obj/effect/proc_holder/spell/invoked/proc/entropyadd(var/mob/living/carbon/human/user = usr)
	var/mob/living/carbon/human/U = user
	U.mind?.entropy++

	if(U.mind?.entropy == 1) //just warning text
		to_chat(U, span_bloody("Ah, [U.mind.current.real_name], i see your attempts.. Go on."))

	if(U.mind?.entropy <= 5 && U.mind?.entropy != 1) //little damage for any next casts
		to_chat(U, span_warning("bruises appear on my skin..."))
		U.adjustBruteLoss(10)
	if(U.mind?.entropy > 5)
		U.adjustBruteLoss(10)

	if(U.mind?.entropy == 10) //Permanent debuff. -1 CON, -1 LCK.
		to_chat(U, span_bloody("This power is given to you for your efforts. You're not giving up, are you?"))
		U.apply_status_effect(/datum/status_effect/debuff/lux_entropy)

	if(U.mind?.entropy >= 15) //little tox damage + 10 brute for any next casts
		U.adjustToxLoss(5)

	if(U.mind?.entropy == 19) //Notice for next cast!
		to_chat(U, span_notice("I feel like something will change next time..."))

	if(U.mind?.entropy == 20) //Undead biotype, silverweakness, 3 aryne spellpoint and damage+ slash on all body.
		to_chat(U, span_bloody("Greetings, [U.mind.current.real_name], it's been a long time... You deserve a little gift..."))
		U.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		if(!locate(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation) in U.mind?.spell_list)
			U.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		U.mind?.adjust_spellpoints(3)
		if (!HAS_TRAIT(U, TRAIT_ARCYNE_T1) && !HAS_TRAIT(U, TRAIT_ARCYNE_T2) && !HAS_TRAIT(U, TRAIT_ARCYNE_T3) && !HAS_TRAIT(U, TRAIT_ARCYNE_T4))
			ADD_TRAIT(user, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
		if (!HAS_TRAIT(U, TRAIT_SILVER_WEAK))
			ADD_TRAIT(user, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
		if (!(U.mob_biotypes & MOB_UNDEAD))
			U.visible_message(span_warning("The pallor of the grave descends across [U]'s skin in a wave of arcyne energy..."))
			U.mob_biotypes |= MOB_UNDEAD
		var/static/list/valid_limbs = list(
				BODY_ZONE_CHEST,
				BODY_ZONE_L_ARM,
				BODY_ZONE_R_ARM,
				BODY_ZONE_L_LEG,
				BODY_ZONE_R_LEG
			)
		var/list/obj/item/bodypart/possible_limbs = list()
		//for(var/i, 1 in 5)
		for(var/zone in valid_limbs)
			var/obj/item/bodypart/BP = U.get_bodypart(zone)
			if(BP)
				possible_limbs += BP

			if(possible_limbs.len)
				// Select random limb
				BP = pick(possible_limbs)
				BP.add_wound(/datum/wound/slash)
		U.adjustBruteLoss(50)

	if(U.mind?.entropy >= 25 && U.mind?.entropy < 30) //10 brute, 5 tox, and now 10 burn for any next casts.
		to_chat(U, span_warning("burns appear on my skin..."))
		U.adjustFireLoss(10)
	if(U.mind?.entropy >= 30)
		U.adjustFireLoss(10)

	if(U.mind?.entropy == 30) //Remove your lux. One Hour. -1 STR, -1 WIL, -1 CON, -1 SPE, -1 LCK.
		to_chat(U, span_bloody("You're making great progress, [U.mind.current.real_name]! Do you like what you see? Since that's the case, I'll take something from you..."))
		U.apply_status_effect(/datum/status_effect/debuff/ritualdefiled)
		U.playsound_local(U, 'sound/misc/astratascream.ogg', 80, 1)

	if(U.mind?.entropy == 35) //3 spellpoints. T2 arcyne.
		to_chat(U, span_notice("I feel like I'm getting stronger, but something's not right..."))
		U.mind?.adjust_spellpoints(3)
		if (!HAS_TRAIT(U, TRAIT_ARCYNE_T2) && !HAS_TRAIT(U, TRAIT_ARCYNE_T3) && !HAS_TRAIT(U, TRAIT_ARCYNE_T4))
			REMOVE_TRAIT(user, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_ARCYNE_T2, TRAIT_GENERIC)

	if(U.mind?.entropy == 40) //Rituos ability, nopain, Critical weakness.
		to_chat(U, span_bloody("You've achieved so much, [U.mind.current.real_name]. My blessing is worthy of your soul. But you do know that you have to pay for all this, right?"))
		if(!locate(/obj/effect/proc_holder/spell/invoked/rituos) in U.mind?.spell_list)
			U.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/rituos)
		if (!HAS_TRAIT(U, TRAIT_CRITICAL_RESISTANCE))
			REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
		if (!HAS_TRAIT(U, TRAIT_CRITICAL_WEAKNESS))
			ADD_TRAIT(user, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
		if (!HAS_TRAIT(U, TRAIT_NOPAIN))
			ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)

	if(U.mind?.entropy == 45) //remove head in rituos blacklist. Allows you full skeletonized your body.
		to_chat(U, span_notice("It seems to me that now I can continue my rise!"))
		U.mind?.RemoveSpell(new /obj/effect/proc_holder/spell/invoked/rituos)
		U.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/rituos/entropy)
		U.adjustOxyLoss(50)
		U.adjustToxLoss(20)

	if(U.mind?.entropy >= 50) //little heal. Soft reduce entropy damage. You a very bad ma'an.
		U.apply_status_effect(/datum/status_effect/buff/healing/zizoblood)
		U.adjustBruteLoss(-5)
		U.adjustFireLoss(-5)
		U.adjustToxLoss(-2)
