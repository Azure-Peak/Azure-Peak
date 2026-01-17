// T1: (fires a bone splinter at a target for brute and bleeding if you're not holding bones in your other hand, fires a significantly stronger bone lance if you are)

/obj/effect/proc_holder/spell/invoked/projectile/profane
	name = "Profane"
	desc = "Fire forth a splinter of unholy bone, tearing flesh and causing bleeding. If you hold pieces of bone in your other hand, you will coax a much stronger lance of bone into being."
	clothes_req = FALSE
	overlay_state = "profane"
	range = 8
	associated_skill = /datum/skill/magic/arcane
	projectile_type = /obj/projectile/magic/profane
	chargedloop = /datum/looping_sound/invokeholy
	invocations = list("Oblino!")
	invocation_type = "whisper"
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
		user.visible_message(span_danger("[user] conjures and hurls a vicious lance of bone towards [target]!"), span_notice("I hurl forth a vicious lance of profaned bone at [target]!"))
	else
		user.visible_message(span_danger("[user] directs forth a splinter of bone towards [target]!"), span_notice("I fling forth a shard of profaned bone at [target]!"))

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
	miracle = TRUE
	devotion_cost = 75
	cabal_affine = TRUE
	to_spawn = 2

// T2: carbon spawn

/obj/effect/proc_holder/spell/invoked/raise_undead_guard/miracle
	miracle = TRUE
	devotion_cost = 75

// T3: tames bio_type = undead mobs

/obj/effect/proc_holder/spell/invoked/tame_undead/miracle
	miracle = TRUE
	devotion_cost = 100

// T3: Rituos (usable once per sleep cycle, allows you to choose any 1 arcane spell to use for the duration w/ an associated devotion cost. each time you change it, 1 of your limbs is skeletonized, if all of your limbs are skeletonized, you gain access to arcane magic. continuing to use rituos after being fully skeletonized gives you additional spellpoints). Gives you the MOB_UNDEAD flag (needed for skeletonize to work) on first use.

/obj/effect/proc_holder/spell/invoked/rituos
	name = "Rituos"
	desc = "Do a ritual for she of Z that skeletonises a part of your body and bestows upon you arcyne magycks until you next sleep. Once your whole body has become skeletonised you gain full access to the Arcyne, bolstering your knowledge of spells with each additional ritual."
	clothes_req = FALSE
	overlay_state = "rituos"
	associated_skill = /datum/skill/magic/arcane
	chargedloop = /datum/looping_sound/invokeholy
	chargedrain = 0
	chargetime = 50
	releasedrain = 90
	no_early_release = TRUE
	movement_interrupt = TRUE
	recharge_time = 2 MINUTES
	var/list/excluded_bodyparts = list(/obj/item/bodypart/head)
	var/list/to_skeletonize = list(
		/obj/item/bodypart/l_arm::name = BODY_ZONE_L_ARM, 
		/obj/item/bodypart/r_arm::name = BODY_ZONE_R_ARM,
		/obj/item/bodypart/l_leg::name = BODY_ZONE_L_LEG,
		/obj/item/bodypart/r_leg::name = BODY_ZONE_R_LEG,
		)
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/rituos/miracle
	miracle = TRUE
	devotion_cost = 120
	associated_skill = /datum/skill/magic/holy

/obj/effect/proc_holder/spell/invoked/rituos/cast(list/targets, mob/living/carbon/user)
	if(!LAZYLEN(to_skeletonize) && tgui_alert(user, "Restore skeleton bodyparts?", "FINISHED RITUOS", list("Nae", "Yae")) == "Yae")
		skeletonize_bodyparts(user)
		return TRUE

	if(user.mind?.has_rituos)
		to_chat(user, span_warning("I have not the mental fortitude to enact the Lesser Work again. I must rest first..."))
		return FALSE

	var/bodypart_choice = tgui_input_list(user, "Which bodypart will be sacrificed?", "SACRIFICE", to_skeletonize)
	
	if(!bodypart_choice)
		return FALSE

	var/list/choices = list()
	var/list/spell_choices = GLOB.learnable_spells
	for(var/i = 1, i <= spell_choices.len, i++)
		var/obj/effect/proc_holder/spell/spell_item = spell_choices[i]
		if(spell_item.spell_tier > 3)
			continue
		choices["[spell_item.name]"] = spell_item

	choices = sortList(choices)

	var/choice = input("Choose an arcyne expression of the Lesser Work") as null|anything in choices
	var/obj/effect/proc_holder/spell/item = choices[choice]

	if (!choice || !item)
		return FALSE

	if (!(user.mob_biotypes & MOB_UNDEAD))
		user.visible_message(span_warning("The pallor of the grave descends across [user]'s skin in a wave of arcyne energy..."), span_boldwarning("A deathly chill overtakes my body at my first culmination of the Lesser Work! I feel my heart slow down in my chest..."))
		user.mob_biotypes |= MOB_UNDEAD
		to_chat(user, span_smallred("I have forsaken the living. I am now closer to a deadite than a mortal... but I still yet draw breath and bleed."))
	
	var/obj/item/bodypart/part = user.get_bodypart(to_skeletonize[bodypart_choice])

	if(part)
		part.skeletonize(FALSE)
		user.update_body_parts()
		user.visible_message(span_warning("Faint runes flare beneath [user]'s skin before [user.p_their()] flesh suddenly slides away from [user.p_their()] [part.name]!"), span_notice("I feel arcyne power surge throughout my frail mortal form, as the Rituos takes its terrible price from my [part.name]."))

	if(user.mind?.rituos_spell)
		to_chat(user, span_warning("My knowledge of [user.mind.rituos_spell.name] flees..."))
		user.mind.RemoveSpell(user.mind.rituos_spell)
		user.mind.rituos_spell = null

	user.mind.has_rituos = TRUE
	to_skeletonize -= bodypart_choice

	if(!LAZYLEN(to_skeletonize))
		finalize(user)
		return TRUE
	
	to_chat(user, span_notice("The Lesser Work of Rituos floods my mind with stolen arcyne knowledge: I can now cast [item.name] until I next rest..."))
	user.mind.rituos_spell = item
	user.mind.AddSpell(new item)

	return TRUE

/obj/effect/proc_holder/spell/invoked/rituos/proc/finalize(mob/living/carbon/human/user)
	var/obj/item/bodypart/torso = user.get_bodypart(BODY_ZONE_CHEST)
	torso?.skeletonize(FALSE)
	user.update_body_parts()

	user.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE)
	user.grant_language(/datum/language/undead)
	user.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
	user.mind?.adjust_spellpoints(18)
	user.visible_message(span_boldwarning("[user]'s form swells with terrible power as they cast away almost all of the remnants of their mortal flesh, arcyne runes glowing upon their exposed bones..."), span_notice("I HAVE DONE IT! I HAVE COMPLETED HER LESSER WORK! I stand at the cusp of unspeakable power, but something is yet missing..."))

	ADD_TRAIT(user, TRAIT_NOHUNGER, "[type]")
	ADD_TRAIT(user, TRAIT_NOBREATH, "[type]")
	ADD_TRAIT(user, TRAIT_ARCYNE_T3, "[type]")

	if(prob(33))
		to_chat(user, span_small("...what have I done?"))

/obj/effect/proc_holder/spell/invoked/rituos/proc/skeletonize_bodyparts(mob/living/carbon/human/user)
	for(var/obj/item/bodypart/part as anything in user.bodyparts)
		if(is_type_in_list(part, excluded_bodyparts))
			continue

		part.skeletonize(FALSE)

	user.update_body_parts()

/obj/effect/proc_holder/spell/self/zizo_snuff
	name = "Snuff Lights"
	desc = "Extinguish all lights in range, with your Miracles skill increasing range."
	releasedrain = 10
	chargedrain = 0
	chargetime = 0
	chargedloop = /datum/looping_sound/invokeholy
	invocations = list("Embrace the darkness!")
	invocation_type = "shout"
	sound = 'sound/magic/zizo_snuff.ogg'
	overlay_state = "rune2"
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
