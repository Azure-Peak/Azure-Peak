/datum/action/cooldown/spell/noc
	background_icon = 'icons/mob/actions/nocmiracles.dmi'
	button_icon = 'icons/mob/actions/nocmiracles.dmi'
	spell_color = GLOW_COLOR_NOC

	ignore_armor_penalty = TRUE

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0

	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/noc, /obj/item/clothing/neck/roguetown/psicross/silver/noc, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/////////////////////
// T0 - Nitevision //
/////////////////////

/datum/action/cooldown/spell/noc/nitevision
	name = "Nitevision"
	desc = "Enhance the night vision of yourself and everyone around you for 15 minutes."
	fluff_desc = "When the first men walked the world, they were not gifted with sight at night. They were preys to monsters and animals in the dark. Noc, in his infinite wisdom, bestowed upon humenity the gift of noc vision. And soon, the Magi followed suit and replicated it with magyck, as is His vision."
	button_icon_state = "noc_sight"
	sound = 'sound/magic/haste.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_STAT_BUFF

	secondary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Noc guide my gaze.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 1.5 MINUTES

	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/nitevision/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.visible_message("[H] mutters an incantation and a dim pulse of light radiates out from them.")
	for(var/mob/living/L in range(1, H))
		L.apply_status_effect(/datum/status_effect/buff/nitevision)

	return TRUE

/////////////////////////
// T1 - Enlightenment. //
/////////////////////////

/datum/action/cooldown/spell/noc/enlightenment
	name = "Enlightenment"
	desc = "Invoke a lesser form of the Moonlight Dance, temporarily increasing intelligence of your target. \
	Scales with holy skill and grows much more effective at nite."
	button_icon_state = "moon_light"
	sound = 'sound/magic/clang.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_STAT_BUFF
	secondary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Grant me your guidance.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	charge_then_click = TRUE
	cooldown_time = 2 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/noc/enlightenment/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/skill_level = H.get_skill_level(associated_skill)
	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and [spelltarget] briefly shines green.")
		to_chat(H, span_notice("With another person as a conduit, my spell's duration is extended."))
		spelltarget.apply_status_effect(/datum/status_effect/buff/wise_moon, skill_level)
	else
		H.visible_message("[H] mutters an incantation and they briefly shine green.")
		spelltarget.apply_status_effect(/datum/status_effect/buff/wise_moon, skill_level)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/wise_moon
	name = "Enlightenment"
	desc = "Divine magic is boosting my intelligence."
	icon_state = "enlightenment"

/datum/status_effect/buff/wise_moon
	id = "wise_moon"
	alert_type = /atom/movable/screen/alert/status_effect/buff/wise_moon
	duration = 2 MINUTES

/datum/status_effect/buff/wise_moon/on_creation(mob/living/new_owner, assocskill)
	var/int_bonus = 0
	if(assocskill)
		int_bonus = 2
		if(assocskill >= 4)
			int_bonus = 2
	if(GLOB.tod == "night")
		if(assocskill <= 2)
			int_bonus = 2
		else
			int_bonus = assocskill
		duration *= 2
	if(GLOB.tod == "day")
		int_bonus--
	if(int_bonus > 0)
		effectedstats = list(STATKEY_INT = int_bonus)
	. = ..()

////////////////////////
// T2 - Invisibility. //
////////////////////////

/datum/action/cooldown/spell/noc/invisibility
	name = "Moon Shroud"
	desc = "Make another (or yourself) invisible for some time. Duration scales with holy skill. Casting, attacking or being attacked will cancel the duration."
	button_icon_state = "invisibility"
	sound = 'sound/misc/area.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_NONE

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	ignore_combat_tag = TRUE

/datum/action/cooldown/spell/noc/invisibility/cast(atom/cast_on)
	. = ..()
	var/mob/living/spelltarget = cast_on

	if(isliving(cast_on))
		if(spelltarget.anti_magic_check(TRUE, TRUE))
			return FALSE
		cast_on.visible_message(span_warning("[cast_on] starts to fade into thin air!"), span_notice("You start to become invisible!"))
		var/dur
		dur = max((5 * (owner.get_skill_level(associated_skill))), 15)
		if(dur >= cooldown_time)
			cooldown_time = dur + 5 SECONDS
		animate(cast_on, alpha = 0, time = 1 SECONDS, easing = EASE_IN)
		spelltarget.mob_timers[MT_INVISIBILITY] = world.time + dur SECONDS
		addtimer(CALLBACK(cast_on, TYPE_PROC_REF(/mob/living, update_sneak_invis), TRUE), dur SECONDS)
		addtimer(CALLBACK(cast_on, TYPE_PROC_REF(/atom/movable, visible_message), span_warning("[cast_on] fades back into view."), span_notice("You become visible again.")), dur SECONDS)
		return TRUE
	else
		return FALSE

/////////////////////
// T2 - Moonscorch //
/////////////////////
//Blindness but as a projectile

/datum/action/cooldown/spell/projectile/moonscorch
	name = "Moonscorch"
	desc = "Hurl an owl at your target, blinding them for 15 seconds. Mindless creechers get IMMOBILIZED."
	background_icon = 'icons/mob/actions/nocmiracles.dmi'
	button_icon = 'icons/mob/actions/nocmiracles.dmi'
	button_icon_state = "blindness"
	spell_color = GLOW_COLOR_NOC
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/noc_owl
	cast_range = 7

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_SHOUT
	invocations = list("Blackest nite, blind!")

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	cooldown_time = 1 MINUTES

	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_requirements = SPELL_REQUIRES_HUMAN

	ignore_armor_penalty = TRUE
	attunement_school = null

	spell_tier = 0
	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/noc, /obj/item/clothing/neck/roguetown/psicross/silver/noc, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/datum/action/cooldown/spell/projectile/moonscorch/cast(atom/cast_on)
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H))
		return
	. = ..()

// ---- Moonscorch Projectile ----

/obj/projectile/magic/noc_owl
	name = "nite owl"
	icon = 'icons/obj/magic_projectiles.dmi'
	icon_state = "nite_owl"//Someone make a better sprite for this someday.
	damage = 0
	nodamage = TRUE
	range = 8
	hitsound = 'sound/magic/owlhoot.ogg'
	guard_deflectable = TRUE

/obj/projectile/magic/noc_owl/on_hit(target)
	if(ismob(target))
		var/mob/living/M = target
		if(M.anti_magic_check(TRUE, TRUE))
			visible_message(span_warning("[src] fizzles on contact with [target]!"))
			playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
			qdel(src)
			return BULLET_ACT_BLOCK
		if(!M.mind)
			M.Immobilize(5 SECONDS)
			qdel(src)
			return TRUE
		if(M.has_status_effect(STATUS_EFFECT_BLINDED))
			visible_message(span_warning("They are already blind!"))
			qdel(src)
			return BULLET_ACT_BLOCK
		M.apply_status_effect(STATUS_EFFECT_BLINDED)
		M.flash_act()
		playsound(get_turf(target), hitsound, 60, TRUE)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/blindness
	name = "Blindness"
	desc = "I see naught but darkness! (-2 PER, vision cone reduced)"

/datum/status_effect/debuff/blindness
	id = "blindness"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/blindness
	duration = 15 SECONDS
	effectedstats = list(STATKEY_PER = -2)

/datum/status_effect/debuff/blindness/on_apply()
	. = ..()

/datum/status_effect/debuff/blindness/on_remove()
	. = ..()
	to_chat(owner, span_warning("My vision returns...!"))

///////////////////////////
// T3 - Arcyne Affinity. //
///////////////////////////

/datum/action/cooldown/spell/noc/spellpack
	name = "Arcyne Affinity"
	desc = "Allows you to learn a set of spells. \n \
	<b>MAGISTER</b>: Greater Arcyne Bolt, Arc Bolt, Phase, Message, Campfire \n \
	<b>ENCHANTER</b>: Stygian Efflorescence, Geas, Rune Ward, Forcewall, Blood Rush \n \
	<b>SEER</b>: Attune Giant, Guidance, Attune Haste, Fortitude, Mindlink"
	button_icon_state = "spellpack"
//Magister = Generic magos, low utility mostly damage; Enchanter = Area denial beast, some utility; Seer = Full support with practically 0 offensive capacity.
	click_to_activate = FALSE
	primary_resource_cost = SPELLCOST_MIRACLE
	secondary_resource_cost = SPELLCOST_UTILITY_BUFF
	invocation_type = INVOCATION_NONE
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	/// var we use to flag we are currently choosing a bundle.
	var/choosing_bundle = FALSE
	var/chosen_bundle
	var/list/magister_bundle = list(
		/datum/action/cooldown/spell/projectile/greater_arcyne_bolt,
		/datum/action/cooldown/spell/projectile/arc_bolt,
		/datum/action/cooldown/spell/phase,
		/datum/action/cooldown/spell/message,
		/datum/action/cooldown/spell/create_campfire
	)
	var/list/enchanter_bundle = list(
		/datum/action/cooldown/spell/projectile/stygian_efflorescence,
		/datum/action/cooldown/spell/geas,
		/datum/action/cooldown/spell/touch/rune_ward,
		/datum/action/cooldown/spell/forcewall,
		/datum/action/cooldown/spell/augment_buff/blood_rush,
	)
	var/list/seer_bundle = list(
		/datum/action/cooldown/spell/augment_buff/attune_giant,
		/datum/action/cooldown/spell/augment_buff/guidance,
		/datum/action/cooldown/spell/augment_buff/attune_haste,
		/datum/action/cooldown/spell/augment_buff/fortitude,
		/datum/action/cooldown/spell/mindlink
	)

/datum/action/cooldown/spell/noc/spellpack/cast(atom/cast_on)
	. = ..()

	if(choosing_bundle)
		return FALSE
	var/choice = chosen_bundle
	if(!chosen_bundle)
		choosing_bundle = TRUE
		choice = alert(owner, "What type of spells has Noc blessed you with?", "CHOOSE PATH", "Magister", "Enchanter", "Seer")
		chosen_bundle = choice
		choosing_bundle = FALSE

	switch(choice)
		if("Magister")
			add_spells(owner, magister_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Enchanter")
			add_spells(owner, enchanter_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Seer")
			add_spells(owner, seer_bundle, grant_all = TRUE)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
	return FALSE

/datum/action/cooldown/spell/noc/spellpack/proc/add_spells(mob/owner, list/spells, choice_count = 1, grant_all = FALSE)
	for(var/spell_type in spells)
		if(owner?.mind.has_spell(spells[spell_type]))
			spells.Remove(spell_type)
	if(!grant_all)
		var/choice_count_visual = choice_count
		for(var/i in 1 to choice_count)
			var/choice = input(owner, "Choose a spell! Choices remaining: [choice_count_visual]") as null|anything in spells
			if(!isnull(choice))
				var/picked_spell = spells[choice]
				var/datum/new_spell = new picked_spell
				owner?.mind.AddSpell(new_spell)
				choice_count_visual--
				spells.Remove(choice)
	else
		for(var/spell_type in spells)
			var/datum/new_spell = new spell_type
			owner?.mind.AddSpell(new_spell)
	if(!length(spells))
		owner.mind?.RemoveSpell(src.type)


//////////////////
// T4 - Eclipse //
//////////////////

// =====================
// Moonlight Component
// =====================

/datum/component/moonlight
	var/mob/living/carbon/caster
	var/duration = 60 SECONDS
	var/adjacency_range = 1
	var/next_process = 0
	var/list/affected_mobs = list()
	can_transfer = FALSE

/datum/component/moonlight/Initialize(mob/living/carbon/caster_mob)
	if(!istype(caster_mob, /mob/living/carbon))
		return COMPONENT_INCOMPATIBLE

	caster = caster_mob

	// Start processing
	START_PROCESSING(SSprocessing, src)
	
	// Apply visual effect to caster
	caster.apply_status_effect(/datum/status_effect/moonlight, TRUE)

/datum/component/moonlight/process()
	if(!istype(caster) || caster.stat != CONSCIOUS)
		remove_moonlight()
		return FALSE

	var/list/current_adjacent = list()

	// Check for adjacent mobs and apply moonlight to them
	for(var/mob/living/L in range(adjacency_range, caster))
		if(L == caster || L.stat == DEAD)
			continue
		current_adjacent[L] = TRUE
		// Apply moonlight effect if they don't have it yet
		if(!L.has_status_effect(/datum/status_effect/moonlight))
			L.apply_status_effect(/datum/status_effect/moonlight, FALSE)

	. = ..()

	affected_mobs = current_adjacent

	return TRUE

/datum/component/moonlight/proc/remove_moonlight()
	if(!QDELETED(src))
		for(var/mob/living/L in affected_mobs)
			L?.remove_status_effect(/datum/status_effect/moonlight)
		affected_mobs.Cut()
		if(caster)
			caster.remove_status_effect(/datum/status_effect/moonlight)
			UnregisterSignal(caster, COMSIG_PARENT_QDELETING)
		STOP_PROCESSING(SSprocessing, src)
		qdel(src)

// =====================
// T4 - Moonlight - Grant antimagic to adjacent allies... and some other stuff.
// =====================

/datum/action/cooldown/spell/noc/moonlight
	name = "Eclipse"
	desc = "Bathe adjacent allies in moonlight, granting them protection against magic. Lasts one minute on the caster."
	fluff_desc = "The wisdom of the night - a blessing that offers those most devout to the Moon a sliver of its power. As Noc reflects Astrata's light, so too can his champions reflect magicks away from themselves and their allies."
	button_icon_state = "noc"
	sound = 'sound/magic/nocbell.ogg'
	glow_intensity = GLOW_INTENSITY_MEDIUM

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR

	secondary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("The tolling of the moonlit bell calls the magicians to their knees!!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 2 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 5 MINUTES

	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/datum/component/moonlight/moonlight_component

/datum/action/cooldown/spell/noc/moonlight/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	// Remove previous moonlight effect if it exists
	if(moonlight_component && !QDELETED(moonlight_component))
		qdel(moonlight_component)

	// Create and attach the moonlight component
	var/datum/component/moonlight/component = H.AddComponent(/datum/component/moonlight, H)
	moonlight_component = component

	H.visible_message(span_blue("[H] is bathed in silvery moonlight, protection radiating outward!"))
	return TRUE

/datum/action/cooldown/spell/noc/moonlight/Destroy()
	if(moonlight_component && !QDELETED(moonlight_component))
		qdel(moonlight_component)
	moonlight_component = null
	return ..()

// =====================
// Moonlight Status Effect
// =====================

/atom/movable/screen/alert/status_effect/moonlight
	name = "Moonlight"
	desc = "I am protected by His moonlight, shielded from magick both miraculous and arcyne."
	icon_state = "moonlight"

/datum/status_effect/moonlight
	id = "moonlight"
	duration = -1
	alert_type = /atom/movable/screen/alert/status_effect/moonlight
	var/is_caster = FALSE

/datum/status_effect/moonlight/on_creation(mob/living/new_owner, caster)
	is_caster = caster
	. = ..()

/datum/status_effect/moonlight/on_apply()
	// Grant the TRAIT_ANTIMAGIC
	ADD_TRAIT(owner, TRAIT_ANTIMAGIC, "moonlight_spell")
	
	// Visual feedback
	if(is_caster)
		owner.visible_message(span_blue("[owner] is surrounded by a protective aura of silvery moonlight!"))
	else
		return TRUE

/datum/status_effect/moonlight/on_remove()
	REMOVE_TRAIT(owner, TRAIT_ANTIMAGIC, "moonlight_spell")

/obj/effect/temp_visual/moon/spell
	icon_state = "spellwarning"
	duration = 2 SECONDS
	layer = MASSIVE_OBJ_LAYER
	light_outer_range = 3
	color = "#1640d7ff"
	light_color = "#1640d7ff"
