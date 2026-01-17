/obj/effect/proc_holder/spell/invoked/bless_cross
	name = "Bless Cross"
	desc = "Channel holy energy to bless a Necran cross, allowing it to be activated against undead. devout can maintain one cross, while masters can maintain three. You can unbless a previously blessed cross to reclaim the slot."
	invocations = list("Necra, grant this cross your watchful gaze!")
	sound = 'sound/magic/bless.ogg'
	devotion_cost = 100
	recharge_time = 2 MINUTES
	chargetime = 1 SECONDS
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "bless_cross"
	action_icon_state = "bless_cross"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	associated_skill = /datum/skill/magic/holy

	/// List of blessed crosses this caster maintains
	var/list/obj/structure/fluff/psycross/necra/cloth/blessed_crosses = list()

/obj/effect/proc_holder/spell/invoked/bless_cross/cast(list/targets, mob/living/user)
	var/obj/structure/fluff/psycross/necra/cloth/cross = targets[1]

	if(!istype(cross))
		to_chat(user, span_warning("I can only bless cloth decorated Necran crosses!"))
		revert_cast()
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	var/max_crosses = (holy_skill >= SKILL_LEVEL_MASTER) ? 3 : 1

	for(var/i = blessed_crosses.len; i > 0; i--)
		var/obj/structure/fluff/psycross/necra/cloth/C = blessed_crosses[i]
		if(QDELETED(C) || !C.necran_blessing)
			blessed_crosses -= C

	if(cross.necran_blessing)
		if(cross in blessed_crosses)
			if(!do_after(user, 10 SECONDS, target = cross))
				revert_cast()
				return FALSE
			cross.necran_blessing = FALSE
			if(cross.cross_active)
				cross.deactivate_cross()
			blessed_crosses -= cross
			playsound(cross, 'sound/magic/magnet.ogg', 50, TRUE)
			to_chat(user, span_notice("Cross unblessed. You can maintain [max_crosses - blessed_crosses.len] crosses again."))
			return TRUE
		else
			to_chat(user, span_warning("Another follower already blessed this cross!"))
			revert_cast()
			return FALSE

	// Check if we have room for another cross
	if(blessed_crosses.len >= max_crosses)
		to_chat(user, span_warning("You can only maintain [max_crosses] crosses! Unbless one first."))
		revert_cast()
		return FALSE

	// Bless the cross
	if(!do_after(user, 10 SECONDS, target = cross))
		revert_cast()
		return FALSE

	cross.necran_blessing = TRUE
	blessed_crosses += cross

	to_chat(user, span_notice("Cross blessed! You can bless [max_crosses - blessed_crosses.len] more crosses."))

	return TRUE

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

	if(!necran_blessing)
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
	else
		last_activation_time = world.time

/obj/structure/fluff/psycross/necra/cloth/process(delta_time)
	if(!cross_active)
		STOP_PROCESSING(SSobj, src)
		return
	var/list/current_mobs = list()

	for(var/mob/living/L in view(aura_range, src))
		current_mobs += L

		if(!affected_mobs[L])
			if(is_undead(L))
				apply_undead_debuff(L)
				affected_mobs[L] = TRUE
				undead_found++
			else if(is_necran_follower(L))
				apply_necran_buff(L)
				affected_mobs[L] = TRUE

	// Remove effects from mobs that left range or are no longer undead
	for(var/mob/living/L in affected_mobs)
		if(!(L in current_mobs))
			if(is_undead(L))
				remove_undead_debuff(L)
				undead_found = max(0, undead_found - 1)
			else
				remove_necran_buff(L)
			affected_mobs -= L

	if(!length(affected_mobs))
		check_auto_deactivate()

/obj/structure/fluff/psycross/necra/cloth/proc/is_necran_follower(mob/living/L)
	if(!iscarbon(L))
		return FALSE

	var/mob/living/carbon/C = L
	if(C.patron?.type == /datum/patron/divine/necra)
		return TRUE
	return FALSE

/obj/structure/fluff/psycross/necra/cloth/proc/is_undead(mob/living/L)
	if(L.mob_biotypes & MOB_UNDEAD)
		return TRUE
	if(L.mind?.has_antag_datum(/datum/antagonist/zombie))
		return TRUE
	return FALSE

/obj/structure/fluff/psycross/necra/cloth/proc/apply_necran_buff(mob/living/carbon/human/H)
	// Freaking necran cows! Raah!
	if(!istype(H))
		return

	var/holy_skill = H.get_skill_level(/datum/skill/magic/holy)
	var/buff_tier

	// Determine buff tier based on holy skill
	if(holy_skill >= SKILL_LEVEL_MASTER)
		buff_tier = 3
	else if(holy_skill >= SKILL_LEVEL_APPRENTICE)
		buff_tier = 2
	else
		buff_tier = 1

	// Apply the appropriate buff status effect
	H.apply_status_effect(/datum/status_effect/buff/necran_mists, buff_tier)

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

/obj/structure/fluff/psycross/necra/cloth/proc/remove_necran_buff(mob/living/carbon/human/H)
	if(!istype(H))
		return

	H.remove_status_effect(/datum/status_effect/buff/necran_mists)

/obj/structure/fluff/psycross/necra/cloth/examine(mob/user)
	. = ..()
	if(cross_active)
		. += span_notice("The cross is actively glowing with holy energy, weakening undead in the area.")
		. += span_notice("The energy coursing through the cross seems to make it more fragile.")
	else if(necran_blessing)
		. += span_info("You can touch it to activate its holy aura.")
		. += span_good("A necran blessed this cross, the undermaiden is watching.")
	if(ishuman(user) && necran_blessing)
		var/mob/living/carbon/human/H = user
		if(H.dna?.species?.id == "revenant")
			. += span_danger("I feel the undermaiden's scornful gaze!")
			user.add_stress(/datum/stressevent/revenant_cross)

#define MOVESPEED_ID_NECRAN_CROSS "movespeed_necran_cross"

/datum/status_effect/debuff/necran_cross
	id = "necran_cross_debuff"
	duration = -1 // Removed when leaving range or cross deactivates
	alert_type = /atom/movable/screen/alert/status_effect/necran_cross_debuff
	var/slowdown_multiplier = 2
	var/strength_debuff = -2
	var/perception_debuff = -2
	var/fortune_debuff = -2

/datum/status_effect/debuff/necran_cross/on_apply()
	var/mob/living/carbon/human/H = owner
	if(istype(H))
		owner.add_movespeed_modifier(MOVESPEED_ID_NECRAN_CROSS, update=TRUE, priority=100, multiplicative_slowdown=slowdown_multiplier)

		effectedstats = list(
		STATKEY_STR = strength_debuff,
		STATKEY_PER = perception_debuff,
		STATKEY_LCK = fortune_debuff
			)

	. = ..()
	return TRUE

/datum/status_effect/debuff/necran_cross/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_NECRAN_CROSS)
	return ..()

/datum/status_effect/debuff/necran_cross/strong
	slowdown_multiplier = 4
	strength_debuff = -2
	perception_debuff = -2
	fortune_debuff = -5

/atom/movable/screen/alert/status_effect/necran_cross_debuff
	name = "Holy Purification"
	desc = "The holy light of Necra weakens your undead form. Your movements are slowed and your senses dulled."
	icon_state = "holy"

#define NECRAN_MISTS_FILTER "necra_mists_filter"

/datum/status_effect/buff/necran_mists
	id = "necran_mists"
	duration = -1 // Removed when leaving range
	alert_type = /atom/movable/screen/alert/status_effect/buff/necran_mists
	/// Tier of buff (1-3)
	var/buff_tier = 1
	var/speed_buff = 1

/atom/movable/screen/alert/status_effect/buff/necran_mists
	name = "Necra's Mists"
	desc = "The sacred mists of Necra envelop you, granting protection and speed."
	icon_state = "holybuff"

/datum/status_effect/buff/necran_mists/on_creation(mob/living/new_owner, tier = 1)
	buff_tier = tier
	. = ..()

/datum/status_effect/buff/necran_mists/on_apply()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	switch(buff_tier)
		if(3) // Master or higher
			ADD_TRAIT(H, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_MIRACLE)
			speed_buff = 3
		if(2) // Apprentice to Master
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_MIRACLE)
			speed_buff = 2
		if(1) // Below apprentice
			speed_buff = 1

	effectedstats = list(
		STATKEY_SPD = speed_buff
		)

	var/list/filter_params = list(
		"type" = "layer",
		"icon" = icon('icons/mob/mob_effects_fog.dmi', "subtle"),
		"render_source" = H.render_target, 
		"blend_mode" = BLEND_INSET_OVERLAY
	)
	H.add_filter(NECRAN_MISTS_FILTER, 1, filter_params)
	. = ..()
	return TRUE

/datum/status_effect/buff/necran_mists/on_remove()
	var/mob/living/carbon/human/H = owner
	if(istype(H))
		// Remove traits
		REMOVE_TRAIT(H, TRAIT_MAGEARMOR, TRAIT_MIRACLE)
		REMOVE_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_MIRACLE)
		H.remove_filter(NECRAN_MISTS_FILTER)
	return ..()

#undef NECRAN_MISTS_FILTER
#undef MOVESPEED_ID_NECRAN_CROSS
