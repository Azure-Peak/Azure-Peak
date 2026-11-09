/datum/species/ooze
	name = "Murkling"
	id = "ooze"
	desc_title = "Murkling"
	desc = "Murklings possess a peculiar physiology, their bodies formed around a rigid, \
	bone-like membrane of hardened slime, surrounded in a softer, malleable exterior of living ooze. \
	Few know of their true origins. Ancient records place their beginnings deep within the cold caverns of the Underdark \
	where primordial ooze infested tunnels and defended its spawning pits with relentless hostility. \
	For centuries, Dark Elves and Dwarven delvers alike sealed these regions away, leaving the living mire undisturbed. \
	Only within the last century did something new begin to emerge from these \
	pools - crude humanoid figures that could speak and think, an imperfect imitation of man. \
	As the ancient spawning pools gradually withered, their offspring ventured outwards, forming colonies of their own. \
	Though born of the violent depths of the Underdark, Murklings remain a young and volatile people, \
	struggling to understand a world that sees them as monsters.\
	Creatures of remarkable adaptability, their bodies readily changing to reflect the environments in which they settle. \
	Yet their malleable nature makes them particularly susceptible to intoxicants. \
	Dusts, spirits, and smoke may leave lasting impressions upon their bodies, sometimes fundamentally altering their composition, \
	With prolonged exposure, some develop an insatiable dependence upon these substances,  \
	their bodies eventually learning to produce and secrete the very things they've come to crave. \
	Caught now in the struggles of surface faiths and kingdoms, Murklings search for new purpose beyond their primordial mothers. \
	Some turn to the gods, using faith to fill the gaps their spawning pools left behind, while others reject them entirely. \
	Yet all carry the memory of the deep: the silent, all-encompassing love and will from which they were born."
	blood_color = "#00FFFF" //Defaults to blue, but we recolor this later to match the slime person's body color.
	origin_default = /datum/virtue/origin/racial/underdark
	base_name = "Ooze"
	origin = "Underdark"
	default_color = "79F299"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,MUTCOLORS)
	restricted_virtues = list(/datum/virtue/utility/feral_appetite, /datum/virtue/utility/noble)
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = FALSE
	possible_ages = ALL_AGES_LIST
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mt.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	allowed_body_builds = STANDARD_BODY_BUILDS
	default_body_build_m = BODY_BUILD_BULKY
	default_body_build_f = BODY_BUILD_SLIM
	race_bonus = list(STAT_CONSTITUTION = 1, STAT_INTELLIGENCE = 1)
	inherent_traits = list(
						TRAIT_NASTY_EATER,
						TRAIT_EASYDISMEMBER,
						TRAIT_REGROW_LIMBS,
						TRAIT_ZOMBIE_IMMUNE,
						TRAIT_WATERBREATHING,
						)
	enflamed_icon = "widefire"
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid/slime,
		/datum/customizer/bodypart_feature/hair/facial/humanoid/slime,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/bodypart_feature/pits,
		/datum/customizer/organ/snout/anthro/slime,
		/datum/customizer/organ/tail/slime,
		/datum/customizer/organ/ears/slime,
		/datum/customizer/organ/wings/slime,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/belly,
		/datum/body_marking_set/bellysocks,
		/datum/body_marking_set/tiger,
		/datum/body_marking_set/tiger_dark,
		/datum/body_marking_set/gradient,
	)
	body_markings = list(
		/datum/body_marking/flushed_cheeks,
		/datum/body_marking/eyeliner,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/bangs,
		/datum/body_marking/bun,
		/datum/body_marking/waist,
		/datum/body_marking/womb_tattoo,
		/datum/body_marking/butterfly
	)
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/ooze,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/ooze,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/ooze,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/ooze,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue/ooze,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/ooze,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/ooze,
		)

	mechanics_explanations = list("Can suffer fractures to the head and chest. Limbs melt away when they would otherwise be fractured, dislocated, or cut off.",
		"Can regenerate lost limbs by sleeping, or use their Regrow Limb ability while awake.",
		"Have uniquely colored blood that matches the color of their bodies.",
		"Gradually shift their body and hair colors toward the most recently metabolized reagent.")

////// ORGAN SPRITES, provided by VelSlime
/obj/item/organ/brain/ooze
	name = "Ooze Neural Core"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC
	decoy_override = TRUE

/obj/item/organ/lungs/ooze
	name = "Ooze Breathing Sac"
	icon = 'icons/obj/velslime.dmi'
	icon_state = "liver" //No lungs sprite, re-using the liver sprite instead.
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/heart/ooze
	name = "Ooze Fluid Pump"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/eyes/ooze
	name = "Ooze Ocular Sensors"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/tongue/wild_tongue/ooze
	name = "Ooze Taste Buds"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/stomach/ooze
	name = "Ooze Digestive Chamber"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/obj/item/organ/liver/ooze
	name = "Ooze Detoxification Organelle"
	icon = 'icons/obj/velslime.dmi'
	organ_flags = ORGAN_ORGANIC

/datum/species/ooze/check_roundstart_eligible()
	return TRUE

//Set slime blood color to match body color.
/datum/species/ooze/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	blood_color = C.dna.features["mcolor"]
	blood_color = "#[blood_color]"
	if(ishuman(C))
		C.AddComponent(/datum/component/ooze_color_shift)
		add_verb(C, /mob/living/carbon/human/proc/toggle_ooze_color_shifting)

/datum/species/ooze/on_species_loss(mob/living/carbon/C)
	. = ..()
	remove_verb(C, /mob/living/carbon/human/proc/toggle_ooze_color_shifting)
	qdel(C.GetComponent(/datum/component/ooze_color_shift))

/mob/living/carbon/human/proc/toggle_ooze_color_shifting()
	set name = "Toggle Color Shifting"
	set category = "RoleUnique.Murkling"

	if(!dna || !istype(dna.species, /datum/species/ooze))
		return
	var/datum/component/ooze_color_shift/color_shift = GetComponent(/datum/component/ooze_color_shift)
	if(!color_shift)
		to_chat(src, span_warning("My body cannot currently shift its colors."))
		return
	color_shift.enabled = !color_shift.enabled
	if(color_shift.enabled)
		to_chat(src, span_notice("My body will shift its colors as I metabolize reagents."))
	else
		STOP_PROCESSING(SSfastprocess, color_shift)
		to_chat(src, span_notice("My body will hold its current colors."))

/datum/component/ooze_color_shift
	var/target_color
	var/start_body_color
	var/list/start_accessory_colors
	var/elapsed_time = 0
	var/last_visual_update = 0
	var/shift_duration = 30 SECONDS
	var/enabled = TRUE

/datum/component/ooze_color_shift/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_REAGENT_METABOLIZED, PROC_REF(on_reagent_metabolized))
	return ..()

/datum/component/ooze_color_shift/Destroy()
	UnregisterSignal(parent, COMSIG_MOB_REAGENT_METABOLIZED)
	STOP_PROCESSING(SSfastprocess, src)
	return ..()

/datum/component/ooze_color_shift/proc/on_reagent_metabolized(mob/living/carbon/human/ooze, datum/reagent/reagent)
	SIGNAL_HANDLER
	if(!enabled)
		return
	var/new_target = sanitize_hexcolor(reagent.color, 6, FALSE, null, TRUE)
	if(!new_target)
		return
	var/list/target_hsl = rgb2hsl(
		hex2num(copytext(new_target, 1, 3)),
		hex2num(copytext(new_target, 3, 5)),
		hex2num(copytext(new_target, 5, 7)),
	)
	target_hsl[2] = min(target_hsl[2], 0.45)
	var/list/target_rgb = hsl2rgb(arglist(target_hsl))
	target_color = "[num2hex(target_rgb[1], 2)][num2hex(target_rgb[2], 2)][num2hex(target_rgb[3], 2)]"
	start_body_color = sanitize_hexcolor(ooze.dna.features["mcolor"], 6, FALSE)
	start_accessory_colors = get_accessory_color_snapshot(ooze)
	elapsed_time = 0
	last_visual_update = 0
	START_PROCESSING(SSfastprocess, src)

/datum/component/ooze_color_shift/process(seconds_per_tick)
	var/mob/living/carbon/human/ooze = parent
	if(!ooze.dna || !istype(ooze.dna.species, /datum/species/ooze))
		qdel(src)
		return
	elapsed_time = min(elapsed_time + seconds_per_tick, shift_duration)
	if(elapsed_time < shift_duration && elapsed_time - last_visual_update < 1)
		return
	last_visual_update = elapsed_time
	var/progress = elapsed_time / shift_duration
	ooze.dna.features["mcolor"] = interpolate_color(start_body_color, target_color, progress)
	ooze.dna.species.blood_color = "#[ooze.dna.features["mcolor"]]"
	update_accessory_colors(start_accessory_colors, progress)
	ooze.update_body_parts(TRUE)
	if(elapsed_time >= shift_duration)
		STOP_PROCESSING(SSfastprocess, src)

/datum/component/ooze_color_shift/proc/get_accessory_color_snapshot(mob/living/carbon/human/ooze)
	var/list/color_snapshot = list()
	for(var/obj/item/bodypart/bodypart as anything in ooze.bodyparts)
		for(var/datum/bodypart_feature/feature as anything in bodypart.bodypart_features)
			if(feature.accessory_type && feature.accessory_colors)
				var/list/colors = get_normalized_accessory_colors(feature.accessory_colors)
				if(length(colors))
					color_snapshot[feature] = colors
	for(var/obj/item/organ/organ as anything in ooze.internal_organs)
		if(istype(organ, /obj/item/organ/eyes) || !organ.accessory_type || !organ.accessory_colors)
			continue
		var/list/colors = get_normalized_accessory_colors(organ.accessory_colors)
		if(length(colors))
			color_snapshot[organ] = colors
	return color_snapshot

/datum/component/ooze_color_shift/proc/get_normalized_accessory_colors(accessory_colors)
	var/list/colors = color_string_to_list(accessory_colors)
	var/list/normalized_colors = list()
	for(var/color in colors)
		var/normalized_color = sanitize_hexcolor(color, 6, FALSE, null, TRUE)
		if(!normalized_color)
			return
		normalized_colors += normalized_color
	return normalized_colors

/datum/component/ooze_color_shift/proc/update_accessory_colors(list/color_snapshot, progress)
	for(var/datum/accessory_holder as anything in color_snapshot)
		if(QDELETED(accessory_holder))
			continue
		var/list/start_colors = color_snapshot[accessory_holder]
		var/list/updated_colors = list()
		for(var/start_color in start_colors)
			updated_colors += "#[interpolate_color(start_color, target_color, progress)]"
		if(istype(accessory_holder, /datum/bodypart_feature))
			var/datum/bodypart_feature/feature = accessory_holder
			feature.accessory_colors = color_list_to_string(updated_colors)
		else if(istype(accessory_holder, /obj/item/organ))
			var/obj/item/organ/organ = accessory_holder
			organ.accessory_colors = color_list_to_string(updated_colors)

/datum/component/ooze_color_shift/proc/interpolate_color(start_color, end_color, progress)
	var/start_red = hex2num(copytext(start_color, 1, 3))
	var/start_green = hex2num(copytext(start_color, 3, 5))
	var/start_blue = hex2num(copytext(start_color, 5, 7))
	var/end_red = hex2num(copytext(end_color, 1, 3))
	var/end_green = hex2num(copytext(end_color, 3, 5))
	var/end_blue = hex2num(copytext(end_color, 5, 7))
	var/red = round(start_red + ((end_red - start_red) * progress))
	var/green = round(start_green + ((end_green - start_green) * progress))
	var/blue = round(start_blue + ((end_blue - start_blue) * progress))
	return "[num2hex(red, 2)][num2hex(green, 2)][num2hex(blue, 2)]"

/datum/species/ooze/random_name(gender,unique,lastname)

	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/oozem.txt") )
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick( world.file2list("strings/rt/names/other/oozef.txt") )
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick( world.file2list("strings/rt/names/other/oozem.txt") )
		if(gender == FEMALE)
			randname = pick( world.file2list("strings/rt/names/other/oozef.txt") )
	return randname

/datum/species/ooze/random_surname()
	return

/datum/action/cooldown/regrow_limb
	name = "Regrow Limb"
	desc = "Spend 250 nutrition and 30 seconds to regrow a missing arm or leg."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "heal"
	check_flags = AB_CHECK_CONSCIOUS|AB_CHECK_IMMOBILE

	var/is_regrowing = FALSE

/datum/action/cooldown/regrow_limb/Activate(atom/target)
	var/mob/living/carbon/ooze = owner
	if(!HAS_TRAIT(ooze, TRAIT_REGROW_LIMBS))
		return FALSE
	if(is_regrowing)
		to_chat(ooze, span_warning("I am already reshaping my body."))
		return FALSE
	if(ooze.nutrition <= NUTRITION_LEVEL_STARVING)
		to_chat(ooze, span_warning("I am too starved to regrow a limb."))
		return FALSE
	if(ooze.nutrition <= 250)
		to_chat(ooze, span_warning("I need more nutrition to regrow a limb."))
		return FALSE

	var/list/missing_limb_options = list()
	for(var/limb_zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
		if(ooze.get_bodypart(limb_zone))
			continue
		var/limb_name = LOWER_TEXT(bodyzone2readablezone(limb_zone))
		missing_limb_options[limb_name] = limb_zone
	if(!length(missing_limb_options))
		to_chat(ooze, span_warning("I have no missing limbs to regrow."))
		return FALSE

	var/selected_limb_name = input(ooze, "Which limb should I regrow?", name) as null|anything in missing_limb_options
	if(!selected_limb_name || QDELETED(ooze) || QDELETED(src) || owner != ooze)
		return FALSE
	var/selected_limb_zone = missing_limb_options[selected_limb_name]
	is_regrowing = TRUE
	ooze.visible_message(
		span_notice("[ooze] begins reshaping [ooze.p_their()] body to regrow [ooze.p_their()] [selected_limb_name]..."),
		span_notice("I begin reshaping my body to regrow my [selected_limb_name]..."),
	)
	play_regrowth_sound()
	if(!do_after(ooze, 30 SECONDS, target = ooze))
		if(!QDELETED(ooze) && HAS_TRAIT(ooze, TRAIT_REGROW_LIMBS))
			ooze.visible_message(
				span_notice("[ooze] stops reshaping [ooze.p_their()] body."),
				span_notice("I stop reshaping my body."),
			)
		if(!QDELETED(src))
			is_regrowing = FALSE
		return FALSE

	if(QDELETED(ooze) || QDELETED(src) || owner != ooze || !HAS_TRAIT(ooze, TRAIT_REGROW_LIMBS))
		return FALSE
	is_regrowing = FALSE
	if(ooze.nutrition <= NUTRITION_LEVEL_STARVING)
		to_chat(ooze, span_warning("I became too starved to finish regrowing my limb."))
		return FALSE
	if(ooze.nutrition <= 250)
		to_chat(ooze, span_warning("I no longer have enough nutrition to finish regrowing my limb."))
		return FALSE
	if(ooze.get_bodypart(selected_limb_zone))
		to_chat(ooze, span_warning("That limb has already been restored."))
		return FALSE
	if(!ooze.regenerate_limb(selected_limb_zone))
		to_chat(ooze, span_warning("I cannot regrow that limb right now."))
		return FALSE

	ooze.adjust_nutrition(-250)
	playsound(ooze.loc, 'sound/magic/slimesquish.ogg', 50, TRUE)
	ooze.visible_message(
		span_notice("[ooze]'s [selected_limb_name] finishes regrowing."),
		span_notice("My [selected_limb_name] finishes regrowing."),
	)
	return TRUE

/datum/action/cooldown/regrow_limb/proc/play_regrowth_sound()
	if(!is_regrowing || QDELETED(owner) || !HAS_TRAIT(owner, TRAIT_REGROW_LIMBS))
		return
	playsound(owner.loc, 'sound/foley/gross.ogg', 50, TRUE)
	addtimer(CALLBACK(src, PROC_REF(play_regrowth_sound)), 2 SECONDS)
