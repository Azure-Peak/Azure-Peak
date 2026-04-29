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
	L.apply_status_effect(/datum/status_effect/debuff/vulnerable, 5 SECONDS)

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
	cooldown = 30 SECONDS

/datum/rot_symptom/exposed/activate(mob/living/L, datum/status_effect/black_rot/rot)
	..()
	to_chat(L, span_userdanger("The rot makes your arms feel numb!"))
	L.apply_status_effect(/datum/status_effect/debuff/exposed, 15 SECONDS)

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

/datum/rot_symptom/necrosis_flare
	name = "Necrosis Flare"
	required_tier = 3
	cooldown = 40 SECONDS

/datum/rot_symptom/necrosis_flare/activate(mob/living/L, datum/status_effect/black_rot/rot)
	..()
	to_chat(L, span_userdanger("I feel bugs crawling around inside of me as the rot festers!"))
	L.adjustBruteLoss(15)
	L.apply_status_effect(/datum/status_effect/buff/infestation)

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
		if((BP.body_zone in rot.valid_body_zones) && !(BP.get_damage() >= BP.max_damage))
			valid_limbs += BP

	if(!length(valid_limbs))
		return FALSE // All valid limbs are already destroyed/broken

	..()
	var/obj/item/bodypart/target = pick(valid_limbs)
	to_chat(L, span_userdanger("My [target.name] twists in an unnatural way as tumors bulge beneath my skin!"))
	L.Jitter(10)
	target.receive_damage(brute = 200, updating_health = TRUE)
	return TRUE
