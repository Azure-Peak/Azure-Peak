/datum/action/cooldown/spell/circumdatum
	button_icon = 'icons/mob/actions/mage_telomancy.dmi'
	name = "Circumdatum"
	desc = "Surrounds an ally with warding orbs instantly. Each reduce an incoming blow's integrity damage by 25% before disintegrating."
	button_icon_state = "circumdatum"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_TELOMANCY

	click_to_activate = TRUE
	self_cast_possible = FALSE
	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Circumdatum!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 15 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

	var/orb_count = 5

/datum/action/cooldown/spell/circumdatum/cast(atom/cast_on)
	. = ..()
	if(!ishuman(cast_on))
		to_chat(owner, span_warning("I can only ward another person!"))
		return FALSE
	var/mob/living/carbon/human/target = cast_on
	target.apply_status_effect(/datum/status_effect/buff/circumdatum, orb_count)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/circumdatum
	name = "Circumdatum"
	desc = "Arcyne orbs circle me,ready to blunt a blow before it lands."
	icon_state = "buff"

/datum/status_effect/buff/circumdatum
	id = "circumdatum"
	duration = 30 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/circumdatum
	var/orbs = 5
	var/list/orb_visuals
	var/last_struck_time = 0

/datum/status_effect/buff/circumdatum/on_creation(mob/living/new_owner, count = 5)
	orbs = count
	return ..()

/datum/status_effect/buff/circumdatum/on_apply()
	. = ..()
	if(!.)
		return
	orb_visuals = list()
	owner.apply_status_effect(/datum/status_effect/buff/iron_skin, duration)
	RegisterSignals(owner, list(COMSIG_MOB_ITEM_BEING_ATTACKED, COMSIG_MOB_ATTACKED_BY_HAND, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HITBY, COMSIG_ATOM_WAS_ATTACKED), PROC_REF(on_struck))
	for(var/i in 1 to orbs)
		var/obj/effect/circumdatum_orb/orb = new()
		orb_visuals += orb
		owner.vis_contents += orb
		spin_orb(orb, (i - 1) * (360 / orbs))
	owner.balloon_alert_to_viewers("<font color='[GLOW_COLOR_ARCANE]'>warded!</font>")

/datum/status_effect/buff/circumdatum/proc/spin_orb(obj/effect/orb, phase)
	var/radius = 16
	var/segments = 12
	var/seg_time = 1.2
	orb.pixel_x = round(radius * cos(phase))
	orb.pixel_y = round(radius * sin(phase))
	for(var/s in 1 to segments)
		var/a = phase + (s * (360 / segments))
		if(s == 1)
			animate(orb, pixel_x = round(radius * cos(a)), pixel_y = round(radius * sin(a)), time = seg_time, loop = -1, flags = ANIMATION_PARALLEL)
		else
			animate(pixel_x = round(radius * cos(a)), pixel_y = round(radius * sin(a)), time = seg_time)

/datum/status_effect/buff/circumdatum/proc/on_struck(datum/source, mob/living/struck, mob/living/attacker, obj/item/weapon)
	SIGNAL_HANDLER
	if(world.time == last_struck_time)
		return
	last_struck_time = world.time
	deplete_orb()

/datum/status_effect/buff/circumdatum/proc/deplete_orb()
	orbs = max(0, orbs - 1)
	if(length(orb_visuals))
		var/obj/effect/spent = orb_visuals[length(orb_visuals)]
		orb_visuals -= spent
		if(owner)
			owner.vis_contents -= spent
		if(!QDELETED(spent))
			qdel(spent)
	if(orbs <= 0)
		owner.remove_status_effect(/datum/status_effect/buff/circumdatum)

/datum/status_effect/buff/circumdatum/on_remove()
	UnregisterSignal(owner, list(COMSIG_MOB_ITEM_BEING_ATTACKED, COMSIG_MOB_ATTACKED_BY_HAND, COMSIG_ATOM_BULLET_ACT, COMSIG_ATOM_HITBY, COMSIG_ATOM_WAS_ATTACKED))
	owner.remove_status_effect(/datum/status_effect/buff/iron_skin)
	for(var/obj/effect/orb in orb_visuals)
		if(owner)
			owner.vis_contents -= orb
		if(!QDELETED(orb))
			qdel(orb)
	orb_visuals = null
	. = ..()

/obj/effect/circumdatum_orb
	name = "arcyne orb"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "seeker_orb"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	vis_flags = VIS_INHERIT_PLANE
