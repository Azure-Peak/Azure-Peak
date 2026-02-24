//Call to Slaughter - AoE buff for all people surrounding you.
/obj/effect/proc_holder/spell/self/call_to_slaughter
	name = "Call to Slaughter"
	desc = "Grants you and all allies nearby a buff to their strength, willpower, and constitution. Debuffs followers of the Ten, but not Psydonites.\
	Works in a three tile radius around you."
	overlay_state = "call_to_slaughter"
	recharge_time = 5 MINUTES
	invocations = list("LAMBS TO THE SLAUGHTER!", "THE DARK STAR IS WATCHING!") // idk who changed it but it was identical to bloodrage. bad.
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
	Though has little effect on simple creatures. Mortals cannot remove the net, but it decays ten seconds after landing."
	overlay_state = "unholy_grab"
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/magic/unholy_grasp
	chargedloop = /datum/looping_sound/invokeascendant // this should stand out on a gaggar guy
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 40 SECONDS // no running, super slow. this FUCKS people. lower it if 40 is too much.
	invocation_type = "shout"
	invocations = list("TURN AND FACE THE BLOOD GOD!!") // VERY loud. do NOT add other invocations, this projectile can FUUUCK people up and needs to be telegraphed.
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
		carbon.visible_message(span_warning("The net slides off-- it has no effect!"))
		return

	carbon.visible_message(span_warning("The [src] ensnares [carbon] around their legs in a horrid cacophany of blood and guts!"), span_warning("I AM ENCAPTURED BY BLOOD AND GUTS! THERES A NET ON MY LEGS!"))
	carbon.legcuffed = src
	forceMove(carbon)
	carbon.update_inv_legcuffed()
	SSblackbox.record_feedback("tally", "handcuffs", 1, type)
	carbon.apply_status_effect(/datum/status_effect/debuff/netted/vile)
	playsound(src, 'sound/combat/caught.ogg', 50, TRUE)

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter
	name = "Revel in Death"
	desc = "Increases the bleeding and pain of a target. Their blood-loss amount scales with every point of constitution over ten. \
	Those with ten or less constituion will instead have a flat rate (x1.25)."
	overlay_state = "bloodsteal"
	recharge_time = 1 MINUTES
	chargetime = 10
	chargedrain = 0
	chargedloop = /datum/looping_sound/invokeevil
	invocations = list("SUFFER FOR THE DARK STAR!", "SINISTAR, MAKE THEM BLEED!")
	invocation_type = "shout"
	sound = 'sound/magic/antimagic.ogg'
	releasedrain = 30
	miracle = TRUE
	devotion_cost = 70

/obj/effect/proc_holder/spell/invoked/revel_in_slaughter/cast(list/targets, mob/living/user = usr)
	var/mob/living/carbon/human/human = targets[1]

	if(!istype(human) || human == user)
		to_chat(user, span_danger("THAT WONT WORK!"))
		revert_cast()
		return FALSE

	if(spell_guard_check(human, TRUE))
		human.visible_message(span_warning("[human] resists the bloodlust!"))
		return TRUE
	
	human.apply_status_effect(/datum/status_effect/debuff/bloody_mess)
	human.apply_status_effect(/datum/status_effect/debuff/sensitive_nerves)

	return TRUE

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
