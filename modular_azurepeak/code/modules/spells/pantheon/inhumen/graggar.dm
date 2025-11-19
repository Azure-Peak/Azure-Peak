//Call to Slaughter - AoE buff for all people surrounding you.
/obj/effect/proc_holder/spell/self/call_to_slaughter
	name = "Call to Slaughter"
	desc = "Grants you and all allies nearby a buff to their strength, willpower, and constitution."
	overlay_state = "call_to_slaughter"
	recharge_time = 5 MINUTES
	invocations = list("LAMBS TO THE SLAUGHTER!")
	invocation_type = "shout"
	sound = 'sound/magic/timestop.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 40

/obj/effect/proc_holder/spell/self/call_to_slaughter/cast(list/targets,mob/living/user = usr)
	for(var/mob/living/carbon/target in view(3, get_turf(user)))
		if(istype(target.patron, /datum/patron/inhumen))
			target.apply_status_effect(/datum/status_effect/buff/call_to_slaughter)	//Buffs inhumens
			continue
		if(istype(target.patron, /datum/patron/old_god))
			to_chat(target, span_danger("You feel a surge of cold wash over you; leaving your body as quick as it hit.."))	//No effect on Psydonians!
			continue
		if(!user.faction_check_mob(target))
			continue
		if(target.mob_biotypes & MOB_UNDEAD)
			continue
		target.apply_status_effect(/datum/status_effect/debuff/call_to_slaughter)	//Debuffs non-inhumens/psydonians
	return TRUE

//Unholy Grasp - Throws disappearing net made of viscera at enemy. Creates blood on impact.
/obj/effect/proc_holder/spell/invoked/projectile/blood_net
	name = "Unholy Grasp"
	desc = "Toss forth an unholy snare of blood and guts a short distance, summoned from your leftover trophies sacrificed to Graggar. Like a net, may it snare your target!"
	clothes_req = FALSE
	overlay_state = "unholy_grasp"
	range = 3													//It's a net, so low range.
	req_inhand = /obj/item/alch/viscera							//Need to have viscera inhand to cast this.
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/magic/unholy_grasp
	chargedloop = /datum/looping_sound/invokeholy
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS

/obj/projectile/magic/unholy_grasp
	name = "viceral organ net"
	icon_state = "tentacle_end"
	nodamage = TRUE

/obj/projectile/magic/unholy_grasp/on_hit(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(..() || !iscarbon(hit_atom))
		return
	
	ensnare(hit_atom)

/obj/projectile/magic/unholy_grasp/proc/ensnare(mob/living/carbon/carbon)
	if(carbon.legcuffed || carbon.get_num_legs(FALSE) < 2)
		return

	visible_message(span_danger("\The [src] ensnares [carbon] in vicera!"))
	carbon.legcuffed = src
	forceMove(carbon)
	carbon.update_inv_legcuffed()
	SSblackbox.record_feedback("tally", "handcuffs", 1, type)
	to_chat(carbon, span_danger("\The [src] ensnares you!"))
	carbon.Knockdown(knockdown)
	carbon.apply_status_effect(/datum/status_effect/debuff/netted)
	playsound(src, 'sound/combat/caught.ogg', 50, TRUE)

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter
	name = "Revel in Slaughter"
	desc = "The blood of your enemy shall boil, their skin feeling as if it's being ripped apart! Graggar demands their blood must FLOW!!!"
	overlay_state = "bloodsteal"
	recharge_time = 1 MINUTES
	invocations = list("YOUR BLOOD WILL BOIL TILL IT'S SPILLED!")
	invocation_type = "shout"
	sound = 'sound/magic/antimagic.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 70

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/human/human = targets[1]

	if(!istype(human) || human == user)
		revert_cast()
		return FALSE

	var/success = 0

	for(var/obj/effect/decal/cleanable/blood/blood in view(3, user))
		success++
		qdel(blood)

	if(!success)
		to_chat(user, span_warning("Graggar demands BLOOD to call upon his powers!"))
		revert_cast()
		return FALSE

	var/datum/physiology/phy = human.physiology

	phy.bleed_mod *= 1.5
	phy.pain_mod *= 1.5

	addtimer(CALLBACK(src, PROC_REF(restore_bleed_mod), phy), 25 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(restore_pain_mod), phy), 15 SECONDS)

	human.visible_message(span_danger("[human]'s wounds become inflammed as their vitality is sapped away!"))
	to_chat(human, span_warning("My skins feels like pins and needles, as if something were ripping and tearing at me!"))

	return TRUE

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter/proc/restore_bleed_mod(datum/physiology/physiology)
	if(!physiology)
		return

	physiology.bleed_mod /= 1.5

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter/proc/restore_pain_mod(datum/physiology/physiology)
	if(!physiology)
		return

	physiology.pain_mod /= 1.5

//Bloodrage T0 -- Uncapped STR buff.
/obj/effect/proc_holder/spell/self/graggar_bloodrage
	name = "Bloodrage"
	desc = "Grants you unbound strength for a short while."
	overlay_state = "bloodrage"
	recharge_time = 5 MINUTES
	invocations = list("GRAGGAR!! GRAGGAR!! GRAGGAR!!",
		"GRAGGAR! BREAK MY CHAINS!",
		"GRAGGAR! SHATTER MY BINDS!"
	)
	invocation_type = "shout"
	sound = 'sound/magic/bloodrage.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 80
	antimagic_allowed = FALSE
	var/static/list/purged_effects = list(
	/datum/status_effect/incapacitating/immobilized,
	/datum/status_effect/incapacitating/paralyzed,
	/datum/status_effect/incapacitating/stun,
	/datum/status_effect/incapacitating/knockdown,)

/obj/effect/proc_holder/spell/self/graggar_bloodrage/cast(list/targets, mob/user)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	if(H.resting)
		H.set_resting(FALSE, FALSE)
	H.emote("warcry")
	for(var/effect in purged_effects)
		H.remove_status_effect(effect)
	H.apply_status_effect(/datum/status_effect/buff/bloodrage)
	H.visible_message(span_danger("[H] rises upward, boiling with immense rage!"))
	return TRUE
