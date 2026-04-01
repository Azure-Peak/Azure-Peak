#define RAGE_FILTER "rage_aura"

/proc/get_buff_value(mob/living/L)
	var/brute = L.getBruteLoss()
	var/burn = L.getFireLoss()
	var/ragedmgbuff = 0
	if(HAS_TRAIT (L, TRAIT_NOPAIN)) //lickers and whatever other things get locked to base buff
		return 0
	if(brute + burn > 125)
		ragedmgbuff = 1
	if(brute + burn > 225)
		ragedmgbuff = 2
	if(brute + burn > 425)
		ragedmgbuff = 3
	if(brute + burn > 625)
		ragedmgbuff = 4
	return ragedmgbuff

/obj/effect/proc_holder/spell/self/rage
	name = "RAGE"
	desc = "GETTING HURT MAKES YOU ANGRY, MAKE THEM HURT BACK- MORE HURT IS MORE ANGRY!"
	antimagic_allowed = TRUE
	clothes_req = FALSE
	recharge_time = 2 MINUTES
	invocations = list("enters a state of furious rage!")
	invocation_type = "emote"

/obj/effect/proc_holder/spell/self/rage/cast(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE		
	user.apply_status_effect(/datum/status_effect/buff/rage)
	if(get_buff_value(user) >= 1)
		user.apply_status_effect(/datum/status_effect/buff/rage_stamina)
	return TRUE

/atom/movable/screen/alert/status_effect/buff/rage
	name = "RAGE"
	desc = "YOU'RE MAKING ME ANGRY!"
	icon_state = "buff"

/datum/status_effect/buff/rage
	id = "rage"
	examine_text = "<font color='red'>SUBJECTPRONOUN is frothing at the mouth!</font>"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rage
	effectedstats = list(STATKEY_STR = 1)
	duration = 90 SECONDS
	var/ragebuff = 0
	var/outline_colour = "#ca0000"

/datum/status_effect/buff/rage/on_apply()
	update_effects()
	. = ..()
	if(.)
		var/filter = owner.get_filter(RAGE_FILTER)
		if(!filter)
			owner.add_filter(RAGE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 120, "size" = 1))
		owner.emote("rage", forced = TRUE)
		to_chat(owner, span_notice("PAIN FUELS MY RAGE, MY BODY IS READY TO FIGHT!"))
		playsound(owner, 'sound/combat/hits/burn (2).ogg', 100, TRUE)

/datum/status_effect/buff/rage/on_remove()
	. = ..()
	owner.remove_filter(RAGE_FILTER)
	to_chat(owner, span_warning("Rage subsides."))

/datum/status_effect/buff/rage/proc/update_effects()
	ragebuff = get_buff_value(owner)
	if(ragebuff < 1)
		effectedstats = list(STATKEY_STR = 1)
	else if(ragebuff < 2)
		effectedstats = list(STATKEY_CON = 2, STATKEY_STR = 1)
	else if(ragebuff < 3)
		effectedstats = list(STATKEY_CON = 2, STATKEY_STR = 2)
	else if(ragebuff < 4)
		effectedstats = list(STATKEY_CON = 2, STATKEY_WIL = 2, STATKEY_STR = 2)
	else
		effectedstats = list(STATKEY_CON = 3, STATKEY_WIL = 3, STATKEY_STR = 3)

/atom/movable/screen/alert/status_effect/buff/rage_stamina
	name = "RAAADRENALINE"
	desc = "THE ANGER DRAINS MY FATIGUE!"
	icon_state = "buff"

/datum/status_effect/buff/rage_stamina
	id = "rage stamina"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rage_stamina
	duration = 20 SECONDS
	var/healing_on_tick = 8
	var/tech_healing_modifier = 1

/datum/status_effect/buff/rage_stamina/tick()
	if(owner.construct)
		return
	var/stamheal = healing_on_tick
	owner.energy_add(stamheal)

//worse version for advent barbarian

/obj/effect/proc_holder/spell/self/ragebad
	name = "RAGE"
	desc = "GETTING HURT MAKES YOU ANGRY, MAKE THEM HURT BACK- MORE HURT IS MORE ANGRY!"
	antimagic_allowed = TRUE
	clothes_req = FALSE
	recharge_time = 2 MINUTES
	invocations = list("enters a state of furious rage!")
	invocation_type = "emote"

/obj/effect/proc_holder/spell/self/ragebad/cast(mob/living/carbon/human/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE		
	user.apply_status_effect(/datum/status_effect/buff/ragebad)
	return TRUE

/datum/status_effect/buff/ragebad
	id = "ragebad"
	examine_text = "<font color='red'>SUBJECTPRONOUN is frothing at the mouth!</font>"
	alert_type = /atom/movable/screen/alert/status_effect/buff/rage
	effectedstats = list(STATKEY_STR = 1)
	duration = 90 SECONDS
	var/ragebuff = 0
	var/outline_colour = "#ca0000"

/datum/status_effect/buff/ragebad/on_apply()
	update_effects()
	. = ..()
	if(.)
		var/filter = owner.get_filter(RAGE_FILTER)
		if(!filter)
			owner.add_filter(RAGE_FILTER, 2, list("type" = "outline", "color" = outline_colour, "alpha" = 120, "size" = 1))
		owner.emote("rage", forced = TRUE)
		to_chat(owner, span_notice("PAIN FUELS MY RAGE, MY BODY IS READY TO FIGHT!"))
		playsound(owner, 'sound/combat/hits/burn (2).ogg', 100, TRUE)

/datum/status_effect/buff/ragebad/on_remove()
	. = ..()
	owner.remove_filter(RAGE_FILTER)
	to_chat(owner, span_warning("Rage subsides."))

/datum/status_effect/buff/ragebad/proc/update_effects()
	ragebuff = get_buff_value(owner)
	if(ragebuff < 1)
		effectedstats = list(STATKEY_STR = 1)
	else if(ragebuff < 3)
		effectedstats = list(STATKEY_CON = 2, STATKEY_STR = 1)
	else
		effectedstats = list(STATKEY_CON = 2, STATKEY_WIL = 2, STATKEY_STR = 2)

#undef RAGE_FILTER
