//arrows ฅ^•ﻌ•^ฅ
#define MIN_ARROW_RANGE		3
#define MAX_ARROW_RANGE		14
#define DAM_FALLOFF_ARROW	0.5
#define MIN_SPLINTER_RANGE	1
#define MAX_SPLINTER_RANGE	5

/obj/item/ammo_casing/caseless/rogue/arrow
	name = "arrow"
	desc = "Some devices are so simple in their nature and austere in their scope \
	that they feel as if they've sprung into being without mortal intervention. \
	Consult your gods."
	projectile_type = /obj/projectile/bullet/reusable/arrow
	caliber = "arrow"
	icon = 'icons/roguetown/weapons/ranged/arrow_mob.dmi'
	icon_state = "arrow"
	force = 10
	dropshrink = 0.6
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	max_integrity = 10
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH

/obj/item/ammo_casing/caseless/rogue/arrow/blunt
	name = "blunt arrow"
	desc = "For when you really need to kill a zad."
	icon_state = "arrow_blunt"
	projectile_type = /obj/projectile/bullet/reusable/arrow/blunt
	force = 5
	possible_item_intents = list(/datum/intent/mace/strike)

/obj/item/ammo_casing/caseless/rogue/arrow/stone
	name = "stone arrow"
	desc = "A simple dowel sports lashed flint knapped and honed to a razor edge. Folk \
	wisdom holds that these cut finer than iron heads, but they tend to shatter \
	on impact with armor."
	max_integrity = 5
	projectile_type = /obj/projectile/bullet/reusable/arrow/stone

/obj/item/ammo_casing/caseless/rogue/arrow/bronze
	name = "bronze flight arrow"
	icon_state = "bronzearrow"
	desc = "Bronze, quenched and batonned onto a feathered stick. The stories scribed along its imperfect edge could fill a hundred tomes; lost to antiquity, but remembered through sheer generational instinct."
	max_integrity = 8
	projectile_type = /obj/projectile/bullet/reusable/arrow/bronze

/obj/item/ammo_casing/caseless/rogue/arrow/iron
	name = "iron broadhead arrow"
	icon_state = "ironarrow"
	desc = "Bundles of steam straightened dowels are notched at one end and fastened \
	to iron-heads on another. With flight feathers lashed it will fly true to its \
	shooters will."
	projectile_type = /obj/projectile/bullet/reusable/arrow/iron

/obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy
	name = "decrepit broadhead arrow"
	desc = "An arrow; one end, tipped with flattened and frayed bronze - the other, \
	inlaid with decayed feathers. The alloy's decrepity forces it to burst into \
	shrapnel upon impact, shredding flesh."
	icon_state = "ancientarrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/iron/aalloy
	color = "#bb9696"

/obj/item/ammo_casing/caseless/rogue/arrow/steel
	name = "steel bodkin arrow"
	icon_state = "steelarrow"
	desc = "Bundles of steam straightened dowels are notched at one end and fastened \
	to steel-heads on another. Crafted for more well-prepared targets."
	projectile_type = /obj/projectile/bullet/reusable/arrow/steel

/obj/item/ammo_casing/caseless/rogue/arrow/steel/paalloy
	name = "ancient bodkin arrow"
	desc = "An arrow; one end, tipped with a sharpened rod of polished gilbranze - \
	the other, inlaid with feathers. The razor-thin tip resembles a sabot; an alloyed \
	sliver that can punch straight through steel."
	icon_state = "ancientarrow"
	projectile_type = /obj/projectile/bullet/reusable/arrow/steel/paalloy

/obj/projectile/bullet/reusable/arrow
	name = "arrow"
	damage = 20
	damage_type = BRUTE
	npc_simple_damage_mult = 2
	armor_penetration = PEN_NONE
	//accuracy = 65 // Default defined by projectile.dm
	icon = 'icons/roguetown/weapons/ranged/arrow_proj.dmi'
	icon_state = "arrow_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 25
	intdamfactor = 1.25 // Attempt to make it so that arrows do more damage to armor
	// Without instantly killing people when armor breaks
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	speed = 0.4
	min_range = MIN_ARROW_RANGE
	max_range = MAX_ARROW_RANGE

/obj/projectile/bullet/reusable/arrow/on_hit(atom/target)
	..()
	var/mob/living/L = firer
	if(!L || !L.mind)
		return
	var/skill_multiplier = 0
	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4
	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/bows, SKILL_LEVEL_EXPERT))
		L.mind.add_sleep_experience(/datum/skill/combat/bows, L.STAINT * skill_multiplier)

/obj/projectile/bullet/reusable/arrow/blunt
	name = "blunt arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/blunt
	damage = 15
	armor_penetration = PEN_NONE
	embedchance = 0
	woundclass = BCLASS_BLUNT

/obj/projectile/bullet/reusable/arrow/stone
	name = "stone arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	damage = 30
	accuracy = 60

// Broadheads are high damage, low AP. Very high base damage - relies on breaking armor
// Broadheads check against slash armor instead of piercing.
/obj/projectile/bullet/reusable/arrow/iron
	name = "broadhead arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	damage = 50
	armor_penetration = PEN_LIGHT
	flag = "piercing"
	embedchance = 30
	npc_simple_damage_mult = 2


/obj/projectile/bullet/reusable/arrow/iron/aalloy
	name = "decrepit broadhead arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy
	icon_state = "ancientarrow_proj"
	damage = 50
	armor_penetration = PEN_LIGHT
	flag = "piercing"

// Bodkins should penetrate essentially any armour in the game with decent perception, as
// recompense for their very low damage. Better for lower perception characters without
// enough raw damage to consistently penetrate armour.
/obj/projectile/bullet/reusable/arrow/steel
	name = "bodkin arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/steel
	accuracy = 75
	damage = 25
	armor_penetration = PEN_HEAVY
	embedchance = 80 // Easy embeds!
	npc_simple_damage_mult = 3

// Significantly worse armour-piercing, slightly more damage. Should still penetrate most things.
// Note that it's pretty likely the skeleton using these has a longbow, which penetrates more stuff.
/obj/projectile/bullet/reusable/arrow/steel/paalloy
	name = "ancient bodkin arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/steel/paalloy
	icon_state = "ancientarrow_proj"
	damage = 30
	armor_penetration = PEN_HEAVY
	embedchance = 60

// Non-existent AP, but strong damage, a high embed chance, and very fast projectiles.
// Will have to see how this one plays out - may be a utility pick for chasedowns?
/obj/projectile/bullet/reusable/arrow/bronze
	name = "bronze flight arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/bronze
	icon_state = "bronzearrow_proj"
	damage = 50
	armor_penetration = PEN_NONE
	embedchance = 70
	npc_simple_damage_mult = 3 //More damage over simplemobs!
	speed = 0.15 // Faster!

// POISON AMMO
/obj/item/ammo_casing/caseless/rogue/arrow/poison
	name = "poisoned arrow"
	desc = "Bundles of steam straightened dowels are notched at one end and fastened \
	to razor heads on another. Furrels cut into the arrow-head with an intoxicating concoction. \
	within."
	projectile_type = /obj/projectile/bullet/reusable/arrow/poison
	icon_state = "ironarrow_poison"

/obj/item/ammo_casing/caseless/rogue/arrow/stone/poison
	name = "poisoned stone arrow"
	desc = "A simple dowel sports lashed flint honed to a razor edge and knapped \
	with furrels for carrying poison residue."
	projectile_type = /obj/projectile/bullet/reusable/arrow/poison/stone
	icon_state = "arrow_poison"

/obj/projectile/bullet/reusable/arrow/poison
	name = "poison iron arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	poisontype = /datum/reagent/stampoison
	poisonamount = 2
	slur = 10
	eyeblur = 10
	drowsy = 5
	icon_state = "arrowpoison_proj"

/obj/projectile/bullet/reusable/arrow/poison/stone
	name = "poison stone arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone

//SILVER AMMO
/obj/item/ammo_casing/caseless/rogue/arrow/silver
	name = "silver arrow"
	icon_state = "silvarrow"
	desc = "A masterworked arrow; boswellia wood, lovingly carved into a javelin \
	that has been fitted with a spearhead of silver. It is expensive, yet unrivaled \
	in power - pray that you have the will to see its aim unfettered-and-true."
	projectile_type = /obj/projectile/bullet/reusable/arrow/silver
	is_silver = FALSE //Give these to the bad guys, if you want to be a little evil. Realistically wouldn't blight someone, unless they're touching the tip.

/obj/projectile/bullet/reusable/arrow/silver
	name = "silver arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/silver
	damage = 60 //The rarest, but most powerful arrow subtype. Intended to be incredibly scarce, in practice - a 'silver bullet', to the most literal extent.
	armor_penetration = PEN_HEAVY
	embedchance = 100
	poisontype = /datum/reagent/water/blessed
	poisonamount = 7
	npc_simple_damage_mult = 7 //..or 420 damage against a mindless mob. Strike true; reduce if these become craftable or more easily acquirable, through any means.


/obj/item/ammo_casing/caseless/rogue/arrow/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -7,"nx" = 13,"ny" = -7,"wx" = -8,"wy" = -7,"ex" = 5,"ey" = -7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/*
 * ELEMENTAL ARROWS - Created by coating iron broadheads with a runic tincture flask.
 * Non-reusable (use /obj/projectile/bullet/arrow/, not /reusable/).
 * Reduced damage compared to iron broadhead, same weight, with on_hit rider effects.
 */

/obj/item/ammo_casing/caseless/rogue/arrow/elemental
	name = "elemental arrow"
	desc = "An iron broadhead arrow coated with an alchemical tincture."
	icon = 'icons/roguetown/weapons/ranged/arrow_mob.dmi'
	caliber = "arrow"
	ammo_weight = 1
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)

/obj/projectile/bullet/arrow/elemental
	name = "elemental arrow"
	damage = 40
	damage_type = BRUTE
	armor_penetration = PEN_LIGHT
	flag = "slash"
	icon = 'icons/roguetown/weapons/ranged/arrow_proj.dmi'
	icon_state = "arrowpyro_proj"
	range = 15
	embedchance = 15
	woundclass = BCLASS_PIERCE
	speed = 1.25
	min_range = MIN_ARROW_RANGE
	max_range = MAX_ARROW_RANGE
	dam_falloff_factor = DAM_FALLOFF_ARROW

// --- FIRE ---
/obj/item/ammo_casing/caseless/rogue/arrow/elemental/fire
	name = "fire arrow"
	desc = "An iron broadhead drenched in a flammable tincture. It smolders faintly."
	projectile_type = /obj/projectile/bullet/arrow/elemental/fire
	icon_state = "arrow_pyroclastic"

/obj/projectile/bullet/arrow/elemental/fire
	name = "fire arrow"
	icon_state = "arrowpyro_proj"

/obj/projectile/bullet/arrow/elemental/fire/on_hit(atom/target)
	..()
	if(!ismob(target))
		return
	var/mob/living/M = target
	M.adjust_fire_stacks(2)
	M.adjustFireLoss(5)
	M.ignite_mob()

// --- FROST --- (Pending PR #6406 frost stack system - should apply 2 frost stacks)
/*
/obj/item/ammo_casing/caseless/rogue/arrow/elemental/frost
	name = "frost arrow"
	desc = "An iron broadhead coated in a chilling solution. Rime clings to the shaft."
	projectile_type = /obj/projectile/bullet/arrow/elemental/frost
	icon_state = "arrow_frost"

/obj/projectile/bullet/arrow/elemental/frost
	name = "frost arrow"
	icon_state = "arrowfrost_proj"

/obj/projectile/bullet/arrow/elemental/frost/on_hit(atom/target)
	..()
	if(!ismob(target))
		return
	var/mob/living/M = target
	// TODO: Replace with frost stack system from PR #6406
	// M.adjust_frost_stacks(2)
	to_chat(M, span_danger("A biting cold seeps into my flesh!"))
*/

/obj/item/ammo_casing/caseless/rogue/arrow/elemental/thunder
	name = "thunder arrow"
	desc = "An iron broadhead laced with a crackling runic solution. The arrowhead thrums with violent energy. Briefly staggers the target on impact."
	projectile_type = /obj/projectile/bullet/arrow/elemental/thunder
	icon_state = "arrow_thunder"

/obj/projectile/bullet/arrow/elemental/thunder
	name = "thunder arrow"
	damage = 30
	damage_type = BURN
	flag = "fire"
	woundclass = BCLASS_BURN
	icon_state = "arrowthunder_proj"

/obj/projectile/bullet/arrow/elemental/thunder/on_hit(atom/target)
	..()
	if(!ismob(target))
		return
	var/mob/living/M = target
	M.electrocute_act(1, src, 1, SHOCK_NOSTUN)
	M.Slowdown(1 SECONDS)
	to_chat(M, span_danger("Arcyne thunder sears through my body!"))

// --- KINETIC --- (Arcyne sprite)
// Deals 35 brute damage and knocks the target back.
/obj/item/ammo_casing/caseless/rogue/arrow/elemental/kinetic
	name = "kinetic arrow"
	desc = "An iron broadhead infused with a volatile kinetic solution. The air around it warps faintly."
	projectile_type = /obj/projectile/bullet/arrow/elemental/kinetic
	icon_state = "arrow_kinetic"

/obj/projectile/bullet/arrow/elemental/kinetic
	name = "kinetic arrow"
	damage = 35
	icon_state = "arrowkinetic_proj"

/obj/projectile/bullet/arrow/elemental/kinetic/on_hit(atom/target)
	..()
	if(!ismob(target))
		return
	var/mob/living/M = target
	var/throw_dir = get_dir(src, target)
	var/atom/throw_target = get_edge_target_turf(M, throw_dir)
	M.safe_throw_at(throw_target, 2, 1)
	to_chat(M, span_danger("A kinetic blast sends me flying!"))

/obj/item/ammo_casing/caseless/rogue/arrow/elemental/splinter
	name = "splinter arrow"
	desc = "An iron broadhead coated in a gold-tinted tincture that causes the head to fragment into shards on release. Its fletching has been removed to save on feather."
	projectile_type = /obj/projectile/bullet/arrow/elemental/splinter
	icon_state = "arrow_splinter"
	pellets = 3
	variance = 25

/obj/projectile/bullet/arrow/elemental/splinter
	name = "splinter arrow"
	damage = 25
	icon_state = "arrowsplinter_proj"
	embedchance = 40
	min_range = MIN_SPLINTER_RANGE
	max_range = MAX_SPLINTER_RANGE


/obj/item/ammo_casing/caseless/rogue/arrow/water
	name = "water arrow"
	desc = "An arrow with its tip containing a glass ampule filled with water. It will shatter on impact, useful for taking out pesky lights."
	projectile_type = /obj/projectile/bullet/arrow/water
	possible_item_intents = list(/datum/intent/mace/strike)
	caliber = "arrow"
	icon_state = "arrow_water"
	force = 0

/obj/projectile/bullet/arrow/water
	name = "water arrow"
	desc = "An arrow with its tip containing a glass ampule filled with water. It will shatter on impact, useful for taking out pesky lights."
	damage = 0
	damage_type = BRUTE
	icon = 'icons/roguetown/weapons/ranged/arrow_proj.dmi'
	icon_state = "arrowwater_proj"
	range = 15
	hitsound = 'sound/blank.ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "piercing"

/obj/projectile/bullet/arrow/water/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		for(var/obj/O in M.contents) //Checks for light sources in the mob's inventory.
			O.extinguish() //Extinguishes light sources on the mob you hit with the arrow.
	var/turf/T = get_turf(target)
	for(var/obj/O in T)
		O.extinguish()

/obj/projectile/bullet/reusable/arrow/poison/stone
	name = "stone arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone

#undef MIN_ARROW_RANGE
#undef MAX_ARROW_RANGE
#undef DAM_FALLOFF_ARROW
#undef MIN_SPLINTER_RANGE
#undef MAX_SPLINTER_RANGE
