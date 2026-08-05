/datum/mob_descriptor/body
	abstract_type = /datum/mob_descriptor/body
	slot = MOB_DESCRIPTOR_SLOT_BODY

/datum/mob_descriptor/body/average
	name = "Average"

/datum/mob_descriptor/body/athletic
	name = "Athletic"

/datum/mob_descriptor/body/muscular
	name = "Muscular"

/datum/mob_descriptor/body/herculean
	name = "Herculean"

/datum/mob_descriptor/body/plump
	name = "Plump"

/datum/mob_descriptor/body/pearshaped
	name = "Pear-shaped"

/datum/mob_descriptor/body/pudgy
	name = "Pudgy"

/datum/mob_descriptor/body/strongfat
	name = "Strong-fat"

/datum/mob_descriptor/body/round
	name = "Round"

/datum/mob_descriptor/body/heavy
	name = "Heavy"

/datum/mob_descriptor/body/topheavy
	name = "Top Heavy"

/datum/mob_descriptor/body/bottomheavy
	name = "Bottom Heavy"

/datum/mob_descriptor/body/curvy
	name = "Curvy"

/datum/mob_descriptor/body/voluptuous
	name = "Voluptuous"

/datum/mob_descriptor/body/decrepit
	name = "Decrepit"

/datum/mob_descriptor/body/thin
	name = "Thin"

/datum/mob_descriptor/body/bulky
	name = "Bulky"

/datum/mob_descriptor/body/slender
	name = "Slender"

/datum/mob_descriptor/body/lissome
	name = "Lissome"

/datum/mob_descriptor/body/lanky
	name = "Lanky"

/datum/mob_descriptor/body/twiggy
	name = "Twiggy"

/datum/mob_descriptor/body/dainty
	name = "Dainty"

/datum/mob_descriptor/body/petite
	name = "Petite"

/datum/mob_descriptor/body/gaunt
	name = "Gaunt"

/datum/mob_descriptor/body/lean
	name = "Lean"

/datum/mob_descriptor/body/skeletal
	name = "Skeletal"

/datum/mob_descriptor/body/broadshoulder
	name = "Broad-shouldered"

/datum/mob_descriptor/body/waspwaist
	name = "Wasp-waisted"

/datum/mob_descriptor/body/burly
	name = "Burly"

/datum/mob_descriptor/body/custom
	var/custom_index

/datum/mob_descriptor/body/custom/can_describe(mob/living/described)
	return length(described.custom_descriptors) >= custom_index

/datum/mob_descriptor/body/custom/get_description(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	return entry.content_text

/datum/mob_descriptor/body/custom/seven
	name = "Custom Body"
	custom_index = 7
