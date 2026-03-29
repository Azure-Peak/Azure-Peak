#define ARCYNE_WARD_FILTER "arcyne_ward_glow"

/datum/action/cooldown/spell/conjure_arcyne_ward
	name = "Conjure Arcyne Ward"
	desc = "Conjure an invisible arcyne ward that protects your entire body. Cast again to dismiss it. \
	The ward dynamically yields coverage to real armor you wear - \
	a helmet yields head coverage, a mask yields face coverage, gauntlets yield hand coverage, \
	arm armor yields arm coverage, leg armor yields leg coverage, and boots yield foot coverage. \
	Chest, vitals and groin coverage is only yielded when both your armor and shirt slots are filled. \
	The ward has 225 integrity and regenerates over time by draining your energy. \
	Cooldown begins when the ward is dismissed or destroyed."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "conjure_armor"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE

	invocations = list("Aegis Congrego!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 3 SECONDS
	charge_drain = 1
	charge_slowdown = 3
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5 MINUTES

	associated_skill = /datum/skill/magic/arcane
	point_cost = 2
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/conjured_ward
	var/ward_type = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward
	var/dismiss_invocation = "Aegis Dissipo!"

/datum/action/cooldown/spell/conjure_arcyne_ward/before_cast(atom/cast_on)
	var/dismissing = conjured_ward && !QDELETED(conjured_ward)
	// Dismiss is instant - temporarily zero charge time
	var/saved_charge_time
	if(dismissing)
		saved_charge_time = charge_time
		charge_time = 0
	. = ..()
	if(dismissing)
		charge_time = saved_charge_time
	. |= SPELL_NO_IMMEDIATE_COOLDOWN
	if(dismissing)
		// Dismiss doesn't cost stamina, and we handle invocation manually in cast()
		. |= SPELL_NO_IMMEDIATE_COST | SPELL_NO_FEEDBACK

/datum/action/cooldown/spell/conjure_arcyne_ward/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	// Toggle off - dismiss active ward (cleanup_ward handles cooldown)
	if(conjured_ward && !QDELETED(conjured_ward))
		H.say(dismiss_invocation, forced = "spell")
		to_chat(owner, span_notice("I dismiss my arcyne ward."))
		qdel(conjured_ward)
		return TRUE

	if(H.skin_armor)
		if(!istype(H.skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward))
			to_chat(owner, span_warning("Something else already protects my skin!"))
			return FALSE
		var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/existing = H.skin_armor
		if(existing.arcyne_armor_tier > initial(ward_type:arcyne_armor_tier))
			to_chat(owner, span_warning("A stronger ward already protects me!"))
			return FALSE

	// Toggle on - conjure ward, no cooldown (button stays available for dismiss)
	owner.visible_message(span_notice("An arcyne ward shimmers into existence around [owner]!"))
	conjured_ward = new ward_type(H)
	H.skin_armor = conjured_ward
	conjured_ward.setup_ward(H)
	conjured_ward.linked_spell = src
	reset_spell_cooldown()
	return TRUE

/datum/action/cooldown/spell/conjure_arcyne_ward/Destroy()
	if(conjured_ward && !QDELETED(conjured_ward))
		conjured_ward.visible_message(span_warning("The arcyne ward flickers and fades!"))
		qdel(conjured_ward)
	return ..()

/datum/action/cooldown/spell/conjure_arcyne_ward/dragonhide
	name = "Conjure Dragonhide Ward"
	desc = "Conjure a dragonhide ward - an upgraded arcyne ward hardened with draconic scales. \
	Grants fire immunity and superior blunt resistance. 300 integrity. \
	Otherwise functions as a standard arcyne ward - yields coverage to real armor, regenerates by draining energy. \
	Cast again to dismiss. Cooldown begins when dismissed or destroyed."
	button_icon_state = "conjure_dragonhide"
	spell_color = GLOW_COLOR_METAL
	invocations = list("Draconis Congrego!")
	dismiss_invocation = "Draconis Dissipo!"
	point_cost = 4
	ward_type = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/dragonhide

/datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide
	name = "Conjure Crystalhide Ward"
	desc = "Conjure a crystalhide ward - an upgraded arcyne ward crystallized with leyline energy. \
	Grants brigandine-tier protection and bolsters intelligence. Shatters violently when broken, knocking back nearby foes. 300 integrity. \
	Otherwise functions as a standard arcyne ward - yields coverage to real armor, regenerates by draining energy. \
	Cast again to dismiss. Cooldown begins when dismissed or destroyed."
	button_icon_state = "conjure_dragonhide"
	spell_color = GLOW_COLOR_ARCANE
	invocations = list("Psymagia Congrego!")
	dismiss_invocation = "Psymagia Dissipo!"
	charge_time = 5 SECONDS
	point_cost = 4
	spell_tier = 3
	ward_type = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/crystalhide

// --- The Ward Item ---

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward
	name = "arcyne ward"
	desc = "An invisible barrier of arcyne energy protecting the wearer."
	icon_state = null
	break_sound = 'sound/magic/magic_nulled.ogg'

	body_parts_covered = COVERAGE_FULL_BODY_ACTUAL
	body_parts_inherent = COVERAGE_FULL_BODY_ACTUAL
	armor_class = ARMOR_CLASS_LIGHT
	armor = ARMOR_LEATHER
	max_integrity = 225

	repair_time = 30 SECONDS
	auto_repair_mode = FALSE

	repairmsg_begin = "The arcyne ward begins to mend itself, drawing from my energy..."
	repairmsg_continue = "The arcyne ward weaves more of itself back together..."
	repairmsg_stop = "The arcyne ward's regeneration falters!"
	repairmsg_end = "The arcyne ward stabilizes, fully restored."

	blocksound = SOFTHIT

	var/datum/action/cooldown/spell/conjure_arcyne_ward/linked_spell
	var/mob/living/carbon/human/ward_owner
	var/coverage_locked = FALSE
	var/ward_color = GLOW_COLOR_ARCANE
	var/arcyne_armor_tier = ARCYNE_WARD_TIER_BASE

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/proc/setup_ward(mob/living/carbon/human/H)
	ward_owner = H
	RegisterSignal(H, COMSIG_ITEM_EQUIPPED, PROC_REF(on_owner_equip_change))
	RegisterSignal(H, COMSIG_ITEM_DROPPED, PROC_REF(on_owner_equip_change))
	recalculate_coverage()

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/proc/on_owner_equip_change(datum/source, obj/item/item)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(recalculate_coverage)), 1)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/proc/recalculate_coverage()
	if(QDELETED(src) || !ward_owner)
		return

	var/new_coverage = COVERAGE_FULL_BODY_ACTUAL
	var/mob/living/carbon/human/H = ward_owner

	if(has_real_armor(H.head))
		new_coverage &= ~(HEAD | HAIR | EARS)

	if(has_real_armor(H.wear_mask))
		new_coverage &= ~(NOSE | MOUTH)

	if(has_real_armor(H.wear_shirt) && has_real_armor(H.wear_armor))
		new_coverage &= ~(CHEST | GROIN | VITALS)

	if(has_real_armor(H.wear_armor, ARM_LEFT | ARM_RIGHT) || has_real_armor(H.wear_shirt, ARM_LEFT | ARM_RIGHT))
		new_coverage &= ~(ARM_LEFT | ARM_RIGHT)

	if(has_real_armor(H.gloves))
		new_coverage &= ~(HAND_LEFT | HAND_RIGHT)

	if(has_real_armor(H.wear_pants))
		new_coverage &= ~(LEG_LEFT | LEG_RIGHT)

	if(has_real_armor(H.shoes))
		new_coverage &= ~(FOOT_LEFT | FOOT_RIGHT)

	if(coverage_locked)
		new_coverage &= body_parts_covered_dynamic
	body_parts_covered_dynamic = new_coverage

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/proc/has_real_armor(obj/item/clothing/C, coverage_check)
	if(!C || !istype(C))
		return FALSE
	if(C.armor_class <= ARMOR_CLASS_NONE)
		return FALSE
	if(C.max_integrity && C.obj_integrity <= 0)
		return FALSE
	if(coverage_check)
		return (C.body_parts_covered_dynamic & coverage_check)
	return TRUE

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	if(ward_owner && damage_amount > 0)
		var/turf/T = get_turf(ward_owner)
		new /obj/effect/temp_visual/spell_impact(T, GLOW_COLOR_ARCANE, SPELL_IMPACT_LOW)
		playsound(T, 'sound/magic/clang.ogg', 50, TRUE)
		flash_ward()
		if(prob(50))
			do_sparks(2, FALSE, T)
	coverage_locked = TRUE
	..()

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/proc/flash_ward()
	if(!ward_owner)
		return
	ward_owner.remove_filter(ARCYNE_WARD_FILTER)
	ward_owner.add_filter(ARCYNE_WARD_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_ARCANE, "alpha" = 80, "size" = 1))
	addtimer(CALLBACK(src, PROC_REF(clear_flash)), 3)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/proc/clear_flash()
	if(ward_owner)
		ward_owner.remove_filter(ARCYNE_WARD_FILTER)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/armour_regen()
	reptimer = null
	if(QDELETED(src))
		return
	if(obj_integrity >= max_integrity)
		to_chat(ward_owner || loc, span_notice(repairmsg_end))
		coverage_locked = FALSE
		recalculate_coverage()
		return
	var/repair_amount
	if(obj_integrity == 0)
		repair_amount = 5
	else
		repair_amount = 0.2 * max_integrity
	repair_amount = min(repair_amount, max_integrity - obj_integrity)
	if(repair_amount <= 0)
		to_chat(ward_owner || loc, span_notice(repairmsg_end))
		coverage_locked = FALSE
		recalculate_coverage()
		return
	if(!ward_owner || ward_owner.energy < repair_amount)
		to_chat(ward_owner || loc, span_warning("I don't have enough energy - the ward can't mend itself!"))
		reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), repair_time, TIMER_STOPPABLE)
		return
	ward_owner.energy_add(-repair_amount)
	obj_integrity = min(obj_integrity + repair_amount, max_integrity)
	if(obj_broken && obj_integrity > 0)
		obj_fix(full_repair = FALSE)
	if(obj_integrity >= max_integrity)
		to_chat(ward_owner, span_notice(repairmsg_end))
		coverage_locked = FALSE
		recalculate_coverage()
	else
		to_chat(ward_owner, span_notice(repairmsg_continue))
		reptimer = addtimer(CALLBACK(src, PROC_REF(armour_regen)), repair_time, TIMER_STOPPABLE)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/dropped(mob/user, silent)
	..()
	cleanup_ward()

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/Destroy()
	cleanup_ward()
	return ..()

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/proc/cleanup_ward()
	if(reptimer)
		deltimer(reptimer)
		reptimer = null
	if(ward_owner)
		ward_owner.remove_filter(ARCYNE_WARD_FILTER)
		UnregisterSignal(ward_owner, list(COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))
		if(ward_owner.skin_armor == src)
			ward_owner.skin_armor = null
		ward_owner = null
	if(linked_spell)
		// Start cooldown on the linked spell if it's not being destroyed
		// This handles both dismiss (recast) and break (combat damage) cases
		// When the spell itself is being destroyed, QDELETED catches it and skips cooldown
		if(!QDELETED(linked_spell))
			linked_spell.StartCooldown(linked_spell.get_adjusted_cooldown())
		linked_spell.conjured_ward = null
		linked_spell = null

// --- Dragonhide Ward Item ---

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/dragonhide
	name = "dragonhide ward"
	desc = "An arcyne ward hardened with draconic scales. Impervious to flame."
	armor = ARMOR_DRAGONHIDE
	max_integrity = 300
	ward_color = GLOW_COLOR_FIRE
	arcyne_armor_tier = ARCYNE_WARD_TIER_GREATER
	repairmsg_begin = "The dragonhide ward begins to mend itself, drawing from my energy..."
	repairmsg_continue = "The dragonhide ward weaves draconic scales back together..."
	repairmsg_end = "The dragonhide ward stabilizes, fully restored."

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/dragonhide/setup_ward(mob/living/carbon/human/H)
	..()
	H.apply_status_effect(/datum/status_effect/buff/dragonhide)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/dragonhide/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/dragonhide)
	..()

// --- Crystalhide Ward Item ---

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/crystalhide
	name = "crystalhide ward"
	desc = "An arcyne ward crystallized with leyline energy. Tough against blunt force but less rigid than plate. Shatters violently when broken."
	armor = ARMOR_BRIGANDINE
	max_integrity = 300
	ward_color = GLOW_COLOR_KINESIS
	arcyne_armor_tier = ARCYNE_WARD_TIER_GREATER
	repairmsg_begin = "The crystalhide ward begins to mend itself, drawing from my energy..."
	repairmsg_continue = "The crystalhide ward reforms crystalline lattice..."
	repairmsg_end = "The crystalhide ward stabilizes, fully restored."

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/crystalhide/setup_ward(mob/living/carbon/human/H)
	..()
	H.apply_status_effect(/datum/status_effect/buff/crystalhide)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/crystalhide/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/crystalhide)
	..()

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/crystalhide/obj_break()
	if(ward_owner)
		blast_back(ward_owner)
	..()

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/crystalhide/proc/blast_back(mob/living/wearer)
	if(!wearer)
		return
	for(var/mob/living/target in oview(1, wearer))
		var/throwtarget = get_edge_target_turf(wearer, get_dir(wearer, get_step_away(target, wearer)))
		target.safe_throw_at(throwtarget, 2, 1, wearer, spin = FALSE, force = MOVE_FORCE_EXTREMELY_STRONG)
		target.adjustBruteLoss(20)

#undef ARCYNE_WARD_FILTER
