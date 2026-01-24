/datum/bodypart_feature/piercing
	name = "Piercing"
	feature_slot = BODYPART_FEATURE_PIERCINGS
	body_zone = BODY_ZONE_CHEST
	var/obj/item/piercings/piercings_item

/datum/bodypart_feature/piercing/set_accessory_type(new_accessory_type, colors, mob/living/carbon/owner)
	accessory_type = new_accessory_type
	var/datum/sprite_accessory/piercing/accessory = SPRITE_ACCESSORY(accessory_type)
	piercings_item = new accessory.piercing_type(owner)
	if(owner.piercings_item)
		qdel(owner.piercings_item)
	owner.piercings_item = piercings_item
	piercings_item.piercings_feature = src
