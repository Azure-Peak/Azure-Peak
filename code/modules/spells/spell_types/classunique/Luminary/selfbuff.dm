/datum/action/cooldown/spell/selfbuff
	source_aspect = /datum/magic_aspect/pseudo/luminary
	name = "Divine Arcanum"
	desc = "Improves the reflexes and wrap yourself and up to 3 nearby fellowship party members with soothing arcyne light(you need to be part of a fellowship to receive the effect of this spell, even alone)"
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "guidance"
	sound = 'sound/magic/undivided_perserverance.ogg'
	glow_intensity = 0

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_AURA

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_SKILL

	secondary_resource_type = SPELL_COST_DEVOTION
	secondary_resource_cost = SPELLCOST_MINOR_SKILL

	invocations = list("Blessed Arcynes guide us true!")
	invocation_type = INVOCATION_SHOUT

	charge_required = FALSE
	cooldown_time = 4 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	
	var/buff = 0 // define the baseline number out of the buffing-targeting loop

/datum/action/cooldown/spell/selfbuff/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	
	for(var/mob/living/carbon/target in view(cast_range, get_turf(owner)))
		if(buff >= 4)
			buff = 0
			break
		if(shares_fellowship(H,target)) //shares the same fellowship, also target self
			target.apply_status_effect(/datum/status_effect/buff/lesser_guidance)
			target.apply_status_effect(/datum/status_effect/buff/healingaura)
			buff++
	return TRUE

/atom/movable/screen/alert/status_effect/buff/lesser_guidance
	name = "Awakening"
	desc = "Arcyne energy quickens the Mynd. (+2 Perception)"
	icon_state = "buff"

/datum/status_effect/buff/lesser_guidance
	id = "lesser_guidance"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lesser_guidance
	effectedstats = list(STATKEY_PER = 2)
	duration = 60 SECONDS

/datum/status_effect/buff/lesser_guidance/on_apply()
	. = ..()
	to_chat(owner, span_warning("Blessed Arcynes guides me true!"))

/datum/status_effect/buff/lesser_guidance/on_remove()
	. = ..()
	to_chat(owner, span_warning("Blessed Arcynes seeps out of my control!"))

/atom/movable/screen/alert/status_effect/buff/healingaura
	name = "Recovery"
	desc = "Holy light shoothes the Heart.(very light health regeneration effect)"
	icon_state = "buff"

#define HYBRID_BUFF_FILTER "Hybrid_Buff_Glow"

/datum/status_effect/buff/healingaura

	id = "healingaura"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healingaura
	duration = 100 SECONDS
	var/healing_on_tick = 0.4
	var/outline_colour = "#0abdbd"

/datum/status_effect/buff/healingaura/on_apply()
	. = ..()
	var/filter = owner.get_filter(HYBRID_BUFF_FILTER)
	if (!filter)
		owner.add_filter(HYBRID_BUFF_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 60, "size" = 1))
	return TRUE

/datum/status_effect/buff/healingaura/tick()
	var/obj/effect/temp_visual/heal/H = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	H.color = "#0abdbd"
	if(owner.blood_volume < BLOOD_VOLUME_OKAY)
		owner.blood_volume = min(owner.blood_volume+healing_on_tick, BLOOD_VOLUME_OKAY)
	var/list/wCount = owner.get_wounds()
	if(length(wCount))
		owner.heal_wounds(healing_on_tick, list(/datum/wound/slash, /datum/wound/puncture, /datum/wound/bite, /datum/wound/bruise, /datum/wound/dynamic, /datum/wound/dislocation))
		owner.update_damage_overlays()
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOrganLoss(ORGAN_SLOT_BRAIN, -healing_on_tick)
	owner.adjustCloneLoss(-healing_on_tick, 0)

/datum/status_effect/buff/healingaura/on_remove()
	. = ..()
	owner.remove_filter(HYBRID_BUFF_FILTER)

#undef HYBRID_BUFF_FILTER
