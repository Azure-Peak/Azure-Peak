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
	chargetime = 0
	recharge_time = 11 SECONDS // moved cast time to cooldown
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
	chargetime = 5 SECONDS
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
		if("Progress") // support path, your mind is twisted in Her design
			user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			if(user.mind)
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 6))
				ADD_TRAIT(user, TRAIT_STEELHEARTED, "[type]") // so you can commit atrocities with a smile
				ADD_TRAIT(user, TRAIT_JACKOFALLTRADES, "[type]") // the progress palooza to let you grind more efficiently
				ADD_TRAIT(user, TRAIT_SELF_SUSTENANCE, "[type]") // also fitting for the progress vibe, way more balanced than the specialist traits IMO
				grant_poke_spell(user)
			user.visible_message(span_boldwarning("Arcyne runes sear themselves across [user]'s skin, glowing with a sickly light before fading beneath the flesh!"), span_notice("THE LESSER WORK IS DONE! Arcyne knowledge floods my mind - I can see the threads of magic itself!"))

		if("Unlife") // combat path, your body is now carries undeath resilience
			user.mob_biotypes |= MOB_UNDEAD
			user.dna.species.species_traits |= NOBLOOD
			ADD_TRAIT(user, TRAIT_NOMOOD, "[type]") // undead apathy
			ADD_TRAIT(user, TRAIT_NOPAIN, "[type]") // you have no flesh
			ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]") // you have no stomach
			ADD_TRAIT(user, TRAIT_NOBREATH, "[type]") // you have no lungs
			ADD_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE, "[type]") // just in case NOBLOOD is not enough
			ADD_TRAIT(user, TRAIT_LIMBATTACHMENT, "[type]") // cause old Rituos let you recreate your skeleton limbs, but since this one deletes the spell after use, this is the best way to make it level
			ADD_TRAIT(user, TRAIT_ZOMBIE_IMMUNE, "[type]") // cause it makes no sense
			ADD_TRAIT(user, TRAIT_SILVER_WEAK, "[type]") // must have
			for(var/obj/item/bodypart/part as anything in user.bodyparts)
				if(istype(part, /obj/item/bodypart/head))
					continue
				part.skeletonize(FALSE)
				user.update_body_parts()
				playsound(user.loc, 'sound/misc/smelter_sound.ogg', 50, FALSE)
				sleep(15)
			var/obj/item/bodypart/torso = user.get_bodypart(BODY_ZONE_CHEST)
			playsound(user.loc, 'sound/misc/lava_death.ogg', 100, FALSE)
			torso?.skeletonize(FALSE)
			user.update_body_parts()
			user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			if(user.mind)
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4, ward = TRUE))
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

/// T3: Bone Cataclysm - Pretty much pops your summons into sad remains of their former selves. Shouldn't do a lot of damage, but it frags someone with bone splinters if they're close enough.
/datum/action/cooldown/spell/miracle/bone_cataclysm
	name = "Bone Cataclysm"
	desc = "Detonate all of your nearby skeletons in a wave of profane bone shrapnel. You and Gravemarked allies will not be harmed by it.<br><br>If used outside Combat Mode, you will disintegrate them and restore your energy."
	fluff_desc = "Zizo taught her faithful that the dead must always serve twice: once in unlife, and once more when their bones are shattered in her name."	
	button_icon_state = "bone_zone"
	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = TRUE
	charge_time = 3 SECONDS
	charge_slowdown = 0.5
	charge_message = "I begin unraveling my undead servants..."
	cooldown_time = 1.5 MINUTES
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 50
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = 75
	invocations = list("Solve ossa. Redite ad pulverem!")
	invocation_type = INVOCATION_SHOUT
	sound = 'sound/magic/swap.ogg'
	spell_color = "#c300ff"
	glow_intensity = GLOW_INTENSITY_HIGH

/datum/action/cooldown/spell/miracle/bone_cataclysm/cast(atom/cast_on)
	. = ..()
	var/list/valid_skeletons = list()
	var/faction_tag = "[REF(owner)]_faction"
	var/mob/living/caster = owner
	for(var/mob/living/L in view(9, owner))
		if(QDELETED(L))
			continue
		if(L.stat == DEAD)
			continue
		if(istype(L, /mob/living/simple_animal/hostile/rogue/skeleton))
			var/mob/living/simple_animal/hostile/rogue/skeleton/S = L
			if(S.summoner != owner.real_name)
				continue
			valid_skeletons += S
			continue

		if(istype(L, /mob/living/carbon/human/species/skeleton))
			if(L.mind?.current)
				if(!(faction_tag in L.mind.current.faction))
					continue
			else
				if(!(faction_tag in L.faction))
					continue
			valid_skeletons += L

	if(!valid_skeletons.len)
		owner.balloon_alert(owner, "No bound skeletons nearby!")
		return FALSE

	if(owner.cmode)
		owner.visible_message(span_danger("[owner] raises their hand as nearby skeletons begin violently rattling apart!"), span_userdanger("I prime my undead servants to violently explode."))
		for(var/mob/living/S in valid_skeletons)
			S.Jitter(100)
			var/datum/beam/B = caster.Beam(S, icon_state = "necra_beam", time = 50, maxdistance = 20)
			addtimer(CALLBACK(src, PROC_REF(explode_skeleton), S, caster, B), rand(3 SECONDS, 6 SECONDS))
		
		return TRUE

	else
		owner.visible_message(span_danger("[owner] raises their hand as nearby skeletons begin calmly rattling apart!"), span_userdanger("I sacrifice my undead servants, and sap their energy."))
		for(var/mob/living/S in valid_skeletons)
			S.Jitter(100)
			var/datum/beam/B = caster.Beam(S,icon_state = "necra_beam",	time = 30, maxdistance = 20)
			addtimer(CALLBACK(src, PROC_REF(despawn_skeleton), S, caster, B), rand(3 SECONDS, 6 SECONDS))

		return TRUE

/datum/action/cooldown/spell/miracle/bone_cataclysm/proc/explode_skeleton(mob/living/S, mob/living/caster, datum/beam/B)
	if(B)
		B.End()
	if(!S || QDELETED(S))
		return
	if(!caster || QDELETED(caster))
		return

	var/turf/T = get_turf(S)
	if(!T)
		return

	var/faction_tag = "[caster.real_name]_faction"

	S.visible_message(span_danger("[S] erupts into a storm of bone fragments!"))
	new /obj/effect/temp_visual/explosion(T)
	playsound(T, 'sound/misc/explode/explosion.ogg', 50)

// Repulse copypasta for more chupatz, will affect you too, just not do damage.
	var/list/thrownatoms = list()
	for(var/turf/nearby in get_hear(1, T))
		for(var/atom/movable/AM in nearby)
			thrownatoms += AM
	for(var/atom/movable/AM in thrownatoms)
		if(QDELETED(AM))
			continue
		if(AM == S)
			continue
		if(AM.anchored)
			continue
		if(isliving(AM))
			var/mob/living/M = AM
			if(M == owner)
				continue
			if(M.mind?.current)
				if(faction_tag in M.mind.current.faction)
					continue
			else
				if(faction_tag in M.faction)
					continue
			M.set_resting(TRUE, TRUE)
			to_chat(M, span_danger("The blast hurls you backwards!"))
		var/atom/throwtarget = get_edge_target_turf(T, get_dir(T, get_step_away(AM, T)))
		AM.safe_throw_at(throwtarget, 2, 1, owner, force = MOVE_FORCE_EXTREMELY_STRONG)

	for(var/mob/living/carbon/C in view(4, T))
		if(C.stat == DEAD && C.mind)
			continue
		if(C == owner)
			continue
		if(C.mind?.current)
			if(faction_tag in C.mind.current.faction)
				continue
		else
			if(faction_tag in C.faction)
				continue

		var/dist = get_dist(C, T)
		var/min_splinters
		var/max_splinters

		switch(dist)
			if(0,1)
				min_splinters = 3
				max_splinters = 6
			if(2)
				min_splinters = 2
				max_splinters = 4
			if(3)
				min_splinters = 1
				max_splinters = 2
			else
				continue
		var/splinter_count = rand(min_splinters, max_splinters)
		C.adjustBruteLoss(rand(10,20))

		for(var/i in 1 to splinter_count)
			if(!length(C.bodyparts))
				break
			var/obj/item/bodypart/limb = pick(C.bodyparts)
			var/obj/item/bone/splinter/P = new
			limb.add_embedded_object(P, FALSE, TRUE)
		C.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
		C.apply_status_effect(/datum/status_effect/debuff/exposed, 8 SECONDS)
		to_chat(C, span_userdanger("Bone splinters bury themselves deep into your flesh!"))
		if(C.resting || C.stat == DEAD && !C.mind) // to finish off NPCs in a cooler way
			C.gib(TRUE, TRUE, TRUE, FALSE)
	new /obj/effect/decal/remains/human(T)
	qdel(S)

/datum/action/cooldown/spell/miracle/bone_cataclysm/proc/despawn_skeleton(mob/living/S,	mob/living/caster, datum/beam/B)	
	if(B)
		B.End()
	if(!S || QDELETED(S))
		return
	if(!caster || QDELETED(caster))
		return
	var/turf/T = get_turf(S)
	if(!T)
		return
	S.visible_message(span_warning("[S] crumbles apart into pale dust as its essence is siphoned away!"), span_warning("Ashes to ashes, dust to dust..."))
	playsound(T, 'sound/magic/swap.ogg', 50, TRUE)
	caster.energy_add(100)
	caster.stamina_add(-50)
	new /obj/item/ash(T)
	new /obj/item/ash(T)
	qdel(S)
