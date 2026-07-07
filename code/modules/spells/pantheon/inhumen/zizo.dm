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
	fluff_desc = "Flame, light, purity... all arrogant lies of the living. Wretched falsehoods peddled by the Ten to keep mortals fearful of the dark. They are intrusions; frail comforts that convince men they are safe from what waits beyond their sight. Zizo's first revelation was simple: light is not needed to see. Truth does not shine. It festers in the dark, waiting for those willing to behold it."
	button_icon_state = "snufflight"
	associated_stat = null
	charge_required = FALSE
	click_to_activate = FALSE
	cooldown_time = 40 SECONDS
	primary_resource_cost = 30
	secondary_resource_cost = 10
	sound = 'sound/magic/zizo_snuff.ogg'
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN
	var/snuff_range = 2

/datum/action/cooldown/spell/zizo/snuff_lights/cast(atom/cast_on)
	. = ..()

	if(!ishuman(owner))
		return FALSE

	var/mob/living/L = owner
	var/skill_level = owner.get_skill_level(/datum/skill/magic/holy)
	var/checkrange = snuff_range + skill_level

	for(var/obj/O in range(checkrange, owner))
		if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
			continue
		if(istype(O, /obj/item/flashlight/flare/light))
			qdel(O)
		O.extinguish()

	for(var/mob/M in range(checkrange, owner))
		for(var/obj/O in M.contents)
			if(istype(O, /obj/item/flashlight/flare/torch/lantern/psycenser))
				continue
			if(istype(O, /obj/item/flashlight/flare/light))
				qdel(O)
			O.extinguish()

	var/bonus_duration = 10 SECONDS + ((max(skill_level - 1, 0)) * 30 SECONDS)
	L.apply_status_effect(/datum/status_effect/buff/snuff_lights, bonus_duration)
	owner.visible_message(span_purple("[owner] exhales a cold fog that smothers nearby lights."))
	return TRUE

/atom/movable/screen/alert/status_effect/buff/snuff_lights
	name = "Embracing Darkness"
	desc = "My eyes can see clearly in darkness. No secrets can hide from my prying gaze."
	icon_state = "darkvision"

/datum/status_effect/buff/snuff_lights
	id = "snuff_lights"
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/buff/snuff_lights

/datum/status_effect/buff/snuff_lights/on_creation(mob/living/new_owner, bonus_duration)
	if(bonus_duration)
		duration = bonus_duration
	return ..()

/datum/status_effect/buff/snuff_lights/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_NITEVISION, "snuff_lights")
	owner.update_sight()

/datum/status_effect/buff/snuff_lights/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_NITEVISION, "snuff_lights")
	owner.update_sight()

////////////////
//T1 - PROFANE//
////////////////
/datum/action/cooldown/spell/projectile/zizo/profane
	name = "Profane"
	desc = "Instantly launch a cursed bone shard that pierces any armor and always lodges into its victim."
	fluff_desc = "An early Cabal sacrament: bone, profaned through Zizo's teachings, proved a willing conduit for Avantyne's anti-life qualities. Splinters touched by Her grace pierce any ward and bury themselves deep in living flesh, a lasting testament to Her cruelty."
	button_icon_state = "profane"
	projectile_type = /obj/projectile/magic/profane
	cast_range = SPELL_RANGE_PROJECTILE
	primary_resource_cost = 15
	secondary_resource_cost = 15
	charge_required = FALSE
	cooldown_time = 30 SECONDS
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/obj/item/bone/profane_splinter
	name = "profaned splinter"
	desc = "A jagged shard of bone pulsing with malignant energy."
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "chronobolt"
	embedding = list("embed_chance" = 100, "embedded_fall_chance" = 0, "embedded_ignore_throwspeed_threshold" = TRUE)

/obj/item/bone/profane_splinter/Initialize()
	. = ..()
	spawn(1)
		if(QDELETED(src))
			return
		if(!is_embedded)
			crumble()

/obj/item/bone/profane_splinter/Exited(atom/movable/gone, direction)
	. = ..()
	if(!is_embedded)
		crumble()

/obj/item/bone/profane_splinter/dropped(mob/user)
	. = ..()
	crumble()

/obj/item/bone/profane_splinter/Moved()
	. = ..()
	if(QDELETED(src))
		return
	if(!is_embedded)
		crumble()

/obj/item/bone/profane_splinter/proc/crumble()
	if(QDELETED(src))
		return
	visible_message(span_purple("[src] crumbles into dust..."), span_purple("[src] crumbles into dust..."))
	new /obj/item/ash(get_turf(src))
	qdel(src)

/obj/projectile/magic/profane
	name = "profaned bone shard"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "chronobolt"
	damage = 15
	damage_type = BRUTE
	nodamage = FALSE
	armor_penetration = PEN_BSTEEL
	range = SPELL_RANGE_PROJECTILE
	speed = MAGE_PROJ_FAST
	accuracy = 40
	var/embed_chance = 100

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

	if(out_of_effective_range())
		return
	try_embed_target(L)
	qdel(src)

/obj/projectile/magic/profane/proc/try_embed_target(mob/living/L)
	if(!prob(embed_chance))
		return

	if(!iscarbon(L))
		return

	var/mob/living/carbon/C = L

	if(!length(C.bodyparts))
		return

	var/obj/item/bodypart/limb = pick(C.bodyparts)
	if(!limb)
		return

	var/obj/item/bone/profane_splinter/S = new
	limb.add_embedded_object(S, FALSE, TRUE, TRUE)
	playsound(get_turf(L),pick('sound/combat/fracture/fracturedry (1).ogg','sound/combat/fracture/fracturedry (2).ogg','sound/combat/fracture/fracturedry (3).ogg'),80,TRUE)

// RAISE LESSER SKELETON (T2) - The new 'main' Zizo undeath-raising skill. Summon's durability scales from Miracle skill.
/datum/action/cooldown/spell/raise_undead_formation/zizo
	name = "Raise Lesser Skeleton"
	desc = "Invoke raw Enochian magicka to bind loose bones into a simple skeletal thrall. Its crude physiology is held together purely by magic; unable to be incapacitated, it shall stand until it crumbles into spare bones. It is also simpler to control, so you can order it to move, guard or attack manually."
	fluff_desc = "The faithful of Zizo do not raise the dead, they mock life by proving how little of it is truly required. Flesh decays, thought falters, and souls flee screaming into the arms of Necra, yet bone remains obedient. Through the language of ancient Enochian words of power, scattered remains are lashed together into a parody of mortal form, animated not by purpose or memory, but by the simple joy of defying the natural order."
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "skeleton"
	spell_color = GLOW_COLOR_ZIZO
	primary_resource_cost = 60
	secondary_resource_cost = 40
	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = 2 SECONDS
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/chargingold.ogg'
	cooldown_time = 30 SECONDS
	cabal_affine = TRUE
	miracle = TRUE
	to_spawn = 1
	invocation_type = null
	invocations = null
	associated_skill = /datum/skill/magic/holy
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

// TAME UNDEAD (T3) - I don't know why this is a T3, being just a forced Gravemark on a hostile NPC undead.
/datum/action/cooldown/spell/tame_undead/zizo
	associated_skill = /datum/skill/magic/holy
	primary_resource_cost = 100
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

// T3: Rituos - Zizo's Lesser Work. A single painful ritual that grants the caster a choice:
// Progress: Arcyne knowledge (2 minor aspects, 4 utilities). No skeletonization. -- Kunai: I made this more distinctive from Undeath, now it also gives you some traits to give a better progress vibe.
// Unlife: Full skeletonization + MOB_UNDEAD, grants bonechill and raise_deadite directly. -- Kunai: We already have raise_deadite, so it's a moot point to give them the Necromancer version of it. Just gave them bonemend and a few more traits to give the vibe of a 'half-lich'.
// Both paths grant undead language and TRAIT_ARCYNE. One-time use - cannot be cast again after completion.

/datum/action/cooldown/spell/zizo/rituos
	name = "Rituos"
	desc = "Enact one of the Lesser Work of Zizo - a single, agonizing ritual that tears open a path to power. Choose Progress to gain arcyne knowledge, or Unlife to embrace undeath."
	fluff_desc = "The holiest of Zizo's Lesser Works among the Cabal. A rite of surrendering weakness and mortality to embrace your purpose in Her design. Through agony, the faithful offer either mind or flesh, allowing Zizo to strip away mortal frailty and shape them into reflections of her ascension. Some surrender thought for forbidden understanding. Others surrender flesh for the stillness of unlife. Few endure enough to become what She envisioned. When the gifts fade, the faithful are taught only one truth: they have not sacrificed enough."
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
	var/exploit_this

/datum/action/cooldown/spell/zizo/rituos/cast(atom/cast_on)
	. = ..()

	if(!ishuman(owner))
		return FALSE

	var/mob/living/carbon/human/user = owner

	// exploit protection / backlash
	if(exploit_this)
		user.zizo_spam_rejection()
		cooldown_time = 99 MINUTES
		return TRUE

	exploit_this = TRUE

	var/path_choice = tgui_alert(user, "What path of the Lesser Work do you seek?", "THE LESSER WORK", list("Progress", "Unlife", "Cancel"))

	if(!path_choice || path_choice == "Cancel")
		reset_spell_cooldown()
		exploit_this = FALSE
		return TRUE
	
	if(user.stat != CONSCIOUS)
		return FALSE

	user.visible_message(span_boldwarning("[user] throws back [user.p_their()] head, arcyne energy crackling across [user.p_their()] body!"))
	user.grant_language(/datum/language/undead)

	if(!src.run_ritual_chant(user, path_choice))
		exploit_this = FALSE
		return TRUE

	ADD_TRAIT(user, TRAIT_ARCYNE, "[type]")

	if(user.mind?.has_antag_datum(/datum/antagonist/vampire))
		user.zizo_vampire_rejection()
		exploit_this = FALSE
		return TRUE

	switch(path_choice)
		if("Progress")
			src.apply_progress_path(user)
		if("Unlife")
			src.apply_unlife_path(user)

	user.mind?.RemoveSpell(src)
	qdel(src)
	exploit_this = FALSE
	return TRUE

/// T3: Bone Cataclysm - Pretty much pops your summons into sad remains of their former selves. Shouldn't do a lot of damage, but it frags someone with bone splinters if they're close enough.
/datum/action/cooldown/spell/zizo/bone_cataclysm
	name = "Bone Cataclysm"
	desc = "Detonate all of your nearby skeletons in a wave of profane bone shrapnel. You and Gravemarked allies will not be harmed by it.<br><br>If used outside Combat Mode, you will disintegrate them and restore your energy."
	fluff_desc = "Zizo taught her faithful that the dead must always serve twice: once in unlife, and once more when their bones are shattered in her name."	
	button_icon_state = "cataclysm"
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
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

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
			if(!M.mind && M.resting && M.stat != CONSCIOUS) // to finish off NPCs in a cooler way
				M.gib(TRUE, TRUE, TRUE, FALSE)
			if(!M.mind)
				M.Stun(50)
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
				max_splinters = 4
			if(2)
				min_splinters = 1
				max_splinters = 3
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
			var/obj/item/bone/profane_splinter/P = new
			limb.add_embedded_object(P, FALSE, TRUE)
		C.apply_status_effect(/datum/status_effect/debuff/clickcd, 8 SECONDS)
		C.apply_status_effect(/datum/status_effect/debuff/exposed, 10 SECONDS)
		to_chat(C, span_userdanger("Bone splinters bury themselves deep into your flesh!"))
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
