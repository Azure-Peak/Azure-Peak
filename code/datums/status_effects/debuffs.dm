#define PARALYZE_L_ARM 0x1
#define PARALYZE_R_ARM 0x2
#define PARALYZE_L_LEG 0x4
#define PARALYZE_R_LEG 0x8
#define PARALYZE_SUM (PARALYZE_L_ARM | PARALYZE_R_ARM | PARALYZE_L_LEG | PARALYZE_R_LEG)

//Largely negative status effects go here, even if they have small benificial effects
//STUN EFFECTS
/datum/status_effect/incapacitating
	tick_interval = 0
	status_type = STATUS_EFFECT_REPLACE
	alert_type = null
	var/needs_update_stat = FALSE

/datum/status_effect/incapacitating/on_creation(mob/living/new_owner, set_duration, updating_canmove)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()
	if(.)
		if(updating_canmove)
			owner.update_mobility()
			if(needs_update_stat)
				owner.update_stat()

/datum/status_effect/incapacitating/on_remove()
	if(owner)
		owner.update_mobility()
		if(needs_update_stat) //silicons need stat updates in addition to normal canmove updates
			owner.update_stat()

//STUN
/datum/status_effect/incapacitating/stun
	id = "stun"
	alert_type = /atom/movable/screen/alert/status_effect/stun

/atom/movable/screen/alert/status_effect/stun
	name = "Stunned"
	desc = ""
	icon_state = "stun"

//KNOCKDOWN
/datum/status_effect/incapacitating/knockdown
	id = "knockdown"
	alert_type = /atom/movable/screen/alert/status_effect/knocked_down

/atom/movable/screen/alert/status_effect/knocked_down
	name = "Knocked Down"
	desc = ""
	icon_state = "knockdown"

//IMMOBILIZED
/datum/status_effect/incapacitating/immobilized
	id = "immobilized"
	alert_type = /atom/movable/screen/alert/status_effect/immobilized
	mob_effect_icon = 'icons/mob/mob_effects.dmi'
	mob_effect_icon_state = "eff_immobilized"
	mob_effect_offset_x = 3

/atom/movable/screen/alert/status_effect/immobilized
	name = "Immobilized"
	desc = ""
	icon_state = "immob"

/datum/status_effect/incapacitating/paralyzed
	id = "paralyzed"
	alert_type = /atom/movable/screen/alert/status_effect/paralyzed

/atom/movable/screen/alert/status_effect/paralyzed
	name = "Paralyzed"
	desc = ""
	icon_state = "paralyze"

//UNCONSCIOUS
/datum/status_effect/incapacitating/unconscious
	id = "unconscious"
	needs_update_stat = TRUE

/datum/status_effect/incapacitating/unconscious/tick()
	if(owner.getStaminaLoss())
		owner.adjustStaminaLoss(-0.3) //reduce stamina loss by 0.3 per tick, 6 per 2 seconds

//SLEEPING
/datum/status_effect/incapacitating/sleeping
	id = "sleeping"
	alert_type = /atom/movable/screen/alert/status_effect/asleep
	needs_update_stat = TRUE
	var/mob/living/carbon/carbon_owner
	var/mob/living/carbon/human/human_owner
	var/sleptonground = FALSE

/datum/status_effect/incapacitating/sleeping/on_creation(mob/living/new_owner, updating_canmove)
	. = ..()
	if(.)
		if(owner.cmode)
			owner.cmode = 0
		SSdroning.kill_droning(owner.client)
		SSdroning.kill_loop(owner.client)
		SSdroning.kill_rain(owner.client)
		owner.clear_typing_indicator()
		if(iscarbon(owner)) //to avoid repeated istypes
			carbon_owner = owner
		if(ishuman(owner))
			human_owner = owner

/datum/status_effect/incapacitating/sleeping/on_remove()
	if(ishuman(owner))
		SSdroning.play_area_sound(get_area(src), owner.client)
		SSdroning.play_loop(get_area(src), owner.client)
	. = ..()

/datum/status_effect/incapacitating/sleeping/Destroy()
	carbon_owner = null
	human_owner = null
	return ..()

/datum/status_effect/incapacitating/sleeping/tick()
	if(owner.maxHealth)
		var/health_ratio = owner.health / owner.maxHealth
		var/healing = -0.2
		if((locate(/obj/structure/bed) in owner.loc))
			healing -= 0.3
		else if((locate(/obj/structure/table) in owner.loc))
			healing -= 0.1
		for(var/obj/item/bedsheet/bedsheet in range(owner.loc,0))
			if(bedsheet.loc != owner.loc) //bedsheets in my backpack/neck don't give you comfort
				continue
			healing -= 0.1
			break //Only count the first bedsheet
		if(health_ratio > 0.8)
			owner.adjustToxLoss(healing * 0.5, FALSE, TRUE)
		owner.adjustStaminaLoss(healing)
	if(human_owner && human_owner.drunkenness)
		human_owner.drunkenness *= 0.997 //reduce drunkenness by 0.3% per tick, 6% per 2 seconds
	if(prob(20))
		if(carbon_owner)
			carbon_owner.handle_dreams()
			if(prob(10) && owner.health > owner.crit_threshold)
				owner.emote("snore")

/atom/movable/screen/alert/status_effect/asleep
	name = "Asleep"
	desc = ""
	icon_state = "asleep"

//STASIS
/datum/status_effect/incapacitating/stasis
		id = "stasis"
		duration = -1
		tick_interval = 10
		alert_type = /atom/movable/screen/alert/status_effect/stasis
		var/last_dead_time

/datum/status_effect/incapacitating/stasis/proc/update_time_of_death()
		if(last_dead_time)
				var/delta = world.time - last_dead_time
				var/new_timeofdeath = owner.timeofdeath + delta
				owner.timeofdeath = new_timeofdeath
				owner.tod = station_time_timestamp(wtime=new_timeofdeath)
				last_dead_time = null
		if(owner.stat == DEAD)
				last_dead_time = world.time

/datum/status_effect/incapacitating/stasis/on_creation(mob/living/new_owner, set_duration, updating_canmove)
		. = ..()
		update_time_of_death()
		owner.reagents?.end_metabolization(owner, FALSE)

/datum/status_effect/incapacitating/stasis/tick()
		update_time_of_death()

/datum/status_effect/incapacitating/stasis/on_remove()
		update_time_of_death()
		return ..()

/datum/status_effect/incapacitating/stasis/be_replaced()
		update_time_of_death()
		return ..()

/atom/movable/screen/alert/status_effect/stasis
		name = "Stasis"
		desc = ""
		icon_state = "stasis"

//GOLEM GANG

//OTHER DEBUFFS
/datum/status_effect/strandling //get it, strand as in durathread strand + strangling = strandling hahahahahahahahahahhahahaha i want to die
	id = "strandling"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/strandling

/datum/status_effect/strandling/on_apply()
	ADD_TRAIT(owner, TRAIT_MAGIC_CHOKE, "dumbmoron")
	return ..()

/datum/status_effect/strandling/on_remove()
	REMOVE_TRAIT(owner, TRAIT_MAGIC_CHOKE, "dumbmoron")
	return ..()

/atom/movable/screen/alert/status_effect/strandling
	name = "Choking strand"
	desc = ""
	icon_state = "his_grace"
	alerttooltipstyle = "hisgrace"

/atom/movable/screen/alert/status_effect/strandling/Click(location, control, params)
	. = ..()
	to_chat(mob_viewer, "<span class='notice'>I attempt to remove the durathread strand from around my neck.</span>")
	if(do_after(mob_viewer, 35, null, mob_viewer))
		if(isliving(mob_viewer))
			var/mob/living/L = mob_viewer
			to_chat(mob_viewer, "<span class='notice'>I succesfuly remove the durathread strand.</span>")
			L.remove_status_effect(STATUS_EFFECT_CHOKINGSTRAND)


/datum/status_effect/pacify/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()

/datum/status_effect/pacify/on_apply()
	ADD_TRAIT(owner, TRAIT_PACIFISM, "status_effect")
	return ..()

/datum/status_effect/pacify/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "status_effect")

//OTHER DEBUFFS
/datum/status_effect/pacify
	id = "pacify"
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 1
	duration = 100
	alert_type = null

/datum/status_effect/pacify/on_creation(mob/living/new_owner, set_duration)
	if(isnum(set_duration))
		duration = set_duration
	. = ..()

/datum/status_effect/pacify/on_apply()
	ADD_TRAIT(owner, TRAIT_PACIFISM, "status_effect")
	return ..()

/datum/status_effect/pacify/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "status_effect")

/datum/status_effect/stacking/saw_bleed
	id = "saw_bleed"
	tick_interval = 6
	delay_before_decay = 5
	stack_threshold = 10
	max_stacks = 10
	overlay_file = 'icons/effects/bleed.dmi'
	underlay_file = 'icons/effects/bleed.dmi'
	overlay_state = "bleed"
	underlay_state = "bleed"
	var/bleed_damage = 200

/datum/status_effect/stacking/saw_bleed/fadeout_effect()
	new /obj/effect/temp_visual/bleed(get_turf(owner))

/datum/status_effect/stacking/saw_bleed/threshold_cross_effect()
	owner.adjustBruteLoss(bleed_damage)
	var/turf/T = get_turf(owner)
	new /obj/effect/temp_visual/bleed/explode(T)
	for(var/d in GLOB.alldirs)
		new /obj/effect/temp_visual/dir_setting/bloodsplatter(T, d)
	playsound(T, "desceration", 100, TRUE, -1)

/datum/status_effect/neck_slice
	id = "neck_slice"
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = null
	duration = -1

/datum/status_effect/neck_slice/tick()
	var/mob/living/carbon/human/H = owner
	if(H.stat == DEAD || H.bleed_rate <= 8)
		H.remove_status_effect(/datum/status_effect/neck_slice)
	if(prob(10))
		H.emote(pick("gasp", "gag", "choke"))

/obj/effect/temp_visual/curse
	icon_state = "curse"

/datum/status_effect/gonbolaPacify
	id = "gonbolaPacify"
	status_type = STATUS_EFFECT_MULTIPLE
	tick_interval = -1
	alert_type = null

/datum/status_effect/gonbolaPacify/on_apply()
	ADD_TRAIT(owner, TRAIT_PACIFISM, "gonbolaPacify")
	ADD_TRAIT(owner, TRAIT_MUTE, "gonbolaMute")
	ADD_TRAIT(owner, TRAIT_JOLLY, "gonbolaJolly")
	to_chat(owner, "<span class='notice'>I suddenly feel at peace and feel no need to make any sudden or rash actions...</span>")
	return ..()

/datum/status_effect/gonbolaPacify/on_remove()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, "gonbolaPacify")
	REMOVE_TRAIT(owner, TRAIT_MUTE, "gonbolaMute")
	REMOVE_TRAIT(owner, TRAIT_JOLLY, "gonbolaJolly")

/datum/status_effect/trance
	id = "trance"
	status_type = STATUS_EFFECT_UNIQUE
	duration = 300
	tick_interval = 10
	examine_text = "<span class='warning'>SUBJECTPRONOUN seems slow and unfocused.</span>"
	var/stun = TRUE
	alert_type = /atom/movable/screen/alert/status_effect/trance

/atom/movable/screen/alert/status_effect/trance
	name = "Trance"
	desc = ""
	icon_state = "high"

/datum/status_effect/trance/tick()
	if(stun)
		owner.Stun(60, TRUE, TRUE)
	owner.dizziness = 20

/datum/status_effect/trance/on_apply()
	if(!iscarbon(owner))
		return FALSE
	RegisterSignal(owner, COMSIG_MOVABLE_HEAR, PROC_REF(hypnotize))
	ADD_TRAIT(owner, TRAIT_MUTE, "trance")
	owner.add_client_colour(/datum/client_colour/monochrome/trance)
	owner.visible_message("[stun ? "<span class='warning'>[owner] stands still as [owner.p_their()] eyes seem to focus on a distant point.</span>" : ""]", \
	"<span class='warning'>[pick("You feel my thoughts slow down...", "You suddenly feel extremely dizzy...", "You feel like you're in the middle of a dream...","You feel incredibly relaxed...")]</span>")
	return TRUE

/datum/status_effect/trance/on_creation(mob/living/new_owner, _duration, _stun = TRUE)
	duration = _duration
	stun = _stun
	return ..()

/datum/status_effect/trance/on_remove()
	UnregisterSignal(owner, COMSIG_MOVABLE_HEAR)
	REMOVE_TRAIT(owner, TRAIT_MUTE, "trance")
	owner.dizziness = 0
	owner.remove_client_colour(/datum/client_colour/monochrome/trance)
	to_chat(owner, "<span class='warning'>I snap out of my trance!</span>")

/datum/status_effect/trance/proc/hypnotize(datum/source, list/hearing_args)
	if(!owner.can_hear())
		return
	if(hearing_args[HEARING_SPEAKER] == owner)
		return
	var/mob/living/carbon/C = owner
	C.cure_trauma_type(/datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY) //clear previous hypnosis
	addtimer(CALLBACK(C, TYPE_PROC_REF(/mob/living/carbon, gain_trauma), /datum/brain_trauma/hypnosis, TRAUMA_RESILIENCE_SURGERY, hearing_args[HEARING_RAW_MESSAGE]), 10)
	addtimer(CALLBACK(C, TYPE_PROC_REF(/mob/living, Stun), 60, TRUE, TRUE), 15) //Take some time to think about it
	qdel(src)

/datum/status_effect/spasms
	id = "spasms"
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null

/datum/status_effect/spasms/tick()
	if(prob(15))
		switch(rand(1,5))
			if(1)
				if((owner.mobility_flags & MOBILITY_MOVE) && isturf(owner.loc))
					to_chat(owner, "<span class='warning'>My leg spasms!</span>")
					step(owner, pick(GLOB.cardinals))
			if(2)
				if(owner.incapacitated())
					return
				var/obj/item/I = owner.get_active_held_item()
				if(I)
					to_chat(owner, "<span class='warning'>My fingers spasm!</span>")
					owner.log_message("used [I] due to a Muscle Spasm", LOG_ATTACK)
					I.attack_self(owner)
			if(3)
				var/prev_intent = owner.a_intent
				owner.a_intent = INTENT_HARM

				var/range = 1
				if(istype(owner.get_active_held_item(), /obj/item/gun)) //get targets to shoot at
					range = 7

				var/list/mob/living/targets = list()
				for(var/mob/M in oview(owner, range))
					if(isliving(M))
						targets += M
				if(LAZYLEN(targets))
					to_chat(owner, "<span class='warning'>My arm spasms!</span>")
					owner.log_message(" attacked someone due to a Muscle Spasm", LOG_ATTACK) //the following attack will log itself
					owner.ClickOn(pick(targets))
				owner.a_intent = prev_intent
			if(4)
				var/prev_intent = owner.a_intent
				owner.a_intent = INTENT_HARM
				to_chat(owner, "<span class='warning'>My arm spasms!</span>")
				owner.log_message("attacked [owner.p_them()]self to a Muscle Spasm", LOG_ATTACK)
				owner.ClickOn(owner)
				owner.a_intent = prev_intent
			if(5)
				if(owner.incapacitated())
					return
				var/obj/item/I = owner.get_active_held_item()
				var/list/turf/targets = list()
				for(var/turf/T in oview(owner, 3))
					targets += T
				if(LAZYLEN(targets) && I)
					to_chat(owner, "<span class='warning'>My arm spasms!</span>")
					owner.log_message("threw [I] due to a Muscle Spasm", LOG_ATTACK)
					owner.throw_item(pick(targets))

/datum/status_effect/go_away
	id = "go_away"
	duration = 100
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 1
	alert_type = /atom/movable/screen/alert/status_effect/go_away
	var/direction

/datum/status_effect/go_away/on_creation(mob/living/new_owner, set_duration, updating_canmove)
	. = ..()
	direction = pick(NORTH, SOUTH, EAST, WEST)
	new_owner.setDir(direction)

/datum/status_effect/go_away/tick()
	owner.AdjustStun(1, ignore_canstun = TRUE)
	var/turf/T = get_step(owner, direction)
	owner.forceMove(T)

/atom/movable/screen/alert/status_effect/go_away
	name = "TO THE STARS AND BEYOND!"
	desc = ""
	icon_state = "high"

/datum/status_effect/fake_virus
	id = "fake_virus"
	duration = 1800//3 minutes
	status_type = STATUS_EFFECT_REPLACE
	tick_interval = 1
	alert_type = null
	var/msg_stage = 0//so you dont get the most intense messages immediately

/datum/status_effect/fake_virus/tick()
	var/fake_msg = ""
	var/fake_emote = ""
	switch(msg_stage)
		if(0 to 300)
			if(prob(1))
				fake_msg = pick("<span class='warning'>[pick("Your head hurts.", "Your head pounds.")]</span>",
				"<span class='warning'>[pick("You're having difficulty breathing.", "Your breathing becomes heavy.")]</span>",
				"<span class='warning'>[pick("You feel dizzy.", "Your head spins.")]</span>",
				"<span notice='warning'>[pick("You swallow excess mucus.", "You lightly cough.")]</span>",
				"<span class='warning'>[pick("Your head hurts.", "Your mind blanks for a moment.")]</span>",
				"<span class='warning'>[pick("Your throat hurts.", "You clear my throat.")]</span>")
		if(301 to 600)
			if(prob(2))
				fake_msg = pick("<span class='warning'>[pick("Your head hurts a lot.", "Your head pounds incessantly.")]</span>",
				"<span class='warning'>[pick("Your windpipe feels like a straw.", "Your breathing becomes tremendously difficult.")]</span>",
				"<span class='warning'>I feel very [pick("dizzy","woozy","faint")].</span>",
				"<span class='warning'>[pick("You hear a ringing in my ear.", "Your ears pop.")]</span>",
				"<span class='warning'>I nod off for a moment.</span>")
		else
			if(prob(3))
				if(prob(50))// coin flip to throw a message or an emote
					fake_msg = pick("<span class='danger'>[pick("Your head hurts!", "You feel a burning knife inside my brain!", "A wave of pain fills my head!")]</span>",
					"<span class='danger'>[pick("Your lungs hurt!", "It hurts to breathe!")]</span>",
					"<span class='warning'>[pick("You feel nauseated.", "You feel like you're going to throw up!")]</span>")
				else
					fake_emote = pick("cough", "sniff", "sneeze")

	if(fake_emote)
		owner.emote(fake_emote)
	else if(fake_msg)
		to_chat(owner, fake_msg)

	msg_stage++

// Magical mishaps
// Victim loses common, their default language, or a random language (in order of preference) for the duration
/atom/movable/screen/alert/status_effect/mishap_langloss
	name = "Forgotten Tongue"
	desc = "I can't remember how to speak in-- what was the language even called, again..?"
	icon_state = "mind_control"
	var/removed_language = null

/datum/status_effect/debuff/mishap_langloss
	id = "language_loss"
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/mishap_langloss
	var/datum/language/removed_language

/datum/status_effect/debuff/mishap_langloss/on_apply()
	. = ..()
	var/datum/language_holder/holder = owner.mind?.language_holder
	if (holder)
		if (owner.has_language(/datum/language/common))
			// Always remove common, if the character has it
			removed_language = /datum/language/common
		else if (holder.selected_default_language != /datum/language/common)
			// Otherwise, remove their default language, if one is defined
			removed_language = holder.selected_default_language
		else
			// And if there's no default language, remove a random language
			removed_language = holder.get_random_understood_language()

		if (removed_language == /datum/language/aphasia)
			return

		// If we haven't selected a language by this point there's probably no language to select
		if (removed_language)
			owner.remove_language(removed_language)


/datum/status_effect/debuff/mishap_langloss/on_remove()
	..()
	if (removed_language)
		owner.grant_language(removed_language)


// Reduces intelligence by 20 (!!) and removes all languages except Aphasia for the duration.
/atom/movable/screen/alert/status_effect/mishap_feeblemind
	name = "Feebleminded"
	desc = "Wuh-- uh..."
	icon_state = "mind_control"

/datum/status_effect/debuff/mishap_feeblemind
	id = "feeblemind"
	duration = 7 MINUTES // This effect is really nasty but is deliberately one of the worst mishap effects, so it has a fairly long duration.
	status_type = STATUS_EFFECT_REFRESH
	// Won't necessarily force intelligence to 1, if we're really smart and have buffs
	effectedstats = list("intelligence" = -20, "speed" = -5)
	alert_type = /atom/movable/screen/alert/status_effect/mishap_feeblemind
	var/datum/language_holder/owner_language_holder
	var/datum/language_holder/old_languages

/datum/status_effect/debuff/mishap_feeblemind/on_apply()
	. = ..()
	owner_language_holder = owner.get_language_holder()
	old_languages = owner_language_holder.copy()
	owner_language_holder.remove_all_languages()
	owner.language_holder.grant_language(/datum/language/aphasia)
	ADD_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, id)

/datum/status_effect/debuff/mishap_feeblemind/tick()
	..()
	if (prob(5))
		owner.emote(pick("drools", "stares blankly"))

/datum/status_effect/debuff/mishap_feeblemind/on_remove()
	..()
	owner_language_holder.remove_language(/datum/language/aphasia)
	owner_language_holder.copy_known_languages_from(old_languages)
	REMOVE_TRAIT(owner, TRAIT_SPELLCOCKBLOCK, id)

// Functions as Nimrod, but a bit worse, for the duration, and enforces simple speech.
/atom/movable/screen/alert/status_effect/mishap_dimwitted
	name = "Dim-witted"
	desc = "My thoughts are so slow..."
	icon_state = "mind_control"

/datum/status_effect/debuff/mishap_dimwitted
	id = "dimwitted"
	duration = 10 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	effectedstats = list("intelligence" = -6, "speed" = -3) // 50% worse than the Nimrod special at the time of implementation (for 10 minutes)
	alert_type = /atom/movable/screen/alert/status_effect/mishap_dimwitted

/datum/status_effect/debuff/mishap_dimwitted/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_SIMPLESPEECH, id)

/datum/status_effect/debuff/mishap_dimwitted/on_remove()
	..()
	REMOVE_TRAIT(owner, TRAIT_SIMPLESPEECH, id)

// Reduces some stats, applies a high overlay, increases slurring by 10 and keeps slurring at a minimum of 10.
/atom/movable/screen/alert/status_effect/mishap_arcane_high
	name = "Arcyne High"
	desc = ""
	icon_state = "high"

/datum/status_effect/debuff/mishap_arcane_high
	id = "arcane_high"
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	effectedstats = list("intelligence" = -4, "perception" = -4)
	alert_type = /atom/movable/screen/alert/status_effect/mishap_arcane_high

/datum/status_effect/debuff/mishap_arcane_high/on_apply()
	. = ..()
	owner.slurring += 10
	ADD_TRAIT(owner, TRAIT_DRUQK, id)
	owner.overlay_fullscreen("arcane_high", /atom/movable/screen/fullscreen/druqks)
	if (owner.client)
		SSdroning.area_entered(get_area(owner), owner.client)

/datum/status_effect/debuff/mishap_arcane_high/tick()
	..()
	owner.slurring = max(owner.slurring, 10)
	if (prob(5))
		owner.emote(pick("giggle", "drools", "grins", "fidgets", "twitch_s"))

/datum/status_effect/debuff/mishap_arcane_high/on_remove()
	..()
	owner.slurring = max(owner.slurring - 10, 0)
	REMOVE_TRAIT(owner, TRAIT_DRUQK, id)
	owner.clear_fullscreen("arcane_high")
	if (owner.client)
		SSdroning.play_area_sound(get_area(owner), owner.client)

// Increases drunkenness by 50. Prevents drunkenness from falling below 50.
/atom/movable/screen/alert/status_effect/mishap_arcane_drunkenness
	name = "Arcyne Drunkenness"
	desc = "I feel so drunk... But I haven't been drinking! Hah..."
	icon_state = "drunk"

/datum/status_effect/debuff/mishap_arcane_drunkenness
	id = "arcane_drunk"
	duration = 10 MINUTES // Drunkenness we add is forcibly removed on expiry
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/mishap_arcane_drunkenness
	var/mob/living/carbon/human/human_owner
	var/const/drunk_amount = 50

/datum/status_effect/debuff/mishap_arcane_drunkenness/on_apply()
	. = ..()
	if (ishuman(owner))
		human_owner = owner
		human_owner.drunkenness += drunk_amount

/datum/status_effect/debuff/mishap_arcane_drunkenness/tick()
	..()
	if (human_owner)
		human_owner.drunkenness = max(human_owner.drunkenness, drunk_amount)

/datum/status_effect/debuff/mishap_arcane_drunkenness/on_remove()
	..()
	if (human_owner)
		human_owner.drunkenness = max(human_owner.drunkenness - drunk_amount, 0)
		if (human_owner.drunkenness <= 0)
			human_owner.remove_status_effect(/datum/status_effect/buff/drunk)

// On application, each limb has a 50% chance of being paralyzed.
// At least one limb is guaranteed to be paralyzed.
/atom/movable/screen/alert/status_effect/mishap_arcane_paralysis
	name = "Arcyne Paralysis"
	desc = "I can't move parts of my body..."
	icon_state = "paralyze"

/datum/status_effect/debuff/mishap_arcane_paralysis
	id = "arcane_paralysis"
	duration = 2 MINUTES // Nasty effect, let's not have it last as long as the others.
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/mishap_arcane_paralysis
	var/list/traits_added = list()
	var/list/bodyparts_disabled = list()

/datum/status_effect/debuff/mishap_arcane_paralysis/on_apply()
	. = ..()
	var/limbs = rand(1, PARALYZE_SUM) // To be used as bits, NOT a meaningful integer value
	// This method ensures our limbs are chosen randomly,
	// that all limbs have a 50% chance of being paralyzed,
	// and at least one limb is guaranteed to be paralyzed
	if (limbs & PARALYZE_L_ARM)
		ADD_TRAIT(owner, TRAIT_PARALYSIS_L_ARM, id)
		traits_added.Add(TRAIT_PARALYSIS_L_ARM)
		bodyparts_disabled.Add(BODY_ZONE_L_ARM)
	if (limbs & PARALYZE_R_ARM)
		ADD_TRAIT(owner, TRAIT_PARALYSIS_R_ARM, id)
		traits_added.Add(TRAIT_PARALYSIS_R_ARM)
		bodyparts_disabled.Add(BODY_ZONE_R_ARM)
	if (limbs & PARALYZE_L_LEG)
		ADD_TRAIT(owner, TRAIT_PARALYSIS_L_LEG, id)
		traits_added.Add(TRAIT_PARALYSIS_L_LEG)
		bodyparts_disabled.Add(BODY_ZONE_L_LEG)
	if (limbs & PARALYZE_R_LEG)
		ADD_TRAIT(owner, TRAIT_PARALYSIS_R_LEG, id)
		traits_added.Add(TRAIT_PARALYSIS_R_LEG)
		bodyparts_disabled.Add(BODY_ZONE_R_LEG)

	for (var/bp in bodyparts_disabled)
		var/obj/item/bodypart/bodypart = owner.get_bodypart(bp)
		if (bodypart && bodypart.can_disable())
			bodypart.update_disabled()

/datum/status_effect/debuff/mishap_arcane_paralysis/on_remove()
	..()
	for (var/trait in traits_added)
		REMOVE_TRAIT(owner, trait, id)

	for (var/part in bodyparts_disabled)
		var/obj/item/bodypart/bodypart = owner.get_bodypart(part)
		if (bodypart && bodypart.can_disable() && bodypart.disabled == BODYPART_DISABLED_PARALYSIS)
			bodypart.update_disabled()

// Makes the victim blind... Obviously
/atom/movable/screen/alert/status_effect/mishap_blindness
	name = "Arcyne Blindness"
	desc = "Arcyne darkness clouds my eyes!"
	icon_state = "blind"

/datum/status_effect/debuff/mishap_blindness
	id = "arcane_blindness"
	duration = 2 MINUTES // Another nasty effect - victim will need to be led around until it expires.
	status_type = STATUS_EFFECT_REFRESH
	effectedstats = list("perception" = -100) // Blind, can't see
	alert_type = /atom/movable/screen/alert/status_effect/mishap_blindness
	var/const/blindness_amount = 20 // 20 should be plenty to keep the victim blind between tick()s

/datum/status_effect/debuff/mishap_blindness/on_apply()
	. = ..()
	owner.adjust_blindness(blindness_amount)

/datum/status_effect/debuff/mishap_blindness/tick()
	..()
	owner.set_blindness(max(owner.eye_blind, blindness_amount))

/datum/status_effect/debuff/mishap_blindness/on_remove()
	..()
	owner.adjust_blindness(-blindness_amount)

// Keep putting the user to sleep for the duration.
/atom/movable/screen/alert/status_effect/mishap_sleepy
	name = "Arcyne Sleep"
	desc = "I can't keep myself awake..."
	icon_state = "hypnosis"

/datum/status_effect/debuff/mishap_sleepy
	id = "arcane_sleep"
	duration = 15 SECONDS // Sleep amount is 60 seconds, so effectively ~75 seconds. User is completely incapacitated so this shouldn't be too long.
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/mishap_sleepy
	var/const/sleeping_amount = 60 SECONDS

/datum/status_effect/debuff/mishap_sleepy/on_apply()
	. = ..()
	owner.eyesclosed = TRUE
	for(var/atom/movable/screen/eye_intent/eyet in owner.hud_used.static_inventory)
		eyet.update_icon(owner)
	owner.become_blind("eyelids")
	owner.Sleeping(sleeping_amount)

/datum/status_effect/debuff/mishap_sleepy/tick()
	..()
	owner.Sleeping(sleeping_amount)

// Makes the victim confused for 5 minutes
/atom/movable/screen/alert/status_effect/mishap_confused
	name = "Arcyne Confusion"
	desc = "Where-- where am I..?"
	icon_state = "mind_control"

/datum/status_effect/debuff/mishap_confused
	id = "arcane_confusion"
	duration = 5 MINUTES
	status_type = STATUS_EFFECT_REFRESH
	alert_type = /atom/movable/screen/alert/status_effect/mishap_confused
	var/const/confusion_amount = 15

/datum/status_effect/debuff/mishap_confused/on_apply()
	. = ..()
	owner.confused += confusion_amount

/datum/status_effect/debuff/mishap_confused/tick()
	owner.confused = max(owner.confused, confusion_amount)
	if (prob(5))
		owner.emote(pick("babbles", "murmurs", "stares", "frowns"))
	..()

/datum/status_effect/debuff/mishap_confused/on_remove()
	owner.confused = max(owner.confused - confusion_amount, 0)
	..()

/datum/status_effect/debuff/baited
	id = "bait"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/baited
	duration = 20 SECONDS

/atom/movable/screen/alert/status_effect/debuff/baited
	name = "Baited"
	desc = "I fell for it. I'm exposed. I won't fall for it again. For now."
	icon_state = "bait"

/atom/movable/screen/alert/status_effect/debuff/baitedcd
	name = "Bait Cooldown"
	desc = "I used it. I must wait."
	icon_state = "baitcd"

/datum/status_effect/debuff/baitcd
	id = "baitcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/baitedcd
	duration = 30 SECONDS

/datum/status_effect/debuff/baitcd/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()
	

/atom/movable/screen/alert/status_effect/debuff/feintcd
	name = "Feint Cool down"
	desc = "I used it. I must wait, or risk a lower chance of success."
	icon_state = "feintcd"

/atom/movable/screen/alert/status_effect/debuff/feinted
	name = "Feinted"
	desc = "I've been feinted. It won't happen again so soon."
	icon_state = "feinted"


/atom/movable/screen/alert/status_effect/debuff/clashcd
	name = "Riposte / Guard Cooldown"
	desc = "I used it. I must wait."
	icon_state = "guardcd"

/datum/status_effect/debuff/strikecd
	id = "strikecd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/precisestrikecd
	duration = 30 SECONDS

/atom/movable/screen/alert/status_effect/debuff/precisestrikecd
	name = "Precise Strike Cooldown"
	desc = "I used it. I must wait."
	icon_state = "strikecd"

/datum/status_effect/debuff/clashcd
	id = "clashcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/clashcd
	duration = 30 SECONDS

/datum/status_effect/debuff/clashcd/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()

/datum/status_effect/debuff/specialcd
	id = "specialcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/specialcd
	duration = 30 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

/datum/status_effect/debuff/specialcd/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()

/atom/movable/screen/alert/status_effect/debuff/specialcd
	name = "Special Manouevre Cooldown"
	desc = "I used it. I must wait."
	icon_state = "strikecd"

/atom/movable/screen/alert/status_effect/debuff/exposed
	name = "Exposed"
	desc = "My defenses are exposed. I can be hit through my parry and dodge!"
	icon_state = "exposed"

/datum/status_effect/debuff/exposed
	id = "nofeint"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/exposed
	duration = 10 SECONDS
	mob_effect_icon = 'icons/mob/mob_effects.dmi'
	mob_effect_icon_state = "eff_exposed"
	mob_effect_layer = MOB_EFFECT_LAYER_EXPOSED

/datum/status_effect/debuff/exposed/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()

/datum/status_effect/debuff/feintcd
	id = "feintcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/feintcd
	duration = 30 SECONDS

/datum/status_effect/debuff/feintcd/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()

/datum/status_effect/debuff/feinted
	id = "feinted"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/feinted
	mob_effect_icon = 'icons/mob/mob_effects.dmi'
	mob_effect_icon_state = "eff_feinted"
	mob_effect_offset_y = 10
	mob_effect_layer = MOB_EFFECT_LAYER_FEINTED
	duration = 30 SECONDS

/datum/status_effect/debuff/feinted/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()

//Unused
/datum/status_effect/debuff/riposted
	id = "riposted"
	duration = 3 SECONDS

/datum/status_effect/debuff/clickcd
	id = "clickcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/clickcd
	duration = 3 SECONDS

/datum/status_effect/debuff/clickcd/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	new_owner.changeNext_move(duration)
	return ..()

/atom/movable/screen/alert/status_effect/debuff/clickcd
	name = "Action Delayed"
	desc = "I cannot take another action."
	icon_state = "clickcd"

/datum/status_effect/debuff/crit_resistance_cd
	id = "crit_resist_cd"
	duration = CRIT_RESISTANCE_TIMER_CD
	alert_type = /atom/movable/screen/alert/status_effect/debuff/crit_resistance_cd
	var/my_stack = 1 // How many time it was triggered. Default to 1 because this is only created when it triggers

// Helper, call this everytime you try to crit
/datum/status_effect/debuff/crit_resistance_cd/proc/try_crit()
	my_stack++
	if(!owner) // wtf
		return TRUE
	if(owner.stat) // Dead / Unconscious
		return TRUE
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		if(NOBLOOD in C.dna?.species?.species_traits)
			return (my_stack > CRIT_RESISTANCE_STACKS_OP)
	if(isdullahan(owner))
		return (my_stack > CRIT_RESISTANCE_STACKS_OP)
	if(!owner.mind)
		return (my_stack > CRIT_RESISTANCE_STACKS_NPC)
	return (my_stack > CRIT_RESISTANCE_STACKS_PLAYER)

/atom/movable/screen/alert/status_effect/debuff/crit_resistance_cd
	name = "Critical Resistance"
	desc = "My body is temporarily resisting critical wounds."
	icon_state = "debuff"

/datum/status_effect/debuff/yeetcd
	id = "yeetcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/yeetcd
	duration = 5 SECONDS

/atom/movable/screen/alert/status_effect/debuff/yeetcd
	name = "Knockback Cooldown"
	desc = "I have been knocked back recently by an attack and cannot be knocked back again"
	icon_state = "debuff" // Placeholder

/datum/status_effect/debuff/specialcd
	id = "specialcd"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/specialcd
	duration = 2 SECONDS

/datum/status_effect/debuff/specialcd/on_creation(mob/living/new_owner, new_dur)
	if(new_dur)
		duration = new_dur
	return ..()

/atom/movable/screen/alert/status_effect/debuff/specialcd
	name = "Special Maneuvre Cooldown"
	desc = "I used it. I must wait."
	icon_state = "strikecd"

#undef PARALYZE_L_ARM
#undef PARALYZE_R_ARM
#undef PARALYZE_L_LEG
#undef PARALYZE_R_LEG
#undef PARALYZE_SUM
