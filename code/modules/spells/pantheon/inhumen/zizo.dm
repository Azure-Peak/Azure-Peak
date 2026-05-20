// T0: Snuffs out fires/lights around area of the caster, greater range with higher HOLY skill
/datum/action/cooldown/spell/zizo_snuff
	name = "Snuff Lights"
	desc = "Extinguish all lights in range, with your Miracles skill increasing range."
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "snufflight"
	invocations = list("exhales a dark grey smog, choking any lights nearby.")
	invocation_type = INVOCATION_EMOTE
	sound = 'sound/magic/zizo_snuff.ogg'
	associated_skill = /datum/skill/magic/holy
	associated_stat = null
	charge_required = FALSE
	click_to_activate = FALSE
	cooldown_time = 20 SECONDS
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 30
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = 10
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC
	zizo_spell = TRUE
	var/snuff_range = 2

/datum/action/cooldown/spell/zizo_snuff/cast(atom/cast_on)
	. = ..()
	if(!ishuman(owner))
		return FALSE
	var/checkrange = snuff_range + owner.get_skill_level(/datum/skill/magic/holy)
	for(var/obj/O in range(checkrange, owner))
		O.extinguish()
	for(var/mob/M in range(checkrange, owner))
		for(var/obj/O in M.contents)
			O.extinguish()
	return TRUE

// T1: (fires a bone splinter at a target; fires a significantly stronger bone lance if holding bones)

/datum/action/cooldown/spell/projectile/profane
	name = "Profane"
	desc = "Fire forth a splinter of unholy bone, tearing flesh and causing bleeding. If you hold pieces of bone in your other hand, you will coax a much stronger lance of bone into being."
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "profane"
	cast_range = 8
	associated_skill = /datum/skill/magic/arcane
	projectile_type = /obj/projectile/magic/profane
	invocation_type = INVOCATION_NONE
	primary_resource_cost = 30
	primary_resource_type = SPELL_COST_STAMINA
	charge_required = TRUE
	charge_time = 15
	cooldown_time = 10 SECONDS
	zizo_spell = TRUE

/datum/action/cooldown/spell/projectile/profane/miracle
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 15
	associated_skill = /datum/skill/magic/holy
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = 30

/datum/action/cooldown/spell/projectile/profane/fire_projectile(atom/target)
	var/obj/item/held_item = owner.get_active_held_item()
	var/big_cast = FALSE
	if(istype(held_item, /obj/item/natural/bundle/bone))
		var/obj/item/natural/bundle/bone/bonez = held_item
		if(bonez.use(1))
			projectile_type = /obj/projectile/magic/profane/major
			big_cast = TRUE
	else if(istype(held_item, /obj/item/natural/bone))
		qdel(held_item)
		projectile_type = /obj/projectile/magic/profane/major
		big_cast = TRUE

	. = ..()

	if(big_cast)
		owner.visible_message(span_danger("[owner] conjures and hurls a vicious lance of bone towards [target]!"), span_notice("I hurl a vicious lance of bone at [target]!"))
	else
		owner.visible_message(span_danger("[owner] swings their arm in a wide arc, hurling a splinter of bone towards [target]!"), span_notice("I fling a shard of profaned bone at [target]!"))

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
	if(iscarbon(target) && prob(embed_prob))
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

/datum/action/cooldown/spell/raise_undead_formation/miracle
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 75
	cabal_affine = TRUE
	to_spawn = 1

// T2: carbon spawn

/datum/action/cooldown/spell/raise_undead_guard/miracle
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	name = "Raise Deadite"
	desc = "Raises a singular, weak deadite."
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 75

// T3: tames bio_type = undead mobs

/datum/action/cooldown/spell/tame_undead/miracle
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 100

// T3: Rituos - Zizo's Lesser Work. A single painful ritual that grants the caster a choice:
// Progress: Arcyne knowledge (2 minor aspects, 4 utilities). No skeletonization.
// Unlife: Full skeletonization + MOB_UNDEAD, grants bonechill and raise_deadite directly.
// Both paths grant undead language and TRAIT_ARCYNE. One-time use - cannot be cast again after completion.

/datum/action/cooldown/spell/rituos
	name = "Rituos"
	desc = "Enact one of the Lesser Work of Zizo - a single, agonizing ritual that tears open a path to power. Choose Progress to gain arcyne knowledge, or Unlife to embrace undeath."
	background_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon = 'icons/mob/actions/zizomiracles.dmi'
	button_icon_state = "rituos"
	associated_skill = /datum/skill/magic/arcane
	associated_stat = null
	charge_required = TRUE
	charge_time = 50
	click_to_activate = FALSE
	primary_resource_cost = 90
	primary_resource_type = SPELL_COST_STAMINA
	cooldown_time = 5 MINUTES
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_NO_MOVE
	zizo_spell = TRUE

/datum/action/cooldown/spell/rituos/miracle
	primary_resource_type = SPELL_COST_DEVOTION
	primary_resource_cost = 120
	associated_skill = /datum/skill/magic/holy
	secondary_resource_type = SPELL_COST_STAMINA
	secondary_resource_cost = 90

	
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

	var/list/chant_lines
	switch(path_choice)
		if("Progress")
			chant_lines = list(
				"ZIZO! ZIZO! ZIZO! GRANT ME INSIGHT UNSHACKLED!",
				"STRIP ME OF STAGNATION AND IGNORANCE!",
				"I OFFER THIS MIND TO COMPLETE THY WORK!",
			)
		if("Unlife")
			chant_lines = list(
				"ZIZO! ZIZO! ZIZO! FLENSE FLESH FROM MY BONE!",
				"STRIP ME OF MORTALITY'S SHACKLE!",
				"I OFFER THIS VESSEL TO THY LESSER WORK!",
			)

	for(var/i in 1 to length(chant_lines))
		user.say(chant_lines[i], forced = "spell", language = /datum/language/common)
		user.adjustBruteLoss(15)
		if(path_choice == "Progress")
			user.emote(pick("whimper", "gasp"))
			user.emote("painscream")
		else
			user.emote("painscream")
		if(i > 1)
			shake_camera(user, i * 2, i)
		if(!do_after(user, 3 SECONDS, target = user))
			to_chat(user, span_warning("The ritual collapses. Zizo's gaze turns away."))
			return FALSE

	user.grant_language(/datum/language/undead)
	ADD_TRAIT(user, TRAIT_ARCYNE, "[type]")

	switch(path_choice)
		if("Progress")
			user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			if(user.mind)
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
				grant_poke_spell(user)
			user.visible_message(span_boldwarning("Arcyne runes sear themselves across [user]'s skin, glowing with a sickly light before fading beneath the flesh!"), span_notice("THE LESSER WORK IS DONE! Arcyne knowledge floods my mind - I can see the threads of magic itself!"))

		if("Unlife")
			user.mob_biotypes |= MOB_UNDEAD
			ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]")
			ADD_TRAIT(user, TRAIT_NOBREATH, "[type]")
			ADD_TRAIT(user, TRAIT_SILVER_WEAK, "[type]")
			for(var/obj/item/bodypart/part as anything in user.bodyparts)
				if(istype(part, /obj/item/bodypart/head))
					continue
				part.skeletonize(FALSE)
			var/obj/item/bodypart/torso = user.get_bodypart(BODY_ZONE_CHEST)
			torso?.skeletonize(FALSE)
			user.update_body_parts()
			user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
			if(user.mind)
				user.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4))
				user.mind.AddSpell(new /datum/action/cooldown/spell/bonechill)
				grant_poke_spell(user)
			user.visible_message(span_boldwarning("[user]'s flesh sloughs away in sheets, revealing bare bone beneath as [user.p_they()] [user.p_are()] consumed by the Lesser Work!"), span_notice("THE LESSER WORK IS DONE! My flesh is forfeit - but death itself answers my call!"))
			to_chat(user, span_small("...what have I done?"))

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

