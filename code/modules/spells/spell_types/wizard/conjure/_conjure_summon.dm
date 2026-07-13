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
	cooldown_time = 45 SECONDS

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
	var/recoil_debuff = TRUE
	var/upkeep_strain = 3

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
	current_mode = (current_mode % length(modes)) + 1
	apply_mode()
	to_chat(user, span_notice("[name]: [modes[current_mode]["name"]]."))
	return TRUE

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
		stats += span_info("Mode (toggle with Shift+G): [modes[current_mode]["name"]]. You may maintain [max_summons] [summon_noun][max_summons > 1 ? "s" : ""] at a time; recasting at capacity re-summons. Losing one to death recoils violently upon you - use Dismiss Conjuration to release it safely.")
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
		summoned.AddComponent(/datum/component/conjured_minion, user, recoil_energy_floor, recoil_debuff)
		var/turf/landing = get_turf(summoned)
		landing?.zFall(summoned)
	update_conjure_upkeep(user)
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
	INVOKE_ASYNC(GLOBAL_PROC, GLOBAL_PROC_REF(update_conjure_upkeep), owner)

/proc/apply_conjure_recoil(mob/living/summoner, energy_floor = 200, apply_debuff = TRUE)
	if(!istype(summoner))
		return
	if(summoner.energy > energy_floor)
		summoner.energy = energy_floor
	if(!apply_debuff)
		to_chat(summoner, span_warning("A jolt of pain stings me as my conjured servant falls."))
		return
	summoner.Knockdown(30)
	summoner.emote("painscream")
	to_chat(summoner, span_userdanger("Agony tears through me as my conjured servant is struck down!"))
	summoner.apply_status_effect(/datum/status_effect/debuff/conjure_backlash)

/datum/status_effect/debuff/conjure_backlash
	id = "conjure_backlash"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/conjure_backlash
	effectedstats = list(STATKEY_STR = -4, STATKEY_SPD = -4, STATKEY_CON = -4, STATKEY_WIL = -4, STATKEY_PER = -3, STATKEY_INT = -3)
	duration = 3 MINUTES
	needs_processing = TRUE

/datum/status_effect/debuff/conjure_backlash/on_apply()
	. = ..()
	if(!.)
		return
	ADD_TRAIT(owner, TRAIT_CONJURE_BACKLASH, "conjure_backlash")

/datum/status_effect/debuff/conjure_backlash/on_remove()
	REMOVE_TRAIT(owner, TRAIT_CONJURE_BACKLASH, "conjure_backlash")
	return ..()

/atom/movable/screen/alert/status_effect/debuff/conjure_backlash
	name = "Conjurer's Backlash"
	desc = "My summon was struck down. The recoil ravages me - my body and focus are sapped, and I cannot conjure anew until it passes."
	icon_state = "debuff"

/proc/update_conjure_upkeep(mob/living/summoner)
	if(!istype(summoner))
		return
	var/strain = 0
	for(var/datum/action/cooldown/spell/conjure_summon/summon_spell in summoner.actions)
		for(var/mob/living/M in summon_spell.conjured_mobs)
			if(!QDELETED(M))
				strain += summon_spell.upkeep_strain
	summoner.remove_status_effect(/datum/status_effect/debuff/conjure_upkeep)
	if(strain > 0)
		summoner.apply_status_effect(/datum/status_effect/debuff/conjure_upkeep, strain)

/datum/status_effect/debuff/conjure_upkeep
	id = "conjure_upkeep"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/conjure_upkeep
	duration = -1
	needs_processing = FALSE
	var/total_strain = 3

/datum/status_effect/debuff/conjure_upkeep/on_creation(mob/living/new_owner, strain = 3)
	total_strain = max(strain, 1)
	effectedstats = list(STATKEY_WIL = -total_strain, STATKEY_CON = -total_strain, STATKEY_INT = -total_strain)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/conjure_upkeep
	name = "Conjurer's Strain"
	desc = "Sustaining my conjured servants saps my will, focus, and vigor - the more I hold, the heavier the toll."
	icon_state = "debuff"
