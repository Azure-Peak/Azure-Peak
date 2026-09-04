/// CAUTERIZE

/datum/action/cooldown/spell/lamplighter/cauterize
	name = "Cauterize"
	desc = "Use the heat of your staff to cauterize someones wounds."
	overlay_icon = 'icons/mob/actions/genericmiracles.dmi'
	button_icon_state = "woundheal"
	sound = 'sound/surgery/cautery1.ogg'
	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE
	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY
	invocation_type = INVOCATION_NONE
	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM // No doing this while gingerbreadmanning
	cooldown_time = 3 MINUTES
	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	associated_skill = /datum/skill/combat/staves
	spell_color = GLOW_COLOR_FIRE

/datum/action/cooldown/spell/lamplighter/cauterize/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/HU = owner
	if(!istype(HU))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(ishuman(spelltarget))

		var/mob/living/carbon/human/target = spelltarget
		var/def_zone = check_zone(owner.zone_selected)
		var/obj/item/bodypart/affecting = target.get_bodypart(def_zone)

		if(!affecting)
			return FALSE
		if(length(affecting.embedded_objects))
			var/no_embeds = TRUE
			for(var/object in affecting.embedded_objects)
				if(!istype(object, /obj/item/natural/worms/leech))	//Leeches and surgical cheeles are made an exception.
					no_embeds = FALSE
			if(!no_embeds)
				to_chat(owner, span_warning("We cannot cauterize wounds with objects inside this limb!"))
				return FALSE
		/*if(!do_after(owner, (delay - (0.5 SECONDS * HU.get_skill_level(associated_skill)))))
			to_chat(owner, span_warning("We were interrupted!"))
			return FALSE*/ //Witty wants this to have no doafter, but I can put it back if its a problem
		var/foundwound = FALSE
		if(length(affecting.wounds))
			for(var/datum/wound/wound in affecting.wounds)
				if(!isnull(wound) && wound.can_cauterize)
					wound.heal_wound()
					foundwound = TRUE
					owner.visible_message(("<font color = '#FF4500'>[capitalize(wound.name)] cauterizes from the heat of the lamp!</font>"))
					affecting.add_wound(/datum/wound/lampcautery)
					target.adjustFireLoss(10)
			if(foundwound)
				playsound(target, 'sound/surgery/cautery1.ogg', 100, TRUE)
			affecting.change_bodypart_status(BODYPART_ORGANIC, heal_limb = TRUE)
			affecting.update_disabled()
			return TRUE
		else
			to_chat(owner, span_warning("The limb is free of wounds."))
			return FALSE
	return FALSE

/// INFLAMED STRIKE

/datum/action/cooldown/spell/lamplighter/firestrike
	name = "Inflamed Strike"
	desc = "Twirl your staff infront of you, dealing damage and applying an oil stack. Can be alt cast with Shift + G to activate stacks instead of applying them"
	button_icon_state = "falling_crescent"
	invocations = list("Burn!", "Ignite!", "Scorch!")
	blade_class = BCLASS_BLUNT
	windup_time = TELEGRAPH_DODGEABLE
	sweep_step = 0
	damage = 45
	parent_type = /datum/action/cooldown/spell/telegraphed_strike
	click_to_activate = TRUE
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	sound = 'sound/misc/fire_place.ogg'
	strike_sound = 'sound/misc/smelter_sound2.ogg'
	glow_intensity = GLOW_INTENSITY_HIGH
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_AOE
	cooldown_time = 20 SECONDS
	charging_slowdown = 1
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	telegraph_type = /obj/effect/temp_visual/special_intent/warning
	swipe_state = "flame"
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN
	var/ignite = FALSE

/datum/action/cooldown/spell/lamplighter/firestrike/get_sweep_bands()
	return list(
		list(list(1, 1)),
		list(list(0, 1)),
		list(list(-1, 1)),
	)

/datum/action/cooldown/spell/lamplighter/firestrike/get_pattern_offsets()
	var/list/flat = list()
	for(var/list/band in get_sweep_bands())
		flat += band
	return flat

/datum/action/cooldown/spell/lamplighter/firestrike/on_hit_target(mob/living/carbon/human/H, mob/living/L, facing)
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

/datum/action/cooldown/spell/lamplighter/firestrike/toggle_alt_mode(mob/user)
	ignite = !ignite
	if(ignite)
		to_chat(user, span_notice("Inflamed Strike will now activate oil stacks on hit."))
	else
		to_chat(user, span_notice("Inflamed strike will no longer activate oil stacks on hit."))
	update_ignite_maptext()
	return TRUE

/datum/action/cooldown/spell/lamplighter/firestrike/proc/update_ignite_maptext()
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

/// FUEL THE BURN

/datum/action/cooldown/spell/lamplighter/firespin
	name = "Fuel The Burn"
	desc = "Twirl your staff around you, engulfing people around you in flame."
	button_icon_state = "falling_crescent"
	invocations = list("To cinders!", "To ashes!", "To dust!")
	blade_class = BCLASS_BURN
	windup_time = TELEGRAPH_DODGEABLE
	sweep_step = 0
	damage = 30
	parent_type = /datum/action/cooldown/spell/telegraphed_strike
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	sound = 'sound/misc/fire_place.ogg'
	strike_sound = 'sound/misc/smelter_sound2.ogg'
	glow_intensity = GLOW_INTENSITY_HIGH
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE
	cooldown_time = 30 SECONDS
	charging_slowdown = 1
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	telegraph_type = /obj/effect/temp_visual/special_intent/warning
	swipe_state = "flame"
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/lamplighter/firespin/get_sweep_bands()
	return list(
		list(list(1, 1), list(1, 0), list(1, -1)),
		list(list(0, 1), list(0, -1)),
		list(list(-1, 1), list(-1, 0), list(-1, -1)),
	)

/datum/action/cooldown/spell/lamplighter/firespin/get_pattern_offsets()
	var/list/flat = list()
	for(var/list/band in get_sweep_bands())
		flat += band
	return flat

/datum/action/cooldown/spell/lamplighter/firespin/on_hit_target(mob/living/carbon/human/H, mob/living/L, facing)
	var/datum/status_effect/debuff/oil_stack/o = L.has_status_effect(/datum/status_effect/debuff/oil_stack)
	if(L.has_status_effect(/datum/status_effect/debuff/oil_stack))
		o.add_stacks(1)
		L.adjustFireLoss(15)
	else
		L.adjustFireLoss(15)
		L.apply_status_effect(/datum/status_effect/debuff/oil_stack)
		return

/// TO BRING LIGHT

#define EMPOWER_FILTER "empower_glow"

/datum/action/cooldown/spell/lamplighter/oil_spill
	name = "To Bring Light"
	desc = "Open up your lamptern staff, spilling oil on the next person you strike with it and applying an Oil Stack. Each stack does five burn damage when activate, at five and twenty stacks you apply vulnerable and expose respectively."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "empower_weapon"
	sound = 'sound/misc/smelter_sound2.ogg'
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocations = list()
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN


/datum/action/cooldown/spell/lamplighter/oil_spill/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(H.has_status_effect(/datum/status_effect/buff/oil_spill))
		to_chat(H, span_warning("The lamptern is already ready to spill!"))
		return FALSE

	H.apply_status_effect(/datum/status_effect/buff/oil_spill)
	H.visible_message(
		span_danger("[H] opens up their lamptern, ready to splash oil!"),
		span_notice("I open up my lamptern, readying myself to splash oil."))

	return TRUE

// To Bring Light - Buff

/atom/movable/screen/alert/status_effect/buff/oil_spill
	name = "Lamptern Open"
	desc = "My next melee strike will apply an oil stack."
	icon_state = "buff"

/datum/status_effect/buff/oil_spill
	id = "lamptern open"
	alert_type = /atom/movable/screen/alert/status_effect/buff/oil_spill
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/buff/oil_spill/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	owner.add_filter(EMPOWER_FILTER, 2, list("type" = "outline", "color" = "#FF4500", "alpha" = 200, "size" = 2))
	owner.balloon_alert_to_viewers("<font color='#FF4500'>lamptern open!</font>")

/datum/status_effect/buff/oil_spill/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	owner.remove_filter(EMPOWER_FILTER)
	. = ..()

/datum/status_effect/buff/oil_spill/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(target == owner || target.stat == DEAD)
		return
	consume_empower(target)
	return

/datum/status_effect/buff/oil_spill/proc/consume_empower(mob/living/hit_target)
	playsound(get_turf(owner), 'sound/misc/fire_place.ogg', 40, TRUE)
	owner.visible_message(
		span_danger("[owner]'s splashes oil forward with their strike!"),
		span_notice("I coat [hit_target] in oil!"))
	owner.remove_status_effect(/datum/status_effect/buff/oil_spill)
	if(!hit_target.has_status_effect(/datum/status_effect/debuff/oil_stack))
		hit_target.apply_status_effect(/datum/status_effect/debuff/oil_stack)
	else
		var/datum/status_effect/debuff/oil_stack/o = hit_target.has_status_effect(/datum/status_effect/debuff/oil_stack)
		o.add_stacks(1)

#undef EMPOWER_FILTER

/// OIL STACKS

/atom/movable/screen/alert/status_effect/debuff/oil_stack
	name = "Oil Stack (0)"
	desc = "I'm covered in oil! If ignited by a Lamplighter I will take five burn damage for each stack, and at five and twenty stacks I will be made vulnerable and exposed respectively! I can cleanse these by washing off."
	icon_state = "debuff"

/datum/status_effect/debuff/oil_stack
	id = "oil_stack"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/oil_stack
	duration = 1200
	status_type = STATUS_EFFECT_UNIQUE
	var/stacks = 1

/datum/status_effect/debuff/oil_stack/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT, PROC_REF(cleanse))
	RegisterSignal(owner, COMSIG_ATOM_FIRE_ACT, PROC_REF(activate))
	owner.balloon_alert_to_viewers("<font color='#FF4500'>oil coated!</font>")

/datum/status_effect/buff/oil_spill/on_remove()
	UnregisterSignal(owner, COMSIG_COMPONENT_CLEAN_ACT)
	UnregisterSignal(owner, COMSIG_ATOM_FIRE_ACT)
	. = ..()

/datum/status_effect/debuff/oil_stack/proc/add_stacks(amount)
	var/old_stacks = stacks
	stacks = stacks + amount
	owner.balloon_alert_to_viewers("<font color='#FF4500'>[stacks]</font>")
	linked_alert.name = "Oil Stack ([stacks])"
	duration = 1200
	if(stacks == old_stacks)
		return

/datum/status_effect/debuff/oil_stack/proc/cleanse()
	to_chat(owner, span_nicegreen("I'm rid of this oil, finally!"))
	owner.balloon_alert_to_viewers("<font color='#80ff86'>stacks cleansed!</font>")
	owner.remove_status_effect(/datum/status_effect/debuff/oil_stack)

/datum/status_effect/debuff/oil_stack/proc/activate()
	SIGNAL_HANDLER
	owner.balloon_alert_to_viewers("<font color='#FF4500'>stacks ignited!!</font>")
	if(stacks >= 20)
		owner.apply_status_effect(/datum/status_effect/debuff/exposed)
		owner.adjustFireLoss(5*stacks)
		owner.remove_status_effect(/datum/status_effect/debuff/oil_stack)
		return
	if(stacks >= 5)
		owner.apply_status_effect(/datum/status_effect/debuff/vulnerable)
		owner.adjustFireLoss(5*stacks)
		owner.remove_status_effect(/datum/status_effect/debuff/oil_stack)
		return
	else
		owner.adjustFireLoss(5*stacks)
		owner.remove_status_effect(/datum/status_effect/debuff/oil_stack)
		return

/// ULT - BURN IT ALL DOWN

#define ULT_FILTER "ult_glow"

/datum/action/cooldown/spell/lamplighter/burn_it_down
	name = "Burn It All Down"
	desc = "Instantly ignite yourself at <b>maximum fire stacks</b>. For two minutes you are immune to fire damage, then for two minutes after you take half fire damage. For six minutes after casting apply an oil stack for <b>every melee hit</b>. The fire does not end when your immunity does."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "empower_weapon"
	sound = 'sound/misc/smelter_sound2.ogg'
	click_to_activate = FALSE
	self_cast_possible = TRUE
	primary_resource_type = SPELL_COST_NONE
	primary_resource_cost = 0
	invocations = list("LETS BURN IT ALL DOWN!!")
	invocation_type = INVOCATION_SHOUT
	charge_required = FALSE
	cooldown_time = 20 MINUTES
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_skill = /datum/skill/combat/staves
	required_items = list(/obj/item/rogueweapon/woodstaff/quarterstaff/lamplighter)
	spell_color = GLOW_COLOR_FIRE
	spell_requirements = SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/lamplighter/burn_it_down/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.apply_status_effect(/datum/status_effect/buff/burn_it_down)
	H.visible_message(
		span_warningbig("[H] lets out a shout, engulfing themself in flames!"),
		span_warningbig("I cover myself in oil and engulf myself flames, lets get to work!"))

	return TRUE

// Burn It Down - Buff

/atom/movable/screen/alert/status_effect/buff/burn_it_down
	name = "BURN IT ALL DOWN!!"
	desc = "LETS DO THIS!!"
	icon_state = "buff"

/datum/status_effect/buff/burn_it_down
	id = "burn it down"
	alert_type = /atom/movable/screen/alert/status_effect/buff/burn_it_down
	effectedstats = list(STATKEY_CON = 1, STATKEY_WIL = 2, STATKEY_STR = 2)
	duration = 5 MINUTES // realistically we're only getting 4ish minutes out of this before we die
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/buff/burn_it_down/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_MOB_ITEM_ATTACK, PROC_REF(on_attack))
	RegisterSignal(owner, COMSIG_LIVING_EXTINGUISHED, PROC_REF(on_extinguish))
	owner.add_filter(ULT_FILTER, 2, list("type" = "outline", "color" = "#FF4500", "alpha" = 200, "size" = 2))
	owner.balloon_alert_to_viewers("<font color='#FF4500'>IGNITED!!</font>")
	addtimer(CALLBACK(src, PROC_REF(downgrade)), 3 MINUTES)
	ADD_TRAIT(owner, TRAIT_FIRE_IMMUNE, "burnitdown")
	ADD_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, "burnitdown")
	ADD_TRAIT(owner, TRAIT_NOFIREDECAY, "burnitdown")
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, "burnitdown")
	owner.adjust_fire_stacks(20)
	owner.ignite_mob()

/datum/status_effect/buff/burn_it_down/on_remove()
	UnregisterSignal(owner, COMSIG_MOB_ITEM_ATTACK)
	UnregisterSignal(owner, COMSIG_LIVING_EXTINGUISHED)
	owner.remove_filter(ULT_FILTER)
	REMOVE_TRAIT(owner, TRAIT_NOFIREDECAY, "burnitdown")
	REMOVE_TRAIT(owner, TRAIT_IGNOREDAMAGESLOWDOWN, "burnitdown")
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, "burnitdown")
	REMOVE_TRAIT(owner, TRAIT_FIRE_RESIST, "burnitdown")
	owner.balloon_alert_to_viewers("<font color='#FF4500'>smoldering!</font>")
	. = ..()

/datum/status_effect/buff/burn_it_down/proc/on_extinguish()
	owner.balloon_alert_to_viewers("<font color='#47a7e7'>extinguished!</font>")
	owner.remove_status_effect(/datum/status_effect/buff/burn_it_down)
	return

/datum/status_effect/buff/burn_it_down/proc/downgrade()
	owner.balloon_alert_to_viewers("<font color='#FF4500'>weakening!</font>")
	owner.visible_message(
		span_warningbig("[owner] lets out a scream as their spell weakens!"),
		span_warningbig("My spell weakens, the fires scorch me!"))
	REMOVE_TRAIT(owner, TRAIT_FIRE_IMMUNE, "burnitdown")
	ADD_TRAIT(owner, TRAIT_FIRE_RESIST, "burnitdown")
	return

/datum/status_effect/buff/burn_it_down/proc/on_attack(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(target == owner || target.stat == DEAD)
		return
	if(!target.has_status_effect(/datum/status_effect/debuff/oil_stack))
		target.apply_status_effect(/datum/status_effect/debuff/oil_stack)
	else
		var/datum/status_effect/debuff/oil_stack/o = target.has_status_effect(/datum/status_effect/debuff/oil_stack)
		o.add_stacks(1)
	return

#undef ULT_FILTER
