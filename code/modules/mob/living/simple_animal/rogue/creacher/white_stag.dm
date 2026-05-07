/datum/species/white_stag
	name = "White Stag"
	id = "white_stag"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_HARDDISMEMBER,
		TRAIT_LONGSTRIDER,
		TRAIT_LEECHIMMUNE,
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOPAINSTUN,
		TRAIT_AZURENATIVE,
		TRAIT_NOPAIN,
		TRAIT_BLOODLOSS_IMMUNE,
		TRAIT_STRENGTH_UNCAPPED,
		TRAIT_KNEESTINGER_IMMUNITY,
		TRAIT_NOBREATH,
		TRAIT_DEATHLESS,
		TRAIT_BLOOD_RESISTANCE,
		// We do not need people farming this for master skills
		TRAIT_BADTRAINER,
	)
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_ARMOR, SLOT_WEAR_MASK, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT)
	nojumpsuit = TRUE
	sexes = 1
	soundpack_m = /datum/voicepack/white_stag
	soundpack_f = /datum/voicepack/white_stag

/datum/species/white_stag/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/mob/unique_shapeshifts/white_stag_shape.dmi'
	H.icon_state = "stag"
	H.pixel_x = -24
	return TRUE

/mob/living/carbon/human/species/wildshape/white_stag
	name = "The White Stag"
	race = /datum/species/white_stag
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	dodgetime = 10
	pixel_x = -16
	// We are not a normal wildshape.
	untransform_on_death = FALSE
	faction = list("White Stag")

/mob/living/carbon/human/species/wildshape/white_stag/gain_inherent_skills()
	return FALSE

/mob/living/carbon/human/species/wildshape/white_stag/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/wildshape/white_stag/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	// Legendary Stats
	STASTR = 16
	STASPD = 18
	STACON = 20
	STAPER = 18
	STAWIL = 15
	STAINT = 15
	STALUC = 14

	// Skills
	adjust_skillrank(/datum/skill/combat/unarmed, 6, TRUE) // Legendary level
	adjust_skillrank(/datum/skill/combat/wrestling, 6, TRUE)
	adjust_skillrank(/datum/skill/misc/athletics, 6, TRUE)

	// Giving them two in an attempt to prevent them from picking up other weapons. AS FUNNY AS IT IS....
	for(var/i in 1 to 2)
		var/obj/item/rogueweapon/stag_antlers/A = new(src)
		if(!put_in_hands(A, TRUE))
			qdel(A)

	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/stag_hide

	var/static/list/stag_titles = list(
		"The White Spectre",
		"Lord Of The Woods",
		"The Ivory Wraith",
		"The Pale Sovereign",
		"The White Scourge",
		"The Pale Vengeance",
		"The Bleak Tyrant",
		"The Alabaster Monarch",
		"The Winter Herald",
		"The Ivory Giant",
		"The Forest Patriarch",
		"The Mist-Walker",
		"The Ghost of the Peak",
		"Kingslayer",
		"Durin's Bane",
		"The One",
		"King's Fever",
		"Lord Of The Hunt",
		"The Wild Hunter",
		"The Bleached Terror",
		"Terror Of The Woods",
		"Night Stalker",
		"The Silent Witness",
		"The Hunter's Ruin",
		"The Ivory Reaper",
		"The Uncatchable",
		"Winter's Wrath",
		"The Great White Calamity",
		"The Beast Of Old",
		"Snow Wraith",
		"Heart Of Ice",
		"Bone Stalker"
	)
	real_name = pick(stag_titles)
	name = real_name
	AddComponent(/datum/component/white_stag_tracker)
	// Practically the only way to kill this thing is through decapitating it, good luck!
	if(dna && dna.species)
		dna.species.species_traits |= NOBLOOD

/obj/item/clothing/suit/roguetown/armor/skin_armor/stag_hide
	slot_flags = null
	name = "white stag skin"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_PLATE_BSTEEL
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 1200
	item_flags = DROPDEL

/datum/intent/simple/stag_gore
	name = "gore"
	clickcd = CLICK_CD_QUICK
	icon_state = "stab"
	blade_class = BCLASS_STAB
	attack_verb = list("gores", "rams", "skewers")
	animname = "stab"
	hitsound = 'sound/combat/rend_hit.ogg'
	penfactor = PEN_BSTEEL
	candodge = TRUE
	canparry = TRUE
	miss_text = "thrusts its antlers wildly!"
	miss_sound = "bluntswoosh"

/obj/item/rogueweapon/stag_antlers
	name = "ancient antlers"
	desc = "Sharp, calcified points of power."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = null
	force = 45
	wdefense = 10
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_LONG
	wbalance = WBALANCE_NORMAL
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	possible_item_intents = list(/datum/intent/simple/stag_gore)
	item_flags = DROPDEL
	special = /datum/special_intent/greatsword_swing/white_stag
	max_blade_int = 8000
	max_integrity = 8000

/obj/item/rogueweapon/stag_antlers/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/datum/special_intent/greatsword_swing/white_stag
	requires_wielding = FALSE
	dam = 80
	cooldown = 25 SECONDS

/mob/living/simple_animal/hostile/retaliate/rogue/white_stag_corpse
	name = "White Stag"
	desc = "A creature of legend, now slain."
	icon = 'icons/mob/unique_shapeshifts/white_stag_shape.dmi'
	icon_state = "stag"
	icon_living = "stag"
	icon_dead = "stag_dead"
	gender = NEUTER
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 1
	maxHealth = 1
	// High-tier loot table
	// Yae, the loot of this thing is fairly lame, but that's because I ain't got the energy to sprite unique crafts right now.
	// It serves as a roleplay tool more than well enough without special loot.
	botched_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w = 6,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w = 3,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_w = 1,
		/obj/item/reagent_containers/food/snacks/fat = 2,
		/obj/item/natural/hide = 4,
		/obj/item/natural/bundle/bone/full = 4,
		/obj/item/alch/sinew = 2,
		/obj/item/alch/viscera = 1
	)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w = 10,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w = 5,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w = 3,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_w = 3,
		/obj/item/reagent_containers/food/snacks/fat = 6,
		/obj/item/natural/hide = 10,
		/obj/item/natural/bundle/bone/full = 10,
		/obj/item/alch/sinew = 5,
		/obj/item/alch/viscera = 3
	)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_w = 8,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_w = 8,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_w = 5,
		/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_w = 5,
		/obj/item/reagent_containers/food/snacks/fat = 6,
		/obj/item/natural/hide = 10,
		/obj/item/natural/bundle/bone/full = 10,
		/obj/item/alch/sinew = 5,
		/obj/item/alch/viscera = 3
	)
	// Dropping the special antlers as a trophy
	head_butcher = /obj/item/natural/head/white_stag
	// Doesn't rot
	rot_type = 0

/obj/item/natural/head/white_stag
	name = "white stag head"
	desc = "The enormous head and rack of the ever elusive white stag, priceless."
	icon = 'icons/roguetown/items/bounty_heads_big.dmi'
	icon_state = "white_stag"
	layer = 3.1
	grid_height = 32
	grid_width = 32
	sellprice = 500
	pixel_x = -16

/obj/structure/fluff/walldeco/mounted_head
	name = "mounted white stag head"
	desc = "A grand trophy, looming from the wall with sightless, ivory eyes."
	icon = 'icons/roguetown/items/bounty_heads_big.dmi'
	icon_state = "white_stag"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_MOB_LAYER
	pixel_x = -16
	var/stolen_item = /obj/item/natural/head/white_stag

/obj/structure/fluff/walldeco/mounted_head/attack_hand(mob/user)
	if(do_after(user, 50, target = src)) // Heavier than a painting
		to_chat(user, span_notice("You carefully pry [src] off the wall."))
		var/obj/item/I = new stolen_item(user.loc)
		user.put_in_hands(I)
		qdel(src)
		return
	..()

/obj/item/natural/head/white_stag/attack_turf(turf/T, mob/living/user)
	if(!isclosedturf(T))
		return ..()

	var/dir_to_wall = get_dir(user, T)
	if(!(dir_to_wall in GLOB.cardinals))
		return ..()

	to_chat(user, span_notice("You begin mounting [src] to the wall..."))
	if(do_after(user, 30, target = T))
		var/obj/structure/fluff/walldeco/mounted_head/S = new(user.loc)

		switch(dir_to_wall)
			if(NORTH)
				S.pixel_y = 32
				S.pixel_x = -16
			if(SOUTH)
				S.pixel_y = -32
				S.pixel_x = -16
			if(WEST)
				S.pixel_x = -48
			if(EAST)
				S.pixel_x = 16

		to_chat(user, span_notice("You mount [src] firmly."))
		qdel(src)
		return
	..()

/mob/living/simple_animal/hostile/retaliate/rogue/white_stag_corpse/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_DNR, TRAIT_GENERIC)

/datum/component/white_stag_tracker
	var/death_processed = FALSE

/datum/component/white_stag_tracker/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damage))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/white_stag_tracker/proc/on_damage(datum/source, damage, damagetype)
	SIGNAL_HANDLER
	if(damage <= 5)
		return
	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/buff/white_rush)

/datum/component/white_stag_tracker/proc/on_death()
	SIGNAL_HANDLER
	if(death_processed)
		return
	death_processed = TRUE

	var/mob/living/carbon/human/H = parent
	var/turf/T = get_turf(H)
	var/mob/living/simple_animal/hostile/retaliate/rogue/white_stag_corpse/C = new(T)
	C.name = H.real_name
	spawn(1)
		C.death() // Immediately kill it so it's just a corpse
	H.visible_message(span_userdanger("[H] lets out a final, haunting bell as its spirit departs, leaving a heavy carcass behind."))
	qdel(H)

#define MOVESPEED_ID_WHITE_RUSH "White Rush"

/datum/status_effect/buff/white_rush
	id = "white_rush"
	duration = 6 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/white_rush
	var/healing_per_tick = 1

/atom/movable/screen/alert/status_effect/buff/white_rush
	name = "Forest Rush"
	desc = "I WILL NOT BE HUNTED."
	icon_state = "stag_heal"

/datum/status_effect/buff/white_rush/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	owner.add_movespeed_modifier(MOVESPEED_ID_WHITE_RUSH, update=TRUE, priority=15, multiplicative_slowdown=-2)

/datum/status_effect/buff/white_rush/tick()
	var/mob/living/carbon/human/H = owner
	H.adjustBruteLoss(-healing_per_tick)
	H.heal_wounds(healing_per_tick)
	var/obj/effect/temp_visual/heal/E = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	E.color = "#FF0000"

/datum/status_effect/buff/white_rush/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_WHITE_RUSH)
	return ..()

#undef MOVESPEED_ID_WHITE_RUSH
