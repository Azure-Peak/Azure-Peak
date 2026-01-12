/obj/structure/fluff/psycross/necra
	name = "necran cross"
	desc = "Not all of the ten bear crosses, but as they oft mark the grave, so do Necrans raise these in honor of the dead. The undermaiden watches."
	icon_state = "cross_necra"
	icon = 'icons/roguetown/misc/tallstructure.dmi'
	max_integrity = 300

/obj/structure/fluff/psycross/necra/Initialize()
	. = ..()
	// - I don't think these need to hear anymore, so I'm cautiously turning this off..
	// chance2hear isn't referenced anywhere in the code!
	lose_hearing_sensitivity()

/obj/structure/fluff/psycross/necra/cloth
	desc = "A Necran cross blessed by a loyal follower. The strips of fabric symbolize the tears of the undermaiden as she welcomes another soul back. It seems sturdy."
	icon_state = "cross_necra_cloth"
	// It's going to be hard to get rid of these when they're not active.
	max_integrity = 1200
	/// Is the cross blessed by a necran?
	var/necran_blessing = FALSE
	/// Is the cross currently active?
	var/cross_active = FALSE
	/// Range of the necran aura
	var/aura_range = 7
	/// List of mobs currently affected by the aura
	var/list/mob/living/affected_mobs = list()
	/// Time when the cross was last activated
	var/last_activation_time = 0
	/// Cooldown between activations
	var/activation_cooldown = 5 SECONDS
	/// Time before auto-deactivation when no undead are detected
	var/auto_deactivate_time = 300 SECONDS
	/// Undead check for auto deactivation
	var/undead_found = 0

/obj/structure/fluff/psycross/necra/cloth/attack_hand(mob/living/user)
	. = ..()

	if(is_undead(user))
		return

	activate_cross(user)

/obj/structure/fluff/psycross/necra/cloth/Destroy()
	deactivate_cross()
	return ..()

/obj/structure/fluff/psycross/necra/cloth/proc/activate_cross(mob/living/user)
	if(cross_active)
		to_chat(user, span_warning("The cross is already active!"))
		return FALSE

	if(world.time < last_activation_time + activation_cooldown)
		to_chat(user, span_warning("The cross needs time to recharge its holy energy."))
		return FALSE

	// Activate the cross
	cross_active = TRUE
	last_activation_time = world.time
	set_light(3, 2, LIGHT_COLOR_HOLY_MAGIC)
	icon_state = "cross_necra_cloth_active"
	visible_message(span_notice("The Necran cross begins to glow with a pale, holy light!"))
	playsound(src, 'sound/magic/ahh1.ogg', 50, TRUE)
	START_PROCESSING(SSobj, src)

	var/health_percentage = obj_integrity / max_integrity
	var/new_max_integrity = 600
	var/new_integrity = round(health_percentage * new_max_integrity)
	max_integrity = new_max_integrity
	obj_integrity = min(new_integrity, max_integrity)
	
	return TRUE

/obj/structure/fluff/psycross/necra/cloth/proc/deactivate_cross()
	if(!cross_active)
		return

	cross_active = FALSE
	set_light(0)
	icon_state = "cross_necra_cloth"
	visible_message(span_notice("The glow fades from the Necran cross."))

	for(var/mob/living/L in affected_mobs)
		remove_undead_debuff(L)
	affected_mobs.Cut()
	STOP_PROCESSING(SSobj, src)

	var/health_percentage = obj_integrity / max_integrity
	var/new_max_integrity = 1200
	var/new_integrity = round(health_percentage * new_max_integrity)
	max_integrity = new_max_integrity
	obj_integrity = min(new_integrity, max_integrity)
	undead_found = 0

/obj/structure/fluff/psycross/necra/cloth/proc/check_auto_deactivate()
	if(!cross_active)
		return

	if(!undead_found && last_activation_time + auto_deactivate_time < world.time)
		visible_message(span_notice("With no undead to purify, the cross's glow fades away."))
		deactivate_cross()


/obj/structure/fluff/psycross/necra/cloth/process(delta_time)
	if(!cross_active)
		STOP_PROCESSING(SSobj, src)
		return
	var/list/current_mobs = list()

	for(var/mob/living/L in view(aura_range, src))
		current_mobs += L

		if(is_undead(L) && !affected_mobs[L])
			apply_undead_debuff(L)
			affected_mobs[L] = TRUE
			undead_found++

	// Remove effects from mobs that left range or are no longer undead
	for(var/mob/living/L in affected_mobs)
		if(!(L in current_mobs) || !is_undead(L))
			remove_undead_debuff(L)
			undead_found = max(0, undead_found - 1)
			affected_mobs -= L

	if(!length(affected_mobs))
		check_auto_deactivate()

/obj/structure/fluff/psycross/necra/cloth/proc/is_undead(mob/living/L)
	if(L.mob_biotypes & MOB_UNDEAD)
		return TRUE
	if(L.mind?.has_antag_datum(/datum/antagonist/zombie))
		return TRUE
	return FALSE

/obj/structure/fluff/psycross/necra/cloth/proc/apply_undead_debuff(mob/living/target)
	if(!target || !is_undead(target))
		return

	var/is_lich = target.mind?.has_antag_datum(/datum/antagonist/lich)
	
	if(is_lich)
		// Stronger debuff for liches
		target.apply_status_effect(/datum/status_effect/debuff/necran_cross/strong)
		to_chat(target, span_danger("You feel the hateful gaze of the undermaiden burn bright upon your very soul!"))
	else
		target.apply_status_effect(/datum/status_effect/debuff/necran_cross)
		to_chat(target, span_danger("You feel the hateful gaze of the undermaiden burn upon your very soul!"))

/obj/structure/fluff/psycross/necra/cloth/proc/remove_undead_debuff(mob/living/target)
	if(!target)
		return
	target.remove_status_effect(/datum/status_effect/debuff/necran_cross)
	target.remove_status_effect(/datum/status_effect/debuff/necran_cross/strong)

/obj/structure/fluff/psycross/necra/cloth/examine(mob/user)
	. = ..()
	if(cross_active)
		. += span_notice("The cross is actively glowing with holy energy.")
	else if(necran_blessing)
		. += span_info("You can touch it to activate its holy aura.")

#define MOVESPEED_ID_NECRAN_CROSS "movespeed_necran_cross"

/datum/status_effect/debuff/necran_cross
	id = "necran_cross_debuff"
	duration = -1 // Removed when leaving range or cross deactivates
	alert_type = /atom/movable/screen/alert/status_effect/necran_cross_debuff
	var/slowdown_multiplier = 4
	var/strength_debuff = -2
	var/perception_debuff = -2
	var/fortune_debuff = -2

/datum/status_effect/debuff/necran_cross/on_apply()
	. = ..()

	var/mob/living/carbon/human/H = owner
	if(istype(H))
		owner.add_movespeed_modifier(MOVESPEED_ID_NECRAN_CROSS, update=TRUE, priority=100, multiplicative_slowdown=slowdown_multiplier)

		effectedstats = list(
		STATKEY_STR = strength_debuff,
		STATKEY_PER = perception_debuff,
		STATKEY_LCK = fortune_debuff
			)

	return TRUE

/datum/status_effect/debuff/necran_cross/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_NECRAN_CROSS)
	return ..()

/datum/status_effect/debuff/necran_cross/strong
	slowdown_multiplier = 6
	strength_debuff = -2
	perception_debuff = -2
	fortune_debuff = -5

/atom/movable/screen/alert/status_effect/necran_cross_debuff
	name = "Holy Purification"
	desc = "The holy light of Necra weakens your undead form. Your movements are slowed and your senses dulled."
	icon_state = "holy"
