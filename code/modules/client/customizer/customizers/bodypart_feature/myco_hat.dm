/datum/customizer/bodypart_feature/hair/head/myco_hat
	name = "Hat"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/hair/head/myco_hat)

/datum/customizer_choice/bodypart_feature/hair/head/myco_hat
	name = "Hat"
	sprite_accessories = list(
		/datum/sprite_accessory/hair/head/myco_hat/wide,
		/datum/sprite_accessory/hair/head/myco_hat/plain,
		/datum/sprite_accessory/hair/head/myco_hat/honey,
		/datum/sprite_accessory/hair/head/myco_hat/fancy,
		/datum/sprite_accessory/hair/head/myco_hat/chanterelle,
		/datum/sprite_accessory/hair/head/myco_hat/morel,
		/datum/sprite_accessory/hair/head/myco_hat/tall,
		/datum/sprite_accessory/hair/head/myco_hat/heretical,
		)

/datum/customizer_choice/bodypart_feature/hair/head/myco_hat/get_random_accessory(datum/customizer_entry/entry, datum/preferences/prefs)
	return pick(sprite_accessories)
