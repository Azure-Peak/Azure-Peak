/datum/vision_quest/orthodox_hunt
	name = "Heretic's Folly"
	description = "An Orthodoxist stands in defiance of Abyssor. Confront them with the phrase and witness their doubt."
	required_tier = 1
	possible_rewards = list(
		/obj/item/dream_material/dream_spike = "spikes",
		/obj/item/dream_material/dream_seed = "seeds",
		/obj/item/dream_material/parchment_raw = "parchment"
	)
	possible_bonus_rewards = list(
		/obj/item/dream_material/dream_spike = "spikes",
		/obj/item/dream_material/dream_seed = "seeds",
		/obj/item/dream_material/parchment_raw = "parchment"
	)
	target_description = "an Orthodoxist priest"
	summary = "A priest's faith wavers when confronted by ancient truths."
	vision_text = "The mists part to reveal a man clad in Orthodoxist vestments, his silver icons gleaming. \
	You see him preaching to a crowd, but his eyes betray uncertainty. The old gods whisper to you: \
	his faith is a hollow echo, built on sand. Confront him, and watch the cracks form."
	possible_phrases = list(
		"Psydon is dead",
		"The old gods remember your sins",
		"Your silver icons mean nothing",
		"The truth shatters false idols"
	)

/datum/vision_quest/orthodox_hunt/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(target == seeker) return FALSE
	if(!target.mind) return FALSE
	if(target.mind.assigned_role == "Orthodoxist")
		return TRUE
	return FALSE
