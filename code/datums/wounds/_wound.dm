/// List of "primordial" wounds so that we don't have to create new wound datums when running checks to see if a wound should be applied
GLOBAL_LIST_INIT(primordial_wounds, init_primordial_wounds())

/proc/init_primordial_wounds()
	var/list/primordial_wounds = list()
	for(var/wound_type in typesof(/datum/wound))
		primordial_wounds[wound_type] = new wound_type()
	return primordial_wounds

/datum/wound
	/// Name of the wound, visible to players when inspecting a limb and such
	var/name = "wound"
	/// Name that appears on check_for_injuries()
	var/check_name

	/// Wounds get sorted from highest severity to lowest severity
	var/severity = WOUND_SEVERITY_LIGHT

	/// Overlay to use when this wound is applied to a carbon mob
	var/mob_overlay = "w1"
	/// Overlay to use when this wound is sewn, and is on a carbon mob
	var/sewn_overlay = ""

	/// Crit message(s) to append when this wound is applied in combat
	var/crit_message
	/// Sound effect(s) to play when this wound is applied
	var/sound_effect

	/// Bodypart that owns this wound, in case it is not a simple one
	var/obj/item/bodypart/bodypart_owner
	/// Mob that owns this wound
	var/mob/living/owner

	/// How many "health points" this wound has, AKA how hard it is to heal
	var/whp = 60
	/// How many "health points" this wound gets after being sewn
	var/sewn_whp = 30
	/// How much this wound bleeds
	var/bleed_rate
	/// Bleed rate when sewn
	var/sewn_bleed_rate = 0.01
	/// Some wounds clot over time, reducing bleeding - This is the rate at which they do so
	var/clotting_rate = 0.01
	/// Clotting rate when sewn
	var/sewn_clotting_rate = 0.02
	/// Clotting will not go below this amount of bleed_rate
	var/clotting_threshold
	/// Clotting will not go below this amount of bleed_rate when sewn
	var/sewn_clotting_threshold = 0
	/// How much pain this wound causes while on a mob
	var/woundpain = 0
	/// Pain this wound causes after being sewn
	var/sewn_woundpain = 0
	/// Sewing progress, because sewing wounds is snowflakey
	var/sew_progress = 0
	/// When sew_progress reaches this, the wound is sewn
	var/sew_threshold = 100

	/// If TRUE, this wound can be sewn
	var/can_sew = FALSE
	/// If TRUE, this wound can be cauterized
	var/can_cauterize = FALSE
	/// If TRUE, this disables limbs
	var/disabling = FALSE
	/// If TRUE, this is a crit wound
	var/critical = FALSE
	/// Some wounds cause instant death for CRITICAL_WEAKNESS
	var/mortal = FALSE
	/// Amount we heal passively while sleeping
	var/sleep_healing = 1
	/// Amount we heal passively, always
	var/passive_healing = 0
	/// Embed chance if this wound allows embedding
	var/embed_chance = 0
	/// Bypass bloody wound checks, used for fractures so they apply to skeleton-mobs.
	var/bypass_bloody_wound_check = FALSE
	/// Some wounds make no sense on a dismembered limb and need to go
	var/qdel_on_droplimb = FALSE
	/// Severity names, assoc list.
	var/list/severity_names = list()
	/// Whether miracles heal it.
	var/healable_by_miracles = TRUE

/datum/wound/Destroy(force)
	if(bodypart_owner)
		remove_from_bodypart()
	else if(owner)
		remove_from_mob()
	if(werewolf_infection_timer)
		deltimer(werewolf_infection_timer)
		werewolf_infection_timer = null
	bodypart_owner = null
	owner = null
	. = ..()

/// Description of this wound returned to the player when a bodypart is examined and such
/datum/wound/proc/get_visible_name(mob/user)
	if(!name)
		return
	var/visible_name = name
	if(is_sewn())
		visible_name += " <span class='green'>(sewn)</span>"
	if(is_clotted())
		visible_name += " <span class='danger'>(clotted)</span>"
	return visible_name

/// Description of this wound returned to the player when the bodypart is checked with check_for_injuries()
/datum/wound/proc/get_check_name(mob/user)
	return check_name

/// Crit message that should be appended when this wound is applied in combat
/datum/wound/proc/get_crit_message(mob/living/affected, obj/item/bodypart/affected_bodypart)
	if(!length(crit_message))
		return
	var/final_message = pick(crit_message)
	if(affected)
		final_message = replacetext(final_message, "%VICTIM", "[affected.name]")
		final_message = replacetext(final_message, "%P_THEIR", "[affected.p_their()]")
	else
		final_message = replacetext(final_message, "%VICTIM", "victim")
		final_message = replacetext(final_message, "%P_THEIR", "their")
	if(affected_bodypart)
		final_message = replacetext(final_message, "%BODYPART", "[affected_bodypart.name]")
	else
		final_message = replacetext(final_message, "%BODYPART", parse_zone(BODY_ZONE_CHEST))
	if(critical)
		final_message = "<span class='crit'><b>Critical hit!</b> [final_message]</span>"
	return final_message

/// Sound that plays when this wound is applied to a mob
/datum/wound/proc/get_sound_effect(mob/living/affected, obj/item/bodypart/affected_bodypart)
	if(critical && prob(3))
		return 'sound/combat/tf2crit.ogg'
	return pick(sound_effect)

/// Returns whether or not this wound can be applied to a given bodypart
/datum/wound/proc/can_apply_to_bodypart(obj/item/bodypart/affected)
	if(bodypart_owner || owner || QDELETED(affected) || QDELETED(affected.owner))
		return FALSE
	if(!isnull(bleed_rate) && !affected.can_bloody_wound() && !bypass_bloody_wound_check)
		return FALSE
	for(var/datum/wound/other_wound as anything in affected.wounds)
		if(!can_stack_with(other_wound))
			return FALSE
	return TRUE

/// Returns whether or not this wound can be applied while this other wound is present
/datum/wound/proc/can_stack_with(datum/wound/other)
	return TRUE

/// Adds this wound to a given bodypart
/datum/wound/proc/apply_to_bodypart(obj/item/bodypart/affected, silent = FALSE, crit_message = FALSE)
	if(QDELETED(affected) || QDELETED(affected.owner))
		return FALSE
	if(bodypart_owner)
		remove_from_bodypart()
	else if(owner)
		remove_from_mob()
	LAZYADD(affected.wounds, src)
	sortTim(affected.wounds, GLOBAL_PROC_REF(cmp_wound_severity_dsc))
	bodypart_owner = affected
	owner = bodypart_owner.owner
	bodypart_owner.bleeding += bleed_rate // immediately apply our base bleeding
	on_bodypart_gain(affected)
	INVOKE_ASYNC(src, PROC_REF(on_mob_gain), affected.owner) //this is literally a fucking lint error like new species cannot possible spawn with wounds until after its ass
	if(crit_message)
		var/message = get_crit_message(affected.owner, affected)
		if(message)
			affected.owner.next_attack_msg += " [message]"
	if(!silent)
		var/sounding = get_sound_effect(affected.owner, affected)
		if(sounding)
			playsound(affected.owner, sounding, 100, vary = FALSE)
	return TRUE


/// Effects when a wound is gained on a bodypart
/datum/wound/proc/on_bodypart_gain(obj/item/bodypart/affected)
	if(bleed_rate && affected.bandage)
		affected.bandage_expire() //new bleeding wounds always expire bandages, fuck you
	if(disabling)
		affected.update_disabled()

/// Removes this wound from a given bodypart
/datum/wound/proc/remove_from_bodypart()
	if(!bodypart_owner)
		return FALSE
	set_bleed_rate(0)
	var/obj/item/bodypart/was_bodypart = bodypart_owner
	var/mob/living/was_owner = owner
	LAZYREMOVE(bodypart_owner.wounds, src)
	bodypart_owner = null
	owner = null
	on_bodypart_loss(was_bodypart)
	on_mob_loss(was_owner)
	return TRUE

/// Effects when a wound is lost on a bodypart
/datum/wound/proc/on_bodypart_loss(obj/item/bodypart/affected)
	if(disabling)
		affected.update_disabled()

/// Returns whether or not this wound can be applied to a given mob
/datum/wound/proc/can_apply_to_mob(mob/living/affected)
	if(bodypart_owner || owner || QDELETED(affected) || !HAS_TRAIT(affected, TRAIT_SIMPLE_WOUNDS))
		return FALSE
	for(var/datum/wound/other_wound as anything in affected.simple_wounds)
		if(!can_stack_with(other_wound))
			return FALSE
	return TRUE

/// Adds this wound to a given mob
/datum/wound/proc/apply_to_mob(mob/living/affected, silent = FALSE, crit_message = FALSE)
	if(QDELETED(affected) || !HAS_TRAIT(affected, TRAIT_SIMPLE_WOUNDS))
		return FALSE
	if(bodypart_owner)
		remove_from_bodypart()
	else if(owner)
		remove_from_mob()
	LAZYADD(affected.simple_wounds, src)
	sortList(affected.simple_wounds, GLOBAL_PROC_REF(cmp_wound_severity_dsc))
	owner = affected
	owner.simple_bleeding += bleed_rate // immediately apply our base bleed to the host mob
	on_mob_gain(affected)
	if(crit_message)
		var/message = get_crit_message(affected)
		if(message)
			affected.next_attack_msg += " [message]"
	if(!silent)
		var/sounding = get_sound_effect(affected)
		if(sounding)
			playsound(affected, sounding, 100, vary = FALSE)
	return TRUE

/// Effects when this wound is applied to a given mob
/datum/wound/proc/on_mob_gain(mob/living/affected)
	if(mob_overlay)
		affected.update_damage_overlays()
	if(werewolf_infection_timer)
		deltimer(werewolf_infection_timer)
		werewolf_infection_timer = null
		werewolf_infect_attempt()
	if(mortal && HAS_TRAIT(affected, TRAIT_CRITICAL_WEAKNESS))
		affected.death()

/// Removes this wound from a given, simpler than adding to a bodypart - No extra effects
/datum/wound/proc/remove_from_mob()
	if(!owner)
		return FALSE
	on_mob_loss(owner)
	set_bleed_rate(0)
	LAZYREMOVE(owner.simple_wounds, src)
	owner = null
	return TRUE

/// Effects when this wound is removed from a given mob
/datum/wound/proc/on_mob_loss(mob/living/affected)
	if(mob_overlay)
		affected.update_damage_overlays()

/// Called on handle_wounds(), on the life() proc
/datum/wound/proc/on_life()
	if(!isnull(clotting_threshold) && clotting_rate && (bleed_rate > clotting_threshold))
		set_bleed_rate(max(clotting_threshold, bleed_rate - clotting_rate))
	if(HAS_TRAIT(owner, TRAIT_PSYDONITE) && !passive_healing)
		heal_wound(0.6) // psydonites are supposed to apparently slightly heal wounds whether dead or alive
	if(owner.stat != DEAD && passive_healing) // passive healing is only called if we're like, you know, alive
		heal_wound(passive_healing)
	return TRUE

/// Called on handle_wounds(), on the life() proc
/datum/wound/proc/on_death()
	// for optimization's sake, only do dead wound healing if the mob has a client.
	if (!owner.client)
		return

	if (HAS_TRAIT(owner, TRAIT_PSYDONITE) && !passive_healing)
		heal_wound(0.6) // psydonites are supposed to apparently slightly heal wounds whether dead or alive
	
	return TRUE

/// Setter for any adjustments we make to our bleed_rate, propagating them to the host bodypart.
/datum/wound/proc/set_bleed_rate(amount)
	if(!owner)
		return

	// do simple bleeding
	if(owner.simple_wounds?.len)
		owner.simple_bleeding -= bleed_rate
		bleed_rate = amount
		owner.simple_bleeding += bleed_rate
		if(abs(owner.simple_bleeding) < 0.01) //Float underflow catch
			owner.simple_wounds = list()
			owner.simple_bleeding = 0
			owner.bleed_rate = 0
	else if(bodypart_owner)
		bodypart_owner.bleeding -= bleed_rate
		bleed_rate = amount
		bodypart_owner.bleeding += bleed_rate

/// Heals this wound by the given amount, and deletes it if it's healed completely
/datum/wound/proc/heal_wound(heal_amount)
	// Wound cannot be healed normally, whp is null
	if(isnull(whp))
		return 0
	var/amount_healed = min(whp, round(heal_amount, DAMAGE_PRECISION))
	var/pain_healed = min(woundpain, round(heal_amount / 2, DAMAGE_PRECISION))
	whp -= amount_healed
	woundpain -= pain_healed
	if(whp <= 0)
		if(!should_persist())
			if(bodypart_owner)
				remove_from_bodypart(src)
			else if(owner)
				remove_from_mob(src)
			else
				qdel(src)
	return amount_healed

/// Sews the wound up, changing its properties to the sewn ones
/datum/wound/proc/sew_wound()
	if(!can_sew)
		return FALSE
	var/old_overlay = mob_overlay
	mob_overlay = sewn_overlay
	set_bleed_rate(sewn_bleed_rate)
	clotting_rate = sewn_clotting_rate
	clotting_threshold = sewn_clotting_threshold
	woundpain = sewn_woundpain
	whp = min(whp, sewn_whp)
	disabling = FALSE
	can_sew = FALSE
	sleep_healing = max(sleep_healing, 1)
	passive_healing = max(passive_healing, 1)
	if(mob_overlay != old_overlay)
		owner?.update_damage_overlays()
	record_round_statistic(STATS_WOUNDS_SEWED)
	return TRUE

/// Checks if this wound has a special infection (zombie or werewolf)
/datum/wound/proc/has_special_infection()
	return (werewolf_infection_timer)

/// Some wounds cannot go away naturally
/datum/wound/proc/should_persist()
	if(has_special_infection())
		return TRUE
	return FALSE

/// Cauterizes the wound
/datum/wound/proc/cauterize_wound()
	if(!can_cauterize)
		return FALSE
	if(!isnull(clotting_threshold) && bleed_rate > clotting_threshold)
		set_bleed_rate(clotting_threshold)
	heal_wound(40)
	return TRUE

/// Checks if this wound is sewn
/datum/wound/proc/is_sewn()
	return (sew_progress >= sew_threshold)

/// Checks if this wound is clotted
/datum/wound/proc/is_clotted()
	return !isnull(clotting_threshold) && (bleed_rate <= clotting_threshold)

/// Returns whether or not this wound should embed a weapon
/proc/should_embed_weapon(datum/wound/wound_or_boolean, obj/item/weapon)
	if(!istype(wound_or_boolean))
		return FALSE
	if(weapon && !can_embed(weapon))
		return FALSE
	return prob(wound_or_boolean.embed_chance)

/// Upgrades a wound's stats based on damage dealt. Used mainly by dynamic wounds.
/datum/wound/proc/upgrade(dam as num)
	SHOULD_CALL_PARENT(TRUE)	//Don't skip this if you're making new dynamic wounds.
	return

/datum/wound/proc/update_name()
	var/newname
	var/oldname = name
	if(length(severity_names))
		for(var/sevname in severity_names)
			if(!bleed_rate) //if it's a hematoma, use whp for naming
				if(severity_names[sevname] <= whp)
					newname = sevname
			else if(severity_names[sevname] <= bleed_rate)
				newname = sevname
	name = "[newname  ? "[newname] " : ""][initial(name)]"	//[adjective] [name], aka, "gnarly slash" or "slash"
	if(name != oldname)
		owner.visible_message(span_red("The [oldname] on [owner]'s [lowertext(bodyzone2readablezone(bodypart_to_zone(bodypart_owner)))] gets worse!"))

// Blank because it'll be overridden by wound code.
/datum/wound/dynamic
	var/is_maxed = FALSE
	var/is_armor_maxed = FALSE
	clotting_rate = 0.4
	clotting_threshold = 0

/datum/wound/dynamic/sew_wound()
	heal_wound(whp)

/datum/wound/dynamic/proc/armor_check(armor, cap)
	if(armor)
		if(!bodypart_owner.unlimited_bleeding)
			if(bleed_rate >= cap)
				set_bleed_rate(cap)
				if(!is_armor_maxed)
					playsound(owner, 'sound/combat/armored_wound.ogg', 100, TRUE)
					owner.visible_message(span_crit("The wound tears open from [bodypart_owner.owner]'s <b>[bodyzone2readablezone(bodypart_to_zone(bodypart_owner))]</b>, the armor won't let it go any further!"))
					is_armor_maxed = TRUE

#define CLOT_THRESHOLD_INCREASE_PER_HIT 0.1	//This raises the MINIMUM bleed the wound can clot to.
#define CLOT_DECREASE_PER_HIT 0.05	//This reduces the amount of clotting the wound has.
#define CLOT_RATE_ARTERY 0	//Artery exceptions. Essentially overrides the clotting threshold.
#define CLOT_THRESHOLD_ARTERY 2

/// Make sure this is called AFTER your child upgrade proc, unless you have a reason for the bleed rate to be above artery on a regular wound.
/datum/wound/dynamic/upgrade(dam as num)
	if(!bodypart_owner.unlimited_bleeding)
		if(bleed_rate >= ARTERY_LIMB_BLEEDRATE)
			set_bleed_rate(ARTERY_LIMB_BLEEDRATE)
			if(!is_maxed)
				playsound(owner, 'sound/combat/wound_tear.ogg', 100, TRUE)
				owner.visible_message(span_crit("The wound gushes open from [bodypart_owner.owner]'s <b>[bodyzone2readablezone(bodypart_to_zone(bodypart_owner))]</b>, nicking an artery!"))
				is_maxed = TRUE
			clotting_rate = CLOT_RATE_ARTERY
			clotting_threshold = CLOT_THRESHOLD_ARTERY
	if(!is_maxed)
		clotting_rate = max(0.01, (clotting_rate - CLOT_DECREASE_PER_HIT))
		clotting_threshold += CLOT_THRESHOLD_INCREASE_PER_HIT
	..()

#undef CLOT_THRESHOLD_INCREASE_PER_HIT
#undef CLOT_DECREASE_PER_HIT
#undef CLOT_RATE_ARTERY
#undef CLOT_THRESHOLD_ARTERY
