/mob/living/carbon/human/species/wildshape/mirecrawler //The baseline and tracker of the wildshapes
	name = "Moss Crawler"
	race = /datum/species/mirecrawler
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/spider_skin

/mob/living/carbon/human/species/wildshape/mirecrawler/death(gibbed, nocutscene = FALSE)
	wildshape_untransform(TRUE, gibbed)

/mob/living/carbon/human/species/wildshape/mirecrawler/gain_inherent_skills()
	. = ..()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
		src.adjust_skillrank(/datum/skill/misc/tracking, 4, TRUE) //'Tracker' transformation
		src.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE)
		src.adjust_skillrank(/datum/skill/misc/climbing, 6, TRUE) //I am in your walls
//Give it miracles maybe as well if needed, but this boi is already good
		src.STASTR = 7
		src.STACON = 8
		src.STAINT = 9 //Tiny spider brain.
		src.STAPER = 15
		src.STASPD = 15
		update_move_intent_slowdown() // Apply speed changes

		AddSpell(new /obj/effect/proc_holder/spell/self/spiderfangs/mire)
		real_name = "lesser mire crawler"


// mirecrawler SPECIES DATUM //
/datum/species/mirecrawler
	name = "Lesser Mire Crawler"
	id = "dendormirecrawler"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY, //All of these are dendorite transformations, they are ALL blessed by dendor
		TRAIT_STRONGBITE,
		TRAIT_BREADY, //Ambusher
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER, //Decapping causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_PIERCEIMMUNE, //Prevents weapon dusting and caltrop effects due to them transforming when killed/stepping on shards.
		TRAIT_LONGSTRIDER,
		TRAIT_INFINITE_ENERGY, //It's a 7 strength spiderling, what's the worst that could happen?
		TRAIT_PERFECT_TRACKER,
		TRAIT_NIGHT_VISION,
	)
	inherent_biotypes = MOB_HUMANOID
	armor = 5
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

/datum/species/mirecrawler/send_voice(mob/living/carbon/human/H)
	playsound(H, pick('sound/vo/mobs/spider/attack (1).ogg','sound/vo/mobs/spider/attack (2).ogg','sound/vo/mobs/spider/attack (3).ogg','sound/vo/mobs/spider/attack (4).ogg'), 80, TRUE, -1)

/datum/species/mirecrawler/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/mob/mirespider_small.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "crawler"
	H.update_damage_overlays()
	return TRUE

/datum/species/mirecrawler/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/mirecrawler/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

// WOLF SPECIFIC ITEMS //
/obj/item/clothing/suit/roguetown/armor/skin_armor/spider_skin
	slot_flags = null
	name = "pitiful carapace"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_LEATHER 
	prevent_crits = list(BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PIERCE)
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 80 
	item_flags = DROPDEL

/obj/item/rogueweapon/spider_fang/mire //Like a less defense dagger
	max_blade_int = 300
	max_integrity = 300
	force = 30 //This form has 7 strength by default so this is more like 15 damage.
	swingsound = list('sound/vo/mobs/vw/attack (1).ogg','sound/vo/mobs/vw/attack (2).ogg','sound/vo/mobs/vw/attack (3).ogg','sound/vo/mobs/vw/attack (4).ogg')
	possible_item_intents = list(/datum/intent/simple/spider/mire, /datum/intent/pick)

/obj/item/rogueweapon/spider_fang/mire/right
	icon_state = "claw_r"

/obj/item/rogueweapon/spider_fang/mire/left
	icon_state = "claw_l"

/obj/item/rogueweapon/spider_fang/mire/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/obj/effect/proc_holder/spell/self/spiderfangs/mire
	name = "Spider Fangs"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 40 //4 seconds
	ignore_cockblock = TRUE	
	var/extendid = FALSE

/obj/effect/proc_holder/spell/self/spiderfangs/mire/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/spider_fang/mire/left/l
	var/obj/item/rogueweapon/spider_fang/mire/right/r

	l = user.get_active_held_item()
	r = user.get_inactive_held_item()
	if(extendid)
		if(istype(l, /obj/item/rogueweapon/spider_fang/mire))
			user.dropItemToGround(l, TRUE)
			qdel(l)
		if(istype(r, /obj/item/rogueweapon/spider_fang/mire))
			user.dropItemToGround(r, TRUE)
			qdel(r)
		//user.visible_message("Your fangs retract.", "You feel your fangs retracting.", "You hear a sound of fangs retracting.")
		extendid = FALSE
	else
		l = new(user,1)
		r = new(user,2)
		user.put_in_hands(l, TRUE, FALSE, TRUE)
		user.put_in_hands(r, TRUE, FALSE, TRUE)
		//user.visible_message("Your fangs extend.", "You feel your fangs extending.", "You hear a sound of fangs extending.")
		extendid = TRUE

/datum/intent/simple/spider/mire
	name = "monch"
	clickcd = 6 //Very fast.
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("bites, chomps")
	animname = "cut"
	hitsound = "genslash"
	penfactor = 5
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air with its fangs!"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"
