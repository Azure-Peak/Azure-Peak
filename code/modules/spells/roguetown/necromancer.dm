/obj/effect/proc_holder/spell/invoked/bonechill
	name = "Bone Chill"
	desc = "Chill the target with necrotic energy. Severely reduces speed and weakens physical prowess."
	cost = 3
	overlay_state = "profane"
	releasedrain = 30
	chargetime = 5
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/magic/whiteflame.ogg'
	spell_tier = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE // Potential offensive use, need a target
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	miracle = FALSE
	zizo_spell = TRUE

/obj/effect/proc_holder/spell/invoked/bonechill/cast(list/targets, mob/living/user)
	..()
	if(!isliving(targets[1]))
		return FALSE

	var/mob/living/target = targets[1]
	if(target.mob_biotypes & MOB_UNDEAD) //positive energy harms the undead
		var/obj/item/bodypart/affecting = target.get_bodypart(check_zone(user.zone_selected))
		if(affecting && (affecting.heal_damage(50, 50) || affecting.heal_wounds(50)))
			target.update_damage_overlays()
		target.visible_message(span_danger("[target] reforms under the vile energy!"), span_notice("I'm remade by dark magic!"))
		return TRUE

	target.visible_message(span_info("Necrotic energy floods over [target]!"), span_userdanger("I feel colder as the dark energy floods into me!"))
	if(iscarbon(target))
		target.apply_status_effect(/datum/status_effect/debuff/chilled)
	else
		target.adjustBruteLoss(20)

	return TRUE

/obj/effect/proc_holder/spell/invoked/eyebite
	name = "Eyebite"
	overlay_state = "raiseskele"
	releasedrain = 30
	chargetime = 15
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	sound = 'sound/items/beartrap.ogg'
	associated_skill = /datum/skill/magic/arcane
	gesture_required = TRUE // Offensive spell
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	miracle = FALSE
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/eyebite/cast(list/targets, mob/living/user)
	..()
	if(!isliving(targets[1]))
		return FALSE
	var/mob/living/carbon/target = targets[1]
	target.visible_message(span_info("A loud crunching sound has come from [target]!"), span_userdanger("I feel arcane teeth biting into my eyes!"))
	target.adjustBruteLoss(30)
	target.blind_eyes(2)
	target.blur_eyes(10)
	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_formation
	name = "Raise Formation"
	desc = "Raises a formation of undead skeleton. Inferior shamblers. Husks in everything but zeal."
	clothes_req = FALSE
	overlay_state = "animate"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 6 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = TRUE // Summon spell
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 20 SECONDS
	var/cabal_affine = FALSE
	var/is_summoned = FALSE
	var/to_spawn = 4
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/cast(list/targets, mob/living/user)
	..()

	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	var/skeleton_roll

	var/list/turf/target_turfs = list(T)
	if(usr.dir == NORTH || usr.dir == SOUTH)
		target_turfs += get_step(T, EAST)
		target_turfs += get_step(T, WEST)
	else
		target_turfs += get_step(T, NORTH)
		target_turfs += get_step(T, SOUTH)

	for(var/i = 1 to to_spawn)
		if(i > to_spawn)
			i = 1

		var/t_turf = target_turfs[i]

		if(!isopenturf(t_turf))
			continue

		new /obj/effect/temp_visual/bluespace_fissure(t_turf)
		skeleton_roll = rand(1,100)
		switch(skeleton_roll)
			if(1 to 20)
				new /mob/living/simple_animal/hostile/rogue/skeleton/axe(t_turf, user, cabal_affine)
			if(21 to 40)
				new /mob/living/simple_animal/hostile/rogue/skeleton/spear(t_turf, user, cabal_affine)
			if(41 to 60)
				new /mob/living/simple_animal/hostile/rogue/skeleton/guard(t_turf, user, cabal_affine)
			if(61 to 80)
				new /mob/living/simple_animal/hostile/rogue/skeleton/bow(t_turf, user, cabal_affine)
			if(81 to 100)
				new /mob/living/simple_animal/hostile/rogue/skeleton(t_turf, user, cabal_affine)
	return TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_formation/necromancer
	cabal_affine = TRUE
	is_summoned = TRUE
	recharge_time = 35 SECONDS
	to_spawn = 3


/obj/effect/proc_holder/spell/invoked/raise_undead_guard
	name = "Conjure Undead"
	desc = "Raises an undead guard in your servitude."
	clothes_req = FALSE
	overlay_state = "animate"
	range = 7
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 3 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	gesture_required = TRUE // Summon spell
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 30 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/raise_undead_guard/cast(list/targets, mob/living/user)
	..()

	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		return FALSE

	new /obj/effect/temp_visual/gib_animation(T, "gibbed-h")
	var/mob/living/skeleton_new = new /mob/living/carbon/human/species/skeleton/npc/bogguard(T, user)
	spawn(11) //Ashamed of this but I hate how after_creation() uses spawn too and I'm not making a timer for this. Proc needs a look-over. - Ryan
		skeleton_new.faction |= list("cabal", "[user.mind.current.real_name]_faction")
	return TRUE


/obj/effect/proc_holder/spell/invoked/tame_undead
	name = "Tame Undead"
	desc = "Oftentymes, husks and shamblers walk aimlessly - uncertain of their future. They need not look further, any longer. \
	Requires the target to be within four tiles. Works on undead animals, too."
	overlay_state = "raiseskele"
	range = 4
	warnie = "sydwarning"
	recharge_time = 60 SECONDS
	releasedrain = 40
	chargetime = 5 SECONDS
	charging_slowdown = 1
	gesture_required = TRUE
	chargedloop = /datum/looping_sound/invokegen
	no_early_release = TRUE

/obj/effect/proc_holder/spell/invoked/tame_undead/cast(list/targets, mob/living/user)
	..()

	if(!isliving(targets[1]))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]

	if(!(target.mob_biotypes & MOB_UNDEAD))
		to_chat(user, span_warning("[target]'s soul is not Hers, yet. I cannot do anything."))
		revert_cast()
		return FALSE
	
	if(target.mind)
		to_chat(user, span_warning("[target]'s mind resists your goadings. It will not do."))
		revert_cast()
		return FALSE

	target.faction |= list("cabal", "[user.mind.current.real_name]_faction")
	target.visible_message(span_notice("[target] turns its head to pay heed to [user]!"))
	if(!target.ai_controller)
		target.ai_controller = /datum/ai_controller/undead
		target.InitializeAIController()
		if(issimple(target))
			var/mob/living/simple_animal/simple_target = target
			simple_target.tamed()

	return TRUE


/obj/effect/proc_holder/spell/invoked/projectile/sickness
	name = "Ray of Sickness"
	desc = ""
	clothes_req = FALSE
	range = 15
	projectile_type = /obj/projectile/magic/sickness
	overlay_state = "raiseskele"
	sound = list('sound/misc/portal_enter.ogg')
	active = FALSE
	releasedrain = 30
	chargetime = 1 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	recharge_time = 15 SECONDS

/obj/effect/proc_holder/spell/invoked/gravemark
	name = "Gravemark"
	desc = "Adds or removes a target from the list of allies exempt from your undead's aggression."
	overlay_state = "raiseskele"
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/gravemark/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/faction_tag = "[user.mind.current.real_name]_faction"
		if (target == user)
			to_chat(user, span_warning("It would be unwise to make an enemy of your own skeletons."))
			return FALSE
		if(target.mind && target.mind.current)
			if (faction_tag in target.mind?.current.faction)
				target.mind?.current.faction -= faction_tag
				user.say("Hostis declaratus es.")
			else
				target.mind?.current.faction += faction_tag
				user.say("Amicus declaratus es.")
		else if(istype(target, /mob/living/simple_animal))
			if (faction_tag in target.faction)
				target.faction -= faction_tag
				user.say("Hostis declaratus es.")
			else
				target.faction |= faction_tag
				user.say("Amicus declaratus es.")
		return TRUE
	return FALSE
