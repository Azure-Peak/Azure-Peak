/obj/effect/proc_holder/spell/self/suicidebomb
	name = "Calcic Outburst"
	desc = "Explode in a wonderful blast of osseous shrapnel."
	overlay_state = "tragedy"
	chargedrain = 0
	chargetime = 0
	recharge_time = 10 SECONDS
	sound = 'sound/magic/swap.ogg'
	warnie = "spellwarning"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	stat_allowed = TRUE
	var/exp_heavy = 2
	var/exp_light = 5
	var/exp_flash = 5
	var/exp_fire = 0

/obj/effect/proc_holder/spell/self/suicidebomb/cast(list/targets, mob/living/user = usr)
	..()
	if(!user)
		revert_cast()
		return FALSE
	if(user.stat == DEAD)
		revert_cast()
		return FALSE
	if(alert(user, "Do you wish to sacrifice this vessel in a powerful explosion?", "ELDRITCH BLAST", "Yes", "No") == "No")
		revert_cast()
		return FALSE

	user.Immobilize(5 SECONDS)
	user.Knockdown(5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(skele_explode), user, user, exp_heavy, exp_light, exp_flash, exp_fire), 5 SECONDS)
	return TRUE

/obj/effect/proc_holder/spell/proc/skele_explode(mob/living/user, mob/living/target = user, exp_heavy, exp_light, exp_flash, exp_fire)
	var/datum/antagonist/lich/lich_antag

	if(user.mind.has_antag_datum(/datum/antagonist/lich))
		lich_antag = user.mind.has_antag_datum(/datum/antagonist/lich)

	if(user != target && !user.mind)
		exp_light -= 2
		exp_flash -= 2

	playsound(get_turf(target), 'sound/magic/antimagic.ogg', 100)
	target.visible_message(
		span_danger("[target] begins to shake violently, a blindingly bright light beginning to emanate from them!")
	)

	explosion((user == target) ? get_turf(user) : get_turf(target), 1, exp_heavy, exp_light, exp_flash, 0, flame_range = exp_fire, soundin = 'sound/misc/explode/incendiary (1).ogg')
	if(lich_antag && user.stat != DEAD && lich_antag.consume_phylactery(0) && user == target) // Use phylactery at 0 timer. Die if none.
		return TRUE

	target.gib()
	return TRUE

/obj/effect/proc_holder/spell/self/suicidebomb/lesser
	name = "Lesser Calcic Outburst"
	exp_heavy = 0
	exp_light = 3
	exp_flash = 3
	exp_fire = 0


/obj/effect/proc_holder/spell/invoked/remotebomb
	name = "Shell Outburst"
	desc = "Cause a minion to give up their lyfe for the Exarch.."
	overlay_state = "tragedy"
	chargedrain = 0
	range = 7
	chargetime = 2 SECONDS
	recharge_time = 15 SECONDS
	gesture_required = TRUE
	charging_slowdown = 1
	sound = 'sound/magic/swap.ogg'
	warnie = "spellwarning"
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	stat_allowed = TRUE
	var/exp_heavy = 1
	var/exp_light = 3
	var/exp_flash = 3
	var/exp_fire = 0

/obj/effect/proc_holder/spell/invoked/remotebomb/cast(list/targets, mob/living/user)
	..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]

	if(target == user)
		to_chat(user, span_warning("I've my own manoeuvre for this."))
		revert_cast()
		return FALSE

	if(!istype(target, /mob/living/carbon/human/species/skeleton))
		to_chat(user, span_warning("[target] is not a shambler. I'm powerless."))
		revert_cast()
		return FALSE

	user.pointed(target)

	if(target.mind)
		to_chat(target, span_warning("The Exarch calls for me. This is it!"))

	target.Immobilize(5 SECONDS)
	target.Knockdown(5 SECONDS)

	addtimer(CALLBACK(src, PROC_REF(skele_explode), user, target, exp_heavy, exp_light, exp_flash, exp_fire), 5 SECONDS)
