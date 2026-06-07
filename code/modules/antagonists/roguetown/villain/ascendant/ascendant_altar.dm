// OH GOD IT'S SO SHITTY IM SO SORRY PLEASE PLEAS EPLEASEP ELEA

GLOBAL_LIST_INIT(psydon_pool, list(
	/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk,  //todo: items lol
	/obj/item/clothing/suit/roguetown/armor/gambeson,
	/obj/item/clothing/suit/roguetown/armor/leather,
	/obj/item/reagent_containers/glass/bottle/waterskin,
	/obj/item/natural/cloth,
	/obj/item/natural/fur,
	/obj/item/reagent_containers/food/snacks/grown/berries/rogue
))

//doing it this way came to me in a dream. find out which items ASCENDANT will be getting today
GLOBAL_LIST_INIT(capstone_pool, list(
	/obj/item/rogueore/coal, //= "minecraft item",
	/obj/item/rogueore/gold,
	/obj/item/rogueore/iron
))


/datum/crafting_recipe/roguetown/structure/ascendant
	name = "ascendant's altar"
	result = /obj/structure/ascendant_altar
	reqs = list(
		/obj/item/bodypart = 2,
		/obj/item/organ/stomach = 1,
	)
	verbage_simple = "construct"
	verbage = "constructs"
	craftsound = 'sound/foley/Building-01.ogg'
	skillcraft = null
	always_availible = FALSE
	subtype_reqs = TRUE

// Altar, sacrifice the right on this to
/obj/structure/ascendant_altar
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "alch"
	var/ascend_stage = 0 //stages - 0 is base, 1 is 1st capstone, 2 is 2nd capstone, 3 is full ascension
	var/ascendpoints = 0 //artefact points

/obj/structure/ascendant_altar/examine(mob/user)
	. = ..()
	if(!user.mind?.has_antag_datum(/datum/antagonist/ascendant))
		. += "It almost looks like it's waiting for something- but I don't know what."
		return

	var/obj/item/next_artefact = LAZYACCESS(GLOB.psydon_pool, 1)
	var/obj/item/next_capstone = LAZYACCESS(GLOB.psydon_pool, 1)
	if(next_artefact)
		. += "The next artefact I must find is \a [initial(next_artefact.name)]."
	else
		. += span_danger("I have all the artefacts I need!")
	if(next_capstone)
		. += "The next capstone to ascend in power is \a [initial(next_capstone.name)]."
	else
		. += span_danger("I have all the capstones I need!")

/obj/structure/ascendant_altar/proc/consume_artefact(obj/item/I, mob/living/user)
	var/next_artefact = LAZYACCESS(GLOB.psydon_pool, 1)
	if(!next_artefact)
		return FALSE
	if(!istype(I, next_artefact))
		return FALSE
	. = TRUE
	if(ascendpoints >= 4) // we already have 4 points, stop already!
		to_chat(user, span_danger("There are nO MORE ARTEFACts to collect. It is time for my BUSINESS to be DONE."))
		return
	ascendpoints++

	user.STASTR += 2
	user.STAPER += 2
	user.STAINT += 2
	user.STACON += 2
	user.STAWIL += 2
	user.STASPD += 2
	user.STALUC += 2

	//check what ascendpoint they are on and add that trait
	switch(ascendpoints)
		if(1)
			ADD_TRAIT(user, TRAIT_DECEIVING_MEEKNESS, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_EMPATH, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_STEELHEARTED, TRAIT_GENERIC)
			to_chat(user, span_userdanger("I bow my head in humility as I begin my journey. MAJOR ARCANA : TEMPERANCE, UPRIGHT."))
		if(2)
			to_chat(user, span_userdanger("The world around me means LESS and LESS- I realize how SMALL everything is. MAJOR ARCANA : QUEEN OF CUPS, REVERSED."))
			ADD_TRAIT(user, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_NOMOOD, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
		if(3)
			ADD_TRAIT(user, TRAIT_NOPAIN, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/fireball)
			user.mind.AddSpell(new /datum/action/cooldown/spell/projectile/lightning_bolt)
			to_chat(user, span_userdanger("I have many enemies- AND they HAVE NOTHING. TEN OF SWORDS, UPRIGHT"))
		if(4)
			ADD_TRAIT(user, TRAIT_STABLEHEART, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_STABLELIVER, TRAIT_GENERIC)
			to_chat(user, span_userdanger("My insides BECOME like INCONGRUOUS STONE. Lines of vapour cross me over. I can NOT be mortal, I am BEYOND MORTAL, I AM I AM I AM I AM NEARING COMPLETION. MAJOR ARCANA : STRENGTH"))
	GLOB.psydon_pool.Cut(1, 2) // remove the first item
	qdel(I)


/obj/structure/ascendant_altar/attackby(obj/item/I, mob/living/user)

//todo: this is garbage, break this into multiple procs, fucking please??
//basically- stuff in artefacts, get traits. stuff in capstone to actually get the next stage
	// first, if we're not an ascendant, we can't do ANYTHING here!
	if(!user.mind?.has_antag_datum(/datum/antagonist/ascendant))
		return ..()
	// second, if this is an artifact, and not a capstone...
	if(consume_artefact(I, user))
		return
	//handles capstones
	else if(consume_capstone(I, user))
		return
	else
		to_chat(user, span_userdanger("This item is USELESS to me..."))

/obj/structure/ascendant_altar/proc/consume_capstone(obj/item/I, mob/living/user)
	var/obj/item/next_capstone = LAZYACCESS(GLOB.capstone_pool, 1)
	if(!next_capstone)
		return FALSE
	if(!istype(I, next_capstone))
		return FALSE
	. = TRUE
	QDEL_NULL(I)
	GLOB.capstone_pool.Cut(1,2) // remove first item
	ascend(user)

// This proc sleeps. Call it at your own peril.
/obj/structure/ascendant_altar/proc/ascend(mob/living/user)
	set waitfor = FALSE
	ascend_stage++

	user.STASTR += 2
	user.STAPER += 2
	user.STAINT += 2
	user.STACON += 2
	user.STAWIL += 2
	user.STASPD += 2
	user.STALUC += 2

	switch(ascend_stage)
		if(1)
			ADD_TRAIT(user, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
			to_chat(user, span_danger("The first capstone. My mind opens. The world around me seems to get smaller. A corpse. We are living on a corpse. And this deadite must be dealt with the same as the rest. My pace stiffens."))
			user.mind.AddSpell(new /obj/effect/proc_holder/spell/targeted/churn)
			addomen(ASCEND_FIRST)
			priority_announce("The leylines begin to tremble in unnatural perversion - MAJOR ARCANA: THE FOOL, UPRIGHT.", "THE DREAMER", 'sound/villain/dreamer_warning.ogg')
		if(2)
			to_chat(user, span_danger("The second capstone. Stuck in filth- FILTH AND SHIT! I grab the rotted, fetted thing and begin to peel it back. LAYER BY LAYER- THE COMET SYON. THE ARCHDEVIL. IS HE DEAD, OR SLEEPING? ..."))
			sleep(30)
			to_chat(user, span_userdanger("IS HE WEAK - OR A COWARD??"))
			sleep(20)
			to_chat(user, span_userdanger("GOD IS COMING."))
			sleep(10)
			to_chat(user, span_userdanger("GODISCOMINGGODISCOMING"))
			new /obj/item/rogueweapon/sword/long/judgement/ascendant
			addomen(ASCEND_WAKENING)
			ADD_TRAIT(user, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
			ADD_TRAIT(user, TRAIT_ANTIMAGIC, TRAIT_GENERIC)
			priority_announce("The sky begins to turn quicker - MAJOR ARCANA: THE HANGED MAN, REVERSED", "THE DREAMER ", 'sound/villain/dreamer_warning.ogg')
		if(3)
			to_chat(user, span_danger("AGONY. SPLITTING HEADACHE. THROBBING OF THE SOUL."))
			user.flash_fullscreen("redflash3")
			user.emote("agony", forced = TRUE)
			sleep(20)
			to_chat(user, span_userdanger("THEW ORLD is not real. my BREATH IS gone. my heart barely baeats. my veins are empty."))
			sleep(50)
			to_chat(user, span_userdanger("i am god. i am god. i am god. i am god. i am god. i am god. i am god. i am god. i am god. i am god. i am god. i am god."))
			sleep(30)
			to_chat(user, span_userdanger("i am god i am god i am go di am ogod I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD"))
			user.flash_fullscreen("redflash3")
			user.emote("agony", forced = TRUE)
			user.Stun(30)
			user.Knockdown(30)
			sleep(30)
			to_chat(user, span_userdanger("i am god i am god i am go di am ogod I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD"))
			user.flash_fullscreen("redflash3")
			user.emote("agony", forced = TRUE)
			user.Stun(100)
			user.Knockdown(100)
			for(var/i = 1, i <= 10, i++)
				spawn((i - 1) * 5)
					to_chat(user, span_userdanger("I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD I AM GOD "))
			sleep(30)
			user.flash_fullscreen("redflash3")

//all goes dark. tp them over. give them their stats.
			user.emote("agony", forced = TRUE)
			user.SetSleeping(10 SECONDS)
			to_chat(user, span_reallybig("THE WORLD GOES DARK!"))
			var/turf/location = get_spawn_turf_for_job("Pilgrim")
			user.forceMove(location)
			user.Stun(50)
			user.cmode_music = 'sound/music/combat_ascended.ogg'
			user.STASTR += 10
			user.STAPER += 10
			user.STAINT += 10
			user.STACON += 10
			user.STAWIL += 10
			user.STASPD += 10
			user.STALUC += 6

			heavensaysdanger() //Roger, our deal is honored; you will be rewarded in heaven.
			addomen(ASCEND_ASCENDANT)
			sleep(15 SECONDS)
			to_chat(user, span_mind_control("i muST go O TO THE TRHORne. THE THRONE. THE THRONE. MY KINGDO M. AWAITS. PSYd ONIA IS DEAD. I MUST ASC end "))

			qdel(src)

/obj/structure/ascendant_altar/attack_right(mob/living/user)
	if(!user.mind?.has_antag_datum(/datum/antagonist/ascendant))
		to_chat(user, span_userdanger("I have no idea what this is."))
		return
	to_chat(user, span_userdanger("I have collected [ascend_stage] capstones and [ascendpoints] artefacts."))

/obj/structure/ascendant_altar/proc/heavensaysdanger()
	priority_announce("THE DREAMER HAS ASCENDED - MAJOR ARCANA : T$yh3 TOW##ER, RE v3RSED", "GOD IS COMING", 'sound/villain/ascendant_intro.ogg')
	sleep(15 SECONDS)
	to_chat(world, span_danger("The ground underneath THE THRONE shakes. The sky is opening."))
