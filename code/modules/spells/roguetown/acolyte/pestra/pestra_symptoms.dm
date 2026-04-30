/datum/rot_symptom
	var/name = "Symptom"
	var/cooldown = 20 SECONDS
	var/next_fire = 0
	var/required_tier = 1
	var/max_tier = 4

/datum/rot_symptom/proc/can_trigger(datum/status_effect/black_rot/rot)
	if(world.time < next_fire)
		return FALSE
	if(rot.tier < required_tier || rot.tier > max_tier)
		return FALSE
	return TRUE

/datum/rot_symptom/proc/activate(mob/living/L, datum/status_effect/black_rot/rot)
	next_fire = world.time + cooldown
	return TRUE

// --- TIER 1 SYMPTOMS ---

/datum/rot_symptom/vulnerable
	name = "Vulnerability"
	required_tier = 1
	max_tier = 1
	cooldown = 30 SECONDS

/datum/rot_symptom/vulnerable/activate(mob/living/L, datum/status_effect/black_rot/rot)
	..()
	to_chat(L, span_warning("Your joints lock up momentarily, leaving you wide open!"))
	L.apply_status_effect(/datum/status_effect/debuff/vulnerable, 6 SECONDS)

/datum/rot_symptom/chills
	name = "Chills"
	required_tier = 1
	max_tier = 1
	cooldown = 30 SECONDS

/datum/rot_symptom/chills/activate(mob/living/L, datum/status_effect/black_rot/rot)
	..()
	to_chat(L, span_warning("I feel a strange, deep chill in my bones..."))
	L.adjustBruteLoss(10)
	L.Jitter(10)

// --- TIER 2 SYMPTOMS ---

/datum/rot_symptom/exposed
	name = "Exposure"
	required_tier = 2
	max_tier = 2
	cooldown = 30 SECONDS
	var/exposed_duration = 7 SECONDS

/datum/rot_symptom/exposed/activate(mob/living/L, datum/status_effect/black_rot/rot)
	..()
	to_chat(L, span_danger("The rot makes your arms feel numb!"))
	L.apply_status_effect(/datum/status_effect/debuff/exposed, exposed_duration)

/datum/rot_symptom/vomit
	name = "Nausea"
	required_tier = 2
	cooldown = 60 SECONDS

/datum/rot_symptom/vomit/activate(mob/living/L, datum/status_effect/black_rot/rot)
	..()
	L.Jitter(10)
	L.adjustToxLoss(20)
	L.Immobilize(10)
	rot.trigger_vomit_fit()

// --- TIER 3 SYMPTOMS ---

/datum/rot_symptom/exposed/greater
	name = "Greater Exposure"
	required_tier = 3
	max_tier = 4
	cooldown = 30 SECONDS
	exposed_duration = 15 SECONDS

/datum/rot_symptom/necrosis_flare
	name = "Necrosis Flare"
	required_tier = 3
	cooldown = 75 SECONDS

/datum/rot_symptom/necrosis_flare/activate(mob/living/L, datum/status_effect/black_rot/rot)
	..()
	to_chat(L, span_danger("I feel bugs crawling around inside of me as the rot festers!"))
	L.adjustBruteLoss(15)
	L.apply_status_effect(/datum/status_effect/buff/infestation)

/datum/rot_symptom/chest_wound
	name = "Chest Burst"
	required_tier = 3
	cooldown = 75 SECONDS

/datum/rot_symptom/chest_wound/activate(mob/living/L, datum/status_effect/black_rot/rot)
	if(!iscarbon(L))
		return FALSE

	..()

	var/mob/living/carbon/C = L
	var/obj/item/bodypart/chest/chest_part = C.get_bodypart(BODY_ZONE_CHEST)

	if(!chest_part)
		return FALSE

	to_chat(L, span_danger("A vile black tendril extends through my skin as it attempts to stab me!"))

	// Apply a dynamic wound to the chest based on random bclass
	var/list/possible_wound_classes = list(BCLASS_BLUNT, BCLASS_CHOP, BCLASS_STAB, BCLASS_TWIST)
	var/chosen_bclass = pick(possible_wound_classes)
	var/damage_amount = rand(30, 60)

	// This will trigger the dynamic wound system through the chest's try_crit
	var/datum/wound/applied_wound = chest_part.bodypart_attacked_by(
		bclass = chosen_bclass,
		dam = damage_amount,
		user = null,  // No specific user, it's the rot itself
		zone_precise = BODY_ZONE_CHEST,
		silent = FALSE,
		crit_message = TRUE,
		armor = 0  // Rot bypasses armor
	)

	if(applied_wound)
		L.emote("scream", forced = TRUE)
		L.Jitter(15)
	else
		// Fallback damage if wound application fails
		chest_part.receive_damage(brute = damage_amount, updating_health = TRUE)
		L.emote("scream", forced = TRUE)

	return TRUE

// --- TIER 4 SYMPTOMS ---

/datum/rot_symptom/bone_snap
	name = "Bone Snap"
	required_tier = 4
	cooldown = 120 SECONDS

/datum/rot_symptom/bone_snap/activate(mob/living/L, datum/status_effect/black_rot/rot)
	if(!iscarbon(L))
		return FALSE
	var/mob/living/carbon/C = L
	var/list/obj/item/bodypart/valid_limbs = list()

	// Find limbs that are in our zone list AND not already broken
	for(var/obj/item/bodypart/BP in C.bodyparts)
		if((BP.body_zone in rot.valid_body_zones) && !BP.has_wound(/datum/wound/fracture))
			valid_limbs += BP

	if(!length(valid_limbs))
		return FALSE // All valid limbs are already destroyed/broken

	..()
	var/obj/item/bodypart/target = pick(valid_limbs)
	if(target)
		target.add_wound(/datum/wound/fracture/no_bleed)
	to_chat(L, span_userdanger("My [target.name] twists in an unnatural way as tumors bulge beneath my skin!"))
	L.Jitter(10)
	target.receive_damage(brute = 200, updating_health = TRUE, blocked = FALSE)
	return TRUE
