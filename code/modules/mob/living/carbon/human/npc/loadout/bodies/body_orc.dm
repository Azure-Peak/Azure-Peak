/datum/npc_body/orc
	species = /datum/species/orc
	randomise_character = FALSE
	random_hair = FALSE
	random_eyes = FALSE
	male_name_file = "strings/rt/names/other/halforcm.txt"
	female_name_file = "strings/rt/names/other/halforcf.txt"
	var/skin_color = "50715C"
	var/eye_color = "#FF0000"
	var/hair_color = "#31302E"
	var/list/male_hairstyles = list(
		/datum/sprite_accessory/hair/head/ponytailwitcher,
		/datum/sprite_accessory/hair/head/lowbraid,
	)
	var/list/female_hairstyles = list(
		/datum/sprite_accessory/hair/head/lowbraid,
		/datum/sprite_accessory/hair/head/countryponytailalt,
	)
	var/list/facial_hairstyles = list(
		/datum/sprite_accessory/hair/facial/viking,
		/datum/sprite_accessory/hair/facial/manly,
		/datum/sprite_accessory/hair/facial/longbeard,
	)

/datum/npc_body/orc/get_head_sellprice()
	return HEAD_BOUNTY_ORC

/datum/npc_body/orc/apply_appearance(mob/living/carbon/human/H)
	if(!H)
		return
	H.skin_tone = skin_color
	var/obj/item/organ/eyes/organ_eyes = H.getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = eye_color
		organ_eyes.accessory_colors = "[eye_color][eye_color]"
	var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
	if(head)
		var/datum/bodypart_feature/hair/head/new_hair = new()
		var/datum/bodypart_feature/hair/facial/new_facial = new()
		if(H.gender == FEMALE)
			new_hair.set_accessory_type(pick(female_hairstyles), null, H)
		else
			new_hair.set_accessory_type(pick(male_hairstyles), null, H)
			new_facial.set_accessory_type(pick(facial_hairstyles), null, H)
		head.add_bodypart_feature(new_hair)
		head.add_bodypart_feature(new_facial)
		new_hair.accessory_colors = hair_color
		new_hair.hair_color = hair_color
		new_facial.accessory_colors = hair_color
		new_facial.hair_color = hair_color
	H.hair_color = hair_color
	H.dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	return ..()
