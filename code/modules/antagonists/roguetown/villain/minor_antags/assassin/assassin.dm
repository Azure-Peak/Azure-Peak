// Assassin, cultist of graggar. Normally found as a drifter.
// Requires at least one living player with the Hunted flaw, otherwise no assassins spawn.
// Roundstart scaling (storyteller_scale_slots): scaling=1, min_players=20, default_cap=2.
//  Cap | <20 | 20-49 | 50+
//   2  |  0  |   1   |  2
// KEYWORDS: HIDDEN DOORWAYS, BLOOD, EDGE, SKINTHIEF, CULT, DEATH & ECSTASY
/datum/antagonist/assassin
	name = "Assassin"
	job_rank = ROLE_ASSASSIN
	roundend_category = "assassins"
	antagpanel_category = "Assassin"
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "assassin"
	show_name_in_check_antagonists = TRUE
	show_in_antagpanel = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_ROUNDSTART | STORYTELLER_ANTAG_SOFT
	override_candidatereq = TRUE
	storyteller_min_players = CHARACTER_INJECTION_MIN_POP
	storyteller_slot_scaling = 1
	storyteller_slot_default_cap = 2
	confess_lines = list(
		"MY CREED IS BLOOD!",
		"THE DAGGER TOLD ME WHO TO CUT!",
		"DEATH IS MY DEVOTION!",
		"THE DARK SUN GUIDES MY HAND!",
		"ALL HAIL HE-WHO-HARVESTS!",
		"ONLY MY DAGGER UNDERSTANDS ME!",
	)
	antag_flags = FLAG_FAKE_ANTAG
	rogue_enabled = TRUE // so it shows up in the panel
	/// This is the assassin's bound dagger, which we can reference for later spells.
	var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/my_dagger

	var/traits_assassin = list(
		TRAIT_ASSASSIN,
		TRAIT_NOSTINK,
		TRAIT_DODGEEXPERT, // look into making this a purchase if/when assassin buyable stuff becomes a thing
		TRAIT_STEELHEARTED,
		TRAIT_ANTISCRYING,
		TRAIT_ZURCH,
	)

	#define SOURCE_ASSASSIN "source_assassin"

/datum/antagonist/assassin/on_gain()
	owner.current.cmode_music = list('sound/music/cmode/antag/combat_deadlyshadows.ogg') // placeholder until a violent way is released
	for(var/assassin_trait in traits_assassin)
		if(!HAS_TRAIT(owner.current, assassin_trait))
			ADD_TRAIT(owner.current, assassin_trait, SOURCE_ASSASSIN)
	// as much as i fucking dread the numbersjak.
	owner.current.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
	var/evil_mask = /obj/item/clothing/mask/rogue/sack
	owner.special_items["Sack Mask"] = evil_mask
	var/datum/action/cooldown/spell/assassin/get_dagger/A = new
	A.Grant(owner.current)
	// temporary to see how this goes. i think it might help w/ how they need to toggle a lot of their features.
	apply_virtue(owner.current, new /datum/virtue/combat/guarded)
	// prevents ear-explosions & THE TEXTWALL. hopefully.
	addtimer(CALLBACK(src, PROC_REF(greet)), 12 SECONDS)

	return ..()

/datum/antagonist/assassin/greet()
	to_chat(owner, span_cult("I hear a singing. HE awaits sacrifice. Death to the world, in the name of the Dark Star."))
	to_chat(owner, span_artery("Summon your dagger. Keep it close. Sense HIS TARGETED, slay them, and PECULATE their being into your blade."))
	owner.current.playsound_local(owner.current,'sound/villain/littlescary.ogg', 10)

/datum/antagonist/assassin/on_removal()
	// this doesnt remove guarded but thats fine for now
	for(var/checked_trait in owner.current.status_traits)
		if(HAS_TRAIT_FROM(owner.current, checked_trait, SOURCE_ASSASSIN))
			REMOVE_TRAIT(owner.current, checked_trait, SOURCE_ASSASSIN)
	// experimental and might be buggy.
	for(var/datum/action/cooldown/assassin_power in owner.current.actions)
		if(istype(assassin_power, /datum/action/cooldown/spell/assassin))
			assassin_power.Remove(owner.current)
	. = ..()



/datum/antagonist/assassin/farewell()
	. = ..()
	to_chat(owner.current,span_danger("The red fog in my mind fades away... my memories as a killer are missing! Who am I, again?"))


/datum/antagonist/assassin/roundend_report()
	var/traitorwin = FALSE
	for(var/obj/item/I in owner.current.get_all_gear()) // Check to see if the Assassin has their profane dagger on them, and then check the souls contained therein.
		if(istype(I, /obj/item/rogueweapon/huntingknife/idagger/steel/profane))
			var/obj/item/rogueweapon/huntingknife/idagger/steel/profane/pissdagger = I
			for(var/datum/profane_soul_data/soul in pissdagger.stored_souls) // Each trapped soul is announced to the server
				if(soul)
					to_world(span_artery("The soul of [soul.name] has been stolen for GRAGGAR by [owner.name]. <span class='greentext'>DAMNATION!</span>"))
					traitorwin = TRUE

	if(!considered_alive(owner))
		traitorwin = FALSE

	if(traitorwin)
		to_world("<span class='greentext'>The [name] [owner.name] has TRIUMPHED!</span>")
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/triumph.ogg', 100, FALSE, pressure_affected = FALSE)
	else
		to_world("<span class='redtext'>The [name] [owner.name] has FAILED!</span>")
		if(owner?.current)
			owner.current.playsound_local(get_turf(owner.current), 'sound/misc/fail.ogg', 100, FALSE, pressure_affected = FALSE)



#undef SOURCE_ASSASSIN
