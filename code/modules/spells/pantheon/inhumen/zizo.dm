// T0: Snuffs out fires/lights around area of the caster, greater range with higher HOLY skill
/obj/effect/proc_holder/spell/self/zizo_snuff
	name = "Snuff Lights"
	desc = "Extinguish all lights in range, with your Miracles skill increasing range."
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "snufflight"
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	invocations = list("exhales a dark grey smog, choking any lights nearby.")
	invocation_type = "emote"
	sound = 'sound/magic/zizo_snuff.ogg'
	associated_skill = /datum/skill/magic/holy
	antimagic_allowed = FALSE
	recharge_time = 20 SECONDS
	miracle = TRUE
	devotion_cost = 30
	range = 2

/obj/effect/proc_holder/spell/self/zizo_snuff/cast(list/targets, mob/user = usr)
	. = ..()
	if(!ishuman(user))
		revert_cast()
		return FALSE
	var/checkrange = (range + user.get_skill_level(/datum/skill/magic/holy)) //+1 range per holy skill up to a potential of 8.
	for(var/obj/O in range(checkrange, user))
		O.extinguish()
	for(var/mob/M in range(checkrange, user))
		for(var/obj/O in M.contents)
			O.extinguish()
	return TRUE

// T1: (fires a bone splinter at a target for brute and bleeding if you're not holding bones in your other hand, fires a significantly stronger bone lance if you are)

/obj/effect/proc_holder/spell/invoked/projectile/profane
	name = "Profane"
	desc = "Fire forth a splinter of unholy bone, tearing flesh and causing bleeding. If you hold pieces of bone in your other hand, you will coax a much stronger lance of bone into being."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "profane"
	range = 8
	associated_skill = /datum/skill/magic/arcane
	projectile_type = /obj/projectile/magic/profane
	chargedloop = /datum/looping_sound/invokeholy
	invocation_type = "none"
	releasedrain = 30
	chargedrain = 0
	chargetime = 15
	recharge_time = 10 SECONDS
	hide_charge_effect = TRUE // Left handed magick babe

/obj/effect/proc_holder/spell/invoked/projectile/profane/miracle
	miracle = TRUE
	devotion_cost = 15
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/projectile/profane/fire_projectile(mob/living/user, atom/target)
	current_amount--

	var/obj/item/held_item = user.get_active_held_item()
	var/big_cast = FALSE
	if (istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/bonez = held_item
		if (bonez.use(1))
			projectile_type = /obj/projectile/magic/profane/major
			big_cast = TRUE
	else if (istype(held_item, /obj/item/natural/bone))
		qdel(held_item)
		projectile_type = /obj/projectile/magic/profane/major
		big_cast = TRUE
	else if (istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/boney_bundle = held_item
		if (boney_bundle.use(1))
			projectile_type = /obj/projectile/magic/profane/major
			big_cast = TRUE

	var/obj/projectile/P = new projectile_type(user.loc)
	P.firer = user
	P.preparePixelProjectile(target, user)
	P.fire()

	if (big_cast)
		user.visible_message(span_danger("[user] conjures and hurls a vicious lance of bone towards [target]!"), span_notice("I hurl a vicious lance of bone at [target]!")) 						//hehe. vicious lance of bone
	else
		user.visible_message(span_danger("[user] swings their arm in a wide arc, hurling a splinter of bone towards [target]!"), span_notice("I fling a shard of profaned bone at [target]!"))

	projectile_type = initial(projectile_type)

/obj/projectile/magic/profane
	name = "profaned bone splinter"
	icon_state = "chronobolt"
	damage = 20
	damage_type = BRUTE
	nodamage = FALSE
	var/embed_prob = 10

/obj/projectile/magic/profane/major
	name = "profaned bone lance"
	damage = 35
	embed_prob = 30

/obj/projectile/magic/profane/on_hit(atom/target, blocked)
	. = ..()
	if (iscarbon(target) && prob(embed_prob))
		var/mob/living/carbon/carbon_target = target
		var/obj/item/bodypart/victim_limb = pick(carbon_target.bodyparts)
		var/obj/item/bone/splinter/our_splinter = new
		victim_limb.add_embedded_object(our_splinter, FALSE, TRUE)

/obj/item/bone/splinter
	name = "bone splinter"
	embedding = list(
		"embed_chance" = 100,
		"embedded_pain_chance" = 25,
		"embedded_fall_chance" = 5,
	)

/obj/item/bone/splinter/dropped(mob/user, silent)
	. = ..()
	to_chat(user, span_danger("[src] crumbles into dust..."))
	qdel(src)

// T2: just use lesser animate undead for now

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/miracle
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "skeleton_formation"
	name = "Raise Lesser Skeleton"
	desc = "Invoke Enochian magicka to bind loose bones into a simple skeletal thrall. Its crude physiology is held together purely by magic; unable to be incapacitated, it shall stand until it crumbles into spare bones. It is also simpler to control, so you can order it to move, guard or attack manually."
	miracle = TRUE
	devotion_cost = 60
	cabal_affine = TRUE
	to_spawn = 1
	chargetime = 2 SECONDS // back then we to_spawned 3, with a 6 second charge time. Now we only 1, for 2 seconds. Because 2 x 3 = 6.

// T2: carbon spawn

/obj/effect/proc_holder/spell/invoked/raise_undead_guard/miracle
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "skeleton"
	name = "Raise Greater Skeleton"
	desc = "Invoke Enochian magicka to bind bones into a more complex skeletal thrall. Its refined physique allows it to wield superior weapons, durability and also wear armor, however it cannot be controlled by any means, aside telling ally from foe."
	chargetime = 3 SECONDS
	miracle = TRUE
	devotion_cost = 80

// T3: tames bio_type = undead mobs

/obj/effect/proc_holder/spell/invoked/tame_undead/miracle
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "deadite_tame"
	miracle = TRUE
	chargetime = 2 SECONDS // unlike the other, this has a chunky devotion cost, should be fine
	devotion_cost = 100

// T3: Rituos - Zizo's Lesser Work. A single painful ritual that grants the caster a choice:
// Progress: Arcyne knowledge (2 minor aspects, 4 utilities). No skeletonization. -- Kunai: I made this more distinctive from Undeath, now it also gives you some traits to give a better progress vibe.
// Unlife: Full skeletonization + MOB_UNDEAD, grants bonechill and raise_deadite directly. -- Kunai: We already have raise_deadite, so it's a moot point to give them the Necromancer version of it. Just gave them bonemend and a few more traits to give the vibe of a 'half-lich'.
// Both paths grant undead language and TRAIT_ARCYNE. One-time use - cannot be cast again after completion.

/obj/effect/proc_holder/spell/invoked/rituos
	name = "Rituos"
	desc = "Enact one of the Lesser Work of Zizo - a single, agonizing ritual that tears open a path to power. Choose Progress to gain arcyne knowledge, or Unlife to embrace undeath."
	clothes_req = FALSE
	action_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_icon = 'icons/mob/actions/zizomiracles.dmi'
	overlay_state = "rituos"
	associated_skill = /datum/skill/magic/arcane
	chargedloop = /datum/looping_sound/invokeholy
	chargedrain = 0
	chargetime = 50
	releasedrain = 90
	no_early_release = TRUE
	movement_interrupt = TRUE
	recharge_time = 5 MINUTES
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/rituos/miracle
	miracle = TRUE
	devotion_cost = 120
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/rituos/cast(list/targets, mob/living/carbon/human/user)
	var/path_choice = tgui_alert(user, "What path of the Lesser Work do you seek?", "THE LESSER WORK", list("Progress", "Unlife", "Cancel"))
	if(!path_choice || path_choice == "Cancel")
		return FALSE

	// The chant - path-specific invocations
	user.visible_message(span_boldwarning("[user] throws back [user.p_their()] head, arcyne energy crackling across [user.p_their()] body!"))

	user.grant_language(/datum/language/undead)

	var/list/chant_lines
	switch(path_choice)
		if("Progress")
			chant_lines = list(
				",w ZIZO! ZIZO! ZIZO! GRANT ME INSIGHT UNSHACKLED!",
				",w STRIP ME OF STAGNATION AND IGNORANCE!",
				",w BREAK THE CHAINS OF FALSE UNDERSTANDING!",
				",w LET REVELATION FLOOD THIS FRAIL MIND!",
				",w I OFFER THIS MIND TO COMPLETE THY WORK!",
			)
		if("Unlife")
			chant_lines = list(
				",w ZIZO! ZIZO! ZIZO! FLENSE FLESH FROM MY BONE!",
				",w STRIP ME OF MORTALITY'S SHACKLE!",
				",w LET THIS FRAIL MORTALITY FALL AWAY FROM PURPOSE!",
				",w REMAKE ME IN DEATH'S ENDURING IMAGE!",
				",w I OFFER THIS VESSEL TO COMPLETE THY WORK!",
			)

	for(var/i in 1 to length(chant_lines))
		user.say(chant_lines[i], forced = "spell", language = /datum/language/common)
		user.adjustBruteLoss(15)
		if(path_choice == "Progress")
			user.emote(pick("whimper", "painmoan", "gag", "choke"))
		else
			user.emote(pick("painscream", "agony", "paincrit", "choke"))
		if(i > 1)
			shake_camera(user, i * 2, i)
		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, span_warning("The ritual collapses. Zizo's gaze turns away."))
			return FALSE

	ADD_TRAIT(user, TRAIT_ARCYNE, "[type]")

	switch(path_choice)
		if("Progress") // basically, this turns you into a skinny nerdinger at the cost of being a CHAD zizo worshipper
			user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			if(user.mind)
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6))
				ADD_TRAIT(user, TRAIT_NOMOOD, "[type]") // your mind belongs to HER now
				ADD_TRAIT(user, TRAIT_JACKOFALLTRADES, "[type]") // the progress palooza to let you grind more efficiently
				ADD_TRAIT(user, TRAIT_SELF_SUSTENANCE, "[type]") // also fitting for the progress vibe, way more balanced than the specialist traits IMO
				grant_poke_spell(user)
			user.visible_message(span_boldwarning("Arcyne runes sear themselves across [user]'s skin, glowing with a sickly light before fading beneath the flesh!"), span_notice("THE LESSER WORK IS DONE! Arcyne knowledge floods my mind - I can see the threads of magic itself!"))

		if("Unlife") // this turns you into a CHAD half-skeleton at the cost of being a nerd
			user.mob_biotypes |= MOB_UNDEAD
			user.dna.species.species_traits |= NOBLOOD
			ADD_TRAIT(user, TRAIT_STEELHEARTED, "[type]") // ready for violence
			ADD_TRAIT(user, TRAIT_NOPAIN, "[type]") // nothing left to feel pain, duh
			ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]") // you have no stomach, duh
			ADD_TRAIT(user, TRAIT_NOBREATH, "[type]") // you have no lungs. duh
			ADD_TRAIT(user, TRAIT_LIMBATTACHMENT, "[type]") // cause old Rituos let you recreate your skeleton limbs, but since this one deletes the spell after use, this is the best way to make it level
			ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, "[type]") // cause it makes no sense
			ADD_TRAIT(user, TRAIT_SILVER_WEAK, "[type]") // yes
			for(var/obj/item/bodypart/part as anything in user.bodyparts)
				if(istype(part, /obj/item/bodypart/head))
					continue
				part.skeletonize(FALSE)
				user.update_body_parts()
				playsound(src, 'sound/misc/lava_death.ogg', 100, FALSE)
				sleep(25)				
			var/obj/item/bodypart/torso = user.get_bodypart(BODY_ZONE_CHEST)
			playsound(src, 'sound/misc/lava_death.ogg', 100, FALSE)
			torso?.skeletonize(FALSE)
			user.update_body_parts()
			user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			if(user.mind)
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 3, ward = TRUE))
				user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonechill)
				user.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonemend)
				grant_poke_spell(user)
			user.visible_message(span_boldwarning("[user]'s skin and flesh burns away in necrotic flames, revealing bare bone beneath as [user.p_they()] [user.p_are()] consumed by the Lesser Work!"), span_notice("THE LESSER WORK IS DONE! My flesh is forfeit - and death itself answers my call!"))
			to_chat(user, span_purple("You finished Rituos to perfection, you should be a full-fledged Lich now, but..."))
			sleep(30)
			to_chat(user, "<i>...Vestiges of mortality still cling to me...? Why?</i>")

	// The Lesser Work is done - remove the spell
	user.mind?.RemoveSpell(src)
	qdel(src)

/obj/effect/proc_holder/spell/invoked/rituos/proc/grant_poke_spell(mob/living/carbon/human/user)
	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Greater Arcyne Bolt", "Stygian Efflorescence", "Arcyne Lance", "Lesser Gravel Blast")
	var/poke_choice = tgui_input_list(user, "Choose your offensive cantrip.", "Arcyne Awakening", poke_options)
	if(!poke_choice || !user.mind)
		return
	switch(poke_choice)
		if("Spitfire")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Greater Arcyne Bolt")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/greater_arcyne_bolt)
		if("Stygian Efflorescence")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
		if("Lesser Gravel Blast")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast/lesser)
