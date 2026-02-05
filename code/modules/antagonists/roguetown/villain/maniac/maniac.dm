
/datum/antagonist/maniac
	name = "Maniac"
	roundend_category = "maniacs"
	antagpanel_category = "Maniac"
	antag_memory = "<b>Recently I've been visited by a lot of VISIONS. They're all about another WORLD, ANOTHER life. I will do EVERYTHING to know the TRUTH, and return to the REAL world.</b>"
	job_rank = ROLE_MANIAC
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "villain"
	confess_lines = list(
		"I gave them no time to squeal.",
		"I shant quit ripping them.",
		"They deserve to be put at my blade.",
		"Do what thou wilt shall be the whole of the law.",
	)
	rogue_enabled = FALSE
	/// Traits we apply to the owner
	var/static/list/applied_traits = list(
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_DECEIVING_MEEKNESS,
		TRAIT_NOSTINK,
		TRAIT_EMPATH,
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOPAIN,
		TRAIT_NOPAINSTUN,
		TRAIT_STEELHEARTED,
		TRAIT_NOMOOD,
		TRAIT_HARDDISMEMBER,
		TRAIT_NOSLEEP,
		TRAIT_SHOCKIMMUNE,
		TRAIT_STABLEHEART,
		TRAIT_STABLELIVER,
		TRAIT_ANTIMAGIC,
		TRAIT_PSYCHOSIS,
		TRAIT_BLOODLOSS_IMMUNE,
	)
	/// Traits that only get applied in the final sequence
	var/static/list/final_traits = list(
		TRAIT_MANIAC_AWOKEN,
		TRAIT_SCREENSHAKE,
	)
	/// Cached old stats in case we get removed
	var/STASTR
	var/STACON
	var/STAWIL
	/// Weapons we can give to the dreamer
	var/static/list/possible_weapons = list(
		/obj/item/rogueweapon/huntingknife/chefknife/cleaver,
		/obj/item/rogueweapon/huntingknife/combat,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special,
	)
		/// Wonder recipes
	var/static/list/recipe_progression = list(
		/datum/crafting_recipe/roguetown/structure/wonder/first,
		/datum/crafting_recipe/roguetown/structure/wonder/second,
		/datum/crafting_recipe/roguetown/structure/wonder/third,
		/datum/crafting_recipe/roguetown/structure/wonder/fourth,
	)
	/// Key number > Key text
	var/list/num_keys = list()
	/// Key text > key number
	var/list/key_nums = list()
	/// Every heart inscryption we have seen
	var/list/hearts_seen = list()
	/// Sum of the numbers of every key
	var/sum_keys = 0
	/// Keeps track of which wonder we are gonna make next
	var/current_wonder = 1
	/// Set to TRUE when we are on the last wonder (waking up)
	var/waking_up = FALSE
	/// Set to true when we WIN and are on the ending sequence
	var/triumphed = FALSE
	/// Wonders we have made
	var/list/wonders_made = list()

/datum/antagonist/maniac/New()
	set_keys()
	load_strings_file("maniac.json")
	return ..()

/datum/antagonist/maniac/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/datum/antagonist/maniac/on_gain()
	. = ..()
	owner.special_role = ROLE_MANIAC
	owner.special_items["Maniac"] = pick(possible_weapons)
	owner.special_items["Surgical Kit"] = /obj/item/storage/belt/rogue/surgery_bag/full
	if(owner.current)
		if(ishuman(owner.current))
			var/mob/living/carbon/human/dreamer = owner.current
			dreamer.cmode_music = 'sound/music/combat_maniac2.ogg'
			dreamer.adjust_skillrank(/datum/skill/combat/knives, 6, TRUE)
			dreamer.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
			dreamer.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
			var/medicine_skill = dreamer.get_skill_level(/datum/skill/misc/medicine)
			if(medicine_skill < 3)// Bumps his skill up to 3 for surgery, not higher
				dreamer.adjust_skillrank(/datum/skill/misc/medicine, 3 - medicine_skill, TRUE)
			STASTR = dreamer.STASTR
			STACON = dreamer.STACON
			STAWIL = dreamer.STAWIL
			dreamer.STASTR = 20
			dreamer.STACON = 20
			dreamer.STAWIL = 20
		for(var/trait in applied_traits)
			ADD_TRAIT(owner.current, trait, "[type]")
	LAZYINITLIST(owner.learned_recipes)
	if(length(objectives))
		SEND_SOUND(owner.current, 'sound/villain/dreamer_warning.ogg')
		to_chat(owner.current, span_danger("[antag_memory]"))
		owner.announce_objectives()
	START_PROCESSING(SSobj, src)

/datum/antagonist/maniac/on_removal()
	STOP_PROCESSING(SSobj, src)
	if(owner.current)
		if(!silent)
			to_chat(owner.current,span_danger("I am no longer a MANIAC!"))
		if(ishuman(owner.current))
			var/mob/living/carbon/human/dreamer = owner.current
			dreamer.STASTR = STASTR
			dreamer.STACON = STACON
			dreamer.STAWIL = STAWIL
		for(var/trait in applied_traits)
			REMOVE_TRAIT(owner.current, trait, "[type]")
		for(var/trait in final_traits)
			REMOVE_TRAIT(owner.current, trait, "[type]")
		owner.current.clear_fullscreen("maniac")
	QDEL_LIST(wonders_made)
	wonders_made = null
	owner.special_role = null
	return ..()

/datum/antagonist/maniac/proc/set_keys()
	key_nums = list()
	num_keys = list()
	//We need 4 numbers and four keys
	for(var/i in 1 to 4)
		//Make the number first
		var/randumb
		while(!randumb || (randumb in num_keys))
			randumb = "[rand(0,9)][rand(0,9)][rand(0,9)][rand(0,9)]"
		//Make the key second
		var/rantelligent
		while(!rantelligent || (rantelligent in key_nums))
			rantelligent = uppertext("[pick(GLOB.alphabet)][pick(GLOB.alphabet)][pick(GLOB.alphabet)][pick(GLOB.alphabet)]")

		//Stick then in the lists, continue the loop
		num_keys[randumb] = rantelligent
		key_nums[rantelligent] = randumb

	sum_keys = 0
	for(var/i in num_keys)
		sum_keys += text2num(i)

/datum/antagonist/maniac/proc/forge_villain_objectives()
	return

/datum/antagonist/maniac/proc/wake_up()
	STOP_PROCESSING(SSobj, src)
	triumphed = TRUE
	waking_up = FALSE
	var/mob/living/carbon/dreamer = owner.current
	// var/client/dreamer_client = dreamer.client // Trust me, we need it later
	dreamer.clear_fullscreen("dream")
	dreamer.clear_fullscreen("wakeup")
	for(var/datum/objective/objective in objectives)
		objective.completed = TRUE
	for(var/mob/connected_player in GLOB.player_list)
		if(!connected_player.client)
			continue
		SEND_SOUND(connected_player, sound(null))
		SEND_SOUND(connected_player, 'sound/villain/dreamer_win.ogg')
	var/mob/living/carbon/human/trey_liam = spawn_trey_liam()
	if(trey_liam)
		owner.transfer_to(trey_liam)
		//Explodie all our wonders
		for(var/obj/structure/wonder/wondie as anything in wonders_made)
			if(istype(wondie))
				explosion(wondie, 8, 16, 32, 64)
		var/obj/item/organ/brain/brain = dreamer.getorganslot(ORGAN_SLOT_BRAIN)
		var/obj/item/bodypart/head/head = dreamer.get_bodypart(BODY_ZONE_HEAD)
		if(head)
			head.dismember(BURN)
			if(!QDELETED(head))
				qdel(head)
		if(brain)
			qdel(brain)
		trey_liam.SetSleeping(25 SECONDS)
		trey_liam.add_stress(/datum/stressevent/maniac_woke_up)
		sleep(1.5 SECONDS)
		to_chat(trey_liam, span_deadsay("<span class='reallybig'>... WHERE AM I? ...</span>"))
		sleep(1.5 SECONDS)
		var/static/list/slop_lore = list(
			span_deadsay("... Azure Peak? No ... It doesn't exist ..."),
			span_deadsay("... My name is Trey. Trey Liam, Liamtific Troverseer ..."),
			span_deadsay("... I'm on NT Liam, a self Treystaining ship, used to Treyserve what Liamains of roguemanity ..."),
			span_deadsay("... Launched into the Grim Darkness, Fart Grimness preserves their grimness ... Their edge ..."),
			span_deadsay("... Keeps them alive in the grim future, where there is only grimdarkness ..."),
			span_deadsay("... There is no hope left. Only the Space Station 13 lets me live in the Trey Liam ..."),
			span_deadsay("... What have I done!? ..."),
		)
		for(var/slop in slop_lore)
			to_chat(trey_liam, slop)
			sleep(5 SECONDS)
	else
		INVOKE_ASYNC(src, PROC_REF(cant_wake_up), dreamer)
	sleep(15 SECONDS)
	to_chat(world, span_deadsay("<span class='reallybig'>The Maniac has TRIUMPHED!</span>"))
	SSticker.declare_completion()

/datum/antagonist/maniac/proc/agony(mob/living/carbon/dreamer)
	dreamer.overlay_fullscreen("dream", /atom/movable/screen/fullscreen/dreaming)
	dreamer.overlay_fullscreen("wakeup", /atom/movable/screen/fullscreen/dreaming/waking_up)
	for(var/trait in final_traits)
		ADD_TRAIT(dreamer, trait, "[type]")
	waking_up = TRUE

/datum/antagonist/maniac/proc/spawn_trey_liam()
	var/turf/spawnturf
	var/obj/effect/landmark/treyliam/trey = locate(/obj/effect/landmark/treyliam) in GLOB.landmarks_list
	if(trey)
		spawnturf = get_turf(trey)
	if(spawnturf)
		var/mob/living/carbon/human/trey_liam = new /mob/living/carbon/human/species/human/northern(spawnturf)
		trey_liam.fully_replace_character_name(trey_liam.name, "Trey Liam")
		trey_liam.gender = MALE
		trey_liam.skin_tone = "ffe0d1"
		trey_liam.hair_color = "999999"
		trey_liam.hairstyle = "Plain Long"
		trey_liam.facial_hair_color = "999999"
		trey_liam.facial_hairstyle = "Knowledge"
		trey_liam.age = AGE_OLD
		trey_liam.equipOutfit(/datum/outfit/treyliam)
		trey_liam.regenerate_icons()
		for(var/obj/structure/chair/chair in spawnturf)
			chair.buckle_mob(trey_liam)
			break
		return trey_liam
	return

/datum/antagonist/maniac/proc/cant_wake_up(mob/living/dreamer)
	if(!iscarbon(dreamer))
		return
	to_chat(dreamer, span_deadsay("<span class='reallybig'>I CAN'T WAKE UP.</span>"))
	sleep(2 SECONDS)
	for(var/i in 1 to 10)
		to_chat(dreamer, span_deadsay("<span class='reallybig'>ICANTWAKEUP</span>"))
		sleep(0.5 SECONDS)
	var/obj/item/organ/brain/brain = dreamer.getorganslot(ORGAN_SLOT_BRAIN)
	var/obj/item/bodypart/head/head = dreamer.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		head.dismember(BURN)
		if(!QDELETED(head))
			qdel(head)
	if(brain)
		qdel(brain)

//TODO Collate
/datum/antagonist/roundend_report()
	var/traitorwin = TRUE

	printplayer(owner)

	var/count = 0
	if(objectives.len)//If the traitor had no objectives, don't need to process this.
		for(var/datum/objective/objective in objectives)
			objective.update_explanation_text()
			if(objective.check_completion())
				to_chat(world, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='greentext'>TRIUMPH!</span>")
			else
				to_chat(world, "<B>Goal #[count]</B>: [objective.explanation_text] <span class='redtext'>Failure.</span>")
				traitorwin = FALSE
			count += objective.triumph_count

	var/special_role_text = lowertext(name)

	if(!considered_alive(owner))
		traitorwin = FALSE

	if(traitorwin)
		if(count)
			if(owner)
				owner.adjust_triumphs(count)
		to_chat(world, span_greentext("The [special_role_text] has TRIUMPHED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_chat(world, span_redtext("The [special_role_text] has FAILED!"))
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)
