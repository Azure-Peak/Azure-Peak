/mob/living/carbon/human/species/wildshape/cat //The sneaker of the wildshapes
	name = "Cat"
	race = /datum/species/shapecat
	footstep_type = FOOTSTEP_MOB_CLAW
	ambushable = FALSE
	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/cat_skin
	wildshape_icon = 'icons/mob/pets.dmi'
	wildshape_icon_state = "cat2"

/mob/living/carbon/human/species/wildshape/cat/gain_inherent_skills()
	. = ..()
	if(src.mind)
		src.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
		src.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/sneaking, 5, TRUE) //Who's a sneaky fellow?
		src.adjust_skillrank(/datum/skill/misc/climbing, 5, TRUE) //May as well be magical
		src.adjust_skillrank(/datum/skill/misc/stealing, 3, TRUE)
		src.adjust_skillrank(/datum/skill/misc/tracking, 1, TRUE)

		src.STASTR = 2
		src.STACON = 2
		src.STAWIL = 7
		src.STAPER = 14
		src.STASPD = 18 //May be overtuned with dodge expert, but this thing is so fragile
		src.STALUC = 12 //Xylyx's critters

		AddSpell(new /obj/effect/proc_holder/spell/self/catclaws)
		AddSpell(new /obj/effect/proc_holder/spell/targeted/woundlick)
		real_name = "cat" //Stealthy transform, lets give it a try

// CAT SPECIES DATUM //
/datum/species/shapecat
	name = "cat"
	id = "shapecat"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_KNEESTINGER_IMMUNITY, //All of these are dendorite transformations, they are ALL blessed by dendor
		TRAIT_NOFALLDAMAGE2, //Cats, what else can I say?
		TRAIT_WILD_EATER,
		TRAIT_HARDDISMEMBER, //Decapping wildshapes causes them to bug out, badly, and need admin intervention to fix. Bandaid fix.
		TRAIT_DODGEEXPERT,
		TRAIT_BRITTLE,
		TRAIT_LEAPER,
		TRAIT_ZJUMP, //its a CAT. Cats can jump so high!
		TRAIT_WOODWALKER
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

/datum/species/shapecat/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/mob/pets.dmi'
	H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon_state = "cat2"
	H.update_damage_overlays()
	return TRUE

/datum/species/shapecat/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/species/shapecat/update_damage_overlays(mob/living/carbon/human/H)
	H.remove_overlay(DAMAGE_LAYER)
	return TRUE

// CAT SPECIFIC ITEMS //
/obj/item/clothing/suit/roguetown/armor/skin_armor/cat_skin
	slot_flags = null
	name = "cat's skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_LEATHER
	blocksound = SOFTHIT
	sewrepair = FALSE
	max_integrity = 1 //You get a single 'lucky' hit as a cat
	item_flags = DROPDEL

/datum/intent/simple/cat //Like a less defense dagger
	name = "claw"
	clickcd = 8
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("claws", "cuts", "scratches")
	animname = "cut"
	hitsound = "genslash"
	penfactor = 10
	candodge = TRUE
	canparry = TRUE
	miss_text = "slashes the air!"
	miss_sound = "bluntswoosh"
	item_d_type = "slash"

/obj/item/rogueweapon/cat_claw //Backscratcher
	name = "cat claw"
	desc = ""
	item_state = null
	lefthand_file = null
	righthand_file = null
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	max_blade_int = 200
	max_integrity = 200
	force = 8 //Pitiful, literally less than a wooden stick or a thrown toy
	block_chance = 0
	wdefense = 1
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_SHORT
	wbalance = WBALANCE_SWIFT
	w_class = WEIGHT_CLASS_NORMAL
	can_parry = TRUE //I just think this is cool as fuck, sue me
	sharpness = IS_SHARP
	parrysound = "bladedmedium"
	swingsound = BLADEWOOSH_MED
	possible_item_intents = list(/datum/intent/simple/cat)
	parrysound = list('sound/combat/parry/parrygen.ogg')
	embedding = list("embedded_pain_multiplier" = 0, "embed_chance" = 0, "embedded_fall_chance" = 0)
	item_flags = DROPDEL
	experimental_inhand = FALSE

/obj/item/rogueweapon/cat_claw/right
	icon_state = "claw_r"

/obj/item/rogueweapon/cat_claw/left
	icon_state = "claw_l"

/obj/item/rogueweapon/cat_claw/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

// CAT SPELLS //
/obj/effect/proc_holder/spell/self/catclaws
	name = "Feline Claws"
	desc = "!"
	overlay_state = "claws"
	antimagic_allowed = TRUE
	recharge_time = 20 //2 seconds
	ignore_cockblock = TRUE
	var/extended = FALSE

/obj/effect/proc_holder/spell/self/catclaws/cast(mob/user = usr)
	..()
	var/obj/item/rogueweapon/cat_claw/left/l
	var/obj/item/rogueweapon/cat_claw/right/r

	l = user.get_active_held_item()
	r = user.get_inactive_held_item()
	if(extended)
		if(istype(l, /obj/item/rogueweapon/cat_claw))
			user.dropItemToGround(l, TRUE)
			qdel(l)
		if(istype(r, /obj/item/rogueweapon/cat_claw))
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

/obj/effect/proc_holder/spell/targeted/woundlick
    action_icon = 'icons/mob/actions/roguespells.dmi'
    name = "Lick the wounds"
    desc = "Heal the wounds of somebody"
    overlay_state = "diagnose"
    range = 1
    sound = 'sound/gore/flesh_eat_03.ogg'
    associated_skill = /datum/skill/misc/climbing
    recharge_time = 10 SECONDS
    ignore_cockblock = TRUE

/obj/effect/proc_holder/spell/targeted/woundlick/cast(list/targets, mob/user)
    if(iscarbon(targets[1]))
        var/mob/living/carbon/target = targets[1]
        if(target.mind)
            if(target.mind.has_antag_datum(/datum/antagonist/zombie))
                to_chat(src, span_warning("I shall not lick it..."))
                return
            if(target.mind.has_antag_datum(/datum/antagonist/vampire))
                to_chat(src, span_warning("... What? Its an elder vampire!"))
                return
        (!do_after(user, 7 SECONDS, target = target))
        var/ramount = 20
        var/rid = /datum/reagent/medicine/healthpot
        target.reagents.add_reagent(rid, ramount)
        ramount = 2
        if(target.mind.has_antag_datum(/datum/antagonist/werewolf))
            target.visible_message(span_green("[user] is licking [target]'s wounds with its tongue!"), span_notice("My kin has covered my wounds..."))
            ramount = 20
            rid = /datum/reagent/water
            target.reagents.add_reagent(rid, ramount)
        else
            target.visible_message(span_green("[user] is licking [target]'s wounds with its tongue!"), span_notice("That thing... Did it lick my wounds?"))
            ramount = 20
            rid = /datum/reagent/water
            target.reagents.add_reagent(rid, ramount)
