/obj/item/organ/tongue
	name = "tongue"
	desc = ""
	icon_state = "tonguenormal"
	zone = BODY_ZONE_PRECISE_MOUTH
	slot = ORGAN_SLOT_TONGUE
	attack_verb = list("licked", "slobbered", "slapped", "frenched", "tongued")
	var/list/languages_possible
	var/say_mod = null
	var/taste_sensitivity = 15 // lower is more sensitive.
	var/modifies_speech = FALSE
	var/list/emote_verbs
	var/static/list/languages_possible_base = typecacheof(list(
		/datum/language/common,
		/datum/language/dwarvish,
		/datum/language/elvish,
		/datum/language/celestial,
		/datum/language/raneshi,
		/datum/language/hellspeak,
		/datum/language/beast,
		/datum/language/orcish,
		/datum/language/draconic,
		/datum/language/tricksterscant,
		/datum/language/thievescant,
		/datum/language/grenzelhoftian,
		/datum/language/kazengunese,
		/datum/language/lingyuese,
		/datum/language/otavan,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/aavnic,
		/datum/language/undead,
		/datum/language/abyssal,
		/datum/language/oldazurian,
		/datum/language/undercommon
	))

/obj/item/organ/tongue/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_base

/obj/item/organ/tongue/proc/handle_speech(datum/source, list/speech_args)

/obj/item/organ/tongue/Insert(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = say_mod
	if (modifies_speech)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	M.UnregisterSignal(M, COMSIG_MOB_SAY)
	for(var/datum/wound/facial/ears/tongue_wound as anything in M.get_wounds())
		qdel(tongue_wound)
	if(length(emote_verbs))
		add_verb(M, emote_verbs)

/obj/item/organ/tongue/Remove(mob/living/carbon/M, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	if(say_mod && M.dna && M.dna.species)
		M.dna.species.say_mod = initial(M.dna.species.say_mod)
	UnregisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	M.RegisterSignal(M, COMSIG_MOB_SAY, TYPE_PROC_REF(/mob/living/carbon, handle_tongueless_speech))
	if(length(emote_verbs))
		remove_verb(M, emote_verbs)

/obj/item/organ/tongue/could_speak_in_language(datum/language/dt)
	return is_type_in_typecache(dt, languages_possible)

/obj/item/organ/tongue/construct
	name = "construct tongue"
	desc = "A beast's tongue, preserved through artifice and with crystals embedded in the base. It seems rather dead..."
	icon_state = "tongue-con"
	say_mod = "crackles"
	taste_sensitivity = 30 //It's dead, jim.

/obj/item/organ/tongue/lizard
	name = "forked tongue"
	desc = ""
	icon_state = "tonguelizard"
	say_mod = "hisses"
	taste_sensitivity = 10 // combined nose + tongue, extra sensitive
	emote_verbs = list(
		/mob/living/carbon/human/proc/emote_yip,
		/mob/living/carbon/human/proc/emote_lizard_bellow,
		/mob/living/carbon/human/proc/emote_lizard_hiss,
		/mob/living/carbon/human/proc/emote_lizard_squeal,
		/mob/living/carbon/human/proc/emote_lizard_thump,
		/mob/living/carbon/human/proc/emote_growl,
		/mob/living/carbon/human/proc/emote_purr,
		/mob/living/proc/emote_squeak,
		/mob/living/proc/emote_hiss,
		/mob/living/carbon/human/proc/emote_phiss,
	)
//	modifies_speech = TRUE
/*
/obj/item/organ/tongue/lizard/handle_speech(datum/source, list/speech_args)
	var/static/regex/lizard_hiss = new("s+", "g")
	var/static/regex/lizard_hiSS = new("S+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = lizard_hiss.Replace(message, "sss")
		message = lizard_hiSS.Replace(message, "SSS")
	speech_args[SPEECH_MESSAGE] = message
*/
/obj/item/organ/tongue/fly
	name = "proboscis"
	desc = ""
	icon_state = "tonguefly"
	say_mod = "buzzes"
	taste_sensitivity = 25 // you eat vomit, this is a mercy
	modifies_speech = TRUE

/obj/item/organ/tongue/fly/handle_speech(datum/source, list/speech_args)
	var/static/regex/fly_buzz = new("z+", "g")
	var/static/regex/fly_buZZ = new("Z+", "g")
	var/message = speech_args[SPEECH_MESSAGE]
	if(message[1] != "*")
		message = fly_buzz.Replace(message, "zzz")
		message = fly_buZZ.Replace(message, "ZZZ")
	speech_args[SPEECH_MESSAGE] = message

/obj/item/organ/tongue/zombie
	name = "rotting tongue"
	desc = ""
	icon_state = "tonguezombie"
	say_mod = "moans"
	modifies_speech = TRUE
	taste_sensitivity = 32

/obj/item/organ/tongue/zombie/handle_speech(datum/source, list/speech_args)
	var/list/message_list = splittext(speech_args[SPEECH_MESSAGE], " ")
	var/maxchanges = max(round(message_list.len / 1.5), 2)

	for(var/i = rand(maxchanges / 2, maxchanges), i > 0, i--)
		var/insertpos = rand(1, message_list.len - 1)
		var/inserttext = message_list[insertpos]

		if(!(copytext(inserttext, length(inserttext) - 2) == "..."))
			message_list[insertpos] = inserttext + "..."

		if(prob(20) && message_list.len > 3)
			message_list.Insert(insertpos, "[pick("BRAINS", "Brains", "Braaaiinnnsss", "BRAAAIIINNSSS")]...")

	speech_args[SPEECH_MESSAGE] = jointext(message_list, " ")

/obj/item/organ/tongue/alien
	name = "alien tongue"
	desc = ""
	icon_state = "tonguexeno"
	say_mod = "hisses"
	taste_sensitivity = 10 // LIZARDS ARE ALIENS CONFIRMED
	modifies_speech = TRUE // not really, they just hiss
	var/static/list/languages_possible_alien = typecacheof(list(
		/datum/language/xenocommon,
		/datum/language/common,
		/datum/language/draconic))

/obj/item/organ/tongue/alien/Initialize(mapload)
	. = ..()
	languages_possible = languages_possible_alien

/obj/item/organ/tongue/alien/handle_speech(datum/source, list/speech_args)
	playsound(owner, "hiss", 25, TRUE, TRUE)

/obj/item/organ/tongue/bone
	name = "bone \"tongue\""
	desc = ""
	icon_state = "tonguebone"
	say_mod = "rattles"
	attack_verb = list("bitten", "chattered", "chomped", "enamelled", "boned")
	taste_sensitivity = 101 // skeletons cannot taste anything
	modifies_speech = TRUE
	var/chattering = FALSE
	var/phomeme_type = "sans"
	var/list/phomeme_types = list("sans", "papyrus")

/obj/item/organ/tongue/bone/Initialize(mapload)
	. = ..()
	phomeme_type = pick(phomeme_types)

/obj/item/organ/tongue/bone/handle_speech(datum/source, list/speech_args)
	if (chattering)
		chatter(speech_args[SPEECH_MESSAGE], phomeme_type, source)
	switch(phomeme_type)
		if("sans")
			speech_args[SPEECH_SPANS] |= SPAN_SANS
		if("papyrus")
			speech_args[SPEECH_SPANS] |= SPAN_PAPYRUS

/obj/item/organ/tongue/bone/plasmaman
	name = "plasma bone \"tongue\""
	desc = ""
	icon_state = "tongueplasma"
	modifies_speech = FALSE

/obj/item/organ/tongue/robot
	name = "robotic voicebox"
	desc = ""
	status = ORGAN_ROBOTIC
	icon_state = "tonguerobot"
	say_mod = "states"
	attack_verb = list("beeped", "booped")
	modifies_speech = TRUE
	taste_sensitivity = 25 // not as good as an organic tongue

/obj/item/organ/tongue/robot/can_speak_in_language(datum/language/dt)
	return TRUE // THE MAGIC OF ELECTRONICS

/obj/item/organ/tongue/robot/handle_speech(datum/source, list/speech_args)
	speech_args[SPEECH_SPANS] |= SPAN_ROBOT

/obj/item/organ/tongue/snail
	name = "snailtongue"
	modifies_speech = TRUE

/obj/item/organ/tongue/snail/handle_speech(datum/source, list/speech_args)
	var/new_message
	var/message = speech_args[SPEECH_MESSAGE]
	for(var/i in 1 to length(message))
		if(findtext("ABCDEFGHIJKLMNOPWRSTUVWXYZabcdefghijklmnopqrstuvwxyz", message[i])) //Im open to suggestions
			new_message += message[i] + message[i] + message[i] //aaalllsssooo ooopppeeennn tttooo sssuuuggggggeeessstttiiiooonsss
		else
			new_message += message[i]
	speech_args[SPEECH_MESSAGE] = new_message

/obj/item/organ/tongue/wild_tongue
	name = "wild tongue"
	emote_verbs = list(
		/mob/living/carbon/human/proc/emote_meow,
		/mob/living/proc/emote_mrrp,
		/mob/living/carbon/human/proc/emote_caw,
		/mob/living/carbon/human/proc/emote_peep,
		/mob/living/carbon/human/proc/emote_hoot,
		/mob/living/proc/emote_squeak,
		/mob/living/proc/emote_hiss,
		/mob/living/carbon/human/proc/emote_phiss,
		/mob/living/carbon/human/proc/emote_roar,
		/mob/living/carbon/human/proc/emote_howl,
		/mob/living/carbon/human/proc/emote_cackle,
		/mob/living/carbon/human/proc/emote_whine,
		/mob/living/carbon/human/proc/emote_fwhine,
		/mob/living/carbon/human/proc/emote_snort,
		/mob/living/carbon/human/proc/emote_oink,
		/mob/living/carbon/human/proc/emote_trill,
		/mob/living/carbon/human/proc/emote_purr,
		/mob/living/carbon/human/proc/emote_moo,
		/mob/living/carbon/human/proc/emote_bark,
		/mob/living/carbon/human/proc/emote_growl,
		/mob/living/proc/emote_prbt,
		/mob/living/carbon/human/proc/emote_bleat,
		/mob/living/carbon/human/proc/emote_chitter,
		/mob/living/carbon/human/proc/emote_flutter,
		/mob/living/carbon/human/proc/emote_yip,
		/mob/living/carbon/human/proc/emote_lizard_bellow,
		/mob/living/carbon/human/proc/emote_lizard_hiss,
		/mob/living/carbon/human/proc/emote_lizard_squeal,
		/mob/living/carbon/human/proc/emote_lizard_thump,
	)

/obj/item/organ/tongue/moth
	name = "moth tongue"
	say_mod = "flutters"
	emote_verbs = list(
		/mob/living/carbon/human/proc/emote_chitter,
		/mob/living/carbon/human/proc/emote_flutter,
		/mob/living/proc/emote_squeak,
	)

/obj/item/organ/tongue/wild_tongue/lux
	name = "silver tongue"
	desc = "A tongue formed of segmented silver. Gilbranze wires dangle where viscera ought be. A humen form could only hold one such piece of artifice at any given time."
	icon_state = "tongue-lux"
	organ_flags = ORGAN_LUX
	decay_factor = 0

/obj/item/organ/tongue/wild_tongue/lux/on_life()
	if(owner.check_lux_organ_cap())
		owner.stuttering = max(owner.stuttering, 2)
		owner.slurring = max(owner.slurring, 10)

/obj/item/organ/tongue/wild_tongue/lux/prepare_eat()
	return FALSE //this thing isn't edible flesh

/obj/item/organ/tongue/wild_tongue/lux/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_LUX_ORGAN)

/obj/item/organ/tongue/wild_tongue/lux/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("A Silvered Tongue harnesses its host's Lux, allowing them to ")
	. += span_info("If the user has no lux to spare, they can only support one Artificed Organ, or one pair of Gilbranze Limbs")
	. += span_info("Whilst the wearer has Lux, they can support up to two Artificed Organs, or pairs of Gilbranze Limbs, without failure. An Artificed Heart increases this capacity by one")
