#define CONJURE_DISMISS_FADE_TIME (4 SECONDS)

/proc/dismiss_conjured_minion(mob/living/M)
	if(QDELETED(M))
		return
	var/datum/component/conjured_minion/minion = M.GetComponent(/datum/component/conjured_minion)
	if(minion)
		minion.dismissing = TRUE
	M.ai_controller?.set_ai_status(AI_STATUS_OFF)
	M.visible_message(span_notice("[M] unravels, dissolving back into the leyline."))
	animate(M, alpha = 0, time = CONJURE_DISMISS_FADE_TIME)
	QDEL_IN(M, CONJURE_DISMISS_FADE_TIME)

/datum/action/cooldown/spell/conjure_summon
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	sound = 'sound/magic/magnet.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE

	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_HEAVY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_swingdelay_type = SWINGDELAY_CANCEL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/combat/arcyne
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 6

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/max_summons = 1
	var/summons_per_cast = 1
	var/list/conjured_mobs = list()
	var/current_mode = 1
	var/list/modes = list()
	var/summon_noun = "servant"
	var/recoil_energy_floor = 200
	var/recoil_severity = CONJURE_RECOIL_FULL
	var/recoil_stamina_only = FALSE

/datum/action/cooldown/spell/conjure_summon/Grant(mob/grant_to)
	. = ..()
	apply_mode()

/datum/action/cooldown/spell/conjure_summon/Destroy()
	for(var/mob/living/M in conjured_mobs.Copy())
		if(!QDELETED(M))
			qdel(M)
	conjured_mobs.Cut()
	return ..()

/datum/action/cooldown/spell/conjure_summon/toggle_alt_mode(mob/user)
	if(length(modes) < 2)
		return
	var/next = current_mode
	for(var/i in 1 to length(modes))
		next = (next % length(modes)) + 1
		if(mode_available(next, user))
			break
	current_mode = next
	apply_mode()
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]]."))
	return TRUE

/datum/action/cooldown/spell/conjure_summon/proc/mode_available(index, mob/user)
	var/req = modes[index]["tier_req"]
	if(!req)
		return TRUE
	return get_summon_tier(user) >= req

/datum/action/cooldown/spell/conjure_summon/proc/apply_mode()
	if(!length(modes))
		return
	var/list/mode = modes[current_mode]
	if(mode["invocation"])
		invocations = list(mode["invocation"])
	update_mode_maptext()

/datum/action/cooldown/spell/conjure_summon/proc/update_mode_maptext()
	if(!length(modes))
		return
	var/list/mode = modes[current_mode]
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		holder.maptext = MAPTEXT(mode["tag"])
		holder.maptext_x = 5
		holder.color = mode["color"]

/datum/action/cooldown/spell/conjure_summon/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	if(length(modes))
		stats += span_info("Mode (toggle with Shift+G): [modes[current_mode]["name"]]. You may maintain [max_summons] [summon_noun][max_summons > 1 ? "s" : ""] at a time; recasting at capacity re-summons. Losing one to death recoils violently upon you. Dismiss Conjuration releases them without the shock, but a battered servant still recoils as it unbinds - the more hurt it is, the deeper the toll.")
	return stats

/datum/action/cooldown/spell/conjure_summon/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return
	if(HAS_TRAIT(owner, TRAIT_CONJURE_BACKLASH))
		if(feedback)
			owner.balloon_alert(owner, "The backlash still grips me!")
		return FALSE

/datum/action/cooldown/spell/conjure_summon/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE

	if(istype(get_area(user), /area/rogue/indoors/ravoxarena))
		to_chat(user, span_userdanger("I reach for outer help, but something rebukes me! This challenge is only for me to overcome!"))
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!isopenturf(T) || T.is_blocked_turf())
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	var/at_capacity = (length(conjured_mobs) >= max_summons)
	if(at_capacity)
		dismiss_summons(conjured_mobs.Copy())
	var/to_spawn = at_capacity ? summons_per_cast : min(summons_per_cast, max_summons - length(conjured_mobs))
	if(to_spawn < 1)
		to_spawn = 1

	var/list/all_summoned = list()
	for(var/i in 1 to to_spawn)
		var/mob/living/summoned = spawn_summon(T, user)
		if(summoned)
			all_summoned += summoned
	if(!length(all_summoned))
		return FALSE
	for(var/mob/living/summoned in all_summoned)
		conjured_mobs += summoned
		RegisterSignal(summoned, COMSIG_QDELETING, PROC_REF(remove_conjure))
		summoned.AddComponent(/datum/component/conjured_minion, user, recoil_energy_floor, recoil_severity, recoil_stamina_only)
		var/turf/landing = get_turf(summoned)
		landing?.zFall(summoned)
	return TRUE

/datum/action/cooldown/spell/conjure_summon/proc/spawn_summon(turf/T, mob/living/user)
	return

/datum/action/cooldown/spell/conjure_summon/proc/get_summon_tier(mob/living/user)
	var/lvl = user?.get_skill_level(/datum/skill/combat/arcyne)
	if(lvl >= SKILL_LEVEL_MASTER)
		return 3
	if(lvl >= SKILL_LEVEL_EXPERT)
		return 2
	return 1

/datum/action/cooldown/spell/conjure_summon/proc/dismiss_summons(list/mobs)
	for(var/mob/living/M in mobs)
		dismiss_conjured_minion(M)

/datum/action/cooldown/spell/conjure_summon/proc/remove_conjure(mob/living/summoned)
	SIGNAL_HANDLER
	conjured_mobs -= summoned

/mob/living/proc/conjure_damage_fraction()
	if(maxHealth <= 0)
		return 0
	var/total = getBruteLoss() + getFireLoss() + getToxLoss() + getOxyLoss()
	return clamp(total / maxHealth, 0, 1)

/proc/apply_conjure_recoil(mob/living/summoner, energy_floor = 200, severity = CONJURE_RECOIL_FULL, scale = 1, shock = TRUE, stamina_only = FALSE)
	if(!istype(summoner))
		return
	scale = clamp(scale, 0, 1)
	if(scale <= 0)
		return
	if(stamina_only)
		summoner.stamina_add(round(summoner.max_stamina * 0.5 * scale))
		to_chat(summoner, span_warning("The leyline snaps taut and tears the wind from me as my primordial unravels."))
		scale *= 0.5
		shock = FALSE
	if(severity == CONJURE_RECOIL_LIGHT)
		to_chat(summoner, span_warning("A jolt of pain stings me as my conjured servant falls."))
		return

	if(summoner.energy > energy_floor)
		summoner.energy = max(energy_floor, summoner.energy - (summoner.energy - energy_floor) * scale)

	var/list/base_stats
	var/base_duration
	if(severity == CONJURE_RECOIL_FULL)
		base_stats = list(STATKEY_STR = -4, STATKEY_SPD = -4, STATKEY_CON = -4, STATKEY_WIL = -4, STATKEY_PER = -3, STATKEY_INT = -3)
		base_duration = 3 MINUTES
	else
		base_stats = list(STATKEY_STR = -2, STATKEY_CON = -2, STATKEY_WIL = -2)
		base_duration = 45 SECONDS

	if(shock)
		summoner.Knockdown(round(30 * scale))
		summoner.emote("painscream")
		to_chat(summoner, span_userdanger("Agony tears through me as my conjured servant is struck down!"))
	else if(!stamina_only)
		to_chat(summoner, span_warning("A cold recoil ripples through me as I unbind my servant."))

	summoner.apply_status_effect(/datum/status_effect/debuff/conjure_backlash, scale, base_stats, base_duration, shock)

/datum/status_effect/debuff/conjure_backlash
	id = "conjure_backlash"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/conjure_backlash
	status_type = STATUS_EFFECT_REPLACE
	duration = 3 MINUTES
	needs_processing = TRUE
	var/blocks_resummon = FALSE

/datum/status_effect/debuff/conjure_backlash/on_creation(mob/living/new_owner, scale = 1, list/base_stats, base_duration = 45 SECONDS, block = FALSE)
	scale = clamp(scale, 0, 1)
	blocks_resummon = block
	var/list/scaled = list()
	if(islist(base_stats))
		for(var/statkey in base_stats)
			var/mag = round(abs(base_stats[statkey]) * scale)
			if(mag)
				scaled[statkey] = -mag
	effectedstats = scaled
	duration = max(1 SECONDS, round(base_duration * scale))
	return ..(new_owner)

/datum/status_effect/debuff/conjure_backlash/on_apply()
	. = ..()
	if(!.)
		return
	if(blocks_resummon)
		ADD_TRAIT(owner, TRAIT_CONJURE_BACKLASH, "conjure_backlash")

/datum/status_effect/debuff/conjure_backlash/on_remove()
	if(blocks_resummon)
		REMOVE_TRAIT(owner, TRAIT_CONJURE_BACKLASH, "conjure_backlash")
	return ..()

/datum/status_effect/debuff/conjure_backlash/be_replaced()
	if(blocks_resummon)
		REMOVE_TRAIT(owner, TRAIT_CONJURE_BACKLASH, "conjure_backlash")
	return ..()

/atom/movable/screen/alert/status_effect/debuff/conjure_backlash
	name = "Conjurer's Backlash"
	desc = "The unbinding of my conjured servant recoils upon me - the more grievously it was hurt, the deeper the toll. My body and focus are sapped until it passes."
	icon_state = "debuff"
