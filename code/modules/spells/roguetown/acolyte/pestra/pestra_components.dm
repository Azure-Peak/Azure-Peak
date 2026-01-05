/datum/component/infestation_charges
	var/current_charges = 0
	var/absolute_max_charges = 100
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/obj/effect/proc_holder/spell/invoked/infestation/parent_spell
	var/mob/living/parent_mob
	var/was_at_max = FALSE
	var/last_rebirth_use = 0
	var/next_rebirth_use = 5 MINUTES

/datum/component/infestation_charges/Initialize(obj/effect/proc_holder/spell/invoked/infestation/spell)
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	parent_spell = spell
	parent_mob = parent
	current_charges = 0
	next_rebirth_use = 0
	RegisterSignal(parent_spell, COMSIG_INFESTATION_CHARGE_ADD, PROC_REF(add_charge))
	RegisterSignal(parent_mob, COMSIG_INFESTATION_CHARGE_REMOVE, PROC_REF(remove_charge))
	RegisterSignal(parent_mob, COMSIG_DIVINE_REBIRTH_CAST, PROC_REF(divine_rebirth_cast))

/datum/component/infestation_charges/proc/add_charge(source, charge_amount)
	SIGNAL_HANDLER
	var/max_charges = SSchimeric_tech.get_infestation_max_charges()
	var/cooldown_active = FALSE
	if(world.time < last_rebirth_use + next_rebirth_use)
		max_charges = 10
		cooldown_active = TRUE
	current_charges = min(current_charges + charge_amount, max_charges)
	var/rounded_charges = get_charges()
	if(parent_spell)
		parent_spell.update_charge_overlay(rounded_charges)
	// This is the only value update that isn't handled by the healing spell's internal logic, so we call the update here.
	if(rounded_charges == 1)
		var/obj/effect/proc_holder/spell/invoked/pestra_heal/heal_spell = parent_mob.mind?.get_spell(/obj/effect/proc_holder/spell/invoked/pestra_heal)
		if(heal_spell)
			heal_spell.update_charges(get_charges())
	if(!cooldown_active && current_charges >= absolute_max_charges && !was_at_max)
		was_at_max = TRUE
		// Effectively a T4 spell in strength, as such, only pestrans get this.
		if(parent_mob.get_skill_level(/datum/skill/magic/holy) >= 5)
			grant_divine_rebirth()

/datum/component/infestation_charges/proc/remove_charge(source, charge_amount)
	SIGNAL_HANDLER
	current_charges = max(current_charges - charge_amount, 0)
	if(parent_spell)
		parent_spell.update_charge_overlay(get_charges())
	var/max_charges = SSchimeric_tech.get_infestation_max_charges()
	if(was_at_max && current_charges < max_charges)
		was_at_max = FALSE
		remove_divine_rebirth()

/datum/component/infestation_charges/proc/get_charges()
	return floor(current_charges / 10)

/datum/component/infestation_charges/Destroy()
	parent_spell = null
	return ..()

/proc/remove_infestation_charges(mob/living/user, charge_amount)
	SEND_SIGNAL(user, COMSIG_INFESTATION_CHARGE_REMOVE, 10)

/datum/component/infestation_charges/proc/grant_divine_rebirth()
	if(!parent_mob?.mind)
		return

	var/obj/effect/proc_holder/spell/invoked/divine_rebirth/existing = parent_mob.mind.get_spell(/obj/effect/proc_holder/spell/invoked/divine_rebirth)
	if(existing)
		return

	var/obj/effect/proc_holder/spell/invoked/divine_rebirth/new_spell = new()
	parent_mob.mind.AddSpell(new_spell)
	to_chat(parent_mob, span_notice("As the infestation of Pestra festers within me, I feel new power well into my core! [new_spell.name] is now available."))

/datum/component/infestation_charges/proc/remove_divine_rebirth()
	if(!parent_mob?.mind)
		return

	var/obj/effect/proc_holder/spell/invoked/divine_rebirth/existing = parent_mob.mind.get_spell(/obj/effect/proc_holder/spell/invoked/divine_rebirth)
	if(existing)
		parent_mob.mind.RemoveSpell(existing)
		to_chat(parent_mob, span_warning("As the infestation of pestra within me wanes, I am robbed of her strongest gift for now. [existing.name] is no longer available."))

/datum/component/infestation_charges/proc/divine_rebirth_cast(mob/living/user, mob/living/target)
	SIGNAL_HANDLER
	last_rebirth_use = world.time
	next_rebirth_use = initial(next_rebirth_use)
	remove_charge(src, 100)
	user.apply_status_effect(/datum/status_effect/divine_exhaustion, next_rebirth_use)
	var/obj/effect/proc_holder/spell/invoked/pestra_heal/heal_spell = parent_mob.mind?.get_spell(/obj/effect/proc_holder/spell/invoked/pestra_heal)
	if(heal_spell)
		heal_spell.update_charges(get_charges())
	if(parent_spell)
		parent_spell.update_charge_overlay(get_charges())
	to_chat(user, span_warning("The divine power leaves me completely exhausted. My body is purified of infestation thoroughly. I won't be able to channel such power again for some time."))

/datum/component/pestilent_blade_enchant
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/obj/item/parent_weapon
	var/duration = 20 SECONDS
	var/outline_applied = FALSE

/datum/component/pestilent_blade_enchant/Initialize()
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	parent_weapon = parent

	apply_outline()
	RegisterSignal(parent_weapon, COMSIG_ITEM_ATTACK_SUCCESS, .proc/on_attack_success)
	RegisterSignal(parent_weapon, COMSIG_PARENT_QDELETING, .proc/on_qdel)
	addtimer(CALLBACK(src, .proc/remove_enchantment), duration)

/datum/component/pestilent_blade_enchant/proc/apply_outline()
	if(outline_applied)
		return
	parent_weapon.add_filter("pestilent_glow", 2, list("type" = "outline", "color" = "#5b7400", "alpha" = 150, "size" = 1))
	outline_applied = TRUE

/datum/component/pestilent_blade_enchant/proc/remove_outline()
	if(!outline_applied)
		return
	parent_weapon.remove_filter("pestilent_glow")
	outline_applied = FALSE

/datum/component/pestilent_blade_enchant/proc/on_attack_success(obj/item/source, mob/living/target, mob/living/user)
	SIGNAL_HANDLER
	if(!isliving(target))
		return
	var/mob/living/living_target = target
	var/infect_prob = 0
	if(SSchimeric_tech.get_node_status("INFESTATION_ATTACK_VECTOR"))
		infect_prob = 20

	if(living_target.has_status_effect(/datum/status_effect/buff/infestation) || prob(infect_prob))
		living_target.apply_status_effect(/datum/status_effect/debuff/pestilent_plague)
		living_target.visible_message(span_warning("[living_target]'s infestation erupts into a violent plague!"),span_userdanger("The infestation within me erupts into unbearable agony!"))
		remove_enchantment()

/datum/component/pestilent_blade_enchant/proc/on_qdel(datum/source)
	SIGNAL_HANDLER
	remove_enchantment()

/datum/component/pestilent_blade_enchant/proc/remove_enchantment()
	if(outline_applied)
		remove_outline()
	if(parent_weapon)
		parent_weapon.visible_message(span_infection("The sickly glow fades from [parent_weapon]."))
	qdel(src)

#define BLACK_ROT_FIRE_ICON 'icons/mob/onfireNEW.dmi'
#define BLACK_ROT_FIRE_STATE "human_big_fire_long_pause"
#define BLACK_ROT_FILTER "black_rot_glow"
#define DARK_OUTLINE_COLOUR "#000000"

/datum/component/infestation_black_rot
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/parent_mob
	var/base_proc_chance = 10 // 10% base chance to apply rot
	var/self_rot_stacks = 1
	var/no_skill_targets_stacks = 2
	var/low_skill_target_stacks = 3
	var/high_skill_target_stacks = 4
	var/high_skill_level = 5

/datum/component/infestation_black_rot/Initialize()
	. = ..()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	parent_mob = parent
	parent_mob.AddElement(/datum/element/relay_attackers)
	apply_visuals()
	parent_mob.apply_status_effect(/datum/status_effect/buff/black_rot_carrier)
	RegisterSignal(parent_mob, COMSIG_ATOM_WAS_ATTACKED, PROC_REF(on_struck))
	RegisterSignal(parent_mob, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack_success))

/datum/component/infestation_black_rot/proc/on_attack_success(mob/living/user, mob/living/target)
	SIGNAL_HANDLER
	if(user != parent_mob)
		return
	if(prob(25))
		attempt_apply_rot(target, is_offensive = TRUE)

/datum/component/infestation_black_rot/proc/on_struck(atom/victum, atom/attacker)
	SIGNAL_HANDLER
	if(!isliving(attacker))
		return
	var/mob/living/living_attacker = attacker
	attempt_apply_rot(living_attacker, is_offensive = FALSE)

/datum/component/infestation_black_rot/proc/attempt_apply_rot(mob/living/target, is_offensive)
	if(!isliving(target) || target == parent_mob)
		return

	if(!target.mind)
		return

	var/skill_level = parent_mob.get_skill_level(/datum/skill/magic/holy)
	var/chance = base_proc_chance + skill_level

	var/target_rot = target.has_status_effect(/datum/status_effect/black_rot)
	if(target_rot)
		return

	if(prob(chance))
		var/stacks_to_apply
		if(skill_level < 3)
			stacks_to_apply = no_skill_targets_stacks
		else if(skill_level < high_skill_level)
			stacks_to_apply = low_skill_target_stacks
		else
			stacks_to_apply = high_skill_target_stacks

		target.apply_status_effect(/datum/status_effect/black_rot, stacks_to_apply)
		target.visible_message(span_userdanger("[target] twitches as a black rot begins to spread across their body!"))
		parent_mob.apply_status_effect(/datum/status_effect/black_rot, self_rot_stacks)

		var/datum/status_effect/black_rot/self_rot = parent_mob.has_status_effect(/datum/status_effect/black_rot)
		if(self_rot)
			self_rot.add_stack(self_rot_stacks)
		else
			parent_mob.apply_status_effect(/datum/status_effect/black_rot, self_rot_stacks)
			if(is_offensive)
				to_chat(parent_mob, span_notice("My touch spreads the rot to [target], but it takes a toll on my own body."))
			else
				to_chat(parent_mob, span_notice("The blight lashes out at [target] in defense, but it takes a toll on my own body."))

/datum/component/infestation_black_rot/Destroy()
	parent_mob.RemoveElement(/datum/element/relay_attackers)
	remove_visuals()
	parent_mob.remove_status_effect(/datum/status_effect/buff/black_rot_carrier)
	return ..()

/datum/component/infestation_black_rot/proc/apply_visuals()
	if(!parent_mob)
		return

	// Apply Black Outline Filter
	if(!parent_mob.get_filter(BLACK_ROT_FILTER))
		parent_mob.add_filter(BLACK_ROT_FILTER, 2, list(
			"type" = "outline",
			"color" = DARK_OUTLINE_COLOUR,
			"alpha" = 10,
			"size" = 1,
		))

	var/mutable_appearance/new_fire_overlay = mutable_appearance(BLACK_ROT_FIRE_ICON, BLACK_ROT_FIRE_STATE, -BLACK_ROT_LAYER)
	new_fire_overlay.color = list(0,0,0, 0,0,0, 0,0,0, 1,1,1)
	new_fire_overlay.appearance_flags = RESET_COLOR
	parent_mob.overlays_standing[BLACK_ROT_LAYER] = new_fire_overlay
	parent_mob.apply_overlay(BLACK_ROT_LAYER)

/datum/component/infestation_black_rot/proc/remove_visuals()
	if(!parent_mob)
		return
	parent_mob.remove_filter(BLACK_ROT_FILTER)
	parent_mob.remove_overlay(BLACK_ROT_LAYER)

#undef BLACK_ROT_FIRE_ICON
#undef BLACK_ROT_FIRE_STATE
#undef BLACK_ROT_FILTER
#undef DARK_OUTLINE_COLOUR
