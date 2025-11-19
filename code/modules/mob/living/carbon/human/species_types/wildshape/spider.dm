/mob/living/carbon/human/species/wildshape/spider //The bog glass cannon
	name = "Spider"
	race = /datum/species/shapespider
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/spider_chitin
	wildshape_icon = 'icons/roguetown/mob/monster/spider.dmi'
	wildshape_icon_state = "honeys"

/mob/living/carbon/human/species/wildshape/spider/gain_inherent_skills()
	. = ..()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE) //For the bog mainly
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE)

		src.STASTR = 12
		src.STACON = 6
		src.STAWIL = 7
		src.STAPER = 12
		src.STASPD = 14

		AddSpell(new /obj/effect/proc_holder/spell/self/spiderfangs)
		AddSpell(new /obj/effect/proc_holder/spell/self/createhoney)
		AddSpell(new /obj/effect/proc_holder/spell/self/weaveweb)
		real_name = "beespider"
		faction += "spiders" // It IS a spider

// CAT SPECIES DATUM //
/datum/species/shapespider
	name = "spider"
	id = "shapespider"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY, //All of these are dendorite transformations, they are ALL blessed by dendor
		TRAIT_STRONGBITE,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER, //Decapping wildshapes causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_LEAPER,
		TRAIT_WEBWALK, //This IS a spider
		TRAIT_BREADY, //Ambusher
		TRAIT_ORGAN_EATER,
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects when killed/stepping on shards, also 8 legs.
		TRAIT_DODGEEXPERT,
		TRAIT_LONGSTRIDER
	)
	inherent_biotypes = MOB_HUMANOID
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

/datum/species/shapespider/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/spider/speak (1).ogg','sound/vo/mobs/spider/speak (2).ogg','sound/vo/mobs/spider/speak (3).ogg','sound/vo/mobs/spider/speak (4).ogg'), 80, TRUE, -1)

/datum/species/shapespider/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/roguetown/mob/monster/spider.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "honeys"
	H.update_damage_overlays()
	return TRUE

/datum/species/shapespider/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/shapespider/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

// CAT SPECIFIC ITEMS //
/obj/item/clothing/suit/roguetown/armor/skin_armor/spider_chitin
	slot_flags = null
	name = "spider's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_LEATHER
	blocksound = SOFTHIT
	sewrepair = FALSE
	max_integrity = 80 //Less than a volf's
	item_flags = DROPDEL

/datum/intent/simple/spider //An ambush weapon
	name = "fang"
	clickcd = 12
	icon_state = "instab"
	blade_class = BCLASS_STAB
	attack_verb = list("bites", "pierces", "impales")
	animname = "stab"
	hitsound = "genslash"
	penfactor = 20
	candodge = TRUE
	canparry = TRUE
	miss_text = "bites the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "stab"

/obj/item/rogueweapon/spider_fang
	name = "spider fang"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	max_blade_int = 400
	max_integrity = 400
	force = 25 //More than the volf, more fragile, hits slower
	block_chance = 0
	wdefense = 1
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_NORMAL
	wbalance = WBALANCE_SWIFT
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = FALSE //Can't really parry with your face
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = list('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg')
	possible_item_intents = list(/datum/intent/simple/spider)
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/spider_fang/right
	icon_state = "claw_r"

/obj/item/rogueweapon/spider_fang/left
	icon_state = "claw_l"

/obj/item/rogueweapon/spider_fang/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

// SPIDER SPELLS //
/obj/effect/proc_holder/spell/self/spiderfangs
	name = "Spider Fangs"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 20 //2 seconds
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/spiderfangs/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/spider_fang/left/l
	var/obj/item/rogueweapon/spider_fang/right/r

	l = user.get_active_held_item()
	r = user.get_inactive_held_item()
	if(extended)
		if(istype(l, /obj/item/rogueweapon/spider_fang))
			user.dropItemToGround(l, TRUE)
			qdel(l)
		if(istype(r, /obj/item/rogueweapon/spider_fang))
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

/obj/effect/proc_holder/spell/self/createhoney
	name = "Create Honey"
	desc = "!"
	antimagic_allowed = TRUE
	recharge_time = 2 MINUTES //Don't spam this you chef lovers, let us have nice things
	ignore_cockblock = TRUE

/obj/effect/proc_holder/spell/self/createhoney/cast(mob/user = usr)
	visible_message(span_alertalien("[user] creates some honey."))
	var/turf/T = get_turf(user)
	playsound(T, pick('sound/vo/mobs/spider/speak (1).ogg','sound/vo/mobs/spider/speak (2).ogg','sound/vo/mobs/spider/speak (3).ogg','sound/vo/mobs/spider/speak (4).ogg'), 100, TRUE, -1)
	new /obj/item/reagent_containers/food/snacks/rogue/honey/spider(T)

/obj/effect/proc_holder/spell/self/weaveweb
	name = "Weave Web"
	desc = "!"
	antimagic_allowed = TRUE
	recharge_time = 20 SECONDS //Not too fast, not too slow
	ignore_cockblock = TRUE

/obj/effect/proc_holder/spell/self/weaveweb/cast(mob/user = usr)
	visible_message(span_alertalien("[user] weaves a spider web."))
	var/turf/T = get_turf(user)
	playsound(T, pick('sound/vo/mobs/spider/speak (1).ogg','sound/vo/mobs/spider/speak (2).ogg','sound/vo/mobs/spider/speak (3).ogg','sound/vo/mobs/spider/speak (4).ogg'), 100, TRUE, -1)
	new /obj/structure/spider/stickyweb(T)
