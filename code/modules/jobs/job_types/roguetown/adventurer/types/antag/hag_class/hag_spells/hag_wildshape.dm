
/datum/status_effect/debuff/hag_bog_tether/wildshape
	id = "hag_bog_tether"
	tick_interval = 5 SECONDS

/datum/status_effect/debuff/hag_bog_tether/wildshape/tick()
	var/mob/living/carbon/human/species/wildshape/hag/H = owner
	if(!istype(H))
		return

	var/area/A = get_area(H)
	if(!istype(A, /area/rogue/outdoors/bog) && !istype(A, /area/rogue/indoors/shelter/bog) && !istype(A, /area/rogue/indoors/shelter/bog_hag))
		to_chat(H, span_userdanger("The purity of the air shatters my form!"))

		// Grab the human inside before we untransform
		var/mob/living/carbon/human/original = H.stored_mob
		if(original)
			// Apply the 2-minute lockout to the original human
			COOLDOWN_START(original, hag_transform_lockout, 2 MINUTES)

		H.wildshape_untransform()
		H.remove_status_effect(/datum/status_effect/debuff/hag_bog_tether/wildshape)


/mob/living/carbon/human/species/wildshape/hag
	name = "True Hag"
	race = /datum/species/hag_true_form
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/hag_skin
	wildshape_icon = 'icons/mob/unique_shapeshifts/hag_shape.dmi'
	wildshape_icon_state = "hag"
	pixel_x = -16

/obj/item/clothing/suit/roguetown/armor/skin_armor/hag_skin
	slot_flags = null
	name = "hag's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_PLATE
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 250
	item_flags = DROPDEL

/mob/living/carbon/human/species/wildshape/hag/gain_inherent_skills()
	. = ..()
	if(mind)
		STASTR = 12
		STACON = 15
		STAWIL = 15
		STAPER = 10
		STASPD = 8
		adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
		adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
		adjust_skillrank(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
		adjust_skillrank(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
		adjust_skillrank(/datum/skill/misc/sneaking, SKILL_LEVEL_EXPERT, TRUE)

		AddSpell(new /obj/effect/proc_holder/spell/self/hagclaws) 
		apply_status_effect(/datum/status_effect/debuff/hag_bog_tether/wildshape)
	//faction |= list("hag", "spiders")

/datum/species/hag_true_form
	name = "True Hag"
	id = "hag_true_form"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_ORGAN_EATER,
		TRAIT_HARDDISMEMBER,
		TRAIT_PIERCEIMMUNE,
		TRAIT_LONGSTRIDER,
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_LEECHIMMUNE,
		TRAIT_AZURENATIVE
	)
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1

/datum/species/hag_true_form/regenerate_icons(mob/living/carbon/human/human)
	human.icon = 'icons/mob/unique_shapeshifts/hag_shape.dmi'
	human.icon_state = "hag"
	human.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	human.pixel_x = -16
	return TRUE

/obj/effect/proc_holder/spell/self/wildshape/hag_true_form
	name = "True Form"
	desc = "I'm tired of these mortals invading MY bog, out with them!! I shall show them -true- terror!"
	invocation_type = "none"
	chargetime = 5 SECONDS
	recharge_time = 10 SECONDS
	action_icon_state = "hag_transform"
	miracle = FALSE
	devotion_cost = 0

	// The cooldown variable we track on the human mob
	var/static/hag_lockout_time = 2 MINUTES
	possible_shapes = list(
		/mob/living/carbon/human/species/wildshape/hag
	)

/obj/effect/proc_holder/spell/self/wildshape/hag_true_form/cast(list/targets, mob/living/carbon/human/user = usr)
	if(!COOLDOWN_FINISHED(user, hag_transform_lockout))
		to_chat(user, span_warning("My essence is too scattered to reform yet. Wait [DisplayTimeText(COOLDOWN_TIMELEFT(user, hag_transform_lockout))]."))
		revert_cast(user)
		return FALSE

	var/area/A = get_area(user)
	if(!istype(A, /area/rogue/outdoors/bog) && !istype(A, /area/rogue/indoors/shelter/bog) && !istype(A, /area/rogue/indoors/shelter/bog_hag))
		to_chat(user, span_warning("The air here is too pure. I can only reveal my true self within the Terrorbog or my Hut!"))
		revert_cast(user)
		return FALSE

	. = ..()
	return TRUE

/datum/intent/simple/hag
	name = "claw"
	clickcd = CLICK_CD_QUICK
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "cut"
	hitsound = "genslash"
	penfactor = PEN_MEDIUM
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"

/obj/item/rogueweapon/hag_claw
	name = "hag claw"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/misc32.dmi'
	max_blade_int = 600
	max_integrity = 600
	force = 25
	block_chance = 0
	wdefense = 6
	blade_dulling = DULLING_SHAFT_WOOD
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = list('sound/vo/mobs/direbear/direbear_attack1.ogg','sound/vo/mobs/direbear/direbear_attack2.ogg','sound/vo/mobs/direbear/direbear_attack3.ogg')
	possible_item_intents = list(/datum/intent/simple/hag)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/hag_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/hag_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/hag_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/obj/effect/proc_holder/spell/self/hagclaws
	name = "Hag Claws"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 2 SECONDS
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/hagclaws/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/hag_claw/left/left = user.get_active_held_item()
	var/obj/item/rogueweapon/hag_claw/right/right = user.get_inactive_held_item()

	if(extended)
		if(istype(left, /obj/item/rogueweapon/hag_claw))
			user.dropItemToGround(left, TRUE)
			qdel(left)

		if(istype(right, /obj/item/rogueweapon/hag_claw))
			user.dropItemToGround(right, TRUE)
			qdel(right)

		extended = FALSE
		return

	left = new(user, 1)
	right = new(user, 2)
	user.put_in_hands(left, TRUE, FALSE, TRUE)
	user.put_in_hands(right, TRUE, FALSE, TRUE)
	extended = TRUE
