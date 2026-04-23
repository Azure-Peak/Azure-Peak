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
		TRAIT_NOPAIN, // oh boi here we go, but Ironman now fully prevents anything above Light Armor from being equipped.
		TRAIT_NOHUNGER, // consum rocke
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
		M.energy_add(1 + (S.magic_power * 3))

		var/brute = M.getBruteLoss()
		var/fire = M.getFireLoss()
		var/MAX_DMG = 200 // scales from 1000% to a mere 10% about this makes rock heal miserably low, in other words: hammer time if wound is at mangled+
		var/brute_ratio = round(min(brute / MAX_DMG, 1))
		var/fire_ratio  = round(min(fire / MAX_DMG, 1))
		var/brute_scale = 0.1 + (1 - brute_ratio) * (10.0 - 0.1) // 10.0 at 0 damage to 0.1 at max damage
		var/fire_scale  = 0.1 + (1 - fire_ratio)  * (10.0 - 0.1) // 10.0 at 0 damage to 0.1 at max damage
		var/brute_heal = round(1 + ((1 + power) * brute_scale))
		var/fire_heal  = round(1 + ((1 + power) * fire_scale))

		M.energy_add(1 + (S.magic_power * 3))
		M.adjustBruteLoss(-brute_heal)
		M.adjustFireLoss(-fire_heal)
		to_chat(user, "DEBUG: [brute_heal] brute/[fire_heal] fire healed.")
		user.visible_message(
			span_notice("[user] offers the [I] to [M]'s mouth, and they crunch it down instinctively."),
			span_notice("I crunch the [I] down and swallow it effortlessly.")
		)
		playsound(M.loc,'sound/misc/eat.ogg', rand(60,100), TRUE)
		sleep(4)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 30)
		qdel(I)
		return TRUE

	// === ROCK === 
	if(istype(I, /obj/item/natural/rock))
		var/obj/item/natural/rock/S = I
		user.visible_message(
			span_notice("[user] offers the [S] to [M]'s mouth, and they crunch it to bits instinctively."),
			span_notice("I crunch the [S] down, breaking it to fine smithereens!")
		)
		playsound(S.loc,'sound/misc/eat.ogg', rand(60,100), TRUE)
		sleep(4)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 30)
		user.drop_all_held_items()
		S.deconstruct(FALSE)
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
		sleep(4)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 30)
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


/obj/structure/flora/newtree/Bumped(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	if(HAS_TRAIT(user, TRAIT_IRONMAN) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong) && !user.resting && user.stat == CONSCIOUS)
		src.ironman_mine(user)

/obj/structure/flora/roguetree/Bumped(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	if(HAS_TRAIT(user, TRAIT_IRONMAN) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong) && !user.resting && user.stat == CONSCIOUS)
		src.ironman_mine(user)

/turf/closed/Bumped(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	if(HAS_TRAIT(user, TRAIT_IRONMAN) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong) && !user.resting && user.stat == CONSCIOUS)
		src.ironman_mine(user)

/atom/proc/ironman_mine(mob/living/user)
	if(!user || !isliving(user) || user.resting || user.doing || !user.Adjacent(src))
		return
	if(!density)
		return

	var/obj/item/bodypart/l_arm = user.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/bodypart/r_arm = user.get_bodypart(BODY_ZONE_R_ARM)

	var/l_bad = (!l_arm || l_arm.disabled != BODYPART_NOT_DISABLED)
	var/r_bad = (!r_arm || r_arm.disabled != BODYPART_NOT_DISABLED)

	if(l_bad && r_bad)
		to_chat(user, span_warning("Both of my arms are too ruined to smash anything."))
		return

	if(isturf(src))
		var/turf/T = src
		if(T.turf_integrity > 3000)
			to_chat(user, span_warning("This is too hard!!"))
			return

	else if(isobj(src))
		var/obj/O = src
		if(O.obj_integrity > 3000)
			to_chat(user, span_warning("This is too hard!!"))
			return

	user.visible_message(span_warning("[user] winds back [user.p_their()] arm, locking in..."), span_warning("I wind back my arm, preparing to demolish [src]..."))

	if(!do_after(user, 1 SECONDS, TRUE, src, TRUE, null, TRUE))
		return

	while(src && density && user && user.Adjacent(src) && !user.resting)
		l_arm = user.get_bodypart(BODY_ZONE_L_ARM)
		r_arm = user.get_bodypart(BODY_ZONE_R_ARM)

		l_bad = (!l_arm || l_arm.disabled != BODYPART_NOT_DISABLED)
		r_bad = (!r_arm || r_arm.disabled != BODYPART_NOT_DISABLED)

		if(l_bad && r_bad)
			to_chat(user, span_warning("My arms give out!"))
			break

		if(!do_after(user, 0.4 SECONDS, TRUE, src))
			break

		var/obj/item/bodypart/BP
		if(!l_bad && !r_bad)
			BP = pick(l_arm, r_arm)
		else if(!l_bad)
			BP = l_arm
		else
			BP = r_arm

		var/brutedmg = rand(1,4)
		var/firedmg = prob(40) ? rand(1,10) : 0
		var/totaldmg = (brutedmg + firedmg) * 6

		if(isturf(src))
			var/turf/T = src
			var/damage_to_deal = totaldmg

			if(istype(T, /turf/closed/mineral))
				damage_to_deal *= 4 

			if(T.turf_integrity)
				T.turf_integrity -= damage_to_deal
				if(T.turf_integrity <= 0)
					T.turf_destruction("blunt")

		else if(isobj(src))
			var/obj/O = src

			if(istype(O, /obj/structure/flora/newtree))
				var/obj/structure/flora/newtree/TR = O
				TR.take_damage(totaldmg, BRUTE, "blunt", FALSE)

			else if(istype(O, /obj/structure/flora/roguetree))
				var/obj/structure/flora/roguetree/RT = O
				RT.take_damage(totaldmg, BRUTE, "blunt", FALSE)

			else
				if(O.obj_integrity)
					O.obj_integrity -= totaldmg
					if(O.obj_integrity <= 0)
						qdel(O)

		BP.receive_damage(brutedmg, 0, 0, 0, TRUE)

		if(firedmg)
			user.adjustFireLoss(firedmg)

		user.stamina_add(-15)

		var/bongo = pick('sound/combat/hits/armor/plate_blunt (1).ogg','sound/combat/hits/armor/plate_blunt (2).ogg','sound/combat/hits/armor/plate_blunt (3).ogg')

		shake_camera(user, 1, 1)
		playsound(user.loc, 'sound/combat/wooshes/punch/punchwoosh (1).ogg', rand(60,100), TRUE)
		playsound(user.loc, bongo, rand(60,100), TRUE)

		if(QDELETED(src) || !density)
			playsound(user.loc, 'sound/foley/smash_rock.ogg', rand(60,100), TRUE)
			break

		user.visible_message(span_danger("[user] slams [user.p_their()] metal fist into [src]!"), span_danger("I pound [src] again and again!"))
