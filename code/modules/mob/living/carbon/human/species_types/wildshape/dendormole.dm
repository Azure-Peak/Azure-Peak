/mob/living/carbon/human/species/wildshape/dendormole //The baseline and tracker of the wildshapes
	name = "Moss Crawler"
	race = /datum/species/dendormole
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/moss_skin

/mob/living/carbon/human/species/wildshape/dendormole/death(gibbed, nocutscene = FALSE)
	wildshape_untransform(TRUE, gibbed)

//BUCKLING
/mob/living/carbon/human/species/wildshape/dendormole/buckle_mob(mob/living/target, force = TRUE, check_loc = TRUE, lying_buckle = FALSE, hands_needed = 0, target_hands_needed = 0)
	. = ..(target, force, check_loc, lying_buckle, hands_needed, target_hands_needed)

/mob/living/carbon/human/species/wildshape/dendormole/gain_inherent_skills()
	. = ..()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE) //We don't want this thing wrestling people.
		src.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/tracking, 5, TRUE) //'Tracker' transformation
		src.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE) //Stalking
//Give it miracles maybe as well if needed, but this boi is already good
		src.STASTR = 13
		src.STACON = 15
		src.STAWIL = 15
		src.STAPER = 9 //Moles are blind, why did this get good perception?
		src.STASPD = 13

		AddSpell(new /obj/effect/proc_holder/spell/self/moleclaw)
		real_name = "moss crawler"


// dendormole SPECIES DATUM //
/datum/species/dendormole
	name = "Moss Crawler"
	id = "dendormole"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY, //All of these are dendorite transformations, they are ALL blessed by dendor
		TRAIT_STRONGBITE,
		TRAIT_STEELHEARTED,
		TRAIT_BREADY, //Ambusher
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER, //Decapping causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects due to them transforming when killed/stepping on shards.
		TRAIT_LONGSTRIDER,
		TRAIT_PERFECT_TRACKER,
		TRAIT_NOPAINSTUN, //This bad boy ENDVRES
		TRAIT_BIGGUY,
	)
	inherent_biotypes = MOB_HUMANOID
	armor = 15
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision,
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

/datum/species/dendormole/send_voice(mob/living/carbon/human/H)
	playsound(H, pick('sound/vo/mobs/vw/idle (1).ogg','sound/vo/mobs/vw/idle (2).ogg','sound/vo/mobs/vw/bark (1).ogg','sound/vo/mobs/vw/bark (2).ogg','sound/vo/mobs/vw/idle (3).ogg'), 80, TRUE, -1)

/datum/species/dendormole/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/roguetown/mob/monster/mosscrawler.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "mole_briars"
	H.update_damage_overlays()
	return TRUE

/datum/species/dendormole/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/dendormole/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

// MOLE SPECIFIC ITEMS //
/obj/item/clothing/suit/roguetown/armor/skin_armor/moss_skin
	slot_flags = null
	name = "aged moss shell"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_LEATHER 
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PIERCE)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 400 
	item_flags = DROPDEL

/datum/intent/simple/mole 
	name = "MAUL"
	clickcd = 10
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("claws", "mauls", "eviscerates")
	animname = "cut"
	hitsound = "genslash"
	penfactor = 15
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"

/datum/intent/simple/mole/dig
	name = "DIG"
	clickcd = 14
	damfactor = 1.2
	swingdelay = 6
	icon_state = "insmash"
	blade_class = BCLASS_SMASH
	attack_verb = list("digs", "excavates", "perforates")
	animname = "cut"
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	candodge = TRUE
	canparry = TRUE
	miss_text = "smashes the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "blunt"

/obj/item/rogueweapon/mole_claw //Like a less defense dagger
	name = "mole claw"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/misc32.dmi'
	max_blade_int = 300
	max_integrity = 300
	force = 25
	demolition_mod = 2.5 //I'M A MOLE AND I'M DIGGING A HOLE
	block_chance = 0
	wdefense = 4 //Very long, decent defense (for wildshape).
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE 
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	possible_item_intents = list(/datum/intent/simple/mole, /datum/intent/simple/mole/dig, /datum/intent/pick)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/mole_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/mole_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/mole_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/obj/effect/proc_holder/spell/self/moleclaw
	name = "Burrow Claws"
	desc = "Extend your digging claws."
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 40
	ignore_cockblock = TRUE	
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/moleclaw/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/mole_claw/left/l
	var/obj/item/rogueweapon/mole_claw/right/r

	l = user.get_active_held_item()
	r = user.get_inactive_held_item()
	if(extended)
		if(istype(l, /obj/item/rogueweapon/mole_claw))
			user.dropItemToGround(l, TRUE)
			qdel(l)
		if(istype(r, /obj/item/rogueweapon/mole_claw))
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
