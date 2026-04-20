#define MIN_BOLT_RANGE		2
#define MAX_BOLT_RANGE		9
#define DAM_FALLOFF_BOLT	0.75
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

/obj/item/ammo_casing/caseless/rogue/bolt/light
	name = "light bolt"
	desc = "A lighter, far less sturdier bolt. Made for smaller crossbows."
	icon_state = "light_bolt"
	caliber = "lightbolt"
	projectile_type = /obj/projectile/bullet/reusable/bolt/light

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
	damage = 70
	damage_type = BRUTE
	armor_penetration = PEN_HEAVY // Meant to punch through plate without issue
	icon_state = "bolt_proj"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt
	range = 15
	hitsound = 'sound/combat/hits/hi_arrow2.ogg'
	embedchance = 100
	woundclass = BCLASS_PIERCE
	flag = "piercing"
	speed = 0.4
	npc_simple_damage_mult = 2
	min_range = MIN_BOLT_RANGE
	max_range = MAX_BOLT_RANGE
	dam_falloff_factor = DAM_FALLOFF_BOLT


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

/obj/projectile/bullet/reusable/bolt/light
	name = "light bolt"
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/light
	speed = 0.8
	min_range = MIN_BOLT_RANGE - 1 // pointblank
	max_range = MAX_BOLT_RANGE - 1
	dam_falloff_factor = DAM_FALLOFF_BOLT

/obj/projectile/bullet/reusable/bolt/aalloy
	damage = 40
	armor_penetration = PEN_MEDIUM
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/aalloy
	icon_state = "ancientbolt_proj"

/obj/projectile/bullet/reusable/bolt/paalloy
	damage = 60
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/paalloy
	icon_state = "ancientbolt_proj"

/obj/projectile/bullet/reusable/bolt/bronze
	damage = 70
	armor_penetration = PEN_MEDIUM
	ammo_type = /obj/item/ammo_casing/caseless/rogue/bolt/bronze
	icon_state = "bronzebolt_proj"
	npc_simple_damage_mult = 3
	speed = 0.15

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
	armor_penetration = PEN_NONE
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
	damage = 90 // +20 damage over the regular bolt
	damage_type = BRUTE
	armor_penetration = PEN_BSTEEL
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
	min_range = MIN_BOLT_RANGE + 2
	max_range = MAX_BOLT_RANGE + 3

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
	armor_penetration = PEN_NONE
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
	damage = 60
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
	armor_penetration = PEN_BSTEEL
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
	damage = 110
	armor_penetration = PEN_BSTEEL 
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


#undef MIN_BOLT_RANGE
#undef MAX_BOLT_RANGE
#undef DAM_FALLOFF_BOLT
