// Scare Beast

/datum/action/cooldown/spell/lamplighter/scare_beast
	name = "Scare Beast"
	desc = "Wave your staff towards a beast, sending fear into its heart with biting flames!"
	button_icon = 'icons/mob/actions/classuniquespells/lamplighter.dmi'
	button_icon_state = "scarebeast"
	sound = 'sound/misc/smelter_sound3.ogg'
	click_to_activate = TRUE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE
	invocations = list("Flee!")
	invocation_type = INVOCATION_SHOUT
	charge_required = FALSE
	cooldown_time = 10 SECONDS
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/lamplighter/scare_beast/cast(atom/cast_on)
	. = ..()
	var/mob/living/spelltarget = cast_on
	if(!isliving(cast_on))
		return FALSE
	if(!spelltarget.mind && spelltarget.ai_controller)
		spelltarget.ai_controller.set_blackboard_key(BB_BASIC_MOB_FLEEING, TRUE)
		spelltarget.ai_controller.CancelActions()
		return TRUE

// Soothe the Soul

#define SOOTHE_FILTER "soothe_glow"

/datum/action/cooldown/spell/lamplighter/sooth_the_soul
	name = "Soothe the Soul"
	desc = "Surround yourself or your target with soothing warmth, restoring their energy for thirty seconds."
	button_icon = 'icons/mob/actions/classuniquespells/lamplighter.dmi'
	button_icon_state = "soothe"
	sound = 'sound/misc/smelter_sound3.ogg'
	click_to_activate = TRUE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE
	invocations = list()
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 2 MINUTES
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/lamplighter/sooth_the_soul/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/spelltarget = cast_on
	spelltarget.apply_status_effect(/datum/status_effect/buff/sooth_the_soul)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/sooth_the_soul
	name = "Soothe the Soul"
	desc = "Comforting warmth restores my energy."
	icon_state = "buff"

/datum/status_effect/buff/sooth_the_soul
	id = "soothe the soul"
	alert_type = /atom/movable/screen/alert/status_effect/buff/sooth_the_soul
	duration = 40 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/buff/sooth_the_soul/on_apply()
	. = ..()
	owner.add_filter(SOOTHE_FILTER, 2, list("type" = "outline", "color" = "#ff7300", "alpha" = 60, "size" = 1))

/datum/status_effect/buff/sooth_the_soul/on_remove()
	owner.remove_filter(SOOTHE_FILTER)
	. = ..()

/datum/status_effect/buff/sooth_the_soul/tick()
	owner.energy_add(5)

#undef SOOTHE_FILTER

// Bulwark of Oil

#define BULWARK_FILTER "bulwark_glow"

/datum/action/cooldown/spell/lamplighter/bulwark_of_oil
	name = "Bulwark of Oil"
	desc = "Surround yourself or your target with a wreath of burning oil, intercepting three attacks and applying an oil stack and ten burn damage to the attacker."
	button_icon = 'icons/mob/actions/classuniquespells/lamplighter.dmi'
	button_icon_state = "oilshield"
	sound = 'sound/misc/smelter_sound2.ogg'
	click_to_activate = TRUE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocations = list()
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 90 SECONDS
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/lamplighter/bulwark_of_oil/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(!isliving(cast_on))
		return FALSE
	var/mob/living/spelltarget = cast_on
	spelltarget.apply_status_effect(/datum/status_effect/buff/bulwark_of_oil)
	return TRUE

// Bulwark of Oil - Buff

/atom/movable/screen/alert/status_effect/buff/bulwark_of_oil
	name = "Bulwark of Oil"
	desc = "I will be shielded from three melee attacks, each doing ten burn damage and applying an oil stack to the attacker."
	icon_state = "buff"

/datum/status_effect/buff/bulwark_of_oil
	id = "bulwark of oil"
	alert_type = /atom/movable/screen/alert/status_effect/buff/bulwark_of_oil
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	var/defend = 3

/datum/status_effect/buff/bulwark_of_oil/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED, PROC_REF(weapon_defend))
	RegisterSignal(owner, COMSIG_MOB_ATTACKED_BY_HAND, PROC_REF(unarmed_defend))
	owner.add_filter(BULWARK_FILTER, 2, list("type" = "outline", "color" = "#ff7300", "alpha" = 100, "size" = 2))
	owner.balloon_alert_to_viewers("<font color='#FF4500'>oil bulwark!</font>")

/datum/status_effect/buff/bulwark_of_oil/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_ITEM_BEING_ATTACKED)
	owner.remove_filter(BULWARK_FILTER)
	. = ..()

/datum/status_effect/buff/bulwark_of_oil/proc/weapon_defend(mob/living/parent, mob/living/target, mob/user)
	var/mob/living/carbon/human/H = user
	if(user == target)
		return
	if(user != H)
		return
	if(defend == 0)
		owner.remove_status_effect(/datum/status_effect/buff/bulwark_of_oil)
		return
	if(H.has_status_effect(/datum/status_effect/debuff/oil_stack))
		var/datum/status_effect/debuff/oil_stack/o = H.has_status_effect(/datum/status_effect/debuff/oil_stack)
		apply_scorch_stack(H, 1)
		o.add_stacks(1)
		H.adjustFireLoss(10)
		defend = defend - 1
		owner.balloon_alert_to_viewers("<font color='#FF4500'>blocked! [defend]/3</font>")
		playsound(get_turf(owner), 'sound/combat/parry/deflect_6.ogg', 40, TRUE)
		return COMPONENT_NO_ATTACK
	else
		apply_scorch_stack(H, 1)
		H.adjustFireLoss(10)
		H.apply_status_effect(/datum/status_effect/debuff/oil_stack)
		defend = defend - 1
		owner.balloon_alert_to_viewers("<font color='#FF4500'>blocked! [defend]/3</font>")
		playsound(get_turf(owner), 'sound/combat/parry/deflect_6.ogg', 40, TRUE)
		return COMPONENT_NO_ATTACK


/datum/status_effect/buff/bulwark_of_oil/proc/unarmed_defend(mob/living/carbon/human/parent, mob/living/carbon/human/attacker, mob/living/carbon/human/defender)
	var/mob/living/carbon/human/H = attacker
	if(defender == attacker)
		return
	if(defend == 0)
		owner.remove_status_effect(/datum/status_effect/buff/bulwark_of_oil)
		return
	if(H.has_status_effect(/datum/status_effect/debuff/oil_stack))
		var/datum/status_effect/debuff/oil_stack/o = H.has_status_effect(/datum/status_effect/debuff/oil_stack)
		o.add_stacks(1)
		H.adjustFireLoss(10)
		defend = defend - 1
		owner.balloon_alert_to_viewers("<font color='#FF4500'>blocked! [defend]/3</font>")
		playsound(get_turf(owner), 'sound/combat/parry/deflect_6.ogg', 40, TRUE)
		return COMPONENT_HAND_NO_ATTACK
	else
		H.adjustFireLoss(10)
		H.apply_status_effect(/datum/status_effect/debuff/oil_stack)
		defend = defend - 1
		owner.balloon_alert_to_viewers("<font color='#FF4500'>blocked! [defend]/3</font>")
		playsound(get_turf(owner), 'sound/combat/clash_struck.ogg', 40, TRUE)
		playsound(get_turf(owner), 'sound/surgery/cautery2.ogg', 40, TRUE)
		return COMPONENT_HAND_NO_ATTACK


#undef BULWARK_FILTER

// Smoke Food

/datum/action/cooldown/spell/lamplighter/smoke_food
	name = "Smoke Food"
	desc = "Smoke food with your lamptern, increasing its lifespan."
	button_icon = 'icons/mob/actions/classuniquespells/lamplighter.dmi'
	button_icon_state = "smokefood"
	sound = 'sound/misc/smelter_sound2.ogg'
	click_to_activate = TRUE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocations = list()
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 90 SECONDS
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/lamplighter/smoke_food/cast(atom/cast_on)
	. = ..()
	if(!istype(cast_on, /obj/item/reagent_containers/food/snacks))
		to_chat(owner, span_warning("That is not food."))
		return FALSE

	var/obj/item/reagent_containers/food/snacks/food = cast_on

	if(!food.rotprocess)
		to_chat(owner, span_warning("[food] does not spoil."))
		return FALSE

	// Same as chill food, but we use fire. Waow.
	food.warming += 15 MINUTES
	food.add_filter("smokefood_glow", 2, list("type" = "outline", "color" = "#5c362f", "alpha" = 150, "size" = 1))
	food.name = "[food.name] (smoked)"
	new /obj/effect/temp_visual/small_smoke(get_turf(food))
	owner.visible_message(span_notice("[owner] holds their lamptern to [food]. The heat and smoke from the lamptern preserving the food."), span_notice("I smoke [food] with my lamptern."))
	return TRUE

// Anoint Foe

/datum/action/cooldown/spell/lamplighter/anoint_foe
	name = "Anoint Foe"
	desc = "Swing your staff forward, splashing oil in an arc and applying 2 oil stacks. Can be alt cast to open the lamptern instead and activate the oil stacks of those it hits. Each stack does five burn damage when activate, at five and twenty stacks you apply vulnerable and expose respectively."
	button_icon_state = "oilsplash"
	invocations = list("Splash!")
	blade_class = BCLASS_BURN
	windup_time = TELEGRAPH_DODGEABLE
	sweep_step = 0
	damage = 15
	parent_type = /datum/action/cooldown/spell/telegraphed_strike
	click_to_activate = TRUE
	button_icon = 'icons/mob/actions/classuniquespells/lamplighter.dmi'
	sound = 'sound/misc/fire_place.ogg'
	strike_sound = 'sound/misc/smelter_sound2.ogg'
	glow_intensity = GLOW_INTENSITY_HIGH
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_AOE
	cooldown_time = 10 SECONDS
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	telegraph_type = /obj/effect/temp_visual/special_intent/warning
	swipe_state = "flame"
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN
	var/ignite = FALSE

/datum/action/cooldown/spell/lamplighter/anoint_foe/get_sweep_bands()
	return list(
		list(list(0, 1), list(0, 2)),
	)

/datum/action/cooldown/spell/lamplighter/anoint_foe/get_pattern_offsets()
	var/list/flat = list()
	for(var/list/band in get_sweep_bands())
		flat += band
	return flat

/datum/action/cooldown/spell/lamplighter/anoint_foe/on_hit_target(mob/living/carbon/human/H, mob/living/L, facing)
	apply_scorch_stack(L, 1)
	var/datum/status_effect/debuff/oil_stack/o = L.has_status_effect(/datum/status_effect/debuff/oil_stack)
	if(ignite && L.has_status_effect(/datum/status_effect/debuff/oil_stack))
		o.activate()
		L.adjustFireLoss(15)
		return
	if(L.has_status_effect(/datum/status_effect/debuff/oil_stack))
		o.add_stacks(1)
		L.adjustFireLoss(15)
	else
		L.adjustFireLoss(15)
		L.apply_status_effect(/datum/status_effect/debuff/oil_stack)
		return

/datum/action/cooldown/spell/lamplighter/anoint_foe/toggle_alt_mode(mob/user)
	ignite = !ignite
	if(ignite)
		to_chat(user, span_notice("Anoint foe will now activate oil stacks on hit."))
	else
		to_chat(user, span_notice("Anoint foe will no longer activate oil stacks on hit."))
	update_ignite_maptext()
	return TRUE

/datum/action/cooldown/spell/lamplighter/anoint_foe/proc/update_ignite_maptext()
	for(var/datum/hud/hud as anything in viewers)
		var/atom/movable/screen/movable/action_button/B = viewers[hud]
		var/atom/movable/screen/arc_maptext_holder/holder
		for(var/atom/movable/screen/arc_maptext_holder/existing in B.vis_contents)
			holder = existing
			break
		if(!holder)
			holder = new(B)
			B.vis_contents.Add(holder)
		if(ignite)
			holder.maptext = MAPTEXT("IGNITE")
			holder.color = "#FF4500"
		else
			holder.maptext = null

// Light the Wicks

/datum/action/cooldown/spell/lamplighter/wicklight
	name = "Light the Wicks"
	desc = "Ignite any flammables in a 7x7 tile radius around yourself. Be careful."
	button_icon_state = "wicks"
	invocations = list("Light!")
	parent_type = /datum/action/cooldown/spell/telegraphed_strike
	button_icon = 'icons/mob/actions/classuniquespells/lamplighter.dmi'
	sound = 'sound/misc/fire_place.ogg'
	strike_sound = 'sound/misc/smelter_sound2.ogg'
	glow_intensity = GLOW_INTENSITY_HIGH
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_AOE
	cooldown_time = 30 SECONDS
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/lamplighter/wicklight/cast(atom/cast_on)
	. = ..()

	if(!ishuman(owner))
		return FALSE
	for(var/obj/O in range(7, owner))
		if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
			continue
		if(istype(O, /obj/item/flashlight/flare/light))
			qdel(O)
		O.spark_act()

	for(var/mob/M in range(7, owner))
		for(var/obj/O in M.contents)
			if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
				continue
			if(istype(O, /obj/item/flashlight/flare/light))
				qdel(O)
			O.spark_act()
	owner.visible_message(span_red("[owner] releases a flickering wave of heat that ignites lights around them!"))
	return TRUE

// ULT - Provide Beacon

#define PROVIDE_BEACON_SLOWDOWN_ID "beacon_slowdown"
#define BEACON_FILTER "beacon_filter"

/datum/action/cooldown/spell/lamplighter/provide_beacon
	name = "Provide Beacon"
	desc = "Raise your lamptern high, taking fire stacks every five seconds over the course of fourty seconds, every five seconds anyone around you regenerates energy. You do NOT gain resistance against the fire, be ready to pat the flames out."
	button_icon = 'icons/mob/actions/classuniquespells/lamplighter.dmi'
	button_icon_state = "beacon"
	sound = 'sound/misc/smelter_sound2.ogg'
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_NONE
	primary_resource_cost = 0
	invocations = list()
	invocation_type = INVOCATION_SHOUT
	charge_required = FALSE
	cooldown_time = 10 MINUTES
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lampwarden, /obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN

	var/channel_duration = 40 SECONDS
	var/pulse_interval = 5 SECONDS
	var/channel_slowdown = 3
	var/beacon_range = 7

/datum/action/cooldown/spell/lamplighter/provide_beacon/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/end_time = world.time + channel_duration

	H.visible_message(span_danger("<b>[H] unleashes a wave of restoring warmth!</b>"))
	playsound(get_turf(H), 'sound/misc/smelter_sound3.ogg', 100, TRUE)
	H.add_movespeed_modifier(PROVIDE_BEACON_SLOWDOWN_ID, update = TRUE, priority = 100, multiplicative_slowdown = channel_slowdown, movetypes = GROUND)
	H.add_filter(BEACON_FILTER, 2, list("type" = "outline", "color" = "#ff7300", "alpha" = 100, "size" = 2))
	StartCooldown(get_adjusted_cooldown())

	while(world.time < end_time)
		if(!channel_valid(H))
			end_channel(H, TRUE)
			return TRUE

		fire_pulse(H)
		H.adjust_fire_stacks(5)
		H.ignite_mob()
		H.balloon_alert_to_viewers("<font color='#FF4500'>channeling!</font>")
		playsound(get_turf(H), 'sound/misc/smelter_sound3.ogg', 100, TRUE)

		new /obj/effect/temp_visual/spell_impact(get_turf(H), spell_color, spell_impact_intensity)
		sleep(pulse_interval)

	end_channel(H, FALSE)
	return TRUE

/datum/action/cooldown/spell/lamplighter/provide_beacon/proc/end_channel(mob/living/carbon/human/H, interrupted)
	if(H)
		H.remove_movespeed_modifier(PROVIDE_BEACON_SLOWDOWN_ID)
		H.remove_filter(BEACON_FILTER)
	if(interrupted)
		if(H)
			to_chat(H, span_warning("My beacon falters!"))
			H.balloon_alert_to_viewers("<font color='#FF4500'>interrupted!</font>")

/datum/action/cooldown/spell/lamplighter/provide_beacon/proc/channel_valid(mob/living/carbon/human/H)
	if(QDELETED(H))
		return FALSE
	if(H.stat != CONSCIOUS)
		return FALSE
	if(H.IsParalyzed() || H.IsStun() || H.IsKnockdown() || H.IsUnconscious())
		return FALSE
	if(H.pulledby)
		return FALSE
	return TRUE

/datum/action/cooldown/spell/lamplighter/provide_beacon/proc/fire_pulse(mob/living/carbon/human/H)
	for(var/mob/living/carbon/human/human in view(7, get_turf(owner)))
		human.energy_add(100)
		new /obj/effect/temp_visual/spell_impact(get_turf(human), spell_color, spell_impact_intensity)
	return

#undef BEACON_FILTER
#undef PROVIDE_BEACON_SLOWDOWN_ID
