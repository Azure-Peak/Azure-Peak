#define ARCYNE_WARD_FILTER "arcyne_ward_glow"
#define BASE_ARCYNE_INTEGRITY 225
#define UPGRADE_ARCYNE_INTEGRITY 300

/datum/action/cooldown/spell/conjure_arcyne_ward
	name = "Conjure Arcyne Ward"
	desc = "Conjure an invisible arcyne ward that covers your entire body. Cast again to dismiss it. \
	The ward withdraws from areas where you wear real armor, leaving those to your equipment instead - \
	a helmet replaces head coverage, a mask replaces face coverage, gauntlets replace hand coverage, \
	arm armor replaces arm coverage, leg armor replaces leg coverage, and boots replace foot coverage. \
	Chest, vitals and groin coverage is only replaced when both your armor and shirt slots are filled. \
	The ward has 225 integrity and does not regenerate - once broken it must be recast. \
	Dismissing the ward refunds cooldown based on remaining integrity - a full health ward has no cooldown, a destroyed ward has full cooldown. \
	While channeling this spell, I cannot parry or dodge - my focus is entirely on the conjuration. \
	While a ward is active, a paired Regenerate Ward action appears on my spell bar, letting me mend it over a full 6-second channel at a cost proportional to how damaged the ward is."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "conjure_armor"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE

	// 70 stamina (green bar) drained up-front at charge start — see on_start_charge().
	// 130-ish energy (blue bar) drained over the charge via charge_drain (5/tick * 5Hz * 6s = 150).
	// Total resource drain is heavy to prevent in-combat re-cast abuse.
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 130
	/// Flat stamina hit taken the instant channeling begins, even if the cast is interrupted.
	var/upfront_stamina_cost = 70

	invocations = list("Aegis Congrego!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 6 SECONDS
	charge_slowdown = 3
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 2 MINUTES
	blocks_defense_while_channeling = TRUE

	associated_skill = /datum/skill/magic/arcane
	point_cost = 2
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/conjured_ward
	var/ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward
	var/dismiss_invocation = "Aegis Dissipo!"
	var/regen_invocation = "Aegis Restauro!"
	/// Paired regen action - granted alongside the conjure spell itself and lives as long as it does.
	/// IsAvailable() on the regen gates by ward existence, so it sits inert (red) when no ward is active.
	var/datum/action/cooldown/spell/regenerate_arcyne_ward/regen_action
	/// Regen spell path paired with this conjure variant. Children override to their matching regen subtype.
	var/regen_spell_type = /datum/action/cooldown/spell/regenerate_arcyne_ward

/datum/action/cooldown/spell/conjure_arcyne_ward/before_cast(atom/cast_on)
	var/dismissing = conjured_ward && !QDELETED(conjured_ward)
	// Dismiss is instant - temporarily zero charge time, and skip the up-front stamina hit
	var/saved_charge_time
	var/saved_upfront
	if(dismissing)
		saved_charge_time = charge_time
		charge_time = 0
		saved_upfront = upfront_stamina_cost
		upfront_stamina_cost = 0
	. = ..()
	if(dismissing)
		charge_time = saved_charge_time
		upfront_stamina_cost = saved_upfront
	. |= SPELL_NO_IMMEDIATE_COOLDOWN
	if(dismissing)
		// Dismiss doesn't cost stamina, and we handle invocation manually in cast()
		. |= SPELL_NO_IMMEDIATE_COST | SPELL_NO_FEEDBACK

/datum/action/cooldown/spell/conjure_arcyne_ward/on_start_charge()
	. = ..()
	if(upfront_stamina_cost > 0 && isliving(owner))
		var/mob/living/L = owner
		var/adjusted = get_adjusted_cost(upfront_stamina_cost)
		if(adjusted > 0)
			L.stamina_add(adjusted)

/datum/action/cooldown/spell/conjure_arcyne_ward/Grant(mob/grant_to)
	. = ..()
	if(!owner)
		return
	if(!regen_action)
		regen_action = new regen_spell_type(owner)
		regen_action.parent_spell = src
	regen_action.Grant(owner)

/datum/action/cooldown/spell/conjure_arcyne_ward/Remove(mob/living/remove_from)
	if(regen_action)
		regen_action.Remove(remove_from)
	return ..()

/datum/action/cooldown/spell/conjure_arcyne_ward/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	// Dismiss active ward with proportional cooldown refund
	if(conjured_ward && !QDELETED(conjured_ward))
		var/integrity_ratio = conjured_ward.obj_integrity / conjured_ward.max_integrity
		H.say(dismiss_invocation, forced = "spell", language = /datum/language/common)
		to_chat(owner, span_notice("I dismiss my arcyne ward."))
		conjured_ward.dismissed = TRUE
		qdel(conjured_ward)
		// Cooldown scales inversely with remaining integrity - full HP = no cooldown, 0 HP = full cooldown
		var/adjusted_cooldown = get_adjusted_cooldown() * (1 - integrity_ratio)
		StartCooldown(adjusted_cooldown)
		return TRUE

	if(H.skin_armor)
		if(!istype(H.skin_armor, /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward))
			to_chat(owner, span_warning("Something else already protects my skin!"))
			return FALSE
		var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/existing = H.skin_armor
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
	// Wake the paired regen button up now that there's a live ward to mend
	regen_action?.build_all_button_icons()
	return TRUE

/datum/action/cooldown/spell/conjure_arcyne_ward/Destroy()
	if(conjured_ward && !QDELETED(conjured_ward))
		conjured_ward.visible_message(span_warning("The arcyne ward flickers and fades!"))
		qdel(conjured_ward)
	QDEL_NULL(regen_action)
	return ..()

/datum/action/cooldown/spell/conjure_arcyne_ward/dragonhide
	name = "Conjure Dragonhide Ward"
	desc = "Conjure a dragonhide ward - an upgraded arcyne ward hardened with draconic scales. \
	Grants fire resistance, halving fire damage and causing flames to burn out faster and bolsters constitution. 300 integrity. \
	Otherwise functions as a standard arcyne ward - yields coverage to real armor, does not regenerate. \
	Cast again to dismiss. Cooldown begins when dismissed or destroyed."
	button_icon_state = "conjure_dragonhide"
	spell_color = GLOW_COLOR_METAL
	invocations = list("Draconis Congrego!")
	dismiss_invocation = "Draconis Dissipo!"
	regen_invocation = "Draconis Restauro!"
	point_cost = 4
	ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/dragonhide
	regen_spell_type = /datum/action/cooldown/spell/regenerate_arcyne_ward/dragonhide

/datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide
	name = "Conjure Crystalhide Ward"
	desc = "Conjure a crystalhide ward - an upgraded arcyne ward crystallized with leyline energy. \
	Grants brigandine-tier protection and bolsters intelligence. Shatters violently when broken, knocking back nearby foes. 300 integrity. \
	Otherwise functions as a standard arcyne ward - yields coverage to real armor, does not regenerate. \
	Cast again to dismiss. Cooldown begins when dismissed or destroyed."
	button_icon_state = "conjure_dragonhide"
	spell_color = GLOW_COLOR_ARCANE
	invocations = list("Psymagia Congrego!")
	dismiss_invocation = "Psymagia Dissipo!"
	regen_invocation = "Psymagia Restauro!"
	charge_time = 5 SECONDS
	point_cost = 4
	spell_tier = 3
	ward_type = /obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide
	regen_spell_type = /datum/action/cooldown/spell/regenerate_arcyne_ward/crystalhide

// --- Regenerate Arcyne Ward (paired spell, granted while a ward is active) ---

/datum/action/cooldown/spell/regenerate_arcyne_ward
	name = "Regenerate Arcyne Ward"
	desc = "Channel a restoration on my active Arcyne Ward, returning it to full integrity. \
	The channel takes 6 seconds and costs stamina and energy proportional to how damaged the ward is - \
	a nearly-full ward costs almost nothing, a shattered one costs nearly as much as a fresh cast. \
	While channeling this spell, I cannot parry or dodge."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "conjure_armor"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = FALSE

	// Costs are scaled at cast time in before_cast() by ward damage.
	// Values here mirror the full-fresh conjure cost so damage_ratio=1 equals a re-cast.
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 130
	var/upfront_stamina_cost = 70

	charge_required = TRUE
	charge_time = 6 SECONDS
	charge_drain = 5
	charge_slowdown = 3
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 2 MINUTES
	blocks_defense_while_channeling = TRUE

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// Back-reference to the conjure spell that owns this action, set by grant_regen_action().
	var/datum/action/cooldown/spell/conjure_arcyne_ward/parent_spell

/datum/action/cooldown/spell/regenerate_arcyne_ward/Grant(mob/grant_to)
	. = ..()
	update_regen_maptext()

/datum/action/cooldown/spell/regenerate_arcyne_ward/proc/update_regen_maptext()
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		if(!B)
			continue
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT("<b>REGEN</b>")
		holder.maptext_x = 2
		holder.color = GLOW_COLOR_ARCANE

/datum/action/cooldown/spell/regenerate_arcyne_ward/IsAvailable(feedback = FALSE)
	if(!parent_spell || QDELETED(parent_spell))
		return FALSE
	if(!parent_spell.conjured_ward || QDELETED(parent_spell.conjured_ward))
		return FALSE
	return ..()

/// Fraction of the ward's max integrity that's missing. 0 at full HP, 1 at zero HP.
/// Drives the proportional resource cost for both check_cost (button state) and before_cast (actual spend).
/datum/action/cooldown/spell/regenerate_arcyne_ward/proc/get_damage_ratio()
	var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ward = parent_spell?.conjured_ward
	if(!ward || QDELETED(ward) || !ward.max_integrity)
		return 0
	return 1 - (ward.obj_integrity / ward.max_integrity)

/datum/action/cooldown/spell/regenerate_arcyne_ward/check_cost(feedback = TRUE)
	// IsAvailable, and therefore the button's red state, calls into check_cost. Scale the
	// primary cost the same way before_cast does so the button reflects the real cost, not
	// the unscaled max - otherwise a half-damaged ward shows red whenever you're below full energy.
	var/damage_ratio = get_damage_ratio()
	var/saved_primary = primary_resource_cost
	primary_resource_cost = round(primary_resource_cost * damage_ratio)
	. = ..()
	primary_resource_cost = saved_primary

/datum/action/cooldown/spell/regenerate_arcyne_ward/before_cast(atom/cast_on)
	var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ward = parent_spell?.conjured_ward
	if(!ward || QDELETED(ward))
		return ..() | SPELL_CANCEL_CAST

	var/damage_ratio = get_damage_ratio()
	var/saved_upfront = upfront_stamina_cost
	var/saved_drain = charge_drain
	var/saved_primary = primary_resource_cost
	upfront_stamina_cost = round(upfront_stamina_cost * damage_ratio)
	charge_drain = round(charge_drain * damage_ratio)
	primary_resource_cost = round(primary_resource_cost * damage_ratio)

	. = ..()

	upfront_stamina_cost = saved_upfront
	charge_drain = saved_drain
	primary_resource_cost = saved_primary

/datum/action/cooldown/spell/regenerate_arcyne_ward/on_start_charge()
	. = ..()
	if(upfront_stamina_cost > 0 && isliving(owner))
		var/mob/living/L = owner
		var/adjusted = get_adjusted_cost(upfront_stamina_cost)
		if(adjusted > 0)
			L.stamina_add(adjusted)

/datum/action/cooldown/spell/regenerate_arcyne_ward/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/ward = parent_spell?.conjured_ward
	if(!ward || QDELETED(ward))
		return FALSE
	H.say(parent_spell.regen_invocation, forced = "spell", language = /datum/language/common)
	to_chat(H, span_notice("My ward shimmers, fully restored."))
	ward.obj_integrity = ward.max_integrity
	return TRUE

/datum/action/cooldown/spell/regenerate_arcyne_ward/dragonhide
	name = "Regenerate Dragonhide Ward"
	spell_tier = 2

/datum/action/cooldown/spell/regenerate_arcyne_ward/crystalhide
	name = "Regenerate Crystalhide Ward"
	spell_tier = 3

// --- The Ward Item ---

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward
	name = "arcyne ward"
	desc = "An invisible barrier of arcyne energy protecting the wearer."
	icon_state = null
	break_sound = 'sound/magic/magic_nulled.ogg'

	body_parts_covered = COVERAGE_FULL_BODY_ACTUAL
	body_parts_inherent = COVERAGE_FULL_BODY_ACTUAL
	armor_class = ARMOR_CLASS_LIGHT
	armor = ARMOR_LEATHER
	max_integrity = BASE_ARCYNE_INTEGRITY

	blocksound = SOFTHIT

	var/datum/action/cooldown/spell/conjure_arcyne_ward/linked_spell
	var/mob/living/carbon/human/ward_owner
	var/coverage_locked = FALSE
	var/dismissed = FALSE
	var/ward_color = GLOW_COLOR_ARCANE
	var/arcyne_armor_tier = ARCYNE_WARD_TIER_BASE

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/setup_ward(mob/living/carbon/human/H)
	ward_owner = H
	RegisterSignal(H, COMSIG_MOB_EQUIPPED_ITEM, PROC_REF(on_owner_equip_change))
	RegisterSignal(H, COMSIG_MOB_DROPITEM, PROC_REF(on_owner_equip_change))
	recalculate_coverage()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/on_owner_equip_change(datum/source, obj/item/item)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(recalculate_coverage)), 1)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/recalculate_coverage()
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

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/has_real_armor(obj/item/clothing/C, coverage_check)
	if(!C || !istype(C))
		return FALSE
	if(C.armor_class <= ARMOR_CLASS_NONE)
		return FALSE
	if(coverage_check)
		return (C.body_parts_covered_dynamic & coverage_check)
	return TRUE

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir, armor_penetration)
	if(ward_owner && damage_amount > 0)
		var/turf/T = get_turf(ward_owner)
		new /obj/effect/temp_visual/spell_impact(T, GLOW_COLOR_ARCANE, SPELL_IMPACT_LOW)
		playsound(T, 'sound/magic/clang.ogg', 50, TRUE)
		flash_ward()
		if(prob(50))
			do_sparks(2, FALSE, T)
	coverage_locked = TRUE
	return ..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/flash_ward()
	if(!ward_owner)
		return
	ward_owner.remove_filter(ARCYNE_WARD_FILTER)
	ward_owner.add_filter(ARCYNE_WARD_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_ARCANE, "alpha" = 80, "size" = 1))
	addtimer(CALLBACK(src, PROC_REF(clear_flash)), 3)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/clear_flash()
	if(ward_owner)
		ward_owner.remove_filter(ARCYNE_WARD_FILTER)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/dropped(mob/user, silent)
	..()
	cleanup_ward()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/Destroy()
	cleanup_ward()
	return ..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/proc/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_filter(ARCYNE_WARD_FILTER)
		UnregisterSignal(ward_owner, list(COMSIG_MOB_EQUIPPED_ITEM, COMSIG_MOB_DROPITEM))
		if(ward_owner.skin_armor == src)
			ward_owner.skin_armor = null
		ward_owner = null
	if(linked_spell)
		// Start full cooldown only when destroyed in combat (not dismissed - dismiss handles its own proportional cooldown)
		if(!QDELETED(linked_spell) && !dismissed)
			linked_spell.StartCooldown(linked_spell.get_adjusted_cooldown())
		linked_spell.conjured_ward = null
		// Refresh the paired regen's button state so it goes red now that the ward is gone
		linked_spell.regen_action?.build_all_button_icons()
		linked_spell = null

// --- Dragonhide Ward Item ---

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/dragonhide
	name = "dragonhide ward"
	desc = "An arcyne ward hardened with draconic scales. Resistant to flame."
	armor = ARMOR_DRAGONHIDE
	max_integrity = UPGRADE_ARCYNE_INTEGRITY
	ward_color = GLOW_COLOR_FIRE
	arcyne_armor_tier = ARCYNE_WARD_TIER_GREATER

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/dragonhide/setup_ward(mob/living/carbon/human/H)
	..()
	H.apply_status_effect(/datum/status_effect/buff/dragonhide)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/dragonhide/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/dragonhide)
	..()

// --- Crystalhide Ward Item ---

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide
	name = "crystalhide ward"
	desc = "An arcyne ward crystallized with leyline energy. Tough against blunt force but less rigid than plate. Shatters violently when broken."
	armor = ARMOR_BRIGANDINE
	max_integrity = UPGRADE_ARCYNE_INTEGRITY
	ward_color = GLOW_COLOR_KINESIS
	arcyne_armor_tier = ARCYNE_WARD_TIER_GREATER

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide/setup_ward(mob/living/carbon/human/H)
	..()
	H.apply_status_effect(/datum/status_effect/buff/crystalhide)

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_status_effect(/datum/status_effect/buff/crystalhide)
	..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide/obj_break()
	if(ward_owner)
		blast_back(ward_owner)
	..()

/obj/item/clothing/suit/roguetown/armor/manual/arcyne_ward/crystalhide/proc/blast_back(mob/living/wearer)
	if(!wearer)
		return
	for(var/mob/living/target in oview(1, wearer))
		var/throwtarget = get_edge_target_turf(wearer, get_dir(wearer, get_step_away(target, wearer)))
		target.safe_throw_at(throwtarget, 2, 1, wearer, spin = FALSE, force = MOVE_FORCE_EXTREMELY_STRONG)
		target.adjustBruteLoss(20)

#undef ARCYNE_WARD_FILTER
#undef BASE_ARCYNE_INTEGRITY
#undef UPGRADE_ARCYNE_INTEGRITY
