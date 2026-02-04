/datum/coven/necromantic
	name = "Necromantic"
	desc = "Speak with the dead, summon undead spirits, and manipulate life force itself."
	icon_state = "daimonion"
	clan_restricted = FALSE
	power_type = /datum/coven_power/necromantic
	has_action = FALSE
	starting_level = 4
	max_level = 4

/datum/coven_power/necromantic
	name = "Necromantic power name"
	desc = "Necromantic power description"

// Speak with Dead
/datum/coven_power/necromantic/speak_with_dead
	name = "Speak with the Dead"
	desc = "Allows you to communicate with the spirits of the dead."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING

/datum/coven_power/necromantic/speak_with_dead/post_gain()
	. = ..()
	owner.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/speak_with_dead)

/obj/effect/proc_holder/spell/invoked/speak_with_dead
	name = "Speak with the Dead"
	range = 1
	associated_skill = /datum/skill/magic/blood
	devotion_cost = 0
	chargedrain = 1
	chargetime = 15
	releasedrain = 80
	recharge_time = 2 MINUTES
	miracle = FALSE
	sound = 'sound/magic/necra_sight.ogg'

/obj/effect/proc_holder/spell/invoked/speak_with_dead/cast(list/targets, mob/living/user)
	if(ismob(targets[1]))
		var/mob/target = targets[1]
		if(target.stat != DEAD)
			to_chat(user, span_warning("Your target is not dead."))
			revert_cast()
			return FALSE

		var/input_message = tgui_input_text(user, "What do you wish to ask of the dead?", "Speak with the Dead")
		if(!input_message)
			revert_cast()
			return FALSE

		var/mob/player_mob = target
		if(!target.client)
			// last ditch effort, try to find their ghost mob
			var/mob/ghost_mob = target.get_ghost(TRUE, TRUE)
			if(ghost_mob.client)
				player_mob = ghost_mob

		if(!player_mob.client)
			to_chat(user, span_warning("Necra's grasp on this one is too strong, not even your blood magic can reach them."))
			revert_cast()
			return FALSE

		var/dead_message = tgui_input_text(player_mob, "The vampyre [user.real_name] asks of you: [input_message]. You are not compelled in any way. What is your response?", "Speak with the Dead", timeout = 2 MINUTES)
		if(!dead_message)
			to_chat(user, span_notice("The dead remain silent."))
			revert_cast()
			return FALSE

		var/audible_message = "The raspy voice of [target] echoes, \"<i>[capitalize(dead_message)]</i>\"."
		user.audible_message(audible_message, runechat_message = dead_message, custom_spans = list("mindlink", "italic"))
		return TRUE

	revert_cast()
	return FALSE

// Raise Spirits
/datum/coven_power/necromantic/raise_spirits
	name = "Raise Spirits"
	desc = "Summon the spirits of the dead to serve you."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING

/datum/coven_power/necromantic/raise_spirits/post_gain()
	. = ..()
	owner.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_spirits)

/obj/effect/proc_holder/spell/invoked/raise_spirits
	name = "Raise Spirits"
	desc = "Summon the spirits of the dead to serve you."
	range = 7
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 30
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokeascendant
	gesture_required = TRUE
	associated_skill = /datum/skill/magic/blood
	recharge_time = 90 SECONDS
	hide_charge_effect = TRUE
	miracle = FALSE
	devotion_cost = 50
	overlay_icon = 'icons/mob/actions/necramiracles.dmi'
	overlay_state = "vengeful_spirit"
	action_icon_state = "vengeful_spirit"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	invocations = list("Awaken, my spirits!")
	invocation_type = "shout"

/obj/effect/proc_holder/spell/invoked/raise_spirits/cast(list/targets, mob/living/user)
	. = ..()

	if(!isliving(targets[1]))
		to_chat(user, span_warning("You must target a living creature to direct your spirits towards."))
		revert_cast()
		return FALSE

	var/mob/living/target = targets[1]
	var/list/haunts = list()
	if(user.dir == SOUTH || user.dir == NORTH)
		haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_turf(user), user)
		if(prob(50))
			haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_step(user, EAST), user)
		else
			haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_step(user, WEST), user)
	else
		haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_turf(user), user)
		if(prob(50))
			haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_step(user, NORTH), user)
		else
			haunts += new /mob/living/simple_animal/hostile/rogue/haunt/omen(get_step(user, SOUTH), user)
	for(var/mob/living/simple_animal/hostile/rogue/haunt/omen/swarm in haunts)
		swarm.ai_controller.set_blackboard_key(BB_BASIC_MOB_CURRENT_TARGET, target)
	return TRUE

// Raise Unholy Undead
/datum/coven_power/necromantic/raise_unholy_undead
	name = "Raise Unholy Undead"
	desc = "Raise an unholy, undead, thinking creature to serve you."

	level = 3
	research_cost = 2
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING

/datum/coven_power/necromantic/raise_unholy_undead/post_gain()
	. = ..()
	owner.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/raise_unholy_undead)

/obj/effect/proc_holder/spell/invoked/raise_unholy_undead
	name = "Raise Unholy Undead"
	desc = "Raise a single revenant that serves you. They are imbued with a fragment of a soul and is more intelligent than usual, simple-minded lesser undead."
	clothes_req = FALSE
	range = 7
	overlay_state = "animate"
	sound = list('sound/magic/magnet.ogg')
	releasedrain = 40
	chargetime = 60
	warnie = "spellwarning"
	no_early_release = TRUE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokeascendant
	gesture_required = TRUE // Summon spell
	associated_skill = /datum/skill/magic/blood
	recharge_time = 60 SECONDS

/obj/effect/proc_holder/spell/invoked/raise_unholy_undead/cast(list/targets, mob/living/user)
	..()

	var/turf/T = get_turf(targets[1])
	if(!isopenturf(T))
		to_chat(user, span_warning("The targeted location is blocked. My summon fails to come forth."))
		revert_cast()
		return FALSE

	var/list/candidates = pollGhostCandidates("Do you want to play as a Vampyre's chosen undead?", ROLE_VAMPIRE_UNDEAD, null, null, 10 SECONDS, POLL_IGNORE_VAMPIRE_UNDEAD)
	if(!LAZYLEN(candidates))
		to_chat(user, span_warning("The depths are hollow."))
		return TRUE

	var/mob/C = pick(candidates)
	if(!C || !istype(C, /mob/dead))
		revert_cast()
		return FALSE

	if (istype(C, /mob/dead/new_player))
		var/mob/dead/new_player/N = C
		N.close_spawn_windows()

	var/mob/living/carbon/human/species/dullahan/target = new /mob/living/carbon/human/species/dullahan(T)
	target.key = C.key
	SSjob.EquipRank(target, "Fortified Skeleton", TRUE)
	target.copy_known_languages_from(user, TRUE)
	target.visible_message(span_warning("[target]'s eyes light up with an eerie glow!"))
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "UNHOLY UNDEAD"), 3 SECONDS)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/mob/living/carbon/human, choose_pronouns_and_body)), 7 SECONDS)
	return TRUE

// Harvest Lux
/datum/coven_power/necromantic/harvest_lux
	name = "Harvest Lux"
	desc = "Reach out and siphon the lux from any non-undead surrounding you."

	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_IMMOBILE | COVEN_CHECK_LYING

/datum/coven_power/necromantic/harvest_lux/post_gain()
	. = ..()
	owner.mind.AddSpell(new /obj/effect/proc_holder/spell/aoe_turf/harvest_lux)

/obj/effect/proc_holder/spell/aoe_turf/harvest_lux
	name = "Harvest Lux"
	desc = "Reach out and siphon the lux from any non-undead surrounding you."
	base_icon_state = ""
	action_icon_state = "knock"
	overlay_state = "knock"
	school = "transmutation"
	recharge_time = 100
	clothes_req = FALSE
	invocations = list("Gaan'Lah'Haas!")
	invocation_type = "shout"
	range = 3
	cooldown_min = 300 //20 deciseconds reduction per rank

/obj/effect/proc_holder/spell/aoe_turf/harvest_lux/cast(list/targets,mob/living/user = usr)
	var/targets_hit = 0
	for(var/turf/T in targets)
		for(var/mob/living/carbon/human/human in T.contents)
			if(("undead" in human.faction) || human.has_status_effect(/datum/status_effect/debuff/devitalised) || human.has_status_effect(/datum/status_effect/debuff/devitalised/lesser))
				continue
			human.apply_status_effect(/datum/status_effect/debuff/devitalised/lesser)
			to_chat(human, span_artery("Your breath catches in your throat. Cold, unseen fingers burrow into your chest, clawing at your very life force!"))
			targets_hit++
	if(targets_hit == 0)
		to_chat(user, span_warning("You don't manage to extract lux from anyone..."))
		return TRUE
	var/vitae_regained = targets_hit * 50
	to_chat(user, span_notice("You siphon lux from [targets_hit] targets around you, regenerating [vitae_regained] vitae."))
	user.apply_status_effect(/datum/status_effect/buff/vitae)
	user.adjust_bloodpool(vitae_regained)
	return TRUE
