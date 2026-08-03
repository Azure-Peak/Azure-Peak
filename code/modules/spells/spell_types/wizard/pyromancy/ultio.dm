/datum/action/cooldown/spell/ultio
	button_icon = 'icons/mob/actions/mage_pyromancy.dmi'
	name = "Ultio"
	desc = "The caster snaps their finger or hand. The air in a nearby spot excites and shakes with magickal, pyromantic power, spontaneously creating a scorching flame directed at their target, scorching all within.\n\
	Fire spells apply scorched effects - at 4 scorched, an armor piercing wound is applied to the head or chest: whichever you are aiming at, and randomly if aiming elsewhere."
	fluff_desc = "The spell of Ultio were independently reinvented or refined by three traditions, differing largely in the gesture used to cast the spell - \
	The Orthodox Palm-Snap, the Finger-Throw, and the Ranesheni Clap. The orthodox palm-snap is a regular snap, utilizing an arcyne circle of fire at the tip of \
	the middle finger, snapping violently into the palm which contains another circle, to ignite the air, and originated in Grenzelhoft. The finger-throw is a \
	variation, built later on to more precisely control the distance, and weakens the circle on the finger and strengthen the one on the palm, followed by the \
	caster throwing their middle finger forth to point at the desired target - sacrificing cast time for tradition. Finally, the Ranesheni Clap uses both hands - \
	clasping them together before pushing it forward at the target, in an attempt to achieve power and precision both.\n\
	Over time, these gestures has become less and less literal as mages started using staff to assist casting and recapture energy. Nowadays, much of these \
	gestures are projected through virtual hands on the tip of the staff as they cast, but effective caster will often mimic part of the gesture with their grip \
	on the staff to ensure full effectiveness of the spell.\n\
	The Finger-Throw tradition is where the legend of this spell as flipping off an opponent to ignite them on fire comes from."
	button_icon_state = "ultio"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_FIRE
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_PYROMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocations = list("Ultio!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = SPELL_COOLDOWN_POKE

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_LOW

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/impact_delay = TELEGRAPH_SKILLSHOT
	var/strike_damage = 65
	var/scorch_stacks = 2
	displayed_damage = 65

/datum/action/cooldown/spell/ultio/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/target_turf = get_turf(cast_on)
	if(!target_turf)
		return FALSE
	if(!(target_turf in get_hear(cast_range, get_turf(H))))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	new /obj/effect/temp_visual/trap_wall/fire/ultio(target_turf)
	addtimer(CALLBACK(src, PROC_REF(detonate), target_turf, H.zone_selected || BODY_ZONE_CHEST), impact_delay)
	return TRUE

/datum/action/cooldown/spell/ultio/proc/detonate(turf/target_turf, def_zone)
	if(QDELETED(src) || QDELETED(owner) || QDELETED(target_turf))
		return
	var/mob/living/carbon/human/caster = owner
	playsound(target_turf, pick('sound/misc/explode/incendiary (1).ogg', 'sound/misc/explode/incendiary (2).ogg'), 100, TRUE, 4)
	new /obj/effect/temp_visual/spell_impact(target_turf, spell_color, spell_impact_intensity)
	new /obj/effect/temp_visual/dragonfire(target_turf)

	target_turf.fire_act()
	for(var/atom/A in target_turf)
		if(ismob(A))
			continue
		A.fire_act()

	for(var/mob/living/L in target_turf)
		if(L == caster)
			continue
		if(L.anti_magic_check())
			L.visible_message(span_warning("The flames sputter out around [L]!"))
			playsound(target_turf, 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(L, TRUE))
			L.visible_message(span_warning("[L] shrugs off the flames!"))
			continue
		if(istype(caster) && ishuman(L))
			arcyne_strike(caster, L, null, strike_damage, def_zone, BCLASS_BURN, spell_name = "Ultio", damage_type = BURN, skip_animation = TRUE)
		else
			L.adjustFireLoss(strike_damage)
		apply_scorch_stack(L, scorch_stacks, def_zone)

/obj/effect/temp_visual/trap_wall/fire/ultio
	duration = TELEGRAPH_SKILLSHOT
