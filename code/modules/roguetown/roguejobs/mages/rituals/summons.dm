/*
 * ========== Leyline Encounter Rituals ==========
 *
 * The core mage gameplay loop. Mages find leylines out in the world, draw summoning
 * circles near them, and fight whatever comes through the veil. This forces mages out
 * of the tower and into dangerous territory where other players can see and interact
 * with the ritual (the chanting is loud and visible).
 *
 * Flow: find leyline -> draw circle -> click circle -> pick ritual -> chant -> fight.
 * No material cost — the circle tier, veil attunement, and the fight itself IS the cost.
 * Exception: the Void Dragon ritual requires 5 runed artifacts (the only summoning with a material gate).
 * Since charges are limited, you are expected to go out to the good leylines, not camp tamed ones.
 *
 * Attunement: mages have dayspassed + 1 charges minus charges spent, each ritual costs 1.
 * Day gate: T1-T2 always available, T3 from day 3, T4 from day 4, T5 (Void Dragon) from day 5.
 * See leylines.dm for charge and gating implementation.
 *
 * Alignment:
 *   Each ritual and leyline has an alignment. Matching = full mob count.
 *   Wrong alignment = -1 mob (primary reduced first, then secondary if primary is already 1).
 *   Neutral leylines (tamed) are not aligned with anything — always wrong, always -1.
 *   This means tamed leylines give the guaranteed minimum (2 mobs for T1) as training wheels.
 *   Powerful leylines (Bog) always give +1 primary independent of alignment penalty,
 *   so wrong alignment in Bog nets to the same as a normal aligned leyline.
 *
 * Composition: T1-T2 = 3 base primary. T3 = 2 primary + 2 secondary. T4 = 1 primary + 3 secondary.
 * Gone wrong: flat 33% chance, +2 extra mobs. More risk, more reward. Bring friends.
 *
 * Chants: Latin/English alternating pairs, 2 seconds per line, tier scales the count.
 *   Primary count = tier * 2 + 2. Secondary = primary (T4/T5) or primary - 2 (T3, shaves one pair from middle).
 *   T3+ add secondary chants — other nearby invokers respond (call and response).
 *   T3 rituals require at least 1 secondary invoker (checked at ritual level, not rune level).
 *   This means a T3 circle can still be solo-invoked for T1/T2 rituals, but T3 rituals need a partner.
 *   T4 requires 3 invokers at the rune level (grand warded matrix). T5 (void dragon) same.
 *   Final two lines (CLIMAX + CTA) are spoken in sync by all invokers.
 *   Chanting is loud (range 14) and visible, drawing attention from other players.
 */

// ===== Shared chant lines — defined once, reused across tiers to prevent desync =====
// LAT = Latin primary, ENG = English primary, CLIMAX = sync English climax, CTA = final Evoca

#define LEYLINE_TILE_DETECTION_RANGE 7

// Infernal — fire, blood, domination
#define INFERNAL_LAT_1 "Aperio portam ignis."
#define INFERNAL_ENG_1 "Break free! Come to me!"
#define INFERNAL_LAT_2 "Sanguis ardet, vincula franguntur."
#define INFERNAL_ENG_2 "Burn hotter! Strain against the veil!"
#define INFERNAL_LAT_3 "Voluntas mea lex est."
#define INFERNAL_ENG_3 "Submit! You are bound to me!"
#define INFERNAL_LAT_4 "Infernus obedit."
#define INFERNAL_ENG_4 "Hell itself bows! Obey!"
#define INFERNAL_CLIMAX "Incinerate! The inferno answers!"
#define INFERNAL_CTA "Burn! Evoca et Incende!"
#define INFERNAL_RES_1 "Ignis!"       // Fire — matches LAT_1 (open the gate of fire)
#define INFERNAL_RES_2 "Venite!"      // Come — matches ENG_1 (break free, come to me)
#define INFERNAL_RES_3 "Cruor!"       // Blood — matches LAT_2 (blood burns, chains break)
#define INFERNAL_RES_4 "Ardete!"      // Burn — matches ENG_2 (burn hotter)
#define INFERNAL_RES_5 "Audite!"      // Listen — matches LAT_3 (my will is law)
#define INFERNAL_RES_6 "Servite!"     // Submit — matches ENG_3 (submit, you are bound)
#define INFERNAL_RES_7 "Exurite!"     // Burn them — matches LAT_4 (hell obeys)
#define INFERNAL_RES_8 "Obedit!"      // Obey — matches ENG_4 (hell itself bows)

// Fae — nature, growth, wild fury
#define FAE_LAT_1 "Flores aperiuntur."
#define FAE_ENG_1 "Come! Playful fae!"
#define FAE_LAT_2 "Silva cantat, folia tremunt."
#define FAE_ENG_2 "Faster! Spin and flutter!"
#define FAE_LAT_3 "Natura ipsa furit."
#define FAE_ENG_3 "No more games! Show your fury!"
#define FAE_LAT_4 "Furor silvae descendit."
#define FAE_ENG_4 "Grow wild! Consume everything!"
#define FAE_CLIMAX "Fly! The wild answers!"
#define FAE_CTA "Bloom! Evoca et Cresce!"
#define FAE_RES_1 "Florete!"         // Bloom — matches LAT_1 (flowers open)
#define FAE_RES_2 "Volate!"          // Fly — matches ENG_1 (come, playful fae)
#define FAE_RES_3 "Cantate!"         // Sing — matches LAT_2 (forest sings)
#define FAE_RES_4 "Ludite!"          // Play — matches ENG_2 (spin and flutter)
#define FAE_RES_5 "Furiae!"          // Furies — matches LAT_3 (nature rages)
#define FAE_RES_6 "Prodite!"         // Come forth — matches ENG_3 (show your fury)
#define FAE_RES_7 "Crescite!"        // Grow — matches LAT_4 (fury descends)
#define FAE_RES_8 "Vorare!"          // Devour — matches ENG_4 (consume everything)

// Earthen — stone, tremors, upheaval
#define EARTHEN_LAT_1 "Terra audit vocem meam."
#define EARTHEN_ENG_1 "Stir! Rise from the deep!"
#define EARTHEN_LAT_2 "Fundamenta tremunt."
#define EARTHEN_ENG_2 "Crack open! Shatter the earth!"
#define EARTHEN_LAT_3 "Mons ipse obedit."
#define EARTHEN_ENG_3 "Erupt! Swallow the ground whole!"
#define EARTHEN_LAT_4 "Ruina totalis."
#define EARTHEN_ENG_4 "Ruin everything! Leave nothing standing!"
#define EARTHEN_CLIMAX "Quake! The earth answers!"
#define EARTHEN_CTA "Shatter! Evoca et Surge!"
#define EARTHEN_RES_1 "Terra!"        // Earth — matches LAT_1 (earth hears me)
#define EARTHEN_RES_2 "Surgite!"      // Rise — matches ENG_1 (rise from the deep)
#define EARTHEN_RES_3 "Tremite!"      // Tremble — matches LAT_2 (foundations tremble)
#define EARTHEN_RES_4 "Frangite!"     // Shatter — matches ENG_2 (shatter the earth)
#define EARTHEN_RES_5 "Mons!"         // Mountain — matches LAT_3 (the mountain obeys)
#define EARTHEN_RES_6 "Devorate!"     // Devour — matches ENG_3 (swallow the ground)
#define EARTHEN_RES_7 "Ruina!"        // Ruin — matches LAT_4 (total ruin)
#define EARTHEN_RES_8 "Contere!"      // Crush — matches ENG_4 (leave nothing standing)

// Leyline
#define LEYLINE_LAT_1 "Nexus patet."
#define LEYLINE_ENG_1 "Come forth! Show yourselves!"
#define LEYLINE_LAT_2 "Vis cruda fluit."
#define LEYLINE_ENG_2 "Hunt! The veil is thin!"
#define LEYLINE_CLIMAX "Hunt! The leyline answers!"
#define LEYLINE_CTA "Hunt! Evoca et Venare!"

// Void (T2 and T5 have different ENG_1 and CTA)
#define VOID_LAT_1 "Vacuum spectat."
#define VOID_ENG_1_T2 "See me! Know me! Acknowledge me!"
#define VOID_ENG_1_T5 "See me! Turn your gaze!"
#define VOID_LAT_2 "Nihil respondet."
#define VOID_ENG_2 "Answer me! I know you hear!"
#define VOID_LAT_3 "Ultra omnia voco."
#define VOID_ENG_3 "Beyond every plane! Past every boundary!"
#define VOID_LAT_4 "Draco vacui surgit."
#define VOID_ENG_4 "Rise from nothing! The dragon wakes!"
#define VOID_CLIMAX "Watch! The void answers!"
#define VOID_CTA_T2 "Gaze! Evoca et Cognosce!"
#define VOID_CTA_T5 "Consume! Evoca et Devora!"
#define VOID_RES_1 "Vacuitas!"        // Emptiness — matches LAT_1 (the void watches)
#define VOID_RES_2 "Specta!"          // See/Watch — matches ENG_1 (see me, turn your gaze)
#define VOID_RES_3 "Finis!"           // End — matches LAT_2 (nothing answers)
#define VOID_RES_4 "Tenebrae!"        // Darkness — matches ENG_2 (I know you hear)
#define VOID_RES_5 "Nihil!"           // Nothing — matches LAT_3 (I call beyond all)
#define VOID_RES_6 "Vorago!"          // Chasm — matches ENG_3 (past every boundary)
#define VOID_RES_7 "Devorate!"        // Devour — matches LAT_4 (void dragon rises)
#define VOID_RES_8 "Expergisce!"     // Awaken — matches ENG_4 (the dragon wakes)

/datum/runeritual/summoning/leyline_encounter
	name = "leyline encounter parent"
	category = "Summoning"
	blacklisted = TRUE
	required_atoms = list()
	var/alignment = "neutral"
	var/list/primary_mobs = list()
	var/list/secondary_mobs = list()
	var/base_primary_count = 3
	var/base_secondary_count = 0
	var/list/gone_wrong_mobs = list()
	var/gone_wrong_extra = 2
	var/list/chants = list("Evoca!")
	var/list/secondary_chants = list() // T3+ — other invokers respond (call and response)

// ----- Infernal -----

/datum/runeritual/summoning/leyline_encounter/infernal_t1
	name = "Lesser Ritual of Infernal Intrusion"
	desc = "Breach the veil and summon imps."
	blacklisted = FALSE
	tier = 1
	alignment = "infernal"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp)
	base_primary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp)
	chants = list(INFERNAL_LAT_1, INFERNAL_ENG_1, INFERNAL_CLIMAX, INFERNAL_CTA)

/datum/runeritual/summoning/leyline_encounter/infernal_t2
	name = "Ordinary Ritual of Infernal Incursion"
	desc = "Reach deeper into the infernal realm and summon hellhounds!"
	blacklisted = FALSE
	tier = 2
	alignment = "infernal"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound)
	base_primary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp)
	chants = list(INFERNAL_LAT_1, INFERNAL_ENG_1, INFERNAL_LAT_2, INFERNAL_ENG_2, INFERNAL_CLIMAX, INFERNAL_CTA)

/datum/runeritual/summoning/leyline_encounter/infernal_t3
	name = "Greater Ritual of Infernal Invasion"
	desc = "Tear open the veil of the infernal realm, and summon infernal watchers!"
	blacklisted = FALSE
	tier = 3
	req_invokers = 2
	alignment = "infernal"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher)
	secondary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound)
	base_primary_count = 2
	base_secondary_count = 2
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/imp)
	chants = list(INFERNAL_LAT_1, INFERNAL_ENG_1, INFERNAL_LAT_2, INFERNAL_ENG_2, INFERNAL_LAT_3, INFERNAL_ENG_3, INFERNAL_CLIMAX, INFERNAL_CTA)
	secondary_chants = list(INFERNAL_RES_1, INFERNAL_RES_2, INFERNAL_RES_3, INFERNAL_RES_4, INFERNAL_RES_5, INFERNAL_RES_6, INFERNAL_CLIMAX, INFERNAL_CTA)

/datum/runeritual/summoning/leyline_encounter/infernal_t4
	name = "Grand Ritual of Infernal Inversion"
	desc = "Inverse the veil that holds the plane apart, summoning an archfiend!"
	blacklisted = FALSE
	tier = 4
	req_invokers = 3
	alignment = "infernal"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/fiend)
	secondary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/watcher)
	base_primary_count = 1
	base_secondary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/infernal/hellhound)
	chants = list(INFERNAL_LAT_1, INFERNAL_ENG_1, INFERNAL_LAT_2, INFERNAL_ENG_2, INFERNAL_LAT_3, INFERNAL_ENG_3, INFERNAL_LAT_4, INFERNAL_ENG_4, INFERNAL_CLIMAX, INFERNAL_CTA)
	secondary_chants = list(INFERNAL_RES_1, INFERNAL_RES_2, INFERNAL_RES_3, INFERNAL_RES_4, INFERNAL_RES_5, INFERNAL_RES_6, INFERNAL_RES_7, INFERNAL_RES_8, INFERNAL_CLIMAX, INFERNAL_CTA)

// ----- Fae -----

/datum/runeritual/summoning/leyline_encounter/fae_t1
	name = "Lesser Ritual of Fae Frolic"
	desc = "Lure fae sprites through the veil."
	blacklisted = FALSE
	tier = 1
	alignment = "fae"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite)
	base_primary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite)
	chants = list(FAE_LAT_1, FAE_ENG_1, FAE_CLIMAX, FAE_CTA)

/datum/runeritual/summoning/leyline_encounter/fae_t2
	name = "Ordinary Ritual of Fae Fluttering"
	desc = "Flutter the arcyne leyline to lure playful glimmerwings through the veil."
	blacklisted = FALSE
	tier = 2
	alignment = "fae"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing)
	base_primary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite)
	chants = list(FAE_LAT_1, FAE_ENG_1, FAE_LAT_2, FAE_ENG_2, FAE_CLIMAX, FAE_CTA)

/datum/runeritual/summoning/leyline_encounter/fae_t3
	name = "Greater Ritual of Fae Frenzy"
	desc = "Disrupts the veil to lure dryads through the veil to defeat you!"
	blacklisted = FALSE
	tier = 3
	req_invokers = 2
	alignment = "fae"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad)
	secondary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing)
	base_primary_count = 2
	base_secondary_count = 2
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/fae/sprite)
	chants = list(FAE_LAT_1, FAE_ENG_1, FAE_LAT_2, FAE_ENG_2, FAE_LAT_3, FAE_ENG_3, FAE_CLIMAX, FAE_CTA)
	secondary_chants = list(FAE_RES_1, FAE_RES_2, FAE_RES_3, FAE_RES_4, FAE_RES_5, FAE_RES_6, FAE_CLIMAX, FAE_CTA)

/datum/runeritual/summoning/leyline_encounter/fae_t4
	name = "Grand Ritual of Fae Fury"
	desc = "Rend the balanace of the fae realm asunder with uncontrolled arcyne energy, attracting the wrath of a sylph and their followers!"
	blacklisted = FALSE
	tier = 4
	req_invokers = 3
	alignment = "fae"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/fae/sylph)
	secondary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/fae/dryad)
	base_primary_count = 1
	base_secondary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/fae/glimmerwing)
	chants = list(FAE_LAT_1, FAE_ENG_1, FAE_LAT_2, FAE_ENG_2, FAE_LAT_3, FAE_ENG_3, FAE_LAT_4, FAE_ENG_4, FAE_CLIMAX, FAE_CTA)
	secondary_chants = list(FAE_RES_1, FAE_RES_2, FAE_RES_3, FAE_RES_4, FAE_RES_5, FAE_RES_6, FAE_RES_7, FAE_RES_8, FAE_CLIMAX, FAE_CTA)

// ----- Earthen -----

/datum/runeritual/summoning/leyline_encounter/earthen_t1
	name = "Lesser Ritual of Earthen Emergence"
	desc = "Imbue energy into the earthen realm, summoning elemental crawlers."
	blacklisted = FALSE
	tier = 1
	alignment = "elemental"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler)
	base_primary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler)
	chants = list(EARTHEN_LAT_1, EARTHEN_ENG_1, EARTHEN_CLIMAX, EARTHEN_CTA)

/datum/runeritual/summoning/leyline_encounter/earthen_t2
	name = "Ordinary Ritual of Earthen Eruption"
	desc = "Pour forth arcyne energy into the earthen realm, summoning wardens."
	blacklisted = FALSE
	tier = 2
	alignment = "elemental"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden)
	base_primary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler)
	chants = list(EARTHEN_LAT_1, EARTHEN_ENG_1, EARTHEN_LAT_2, EARTHEN_ENG_2, EARTHEN_CLIMAX, EARTHEN_CTA)

/datum/runeritual/summoning/leyline_encounter/earthen_t3
	name = "Greater Ritual of Earthen Earthquake"
	desc = "Shatters the veil with a surge of arcyne energy, summoning behemoths from the earthen realm!"
	blacklisted = FALSE
	tier = 3
	req_invokers = 2
	alignment = "elemental"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth)
	secondary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden)
	base_primary_count = 2
	base_secondary_count = 2
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/elemental/crawler)
	chants = list(EARTHEN_LAT_1, EARTHEN_ENG_1, EARTHEN_LAT_2, EARTHEN_ENG_2, EARTHEN_LAT_3, EARTHEN_ENG_3, EARTHEN_CLIMAX, EARTHEN_CTA)
	secondary_chants = list(EARTHEN_RES_1, EARTHEN_RES_2, EARTHEN_RES_3, EARTHEN_RES_4, EARTHEN_RES_5, EARTHEN_RES_6, EARTHEN_CLIMAX, EARTHEN_CTA)

/datum/runeritual/summoning/leyline_encounter/earthen_t4
	name = "Grand Ritual of Earthen Engulfment"
	desc = "Rend the veil asunder and summon a colossi and its followers!"
	blacklisted = FALSE
	tier = 4
	req_invokers = 3
	alignment = "elemental"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/elemental/colossus)
	secondary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/elemental/behemoth)
	base_primary_count = 1
	base_secondary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/elemental/warden)
	chants = list(EARTHEN_LAT_1, EARTHEN_ENG_1, EARTHEN_LAT_2, EARTHEN_ENG_2, EARTHEN_LAT_3, EARTHEN_ENG_3, EARTHEN_LAT_4, EARTHEN_ENG_4, EARTHEN_CLIMAX, EARTHEN_CTA)
	secondary_chants = list(EARTHEN_RES_1, EARTHEN_RES_2, EARTHEN_RES_3, EARTHEN_RES_4, EARTHEN_RES_5, EARTHEN_RES_6, EARTHEN_RES_7, EARTHEN_RES_8, EARTHEN_CLIMAX, EARTHEN_CTA)

// ----- Leyline (Fixed T2) -----

/datum/runeritual/summoning/leyline_encounter/leyline_t2
	name = "Ordinary Ritual of Lycan Luring"
	desc = "Channel raw leyline energy to lure the lycans that dwell within"
	blacklisted = FALSE
	tier = 2
	alignment = "leyline"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan)
	base_primary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/leylinelycan)
	chants = list(LEYLINE_LAT_1, LEYLINE_ENG_1, LEYLINE_LAT_2, LEYLINE_ENG_2, LEYLINE_CLIMAX, LEYLINE_CTA)

// ----- Void (Fixed T2) — spawns mob form directly, no dormant obelisk phase -----

/datum/runeritual/summoning/leyline_encounter/void_t2
	name = "Ordinary Ritual of Void Vexation"
	desc = "Peer into the void and provoke what lurks beyond. KNOWLEDGE KNOWLEDGE KNOWLEDGE."
	blacklisted = FALSE
	tier = 2
	alignment = "void"
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk)
	base_primary_count = 3
	gone_wrong_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/voidstoneobelisk)
	chants = list(VOID_LAT_1, VOID_ENG_1_T2, VOID_LAT_2, VOID_ENG_2, VOID_CLIMAX, VOID_CTA_T2)

// ----- Void Dragon (T5, requires Powerful leyline + day 5 + 5 runed artifacts) -----
// Uses a T4 circle (grand warded matrix) — the T4 ritual list has no tier filter,
// so this T5 ritual appears on T4 runes. Day-gated to day 5 via get_max_leyline_tier().
// Only powerful leylines (Bog) have max_tier = 5, so it can only be performed there.

/datum/runeritual/summoning/leyline_encounter/void_dragon
	name = "Supreme Ritual of Void Dragon Calling"
	desc = "Tear open the deepest layer of the veil, reaching beyond all planes. There is only one thing that dwells there. Requires a confluence of power from all three realms."
	blacklisted = FALSE
	tier = 5
	req_invokers = 3
	alignment = "void"
	required_atoms = list(/obj/item/magic/artifact = 5, /obj/item/magic/melded/t4 = 1, /obj/item/magic/voidstone = 3, /obj/item/magic/leyline = 3)
	primary_mobs = list(/mob/living/simple_animal/hostile/retaliate/rogue/voiddragon)
	base_primary_count = 1
	gone_wrong_extra = 0
	chants = list(VOID_LAT_1, VOID_ENG_1_T5, VOID_LAT_2, VOID_ENG_2, VOID_LAT_3, VOID_ENG_3, VOID_LAT_4, VOID_ENG_4, VOID_CLIMAX, VOID_CTA_T5)
	secondary_chants = list(VOID_RES_1, VOID_RES_2, VOID_RES_3, VOID_RES_4, VOID_RES_5, VOID_RES_6, VOID_RES_7, VOID_RES_8, VOID_CLIMAX, VOID_CTA_T5)

/datum/runeritual/summoning/leyline_encounter/void_dragon/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(GLOB.dayspassed < 4)
		to_chat(user, span_warning("The veil is not yet thin enough for such a ritual. The void dragon can only be called later in the week."))
		return FALSE
	return ..()

/datum/runeritual/summoning/leyline_encounter/on_finished_recipe(mob/living/user, list/selected_atoms, turf/loc)
	if(!locate(/obj/effect/decal/cleanable/roguerune/arcyne/summoning) in loc)
		to_chat(user, span_warning("The summoning matrix has been destroyed! The ritual fizzles."))
		return FALSE
	var/obj/structure/leyline/leyline
	for(var/obj/structure/leyline/L in range(LEYLINE_TILE_DETECTION_RANGE, loc))
		leyline = L
		break
	if(!leyline)
		to_chat(user, span_warning("There is no leyline nearby. Draw your circle closer to a leyline."))
		return FALSE
	if(!leyline.has_uses_remaining())
		to_chat(user, span_warning("This leyline has been exhausted for todae."))
		return FALSE
	if(get_leyline_charges(user) <= 0)
		to_chat(user, span_boldwarning("You've reached into the leyline too many times. Further interference might result in catastrophic consequences for yourself. Wait for another dae."))
		return FALSE
	if(tier > get_max_leyline_tier())
		to_chat(user, span_warning("Tis too early in the week. The power of the leylines grows and waxes. Wait until later for such powerful summoning."))
		return FALSE
	if(leyline.max_tier && tier > leyline.max_tier)
		to_chat(user, span_warning("This leyline is too weak for a ritual of this circle."))
		return FALSE

	var/primary_count = base_primary_count
	var/secondary_count = base_secondary_count
	var/aligned = (leyline.alignment == alignment)

	// Bog always gives +1 primary, independent of alignment penalty
	if(leyline.leyline_type == "powerful")
		primary_count += 1

	// Wrong alignment: -1 mob, reduce primary first then secondary
	if(!aligned)
		if(primary_count > 1)
			primary_count -= 1
		else
			secondary_count = max(secondary_count - 1, 0)

	var/gone_wrong = gone_wrong_extra > 0 && prob(33)
	var/extra_count = gone_wrong ? gone_wrong_extra : 0

	// Gather secondary invokers for call-and-response (T3+)
	// Search near the rune (loc), not the leyline — invokers stand at the circle, not the leyline
	var/list/other_invokers = list()
	if(length(secondary_chants))
		for(var/mob/living/M in range(3, loc))
			if(M == user)
				continue
			if(isarcyne(M) && M.stat == CONSCIOUS && M.can_speak())
				other_invokers += M

	// T3+ rituals with secondary chants require at least one secondary invoker.
	// The rune itself doesn't enforce this — a T3 circle can still be solo-invoked for T1/T2 rituals.
	// But the ritual refuses to proceed without a partner for the call-and-response.
	if(length(secondary_chants) && !length(other_invokers))
		to_chat(user, span_warning("This ritual requires at least one other magos nearby. You cannot do this alone."))
		return FALSE

	// Chant — loud and visible, this is what draws attention from other players
	user.visible_message(span_danger("You begin to chant, channeling energy into the leyline!"))
	playsound(loc, 'sound/magic/teleport_diss.ogg', 100, TRUE, 14)

	// Secondary chants are offset to start partway through — the chorus joins in for the final lines
	var/secondary_offset = max(length(chants) - length(secondary_chants), 0)

	var/list/active_beams = list()
	for(var/i in 1 to length(chants))
		var/line = chants[i]
		user.say(line, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		// Secondary invokers respond in sync with the primary — call and response
		var/secondary_index = i - secondary_offset
		if(secondary_index >= 1 && secondary_index <= length(secondary_chants) && length(other_invokers))
			var/response_line = secondary_chants[secondary_index]
			for(var/mob/living/invoker in other_invokers)
				invoker.say(response_line, language = /datum/language/common, ignore_spam = TRUE, forced = "cult invocation")
		// Beams: visually leyline → circle and circle → caster (origin.Beam draws FROM origin)
		var/turf/leyline_turf = get_turf(leyline)
		active_beams += leyline_turf.Beam(loc, icon_state = "b_beam", time = 2 SECONDS, maxdistance = 10)
		active_beams += loc.Beam(user, icon_state = "b_beam", time = 2 SECONDS, maxdistance = 10)
		for(var/mob/living/invoker in other_invokers)
			active_beams += loc.Beam(invoker, icon_state = "b_beam", time = 2 SECONDS, maxdistance = 10)
		// Drain energy from all chanters
		user.energy_add(-10)
		for(var/mob/living/invoker in other_invokers)
			invoker.energy_add(-10)
		if(!do_after(user, 2 SECONDS, target = leyline))
			to_chat(user, span_warning("The ritual is interrupted!"))
			for(var/datum/beam/B in active_beams)
				B.End()
			return FALSE

	// Re-check that the summoning matrix still exists after the chant
	if(!locate(/obj/effect/decal/cleanable/roguerune/arcyne/summoning) in loc)
		to_chat(user, span_warning("The summoning matrix was destroyed during the ritual!"))
		return FALSE

	spend_leyline_charge(user)
	leyline.use_charge()

	var/list/spawn_turfs = get_encounter_turfs(loc, primary_count + secondary_count + extra_count)
	var/spawned = 0

	var/mob_type
	for(var/i in 1 to primary_count)
		if(spawned >= length(spawn_turfs))
			break
		spawned++
		mob_type = pick(primary_mobs)
		new mob_type(spawn_turfs[spawned])

	for(var/i in 1 to secondary_count)
		if(spawned >= length(spawn_turfs))
			break
		spawned++
		mob_type = pick(secondary_mobs)
		new mob_type(spawn_turfs[spawned])

	if(gone_wrong)
		user.visible_message(span_boldwarning("The ritual spirals out of control! More creatures pour through the breach!"))
		for(var/i in 1 to extra_count)
			if(spawned >= length(spawn_turfs))
				break
			spawned++
			mob_type = pick(gone_wrong_mobs)
			new mob_type(spawn_turfs[spawned])

	playsound(loc, 'sound/magic/cosmic_expansion.ogg', 100, TRUE, 14)
	user.visible_message(span_boldwarning("The veil tears open and creatures surge forth from beyond!"))
	return TRUE

/datum/runeritual/summoning/leyline_encounter/proc/get_encounter_turfs(turf/center, count)
	var/list/valid_turfs = list()
	for(var/turf/open/T in range(3, center))
		if(T.density)
			continue
		if(T == center)
			continue
		valid_turfs += T
	shuffle_inplace(valid_turfs)
	return valid_turfs.Copy(1, min(count + 1, length(valid_turfs) + 1))

// ----- Debug: arcyne invoker for testing secondary chants -----

/mob/living/carbon/human/species/npc/arcyne_invoker
	name = "Arcyne Invoker"
	real_name = "Arcyne Invoker"
	mode = NPC_AI_OFF
	wander = FALSE

/mob/living/carbon/human/species/npc/arcyne_invoker/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	gender = pick(MALE, FEMALE)
	addtimer(CALLBACK(src, PROC_REF(setup_invoker)), 1 SECONDS)

/mob/living/carbon/human/species/npc/arcyne_invoker/proc/setup_invoker()
	mind_initialize()
	adjust_skillrank(/datum/skill/magic/arcane, 6, TRUE)

// ===== Cleanup =====
#undef INFERNAL_LAT_1
#undef INFERNAL_ENG_1
#undef INFERNAL_LAT_2
#undef INFERNAL_ENG_2
#undef INFERNAL_LAT_3
#undef INFERNAL_ENG_3
#undef INFERNAL_LAT_4
#undef INFERNAL_ENG_4
#undef INFERNAL_CLIMAX
#undef INFERNAL_CTA
#undef INFERNAL_RES_1
#undef INFERNAL_RES_2
#undef INFERNAL_RES_3
#undef INFERNAL_RES_4
#undef INFERNAL_RES_5
#undef INFERNAL_RES_6
#undef INFERNAL_RES_7
#undef INFERNAL_RES_8
#undef FAE_LAT_1
#undef FAE_ENG_1
#undef FAE_LAT_2
#undef FAE_ENG_2
#undef FAE_LAT_3
#undef FAE_ENG_3
#undef FAE_LAT_4
#undef FAE_ENG_4
#undef FAE_CLIMAX
#undef FAE_CTA
#undef FAE_RES_1
#undef FAE_RES_2
#undef FAE_RES_3
#undef FAE_RES_4
#undef FAE_RES_5
#undef FAE_RES_6
#undef FAE_RES_7
#undef FAE_RES_8
#undef EARTHEN_LAT_1
#undef EARTHEN_ENG_1
#undef EARTHEN_LAT_2
#undef EARTHEN_ENG_2
#undef EARTHEN_LAT_3
#undef EARTHEN_ENG_3
#undef EARTHEN_LAT_4
#undef EARTHEN_ENG_4
#undef EARTHEN_CLIMAX
#undef EARTHEN_CTA
#undef EARTHEN_RES_1
#undef EARTHEN_RES_2
#undef EARTHEN_RES_3
#undef EARTHEN_RES_4
#undef EARTHEN_RES_5
#undef EARTHEN_RES_6
#undef EARTHEN_RES_7
#undef EARTHEN_RES_8
#undef LEYLINE_LAT_1
#undef LEYLINE_ENG_1
#undef LEYLINE_LAT_2
#undef LEYLINE_ENG_2
#undef LEYLINE_CLIMAX
#undef LEYLINE_CTA
#undef VOID_LAT_1
#undef VOID_ENG_1_T2
#undef VOID_ENG_1_T5
#undef VOID_LAT_2
#undef VOID_ENG_2
#undef VOID_LAT_3
#undef VOID_ENG_3
#undef VOID_LAT_4
#undef VOID_ENG_4
#undef VOID_CLIMAX
#undef VOID_CTA_T2
#undef VOID_CTA_T5
#undef VOID_RES_1
#undef VOID_RES_2
#undef VOID_RES_3
#undef VOID_RES_4
#undef VOID_RES_5
#undef VOID_RES_6
#undef VOID_RES_7
#undef VOID_RES_8
#undef LEYLINE_TILE_DETECTION_RANGE
