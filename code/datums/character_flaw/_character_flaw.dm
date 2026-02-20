
GLOBAL_LIST_INIT(character_flaws, list(
	/datum/charflaw/addiction/alcoholic::name = /datum/charflaw/addiction/alcoholic,
	/datum/charflaw/averse::name = /datum/charflaw/averse,
	/datum/charflaw/addiction/godfearing::name = /datum/charflaw/addiction/godfearing,
	/datum/charflaw/colorblind::name = /datum/charflaw/colorblind,
	/datum/charflaw/addiction/smoker::name = /datum/charflaw/addiction/smoker,
	/datum/charflaw/addiction/junkie::name = /datum/charflaw/addiction/junkie,
	/datum/charflaw/unintelligible::name = /datum/charflaw/unintelligible,
	/datum/charflaw/greedy::name = /datum/charflaw/greedy,
	/datum/charflaw/narcoleptic::name = /datum/charflaw/narcoleptic,
	/datum/charflaw/addiction/lovefiend::name = /datum/charflaw/addiction/lovefiend,
	/datum/charflaw/addiction/sadist::name = /datum/charflaw/addiction/sadist,
	/datum/charflaw/addiction/masochist::name = /datum/charflaw/addiction/masochist,
	/datum/charflaw/clingy::name = /datum/charflaw/clingy,
	/datum/charflaw/finicky::name = /datum/charflaw/finicky,
	/datum/charflaw/lonely::name = /datum/charflaw/lonely,
	/datum/charflaw/addiction/paranoid::name = /datum/charflaw/addiction/paranoid,
	/datum/charflaw/addiction/clamorous::name = /datum/charflaw/addiction/clamorous,
	/datum/charflaw/addiction/thrillseeker::name = /datum/charflaw/addiction/thrillseeker,
	/datum/charflaw/indebted::name = /datum/charflaw/indebted,
	/datum/charflaw/addiction/voyeur::name = /datum/charflaw/addiction/voyeur,
	/datum/charflaw/badsight::name = /datum/charflaw/badsight,
	/datum/charflaw/noeyer::name = /datum/charflaw/noeyer,
	/datum/charflaw/noeyel::name = /datum/charflaw/noeyel,
	/datum/charflaw/noeyeall::name = /datum/charflaw/noeyeall,
	/datum/charflaw/limbloss/arm_r::name = /datum/charflaw/limbloss/arm_r,
	/datum/charflaw/limbloss/arm_l::name = /datum/charflaw/limbloss/arm_l,
	/datum/charflaw/sleepless::name = /datum/charflaw/sleepless,
	/datum/charflaw/mute::name = /datum/charflaw/mute,
	/datum/charflaw/critweakness::name = /datum/charflaw/critweakness,
	/datum/charflaw/hunted::name = /datum/charflaw/hunted,
	/datum/charflaw/mind_broken::name = /datum/charflaw/mind_broken,
	/datum/charflaw/noflaw::name = /datum/charflaw/noflaw,
	/datum/charflaw/leprosy::name = /datum/charflaw/leprosy,
	/datum/charflaw/randflaw::name = /datum/charflaw/randflaw
	))

GLOBAL_LIST_INIT(averse_factions, list(
	"Courtiers & Nobility" = (COURTIERS | NOBLEMEN | COUNCILLOR),
	"Inquisition" = INQUISITION,
	"Burghers" = BURGHERS,
	"Retinue" = RETINUE,
	"Garrison" = GARRISON,
	"Churchmen" = CHURCHMEN,
	"Peasants" = PEASANTS,
	"Wanderers" = WANDERERS,
	"Everyone" = (COURTIERS | NOBLEMEN | INQUISITION | BURGHERS | RETINUE | GARRISON | CHURCHMEN | PEASANTS | WANDERERS | SIDEFOLK | ANTAGONIST | COUNCILLOR)
))

/datum/charflaw
	var/name
	var/desc
	var/ephemeral = FALSE // This flaw is currently disabled and will not process
	/// For voyeur vice examines only. Format is "[name] is " + this + "...", leave blank to use the flaw's name.
	/// Intended for addiction types only.
	var/voyeur_descriptor	

/datum/charflaw/proc/on_mob_creation(mob/user)
	return

/datum/charflaw/proc/apply_post_equipment(mob/user)
	return

/datum/charflaw/proc/flaw_on_life(mob/user)
	return

/mob/proc/has_flaw(flaw)
	return

/mob/living/carbon/human/has_flaw(flaw)
	if(!flaw)
		return FALSE

	if(charflaws && charflaws.len)
		for(var/datum/charflaw/cf in charflaws)
			if(istype(cf, flaw))
				return TRUE

	if(client?.prefs?.charflaws && client.prefs.charflaws.len)
		for(var/datum/charflaw/cf in client.prefs.charflaws)
			if(istype(cf, flaw))
				return TRUE

	return FALSE

/mob/proc/get_flaw()
	return

/mob/living/carbon/human/get_flaw(flaw_type)
	if(!flaw_type)
		return charflaws.len > 0 ? charflaws[1] : null
	for(var/datum/charflaw/cf in charflaws)
		if(istype(cf, flaw_type))
			return cf
	return null

/datum/charflaw/eznoflaw
	name = "No Flaw"
	desc = "I'm a normal person, how rare!"

/datum/charflaw/noflaw
	name = "No Flaw (-3 TRI)"
	desc = "I'm a normal person, how rare! (Consumes 3 triumphs or gives a random flaw.)"

/datum/charflaw/noflaw/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	if(H.get_triumphs() < 3)
		var/flawz = GLOB.character_flaws.Copy()
		var/charflaw = pick_n_take(flawz)
		charflaw = GLOB.character_flaws[charflaw]
		var/datum/charflaw/new_flaw = new charflaw()
		H.charflaws.Add(new_flaw)
		new_flaw.on_mob_creation(H)
	else
		H.adjust_triumphs(-3)

/datum/charflaw/randflaw
	name = "Random"
	desc = "A chance for a random flaw."

/datum/charflaw/randflaw/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/target = user

	var/list/cf_list = GLOB.character_flaws.Copy()
	for(var/key in cf_list)
		if(cf_list[key] == type || cf_list[key] == /datum/charflaw/noflaw)
			cf_list -= key

	var/datum/job/mob_job = null
	if(target.mind?.assigned_role)
		mob_job = SSjob.GetJob(target.mind.assigned_role)
	else if(target.client?.prefs?.lastclass)
		mob_job = SSjob.GetJob(target.client.prefs.lastclass)

	if(mob_job && mob_job.vice_restrictions)
		for(var/key in cf_list)
			if(cf_list[key] in mob_job.vice_restrictions)
				cf_list -= key

	var/datum/charflaw/chosen_type = null
	if(length(cf_list))
		var/chosen_key = pick_n_take(cf_list)
		chosen_type = GLOB.character_flaws[chosen_key]

	if(chosen_type)
		var/datum/charflaw/added_flaw = new chosen_type()
		target.charflaws.Add(added_flaw)
		added_flaw.on_mob_creation(target)

	target.charflaws.Remove(src)
	QDEL_NULL(src)

/datum/charflaw/badsight
	name = "Bad Eyesight"
	desc = "I need spectacles to see normally from my years spent reading books."

/datum/charflaw/badsight/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.wear_mask)
		if(isclothing(H.wear_mask))
			if(istype(H.wear_mask, /obj/item/clothing/mask/rogue/spectacles))
				var/obj/item/I = H.wear_mask
				if(!I.obj_broken)
					return
	H.blur_eyes(2)
	H.apply_status_effect(/datum/status_effect/debuff/badvision)

/datum/status_effect/debuff/badvision
	id = "badvision"
	alert_type = null
	effectedstats = list(STATKEY_PER = -20, STATKEY_SPD = -5)
	duration = 10 SECONDS

/datum/charflaw/badsight/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/spectacles(H), SLOT_WEAR_MASK)
	else
		new /obj/item/clothing/mask/rogue/spectacles(get_turf(H))
	
	// we don't seem to have a mind when on_mob_creation fires, so set up a timer to check when we probably will
	addtimer(CALLBACK(src, PROC_REF(apply_reading_skill), H), 5 SECONDS)

/datum/charflaw/badsight/proc/apply_reading_skill(mob/living/carbon/human/H)
	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)

/datum/charflaw/paranoid
	name = "Paranoid"
	desc = "I'm even more anxious than most people. I'm extra paranoid of other races and the sight of blood."
	var/last_check = 0

/datum/charflaw/paranoid/flaw_on_life(mob/user)
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == src)
			continue
		if(L.stat)
			continue
		if(L.dna?.species)
			if(ishuman(user))
				var/mob/living/carbon/human/H = user
				if(L.dna.species.id != H.dna.species.id)
					cnt++
		if(cnt > 2)
			break
	if(cnt > 2)
		user.add_stress(/datum/stressevent/paracrowd)
	cnt = 0
	for(var/obj/effect/decal/cleanable/blood/B in view(7, user))
		cnt++
		if(cnt > 3)
			break
	if(cnt > 6)
		user.add_stress(/datum/stressevent/parablood)

/datum/charflaw/finicky
	name = "Finicky"
	desc = "I don't like crowds. I don't like being alone, neither. There's a middle, isn't there?"
	var/interval = 1 MINUTES
	var/is_active = FALSE
	var/next_check = 0

/datum/charflaw/finicky/flaw_on_life(mob/user)
	if(!user)
		return
	if(is_active)
		if(world.time > next_check)
			next_check = world.time + interval
			var/cnt = 0
			for(var/mob/living/carbon/human/L in get_hearers_in_view(6, user, RECURSIVE_CONTENTS_CLIENT_MOBS))
				if(L == user)
					continue
				if(L.stat)
					continue
				if(L.dna.species)
					cnt++
				if(cnt > 3)
					break
			var/mob/living/carbon/P = user
			if(cnt > 3)
				P.add_stress(/datum/stressevent/crowd)
			else if(cnt == 0)
				P.add_stress(/datum/stressevent/nocrowd)
			else
				next_check = world.time + (interval * 6)	//we procced it successfully, so the delay is longer

/datum/charflaw/finicky/apply_post_equipment(mob/user)
	if(user.mind)
		is_active = TRUE

/datum/charflaw/lonely
	name = "Lonely"
	desc = "I just don't like being alone."
	var/interval = 1 MINUTES
	var/severity_interval = 5 MINUTES
	var/stacks = 0
	var/is_active = FALSE
	var/next_check = 0
	var/next_severity = 0

/datum/charflaw/lonely/flaw_on_life(mob/user)
	if(!user)
		return
	if(is_active)
		if(world.time > next_check)
			next_check = world.time + interval
			var/cnt = 0
			for(var/mob/living/carbon/human/L in get_hearers_in_view(7, user, RECURSIVE_CONTENTS_CLIENT_MOBS))
				if(L == user)
					continue
				if(L.stat)
					continue
				if(L.dna.species)
					cnt++
				if(cnt > 3)
					break
			var/mob/living/carbon/P = user
			if(cnt <= 0)
				handle_stacks(P)
			else
				reset_stacks(P)

/datum/charflaw/lonely/apply_post_equipment(mob/user)
	if(user.mind)
		is_active = TRUE

/datum/charflaw/lonely/proc/handle_stacks(mob/living/L)
	if(world.time > next_severity)
		stacks++
		next_severity = world.time + severity_interval
		switch(stacks)
			if(1)
				L.add_stress(/datum/stressevent/lonely_one)
			if(2)
				L.add_stress(/datum/stressevent/lonely_two)
			if(3)
				L.add_stress(/datum/stressevent/lonely_three)
			if(4)
				L.add_stress(/datum/stressevent/lonely_max)

/datum/charflaw/lonely/proc/reset_stacks(mob/living/L)
	if(stacks >= 2)
		to_chat(L, span_info("Oh thank [L.patron?.name]! A person!"))
	if(stacks > 1)
		L.remove_stress_list(/datum/stressevent/lonely_one, /datum/stressevent/lonely_two, /datum/stressevent/lonely_three, /datum/stressevent/lonely_max)
	stacks = 0

/datum/charflaw/clingy
	name = "Clingy"
	desc = "I like being close to people. Real close."
	var/next_check = 0
	var/interval = 1 MINUTES
	var/is_active = FALSE

/datum/charflaw/clingy/flaw_on_life(mob/user)
	if(!user)
		return
	if(is_active)
		if(world.time > next_check)
			next_check = world.time + interval
			var/cnt = 0
			var/distfound = FALSE
			for(var/mob/living/carbon/human/L in get_hearers_in_view(2, user))
				if(L == user)
					continue
				if(L.stat == DEAD)
					continue
				var/dist = get_dist(L, user)
				if(dist <= 1)
					distfound = TRUE
					user.remove_stress(/datum/stressevent/nopeople)
					break
				if(L.dna.species)
					cnt++
				if(cnt >= 2)
					user.remove_stress(/datum/stressevent/nopeople)
					break
			var/mob/living/carbon/P = user
			if(cnt < 1 && !distfound)
				P.add_stress(/datum/stressevent/nopeople)
			else
				next_check = world.time + (interval * 6) //we procced it successfully, so the delay is longer

/datum/charflaw/clingy/apply_post_equipment(mob/user)
	if(user.mind)
		is_active = TRUE
	

/datum/charflaw/noeyer
	name = "Cyclops (R)"
	desc = "I lost my right eye long ago."

/datum/charflaw/noeyer/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/eyepatch(H), SLOT_WEAR_MASK)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/right/permanent)
	H.update_fov_angles()

/datum/charflaw/noeyel
	name = "Cyclops (L)"
	desc = "I lost my left eye long ago."

/datum/charflaw/noeyel/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/eyepatch/left(H), SLOT_WEAR_MASK)
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/left/permanent)
	H.update_fov_angles()

/datum/charflaw/noeyeall
	name = "Blindness"
	desc = "I lost both of my eyes long ago."

/datum/charflaw/noeyeall/on_mob_creation(mob/user)
	..()
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!H.wear_mask)
		H.equip_to_slot_or_del(new /obj/item/clothing/glasses/blindfold(H), SLOT_WEAR_MASK)
	H.overlay_fullscreen("blind_flaw", /atom/movable/screen/fullscreen/impaired, 2)

/datum/charflaw/colorblind
	name = "Colorblind"
	desc = "I was cursed with flawed eyesight from birth, and can't discern things others can. Incompatible with Night-eyed virtue."

/datum/charflaw/colorblind/on_mob_creation(mob/user)
	..()
	user.add_client_colour(/datum/client_colour/monochrome)

/datum/charflaw/hunted
	name = "Hunted"
	desc = "Something in my past has made me a target. I'm always looking over my shoulder.	\
	\nTHIS IS A DIFFICULT FLAW, YOU WILL BE HUNTED BY ASSASSINS AND HAVE ASSASINATION ATTEMPTS MADE AGAINST YOU WITHOUT ANY ESCALATION. \
	EXPECT A MORE DIFFICULT EXPERIENCE. PLAY AT YOUR OWN RISK."
	var/logged = FALSE

/datum/charflaw/hunted/flaw_on_life(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(logged == FALSE)
		if(H.name) // If you don't check this, the log entry wont have a name as flaw_on_life is checked at least once before the name is set.
			log_hunted("[H.ckey] playing as [H.name] had the hunted flaw by vice.")
			logged = TRUE

/datum/charflaw/hunted/apply_post_equipment(mob/user)
	..()
	if(!ishuman(user))
		return
	var/datum/job/gnoll_job = SSjob.GetJob("Gnoll")
	var/total_gnoll_positions = gnoll_job.total_positions
	var/gnoll_increase = get_gnoll_slot_increase(total_gnoll_positions)

	if(gnoll_increase >= 1)
		to_chat(user, span_notice("I have offended graggarite agents, and they may be tracking my scent."))
		gnoll_job.total_positions = min(total_gnoll_positions + gnoll_increase, 10)
		gnoll_job.spawn_positions = min(total_gnoll_positions + gnoll_increase, 10)

/datum/charflaw/unintelligible
	name = "Unintelligible"
	desc = "I cannot speak the common tongue!"

/datum/charflaw/unintelligible/on_mob_creation(mob/user)
	var/mob/living/carbon/human/recipient = user
	addtimer(CALLBACK(src, PROC_REF(unintelligible_apply), recipient), 5 SECONDS)

/datum/charflaw/unintelligible/proc/unintelligible_apply(mob/living/carbon/human/user)
	if(user.advsetup)
		addtimer(CALLBACK(src, PROC_REF(unintelligible_apply), user), 5 SECONDS)
		return
	user.remove_language(/datum/language/common)
	user.adjust_skillrank(/datum/skill/misc/reading, -6, TRUE)

/datum/charflaw/greedy
	name = "Greedy"
	desc = "I can't get enough of mammons, I need more and more! I've also become good at knowing how much things are worth"
	var/last_checked_mammons = 0
	var/required_mammons = 0
	var/next_mammon_increase = 0
	var/last_passed_check = 0
	var/first_tick = FALSE
	var/extra_increment_value = 0

/datum/charflaw/greedy/on_mob_creation(mob/user)
	next_mammon_increase = world.time + rand(15 MINUTES, 25 MINUTES)
	last_passed_check = world.time
	ADD_TRAIT(user, TRAIT_SEEPRICES_SHITTY, "[type]")

/datum/charflaw/greedy/flaw_on_life(mob/user)
	if(!first_tick)
		determine_starting_mammons(user)
		first_tick = TRUE
		return
	if(world.time >= next_mammon_increase)
		mammon_increase(user)
	mammon_check(user)

/datum/charflaw/greedy/proc/determine_starting_mammons(mob/living/carbon/human/user)
	var/starting_mammons = get_mammons_in_atom(user)
	required_mammons = round(starting_mammons * 0.7)
	extra_increment_value = round(starting_mammons * 0.15)

/datum/charflaw/greedy/proc/mammon_increase(mob/living/carbon/human/user)
	if(last_passed_check + (50 MINUTES) < world.time) //If we spend a REALLY long time without being able to satisfy, then pity downgrade
		required_mammons -= rand(10, 20)
		to_chat(user, span_blue("Maybe a little less mammons is enough..."))
	else
		required_mammons += rand(25, 35) + extra_increment_value
	required_mammons = min(required_mammons, 250) //Cap at 250 coins maximum
	next_mammon_increase = world.time + rand(35 MINUTES, 40 MINUTES)
	var/current_mammons = get_mammons_in_atom(user)
	if(current_mammons >= required_mammons)
		to_chat(user, span_blue("I'm quite happy with the amount of mammons I have..."))
	else
		to_chat(user, span_boldwarning("I need more mammons, what I have is not enough..."))

	last_checked_mammons = current_mammons

/datum/charflaw/greedy/proc/mammon_check(mob/living/carbon/human/user)
	var/new_mammon_amount = get_mammons_in_atom(user)
	var/ascending = (new_mammon_amount > last_checked_mammons)

	var/do_update_msg = TRUE
	if(new_mammon_amount >= required_mammons)
		// Feel better
		if(user.has_stress_event(/datum/stressevent/vice))
			to_chat(user, span_blue("[new_mammon_amount] mammons... That's more like it.."))
		user.remove_stress(/datum/stressevent/vice)
		user.remove_status_effect(/datum/status_effect/debuff/addiction)
		last_passed_check = world.time
		do_update_msg = FALSE
	else
		// Feel bad
		user.add_stress(/datum/stressevent/vice)
		user.apply_status_effect(/datum/status_effect/debuff/addiction)

	if(new_mammon_amount == last_checked_mammons)
		do_update_msg = FALSE

	if(do_update_msg)
		if(ascending)
			to_chat(user, span_warning("Only [new_mammon_amount] mammons.. I need more..."))
		else
			to_chat(user, span_boldwarning("No! My precious mammons..."))

	last_checked_mammons = new_mammon_amount

/datum/charflaw/narcoleptic
	name = "Narcoleptic"
	desc = "I get drowsy during the day and tend to fall asleep suddenly, but I can sleep easier if I want to, and moon dust can help me stay awake."
	var/last_unconsciousness = 0
	var/next_sleep = 0
	var/concious_timer = (10 MINUTES)
	var/do_sleep = FALSE
	var/pain_pity_charges = 3
	var/drugged_up = FALSE

/datum/charflaw/narcoleptic/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_FASTSLEEP, "[type]")
	reset_timer()

/datum/charflaw/narcoleptic/proc/reset_timer()
	do_sleep = FALSE
	last_unconsciousness = world.time
	concious_timer = rand(7 MINUTES, 15 MINUTES)
	pain_pity_charges = rand(2,4)

/datum/charflaw/narcoleptic/flaw_on_life(mob/living/carbon/human/user)
	if(user.stat != CONSCIOUS)
		reset_timer()
		return
	if(do_sleep)
		if(next_sleep <= world.time)
			var/pain = user.get_complex_pain()
			if(pain >= 40 && pain_pity_charges > 0)
				pain_pity_charges--
				concious_timer = rand(1 MINUTES, 2 MINUTES)
				to_chat(user, span_warning("The pain keeps me awake..."))
			else
				if(prob(40) || drugged_up)
					drugged_up = FALSE
					concious_timer = rand(4 MINUTES, 6 MINUTES)
					to_chat(user, span_info("The feeling has passed."))
				else
					concious_timer = rand(7 MINUTES, 15 MINUTES)
					to_chat(user, span_boldwarning("I can't keep my eyes open any longer..."))
					user.Sleeping(rand(30 SECONDS, 50 SECONDS))
					user.visible_message(span_warning("[user] suddenly collapses!"))
			do_sleep = FALSE
			last_unconsciousness = world.time
	else
		// Been conscious for ~10 minutes (whatever is the conscious timer)
		if(last_unconsciousness + concious_timer < world.time)
			do_sleep = TRUE
			user.emote("yawn", forced = TRUE)
			next_sleep = world.time + rand(7 SECONDS, 11 SECONDS)
			if(drugged_up)
				to_chat(user, span_blue("The drugs keeps me awake, for now..."))
			else
				to_chat(user, span_blue("I'm getting drowsy..."))

/proc/narcolepsy_drug_up(mob/living/living)
	var/datum/charflaw/narcoleptic/narco = living.get_flaw()
	if (!istype(narco, /datum/charflaw/narcoleptic))
		return
	narco.drugged_up = TRUE

/proc/get_mammons_in_atom(atom/movable/movable)
	var/static/list/coins_types = typecacheof(/obj/item/roguecoin)
	var/mammons = 0
	if(coins_types[movable.type])
		var/obj/item/roguecoin/coin = movable
		mammons += coin.quantity * coin.sellprice
	for(var/atom/movable/content in movable.contents)
		mammons += get_mammons_in_atom(content)
	return mammons

/datum/charflaw/sleepless
	name = "Sleepless"
	desc = "I do not sleep. I cannot sleep. I've tried everything."
	var/drugged_up = FALSE
	var/dream_prob = 1000

/datum/charflaw/sleepless/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_NOSLEEP, TRAIT_GENERIC)

/proc/sleepless_drug_up(mob/living/living)
	var/datum/charflaw/sleepless/sleeper = living.get_flaw()
	if (!istype(sleeper, /datum/charflaw/sleepless))
		return
	sleeper.drugged_up = TRUE

/datum/charflaw/mute
	name = "Mute"
	desc = "I was born without the ability to speak."

/datum/charflaw/mute/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_PERMAMUTE, TRAIT_GENERIC)

/datum/charflaw/critweakness
	name = "Critical Weakness"
	desc = "My body is as fragile as an eggshell. A critical strike is like to end me then and there."

/datum/charflaw/critweakness/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

/datum/charflaw/leprosy
	name = "Leper (+1 TRI)"
	desc = "I am cursed with leprosy! Too poor to afford treatment, my skin now lays violated by lesions, my extremities are numb, and my presence disturbs even the most stalwart men."

/datum/charflaw/leprosy/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	to_chat(user, "I am afflicted. I am outcast and weak. I am a pox on this world.")
	ADD_TRAIT(user, TRAIT_LEPROSY, TRAIT_GENERIC)
	H.change_stat(STATKEY_STR, -1)
	H.change_stat(STATKEY_INT, -1)
	H.change_stat(STATKEY_PER, -1)
	H.change_stat(STATKEY_CON, -1)
	H.change_stat(STATKEY_WIL, -1)
	H.change_stat(STATKEY_SPD, -1)
	H.change_stat(STATKEY_LCK, -1)
	H.adjust_triumphs(1)

/datum/charflaw/mind_broken
	name = "Asundered Mind (+1 TRI)"
	desc = "My mind is asundered, wether it was by own means or an unfortunate accident. Nothing seems real to me... \
	\nWARNING: HALLUCINATIONS MAY JUMPSCARE YOU, AND PREVENT YOU FROM TELLING APART REALITY AND IMAGINATION. \
	FURTHERMORE, THIS DOES NOT EXEMPT YOU FROM ANY RULES SET BY THE SERVER. ESCALATION STILL APPLIES."

/datum/charflaw/mind_broken/apply_post_equipment(mob/living/carbon/human/insane_fool)
	insane_fool.hallucination = INFINITY
	ADD_TRAIT(insane_fool, TRAIT_PSYCHOSIS, TRAIT_GENERIC)
	insane_fool.adjust_triumphs(1)
	if(insane_fool.patron?.type == /datum/patron/divine/abyssor) 
	 insane_fool.grant_language(/datum/language/abyssal)

/datum/charflaw/indebted
	name = "Indebted"
	desc = "Whether by divorce, gambling debts, or wages due, I must pay a sum from my meister every dae. Not doing this will bring about great stress and potentially a bounty."
	var/minimum = 30
	var/relative = 0.2
	var/interval = 30 MINUTES
	var/next_alimony
	var/is_active = FALSE
	var/bounty_added = FALSE

/datum/charflaw/indebted/apply_post_equipment(mob/living/carbon/human/alimony)
	addtimer(CALLBACK(src, PROC_REF(setup_self), alimony), 5 SECONDS)

/datum/charflaw/indebted/proc/setup_self(mob/living/carbon/human/user)
	if(user.mind)
		if(!SStreasury.bank_accounts[user.real_name])
			SStreasury.create_bank_account(user.real_name, minimum)
			is_active = TRUE
			next_alimony = world.time + interval

/datum/charflaw/indebted/flaw_on_life(mob/user)
	. = ..()
	if(is_active)
		if(world.time > next_alimony)
			calculate_childsupport(user)

/datum/charflaw/indebted/proc/calculate_childsupport(mob/deadbeat)
	var/bankamt = SStreasury.bank_accounts[deadbeat]
	var/alimony = minimum
	if(bankamt > minimum)
		if((bankamt * relative) > minimum)
			alimony = round(bankamt * relative)
		SStreasury.give_money_account(-alimony, deadbeat, "Debts")
		next_alimony = world.time + interval
	else
		SStreasury.give_money_account(-bankamt, deadbeat, "Defaulted Debts")
		deadbeat.add_stress(/datum/stressevent/debt)
		if(!bounty_added)
			if(ishuman(deadbeat))
				var/mob/living/carbon/human/H = deadbeat
				var/list/d_list = H.get_mob_descriptors()
				var/height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
				var/body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
				var/voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")
				add_bounty(H.real_name, H.dna.species, H.gender, height, body, voice, rand(100, 200), FALSE, "Failure to pay outstanding debts.", "The Justiciary of Azuria")
			bounty_added = TRUE

/datum/charflaw/averse
	name = "Averse"
	desc = "I hate being around a particular kind of group."
	var/chosen_group
	var/paid_triumphs = FALSE
	var/is_active = FALSE
	var/check_interval = 15 SECONDS
	var/active_since
	var/next_check = 0
	var/check_range = 5

/datum/charflaw/averse/flaw_on_life(mob/user)
	if(is_active && world.time > next_check)
		next_check = world.time + check_interval
		if(user.has_stress_event(/datum/stressevent/averse))
			return
		var/count = 0
		for(var/mob/living/L in get_hearers_in_LOS(check_range, user, RECURSIVE_CONTENTS_CLIENT_MOBS))
			if(check_aversion(user, L))
				count++
				if(count >= 2)
					user.add_stress(/datum/stressevent/averse)
					break
				if(paid_triumphs)
					triumph_refund(user)


/datum/charflaw/averse/proc/check_aversion(mob/user, mob/target)
	if(target == user || target.stat == DEAD)
		return FALSE

	if(!ishuman(target))
		return FALSE

	var/datum/job/J = SSjob.GetJob(target.job)
	if(!J || !J.department_flag)
		return FALSE

	if(!chosen_group)
		return FALSE

	if(chosen_group & J.department_flag)
		return TRUE

	return FALSE

/datum/charflaw/averse/proc/triumph_refund(mob/user)
	var/time_since = world.time - active_since
	var/refund = 0
	switch(time_since)
		if(1 to 30 MINUTES)
			refund = 3
		if(31 MINUTES to 60 MINUTES)
			refund = 2
		if(61 MINUTES to 90 MINUTES)
			refund = 1
		if(91 to 9999 MINUTES)
			refund = 0
	if(refund)
		to_chat(user, span_info("Refunding Triumphs due to vice."))
		user.adjust_triumphs(refund)
	paid_triumphs = FALSE

/datum/charflaw/averse/proc/set_jobflag(faction)
	if(!faction)
		CRASH("Invalid set_jobflag called from Averse charflaw.")
	if(faction in GLOB.averse_factions)
		chosen_group = GLOB.averse_factions[faction]
	else
		CRASH("Invalid set_jobflag called from Averse charflaw using the faction:[faction].")

/datum/charflaw/averse/proc/check_for_candidates(mob/user)
	if(!user || QDELETED(user) || !user.mind)
		return

	var/averse_found = FALSE
	for(var/mob/living/player in GLOB.player_list)
		if(player == user)
			continue
		if(!ishuman(player))
			continue

		var/datum/job/J = SSjob.GetJob(player.job)
		if(!J || !J.department_flag)
			continue
		if(!chosen_group)
			return FALSE

		if(chosen_group & J.department_flag)
			averse_found = TRUE
			break
	if(!averse_found)
		var/list/options = list("Pick a Random Aversion", "Keep Current (-3 TRI)")
		var/choice = input(user, "There are no viable candidates for your Aversion. What do you do?", "AVERSION ALERT") as anything in options
		if(choice == "Keep Current (-3 TRI)" || !choice)
			user.adjust_triumphs(-3)
			paid_triumphs = TRUE
		else if(choice == "Pick a Random Aversion")
			var/new_aversion
			var/max_attempts = 10
			for(var/i = 1 to max_attempts)
				new_aversion = pick(GLOB.averse_factions)
				if(new_aversion != chosen_group)
					to_chat(user, span_info("New Aversion selected: [new_aversion]"))
					set_jobflag(new_aversion)
					break


/datum/charflaw/averse/apply_post_equipment(mob/user)
	if(user.mind)
		if(user.client.prefs?.averse_chosen_faction)
			set_jobflag(user.client.prefs?.averse_chosen_faction)
			is_active = TRUE
			active_since = world.time
	if(is_active && user && !QDELETED(user))
		addtimer(CALLBACK(src, PROC_REF(check_for_candidates), user), 5 SECONDS)



