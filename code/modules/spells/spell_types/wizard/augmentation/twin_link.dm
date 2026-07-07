GLOBAL_LIST_EMPTY(twin_links)

/datum/twin_link
	var/mob/living/caster
	var/mob/living/twin

/datum/twin_link/New(mob/living/caster, mob/living/twin)
	src.caster = caster
	src.twin = twin
	GLOB.twin_links += src
	RegisterSignal(caster, COMSIG_PARENT_QDELETING, PROC_REF(member_gone))
	RegisterSignal(twin, COMSIG_PARENT_QDELETING, PROC_REF(member_gone))

/datum/twin_link/Destroy()
	if(caster)
		UnregisterSignal(caster, COMSIG_PARENT_QDELETING)
	if(twin)
		UnregisterSignal(twin, COMSIG_PARENT_QDELETING)
	GLOB.twin_links -= src
	caster = null
	twin = null
	return ..()

/datum/twin_link/proc/member_gone(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/datum/twin_link/proc/contains(mob/living/target)
	return target == caster || target == twin

/datum/twin_link/proc/partner_of(mob/living/target)
	if(target == caster)
		return twin
	if(target == twin)
		return caster
	return null

/proc/get_twin_link(mob/living/target)
	for(var/datum/twin_link/link in GLOB.twin_links)
		if(link.contains(target))
			return link
	return null

/proc/apply_buff_to(mob/living/spelltarget, buff_type, duration)
	var/echo_type = weakened_twinlink_variant(buff_type)
	if(echo_type)
		spelltarget.remove_status_effect(echo_type)
	spelltarget.apply_status_effect(buff_type, duration)
	mirror_twin_link(spelltarget, buff_type)

/proc/mirror_twin_link(mob/living/spelltarget, buff_type)
	var/weakened = weakened_twinlink_variant(buff_type)
	if(!weakened)
		return
	var/datum/twin_link/link = get_twin_link(spelltarget)
	if(!link)
		return
	var/mob/living/partner = link.partner_of(spelltarget)
	if(!partner || partner.stat == DEAD)
		return
	if(!(partner in view(spelltarget)))
		return
	if(partner.has_status_effect(buff_type))
		return
	spelltarget.Beam(partner, icon_state = "b_beam", time = 1 SECONDS)
	partner.apply_status_effect(weakened)

/proc/weakened_twinlink_variant(buff_type)
	switch(buff_type)
		if(/datum/status_effect/buff/attune_haste)
			return /datum/status_effect/buff/twinlink/haste
		if(/datum/status_effect/buff/attune_giant)
			return /datum/status_effect/buff/twinlink/giant
		if(/datum/status_effect/buff/attune_hawk)
			return /datum/status_effect/buff/twinlink/hawk
		if(/datum/status_effect/buff/guidance)
			return /datum/status_effect/buff/twinlink/guidance
	return null

/datum/action/cooldown/spell/twin_link
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Twin Link"
	desc = "Bind a single ally to yourself. While the two of you remain in sight of one another, any augmentation placed on either of you echoes to the other at half strength. \
	Casting again re-links to a new ally. The bond ends if either of you dies."
	button_icon_state = "guidance"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Geminus Nexus.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/twin_link/cast(atom/cast_on)
	. = ..()
	var/mob/living/H = owner
	if(!isliving(H))
		return FALSE

	if(!isliving(cast_on) || cast_on == H)
		to_chat(H, span_warning("I must bind myself to another living ally!"))
		return FALSE

	var/mob/living/target = cast_on
	if(!target.mind)
		to_chat(H, span_warning("Their mind is too simple to weave a bond with."))
		return FALSE

	var/datum/twin_link/existing = get_twin_link(H)
	if(existing)
		qdel(existing)
	var/datum/twin_link/other = get_twin_link(target)
	if(other)
		qdel(other)

	new /datum/twin_link(H, target)
	H.visible_message("[H] weaves a shimmering thread of arcyne between themselves and [target].")
	to_chat(H, span_notice("I am now twin-linked with [target] - our augmentations will echo between us."))
	to_chat(target, span_notice("A twin link binds me to [H] - their augmentations will echo to me, and mine to them."))
	return TRUE

/atom/movable/screen/alert/status_effect/buff/twinlink
	name = "Twin Link Echo"
	desc = "A weakened echo of an ally's augmentation flows through our bond."
	icon_state = "buff"

/datum/status_effect/buff/twinlink
	alert_type = /atom/movable/screen/alert/status_effect/buff/twinlink
	duration = STAT_BUFF_ALLY_DURATION
	var/outline_colour = "#3aa8ff"

/datum/status_effect/buff/twinlink/on_apply()
	. = ..()
	owner.balloon_alert_to_viewers("<font color='[outline_colour]'>[echo_description()]</font>")

/datum/status_effect/buff/twinlink/proc/echo_description()
	var/list/parts = list()
	for(var/statkey in effectedstats)
		var/amount = effectedstats[statkey]
		parts += "[amount > 0 ? "+" : ""][amount] [capitalize(statkey)]"
	return "twin echo: [parts.Join(", ")]"

/datum/status_effect/buff/twinlink/haste
	id = "twinlink_haste"
	effectedstats = list(STATKEY_SPD = 2)

/datum/status_effect/buff/twinlink/giant
	id = "twinlink_giant"
	effectedstats = list(STATKEY_STR = 2)

/datum/status_effect/buff/twinlink/hawk
	id = "twinlink_hawk"
	effectedstats = list(STATKEY_PER = 2)

/datum/status_effect/buff/twinlink/guidance
	id = "twinlink_guidance"
	effectedstats = list(STATKEY_PER = 2)
