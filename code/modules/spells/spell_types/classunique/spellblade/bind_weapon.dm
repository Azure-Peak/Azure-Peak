/obj/effect/proc_holder/spell/self/bind_weapon
	name = "Bind Weapon"
	desc = "Bind your held weapon as an arcyne conduit. Successful strikes with bound weapons build arcyne momentum, fueling your abilities. \
		It can also be recalled to your hand from anywhere with Recall Weapon. \
		The weapon must match your chant — Blade requires a sword, Phalangite a polearm, Macebearer a mace or warhammer. \
		You can rebind to restore a lost Arcyne Momentum status, or bind a new weapon if your old one was destroyed."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "bind_weapon"
	releasedrain = 20
	chargedrain = 0
	chargetime = 0
	recharge_time = 5 SECONDS
	warnie = "yourstate"
	invocations = list("Vinculum Arcanum.")
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE

/obj/effect/proc_holder/spell/self/bind_weapon/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/obj/item/weapon = H.get_active_held_item()
	if(!weapon)
		to_chat(H, span_warning("I need to hold a weapon to bind it!"))
		revert_cast()
		return

	if(weapon.GetComponent(/datum/component/arcyne_conduit))
		to_chat(H, span_warning("[weapon] is already bound as a conduit!"))
		revert_cast()
		return

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(!M)
		M = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)

	if(M?.chant)
		var/valid = FALSE
		var/datum/skill/required_skill
		switch(M.chant)
			if("blade")
				required_skill = /datum/skill/combat/swords
			if("phalangite")
				required_skill = /datum/skill/combat/polearms
			if("macebearer")
				required_skill = /datum/skill/combat/maces
		if(required_skill)
			valid = (weapon.associated_skill == required_skill)
		if(!valid)
			to_chat(H, span_warning("This weapon does not match my chant!"))
			revert_cast()
			return

	if(M?.bound_weapon && !QDELETED(M.bound_weapon))
		var/datum/component/arcyne_conduit/old_conduit = M.bound_weapon.GetComponent(/datum/component/arcyne_conduit)
		if(old_conduit)
			qdel(old_conduit)
		to_chat(H, span_notice("The arcyne bond on [M.bound_weapon] fades."))

	weapon.AddComponent(/datum/component/arcyne_conduit)
	if(M)
		M.bound_weapon = weapon
	to_chat(H, span_notice("I bind [weapon] as my arcyne conduit. Its strikes will build momentum."))
	playsound(get_turf(H), 'sound/magic/charged.ogg', 50, TRUE)
	H.visible_message(span_notice("[H] passes a hand over [weapon], which begins to glow faintly."))
	return TRUE