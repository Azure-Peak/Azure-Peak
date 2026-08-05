
/datum/action/cooldown/spell/minion_order/conjurer
	name = "Order Servants"
	desc = "Issue commands to your conjured servants - primordials, champions, and the like - within 12 tiles.<br>\
	<br>\
	Cast on a turf: order them to move there.<br>\
	Cast on yourself: recall them and set them to retaliate-only.<br>\
	Cast on an enemy: order them to attack that target.<br>\
	Cast on one of your servants: toggle its stance between retaliate-only and attack-all-strangers."
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "order_servants"
	spell_color = GLOW_COLOR_ARCANE
	associated_skill = /datum/skill/magic/arcane
	zizo_spell = FALSE

/datum/action/cooldown/spell/minion_mark
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "Conjurer's Mark"
	desc = "Cast on someone to mark them friendly to your conjured servants, or strip an existing mark."
	button_icon_state = "primordial_mark"
	sound = null
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	click_to_activate = TRUE
	cast_range = 7
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_NONE
	cooldown_time = 1 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 0

	spell_requirements = SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/minion_mark/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	var/faction_tag = "[user.mind.current.real_name]_faction"
	if(isliving(cast_on))
		var/mob/living/target = cast_on
		if(target == user)
			to_chat(user, span_warning("It would be unwise to make an enemy of your own conjured servants."))
			return FALSE
		if(HAS_TRAIT(target, TRAIT_CONJURED_SUMMON))
			to_chat(user, span_warning("[target] is already bound to another conjurer."))
			return FALSE
		if(target.mind && target.mind.current)
			if(faction_tag in target.mind.current.faction)
				target.mind.current.faction -= faction_tag
				user.say("Hostis declaratus es.", language = /datum/language/common)
				target.notify_faction_change()
			else
				target.mind.current.faction += faction_tag
				user.say("Amicus declaratus es.", language = /datum/language/common)
				target.notify_faction_change()
		else if(istype(target, /mob/living/simple_animal))
			if(faction_tag in target.faction)
				target.faction -= faction_tag
				user.say("Hostis declaratus es.", language = /datum/language/common)
				target.notify_faction_change()
			else
				target.faction |= faction_tag
				user.say("Amicus declaratus es.", language = /datum/language/common)
				target.notify_faction_change()
		return TRUE
	return FALSE

/datum/action/cooldown/spell/conjure_recall
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	button_icon_state = "order_servants"
	name = "Recall Servants"
	desc = "Wrench every conjured servant through the leyline to your side, wherever they have strayed - even across floors or a piloted body's leash."
	sound = 'sound/magic/magnet.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CONJURATION

	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = FALSE
	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE
	cooldown_time = 30 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	spell_impact_intensity = SPELL_IMPACT_NONE
	point_cost = 0

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_MIND

/datum/action/cooldown/spell/conjure_recall/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return
	var/mob/living/user = owner
	if(!istype(user) || !length(user.summoned_minions))
		if(feedback)
			owner.balloon_alert(owner, "no servants to recall!")
		return FALSE

/datum/action/cooldown/spell/conjure_recall/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!istype(user))
		return FALSE
	var/turf/center = get_turf(user)
	if(!center)
		return FALSE
	var/list/landing_turfs = list()
	for(var/turf/T in range(2, center))
		if(!isopenturf(T) || istype(T, /turf/open/transparent/openspace))
			continue
		if(T.is_transition_turf() || T.is_blocked_turf(exclude_mobs = TRUE))
			continue
		landing_turfs += T
	var/count = 0
	for(var/mob/living/M in user.summoned_minions.Copy())
		if(QDELETED(M) || M.stat == DEAD || M == user)
			continue
		var/turf/landing = length(landing_turfs) ? pick(landing_turfs) : center
		if(do_teleport(M, landing, precision = 0, channel = TELEPORT_CHANNEL_MAGIC, forced = TRUE))
			count++
	if(!count)
		to_chat(user, span_warning("None of my servants answer the pull."))
		reset_spell_cooldown()
		return FALSE
	to_chat(user, span_notice("I draw the leyline taut, and my servants are dragged to my side."))
	playsound(user, 'sound/magic/magnet.ogg', 60, TRUE)
	return TRUE
