/mob/living/simple_animal/hostile/retaliate/rogue/boar/undead
	icon = 'icons/roguetown/mob/monster/deadites/boar_undead.dmi'
	name = "deadite bramblesnout"
	desc = "The terrifying bramblesnout, claimed by undeath. Its viciously curved tusks are splintered but lethal, backed by a ruined mass of muscle that no longer feels pain, fatigue, or mercy."
	icon_state = "boar"
	icon_living = "boar"
	icon_dead = "boar_dead"
	health = BOAR_HEALTH_UNDEAD
	maxHealth = BOAR_HEALTH_UNDEAD
	ai_controller = /datum/ai_controller/boar/undead

	head_butcher = /obj/item/natural/head/boar/undead
	botched_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2, 
		/obj/item/alch/sinew = 2, 
		/obj/item/natural/bone = 4,
		/obj/item/alch/viscera = 1,
		/obj/item/natural/hide = 1,
	)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 4,
		/obj/item/reagent_containers/food/snacks/fat = 2, 
		/obj/item/natural/bundle/bone/full = 1, 
		/obj/item/alch/sinew = 3, 
		/obj/item/alch/bone = 1, 
		/obj/item/alch/viscera = 2, 
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2,
		/obj/item/natural/hide = 2,
	)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 5,
		/obj/item/reagent_containers/food/snacks/fat = 3, 
		/obj/item/natural/bundle/bone/full = 1, 
		/obj/item/alch/sinew = 4, 
		/obj/item/alch/bone = 1, 
		/obj/item/alch/viscera = 2, 
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2,
		/obj/item/natural/hide = 3,
	)

/mob/living/simple_animal/hostile/retaliate/rogue/boar/undead/Initialize()
	. = ..()
	AddComponent(/datum/component/deadite, 15 MINUTES, BOAR_HEALTH_UNDEAD, 300, "boar_downed", 0)

/mob/living/simple_animal/hostile/retaliate/rogue/boar/undead/simple_limb_hit(zone)
	if(!zone)
		return ""
	switch(zone)
		if(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE, BODY_ZONE_PRECISE_SKULL, BODY_ZONE_PRECISE_EARS)
			return "head"
		if(BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH)
			return "mouth"
		if(BODY_ZONE_PRECISE_NECK)
			return "neck"
		if(BODY_ZONE_R_LEG, BODY_ZONE_PRECISE_R_FOOT, BODY_ZONE_R_ARM, BODY_ZONE_PRECISE_R_HAND)
			return "r_leg"
		if(BODY_ZONE_L_LEG, BODY_ZONE_PRECISE_L_FOOT, BODY_ZONE_L_ARM, BODY_ZONE_PRECISE_L_HAND)
			return "l_leg"
		if(BODY_ZONE_PRECISE_STOMACH)
			return "stomach"
	return ..()

/datum/species/terrorhog
	name = "Terrorhog"
	id = "terrorhog"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
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
		TRAIT_NOBREATH,
		TRAIT_DEATHLESS,
		TRAIT_BLOOD_RESISTANCE,
		TRAIT_BADTRAINER,
	)
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_ARMOR, SLOT_WEAR_MASK, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT)
	nojumpsuit = TRUE
	sexes = 1
	soundpack_m = /datum/voicepack/boar
	soundpack_f = /datum/voicepack/boar

/datum/species/terrorhog/regenerate_icons(mob/living/carbon/human/H)
	H.icon = 'icons/mob/unique_shapeshifts/boar_shape.dmi'
	H.icon_state = "boar"
	H.pixel_x = -16
	return TRUE

/mob/living/carbon/human/species/wildshape/terrorhog
	name = "The Terrorhog"
	race = /datum/species/terrorhog
	ai_controller = /datum/ai_controller/human_npc
	d_intent = INTENT_PARRY
	dodgetime = 10
	pixel_x = -16
	// We are not a normal wildshape.
	untransform_on_death = FALSE
	faction = list(FACTION_ZOMBIE)
	icon = 'icons/mob/unique_shapeshifts/boar_shape.dmi'
	icon_state = "boar"

/mob/living/carbon/human/species/wildshape/terrorhog/gain_inherent_skills()
	return FALSE

/mob/living/carbon/human/species/wildshape/terrorhog/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/wildshape/terrorhog/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)

	STASTR = 14
	STASPD = 18
	STACON = 20
	STAPER = 11
	STAWIL = 16
	// Minimum int needed to use specials
	STAINT = 8
	STALUC = 10

	adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	adjust_skillrank(/datum/skill/combat/wrestling, 6, TRUE)
	adjust_skillrank(/datum/skill/misc/athletics, 6, TRUE)

	for(var/i in 1 to 2)
		var/obj/item/rogueweapon/terrorhog_tusks/T = new(src)
		if(!put_in_hands(T, TRUE))
			qdel(T)

	skin_armor = new /obj/item/clothing/suit/roguetown/armor/skin_armor/terrorhog_hide
	real_name = "Terrorhog"
	name = real_name

	AddComponent(/datum/component/terrorhog_tracker)

	if(dna && dna.species)
		dna.species.species_traits |= NOBLOOD

/obj/item/clothing/suit/roguetown/armor/skin_armor/terrorhog_hide
	slot_flags = null
	name = "calcified bristled hide"
	desc = "Thick skin packed with dense scar tissue."
	icon_state = null
	body_parts_covered = FULL_BODY
	body_parts_inherent = FULL_BODY
	armor = ARMOR_PLATE_BSTEEL
	blocksound = SOFTHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 600
	item_flags = DROPDEL

/datum/intent/simple/terrorhog_trample
	name = "slash"
	clickcd = CLICK_CD_QUICK
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("tramples", "slashes", "eviscerates")
	animname = "chop"
	hitsound = 'sound/combat/rend_hit.ogg'
	penfactor = PEN_HEAVY
	candodge = TRUE
	canparry = TRUE
	miss_text = "swings its massive head wildly!"
	miss_sound = "bluntswoosh"
	swingdelay = 0.7 SECONDS
	cleave = /datum/cleave_pattern/frontal_t

/obj/item/rogueweapon/terrorhog_tusks
	name = "bone blade"
	desc = "Jagged, bone jutting from the leg."
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = null
	force = 36
	wdefense = 6
	associated_skill = /datum/skill/combat/unarmed
	wlength = WLENGTH_LONG
	wbalance = WBALANCE_NORMAL
	can_parry = TRUE
	sharpness = IS_SHARP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	possible_item_intents = list(/datum/intent/simple/terrorhog_trample)
	item_flags = DROPDEL
	special = /datum/special_intent/terrorhog_onslaught
	max_blade_int = 8000
	max_integrity = 8000

/obj/item/rogueweapon/terrorhog_tusks/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOEMBED, TRAIT_GENERIC)

/datum/component/terrorhog_tracker
	var/death_processed = FALSE

/datum/component/terrorhog_tracker/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_MOB_APPLY_DAMGE, PROC_REF(on_damage))
	RegisterSignal(parent, COMSIG_LIVING_DEATH, PROC_REF(on_death))

/datum/component/terrorhog_tracker/proc/on_damage(datum/source, damage, damagetype)
	SIGNAL_HANDLER
	if(damage <= 5)
		return
	var/mob/living/carbon/human/H = parent
	H.apply_status_effect(/datum/status_effect/buff/blood_frenzy)

/datum/component/terrorhog_tracker/proc/on_death()
	SIGNAL_HANDLER
	if(death_processed)
		return
	death_processed = TRUE

	var/mob/living/carbon/human/H = parent
	var/turf/T = get_turf(H)
	var/mob/living/simple_animal/hostile/retaliate/rogue/terrorhog_corpse/C = new(T)
	
	spawn(1)
		C.death()
		
	H.visible_message(span_userdanger("[H] crashes down with a massive thud, its squealing finally falling silent."))
	qdel(H)

#define MOVESPEED_ID_BLOOD_FRENZY "Blood Frenzy"

/datum/status_effect/buff/blood_frenzy
	id = "blood_frenzy"
	duration = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/blood_frenzy

/atom/movable/screen/alert/status_effect/buff/blood_frenzy
	name = "Blood Frenzy"
	desc = "THE SMELL OF BLOOD DRIVES ME FORWARD."
	icon_state = "buff"

/datum/status_effect/buff/blood_frenzy/on_apply()
	. = ..()
	if(!ishuman(owner))
		return FALSE
	owner.add_movespeed_modifier(MOVESPEED_ID_BLOOD_FRENZY, update=TRUE, priority=15, multiplicative_slowdown=-1)

/datum/status_effect/buff/blood_frenzy/tick()
	var/obj/effect/temp_visual/heal/E = new /obj/effect/temp_visual/heal_rogue(get_turf(owner))
	E.color = "#8B0000"

/datum/status_effect/buff/blood_frenzy/on_remove()
	owner.remove_movespeed_modifier(MOVESPEED_ID_BLOOD_FRENZY)
	return ..()

#undef MOVESPEED_ID_BLOOD_FRENZY

/mob/living/simple_animal/hostile/retaliate/rogue/terrorhog_corpse
	name = "Terrorhog"
	desc = "No longer do the wails of this profane creature pierce the night."
	icon = 'icons/mob/unique_shapeshifts/boar_shape.dmi'
	icon_state = "boar"
	icon_living = "boar"
	icon_dead = "boar_dead"
	gender = NEUTER
	mob_biotypes = MOB_ORGANIC|MOB_BEAST
	health = 1
	maxHealth = 1

	botched_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2, 
		/obj/item/alch/sinew = 2, 
		/obj/item/natural/bone = 4,
		/obj/item/alch/viscera = 1,
		/obj/item/natural/hide = 1,
	)
	butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 4,
		/obj/item/reagent_containers/food/snacks/fat = 2, 
		/obj/item/natural/bundle/bone/full = 1, 
		/obj/item/alch/sinew = 3, 
		/obj/item/alch/bone = 1, 
		/obj/item/alch/viscera = 2, 
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2,
		/obj/item/natural/hide = 2,
	)
	perfect_butcher_results = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 5,
		/obj/item/reagent_containers/food/snacks/fat = 3, 
		/obj/item/natural/bundle/bone/full = 1, 
		/obj/item/alch/sinew = 4, 
		/obj/item/alch/bone = 1, 
		/obj/item/alch/viscera = 2, 
		/obj/item/reagent_containers/food/snacks/rogue/meat_rotten = 2,
		/obj/item/natural/hide = 3,
	)

	head_butcher = /obj/item/natural/head/terrorhog
	rot_type = 0

/datum/special_intent/terrorhog_onslaught
	name = "Phantom Onslaught"
	desc = "The Terrorhog summons phantoms to knock down nearby targets, possibly goring them if they are downed."
	cooldown = 35 SECONDS
	requires_wielding = FALSE
	use_clickloc = FALSE
	respect_adjacency = FALSE
	respect_dir = FALSE
	stamcost = 40
	var/dam = 40
	var/duration_of_special = 4 SECONDS
	var/stagger_delay = 0.5 SECONDS
	tile_coordinates = list(list(0, 0))
	pre_icon_state = null
	post_icon_state = null

/datum/special_intent/terrorhog_onslaught/process_attack()
	SHOULD_CALL_PARENT(FALSE) 

	if(!isliving(howner) || howner.stat == DEAD)
		return FALSE

	howner.visible_message(span_danger("[howner] stomps the ground furiously as phantoms dive out of the shadows!"))
	playsound(howner, 'modular/Creechers/sound/pighangry.ogg', 100, TRUE)
	howner.Immobilize(duration_of_special)

	var/list/valid_targets = list()
	for(var/mob/living/L in orange(7, howner))
		if(L.stat == DEAD) 
			continue
		var/shared_faction = FALSE
		if(L.faction && howner.faction)
			for(var/F in L.faction)
				if(F in howner.faction)
					shared_faction = TRUE
					break
		if(shared_faction)
			continue
		valid_targets += L

	apply_cooldown()

	if(!valid_targets.len)
		return TRUE

	spawn(0)
		var/ambushes_launched = 0
		var/list/spawned_phantom_turfs = list()

		while(valid_targets.len && ambushes_launched < 5)
			if(!howner || howner.stat == DEAD)
				break

			var/mob/living/victim = pick(valid_targets)

			// If anyone were to comment this out, the same guy could get nerded.
			valid_targets -= victim 

			var/turf/victim_turf = get_turf(victim)
			if(!victim_turf)
				continue
			var/turf/spawn_turf = null
			var/list/potential_spots = orange(3, victim_turf) - orange(2, victim_turf)
			var/list/filtered_spots = list()

			for(var/turf/T in potential_spots)
				if(T.density || (T in spawned_phantom_turfs))
					continue
				filtered_spots += T

			if(filtered_spots.len)
				spawn_turf = pick(filtered_spots)

			if(!spawn_turf)
				continue

			spawned_phantom_turfs += spawn_turf
			ambushes_launched++

			new /obj/projectile/bullet/terrorhog_phantom(spawn_turf, victim, howner, dam)
			sleep(stagger_delay)

	return TRUE

/obj/projectile/bullet/terrorhog_phantom
	name = "spectral phantom"
	desc = "A terrifying, spectral image of a charging boar!"
	icon = 'icons/mob/unique_shapeshifts/boar_shape.dmi'
	icon_state = "boar"

	color = "#777777"
	alpha = 220
	pixel_x = -16

	var/damage_value = 40
	var/mob/living/master_hog
	speed = 2

/obj/projectile/bullet/terrorhog_phantom/Initialize(mapload, mob/living/target, mob/living/boss_source, base_damage)
	. = ..()
	if(!target || !boss_source)
		return INITIALIZE_HINT_QDEL

	master_hog = boss_source
	firer = boss_source
	damage_value = base_damage
	def_zone = BODY_ZONE_CHEST

	var/raw_dir = get_dir(src, target)
	if(raw_dir & (NORTH|SOUTH))
		raw_dir &= (NORTH|SOUTH)
	else if(raw_dir & (EAST|WEST))
		raw_dir &= (EAST|WEST)
	src.dir = raw_dir

	playsound(src, 'sound/vo/mobs/boar/boar_charge.ogg', 50, TRUE)
	
	var/turf/destination = get_turf(target)
	addtimer(CALLBACK(src, PROC_REF(start_phantom_drive), destination), 0.8 SECONDS)

/obj/projectile/bullet/terrorhog_phantom/proc/start_phantom_drive(turf/destination)
	if(QDELETED(src) || !destination)
		qdel(src)
		return

	var/firing_angle = Get_Angle(src, destination)
	fire(firing_angle)

/obj/projectile/bullet/terrorhog_phantom/on_hit(atom/target, blocked)
	explode_payload()
	return BULLET_ACT_HIT

/obj/projectile/bullet/terrorhog_phantom/proc/explode_payload()
	var/turf/landing_zone = get_turf(src)
	if(!landing_zone)
		qdel(src)
		return

	var/list/affected_turfs = range(1, landing_zone)
	for(var/turf/T in affected_turfs)
		var/obj/effect/temp_visual/special_intent/fx = new(T, 0.5 SECONDS)
		fx.icon = 'icons/effects/effects.dmi'
		fx.icon_state = "sweep_fx"

	playsound(landing_zone, 'sound/combat/hits/onwood/fence_hit3.ogg', 70, TRUE)

	for(var/turf/T in affected_turfs)
		for(var/mob/living/L in T)
			if(L == master_hog)
				continue
				
			var/shared_faction = FALSE
			if(L.faction && master_hog.faction)
				for(var/F in L.faction)
					if(F in master_hog.faction)
						shared_faction = TRUE
						break
			if(shared_faction)
				continue

			// Gore only if a target is downed and hit by a shockwave
			// You can dodge the projectiles by ducking, but it is risky!
			if(!(L.mobility_flags & MOBILITY_STAND))
				L.visible_message(span_userdanger("[src] ruthlessly gores [L]!"))
				if(iscarbon(L))
					var/mob/living/carbon/C = L
					var/obj/item/bodypart/chest = C.get_bodypart(BODY_ZONE_CHEST)
					if(chest)
						chest.add_wound(/datum/wound/slash/boar_gore)
				L.Stun(2 SECONDS)
				L.apply_status_effect(/datum/status_effect/debuff/exposed, 10 SECONDS)
				L.adjustBruteLoss(50)
				playsound(L, 'sound/combat/crit.ogg', 75, TRUE)
			else
				L.visible_message("<span class='warning'>The shockwave from [src]'s impact knocks [L] off their feet!</span>")
				L.Knockdown(3 SECONDS)
				L.apply_status_effect(/datum/status_effect/debuff/dazed)
				L.adjustBruteLoss(damage_value)
	qdel(src)
