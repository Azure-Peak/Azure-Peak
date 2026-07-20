/datum/action/cooldown/spell/ink_presence
	name = "Depth Stride"
	desc = "Start leaving paint trails as you move. You and those with paint affinity are sped up and regain a smidge of nutrition for touching trails, everyone else touching the trail is slowed."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#00051f"

	primary_resource_type = SPELLCOST_CONJURE
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list(
		"Shogg sp'gai! Swift steps from beyond!",
		"N'gai, n'gha'ghaa, fhtagn!",
		"Y'gathil mor, speed my step!",
		"K'rnul, the painter bleeds!"
	)
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 0.1 SECONDS
	cooldown_time = 22 SECONDS
	devotion_cost = 25
	associated_skill = /datum/skill/magic/holy

	var/active_duration = 7 SECONDS

/datum/action/cooldown/spell/ink_presence/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/generate_ink_trail)
	addtimer(CALLBACK(src, .proc/stop_ink_presence, user), active_duration)
	return TRUE

/datum/action/cooldown/spell/ink_presence/proc/generate_ink_trail(mob/living/user, turf/old_turf, dir)
	SIGNAL_HANDLER
	if(!user || user.stat != CONSCIOUS)
		return
	var/turf/current_turf = get_turf(user)
	if(!current_turf || !isopenturf(current_turf))
		return

	var/obj/effect/ink_trail/existing_trail = locate(/obj/effect/ink_trail) in current_turf

	if(existing_trail)
		existing_trail.refresh_lifetime()
	else
		new /obj/effect/ink_trail(current_turf, user)
		user.apply_status_effect(/datum/status_effect/buff/ink_surge)

/datum/action/cooldown/spell/ink_presence/proc/stop_ink_presence(mob/living/user)
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)

/datum/action/cooldown/spell/paint_blessing
	name = "Paint Attunement"
	desc = "Conduct a lengthy attunement mracle to bind an ally to your paint trails. Targets cannot move during the ritual. Casting without a direct target allows you to manage or revoke existing blessings."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint_bless"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#5c0099"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list(
		"Tha'lass-vax, maro det'us!",
		"Vrek'hen-dyll, khoro!",
		"zul-morn, dra'yne the light!"
	)
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 2 SECONDS
	cooldown_time = 10 SECONDS
	devotion_cost = 30
	associated_skill = /datum/skill/magic/holy

	// Soft references (weakrefs) mapping [Target Ref String] -> [Weakref to Target]
	var/list/beneficiaries = list()

/datum/action/cooldown/spell/paint_blessing/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	for(var/ref_str in beneficiaries)
		var/datum/weakref/W = beneficiaries[ref_str]
		var/mob/living/L = W?.resolve()
		if(!L || QDELETED(L) || L.stat == DEAD)
			beneficiaries -= ref_str

	var/mob/living/target = cast_on
	if(!istype(target) || target == user)
		if(!length(beneficiaries))
			to_chat(user, span_warning("You are not currently sustaining any paint affinity blessings."))
			return FALSE

		var/list/revoke_options = list()
		for(var/ref_str in beneficiaries)
			var/datum/weakref/W = beneficiaries[ref_str]
			var/mob/living/L = W.resolve()
			if(L && !(L.patron.type == /datum/patron/divine/abyssor))
				revoke_options[L.name] = ref_str
			else if(L)
				revoke_options[L.real_name] = ref_str

		var/chosen_name = tgui_input_list(user, "Select a blessing to revoke:", "Manage Paint Blessings", revoke_options)
		if(!chosen_name || !user || QDELETED(src))
			return FALSE

		var/target_ref_str = revoke_options[chosen_name]
		var/datum/weakref/target_W = beneficiaries[target_ref_str]
		var/mob/living/revoked_mob = target_W?.resolve()

		beneficiaries -= target_ref_str
		if(revoked_mob)
			REMOVE_TRAIT(revoked_mob, TRAIT_INK_AFFINITY, TRAIT_MIRACLE)
			to_chat(revoked_mob, span_userdanger("Your paint affinity has been dissolved by your patron!"))
		user.visible_message(span_warning("[user] severs the canvas binding [chosen_name]!"))
		return TRUE

	if(target.stat == DEAD)
		to_chat(user, span_warning("The dead cannot hold the pigment of Abyssor."))
		return FALSE
	if(HAS_TRAIT(target, TRAIT_INK_AFFINITY))
		to_chat(user, span_warning("[target] is already attuned to holy paints."))
		return FALSE

	var/max_beneficiaries = 1
	var/holy_skill = user.get_skill_level(/datum/skill/magic/holy)

	switch(holy_skill)
		if(3)
			max_beneficiaries = 2
		if(4, 5)
			max_beneficiaries = 3
		if(6)
			max_beneficiaries = 4
		else
			max_beneficiaries = 1

	if(length(beneficiaries) >= max_beneficiaries)
		to_chat(user, span_warning("Your current holy skill only allows you to sustain [max_beneficiaries] blessing\s at a time. Revoke an old one first."))
		return FALSE

	user.visible_message(span_notice("[user] begins painting beneath [target]'s feet!"))

	if(!do_after(user, 5 SECONDS, target = target))
		to_chat(user, span_warning("The attunement ritual was broken by movement!"))
		return FALSE

	if(QDELETED(target) || target.stat == DEAD || HAS_TRAIT(target, TRAIT_INK_AFFINITY))
		return FALSE

	var/display_name = target.name
	beneficiaries[REF(target)] = WEAKREF(target)
	ADD_TRAIT(target, TRAIT_INK_AFFINITY, TRAIT_MIRACLE)

	user.visible_message(span_nicegreen("[user] successfully completes the ritual! [display_name] is now attuned to holy paints."))
	to_chat(target, span_purple("<b>Your lux has been coated in sacred pigments. You can now walk safely through abyssal paints!</b>"))
	return TRUE

/datum/action/cooldown/spell/paint_blessing/Destroy()
	var/mob/living/user = owner
	for(var/ref_str in beneficiaries)
		var/datum/weakref/W = beneficiaries[ref_str]
		var/mob/living/L = W?.resolve()
		if(L && user)
			REMOVE_TRAIT(L, TRAIT_INK_AFFINITY, TRAIT_MIRACLE)
	beneficiaries.Cut()
	return ..()

/datum/action/cooldown/spell/umbral_viscosity
	name = "Umbral Coating"
	desc = "Infuse your active weapon with a heavy, abyssal paint. Strikes against mindless beasts deal devastating damage. Conscious targets take minimal damage but bleed paint trails. If cast with an empty hand, shapes the paint into a short-lived bow preloaded with a single paint arrow."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint_blade"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#03000a"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE

	invocations = list(
		"Tha'lass-vax, blacken the iron!",
		"Cri'morah, let the edges weep!",
		"kra'khen, coat this steel!"
	)
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 0.7 SECONDS
	cooldown_time = 60 SECONDS
	devotion_cost = 25
	associated_skill = /datum/skill/magic/holy

/datum/action/cooldown/spell/umbral_viscosity/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	var/obj/item/weapon = user.get_active_held_item()
	if(!weapon)
		var/obj/item/gun/ballistic/revolver/grenadelauncher/bow/short/paint/P = new(user.loc)
		if(user.put_in_active_hand(P))
			user.visible_message(span_purple("Shimmering, abyssal paint coalesces in [user]'s empty hand, forming a volatile bow!"))
			return TRUE
		else
			return FALSE

	if(!isitem(weapon))
		to_chat(user, span_warning("I must hold a valid weapon to coat it!"))
		return FALSE

	if(weapon.AddComponent(/datum/component/umbral_enchant, user))
		weapon.visible_message(span_purple("[weapon]'s aura turns purple, oozing thick droplets of paint."))
		return TRUE

	return FALSE

/datum/action/cooldown/spell/umbral_viscosity/single_use
	name = "Invoke Umbral Coating"
	desc = "Call upon your gifted umbral energy to coat your active weapon, or form a volatile bow if your hand is empty. This is a one-time use manifestation."
	cooldown_time = 1 HOURS

/datum/action/cooldown/spell/umbral_viscosity/single_use/cast(atom/cast_on)
	. = ..()
	if(.)
		var/mob/living/user = owner
		addtimer(CALLBACK(src, .proc/self_consume, user), 1)

/datum/action/cooldown/spell/umbral_viscosity/single_use/proc/self_consume(mob/living/L)
	if(L?.mind)
		L.mind.RemoveSpell(src)

/datum/action/cooldown/spell/transmute_ink
	name = "Purifying Wave"
	desc = "Purify nearby abyssal paint trails within your immediate surroundings, turning them into healing trails for the attuned. The more paint affected (up to 10), the longer the cooldown."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint_heal"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#125a00"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list(
		"Prash'ik, nar'n. Heal the faithful!",
		"Ya'shna vin'thu rasa. Fruits of the sea!",
		"Hu'maw, A'ferta'nu. Rejuvinate!"
	)
	invocation_type = INVOCATION_SHOUT
	// Hefty cooldown given we can heal a lot of people.
	// Up to double the cooldown with no int modifiers if a lot of puddles are made into healing stuff.
	cooldown_time = 28 SECONDS
	charge_time = 0.5 SECONDS
	associated_skill = /datum/skill/magic/holy
	var/transmute_range = 4
	var/temp_cooldown_multiplier = 1.0

/datum/action/cooldown/spell/transmute_ink/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	var/turf/center = get_turf(user)
	if(!center)
		return FALSE

	var/affected_count = 0
	for(var/obj/effect/ink_trail/trail in range(transmute_range, center))
		trail.buff_payload = /datum/status_effect/buff/umbral_recovery
		trail.debuff_payload = null
		trail.icon_state = "paint_gray"
		trail.color = "#b6e6b6"
		trail.consume_buff = TRUE
		trail.deny_buff = TRUE
		trail.refresh_lifetime(15 SECONDS)
		affected_count++

	if(affected_count > 0)
		to_chat(user, span_nicegreen("I have successfully converted [affected_count] puddles into healing paint!"))
		temp_cooldown_multiplier = clamp(1.0 + (affected_count * 0.08), 1.0, 2.0)
		return TRUE
	else
		to_chat(user, span_warning("There were no abyssal paint puddles nearby to transmute."))
		return FALSE

/datum/action/cooldown/spell/transmute_ink/get_adjusted_cooldown()
	. = ..()
	. *= temp_cooldown_multiplier
	temp_cooldown_multiplier = 1.0

/datum/action/cooldown/spell/recharge_pylon
	name = "Umbral Replenishment"
	desc = "Channel your devotion into a depleted pylon, restoring its current infusion reservoirs up to half capacity. Can only be performed once per unique infusion cycle."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint_infusion"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#330066"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list(
		"O'khor, remember the well!",
		"Thal'ass, feed the paints!",
		"Dra'yne back the void, fill the core!"
	)
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 1.5 SECONDS
	cooldown_time = 45 SECONDS
	devotion_cost = 100
	associated_skill = /datum/skill/magic/holy

/datum/action/cooldown/spell/recharge_pylon/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	var/obj/structure/dream_pylon/target = cast_on
	if(!istype(target))
		to_chat(user, span_warning("This miracle must target a painted pylon!"))
		return FALSE

	if(!target.can_recharge)
		to_chat(user, span_warning("[target]'s structure is saturated. It cannot accept any further replenishment until its core changes!"))
		return FALSE

	if(target.charge >= target.max_charge)
		to_chat(user, span_warning("[target] is already completely overflowing with paint energy!"))
		return FALSE

	var/replenish_amount = target.max_charge * 0.5
	replenish_amount = max(25, round(replenish_amount, 25))

	target.charge = min(target.max_charge, target.charge + replenish_amount)
	target.can_recharge = FALSE

	user.visible_message(span_purple("[user] raises their hands, coaxing streams of ink from the dream back into [target]'s core!"))
	target.update_pylon_appearance()
	return TRUE
