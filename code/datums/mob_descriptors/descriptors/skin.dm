/datum/mob_descriptor/skin
	abstract_type = /datum/mob_descriptor/skin
	slot = MOB_DESCRIPTOR_SLOT_SKIN
	verbage = "%HAVE%"

/datum/mob_descriptor/skin/normal
	name = "Normal Skin"

/datum/mob_descriptor/skin/hairy
	name = "Hairy Skin"

/datum/mob_descriptor/skin/soft
	name = "Soft Skin"

/datum/mob_descriptor/skin/rugged
	name = "Rugged Skin"

/datum/mob_descriptor/skin/diseased
	name = "Diseased Skin"

/datum/mob_descriptor/skin/dry
	name = "Dry Skin"

/datum/mob_descriptor/skin/fine
	name = "Fine Skin"

/datum/mob_descriptor/skin/wrinkled
	name = "Wrinkled Skin"

/datum/mob_descriptor/skin/sunkissed
	name = "Sunkissed Skin"

/datum/mob_descriptor/skin/aged
	name = "Aged Skin"

/datum/mob_descriptor/skin/pockmarked
	name = "Pockmarked Skin"

/datum/mob_descriptor/skin/dusky
	name = "Dusky Skin"

/datum/mob_descriptor/skin/irritated
	name = "Irritated Skin"

/datum/mob_descriptor/skin/ashen
	name = "Ashen Skin"

/datum/mob_descriptor/skin/ravaged
	name = "Ravaged Skin"

/datum/mob_descriptor/skin/pale
	name = "Pale Skin"

/datum/mob_descriptor/skin/ghoulish
	name = "Ghoulish Skin"

/datum/mob_descriptor/scales
	abstract_type = /datum/mob_descriptor/scales
	slot = MOB_DESCRIPTOR_SLOT_SKIN
	verbage = "%HAVE%"

/datum/mob_descriptor/scales/plain
	name = "Plain Scales"

/datum/mob_descriptor/scales/rough
	name = "Rough Scales"

/datum/mob_descriptor/scales/smooth
	name = "Smooth Scales"

/datum/mob_descriptor/scales/plated
	name = "Plated Scales"

/datum/mob_descriptor/scales/peeling
	name = "Peeling Scales"

/datum/mob_descriptor/fur
	abstract_type = /datum/mob_descriptor/fur
	slot = MOB_DESCRIPTOR_SLOT_SKIN
	verbage = "%HAVE%"

/datum/mob_descriptor/fur/plain
	name = "Plain Fur"

/datum/mob_descriptor/fur/short
	name = "Short Fur"

/datum/mob_descriptor/fur/coarse
	name = "Coarse Fur"

/datum/mob_descriptor/fur/bristly
	name = "Bristly Fur"

/datum/mob_descriptor/fur/fluffy
	name = "Fluffy Fur"

/datum/mob_descriptor/fur/shaggy
	name = "Shaggy Fur"

/datum/mob_descriptor/fur/silky
	name = "Silky Fur"

/datum/mob_descriptor/fur/lank
	name = "Lank Fur"

/datum/mob_descriptor/fur/mangy
	name = "Mangy Fur"

/datum/mob_descriptor/fur/velvety
	name = "Velvety Fur"

/datum/mob_descriptor/fur/dense
	name = "Dense Fur"

/datum/mob_descriptor/fur/matted
	name = "Matted Fur"

/datum/mob_descriptor/feathers
	abstract_type = /datum/mob_descriptor/feathers
	slot = MOB_DESCRIPTOR_SLOT_SKIN
	verbage = "%HAVE%"

/datum/mob_descriptor/feathers/fine
	name = "Fine Feathers"

/datum/mob_descriptor/feathers/stiff
	name = "Stiff Feathers"

/datum/mob_descriptor/feathers/frayed
	name = "Frayed Feathers"

/datum/mob_descriptor/feathers/delicate
	name = "Delicate Feathers"

/datum/mob_descriptor/feathers/soft
	name = "Soft Feathers"

/datum/mob_descriptor/chitin
	abstract_type = /datum/mob_descriptor/chitin
	slot = MOB_DESCRIPTOR_SLOT_SKIN
	verbage = "%HAVE%"

/datum/mob_descriptor/chitin/smooth
	name = "Smooth Chitin"

/datum/mob_descriptor/chitin/hard
	name = "Hard Chitin"

/datum/mob_descriptor/chitin/fine
	name = "Fine Chitin"

/datum/mob_descriptor/skin/custom
	suffix = "skin"
	var/custom_index

/datum/mob_descriptor/skin/custom/can_describe(mob/living/described)
	return length(described.custom_descriptors) >= custom_index

/datum/mob_descriptor/skin/custom/get_description(mob/living/described)
	var/datum/custom_descriptor_entry/entry = described.custom_descriptors[custom_index]
	return entry.content_text

/datum/mob_descriptor/skin/custom/eight
	name = "Custom Skin"
	custom_index = 8
