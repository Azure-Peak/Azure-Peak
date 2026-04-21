/mob/living/carbon/human/species/construct/metal
	race = /datum/species/construct/metal

/datum/species/construct/metal
	name = "Metal Construct"
	id = "constructm"
	origin_default = /datum/virtue/origin/naledi
	origin = "Naledi"
	base_name = "Godtouched"
	is_subrace = TRUE
	desc = "<b>Metallic Construct</b><br>\
	Masterworks of artifice, metal constructs are as the name implies- entirely constructed by mortal hands. They are beings not of flesh and blood, but cold metal and the arcyne. Constructs are said to originate from works of Zizo, and they hail from the far-off lands of the Southern Empty- a great city of artifice, where the only artificers capable of understanding what is necessary to create the constructs live. For some reason, they have found themselves travelling out of the empty, as of late. Children of the Resonator Siphon.<br>\
	<span style='color: #6a8cb7;text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'><b>+1 WIL | -2 SPD | No Hunger | No Breath | No Blood | Toxic Immunity | Shock Weakness</b></span><br><br>"

	construct = 1
	skin_tone_wording = "Material"
	use_skin_tone_wording_for_examine = FALSE
	default_color = "FFFFFF"
	species_traits = list(EYECOLOR,HAIR,FACEHAIR,LIPS,STUBBLE,OLDGREY,NOBLOOD) // this already overwrites all blood-related things, I made it better at stopping bleeding completely
	default_features = MANDATORY_FEATURE_LIST
	use_skintones = TRUE
	possible_ages = ALL_AGES_LIST
	skinned_type = /obj/item/ingot/steel
	disliked_food = NONE
	liked_food = NONE
	inherent_traits = list(
		TRAIT_IRONMAN, // this will help define better construct flags around the code, also bloodloss immunity and deathless are redundant due to NOBLOOD anyway, trait should also bar you from being infected now, same for Rotman
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH, // nobreath should make it so snoring doesn't make noises anymore, sleep away, brothers
		TRAIT_TOXIMMUNE, // legit once got poisoned for eating bad food LOL, fixed
		TRAIT_ZOMBIE_IMMUNE, // Much as I wish I could simplify it, this is best centralized
		)
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	limbs_icon_m = 'icons/roguetown/mob/bodies/m/mcom.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fcom.dmi'
	dam_icon = 'icons/roguetown/mob/bodies/dam/dam_male.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	soundpack_m = /datum/voicepack/male
	soundpack_f = /datum/voicepack/female
	offset_features = list(
		OFFSET_ID = list(0,1), OFFSET_GLOVES = list(0,1), OFFSET_WRISTS = list(0,1),\
		OFFSET_CLOAK = list(0,1), OFFSET_FACEMASK = list(0,1), OFFSET_HEAD = list(0,1), \
		OFFSET_FACE = list(0,1), OFFSET_BELT = list(0,1), OFFSET_BACK = list(0,1), \
		OFFSET_NECK = list(0,1), OFFSET_MOUTH = list(0,1), OFFSET_PANTS = list(0,1), \
		OFFSET_SHIRT = list(0,1), OFFSET_ARMOR = list(0,1), OFFSET_HANDS = list(0,1), OFFSET_UNDIES = list(0,1), \
		OFFSET_ID_F = list(0,-1), OFFSET_GLOVES_F = list(0,0), OFFSET_WRISTS_F = list(0,0), OFFSET_HANDS_F = list(0,0), \
		OFFSET_CLOAK_F = list(0,0), OFFSET_FACEMASK_F = list(0,-1), OFFSET_HEAD_F = list(0,-1), \
		OFFSET_FACE_F = list(0,-1), OFFSET_BELT_F = list(0,0), OFFSET_BACK_F = list(0,-1), \
		OFFSET_NECK_F = list(0,-1), OFFSET_MOUTH_F = list(0,-1), OFFSET_PANTS_F = list(0,0), \
		OFFSET_SHIRT_F = list(0,0), OFFSET_ARMOR_F = list(0,0), OFFSET_UNDIES_F = list(0,-1), \
		)
	race_bonus = list(STAT_WILLPOWER = 1, STAT_SPEED = -2)
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain/construct,
		ORGAN_SLOT_HEART = /obj/item/organ/heart/construct,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs/construct,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/construct,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/construct,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver/construct,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach/construct,
		)
	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/crest,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/underwear,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/piercing,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		)
	body_marking_sets = list(
		/datum/body_marking_set/none,
		/datum/body_marking_set/construct_plating_light,
		/datum/body_marking_set/construct_plating_medium,
		/datum/body_marking_set/construct_plating_heavy,
		)
	body_markings = list(
		/datum/body_marking/eyeliner,
		/datum/body_marking/tonage,
		/datum/body_marking/nose,
		/datum/body_marking/construct_plating_light,
		/datum/body_marking/construct_plating_medium,
		/datum/body_marking/construct_plating_heavy,
		/datum/body_marking/construct_head_standard,
		/datum/body_marking/construct_head_round,
		/datum/body_marking/construct_standard_eyes,
		/datum/body_marking/construct_visor_eyes,
		/datum/body_marking/construct_psyclops_eye,
	)

	restricted_virtues = list(/datum/virtue/utility/noble, /datum/virtue/utility/hollow)

/datum/species/construct/metal/check_roundstart_eligible()
	return TRUE
	
/datum/species/construct/metal/get_skin_list()
	return list(
		"BRASS" = "dfbd6c",
		"IRON" = "525352",
		"STEEL" = "babbb9",
		"BRONZE" = "e2a670",
		"GOLD" = "bf9b30",
		"WOOD" = "8B4513",
		"PORCELAIN" = "FFF5EE",
	)

/datum/species/construct/metal/get_hairc_list()
	return sortList(list(

	"black - midnight" = "1d1b2b",

	"red - blood" = "822b2b"

	))

/proc/try_construct_consume(obj/item/I, mob/living/M, mob/user)
	if(!HAS_TRAIT(M, TRAIT_IRONMAN))
		return FALSE

	// === PROCESSING LOCKOUT ===
	if(M.has_status_effect(/datum/status_effect/buff/ingotmuncher) \
	|| M.has_status_effect(/datum/status_effect/buff/oremuncher) \
	|| M.has_status_effect(/datum/status_effect/buff/gemmuncher))

		if(M == user)
			to_chat(user, span_warning("I am currently processing minerals, and need to wait..."))
		else
			to_chat(user, span_warning("[M] seems to be processing minerals on the moment, you need to wait..."))

		return TRUE

	var/power = 1

	// === STONE === 
	if(istype(I, /obj/item/natural/stone))
		var/obj/item/natural/stone/S = I
		power = S.magic_power + 1
		M.energy_add(S.magic_power)
		M.adjustBruteLoss(-power/2)
		M.adjustFireLoss(-power/2)
		user.visible_message(
			span_notice("[user] offers the [I] to [M]'s mouth, and they crunch it down instinctively."),
			span_notice("I crunch the [I] down and swallow it effortlessly.")
		)
		playsound(M.loc,'sound/misc/eat.ogg', rand(60,100), TRUE)
		sleep(5)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 25)
		qdel(I)
		return TRUE

	// === ORE === 
	if(istype(I, /obj/item/rogueore))
		power = 2 + I.sellprice / 2
		M.apply_status_effect(/datum/status_effect/buff/oremuncher, power)
		user.visible_message(
			span_notice("[user] offers the [I] to [M]'s mouth, and they crunch it down instinctively."),
			span_notice("I crunch the [I] down and swallow it effortlessly. This one is good stuff.")
		)
		playsound(M.loc,'sound/misc/eat.ogg', rand(60,100), TRUE)
		sleep(5)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 25)
		qdel(I)
		return TRUE

	if(M == user)
		if(!do_after(user, 12 SECONDS, M))
			return FALSE

	// === INGOT === 
	if(istype(I, /obj/item/ingot))
		power = 4 + I.sellprice / 2
		M.apply_status_effect(/datum/status_effect/buff/oremuncher, power)
		user.visible_message(
			span_notice("[user] presses the [I] into their form. It fuses seamlessly, spreading throughout their shell."),
			span_notice("I press the [I] into my body. It quickly binds and greatly reinforces me.")
		)
		playsound(user.loc, 'sound/magic/swap.ogg', 40)
		playsound(user.loc, 'sound/misc/lava_death.ogg', 40)
		qdel(I)
		return TRUE

	// === GEM ===
	if(istype(I, /obj/item/roguegem))
		power = 6 + I.sellprice / 2
		M.apply_status_effect(/datum/status_effect/buff/gemmuncher, power)
		user.visible_message(
			span_notice("[user] embeds the [I] into their core. It crackles, then vanishes within."),
			span_notice("I set [I] into my core. It sinks in... and I feel it resonate greatly, restoring me!")
		)
		qdel(I)
		playsound(user.loc, 'sound/magic/swap.ogg', 40)
		playsound(user.loc, 'sound/misc/lava_death.ogg', 40)
		return TRUE

	return FALSE
