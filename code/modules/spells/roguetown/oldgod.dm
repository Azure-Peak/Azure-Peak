/datum/action/cooldown/spell/psydon
	background_icon = 'icons/mob/actions/psydonmiracles.dmi'
	button_icon = 'icons/mob/actions/psydonmiracles.dmi'
	spell_color = GLOW_COLOR_ASTRATA
	glow_intensity = null

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

	spell_flags = SPELL_PSYDON
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z
	required_items = list(/obj/item/clothing/neck/roguetown/psicross) //He is dead so yeah we need something to INVOKE IT

/////////////////////
// T0 - BOOTCHECK  //
/////////////////////

/datum/action/cooldown/spell/psydon/bootcheck
	name = "BOOTCHECK"
	desc = "'Now, where did I put that..?' </br>Checks your boot - or failing that, your surroundings - for something of use.\
	Scales with FORTUNE of the user."
	button_icon_state = "BOOTCHECK"
	sound = null

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE

	secondary_resource_cost = SPELLCOST_MINOR_PROJECTILE

	invocation_type = INVOCATION_NONE
	invocations = null

	charge_required = FALSE
	cooldown_time = 10 MINUTES

	var/static/list/lootpool = list(/obj/item/flowercrown/rosa,
	/obj/item/bouquet/rosa,
	/obj/item/jingle_bells,
	/obj/item/bouquet/salvia,
	/obj/item/bouquet/calendula,
	/obj/item/roguecoin/gold,
	/obj/item/roguecoin/silver,
	/obj/item/roguecoin/copper,
	/obj/item/alch/atropa,
	/obj/item/alch/salvia,
	/obj/item/alch/artemisia,
	/obj/item/alch/rosa,
	/obj/item/rogueweapon/huntingknife/idagger/navaja,
	/obj/item/lockpick,
	/obj/item/reagent_containers/glass/bottle/alchemical/strpot,
	/obj/item/reagent_containers/glass/bottle/alchemical/willpot,
	/obj/item/reagent_containers/glass/bottle/alchemical/conpot,
	/obj/item/reagent_containers/glass/bottle/alchemical/lucpot,
	/obj/item/reagent_containers/glass/bottle/rogue/poison,
	/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
	/obj/item/needle,
	/obj/item/natural/rock,
	/obj/item/natural/bundle/cloth,
	/obj/item/natural/bundle/fibers,
	/obj/item/clothing/suit/roguetown/armor/leather/hide/bikini,
	/obj/item/reagent_containers/glass/bottle/waterskin/milk,
	/obj/item/reagent_containers/food/snacks/rogue/bread,
	/obj/item/reagent_containers/food/snacks/grown/apple,
	/obj/item/natural/worms,
	/obj/item/natural/worms/leech,
	/obj/item/reagent_containers/food/snacks/rogue/psycrossbun,
	/obj/item/clothing/neck/roguetown/psicross,
	/obj/item/clothing/neck/roguetown/psicross/wood,
	/obj/item/rope/chain,
	/obj/item/rope,
	/obj/item/clothing/neck/roguetown/collar,
	/obj/item/natural/dirtclod,
	/obj/item/reagent_containers/glass/cup/wooden,
	/obj/item/natural/glass,
	/obj/item/clothing/shoes/roguetown/sandals,
	/obj/item/alch/transisdust)

/datum/action/cooldown/spell/psydon/bootcheck/cast(atom/cast_on)
	. = ..()
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/H = owner
	var/turf/T = get_turf(H)
	if(!T)
		return FALSE

	var/obj/item/found_thing
	if(H.get_stress_amount() < 0 && H.STALUC > 10)
		found_thing = new /obj/item/roguecoin/gold(T)
	else if(H.STALUC == 10)
		found_thing = new /obj/item/roguecoin/silver(T)
	else
		found_thing = new /obj/item/roguecoin/copper(T)

	to_chat(H, span_info("A coin in my boot? Psydon smiles upon me!"))
	if(!H.put_in_hands(found_thing, FALSE))
		found_thing.forceMove(T)

	if(prob(H.STALUC + H.get_skill_level(associated_skill)))
		var/path = pick(lootpool)
		var/obj/item/extra = new path(T)
		to_chat(H, span_info("Ah, of course! I almost forgot I had this stashed away for a perfect occasion."))
		if(!H.put_in_hands(extra, FALSE))
			extra.forceMove(T)

	return TRUE

/////////////////
// T1 - ENDURE //
/////////////////

/datum/action/cooldown/spell/psydon/endure
	name = "ENDURE"
	desc = "Invoke an envigoring prayer for those who're faltering in willpower. </br>‎  </br>Provides minor health regeneration, staunches the target's bleeding, and helps to alleviate those who're struggling to breathe. The more valuable a caster's psycross is, the more health that is restored unto the target - this is further increased if they have been mortally wounded."
	button_icon_state = "ENDURE"
	sound = 'sound/magic/ENDVRE.ogg'

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_ADJACENT + 1
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE + 10

	secondary_resource_cost = SPELLCOST_MIRACLE_MINOR

	invocation_type = INVOCATION_MESSAGE
	invocations = list(span_blue("quietly recites an orison, invoking the warmth of a dying light."))

	charge_required = FALSE
	cooldown_time = 30 SECONDS

/datum/action/cooldown/spell/psydon/endure/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(isliving(cast_on))
		var/mob/living/target = cast_on
		var/brute = target.getBruteLoss()
		var/burn = target.getFireLoss()
		var/list/wAmount = target.get_wounds()
		var/conditional_buff = FALSE
		var/situational_bonus = 0
		var/psicross_bonus = 0
		var/pp = 0
		var/damtotal = brute + burn
		var/zcross_trigger = FALSE
		if(H.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD)) // YOU ARE NO LONGER MORTAL. NO LONGER OF HIM. PSYDON WEEPS.
			// We do nothing to avoid meta checking for undead
			target.visible_message(span_info("A strange stirring feeling pours from [target]!"), span_info("Sentimental thoughts drive away my pain..."))		
			return TRUE

		// Bonuses! Flavour! SOVL!
		for(var/obj/item/clothing/neck/current_item in target.get_equipped_items(TRUE))
			if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/aalloy, /obj/item/clothing/neck/roguetown/psicross/silver,	/obj/item/clothing/neck/roguetown/psicross/g))
				pp += 1
				if(pp >= 12 & target == owner) // A harmless easter-egg. Only applies on self-cast. You'd have to be pretty deliberate to wear 12 of them.
					target.visible_message(span_danger("[target]'s many psycrosses reverberate with a strange, ephemeral sound..."), span_userdanger("HE must be waking up! I can hear it! I'm ENDURING so much!"))
					playsound(owner, 'sound/magic/PSYDONE.ogg', 100, FALSE)
					sleep(60)
					owner.psydo_nyte()
					owner.playsound_local(owner, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(20)
					owner.psydo_nyte()
					owner.playsound_local(owner, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(15)
					owner.psydo_nyte()
					owner.playsound_local(owner, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(10)
					owner.gib()
					return FALSE
				
				switch(current_item.type) // Target-based worn Psicross Piety bonus. For fun.
					if(/obj/item/clothing/neck/roguetown/psicross/wood)
						psicross_bonus = 0.1				
					if(/obj/item/clothing/neck/roguetown/psicross/aalloy)
						psicross_bonus = 0.2	
					if(/obj/item/clothing/neck/roguetown/psicross)
						psicross_bonus = 0.3
					if(/obj/item/clothing/neck/roguetown/psicross/silver)
						psicross_bonus = 0.4	
					if(/obj/item/clothing/neck/roguetown/psicross/g) // PURITY AFLOAT.
						psicross_bonus = 0.5
					if(/obj/item/clothing/neck/roguetown/psicross/weeping)
						psicross_bonus = 0.7
					if(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy)
						zcross_trigger = TRUE	

		if(damtotal >= 300) // ARE THEY ENDURING MUCH, IN ONE WAY OR ANOTHER?
			situational_bonus += 0.3

		if(wAmount.len > 5)	
			situational_bonus += 0.3		
	
		if (situational_bonus > 0)
			conditional_buff = TRUE

		target.visible_message(span_info("A strange stirring feeling pours from [target]!"), span_info("Sentimental thoughts drive away my pain..."))
		var/psyhealing = 3
		psyhealing += psicross_bonus
		if (conditional_buff & !zcross_trigger)
			to_chat(owner, "In <b>ENDURING</b> so much, become <b>EMBOLDENED</b>!")
			psyhealing += situational_bonus
	
		if (zcross_trigger)
			owner.visible_message(span_warning("[owner] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
			owner.playsound_local(owner, 'sound/misc/zizo.ogg', 25, FALSE)
			H.adjustBruteLoss(25)		
			return FALSE

		target.apply_status_effect(/datum/status_effect/buff/psyhealing, psyhealing)
		return TRUE

	return FALSE

/////////////////
// T1 - PRAYER //
/////////////////

/datum/action/cooldown/spell/psydon/prayer
	name = "PRAYER"
	desc = "Recite a psalm betwixt huffs, so that your wits do not succumb to more worldly ailments. </br>‎  </br>Provides minor health regeneration while standing still. The more damage that a caster has sustained - and the more valuable that their worn psycross is, the more health that they'll regenerate with each cycle."
	button_icon_state = "PRAYER"
	sound = null

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_ORISON

	secondary_resource_cost = SPELLCOST_MIRACLE_MINOR

	invocation_type = INVOCATION_MESSAGE
	invocations = list(span_blue("quietly recites a prayer, steadying their mind."))

	charge_required = FALSE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/spell/psydon/prayer/cast(atom/cast_on) ///Lesser version of 'RESPITE' and 'PERSIST', T1. Self-regenerative.
	. = ..()
	if(!ishuman(cast_on))
		return FALSE

	var/mob/living/carbon/human/H = owner
	to_chat(H, span_info("I take a moment to collect myself..."))

	for(var/i in 1 to 10)
		if(!do_after(H, 50))
			break
		var/brute = H.getBruteLoss()
		var/burn = H.getFireLoss()
		var/conditional_buff = FALSE
		var/zcross_trigger = FALSE
		var/sit_bonus1 = 0
		var/sit_bonus2 = 0
		var/psicross_bonus = 0

		for(var/obj/item/clothing/neck/current_item in H.get_equipped_items(TRUE))
			if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/aalloy, /obj/item/clothing/neck/roguetown/psicross/silver, /obj/item/clothing/neck/roguetown/psicross/g))
				switch(current_item.type) // Worn Psicross Piety bonus. For fun.
					if(/obj/item/clothing/neck/roguetown/psicross/wood)
						psicross_bonus = -1
					if(/obj/item/clothing/neck/roguetown/psicross/aalloy)
						psicross_bonus = -2
					if(/obj/item/clothing/neck/roguetown/psicross)
						psicross_bonus = -4
					if(/obj/item/clothing/neck/roguetown/psicross/silver)
						psicross_bonus = -6
					if(/obj/item/clothing/neck/roguetown/psicross/g) // PURITY AFLOAT.
						psicross_bonus = -7
					if(/obj/item/clothing/neck/roguetown/psicross/weeping)
						psicross_bonus = -9
					if(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy)
						zcross_trigger = TRUE
		if(zcross_trigger)
			owner.visible_message(span_warning("[owner] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
			owner.playsound_local(owner, 'sound/misc/zizo.ogg', 25, FALSE)
			H.adjustBruteLoss(25)
			return FALSE

		if(brute > 100) //A supplemental healing bonus, scaling off of how much damage's currently inflicted onto you.
			sit_bonus1 = -1
		if(brute > 150)
			sit_bonus1 = -2
		if(brute > 200)
			sit_bonus1 = -3
		if(brute > 300)
			sit_bonus1 = -4
		if(brute > 350)
			sit_bonus1 = -7
		if(brute > 400)
			sit_bonus1 = -9

		if(burn > 100) //Ditto.
			sit_bonus2 = -1
		if(burn > 150)
			sit_bonus2 = -2
		if(burn > 200)
			sit_bonus2 = -3
		if(burn > 300)
			sit_bonus2 = -4
		if(burn > 350)
			sit_bonus2 = -7
		if(burn > 400)
			sit_bonus2 = -9

		if(sit_bonus1 || sit_bonus2)
			conditional_buff = TRUE

		var/bruthealval = -5 + psicross_bonus + sit_bonus1
		var/burnhealval = -5 + psicross_bonus + sit_bonus2

		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		H.devotion?.update_devotion(-15)
		to_chat(owner, "<font color='purple'>I lose 15 devotion!</font>")
		if(conditional_buff)
			to_chat(owner, span_info("My pain gives way to a sense of furthered clarity before returning again, dulled."))

	to_chat(H, span_warning("My thoughts and sense of quiet escape me."))
	return FALSE

//////////////////
// T2 - RESPITE //
//////////////////

/datum/action/cooldown/spell/psydon/respite
	name = "RESPITE"
	desc = "Gather yourself, so that you may ready yourself for whatever lies next. </br>‎  </br>Provides health regeneration while standing still. The more damage that a caster has sustained - and the more valuable that their worn psycross is, the more health that they'll regenerate with each cycle."
	button_icon_state = "RESPITE"
	sound = null

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_ORISON

	secondary_resource_cost = SPELLCOST_MIRACLE - 5

	invocation_type = INVOCATION_MESSAGE
	invocations = list(span_blue("quietly recites a lesser psalm, soothing their pains."))

	charge_required = FALSE
	cooldown_time = 5 SECONDS

/datum/action/cooldown/spell/psydon/respite/cast(mob/living/carbon/human/user) // Greater version of 'PRAYER', T2. Requires the 'Devotee' virtue to unlock, if not playing as an Orthodoxist or Missionary.
	. = ..()
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user
	to_chat(H, span_info("I take a moment to collect myself..."))

	for(var/i in 1 to 10)
		if(!do_after(H, 50))
			break
		var/brute = H.getBruteLoss()
		var/burn = H.getFireLoss()
		var/conditional_buff = FALSE
		var/zcross_trigger = FALSE
		var/sit_bonus1 = 0
		var/sit_bonus2 = 0
		var/psicross_bonus = 0

		for(var/obj/item/clothing/neck/current_item in H.get_equipped_items(TRUE))
			if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/aalloy, /obj/item/clothing/neck/roguetown/psicross/silver, /obj/item/clothing/neck/roguetown/psicross/g))
				switch(current_item.type) // Worn Psicross Piety bonus. For fun.
					if(/obj/item/clothing/neck/roguetown/psicross/wood)
						psicross_bonus = -2
					if(/obj/item/clothing/neck/roguetown/psicross/aalloy)
						psicross_bonus = -4
					if(/obj/item/clothing/neck/roguetown/psicross)
						psicross_bonus = -5
					if(/obj/item/clothing/neck/roguetown/psicross/silver)
						psicross_bonus = -7
					if(/obj/item/clothing/neck/roguetown/psicross/g) // PURITY AFLOAT.
						psicross_bonus = -9
					if(/obj/item/clothing/neck/roguetown/psicross/weeping)
						psicross_bonus = -11
					if(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy)
						zcross_trigger = TRUE
		if(zcross_trigger)
			user.visible_message(span_warning("[user] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
			user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
			user.adjustBruteLoss(25)
			return FALSE

		if(brute > 100)
			sit_bonus1 = -2
		if(brute > 150)
			sit_bonus1 = -4
		if(brute > 200)
			sit_bonus1 = -6
		if(brute > 300)
			sit_bonus1 = -8
		if(brute > 350)
			sit_bonus1 = -10
		if(brute > 400)
			sit_bonus1 = -14

		if(burn > 100)
			sit_bonus2 = -2
		if(burn > 150)
			sit_bonus2 = -4
		if(burn > 200)
			sit_bonus2 = -6
		if(burn > 300)
			sit_bonus2 = -8
		if(burn > 350)
			sit_bonus2 = -10
		if(burn > 400)
			sit_bonus2 = -14

		if(sit_bonus1 || sit_bonus2)
			conditional_buff = TRUE

		var/bruthealval = -7 + psicross_bonus + sit_bonus1
		var/burnhealval = -7 + psicross_bonus + sit_bonus2

		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		H.devotion?.update_devotion(-25)
		to_chat(user, "<font color='purple'>I lose 25 devotion!</font>")
		if(conditional_buff)
			to_chat(user, span_info("My pain gives way to a sense of furthered clarity before returning again, dulled."))

	to_chat(H, span_warning("My thoughts and sense of quiet escape me."))
	return FALSE

//////////////////
// T3 - PERSIST //
//////////////////

/datum/action/cooldown/spell/psydon/persist
	name = "PERSIST"
	desc = "Gather yourself, so that you may ready yourself for whatever lies next. </br>‎  </br>Provides health regeneration while standing still. The more damage that a caster has sustained - and the more valuable that their worn psycross is, the more health that they'll regenerate with each cycle."
	button_icon_state = "PERSIST"
	sound = null

	click_to_activate = FALSE
	cast_range = SPELL_RANGE_ADJACENT
	self_cast_possible = TRUE

	primary_resource_cost = SPELLCOST_MIRACLE_ORISON

	secondary_resource_cost = SPELLCOST_MIRACLE

	invocation_type = INVOCATION_MESSAGE
	invocations = list(span_blue("quietly recites a greater psalm, soothing their pains."))

	charge_required = FALSE
	cooldown_time = 5 MINUTES

/datum/action/cooldown/spell/psydon/persist/cast(mob/living/carbon/human/user) // Greater version of 'PRAYER' and 'RESPITE', T4. Inherently restricted to the Absolver, but potentially(?) achievable as a Missionary with the 'Devotee' virtue.
	. = ..()
	if(!ishuman(user))
		return FALSE

	var/mob/living/carbon/human/H = user
	to_chat(H, span_info("I take a moment to collect myself..."))

	for(var/i in 1 to 10)
		if(!do_after(H, 50))
			break
		var/brute = H.getBruteLoss()
		var/burn = H.getFireLoss()
		var/conditional_buff = FALSE
		var/zcross_trigger = FALSE
		var/sit_bonus1 = 0
		var/sit_bonus2 = 0
		var/psicross_bonus = 0

		for(var/obj/item/clothing/neck/current_item in H.get_equipped_items(TRUE))
			if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/aalloy, /obj/item/clothing/neck/roguetown/psicross/silver, /obj/item/clothing/neck/roguetown/psicross/g))
				switch(current_item.type) // Worn Psicross Piety bonus. For fun.
					if(/obj/item/clothing/neck/roguetown/psicross/wood)
						psicross_bonus = -2
					if(/obj/item/clothing/neck/roguetown/psicross/aalloy)
						psicross_bonus = -4
					if(/obj/item/clothing/neck/roguetown/psicross)
						psicross_bonus = -5
					if(/obj/item/clothing/neck/roguetown/psicross/silver)
						psicross_bonus = -7
					if(/obj/item/clothing/neck/roguetown/psicross/g) // PURITY AFLOAT.
						psicross_bonus = -9
					if(/obj/item/clothing/neck/roguetown/psicross/weeping)
						psicross_bonus = -11
					if(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy)
						zcross_trigger = TRUE
		if(zcross_trigger)
			user.visible_message(span_warning("[user] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
			user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
			user.adjustBruteLoss(25)
			return FALSE

		if(brute > 100)
			sit_bonus1 = -2
		if(brute > 150)
			sit_bonus1 = -4
		if(brute > 200)
			sit_bonus1 = -6
		if(brute > 300)
			sit_bonus1 = -8
		if(brute > 350)
			sit_bonus1 = -10
		if(brute > 400)
			sit_bonus1 = -14

		if(burn > 100)
			sit_bonus2 = -2
		if(burn > 150)
			sit_bonus2 = -4
		if(burn > 200)
			sit_bonus2 = -6
		if(burn > 300)
			sit_bonus2 = -8
		if(burn > 350)
			sit_bonus2 = -10
		if(burn > 400)
			sit_bonus2 = -14

		if(sit_bonus1 || sit_bonus2)
			conditional_buff = TRUE

		var/bruthealval = -14 + psicross_bonus + sit_bonus1
		var/burnhealval = -14 + psicross_bonus + sit_bonus2

		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4")
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		user.devotion?.update_devotion(-50)
		to_chat(user, "<font color='purple'>I lose 50 devotion!</font>")
		if(conditional_buff)
			to_chat(user, span_info("My pain gives way to a sense of furthered clarity before returning again, dulled."))

	to_chat(H, span_warning("My thoughts and sense of quiet escape me!"))
	return FALSE

//

/obj/effect/proc_holder/spell/invoked/psydonlux_tamper
	name = "WEEP"
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "WEEP" //Absolver-exclusive. Classified as 'lux-magicka', rather than a traditional miracle. Same line of thought as the Naledians.
	releasedrain = 33
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	desc = "Lesser lux-magicka. Endure the wounds of another, for their sake. </br>‎  </br>Siphons away lesser injuries, such as gashes and fractures, from the target. In exchange, any siphoned injuries are subsequently imposed onto you. If the target has lost any blood, they will be fully replenished through your own veins."
	movement_interrupt = FALSE
	sound = 'sound/magic/psydonbleeds.ogg'
	invocations = list("I BLEED, SO THAT YOU MIGHT ENDURE!","PERSIST AGAINST THE PAIN!","LET YOUR WOUNDS WEEP NO MORE!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 80

/obj/effect/proc_holder/spell/invoked/psydonlux_tamper/cast(list/targets, mob/living/user)
	if(!ishuman(targets[1]))
		to_chat(user, span_warning("Their Lux doesn't need to be purified."))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/H = targets[1]
	
	if(H == user)
		to_chat(user, span_warning("My own Lux maintains purity."))
		revert_cast()
		return FALSE

	if(H.stat == DEAD)
		to_chat(user, span_warning("[H]'s Lux is gone. I can't do anything, anymore."))
		user.emote("cry")
		revert_cast()
		return FALSE	
	
	// Transfer wounds.
	if(ishuman(H) && ishuman(user))
		var/mob/living/carbon/human/C_target = H
		var/mob/living/carbon/human/C_caster = user
		var/list/datum/wound/tw_List = C_target.get_wounds()

		if(!tw_List.len)
			revert_cast()
			return FALSE

		var/list/BPs_to_check = list()

		//Transfer wounds from each bodypart.
		for(var/datum/wound/targetwound in tw_List)
			if (istype(targetwound, /datum/wound/dismemberment))
				continue				
			if (istype(targetwound, /datum/wound/facial))
				continue					
			if (istype(targetwound, /datum/wound/fracture/head))
				continue				
			if (istype(targetwound, /datum/wound/fracture/neck))
				continue
			if (istype(targetwound, /datum/wound/cbt/permanent))
				continue			
			var/obj/item/bodypart/c_BP = C_caster.get_bodypart(targetwound.bodypart_owner.body_zone)
			if(c_BP)
				var/datum/wound/newwound = c_BP.add_wound(targetwound.type)
				if(newwound)	// We transferred it successfully.
					targetwound.copy_to(newwound)
				else
					c_BP.receive_damage(targetwound.whp)
					if(!(c_BP in BPs_to_check))
						LAZYADD(BPs_to_check, c_BP)

				if((HAS_TRAIT(C_caster, TRAIT_NOPAIN) || HAS_TRAIT(C_caster, TRAIT_NOPAINSTUN)) && HAS_TRAIT(C_caster, TRAIT_BLOODLOSS_IMMUNE))
					if(!(c_BP in BPs_to_check))
						c_BP.receive_damage(targetwound.whp)
						LAZYADD(BPs_to_check, c_BP) // This, in essence, checks whether we're a quirky caster that does not bleed (IE constructs).
				var/obj/item/bodypart/t_BP = C_target.get_bodypart(targetwound.bodypart_owner.body_zone)
				if(t_BP)
					t_BP.remove_wound(targetwound.type)

		if(length(BPs_to_check))
			var/stuntime = 0
			for(var/obj/item/bodypart/c_BP in BPs_to_check)
				if(c_BP.get_damage() >= c_BP.max_damage)	// We're some snowflake-ahh Absolver that does not accept regular wounds
					if(istype(c_BP, /obj/item/bodypart/head) || !c_BP.dismember(skip_checks = TRUE) )	// Our limb can't fall off (or we don't want it to)
						stuntime += 5 SECONDS
			if(stuntime)
				C_caster.Knockdown(stuntime)
				C_caster.apply_status_effect(/datum/status_effect/debuff/exposed, stuntime)
				C_caster.emote("pain")


	// Transfer blood
	var/blood_transfer = 0
	if(H.blood_volume < BLOOD_VOLUME_NORMAL)
		blood_transfer = BLOOD_VOLUME_NORMAL - H.blood_volume
		H.blood_volume = BLOOD_VOLUME_NORMAL
		user.blood_volume -= blood_transfer
		to_chat(user, span_warning("You feel your blood drain into [H]!"))
		to_chat(H, span_notice("You feel your blood replenish!"))

	// Visual effects
	user.visible_message(span_danger("[user] purifies [H]'s wounds!"))
	playsound(get_turf(user), 'sound/magic/psydonbleeds.ogg', 50, TRUE)
	
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#487e97") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#487e97") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#487e97") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#487e97") 
	
	// Notify the user and target
	to_chat(user, span_notice("You purify their Lux with the merging of theirs and your own, for a mote."))
	to_chat(H, span_info("You feel a strange stirring sensation pour over your Lux, stealing your wounds."))
	return TRUE

//

/obj/effect/proc_holder/spell/invoked/psydonabsolve	
	name = "ABSOLVE"
	action_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_icon = 'icons/mob/actions/psydonmiracles.dmi'
	overlay_state = "ABSOLVE" //Absolver-exclusive. Classified as 'lux-magicka', rather than a traditional miracle. Same line of thought as the Naledians.
	desc = "Greater lux-magicka. Exchange your vitality for the sake of another. </br>‎  </br>Siphons away all injuries - be it physical damage, blood loss, or dismemberment - from the target, completely healing them. In exchange, all siphoned injuries are subsequently inflicted unto you. Using this on a target who's dead will fully resurrect them, albeit at the cost of your own lyfe."
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	range = 3 // i got a request to up this. tbh it could be 4.
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/psyabsolution.ogg'
	invocations = list("BE ABSOLVED!","BREATHE ONCE MORE!","YOUR TIME IS NOT NOW!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS // 60 seconds cooldown
	miracle = TRUE
	devotion_cost = 100

/obj/effect/proc_holder/spell/invoked/psydonabsolve/cast(list/targets, mob/living/user)

	if(!ishuman(targets[1]))
		to_chat(user, span_warning("ABSOLUTION is for those who walk in HIS image!"))
		revert_cast()
		return FALSE
	
	var/mob/living/carbon/human/H = targets[1]
	
	if(H == user)
		to_chat(user, span_warning("You cannot ABSOLVE yourself!"))
		revert_cast()
		return FALSE
	
	// Special case for dead targets
	if(H.stat >= DEAD)
		if(!H.check_revive(user))
			revert_cast()
			return FALSE
		if(alert(user, "REACH OUT AND PULL?", "THERE'S NO LUX IN THERE", "YES", "NO") != "YES")	
			revert_cast()
			return FALSE
		to_chat(user, span_warning("You attempt to revive [H] by ABSOLVING them!"))
		// Dramatic effect
		user.visible_message(span_danger("[user] grabs [H] by the wrists, attempting to ABSOLVE them!"))
		if(alert(H, "They want to ABSOLVE you. Will you let them?", "ABSOLUTION", "I'll allow it", "I refuse") != "I'll allow it")
			H.visible_message(span_notice("Nothing happens."))
			return FALSE
		// Create visual effects
		H.apply_status_effect(/datum/status_effect/buff/psyvived)
		// Kill the caster
		user.say("MY LYFE FOR YOURS! LYVE, AS DOES HE!", forced = TRUE, language = /datum/language/common)
		user.death()
		// Revive the target
		H.revive(full_heal = TRUE, admin_revive = FALSE)
		H.adjustOxyLoss(-H.getOxyLoss())
		H.grab_ghost(force = TRUE) // even suicides
		H.emote("breathgasp")
		H.Jitter(100)
		H.update_body()
		record_round_statistic(STATS_LUX_REVIVALS)
		ADD_TRAIT(H, TRAIT_IWASREVIVED, "[type]")
		H.apply_status_effect(/datum/status_effect/buff/psyvived)
		user.apply_status_effect(/datum/status_effect/buff/psyvived)
		H.visible_message(span_notice("[H] is ABSOLVED!"), span_green("I awake from the void."))		
		H.mind.remove_antag_datum(/datum/antagonist/zombie)
		H.remove_status_effect(/datum/status_effect/debuff/rotted_zombie)	//Removes the rotted-zombie debuff if they have it - Failsafe for it.
		H.apply_status_effect(/datum/status_effect/debuff/revived)	//Temp debuff on revive, your stats get hit temporarily. Doubly so if having rotted.
		return TRUE

	// Transfer afflictions from the target to the caster

	// Transfer damage
	var/brute_transfer = H.getBruteLoss()
	var/burn_transfer = H.getFireLoss()
	var/tox_transfer = H.getToxLoss()
	var/oxy_transfer = H.getOxyLoss()
	var/clone_transfer = H.getCloneLoss()
	
	// Heal the target
	H.adjustBruteLoss(-brute_transfer)
	H.adjustFireLoss(-burn_transfer)
	H.adjustToxLoss(-tox_transfer)
	H.adjustOxyLoss(-oxy_transfer)
	H.adjustCloneLoss(-clone_transfer)
	
	// Apply damage to the caster
	user.adjustBruteLoss(brute_transfer)
	user.adjustFireLoss(burn_transfer)
	user.adjustToxLoss(tox_transfer)
	user.adjustOxyLoss(oxy_transfer)
	user.adjustCloneLoss(clone_transfer)

	// Visual effects
	user.visible_message(span_danger("[user] absolves [H]'s suffering!"))
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#aa1717") 

	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717") 
	new /obj/effect/temp_visual/psyheal_rogue(get_turf(user), "#aa1717") 
	
	// Notify the user and target
	to_chat(user, span_warning("You absolve [H] of their injuries!"))
	to_chat(H, span_notice("[user] absolves you of your injuries!"))
	
	return TRUE

// UNUSED DIALOGUE: PRAYER, RESPITE, PERSIST
// ("#..our father above, hallowed be thy name..","#..thy kingdom come, thy will be done..","#..I fear no evil, for thou art with me..")
// ("#..with every broken bone, I swore I lyved..","#..thou shalt ward me within the valleys o' evil..","#..the fires of Syon, everburning with thine vigor..")
// ("#..in Psydon's glory, all malaises shall melt away..","#..thine holy spirit lies within all our hearts, weeping forevermore..","#..thou shalt know all, for enduring begets enlightenment..")
