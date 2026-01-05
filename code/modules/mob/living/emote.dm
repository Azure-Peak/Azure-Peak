/* EMOTE DATUMS */
/datum/emote/living
	mob_type_allowed_typecache = /mob/living
	mob_type_blacklist_typecache = list(/mob/living/brain)

/datum/emote/living/blush
	key = "blush"
	key_third_person = "blushes"
	message = "blushes."

/datum/emote/living/pray
	key = "pray"
	key_third_person = "prays"
	message = "prays something."
	restraint_check = FALSE
	emote_type = EMOTE_VISIBLE
	// We let people pray unconcious for death-gasp style prayers in crit.
	stat_allowed = list(CONSCIOUS, UNCONSCIOUS)

/mob/living/carbon/human/verb/emote_pray()
	set name = "Pray"
	set category = "Emotes"

	emote("pray", intentional = TRUE)

//Also see how prayers work in '/code/datums/gods/_patron.dm' for how patrons hear and filter prayers based on profanity, etc.
/datum/emote/living/pray/run_emote(mob/user, params, type_override, intentional)
	var/mob/living/carbon/follower = user
	var/datum/patron/patron = follower.patron

	var/prayer = input("Whisper your prayer:", "Prayer") as text|null
	if(!prayer)
		return

	//If God can hear your prayer (long enough, no bad words, etc.)
	if(patron.hear_prayer(follower, prayer))
		if(follower.has_flaw(/datum/charflaw/addiction/godfearing))
			// Stops prayers if you don't meet your patron's requirements to pray.
			if(!patron?.can_pray(follower))
				return
			else
				follower.sate_addiction()

	/* admin stuff - tells you the followers name, key, and what patron they follow */
	var/follower_ident = "[follower.key]/([follower.real_name]) (follower of [patron])"
	message_admins("[follower_ident] [ADMIN_SM(follower)] [ADMIN_FLW(follower)] prays: [span_info(prayer)]")
	user.log_message("(follower of [patron]) prays: [prayer]", LOG_GAME)

	follower.whisper(prayer)

	if(SEND_SIGNAL(follower, COMSIG_CARBON_PRAY, prayer) & CARBON_PRAY_CANCEL)
		return

/datum/emote/living/meditate
	key = "meditate"
	key_third_person = "meditates"
	message = "meditates."
	restraint_check = FALSE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_meditate()
	set name = "Meditate"
	set category = "Emotes"

	emote("meditate", intentional = TRUE)

/datum/emote/living/meditate/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(do_after(user, 1 MINUTES))
		user.add_stress(/datum/stressevent/meditation)
		to_chat(user, span_green("My meditations were rewarding."))

/datum/emote/living/bow
	key = "bow"
	key_third_person = "bows"
	message = "bows."
	message_param = "bows to %t."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE

/datum/emote/living/bow/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && params && isliving(user))
		var/mob/living/L = user
		var/list/split_params = splittext(params, " ")
		var/mob/target = get_target(L, split_params)
		if(target && ishuman(target))
			var/mob/living/carbon/human/H = target
			if(HAS_TRAIT(H, TRAIT_NOBLE))
				H.add_stress(/datum/stressevent/noble_bowed_to)

/mob/living/carbon/human/verb/emote_bow()
	set name = "Bow"
	set category = "Emotes"

	emote("bow", intentional = TRUE)

/datum/emote/living/burp
	key = "burp"
	key_third_person = "burps"
	message = "burps."
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_burp()
	set name = "Burp"
	set category = "Noises"

	emote("burp", intentional = TRUE)

/datum/emote/living/choke
	key = "choke"
	key_third_person = "chokes"
	message = "chokes!"
	emote_type = EMOTE_AUDIBLE
	ignore_silent = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_choke()
	set name = "Choke"
	set category = "Noises"

	emote("choke", intentional = TRUE)

/datum/emote/living/cross
	key = "crossarms"
	key_third_person = "crossesarms"
	message = "crosses their arms."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_crossarms()
	set name = "Cross Arms"
	set category = "Emotes"

	emote("crossarms", intentional = TRUE)

/datum/emote/living/collapse
	key = "collapse"
	key_third_person = "collapses"
	message = "collapses."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/collapse/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && isliving(user))
		var/mob/living/L = user
		L.Unconscious(40)

/datum/emote/living/whisper
	key = "whisper"
	key_third_person = "whispers"
	message = "whispers."
	message_mime = "appears to whisper."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/aggro
	key = "aggro"
	key_third_person = "aggro"
	message = ""
	nomsg = TRUE
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/cough
	key = "cough"
	key_third_person = "coughs"
	message = "coughs."
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_cough()
	set name = "Cough"
	set category = "Noises"

	emote("cough", intentional = TRUE)

/datum/emote/living/clearthroat
	key = "clearthroat"
	key_third_person = "clearsthroat"
	message = "clears their throat."
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_clearthroat()
	set name = "Clear Throat"
	set category = "Noises"

	emote("clearthroat", intentional = TRUE)

/datum/emote/living/dance
	key = "dance"
	key_third_person = "dances"
	message = "dances."
	restraint_check = TRUE
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_dance()
	set name = "Dance"
	set category = "Emotes"

	emote("dance", intentional = TRUE)

/datum/emote/living/deathgasp
	key = ""
	key_third_person = ""
	message = "gasps out their last breath."
	message_monkey = "lets out a faint chimper as it collapses and stops moving..."
	message_simple =  "falls limp."
	stat_allowed = UNCONSCIOUS

/datum/emote/living/deathgasp/run_emote(mob/user, params, type_override, intentional)
	var/mob/living/simple_animal/S = user
	if(istype(S) && S.deathmessage)
		message_simple = S.deathmessage
	. = ..()
	message_simple = initial(message_simple)
	if(. && user.deathsound)
		if(isliving(user))
			var/mob/living/L = user
			if(!L.can_speak_vocal() || L.oxyloss >= 50)
				return //stop the sound if oxyloss too high/cant speak
		playsound(user, user.deathsound, 200, TRUE, TRUE)

/datum/emote/living/drool
	key = "drool"
	key_third_person = "drools"
	message = "drools."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_drool()
	set name = "Drool"
	set category = "Emotes"

	emote("drool", intentional = TRUE)

/datum/emote/living/faint
	key = "faint"
	key_third_person = "faints"
	message = "faints."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_faint()
	set name = "Faint"
	set category = "Emotes"

	emote("faint", intentional = TRUE)

/datum/emote/living/faint/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/L = user
		if(L.get_complex_pain() > (L.STAWIL * 9))
			L.setDir(2)
			L.SetUnconscious(200)
		else
			L.Knockdown(10)

/datum/emote/living/flap
	key = "flap"
	key_third_person = "flaps"
	message = "flaps their wings."
	restraint_check = TRUE
	var/wing_time = 20

/datum/emote/living/carbon/human/flap/can_run_emote(mob/user, status_check = TRUE , intentional)
	return FALSE

/datum/emote/living/flap/aflap
	key = "aflap"
	key_third_person = "aflaps"
	message = "flaps their wings ANGRILY!"
	restraint_check = TRUE
	wing_time = 10

/datum/emote/living/carbon/human/aflap/can_run_emote(mob/user, status_check = TRUE , intentional)
	return FALSE

/datum/emote/living/frown
	key = "frown"
	key_third_person = "frowns"
	message = "frowns."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_frown()
	set name = "Frown"
	set category = "Emotes"

	emote("frown", intentional = TRUE)

/datum/emote/living/gag
	key = "gag"
	key_third_person = "gags"
	message = "gags."
	emote_type = EMOTE_AUDIBLE
	ignore_silent = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_gag()
	set name = "Gag"
	set category = "Noises"

	emote("gag", intentional = TRUE)

/datum/emote/living/gasp
	key = "gasp"
	key_third_person = "gasps"
	message = "gasps!"
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_gasp()
	set name = "Gasp"
	set category = "Noises"

	emote("gasp", intentional = TRUE)

/datum/emote/living/breathgasp
	key = "breathgasp"
	key_third_person = "breathgasps"
	message = "gasps for air!"
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/giggle
	key = "giggle"
	key_third_person = "giggles"
	message = "giggles."
	message_mime = "giggles silently!"
	message_muffled = "makes a muffled giggle."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/giggle/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(.)
		// Apply Xylix buff to those with the trait who hear the giggling
		// Only apply if the hearer is not the one laughing
		for(var/mob/living/carbon/human/H in hearers(7, user))
			if(H == user || !H.client)
				continue
			if(HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy))
				H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
				to_chat(H, span_info("The giggling brings a smile to my face, and fortune to my steps!"))

/mob/living/carbon/human/verb/emote_giggle()
	set name = "Giggle"
	set category = "Noises"

	emote("giggle", intentional = TRUE)

/datum/emote/living/chuckle
	key = "chuckle"
	key_third_person = "chuckles"
	message = "chuckles."
	message_muffled = "makes a muffled chuckle."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/chuckle/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(.)
		// Apply Xylix buff to those with the trait who hear the chuckling
		// Only apply if the hearer is not the one chuckling
		for(var/mob/living/carbon/human/H in hearers(7, user))
			if(H == user || !H.client)
				continue
			if(HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy))
				H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
				to_chat(H, span_info("The chuckling brings a smile to my face, and fortune to my steps!"))

/mob/living/carbon/human/verb/emote_chuckle()
	set name = "Chuckle"
	set category = "Noises"

	emote("chuckle", intentional = TRUE)

/datum/emote/living/glare
	key = "glare"
	key_third_person = "glares"
	message = "glares."
	message_param = "glares at %t."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_glare()
	set name = "Glare"
	set category = "Emotes"

	emote("glare", intentional = TRUE)

/datum/emote/living/grin
	key = "grin"
	key_third_person = "grins"
	message = "grins."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_grin()
	set name = "Grin"
	set category = "Emotes"

	emote("grin", intentional = TRUE)

/datum/emote/living/groan
	key = "groan"
	key_third_person = "groans"
	message = "groans."
	message_muffled = "makes a muffled groan."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_groan()
	set name = "Groan"
	set category = "Noises"

	emote("groan", intentional = TRUE)

/datum/emote/living/grimace
	key = "grimace"
	key_third_person = "grimaces"
	message = "grimaces."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_grimace()
	set name = "Grimace"
	set category = "Emotes"

	emote("grimace", intentional = TRUE)

/datum/emote/living/jump
	key = "jump"
	key_third_person = "jumps"
	message = "jumps!"
	restraint_check = TRUE

/datum/emote/living/leap
	key = "leap"
	key_third_person = "leaps"
	message = "leaps!"
	restraint_check = TRUE
	only_forced_audio = TRUE

/datum/emote/living/kiss
	key = "kiss"
	key_third_person = "kisses"
	message = "blows a kiss."
	message_param = "kisses %t."
	emote_type = EMOTE_VISIBLE
	use_params_for_runechat = TRUE

/mob/living/carbon/human/verb/emote_kiss()
	set name = "Kiss"
	set category = "Emotes"

	emote("kiss", intentional = TRUE, targetted = TRUE)

/datum/emote/living/kiss/adjacentaction(mob/user, mob/target)
	. = ..()
	message_param = initial(message_param) // re
	if(!user || !target)
		return
	if(ishuman(user) && ishuman(target))
		var/mob/living/carbon/human/H = user
		var/do_change
		if(target.loc == user.loc)
			do_change = TRUE
		if(!do_change)
			if(H.pulling == target)
				do_change = TRUE
		if(do_change)
			if(H.zone_selected == BODY_ZONE_PRECISE_MOUTH)
				message_param = "kisses %t deeply."
			else if(H.zone_selected == BODY_ZONE_PRECISE_EARS)
				message_param = "kisses %t on the ear."
				var/mob/living/carbon/human/E = target
				if(iself(E) || ishalfelf(E) || isdarkelf(E))
					if(!E.cmode)
						to_chat(target, span_love("It tickles..."))
			else if(H.zone_selected == BODY_ZONE_PRECISE_R_EYE || H.zone_selected == BODY_ZONE_PRECISE_L_EYE)
				message_param = "kisses %t on the brow."
			else if(H.zone_selected == BODY_ZONE_PRECISE_SKULL)
				message_param = "kisses %t on the forehead."
			else
				message_param = "kisses %t on \the [parse_zone(H.zone_selected)]."
	playsound(target.loc, pick('sound/vo/kiss (1).ogg','sound/vo/kiss (2).ogg'), 100, FALSE, -1)
	if(user.mind)
		record_round_statistic(STATS_KISSES_MADE)

/datum/emote/living/lick
	key = "lick"
	key_third_person = "licks"
	message = "licking."
	message_param = "licks %t."
	emote_type = EMOTE_VISIBLE
	use_params_for_runechat = TRUE

/mob/living/carbon/human/verb/emote_lick()
	set name = "Lick"
	set category = "Emotes"
	emote("lick", intentional = TRUE, targetted = TRUE)

/datum/emote/living/lick/adjacentaction(mob/user, mob/target)
	. = ..()
	message_param = initial(message_param)
	if(!user || !target)
		return
	if(ishuman(user) && ishuman(target))
		var/mob/living/carbon/human/J = user
		var/do_change
		if(target.loc == user.loc)
			do_change = TRUE
		if(!do_change)
			if(J.pulling == target)
				do_change = TRUE
		if(do_change)
			if(J.zone_selected == BODY_ZONE_PRECISE_MOUTH)
				message_param = "licks %t lips."
			else if(J.zone_selected == BODY_ZONE_PRECISE_EARS)
				message_param = "licks the ear of %t."
				var/mob/living/carbon/human/O = target
				if(iself(O) || ishalfelf(O) || isdarkelf(O))
					if(!O.cmode)
						to_chat(target, span_love("It tickles..."))
			else if(J.zone_selected == BODY_ZONE_PRECISE_GROIN)
				message_param = "licks %t between the legs."
				to_chat(target, span_love("It somewhat stimulating..."))
			else if(J.zone_selected == BODY_ZONE_HEAD)
				message_param = "licks %t cheek"
			else
				message_param = "licks %t [parse_zone(J.zone_selected)]."
	playsound(target.loc, pick("sound/vo/lick.ogg"), 100, FALSE, -1)

/datum/emote/living/spit
	key = "spit"
	key_third_person = "spits"
	message = "spits on the ground."
	message_param = "spits on %t."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_spit()
	set name = "Spit"
	set category = "Emotes"

	emote("spit", intentional = TRUE, targetted = TRUE)


/datum/emote/living/spit/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.mouth)
			if(H.mouth.spitoutmouth)
				H.visible_message(span_warning("[H] spits out [H.mouth]."))
				H.dropItemToGround(H.mouth, silent = FALSE)
			return
	..()

/datum/emote/living/spit/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(user.gender == MALE)
		playsound(target.loc, pick('sound/vo/male/gen/spit.ogg'), 100, FALSE, -1)
	else
		playsound(target.loc, pick('sound/vo/female/gen/spit.ogg'), 100, FALSE, -1)


/datum/emote/living/hug
	key = "hug"
	key_third_person = "hugs"
	message = ""
	message_param = "hugs %t."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/mob/living/carbon/human/verb/emote_hug()
	set name = "Hug"
	set category = "Emotes"

	emote("hug", intentional = TRUE, targetted = TRUE)

/datum/emote/living/hug/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		playsound(target.loc, pick('sound/vo/hug.ogg'), 100, FALSE, -1)
		if(user.mind)
			record_round_statistic(STATS_HUGS_MADE)
			SEND_SIGNAL(user, COMSIG_MOB_HUGGED, target)

/datum/emote/living/holdbreath
    key = "hold"
    key_third_person = "holds"
    message = null

/mob/living/carbon/human/verb/emote_hold()
    set name = "Hold Breath"
    set category = "Emotes"
    emote("hold", intentional = TRUE)

/datum/emote/living/holdbreath/can_run_emote(mob/living/user, status_check = TRUE, intentional)
    . = ..()
    if(!.)
        return FALSE
    return TRUE

/datum/emote/living/holdbreath/run_emote(mob/user, params, type_override, intentional)
    if(!ishuman(user))
        return FALSE

    var/mob/living/carbon/human/H = user
    var/is_holding = HAS_TRAIT(H, TRAIT_HOLDBREATH)

    if(is_holding)
        REMOVE_TRAIT(H, TRAIT_HOLDBREATH, "[type]")
        H.visible_message(
            span_notice("[H] stops holding [H.p_their()] breath."),
            span_notice("You stop holding your breath.")
        )
    else
        ADD_TRAIT(H, TRAIT_HOLDBREATH, "[type]")
        H.visible_message(
            span_notice("[H] begins to hold [H.p_their()] breath."),
            span_notice("You begin to hold your breath.")
        )

    return TRUE


/datum/emote/living/slap
	key = "slap"
	key_third_person = "slaps"
	message = ""
	message_param = "slaps %t in the face."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE


/datum/emote/living/slap/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.zone_selected == BODY_ZONE_PRECISE_GROIN)
			message_param = "slaps %t's ass!"
		else if(H.zone_selected == BODY_ZONE_PRECISE_SKULL)
			message_param = "slaps %t's head!"
		else if(H.zone_selected == BODY_ZONE_PRECISE_L_HAND || H.zone_selected == BODY_ZONE_PRECISE_R_HAND)
			message_param = "slaps %t's hand!"
	..()

/mob/living/carbon/human/verb/emote_slap()
	set name = "Slap"
	set category = "Emotes"

	emote("slap", intentional = TRUE, targetted = TRUE)

/datum/emote/living/slap/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.flash_fullscreen("redflash3")
		H.AdjustSleeping(-50)
		playsound(target.loc, 'sound/foley/slap.ogg', 100, TRUE, -1)

/datum/emote/living/pinch
	key = "pinch"
	key_third_person = "pinches"
	message = ""
	message_param = "pinches %t."
	emote_type = EMOTE_VISIBLE
	restraint_check = TRUE

/datum/emote/living/pinch/adjacentaction(mob/user, mob/target)
	. = ..()
	if(!user || !target)
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		H.flash_fullscreen("redflash1")

/mob/living/carbon/human/verb/emote_pinch()
	set name = "Pinch"
	set category = "Emotes"

	emote("pinch", intentional = TRUE, targetted = TRUE)

/datum/emote/living/laugh/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(. && user.mind)
		record_round_statistic(STATS_LAUGHS_MADE)

/datum/emote/living/laugh
	key = "laugh"
	key_third_person = "laughs"
	message = "laughs."
	message_mime = "laughs silently!"
	message_muffled = "makes a muffled laugh."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/laugh/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		return !C.silent

/datum/emote/living/laugh/run_emote(mob/living/user, params, type_override, intentional)
	. = ..()
	if(.)
		// Apply Xylix buff to those with the trait who hear the laughter
		// Only apply if the hearer is not the one laughing
		for(var/mob/living/carbon/human/H in hearers(7, user))
			if(H == user || !H.client)
				continue
			if(HAS_TRAIT(H, TRAIT_XYLIX) && !H.has_status_effect(/datum/status_effect/buff/xylix_joy))
				H.apply_status_effect(/datum/status_effect/buff/xylix_joy)
				to_chat(H, span_info("The laughter brings a smile to my face, and fortune to my steps!"))

/mob/living/carbon/human/verb/emote_laugh()
	set name = "Laugh"
	set category = "Noises"

	emote("laugh", intentional = TRUE)

/datum/emote/living/look
	key = "look"
	key_third_person = "looks"
	message = "stares blankly."
	message_param = "looks at %t."

/datum/emote/living/nod
	key = "nod"
	key_third_person = "nods"
	message = "nods."
	message_param = "nods at %t."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_nod()
	set name = "Nod"
	set category = "Emotes"

	emote("nod", intentional = TRUE)

/datum/emote/living/point
	key = "point"
	key_third_person = "points"
	message = "points."
	message_param = "points at %t."
	restraint_check = TRUE

/datum/emote/living/point/run_emote(mob/user, params, type_override, intentional)
	message_param = initial(message_param) // reset
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.get_num_arms() == 0)
			if(H.get_num_legs() != 0)
				message_param = "tries to point at %t with a leg, <span class='danger'>falling down</span> in the process!"
				H.Paralyze(20)
			else
				message_param = "<span class='danger'>bumps [user.p_their()] head on the ground</span> trying to motion towards %t."
				H.adjustOrganLoss(ORGAN_SLOT_BRAIN, 5)
	..()

/datum/emote/living/pout
	key = "pout"
	key_third_person = "pouts"
	message = "pouts."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/scream
	key = "scream"
	key_third_person = "screams"
	message = "screams!"
	message_mime = "acts out a scream!"
	message_muffled = "makes a muffled noise in attempt to scream!"
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_scream()
	set name = "Scream"
	set category = "Noises"

	emote("scream", intentional = TRUE)

/datum/emote/living/scream/can_run_emote(mob/living/user, status_check = TRUE , intentional)
	. = ..()
	if(. && iscarbon(user))
		var/mob/living/carbon/C = user
		if(intentional)
			if(!C.stamina_add(10))
				to_chat(C, span_warning("I try to scream but my voice fails me."))
				. = FALSE

/datum/emote/living/scream/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(. && user.mind)
		record_featured_stat(FEATURED_STATS_SCREAMERS, user)

/datum/emote/living/scream/painscream
	key = "painscream"
	message = "screams in pain!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/scream/painscream/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/L in viewers(7,user))
			if(L == user)
				if(L.has_flaw(/datum/charflaw/addiction/masochist))
					L.sate_addiction()
				continue
			if(L.has_flaw(/datum/charflaw/addiction/sadist))
				L.sate_addiction()

/datum/emote/living/scream/strain
	key = "strain"
	message = "strains themselves!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/scream/agony
	key = "agony"
	message = "screams in agony!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/scream/agony/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/L in viewers(7,user))
			if(L == user)
				if(L.has_flaw(/datum/charflaw/addiction/masochist))
					L.sate_addiction()
				continue // i hope this shit works.
			if(L.has_flaw(/datum/charflaw/addiction/sadist))
				L.sate_addiction()

/datum/emote/living/scream/firescream
	key = "firescream"
	nomsg = TRUE
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/scream/firescream/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(.)
		for(var/mob/living/carbon/human/L in viewers(7,user))
			if(L == user)
				if(L.has_flaw(/datum/charflaw/addiction/masochist))
					L.sate_addiction()
				continue // i hope this shit works.
			if(L.has_flaw(/datum/charflaw/addiction/sadist))
				L.sate_addiction()

/datum/emote/living/aggro
	key = "aggro"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/idle
	key = "idle"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/death
	key = "death"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living)
	show_runechat = FALSE

/datum/emote/living/pain
	key = "pain"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/drown
	key = "drown"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	ignore_silent = TRUE
	show_runechat = FALSE

/datum/emote/living/paincrit
	key = "paincrit"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/embed
	key = "embed"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/painmoan
	key = "painmoan"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/groin
	key = "groin"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/fatigue
	key = "fatigue"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/jump
	key = "jump"
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/haltyell
	key = "haltyell"
	message = "shouts a halt!"
	emote_type = EMOTE_AUDIBLE
	only_forced_audio = TRUE
	show_runechat = FALSE

/datum/emote/living/rage
	key = "rage"
	message = "screams in rage!"
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_rage()
	set name = "Rage"
	set category = "Noises"

	emote("rage", intentional = TRUE)

/datum/emote/living/rage/run_emote(mob/user, params, type_override, intentional, targetted)
	. = ..()
	if(. && user.mind)
		record_round_statistic(STATS_WARCRIES)

/datum/emote/living/attnwhistle
	key = "attnwhistle"
	message = "whistles for attention!"
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_attnwhistle()
	set name = "Attnwhistle"
	set category = "Noises"

	emote("attnwhistle", intentional = TRUE)

/datum/emote/living/choke
	key = "choke"
	key_third_person = "chokes"
	message = "chokes!"
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/scowl
	key = "scowl"
	key_third_person = "scowls"
	message = "scowls."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/shakehead
	key = "shakehead"
	key_third_person = "shakeshead"
	message = "shakes their head."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_shakehead()
	set name = "Shake Head"
	set category = "Emotes"

	emote("shakehead", intentional = TRUE)


/datum/emote/living/shiver
	key = "shiver"
	key_third_person = "shiver"
	message = "shivers."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_shiver()
	set name = "Shiver"
	set category = "Emotes"

	emote("shiver", intentional = TRUE)


/datum/emote/living/sigh
	key = "sigh"
	key_third_person = "sighs"
	message = "sighs."
	message_muffled = "makes a muffled sigh."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_sigh()
	set name = "Sigh"
	set category = "Noises"

	emote("sigh", intentional = TRUE)

/datum/emote/living/whistle
	key = "whistle"
	key_third_person = "whistles"
	message = "whistles."
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_whistle()
	set name = "Whistle"
	set category = "Noises"

	emote("whistle", intentional = TRUE)

/datum/emote/living/hmm
	key = "hmm"
	key_third_person = "hmms"
	message = "hmms."
	message_muffled = "makes a muffled hmm."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_hmm()
	set name = "Hmm"
	set category = "Noises"

	emote("hmm", intentional = TRUE)

/datum/emote/living/huh
	key = "huh"
	key_third_person = "huhs"
	message_muffled = "makes a muffled noise."
	emote_type = EMOTE_AUDIBLE
	nomsg = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_huh()
	set name = "Huh"
	set category = "Noises"

	emote("huh", intentional = TRUE)

/datum/emote/living/hum
	key = "hum"
	key_third_person = "hums"
	message = "hums."
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled hum."
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_hum()
	set name = "Hum"
	set category = "Noises"

	emote("hum", intentional = TRUE)

/datum/emote/living/smile
	key = "smile"
	key_third_person = "smiles"
	message = "smiles."
	emote_type = EMOTE_VISIBLE
/mob/living/carbon/human/verb/emote_smile()
	set name = "Smile"
	set category = "Emotes"

	emote("smile", intentional = TRUE)

/datum/emote/living/sneeze
	key = "sneeze"
	key_third_person = "sneezes"
	message = "sneezes."
	message_muffled = "makes a muffled sneeze."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/shh
	key = "shh"
	key_third_person = "shhs"
	message = "shooshes."
	message_muffled = "makes a muffled shh."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_shh()
	set name = "Shh"
	set category = "Noises"

	emote("shh", intentional = TRUE)

/datum/emote/living/smug
	key = "smug"
	key_third_person = "smugs"
	message = "grins smugly."

/datum/emote/living/sniff
	key = "sniff"
	key_third_person = "sniffs"
	message = "sniffs."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/datum/emote/living/snore
	key = "snore"
	key_third_person = "snores"
	message = "snores."
	message_mime = "sleeps soundly."
	emote_type = EMOTE_AUDIBLE
	stat_allowed = UNCONSCIOUS
	snd_range = -4
	show_runechat = FALSE

/datum/emote/living/stare
	key = "stare"
	key_third_person = "stares"
	message = "stares."
	message_param = "stares at %t."

/datum/emote/living/strech
	key = "stretch"
	key_third_person = "stretches"
	message = "stretches their arms."

/datum/emote/living/sulk
	key = "sulk"
	key_third_person = "sulks"
	message = "sulks down sadly."

/datum/emote/living/sway
	key = "sway"
	key_third_person = "sways"
	message = "sways around dizzily."

/datum/emote/living/tremble
	key = "tremble"
	key_third_person = "trembles"
	message = "trembles in fear!"

/datum/emote/living/twitch
	key = "twitch"
	key_third_person = "twitches"
	message = "twitches violently."

/datum/emote/living/twitch_s
	key = "twitch_s"
	message = "twitches."
	stat_allowed = UNCONSCIOUS
	mob_type_ignore_stat_typecache = list(/mob/living/carbon/human)

/datum/emote/living/warcry
	key = "warcry"
	key_third_person = "warcrys"
	message = "lets out an inspiring battle cry!"
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled shout!"
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_warcry()
	set name = "Warcry"
	set category = "Noises"

	emote("warcry", intentional = TRUE)

/datum/emote/living/wave
	key = "wave"
	key_third_person = "waves"
	message = "waves."

/datum/emote/living/whimper
	key = "whimper"
	key_third_person = "whimpers"
	message = "whimpers."
	message_mime = "appears hurt."
	message_muffled = "makes a muffled whimper."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_whimper()
	set name = "Whimper"
	set category = "Noises"

	emote("whimper", intentional = TRUE)

/datum/emote/living/wsmile
	key = "wsmile"
	key_third_person = "wsmiles"
	message = "smiles weakly."

/datum/emote/living/yawn
	key = "yawn"
	key_third_person = "yawns"
	message = "yawns."
	message_muffled = "makes a muffled yawn."
	emote_type = EMOTE_AUDIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_yawn()
	set name = "Yawn"
	set category = "Noises"

	emote("yawn", intentional = TRUE)

/datum/emote/living/custom
	key = "me"
	key_third_person = "custom"
	show_runechat = TRUE
#ifdef MATURESERVER
	message_param = "%t"
#endif
	//mute_time = 1 - RATWOOD CHANGE, I don't want spammers.
/datum/emote/living/custom/can_run_emote(mob/user, status_check, intentional)
	. = ..() && intentional

/datum/emote/living/custom/proc/check_invalid(mob/user, input)
	. = TRUE
	if(copytext(input,1,5) == "says")
		to_chat(user, span_danger("Invalid emote."))
	else if(copytext(input,1,9) == "exclaims")
		to_chat(user, span_danger("Invalid emote."))
	else if(copytext(input,1,6) == "yells")
		to_chat(user, span_danger("Invalid emote."))
	else if(copytext(input,1,5) == "asks")
		to_chat(user, span_danger("Invalid emote."))
	else
		. = FALSE

/datum/emote/living/custom/run_emote(mob/user, params, type_override = null, intentional = FALSE)
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	if(is_banned_from(user.ckey, "Emote"))
		to_chat(user, span_boldwarning("I cannot send custom emotes (banned)."))
		return FALSE
	else if(QDELETED(user))
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, span_boldwarning("I cannot send IC messages (muted)."))
		return FALSE
	else if(!params)
		var/custom_emote = copytext(sanitize(input("What does your character do?") as text|null), 1, MAX_MESSAGE_LEN)
		if(custom_emote && !check_invalid(user, custom_emote))
/*			var/type = input("Is this a visible or hearable emote?") as null|anything in list("Visible", "Hearable")
			switch(type)
				if("Visible")
					emote_type = EMOTE_VISIBLE
				if("Hearable")
					emote_type = EMOTE_AUDIBLE
				else
					alert("Unable to use this emote, must be either hearable or visible.")
					return*/
			message = custom_emote
			emote_type = EMOTE_VISIBLE
	else
		message = params
		if(type_override)
			emote_type = type_override
	. = ..()
	message = null
	emote_type = EMOTE_VISIBLE

/datum/emote/living/custom/replace_pronoun(mob/user, message)
	return message

/datum/emote/living/help
	key = "help"

/datum/emote/living/help/run_emote(mob/user, params, type_override, intentional)
/*	var/list/keys = list()
	var/list/message = list("Available emotes, you can use them with say \"*emote\": ")

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/P in GLOB.emote_list[key])
			if(P.key in keys)
				continue
			if(P.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += P.key

	keys = sortList(keys)

	for(var/emote in keys)
		if(LAZYLEN(message) > 1)
			message += ", [emote]"
		else
			message += "[emote]"

	message += "."

	message = jointext(message, "")

	to_chat(user, message)*/

/datum/emote/beep
	key = "beep"
	key_third_person = "beeps"
	message = "beeps."
	message_param = "beeps at %t."
	sound = 'sound/blank.ogg'
	mob_type_allowed_typecache = list(/mob/living/brain, /mob/living/silicon)
/*
/datum/emote/living/circle
	key = "circle"
	key_third_person = "circles"
	restraint_check = TRUE

/datum/emote/living/circle/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/obj/item/circlegame/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("I make a circle with your hand."))
	else
		qdel(N)
		to_chat(user, span_warning("I don't have any free hands to make a circle with."))

/datum/emote/living/slap
	key = "slap"
	key_third_person = "slaps"
	restraint_check = TRUE

/datum/emote/living/slap/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	if(!.)
		return
	var/obj/item/slapper/N = new(user)
	if(user.put_in_hands(N))
		to_chat(user, span_notice("I ready your slapping hand."))
	else
		to_chat(user, span_warning("You're incapable of slapping in your current state."))
*/

/datum/emote/living/shake
	key = "shake"
	key_third_person = "shakes"
	message = "shakes their head."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_shake()
	set name = "Shake Head"
	set category = "Emotes"

	emote("shake", intentional = TRUE)

/datum/emote/living/squint
	key = "squint"
	key_third_person = "squints"
	message = "squints their eyes."
	emote_type = EMOTE_VISIBLE

/mob/living/carbon/human/verb/emote_squint()
	set name = "Squint"
	set category = "Emotes"

	emote("squint", intentional = TRUE)

/datum/emote/living/meow
	key = "meow"
	key_third_person = "meows!"
	message = "meows!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_meow()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Meow"
		set category = "Noises"
		emote("meow", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/mrrp
	key = "mrrp"
	key_third_person = "mrrps!"
	message = "mrrps!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_mrrp()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Mrrp"
		set category = "Noises"
		emote("mrrp", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/caw
	key = "caw"
	key_third_person = "caws!"
	message = "caws!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_caw()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Caw"
		set category = "Noises"
		emote("caw", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/peep
	key = "peep"
	key_third_person = "peeps!"
	message = "peeps!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_peep()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Peep"
		set category = "Noises"
		emote("peep", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/hoot
	key = "hoot"
	key_third_person = "hoots!"
	message = "hoots!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_hoot()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Hoot"
		set category = "Noises"
		emote("hoot", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/squeak
	key = "squeak"
	key_third_person = "squeaks!"
	message = "squeaks!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_squeak()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Squeak"
		set category = "Noises"
		emote("squeak", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/hiss
	key = "hiss"
	key_third_person = "hisses!"
	message = "hisses!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_hiss()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Hiss"
		set category = "Noises"
		emote("hiss", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/phiss
	key = "phiss"
	key_third_person = "hisses!"
	message = "hisses!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_phiss()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "PHiss"
		set category = "Noises"
		emote("phiss", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/roar
	key = "roar"
	key_third_person = "roars!"
	message = "roars!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_roar()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Roar"
		set category = "Noises"
		emote("roar", intentional = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/howl
	key = "howl"
	key_third_person = "howls!"
	message = "howls!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_howl()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Howl"
		set category = "Noises"
		emote("howl", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/cackle
	key = "cackle"
	key_third_person = "cackles!"
	message = "cackles!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_cackle()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Cackle"
		set category = "Noises"
		emote("cackle", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/whine
	key = "whine"
	key_third_person = "whines."
	message = "whines."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_whine()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Whine"
		set category = "Noises"
		emote("whine", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/fwhine
	key = "fwhine"
	key_third_person = "whines like a Venard."
	message = "whines like a Venard."
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_fwhine()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Whine (Venard)"
		set category = "Noises"
		emote("fwhine", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/psnort
	key = "psnort"
	key_third_person = "psnorts"
	message = "lets out an elongated snort."
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_snort()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Snort (Animal)"
		set category = "Noises"
		emote("psnort", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/oink
	key = "oink"
	key_third_person = "oinks."
	message = "oinks."
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_oink()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Oink"
		set category = "Noises"
		emote("oink", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/trill
	key = "trill"
	key_third_person = "trills!"
	message = "trills!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_trill()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Trill"
		set category = "Noises"
		emote("trill", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/snap
	key = "snap"
	key_third_person = "finger snaps!"
	message = "finger snaps!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_snap()
	set name = "Snap"
	set category = "Noises"

	emote("snap", intentional = TRUE)

/datum/emote/living/blink
	key = "blink"
	key_third_person = "blinks."
	message = "blinks."
	emote_type = EMOTE_VISIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_blink()
	set name = "Blink"
	set category = "Noises"

	emote("blink", intentional = TRUE)

/datum/emote/living/stomp
	key = "stomp"
	key_third_person = "stomps!"
	message = "stomps!"
	emote_type = EMOTE_VISIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_stomp()
	set name = "Stomp"
	set category = "Noises"

	emote("stomp", intentional = TRUE)

/datum/emote/living/snap2
	key = "snap2"
	key_third_person = "finger snaps twice!"
	message = "finger snaps twice!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_snap2()
	set name = "Snap2"
	set category = "Noises"

	emote("snap2", intentional = TRUE)

/datum/emote/living/snap3
	key = "snap3"
	key_third_person = "finger snaps thrice!"
	message = "finger snaps thrice!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_snap3()
	set name = "Snap3"
	set category = "Noises"

	emote("snap3", intentional = TRUE)

/datum/emote/living/purr
	key = "purr"
	key_third_person = "purrs!"
	message = "purrs!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_purr()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Purr"
		set category = "Noises"
		emote("purr", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/moo
	key = "moo"
	key_third_person = "moos!"
	message = "moos!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_moo()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Moo"
		set category = "Noises"
		emote("moo", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/bark
	key = "bark"
	key_third_person = "barks!"
	message = "barks!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_bark()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Bark"
		set category = "Noises"
		emote("bark", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/growl
	key = "growl"
	key_third_person = "growls!"
	message = "growls!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_growl()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Growl"
		set category = "Noises"
		emote("growl", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/prbt
	key = "prbt"
	key_third_person = "prbts!"
	message = "prbts!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_prbt()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Prbt"
		set category = "Noises"
		emote("prbt", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/bleat
	key = "bleat"
	key_third_person = "bleats!"
	message = "bleats!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled sound!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_bleat()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/wild_tongue))
		set name = "Bleat"
		set category = "Noises"
		emote("bleat", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/chitter
	key = "chitter"
	key_third_person = "chitters!"
	message = "chitters!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	message_muffled = "makes a muffled chitter!"
	vary = TRUE
	show_runechat = FALSE
	is_animal = TRUE

/mob/living/carbon/human/verb/emote_chitter()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/moth))
		set name = "Chitter"
		set category = "Noises"
		emote("chitter", intentional = TRUE, animal = TRUE)
	else
		to_chat(usr, span_warning("Your tongue doesn't do that"))
		return

/datum/emote/living/flutter
	key = "flutter"
	key_third_person = "flutters!"
	message = "flutters!"
	emote_type = EMOTE_AUDIBLE | EMOTE_VISIBLE
	show_runechat = FALSE

/mob/living/carbon/human/verb/emote_flutter()
	if(istype(usr.getorganslot(ORGAN_SLOT_TONGUE), /obj/item/organ/tongue/moth))
		set name = "Flutter"
		set category = "Noises"
		emote("flutter", intentional = TRUE)
	else
		to_chat(usr, span_warning("Your back doesn't do that"))
		return

/datum/emote/living/fsalute
	key = "fsalute"
	key_third_person = "salutes their faith."
	message = "salutes their faith."
	emote_type = EMOTE_AUDIBLE
	show_runechat = TRUE

/datum/emote/living/fsalute/run_emote(mob/living/user, params, type_override, intentional, targetted, animal)
	. = ..()
	if(. && !isnull(user.patron) && !HAS_TRAIT(user, TRAIT_DECEIVING_MEEKNESS))	//Guarded doesn't show an icon to anyone.
		user.play_overhead_indicator('icons/mob/overhead_effects.dmi', "stress", 15, MUTATIONS_LAYER, private = user.patron.type, soundin = 'sound/magic/holyshield.ogg', y_offset = 32)

/mob/living/carbon/human/verb/emote_fsalute()
	set name = "Faith Salute"
	set category = "Emotes"

	emote("fsalute", intentional =  TRUE)

/datum/emote/living/ffsalute
	key = "ffsalute"
	key_third_person = "salutes their faith."
	message = "salutes their faith."
	emote_type = EMOTE_AUDIBLE
	show_runechat = TRUE

/datum/emote/living/ffsalute/run_emote(mob/living/user, params, type_override, intentional, targetted, animal)
	if(HAS_TRAIT(user, TRAIT_XYLIX))
		. = ..()

/mob/living/carbon/human/proc/emote_ffsalute()
	set name = "Fake Faith Salute"
	set category = "Emotes"

	emote("ffsalute", intentional =  TRUE)

/datum/emote/living/yip
	key = "yip"
	key_third_person = "yips"
	message = "yips!"
	emote_type = EMOTE_AUDIBLE
	message_muffled = "makes a muffled yip!"
	is_animal = TRUE
	show_runechat = FALSE

/mob/living/carbon/human/verb/yip()
	set name = "Yip"
	set category = "Noises"

	emote("yip", intentional = TRUE)

/datum/emote/living/stat_roll
	var/delay = 2.5 SECONDS
	var/list/attempt_message_list
	var/list/success_message_list
	var/list/failure_message_list

	/**
	 * An assoc list of character traits which will affect the outcome of rolls by the defined values if the rolling player has them. If empty, this process will be ignored.
	 * This basically determines the difficulty class in rolls (see: `/mob/living/proc/stat_roll()`)
	 * -1 value means decreased difficulty class, 5% higher chance to succeed, otherwise vice versa.
	 */
	var/list/modifiers_list = list()

/datum/emote/living/stat_roll/run_emote(mob/user, params, type_override, intentional = FALSE)
	. = ..()
	if(.)
		sleep(delay)

		var/mob/living/living = user
		var/chance_per_point = 5
		var/success = FALSE
		var/chance = 0

		var/modifier_sum
		if(length(modifiers_list))
			for(var/key in modifiers_list)
				if(HAS_TRAIT(living, key))
					modifier_sum += modifiers_list[key]

		switch(key)
			if("strength")
				success = living.stat_roll(STAT_STRENGTH, chance_per_point, modifier_sum) 
				chance = living.get_stat(STAT_STRENGTH)
			if("perception")
				success = living.stat_roll(STAT_PERCEPTION, chance_per_point, modifier_sum)
				chance = living.get_stat(STAT_PERCEPTION)
			if("intelligence")
				success = living.stat_roll(STAT_INTELLIGENCE, chance_per_point, modifier_sum)
				chance = living.get_stat(STAT_INTELLIGENCE)
			if("constitution")
				success = living.stat_roll(STAT_CONSTITUTION, chance_per_point, modifier_sum)
				chance = living.get_stat(STAT_CONSTITUTION)
			if("willpower")
				success = living.stat_roll(STAT_WILLPOWER, chance_per_point, modifier_sum)
				chance = living.get_stat(STAT_WILLPOWER)
			if("speed")
				success = living.stat_roll(STAT_SPEED, chance_per_point, modifier_sum)
				chance = living.get_stat(STAT_SPEED)
			if("fortune")
				success = living.stat_roll(STAT_FORTUNE, chance_per_point, modifier_sum)
				chance = living.get_stat(STAT_FORTUNE)
			if("charisma")
				// We compare willpower and fortune and use the highest. Not the best way to handle charisma actions, may be a subject to change in future
				var/will = living.get_stat(STAT_WILLPOWER)
				var/fort = living.get_stat(STAT_FORTUNE)
				var/chosen_stat = (will > fort) ? STAT_WILLPOWER : STAT_FORTUNE

				success = living.stat_roll(chosen_stat, chance_per_point, modifier_sum)
				chance = living.get_stat(chosen_stat)

		// modifier_sum is a difficulty class modifier, negative values make a roll more likely to succeed
		chance -= modifier_sum
		chance *= chance_per_point

		var/msg = success ? span_green("SUCCEEDS and [pick(success_message_list)]") : span_danger("FAILS and [pick(failure_message_list)] [chance]%")

		msg = replace_pronoun(user, msg)

		if(!msg)
			return

		// A COMSIG here would be nice, in my attempts it sadly didn't work out well for the relay.
		var/atom/movable/emotelocation = user
		var/mob/living/carbon/human/human
		if(ishuman(user))
			human = user

		var/obj/item/organ/dullahan_vision/vision
		var/datum/species/dullahan/dullahan
		if(isdullahan(user))
			dullahan = human.dna.species
			vision = human.getorganslot(ORGAN_SLOT_HUD)
			if(dullahan.headless && vision.viewing_head)
				emotelocation = dullahan.my_head

		user.log_message(msg, LOG_EMOTE)
		var/pre_color_msg = msg
		if (use_params_for_runechat) // apply puncutation stripping here where appropriate
			var/static/regex/regex = regex(@"[,.!?]", "g")
			pre_color_msg = regex.Replace(pre_color_msg, "")
			pre_color_msg = trim(pre_color_msg, MAX_MESSAGE_LEN)
		// Checks to see if we're emoting on the body while we have a head, or if we're emoting on the head.
		if(human && human.voice_color)
			msg = "<span style='color:#[human.voice_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>[emotelocation]</b></span> " + msg
		else
			msg = "<b>[emotelocation]</b> " + msg
		for(var/mob/M in GLOB.dead_mob_list)
			if(!M.client || isnewplayer(M))
				continue
			var/T = get_turf(emotelocation)
			if(M.stat == DEAD && M.client && (M.client.prefs?.chat_toggles & CHAT_GHOSTSIGHT) && !(M in viewers(T, null)))
				M.show_message(msg)
		var/runechat_msg_to_use = null
		if(show_runechat)
			runechat_msg_to_use = runechat_msg ? runechat_msg : pre_color_msg
		emotelocation.visible_message(msg, runechat_message = runechat_msg_to_use, log_seen = SEEN_LOG_EMOTE)

/datum/emote/living/stat_roll/select_message_type(mob/user, msg, intentional)
	return pick(attempt_message_list)

/datum/emote/living/stat_roll/strength
	key = "strength"
	key_third_person = "str"
	modifiers_list = list(
		TRAIT_BIGGUY = -1,
	)

	attempt_message_list = list(
		"tests their strength...",
		"puts their back into it...",
		"begins to flex...",
	)

	success_message_list = list(
		"is brimming with power!",
		"is truly beefy!",
		"shows off their muscle!",
	)

	failure_message_list = list(
		"is a little wet noodle...",
		"would lose in an arm wrestling match against a rous...",
		"should eat more sausage...",
	)

/mob/living/carbon/human/verb/emote_strength_roll()
	set name = "Roll Strength"
	set category = "Emotes"

	emote("strength", intentional = TRUE)

/datum/emote/living/stat_roll/perception
	key = "perception"
	key_third_person = "per"
	modifiers_list = list(
		TRAIT_KEENEARS = -1,
	)

	attempt_message_list = list(
		"takes a good, long look...",
		"focuses in...",
		"squints...",
	)

	success_message_list = list(
		"has eyes like a hawk!",
		"sees what others don't!",
		"has perfect 20/20 vision!",
	)

	failure_message_list = list(
		"is totally oblivious...",
		"has cataracts in their eyes...",
		"is blind...",
	)

/mob/living/carbon/human/verb/emote_perception_roll()
	set name = "Roll Perception"
	set category = "Emotes"

	emote("perception", intentional = TRUE)


/datum/emote/living/stat_roll/intelligence
	key = "intelligence"
	key_third_person = "int"
	modifiers_list = list(
		TRAIT_INTELLECTUAL = -1,
	)

	attempt_message_list = list(
		"thinks hard...",
		"furrows their brows...",
		"rubs their chin...",
	)

	success_message_list = list(
		"is a genius!",
		"has a mind sharp as a whip!",
		"knows what they're doing!",
	)

	failure_message_list = list(
		"is as dumb as a rock...",
		"has an empty head...",
		"couldn't put 2 and 2 together...",
	)

/mob/living/carbon/human/verb/emote_intelligence_roll()
	set name = "Roll Intelligence"
	set category = "Emotes"

	emote("intelligence", intentional = TRUE)

/datum/emote/living/stat_roll/constitution
	key = "constitution"
	key_third_person = "con"
	modifiers_list = list(
		TRAIT_NOPAIN = -1,
	)

	attempt_message_list = list(
		"tests their toughness...",
		"braces for impact...",
		"prepares to endure...",
	)

	success_message_list = list(
		"doesn't even flinch!",
		"is solid as an oak!",
		"is one tough nut to crack!",
	)

	failure_message_list = list(
		"has paper skin...",
		"would be torn to shreds by a light breeze...",
		"has a glass jaw...",
	)

/mob/living/carbon/human/verb/emote_constitution_roll()
	set name = "Roll Constitution"
	set category = "Emotes"

	emote("constitution", intentional = TRUE)

/datum/emote/living/stat_roll/willpower
	key = "willpower"
	key_third_person = "wil"
	modifiers_list = list(
		TRAIT_TOLERANT = -1,
	)

	attempt_message_list = list(
		"tests their willpower...",
		"gathers their courage...",
		"prepares to use their determination...",
	)

	success_message_list = list(
		"proves mighty!",
		"never gives up!",
		"persists through anything!",
	)

	failure_message_list = list(
		"is a weak willed chicken...",
		"gives up trying...",
		"faints when they get a splinter...",
	)

/mob/living/carbon/human/verb/emote_willpower_roll()
	set name = "Roll Willpower"
	set category = "Emotes"

	emote("willpower", intentional = TRUE)

/datum/emote/living/stat_roll/speed
	key = "speed"
	key_third_person = "spd"
	modifiers_list = list(
		TRAIT_LEAPER = -1,
		TRAIT_LIGHT_STEP = -1,
		TRAIT_NORUN = 2,
	)

	attempt_message_list = list(
		"prepares their moves...",
		"starts to get limber...",
		"tries to get speedy...",
	)

	success_message_list = list(
		"is in perfect control!",
		"is as agile as a cat!",
		"is very flexible!",
	)

	failure_message_list = list(
		"has two left feet...",
		"trips over themselves...",
		"is slower than a snail...",
	)

/mob/living/carbon/human/verb/emote_speed_roll()
	set name = "Roll Speed"
	set category = "Emotes"

	emote("speed", intentional = TRUE)

/datum/emote/living/stat_roll/fortune
	key = "fortune"
	key_third_person = "for"
	attempt_message_list = list(
		"tries their fortune...",
		"takes a chance...",
		"prepares to gamble...",
	)

	success_message_list = list(
		"could make an arrow turn around and climb back into the bow!",
		"has a rabbit's paw in their pocket!",
		"persists through pure luck!",
	)

	failure_message_list = list(
		"realizes the game was rigged from the start...",
		"gets dealt a bad hand...",
		"has the odds stacked against them...",
	)

/mob/living/carbon/human/verb/emote_fortune_roll()
	set name = "Roll Fortune"
	set category = "Emotes"

	emote("fortune", intentional = TRUE)

/datum/emote/living/stat_roll/charisma
	key = "charisma"
	key_third_person = "chr"
	modifiers_list = list(
		TRAIT_BEAUTIFUL = -1,
		TRAIT_EMPATH = -1,
		TRAIT_UNSEEMLY = 1,
		TRAIT_DISFIGURED = 2,
	)

	attempt_message_list = list(
		"tries to maintain their composure...",
		"attempts to appear impressive...",
		"contemplating their next move...",
	)

	success_message_list = list(
		"is brimming with self-confidence!",
		"has a true poker face!",
		"is the first crack in the sheer face of god, from them it will spread!",
	)

	failure_message_list = list(
		"is brimming with self-doubt...",
		"can't quite sell it...",
		"is holding it together with string and prayer...",
	)

/mob/living/carbon/human/verb/emote_charisma_roll()
	set name = "Roll Charisma"
	set category = "Emotes"

	emote("charisma", intentional = TRUE)
