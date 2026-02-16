//Call to Slaughter - AoE buff for all people surrounding you.
/obj/effect/proc_holder/spell/self/call_to_slaughter
	name = "Call to Slaughter"
	desc = "Grants you and all allies nearby a buff to their strength, willpower, and constitution."
	overlay_state = "call_to_slaughter"
	recharge_time = 5 MINUTES
	invocations = list("GRAGGAAAAAAAAAR!!") 	//MUSTAAAAAAAAAAAAAARD
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
	desc = "Unleashes a snare of external blood and guts. The viscera winds around the legs of mortals... \
	Though has little effect on simple creatures."
	overlay_state = "unholy_grasp"
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/magic/unholy_grasp
	chargedloop = /datum/looping_sound/invokeascendant // this should stand out on a gaggar guy
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 40 SECONDS // no running, super slow. this FUCKS people. lower it if 40 is too much.
	invocation_type = "shout"
	invocations = list("STOP RUNNING, COWARD!!") // VERY loud. do NOT add other invocations, this projectile can FUUUCK people up and needs to be telegraphed.
	sound = 'sound/magic/soulsteal.ogg'

/obj/projectile/magic/unholy_grasp
	name = "visceral organ net"
	icon_state = "tentacle_end"
	nodamage = TRUE
	range = 8 // you can dodge it, see speed. lower if need be.
	speed = 1.6
	hitsound = 'sound/magic/slimesquish.ogg'

/obj/projectile/magic/unholy_grasp/on_hit(target)
	. = ..()
	if(!iscarbon(target))
		return
	if(target)
		ensnare(target)

/obj/projectile/magic/unholy_grasp/proc/ensnare(mob/living/carbon/carbon)
	if(carbon.legcuffed || carbon.get_num_legs(FALSE) < 2)
		return

	carbon.visible_message(span_warning("The [src] ensnares [carbon] around their legs in a horrid cacophany of blood and guts!"), span_warning("I AM ENCAPTURED BY BLOOD AND GUTS! THERES A NET ON MY LEGS!"))
	carbon.legcuffed = src
	forceMove(carbon)
	carbon.update_inv_legcuffed()
	SSblackbox.record_feedback("tally", "handcuffs", 1, type)
	carbon.Knockdown(knockdown)
	carbon.apply_status_effect(/datum/status_effect/debuff/netted)
	playsound(src, 'sound/combat/caught.ogg', 50, TRUE)

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter
	name = "Revel in Slaughter"
	desc = "The blood of your enemy shall boil, increasing their blood and pain tenfold! THE BLOOD MUST FLOW!!!"
	overlay_state = "bloodsteal"
	recharge_time = 1 MINUTES
	invocations = list("snaps their fingers at their enemy, causing their wounds to gush more blood than should be possible!") 				//what the fuck did "your blood will boil till it's spilled" mean.
	invocation_type = "emote"
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
	to_chat(human, span_warning("My own blood fills my lungs! The pain is unbearable!"))

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
	desc = "Tap into Graggar's wellspring of strength and knowledge, granting unbound power at the cost of temporary insanity and physical exhaustion." 		//reflavored into "graggar grants you some of the strength he got from stealing the souls of miscellaneous ravoxians"
	overlay_state = "bloodrage"
	recharge_time = 5 MINUTES
	invocations = list("GRAGGAAAAAAAAAAAR!!",
		"WHERE'S THE DEATH?!!",
		"YOU! CAN'T!! KILL!!! ME!!!!",
		"I CAN HEAR EVERYTHING!!",
		"WE'LL ALL GO TOGETHER!!",
		"BLOOD AND NOISE, FOREVER PIERCING MY SKULL!!",
		"I AM THE INSIDE OF THIS WORLD!!",
		"I TASTE THE GORE! I SMELL THE CRYING! I! WANT! MORE!!",
		"THE BLOOD IS IN MY EYES!! IT'S WAVES CRASH AGAINST MY FOREHEAD!!",
		"LOOK AT ME WHEN I SCREAM INTO YOUR SOUL!!",
		"GRAGGARDAMMERUUUUNG!!" // they took our night awayyy gotterdammeruuungggg
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
