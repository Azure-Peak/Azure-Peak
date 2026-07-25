/datum/action/cooldown/spell/touch/conjure_repairkit
	button_icon = 'icons/mob/actions/roguespells.dmi'
	name = "Mending"
	desc = "Conjure a mending focus that can be used to repair equipment. It will be unsummoned as soon as it leaves your hand."
	button_icon_state = "mending"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW

	draw_message = span_notice("I prepare to channel restorative arcyna.")
	drop_message = span_notice("I release my mending focus.")
	infinite_use = TRUE

	hand_path = /obj/item/melee/new_touch_attack/arcyne_repairkit

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CANTRIP

	invocations = list("Reficio")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 1 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1

	point_cost = 3
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/repair_amt = 30 // equal to a fabric patch or metal scrap kit; half as much as something like armor plates

/datum/action/cooldown/spell/touch/conjure_repairkit/cast_on_hand_hit(obj/item/melee/touch_attack/hand, atom/victim, mob/living/carbon/caster, list/modifiers)
	var/obj/item/melee/new_touch_attack/arcyne_repairkit/repairkit = hand
	if(!istype(repairkit))
		return FALSE

	if(!isitem(victim))
		return FALSE
	var/obj/item/I = victim

	if(!I.sewrepair && !I.anvilrepair)
		to_chat(caster, span_warning("Not even magic can repair this item."))
		return FALSE
	if(I.max_integrity)
		if(I.obj_integrity == I.max_integrity)
			to_chat(caster, span_warning("This is not broken."))
			return FALSE
		if(!I.ontable())
			to_chat(caster, span_warning("I should put this on a table first."))
			return FALSE
		if(I.sewrepair)
			playsound(caster.loc, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)
		if(I.anvilrepair)
			playsound(caster.loc,'sound/items/bsmith3.ogg', 100, TRUE, -2)
		var/const/AUTO_SEW_DELAY = CLICK_CD_MELEE
		if(!do_after(caster, 2 SECONDS, target = I))
			return FALSE
		else
			if(I.sewrepair)
				playsound(caster.loc, 'sound/foley/sewflesh.ogg', 50, TRUE, -2)
			if(I.anvilrepair)
				playsound(caster.loc,'sound/items/bsmith3.ogg', 100, TRUE, -2)

			caster.visible_message(span_info("[caster] repairs [I]!"))
			if(I.body_parts_covered != I.body_parts_covered_dynamic)
				caster.visible_message(span_info("[caster] repairs [I]'s coverage!"))
				I.repair_coverage()
			I.obj_integrity = min(I.obj_integrity + repair_amt, I.max_integrity) //10%
			if(I.obj_broken && I.obj_integrity >= I.max_integrity)
				var/obj/item/T = I
				T.obj_fix()
				return FALSE
			if(do_after(caster, AUTO_SEW_DELAY, target = I))
				cast_on_hand_hit(repairkit, I, caster, modifiers)
	return FALSE

/datum/action/cooldown/spell/touch/conjure_repairkit/on_hand_dropped(datum/source, mob/living/dropper)
	SIGNAL_HANDLER

	remove_hand(dropper) // we do NOT want to reset the cooldown - once your mending is gone, you need to wait to get it back

/obj/item/melee/new_touch_attack/arcyne_repairkit
	name = "arcyne restorative"
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "grabbing_greyscale"
	color = "#fd943f"
	desc = "A conjured focus for a magos's will, allowing them to repair arms-and-armor without a smith-or-tailor's equipment - or expertise."
	possible_item_intents = list(/datum/intent/hand/use)
	experimental_inhand = FALSE

/obj/item/melee/new_touch_attack/arcyne_repairkit/afterattack(atom/target, mob/living/carbon/user, proximity)
	if(!proximity && get_dist(user, target) > 1)
		return
	var/datum/action/cooldown/spell/touch/conjure_repairkit/spell = spell_which_made_us?.resolve()
	if(spell)
		spell.cast_on_hand_hit(src, target, user)
