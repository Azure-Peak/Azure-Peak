
GLOBAL_LIST_INIT(character_flaws, list(
	"Alcoholic"=/datum/charflaw/addiction/alcoholic,
	"Devout Follower"=/datum/charflaw/addiction/godfearing,
	"Colorblind"=/datum/charflaw/colorblind,
	"Smoker"=/datum/charflaw/addiction/smoker,
	"Junkie"=/datum/charflaw/addiction/junkie,
	"Unintelligible"=/datum/charflaw/unintelligible,
	"Greedy"=/datum/charflaw/greedy,
	"Narcoleptic"=/datum/charflaw/narcoleptic,
	"Nymphomaniac"=/datum/charflaw/addiction/lovefiend,
	"Sadist"=/datum/charflaw/addiction/sadist,
	"Masochist"=/datum/charflaw/addiction/masochist,
	"Paranoid"=/datum/charflaw/paranoid,
	"Clingy"=/datum/charflaw/clingy,
	"Isolationist"=/datum/charflaw/isolationist,
	"Bad Sight"=/datum/charflaw/badsight,
	"Cyclops (R)"=/datum/charflaw/noeyer,
	"Cyclops (L)"=/datum/charflaw/noeyel,
	"Blindness"=/datum/charflaw/noeyeall,
	"Wood Arm (R)"=/datum/charflaw/limbloss/arm_r,
	"Wood Arm (L)"=/datum/charflaw/limbloss/arm_l,
	"Sleepless"=/datum/charflaw/sleepless,
	"Mute"=/datum/charflaw/mute,
	"Critical Weakness"=/datum/charflaw/critweakness,
	"Hunted"=/datum/charflaw/hunted,
	"Random or No Flaw"=/datum/charflaw/randflaw,
	"No Flaw (-3 TRIUMPHS)"=/datum/charflaw/noflaw,
	"Leper (+1 TRIUMPHS)"=/datum/charflaw/leprosy,
	))

/datum/charflaw
	var/name
	var/desc
	var/ephemeral = FALSE // This flaw is currently disabled and will not process
	var/roundend_triumph_award = 1	//Awards triumphs round end for those with flaws. Base is 1, no flaw is 0, some punishing flaws are 2.

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
		return
	if(istype(charflaw, flaw))
		return TRUE

/mob/proc/get_flaw()
	return

/mob/living/carbon/human/get_flaw()
	return charflaw

/datum/charflaw/randflaw
	name = "Random or None"
	desc = "A 50% chance to be given a random flaw, or a 50% chance to have NO flaw."

/datum/charflaw/randflaw/apply_post_equipment(mob/user)
	var/mob/living/carbon/human/H = user
	if(prob(50))
		var/flawz = GLOB.character_flaws.Copy()
		var/charflaw = pick_n_take(flawz)
		charflaw = GLOB.character_flaws[charflaw]
		if((charflaw == type) || (charflaw == /datum/charflaw/noflaw))
			charflaw = pick_n_take(flawz)
			charflaw = GLOB.character_flaws[charflaw]
		if((charflaw == type) || (charflaw == /datum/charflaw/noflaw))
			charflaw = pick_n_take(flawz)
			charflaw = GLOB.character_flaws[charflaw]
		H.charflaw = new charflaw()
		H.charflaw.on_mob_creation(H)
	else
		H.charflaw = new /datum/charflaw/eznoflaw()
		H.charflaw.on_mob_creation(H)


/datum/charflaw/eznoflaw
	name = "No Flaw"
	desc = "I'm a normal person, how rare!"
	roundend_triumph_award = 0

/datum/charflaw/noflaw
	name = "No Flaw"
	desc = "I'm a normal person, how rare!"
	roundend_triumph_award = 0
	var/nochekk = TRUE

/datum/charflaw/noflaw/flaw_on_life(mob/user)
	if(!nochekk)
		return

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
	roundend_triumph_award = 2
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

/datum/charflaw/isolationist
	name = "Isolationist"
	desc = "I don't like being near people. They might be trying to do something to me..."
	var/last_check = 0

/datum/charflaw/isolationist/flaw_on_life(mob/user)
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
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

/datum/charflaw/clingy
	name = "Clingy"
	desc = "I like being around people, it's just so lively..."
	var/last_check = 0

/datum/charflaw/clingy/flaw_on_life(mob/user)
	. = ..()
	if(world.time < last_check + 10 SECONDS)
		return
	if(!user)
		return
	last_check = world.time
	var/cnt = 0
	for(var/mob/living/carbon/human/L in hearers(7, user))
		if(L == user)
			continue
		if(L.stat)
			continue
		if(L.dna.species)
			cnt++
		if(cnt > 1)
			break
	var/mob/living/carbon/P = user
	if(cnt < 1)
		P.add_stress(/datum/stressevent/nopeople)

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
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	head?.add_wound(/datum/wound/facial/eyes/left/permanent)
	head?.add_wound(/datum/wound/facial/eyes/right/permanent)
	H.update_fov_angles()

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
	roundend_triumph_award = 2

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
	roundend_triumph_award = 2

/datum/charflaw/mute/on_mob_creation(mob/user)
	ADD_TRAIT(user, TRAIT_PERMAMUTE, TRAIT_GENERIC)

/datum/charflaw/critweakness
	name = "Critical Weakness"
	desc = "My body is as fragile as an eggshell. A critical strike is like to end me then and there."
	roundend_triumph_award = 3

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
