/datum/action/cooldown/spell/zizo
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	spell_color = GLOW_COLOR_ZIZO

	ignore_armor_penalty = TRUE

	attunement_school = null

	primary_resource_type = SPELL_COST_DEVOTION

	secondary_resource_type = SPELL_COST_STAMINA

	has_visual_effects = FALSE
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC

	associated_stat = null
	associated_skill = /datum/skill/magic/holy
	zizo_spell = TRUE

	spell_tier = 0
	point_cost = 0

	required_items = list(/obj/item/clothing/neck/roguetown/psicross)

// SNUFF LIGHTS (T0) - Extinguishes most light sources, and grants you a temporary Dark Vision steroid that scales from your Holy skill.
/datum/action/cooldown/spell/zizo/snuff_lights
	name = "Snuff Lights"
	desc = "Extinguish all lights in range, with your Miracle skill increasing range."
	button_icon_state = "snufflight"
	sound = 'sound/magic/zizo_snuff.ogg'
	associated_stat = null
	charge_required = FALSE
	click_to_activate = FALSE
	cooldown_time = 20 SECONDS
	primary_resource_cost = 30
	secondary_resource_cost = 10
	var/snuff_range = 2

/datum/action/cooldown/spell/zizo/snuff_lights/cast(atom/cast_on)
	. = ..()

	if(!ishuman(owner))
		return FALSE

	var/checkrange = snuff_range + owner.get_skill_level(/datum/skill/magic/holy)
	var/extinguished_anything = FALSE
	var/had_nightvision = HAS_TRAIT(owner, TRAIT_NITEVISION)

	for(var/obj/O in range(checkrange, owner))
		if(O.light_range || O.light_power)
			extinguished_anything = TRUE

		O.extinguish()

	for(var/mob/M in range(checkrange, owner))
		for(var/obj/O in M.contents)
			if(O.light_range || O.light_power)
				extinguished_anything = TRUE

			O.extinguish()

	var/skill_level = owner.get_skill_level(/datum/skill/magic/holy)
	var/duration = (10 SECONDS) + (skill_level * 5 SECONDS)

	REMOVE_TRAIT(owner, TRAIT_NITEVISION, "zizo_snuff")
	ADD_TRAIT(owner, TRAIT_NITEVISION, "zizo_snuff")

	addtimer(
		CALLBACK(src, PROC_REF(remove_nightvision_buff), owner),
		duration
	)

	if(extinguished_anything && !had_nightvision)
		owner.visible_message(
			span_warning("[owner] exhales a grayish fog that smothers nearby lights as their pupils widen unnaturally."),
			span_notice("You exhale a gray fog that chokes out nearby lights. As darkness settles in, your pupils dilate.")
		)

	else if(!extinguished_anything && !had_nightvision)
		owner.visible_message(
			span_warning("[owner]'s pupils suddenly dilate into dark pools."),
			span_notice("No lights answer your call, but your pupils still widen to drink in the darkness.")
		)

	return TRUE

/datum/action/cooldown/spell/zizo/snuff_lights/proc/remove_nightvision_buff(mob/living/user)
	if(!user)
		return
	if(HAS_TRAIT(user, TRAIT_NITEVISION))
		REMOVE_TRAIT(user, TRAIT_NITEVISION, "zizo_snuff")

// PROFANE (T1) - Fires a cheap shot that has a very high chance to embed into an enemy and deals bonus integrity damage. If you have bones around you, or on your hands, you'll throw a lance that deals a lot of integrity damage. If the target is standing close to bones/piles when they are hit, those will also become Profaned and attack them.
/datum/action/cooldown/spell/projectile/profane
	name = "Profane"
	desc = "Fire forth a splinter of unholy bone, tearing flesh and causing bleeding. If bones are nearby—or in your hands—you may shape them into a far deadlier lance."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "profane"
	projectile_type = /obj/projectile/magic/profane
	primary_resource_cost = 15
	secondary_resource_cost = 15
	charge_required = FALSE
	cooldown_time = 11 SECONDS

/datum/action/cooldown/spell/projectile/profane/fire_projectile(atom/target)
	var/big_cast = FALSE

	for(var/obj/item/I in owner.held_items)
		if(istype(I, /obj/item/natural/bundle/bone))
			var/obj/item/natural/bundle/bone/B = I
			if(B.use(1))
				big_cast = TRUE
				break

		else if(istype(I, /obj/item/natural/bone))
			qdel(I)
			big_cast = TRUE
			break

	if(!big_cast)
		for(var/obj/item/I in range(1, owner))
			if(istype(I, /obj/item/natural/bundle/bone))
				var/obj/item/natural/bundle/bone/B = I
				if(B.use(1))
					big_cast = TRUE
					break

			else if(istype(I, /obj/item/natural/bone))
				qdel(I)
				big_cast = TRUE
				break

	if(big_cast)
		projectile_type = /obj/projectile/magic/profane/major

	. = ..()

	if(big_cast)
		owner.visible_message(span_danger("[owner] tears nearby bone into the air, shaping it into a vicious lance before hurling it at [target]!"), span_notice("I shape available bone into a brutal lance and hurl it at [target]!"))
	else
		owner.visible_message(span_danger("[owner] flicks their arm forward, launching a jagged bone splinter at [target]!"), span_notice("I launch a splinter of profaned bone at [target]!"))
	
	projectile_type = initial(projectile_type)

/obj/projectile/magic/profane
	name = "profaned bone splinter"
	icon_state = "chronobolt"
	damage = 25
	damage_type = BRUTE
	nodamage = FALSE
	intdamfactor = 1.5
	var/embed_prob = 50

/obj/projectile/magic/profane/major
	name = "profaned bone lance"
	damage = 50
	embed_prob = 75
	intdamfactor = 3

/obj/projectile/magic/profane/on_hit(atom/target, blocked)
	. = ..()
	if(!iscarbon(target))
		return
	var/mob/living/carbon/carbon_target = target
	// Primary embed effect
	if(prob(embed_prob))
		if(length(carbon_target.bodyparts))
			var/obj/item/bodypart/victim_limb = pick(carbon_target.bodyparts)
			if(victim_limb)
				var/obj/item/bone/splinter/S = new
				victim_limb.add_embedded_object(S, FALSE, TRUE)

	// Nearby bones erupt toward victim
	for(var/obj/item/I in range(3, carbon_target))
		if(istype(I, /obj/item/natural/bundle/bone))
			var/obj/item/natural/bundle/bone/B = I
			qdel(B)
			fire_secondary_profane_shard(carbon_target)
		else if(istype(I, /obj/item/natural/bone))
			qdel(I)
			fire_secondary_profane_shard(carbon_target)

/obj/projectile/magic/profane/proc/fire_secondary_profane_shard(mob/living/carbon/target)
	if(!target)
		return
	var/turf/start = get_turf(src)
	if(!start)
		return
	var/obj/projectile/magic/profane/P = new start
	P.firer = firer
	P.preparePixelProjectile(target, start)
	P.fire()

/obj/item/bone/splinter
	name = "bone splinter"
	embedding = list("embed_chance" = 100, "embedded_pain_chance" = 25, "embedded_fall_chance" = 5)

/obj/item/bone/splinter/dropped(mob/user, silent)
	. = ..()

	if(isturf(loc))
		visible_message(span_danger("[src] crumbles into dust..."))
		qdel(src)

/obj/item/bone/splinter/forceMove(atom/newloc)
	. = ..()
	if(isturf(newloc))
		visible_message(span_danger("[src] crumbles into dust..."))
		qdel(src)

// RAISE LESSER SKELETON (T2) - The new 'main' Zizo undeath-raising skill. Summon's durability scales from Miracle skill.
/datum/action/cooldown/spell/raise_undead_formation/zizo
	overlay_state = "skeleton_formation"
	name = "Raise Lesser Skeleton"
	desc = "Invoke Enochian magicka to bind loose bones into a simple skeletal thrall. Its crude physiology is held together purely by magic; unable to be incapacitated, it shall stand until it crumbles into spare bones. It is also simpler to control, so you can order it to move, guard or attack manually."
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 60
	secondary_resource_cost = SPELL_COST_ENERGY
	secondary_resource_cost = 40
	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 30 SECONDS
	cabal_affine = TRUE
	to_spawn = 1

// RAISE GREATER SKELETON (T2) - Mostly antiquated here, not available for Zizites, but they're still available for Liches/Necromancers.
/datum/action/cooldown/spell/raise_undead_guard/zizo
	name = "Raise Greater Skeleton"
	desc = "Invoke Enochian magicka to bind bones into a more complex skeletal thrall. Its refined physique allows it to wield superior weapons, durability and also wear armor, however it cannot be controlled by any means, aside telling ally from foe."
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 75

// TAME UNDEAD (T3) - I don't know why this is a T3, being just a forced Gravemark on a hostile NPC undead.
/datum/action/cooldown/spell/tame_undead/zizo
	primary_resource_cost = 100

// T3: Rituos - Zizo's Lesser Work. A single painful ritual that grants the caster a choice:
// Progress: Arcyne knowledge (2 minor aspects, 4 utilities). No skeletonization. -- Kunai: I made this more distinctive from Undeath, now it also gives you some traits to give a better progress vibe.
// Unlife: Full skeletonization + MOB_UNDEAD, grants bonechill and raise_deadite directly. -- Kunai: We already have raise_deadite, so it's a moot point to give them the Necromancer version of it. Just gave them bonemend and a few more traits to give the vibe of a 'half-lich'.
// Both paths grant undead language and TRAIT_ARCYNE. One-time use - cannot be cast again after completion.

/datum/action/cooldown/spell/zizo/rituos
	name = "Rituos"
	desc = "Enact one of the Lesser Work of Zizo - a single, agonizing ritual that tears open a path to power. Choose Progress to gain arcyne knowledge, or Unlife to embrace undeath."
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "rituos"
	primary_resource_cost = 90
	secondary_resource_cost = 90
	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = 5 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 3 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_NO_MOVE
	zizo_spell = TRUE

/datum/action/cooldown/spell/rituos/cast(atom/cast_on)
	. = ..()
	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/user = owner
	var/path_choice = tgui_alert(user, "What path of the Lesser Work do you seek?", "THE LESSER WORK", list("Progress", "Unlife", "Cancel"))
	if(!path_choice || path_choice == "Cancel")
		reset_spell_cooldown()
		return FALSE

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
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
				user.mind.AddSpell(new /datum/action/cooldown/spell/bonechill)
				user.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)
				grant_poke_spell(user)
			user.visible_message(span_boldwarning("[user]'s skin and flesh burns away in necrotic flames, revealing bare bone beneath as [user.p_they()] [user.p_are()] consumed by the Lesser Work!"), span_notice("THE LESSER WORK IS DONE! My flesh is forfeit - and death itself answers my call!"))
			to_chat(user, span_purple("You finished Rituos to perfection, you should be a full-fledged Lich now, but..."))
			sleep(30)
			to_chat(user, "<i>...Vestiges of mortality still cling to me...? Why?</i>")

	user.mind?.RemoveSpell(src)
	qdel(src)
	return TRUE

/datum/action/cooldown/spell/rituos/proc/grant_poke_spell(mob/living/carbon/human/user)
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
