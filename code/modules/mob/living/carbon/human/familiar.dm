#define FAMILIAR_SEE_IN_DARK 10

/mob/living/carbon/human/species/familiar
	name = "Generic Wizard familiar"
	desc = "The spirit of what makes a familiar (You shouldn't be seeing this.)"
	race = /datum/species/familiar

	icon = 'icons/roguetown/mob/familiars.dmi'

	pass_flags = PASSMOB //We don't want them to block players.

	gender = NEUTER
	ambushable = FALSE

	mob_size = MOB_SIZE_SMALL
	density = FALSE
	see_in_dark = FAMILIAR_SEE_IN_DARK
	lighting_alpha = LIGHTING_PLANE_ALPHA_INVISIBLE
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	faction = list(FACTION_ROGUEANIMAL, FACTION_NEUTRAL)
	footstep_type = FOOTSTEP_MOB_BAREFOOT
	var/tier = 0 // increments once per dae survived; gates the stronger abilities
	var/mob/living/carbon/familiar_summoner = null
	var/inherent_spell = null
	var/t1_spell = list()
	var/tutorial_message = null
	var/tierup_messages = list()
	var/t2_spell = list()
	var/summoning_emote = null
	var/list/valid_healing_items = list() // what planar materials can heal you?
	var/planar_origin = "void" // what plane are we from? avoids a bunch of istype checks
	rot_type = null // no rotting inside vestiges please
	var/fly_time = 3 SECONDS
	var/list/speak_emote = list()
	var/binded = FALSE
	var/voiceclips = list() // list of sounds that'll be chosen to play when we talk
	can_do_sex = FALSE // I HATE YOU ALL???

	// stats: should be squishy, but able to keep up with their summoner
	STACON = 5 // might be too low? it's more than skeletons...

/mob/living/carbon/human/species/familiar/attack_hand(mob/user) // very important port from simplemobs
	. = ..()
	if(user.used_intent.type == INTENT_HELP)
		if (health > 0)
			visible_message(span_notice("[user] pets [src]."), \
							span_notice("[user] pets you."), null, null, user)
			to_chat(user, span_notice("I pet [src]."))
			playsound(loc, 'sound/blank.ogg', 50, TRUE, -1)
		return TRUE

/datum/status_effect/buff/healing/familiar
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing/familiar

/atom/movable/screen/alert/status_effect/buff/healing/familiar
	name = "Planar Respite"
	desc = "Drawing energy from my home plane to restore myself."

// slight perf gains over list iteration for all types
/mob/living/carbon/human/species/familiar/proc/is_aligned_leyline(obj/structure/leyline/ley)
	return FALSE

// leying down gives healing
/mob/living/carbon/human/species/familiar/Life()
	. = ..()
	if(!resting || !isturf(loc) || has_status_effect(/datum/status_effect/buff/healing/familiar))
		return .
	for(var/obj/structure/leyline/ley in loc)
		// bog leylines are high-tier healing for all familiars, otherwise you need to use the one aligned to your plane to get the bonus
		var/is_high_tier = ley.max_tier==5 || is_aligned_leyline(ley)
		// full recovery takes 20 seconds, or 10 seconds on high tier; we don't want to force people to sit around forever familiars don't have much health anywae
		var/healing_factor = maxHealth/(is_high_tier ? 100 : 200)
		apply_status_effect(/datum/status_effect/buff/healing/familiar, healing_factor)
		// only do this once; if there are multiple leylines on a tile uh why lol
		// (checking every leyline for the highest tier healing in this hypothetical scenario would not be worth the performance hit)
		return .

// if they are within the orb, they should not be able to commit recursion
/mob/living/carbon/human/species/familiar/restrained(ignore_grab)
	return !isturf(src.loc)

/mob/living/carbon/human/species/familiar/become_item()
	var/obj/item/mob_item/orb = ..()
	orb.slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_RING // little pendant-esque thing
	orb.filters += filter(type = "drop_shadow", x=0, y=0, size=1, offset = 2, color = GLOW_COLOR_ARCANE)
	orb.desc = "A small orb, containing the spirit of [name]."
	orb.can_container = TRUE
	orb.w_class = WEIGHT_CLASS_SMALL
	return orb

/mob/living/carbon/human/species/familiar/Initialize(mapload)
	. = ..()
	adjust_skillrank_up_to(/datum/skill/misc/reading, SKILL_LEVEL_NOVICE)
	AddComponent(/datum/component/footstep, footstep_type)
	TryAddFlight()
	icon_state = initial(icon_state) // parent proc nulls this
	real_name = initial(real_name) // we override these later but we don't want random human names being pulled for this
	name = initial(name)

/mob/living/carbon/human/species/familiar/say_mod(input, message_mode)
	if(speak_emote && speak_emote.len)
		verb_say = pick(speak_emote)
	. = ..()

/mob/living/carbon/human/species/familiar/has_extractable_lux()
	return FALSE

/mob/living/carbon/human/species/familiar/can_piggyback(mob/living/carbon/target)
	return FALSE

/datum/species/familiar
	name = "base familiar"
	id = "familiar"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES, NOBLOOD)
	inherent_traits = list(
		TRAIT_STEELHEARTED,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_TINYPAWS,
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_NOPAIN,
		TRAIT_NOBREATH,
		TRAIT_TECHNOPHOBE,
		TRAIT_NODISMEMBER, //Decapping Volfs causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_CRITICAL_WEAKNESS, // ...this should prevent them from being literally unkillable, though
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects due to them transforming when killed/stepping on shards.
		TRAIT_NOMETABOLISM, // partly to avoid potion jank, mostly because fae need to store reagents inside themselves
		TRAIT_NOWW, // no antag familiars pls
		TRAIT_UNLYCKERABLE,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_UNCONVERTIBLE,
	)
	inherent_biotypes = MOB_HUMANOID
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE, SLOT_BELT_L, SLOT_BELT_R, SLOT_WRISTS, SLOT_RING)
	nojumpsuit = 1
	sexes = 0
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		)

	languages = list( // we're pAI equivalent extraplanar beings and this avoids weird edge cases like infernals not speaking infernal
		/datum/language/common,
		/datum/language/elvish,
		/datum/language/dwarvish,
		/datum/language/orcish,
		/datum/language/hellspeak,
		/datum/language/draconic,
		/datum/language/celestial,
		/datum/language/raneshi,
		/datum/language/grenzelhoftian,
		/datum/language/kazengunese,
		/datum/language/lingyuese,
		/datum/language/etruscan,
		/datum/language/gronnic,
		/datum/language/otavan,
		/datum/language/aavnic,
		/datum/language/undercommon,
		/datum/language/oldazurian,
		/datum/language/abyssal,
		/datum/language/beast,
		/datum/language/undead,
	)

/datum/species/familiar/send_voice(mob/living/carbon/human/species/familiar/H)
	if(!length(H.voiceclips))
		return
	playsound(get_turf(H), pick(H.voiceclips), 80, TRUE, -1)

/datum/species/familiar/regenerate_icons(mob/living/carbon/human/H)
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.update_damage_overlays()
	return TRUE

/datum/species/familiar/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/familiar/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

/mob/living/carbon/human/species/familiar/death(gibbed, nocutscene = FALSE)
	. = ..(gibbed, nocutscene)
	if(gibbed)
		return .
	var/obj/item/magic/familiar/familiar_vestige/vestige = new /obj/item/magic/familiar/familiar_vestige(loc)
	vestige.stored_familiar = src
	src.forceMove(vestige)
	vestige.desc = "The vestige of [src.name], a fallen [GLOB.familiar_display_names[src.type]]. Likely worth a lot to the magos that summoned [src.p_them()]!"
	if(familiar_summoner)
		to_chat(familiar_summoner, span_warning("[src.name] has fallen, and your bond dims. They may be recalled yet, should you recover their vestige."))

/mob/living/carbon/human/species/familiar/proc/TryAddFlight()
	if(movement_type & (FLYING | FLOATING))
		add_verb(src, list(/mob/living/carbon/human/species/familiar/proc/fly_up,
		/mob/living/carbon/human/species/familiar/proc/fly_down))

/mob/living/carbon/human/species/familiar/proc/fly_up()
	set category = "RoleUnique.Winged Form"
	set name = "Fly Up"

	if(src.pulledby != null)
		to_chat(src, span_notice("I can't fly away while being grabbed!"))
		return
	src.visible_message(span_notice("[src] begins to ascend!"), span_notice("You take flight..."))
	if(do_after(src, fly_time))
		if(src.pulledby == null)
			src.zMove(UP, TRUE)
			to_chat(src, span_notice("I fly up."))
		else
			to_chat(src, span_notice("I can't fly away while being grabbed!"))

/mob/living/carbon/human/species/familiar/proc/fly_down()
	set category = "RoleUnique.Winged Form"
	set name = "Fly Down"

	if(src.pulledby != null)
		to_chat(src, span_notice("I can't fly away while being grabbed!"))
		return
	src.visible_message(span_notice("[src] begins to descend!"), span_notice("You take flight..."))
	if(do_after(src, fly_time))
		if(src.pulledby == null)
			src.zMove(DOWN, TRUE)
			to_chat(src, span_notice("I fly down."))
		else
			to_chat(src, span_notice("I can't fly away while being grabbed!"))

/mob/living/carbon/human/species/familiar/proc/grant_tier_abilities(tier)
	if(tier==1 && length(t1_spell))
		for(var/path in t1_spell)
			var/spell_instance = new path
			if(spell_instance && src.mind)
				src.mind.AddSpell(spell_instance)
	if(tier==2 && length(t2_spell))
		for(var/path in t2_spell)
			var/spell_instance = new path
			if(spell_instance && src.mind)
				src.mind.AddSpell(spell_instance)
	return

/mob/living/carbon/human/species/familiar/proc/debug_force_tierup()
	GLOB.tod="night"
	do_time_change()

/mob/living/carbon/human/species/familiar/do_time_change()
	. = ..()
	if(src.planar_origin!="void" && GLOB.tod == "night" && tier < 2)
		tier++
		to_chat(src, span_info("As another nite falls, your powers grow, adjusting more to the mortal plane."))
		if(LAZYLEN(tierup_messages) && tierup_messages[tier])
			to_chat(src, tierup_messages[tier])
		grant_tier_abilities(tier)

/mob/living/carbon/human/species/familiar/Destroy()
	if(familiar_summoner && familiar_summoner.mind)
		familiar_summoner.mind.RemoveSpell(/datum/action/cooldown/spell/message_familiar)
	return ..()

/mob/living/carbon/human/species/familiar/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/magic))
		var/obj/item/magic/magicmaterial = I
		for(var/item_type in valid_healing_items)
			if(istype(magicmaterial,item_type))
				to_chat(user, "I start healing [src] with [magicmaterial].")
				if(do_mob(user, src, 20))
					apply_status_effect(/datum/status_effect/buff/healing/familiar, magicmaterial.tier)
					visible_message("[src] absorbs [magicmaterial] and is healed.")
					qdel(magicmaterial)
					return
	. = ..()

/mob/living/carbon/human/species/familiar/examine(mob/user)
	var/list/ret = ..()
	var/datum/familiar_prefs/prefs = src.client?.prefs?.familiar_prefs
	if(!prefs)
		return ret
	if(!prefs.familiar_headshot_link || !istype(prefs.familiar_headshot_link)) // prefs object from the dev period before we had examines; update them
		prefs.instantiate_examine_prefs()
		return ret
	if((valid_headshot_link(src, prefs.familiar_headshot_link[planar_origin], TRUE)) && (user.client?.prefs.chatheadshot))
		ret.Insert(2, "<img src=[prefs.familiar_headshot_link[planar_origin]] width=100 height=100/>")
	if(prefs.familiar_flavortext_display[planar_origin] || prefs.familiar_headshot_link[planar_origin] || prefs.familiar_ooc_notes_display[planar_origin])
		ret.Insert(ret.len-1, "<a href='?src=[REF(src)];task=view_fam_headshot;'>Examine closer</a>")
	return ret

/mob/living/carbon/human/species/familiar/can_be_held(mob/by)
	return TRUE

#undef FAMILIAR_SEE_IN_DARK
