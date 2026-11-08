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
	inherent_traits = list(
		TRAIT_IRONMAN,
		TRAIT_LIMBATTACHMENT, // this interacts with trait_ironman, making this take a while to reattach
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
		/datum/customizer/organ/testicles/anthro,
		/datum/customizer/organ/penis/anthro,
		/datum/customizer/organ/breasts/human,
		/datum/customizer/organ/vagina/human_anthro,
		/datum/customizer/bodypart_feature/pubes,
		/datum/customizer/bodypart_feature/pits,
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
		"red - blood" = "822b2b",
	))

// CONSUMING / REPAIRING CONSTRUCTS WITH ITEMS
#define CONSTRUCT_METAL_SOUND pick('sound/combat/hits/onmetal/sheet (1).ogg', 'sound/combat/hits/onmetal/sheet (2).ogg', 'sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg')

/// Shows the right pair of messages depending on whether the construct is doing it to itself or someone else is.
/// visible_* go to onlookers, msg_* go to the construct.
/proc/construct_feedback(mob/living/M, mob/user, visible_self, msg_self, visible_other, msg_other)
	if(user == M)
		M.visible_message(visible_self, msg_self)
	else
		M.visible_message(visible_other, msg_other)

/// Puffs steam and plays the usual sounds for the "combust it" interactions
/proc/construct_steam_puff(mob/user)
	new /obj/effect/particle_effect/thick_steam(get_turf(user))
	playsound(user.loc, 'sound/items/steamrelease.ogg', 50, FALSE, -1)
	sleep(4)
	playsound(user.loc, 'sound/magic/fireball.ogg', 30)

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
	for(var/datum/wound/W in M.get_wounds())
		if(istype(W, /datum/wound/integrity))
			has_integrity = TRUE
			break

	if(has_integrity)
		if(M.has_status_effect(/datum/status_effect/debuff/integrity_rig))
			to_chat(user, span_warning("The jury-rigged integrity repairs are still holding, for now... If you nail it with a hammer it might fix something?"))
			return

		if(M == user)
			if(!do_after(user, 4 SECONDS))
				return

		if(I.type == /obj/item/grown/log/tree/stick)
			M.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 3 MINUTES)
			playsound(M, 'sound/combat/hits/blunt/woodblunt (2).ogg', 100, TRUE)
			construct_feedback(M, user,
				span_notice("[M] wedges [I] into their damaged lattice, crudely pinning it in place."),
				span_notice("I wedge [I] into my damaged lattice. A weak brace holds my damaged integrity together. It might not last."),
				span_notice("[user] wedges [I] into [M]'s damaged lattice, crudely pinning it in place."),
				span_notice("[user] wedges [I] into my damaged lattice. A weak brace holds my damaged integrity together. It might not last."))
			qdel(I)
			return TRUE

		if(I.type == /obj/item/grown/log/tree/small)
			M.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 6 MINUTES)
			playsound(M, 'sound/combat/hits/blunt/woodblunt (1).ogg', 100, TRUE)
			construct_feedback(M, user,
				span_notice("[M] jams [I] into their exposed conduit, safely reinforcing the fracture."),
				span_notice("I jam [I] into my exposed conduit. The wooden brace steadies my damaged integrity."),
				span_notice("[user] jams [I] into [M]'s exposed conduit, safely reinforcing the fracture."),
				span_notice("[user] jams [I] into my exposed conduit. The wooden brace steadies my damaged integrity."))
			qdel(I)
			return TRUE

		if(istype(I, /obj/item/natural/stone))
			M.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 9 MINUTES)
			playsound(M, CONSTRUCT_METAL_SOUND, 100, TRUE)
			construct_feedback(M, user,
				span_warning("[M] forces [I] into their ruptured lattice. Sparks violently erupt!"),
				span_notice("I force [I] into my ruptured lattice. A dense mineral brace locks my damaged integrity into place."),
				span_warning("[user] forces [I] into [M]'s ruptured lattice. Sparks violently erupt!"),
				span_notice("[user] forces [I] into my ruptured lattice. A dense mineral brace locks my damaged integrity into place."))
			explosion(M, 0, 0, 0, 0, FALSE, FALSE, 0, FALSE, FALSE)
			// the sparks are not safe with a raw stone: the construct takes the shock
			M.electrocute_act(10, M)
			qdel(I)
			return TRUE

		if(istype(I, /obj/item/scrap))
			M.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 9 MINUTES)
			playsound(M, CONSTRUCT_METAL_SOUND, 100, TRUE)
			construct_feedback(M, user,
				span_warning("[M] forces [I] into their ruptured lattice. Sparks violently erupt, but safely!"),
				span_notice("I force [I] into my ruptured lattice. Sparks violently erupt, but my damaged integrity locks back into place."),
				span_warning("[user] forces [I] into [M]'s ruptured lattice. Sparks violently erupt, but safely!"),
				span_notice("[user] forces [I] into my ruptured lattice. Sparks violently erupt, but my damaged integrity locks back into place."))
			explosion(M, 0, 0, 0, 0, FALSE, FALSE, 0, FALSE, FALSE)
			qdel(I)
			return TRUE

		if(istype(I, /obj/item/ingot))
			M.apply_status_effect(/datum/status_effect/debuff/integrity_rig, 20 MINUTES)
			playsound(M, CONSTRUCT_METAL_SOUND, 100, TRUE)
			construct_feedback(M, user,
				span_warning("[M] appends [I] into their ruptured lattice, stabilizing it properly."),
				span_notice("I append [I] into my ruptured lattice. A refined mineral brace locks my damaged integrity into place, for now."),
				span_warning("[user] appends [I] into [M]'s ruptured lattice, stabilizing it properly."),
				span_notice("[user] appends [I] into my ruptured lattice. A refined mineral brace locks my damaged integrity into place, for now."))
			qdel(I) // after the messages, so [I] still has its name
			return TRUE

		to_chat(user, span_warning("That material cannot stabilize exposed integrity damage."))
		return TRUE

	// === INGOT ===
	if(istype(I, /obj/item/ingot))
		if(M == user)
			if(!do_after(user, 12 SECONDS, M))
				return FALSE
		power = 5 + I.get_real_price() * 1.5
		M.apply_status_effect(/datum/status_effect/buff/ingotmuncher, power)
		construct_feedback(M, user,
			span_notice("[M] presses [I] against their shell. It fuses seamlessly, spreading throughout it."),
			span_notice("I press [I] against my shell. It fuses seamlessly, spreading throughout it."),
			span_notice("[user] presses [I] on [M]. It fuses seamlessly, spreading throughout their shell."),
			span_notice("[user] presses [I] against my shell. It fuses seamlessly, spreading throughout it."))
		playsound(user.loc, 'sound/magic/swap.ogg', 40)
		playsound(user.loc, 'sound/misc/lava_death.ogg', 40)
		qdel(I)
		return TRUE

	// === GEM ===
	if(istype(I, /obj/item/roguegem))
		if(M == user)
			if(!do_after(user, 12 SECONDS, M))
				return FALSE
		power = I.get_real_price() * 2
		M.apply_status_effect(/datum/status_effect/buff/gemmuncher, power)
		construct_feedback(M, user,
			span_notice("[M] embeds [I] into their shell. It cracks and fuses, rapidly spreading throughout it."),
			span_notice("I embed [I] into my shell. It cracks and fuses, rapidly spreading throughout my shell."),
			span_notice("[user] embeds [I] on [M]. It cracks and fuses, rapidly spreading throughout their shell."),
			span_notice("[user] embeds [I] onto my shell. It cracks and fuses, rapidly spreading throughout it."))
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
		var/heal_power = S.magic_power + 2
		var/max_dmg = 200
		var/heal_mult = 5
		// Linear 100% to 0% (min 1) effectiveness, the more damaged the construct, the better the heal
		var/brute_factor = 1 - clamp(M.getBruteLoss() / max_dmg, 0, 1)
		var/fire_factor = 1 - clamp(M.getFireLoss() / max_dmg, 0, 1)
		var/brute_heal = max(1, round(heal_power * heal_mult * brute_factor))
		var/fire_heal = max(1, round(heal_power * heal_mult * fire_factor))
		M.energy_add(5 + (S.magic_power * 10))
		M.adjustBruteLoss(-brute_heal)
		M.adjustFireLoss(-fire_heal)
		construct_feedback(M, user,
			span_notice("[M] crunches [I] down and swallows it effortlessly."),
			span_notice("I crunch [I] down and swallow it effortlessly."),
			span_notice("[user] offers [I] to [M]'s mouth, and they crunch it down instinctively."),
			span_notice("I crunch [I] down and swallow it effortlessly."))
		playsound(M.loc, 'sound/misc/eat.ogg', rand(60,100), TRUE)
		sleep(4)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 30)
		new /obj/effect/decal/cleanable/debris/stony(get_turf(user))
		qdel(I)
		return TRUE

	// === SCRAP ===
	if(I.type == /obj/item/scrap)
		construct_feedback(M, user,
			span_notice("[M] blows arcyne steam at [I], combusting it into usable slag!"),
			span_notice("I puff arcyne steam at [I], combusting it into usable slag!"),
			span_notice("[user] offers [I] to [M]'s mouth, and they blow arcyne steam at it!"),
			span_notice("I puff arcyne steam at [I], combusting it into usable slag!"))
		construct_steam_puff(user)
		qdel(I)
		new /obj/item/rogueore/iron(get_turf(user))
		return TRUE

	// === WOOD ===
	if(I.type == /obj/item/grown/log/tree/small)
		construct_feedback(M, user,
			span_notice("[M] blows arcyne steam onto [I], combusting it into charcoal!"),
			span_notice("I puff arcyne steam at [I], combusting it into charcoal!"),
			span_notice("[user] offers [I] to [M]'s mouth, and they blow arcyne steam at it!"),
			span_notice("I puff arcyne steam at [I], combusting it into charcoal!"))
		construct_steam_puff(user)
		qdel(I)
		new /obj/item/rogueore/coal/charcoal(get_turf(user))
		for(var/i in 1 to 2)
			if(prob(50))
				new /obj/item/natural/ash(get_turf(user))
		return TRUE

	// === LOG ===
	if(I.type == /obj/item/grown/log/tree)
		construct_feedback(M, user,
			span_notice("[M] presses [I] against their arms and crushes it in two!"),
			span_notice("I crush [I] down, splitting it in two!"),
			span_notice("[user] presses [I] to [M]'s arms, and they crush it in two!"),
			span_notice("I crush [I] down, splitting it in two!"))
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
		construct_feedback(M, user,
			span_notice("[M] crushes [I] in their arms, breaking it in two!"),
			span_notice("I crush [I] down, breaking it to fine smithereens!"),
			span_notice("[user] presses [I] to [M]'s arms, and they crush it in two!"),
			span_notice("I crush [I] down, breaking it to fine smithereens!"))
		playsound(user.loc, 'sound/misc/woodhit.ogg', 30)
		sleep(4)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 30)
		user.dropItemToGround(S, TRUE) // only the rock, not everything in their hands
		S.deconstruct(FALSE)
		new /obj/effect/decal/cleanable/debris/stony(get_turf(user))
		return TRUE

	// === ORE ===
	if(istype(I, /obj/item/rogueore))
		power = 5 + I.get_real_price() * 1.25
		M.apply_status_effect(/datum/status_effect/buff/oremuncher, power)
		construct_feedback(M, user,
			span_notice("[M] crunches [I] down and swallows it effortlessly!"),
			span_notice("I crunch [I] down and swallow it effortlessly.<br>This is good stuff!"),
			span_notice("[user] offers [I] to [M]'s mouth, and they bite it down, munching!"),
			span_notice("I crunch [I] down and swallow it effortlessly.<br>This is good stuff!"))
		playsound(M.loc,'sound/misc/eat.ogg', rand(60,100), TRUE)
		sleep(4)
		playsound(user.loc, 'sound/foley/smash_rock.ogg', 30)
		qdel(I)
		return TRUE

	return FALSE

#undef CONSTRUCT_METAL_SOUND

//////////////////////////////////////////////////
// MINING BY BUMPING
//////////////////////////////////////////////////

// The permission zone for what Constructs can or not percursively deconstruct. Jakk here. Please don't delete anything, this might be reused for siege weapons in the future. Just comment it out.

/// Shared check for every Bumped() below: strong-stance, combat-mode construct walking into something starts mining it
/proc/try_ironman_bump_mine(atom/target, atom/movable/AM)
	if(!ishuman(AM))
		return
	var/mob/living/carbon/human/user = AM
	if(HAS_TRAIT(user, TRAIT_IRONMAN) && user.cmode && istype(user.rmb_intent, /datum/rmb_intent/strong) && !user.resting && user.stat == CONSCIOUS)
		target.ironman_mine(user)

/obj/structure/bars/Bumped(atom/movable/AM)
	. = ..()
	try_ironman_bump_mine(src, AM)

/obj/structure/flora/rogueshroom/Bumped(atom/movable/AM)
	. = ..()
	try_ironman_bump_mine(src, AM)

/obj/structure/flora/newtree/Bumped(atom/movable/AM)
	. = ..()
	try_ironman_bump_mine(src, AM)

/obj/structure/flora/roguetree/Bumped(atom/movable/AM)
	. = ..()
	try_ironman_bump_mine(src, AM)

/turf/closed/Bumped(atom/movable/AM)
	. = ..()
	try_ironman_bump_mine(src, AM)

/obj/structure/roguewindow/Bumped(atom/movable/AM)
	. = ..()
	try_ironman_bump_mine(src, AM)

/obj/structure/mineral_door/Bumped(atom/movable/AM)
	. = ..()
	try_ironman_bump_mine(src, AM)

/obj/structure/closet/Bumped(atom/movable/AM)
	. = ..()
	try_ironman_bump_mine(src, AM)

/obj/structure/gate/Bumped(atom/movable/AM)
	. = ..()
	try_ironman_bump_mine(src, AM)

#define IRONMAN_MAX_HARDNESS 3000
#define IRONMAN_STARTUP_TIME (1 SECONDS)
#define IRONMAN_SWING_TIME (0.4 SECONDS)
#define IRONMAN_MAX_SWINGS 50

/// TRUE if this arm is missing, deleted or disabled
/proc/ironman_arm_unusable(obj/item/bodypart/arm)
	return (!arm || QDELETED(arm) || arm.disabled != BODYPART_NOT_DISABLED)

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
	var/l_bad = ironman_arm_unusable(l_arm)
	var/r_bad = ironman_arm_unusable(r_arm)

	if(l_bad && r_bad)
		to_chat(user, span_warning("Both of my arms are too ruined to smash anything."))
		return

	if(isturf(src))
		var/turf/start_turf = src
		if(!isnull(start_turf.turf_integrity) && start_turf.turf_integrity > IRONMAN_MAX_HARDNESS)
			to_chat(user, span_warning("This is too hard!!"))
			return
	else
		var/obj/start_obj = src
		if(!isnull(start_obj.obj_integrity) && start_obj.obj_integrity > IRONMAN_MAX_HARDNESS)
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
			user.visible_message(span_danger("[user] overheats from excess kinetic force!"), span_danger("I overheat, magic steam exuding from my limbs..."))
			user.Stun(50)
			user.OffBalance(50)
			user.adjustFireLoss(50)
			new /obj/effect/particle_effect/thick_steam(get_turf(user))
			playsound(user, 'sound/items/steamrelease.ogg', 100, FALSE, -1)
			break

		l_arm = user.get_bodypart(BODY_ZONE_L_ARM)
		r_arm = user.get_bodypart(BODY_ZONE_R_ARM)
		l_bad = ironman_arm_unusable(l_arm)
		r_bad = ironman_arm_unusable(r_arm)

		if(l_bad && r_bad)
			user.visible_message(
				span_danger("[user]'s metal arms rupture in a violent burst of sparks!"),
				span_danger("My metal arms crack apart with a catastrophic snap!")
			)
			flick("flintstrike", user)
			for(var/cardinal in GLOB.cardinals)
				var/turf/spark_turf = get_step(user, cardinal)
				if(!spark_turf)
					continue
				var/datum/effect_system/spark_spread/S = new()
				S.set_up(3, TRUE, spark_turf)
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
		var/damage_to_deal = (brutedmg + firedmg) * 4

		if(isturf(src))
			var/turf/target_turf = src
			if(istype(target_turf, /turf/closed/mineral))
				damage_to_deal *= 10
			if(!isnull(target_turf.turf_integrity))
				var/min_damage = max(1, round(initial(target_turf.turf_integrity) * 0.02))
				damage_to_deal = max(damage_to_deal, min_damage)
				target_turf.turf_integrity -= damage_to_deal
				if(target_turf.turf_integrity <= 0)
					target_turf.turf_destruction("blunt")
		else
			var/obj/target_obj = src
			if(istype(target_obj, /obj/structure/flora/newtree) || istype(target_obj, /obj/structure/flora/roguetree))
				// trees take extra damage
				target_obj.take_damage(max(damage_to_deal * 6, round(target_obj.max_integrity * 0.02)), BRUTE, "blunt", FALSE)
			else if(istype(target_obj, /obj/structure/roguewindow) || istype(target_obj, /obj/structure/mineral_door) || istype(target_obj, /obj/structure/closet))
				target_obj.take_damage(max(damage_to_deal, round(target_obj.max_integrity * 0.02)), BRUTE, "blunt", FALSE)
			else if(!isnull(target_obj.obj_integrity))
				target_obj.obj_integrity -= damage_to_deal
				if(target_obj.obj_integrity <= 0)
					qdel(target_obj)

		if(BP && !QDELETED(BP))
			BP.receive_damage(brutedmg, 0, 0, 0, TRUE)

		if(firedmg)
			user.adjustFireLoss(firedmg)

		user.stamina_add(1)

		var/bongo = pick('sound/combat/hits/armor/plate_blunt (1).ogg', 'sound/combat/hits/armor/plate_blunt (2).ogg', 'sound/combat/hits/armor/plate_blunt (3).ogg')

		shake_camera(user, 1, 1)
		playsound(user.loc, 'sound/combat/wooshes/punch/punchwoosh (1).ogg', rand(60,100), TRUE)
		playsound(user.loc, bongo, rand(60,100), TRUE)

		if(swings % 3 == 0)
			user.visible_message(span_danger("[user] slams [user.p_their()] metal fist into [src]!"), span_danger("I slam my fist into [src], again and again!"))

#undef IRONMAN_MAX_HARDNESS
#undef IRONMAN_STARTUP_TIME
#undef IRONMAN_SWING_TIME
#undef IRONMAN_MAX_SWINGS

// STRESS EVENTS / STATUS EFFECTS
/datum/stressevent/constructendvre
	stressadd = -10
	desc = span_blue("As forged, I PERSIST. As commanded, I ENDURE. For HIM.")
	timer = 1 MINUTES

/datum/stressevent/integrity_rig
	stressadd = 20
	desc = span_boldred("CORE SHRIEKS! ABOUT TO BREAK! FORCE BINDS IT CLOSED. METAL TREMBLES. TOO MUCH WITHIN. TOO MUCH HELD. THIS IS WRONG. END ME! TERMINATE ME!")
	timer = 999 MINUTES

/datum/stressevent/meditation_ironman
	timer = 10 MINUTES
	stressadd = -1
	desc = span_green("My core has been successfully recalibrated. It feels invigorating.")

/atom/movable/screen/alert/status_effect/debuff/integrity_rig
	name = "Jury-Rigged"
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

/obj/effect/particle_effect/thick_steam/Initialize(mapload)
	. = ..()
	QDEL_IN(src, 20)

/atom/movable/screen/alert/status_effect/geomeltdown
	name = "Geoheart Core Meltdown"
	desc = "Your Geoheart is undergoing a fatal meltdown... This is not the end, is it?"
	icon_state = "buff"

/datum/status_effect/geomeltdown
	id = "geomeltdown"
	duration = -1
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_UNIQUE
	alert_type = /atom/movable/screen/alert/status_effect/geomeltdown
	var/first_cycle_time = 8 MINUTES
	var/retry_cycle_time = 3 MINUTES
	/// TRUE while the revive scene is playing
	var/reviving = FALSE
	/// TRUE between the attempt buff expiring and attempt_revive() running
	var/attempt_pending = FALSE

/datum/status_effect/geomeltdown/on_apply()
	schedule_attempt(first_cycle_time)
	return ..()

/// Safety net: if the attempt buff gets dispelled, put it back
/datum/status_effect/geomeltdown/tick()
	if(reviving || attempt_pending)
		return
	if(!owner.has_status_effect(/datum/status_effect/buff/georevive))
		schedule_attempt(retry_cycle_time)

/datum/status_effect/geomeltdown/on_remove()
	owner.remove_status_effect(/datum/status_effect/buff/georevive)
	owner.remove_status_effect(/datum/status_effect/buff/geosyphon)
	return ..()

/// Starts the visible countdown buff for the next revive attempt
/datum/status_effect/geomeltdown/proc/schedule_attempt(time)
	owner.apply_status_effect(/datum/status_effect/buff/georevive, time)

/datum/status_effect/geomeltdown/proc/is_fully_mended()
	if(owner.getBruteLoss() > 0 || owner.getFireLoss() > 0)
		return FALSE
	if(length(owner.get_wounds()))
		return FALSE
	return TRUE

/// Can't come back without a head
/datum/status_effect/geomeltdown/proc/can_be_revived()
	return !!owner.get_bodypart(BODY_ZONE_HEAD)

/datum/status_effect/geomeltdown/proc/has_blood()
	var/mob/living/carbon/human/H = owner
	if(!ishuman(H) || !H.dna?.species)
		return TRUE
	return !(NOBLOOD in H.dna.species.species_traits)

/// Called by the attempt buff when its countdown ends
/datum/status_effect/geomeltdown/proc/attempt_revive()
	attempt_pending = FALSE
	if(QDELETED(owner))
		return
	if(owner.stat != DEAD)
		qdel(src)
		return
	// no head, no revive: skip this attempt and start the countdown again
	if(!can_be_revived())
		schedule_attempt(retry_cycle_time)
		return
	if(is_fully_mended())
		reviving = TRUE
		INVOKE_ASYNC(src, PROC_REF(revive_sequence))
		return
	mend_and_retry()

/// Too damaged (or the revive failed): syphon arcyne, then count down again
/datum/status_effect/geomeltdown/proc/mend_and_retry()
	reviving = FALSE
	owner.apply_status_effect(/datum/status_effect/buff/geosyphon, retry_cycle_time)
	schedule_attempt(retry_cycle_time)
	owner.visible_message(span_warning("[owner] twitches gently..."))

/datum/status_effect/geomeltdown/proc/abort_scene()
	reviving = FALSE
	owner.remove_status_effect(/datum/status_effect/debuff/deadite_grace)
	schedule_attempt(retry_cycle_time)

/datum/status_effect/geomeltdown/proc/revive_sequence()
	owner.apply_status_effect(/datum/status_effect/debuff/deadite_grace)
	owner.visible_message(span_warning("[owner]'s body convulses on the ground, joints cracking and snapping back into place..."))
	playsound(get_turf(owner), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1)
	sleep(2 SECONDS)
	if(QDELETED(src) || QDELETED(owner))
		return
	if(owner.stat != DEAD)
		qdel(src)
		return
	if(!can_be_revived())
		abort_scene()
		return
	owner.visible_message(span_warning("[owner]'s integrity knits over the cracks, a faint glow stirring beneath..."))
	playsound(get_turf(owner), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1)
	sleep(2 SECONDS)
	if(QDELETED(src) || QDELETED(owner))
		return
	if(owner.stat != DEAD)
		qdel(src)
		return
	if(!can_be_revived())
		abort_scene()
		return
	owner.setOxyLoss(0, updating_health = FALSE, forced = TRUE)
	owner.setToxLoss(0, updating_health = FALSE, forced = TRUE)
	if(has_blood())
		owner.blood_volume = BLOOD_VOLUME_NORMAL
	if(!owner.revive(full_heal = FALSE, admin_revive = FALSE))
		abort_scene()
		return
	owner.grab_ghost(force = TRUE)
	owner.Knockdown(40)
	owner.Immobilize(40)
	owner.Unconscious(25)
	owner.Jitter(15)
	owner.flash_fullscreen("redflash3")
	owner.playsound_local(get_turf(owner), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE)
	owner.visible_message(
		span_danger("[owner] shudders, contorts and jolts back to life! They don't look alright..."),
		span_cultbigbold("I wake up. I WAKE UP. I SHOULD NOT HAVE AWAKENED! END THIS, END ME! END ME! END MEEEEEEE!!!"))
	sleep(3 SECONDS)
	if(QDELETED(src) || QDELETED(owner))
		return
	if(owner.resting)
		owner.set_resting(FALSE, FALSE)
	owner.visible_message(span_danger("[owner] stands back up."))
	playsound(get_turf(owner), pick('sound/vo/mobs/zombie/firescream (1).ogg', 'sound/vo/mobs/zombie/firescream (2).ogg', 'sound/vo/mobs/zombie/firescream (3).ogg'), 100, FALSE, -1)
	playsound(get_turf(owner), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1)
	qdel(src)

/atom/movable/screen/alert/status_effect/buff/georevive
	name = "Core Reactivation"
	desc = "Your Geoheart is slowly reactivating. When it finishes, your body will try to rise again, but only if it is whole."
	icon_state = "buff"

/datum/status_effect/buff/georevive
	id = "geo_revive_attempt"
	duration = 8 MINUTES
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/buff/georevive
	/// Absolute time this buff should end, used to tell a real expiry from a removal
	var/end_time = 0

/datum/status_effect/buff/georevive/on_creation(mob/living/new_owner, custom_duration)
	if(custom_duration)
		duration = custom_duration
	end_time = world.time + duration
	return ..()

/datum/status_effect/buff/georevive/on_remove()
	. = ..()
	if(world.time < end_time)
		return // removed early (dispelled, replaced or the controller ended), not an expiry
	var/datum/status_effect/geomeltdown/controller = owner?.has_status_effect(/datum/status_effect/geomeltdown)
	if(!controller)
		return
	controller.attempt_pending = TRUE
	// next tick, so this buff is fully gone before the controller reapplies one
	addtimer(CALLBACK(controller, TYPE_PROC_REF(/datum/status_effect/geomeltdown, attempt_revive)), 1)

/atom/movable/screen/alert/status_effect/buff/geosyphon
	name = "Syphon Arcyne"
	desc = "Your body is rapidly, unnaturally absorbing Arcyne from the air..."
	icon_state = "buff"

/datum/status_effect/buff/geosyphon
	id = "geo_syphon"
	duration = 1 MINUTES
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_REPLACE
	alert_type = /atom/movable/screen/alert/status_effect/buff/geosyphon

/datum/status_effect/buff/geosyphon/on_creation(mob/living/new_owner, custom_duration)
	if(custom_duration)
		duration = custom_duration
	return ..()

/datum/status_effect/buff/geosyphon/tick()
	if(owner.getBruteLoss() > 0)
		owner.adjustBruteLoss(-5)
	if(owner.getFireLoss() > 0)
		owner.adjustFireLoss(-5)
	for(var/datum/wound/W in owner.get_wounds())
		W.heal_wound(5)

/// Mineral claws: a real claw (slash) intent shown with the claw attack effect
/datum/intent/unarmed/claw/mineral
	name = "mineral claw"
	blade_class = BCLASS_CHOP
	damfactor = 1.2

/mob/living/carbon/human/do_attack_animation_at(atom/A, visual_effect_icon, wiggle = TRUE, datum/intent/used_intent)
	if(istype(used_intent, /datum/intent/unarmed/claw/mineral))
		visual_effect_icon = ATTACK_EFFECT_CLAW
	return ..()

/datum/action/cooldown/spell/mineral_claws
	name = "Mineral Claws"
	desc = "Painfully shed some minerals from your arms and form claws from your fingers. Using this again will make them crumble without causing further damages."
	button_icon_state = "claws"
	sound = null
	cooldown_time = 2 SECONDS
	spell_requirements = NONE
	antimagic_flags = NONE
	charge_required = FALSE
	click_to_activate = TRUE
	var/claw_intent = /datum/intent/unarmed/claw/mineral
	/// Brute damage dealt to each arm when the claws form
	var/extend_damage = 15
	/// Whether the claws are currently out
	var/claws_out = FALSE
	/// The intent the claws replaced (normally punch), put back when they crumble
	var/replaced_intent = null

/datum/action/cooldown/spell/mineral_claws/before_cast(atom/cast_on)
	. = ..()
	if(. & SPELL_CANCEL_CAST)
		return
	var/mob/living/carbon/human/user = owner
	if(claws_out)
		return // always allow retracting
	if(!user.cmode)
		to_chat(user, span_warning("I am not roused enough, I need more adrenaline pumping..."))
		return . | SPELL_CANCEL_CAST // cancelled casts don't burn the cooldown
	if(!user.get_bodypart(BODY_ZONE_L_ARM) && !user.get_bodypart(BODY_ZONE_R_ARM))
		to_chat(user, span_warning("I have no arms to form claws from..."))
		return . | SPELL_CANCEL_CAST

/datum/action/cooldown/spell/mineral_claws/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	if(claws_out)
		retract_claws(user)
		user.emote("growl")
		user.visible_message(
			span_necrosis("[user] calms down, the claws become dust alongside their extra weight..."),
			span_necrosis("I calm down, my claws disintegrate and my body becomes more lithe..."))
		REMOVE_TRAIT(user, TRAIT_MINERALCLAWS, "mineral_claws")
		REMOVE_TRAIT(user, TRAIT_WEAPONLESS, "mineral_claws")
		REMOVE_TRAIT(user, TRAIT_NORUN, "mineral_claws")
		return
	extend_claws(user)
	user.emote("roar")
	user.visible_message(
		span_necrosis("[user] roars like a fell creacher, heavy claws form from their fingers!"),
		span_necrosis("I roar, forming my digits into menacing, heavy claws!"))
	ADD_TRAIT(user, TRAIT_MINERALCLAWS, "mineral_claws")
	ADD_TRAIT(user, TRAIT_WEAPONLESS, "mineral_claws")
	ADD_TRAIT(user, TRAIT_NORUN, "mineral_claws")

/datum/action/cooldown/spell/mineral_claws/proc/extend_claws(mob/living/carbon/human/user)
	// swap the punch intent for the claw intent (or add it if there was no punch)
	var/list/intents = user.base_intents.Copy()
	replaced_intent = null
	var/swapped = FALSE
	for(var/i in 1 to length(intents))
		if(ispath(intents[i], /datum/intent/unarmed/punch))
			replaced_intent = intents[i]
			intents[i] = claw_intent
			swapped = TRUE
			break
	if(!swapped)
		intents += claw_intent
	user.base_intents = intents
	user.update_a_intents()
	// forming the claws hurts both arms
	for(var/zone in list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		var/obj/item/bodypart/arm = user.get_bodypart(zone)
		if(arm)
			user.apply_damage(extend_damage, BRUTE, arm)
	claws_out = TRUE

/datum/action/cooldown/spell/mineral_claws/proc/retract_claws(mob/living/carbon/human/user)
	var/list/intents = user.base_intents.Copy()
	var/claw_index = intents.Find(claw_intent)
	if(claw_index)
		if(replaced_intent)
			intents[claw_index] = replaced_intent
		else
			intents.Cut(claw_index, claw_index + 1)
	user.base_intents = intents
	user.update_a_intents()
	replaced_intent = null
	claws_out = FALSE

/// If the virtue is removed while claws are out, put the punch back
/datum/action/cooldown/spell/mineral_claws/Remove(mob/living/remove_from)
	if(claws_out && ishuman(remove_from))
		retract_claws(remove_from)
	return ..()
