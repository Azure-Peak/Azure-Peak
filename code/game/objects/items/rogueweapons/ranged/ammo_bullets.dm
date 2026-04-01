#define MIN_BULLET_RANGE	2
#define MAX_BULLET_RANGE	7
#define DAM_FALLOFF_BULLET	0.5
#define HEAVY_AMMO_SPEED	3.5
#define HEAVY_AMMO_CHARGE	1.5
#define MIN_SCATTER_RANGE	1

// Slings - 1x Charge Time, 2x ammo capacity in pouch
// Never penetrate armor, it is meant to win by attrition, so it starts off with
// High base damage vs bow, as their damage type is damage reduced aggressively.

//sling bullets
/obj/item/ammo_casing/caseless/rogue/sling_bullet //parent of sling ammo and the temporary sling bullet for stones. shouldn't ever be seen
	name = "soaring stone"
	desc = "You shouldn't be seeing this."
	projectile_type = /obj/projectile/bullet/sling_bullet
	caliber = "slingbullet"
	icon = 'icons/roguetown/weapons/ranged/sling_mob.dmi'
	icon_state = "stone_sling_bullet"
	force = 5
	throwforce = 20 //you can still throw them
	dropshrink = 0.6
	possible_item_intents = list(INTENT_GENERIC) //not intended to attack with them
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20
	var/inscription

	var/static/list/sling_inscriptions = list(
		"CATCH",
		"TAKE THAT",
		"OUCH",
		"A GIFT",
		"FOR YOUR HEAD",
		"VICTORY",
		"SWALLOW THIS",
		"YOU ASKED FOR IT",
		"A NASTY SURPRISE",
		"SWIFT DEATH",
		"FROM THE SLINGER WITH LOVE",
		"RUN FASTER",
		"DODGE THIS",
		"FOR YOUR TEETH",
		"EAT LEAD",
		"GREETINGS",
		"TASTE IRON",
		"BULLS-EYE",
		"HELLO",
		"HEY",
		"GOOD DAE",
		"GOOD NITE",
		"GOOD EVENING",
		"MASK OFF",
		"PARRY THIS",
		"BLOCK THIS",
		"RIPOSTE THIS",
		"NEXT TIME I WONT MISS",
		"FEELS BETTER SOON",
		"MISS YOU",
		"SLEEP WELL",
		"FOR YOUR GOD'S BACKSIDE",
	)

/obj/item/ammo_casing/caseless/rogue/sling_bullet/examine(mob/user)
	. = ..()
	if(!inscription)
		return
	if(user.is_literate())
		. += span_smallnotice("Engraved: <i>\"[inscription]\"</i>")
	else
		. += span_smallnotice("It has some squiggly jiggly scratches on it.")

/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone/Initialize()
	. = ..()
	inscription = pick(sling_inscriptions)

/obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze/Initialize()
	. = ..()
	inscription = pick(sling_inscriptions)

/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron/Initialize()
	. = ..()
	inscription = pick(sling_inscriptions)

/obj/item/ammo_casing/caseless/rogue/sling_bullet/aalloy/Initialize()
	. = ..()
	inscription = pick(sling_inscriptions)

/obj/item/ammo_casing/caseless/rogue/sling_bullet/paalloy/Initialize()
	. = ..()
	inscription = pick(sling_inscriptions)

/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot/Initialize()
	. = ..()
	inscription = pick(sling_inscriptions)

/obj/item/ammo_casing/caseless/rogue/sling_bullet/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -7,"sy" = -5,"nx" = 7,"ny" = -5,"wx" = -3,"wy" = -5,"ex" = 5,"ey" = -5,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/ammo_casing/caseless/rogue/sling_bullet/stone //these should be seen
	name = "stone sling bullet"
	desc = "A stone refined for wrath."
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/stone
	icon_state = "stone_sling_bullet"

/obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	name = "bronze sling bullet"
	desc = "A small bronze sphere. It feels deceptively heavy in the palm of your hand."
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/bronze
	icon_state = "bronze_sling_bullet"


/obj/item/ammo_casing/caseless/rogue/sling_bullet/aalloy
	name = "decrepit sling bullet"
	desc = "A pellet of frayed bronze. The alloy flakes apart in your grasp, staining the palm with flecks of brown-and-red."
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/aalloy
	icon_state = "ancient_sling_bullet"
	color = "#bb9696"

/obj/item/ammo_casing/caseless/rogue/sling_bullet/paalloy
	name = "ancient sling bullet"
	desc = "A pellet of polished gilbranze. The bigger they are, the harder they'll fall; be it Man or God."
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/paalloy
	icon_state = "ancient_sling_bullet"

/obj/item/ammo_casing/caseless/rogue/sling_bullet/iron
	name = "iron sling bullet"
	desc = "Not to be mistakened for a ball bearing."
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/iron
	icon_state = "iron_sling_bullet"

/obj/projectile/bullet/sling_bullet // Supposed to be a version that breaks on impact. Might be unused?
	name = "stone sling bullet"
	desc = "If you're reading this: duck."
	damage = 40
	damage_type = BRUTE
	armor_penetration = PEN_NONE
	npc_simple_damage_mult = 2
	icon = 'icons/roguetown/weapons/ranged/sling_mob.dmi'
	icon_state = "stone_sling_bullet"
	range = 15
	hitsound = 'sound/combat/hits/blunt/bluntsmall (1).ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	speed = 0.4
	npc_simple_damage_mult = 2.5 // Deals roughly ~75-95 damage against a simplemob, compared to the ~140 damage of a crossbolt or arrow.

/obj/projectile/bullet/sling_bullet/on_hit(atom/target)
	. = ..()
	var/mob/living/L = firer
	if(!L || !L.mind) return
	var/skill_multiplier = 0
	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4
	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/slings, SKILL_LEVEL_LEGENDARY))
		L.mind.add_sleep_experience(/datum/skill/combat/slings, L.STAINT * skill_multiplier)

/obj/projectile/bullet/reusable/sling_bullet //parent for proper reusable sling bullets
	name = "metal sling bullet"
	desc = "If you're reading this: duck."
	damage = 40
	damage_type = BRUTE
	armor_penetration = PEN_NONE
	icon = 'icons/roguetown/weapons/ranged/sling_proj.dmi'
	icon_state = "slingbullet_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet
	range = 15
	hitsound = 'sound/combat/hits/blunt/bluntsmall (1).ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	speed = 0.4
	npc_simple_damage_mult = 2.5 // Deals roughly ~75-95 damage against a simplemob, compared to the ~140 damage of a crossbolt or arrow.
	ricochets_max = 2
	ricochet_chance = 80
	ricochet_auto_aim_angle = 40
	ricochet_auto_aim_range = 5
	ricochet_incidence_leeway = 40
	ricochet_decay_chance = 1
	ricochet_decay_damage = 1 /// No bonus damage on bounce.
	min_range = MIN_BULLET_RANGE
	max_range = MAX_BULLET_RANGE
	dam_falloff_factor = DAM_FALLOFF_BULLET

/obj/projectile/bullet/reusable/sling_bullet/on_hit(atom/target)
	. = ..()
	var/mob/living/L = firer
	if(!L || !L.mind) return
	var/skill_multiplier = 0
	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4
	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/slings, SKILL_LEVEL_LEGENDARY))
		L.mind.add_sleep_experience(/datum/skill/combat/slings, L.STAINT * skill_multiplier)

/obj/projectile/bullet/reusable/sling_bullet/stone
	name = "stone sling bullet"
	damage = 32 //proper stones are better
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone

/obj/projectile/bullet/reusable/sling_bullet/aalloy
	name = "decrepit sling bullet"
	damage = 22
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/aalloy

/obj/projectile/bullet/reusable/sling_bullet/bronze
	name = "bronze sling bullet"
	damage = 45
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	speed = 0.25 // Faster! 

/obj/projectile/bullet/reusable/sling_bullet/iron
	name = "iron sling bullet"
	damage = 40
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron


/obj/projectile/bullet/reusable/sling_bullet/paalloy
	name = "ancient sling bullet"
	damage = 40
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/paalloy

// SCATTERSHOT - Steel pellets that shatter on impact. Non-recoverable.
// No minimum range, extra ricochets, but short max range. Better DPS if all pellets land.
/obj/item/ammo_casing/caseless/rogue/sling_bullet/scattershot
	name = "steel scattershot"
	desc = "A cluster of steel pellets packed into a pouch. They scatter on release, shredding anything nearby - but they won't fly far."
	projectile_type = /obj/projectile/bullet/sling_bullet/scattershot
	icon_state = "scattershot"
	pellets = 3
	variance = 30

/obj/projectile/bullet/sling_bullet/scattershot
	name = "steel scattershot"
	icon = 'icons/roguetown/weapons/ranged/sling_proj.dmi'
	icon_state = "scatter_proj"
	damage = 20
	ricochets_max = 0
	ricochet_chance = 0
	min_range = MIN_SCATTER_RANGE
	max_range = 5
	dam_falloff_factor = DAM_FALLOFF_BULLET

// HEAVY SLING BULLET - Big slow CC projectile. Staggers and slows on hit, takes 3 weight in the pouch.
/obj/item/ammo_casing/caseless/rogue/sling_bullet/heavy_sling_bullet
	name = "heavy sling bullet"
	desc = "A hefty stone polished and rounded to fit in a sling as a projectile, at the upper limit of how heavy a sling bullet can be. It won't fly fast or far, but the sheer mass can stagger a target and knock them back on impact."
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/heavy_sling_bullet
	icon_state = "heavy_sling_bullet"
	ammo_weight = 3
	charge_time_mult = HEAVY_AMMO_CHARGE

/obj/projectile/bullet/reusable/sling_bullet/heavy_sling_bullet
	name = "heavy sling bullet"
	icon_state = "heavy_proj"
	damage = 50
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/heavy_sling_bullet
	speed = HEAVY_AMMO_SPEED
	ricochets_max = 0
	ricochet_chance = 0
	max_range = 5

/obj/projectile/bullet/reusable/sling_bullet/heavy_sling_bullet/on_hit(atom/target)
	. = ..()
	if(!isliving(target))
		return
	var/mob/living/M = target
	M.visible_message(span_warning("[M] staggers from the heavy impact!"))
	M.apply_status_effect(/datum/status_effect/debuff/staggered, 3 SECONDS)
	var/throw_dir = get_dir(src, target)
	var/atom/throw_target = get_edge_target_turf(M, throw_dir)
	M.safe_throw_at(throw_target, 2, 1)

// FIRE POT - Ceramic pot of alchemical fire. Ignites on impact.
/obj/item/ammo_casing/caseless/rogue/sling_bullet/fire_pot
	name = "fire pot"
	desc = "A small ceramic pot filled with volatile alchemical fire. It shatters on impact, spreading flames."
	projectile_type = /obj/projectile/bullet/sling_bullet/fire_pot
	icon_state = "fire_pot"
	ammo_weight = 3
	charge_time_mult = HEAVY_AMMO_CHARGE

/obj/projectile/bullet/sling_bullet/fire_pot
	name = "fire pot"
	damage = 10
	damage_type = BURN
	icon = 'icons/roguetown/weapons/ranged/sling_proj.dmi'
	icon_state = "pot_proj"
	range = 15
	hitsound = 'sound/combat/hits/blunt/bluntsmall (1).ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	speed = HEAVY_AMMO_SPEED
	min_range = MIN_BULLET_RANGE
	max_range = MAX_BULLET_RANGE
	dam_falloff_factor = DAM_FALLOFF_BULLET

/obj/projectile/bullet/sling_bullet/fire_pot/on_hit(atom/target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.adjust_fire_stacks(2)
		M.adjustFireLoss(10)
		M.ignite_mob()
	var/turf/T = get_turf(target)
	if(T)
		new /obj/effect/hotspot(T, null, null, 15)

// GUNPOWDER AMMO
/obj/projectile/bullet/reusable/bullet
	name = "lead ball"
	damage = 30
	damage_type = BRUTE
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	range = 30
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	armor_penetration = PEN_NONE
	speed = 0.1
	npc_simple_damage_mult = 2 // I know this isn't used in Azure Peak but trust me some downstream guys are going to thank me for this because everything that uses it shoots so fucking slow that even volves are hard to kill.

/obj/item/ammo_casing/caseless/rogue/bullet
	name = "lead sphere"
	desc = "A small lead sphere. This should go well with gunpowder."
	projectile_type = /obj/projectile/bullet/reusable/bullet
	caliber = "musketball"
	icon_state = "musketball"
	dropshrink = 0.5
	possible_item_intents = list(/datum/intent/use)
	max_integrity = 0.1


//mob projectiles
/obj/projectile/bullet/reusable/arrow/orc
	armor_penetration = PEN_LIGHT
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	embedchance = 100
	speed = 2 // I guess slower to be slightly more forgiving to players since they're otherwise aimbots

/obj/projectile/bullet/reusable/arrow/ancient
	damage = 10
	armor_penetration = PEN_LIGHT
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy
	embedchance = 100
	speed = 2 // I guess slower to be slightly more forgiving to players since they're otherwise aimbots

//deep one thrown stone
/obj/projectile/bullet/reusable/deepone
	name = "stone"
	damage = 25
	damage_type = BRUTE
	armor_penetration = PEN_NONE
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stone1"
	ammo_type = /obj/item/natural/stone
	range = 15
	hitsound = 'sound/combat/hits/blunt/bluntsmall (1).ogg'
	embedchance = 50
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	speed = 10

//Spider projectiles
/obj/projectile/bullet/spider
	name = "web glob"
	damage = 10
	damage_type = BRUTE
	icon = 'modular/Mapping/icons/webbing.dmi'
	icon_state = "webglob"
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 0
	//Will not cause wounds.
	woundclass = null
	flag = "piercing"
	speed = 2 // I guess slower to be slightly more forgiving to players since they're otherwise aimbots

/obj/projectile/bullet/spider_shroom
	name = "web glob"
	damage = 10
	damage_type = BRUTE
	icon = 'modular/Mapping/icons/webbing.dmi'
	icon_state = "webglob"
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 0
	//Will not cause wounds.
	woundclass = null
	flag = "piercing"
	speed = 2

/obj/projectile/bullet/spider/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.apply_status_effect(/datum/status_effect/debuff/vulnerable)
		M.Immobilize(15)
	var/turf/T
	if(isturf(target))
		T = target
	else
		T = get_turf(target)
	var/web = locate(/obj/structure/spider/stickyweb/mirespider) in T.contents
	if(!(web in T.contents))
		new /obj/structure/spider/stickyweb/mirespider(T)

/obj/projectile/bullet/spider_shroom/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		M.apply_status_effect(/datum/status_effect/debuff/vulnerable)
		M.apply_status_effect(/datum/status_effect/buff/druqks)
	var/turf/T
	if(isturf(target))
		T = target
	else
		T = get_turf(target)
	var/web = locate(/obj/structure/spider/stickyweb/mirespider) in T.contents
	if(!(web in T.contents))
		new /obj/structure/spider/stickyweb/mirespider(T)

//Mirespider webs are thinner and will not stop projectiles or obstruct movement as often.
/obj/structure/spider/stickyweb/mirespider
	opacity = 0
	pass_flags = LETPASSTHROW
	debris = null

/obj/structure/spider/stickyweb/mirespider/CanPass(atom/movable/mover, turf/target)
	if(isliving(mover))
		if(prob(25) && !HAS_TRAIT(mover, TRAIT_WEBWALK))
			to_chat(mover, "<span class='danger'>I get stuck in \the [src] for a moment.</span>")
			return FALSE
	else if(istype(mover, /obj/projectile))
		return prob(85)
	return TRUE

#undef MIN_BULLET_RANGE
#undef MAX_BULLET_RANGE
#undef DAM_FALLOFF_BULLET
#undef HEAVY_AMMO_SPEED
#undef HEAVY_AMMO_CHARGE
#undef MIN_SCATTER_RANGE
