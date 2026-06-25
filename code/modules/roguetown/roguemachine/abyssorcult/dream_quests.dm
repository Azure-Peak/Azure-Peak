/datum/vision_quest/orthodox_hunt
	name = "Psydonic Vision"
	description = "A psydonite stands in Abyssor's gaze. You are the prophet, you will deliver his missive."
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
	target_description = "an Orthodoxist"
	summary = "A psydonite's faith in the light of a true vision."
	vision_text = "The mists part to reveal a man clad in Orthodoxist vestments, his silver icons gleaming. \
	You see him preaching to a crowd, but his eyes betray uncertainty. His faith is a hollow shell, built on sand. \
	Confront him, and watch the cracks form. \
	\n\nSuddenly, you find yourself deep beneath the earth. A chamber hollowed out in rock by Malum, like a cathedral. \
	A large, elderly figure lies quietly in a bed of gigantic, thorny roses. Briars cut the flesh, marring the skin. \
	Wounds ooze crimson—the wine of life decanted into hungry roots, carrying the essence far and wide. \
	The old god stands no more... But you need to know, your calloused hands fighting the thorns to clamber up a gigantic palm. \
	It is arduous, a journey which feels like hours... stretching on into days, hands digging into bits of loose skin like a misshapen ladder. \
	Sides like a mountain, the torso stretching on like a desert. Was He ever this large? Did your eyes deceive you? It has been too long to remember anything clearly. \
	Then the jaws, stretching on like the gate to Necra's domain. With the end in sight, it is as if the very sweat crawls back into your flesh. \
	The howling winds you anticipate, yet the hollow stays silent. Pale curtains cover what should be basking in His glory, His caring gaze. \
	O Psydon, why have you forsaken us so?"
	possible_phrases = list(
		"Psydon is dead",
		"The seas sing a somber dirge for him"
	)
	valid_roles = list("Orthodoxist","Inquisitor","Absolver")
