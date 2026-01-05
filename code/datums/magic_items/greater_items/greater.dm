///T3 Enchantmentsdatum
/datum/magic_item/greater/lifesteal
	name = "life steal"
	description = "It seems bloodthirsty."
	var/last_used
	var/flat_heal = 10
	var/static/list/damage_heal_order = list(BRUTE, BURN, OXY)
	var/warned = FALSE

/datum/magic_item/greater/lifesteal/projectile_hit(atom/fired_from, atom/movable/firer, atom/target, Angle)
	if(world.time < src.last_used + 100)
		to_chat(firer, span_notice("[fired_from] is not yet hungry for more life!"))
		return
	if(isliving(firer) && isliving(target))
		var/mob/living/healing = firer
		var/mob/living/damaging = target
		if(damaging.stat != DEAD)
			healing.heal_ordered_damage(flat_heal, damage_heal_order)
			firer.visible_message(span_danger("[fired_from] drains life from [target]!"))
			src.last_used = world.time

/datum/magic_item/greater/lifesteal/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < src.last_used + 100)
		if(!warned)
			to_chat(user, span_notice("[source] is not yet hungry for more life!"))
			warned = TRUE
		return
	if(isliving(user) && isliving(target))
		var/mob/living/healing = user
		var/mob/living/damaging = target
		if(damaging.stat != DEAD)
			healing.heal_ordered_damage(flat_heal, damage_heal_order)
			user.visible_message(span_danger("[source] drains life from [target]!"))
			warned = FALSE
			src.last_used = world.time

/datum/magic_item/greater/lightning
	name = "lightning"
	description = "It has small arcs of electricity dance across it"
	var/list/last_used = list()

/datum/magic_item/greater/lightning/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < (src.last_used[source] + (1 MINUTES + 40 SECONDS))) //thanks borbop
		return

	if(isliving(target))
		var/mob/living/L = target
		L.Immobilize(0.5 SECONDS)
		L.apply_status_effect(/datum/status_effect/debuff/clickcd, 6 SECONDS)
		L.electrocute_act(1, src, 1, SHOCK_NOSTUN)
		L.apply_status_effect(/datum/status_effect/buff/lightningstruck, 6 SECONDS)

		for(var/mob/living/nearby in range(2, target))
			if(nearby == target || nearby == user)
				continue
			if(prob(30))
				nearby.Immobilize(0.5 SECONDS)
				nearby.apply_status_effect(/datum/status_effect/debuff/clickcd, 6 SECONDS)
				nearby.electrocute_act(1, src, 1, SHOCK_NOSTUN)
				nearby.apply_status_effect(/datum/status_effect/buff/lightningstruck, 6 SECONDS)
				new /obj/effect/temp_visual/lightning(get_turf(target), get_turf(nearby))
	last_used[source] = world.time

/datum/magic_item/greater/frostveil
	name = "frostveil"
	description = "It feels rather cold."
	var/last_used

/datum/magic_item/greater/frostveil/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < src.last_used + 20 SECONDS)
		return
	if(isliving(target))
		var/mob/living/targeted = target
		targeted.apply_status_effect(/datum/status_effect/debuff/cold)
		targeted.visible_message(span_danger("[source] chills [targeted]!"))
		src.last_used = world.time

/datum/magic_item/greater/frostveil/on_hit_response(var/obj/item/I, var/mob/living/carbon/human/owner, var/mob/living/carbon/human/attacker)
	if(world.time < src.last_used + 20 SECONDS)
		return
	if(isliving(attacker) && attacker != owner)
		attacker.apply_status_effect(/datum/status_effect/debuff/cold)
		attacker.visible_message(span_danger("[I] chills [attacker]!"))
		src.last_used = world.time

/datum/magic_item/greater/phoenixguard
	name = "phoenixguard"
	description = "It gives off radiant heat."
	var/last_used

/datum/magic_item/greater/phoenixguard/on_hit_response(var/obj/item/I, var/mob/living/carbon/human/owner, var/mob/living/carbon/human/attacker)
	if(world.time < src.last_used + 20 SECONDS)
		return
	if(isliving(attacker) && attacker != owner)
		attacker.adjust_fire_stacks(5)
		attacker.ignite_mob()
		attacker.visible_message(span_danger("[I] sets [attacker] on fire!"))
		src.last_used = world.time

/datum/magic_item/greater/woundclosing
	name = "wound closing"
	description = "It pulses with healing magick."
	var/active_item = FALSE

/datum/magic_item/greater/woundclosing/on_equip(var/obj/item/i, var/mob/living/user, slot)
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/wound_closure)
		to_chat(user, span_notice("[i] feels warm against fingers."))
		active_item = TRUE

/datum/magic_item/greater/woundclosing/on_drop(var/obj/item/i, var/mob/living/user)
	if(active_item)
		active_item = FALSE
		user.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/wound_closure)
		to_chat(user, span_notice("The warmth of [i] fades away."))

/datum/magic_item/greater/returningweapon
	name = "returning weapon"
	description = "It glows with arcane sigils."
	var/active_item = FALSE

/datum/magic_item/greater/returningweapon/on_equip(var/obj/item/i, var/mob/living/user, slot)
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		active_item = TRUE
		user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/summonweapon)
		to_chat(user, span_notice("I feel the magick within [i] resonate with my own."))

/datum/magic_item/greater/returningweapon/on_drop(var/obj/item/i, var/mob/living/user)
	if(active_item)
		user.mind.RemoveSpell(/obj/effect/proc_holder/spell/targeted/summonweapon)
		to_chat(user, span_notice("the warmth of [i] fades away."))
		active_item = FALSE

/datum/magic_item/greater/archery
	name = "archery"
	description = "It has the imprint of a bowstring."
	var/active_item = FALSE
	var/masterbow = FALSE
	var/legendbow = FALSE
	var/mastercrossbow = FALSE
	var/legendcrossbow = FALSE
	var/mastersling = FALSE
	var/legendsling = FALSE

/datum/magic_item/greater/archery/on_equip(var/obj/item/i, var/mob/living/user, slot)
	if(slot == ITEM_SLOT_HANDS)
		return
	if(active_item)
		return
	else
		//stat boost
		user.change_stat(STATKEY_PER, 2)

		//Bow boost
		if (user.get_skill_level(/datum/skill/combat/bows) == 6)
			legendbow = TRUE
			masterbow = FALSE
		else
			if (user.get_skill_level(/datum/skill/combat/bows) == 5)
				user.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
				masterbow = TRUE
			else
				user.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)

		//crossbow boost
		if (user.get_skill_level(/datum/skill/combat/crossbows) == 6)
			legendcrossbow = TRUE
			mastercrossbow = FALSE
		else
			if (user.get_skill_level(/datum/skill/combat/crossbows) == 5)
				user.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
				mastercrossbow = TRUE
			else
				user.adjust_skillrank(/datum/skill/combat/crossbows, 2, TRUE)

		//sling boost
		if (user.get_skill_level(/datum/skill/combat/slings) == 6)
			legendsling = TRUE
			mastersling = FALSE
		else
			if (user.get_skill_level(/datum/skill/combat/slings) == 5)
				user.adjust_skillrank(/datum/skill/combat/slings, 1, TRUE)
				mastersling = TRUE
			else
				user.adjust_skillrank(/datum/skill/combat/slings, 2, TRUE)

		to_chat(user, span_notice("I feel more dexterious!"))
		active_item = TRUE

/datum/magic_item/greater/archery/on_drop(var/obj/item/i, var/mob/living/user)
	if(active_item)
		active_item = FALSE
		user.change_stat(STATKEY_PER, -2)
		//correct bows
		if (!legendbow)
			if (masterbow)
				user.adjust_skillrank(/datum/skill/combat/bows -1, TRUE)
			else
				user.adjust_skillrank(/datum/skill/combat/bows, -2, TRUE)

		//correct crossbows
		if (!legendcrossbow)
			if (mastercrossbow)
				user.adjust_skillrank(/datum/skill/combat/crossbows -1, TRUE)
			else
				user.adjust_skillrank(/datum/skill/combat/crossbows, -2, TRUE)

		//correct slings
		if (!legendsling)
			if (mastersling)
				user.adjust_skillrank(/datum/skill/combat/slings -1, TRUE)
			else
				user.adjust_skillrank(/datum/skill/combat/slings, -2, TRUE)

		to_chat(user, span_notice("I feel mundane once more"))

/datum/magic_item/greater/void
	name = "void touched"
	description = "It seems to absorb light around it, existing partially outside reality."
	var/list/last_used = list()

/datum/magic_item/greater/void/on_hit(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(world.time < (src.last_used[source] + 10 SECONDS))
		return

	if(isliving(target) && target != user) //self teleporting might be scary actually
		var/mob/living/L = target
		to_chat(L, span_warning("You feel reality warp around you!"))
		var/list/possible_turfs = list()
		for(var/turf/T in range(3, L))
			if(T.density)
				continue
			possible_turfs += T
		if(possible_turfs.len)
			L.forceMove(pick(possible_turfs))
		last_used[source] = world.time
