/mob/living/carbon/human/species/construct/metal
	race = /datum/species/construct/metal

/datum/species/construct/metal
	name = "Metal Construct"
	id = "constructm"
	origin_default = /datum/virtue/origin/naledi
	origin = "Naledi"
	base_name = "Godtouched"
	is_subrace = TRUE
	desc_title = "Metallic Construct"
	desc = "Masterworks of artifice, metal constructs are as the name implies- entirely constructed by mortal hands. They are beings not of flesh and blood, but cold metal and the arcyne. Constructs are said to originate from works of Zizo, and they hail from the far-off lands of the Southern Empty- a great city of artifice, where the only artificers capable of understanding what is necessary to create the constructs live. For some reason, they have found themselves travelling out of the empty, as of late. Children of the Resonator Siphon."
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
		TRAIT_IRONMAN,
		TRAIT_LIMBATTACHMENT, // this interacts with trait_ironman, making this take a while to reattach
		TRAIT_NOPAINSTUN, // look into this later, just remembered Ryan merged NoPainSlow (cur. TRAIT_IGNOREDAMAGESLOWDOWN) into NoPainStun, might be good to separate them again for situations where I want my character to collapse from total pain, but not flinch when being hit
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH, 
		TRAIT_TOXIMMUNE, 
		TRAIT_ZOMBIE_IMMUNE,
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

	mechanics_explanations = list("Their wounds cannot be mended with needles or surgery, but instead with mechanical repairs. Light wounds can be mended with just a hammer, but more severe injuries will require a pair of tongs or a wrench held in the off hand for the hammer to work.",
		"Generic healing miracles used on them will be less effective the closer they are to being at perfect condition.",
		"Spells of mending can heal their wounds.",
		"While on the brink of death, can be temporarily stabilized by sticks or rocks.",
		"Can easily attach any prosthetic limbs to their bodies, including their own when they are lost.",
		"Can mine rocky terrain by trying to walk into it while in Combat Mode and while in STRONG stance.",
		"Are vulnerable to electrocution.",
		"Have unique interactions when certain items are used on them:\n\
		\t<b>Gemstones, Ingots, Raw Ores, and Stones</b>: Are consumed to heal the construct.\n\
		\t<b>Cut Tree Logs</b>: Are turned into charcoal.\n\
		\t<b>Whole Tree Logs</b>: Are split in half.\n\
		\t<b>Large Rocks</b>: Are broken down into stones.")

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

	if(M.stat == DEAD)
		to_chat(user, span_warning("They are dead. Only proper repairs can help now..."))
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

	// INTEGRITY DAMAGE OVERRIDE
	var/has_integrity = FALSE
	var/list/integ = M.get_wounds()
	for(var/datum/wound/W in integ)
		if(istype(W, /datum/wound/integrity))
			has_integrity = TRUE
			break

	if(has_integrity)
		if(M == user)
			if(!do_after(user, 4 SECONDS))
				return
		
		if(M.has_status_effect(/datum/status_effect/debuff/integrity_rig))
			to_chat(user, span_warning("The jury rigged integrity repairs are still holding, for now..."))
			return

		if(I.type == /obj/item/grown/log/tree/stick)
			var/obj/item/grown/log/tree/stick/S = I
			M.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 3 MINUTES)
			playsound(M, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
			user.visible_message(
				span_notice("[user] wedges [I] into [M]'s damaged lattice, crudely pinning it in place."),
				span_notice("A weak brace holds my damaged integrity together. It might not last")
			)
			qdel(S)
			return TRUE

		if(I.type == /obj/item/grown/log/tree/small)
			var/obj/item/grown/log/tree/small/S = I
			M.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 6 MINUTES)
			playsound(M, 'sound/combat/hits/blunt/woodblunt (1).ogg', 100, TRUE)
			user.visible_message(
				span_notice("[user] jams [I] into [M]'s exposed conduit, safely reinforcing the fracture."),
				span_notice("The wooden brace steadies my damaged integrity.")
			)
			qdel(S)
			return TRUE

		if(istype(I, /obj/item/natural/stone))
			var/obj/item/natural/stone/S = I
			M.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 9 MINUTES)
			playsound(M, pick('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/sheet (2).ogg', 'sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, TRUE)
			user.visible_message(
				span_warning("[user] forces [I] into [M]'s ruptured lattice. Sparks violently erupt!"),
				span_notice("A dense mineral brace locks my damaged integrity into place.")
			)
			explosion(M, 0, 0, 0, 0, FALSE, FALSE, 0, FALSE, FALSE)
			for(var/mob/living/L in range(2, M))
				L.electrocute_act(10, L)
				break
			qdel(S)
			return TRUE

		if(istype(I, /obj/item/scrap))
			var/obj/item/scrap/S = I
			M.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 9 MINUTES)
			playsound(M, pick('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/sheet (2).ogg', 'sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, TRUE)
			user.visible_message(
				span_warning("[user] forces [I] into [M]'s ruptured lattice. Sparks violently erupt, a bit safely!"),
				span_notice("Odds bits and pieces locks my damaged integrity into place.")
			)
			explosion(M, 0, 0, 0, 0, FALSE, FALSE, 0, FALSE, FALSE)
			qdel(S)
			return TRUE

		if(istype(I, /obj/item/ingot))
			qdel(I)
			M.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 20 MINUTES)
			playsound(M, pick('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/sheet (2).ogg', 'sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, TRUE)
			user.visible_message(
				span_warning("[user] appends [I] into [M]'s ruptured lattice, stabilizing it properly."),
				span_notice("A refined mineral brace locks my damaged integrity into place, for now.")
			)
			return TRUE

		to_chat(user, span_warning("That material cannot stabilize exposed integrity damage."))
		return TRUE

	// === INGOT === 
	if(istype(I, /obj/item/ingot))
		if(M == user)
			if(!do_after(user, 12 SECONDS, M))
				return FALSE
		power = 5 + I.sellprice * 1.5
		M.apply_status_effect(/datum/status_effect/buff/ingotmuncher, power)
		user.visible_message(span_notice("[user] presses [I] on [M]. It fuses seamlessly, spreading throughout their shell."))
		playsound(user.loc, 'sound/magic/swap.ogg', 40)
		playsound(user.loc, 'sound/misc/lava_death.ogg', 40)
		qdel(I)
		return TRUE

	// === GEM ===
	if(istype(I, /obj/item/roguegem))
		if(M == user)
			if(!do_after(user, 12 SECONDS, M))
				return FALSE
		power = I.sellprice * 2
		M.apply_status_effect(/datum/status_effect/buff/gemmuncher, power)
		user.visible_message(span_notice("[user] embeds [I] on [M]. It cracks and fuses, rapidly spreading throughout their shell."))
		qdel(I)
		playsound(user.loc, 'sound/magic/swap.ogg', 40)
		playsound(user.loc, 'sound/misc/lava_death.ogg', 40)
		return TRUE

	if(M.stat != CONSCIOUS)
		to_chat(user, span_warning("They are in no condition to do this."))
		return FALSE

	// === STONE ===
	if(istype(I, /obj/item/natural/stone))
		var/obj/item/natural/stone/S = I
		var/pow = S.magic_power + 2
		var/brute = M.getBruteLoss()
		var/fire  = M.getFireLoss()
		var/MAX_DMG = 200
		var/MULT = 5
		// Normalize damage
		var/brute_ratio = clamp(brute / MAX_DMG, 0, 1)
		var/fire_ratio  = clamp(fire  / MAX_DMG, 0, 1)
		// Linear 100% to 0% (min 1) effectiveness ratio
		var/brute_factor = 1 - brute_ratio
		var/fire_factor  = 1 - fire_ratio
		// Final healing
		var/brute_heal = max(1, round(pow * MULT * brute_factor))
		var/fire_heal  = max(1, round(pow * MULT * fire_factor))
		M.energy_add(5 + (S.magic_power * 10))
		M.adjustBruteLoss(-brute_heal)
		M.adjustFireLoss(-fire_heal)
		user.visible_message(
			span_notice("[user] offers [I] to [M]'s mouth, and they crunch it down instinctively."),
			span_notice("I crunch [I] down and swallow it effortlessly.")
		)
		playsound(M.loc, 'sound/misc/eat.ogg', rand(60,100), TRUE)
		sleep(4)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 30)
		new /obj/effect/decal/cleanable/debris/stony(get_turf(user))
		qdel(I)
		return TRUE

	// === SCRAP === 
	if(I.type == /obj/item/scrap)
		var/obj/item/scrap/L = I
		user.visible_message(
			span_notice("[user] offers [L] to [M]'s mouth, and they blow arcyne steam at it!"),
			span_notice("I puff arcyne steam at [L], combusting it into usable slag!")
		)
		new /obj/effect/particle_effect/thick_steam(get_turf(user))
		playsound(user.loc, 'sound/items/steamrelease.ogg', 50, FALSE, -1)
		sleep(4)
		playsound(user.loc, 'sound/magic/fireball.ogg', 30)
		qdel(I)
		new /obj/item/rogueore/iron(get_turf(user))
		return TRUE

	// === WOOD === 
	if(I.type == /obj/item/grown/log/tree/small)
		var/obj/item/grown/log/tree/small/L = I
		user.visible_message(
			span_notice("[user] offers [L] to [M]'s mouth, and they blow arcyne steam at it!"),
			span_notice("I puff arcyne steam at [L], combusting it into charcoal!")
		)
		new /obj/effect/particle_effect/thick_steam(get_turf(user))
		playsound(user.loc, 'sound/items/steamrelease.ogg', 50, FALSE, -1)
		sleep(4)
		playsound(user.loc, 'sound/magic/fireball.ogg', 30)
		qdel(I)
		new /obj/item/rogueore/coal/charcoal(get_turf(user))
		if(prob(50))
			new /obj/item/ash(get_turf(user))
		if(prob(50))
			new /obj/item/ash(get_turf(user))
		return TRUE

	// === LOG === 
	if(I.type == /obj/item/grown/log/tree)
		var/obj/item/grown/log/tree/L = I
		user.visible_message(
			span_notice("[user] presses [L] to [M]'s arms, and they crush it in two!"),
			span_notice("I crush [L] down, splitting it in two!")
		)
		playsound(user.loc, 'sound/misc/woodhit.ogg', 30)
		sleep(4)
		playsound(user, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
		qdel(I)
		new /obj/item/grown/log/tree/small(get_turf(user.loc))
		new /obj/item/grown/log/tree/small(get_turf(user.loc))
		new /obj/effect/decal/cleanable/debris/woody(get_turf(user))
		return TRUE

	// === ROCK === 
	if(istype(I, /obj/item/natural/rock))
		var/obj/item/natural/rock/S = I
		user.visible_message(
			span_notice("[user] presses [I] to [M]'s arms, and they crush it in two!"),
			span_notice("I crush [S] down, breaking it to fine smithereens!")
		)
		playsound(user.loc, 'sound/misc/woodhit.ogg', 30)
		sleep(4)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 30)
		user.drop_all_held_items()
		S.deconstruct(FALSE)
		new /obj/effect/decal/cleanable/debris/stony(get_turf(user))
		return TRUE

	// === ORE === 
	if(istype(I, /obj/item/rogueore))
		power = 5 + I.sellprice * 1.25
		M.apply_status_effect(/datum/status_effect/buff/oremuncher, power)
		user.visible_message(
			span_notice("[user] offers [I] to [M]'s mouth, and they bite it down, munching!"),
			span_notice("I crunch [I] down and swallow it effortlessly.<br>This is good stuff!")
		)
		playsound(M.loc,'sound/misc/eat.ogg', rand(60,100), TRUE)
		sleep(4)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 30)
		qdel(I)
		return TRUE

	return FALSE

// The permission zone for what Constructs can or not percursively deconstruct. Jakk here. Please don't delete anything, this might be reused for siege weapons in the future. Just comment it out.

/obj/structure/bars/Bumped(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	if(HAS_TRAIT(user, TRAIT_IRONMAN) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong) && !user.resting && user.stat == CONSCIOUS)
		src.ironman_mine(user)

/obj/structure/flora/rogueshroom/Bumped(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	if(HAS_TRAIT(user, TRAIT_IRONMAN) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong) && !user.resting && user.stat == CONSCIOUS)
		src.ironman_mine(user)

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

/obj/structure/roguewindow/Bumped(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	if(HAS_TRAIT(user, TRAIT_IRONMAN) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong) && !user.resting && user.stat == CONSCIOUS)
		src.ironman_mine(user)

/obj/structure/mineral_door/Bumped(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	if(HAS_TRAIT(user, TRAIT_IRONMAN) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong) && !user.resting && user.stat == CONSCIOUS)
		src.ironman_mine(user)

/obj/structure/closet/Bumped(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	if(HAS_TRAIT(user, TRAIT_IRONMAN) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong) && !user.resting && user.stat == CONSCIOUS)
		src.ironman_mine(user)

/obj/structure/gate/Bumped(atom/movable/AM)
	. = ..()
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	if(HAS_TRAIT(user, TRAIT_IRONMAN) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong) && !user.resting && user.stat == CONSCIOUS)
		src.ironman_mine(user)

#define IRONMAN_MAX_HARDNESS 3000
#define IRONMAN_STARTUP_TIME 1 SECONDS
#define IRONMAN_SWING_TIME 0.4 SECONDS
#define IRONMAN_MAX_SWINGS 50

/atom/proc/ironman_mine(mob/living/user)
	if(!user || !isliving(user))
		return

	if(user.resting || user.doing || user.stat)
		return

	if(!user.Adjacent(src))
		return

	if(QDELETED(src))
		return

	if(!isturf(src) && !isobj(src))
		return

	if(!density)
		return

	if(user.get_active_held_item() || user.get_inactive_held_item())
		return

	var/obj/item/bodypart/l_arm = user.get_bodypart(BODY_ZONE_L_ARM)
	var/obj/item/bodypart/r_arm = user.get_bodypart(BODY_ZONE_R_ARM)

	var/l_bad = (!l_arm || QDELETED(l_arm) || l_arm.disabled != BODYPART_NOT_DISABLED)
	var/r_bad = (!r_arm || QDELETED(r_arm) || r_arm.disabled != BODYPART_NOT_DISABLED)

	if(l_bad && r_bad)
		to_chat(user, span_warning("Both of my arms are too ruined to smash anything."))
		return

	if(isturf(src))
		var/turf/T = src
		if(!isnull(T.turf_integrity) && T.turf_integrity > IRONMAN_MAX_HARDNESS)
			to_chat(user, span_warning("This is too hard!!"))
			return

	else if(isobj(src))
		var/obj/O = src
		if(!isnull(O.obj_integrity) && O.obj_integrity > IRONMAN_MAX_HARDNESS)
			to_chat(user, span_warning("This is too hard!!"))
			return

	user.visible_message(
		span_warning("[user] winds back [user.p_their()] arm, locking in..."),
		span_warning("I wind back my arm, preparing to demolish [src]...")
	)


	if(!do_after(user, IRONMAN_STARTUP_TIME, TRUE, src, TRUE, null, TRUE))
		return

	var/swings = 0

	while(src && !QDELETED(src) && density && user && !QDELETED(user) && user.Adjacent(src) && !user.resting && !user.stat)
		swings++
		if(swings > IRONMAN_MAX_SWINGS)
			user.visible_message(span_danger("[user] overheats from excess kinetic force!"),span_danger("I overheat, magic steam exhuding from my limbs..."))
			user.Stun(50)
			user.OffBalance(50)
			user.adjustFireLoss(50)
			new /obj/effect/particle_effect/thick_steam(get_turf(user))
			playsound(user, 'sound/items/steamrelease.ogg', 100, FALSE, -1)
			break

		l_arm = user.get_bodypart(BODY_ZONE_L_ARM)
		r_arm = user.get_bodypart(BODY_ZONE_R_ARM)

		l_bad = (!l_arm || QDELETED(l_arm) || l_arm.disabled != BODYPART_NOT_DISABLED)
		r_bad = (!r_arm || QDELETED(r_arm) || r_arm.disabled != BODYPART_NOT_DISABLED)

		if(l_bad && r_bad)
			user.visible_message(
				span_danger("[user]'s metal arms rupture in a violent burst of sparks!"),
				span_danger("My metal arms crack apart with a catastrophic snap!")
			)
			flick("flintstrike", user)

			for(var/dir in GLOB.cardinals)
				var/turf/T = get_step(user, dir)
				if(!T)
					continue

				var/datum/effect_system/spark_spread/S = new()
				S.set_up(3, TRUE, T)
				S.start()

			playsound(user.loc, 'sound/foley/breaksound.ogg', 100, FALSE, -1)
			shake_camera(user, 2, 1)
			break

		if(!do_after(user, IRONMAN_SWING_TIME, TRUE, src))
			break

		if(QDELETED(src) || !density)
			playsound(user.loc, 'sound/foley/smash_rock.ogg', rand(60,100), TRUE)
			break

		var/list/usable_arms = list()
		if(!l_bad)
			usable_arms += l_arm
		if(!r_bad)
			usable_arms += r_arm

		if(!length(usable_arms))
			break

		var/obj/item/bodypart/BP = pick(usable_arms)

		var/brutedmg = rand(1,4)
		var/firedmg = prob(40) ? rand(1,10) : 0
		var/totaldmg = (brutedmg + firedmg) * 4

		if(isturf(src))
			var/turf/T = src
			var/damage_to_deal = totaldmg

			if(istype(T, /turf/closed/mineral))
				damage_to_deal *= 10

			if(!isnull(T.turf_integrity))
				var/min_damage = max(1, round(initial(T.turf_integrity) * 0.02))
				damage_to_deal = max(damage_to_deal, min_damage)

				T.turf_integrity -= damage_to_deal

				if(T.turf_integrity <= 0)
					T.turf_destruction("blunt")

		else if(isobj(src))
			var/obj/O = src
			var/damage_to_deal = totaldmg

			if(istype(O, /obj/structure/flora/newtree))
				var/obj/structure/flora/newtree/TR = O
				var/min_damage = round(TR.max_integrity * 0.02)
				TR.take_damage(max(damage_to_deal * 6, min_damage), BRUTE, "blunt", FALSE)

			else if(istype(O, /obj/structure/flora/roguetree))
				var/obj/structure/flora/roguetree/RT = O
				var/min_damage = round(RT.max_integrity * 0.02)
				RT.take_damage(max(damage_to_deal * 6, min_damage), BRUTE, "blunt", FALSE)

			else if(istype(O, /obj/structure/roguewindow))
				var/obj/structure/roguewindow/RW = O
				var/min_damage = round(RW.max_integrity * 0.02)
				RW.take_damage(max(damage_to_deal, min_damage), BRUTE, "blunt", FALSE)

			else if(istype(O, /obj/structure/mineral_door))
				var/obj/structure/mineral_door/MD = O
				var/min_damage = round(MD.max_integrity * 0.02)
				MD.take_damage(max(damage_to_deal, min_damage), BRUTE, "blunt", FALSE)

			else if(istype(O, /obj/structure/closet))
				var/obj/structure/closet/CL = O
				var/min_damage = round(CL.max_integrity * 0.02)
				CL.take_damage(max(damage_to_deal, min_damage), BRUTE, "blunt", FALSE)

			else if(!isnull(O.obj_integrity))
				O.obj_integrity -= damage_to_deal

				if(O.obj_integrity <= 0)
					qdel(O)

		if(BP && !QDELETED(BP))
			BP.receive_damage(brutedmg, 0, 0, 0, TRUE)

		if(firedmg)
			user.adjustFireLoss(firedmg)

		user.stamina_add(1)

		var/bongo = pick('sound/combat/hits/armor/plate_blunt (1).ogg','sound/combat/hits/armor/plate_blunt (2).ogg','sound/combat/hits/armor/plate_blunt (3).ogg')

		shake_camera(user, 1, 1)
		playsound(user.loc, 'sound/combat/wooshes/punch/punchwoosh (1).ogg', rand(60,100), TRUE)
		playsound(user.loc, bongo, rand(60,100), TRUE)

		if(swings % 3 == 0)
			user.visible_message(span_danger("[user] slams [user.p_their()] metal fist into [src]!"),span_danger("I slam my fist into [src], again and again!"))

#undef IRONMAN_MAX_HARDNESS
#undef IRONMAN_STARTUP_TIME
#undef IRONMAN_SWING_TIME
#undef IRONMAN_MAX_SWINGS

/datum/stressevent/constructendvre
	stressadd = -10
	desc = span_blue("As forged, I PERSIST. As commanded, I ENDURE. For HIM.")
	timer = 1 MINUTES

/datum/stressevent/integrity_rig
	stressadd = 20
	desc = span_boldred("CORE SHRIEKS! ABOUT TO BREAK! FORCE BINDS IT CLOSED. METAL TREMBLES. TOO MUCH WITHIN. TOO MUCH HELD. THIS IS WRONG. END ME! TERMINATE ME!")
	timer = 999 MINUTES

/atom/movable/screen/alert/status_effect/debuff/integrity_rig
	name = "Jury Rigged"
	desc = "Your damaged lattice has been temporarily stabilized, at a heavy cost of your performance."
	icon_state = "muscles"

/datum/status_effect/debuff/integrity_rig
	id = "integrity_rig"
	duration = 1 MINUTES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/debuff/integrity_rig
	effectedstats = list(STATKEY_STR = -7, STATKEY_WIL = -7, STATKEY_LCK = -7)

/datum/status_effect/debuff/integrity_rig/on_creation(mob/living/new_owner, custom_duration)
	if(custom_duration)
		duration = custom_duration
	return ..()

/datum/status_effect/debuff/integrity_rig/on_apply()
	owner.add_stress(/datum/stressevent/integrity_rig)
	. = ..()
	
/datum/status_effect/debuff/integrity_rig/on_remove()
	owner.remove_stress(/datum/stressevent/integrity_rig)
	. = ..()

/obj/effect/particle_effect/thick_steam
	name = "steam"
	icon_state = "smoke"
	density = FALSE
	layer = MOB_LAYER+1

/obj/effect/particle_effect/thick_steam/Initialize()
	. = ..()
	QDEL_IN(src, 20)

/datum/stressevent/meditation_ironman
	timer = 10 MINUTES
	stressadd = -1
	desc = span_green("My core has been successfully recalibrated. It feels invigorating.")
