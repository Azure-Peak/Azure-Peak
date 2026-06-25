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
	vision_text = "The mists part to reveal someone clad in Orthodoxist vestments, their silver icons gleaming. \
	You see them preaching to a crowd, but their eyes betray uncertainty. Their faith is a hollow shell, built on sand. \
	Confront them, and watch the cracks form. \
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

/datum/vision_quest/wounded_tennite
	name = "Wounded Pilgrim"
	description = "A faithful tennite limps. Abyssor's waters will close their wounds."
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
	target_description = "a Tennite"
	summary = "A wounded lamb whom may require your aid."
	vision_text = "The mists part to reveal a trail of blood—crimson droplets staining the stone like a rosary of suffering. \
	You follow it to its source. A Tennite pilgrim, collapsed against a weathered shrine too damaged to identify. Their leg is savaged, \
	the flesh torn by something with claws like fishhooks. They clutch a rusted icon of the Gods, whispering prayers \
	between ragged breaths. Their eyes, clouded with pain, search the fog for salvation or death. \
	\n\nAs you approach, the vision shifts. You stand at the edge of an endless sea, black and restless beneath a moonless sky. \
	The waters churn, parting to reveal a path of jagged coral that leads to a submerged cathedral. Inside, a figure kneels \
	the pilgrim, whole and unbroken, dipping their hands into a pool of shimmering waters. Abyssor's voice rumbles from the depths, \
	not in words, but in the crash of waves against the shore. 'The faithful are not measured by their scars, but by their \
	willingness to rise from them.' The pilgrim rises, and the sea closes \
	behind them. \
	You blink, and you are back in the mist. The pilgrim stirs, their wounds weeping. They will not survive the night \
	without intervention. Will you be the hand that pulls them from the tide, or will you watch them drown?"
	possible_phrases = list(
		"The faithful do not bleed upon corrupt soil",
		"Bury whom wounds or suffer their grief"
	)

/datum/vision_quest/wounded_tennite/is_valid_target(mob/living/carbon/human/target, mob/living/carbon/human/seeker)
	if(!..())
		return FALSE
	if(target.getBruteLoss() < 50)
		return FALSE
	if(!target.patron)
		return FALSE
	var/list/tennite_gods = ALL_DIVINE_PATRONS
	if(!(target.patron.type in tennite_gods))
		return FALSE
	return TRUE
