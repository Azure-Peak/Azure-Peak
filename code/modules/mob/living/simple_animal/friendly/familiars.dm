#define FAMILIAR_SEE_IN_DARK 6
#define FAMILIAR_MIN_BODYTEMP 200
#define FAMILIAR_MAX_BODYTEMP 400

/*
	Familiar list and buffs below. 
	Sprites by Diltyrr (those aren't good gah)

	Quick AI pictures idea for each of them : https://imgbox.com/g/MvanomKazA
*/

/mob/living/simple_animal/pet/familiar
	name = "Generic Wizard familiar"
	desc = "The spirit of what makes a familiar (You shouldn't be seeing this.)"

	icon = 'icons/roguetown/mob/familiars.dmi'
	
	butcher_results = list(/obj/item/natural/stone = 1)

	pass_flags = PASSMOB //We don't want them to block players.
	base_intents = list(INTENT_HELP)
	melee_damage_lower = 1
	melee_damage_upper = 2

	dextrous = TRUE
	gender = MALE

	speak_chance = 1
	turns_per_move = 5
	mob_size = MOB_SIZE_SMALL
	density = FALSE
	see_in_dark = FAMILIAR_SEE_IN_DARK
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	minbodytemp = FAMILIAR_MIN_BODYTEMP
	maxbodytemp = FAMILIAR_MAX_BODYTEMP
	unsuitable_atmos_damage = 1
	response_help_continuous = "pets"
	response_help_simple = "pet"
	response_disarm_continuous = "gently pushes aside"
	response_disarm_simple = "gently push aside"
	response_harm_continuous = "kicks"
	response_harm_simple = "kick"
	faction = list("rogueanimal", "neutral")
	speed = 0.8
	breedchildren = 0 //Yeah no, I'm not falling for this one.
	dodgetime = 20
	held_items = list(null, null)
	pooptype = null
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	var/obj/item/mouth = null
	
	var/buff_given = null
	var/mob/living/carbon/familiar_summoner = null
	var/inherent_spell = null
	var/summoning_emote = null
	
//As far as I am aware, you cannot pat out fire as a familiar at least not in time for it to not kill you, this seems fair.
/mob/living/simple_animal/pet/familiar/fire_act(added, maxstacks)
	. = ..()
	addtimer(CALLBACK(src, TYPE_PROC_REF(/mob/living, extinguish_mob)), 1 SECONDS)

/mob/living/simple_animal/pet/familiar/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NOFALLDAMAGE1, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CHUNKYFINGERS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	AddComponent(/datum/component/footstep, footstep_type)

/mob/living/simple_animal/pet/familiar/proc/can_bite()
	for(var/obj/item/grabbing/grab in grabbedby) //Grabbed by the mouth
		if(grab.sublimb_grabbed == BODY_ZONE_PRECISE_MOUTH)
			return FALSE
			
	return TRUE

/mob/living/simple_animal/pet/familiar/examine(mob/user)
	. = ..()
	var/datum/familiar_prefs/fpref = src.client?.prefs.familiar_prefs
	if(fpref && (fpref.familiar_flavortext || fpref.familiar_headshot_link || fpref.familiar_ooc_notes))
		. += "<a href='?src=[REF(src)];task=view_fam_headshot;'>Examine closer</a>"

/datum/status_effect/buff/familiar
	duration = -1

/mob/living/simple_animal/pet/familiar/death()
	. = ..()
	emote("deathgasp")
	if(familiar_summoner)
		to_chat(familiar_summoner, span_warning("[src.name] has fallen, and your bond dims. Yet in the quiet beyond, a flicker of their essence remains."))
		if(buff_given)
			familiar_summoner.remove_status_effect(buff_given) //dead familiars should not continue to provide buffs

/mob/living/simple_animal/pet/familiar/Destroy()
    if(familiar_summoner)
        if(buff_given)
            familiar_summoner.remove_status_effect(buff_given)
        if(familiar_summoner.mind)
            familiar_summoner.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/message_familiar)
    return ..()

/mob/living/simple_animal/pet/familiar/pondstone_toad
    name = "Pondstone Toad"
    desc = "This damp, heavy toad pulses with unseen strength. Its skin is cool and lined with mineral veins."
    animal_species = "Pondstone Toad"
    summoning_emote = "A deep thrum echoes beneath your feet, and a mossy toad pushes itself free from the earth, humming low."
    icon_state = "pondstone"
    icon_living = "pondstone"
    icon_dead = "pondstone_dead"
    buff_given = /datum/status_effect/buff/familiar/settled_weight
    inherent_spell = list(/obj/effect/proc_holder/spell/self/stillness_of_stone)
    STASTR = 11
    STAPER = 7
    STAINT = 9
    STACON = 11
    STASPD = 5
    STALUC = 9
    speak = list("Hrrrm.", "Grrup.", "Blorp.")
    speak_emote = list("croaks low", "grumbles")
    emote_hear = list("croaks lowly.", "lets out a bubbling sound.")
    emote_see = list("shudders like stone.", "thumps softly in place.")
    var/icon/original_icon = null
    var/original_icon_state = ""
    var/original_icon_living = ""
    var/original_name = ""
    var/stoneform = FALSE

/datum/status_effect/buff/familiar/settled_weight
	id = "settled_weight"
	effectedstats = list(STATKEY_STR = 1, STATKEY_INT = -1, STATKEY_PER = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/settled_weight

/atom/movable/screen/alert/status_effect/buff/familiar/settled_weight
	name = "Settled Weight"
	desc = "You feel just a touch more grounded. Pushing back has become a little easier."


/mob/living/simple_animal/pet/familiar/mist_lynx
    name = "Mist Lynx"
    desc = "A ghostlike lynx, its eyes gleaming like twin moons. It never seems to blink, even when you're not looking."
    animal_species = "Mist Lynx"
    summoning_emote = "Mist coils into feline shape, resolving into a lynx with pale fur and unblinking silver eyes."
    icon_state = "mist"
    icon_living = "mist"
    icon_dead = "mist_dead"
    alpha = 150
    buff_given = /datum/status_effect/buff/familiar/silver_glance
    inherent_spell = list(/obj/effect/proc_holder/spell/self/lurking_step, /obj/effect/proc_holder/spell/invoked/veilbound_shift)
    pass_flags = PASSGRILLE | PASSMOB
    STASTR = 6
    STAPER = 11
    STAINT = 9
    STACON = 7
    STAWIL = 9
    STASPD = 13
    STALUC = 9
    speak = list("...") // mostly silent
    speak_emote = list("purrs softly", "whispers")
    emote_hear = list("lets out a soft yowl.", "whispers almost silently.")
    emote_see = list("pads in a circle.", "vanishes briefly, then reappears.")
    var/list/saved_trails = list()

/datum/status_effect/buff/familiar/silver_glance
	id = "silver_glance"
	effectedstats = list(STATKEY_PER = 1, STATKEY_WIL = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/silver_glance

/atom/movable/screen/alert/status_effect/buff/familiar/silver_glance
	name = "Silver Glance"
	desc = "There's a flicker at the edge of your vision. You notice what others pass by."

/mob/living/simple_animal/pet/familiar/rune_rat
    name = "Rune Rat"
    desc = "This rat leaves fading runes in the air as it twitches. The smell of old paper clings to its fur."
    animal_species = "Rune Rat"
    summoning_emote = "A faint spark dances through the air. A rat with a softly glowing tail scampers into existence."
    icon_state = "runerat"
    icon_living = "runerat"
    icon_dead = "runerat_dead"
    buff_given = /datum/status_effect/buff/familiar/threaded_thoughts
    inherent_spell = list(/obj/effect/proc_holder/spell/self/inscription_cache, /obj/effect/proc_holder/spell/self/recall_cache)
    STASTR = 5
    STAPER = 9
    STAINT = 11
    STACON = 7
    STAWIL = 8
    STASPD = 11
    speak = list("Skrii!", "Tik-tik.", "Chrr.")
    speak_emote = list("squeaks", "chatters")
    emote_hear = list("squeaks thoughtfully.", "sniffs the air.")
    emote_see = list("twitches its tail in patterns.", "skitters in a loop.")
    var/stored_books = list()
    var/storage_limit = 5

/datum/status_effect/buff/familiar/threaded_thoughts
	id = "threaded_thoughts"
	effectedstats = list(STATKEY_INT = 1, STATKEY_CON = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/threaded_thoughts

/atom/movable/screen/alert/status_effect/buff/familiar/threaded_thoughts
	name = "Threaded Thoughts"
	desc = "Your thoughts gather more easily, like threads pulled into a tidy weave."

/mob/living/simple_animal/pet/familiar/vaporroot_wisp
    name = "Vaporroot Wisp"
    desc = "This vaporroot wisp shimmers and shifts like smoke but feels solid enough to lean on."
    animal_species = "Vaporroot"
    summoning_emote = "A swirl of silvery mist gathers, coalescing into a small wisp of vaporroot."
    icon_state = "vaporroot"
    icon_living = "vaporroot"
    icon_dead = "vaporroot_dead"
    alpha = 150
    buff_given = /datum/status_effect/buff/familiar/quiet_resilience
    inherent_spell = list(/obj/effect/proc_holder/spell/self/soothing_bloom)
    pass_flags = PASSTABLE | PASSGRILLE | PASSMOB
    movement_type = FLYING
    STASTR = 4
    STACON = 11
    STAWIL = 9
    STASPD = 8
    speak = list("Fffff...", "Whuuuh.")
    speak_emote = list("whispers", "murmurs")
    emote_hear = list("hums softly.", "emits a calming mist.")
    emote_see = list("swirls in place.", "dissolves briefly.")

/datum/status_effect/buff/familiar/quiet_resilience
	id = "quiet_resilience"
	effectedstats = list(STATKEY_CON = 1, STATKEY_INT = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/quiet_resilience

/atom/movable/screen/alert/status_effect/buff/familiar/quiet_resilience
	name = "Quiet Resilience"
	desc = "A calm strength hums beneath your skin. You breathe a little deeper."

/mob/living/simple_animal/pet/familiar/ashcoiler
	name = "Ashcoiler"
	desc = "This long-bodied snake coils slowly, like a heated rope. Its breath carries a faint scent of burnt herbs."
	summoning_emote = "Dust rises and circles before coiling into a gray-scaled creature that radiates dry, residual warmth."
	animal_species = "Ashcoiler"
	buff_given = /datum/status_effect/buff/familiar/desert_bred_tenacity
	inherent_spell = list(/obj/effect/proc_holder/spell/self/smolder_shroud)
	butcher_results = list(/obj/item/ash = 1)
	STASTR = 7
	STAPER = 8
	STAINT = 9
	STACON = 9
	STAWIL = 11
	STASPD = 8
	STALUC = 8

	icon_state = "ashcoiler"
	icon_living = "ashcoiler"
	icon_dead = "ashcoiler_dead"

	speak = list("Ssshh...", "Hhsss.", "Ffff.")
	speak_emote = list("hisses", "rasps")
	emote_hear = list("hisses faintly.", "breathes a puff of ash.")
	emote_see = list("slowly coils and uncoils.", "shifts weight in rhythm.")

/datum/status_effect/buff/familiar/desert_bred_tenacity
	id = "desert_bred_tenacity"
	effectedstats = list(STATKEY_WIL = 1, STATKEY_PER = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/desert_bred_tenacity

/atom/movable/screen/alert/status_effect/buff/familiar/desert_bred_tenacity
	name = "Desert-Bred Tenacity"
	desc = "You feel steady and patient, like something that has survived years without rain."

/mob/living/simple_animal/pet/familiar/glimmer_hare
	name = "Glimmer Hare"
	desc = "A quick, nervy creature. Light bends strangely around its translucent body."
	summoning_emote = "The air glints, and a translucent hare twitches into existence."
	animal_species = "Glimmer Hare"
	buff_given = /datum/status_effect/buff/familiar/lightstep
	inherent_spell = list(/obj/effect/proc_holder/spell/invoked/blink/glimmer_hare)
	STASTR = 4
	STAPER = 9
	STACON = 6
	STAWIL = 9
	STASPD = 9
	STALUC = 11

	alpha = 150
	icon_state = "glimmer"
	icon_living = "glimmer"
	icon_dead = "glimmer_dead"
	
	speak = list("Tik!", "Tch!", "Hah!")
	speak_emote = list("chatters quickly", "chirps")
	emote_hear = list("thumps the ground.", "scatters some dust.")
	emote_see = list("dashes suddenly, then stops.", "vibrates subtly.")

/datum/status_effect/buff/familiar/lightstep
	id = "lightstep"
	effectedstats = list(STATKEY_SPD = 1, STATKEY_WIL = -1, STATKEY_INT = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/lightstep

/atom/movable/screen/alert/status_effect/buff/familiar/lightstep
	name = "Lightstep"
	desc = "You move with just a touch more ease."

/mob/living/simple_animal/pet/familiar/hollow_antlerling
	name = "Hollow Antlerling"
	desc = "A dog-sized deer with gleaming hollow antlers that emit flute-like sounds."
	summoning_emote = "A musical chime sounds. A tiny deer with antlers like bone flutes steps gently into view."
	animal_species = "Hollow Antlerling"
	buff_given = /datum/status_effect/buff/familiar/soft_favor
	inherent_spell = list(/obj/effect/proc_holder/spell/self/verdant_veil)

	STASTR = 6
	STACON = 8
	STAWIL = 9
	STASPD = 9
	STALUC = 11

	icon_state = "antlerling"
	icon_living = "antlerling"
	icon_dead = "antlerling_dead"

	speak = list("Hrrn.", "Mnnn.", "Chuff.")
	speak_emote = list("chimes softly", "calls out")
	emote_hear = list("lets out a musical chime.")
	emote_see = list("flickers like a mirage.", "steps just out of reach of falling dust.")

/datum/status_effect/buff/familiar/soft_favor
	id = "soft_favor"
	effectedstats = list(STATKEY_PER = 1, STATKEY_INT = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/soft_favor

/atom/movable/screen/alert/status_effect/buff/familiar/soft_favor
	name = "Soft Favor"
	desc = "Fortune seems to tilt in your direction."

/mob/living/simple_animal/pet/familiar/gravemoss_serpent
	name = "Gravemoss Serpent"
	desc = "Its scales are flecked with lichen and grave-dust. Wherever it passes, roots twitch faintly in the soil."
	summoning_emote = "The ground heaves faintly as a long, moss-veiled serpent uncoils from it."
	animal_species = "Gravemoss Serpent"
	butcher_results = list(/obj/item/natural/dirtclod = 1)
	buff_given = /datum/status_effect/buff/familiar/burdened_coil
	inherent_spell = list(/obj/effect/proc_holder/spell/self/scent_of_the_grave)

	STASTR = 11
	STAPER = 8
	STAINT = 9
	STAWIL = 11
	STASPD = 6
	STALUC = 8

	icon_state = "gravemoss"
	icon_living = "gravemoss"
	icon_dead = "gravemoss_dead"

	speak = list("Grhh...", "Sssrrrh.", "Urrh.")
	speak_emote = list("hisses low", "mutters")
	emote_hear = list("rumbles from deep within.", "hisses like wind in roots.")
	emote_see = list("sinks halfway into the earth.", "gazes steadily.")

/datum/status_effect/buff/familiar/burdened_coil
	id = "burdened_coil"
	effectedstats = list(STATKEY_LCK = -1, STATKEY_WIL = 1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/burdened_coil

/atom/movable/screen/alert/status_effect/buff/familiar/burdened_coil
	name = "Burdened Coil"
	desc = "You feel grounded and steady, as if strength coils beneath your skin."

/mob/living/simple_animal/pet/familiar/starfield_crow
	name = "Starfield Zad"
	desc = "Its glossy feathers shimmer with shifting constellations, eyes gleaming with uncanny awareness even in the darkest shadows."
	summoning_emote = "A rift in the air reveals a fragment of the starry void, from which a sleek zad with feathers like the night sky takes flight."
	animal_species = "Starfield Crow"
	buff_given = /datum/status_effect/buff/familiar/starseam
	pass_flags = PASSTABLE | PASSMOB
	movement_type = FLYING
	inherent_spell = list(/obj/effect/proc_holder/spell/self/starseers_cry)
	STASTR = 4
	STAPER = 11
	STACON = 6
	STAWIL = 8
	STALUC = 11

	icon_state = "crow_flying"
	icon_living = "crow_flying"
	icon_dead = "crow_dead"

	base_intents = list(/datum/intent/unarmed/help)
	harm_intent_damage = 0
	melee_damage_lower = 0
	melee_damage_upper = 0
	remains_type = /obj/effect/decal/remains/crow

	speak = list("Kraa.", "Caw.", "Krrrk.")
	speak_emote = list("caws quietly", "croaks")
	emote_hear = list("lets out a knowing caw.", "chirps like stars ticking.")
	emote_see = list("flickers through constellations.", "tilts its head and vanishes for a second.")

/datum/status_effect/buff/familiar/starseam
	id = "starseam"
	effectedstats = list(STATKEY_PER = 1, STATKEY_CON = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/starseam

/atom/movable/screen/alert/status_effect/buff/familiar/starseam
	name = "Starseam"
	desc = "You feel nudged by distant patterns. The world flows more legibly."

/mob/living/simple_animal/pet/familiar/emberdrake
	name = "Emberdrake"
	desc = "Tiny and warm to the touch, this drake's wingbeats stir old memories. Runes flicker behind it like afterimages."
	summoning_emote = "A hush falls as glowing ash collects into a fluttering emberdrake."
	animal_species = "Emberdrake"
	buff_given = /datum/status_effect/buff/familiar/steady_spark
	inherent_spell = list(/obj/effect/proc_holder/spell/invoked/pyroclastic_puff)
	butcher_results = list(/obj/item/ash = 1)
	STASTR = 9
	STAPER = 8
	STAINT = 11
	STACON = 11
	STAWIL = 9
	STASPD = 8
	STALUC = 8

	icon_state = "emberdrake"
	icon_living = "emberdrake"
	icon_dead = "emberdrake_dead"

	speak = list("Ffff.", "Rrrhh.", "Chhhh.")
	speak_emote = list("crackles", "speaks warmly")
	emote_hear = list("rumbles like a hearth.", "flickers with flame.")
	emote_see = list("glows briefly brighter.", "leaves a brief heat haze.")

/datum/status_effect/buff/familiar/steady_spark
	id = "steady_spark"
	effectedstats = list(STATKEY_STR = 1, STATKEY_PER = -1, STATKEY_CON = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/steady_spark

/atom/movable/screen/alert/status_effect/buff/familiar/steady_spark
	name = "Steady Spark"
	desc = "Your thoughts don't burn, they smolder. Clear, slow, and lasting."

/mob/living/simple_animal/pet/familiar/ripplefox
	name = "Ripplefox"
	desc = "They flicker when not directly observed. Leaves no tracks. You're not always sure they're still nearby."
	summoning_emote = "A ripple in the air becomes a sleek fox, their fur twitching between shades of color as they pads forth."
	animal_species = "Ripplefox"
	buff_given = /datum/status_effect/buff/familiar/subtle_slip
	inherent_spell = list(/obj/effect/proc_holder/spell/self/phantom_flicker)
	STASTR = 5
	STACON = 8
	STAWIL = 9
	STASPD = 11
	STALUC = 11

	icon_state = "ripple"
	icon_living = "ripple"
	icon_dead = "ripple_dead"

	speak = list("Yip!", "Hrrnk.", "Tchk-tchk.")
	speak_emote = list("whispers fast", "speaks quickly")
	emote_hear = list("lets out a playful yip.", "laughs like water in motion.")
	emote_see = list("blurs like a ripple.", "isn't where it was a second ago.")

/datum/status_effect/buff/familiar/subtle_slip
	id = "subtle_slip"
	effectedstats = list(STATKEY_LCK = 1, STATKEY_WIL = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/subtle_slip

/atom/movable/screen/alert/status_effect/buff/familiar/subtle_slip
	name = "Subtle Slip"
	desc = "Things seem a bit looser around you, a gap, a chance, a beat ahead."

/mob/living/simple_animal/pet/familiar/whisper_stoat
	name = "Whisper Stoat"
	desc = "Its gaze is too knowing. It tilts its head as if listening to something inside your skull."
	summoning_emote = "A thought twists into form, a tiny stoat slinks into view."
	animal_species = "Whisper Stoat"
	buff_given = /datum/status_effect/buff/familiar/noticed_thought
	inherent_spell = list(/obj/effect/proc_holder/spell/self/phantasm_fade)
	STASTR = 5
	STAPER = 11
	STAINT = 11
	STACON = 7
	STAWIL = 8
	STASPD = 11
	STALUC = 9

	icon_state = "whisper"
	icon_living = "whisper"
	icon_dead = "whisper_dead"

	speak = list("Tchhh.", "Hmm.", "Skkk.")
	speak_emote = list("mutters", "speaks softly")
	emote_hear = list("murmurs in your direction.", "makes a sound you forget instantly.")
	emote_see = list("wraps around a shadow.", "slips behind a thought.")

/datum/status_effect/buff/familiar/noticed_thought
	id = "noticed_thought"
	effectedstats = list(STATKEY_PER = 1, STATKEY_INT = 1, STATKEY_STR = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/noticed_thought

/atom/movable/screen/alert/status_effect/buff/familiar/noticed_thought
	name = "Noticed Thought"
	desc = "Everything makes just a bit more sense. You catch patterns more quickly."

/mob/living/simple_animal/pet/familiar/thornback_turtle
	name = "Thornback Turtle"
	desc = "It barely moves, but seems unshakable. Vines twist gently around its limbs."
	summoning_emote = "The ground gives a slow rumble. A turtle with a bark-like shell emerges from the soil."
	animal_species = "Thornback Turtle"
	buff_given = /datum/status_effect/buff/familiar/worn_stone
	inherent_spell = list(/obj/effect/proc_holder/spell/self/verdant_sprout)
	STASPD = 5
	STAPER = 7
	STAINT = 9
	STACON = 11
	STAWIL = 12
	STALUC = 8

	icon_state = "thornback"
	icon_living = "thornback"
	icon_dead = "thornback_dead"
	
	speak = list("Hrmm.", "Grunk.", "Mmm.")
	speak_emote = list("rumbles", "speaks slowly")
	emote_hear = list("grunts like shifting boulders.", "sighs like old wood.")
	emote_see = list("retracts slightly into its shell.", "blinks slowly.")

/datum/status_effect/buff/familiar/worn_stone
	id = "worn_stone"
	effectedstats = list(STATKEY_WIL = 1, STATKEY_CON = 1, STATKEY_SPD = -1)
	alert_type = /atom/movable/screen/alert/status_effect/buff/familiar/worn_stone

/atom/movable/screen/alert/status_effect/buff/familiar/worn_stone
	name = "Worn Stone"
	desc = "Nothing feels urgent. You can take your time... and take a hit."

/*
	Mundane and Mechanical Familiars, Reusing old sprites.
*/


/mob/living/simple_animal/pet/familiar/mouse_brown
    name = "Mouse (brown)"
    desc = "A small brown mouse, quick and alert, always searching for crumbs and cozy hiding spots."
    animal_species = "Mouse"
    icon = 'icons/mob/animal.dmi'
    icon_state = "mouse_brown"
    icon_living = "mouse_brown"
    icon_dead = "mouse_brown_dead"
    STASTR = 3
    STAPER = 7
    STAINT = 4
    STACON = 5
    STAWIL = 5
    STASPD = 8
    STALUC = 6
    summoning_emote = "A faint rustle as a brown mouse darts out from a shadow."
    speak = list("Squeak!", "Skrit.", "Chrr.")
    speak_emote = "squeaks"
    emote_hear = list("squeaks softly.", "nibbles on something unseen.", "scratches at the floor.")
    emote_see = list("washes its face.", "scurries in a small circle.", "stands up on its hind legs.")

/mob/living/simple_animal/pet/familiar/mouse_white
    name = "Mouse (white)"
    desc = "A white mouse, gentle and inquisitive, often found exploring nooks and crannies."
    animal_species = "Mouse"
    icon = 'icons/mob/animal.dmi'
    icon_state = "mouse_white"
    icon_living = "mouse_white"
    icon_dead = "mouse_white_dead"
    STASTR = 3
    STAPER = 7
    STAINT = 4
    STACON = 5
    STAWIL = 5
    STASPD = 8
    STALUC = 6
    summoning_emote = "A soft squeak as a white mouse peeks out from behind an object."
    speak = list("Squeak!", "Skrit.", "Chrr.")
    speak_emote = "squeaks"
    emote_hear = list("squeaks quietly.", "sniffs the air.", "scratches at a corner.")
    emote_see = list("grooms its fur.", "scampers quickly.", "pauses to listen.")

/mob/living/simple_animal/pet/familiar/mouse_grey
    name = "Mouse (grey)"
    desc = "A grey mouse, quiet and nimble, skilled at slipping unnoticed through the smallest gaps."
    animal_species = "Mouse"
    icon = 'icons/mob/animal.dmi'
    icon_state = "mouse_gray"
    icon_living = "mouse_gray"
    icon_dead = "mouse_gray_dead"
    STASTR = 3
    STAPER = 7
    STAINT = 4
    STACON = 5
    STAWIL = 5
    STASPD = 8
    STALUC = 6
    summoning_emote = "A grey mouse slips quietly from a crack in the wall."
    speak = list("Squeak!", "Skrit.", "Chrr.")
    speak_emote = "squeaks"
    emote_hear = list("squeaks.", "chews on something.", "scratches at the ground.")
    emote_see = list("darts under a nearby object.", "sits up and looks around.", "twitches its tail.")

/mob/living/simple_animal/pet/familiar/crow
    name = "Zad"
    desc = "A clever black zad, watchful and resourceful, known for its sharp eyes and love of shiny things."
    animal_species = "Crow"
    icon = 'icons/roguetown/mob/monster/crow.dmi'
    icon_state = "crow_flying"
    icon_living = "crow_flying"
    icon_dead = "crow1"
    STASTR = 4
    STAPER = 8
    STAINT = 5
    STACON = 6
    STAWIL = 6
    STASPD = 7
    STALUC = 7
    summoning_emote = "A black feather flutters down as a zad lands nearby with a caw."
    speak = list("Caw!", "Kraa.", "Crrk.")
    speak_emote = "caws"
    emote_hear = list("caws.", "clicks its beak.", "ruffles its feathers.")
    emote_see = list("tilts its head.", "hops in a circle.", "spreads its wings briefly.")

/mob/living/simple_animal/pet/familiar/chicken_grey
    name = "Chicken (grey)"
    desc = "A plump grey chicken, content to peck at the ground and cluck softly among friends."
    animal_species = "Chicken"
    icon = 'icons/roguetown/mob/monster/chicken.dmi'
    icon_state = "chicken"
    icon_living = "chicken"
    icon_dead = "chicken_dead"
    STASTR = 4
    STAPER = 5
    STAINT = 4
    STACON = 6
    STAWIL = 6
    STASPD = 5
    STALUC = 5
    summoning_emote = "A soft clucking as a grey chicken waddles into view."
    speak = list("Cluck.", "Bawk.", "Buk-buk.")
    speak_emote = list("clucks", "fluffs its feathers")
    emote_hear = list("clucks softly.", "bawks.", "scratches at the dirt.")
    emote_see = list("fluffs up its feathers.", "pecks at the ground.", "shakes its tail feathers.")

/mob/living/simple_animal/pet/familiar/chicken_brown
    name = "Chicken (brown)"
    desc = "A brown chicken, lively and sociable, always scratching for seeds and insects."
    animal_species = "Chicken"
    icon = 'icons/roguetown/mob/monster/chicken.dmi'
    icon_state = "chicken_brown"
    icon_living = "chicken_brown"
    icon_dead = "chicken_brown_dead"
    STASTR = 4
    STAPER = 5
    STAINT = 4
    STACON = 6
    STAWIL = 6
    STASPD = 5
    STALUC = 5
    summoning_emote = "A brown chicken bustles in, pecking at the floor."
    speak = list("Cluck.", "Bawk.", "Buk-buk.")
    speak_emote = "clucks"
    emote_hear = list("clucks.", "bawks loudly.", "scratches at the floor.")
    emote_see = list("struts proudly.", "flaps its wings.", "pecks at a seed.")

/mob/living/simple_animal/pet/familiar/chicken_white
    name = "Chicken (white)"
    desc = "A white chicken, calm and steady, with a soft cluck and a gentle demeanor."
    animal_species = "Chicken"
    icon = 'icons/roguetown/mob/monster/chicken.dmi'
    icon_state = "chicken_white"
    icon_living = "chicken_white"
    icon_dead = "chicken_white_dead"
    STASTR = 4
    STAPER = 5
    STAINT = 4
    STACON = 6
    STAWIL = 6
    STASPD = 5
    STALUC = 5
    summoning_emote = "A white chicken quietly settles down."
    speak = list("Cluck.", "Bawk.", "Buk-buk.")
    speak_emote = "clucks"
    emote_hear = list("clucks quietly.", "bawks.", "scratches at the ground.")
    emote_see = list("walks in a slow circle.", "fluffs up.", "pecks gently at the floor.")

/mob/living/simple_animal/pet/familiar/chicken_black
    name = "Chicken (black)"
    desc = "A black chicken, sleek and proud, strutting confidently wherever it goes."
    animal_species = "Chicken"
    icon = 'icons/roguetown/mob/monster/chicken.dmi'
    icon_state = "chicken_black"
    icon_living = "chicken_black"
    icon_dead = "chicken_black_dead"
    STASTR = 4
    STAPER = 5
    STAINT = 4
    STACON = 6
    STAWIL = 6
    STASPD = 5
    STALUC = 5
    summoning_emote = "A black chicken struts in, head held high."
    speak = list("Cluck.", "Bawk.", "Buk-buk.")
    speak_emote = "clucks"
    emote_hear = list("clucks.", "bawks.", "ruffles its feathers.")
    emote_see = list("spins in place.", "struts with its head high.", "flaps its wings.")

/mob/living/simple_animal/pet/familiar/rat
    name = "Rat"
    desc = "A streetwise rat, clever and adaptable, able to thrive in almost any environment."
    animal_species = "Rat"
    icon = 'icons/roguetown/mob/monster/rat.dmi'
    icon_state = "srat"
    icon_living = "srat"
    icon_dead = "srat1"
    STASTR = 4
    STAPER = 7
    STAINT = 5
    STACON = 5
    STAWIL = 6
    STASPD = 7
    STALUC = 6
    summoning_emote = "A rat scurries out from a dark corner, nose twitching."
    speak = list("Squeak!", "Chrr.", "Tik-tik.")
    speak_emote = "squeaks"
    emote_hear = list("squeaks.", "gnaws on something.", "scratches at the floor.")
    emote_see = list("washes its face.", "runs in a quick circle.", "sniffs the air.")

/mob/living/simple_animal/pet/familiar/bat
    name = "Bat"
    desc = "A tiny bat, nocturnal and swift, flitting silently through the night in search of insects."
    animal_species = "Bat"
    icon = 'icons/mob/animal.dmi'
    icon_state = "bat"
    icon_living = "bat"
    icon_dead = "bat_dead"
    STASTR = 3
    STAPER = 8
    STAINT = 4
    STACON = 5
    STAWIL = 5
    STASPD = 8
    STALUC = 6
    summoning_emote = "A flutter of wings as a bat swoops down from above."
    speak = list("Screech!", "Eek!", "Chirp.")
    speak_emote = "screeches"
    emote_hear = list("screeches.", "chirps.", "flaps its wings.")
    emote_see = list("hangs upside down.", "circles overhead.", "lands briefly before taking off again.")

/mob/living/simple_animal/pet/familiar/frog_green
    name = "Frog (Green)"
    desc = "A green frog, cheerful and spry, happiest near water and quick to leap away from danger."
    animal_species = "Frog"
    icon = 'icons/mob/animal.dmi'
    icon_state = "frog"
    icon_living = "frog"
    icon_dead = "frog_dead"
    STASTR = 3
    STAPER = 6
    STAINT = 4
    STACON = 5
    STAWIL = 6
    STASPD = 7
    STALUC = 5
    summoning_emote = "A green frog hops into view with a wet plop."
    speak = list("Ribbit.", "Croak.", "Brrrp.")
    speak_emote = "croaks"
    emote_hear = list("croaks.", "ribbits.", "chirps softly.")
    emote_see = list("hops in place.", "blinks slowly.", "wriggles its toes.")

/mob/living/simple_animal/pet/familiar/frog_purple
    name = "Frog (Purple)"
    desc = "A purple frog, unusual in color but otherwise a typical amphibian, fond of damp places."
    animal_species = "Frog"
    icon = 'icons/mob/animal.dmi'
    icon_state = "rare_frog"
    icon_living = "rare_frog"
    icon_dead = "rare_frog_dead"
    STASTR = 3
    STAPER = 6
    STAINT = 4
    STACON = 5
    STAWIL = 6
    STASPD = 7
    STALUC = 5
    summoning_emote = "A purple frog appears with a soft splash."
    speak = list("Ribbit.", "Croak.", "Brrrp.")
    speak_emote = "croaks"
    emote_hear = list("croaks.", "ribbits.", "makes a soft brrrp.")
    emote_see = list("leaps to a new spot.", "sits very still.", "wriggles its toes.")

/mob/living/simple_animal/pet/familiar/parrot
    name = "Parrot"
    desc = "A bright parrot, talkative and intelligent, with a fondness for mimicking voices and sounds."
    animal_species = "Parrot"
    icon = 'icons/mob/animal.dmi'
    icon_state = "parrot_fly"
    icon_living = "parrot_fly"
    icon_dead = "parrot_dead"
    STASTR = 4
    STAPER = 7
    STAINT = 6
    STACON = 5
    STAWIL = 6
    STASPD = 7
    STALUC = 7
    summoning_emote = "A flash of color as a parrot swoops down, squawking."
    speak = list("Squawk!", "Hello!", "Pretty bird!")
    speak_emote = "squawks"
    emote_hear = list("squawks.", "chatters.", "clicks its beak.")
    emote_see = list("preens its feathers.", "bobs its head.", "flaps its wings.")

/mob/living/simple_animal/pet/familiar/snake
    name = "Snake"
    desc = "A slender snake, calm and observant, moving gracefully and silently through its surroundings."
    animal_species = "Snake"
    icon = 'icons/mob/animal.dmi'
    icon_state = "snake"
    icon_living = "snake"
    icon_dead = "snake_dead"
    STASTR = 4
    STAPER = 7
    STAINT = 5
    STACON = 6
    STAWIL = 6
    STASPD = 7
    STALUC = 6
    summoning_emote = "A snake slithers into view, tongue flicking."
    speak = list("Hiss.", "Sss.", "Tssst.")
    speak_emote = "hisses"
    emote_hear = list("hisses.", "flicks its tongue.", "slides quietly.")
    emote_see = list("coils up.", "raises its head.", "slithers in a slow circle.")

/mob/living/simple_animal/pet/familiar/mudcrab
    name = "Mudcrab"
    desc = "A mudcrab, sturdy and stubborn, scuttling sideways and always ready to defend itself."
    animal_species = "Mudcrab"
    icon = 'icons/mob/animal.dmi'
    icon_state = "mudcrab"
    icon_living = "mudcrab"
    icon_dead = "mudcrab_dead"
    STASTR = 5
    STAPER = 5
    STAINT = 4
    STACON = 7
    STAWIL = 7
    STASPD = 4
    STALUC = 5
    summoning_emote = "A mudcrab emerges from a patch of damp earth."
    speak = list("Click.", "Clack.", "Snap.")
    speak_emote = "clicks"
    emote_hear = list("clicks.", "clacks.", "scrapes its claws together.")
    emote_see = list("scuttles sideways.", "raises its claws.", "digs at the ground.")

/mob/living/simple_animal/pet/familiar/cat_pink
    name = "Cat (Pink)"
    desc = "A hairless cat, playful and affectionate, with a knack for finding the warmest spot in any room."
    animal_species = "Cat"
    icon = 'icons/mob/pets.dmi'
    icon_state = "cat"
    icon_living = "cat"
    icon_dead = "cat_dead"
    STASTR = 4
    STAPER = 7
    STAINT = 5
    STACON = 6
    STAWIL = 6
    STASPD = 7
    STALUC = 7
    summoning_emote = "A pink, hairless cat stretches and yawns as it appears."
    speak = list("Mrrp.", "Mew.", "Prrt.")
    speak_emote = "meows"
    emote_hear = list("purrs.", "meows softly.", "chirps quietly.")
    emote_see = list("arches its back.", "rolls over and stretches.", "kneads a soft spot.")

/mob/living/simple_animal/pet/familiar/cat_black
    name = "Cat (Black)"
    desc = "A black cat, sleek and mysterious, often seen watching quietly from the shadows."
    animal_species = "Cat"
    icon = 'icons/roguetown/topadd/takyon/Cat.dmi'
    icon_state = "cat"
    icon_living = "cat"
    icon_dead = "cat_dead"
    STASTR = 4
    STAPER = 7
    STAINT = 5
    STACON = 6
    STAWIL = 6
    STASPD = 7
    STALUC = 7
    summoning_emote = "A black cat pads silently into view, tail flicking."
    speak = list("Mrrp.", "Mew.", "Prrt.")
    speak_emote = "meows"
    emote_hear = list("purrs.", "meows.", "makes a soft prrt.")
    emote_see = list("flicks its tail.", "blinks slowly.", "circles in place.")

/mob/living/simple_animal/pet/familiar/mechanical/brass_thrum
    name = "Brass Thrum"
    desc = "A mechanical spider-like creature of brass and whirring gears, its movements precise and accompanied by a faint, rhythmic hum."
    animal_species = "Brass Thrum"
    icon = 'icons/mob/drone.dmi'
    icon_state = "drone_clock"
    icon_living = "drone_clock"
    icon_dead = "drone_clock_dead"
    STASTR = 5
    STAPER = 6
    STAINT = 5
    STACON = 7
    STAWIL = 7
    STASPD = 5
    STALUC = 5
    mob_biotypes = MOB_ROBOTIC
    summoning_emote = "A metallic clatter as a brass spider-like automaton unfolds itself."
    speak = list("Whirr.", "Click.", "Thrum.")
    speak_emote = "whirrs"
    emote_hear = list("whirrs.", "clicks.", "hums softly.")
    emote_see = list("rotates its body.", "taps its legs on the ground.", "spins in place.")

/mob/living/simple_animal/pet/familiar/mechanical/gemspire_beetle
    name = "Gemspire Beetle"
    desc = "A four-legged, spider-like automaton adorned with crystalline spires, blending arcane energy with intricate clockwork."
    animal_species = "Gemspire Beetle"
    icon = 'icons/mob/drone.dmi'
    icon_state = "drone_gem"
    icon_living = "drone_gem"
    icon_dead = "drone_gem_dead"
    STASTR = 5
    STAPER = 6
    STAINT = 5
    STACON = 7
    STAWIL = 7
    STASPD = 5
    STALUC = 5
    mob_biotypes = MOB_ROBOTIC
    summoning_emote = "A faint chime as a gem-encrusted mechanical beetle scuttles into view."
    speak = list("Tick.", "Chime.", "Clack.")
    speak_emote = "chimes"
    emote_hear = list("chimes.", "clicks.", "makes a faint ticking sound.")
    emote_see = list("glints in the light.", "shifts its crystalline spires.", "spins in a small circle.")

#undef FAMILIAR_SEE_IN_DARK
#undef FAMILIAR_MIN_BODYTEMP
#undef FAMILIAR_MAX_BODYTEMP
