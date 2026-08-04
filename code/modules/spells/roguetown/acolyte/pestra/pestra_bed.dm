/datum/action/cooldown/spell/summon_bed/pestra
	name = "Pestra's Rest"
	desc = "Summon a bed of black rose petals to tend to the deceased and punish non-believers. \
	You can only maintain 1 bed at a time. Prevents deadite infection from reanimating corpses laid on the bed."
	background_icon = 'icons/mob/actions/pestraspells.dmi'
	button_icon = 'icons/mob/actions/pestraspells.dmi'
	button_icon_state = "pestrabed"
	sound = 'sound/magic/slimesquish.ogg'
	spell_color = "#4a0d66"
	invocations = list("Pestra, provide sanctuary for the dead.")
	bed_type = /obj/structure/bed/rogue/sanctuary/pestra
	scale_with_skill = FALSE
	base_max_beds = 1

/obj/structure/bed/rogue/sanctuary/pestra
	name = "ghastly petals"
	desc = "A bed comprised of black rose petals. Said to harm the living, but reverse decomposition for the dead."
	icon_state = "pestra"
	status_effect_type = /datum/status_effect/buff/healing/bed_rest/pestra
	sleepy = 1.5 // same as a straw bed

/obj/structure/bed/rogue/sanctuary/pestra/calculate_priority(mob/living/L)
	if(L.stat == DEAD)
		return 1000 + L.getBruteLoss() + L.getFireLoss()

	return L.getBruteLoss() + L.getFireLoss()

/datum/status_effect/buff/healing/bed_rest/pestra
	id = "pestra_bed"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/pestra_bed
	outline_colour = "#4a0d66"
	healing_on_tick = 4

/atom/movable/screen/alert/status_effect/buff/healing/pestra_bed
	name = "Pestra's black petals"
	desc = "The cold petals underneath me cause a strange sensation in my flesh."
	icon_state = "pestrabed"

/datum/status_effect/buff/healing/bed_rest/pestra/tick()
	if(!owner)
		return

	spawn_visual()

	if(owner.stat != DEAD && ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/is_protected = (H.patron?.type == /datum/patron/divine/pestra && owner.get_skill_level(/datum/skill/magic/holy) >= 1)

		if(is_protected)
			return

		if(prob(15))
			to_chat(owner, span_danger("You feel like your vitality is being sapped!"))
		owner.adjustBruteLoss(2, 0)
		owner.adjustToxLoss(1, 0)
		return

	// reached only if dead
	owner.heal_wounds(healing_on_tick)
	owner.adjustBruteLoss(-healing_on_tick, 0)
	owner.adjustFireLoss(-healing_on_tick, 0)
	owner.adjustToxLoss(-healing_on_tick, 0)
	owner.adjustOxyLoss(-healing_on_tick, 0)

	if(owner.blood_volume < BLOOD_VOLUME_OKAY)
		owner.blood_volume = min(owner.blood_volume + (healing_on_tick * 2), BLOOD_VOLUME_OKAY)
