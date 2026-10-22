// Face hollows offered as a Snout section; paint themselves with the Heartwood
// colour unless the player colours them.

/datum/sprite_accessory/snout/ent_veil
	abstract_type = /datum/sprite_accessory/snout/ent_veil
	icon = 'icons/mob/species/ents_male.dmi'
	icon_f = 'icons/mob/species/ents_female.dmi'
	// The sheet carries the finished state, so this draws it as-is instead of asking for
	// per-layer "_ADJ" copies the way the snout sheet does.
	relevant_layers = null
	// Above the limb, the ent growths (BODY_ADJ_LAYER - 0.1) and the body-feature organs, below
	// hair and the other BODY_LAYER features.
	layer = BODY_ADJ_LAYER - 0.2
	color_key_name = "Growth"
	color_key_defaults = list(KEY_SKIN_COLOR)
	gendered_variants = FALSE

/datum/sprite_accessory/snout/ent_veil/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	// While the *veil emote has the veil pulled aside, nothing is drawn.
	if(istype(organ, /obj/item/organ/snout/ent))
		var/obj/item/organ/snout/ent/veil_organ = organ
		if(!veil_organ.veil_worn)
			return FALSE
	return ..()

/datum/sprite_accessory/snout/ent_veil/hollow/birch
	name = "Birch Hollow"
	icon_state = "birch_hollow_head"

/datum/sprite_accessory/snout/ent_veil/hollow/oak
	name = "Oak Hollow"
	icon_state = "oak_hollow_head"

/datum/sprite_accessory/snout/ent_veil/hollow/swamp
	name = "Swamp Hollow"
	icon_state = "swamp_hollow_head"

/datum/sprite_accessory/snout/ent_veil/shrike
	name = "Shrike"
	icon_state = "shrike_ent_head"
	// The shrike is painted, not bark: a white default leaves the bird its own
	// colours (it was the one growth that did not paint with the Heartwood).
	default_colors = list("#FFFFFF")
