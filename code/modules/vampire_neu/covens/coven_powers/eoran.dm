/datum/coven/eora
	name = "Eoran Embrace"
	desc = "Blessed by the Goddess of Love, Family, and Art, these vampires have developed powers that strengthen bonds, inspire beauty, and heal emotional wounds."
	icon_state = "eora"
	power_type = /datum/coven_power/eora
	max_level = 4

/datum/coven_power/eora
	name = "Eora power name"
	desc = "Eora power description"

//EMPATHIC BOND
/datum/coven_power/eora/empathic_bond
	name = "Empathic Bond"
	desc = "Touch someone to sense their emotional state and immediate needs, making you obsessed with them for a short time."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 1

	cooldown_length = 10 SECONDS

/datum/coven_power/eora/empathic_bond/activate(mob/living/target)
	. = ..()
	if(!ishuman(target))
		to_chat(owner, span_warning("You can only sense the emotions of other people."))
		return

	var/mob/living/carbon/human/victim = target

	// Generate emotional state based on character's current condition
	var/list/emotions = list()
	var/list/needs = list()

	if(victim.getBruteLoss() > 20 || victim.getFireLoss() > 20)
		emotions += "pain"
		needs += "healing"
	if(victim.getToxLoss() > 20)
		emotions += "sickness"
		needs += "cleansing"
	if(victim.getOxyLoss() > 20)
		emotions += "exhaustion"
		needs += "rest"
	if(victim.nutrition < 200)
		emotions += "hunger"
		needs += "sustenance"
	if(victim.getOrganLoss(ORGAN_SLOT_BRAIN) > 20)
		emotions += "confusion"
		needs += "mental clarity"

	// Add some randomized emotional states
	var/list/possible_emotions = list("loneliness", "contentment", "anxiety", "hope", "sadness", "joy", "fear", "love", "anger", "peace")
	emotions += pick(possible_emotions)

	var/list/possible_needs = list("companionship", "understanding", "safety", "purpose", "acceptance", "creative expression")
	needs += pick(possible_needs)

	var/emotion_text = english_list(emotions)
	var/needs_text = english_list(needs)

	to_chat(owner, span_notice("You sense [victim]'s emotional state: [emotion_text]. They seem to need: [needs_text]."))
	to_chat(victim, span_info("You feel [owner] understanding your inner state with surprising clarity."))
	owner.AddComponent(/datum/component/empathic_obsession, victim, 2 MINUTES)

//ARTISTIC INSPIRATION
/datum/coven_power/eora/artistic_inspiration
	name = "Artistic Inspiration"
	desc = "Inspire others with divine creativity, enhancing their artistic abilities and mood."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 3

	cooldown_length = 30 SECONDS
	duration_length = 5 MINUTES

/datum/coven_power/eora/artistic_inspiration/activate(mob/living/target)
	. = ..()
	if(!ishuman(target))
		to_chat(owner, span_warning("Only humans can receive artistic inspiration."))
		return

	var/mob/living/carbon/human/inspired = target

	to_chat(owner, span_notice("You whisper words of divine inspiration to [inspired]."))
	to_chat(inspired, span_purple("You feel a surge of creative energy flow through you, your mind buzzing with artistic possibilities!"))
	target.heal_overall_damage(30, 30)
	target.mind?.sleep_adv?.retained_dust += 200
	target.mind?.sleep_adv?.grant_inspiration_xp(2)

	// Boost mood and give temporary creative buff do this for now until we add some form of creation quality outside of blacksmithing
	target.add_stress(/datum/stressevent/artistic_inspiration)

	addtimer(CALLBACK(src, PROC_REF(deactivate), inspired), duration_length)

/datum/coven_power/eora/artistic_inspiration/deactivate(mob/living/carbon/human/target)
	. = ..()
	to_chat(target, span_info("The divine inspiration fades, but the memory of it remains."))

//FAMILIAL BOND
/datum/coven_power/eora/familial_bond
	name = "Familial Bond"
	desc = "Create a temporary spiritual connection between two people, allowing them to sense each other's location and well-being."

	level = 3
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_SPEAK
	target_type = TARGET_LIVING | TARGET_HUMAN
	range = 5

	cooldown_length = 60 SECONDS
	duration_length = 10 MINUTES

/datum/coven_power/eora/familial_bond/activate(mob/living/target)
	. = ..()
	if(!ishuman(target))
		to_chat(owner, span_warning("You can only bond with other people."))
		return

	var/mob/living/carbon/human/bonded = target

	// Get second target
	var/mob/living/carbon/human/second_target = input(owner, "Who will you bond [bonded] with?") as null|mob in (oviewers(5, owner) - bonded)
	if(!second_target || !ishuman(second_target))
		to_chat(owner, span_warning("You need a second person to create a familial bond."))
		return

	to_chat(owner, span_notice("You weave a spiritual connection between [bonded] and [second_target]."))
	to_chat(bonded, span_purple("You feel a warm connection forming with [second_target], as if they were family."))
	to_chat(second_target, span_purple("You feel a warm connection forming with [bonded], as if they were family."))

	// Store the bond information
	bonded.AddComponent(/datum/component/familial_bond, second_target, duration_length, src)
	second_target.AddComponent(/datum/component/familial_bond, bonded, duration_length, src)

//BEAUTY'S RESTORATION
/datum/coven_power/eora/beautys_restoration
	name = "Beauty's Restoration"
	desc = "Channel Eora's power to restore physical beauty and heal disfigurements."

	level = 4
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS | COVEN_CHECK_CAPABLE | COVEN_CHECK_FREE_HAND
	target_type = TARGET_LIVING | TARGET_HUMAN | TARGET_SELF
	range = 1

	cooldown_length = 90 SECONDS

/datum/coven_power/eora/beautys_restoration/activate(mob/living/target)
	. = ..()
	if(!ishuman(target))
		to_chat(owner, span_warning("You can only restore the beauty of people."))
		return

	var/mob/living/carbon/human/patient = target

	to_chat(owner, span_notice("You channel Eora's restorative power into [patient]."))
	to_chat(patient, span_purple("You feel divine energy coursing through you, restoring your natural beauty!"))

	// Visual effect
	patient.remove_overlay(MUTATIONS_LAYER)
	var/mutable_appearance/restoration_overlay = mutable_appearance('icons/effects/clan.dmi', "dementation", -MUTATIONS_LAYER)
	patient.overlays_standing[MUTATIONS_LAYER] = restoration_overlay
	patient.apply_overlay(MUTATIONS_LAYER)

	// Heal brute and burn damage (representing restoration of beauty)
	patient.heal_overall_damage(60, 60)

	patient.add_stress(/datum/stressevent/artistic_inspiration_minor)

	addtimer(CALLBACK(src, PROC_REF(deactivate), patient), 3 SECONDS)
	owner.AddComponent(/datum/component/empathic_obsession, patient, 5 MINUTES)

/datum/coven_power/eora/beautys_restoration/deactivate(mob/living/carbon/human/target)
	. = ..()
	target.remove_overlay(MUTATIONS_LAYER)

/datum/stressevent/artistic_inspiration
	desc = span_love("I feel divinely inspired to create something beautiful!")
	stressadd = -3
	timer = 5 MINUTES
	quality_modifier = 3

/datum/stressevent/artistic_inspiration_minor
	desc = span_love("I feel... Inspired!")
	stressadd = -1
	timer = 2 MINUTES
	quality_modifier = 1

