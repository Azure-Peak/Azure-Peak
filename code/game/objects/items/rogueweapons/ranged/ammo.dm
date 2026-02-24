#define ARROW_DAMAGE		20
#define BOLT_DAMAGE			70
#define BULLET_DAMAGE		80
#define ARROW_PENETRATION	10
#define BOLT_PENETRATION	50
#define BULLET_PENETRATION	100

/**
	GENERAL NOTE FOR BALANCING PROJECTILES:
	Damage and armor penetration both factor into whether a projectile will pierce a given
	set of armour! Additionally, unlike armor penetration, damage is subject to multiplication
	from PER + damfactor modifiers. As such, always value damage much higher than armor penetration.
	If you add 5 damage in return for taking away 5 AP, you haven't given the projectile a
	mechanical trade-off, you've made it worse in an entirely linear way. It may be wiser to
	deduct 10 or 15 armor penetration in return for adding 5 damage if you want a trade-off.
*/

//parent of all bolts and arrows ฅ^•ﻌ•^ฅ
/obj/item/ammo_casing/caseless/rogue/
	firing_effect_type = null
	icon = 'icons/roguetown/weapons/ammo.dmi'

//bolts ฅ^•ﻌ•^ฅ

/obj/item/ammo_casing/caseless/rogue/bolt
	name = "bolt"
	desc = "A durable iron bolt that will pierce a skull easily."
	projectile_type = /obj/projectile/bullet/reusable/bolt
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	caliber = "regbolt"
	icon_state = "bolt"
	dropshrink = 0.6
	max_integrity = 10
	force = 10
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH

/obj/item/ammo_casing/caseless/rogue/bolt/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -6,"nx" = 11,"ny" = -6,"wx" = -4,"wy" = -6,"ex" = 2,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/ammo_casing/caseless/rogue/bolt/aalloy
	name = "decrepit bolt"
	desc = "An ancient bolt, tipped with frayed bronze. It lacks the luster that it once held, many centuries ago."
	icon_state = "ancientbolt"
	projectile_type = /obj/projectile/bullet/reusable/bolt/aalloy
	color = "#bb9696"

/obj/item/ammo_casing/caseless/rogue/bolt/paalloy
	name = "ancient bolt"
	desc = "An ancient bolt, tipped with polished gilbranze. The razor-thin tip \
	resembles a sabot more than an arrowhead; something that most alloys cannot reliably withstand."
	icon_state = "ancientbolt"
	projectile_type = /obj/projectile/bullet/reusable/bolt/paalloy

/obj/item/ammo_casing/caseless/rogue/bolt/bronze
	name = "bronze bolt"
	desc = "Bronze and wood, fitted by-hand to fashion a bolt's fuselage. The \
	design, perfected over a millennium of trial-and-error, sails with tremendous haste."
	icon_state = "bronzebolt"
	projectile_type = /obj/projectile/bullet/reusable/bolt/bronze

/obj/item/ammo_casing/caseless/rogue/bolt/blunt
	name = "blunt bolt"
	desc = "A crossbow bolt without the part that pierces skulls. That doesn't mean it won't kill you."
	projectile_type = /obj/projectile/bullet/reusable/bolt/blunt
	possible_item_intents = list(/datum/intent/mace/strike)
	icon_state = "bolt_blunt"
	force = 5

/obj/item/ammo_casing/caseless/rogue/bolt/holy
	name = "sunderbolt"
	desc = "A silver-tipped bolt, containing a small vial of holy water. Though it inflicts lesser wounds on living flesh, it exceeds when employed against the unholy; a snap and a crack, followed by a fiery surprise. </br>'One baptism for the remission of sins.'"
	projectile_type = /obj/projectile/bullet/reusable/bolt/holy
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	caliber = "regbolt"
	icon_state = "bolt_holywater"

/obj/projectile/bullet/reusable/bolt
	name = "bolt"
	damage = BOLT_DAMAGE
	damage_type = BRUTE
	armor_penetration = BOLT_PENETRATION
	icon_state = "bolt_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	speed = 0.4
	npc_simple_damage_mult = 2

/obj/item/ammo_casing/caseless/rogue/arrow/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -7,"nx" = 13,"ny" = -7,"wx" = -8,"wy" = -7,"ex" = 5,"ey" = -7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/projectile/bullet/reusable/bolt/on_hit(atom/target)
	. = ..()
	var/mob/living/L = firer
	if(!L || !L.mind)
		return
	var/skill_multiplier = 0
	if(isliving(target)) // If the target theyre shooting at is a mob/living
		var/mob/living/T = target
		if(T.stat != DEAD) // If theyre alive
			skill_multiplier = 4
	if(skill_multiplier && can_train_combat_skill(L, /datum/skill/combat/crossbows, SKILL_LEVEL_EXPERT))
		L.mind.add_sleep_experience(/datum/skill/combat/crossbows, L.STAINT * skill_multiplier)

/obj/projectile/bullet/reusable/bolt/aalloy
	damage = 40
	armor_penetration = 30
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/aalloy
	icon_state = "ancientbolt_proj"

/obj/projectile/bullet/reusable/bolt/paalloy
	damage = 65
	armor_penetration = 45
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/paalloy
	icon_state = "ancientbolt_proj"

/obj/projectile/bullet/reusable/bolt/bronze
	damage = 70
	armor_penetration = 30 //Same damage, but reduced penetration.
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/bronze
	icon_state = "bronzebolt_proj"
	npc_simple_damage_mult = 3 //More damage over simplemobs!
	speed = 0.15 // Faster!

/obj/projectile/bullet/reusable/bolt/holy
	name = "sunderbolt"
	damage = 35 //Halved damage, but same penetration.
	icon_state = "bolthwater_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/holy
	embedchance = 100
	poisontype = /datum/reagent/water/blessed
	poisonamount = 5
	npc_simple_damage_mult = 5 //175, compared to the regular bolt's 140. Slightly more damage, as to imitate its anti-unholy properties on mobs who aren't affected by any form of poison.

/obj/projectile/bullet/reusable/bolt/blunt
	damage = 25
	armor_penetration = 0
	embedchance = 0
	woundclass = BCLASS_BLUNT
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/blunt

//superbolts ฅ^•ﻌ•^ฅ

//

/obj/item/ammo_casing/caseless/rogue/heavy_bolt
	name = "heavy bolt"
	desc = "A massive steel bolt that is designed to pulverize the defenses of \
	another, whether it be a castle's parapit or a knight's plate."
	projectile_type = /obj/projectile/bullet/reusable/heavy_bolt
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	caliber = "heabolt"
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "heavybolt" //NOTE!!! FIND A WAY TO MAKE BOLTS DEAL EXTRA DAMAGE TO BARRICADES AND STRUCTURES ASAP!!! IF YOU KNOW, FEEL FREE TO PR IT ASAP!!!
	dropshrink = 0.8
	max_integrity = 15
	force = 15
	grid_height = 96 //Effectively as large as a shortsword. Two in a belt, four in a satchel. Unideal for carrying without a purpose-made pouch.
	grid_width = 32
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH //Carry it on the hip or bite down like a carrot, if you're out of options.
	equip_delay_self = 2 SECONDS //Girth. Pack a siege bolt pouch if you want to circumvent it.
	unequip_delay_self = 2 SECONDS
	inv_storage_delay = 1 SECONDS

/obj/projectile/bullet/reusable/heavy_bolt
	name = "heavy bolt"
	damage = BOLT_DAMAGE + 20 // +33% the damage.
	damage_type = BRUTE
	armor_penetration = BOLT_PENETRATION + 25 // +50% the penetrative power.
	object_damage_multiplier = 14 //Determines the multiplier that's applied to the bolt's damage value, when striking a structure. By default, it can destroy any wooden defense - a door, barricade, wall - in one shot.
	wall_impact_break_probability = 100 //Determines the chance that a bolt will destroy itself, when striking a structure. By default, it will always destroy itself after successfully impacting a wall.
	damages_turf_walls = TRUE //Determines whether the bolt can damage turfs or not. By default, yes.
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "heavybolt_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt
	range = 30
	hitsound = 'sound/combat/hits/hi_bolt (2).ogg'
	embedchance = 100
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	speed = 1.2
	npc_simple_damage_mult = 5 //..or 350 damage against mindless opponents. Run them through!

/obj/item/ammo_casing/caseless/rogue/heavy_bolt/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -6,"nx" = 11,"ny" = -6,"wx" = -4,"wy" = -6,"ex" = 2,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/projectile/bullet/reusable/heavy_bolt/on_hit(target)
	. = ..()
	var/mob/living/M = target
	if(ismob(target))
		M.visible_message(span_warning("[M] staggers back from the tremendous impact!"))
		M.apply_status_effect(/datum/status_effect/debuff/staggered, 6 SECONDS)
		M.apply_status_effect(/datum/status_effect/debuff/exposed, 6 SECONDS) //Done in conjunction with the new Feint testmerge - opens up for a single integrity-destroying attack.
		M.Slowdown(6 SECONDS)
		M.OffBalance(1 SECONDS)
		M.Immobilize(1 SECONDS)
		return

	var/turf/T = target
	if(isturf(target))
		explosion(T, heavy_impact_range = 0, light_impact_range = 1, flame_range = 0, smoke = FALSE, soundin = pick('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg'))
		return

/obj/item/ammo_casing/caseless/rogue/heavy_bolt/blunt
	name = "blunt heavy bolt"
	desc = "Ostensibly, these wrought-iron siegebolts are meant for the calibration of a siegebow's ever-particular mechanisms. In practice, besieged artificers have discovered another use for these ten-kilogram battering rams."
	possible_item_intents = list(/datum/intent/mace/strike)
	icon_state = "bluntheavybolt"
	projectile_type = /obj/projectile/bullet/reusable/heavy_bolt/blunt

/obj/projectile/bullet/reusable/heavy_bolt/blunt
	name = "blunt heavy bolt"
	armor_penetration = 0
	embedchance = 0 //'If you're reading this, duck!'
	woundclass = BCLASS_BLUNT
	flag = "blunt"
	icon_state = "heavybolt_proj"

/obj/item/ammo_casing/caseless/rogue/heavy_bolt/aalloy
	name = "decrepit heavy bolt"
	desc = "A length of frayed bronze, quilled to take flight and tear down the living. \
	Metal flakes occassionally peel off from its core, mysteriously hovering about - \
	tolerable by the undying, but unbearibly noxious to the living."
	icon_state = "ancientheavybolt"
	projectile_type = /obj/projectile/bullet/reusable/heavy_bolt/aalloy
	color = "#bb9696"

/obj/projectile/bullet/reusable/heavy_bolt/aalloy
	name = "decrepit heavy bolt"
	damage = BOLT_DAMAGE - 10
	object_damage_multiplier = 20 //Ensures the bolt can still, at a minimum, destroy most wooden barricades and doors in one shot.
	icon_state = "ancientbolt_proj"
	poisontype = /datum/reagent/stampoison
	poisonamount = 1 //You are, in essence, giving them tenantus.
	slur = 2
	eyeblur = 2
	drowsy = 2

/obj/item/ammo_casing/caseless/rogue/heavy_bolt/paalloy
	name = "ancient heavy bolt"
	desc = "A polished length of gilbranze, which chisels away stone-and-spirit alike with each vaulting. It whispers to you; a half-glance to the right, further up to compensate, so that the living's humors may taste utter disruption."
	icon_state = "ancientheavybolt"
	projectile_type = /obj/projectile/bullet/reusable/heavy_bolt/paalloy

/obj/projectile/bullet/reusable/heavy_bolt/paalloy
	name = "ancient heavy bolt"
	icon_state = "ancientbolt_proj"
	object_damage_multiplier = 16
	poisontype = /datum/reagent/stampoison
	poisonamount = 1 //You are, in essence, giving them tenantus. Roughly 50% stronger than a poisoned iron arrow.
	slur = 3
	eyeblur = 3
	drowsy = 3

/obj/item/ammo_casing/caseless/rogue/heavy_bolt/bronze
	name = "bronze heavy bolt"
	desc = "A siege-weapon's most treasured compatriot, fitted with a surprisingly light spearhead of bronze. It screams through the air, releasing a haunting whistle that's purported to be purpose-made; an added caveat to wither away the wits of a besieged defender."
	icon_state = "bronzeheavybolt"
	projectile_type = /obj/projectile/bullet/reusable/heavy_bolt/bronze

/obj/projectile/bullet/reusable/heavy_bolt/bronze
	name = "bronze heavy bolt"
	icon_state = "bronzebolt_proj"
	speed = 0.8

//

//arrows ฅ^•ﻌ•^ฅ

/obj/item/ammo_casing/caseless/rogue/arrow
	name = "arrow"
	desc = "Some devices are so simple in their nature and austere in their scope \
	that they feel as if they've sprung into being without mortal intervention. \
	Consult your gods."
	projectile_type = /obj/projectile/bullet/reusable/arrow
	caliber = "arrow"
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
	name = "bronze arrow"
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
	damage = ARROW_DAMAGE
	damage_type = BRUTE
	npc_simple_damage_mult = 2
	armor_penetration = ARROW_PENETRATION
	//accuracy = 65 // Default defined by projectile.dm
	icon_state = "arrow_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 25
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	speed = 0.4

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
	armor_penetration = 0
	embedchance = 0
	woundclass = BCLASS_BLUNT

/obj/projectile/bullet/reusable/arrow/stone
	name = "stone arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	accuracy = 60

// Broadheads are high damage, low AP. Shouldn't be penetrating 80 pierce armor (padded gambesons)
// short of either being used in a longbow, or by an incredibly high perception character!
// At 15PER with a recurve, penetrates just short of 70 pierce armour, and cannot realistically allpen.
/obj/projectile/bullet/reusable/arrow/iron
	name = "broadhead arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron
	damage = 35
	armor_penetration = 15 // Pierces 80 (padded gambesons) at 19PER, 16PER with a longbow.
	embedchance = 30
	npc_simple_damage_mult = 2

// Gains 5 damage, loses 10 AP.
/obj/projectile/bullet/reusable/arrow/iron/aalloy
	name = "decrepit broadhead arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy
	icon_state = "ancientarrow_proj"
	damage = 40
	armor_penetration = 5 // Pierces 80 (padded gambesons) at 19PER, 16PER with a longbow.
	embedchance = 40

// Bodkins should penetrate essentially any armour in the game with decent perception, as
// recompense for their very low damage. Better for lower perception characters without
// enough raw damage to consistently penetrate armour.
/obj/projectile/bullet/reusable/arrow/steel
	name = "bodkin arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/steel
	accuracy = 75
	damage = 25
	armor_penetration = 55 // Pierces 80 (padded gambesons) with a recurve at 11PER.
	embedchance = 80 // Easy embeds!
	npc_simple_damage_mult = 3

// Significantly worse armour-piercing, slightly more damage. Should still penetrate most things.
// Note that it's pretty likely the skeleton using these has a longbow, which penetrates more stuff.
/obj/projectile/bullet/reusable/arrow/steel/paalloy
	name = "ancient bodkin arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/steel/paalloy
	icon_state = "ancientarrow_proj"
	damage = 30
	armor_penetration = 35 // Pierces 80 (padded gambesons) with a recurve at 15PER.
	embedchance = 60

// Non-existent AP, but strong damage, a high embed chance, and very fast projectiles.
// Will have to see how this one plays out - may be a utility pick for chasedowns?
/obj/projectile/bullet/reusable/arrow/bronze
	name = "bronze arrow"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/bronze
	icon_state = "bronzearrow_proj"
	damage = 40
	armor_penetration = 0 // Cannot pierce 80 (padded gambesons) with a recurve, does so at 17PER with a longbow.
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
	armor_penetration = 60
	embedchance = 100
	poisontype = /datum/reagent/water/blessed
	poisonamount = 7
	npc_simple_damage_mult = 7 //..or 420 damage against a mindless mob. Strike true; reduce if these become craftable or more easily acquirable, through any means.

/obj/item/ammo_casing/caseless/rogue/bolt/silver
	name = "silver bolt"
	desc = "A masterworked bolt of silver, fitted to a winged rod of boswellia wood. Expensive, yet uncompromisingly lethal; the final adjucation of abberants, delivered from afar. </br>'Non timebo mala..' - '..I will fear no evil.'"
	projectile_type = /obj/projectile/bullet/reusable/bolt/silver
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	caliber = "regbolt"
	icon_state = "silvbolt"
	is_silver = FALSE //Ditto.

/obj/projectile/bullet/reusable/bolt/silver
	name = "silver bolt"
	damage = 80 //One shot. Make it count. Pray your aim is true - and that whoever's on the other side isn't packing a shield or knows how to sidestep.
	armor_penetration = 80
	icon_state = "silvbolt_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/silver
	embedchance = 100
	npc_simple_damage_mult = 6 //..or 480 damage against a mindless mob. Only if you're desperate.
	poisontype = /datum/reagent/water/blessed
	poisonamount = 7

/obj/item/ammo_casing/caseless/rogue/heavy_bolt/silver
	name = "heavy silver bolt"
	desc = "A silvered lance, poised to impale the unimaginable. You feel the hands of another guiding your own, as you prepare to load; may it be guidence from a higher power, or your wit upon the verge of breaking? </br>'God, please..'"
	projectile_type = /obj/projectile/bullet/reusable/heavy_bolt/silver
	icon_state = "silvheavybolt"
	max_integrity = 30
	force = 12
	is_silver = TRUE

/obj/projectile/bullet/reusable/heavy_bolt/silver
	name = "heavy silver bolt"
	damage = BOLT_DAMAGE + 30
	armor_penetration = 777 //Same damage, but with absolute penetration. 
	ammo_type = /obj/item/ammo_casing/caseless/rogue/heavy_bolt/silver
	icon_state = "silvheavybolt_proj"
	hitsound = 'sound/combat/hits/hi_bolt (3).ogg'
	speed = 0.8 //Same speed as a crossbow bolt. 
	poisontype = /datum/reagent/water/blessed
	poisonamount = 10
	npc_simple_damage_mult = 10 //..or 1000 damage against a mindless mob. If you're using this against one, you're either a fool or have no other choice left. Godspeed.

// PYRO AMMO
/obj/item/ammo_casing/caseless/rogue/bolt/pyro
	name = "pyroclastic bolt"
	desc = "A bolt smeared with a flammable tincture."
	projectile_type = /obj/projectile/bullet/bolt/pyro
	possible_item_intents = list(/datum/intent/mace/strike)
	icon_state = "bolt_pyroclastic"

/obj/projectile/bullet/bolt/pyro
	name = "pyroclastic bolt"
	desc = "A bolt smeared with a flammable tincture."
	damage = 20
	icon_state = "boltpyro_proj"
	hitsound = 'sound/blank.ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT

/obj/projectile/bullet/bolt/pyro/on_hit(target)
	..()
	if(!ismob(target))
		return
	var/mob/living/M = target
	M.adjust_fire_stacks(6)
	M.adjustFireLoss(15)
	M.ignite_mob()

/obj/item/ammo_casing/caseless/rogue/bolt/water
	name = "water bolt"
	desc = "A bolt with its tip containing a glass ampule filled with water. It will shatter on impact, useful for taking out pesky lights."
	projectile_type = /obj/projectile/bullet/bolt/water
	possible_item_intents = list(/datum/intent/mace/strike)
	caliber = "regbolt"
	icon_state = "bolt_water"
	force = 0

/obj/projectile/bullet/bolt/water
	name = "water bolt"
	desc = "A bolt with its tip containing a glass ampule filled with water. It will shatter on impact, useful for taking out pesky lights."
	damage = 0
	damage_type = BRUTE
	icon_state = "boltwater_proj"
	range = 15
	hitsound = 'sound/blank.ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "piercing"
	var/explode_sound = list('sound/misc/explode/incendiary (1).ogg','sound/misc/explode/incendiary (2).ogg')
	//explosion values
	var/exp_heavy = 0
	var/exp_light = 0
	var/exp_flash = 0
	var/exp_fire = 1

/obj/projectile/bullet/bolt/water/on_hit(target)
	. = ..()
	if(ismob(target))
		var/mob/living/M = target
		for(var/obj/O in M.contents) //Checks for light sources in the mob's inventory
			O.extinguish() //Extinguishes light sources on the mob you hit with the arrow.
	var/turf/T = get_turf(target)
	for(var/obj/O in T)
		O.extinguish()

//pyro arrows
/obj/item/ammo_casing/caseless/rogue/arrow/pyro
	name = "pyroclastic arrow"
	desc = "An arrow with its tip drenched in a flammable tincture."
	projectile_type = /obj/projectile/bullet/arrow/pyro
	possible_item_intents = list(/datum/intent/mace/strike)
	caliber = "arrow"
	icon_state = "arrow_pyroclastic"

/obj/projectile/bullet/arrow/pyro
	name = "pyroclastic arrow"
	desc = "An arrow with its tip drenched in a flammable tincture."
	damage = 15
	icon_state = "arrowpyro_proj"
	hitsound = 'sound/blank.ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT

/obj/projectile/bullet/arrow/pyro/on_hit(target)
	..()
	if(!ismob(target))
		return
	var/mob/living/M = target
	M.adjust_fire_stacks(4)
	M.adjustFireLoss(10)
	M.ignite_mob()

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

// GUNPOWDER AMMO
/obj/projectile/bullet/reusable/bullet
	name = "lead ball"
	damage = BULLET_DAMAGE
	damage_type = BRUTE
	icon_state = "musketball_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bullet
	range = 30
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	armor_penetration = BULLET_PENETRATION
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
	armor_penetration = 25
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/stone
	embedchance = 100
	speed = 2 // I guess slower to be slightly more forgiving to players since they're otherwise aimbots

/obj/projectile/bullet/reusable/arrow/ancient
	damage = 10
	armor_penetration = 25
	ammo_type = /obj/item/ammo_casing/caseless/rogue/arrow/iron/aalloy
	embedchance = 100
	speed = 2 // I guess slower to be slightly more forgiving to players since they're otherwise aimbots

//deep one thrown stone
/obj/projectile/bullet/reusable/deepone
	name = "stone"
	damage = 25
	damage_type = BRUTE
	armor_penetration = 30
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stone1"
	ammo_type = /obj/item/natural/stone
	range = 15
	hitsound = 'sound/combat/hits/blunt/bluntsmall (1).ogg'
	embedchance = 50
	woundclass = BCLASS_BLUNT
	flag = "piercing"
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

//Javelins - Basically spears, but to get them working as proper javelins and able to fit in a bag, they are 'ammo'. (Maybe make an atlatl later?)
//Only ammo casing, no 'projectiles'. You throw the casing, as weird as it is.
/obj/item/ammo_casing/caseless/rogue/javelin
	force = 14
	throw_speed = 4	
	name = "iron javelin"
	desc = "A tool used for centuries, as early as recorded history. This one is tipped with a iron head; standard among militiamen and irregulars alike."
	icon_state = "ijavelin"
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	armor_penetration = 40					//Redfined because.. it's not a weapon, it's an 'arrow' basically.
	max_integrity = 50						//Breaks semi-easy, stops constant re-use.
	wdefense = 3							//Worse than a spear
	thrown_bclass = BCLASS_STAB				//Knives are slash, lets try out stab and see if it's too strong in terms of wounding.
	throwforce = 25							//throwing knife is 22, slightly better for being bulkier.
	possible_item_intents = list(/datum/intent/sword/thrust, /datum/intent/spear/bash, /datum/intent/spear/cut)	//Sword-thrust to avoid having 2 reach.
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 35, "embedded_fall_chance" = 10)	//Better than iron throwing knife by 10%
	anvilrepair = /datum/skill/craft/weaponsmithing
	associated_skill = /datum/skill/combat/polearms
	heavy_metal = FALSE						//Stops spin animation, maybe.
	thrown_damage_flag = "piercing"			//Checks peircing protection.

/obj/item/ammo_casing/caseless/rogue/javelin/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/ammo_casing/caseless/rogue/javelin/aalloy
	name = "decrepit javelin"
	desc = "A missile of frayed bronze. Before you is your weapon; that which rose Man out of the mud, and brought the Beasts of Old Syon to heel. When were you last aware of any other part of you? Do you recall seeing the world in any other way?"
	icon_state = "ajavelin"
	throwforce = 20
	force = 10
	color = "#bb9696"
	embedding = list("embedded_pain_multiplier" = 6, "embed_chance" = 65, "embedded_fall_chance" = 5)
	smeltresult = null // Override iron inherit
	anvilrepair = null

/obj/item/ammo_casing/caseless/rogue/javelin/bronze
	name = "bronze javelin"
	desc = "A tool used for centuries, as early as recorded history. This one is tipped with a bronze head, wide and serrated - a death knell to the unarmored, and a staggering wound to the beplated."
	icon_state = "bjavelin"
	force = 20
	throwforce = 36	//Devastating against unarmored foes, but with nearly halved armor penetration.
	armor_penetration = 30
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 80, "embedded_fall_chance" = 5)
	thrown_bclass = BCLASS_PICK	
	smeltresult = null // 1 Ingot = 2 Javelins

/obj/item/ammo_casing/caseless/rogue/javelin/steel
	force = 16
	armor_penetration = 50
	name = "steel javelin"
	desc = "A tool used for centuries, as early as recorded history. This one is tipped with a steel head; perfect for piercing armor!"
	icon_state = "javelin"
	max_integrity = 100						//In-line with other stabbing weapons.
	throwforce = 28							//Equal to steel knife BUT this has peircing damage type so..
	thrown_bclass = BCLASS_PICK				//Bypasses crit protection better than stabbing. Makes it better against heavy-targets.
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 45, "embedded_fall_chance" = 10) //Better than steel throwing knife by 10%
	smeltresult = null // 1 Ingot = 2 Javelins

/obj/item/ammo_casing/caseless/rogue/javelin/steel/paalloy
	name = "ancient javelin"
	desc = "A missile of polished gilbranze. Old Syon had drowned beneath His tears, and Her ascension had brought forth this world's end - so that You, with the killing blow, could become God."
	icon_state = "ajavelin"
	smeltresult = null // 1 Ingots = 2 Javelins

/obj/item/ammo_casing/caseless/rogue/javelin/silver
	name = "silver javelin"
	desc = "A tool used for centuries, as early as recorded history. This one appears to be tipped with a silver head. Decorative, perhaps.. or for some sort of specialized hunter."
	icon_state = "sjavelin"
	is_silver = TRUE
	throwforce = 25							//Less than steel because it's.. silver. Good at killing vampires/WW's still.
	armor_penetration = 60
	thrown_bclass = BCLASS_PICK				//Bypasses crit protection better than stabbing. Makes it better against heavy-targets.
	smeltresult = /obj/item/ingot/silver // 2 ingots = 2 javelins so this can smelt.

/obj/item/ammo_casing/caseless/rogue/javelin/silver/ComponentInitialize()
	. = ..()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = -3,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 3,\
	)

//Snowflake code to make sure the silver-bane is applied on hit to targeted mob. Thanks to Aurorablade for getting this code to work.
/obj/item/ammo_casing/caseless/rogue/javelin/silver/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(!iscarbon(hit_atom))
		return//abort

//sling bullets
/obj/item/ammo_casing/caseless/rogue/sling_bullet //parent of sling ammo and the temporary sling bullet for stones. shouldn't ever be seen
	name = "soaring stone"
	desc = "You shouldn't be seeing this."
	projectile_type = /obj/projectile/bullet/sling_bullet
	caliber = "slingbullet"
	icon_state = "stone_sling_bullet"
	force = 5
	throwforce = 20 //you can still throw them
	dropshrink = 0.6
	possible_item_intents = list(INTENT_GENERIC) //not intended to attack with them
	slot_flags = ITEM_SLOT_MOUTH
	max_integrity = 20

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

/obj/item/ammo_casing/caseless/rogue/sling_bullet/steel
	name = "steel sling bullet"
	desc = "Not to be mistaken with an actual bullet. </br>'As one who binds a stone in a sling, so is he who gives honor to a fool.'"
	projectile_type = /obj/projectile/bullet/reusable/sling_bullet/steel
	icon_state = "steel_sling_bullet"

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
	damage = 30 //Parity check.
	damage_type = BRUTE
	armor_penetration = 0
	npc_simple_damage_mult = 2
	icon = 'icons/roguetown/weapons/ammo.dmi'
	icon_state = "stone_sling_bullet"
	range = 15
	hitsound = 'sound/combat/hits/blunt/bluntsmall (1).ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "piercing"
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
	damage = 30 //Parity check.
	damage_type = BRUTE
	armor_penetration = 0
	icon_state = "slingbullet_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet
	range = 15
	hitsound = 'sound/combat/hits/blunt/bluntsmall (1).ogg'
	embedchance = 0
	woundclass = BCLASS_BLUNT
	flag = "piercing"
	speed = 0.4
	npc_simple_damage_mult = 2.5 // Deals roughly ~75-95 damage against a simplemob, compared to the ~140 damage of a crossbolt or arrow.
	ricochets_max = 4
	ricochet_chance = 80
	ricochet_auto_aim_angle = 40
	ricochet_auto_aim_range = 5
	ricochet_incidence_leeway = 40
	ricochet_decay_chance = 1
	ricochet_decay_damage = 2 /// stronger with every bounce, fuck it

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
	damage = 30 //proper stones are better
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/stone

/obj/projectile/bullet/reusable/sling_bullet/aalloy
	name = "decrepit sling bullet"
	damage = 15
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/aalloy

/obj/projectile/bullet/reusable/sling_bullet/bronze
	name = "bronze sling bullet"
	damage = 35
	armor_penetration = 20 //Slightly more damage, but with -33% AP.
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/bronze
	speed = 0.15 // Faster!

/obj/projectile/bullet/reusable/sling_bullet/iron
	name = "iron sling bullet"
	damage = 30
	armor_penetration = 30
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/iron

/obj/projectile/bullet/reusable/sling_bullet/steel
	name = "steel sling bullet"
	damage = 40 //Best-of-the-best. Harder to mass-produce, however.
	armor_penetration = 40
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/steel

/obj/projectile/bullet/reusable/sling_bullet/paalloy
	name = "ancient sling bullet"
	damage = 35 // Best of both worlds 'cuz why not
	armor_penetration = 30
	ammo_type = /obj/item/ammo_casing/caseless/rogue/sling_bullet/paalloy
	ricochets_max = 6

#undef ARROW_DAMAGE
#undef BOLT_DAMAGE
#undef BULLET_DAMAGE
#undef ARROW_PENETRATION
#undef BOLT_PENETRATION
#undef BULLET_PENETRATION
