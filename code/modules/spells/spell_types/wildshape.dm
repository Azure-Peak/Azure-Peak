/obj/effect/proc_holder/spell/self/wildshape
	name = "Beast Form"
	desc = "Take on the form of one of Dendor's sacred beasts."
	overlay_state = "tamebeast"
	clothes_req = FALSE
	human_req = FALSE
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	cooldown_min = 50
	invocations = list("Treefather grant me your form!")
	invocation_type = "shout"
	action_icon_state = "shapeshift"
	associated_skill = /datum/skill/magic/holy
	devotion_cost = 80
	miracle = TRUE

	var/list/possible_shapes = list(
		/mob/living/carbon/human/species/wildshape/volf,
		/mob/living/carbon/human/species/wildshape/fox,
		/mob/living/carbon/human/species/wildshape/cat,
		/mob/living/carbon/human/species/wildshape/bear,
		/mob/living/carbon/human/species/wildshape/cabbit,
		/mob/living/carbon/human/species/wildshape/saiga,
		/mob/living/carbon/human/species/wildshape/spider
	)

/obj/effect/proc_holder/spell/self/wildshape/cast(list/targets, mob/living/carbon/human/user = usr)
	. = ..()

	if(user.has_status_effect(/datum/status_effect/debuff/submissive))
		to_chat(user, span_warning("Your will is too broken to change form."))
		return FALSE

	if(istype(user, /mob/living/carbon/human/species/wildshape))
		user.wildshape_untransform()
		return FALSE

	var/list/choices = list()

	for(var/mob/living/carbon/human/species/wildshape/shape as anything in possible_shapes)
		var/icon/icon = icon(shape.wildshape_icon, shape.wildshape_icon_state)

		var/size_x = icon.Width()
		var/size_y = icon.Height()

		var/image/icon_img = image(icon)

		icon_img.pixel_x = -(size_x / 2) + 16
		icon_img.pixel_y = -(size_y / 2) + 16
		
		choices[shape.name] = icon_img

	var/new_wildshape_type = show_radial_menu(user, user, choices)

	if(!new_wildshape_type)
		revert_cast()
		return FALSE

	user.Stun(30)
	user.Knockdown(30)
	INVOKE_ASYNC(user, TYPE_PROC_REF(/mob/living/carbon/human, wildshape_transformation), GLOB.wildshapes[new_wildshape_type])

	return TRUE

// Mob itself
/mob/living/carbon/human/species/wildshape
	var/datum/language_holder/stored_language
	var/list/stored_skills
	var/list/stored_experience
	var/list/stored_spells

	var/wildshape_icon
	var/wildshape_icon_state

/mob/living/carbon/human/species/wildshape/proc/gain_inherent_skills()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/magic/holy, 3, TRUE) //Any dendorite using this should be a holy magic user

		var/datum/devotion/C = new /datum/devotion(src, src.patron) //If we don't do this, Dendorites can't be clerics and they can't revert back to their true forms
		C.grant_miracles(src, cleric_tier = CLERIC_T2, passive_gain = CLERIC_REGEN_MAJOR)	//Major regen as no matter the previous level, it gets reset on transform. More connection to dendor I guess? Can level up to T4.

/mob/living/carbon/human/species/wildshape/update_inv_gloves() //Prevents weird blood overlays
	remove_overlay(GLOVES_LAYER)
	remove_overlay(GLOVESLEEVE_LAYER)

/mob/living/carbon/human/species/wildshape/update_inv_shoes() //Prevents weird blood overlays
	remove_overlay(SHOES_LAYER)
