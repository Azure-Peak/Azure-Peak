
//Unique assassin/antag dagger.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane
	name = "profane dagger"
	desc = "A profane dagger made from a cursed alloy. Whispers emanate from the glut on its hilt. </br>A chill rolls down my spine. I am not alone."
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/peculate, /datum/intent/dagger/thrust/pick)
	icon_state = "graggardagger"
	sheathe_icon = "graggardagger"
	embedding = list("embed_chance" = 0) // Embedding the cursed dagger has the potential to cause duping issues. Keep it like this unless you want to do a lot of bug hunting.
	// maybe add TRAIT_NOEMBED on initalize??? Fuck IDK man
	resistance_flags = INDESTRUCTIBLE
	stealthy_audio = TRUE

	// BEGIN THE STATJAKS.
	force = 24 // it actually always did 24 to non-targets this is just explicit. does 40 to targets. someone smarter than me replace it w/ extra pen.
	wdefense = 5 // antag weapon idfc man mercs get whatever these days and i want mercs dead
	max_integrity = 200 // ditto. hunting knife is actually 175 so this (shouldnt) be too crazy.

	var/last_spoken = 0 // prevent chatspam
	is_important = TRUE // do not let it be sold or whatever
	sellprice = 0

	// static list for what non-assassins hear on picking up the dagger.
	var/static/list/na_pleads = list(
		"Help me...",
		"Save me...",
		"It's cold...",
		"Free us... please...",
		"Necra... deliver us...",
		"I can still feel the pain...",
		"Break the dagger... please...",
	)
	// non-static list for last words. non-static bc we will add the last words of a peculated victim into our repetoire.
	var/list/last_words = list(
		"Why...",
		"...Who sent you?",
		"You will burn for what you've done...",
		"I hate you...",
		"GUARDS, STOP THEM!",
		"GUARDS! HELP!",
		"Someone stop them!",
		"...What's that in your hand?",
		"...You love me, don't you?",
		"Wait... don't I know you?",
		"I thought you were... my friend...",
		"What, you egg?",
		"How long have I been in here...?"
	)
	var/list/stored_souls = list()
	var/mob/living/dominator // set on dagger pickup if not on spell, for admin-intervention
	voicecolor_override = "3F5C6D"
	verb_say = "whispers"


/datum/profane_soul_data
	var/name
	// i couldnt get the ghosts to store well so we're just gonna check body & apply & remove DNR as needed cus thats close enough
	var/mob/living/carbon/human/body

/datum/profane_soul_data/New(mob/living/carbon/human/target)
	name = target.real_name
	body = target

/datum/profane_soul_data/Destroy(force, ...)
	if(!src.body)
		return
	src.remove_assassinate_traits()
	. = ..()

/// Removes the DNR & claimed by darkstar. CALL THIS BEFORE NUKING A SOUL_DATA.
/datum/profane_soul_data/proc/remove_assassinate_traits()
	if(!src.body)
		return
	if(HAS_TRAIT_FROM(src.body, TRAIT_DNR, GRAGGAR_ASSASSINATED))
		REMOVE_TRAIT(src.body, TRAIT_DNR, GRAGGAR_ASSASSINATED)
	if(HAS_TRAIT_FROM(src.body, TRAIT_CLAIMED_BY_DARKSTAR, GRAGGAR_ASSASSINATED))
		REMOVE_TRAIT(src.body, TRAIT_CLAIMED_BY_DARKSTAR, GRAGGAR_ASSASSINATED)

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_ASSASSIN))
		. += "<span style='color:#3F5C6D'>The profane dagger</span> whispers, " + span_cult("<i>\"...here we are!\"</i>")
	else if(HAS_TRAIT(user, TRAIT_DEATHSIGHT))
		. += span_gamedeadsay("This is the VILE DAGGER of a SOUL-THIEF! SLAY IT'S MASTER and BREAK IT by invoking a Necran ritual upon it!")
	if(stored_souls.len)
		// tried some bullshit w/ the expression being in here like the pale aura from dnr for practice
		. += span_gamedeadsay("You can hear [stored_souls.len] soul[stored_souls.len > 1 ? "s" : ""] screaming from within...")

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/twirl_success(mob/living/user)
	. = ..()
	// it funny
	if(world.time >= last_spoken + 3 SECONDS)
		to_chat(user, "<span style='color:#3F5C6D'>The profane dagger</span> whispers, " + span_cult("<i>\"YOU'RE GOING TO PAY FOR THIS!\"</i>"))
		last_spoken = world.time

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("This is a dagger used by the ASSASSIN antagonist. Targets who have the \"TARGETED\" vice can be soul-trapped \
	within it by use of it's PECULATE intent. If you are an assassin, slay your target, or wait until they have produced a \"BLED OUT\" \
	message in order to sap them with it.")
	. += span_info("PECULATE steals the face of any valid being, TARGETED or not. It is still a little buggy. It will not work on NPCs, revenants, \
	or oozelings. Their souls will still be trapped if they are valid, however.")
	. += span_info("BREAKING the dagger requires the assassin to be slain.")
	// keep this updated w/ absolver if that also gets added
	. += span_info("This dagger can be broken through a Necran Rite, a Bishop's blessing, or an Absolver's Golgatha blessing.")
	. += span_info("Breaking the dagger will restore the souls, allowing any ghosts who are still present in-round to be returned to their \
	bodies and revived.")
	. += span_redinfo("If you are an assassin, you can break any dagger you own by MMB'ing it. Please consider using this is if you are about to ERP \
	or similar. Thank you.")



/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pickup(mob/living/M)
	. = ..()
	var/picked_message = "Help us..."

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(HAS_TRAIT(H, TRAIT_ASSASSIN))
			// as a fallback, in case an admin spawns a new dagger for someone, we'll allow new ones to be taken on pickup().
			// check one: does dagger already have a master?
			if(!src.dominator)
				var/datum/antagonist/assassin/ass = H.mind.has_antag_datum(/datum/antagonist/assassin)
				if(ass)
					if(!ass.my_dagger)
						dominator = H
						ass.my_dagger = src
						to_chat(M, "<span style='color:#3F5C6D'>The profane dagger</span> whispers, " + span_cult("<i>\"YOU ARE THE LORD OF THIS WASTELAND!\"</i>"))
						return
			picked_message = pick(last_words)
		else
			H.add_stress(/datum/stressevent/profane)
			to_chat(H, span_danger("Your breath chills as you pick up the dagger. You feel a sense of morbid wrongness."))
			picked_message = pick(na_pleads)
		// whispers in the walls and such
		if(world.time >= last_spoken + 3 SECONDS)
			to_chat(M, "<span style='color:#3F5C6D'>The profane dagger</span> whispers, " + span_cult("<i>\"[picked_message]\"</i>"))
			last_spoken = world.time

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/Destroy()
	if(stored_souls.len)
		// any dagger destruction needs to release all the souls in it
		release_profane_souls()
	if(dominator && dominator.mind)
		// inform dominator if any
		to_chat(dominator, span_cult("I hear a faint screaming-- blood drips. My dagger has been destroyed."))
		var/datum/antagonist/assassin/ass = dominator.mind.has_antag_datum(/datum/antagonist/assassin)
		if(ass)
			// null the knife out. admins can spawn them a new one if they need to.
			ass.my_dagger = null
	// i THINK this should clear the list?
	stored_souls.Cut()
	. = ..()

// this is the stupidest way i can think to proof this against an assassin fucking off to erp all round after killing people.
// you get to break your own dagger & un-dnr them. you dont get another. Good Luck!
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/MiddleClick(mob/user, params)
	. = ..()
	if(!ishuman(user))
		return
	if(dominator != user)
		return
	var/mob/living/carbon/human/daggermaster = user
	if(user.mmb_intent)
		return ..()
	to_chat(daggermaster, span_cult("I consider breaking my own dagger..."))
	var/are_you_sure = input(daggermaster, "Are you sure you wish to shatter your own dagger?", "ARE YOU SURE?") as anything in list("Yes", "No")
	if(are_you_sure == "Yes")
		var/are_you_really_sure = input(daggermaster, "Are you REALLY SURE you wish to shatter your own dagger?", "GUESS WHO GOT HIS DAGGER...") as anything in list("Yes", "No")
		if(are_you_really_sure == "Yes")
			to_chat(user, "<span style='color:#3F5C6D'>The profane dagger</span> whispers, " + span_cult("<i>\"MASTER... NO!\"</i>"))
			var/are_you_triple_sure = input(daggermaster, "Are you REALLY, REALLY SURE wish to shatter your own dagger?", "THINK, MASTER, THINK!") as anything in list("Yes", "No")
			if(are_you_triple_sure == "Yes")
				playsound(daggermaster, 'sound/misc/adrenaline_rush.ogg', 20, FALSE, -4)
				daggermaster.visible_message(span_warning("[daggermaster] begins to break their own cursed dagger..."), span_artery("THIS IS ONENESS..."))
				if(do_after(daggermaster, 10 SECONDS, same_direction = TRUE))
					playsound(daggermaster, 'sound/misc/bellold.ogg', 20, FALSE, -4)
					daggermaster.visible_message(span_warning("[daggermaster] breaks their own dagger! Wayward souls pour free!"), span_artery("...AND ANNIHILATION!"))
					// no triumphs for you. bad.
					var/remove_triumphs = release_profane_souls() * -1
					daggermaster.adjust_triumphs(remove_triumphs)
					to_chat(user, "<span style='color:#3F5C6D'>The profane dagger</span> whispers, " + span_cult("<i>\"WE HAD SO MUCH FUN TOGETHER! YOU LOVE ME, RIGHT?!\"</i>"))
					qdel(src)
					return TRUE
	to_chat(daggermaster, span_cult("I push aside the thought of breaking my poor, poor dagger..."))


/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pre_attack(mob/living/carbon/human/target, mob/living/user = usr, params)
	if(!istype(target))
		return FALSE
	if(target.has_flaw(/datum/charflaw/targeted)) // dagger deals more dmg to ppl who r targeted
		force = 40	//vs trait havers, 2x damage over a steel knife
		update_force_dynamic()
	else
		force = 24
		update_force_dynamic()
	return FALSE

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/afterattack(mob/living/carbon/human/target, mob/living/user = usr, proximity)
	. = ..()
	// FIRST. we check for peculate.
	// WEWHO'S NOTE: this could probably be changed to be /datum/intent/proc/spec_on_apply_effect for peculate. i'm not doing it rn though.
	if(istype(user.used_intent, /datum/intent/peculate))
		// are they allowed to use this
		if(!can_peculate(target, user))
			return

		// run a health check on the target. if they're not dead enough, return us early.
		if(!target_health_check(target))
			to_chat(user, span_warning("My target must be a bit more dead! Let them bleed!"))
			return

		if(!ishuman(user))
			return
		var/mob/living/carbon/human/human_user = user

		if(!head_check(target, human_user))
			return

		// send a message. everyone know what we're doing.
		human_user.visible_message(span_cultbigbold("[human_user] places [human_user.p_their()] dagger into [target]'s chest, murmuring heresies... \
												STOP [human_user.p_them()]!!"), span_cult("I beckon the Dark Star, beginning to confirm my blood-bounty."))

		to_chat(human_user, span_artery("\"De-za-kh...\""))

		// INITIATE GRAGGAR BEAM.
		var/datum/beam/transfer_beam = user.Beam(target, icon_state = "drain_life", time = 10 SECONDS)

		playsound(human_user, 'sound/magic/soulsteal_2.ogg', 80, TRUE)

		if(!do_after(human_user, 5 SECONDS, target = target))
			qdel(transfer_beam)
			return
		playsound(user, 'sound/magic/soulsteal_2.ogg', 80, TRUE)
		to_chat(human_user, span_artery("\"...a-da-sh...\""))

		if(!do_after(human_user, 5 SECONDS, target = target))
			qdel(transfer_beam)
			return
		playsound(human_user, 'sound/magic/soulsteal.ogg', 80, TRUE)
		to_chat(human_user, span_artery("\"...ba-a-ha-v!\""))

		if(!human_user.client)
			qdel(transfer_beam)
			return
		qdel(transfer_beam)
		// graggar beam worked w/ no interruptions. domp eet.

		// fetch a face_flag bc we're going to need it to assume they've been yoinked once or smthn. idk i dont want to add anotehr trait rn
		var/face_flag = face_wound_check(target, human_user)
		// we need to check to make sure we can face-steal them
		if(preliminary_face_steal_check(target, human_user) && face_flag)
			// do it, if we can
			human_user.copy_physical_features(target) // this needs replacement to more changeling type shit later
			to_chat(user, span_cult("I take on a new face..."))
			// apply a facial disfigurement that can be healed thru surgery
			target.visible_message(span_danger("[target]'s face bubbles and froths off, leaving behind a mess of exposed blood-and-bone. Perhaps surgery could repair it...?"))
			var/obj/item/bodypart/head = target.get_bodypart(BODY_ZONE_HEAD)
			head?.add_wound(/datum/wound/facial/disfigurement)
		else
			to_chat(user, span_cult("I can't take on this one's face."))

		// they die either way. we dont get last words if they've got a pre-existing disfigurement.
		die_motherfucker_die(target, get_last = face_flag)

		// they get yoinked either way
		if(target.has_flaw(/datum/charflaw/targeted)) // The profane dagger only thirsts for those who are targeted, by flaw or by zizoid curse.
			if(HAS_TRAIT(target, TRAIT_CLAIMED_BY_DARKSTAR)) // no doubling up if theyre already claimed
				return FALSE
			init_profane_soul(target, user)
/// This proc confirms that the user/target is a viable, face-stealable thing
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/preliminary_face_steal_check(mob/living/carbon/human/target, mob/living/user)

	if(!ishuman(target)) // carbons don't have all features of a human
		return FALSE
	if(!ishuman(user)) // carbons don't have all features of a human
		return FALSE
	var/mob/living/carbon/human/assassin = user

	// BEGIN THE LOOPS.
	var/user_workable_species = species_check(assassin)
	var/target_workable_species = FALSE
	// only check if the user is workable to avoid extra loops
	if(user_workable_species)
		target_workable_species = species_check(target)
	if(!user_workable_species || !target_workable_species)
		return FALSE
	// everything went well
	return TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/species_check(mob/living/L)
	if(!ishuman(L))
		return FALSE
	var/mob/living/carbon/human/H = L
	// this should be a define of every "non-weird" species. in this case, it's just missing construct & revenant.
	// this is fine though because this should be more of a whitelist check than a blacklist since it's so finnicky
	var/static/list/check_list = list(\
	/datum/species/human/northern,\
	/datum/species/human/halfelf,\
	/datum/species/elf/dark,\
	/datum/species/elf/wood,\
	/datum/species/elf/sun,\
	/datum/species/dwarf/mountain,\
	/datum/species/tieberian,\
	/datum/species/aasimar,\
	/datum/species/lizardfolk,\
	/datum/species/lupian,\
	/datum/species/tabaxi,\
	/datum/species/vulpkanin,\
	/datum/species/akula,\
	/datum/species/moth,\
	/datum/species/dracon,\
	/datum/species/anthromorph,\
	/datum/species/anthromorphsmall,\
	/datum/species/demihuman,\
	/datum/species/halforc,\
	/datum/species/kobold,\
	/datum/species/goblinp,\
	/datum/species/ooze,\
	/datum/species/dwarf/gnome\
	)
	for(var/checked_species in check_list)
		if(istype(H.dna.species, checked_species))
			return TRUE
	return FALSE


/// Checks if the user is allowed to peculate in the first place. Adjacent, trait check, whatever.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/can_peculate(mob/living/carbon/human/target, mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_ASSASSIN))
		to_chat(user, "<span style='color:#3F5C6D'>The profane dagger</span> whispers, " + span_cult("<i>\"HEHEHE, HEHEHE!\"</i>"))
		return FALSE
	if(!user.Adjacent(target))
		to_chat(user, span_warning("I must be adjacent to my target!"))
		return FALSE
	return TRUE

/// This proc checks if the user & target both have heads. Returns TRUE if both do. Returns FALSE if either is missing. Handles cases w/ a to_chat.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/head_check(mob/living/carbon/human/target, mob/living/carbon/human/user)
	var/obj/item/bodypart/head/target_head = target.get_bodypart(BODY_ZONE_HEAD)
	if(QDELETED(target_head))
		to_chat(user, span_notice("I need their head or else I can't confirm the blood-bounty!"))
		return FALSE

	var/obj/item/bodypart/head/user_head = user.get_bodypart(BODY_ZONE_HEAD)
	if(QDELETED(user_head))
		to_chat(user, span_notice("...where's my head at?"))
		return FALSE
	// everything went ok
	return TRUE

/// This proc checks if either assassin or target have a facial disfigurement wound. Prevents repeat-peculates. Returns TRUE if neither target or user has a disfigurement.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/face_wound_check(mob/living/carbon/human/target, mob/living/carbon/human/user)
	// TODO IN THE FAR FAR FUTURE: check for TRAIT_FACELESS_ASSASSIN that auto returns false w/ no msg. faceless wont be able to skinthief.
	var/obj/item/bodypart/head/target_head = target.get_bodypart(BODY_ZONE_HEAD)
	var/obj/item/bodypart/head/user_head = user.get_bodypart(BODY_ZONE_HEAD)
	if(QDELETED(target_head) || QDELETED(user_head))
		return FALSE
	// heads exist. get head wounds. check wounds.
	if(target_head?.has_wound(/datum/wound/facial/disfigurement))
		return FALSE
	else if(user_head?.has_wound(/datum/wound/facial/disfigurement))
		return FALSE
	// everything went well. return true.
	return TRUE


/// This check returns TRUE if the target is DEAD, in InCritical(), or has a dying amount of blood.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/target_health_check(mob/living/carbon/human/target)
	if(target.stat == DEAD || target.InCritical() || target.blood_volume <= BLOOD_VOLUME_SURVIVE)
		return TRUE
	return FALSE

/// This proc ensures the target is dead with death() and adds their last words to the dagger's list if get_last = true.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/die_motherfucker_die(mob/living/carbon/human/target, get_last = TRUE)
	if(target.stat != DEAD)
		target.death()
	if(get_last && target.last_words)
		last_words += target.last_words

/// This proc records the assassination, the criminal stat, makes a new soul datum, adds it to the dagger's list, gives a triumph, and fixes the blade/integrity.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/init_profane_soul(mob/living/carbon/human/target, mob/user, mob/soul)
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_ASSASSINATIONS)

	var/datum/profane_soul_data/new_soul = new(target)

	src.stored_souls += new_soul
	// target gets DNR & a unique trait to prevent being yoinked a second time.
	// removed when the dagger is broken by any means OR if the soul is deleted.
	ADD_TRAIT(target, TRAIT_DNR, GRAGGAR_ASSASSINATED)
	ADD_TRAIT(target, TRAIT_CLAIMED_BY_DARKSTAR, GRAGGAR_ASSASSINATED)

	target.visible_message(span_cult("A purple mist spews forth from [target]'s chest, entering [user]'s [src.name]... their soul has been taken!"),
	span_cult("I find myself in a strange realm, vantablack save for vestiges of a heavy blue-and-red fog. Screams surround \
	me. The pain from all my wounds is not only present, but intensified! How long will I be trapped in here?!"))
	playsound(src, 'sound/magic/soulsteal.ogg', 100, extrarange = 5)
	blade_int = max_blade_int // Stealing a soul successfully sharpens the blade.
	obj_fix(max_integrity) // And fixes the dagger. No blacksmith required!
	user.adjust_triumphs(1)





/// Loops thru all souls and qdels them. If user is specified, gives soul# in triumphs. Returns amount of souls freed.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/release_profane_souls(mob/user) // For ways to release the souls trapped within a profane dagger, such as a Necrite burial rite. Returns the number of freed souls.
	var/freed_souls = 0
	for(var/datum/profane_soul_data/soul in stored_souls)
		freed_souls++
		if(soul.body && !QDELETED(soul.body))
			var/mob/living/carbon/human/H = soul.body
			var/mob/dead/observer/playerghost = H.get_ghost(TRUE, TRUE)
			if(playerghost)
				to_chat(playerghost, "<b>I have been freed from my vile prison! I await revival, or Necra's cold grasp... SALVATION!</b>")
			else
				to_chat(H, "<b>I have been freed from my vile prison! I await revival, or Necra's cold grasp... SALVATION!</b>")
			src.visible_message(span_cult("The soul of [soul.name] flows out from the profane dagger, finally free of its grasp. Revival may be possible!"))
			// qdel handles removing traits
			qdel(soul)
		else
			// fallback in case body is missing for some reason
			src.visible_message(span_cult("The soul of [soul.name] flows out from the profane dagger, finally free of its grasp... yet it quickly fades. Perchance it could not find it's body...?"))
			qdel(soul)
	if(user)
		user.adjust_triumphs(freed_souls)
	return freed_souls

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/shatter_dagger()
	src.visible_message(span_cult("The profane dagger shatters into putrid smoke!"))
	qdel(src)

/// If the dagger has a "dominator" and that dominator is alive, returns false. Otherwise returns true.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/is_my_owner_dead()
	if(dominator && !QDELETED(dominator))
		var/mob/living/carbon/human/dom = dominator
		if(dom.stat != DEAD)
			return FALSE
	return TRUE


/*
								THIS RITUAL CHANNELED THROUGH
									TABERNAKEL des
									ROTEN PHOENIX
					+&&&&+                          +&&&&&+
					&&&&&&                          &&&&&&&
					&&&&x&&&&&&+                  +&&X;;;&&
					+&&&&+;&&&&&&&+               &&&;.  $&
						x&&&&;::&&&&&&$        +&&&&&:;.:X&X              +&&&+
							&&;;+;:+&&&&        &&&&&$+$$&&X:              &&&&&
	+&&&+                  X&&&&;:.;.&&&&+   +&&&;; :;&&X:            X&&&&x&&&
	&&&&&&&&+              :X$&&$x+:;xx$&&   &&Xx:;xX&&&            +&&&&&&$&&+
	&&& &&&&&                 $$ :X&&$xx&&   &&x$&&X;.$$            &&&;$$$&&
	+&&&+;.&&&+               $$...::   x$$$$$x .::   XX      +&&&&&&$;+X&&&$
		&&++;+&&&&&&+        :X$$x  .:+xXX&&&&&&&XXXXx+;$&$$$&&&&&&&&&$ ;:$&&X:
		&&&&&; +&&&&&        X&$X;..:;x$&&&&&&&&&&&&$x+;x$$$$&&&&X;:+XX;. $&
		x&&&&&;:;;.&&&+   :X$&$;;;;+xXXx;;xX$$$$$$x;+xxXX+;;;:.;;xXXx::+X$&X
			&&;x;:.+&&&&&&&&&&X+;;;;xx;. .;++++++++:.;++x+;;;;..:+$X;. X&$X:
			X&$$XX:::X&&&&$x;;:    .+;   :+:     .+:   :+:   .::::.. ..$X
			:X&$.;xx+ :xx.:;::;;;;;;xx;. .;+++++++;:.;++x+;;;;:::. ..  XX
			&$ .;X$X;++::;::;++;: ;X$X++X$&&&&&$XxxXXX:.:;++;:;;:::..XX
			X&$$X;;X&$::xXXX$&&&$x:.+xx+++++++++++++:.+X$$&&$Xx+;;;..$x&&&&&&&&&&&+
			X&&&$x; .::;x$&&&&x::;Xx ;;:       :;:.xX+.;X&&&&X+::;..$X&&&&&&&&&&&&
				:+$X;: ;xX&&&&&&&X+:::.:;;:. .:;:..:::x$&&&&&&$x+; :.XX&.::::::. &&&&&&&+
	+&&&&+     +&&&&&&&;;:::.    :;;x$&$.. .:;:.::: . ;&&$+;;.   .:::++++;$+......::;&&&&&&&&&&&+
	&&&&&&     &&&&&&$x ;+:      :xx+..;++..;xx+x;: ;++;.;xx;       +x.;:.x$XXXXXXXx;;;;;;x&&&&&&
	&& .&&&&&&&&&;+x.:+;;+:      ;+:+: .;;;::+;;+..++;: :+:+;       +x;;;.;xxxxxxx+;::::;x+ +:+&&
	&&&&+&&&&&&&+ :x;.;::::.:::;+;: :;++;:::;x+;+;;:::;;;: :;++;::..:;..:...    :X$$$$$$&&&&&&&&+
	+&&&&&&x;+X$$$XX+ ;;:::;+xX$&&&&&&&&$x:..xx+x;.:+xX&&&&&&&&$X+;:;+;;xxX$$$$$&&&&&&&&&&&&&&&+
	x&&&;::;++++;:.;.::.....;::;;;::;: :xX&&X&$X+. .:;+;;:.:;:...::..&&X$$$$$X:
		X&$$$$$$$$$Xxx;: . .;+x$&&&&&&$x;:;;+;:+:;;;;+$&&&&&&&X+: . :;;x&&&+
		;X&$$$$$$$$X$X..:;;;.  ::. .. ...;x$&&&&$Xx: .. .  .:. ..:;;:..;&&&&
			+&&&&&&X :+;:;. ..+&&&&x: .;+xX$$Xxx+:. :X&&&&; . .;:;+ :;;;$&&&&&x
			+&&&&&&&&x::+;:;. ..&&$&&xx&&X;.+&&X;:x&&X+X&&&&x .  ;;+x :::; X&&&&&&&&x
		+&&&X:::x$X:.;;;:  ..&&&&x.X&&&&x&&&&$x&&&&;:&&&&x .  :;+; .  .;;+xx.&&&&&
		+&&&&+ ;xXx+;:.... .;::.$&$$+ X&X$+ $&$$;.&$$$;:$$&&+:;;: ..;+x;  ..:+xXx++&&&+
	+&&&&X:::+XX+... .. :;;;+x&&.Xx.+x.+; x+:+: x;;+:;&;x&$Xx;;;  X$&X     .:++:;+X&&&&&x
	&&&.;;;;;x$$$$$$XX$$$x  +$+X&&x.X&&&+ &&&&+.&&&$;:&&&;+X; .xX$&XX&$$$$$$&&&&&x;;&&&&&
	+&&&x&&&&&&&&&$$$$$Xx;.X$;:x+;+:..:&&&&X;&&&&x+&&&&x:::;+;;x;;xX;xx:X$$$$$$&&&&&&&&&&&&&&+
	&&&&x&&&$$$$X:   +&&&&$x;;x$X+.xx;.;xx::::&&x ::+x+.:Xx+ +$&+; &&&&&&+         :X&&&&&x&&&
	&&&&&&           &&&&;.. .+X$$X:+;:+$&&&$&x;X$$&&$x:;x:+$$$x.:+:.;&&&&               &&&&&
	+&&&&+           && ;; .. .;$&&$X+;xx...:$X:Xx:..;x:;X$$X+:  .:;;:  &&               +&&&+
				+&&&;x+.....+$&&++++$&$$$$&X;X$$$$$$x+x$X+:     .:;;;&&&&+
				&&&X.+x: :+XXXx&&X: ;X$&&$X+:xX$&&$x:.    ::;    .:;; X&&&
				&&:.XXxxX&&$X;:X&&+. .:::::. .;x;:. ......xx&$$$$X:  :;;$&&&+
			+&&&&&+&&&&&&X:      x$x..     ...+;x         Xx X$$$&&$&&$++&&&&&+
			&&&&X+$&&$$X:        :X&x:.:::....$ $..   .:::;X&X   :X$$$&&.  +&&&
			&&+x$$x&X              &&;;;;;;x$$&;&$$x;+X$Xx;;&&        &&&&&&&&&
			+&&&&&&&&X:              &&$$x: &&$&X;X$$&&$x.:;x$&&        +&&&&&&&+
			&&&x&&&&x                &&..;+;&&       +&&&X+:: &&
			&&&&&                  x&&&X$xX$&X         &&;++++&&
			+&&&+                  &&&.$&&&&X:         X&&$X+;&&
									&&+:&&$X:           :X$&&. &&
								+&&&x&&&&                 &&++&&
								xx +&&&&+                 &&&&&&
								+&&&&+                    +&&&&+
*/
