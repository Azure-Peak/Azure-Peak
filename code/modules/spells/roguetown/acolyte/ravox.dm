/datum/action/cooldown/spell/ravox
	background_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	button_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	spell_color = GLOW_COLOR_RAVOX

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

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/ravox, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/////////////////////////////////////////////////
// T0 - Judgement - Slow down an enemy on hit. //
/////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/judgement
	name = "Judgement"
	desc = "Bless your next strike to apply a debilitating pressure upon your enemy. On hit, applies a status that reduces their Movement Speed by 50% for 15 seconds. Attacking the mindless will cause them to be smited, dealing bonus damage."
	fluff_desc = "A miracle wrought from willpower tempered in another's moral compass. A servant of the Justicar may channel this force through their strikes, branding their prey with their own past burdens. So they can stand and fight. So they can face their sins head on. For justice is never good nor evil, but fair."
	button_icon_state = "judgement"
	sound = 'sound/magic/battletrance.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT
	invocations = list("By Ravox, face judgement!")

	charge_required = FALSE
	cooldown_time = 1 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ravox/judgement/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!isliving(user))
		return FALSE
	user.apply_status_effect(/datum/status_effect/judgement, user.get_active_held_item())
	return TRUE

/atom/movable/screen/alert/status_effect/buff/judgement
	name = "Judgement"
	desc = "Your next attack will slow your target. Mindless creechers get damaged."
	icon_state = "judgement"

/datum/status_effect/judgement
	id = "judgement"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 15 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/judgement
	on_remove_on_mob_delete = TRUE
	var/datum/weakref/buffed_item

/datum/status_effect/judgement/on_creation(mob/living/new_owner, obj/item/I)
	. = ..()
	if(!.)
		return
	if(istype(I) && !(I.item_flags & ABSTRACT))
		buffed_item = WEAKREF(I)
		if(!I.light_outer_range && I.light_system == STATIC_LIGHT)
			I.set_light(1)
		RegisterSignal(I, COMSIG_ITEM_AFTERATTACK, PROC_REF(item_afterattack))
	else
		RegisterSignal(owner, COMSIG_MOB_ATTACK_HAND, PROC_REF(hand_attack))

/datum/status_effect/judgement/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_MOB_ATTACK_HAND)
	if(buffed_item)
		var/obj/item/I = buffed_item.resolve()
		if(istype(I))
			I.set_light(0)
		UnregisterSignal(I, COMSIG_ITEM_AFTERATTACK)

/datum/status_effect/judgement/proc/item_afterattack(obj/item/source, atom/target, mob/user, proximity_flag, click_parameters)
	if(!proximity_flag)
		return
	if(!isliving(target))
		return
	var/mob/living/D = target
	if(!D.mind)
		D.adjustBruteLoss(20)
		D.adjustFireLoss(20)
		D.apply_status_effect(/datum/status_effect/debuff/judgement)
		D.visible_message(span_warning("The strike from [user]'s weapon smites [D]!"), vision_distance = COMBAT_MESSAGE_RANGE)
		var/turf/target_turf = get_turf(D)
		new /obj/effect/temp_visual/thunderstrike_actual(target_turf)
		playsound(target_turf, 'sound/magic/lightning.ogg', 50)
	else
		D.apply_status_effect(/datum/status_effect/debuff/judgement)
		D.visible_message(span_warning("The strike from [user]'s weapon causes [D] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/datum/status_effect/judgement/proc/hand_attack(datum/source, mob/living/carbon/human/user, mob/living/carbon/human/D, datum/martial_art/attacker_style)
	if(!istype(user))
		return
	if(!istype(D))
		return
	if(!istype(user.used_intent, INTENT_HARM))
		return
	if(!D.mind)
		D.adjustBruteLoss(20)
		D.adjustFireLoss(20)
		D.apply_status_effect(/datum/status_effect/debuff/judgement)
		D.visible_message(span_warning("[user]'s fist smites [D]!"), vision_distance = COMBAT_MESSAGE_RANGE)
		var/turf/target_turf = get_turf(D)
		new /obj/effect/temp_visual/thunderstrike_actual(target_turf)
		playsound(target_turf, 'sound/magic/lightning.ogg', 50)
	else
		D.apply_status_effect(/datum/status_effect/debuff/judgement)
		D.visible_message(span_warning("The strike from [user]'s fist causes [D] to go stiff!"), vision_distance = COMBAT_MESSAGE_RANGE)
	qdel(src)

/atom/movable/screen/alert/status_effect/debuff/judgement
	name = "Weight of Sins"
	desc = "My entire body is stiffened by the unseen burden of my every living sins!"
	icon_state = "restrained"

/datum/status_effect/debuff/judgement
	id = "judgement_debuff"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/judgement
	duration = 15 SECONDS

/datum/status_effect/debuff/judgement/on_apply()
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN, multiplicative_slowdown = 1.5)

/datum/status_effect/debuff/judgement/on_remove()
	. = ..()
	owner.remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////
// T1 - Tug of War - Chain projectile that off-balances + stuns. Exposes the user.							//
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/projectile/ravox_tug
	name = "Tug of War"
	desc = "Divine wrought-iron is hurled out to tug back my opponent. I'm left exposed whilst I throw-and-pull."
	fluff_desc = "One's worth is determined by weight of their soul in the afterlyfe, chains of sin pushing the scale downwards to inevitable pits of damnation."
	background_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	button_icon = 'icons/mob/actions/ravoxmiracles.dmi'
	button_icon_state = "ravox_tug"
	spell_color = GLOW_COLOR_RAVOX
	sound = 'sound/magic/battletrance.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	projectile_type = /obj/projectile/magic/ravox_chain

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT
	invocations = list("Feel the weight of your sins!")

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1 MINUTES

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	ignore_armor_penalty = TRUE
	attunement_school = null
	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	spell_tier = 0
	point_cost = 0

	spell_flags = SPELL_PSYDON
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_CMODE
	allow_cross_z = FALSE

	required_items = list(/obj/item/clothing/neck/roguetown/psicross/ravox, /obj/item/clothing/neck/roguetown/psicross/undivided, /obj/item/clothing/neck/roguetown/psicross/silver/undivided)

/datum/action/cooldown/spell/projectile/ravox_tug/is_valid_target(atom/cast_on)
	if(owner)
		cast_range = 4 + floor(owner.get_skill_level(/datum/skill/magic/holy) / 2)
	return ..()

/datum/action/cooldown/spell/projectile/ravox_tug/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	var/obj/projectile/magic/ravox_chain/chain = to_fire
	if(!istype(chain))
		return
	chain.range = cast_range
	chain.pull_distance = 1 + floor(user.get_skill_level(/datum/skill/magic/holy) / 2)//+1 pull dist at Apprentice, Expert and Legendary
	user.visible_message(span_boldwarning("[user] hurls out a transluscent chain!"))

// ---- Projectile ----

/obj/projectile/magic/ravox_chain
	name = "chain of judgement"
	icon = 'icons/effects/beam.dmi'
	icon_state = "chain"
	nodamage = TRUE
	damage = 0
	range = 5
	speed = 2.5
	hitsound = 'sound/combat/hits/onmetal/metalimpact (1).ogg'
	guard_deflectable = TRUE

	/// How many tiles the caught target is dragged. Set by the spell from holy skill.
	var/pull_distance = 1
	/// Trailing beam for that mortal kombat feel.
	var/datum/beam/chain_beam
	/// Boolean flag to check if the user currently is exposed during casting or not.
	var/applied_exposure = FALSE

/obj/projectile/magic/ravox_chain/proc/expose_caster(expose_for)
	var/mob/living/thrower = firer
	if(!isliving(thrower))
		return
	if(!applied_exposure && thrower.has_status_effect(/datum/status_effect/debuff/exposed))
		return
	thrower.remove_status_effect(/datum/status_effect/debuff/exposed)
	thrower.apply_status_effect(/datum/status_effect/debuff/exposed, expose_for)
	applied_exposure = TRUE

/obj/projectile/magic/ravox_chain/fire(angle, atom/direct_target)
	if(firer)
		chain_beam = firer.Beam(src, icon_state = "chain", time = 10 SECONDS, maxdistance = 15, beam_sleep_time = 1)
		expose_caster((range * speed) + 2)
	return ..()

/obj/projectile/magic/ravox_chain/Destroy()
	if(chain_beam)
		chain_beam.End()
		chain_beam = null
	return ..()

/obj/projectile/magic/ravox_chain/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(!isliving(target) || !firer)
		return
	var/mob/living/caught = target

	firer.Beam(caught, icon_state = "chain", time = 5, maxdistance = 15, beam_sleep_time = 1)

	expose_caster(max(pull_distance, 2))

	caught.throw_at(firer, pull_distance, 1, caught, FALSE)
	caught.OffBalance(2 SECONDS)
	caught.Stun(1 SECONDS)
	caught.visible_message(span_warning("The chain snaps taut and hauls [caught] in!"), span_userdanger("The chain bites into me and drags me forward!"))

////////////////////////////////////////////////////////////////////////////////////////
// T2 - Provocation - Ravox Trial Selector. CON/STR or INT/PER equalise.				//
////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/provocation
	name = "Provocation"
	desc = "Declare the measure by which Ravox will weigh me against my foes. Choose between the Trial of Glory (brawn) or the Trial of Wits (mind). This choice is made once and cannot be unmade."
	fluff_desc = "No duel pleases Him where one side was never in danger. Before He grants His judgement, He asks only which scale you would be set upon."
	button_icon_state = "provocation"

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT

	primary_resource_cost = SPELLCOST_MIRACLE_MINOR

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_NONE

	charge_required = FALSE
	cooldown_time = 10 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/trial_glory = /datum/action/cooldown/spell/ravox/trial/glory
	var/trial_wits = /datum/action/cooldown/spell/ravox/trial/wits
	var/choosingspell = FALSE

/datum/action/cooldown/spell/ravox/provocation/cast(atom/cast_on)
	. = ..()
	if(choosingspell)
		to_chat(owner, span_warning("I'm already declaring my trial!"))
		return FALSE

	choosingspell = TRUE
	var/choice = tgui_alert(owner, "By which measure shall Ravox weigh you?", "DECLARE THE TRIAL", list("Trial of Glory", "Trial of Wits", "Cancel"))
	choosingspell = FALSE

	switch(choice)
		if("Trial of Glory")
			owner.mind?.AddSpell(new trial_glory, owner)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		if("Trial of Wits")
			owner.mind?.AddSpell(new trial_wits, owner)
			owner.mind?.RemoveSpell(src.type)
			return TRUE
		else
			return FALSE

/datum/action/cooldown/spell/ravox/trial
	sound = 'sound/magic/battletrance.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 1 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 1 MINUTES

	spell_flags = SPELL_PSYDON
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_CMODE | SPELL_REQUIRES_TARGET_CMODE

	var/list/weighed_stats

/datum/action/cooldown/spell/ravox/trial/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!istype(user))
		return FALSE
	if(!isliving(cast_on))
		return FALSE

	var/mob/living/target = cast_on
	if(!target.mind)
		to_chat(user, span_warning("[target] is not worthy of Trial!"))
		return FALSE

	if(spell_guard_check(target, TRUE))
		target.visible_message(span_warning("[target] refuses to step onto the scales!"))
		return TRUE

	if(user.has_status_effect(/datum/status_effect/buff/ravox_provocation))
		to_chat(user, span_warning("Ravox has already weighed me."))
		return FALSE
	if(target.has_status_effect(/datum/status_effect/buff/ravox_provocation))
		to_chat(user, span_warning("[target] has already been weighed!"))
		return FALSE

	var/cap = clamp(ROUND_UP(user.get_skill_level(/datum/skill/magic/holy) / 2), 1, 3)

	var/list/user_shifts = list()
	var/list/target_shifts = list()
	var/anything_shifted = FALSE

	for(var/stat_key in weighed_stats)
		var/diff = target.get_stat(stat_key) - user.get_stat(stat_key)
		var/shift = clamp(round(abs(diff) / 2), 0, cap)
		if(!shift)//Already level on this measure
			continue
		anything_shifted = TRUE
		if(diff > 0)
			user_shifts[stat_key] = shift
			target_shifts[stat_key] = -shift
		else
			user_shifts[stat_key] = -shift
			target_shifts[stat_key] = shift

	if(!anything_shifted)
		user.visible_message(span_info("The scales between [user] and [target] do not budge."), span_notice("Ravox finds us already evenly matched."))
		return TRUE

	user.apply_status_effect(/datum/status_effect/buff/ravox_provocation, user_shifts)
	target.apply_status_effect(/datum/status_effect/buff/ravox_provocation, target_shifts)

	user.visible_message(span_boldwarning("[user] calls Ravox to weigh them against [target]!"), span_notice("Ravox sets us both upon His scales."))
	to_chat(target, span_userdanger("Ravox has weighed you against [user]!"))
	return TRUE

/datum/action/cooldown/spell/ravox/trial/glory
	name = "Trial of Glory"
	desc = "Set myself and my foe upon Ravox's scales and level our brawn. The stronger of us is brought down and the weaker brought up, in strength and constitution alike. Lasts 20 seconds. Both of us must be ready to fight.."
	fluff_desc = "There is no glory in felling a man who could never have felled you."
	button_icon_state = "provocation"
	invocations = list("By Ravox, stand and face me!")
	weighed_stats = list(STATKEY_STR, STATKEY_CON)

/datum/action/cooldown/spell/ravox/trial/wits
	name = "Trial of Wits"
	desc = "Set myself and my foe upon Ravox's scales and level our minds. The sharper of us is dulled and the duller sharpened, in intelligence and perception alike. Lasts 20 seconds. Both of us must be ready to fight.."
	fluff_desc = "A justicar who wins only because his foe was a fool has proven nothing at all."
	button_icon_state = "provocation"
	invocations = list("By Ravox, match me in wit!")
	weighed_stats = list(STATKEY_INT, STATKEY_PER)

/atom/movable/screen/alert/status_effect/buff/ravox_provocation
	name = "Weighed by Ravox"
	desc = "Ravox has set me upon His scales against my foe. We have been brought toward parity."
	icon_state = "provocation"

/datum/status_effect/buff/ravox_provocation
	id = "ravox_provocation"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/buff/ravox_provocation
	duration = 15 SECONDS

/datum/status_effect/buff/ravox_provocation/on_creation(mob/living/new_owner, list/shifts)
	if(length(shifts))
		effectedstats = shifts.Copy()
	. = ..()

//////////////////////////////////////////////////////////////////////////////////////////////////
// T2 - Withstand - Based on skill provides varying degrees of stun immunity and force push up. //
//////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/withstand
	name = "Withstand"
	desc = "Regain balance and become immune to any form of stun for the next 10 seconds."
	button_icon_state = "withstand"
	sound = 'sound/magic/ravox_withstand.ogg'
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_CANTRIP

	invocation_type = INVOCATION_SHOUT
	invocations = list("I stand, by Ravox!")

	charge_required = FALSE
	cooldown_time = 1 MINUTES

	check_flags = AB_CHECK_CONSCIOUS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ravox/withstand/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!isliving(user))
		return FALSE
	var/skill = user.get_skill_level(/datum/skill/magic/holy)
	user.apply_status_effect(/datum/status_effect/withstand)
	if(user.has_status_effect(/datum/status_effect/incapacitating/off_balanced))
		user.remove_status_effect(/datum/status_effect/incapacitating/off_balanced)
	if(skill >= 2)
		if(!(user.mobility_flags & MOBILITY_STAND))
			user.SetUnconscious(0)
			user.SetSleeping(0)
			user.SetParalyzed(0)
			user.SetImmobilized(0)
			user.SetStun(0)
			user.SetKnockdown(0)
			user.set_resting(FALSE)
	if(skill >= 3)
		user.apply_status_effect(/datum/status_effect/buff/order/onfeet)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/withstand
	name = "Withstand"
	desc = "I hold fast for Ravox."
	icon_state = "withstand"

/datum/status_effect/withstand
	id = "withstand"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 10 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/withstand

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// T3 - Persistence - Harms an undead mob/player while causing bleeding/pain wounds to clot at higher rate for living ones. //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/persistence
	name = "Persistence"
	desc = "Harms Undead and encourages the livings wounds to close faster."
	button_icon_state = "persistence"
	sound = 'sound/magic/persistence.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocation_type = INVOCATION_SHOUT
	invocations = list("Ravox deems your persistence worthy!")

	charge_required = FALSE
	cooldown_time = 30 SECONDS

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ravox/persistence/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		return FALSE
	if(isliving(cast_on))
		var/mob/living/target = cast_on
		if(target.mob_biotypes & MOB_UNDEAD)
			if(spell_guard_check(target, TRUE))
				target.visible_message(span_warning("[target] resists Ravox's judgment!"))
				return TRUE
			if(ishuman(target)) //BLEED AND PAIN
				var/mob/living/carbon/human/human_target = target
				var/datum/physiology/phy = human_target.physiology
				phy.bleed_mod *= 1.5
				phy.pain_mod *= 1.5
				addtimer(CALLBACK(src, PROC_REF(restore_modifiers), phy), 19 SECONDS)
				human_target.visible_message(span_danger("[target]'s wounds become inflamed as their vitality is sapped away!"), span_userdanger("Ravox inflames my wounds and weakens my body!"))
				return TRUE
			return FALSE

		target.visible_message(span_info("Warmth radiates from [target] as their wounds seal over!"), span_notice("The pain from my wounds fade as warmth radiates from my soul!"))
		var/situational_bonus = 0.25
		for(var/obj/effect/decal/cleanable/blood/O in oview(5, target))
			situational_bonus = min(situational_bonus + 0.015, 1)
		if(situational_bonus > 0.25)
			to_chat(owner, "Channeling Ravox's power is easier in these conditions!")

		if(iscarbon(target))
			var/mob/living/carbon/C = target
			var/obj/item/bodypart/affecting = C.get_bodypart(check_zone(owner.zone_selected))
			if(affecting)
				for(var/datum/wound/bleeder in affecting.wounds)
					bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25)
					if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
						var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
						bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference * situational_bonus))
		else if(HAS_TRAIT(target, TRAIT_SIMPLE_WOUNDS))
			for(var/datum/wound/bleeder in target.simple_wounds)
				bleeder.woundpain = max(bleeder.sewn_woundpain, bleeder.woundpain * 0.25)
				if(!isnull(bleeder.clotting_threshold) && bleeder.bleed_rate > bleeder.clotting_threshold)
					var/difference = bleeder.bleed_rate - bleeder.clotting_threshold
					bleeder.set_bleed_rate(max(bleeder.clotting_threshold, bleeder.bleed_rate - difference * situational_bonus))
		return TRUE
	return FALSE

/datum/action/cooldown/spell/ravox/persistence/proc/restore_modifiers(datum/physiology/physiology)
	if(!physiology)
		return

	physiology.bleed_mod /= 1.5
	physiology.pain_mod /= 1.5

///////////////////////////////////////////////////////////////////////////////////////////////////
// T3 - Call to Arms - Warcry that provides buff to DIVINE worshippers and debuff to ASCENDANTS. //
///////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/battlecry
	name = "Call to Arms"
	desc = "Grants you and all allies nearby a buff to their strength, willpower, and constitution while taking away willpower and constitution from ascendant worshippers."
	fluff_desc = "A yell rings out across the battlefield! Your sergeant bellows a final order before they're claimed by Necra's grasp - leave none standing before the might of Ravox! So long as you draw breath, there shall be no defeat."
	button_icon_state = "call_to_arms"
	sound = 'sound/magic/battle_cry.ogg'

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_AURA

	primary_resource_cost = SPELLCOST_MIRACLE_MAJOR - 10

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocation_type = INVOCATION_SHOUT
	invocations = list("By Ravox, stand and fight!")

	charge_required = FALSE
	cooldown_time = 5 MINUTES

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/ravox/battlecry/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	for(var/mob/living/carbon/target in view(cast_range, get_turf(owner)))
		if(istype(target.patron, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/debuff/call_to_arms)	//Debuffs inhumen worshipers.
			continue
		if(istype(target.patron, /datum/patron/old_god))
			to_chat(target, span_danger("You feel a hot-wave wash over you, leaving as quickly as it came.."))	//No effect on Psydonians!
			continue
		if(istype(target.patron, /datum/patron/vheslyn))
			to_chat(target, span_danger("You feel... nothing..")) //No effect on Vheslynites, fear them.
			continue
		if(!owner.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/buff/call_to_arms)
	return TRUE

/datum/status_effect/buff/call_to_arms
	id = "call_to_arms"
	alert_type = /atom/movable/screen/alert/status_effect/buff/call_to_arms
	duration = 3 MINUTES
	effectedstats = list(STATKEY_STR = 1, STATKEY_WIL = 2, STATKEY_CON = 2)

/atom/movable/screen/alert/status_effect/buff/call_to_arms
	name = "Call to Arms"
	desc = span_bloody("FOR GLORY AND HONOR!")
	icon_state = "call_to_arms"

/datum/status_effect/debuff/call_to_arms
	id = "call_to_arms"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/call_to_arms
	effectedstats = list(STATKEY_WIL = -2, STATKEY_CON = -2)
	duration = 3 MINUTES

/atom/movable/screen/alert/status_effect/debuff/call_to_arms
	name = "Ravox's Call to Arms"
	desc = "His voice keeps ringing in your ears, rocking your soul.."
	icon_state = "call_to_arms_negative"

/////////////////////////////////////////////////////////////////////////////////////////////////////////
// T4 - Challenge - Teleport yourself and target into an ARENA for 3 minutes or until one of you dies. //
/////////////////////////////////////////////////////////////////////////////////////////////////////////

/datum/action/cooldown/spell/ravox/challenge
	name = "Challenge"
	desc = "Bring an opponent with you to Ravoxian Trial. Engage in 3 minute combat. Both of us must be ready to fight.."
	button_icon_state = "ravoxchallenge"
	sound = 'sound/magic/battletrance.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_AURA
	self_cast_possible = FALSE

	primary_resource_cost = SPELLCOST_MIRACLE_LEGENDARY

	secondary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocation_type = INVOCATION_SHOUT
	invocations = list("By Ravox, I challenge you!!")

	charge_required = TRUE
	charge_time = 3 SECONDS
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/holycharging.ogg'
	cooldown_time = 10 MINUTES

	spell_flags = SPELL_PSYDON
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z | SPELL_REQUIRES_CMODE | SPELL_REQUIRES_TARGET_CMODE

GLOBAL_LIST_EMPTY(arenafolks) // we're just going to use a list and add to it. Since /entered doesnt work on teleported mobs.

/datum/action/cooldown/spell/ravox/challenge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(!istype(user))
		return FALSE

	var/area/rogue/indoors/ravoxarena/thearena = GLOB.areas_by_type[/area/rogue/indoors/ravoxarena]
	var/turf/challengerspawnpoint
	var/turf/challengedspawnpoint
	var/arenacount = GLOB.arenafolks.len
	if(arenacount >= 2)
		to_chat(user, span_italics("The arena is not yet ready for the next trial! Wait your turn!"))
		return FALSE

	if(!isliving(cast_on))
		return FALSE

	var/mob/living/carbon/target = cast_on
	var/originalcmodeuser = user.cmode_music
	var/originalcmodetarget = target.cmode_music
	var/turf/storedchallengerturf = get_turf(user)
	var/turf/storedchallengedturf = get_turf(target)

	if(user.z != target.z)
		return FALSE
	if(target == user)
		return FALSE
	if(!target.mind)//We can't use it on mindless mobs
		to_chat(user, span_warning("[target] is not worthy of a duel!"))
		return FALSE
	if(
		(target.stat > CONSCIOUS) || \
		!(target.mobility_flags & MOBILITY_STAND) || \
		!(target.mobility_flags & MOBILITY_MOVE) || \
		(HAS_TRAIT(target, TRAIT_PACIFISM)) || \
		(target.handcuffed) || \
		(target.legcuffed)
	)
		to_chat(user, span_warning("[target] is in no shape to accept the duel!"))
		return FALSE

	if(spell_guard_check(target, TRUE))
		target.visible_message(span_warning("[target] stands firm, refusing the trial!"))
		return TRUE

	for(var/obj/structure/fluff/ravox/challenger/aflag in thearena)
		challengerspawnpoint = get_turf(aflag)
	for(var/obj/structure/fluff/ravox/challenged/bflag in thearena)
		challengedspawnpoint = get_turf(bflag)

	do_teleport(user, challengerspawnpoint)
	do_teleport(target, challengedspawnpoint)
	GLOB.arenafolks += user
	GLOB.arenafolks += target
	storedchallengerturf.visible_message((span_cult("[user] calls upon the Ravoxian rite of Trial! [target] and [user] are brought to Trial!")))

	new /obj/structure/fluff/ravox/challenger/recall(storedchallengerturf)
	new /obj/structure/fluff/ravox/challenged/recall(storedchallengedturf)

	to_chat(user, span_userdanger("THE TRIAL IS CALLED, IMPRESS US, PROSECUTOR!!"))
	to_chat(target, span_userdanger("A TRIAL OF RAVOX BEGINS. IMPRESS US, DEFENDANT!!"))

	user.cmode_change('sound/music/ravoxarena.ogg')
	target.cmode_change('sound/music/ravoxarena.ogg')

	addtimer(CALLBACK(user, GLOBAL_PROC_REF(do_teleport), user, storedchallengerturf), 3 MINUTES)
	addtimer(CALLBACK(target, GLOBAL_PROC_REF(do_teleport), target, storedchallengedturf), 3 MINUTES)
	addtimer(CALLBACK(user, TYPE_PROC_REF(/mob, cmode_change), originalcmodeuser), 3 MINUTES)
	addtimer(CALLBACK(target,TYPE_PROC_REF(/mob, cmode_change), originalcmodetarget), 3 MINUTES)
	addtimer(CALLBACK(thearena,TYPE_PROC_REF(/area/rogue/indoors/ravoxarena, cleanthearena), storedchallengedturf), 3 MINUTES) // shunt all items from the arena out onto the challenged spot.

	if(iscarbon(target))
		var/mob/living/carbon/human/spawnprotectiontarget = target
		addtimer(CALLBACK(spawnprotectiontarget,TYPE_PROC_REF(/mob/living/carbon/human, do_invisibility), 10 SECONDS), 3 MINUTES)

	return TRUE


/obj/structure/fluff/ravox
	icon = 'icons/roguetown/rav/obj/flags.dmi'
	density = FALSE
	anchored = TRUE
	blade_dulling = DULLING_BASHCHOP
	layer = BELOW_MOB_LAYER
	max_integrity = 0

/obj/structure/fluff/ravox/proc/spawnprotection()
	var/list/thrownatoms = list()
	var/atom/throwtarget
	var/distfromflag
	var/maxthrow = 6
	var/sparkle_path = /obj/effect/temp_visual/gravpush
	var/repulse_force = MOVE_FORCE_EXTREMELY_STRONG
	var/push_range = 3

	playsound(src, 'sound/magic/repulse.ogg', 80, TRUE)
	for(var/turf/T in view(push_range, src))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/atom/movable/AM in T)
			thrownatoms += AM

	for(var/am in thrownatoms)
		var/atom/movable/AM = am
		if(AM == src || AM.anchored)
			continue

		if(ismob(AM))
			var/mob/M = AM
			if(M.anti_magic_check())
				continue

		throwtarget = get_edge_target_turf(src, get_dir(src, get_step_away(AM, src)))
		distfromflag = get_dist(src, AM)
		if(distfromflag == 0)
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(10)
				M.adjustBruteLoss(20)
				to_chat(M, "<span class='danger'>You're slammed into the floor by Ravox's strength!!</span>")
		else
			new sparkle_path(get_turf(AM), get_dir(src, AM)) //created sparkles will disappear on their own
			if(isliving(AM))
				var/mob/living/M = AM
				M.Paralyze(5)
				to_chat(M, "<span class='danger'>You're thrown back by Ravox's strength!!</span>")
			AM.safe_throw_at(throwtarget, ((CLAMP((maxthrow - (CLAMP(distfromflag - 2, 0, distfromflag))), 3, maxthrow))), 1,null, force = repulse_force)


/obj/structure/fluff/ravox/challenger
	name = "Flag of the challenger"
	desc = "Where the challenger will return after the trial is decided."
	icon_state = "ravoxchallenger"

/obj/structure/fluff/ravox/challenged
	name = "Flag of the challenged"
	desc = "Where the challenged will return after the trial is decided."
	icon_state = "ravoxchallenged"


/obj/structure/fluff/ravox/challenger/recall/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(qdel), src), 3 MINUTES)
	addtimer(CALLBACK(src,TYPE_PROC_REF(/obj/structure/fluff/ravox, spawnprotection)), 179 SECONDS)

/obj/structure/fluff/ravox/challenged/recall/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, GLOBAL_PROC_REF(qdel), src), 3 MINUTES)
	addtimer(CALLBACK(src,TYPE_PROC_REF(/obj/structure/fluff/ravox, spawnprotection)), 179 SECONDS)
