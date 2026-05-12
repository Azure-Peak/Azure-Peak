/datum/action/cooldown/spell/projectile/zizo
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
	desc = "Extinguish most light sources within 2 range. For 5 seconds, you will also hone your Darksight. Both effects scale up from Miracle skill."
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
	var/mob/living/L = owner
	var/checkrange = snuff_range + owner.get_skill_level(/datum/skill/magic/holy)
	var/extinguished_anything = FALSE
	var/had_nightvision = L.has_status_effect(/datum/status_effect/buff/snuff_lights)

	for(var/obj/O in range(checkrange, owner))
		if(O.light_power)
			extinguished_anything = TRUE

		O.extinguish()

	for(var/mob/M in range(checkrange, owner))
		for(var/obj/O in M.contents)
			if(O.light_power)
				extinguished_anything = TRUE

			O.extinguish()

	var/skill_level = owner.get_skill_level(/datum/skill/magic/holy)
	var/duration = (5 SECONDS) + ((1 - skill_level) * 10 SECONDS)
	if(!extinguished_anything)
		duration += 30 SECONDS

	L.apply_status_effect(/datum/status_effect/buff/snuff_lights, duration)

	if(extinguished_anything && !had_nightvision)
		owner.visible_message(span_purple("[owner] exhales a grayish fog that smothers nearby lights as their pupils widen unnaturally."),span_purple("You exhale a gray fog that chokes out nearby lights. As darkness settles in, your pupils dilate."))

	else if(!extinguished_anything && !had_nightvision)
		owner.visible_message(span_purple("[owner]'s pupils suddenly dilate into dark pools."), span_purple("No lights answer your call, but your pupils still widen to drink in the darkness."))

	else

		return FALSE

	return TRUE


/atom/movable/screen/alert/status_effect/buff/snuff_lights
	name = "True Darksight"
	desc = "My eyes can see clearly through the darkness."
	icon_state = "darkvision"

/datum/status_effect/buff/snuff_lights
	id = "snuff_lights"
	alert_type = /atom/movable/screen/alert/status_effect/buff/snuff_lights

/datum/status_effect/buff/snuff_lights/on_apply(mob/living/new_owner, new_duration)
	. = ..()
	duration = new_duration
	ADD_TRAIT(owner, TRAIT_NITEVISION, "snuff_lights")
	owner.update_sight()

/datum/status_effect/buff/snuff_lights/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NITEVISION, "snuff_lights")
	owner.update_sight()

////////////////
//T1 - PROFANE//
////////////////
// Fires a cheap and weak shot that if you manage to hit 4 times in the brief gap of 3 seconds consecutively, it pops, inflicting a light poison and some damage. Bones around will null the cost.
/datum/action/cooldown/spell/projectile/zizo/profane
	name = "Profane"
	desc = "Launch a shard of profaned bone that tears flesh and causes bleeding. Every fourth successful hit causes a violent rupture that bypasses armor and impales the target, spreading vile toxins.<br><br>If bones are nearby, they are consumed and the spell's costs are negated."
	fluff_desc = "Bone remembers. Even when stripped, burned, or buried, it recalls the shape of life, and the cruelty that denied it rest. The Cabal does not summon the dead; it convinces what remains that it was never meant to be still. Each shard is a prayer spoken backward, each wound a lesson in obedience to Her Grand Design. There is a greater meaning behind the number 'four'."	
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "profane"
	projectile_type = /obj/projectile/magic/profane
	cast_range = SPELL_RANGE_PROJECTILE
	primary_resource_cost = 10
	secondary_resource_cost = 10
	charge_required = FALSE
	cooldown_time = 7 SECONDS

/datum/action/cooldown/spell/projectile/zizo/profane/cast(atom/cast_on)
	var/mob/living/user = owner
	if(consume_bones_for_refund(user, 1))
		primary_resource_cost = 0
		secondary_resource_cost = 0
		user.visible_message(span_notice("[user] feeds bone fragments into the ritual, lessening the costs..."))

	. = ..()

/proc/consume_bones_for_refund(mob/living/user, amount = 1)
	var/remaining = amount
	for(var/obj/item/natural/bone/B in user.contents)
		if(remaining <= 0)
			break
		qdel(B)
		remaining--
	for(var/obj/item/natural/bundle/bone/BB in user.contents)
		if(remaining <= 0)
			break
		if(BB.amount <= 0)
			continue
		var/take = min(BB.amount, remaining)
		BB.amount -= take
		remaining -= take
		if(BB.amount <= 0)
			qdel(BB)
	return (remaining <= 0)

/obj/item/bone/splinter
	name = "bone splinter"
	embedding = list("embed_chance" = 100, "embedded_pain_chance" = 20, "embedded_fall_chance" = 2)

/obj/item/bone/splinter/dropped(mob/user, silent)
	. = ..()
	if(isturf(loc))
		visible_message(span_danger("[src] crumbles into dust..."))
		qdel(src)

/obj/item/bone/splinter/forceMove(atom/newloc)
	. = ..()
	if(isturf(newloc))
		visible_message(span_danger("[src] crumbles into dust..."))

/obj/projectile/magic/profane
	name = "profaned bone splinter"
	icon_state = "chronobolt"
	damage = 20
	damage_type = BRUTE
	nodamage = FALSE
	intdamfactor = 1.6
	range = SPELL_RANGE_PROJECTILE
	speed = MAGE_PROJ_FAST
	accuracy = 40
	var/embed_prob = 50

/obj/projectile/magic/profane/on_hit(atom/target, blocked)
	. = ..()
	if(!isliving(target))
		qdel(src)
		return
	var/mob/living/L = target
	if(L.anti_magic_check())
		visible_message(span_warning("[src] shatters harmlessly against [target]!"))
		playsound(get_turf(target), 'sound/magic/magic_nulled.ogg', 100)
		qdel(src)
		return BULLET_ACT_BLOCK
	if(iscarbon(L))
		var/mob/living/carbon/C = L
		if(prob(embed_prob) && length(C.bodyparts))
			var/obj/item/bodypart/limb = pick(C.bodyparts)
			if(limb)
				var/obj/item/bone/splinter/S = new
				limb.add_embedded_object(S, FALSE, TRUE)
		C.apply_status_effect(/datum/status_effect/debuff/profane_mark, firer)
	qdel(src)

/datum/status_effect/debuff/profane_mark
	id = "profane_mark"
	status_type = STATUS_EFFECT_REFRESH
	duration = 15 SECONDS
	var/stacks = 0
	var/max_stacks = 4
	var/mob/living/original_caster

/datum/status_effect/debuff/profane_mark/on_creation(mob/living/new_owner, mob/living/caster)
	. = ..()
	original_caster = caster
	stacks = 1
	return TRUE

/datum/status_effect/debuff/profane_mark/on_apply()
	. = ..()
	stacks++
	if(stacks >= max_stacks)
		rupture()

/datum/status_effect/debuff/profane_mark/proc/rupture()
	if(!owner || owner.stat == DEAD)
		qdel(src)
		return
	if(owner.resting && !owner.mind)
		owner.visible_message(span_danger("[owner] is torn apart as profaned bone detonates within their body!"), span_userdanger("I am ripped apart from within!"))
		owner.gib(TRUE, TRUE, TRUE)
		qdel(src)
		return
	owner.visible_message(span_danger("Profaned bone violently erupts from [owner] and corrupt their humors!"), span_userdanger("Agony explodes through me as profaned bone tears me apart and corrupt my humors!"))
	new /obj/effect/temp_visual/dir_setting/bloodsplatter(get_turf(owner), pick(GLOB.alldirs))
	playsound(get_turf(owner), pick('sound/combat/fracture/fracturedry (1).ogg', 'sound/combat/fracture/fracturedry (2).ogg', 'sound/combat/fracture/fracturedry (3).ogg'), 80, TRUE)
	var/damage_zone = BODY_ZONE_CHEST
	if(isliving(original_caster))
		var/mob/living/caster = original_caster
		damage_zone = check_zone(caster.zone_selected)
	owner.apply_damage(50, BRUTE, def_zone = damage_zone)
	owner.apply_status_effect(/datum/status_effect/debuff/profane_poison)
	qdel(src)

/datum/status_effect/debuff/profane_poison
	id = "profane_poison"
	status_type = STATUS_EFFECT_REFRESH
	duration = 10 SECONDS
	tick_interval = 1 SECONDS
	var/tick_damage = 2
	var/npc = 8

/datum/status_effect/debuff/profane_poison/tick()
	if(!owner)
		qdel(src)
		return
	if(owner.stat == UNCONSCIOUS || owner.stat == DEAD)
		qdel(src)
		return
	var/damage = tick_damage
	if(!owner.mind)
		damage = npc
	owner.adjustToxLoss(damage)
	owner.adjustOxyLoss(damage * 2)
	return

// RAISE LESSER SKELETON (T2) - The new 'main' Zizo undeath-raising skill. Summon's durability scales from Miracle skill.
/datum/action/cooldown/spell/raise_undead_formation/zizo
	button_icon_state = "skeleton_formation"
	name = "Raise Lesser Skeleton"
	desc = "Invoke raw Enochian magicka to bind loose bones into a simple skeletal thrall. Its crude physiology is held together purely by magic; unable to be incapacitated, it shall stand until it crumbles into spare bones. It is also simpler to control, so you can order it to move, guard or attack manually."
	spell_color = GLOW_COLOR_ZIZO
	primary_resource_cost = 60
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
	invocation_type = null
	invocations = null
	associated_skill = /datum/skill/magic/holy

// TAME UNDEAD (T3) - I don't know why this is a T3, being just a forced Gravemark on a hostile NPC undead.
/datum/action/cooldown/spell/tame_undead/zizo
	associated_skill = /datum/skill/magic/holy
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
	charge_sound = 'sound/magic/chargingold.ogg'
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_NO_MOVE
	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_message = "<font color=red>ZIZO! ZIZO! ZIZO!"
	charge_required = TRUE
	charge_time = 10 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	cooldown_time = 3 MINUTES
	primary_resource_cost = 100
	secondary_resource_cost = 100
	sound = 'sound/magic/swap.ogg'


/datum/action/cooldown/spell/zizo/rituos/cast(atom/cast_on)
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

/datum/action/cooldown/spell/zizo/rituos/proc/grant_poke_spell(mob/living/carbon/human/user)
	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Greater Arcyne Bolt", "Stygian Efflorescence", "Arcyne Lance", "Lesser Gravel Blast", "Lesser Soulshot")
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
		if("Lesser Soulshot")
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/soulshot/lesser)

/// T3: Bone Cataclysm - Pretty much pops your summons into sad remains of their former selves. Shouldn't do a lot of damage, but it frags someone with bone splinters if they're close enough.
/datum/action/cooldown/spell/zizo/bone_cataclysm
	name = "Bone Cataclysm"
	desc = "Detonate all of your nearby skeletons in a wave of profane bone shrapnel. You and Gravemarked allies will not be harmed by it.<br><br>If used outside Combat Mode, you will disintegrate them and restore your energy."
	fluff_desc = "Zizo taught her faithful that the dead must always serve twice: once in unlife, and once more when their bones are shattered in her name."	
	button_icon = 'icons/mob/actions/actions_clockcult.dmi'
	button_icon_state = "Kindle"
	click_to_activate = FALSE
	self_cast_possible = TRUE
	charge_required = TRUE
	charge_time = 3 SECONDS
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_message = "I begin unraveling my undead servants..."
	cooldown_time = 1.5 MINUTES
	primary_resource_cost = 50
	secondary_resource_cost = 50
	invocations = list("Solve ossa, redite ad pulverem!")
	invocation_type = INVOCATION_SHOUT
	sound = 'sound/magic/swap.ogg'

/datum/action/cooldown/spell/zizo/bone_cataclysm/cast(atom/cast_on)
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
			addtimer(CALLBACK(src, PROC_REF(despawn_skeleton), S, caster, B), rand(2 SECONDS, 3 SECONDS))

		return TRUE

/datum/action/cooldown/spell/zizo/bone_cataclysm/proc/explode_skeleton(mob/living/S, mob/living/caster, datum/beam/B)
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

/datum/action/cooldown/spell/zizo/bone_cataclysm/proc/despawn_skeleton(mob/living/S,	mob/living/caster, datum/beam/B)	
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
