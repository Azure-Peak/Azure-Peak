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
		"BLOOD FOR THE NEW GODS!", // PRAY TO THE SUN-GOD. https://www.youtube.com/watch?v=JjNYmxdkd1w
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
	to_chat(owner.current, span_redinfo("Assassins do NOT have to escalate against THEIR TARGETS. You must escalate against everyone else. \
	Your targets are STILL AFFORDED ERP protections."))
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
	if(ishuman(owner.current))
		var/mob/living/carbon/human/antag = owner.current
		for(var/obj/item/I in antag.get_all_gear()) // Check to see if the Assassin has their profane dagger on them, and then check the souls contained therein.
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

// EXPANDED VISION FOR FUTURE DEVELOPERS //
/*Good evening! If you're reading this, you may be a developer poking thru the assassin.dm! If you're interested in
adopting this feature after I retire, here was my vague idea of shit you may able to work off of.

// CONCEPTS: FACELESS MEN & SPHERES
	At the moment in AP, we have spheres. I find these limiting for certain antag-related things when we could just render them
non-canon or similar. In the same vein as an evil councillor gets predictable when they've done it a dozen times, I think
assassins should be significantly more varied in what/who they look like. With that in mind, assassin's peculate intent should
end up functioning more like a changeling if anyone can finnagle that. Peculated faces, including the assassins roundstart, could
just be hot-swappable, perhaps on a cooldown.

	With that also in mind; ANYONE should be able to be an assassin. Though their patron should be forced Graggar. In addition, a disguise
system would probably be necessary for this to happen with minimal jank.

// DISGUISES
	On spawn, assassins should, instead of their current class selection, be prompted with various "disguises" fitting various kinds of
characters. This is how it used to work, basically. Anything from 'NAKED' to 'ADVENTURER - BARBARIAN' or something adjacent. Mages and such
could be granted prestidigtation or some minor spellpoints for keeping up that convincing whatever-- clerics can be given orison. Maybe miracle altho
they should maybe just purchase it as described later.

// THE BEAST ROARS -- BUILD YOUR OWN ASSASSIN POINT SYSTEM
	Simply put, we should first force Graggar Patron. Then, assassins could be granted a roundstart # of points to spend on various things. Like
the skills from previous classes, poisons, grapplers, traits, miracles, ETC. You get more points for peculating people and/or your targets. Double points
for "high security" or "strong" roles like retinue (knights, duke, etc) as well as mercenaries. Fuck mercenaries.

Also, if anyone ever tries to de-Graggar the role, please blow it the fuck up. I don't want a repeat of what's happened to gnolls in tone and whatever.
If you want to play a normal "assassin" that kills for coin, cool, play advent, not the explicit death cultist role.

How you'd want to implement this is up to you. I wanted a cool crucified & split open Gnoll w/ an intact head that accepts your sacrifice while
spitting lore. That'd be kinda cool....

// GROTTO
	Assassins can go after Wretches and so while they already have Zurch access, should probably have their own "grotto". Just make it a unique FT point
and on the same z as the wretchamp. Like beyond 2 layers of rock or something. Give them a cool Spot to hang out. Maybe a cool Graggar homunculus
if any of you remember the old art posts from back i nthe day. That wasp retty funny I liked that litle guy.

// KILLING GOD OF HIDDEN DOORWAYS
	If assassins are still weakshit for whatever reason, let PECULATE open open/close windows. Players WILL shit their pants.
	...so will the map-designers, though. ONLY LET THEM DO THIS!!!!!

// LINGERING SOVL
- make spinning the dagger stab you
- make using peculate as a non-assassin stab you
- automatically detonate dagger after 15-30 minutes of assassin being dead

*/

