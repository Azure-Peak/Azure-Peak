////////////////////////
// ASSASSIN EQUIPMENT //
////////////////////////

/*
Due to the INANE amount of procs the dagger requires, I have decided to move it out of special.dm and into here. If you're reading this, that worked
fine or I forgot to remove this. The avantyne lockpick is also here. Any future equipment specific to assassin, such as FACELESS gear or anything else
we happen to commission/code should GO IN HERE. Thanks.
*/

/datum/intent/face_steal // FACE MELTER HELTER SKELTER
	name = "face steal"
	hitsound = null
	desc = "Thieve the appearance of another." + span_graggarsmall("\nUsing this intent on a window that can be opened will open it. \
	Be warned, it's obvious you're a heretic when you do this.")
	icon_state = "insteal"
	max_intent_damage = 0

/datum/intent/face_steal/examine(mob/user)
	// little flavor for non-assassins lookin at it
	if(!HAS_TRAIT(user, TRAIT_ASSASSIN))
		switch(rand(0,3))
			if(0)
				to_chat(user, span_graggarsmall("The profane dagger says, \"You are unworthy, mortal.\""))
			if(1)
				to_chat(user, span_graggarsmall("The profane dagger says, \"Hehe... hehehe...\""))
			if(2)
				to_chat(user, span_graggarsmall("The profane dagger says, \"Are you my next master...?\""))
			if(3)
				to_chat(user, span_graggarsmall("You look closely at the dagger. Every hair on your body raises-- you are not alone."))
		return
	// call the normal examine IF they have the trait
	..()

//Unique assassin/antag dagger.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane
	name = "profane dagger"
	desc = "A profane dagger made from a cursed alloy. Whispers emanate from the diamond on its hilt. </br>A chill rolls down my spine. I am not alone."
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/dagger/thrust/pick, /datum/intent/face_steal)
	sellprice = 0 // this shouldnt be del'able by merchant means
	icon_state = "graggardagger"
	sheathe_icon = "graggardagger"
	embedding = list("embed_chance" = 0) // Embedding the cursed dagger has the potential to cause duping issues. Keep it like this unless you want to do a lot of bug hunting.
	resistance_flags = INDESTRUCTIBLE // this has to be destroyed by a necran
	stealthy_audio = TRUE
	var/stolen_faces = list()
	var/attached_assassin = null // if an assassin picks up a dagger, it gets "attached" to them for later use.
	var/graggar_boy_points = 0
	var/total_souls_taken // backup incase going to the underworld fucks up the soul-theft

	// For the sake of making these easier to edit, we're going to store these lines on the dagger.
	var/static/list/na_pleads = list(
		"Help me...",
		"Save me...",
		"It's cold...",
		"Free us... please...",
		"Necra... deliver us...",
		"I can still feel the pain...",
		"Break the dagger... please...",
	)

	// This is A NON STATIC list bc of future intentions.
	// HOPES AND DREAMS: Add the last words of any given soul-stolen victim in the same vein as the
	// way it's recorded on round-end. This SHOULD be doable.
	var/list/last_words = list(
		"Why...",
		"...Who sent you?",
		"You will burn for what you've done...",
		"I hate you...",
		"Guards, stop them!",
		"GUARDS! HELP!",
		"Someone stop them!",
		"...What's that in your hand?",
		"...You love me, don't you?",
		"Wait... dont I know you?",
		"I thought you were... my friend...",
		"What, you egg?",
		"How long have I been in here...?",
	)

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_ASSASSIN))
		. += span_cultsmall("[src] whispers, \"...here we are!\"")

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pickup(mob/living/M)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		// TODO: FORCE A DROP & MOOD MIFF
		if (!HAS_TRAIT(H, TRAIT_ASSASSIN)) // Non-assassins don't like holding the profane dagger.
			to_chat(H, span_danger("Your breath chills as you pick up the dagger. You feel a sense of morbid wrongness!"))
			H.add_stress(/datum/stressevent/profane)
			var/message = pick(na_pleads)
			to_chat(H, span_gamedeadsay("[src] whispers, \"[message]\"")) // i tried making the dagger actually whisper but no this is the best we're getting.
		else
			// i fucking haaate the fact this checks EVERY pickup when i just want it to RUN ONCE!! F UCK!!
			if(!attached_assassin) // first assassin to pick up a dagger "claims" it
				// Someone find a better way to do this, please.
				var/datum/antagonist/assassin/villain = H.mind.has_antag_datum(/datum/antagonist/assassin)
				if(!villain.attached_knife) // no doubling up
					to_chat(H, span_graggarsmall("As you pick up the dagger, it recognizes you as it's master. " + span_graggarsmallanimated("DESTROY. DESPOIL. DOMINATE.")))
					// They are both now linked to each other. This is needed for later shitcode.
					attached_assassin = H
					villain.attached_knife = src
					// we want you to always have your own face for later use
					var/datum/stolen_face/your_face = new
					your_face.steal_face(H) 
					stolen_faces += your_face
				
			// this goes second for looks reasons
			var/message = pick(last_words)
			to_chat(H, span_gamedeadsay("[src] whispers, \"[message]\"")) // i tried making the dagger actually whisper but no this is the best we're getting.

// when you use the item via interact...
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/attack_self(mob/user)
	. = ..()
	// TEMP -- FOR DEBUGGING PURPOSES
	release_profane_souls(user)
	/* TODO:
	// TRY TO BUILD SOME SORT OF RADIAL MENU. MAYBE STEAL CODE FROM SLAPCRAFTING BC I THINK THERE WERE RADIALS FOR THAT.alist
	// WE WANT TO BE ABLE TO USE THE APPLY FACE OR WHATEVER I CALLED IT PROC, PREFERABLY W/ A LITTLE HEAD ICON TO SHOW
	// WHAT WE'RE TURNING INTO. ALSO A NAME IF POSSIBLE. WE'LL SEE.

	// ALSO TODO: RANCOR -- TIME LIMITED BUFF BASED ON # OF PEOPLE KILLED / SOULS IN DAGGER.
	*/

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pre_attack(atom/A, mob/living/user = usr, params)
	var/mob/living/carbon/human/H = user
	var/obj/structure/roguewindow/openclose/selectedwindow = null
	// non-assassins dont know how to Use the Window Opener.
	if(HAS_TRAIT(H, TRAIT_ASSASSIN))
		var/woke = user.p_their() // cacheing this cause we use it like 4 times lol
		// creep functionality has bene placed on the dagger itself as an inherent ability. steal wintent a window. it'll open.
		if(istype(A, /obj/structure/roguewindow/openclose))
			selectedwindow = A
		if((selectedwindow) && (istype(H.used_intent, /datum/intent/face_steal)))
			// ensure its not already open
			if(selectedwindow.climbable)
				to_chat(H, span_warning("That window is already open!"))
				return 
			// 1s delay
			if(do_after(H, 1 SECONDS, FALSE, selectedwindow, TRUE, null, TRUE, TRUE))
				if(prob(1)) // shoutout to crowbar and my other oomfs for playing graggar 4 me b4 this class existed
					H.visible_message(span_graggar("[H] pricks [woke] finger on [woke] dagger, drawing a heretical symbol on the window..."), span_graggaranimated("You open a hole. The feeling is strangely familiar."))
				else
					H.visible_message(span_graggar("[H] pricks [woke] finger on [woke] dagger, drawing a heretical symbol on the window..."))
				selectedwindow.force_open()
				selectedwindow.visible_message(span_warning("[selectedwindow] suddenly opens with a cacophanous crash!"))

	// handle damage here
	var/mob/living/carbon/human/target = A
	if(!istype(target))
		return FALSE
	if(target.has_flaw(/datum/charflaw/hunted)) // Check to see if the dagger will do 20 damage or 14
		force = 20 * 2	//vs trait havers, 2x damage over a steel knife
	else
		force = 20 + 4	//vs non-trait havers, 4 more damage over a steel knife
	return FALSE

/*TODO:
// fix this
// sound/misc/zizo.ogg, 25
*/
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/afterattack(mob/living/carbon/human/target, mob/living/user = usr, proximity)
	. = ..()
	// leaving this out of the rewritten logic flow below cus idk if it was there 4 a reason
	if(!ishuman(target))
		return
	if(!ishuman(user)) // carbons don't have all features of a human
		to_chat(user, span_danger("You can't do that!"))
		return
	if(istype(user.used_intent, /datum/intent/face_steal))
		// PRELIMINARY CHECKS.
		if(!HAS_TRAIT(user, TRAIT_ASSASSIN))
			to_chat(user, span_smallred("I AM NOT WORTHY!!"))
			return
		if(!user.Adjacent(target))
			to_chat(user, span_smallred("I must be adjacent to my target!"))
			return
		if(HAS_TRAIT(target, TRAIT_KOH))
			to_chat(user, span_graggarsmall("I cannot steal someones face twice."))
			return
		// DEATH/CRIT CHECK. ITS STUPID. ITS SO STUPID. INCRITICAL() IS SUCH A SPECIFIC THING.
		if(target.stat == DEAD || target.InCritical()) // Trigger soul steal or identity theft if the target is either dead or in crit
			var/obj/item/bodypart/head/target_head = target.get_bodypart(BODY_ZONE_HEAD)
			if(QDELETED(target_head))
				to_chat(user, span_notice("I need their head or else I can't confirm the blood-bounty!"))
				return
			// ok, everything is fine. lets start the transfer process. you have time to interrupt it.
			user.visible_message(span_graggaranimated("[user] begins sucking [target]'s soul into their dagger! STOP THEM!!"), span_graggar("I beckon the Dark Star, beginning to confirm my blood bounty..."))
			var/datum/beam/transfer_beam = user.Beam(target, icon_state = "drain_life", time = 16 SECONDS)
			playsound(user, 'sound/magic/soulsteal_2.ogg', 80, TRUE)
			if(!do_after(user, 8 SECONDS, FALSE, target, no_interrupt = FALSE))
				qdel(transfer_beam)
				return
			playsound(user, 'sound/magic/soulsteal_2.ogg', 80, TRUE)
			if(!do_after(user, 8 SECONDS, FALSE, target, no_interrupt = FALSE))
				qdel(transfer_beam)
				return
			// all done! 
			playsound(user, 'sound/magic/soulsteal.ogg', 80, TRUE)
			var/datum/stolen_face/new_face = new // heyyy we want sum new face
			new_face.steal_face(target)
			stolen_faces += new_face
			// human_user.copy_physical_features(target)
			to_chat(user, span_graggar("I take on a new face..."))
			ADD_TRAIT(target, TRAIT_DISFIGURED, TRAIT_GENERIC)
			ADD_TRAIT(target, TRAIT_KOH, TRAIT_GENERIC)
			// hunted interactions
			if(target.has_flaw(/datum/charflaw/hunted)) // The profane dagger only thirsts for those who are hunted, by flaw or by zizoid curse.
				if(target.client == null)
					to_chat(user, span_graggarsmall("My target's soul has left their body. I can try to call it back..."))
					get_profane_ghost(target, user)
				else
					// if you arent a ghost you are now you little shit
					target.ghostize(TRUE, FALSE, FALSE, FALSE, TRUE)
					get_profane_ghost(target, user)
		
			target.death() // kill em to make sure
			target.set_ssd_indicator(FALSE) // jank but needed
		else
			to_chat(user, span_warning("They aren't quite dead enough! You may need to wait a minute..."))
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/get_profane_ghost(mob/living/carbon/human/target, mob/living/user)
	// we dont have an underworld, so this proc strictly checks to see if a ghost already exists.
	var/mob/dead/observer/chosen_ghost
	// we do that by get.ghosting() the target. 
	chosen_ghost = target.get_ghost(TRUE, TRUE)
	// if none exist, just return false.
	if(!chosen_ghost || !chosen_ghost.client)
		to_chat(user, span_warning("Something is wrong... there's no spirit summoned! Perhaps I can summon it...?"))
		chosen_ghost = target.grab_ghost(TRUE)
		if(chosen_ghost)
			init_profane_soul(chosen_ghost, target, user)
			message_admins("caught [chosen_ghost] in force-grabber")
			return TRUE
		return FALSE
	// else, let's put 'em thru the profaner.
	init_profane_soul(chosen_ghost, target, user)
	// delete the old ghost.
	qdel(chosen_ghost)
	return TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/init_profane_soul(mob/dead/observer/chosen_ghost, mob/living/carbon/human/target, mob/living/user)
	record_featured_stat(FEATURED_STATS_CRIMINALS, user)
	record_round_statistic(STATS_ASSASSINATIONS)
	
	//-- FULL DISCLOSURE. -- 
	//This has to deal with components and I Dont Know How the Fuck They Work. This was ""intern"" (AI) assisted. Sorry.
	
	var/mob/dead/observer/profane/S = new /mob/dead/observer/profane(src)
	S.AddComponent(/datum/component/profaned, src)

	// put the client in the new ghost
	S.key = chosen_ghost.key
	// del the old one
	qdel(chosen_ghost)
	// set their ghost's features = their body...
	S.name = "soul of [target.real_name]"
	S.real_name = "soul of [target.real_name]"
	S.deadchat_name = target.real_name
	S.original_body = target	
	S.language_holder = target.language_holder.copy(S)

	// effects on game world
	target.visible_message(span_danger("[target] has their soul PLUCKED FROM THEIR BODY and placed into the PROFANE DAGGER!"), span_danger("MY SOUL IS TRAPPED WITHIN THE DAGGER! I hear a HORRID WAILING... EVERYTHING HURTS!!"))
	playsound(src, 'sound/magic/soulsteal.ogg', 100, extrarange = 5)
	user.adjust_triumphs(1)
	// boons
	src.restore_bintegrity() // Stealing a soul successfully sharpens the blade.
	obj_fix(max_integrity) // And fixes the dagger. No blacksmith required!

	total_souls_taken += 1

	if(HAS_TRAIT(target, TRAIT_NOBLE) || HAS_TRAIT(target, TRAIT_CRITICAL_WEAKNESS))
		// double points for treading on the weak and those who would put themselves above you
		src.graggar_boy_points += 2
	else
		src.graggar_boy_points += 1

/*
WE DO NOT CURRENTLY USE THE UNDERWORLD. IF WE EVER GET IT BACK, FOR SOME REASON, THE CODE IS SAVED HERE FOR POSTERITY.
- MUMBLEMANCER
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/get_profane_ghost(mob/living/carbon/human/target, mob/user)
	var/mob/dead/observer/chosen_ghost
	var/mob/living/carbon/spirit/underworld_spirit = target.get_spirit() //Check if a soul has already gone to the underworld
	if(underworld_spirit) // If they are in the underworld, pull them back to the real world and make them a normal ghost. Necra can't save you now!
		var/mob/dead/observer/ghost = underworld_spirit.ghostize()
		chosen_ghost = ghost.get_ghost(TRUE,TRUE)
	else //Otherwise, try to get a ghost from the real world
		chosen_ghost = target.get_ghost(TRUE,TRUE)
	if(!chosen_ghost || !chosen_ghost.client) // If there is no valid ghost or if that ghost has no active player
		return FALSE
	user.adjust_triumphs(1)
	init_profane_soul(target, user) // If we got the soul, store them in the dagger.
	qdel(target) // Get rid of that ghost!
	return TRUE
*/

// this is ai bc the loop got fucking weird w/ the components.
/obj/item/rogueweapon/huntingknife/idagger/steel/profane/proc/release_profane_souls(mob/user)
	var/freed_souls = 0
	message_admins("dagger engaged") // debug
	message_admins("src content: [src.contents]")
	message_admins(" len : [length(src.contents)]")

	for(var/atom/movable/child in src.contents)
		message_admins("found [child] in [src.contents]")
		message_admins("child name [child.name]")
		if(!istype(child, /mob/dead/observer/profane))
			continue

		var/mob/dead/observer/profane/S = child
		var/mob/living/carbon/human/original_body = S.original_body

		if(original_body && S.mind)
			S.mind.transfer_to(original_body)
			message_admins("transferto proc'd")
		else
			S.returntolobby()
			message_admins("returntolobby proc'd")

		freed_souls += 1
		src.total_souls_taken -= 1
		qdel(S)

	return freed_souls

/datum/component/profaned
	var/atom/movable/container

/datum/component/profaned/Initialize(atom/movable/container)
	if(!istype(parent, /mob/dead/observer/profane))
		return COMPONENT_INCOMPATIBLE
	var/mob/dead/observer/profane/S = parent

	src.container = container

	S.forceMove(container)
	
/obj/item/clothing/cloak/poncho/evil
	color = CLOTHING_DARK_GREY
	detail_color = CLOTHING_BLACK



/////////////////////
// ASSASSIN SPELLS //
/////////////////////

/*
These spells are to be granted to the assassin role. Some roundstart, others as rewards for getting a certain # of kills. Assassins
should also be potentially granted some spells from Gnolls, as well as Graggar spells being an option. Each should have an ASSASSIN subtype
that costs DEVOTION. All assassins SHOULD be given devotion that scales w/ their number of kills.
*/
