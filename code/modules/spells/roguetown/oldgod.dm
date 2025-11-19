/////////////////////////////////
// PSYDONIC SPELLS, EXTERNAL.  //
/////////////////////////////////

/obj/effect/proc_holder/spell/invoked/psydonendure
	name = "ENDURE"
	desc = "Invoke an envigoring prayer for those who're faltering in willpower. </br>‎  </br>Provides minor health regeneration, staunches the target's bleeding, and helps to alleviate those who're struggling to breathe. The more valuable a caster's psycross is, the more health that is restored unto the target - this is further increased if they have been mortally wounded."
	overlay_state = "ENDURE"
	releasedrain = 33
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = 'sound/magic/ENDVRE.ogg'
	invocations = list("ENDURE!","GET UP!","COME ON!") //Kept intentionally vague as to whether it's genuine magic or just a very inspiring attempt to rally the target, like with 'PRAYER'. Invigorate the wounded; give them the motivation to thug it out.
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 30 SECONDS
	miracle = TRUE
	devotion_cost = 40

/obj/effect/proc_holder/spell/invoked/psydonendure/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/brute = target.getBruteLoss()
		var/burn = target.getFireLoss()
		var/list/wAmount = target.get_wounds()
		var/conditional_buff = FALSE
		var/situational_bonus = 0
		var/psicross_bonus = 0
		var/pp = 0
		var/damtotal = brute + burn
		var/zcross_trigger = FALSE
		if(user.patron?.undead_hater && (target.mob_biotypes & MOB_UNDEAD)) // YOU ARE NO LONGER MORTAL. NO LONGER OF HIM. PSYDON WEEPS.
			target.visible_message(span_danger("[target] shudders with a strange stirring feeling!"), span_userdanger("It hurts. You feel like weeping."))
			target.adjustBruteLoss(40)			
			return TRUE

		// Bonuses! Flavour! SOVL!
		for(var/obj/item/clothing/neck/current_item in target.get_equipped_items(TRUE))
			if(current_item.type in list(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy, /obj/item/clothing/neck/roguetown/psicross, /obj/item/clothing/neck/roguetown/psicross/wood, /obj/item/clothing/neck/roguetown/psicross/aalloy, /obj/item/clothing/neck/roguetown/psicross/silver,	/obj/item/clothing/neck/roguetown/psicross/g))
				pp += 1
				if(pp >= 12 & target == user) // A harmless easter-egg. Only applies on self-cast. You'd have to be pretty deliberate to wear 12 of them.
					target.visible_message(span_danger("[target]'s many psycrosses reverberate with a strange, ephemeral sound..."), span_userdanger("HE must be waking up! I can hear it! I'm ENDURING so much!"))
					playsound(user, 'sound/magic/PSYDONE.ogg', 100, FALSE)
					sleep(60)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(20)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(15)
					user.psydo_nyte()
					user.playsound_local(user, 'sound/misc/psydong.ogg', 100, FALSE)
					sleep(10)
					user.gib()
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
			to_chat(user, "In <b>ENDURING</b> so much, become <b>EMBOLDENED</b>!")
			psyhealing += situational_bonus
	
		if (zcross_trigger)
			user.visible_message(span_warning("[user] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
			user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
			user.adjustBruteLoss(25)		
			return FALSE

		target.apply_status_effect(/datum/status_effect/buff/psyhealing, psyhealing)
		return TRUE

	revert_cast()
	return FALSE

//

/obj/effect/proc_holder/spell/invoked/psydonlux_tamper
	name = "WEEP"
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
			c_BP.add_wound(targetwound.type)
			var/obj/item/bodypart/t_BP = C_target.get_bodypart(targetwound.bodypart_owner.body_zone)
			t_BP.remove_wound(targetwound.type)

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
	overlay_state = "ABSOLVE" //Absolver-exclusive. Classified as 'lux-magicka', rather than a traditional miracle. Same line of thought as the Naledians.
	desc = "Greater lux-magicka. Exchange your vitality for the sake of another. </br>‎  </br>Siphons away all injuries - be it physical damage, blood loss, or dismemberment - from the target, completely healing them. In exchange, all siphoned injuries are subsequently inflicted unto you. Using this on a target who's dead will fully resurrect them, albeit at the cost of your own lyfe."
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	range = 1
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
		user.say("MY LYFE FOR YOURS! LYVE, AS DOES HE!", forced = TRUE)
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

//////////////////////////////////
// PSYDONIC SPELLS, INTERNAL.   //
//////////////////////////////////

/obj/effect/proc_holder/spell/self/check_boot
	name = "BOOTCHECK"
	desc = "'Now, where did I put that..?' </br>Checks your boot - or failing that, your surroundings - for something of use."
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = null
	sound = null
	overlay_state = "BOOTCHECK"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = TRUE
	recharge_time = 10 MINUTES
	miracle = TRUE
	devotion_cost = 30
	range = 1
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
	/obj/item/reagent_containers/glass/bottle/alchemical/endpot,
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
	
/obj/effect/proc_holder/spell/self/check_boot/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/mob/living/carbon/human/H = user
	var/obj/item/found_thing
	if(H.get_stress_amount() < 0 && H.STALUC > 10)
		found_thing = new /obj/item/roguecoin/gold
	else if(H.STALUC == 10)
		found_thing = new /obj/item/roguecoin/silver
	else
		found_thing = new /obj/item/roguecoin/copper
	to_chat(H, span_info("A coin in my boot? Psydon smiles upon me!"))
	H.put_in_hands(found_thing, FALSE)
	if(prob(H.STALUC + H.get_skill_level(associated_skill)))
		var/obj/item/extra_thing = pick(lootpool)
		new extra_thing(get_turf(user))
		to_chat(H, span_info("Ah, of course! I almost forgot I had this stashed away for a perfect occasion."))
		H.put_in_hands(extra_thing, FALSE)
	return TRUE

//

/obj/effect/proc_holder/spell/self/psydonprayer
	name = "PRAYER"
	desc = "Recite a psalm betwixt huffs, so that your wits do not succumb to more worldly ailments. </br>‎  </br>Provides minor health regeneration while standing still. The more damage that a caster has sustained - and the more valuable that their worn psycross is, the more health that they'll regenerate with each cycle."
	overlay_state = "limb_attach"
	releasedrain = 15
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = null
	invocations = list("#..our father above, hallowed be thy name..","#..thy kingdom come, thy will be done..","#..I fear no evil, for thou art with me..") //Like with 'ENDURE', it's kept vague as to whether this is an acutal miracle or not. Fluffs it as a proper prayer, incantations and all!
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 0 //Doesn't have an initial cost, but charges the caster once they're interrupted or have cycled a couple times. Check the 'if-doafter' line near the bottom if you wish to fiddle with the logic.

/obj/effect/proc_holder/spell/self/psydonprayer/cast(mob/living/carbon/human/user) ///Lesser version of 'RESPITE' and 'PERSIST', T1. Self-regenerative
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
		
	var/mob/living/carbon/human/H = user
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
				if(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy)
					zcross_trigger = TRUE		
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

	to_chat(H, span_info("I take a moment to collect myself..."))
	if(zcross_trigger)
		user.visible_message(span_warning("[user] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
		user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
		user.adjustBruteLoss(25)		
		return FALSE

	if(do_after(H, 50))
		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4") 
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4") 
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		if (conditional_buff)
			to_chat(user, span_info("My pain gives way to a sense of furthered clarity before returning again, dulled."))
		user.devotion?.update_devotion(-15)
		to_chat(user, "<font color='purple'>I lose 15 devotion!</font>")
		cast(user)	
		return TRUE
	else
		to_chat(H, span_warning("My thoughts and sense of quiet escape me."))	
		return FALSE								

//

/obj/effect/proc_holder/spell/self/psydonrespite
	name = "RESPITE"
	desc = "Gather yourself, so that you may ready yourself for whatever lies next. </br>‎  </br>Provides health regeneration while standing still. The more damage that a caster has sustained - and the more valuable that their worn psycross is, the more health that they'll regenerate with each cycle."
	overlay_state = "RESPITE"
	releasedrain = 25
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = null
	invocations = list("#..with every broken bone, I swore I lyved..","#..thou shalt ward me within the valleys o' evil..","#..the fires of Syon, everburning with thine vigor..") //General rule of thumb, with these prayers; the more powerful they are, the more zealous the incantations should be.
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 0

/obj/effect/proc_holder/spell/self/psydonrespite/cast(mob/living/carbon/human/user) // Greater version of 'PRAYER', T2. Requires the 'Devotee' virtue to unlock, if not playing as an Orthodoxist or Missionary.
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
		
	var/mob/living/carbon/human/H = user
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
				if(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy)
					zcross_trigger = TRUE		
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

	to_chat(H, span_info("I take a moment to collect myself..."))
	if(zcross_trigger)
		user.visible_message(span_warning("[user] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
		user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
		user.adjustBruteLoss(25)		
		return FALSE

	if(do_after(H, 50))
		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4") 
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4") 
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		if (conditional_buff)
			to_chat(user, span_info("My pain gives way to a sense of furthered clarity before returning again, dulled."))
		user.devotion?.update_devotion(-25)
		to_chat(user, "<font color='purple'>I lose 25 devotion!</font>")
		cast(user)	
		return TRUE
	else
		to_chat(H, span_warning("My thoughts and sense of quiet escape me."))	
		return FALSE					

//

/obj/effect/proc_holder/spell/self/psydonpersist
	name = "PERSIST"
	desc = "Channel your willpower under duress, so that you may yet triumph over adversity. </br>‎  </br>Provides greater health regeneration while standing still. The more damage that a caster has sustained - and the more valuable that their worn psycross is, the more health that they'll regenerate with each cycle."
	overlay_state = "PERSIST"
	releasedrain = 30
	chargedrain = 0
	chargetime = 0
	range = 2
	warnie = "sydwarning"
	movement_interrupt = FALSE
	invocations = list("#..in Psydon's glory, all malaises shall melt away..","#..thine holy spirit lies within all our hearts, weeping forevermore..","#..thou shalt know all, for enduring begets enlightenment..") //Highest tier of self-healing, and - in turn - the most devoutly-phrased.
	invocation_type = "shout"
	sound = null
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 5 SECONDS
	miracle = TRUE
	devotion_cost = 0

/obj/effect/proc_holder/spell/self/psydonpersist/cast(mob/living/carbon/human/user) // Greater version of 'PRAYER' and 'RESPITE', T4. Inherently restricted to the Absolver, but potentially(?) achievable as a Missionary with the 'Devotee' virtue.
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
		
	var/mob/living/carbon/human/H = user
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
				if(/obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy)
					zcross_trigger = TRUE		
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

	to_chat(H, span_info("I take a moment to collect myself..."))
	if(zcross_trigger)
		user.visible_message(span_warning("[user] shuddered. Something's very wrong."), span_userdanger("Cold shoots through my spine. Something laughs at me for trying."))
		user.playsound_local(user, 'sound/misc/zizo.ogg', 25, FALSE)
		user.adjustBruteLoss(25)		
		return FALSE

	if(do_after(H, 50))
		playsound(H, 'sound/magic/psydonrespite.ogg', 100, TRUE)
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4") 
		new /obj/effect/temp_visual/psyheal_rogue(get_turf(H), "#e4e4e4") 
		H.adjustBruteLoss(bruthealval)
		H.adjustFireLoss(burnhealval)
		if (conditional_buff)
			to_chat(user, span_info("My pain gives way to a sense of furthered clarity before returning again, dulled."))
		user.devotion?.update_devotion(-50)
		to_chat(user, "<font color='purple'>I lose 50 devotion!</font>")
		cast(user)	
		return TRUE
	else
		to_chat(H, span_warning("My thoughts and sense of quiet escape me."))	
		return FALSE					
