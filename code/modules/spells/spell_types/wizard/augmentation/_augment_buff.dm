/datum/action/cooldown/spell/augment_buff
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = CHARGETIME_MINOR
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/fellowship_snap = FALSE

/datum/action/cooldown/spell/augment_buff/toggle_alt_mode(mob/user)
	fellowship_snap = !fellowship_snap
	if(fellowship_snap)
		to_chat(user, span_notice("[name]: Fellowship Mode enabled - an off-target cast snaps to your nearest fellowship member in range."))
	else
		to_chat(user, span_notice("[name]: Fellowship Mode disabled."))
	update_snap_maptext()
	return TRUE

/datum/action/cooldown/spell/augment_buff/InterceptClickOn(mob/living/clicker, list/modifiers, atom/click_target)
	if(!fellowship_snap)
		return ..()
	if(istext(modifiers))
		modifiers = params2list(modifiers)
	if(!LAZYACCESS(modifiers, MIDDLE_CLICK))
		return ..(clicker, modifiers, click_target)
	if(click_target == clicker)
		return ..(clicker, modifiers, click_target)
	if(isliving(click_target) && shares_fellowship(clicker, click_target))
		return ..(clicker, modifiers, click_target)
	var/mob/living/snapped = get_snap_target(clicker)
	if(snapped)
		return ..(clicker, modifiers, snapped)
	clicker.balloon_alert(clicker, "no fellow in range!")
	return ..(clicker, modifiers, click_target)

/datum/action/cooldown/spell/augment_buff/proc/get_snap_target(mob/living/clicker)
	if(!clicker.current_fellowship)
		return null
	var/mob/living/nearest
	var/nearest_dist = INFINITY
	for(var/mob/living/candidate in view(cast_range, clicker))
		if(candidate == clicker)
			continue
		if(candidate.stat == DEAD)
			continue
		if(!candidate.mind)
			continue
		if(!shares_fellowship(clicker, candidate))
			continue
		var/dist = get_dist(clicker, candidate)
		if(dist < nearest_dist)
			nearest_dist = dist
			nearest = candidate
	return nearest

/datum/action/cooldown/spell/augment_buff/proc/update_snap_maptext()
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		if(fellowship_snap)
			holder.maptext = MAPTEXT("SNAP")
			holder.color = "#66ff66"
		else
			holder.maptext = null

/datum/action/cooldown/spell/augment_buff/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats += span_info("Fellowship Mode (toggle with Shift+G): an off-target cast snaps the buff to your nearest fellowship member in range.")
	return stats
