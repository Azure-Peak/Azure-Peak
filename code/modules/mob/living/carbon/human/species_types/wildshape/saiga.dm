/mob/living/carbon/human/species/wildshape/saiga //The transport option for shapeshifters
	name = "Saiga"
	race = /datum/species/shapesaiga
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/saiga_skin
	wildshape_icon = 'icons/roguetown/mob/monster/saiga.dmi'
	wildshape_icon_state = "saiga"

//BUCKLING
/mob/living/carbon/human/species/wildshape/saiga/buckle_mob(mob/living/target, force = TRUE, check_loc = TRUE, lying_buckle = FALSE, hands_needed = 0, target_hands_needed = 0)
	. = ..(target, force, check_loc, lying_buckle, hands_needed, target_hands_needed)

/mob/living/carbon/human/species/wildshape/saiga/gain_inherent_skills()
	. = ..()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)

		src.STASTR = 10
		src.STACON = 13
		src.STAWIL = 18 //Because I don't want to give it TRAIT_INFINITE_STAMINA
		src.STASPD = 13

		AddSpell(new /obj/effect/proc_holder/spell/self/saigahoofs)
		real_name = "saiga doe" //So we don't get a random name

// SAIGA SPECIES DATUM //
/datum/species/shapesaiga
	name = "saiga"
	id = "shapesaiga"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY, //All of these are dendorite transformations, they are ALL blessed by dendor
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER, //Decapping wildshapes causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects when killed/stepping on shards.
		TRAIT_LONGSTRIDER,
		TRAIT_INFINITE_ENERGY, //Saiga's gonna run a marathon
		TRAIT_PUSHIMMUNE,
		TRAIT_MOUNTABLE
	)
	inherent_biotypes = MOB_HUMANOID
	armor = 5
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		)

	languages = list(
		/datum/language/beast,
		/datum/language/common,
	)

/datum/species/shapesaiga/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/saiga/idle (1).ogg','sound/vo/mobs/saiga/idle (2).ogg','sound/vo/mobs/saiga/idle (3).ogg','sound/vo/mobs/saiga/idle (4).ogg','sound/vo/mobs/saiga/idle (5).ogg','sound/vo/mobs/saiga/idle (6).ogg','sound/vo/mobs/saiga/idle (7).ogg'), 100, TRUE, -1)

/datum/species/shapesaiga/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/roguetown/mob/monster/saiga.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "saiga"
	H.update_damage_overlays()
	return TRUE

/datum/species/shapesaiga/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/shapesaiga/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

// SAIGA SPECIFIC ITEMS //
/obj/item/clothing/suit/roguetown/armor/skin_armor/saiga_skin
	slot_flags = null
	name = "saiga's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_LEATHER //Saiga should be tankier
	prevent_crits = PREVENT_CRITS_NONE
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 150 //Same as leather
	item_flags = DROPDEL

/datum/intent/simple/saiga //Like a less defense dagger
	name = "hoof"
	icon_state = "instrike"
	blade_class = BCLASS_BLUNT
	attack_verb = list("hits", "mauls", "bashes")
	animname = "strike"
	hitsound = "punch_hard"
	penfactor = BLUNT_DEFAULT_PENFACTOR
	candodge = TRUE
	canparry = TRUE
	miss_text = "kicks the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "blunt"
	swingdelay = 8
	clickcd = 10
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR // I'm evil

/obj/item/rogueweapon/saiga_hoof //Like a mace
	name = "saiga hoof"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/misc32.dmi'
	max_blade_int = 600
	max_integrity = 600
	force = 20
	block_chance = 0
	wdefense = 2
	blade_dulling = DULLING_SHAFT_WOOD
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE //I just think this is cool as fuck, sue me
	sharpness = IS_BLUNT
	demolition_mod = 1.5
	swingsound = list('sound/vo/mobs/saiga/attack (1).ogg','sound/vo/mobs/saiga/attack (2).ogg')
	possible_item_intents = list(/datum/intent/simple/saiga)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/saiga_hoof/right //Placeholders
	icon_state = "claw_r"

/obj/item/rogueweapon/saiga_hoof/left
	icon_state = "claw_l"

/obj/item/rogueweapon/saiga_hoof/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

// SAIGA SPELLS //
/obj/effect/proc_holder/spell/self/saigahoofs
	name = "Saiga Hoofs"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 20 //2 seconds
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/saigahoofs/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/saiga_hoof/left/l
	var/obj/item/rogueweapon/saiga_hoof/right/r

	l = user.get_active_held_item()
	r = user.get_inactive_held_item()
	if(extended)
		if(istype(l, /obj/item/rogueweapon/saiga_hoof))
			user.dropItemToGround(l, TRUE)
			qdel(l)
		if(istype(r, /obj/item/rogueweapon/saiga_hoof))
			user.dropItemToGround(r, TRUE)
			qdel(r)
		//user.visible_message("Your claws retract.", "You feel your claws retracting.", "You hear a sound of claws retracting.")
		extended = FALSE
	else
		l = new(user,1)
		r = new(user,2)
		user.put_in_hands(l, TRUE, FALSE, TRUE)
		user.put_in_hands(r, TRUE, FALSE, TRUE)
		//user.visible_message("Your claws extend.", "You feel your claws extending.", "You hear a sound of claws extending.")
		extended = TRUE
