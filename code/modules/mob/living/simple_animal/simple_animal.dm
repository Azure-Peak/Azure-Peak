#define MAX_FARM_ANIMALS 20

GLOBAL_VAR_INIT(farm_animals, FALSE)

/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20
	gender = PLURAL //placeholder

	status_flags = CANPUSH
	fire_stack_decay_rate = -3
	var/icon_living = ""
	///Icon when the animal is dead. Don't use animated icons for this.
	var/icon_dead = ""
	///We only try to show a gibbing animation if this exists.
	var/icon_gib = null
	///Flip the sprite upside down on death. Mostly here for things lacking custom dead sprites.
	var/flip_on_death = FALSE

	var/list/speak = list()
	///Emotes while speaking IE: Ian [emote], [text] -- Ian barks, "WOOF!". Spoken text is generated from the speak variable.
	var/list/speak_emote = list()
	var/speak_chance = 0
	///Hearable emotes
	var/list/emote_hear = list()
	///Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps
	var/list/emote_see = list()

	var/move_skip = FALSE
	var/action_skip = FALSE

	var/turns_per_move = 1
	var/turns_since_move = 0
	///Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/stop_automated_movement = 0
	///Does the mob wander around when idle?
	var/wander = 1
	///When set to 1 this stops the animal from moving when someone is pulling it.
	var/stop_automated_movement_when_pulled = 1

	var/obj/item/handcuffed = null //Whether or not the mob is handcuffed
	var/obj/item/legcuffed = null  //Same as handcuffs but for legs. Bear traps use this.

	///When someone interacts with the simple animal.
	///Help-intent verb in present continuous tense.
	var/response_help_continuous = "pokes"
	///Help-intent verb in present simple tense.
	var/response_help_simple = "poke"
	///Disarm-intent verb in present continuous tense.
	var/response_disarm_continuous = "shoves"
	///Disarm-intent verb in present simple tense.
	var/response_disarm_simple = "shove"
	///Harm-intent verb in present continuous tense.
	var/response_harm_continuous = "hits"
	///Harm-intent verb in present simple tense.
	var/response_harm_simple = "hit"
	var/harm_intent_damage = 3
	///Minimum force required to deal any damage.
	var/force_threshold = 0
	///Temperature effect.
	var/minbodytemp = 250
	var/maxbodytemp = 350

	///Healable by medical stacks? Defaults to yes.
	var/healable = 1

	///Atmos effect - Yes, you can make creatures that require plasma or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	///Leaving something at 0 means it's off - has no maximum.
	var/list/atmos_requirements = list("min_oxy" = 5, "max_oxy" = 0, "min_tox" = 0, "max_tox" = 1, "min_co2" = 0, "max_co2" = 5, "min_n2" = 0, "max_n2" = 0)
	///This damage is taken when atmos doesn't fit all the requirements above.
	var/unsuitable_atmos_damage = 2

	///LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly.
	var/melee_damage_lower = 0
	var/melee_damage_upper = 0
	///how much damage this simple animal does to objects, if any.
	var/obj_damage = 0
	///How much armour they ignore, as a flat reduction from the targets armour value.
	var/armor_penetration = 0
	///Damage type of a simple mob's melee attack, should it do damage.
	var/melee_damage_type = BRUTE
	///Type of melee attack
	var/d_type = "slash"
	/// 1 for full damage , 0 for none , -1 for 1:1 heal from that source.
	var/list/damage_coeff = list(BRUTE = 1, BURN = 1, TOX = 1, CLONE = 1, STAMINA = 0, OXY = 1)
	///Attacking verb in present continuous tense.
	var/attack_verb_continuous = "attacks"
	///Attacking verb in present simple tense.
	var/attack_verb_simple = "attack"
	var/attack_sound = PUNCHWOOSH
	///Attacking, but without damage, verb in present continuous tense.
	var/friendly_verb_continuous = "nuzzles"
	///Attacking, but without damage, verb in present simple tense.
	var/friendly_verb_simple = "nuzzle"
	///Set to 1 to allow breaking of crates,lockers,racks,tables; 2 for walls; 3 for Rwalls.
	var/environment_smash = ENVIRONMENT_SMASH_NONE

	///LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster.
	var/speed = 1

	///Hot simple_animal baby making vars.
	var/list/childtype = null
	var/next_scan_time = 0
	///Sorry, no spider+corgi buttbabies.
	var/animal_species
	var/adult_growth
	var/growth_prog = 0
	var/breedcd = 5 MINUTES
	var/breedchildren = 3

	///Simple_animal access.
	var/list/lock_hashes
	///Innate access uses an internal ID card.
	var/obj/item/card/id/access_card = null
	///In the event that you want to have a buffing effect on the mob, but don't want it to stack with other effects, any outside force that applies a buff to a simple mob should at least set this to 1, so we have something to check against.
	var/buffed = 0
	///If the mob can be spawned with a gold slime core. HOSTILE_SPAWN are spawned with plasma, FRIENDLY_SPAWN are spawned with blood.
	var/gold_core_spawnable = NO_SPAWN

	var/datum/component/spawner/nest

	///Sentience type, for slime potions.
	var/sentience_type = SENTIENCE_ORGANIC

	///List of things spawned at mob's loc when it dies.
	var/list/loot = list()
	///Causes mob to be deleted on death, useful for mobs that spawn lootable corpses.
	var/del_on_death = 0
	var/deathmessage = ""

	var/allow_movement_on_non_turfs = FALSE

	///Played when someone punches the creature.
	var/attacked_sound = "punch"

	///If the creature has, and can use, hands.
	var/dextrous = FALSE
	var/dextrous_hud_type = /datum/hud/dextrous

	///The Status of our AI, can be set to AI_ON (On, usual processing), AI_IDLE (Will not process, but will return to AI_ON if an enemy comes near), NPC_AI_OFF (Off, Not processing ever), AI_Z_OFF (Temporarily off due to nonpresence of players).
	var/AIStatus = AI_ON
	///once we have become sentient, we can never go back.
	var/can_have_ai = TRUE

	///Domestication.
	var/tame = FALSE
	///What the mob eats, typically used for taming or animal husbandry.
	var/list/food_type
	///Starting success chance for taming.
	var/tame_chance
	///Added success chance after every failed tame attempt.
	var/bonus_tame_chance

	var/mob/owner = null

	///I don't want to confuse this with client registered_z.
	var/my_z
	///What kind of footstep this mob should have. Null if it shouldn't have any.
	var/footstep_type

	var/food = 0	//increase to make poop
	var/production = 0
	var/pooptype = /obj/item/natural/poo/horse
	var/pooprog = 0

	var/swinging = FALSE

	var/familiar_headshot_link = null
	var/familiar_ooc_notes = null
	var/familiar_flavortext = null

	buckle_lying = FALSE
	cmode = 1

	var/remains_type
	var/binded = FALSE // Whether it is bound to a summoning circle or not

	var/botched_butcher_results
	var/perfect_butcher_results
	var/list/inherent_spells = list()

	///What distance should we be checking for interesting things when considering idling/deidling? Defaults to AI_DEFAULT_INTERESTING_DIST
	var/interesting_dist = AI_DEFAULT_INTERESTING_DIST
	///our current cell grid
	var/datum/cell_tracker/our_cells

	var/obj/item/caparison/ccaparison

/mob/living/simple_animal/Initialize()
	. = ..()
	GLOB.simple_animals[AIStatus] += src
	if(gender == PLURAL)
		gender = pick(MALE,FEMALE)
	if(!real_name)
		real_name = name
	if(!loc)
		stack_trace("Simple animal being instantiated in nullspace")
	update_simplemob_varspeed()
	our_cells = new(interesting_dist, interesting_dist, 1)
	set_new_cells()
//	if(dextrous)
//		AddComponent(/datum/component/personal_crafting)
	for(var/spell in inherent_spells)
		var/obj/effect/proc_holder/spell/newspell = new spell()
		AddSpell(newspell)

/mob/living/simple_animal/Destroy()
	our_cells = null
	GLOB.simple_animals[AIStatus] -= src
	SSnpcpool.currentrun -= src

	if(nest)
		nest.spawned_mobs -= src
		nest = null

	if(ssaddle)
		QDEL_NULL(ssaddle)
		ssaddle = null

	if(ccaparison)
		QDEL_NULL(ccaparison)
		ccaparison = null

	var/turf/T = get_turf(src)
	if (T && AIStatus == AI_Z_OFF)
		SSidlenpcpool.idle_mobs_by_zlevel[T.z] -= src

	return ..()

/mob/living/simple_animal/examine(mob/user)
	. = ..()
	if(tame)
		. += span_notice("This animal appears to be tamed.")
	if(ssaddle)
		. += span_notice("This animal is saddled: ([ssaddle.name]).")
	if(ccaparison)
		. += span_notice("This animal is wearing a caparison: ([ccaparison.name]).")

/mob/living/simple_animal/attackby(obj/item/O, mob/user, params)
	if(!is_type_in_list(O, food_type))
		..()
		return
	else
		if(!stat)
			user.visible_message(span_info("[user] hand-feeds [O] to [src]."), span_notice("I hand-feed [O] to [src]."))
			playsound(loc,'sound/misc/eat.ogg', rand(30,60), TRUE)
			qdel(O)
			food = min(food + 30, 100)
			adjustHealth(-rand(10,20))
			if(tame && owner == user)
				return
			var/realchance = tame_chance
			if(realchance)
				if(prob(realchance))
					tamed(user)
				else
					tame_chance += bonus_tame_chance

/mob/living/simple_animal/attack_right(mob/user, params)
	if(ccaparison)
		user.visible_message(span_notice("[user] is removing the caparison from [src]..."), span_notice("I start removing the caparison from [src]..."))
		if(!do_after(user, 10 SECONDS, TRUE, src))
			return
		playsound(loc, 'sound/foley/saddledismount.ogg', 100, FALSE)
		user.visible_message(span_notice("[user] removes the caparison from [src]."), span_notice("I remove the caparison from [src]."))
		var/obj/item/caparison/C = ccaparison
		ccaparison = null
		C.forceMove(get_turf(src))
		user.put_in_hands(C)
		update_icon()
		return
	else if(ssaddle)
		user.visible_message(span_notice("[user] is removing the saddle from [src]..."), span_notice("I start removing the saddle from [src]..."))
		if(!do_after(user, 5 SECONDS, TRUE, src))
			return
		playsound(loc, 'sound/foley/saddledismount.ogg', 100, FALSE)
		user.visible_message(span_notice("[user] removes the saddle from [src]."), span_notice("I remove the saddle from [src]."))
		var/obj/item/natural/saddle/S = ssaddle
		ssaddle = null
		S.forceMove(get_turf(src))
		user.put_in_hands(S)
		update_icon()
		return
	return ..()

/mob/living/simple_animal/update_icon()
	cut_overlays()
	. = ..()
	if(ccaparison && stat == CONSCIOUS && !resting)
		var/caparison_overlay = ccaparison.female_caparison_state && gender == FEMALE ? ccaparison.female_caparison_state : ccaparison.caparison_state
		var/mutable_appearance/caparison_above_overlay = mutable_appearance(icon, caparison_overlay + "-above", 4.31)
		add_overlay(caparison_overlay)
		add_overlay(caparison_above_overlay)

///Extra effects to add when the mob is tamed, such as adding a riding component
/mob/living/simple_animal/proc/tamed(mob/user)
	INVOKE_ASYNC(src, PROC_REF(emote), "lower_head", null, null, null, TRUE)
	tame = TRUE
	stop_automated_movement_when_pulled = TRUE
	if(user)
		owner = user
		SEND_SIGNAL(user, COMSIG_ANIMAL_TAMED, src)

//mob/living/simple_animal/examine(mob/user)
//	. = ..()
//	if(stat == DEAD)
//		. += span_deadsay("Upon closer examination, [p_they()] appear[p_s()] to be dead.")

/mob/living/simple_animal/updatehealth()
	..()
	update_damage_overlays()

/mob/living/simple_animal/hostile
	var/retreating

/mob/living/simple_animal/hostile/updatehealth()
	..()
	if(!retreating)
		if(target)
			if(retreat_health)
				if(health <= round(maxHealth*retreat_health))
					emote("retreat")
					retreat_distance = 20
					minimum_distance = 20
					retreating = world.time
	if(!retreating || (world.time > retreating + 10 SECONDS))
		retreating = null
		retreat_distance = initial(retreat_distance)
		minimum_distance = initial(minimum_distance)
	if(HAS_TRAIT(src, TRAIT_RIGIDMOVEMENT))
		return
	if(HAS_TRAIT(src, TRAIT_IGNOREDAMAGESLOWDOWN))
		move_to_delay = initial(move_to_delay)
		return
	var/health_deficiency = getBruteLoss() + getFireLoss()
	if(health_deficiency >= ( maxHealth - (maxHealth*0.50) ))
		move_to_delay = initial(move_to_delay) + 2
	else
		move_to_delay = initial(move_to_delay)

/mob/living/simple_animal/hostile/forceMove(turf/T)
	var/list/BM = list()
	for(var/m in buckled_mobs)
		BM += m
	. = ..()
	for(var/mob/x in BM)
		x.forceMove(get_turf(src))
		buckle_mob(x, TRUE)

/mob/living/simple_animal/update_stat()
	if(status_flags & GODMODE)
		return
	if(stat != DEAD)
		if(health <= 0)
			death()
			SEND_SIGNAL(src, COMSIG_MOB_STATCHANGE, DEAD)
			return
	if(footstep_type)
		if(!QDELING(src))
			AddComponent(/datum/component/footstep, footstep_type)

/mob/living/simple_animal/handle_status_effects()
	..()
	if(stuttering)
		stuttering = 0

/mob/living/simple_animal/proc/handle_automated_action()
	set waitfor = FALSE
	return

/mob/living/simple_animal/proc/handle_automated_movement()
	set waitfor = FALSE
	if(!stop_automated_movement && wander && !doing)
		if(ssaddle && has_buckled_mobs())
			return 0
		if(binded)
			return FALSE
		if((isturf(loc) || allow_movement_on_non_turfs) && (mobility_flags & MOBILITY_MOVE))		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			return 1

/mob/living/simple_animal/proc/handle_automated_speech(override)
	set waitfor = FALSE
	if(speak_chance)
		if(prob(speak_chance) || override)
			if(speak && speak.len)
				if((emote_hear && emote_hear.len) || (emote_see && emote_see.len))
					var/length = speak.len
					if(emote_hear && emote_hear.len)
						length += emote_hear.len
					if(emote_see && emote_see.len)
						length += emote_see.len
					var/randomValue = rand(1,length)
					if(randomValue <= speak.len)
						say(pick(speak), forced = "poly")
					else
						randomValue -= speak.len
						if(emote_see && randomValue <= emote_see.len)
							emote("me [pick(emote_see)]", 1)
						else
							emote("me [pick(emote_hear)]", 2)
				else
					say(pick(speak), forced = "poly")
			else
				if(!(emote_hear && emote_hear.len) && (emote_see && emote_see.len))
					emote("me", 1, pick(emote_see))
				if((emote_hear && emote_hear.len) && !(emote_see && emote_see.len))
					emote("me", 2, pick(emote_hear))
				if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
					var/length = emote_hear.len + emote_see.len
					var/pick = rand(1,length)
					if(pick <= emote_see.len)
						emote("me", 1, pick(emote_see))
					else
						emote("me", 2, pick(emote_hear))


/mob/living/simple_animal/proc/environment_is_safe(check_temp = FALSE)
	. = TRUE

	if(pulledby && pulledby.grab_state >= GRAB_KILL && atmos_requirements["min_oxy"])
		. = FALSE //getting choked

	if(check_temp)
		//ATMO/TURF/TEMPERATURE
		var/turf/cur_turf = get_turf(src)
		var/areatemp = cur_turf.temperature
		if((areatemp < minbodytemp) || (areatemp > maxbodytemp))
			. = FALSE


/mob/living/simple_animal/handle_environment()
	var/atom/A = src.loc
	if(isturf(A))
		//ATMO/TURF/TEMPERATURE
		var/turf/cur_turf = A
		var/areatemp = cur_turf.temperature
		if( abs(areatemp - bodytemperature) > 5)
			var/diff = areatemp - bodytemperature
			diff = diff / 5
			adjust_bodytemperature(diff)

	handle_temperature_damage()

/mob/living/simple_animal/proc/handle_temperature_damage()
	if((bodytemperature < minbodytemp) || (bodytemperature > maxbodytemp))
		adjustHealth(unsuitable_atmos_damage)

/mob/living/simple_animal/MiddleClick(mob/living/user, params)
	if(stat == DEAD)
		var/obj/item/held_item = user.get_active_held_item()
		if(held_item)
			if((butcher_results || guaranteed_butcher_results) && ((held_item.get_sharpness() && held_item.wlength == WLENGTH_SHORT) || istype(held_item, /obj/item/contraption/shears)))
				var/used_time = 3 SECONDS
				var/on_meathook = FALSE
				if((src.buckled && istype(src.buckled, /obj/structure/meathook))|| istype(held_item, /obj/item/contraption/shears))
					on_meathook = TRUE //will work efficiently if they are using autosheers as well
					used_time -= 3 SECONDS
					visible_message("[user] begins to efficiently butcher [src]...")
				else
					visible_message("[user] begins to butcher [src]...")
				if(user.mind)
					used_time -= (user.get_skill_level(/datum/skill/labor/butchering) * 30)
				playsound(src, 'sound/foley/gross.ogg', 100, FALSE)
				if(used_time <= 0 || do_after(user, used_time, target = src))
					butcher(user, on_meathook)

	else if (stat != DEAD && istype(ssaddle, /obj/item/natural/saddle))		//Fallback saftey for saddles
		var/datum/component/storage/saddle_storage = ssaddle.GetComponent(/datum/component/storage)
		var/access_time = (user in buckled_mobs) ? 10 : 30
		if (do_after(user, access_time, target = src))
			saddle_storage.show_to(user)
	..()

/mob/living/simple_animal/proc/butcher(mob/living/user, on_meathook = FALSE)
	if(ssaddle)
		ssaddle.forceMove(get_turf(src))
		ssaddle = null

	var/butchery_skill_level = user.get_skill_level(/datum/skill/labor/butchering)
	var/time_per_cut = max(5, 30 - butchery_skill_level * 5) // 3 seconds for no skill, 5 ticks for master
	if(on_meathook)
		time_per_cut *= 0.75
	var/botch_chance = 0
	if(length(botched_butcher_results) && butchery_skill_level < SKILL_LEVEL_JOURNEYMAN)
		botch_chance = 70 - (20 * butchery_skill_level) // 70% at unskilled, 20% lower for each level above it, 0% at journeyman or higher

	var/perfect_chance = 0
	if(length(perfect_butcher_results))
		switch(butchery_skill_level)
			if(SKILL_LEVEL_NONE to SKILL_LEVEL_APPRENTICE)
				perfect_chance = 0
			if(SKILL_LEVEL_JOURNEYMAN)
				perfect_chance = 10
			if(SKILL_LEVEL_EXPERT)
				perfect_chance = 50
			if(SKILL_LEVEL_MASTER to INFINITY)
				perfect_chance = 100

	var/rotstuff = FALSE
	var/datum/component/rot/simple/CR = GetComponent(/datum/component/rot/simple)
	if(CR && CR.amount >= 10 MINUTES)
		rotstuff = TRUE
	var/atom/Tsec = drop_location()

	// Track results
	var/botch_count = 0
	var/perfect_count = 0
	var/normal_count = 0

	for(var/path in butcher_results)
		var/amount = butcher_results[path]
		if(!do_after(user, time_per_cut, target = src))
			if(botch_count || normal_count || perfect_count)
				to_chat(user, "<span class='notice'>I stop butchering: [butcher_summary(botch_count, normal_count, perfect_count, botch_chance, perfect_chance)].</span>")
			else
				to_chat(user, "<span class='notice'>I stop butchering for now.</span>")
			break

		// Check for botch first
		if(prob(botch_chance))
			botch_count++
			if(length(botched_butcher_results) && (path in botched_butcher_results))
				amount = botched_butcher_results[path]
			else
				amount = 0

		// Otherwise check for perfect
		else if(length(perfect_butcher_results) && (path in perfect_butcher_results) && prob(perfect_chance))
			amount = perfect_butcher_results[path]
			perfect_count++

		else
			normal_count++

		butcher_results -= path

		// Spawn the item(s)
		for(var/j in 1 to amount)
			var/obj/item/I = new path(Tsec)
			I.add_mob_blood(src)
			if(istype(I,/obj/item/reagent_containers/food/snacks))
				I.item_flags |= FRESH_FOOD_ITEM
				if(rotstuff)
					var/obj/item/reagent_containers/food/snacks/F = I
					F.become_rotten()

		if(user.mind)
			user.mind.add_sleep_experience(/datum/skill/labor/butchering, user.STAINT * 0.5)
		playsound(src, 'sound/foley/gross.ogg', 100, FALSE)
	if(isemptylist(butcher_results))
		to_chat(user, "<span class='notice'>I finish butchering: [butcher_summary(botch_count, normal_count, perfect_count, botch_chance, perfect_chance)].</span>")
		gib()

/mob/living/proc/butcher_summary(botch_count, normal_count, perfect_count, botch_chance, perfect_chance)
    var/list/parts = list()
    if(botch_count)
        parts += "[botch_count] botched ([botch_chance]%)"
    if(normal_count)
        parts += "[normal_count] normal"
    if(perfect_count)
        parts += "[perfect_count] perfect ([perfect_chance]%)"

    var/msg = ""
    for(var/i = 1, i <= length(parts), i++)
        msg += parts[i]
        if(i < length(parts))
            msg += ", "

    return msg

/mob/living/simple_animal/spawn_dust(just_ash = FALSE)
	if(just_ash || !remains_type)
		for(var/i in 1 to 5)
			new /obj/item/ash(loc)
	else
		new remains_type(loc)

/mob/living/simple_animal/gib_animation()
	if(icon_gib)
		new /obj/effect/temp_visual/gib_animation/animal(loc, icon_gib)

/mob/living/simple_animal/say_mod(input, message_mode)
	if(speak_emote && speak_emote.len)
		verb_say = pick(speak_emote)
	. = ..()

/mob/living/simple_animal/proc/set_varspeed(var_value)
	speed = var_value
	update_simplemob_varspeed()

/mob/living/simple_animal/proc/update_simplemob_varspeed()
	if(speed == 0)
		remove_movespeed_modifier(MOVESPEED_ID_SIMPLEMOB_VARSPEED, TRUE)
	add_movespeed_modifier(MOVESPEED_ID_SIMPLEMOB_VARSPEED, TRUE, 100, multiplicative_slowdown = speed, override = TRUE)

/mob/living/simple_animal/Stat()
	..()
	return //RTCHANGE

/mob/living/simple_animal/proc/drop_loot()
	if(loot.len)
		for(var/i in loot)
			new i(loc)

/mob/living/simple_animal/death(gibbed)
	movement_type &= ~FLYING
	if(nest)
		nest.spawned_mobs -= src
		nest = null
	drop_loot()
	if(dextrous)
		drop_all_held_items()
	if(!gibbed)
		emote("death", forced = TRUE)
	layer = layer-0.1
	if(del_on_death)
		..()
		//Prevent infinite loops if the mob Destroy() is overridden in such
		//a manner as to cause a call to death() again
		del_on_death = FALSE
		qdel(src)
	else
		health = 0
		icon_state = icon_dead
		if(flip_on_death)
			transform = transform.Turn(180)
		density = FALSE
		..()
	update_icon()

/mob/living/simple_animal/proc/CanAttack(atom/the_target)
	if(binded)
		return FALSE
	if(see_invisible < the_target.invisibility)
		return FALSE
	if(ismob(the_target))
		var/mob/M = the_target
		if(M.status_flags & GODMODE)
			return FALSE
	if (isliving(the_target))
		var/mob/living/L = the_target
		if(L.stat == DEAD)
			return FALSE
	return TRUE

//mob/living/simple_animal/ignite_mob()
//	return FALSE

///mob/living/simple_animal/extinguish_mob()
//	return

/mob/living/simple_animal/revive(full_heal = FALSE, admin_revive = FALSE)
	if(..()) //successfully ressuscitated from death
		icon = initial(icon)
		icon_state = icon_living
		density = initial(density)
		mobility_flags = MOBILITY_FLAGS_DEFAULT
		update_mobility()
		. = TRUE
		setMovetype(initial(movement_type))

/mob/living/simple_animal/proc/make_babies() // <3 <3 <3
	if(gender != FEMALE || stat || next_scan_time > world.time || !childtype || !animal_species || !SSticker.IsRoundInProgress())
		return
	if(GLOB.farm_animals >= MAX_FARM_ANIMALS)
		return
	if(food < 10)
		return
	if(next_scan_time == 0)
		next_scan_time = world.time + breedcd
		return
	if(breedchildren <= 0)
		childtype = null //we no longer can br33d bro
		return
	next_scan_time = world.time + breedcd
	var/alone = TRUE
	var/children = 0
	var/mob/living/simple_animal/partner
	for(var/mob/M in view(7, src))
		if(M.stat != CONSCIOUS) //Check if it's conscious FIRST.
			continue
		else if(istype(M, childtype)) //Check for children SECOND.
			children++
		else if(istype(M, animal_species))
			if(M.ckey)
				continue
			else if(!istype(M, childtype) && M.gender == MALE && !(M.flags_1 & HOLOGRAM_1)) //Better safe than sorry ;_;
				partner = M
	if(alone && partner && children < 3)
		var/childspawn = pickweight(childtype)
		var/turf/target = get_turf(loc)
		if(target)
			return new childspawn(target)

/mob/living/simple_animal/canUseTopic(atom/movable/M, be_close=FALSE, no_dexterity=FALSE, no_tk=FALSE)
	if(incapacitated())
		to_chat(src, span_warning("I can't do that right now!"))
		return FALSE
	if(be_close && !in_range(M, src))
		to_chat(src, span_warning("I are too far away!"))
		return FALSE
	if(!(no_dexterity || dextrous))
		to_chat(src, span_warning("I don't have the dexterity to do this!"))
		return FALSE
	return TRUE

/mob/living/simple_animal/stripPanelUnequip(obj/item/what, mob/who, where)
	if(!canUseTopic(who, BE_CLOSE))
		return
	else
		..()

/mob/living/simple_animal/stripPanelEquip(obj/item/what, mob/who, where)
	if(!canUseTopic(who, BE_CLOSE))
		return
	else
		..()

/mob/living/simple_animal/update_mobility(value_otherwise = TRUE)
	if(IsUnconscious() || IsParalyzed() || IsStun() || IsKnockdown() || IsParalyzed() || stat || resting)
		drop_all_held_items()
		mobility_flags = NONE
	else if(buckled)
		mobility_flags = MOBILITY_FLAGS_INTERACTION
	else
		if(value_otherwise)
			mobility_flags = MOBILITY_FLAGS_DEFAULT
		else
			mobility_flags = NONE
	if(!(mobility_flags & MOBILITY_MOVE))
		walk(src, 0) //stop mid walk

	update_transform()
	update_action_buttons_icon()

/mob/living/simple_animal/update_transform()
	var/matrix/ntransform = matrix(transform) //aka transform.Copy()
	var/changed = FALSE

	if(resize != RESIZE_DEFAULT_SIZE)
		changed = TRUE
		ntransform.Scale(resize)
		resize = RESIZE_DEFAULT_SIZE

	if(changed)
		animate(src, transform = ntransform, time = 2, easing = EASE_IN|EASE_OUT)

/mob/living/simple_animal/proc/sentience_act() //Called when a simple animal gains sentience via gold slime potion
	toggle_ai(AI_OFF) // To prevent any weirdness.
	can_have_ai = FALSE

/mob/living/simple_animal/update_sight()
	if(!client)
		return
	if(stat == DEAD)
		sight = (SEE_TURFS|SEE_MOBS|SEE_OBJS)
		see_in_dark = 8
		see_invisible = SEE_INVISIBLE_OBSERVER
		return

	see_invisible = initial(see_invisible)
	see_in_dark = initial(see_in_dark)
	sight = initial(sight)

	if(client.eye != src)
		var/atom/A = client.eye
		if(A.update_remote_sight(src)) //returns 1 if we override all other sight updates.
			return
	sync_lighting_plane_alpha()

/mob/living/simple_animal/can_hold_items()
	return dextrous

/mob/living/simple_animal/IsAdvancedToolUser()
	return dextrous

/mob/living/simple_animal/activate_hand(selhand)
	if(!dextrous)
		return ..()
	if(!selhand)
		selhand = (active_hand_index % held_items.len)+1
	if(istext(selhand))
		selhand = lowertext(selhand)
		if(selhand == "right" || selhand == "r")
			selhand = 2
		if(selhand == "left" || selhand == "l")
			selhand = 1
	if(selhand != active_hand_index)
		swap_hand(selhand)
	else
		mode()

/mob/living/simple_animal/swap_hand(hand_index)
	if(!dextrous)
		return ..()
	if(!hand_index)
		hand_index = (active_hand_index % held_items.len)+1
	var/obj/item/held_item = get_active_held_item()
	if(held_item)
		if(istype(held_item, /obj/item/twohanded))
			var/obj/item/twohanded/T = held_item
			if(T.wielded == 1)
				to_chat(usr, span_warning("My other hand is too busy holding [T]."))
				return FALSE
	var/oindex = active_hand_index
	active_hand_index = hand_index
	if(hud_used)
		var/atom/movable/screen/inventory/hand/H
		H = hud_used.hand_slots["[hand_index]"]
		if(H)
			H.update_icon()
		H = hud_used.hand_slots["[oindex]"]
		if(H)
			H.update_icon()
	return TRUE

/mob/living/simple_animal/put_in_hands(obj/item/I, del_on_fail = FALSE, merge_stacks = TRUE)
	. = ..(I, del_on_fail, merge_stacks)
	update_inv_hands()

/mob/living/simple_animal/update_inv_hands()
	if(client && hud_used && hud_used.hud_version != HUD_STYLE_NOHUD)
		var/obj/item/l_hand = get_item_for_held_index(1)
		var/obj/item/r_hand = get_item_for_held_index(2)
		if(r_hand)
			r_hand.layer = ABOVE_HUD_LAYER
			r_hand.plane = ABOVE_HUD_PLANE
			r_hand.screen_loc = ui_hand_position(get_held_index_of_item(r_hand))
			client.screen |= r_hand
		if(l_hand)
			l_hand.layer = ABOVE_HUD_LAYER
			l_hand.plane = ABOVE_HUD_PLANE
			l_hand.screen_loc = ui_hand_position(get_held_index_of_item(l_hand))
			client.screen |= l_hand

//ANIMAL RIDING

/mob/living/simple_animal/hostile/user_unbuckle_mob(mob/living/M, mob/user)
	if(user != M)
		return
	var/time2mount = 12
	if(M.mind)
		var/amt = M.get_skill_level(/datum/skill/misc/riding)
		if(amt)
			if(amt > 3)
				time2mount = 0
		else
			time2mount = 30
	if(ssaddle)
		playsound(src, 'sound/foley/saddledismount.ogg', 100, TRUE)
	if(!move_after(M,time2mount, target = src))
		M.Paralyze(50)
		M.Stun(50)
		playsound(src.loc, 'sound/foley/zfall.ogg', 100, FALSE)
		M.visible_message(span_danger("[M] falls off [src]!"))
	..()
	update_icon()

/mob/living/simple_animal/hostile/user_buckle_mob(mob/living/M, mob/user)
	if(user != M)
		return
	var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding/no_ocean)
	if(riding_datum)
		var/time2mount = 12
		riding_datum.vehicle_move_delay = move_to_delay
		if(M.mind)
			var/amt = M.get_skill_level(/datum/skill/misc/riding)
			if(amt)
				if(amt > 3)
					time2mount = 0
			else
				time2mount = 50

		if(!move_after(M,time2mount, target = src))
			return
		if(user.incapacitated())
			return
//		for(var/atom/movable/A in get_turf(src))
//			if(A != src && A != M && A.density)
//				return
		M.forceMove(get_turf(src))
		if(ssaddle)
			playsound(src, 'sound/foley/saddlemount.ogg', 100, TRUE)
	..()
	update_icon()

/mob/living/simple_animal/hostile
	var/do_footstep = FALSE

/mob/living/simple_animal/hostile/relaymove(mob/user, direction)
	if (stat == DEAD)
		return
	var/oldloc = loc
	var/datum/component/riding/riding_datum = GetComponent(/datum/component/riding/no_ocean)
	if(tame && riding_datum)
		if(riding_datum.handle_ride(user, direction))
			riding_datum.vehicle_move_delay = move_to_delay
			if(user.m_intent == MOVE_INTENT_RUN)
				riding_datum.vehicle_move_delay -= 1
				if(loc != oldloc)
					var/turf/open/T = loc
					if(!do_footstep && T.footstep)
						do_footstep = TRUE
						playsound(loc,pick('sound/foley/footsteps/hoof/horserun (1).ogg','sound/foley/footsteps/hoof/horserun (2).ogg','sound/foley/footsteps/hoof/horserun (3).ogg'), 100, TRUE)
					else
						do_footstep = FALSE
			else
				if(loc != oldloc)
					var/turf/open/T = loc
					if(!do_footstep && T.footstep)
						do_footstep = TRUE
						playsound(loc,pick('sound/foley/footsteps/hoof/horsewalk (1).ogg','sound/foley/footsteps/hoof/horsewalk (2).ogg','sound/foley/footsteps/hoof/horsewalk (3).ogg'), 100, TRUE)
					else
						do_footstep = FALSE
			if(user.mind)
				var/amt = user.get_skill_level(/datum/skill/misc/riding)
				if(amt)
					riding_datum.vehicle_move_delay -= 5 + amt/6
				else
					riding_datum.vehicle_move_delay -= 3
			if(loc != oldloc)
				var/obj/structure/mineral_door/MD = locate() in loc
				if(MD && !MD.ridethrough)
					if(!HAS_TRAIT(user, TRAIT_EQUESTRIAN))
						violent_dismount(user)

/mob/living/simple_animal/proc/violent_dismount(mob/living/user)
	if(isliving(user))
		var/mob/living/L = user
		unbuckle_mob(L)
		L.Paralyze(50)
		L.Stun(50)
		playsound(L.loc, 'sound/foley/zfall.ogg', 100, FALSE)
		L.visible_message(span_danger("[L] falls off [src]!"))

/mob/living/simple_animal/buckle_mob(mob/living/buckled_mob, force = 0, check_loc = 1)
	. = ..()
	LoadComponent(/datum/component/riding)

/mob/living/simple_animal/proc/toggle_ai(togglestatus)
	if(!can_have_ai && (togglestatus != AI_OFF))
		return
	if (AIStatus != togglestatus)
		if (togglestatus > 0 && togglestatus < 5)
			if (togglestatus == AI_Z_OFF || AIStatus == AI_Z_OFF)
				var/turf/T = get_turf(src)
				if (AIStatus == AI_Z_OFF)
					SSidlenpcpool.idle_mobs_by_zlevel[T.z] -= src
				else
					SSidlenpcpool.idle_mobs_by_zlevel[T.z] += src
			GLOB.simple_animals[AIStatus] -= src
			GLOB.simple_animals[togglestatus] += src
			AIStatus = togglestatus
		else
			stack_trace("Something attempted to set simple animals AI to an invalid state: [togglestatus]")

/mob/living/simple_animal/proc/consider_wakeup()
	for(var/datum/spatial_grid_cell/grid as anything in our_cells.member_cells)
		if(length(grid.client_contents))
			toggle_ai(AI_ON)
			return TRUE

	toggle_ai(AI_OFF)
	return FALSE

/mob/living/simple_animal/adjustHealth(amount, updating_health = TRUE, forced = FALSE)
	. = ..()
	if(!ckey && !stat)//Not unconscious
		if(AIStatus == AI_IDLE)
			toggle_ai(AI_ON)


/mob/living/simple_animal/onTransitZ(old_z, new_z)
	..()
	if (AIStatus == AI_Z_OFF)
		SSidlenpcpool.idle_mobs_by_zlevel[old_z] -= src
		toggle_ai(initial(AIStatus))

/mob/living/simple_animal/Move()
	if(binded)
		return FALSE
	. = ..()
//	if(!stat)
//		eat_plants()

/mob/living/simple_animal/proc/eat_plants()

	var/obj/item/reagent_containers/food/I = locate(/obj/item/reagent_containers/food) in loc
	if(is_type_in_list(I, food_type))
		qdel(I)
		food = max(food + 30, 100)

/mob/living/simple_animal/Life()
	if(!client && can_have_ai && (AIStatus == AI_Z_OFF || AIStatus == AI_OFF))
		return
	. = ..()
	if(.)
		if(food > 0)
			food--
			pooprog++
			production++
			production = min(production, 100)
			if(pooprog >= 100)
				pooprog = 0
				poop()

/mob/living/simple_animal/proc/poop()
	if(pooptype)
		if(isturf(loc))
			playsound(src, "fart", 100, TRUE)
			new pooptype(loc)

/mob/living/simple_animal/proc/on_client_enter(datum/source, atom/target)
	SIGNAL_HANDLER
	if(AIStatus == AI_IDLE)
		toggle_ai(AI_ON)

/mob/living/simple_animal/proc/on_client_exit(datum/source, datum/exited)
	SIGNAL_HANDLER
	consider_wakeup()

/mob/living/simple_animal/proc/set_new_cells()
	var/turf/our_turf = get_turf(src)
	if(isnull(our_turf))
		return

	var/list/cell_collections = our_cells.recalculate_cells(our_turf)

	for(var/datum/old_grid as anything in cell_collections[2])
		UnregisterSignal(old_grid, list(SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)))

	for(var/datum/spatial_grid_cell/new_grid as anything in cell_collections[1])
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_client_enter))
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_client_exit))
	consider_wakeup()

/mob/living/simple_animal/Moved()
	. = ..()
	update_grid()

/mob/living/simple_animal/proc/update_grid()
	var/turf/our_turf = get_turf(src)
	if(isnull(our_turf) || isnull(our_cells))
		return

	var/list/cell_collections = our_cells.recalculate_cells(our_turf)

	for(var/datum/old_grid as anything in cell_collections[2])
		UnregisterSignal(old_grid, list(SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)))

	for(var/datum/spatial_grid_cell/new_grid as anything in cell_collections[1])
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_client_enter))
		RegisterSignal(new_grid, SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_client_exit))
	consider_wakeup()

#undef MAX_FARM_ANIMALS
