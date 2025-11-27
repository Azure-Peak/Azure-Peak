//Baotha's Blessings - T1, reverses overdose effect on a target + soothing moodlet. (Medieval narcan..... #BanNarcan)

/obj/effect/proc_holder/spell/invoked/baothablessings
	name = "Baotha's Blessings"
	desc = "Gets the target drunk and stops them from overdosing for a time."
	overlay_state = "lesserheal"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/heal.ogg'
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 10

/obj/effect/proc_holder/spell/invoked/baothablessings/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/carbon/target = targets[1]
		if(HAS_TRAIT(target, TRAIT_PSYDONITE))
			target.visible_message(span_info("[target] stirs for a moment, the miracle dissipates."), span_notice("A dull warmth swells in your heart, only to fade as quickly as it arrived."))
			user.playsound_local(user, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			playsound(target, 'sound/magic/PSY.ogg', 100, FALSE, -1)
			return FALSE
		if(target.has_status_effect(/datum/status_effect/buff/druqks/baotha))
			to_chat(user, span_warning("They're already blessed by these effects!"))
			revert_cast()
			return FALSE
		target.apply_status_effect(/datum/status_effect/buff/druqks/baotha) //Gets the trait temorarily, basically will just stop any active/upcoming ODs.	
		target.visible_message("<span class='info'>[target]'s eyes appear to gloss over!</span>", "<span class='notice'>I feel.. at ease.</span>")

//Enrapturing Powder - T2, basically a crackhead blowing cocaine in your face.

/obj/effect/proc_holder/spell/invoked/projectile/blowingdust
	name = "Enrapturing Powder"
	desc = "Blows dust of a potent painkilling drug at the target."
	clothes_req = FALSE
	range = 3	//It's literally blowing coke in their face, basically.
	associated_skill = /datum/skill/magic/holy
	projectile_type = /obj/projectile/magic/blowingdust
	chargedloop = /datum/looping_sound/invokeholy
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS
	invocation_type = "whisper"
	invocations = list("Have a taste of the maiden's pure-bliss...")
	devotion_cost = 30

/obj/projectile/magic/blowingdust
	name = "unholy dust"
	icon_state = "spark"
	nodamage = FALSE
	damage = 1
	poisontype = /datum/reagent/herozium
	poisonfeel = "burning" //Would make sense for your eyes or nose to burn, I guess.
	poisonamount = 8 //Decent bit of high, three doses would be just above the overdose threshold if applied fast enough.

/obj/projectile/magic/blowingdust/on_hit(target, mob/living/M)
	. = ..()
	if(!istype(M))
		return
	if(target)
		to_chat(target, span_warning("Gah! Something.. got in my - eyes.."))
		M.blur_eyes(2)

//Numbing Pleasure - T3, removes all pain from self for a period of time. (Similar to Ravox's without any blood-clotting and better pain suppression + good mood buff.)
/obj/effect/proc_holder/spell/invoked/painkiller
	name = "Numbing Pleasure"
	desc = "Numbs the targets pain and improves their mood."
	overlay_state = "astrata"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	sound = 'sound/magic/timestop.ogg'
	invocations = list("May you find bliss through your pain!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 90 SECONDS
	miracle = TRUE
	devotion_cost = 75

/obj/effect/proc_holder/spell/invoked/painkiller/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/mob/living/carbon/human/human_target = target
		var/datum/physiology/phy = human_target.physiology
		if(target.mob_biotypes & MOB_UNDEAD)
			return FALSE	//No, you don't get to feel good. You're a undead mob. Feel bad.
		target.visible_message(span_info("[target] begins to twitch as warmth radiates from them!"), span_notice("The pain from my wounds fade, every new one being a mere, pleasent warmth!"))
		phy.pain_mod *= 0.5	//Literally halves your pain modifier.
		addtimer(CALLBACK(src, PROC_REF(restore_pain_mod), phy), 1 MINUTES)
		target.apply_status_effect(/datum/status_effect/buff/vitae)					//+2 Fortune and mood buff
		return TRUE

/obj/effect/proc_holder/spell/invoked/painkiller/proc/restore_pain_mod(datum/physiology/physiology)
	if(!physiology)
		return

	physiology.pain_mod /= 0.5

//T0 that tells the user the person's vice.
/obj/effect/proc_holder/spell/invoked/baothavice
	name = "Tell Vice"
	desc = "Tells you the targets Vice."
	overlay_state = "baotha_vice"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	range = 3
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocation_type = "none"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 SECONDS 
	miracle = TRUE
	devotion_cost = 10
	var/list/fake_vices = list()

/obj/effect/proc_holder/spell/invoked/baothavice/cast(list/targets, mob/living/user)
	if(ishuman(targets[1]))
		var/vice_found
		var/mob/living/carbon/human/H = targets[1]
		if(HAS_TRAIT(H, TRAIT_DECEIVING_MEEKNESS) && user.get_skill_level(/datum/skill/magic/holy) <= SKILL_LEVEL_NOVICE)
			if(!(H in fake_vices))
				fake_vices[H] = pick(GLOB.character_flaws)
				vice_found = fake_vices[H]
			else
				vice_found = fake_vices[H]
			if(prob(50 + ((H.STAPER - 10) * 10)))
				to_chat(H, span_warning("A pair of prying eyes were laid on me..."))
		if(!vice_found)
			vice_found = H.charflaw.name
		to_chat(user, span_info("They are... [span_warning("a [vice_found]")]"))
		return TRUE
	revert_cast()
	return FALSE

// T0, orison inspired healing spell that pours a drink called Lover's Ruin. Works like a red for baotha blessed, poisons non-blessed.
/obj/effect/proc_holder/spell/targeted/touch/loversruin
	name = "Lover's Ruin"
	desc = "A toast to passion that ends in ash.\n \
		Beseech Baotha to pour wine onto a container. Poisons the unfaithful, rewards Her blessed with healing."
	overlay_state = "aerosolize"
	chargedrain = 0
	chargetime = 0
	releasedrain = 5
	miracle = TRUE
	devotion_cost = 5
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	hand_path = /obj/item/melee/touch_attack/loversruin
	recharge_time = 2 MINUTES

/obj/item/melee/touch_attack/loversruin
	name = "Baotha's Touch"
	catchphrase = null
	possible_item_intents = list(/datum/intent/fill)
	icon = 'icons/mob/roguehudgrabs.dmi'
	icon_state = "pulling"
	icon_state = "grabbing_greyscale"
	color = "#FFFFFF"
	var/right_click = FALSE

/obj/item/melee/touch_attack/loversruin/attack_self()
	qdel(src)

/obj/item/melee/touch_attack/loversruin/afterattack(atom/target, mob/living/carbon/human/user, proximity)
	if(istype(user.used_intent, /datum/intent/fill) && create_ichor(target, user))
		qdel(src)

/datum/reagent/medicine/loversruin
	name = "Lover's Ruin"
	description = "A sweet smelling concoction. It has small charred petals swimming on the surface."
	color = "#9c2745"
	taste_description = "sin"

/datum/reagent/medicine/loversruin/on_mob_life(mob/living/carbon/M)
	if(HAS_TRAIT(M, TRAIT_CRACKHEAD))
		if(volume >= 60)
			M.reagents.remove_reagent(/datum/reagent/medicine/loversruin, 2)
		if(M.blood_volume < BLOOD_VOLUME_NORMAL)
			M.blood_volume = min(M.blood_volume+40, BLOOD_VOLUME_MAXIMUM)
		var/list/wCount = M.get_wounds()
		if(wCount.len > 0)
			M.heal_wounds(4.5)
		if(volume > 0.99)
			M.adjustBruteLoss(-2  * REAGENTS_EFFECT_MULTIPLIER, 0)
			M.adjustFireLoss(-2  * REAGENTS_EFFECT_MULTIPLIER, 0)
			M.adjustOxyLoss(-2, 0)
			M.adjustToxLoss(-2, 0)
			M.adjustOrganLoss(ORGAN_SLOT_BRAIN, -5  * REAGENTS_EFFECT_MULTIPLIER)
			M.adjustCloneLoss(-4  * REAGENTS_EFFECT_MULTIPLIER, 0)
	else
		M.adjustToxLoss(3, 0)
		M.adjustOxyLoss(1, 0)
	..()

/obj/item/melee/touch_attack/loversruin/proc/create_ichor(atom/thing, mob/living/carbon/human/user)
	if(!thing.Adjacent(user))
		to_chat(user, span_info("I need to be closer to [thing] in order to try filling it with the concoction."))
		return

	if(thing.is_refillable())
		if(thing.reagents.holder_full())
			to_chat(user, span_warning("[thing] is full."))
			return
		
		user.visible_message(span_info("[user] closes [user.p_their()] eyes in prayer and extends a hand over [thing] as a sweet smelling ichor begins to stream from [user.p_their()] fingertips..."), span_notice("I call forth [user.patron.name], to fill [thing] with Her blessings..."))

		var/holy_skill = user.get_skill_level(attached_spell.associated_skill)
		var/drip_speed = 56 - (holy_skill * 8)
		var/fatigue_spent = 0
		var/fatigue_used = max(3, holy_skill)
		while(do_after(user, drip_speed, target = thing))
			if(thing.reagents.holder_full() || (user.devotion.devotion - fatigue_used <= 0))
				break

			var/water_qty = max(1, holy_skill) + 1
			var/list/water_contents = list(/datum/reagent/medicine/loversruin = water_qty)
			var/datum/reagents/reagents_to_add = new()
			reagents_to_add.add_reagent_list(water_contents)
			reagents_to_add.trans_to(thing, reagents_to_add.total_volume, transfered_by = user, method = INGEST)

			fatigue_spent += fatigue_used
			user.stamina_add(fatigue_used)
			user.devotion?.update_devotion(-1.0)

			if(prob(80))
				playsound(user, 'sound/items/fillcup.ogg', 55, TRUE)
		
		return max(50, fatigue_spent)
	else
		to_chat(user, span_info("I'll need to find a container that can hold Her blessing."))

//T1, Baotha's version of Eora's Bud (now renamed True Peace Bloom). Applies the TRAIT_CRACKHEAD baothans have.
/obj/effect/proc_holder/spell/invoked/griefflower
	name = "False Serenity Bloom"
	desc = "A gift for those whom you have choosen as worthy of Her grace, to be able to imbibe in Her gifts as you do."
	clothes_req = FALSE
	range = 7
	overlay_state = "love"
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 10
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/holy
	recharge_time = 30 MINUTES //To avoid spamming this shit and giving all heretics florida-man crackhead superpowers. No Bro.

/obj/effect/proc_holder/spell/invoked/griefflower/cast(mob/living/user)
	var/turf/T = get_turf(user)
	if(!isclosedturf(T))
		new /obj/item/clothing/ring/griefflower(T)
		return TRUE

	to_chat(user, span_warning("The targeted location is blocked. Her gift cannot be invoked."))
	revert_cast()
	return FALSE

/obj/item/clothing/ring/griefflower
	name = "rosa ring"
	desc = "Once a flower of love, now touched by Baotha's hand. Its petals whisper of desire, despair, and the kind of longing that never dies. Worn by those who cannot let go."
	icon_state = "peaceflower"
	item_state = "peaceflower"
	icon = 'icons/roguetown/items/produce.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/head_items.dmi'

/obj/item/clothing/ring/griefflower/equipped(mob/living/carbon/human/user, slot)
	. = ..()
	if(slot == SLOT_RING)
		user.apply_status_effect(/datum/status_effect/buff/griefflower)

/obj/item/clothing/ring/griefflower/dropped(mob/living/carbon/human/user)
	. = ..()
	if(istype(user) && user?.wear_ring == src)
		user.remove_status_effect(/datum/status_effect/buff/griefflower)

// T2 - bond that lasts for 8 minutes as long as bonded are within 7 tiles, TRAIT_NOPAIN, spd = 5 end = 3
/obj/effect/proc_holder/spell/invoked/joyride
	name = "Joyride"
	desc = "A frenzy for two to partake in."
	overlay_state = "bliss"
	range = 2
	chargetime = 0.5 SECONDS
	invocations = list("By Baotha's mercy, an ecstasy trance for two!")
	sound = 'sound/magic/magnet.ogg'
	recharge_time = 60 SECONDS
	miracle = TRUE
	devotion_cost = 75
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/joyride/cast(list/targets, mob/living/user)
	var/mob/living/target = targets[1]

	var/datum/component/baotha_joyride/existing = user.GetComponent(/datum/component/baotha_joyride)
	if(existing)
		to_chat(user, span_warning("Your fates are already intertwined!"))
		revert_cast()
		return FALSE

	if(!istype(target, /mob/living/carbon) || target == user)
		revert_cast()
		return FALSE

	if(!do_after(user, 3 SECONDS, target = target))
		to_chat(user, span_warning("There is no joy without concentration!"))
		revert_cast()
		return FALSE

	var/holy_skill = user.get_skill_level(associated_skill)
	user.AddComponent(/datum/component/baotha_joyride, target, user, holy_skill)
	target.AddComponent(/datum/component/baotha_joyride/partner, target, user, holy_skill)

	user.visible_message(
		span_notice("[user] and [target] inhale a magenta mist. A shudder, a smile, and the taste of hysteria sweetens their blood."),
	)
	return TRUE

// T3 - clears all stress. Forget your worries, pookie bear.
/obj/effect/proc_holder/spell/invoked/lasthigh
	name = "Last High"
	desc = "Pleasure's perfume, just before the fall."
	overlay_state = "astrata"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 7
	warnie = "sydwarning"
	sound = 'sound/magic/timestop.ogg'
	invocations = list("May you find bliss through your pain!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 5 MINUTES
	miracle = TRUE
	devotion_cost = 75

/obj/effect/proc_holder/spell/invoked/lasthigh/cast(list/targets, mob/living/user)
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		if(target.mob_biotypes & MOB_UNDEAD)
			return FALSE

		target.visible_message(
			span_info("[target] is forced to inhale deeply a sweet smelling mist. They twist in pain, yet a smile decorates their face!"), 
			span_notice("The world starts to fade around me. My throat melts, my stomach churns, and my pulse quickens. Oblivion never tasted better.")
		)
		target.adjustToxLoss(3)
		target.add_stress(/datum/stressevent/lasthigh)
		return TRUE

/datum/stressevent/lasthigh
	timer = 10 MINUTES
	stressadd = -99
	desc = span_hypnophrase("The world starts to fade around me. My throat melts, my stomach churns, and my pulse quickens. Oblivion never tasted better.") 
