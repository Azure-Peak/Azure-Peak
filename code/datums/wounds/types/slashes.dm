/datum/wound/slash
	name = "slash"
	whp = 30
	sewn_whp = 10
	bleed_rate = 0.4
	sewn_bleed_rate = 0.02
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.2
	sewn_clotting_threshold = 0.1
	sew_threshold = 50
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE

/datum/wound/slash/small
	name = "small slash"
	whp = 15
	sewn_whp = 5
	bleed_rate = 0.2
	sewn_bleed_rate = 0.01
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.1
	sewn_clotting_threshold = 0.05
	sew_threshold = 25

/datum/wound/slash/large
	name = "gruesome slash"
	whp = 40
	sewn_whp = 12
	bleed_rate = 1
	sewn_bleed_rate = 0.05
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.4
	sewn_clotting_threshold = 0.1
	sew_threshold = 75

/datum/wound/dynamic/slash
	name = "slash"
	whp = 15
	sewn_whp = 5
	bleed_rate = 1
	sew_threshold = 25
	woundpain = 5
	clotting_rate = 0.1
	clotting_threshold = 0.25

	sewn_clotting_threshold = null
	sewn_clotting_rate = null
	sewn_bleed_rate = null
	
	can_sew = TRUE
	can_cauterize = TRUE
	severity_names = list(
		"light" = 5,
		"deep" = 10,
		"gnarly" = 15,
		"lethal" = 20,
	)

//Slash Omniwounds
//Vaguely: Painful, hard to sew, hard to heal, but scales poorly through armor.

#define SLASH_UPG_BLEEDRATE 0.12
#define SLASH_UPG_WHPRATE 0.6
#define SLASH_UPG_SEWRATE 1.5
#define SLASH_UPG_PAINRATE 0.25
#define SLASH_UPG_CLAMP_ARMORED 1
#define SLASH_UPG_CLAMP_RAW 2.2
#define SLASH_ARMORED_BLEED_CLAMP 9

/datum/wound/dynamic/slash/upgrade(dam, armor)
	whp += (dam * SLASH_UPG_WHPRATE)
	set_bleed_rate(bleed_rate + clamp((dam * SLASH_UPG_BLEEDRATE), 0.1, ((armor > 0) ? SLASH_UPG_CLAMP_ARMORED : SLASH_UPG_CLAMP_RAW)))
	sew_threshold += (dam * SLASH_UPG_SEWRATE)
	woundpain += (dam * SLASH_UPG_PAINRATE)
	armor_check(armor, SLASH_ARMORED_BLEED_CLAMP)
	update_name()
	..()

#undef SLASH_UPG_BLEEDRATE
#undef SLASH_UPG_WHPRATE
#undef SLASH_UPG_SEWRATE
#undef SLASH_UPG_PAINRATE
#undef SLASH_UPG_CLAMP_ARMORED
#undef SLASH_UPG_CLAMP_RAW
#undef SLASH_ARMORED_BLEED_CLAMP

/datum/wound/slash/disembowel
	name = "disembowelment"
	check_name = span_userdanger("<B>GUTS</B>")
	severity = WOUND_SEVERITY_FATAL
	crit_message = list(
		"%VICTIM spills %P_THEIR organs!",
		"%VICTIM spills %P_THEIR entrails!",
	)
	sound_effect = 'sound/combat/crit2.ogg'
	whp = 100
	sewn_whp = 35
	bleed_rate = 20
	sewn_bleed_rate = 0.8
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 10
	sewn_clotting_threshold = 0.5
	sew_threshold = 150 //absolutely awful to sew up
	critical = TRUE
	/// Organs we can disembowel associated with chance to disembowel
	var/static/list/affected_organs = list(
		ORGAN_SLOT_STOMACH = 100,
		ORGAN_SLOT_LIVER = 50,
	)

/datum/wound/slash/disembowel/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/slash/disembowel) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/slash/disembowel/on_mob_gain(mob/living/affected)
	. = ..()
	affected.emote("paincrit", TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/slash/disembowel/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	var/mob/living/carbon/gutted = affected.owner
	var/atom/drop_location = gutted.drop_location()
	var/list/spilled_organs = list()
	for(var/obj/item/organ/organ as anything in gutted.internal_organs)
		var/org_zone = check_zone(organ.zone)
		if(org_zone != BODY_ZONE_CHEST)
			continue
		if(!(organ.slot in affected_organs))
			continue
		var/spill_prob = affected_organs[organ.slot]
		if(prob(spill_prob))
			spilled_organs += organ
	for(var/obj/item/organ/spilled as anything in spilled_organs)
		spilled.Remove(owner)
		spilled.forceMove(drop_location)
	if(istype(affected, /obj/item/bodypart/chest))
		var/obj/item/bodypart/chest/cavity = affected
		if(cavity.cavity_item)
			cavity.cavity_item.forceMove(drop_location)
			cavity.cavity_item = null

/datum/wound/slash/incision
	name = "incision"
	check_name = span_bloody("<B>INCISION</B>")
	severity = WOUND_SEVERITY_SUPERFICIAL
	whp = 40
	sewn_whp = 12
	bleed_rate = 1
	sewn_bleed_rate = 0.05
	clotting_rate = null
	clotting_threshold = null
	sew_threshold = 75
	passive_healing = 0
	sleep_healing = 0

/datum/wound/slash/incision/sew_wound()
	qdel(src)
	return TRUE

/datum/wound/slash/incision/cauterize_wound()
	qdel(src)
	return TRUE

/datum/wound/slash/vein
	name= "vein"
	check_name = span_bloody("<B>VEIN</B")
	severity = WOUND_SEVERITY_LIGHT
	whp = 40
	sewn_whp = 12
	bleed_rate = 5
	sewn_bleed_rate = 0.15
	clotting_rate = null
	clotting_threshold = null
	sew_threshold = 75
	passive_healing = 0
	sleep_healing = 0


/datum/wound/dynamic/lashing
	name = "lashing"
	whp = 30
	sewn_whp = 12
	bleed_rate = 0
	clotting_rate = 0.02
	clotting_threshold = 0.2
	woundpain = 10
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = FALSE	//Ouch owie oof
	severity_names = list(
		"light" = 5,
		"deep" = 10,
		"gnarly" = 15,
		"lethal" = 20,
	)

//Lashing (Whip) Omniwounds
//Vaguely: Painful, huge bleeds, but nearly nothing at all through any armor.

#define LASHING_UPG_BLEEDRATE 0.1
#define LASHING_UPG_WHPRATE 1
#define LASHING_UPG_SEWRATE 1.8
#define LASHING_UPG_PAINRATE 0.5
#define LASHING_UPG_CLAMP_ARMORED 0.2
#define LASHING_UPG_CLAMP_RAW 3.5
#define LASHING_ARMORED_BLEED_CLAMP 2

/datum/wound/dynamic/lashing/upgrade(dam, armor)
	whp += (dam * LASHING_UPG_WHPRATE)
	set_bleed_rate(bleed_rate + clamp((dam * LASHING_UPG_BLEEDRATE), 0.1, ((armor > 0) ? LASHING_UPG_CLAMP_ARMORED : LASHING_UPG_CLAMP_RAW)))
	sew_threshold += (dam * LASHING_UPG_SEWRATE)
	woundpain += (dam * LASHING_UPG_PAINRATE)
	armor_check(armor, LASHING_ARMORED_BLEED_CLAMP)
	update_name()
	..()

#undef LASHING_UPG_BLEEDRATE
#undef LASHING_UPG_WHPRATE
#undef LASHING_UPG_SEWRATE
#undef LASHING_UPG_PAINRATE
#undef LASHING_UPG_CLAMP_ARMORED
#undef LASHING_UPG_CLAMP_RAW
#undef LASHING_ARMORED_BLEED_CLAMP

/datum/wound/dynamic/punish
	name = "flogging"
	whp = 30
	sewn_whp = 12
	bleed_rate = 0
	clotting_rate = 0.02
	clotting_threshold = 0.2
	woundpain = 10
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = FALSE	//Ouch owie oof
	severity_names = list(
		"light" = 5,
		"deep" = 10,
		"gnarly" = 15,
		"lethal" = 20,
	)

//Special Punish omniwounds for whip (or anything else if desired) intent.
//Vaguely: Really very giga painful. Not very bleedy. Can still be sewn!

#define PUNISH_UPG_BLEEDRATE 0.01
#define PUNISH_UPG_WHPRATE 2
#define PUNISH_UPG_SEWRATE 2
#define PUNISH_UPG_PAINRATE 2
#define PUNISH_UPG_CLAMP_ARMORED 0.1
#define PUNISH_UPG_CLAMP_RAW 0.5
#define PUNISH_UPG_SELFHEAL 0.25
#define PUNISH_ARMORED_BLEED_CLAMP 0.1

/datum/wound/dynamic/punish/upgrade(dam, armor)
	whp += (dam * PUNISH_UPG_WHPRATE)
	set_bleed_rate(bleed_rate + clamp((dam * PUNISH_UPG_BLEEDRATE), 0.1, ((armor > 0) ? PUNISH_UPG_CLAMP_ARMORED : PUNISH_UPG_CLAMP_RAW)))
	sew_threshold += (dam * PUNISH_UPG_SEWRATE)
	woundpain += (dam * PUNISH_UPG_PAINRATE)
	passive_healing += PUNISH_UPG_SELFHEAL
	armor_check(armor, PUNISH_ARMORED_BLEED_CLAMP)
	update_name()
	..()

#undef PUNISH_UPG_BLEEDRATE
#undef PUNISH_UPG_WHPRATE
#undef PUNISH_UPG_SEWRATE
#undef PUNISH_UPG_PAINRATE
#undef PUNISH_UPG_CLAMP_ARMORED
#undef PUNISH_UPG_CLAMP_RAW
#undef PUNISH_UPG_SELFHEAL
#undef PUNISH_ARMORED_BLEED_CLAMP

/datum/wound/lashing
	name = "lashing"
	whp = 30
	sewn_whp = 12
	bleed_rate = 0.6
	sewn_bleed_rate = 0.02
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.2
	sewn_clotting_threshold = 0.1
	woundpain = 10
	sewn_woundpain = 4
	sew_threshold = 65
	mob_overlay = "cut"
	can_sew = TRUE
	can_cauterize = TRUE

/datum/wound/lashing/small
	name = "superficial lashing"
	whp = 15
	sewn_whp = 5
	bleed_rate = 0.2
	sewn_bleed_rate = 0.01
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.1
	sewn_clotting_threshold = 0.05
	woundpain = 8
	sewn_woundpain = 2
	sew_threshold = 30

/datum/wound/lashing/large
	name = "excruciating lashing"
	whp = 45
	sewn_whp = 15
	bleed_rate = 1.2 //Intended for combat, might kill if used for punishment. Force can be controlled by not charging the whip lash fully.
	sewn_bleed_rate = 0.05
	clotting_rate = 0.02
	sewn_clotting_rate = 0.02
	clotting_threshold = 0.4
	sewn_clotting_threshold = 0.1
	woundpain = 22
	sewn_woundpain = 14
	sew_threshold = 95
