//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/axe/cut
	name = "cut"
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("cuts", "slashes")
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	animname = "cut"
	penfactor = 20
	chargetime = 0
	item_d_type = "slash"

/datum/intent/axe/chop
	name = "chop"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("chops", "hacks")
	animname = "chop"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 35
	swingdelay = 10
	clickcd = 14
	item_d_type = "slash"

/datum/intent/axe/chop/scythe
	reach = 2

/datum/intent/axe/chop/stone
	penfactor = 5

/datum/intent/axe/chop/battle
	damfactor = 1.2 //36 on battleaxe
	penfactor = 40

/datum/intent/axe/chop/battle/halberd
	damfactor = 1.3
	swingdelay = 12
	penfactor = 20

/datum/intent/axe/cut/battle
	penfactor = 25

/datum/intent/axe/bash
	name = "bash"
	icon_state = "inbash"
	attack_verb = list("bashes", "clubs")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 5
	damfactor = NONBLUNT_BLUNT_DAMFACTOR // Not a real blunt weapon, so less damage.
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

//axe objs ฅ^•ﻌ•^ฅ

/obj/item/rogueweapon/stoneaxe
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 18
	force_wielded = 20
	possible_item_intents = list(/datum/intent/axe/chop/stone)
	name = "stone axe"
	desc = "A rough stone axe. Badly balanced."
	icon_state = "stoneaxe"
	icon = 'icons/roguetown/weapons/axes32.dmi'
	item_state = "axe"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	//dropshrink = 0.75
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/skill/combat/axes
	max_blade_int = 100
	minstr = 8
	wdefense = 1
	demolition_mod = 2
	w_class = WEIGHT_CLASS_BULKY
	wlength = WLENGTH_SHORT
	pickup_sound = 'sound/foley/equip/rummaging-03.ogg'
	gripped_intents = list(/datum/intent/axe/chop/stone)
	resistance_flags = FLAMMABLE
	special = /datum/special_intent/axe_swing


/obj/item/rogueweapon/stoneaxe/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,
"sx" = -15,
"sy" = -12,
"nx" = 9,
"ny" = -11,
"wx" = -11,
"wy" = -11,
"ex" = 1,
"ey" = -12,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 90,
"sturn" = -90,
"wturn" = -90,
"eturn" = 90,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,
"sx" = -15,
"sy" = -1,
"nx" = 10,
"ny" = 0,
"wx" = -13,
"wy" = -1,
"ex" = 2,
"ey" = -1,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 0,
"sturn" = 0,
"wturn" = 0,
"eturn" = 0,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
	return ..()

// Battle Axe
/obj/item/rogueweapon/stoneaxe/battle
	force = 25
	force_wielded = 30
	possible_item_intents = list(/datum/intent/axe/cut/battle, /datum/intent/axe/chop/battle, /datum/intent/axe/bash, /datum/intent/sword/peel)
	wlength = WLENGTH_LONG		//It's a big battle-axe.
	name = "battle axe"
	desc = "A steel battleaxe of war. Has a wicked edge."
	icon_state = "battleaxe"
	max_blade_int = 300
	smeltresult = /obj/item/ingot/steel
	smelt_bar_num = 2
	gripped_intents = list(/datum/intent/axe/cut/battle ,/datum/intent/axe/chop/battle, /datum/intent/axe/bash, /datum/intent/sword/peel)
	minstr = 9
	wdefense = 4

/obj/item/rogueweapon/stoneaxe/battle/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 1,"sy" = -5,"nx" = -6,"ny" = -3,"wx" = 3,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = 47,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 8)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
	return ..()

/obj/item/rogueweapon/stoneaxe/oath
	force = 30
	force_wielded = 40
	possible_item_intents = list(/datum/intent/axe/cut/battle, /datum/intent/axe/chop/battle, /datum/intent/axe/bash)
	name = "oath"
	desc = "A hefty, steel-forged axe marred by the touch of countless Wardens. Despite it's weathered etchings and worn grip, the blade has been honed to a razor's edge and you can see your reflection in the finely polished metal."
	icon_state = "oath"
	icon = 'icons/roguetown/weapons/64.dmi'
	max_blade_int = 500
	dropshrink = 0.75
	wlength = WLENGTH_LONG
	slot_flags = ITEM_SLOT_BACK
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	smeltresult = /obj/item/ingot/steel
	gripped_intents = list(/datum/intent/axe/cut/battle ,/datum/intent/axe/chop/battle, /datum/intent/axe/bash)
	minstr = 12
	wdefense = 5

/obj/item/rogueweapon/stoneaxe/oath/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -8,"sy" = -1,"nx" = 9,"ny" = -1,"wx" = -4,"wy" = -1,"ex" = 3,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -45,"sturn" = 45,"wturn" = 45,"eturn" = -45,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0,"wielded")
			if("wielded")
				return list("shrink" = 0.5,"sx" = 4,"sy" = -4,"nx" = -6,"ny" = -3,"wx" = -8,"wy" = -4,"ex" = 8,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0,"onback")
			if("onbelt")
				return list("shrink" = 0.5,"sx" = 1,"sy" = -1,"nx" = 1,"ny" = -1,"wx" = 4,"wy" = -1,"ex" = -1,"ey" = -1,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0,)

/obj/item/rogueweapon/stoneaxe/woodcut
	name = "axe"
	force = 20
	force_wielded = 26
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/sword/peel)
	desc = "A regular iron woodcutting axe."
	icon_state = "axe"
	max_blade_int = 400
	smeltresult = /obj/item/ingot/iron
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/sword/peel)
	wdefense = 2

/obj/item/rogueweapon/stoneaxe/woodcut/aaxe
	name = "decrepit axe"
	desc = "A hatchet of frayed bronze. It reigns from a tyme before the Comet Syon's impact; when Man wrought metal not to spill blood, but to better shape the world in His image."
	icon_state = "ahandaxe"
	force = 17
	force_wielded = 20
	max_integrity = 180
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/stoneaxe/hurlbat
	name = "hurlbat"
	desc = "With the sleek, lightweight design of a tossblade, and the stopping power of a battleaxe, the hurlbat's tricky design allows it to strike its targets with deadly efficiency. Although its historic origin is disputed, it is often-seen amongst Varangian Bounty-Hunters and ruthless Steppesmen."
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	wbalance = WBALANCE_SWIFT
	minstr = 13 //Better hit those weights or go back to tossblades chuddy!
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	grid_height = 64
	grid_width = 32
	force = 20
	throwforce = 32 //You ever had an axe thrown at you? 
	throw_speed = 6 //Batarangs, baby.
	max_integrity = 50 //Brittle design, hits hard, breaks quickly.
	armor_penetration = 40 //On-par with steel tossblades. 
	wdefense = 1
	icon_state = "hurlbat"
	embedding = list("embedded_pain_multiplier" = 6, "embed_chance" = 50, "embedded_fall_chance" = 30) //high chance at embed, high chance to fall out on its own.
	possible_item_intents = list(/datum/intent/axe/chop/stone)
	gripped_intents = null
	sellprice = 1
	thrown_damage_flag = "piercing"		//Checks piercing type like an arrow.

/obj/item/rogueweapon/stoneaxe/hurlbat/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -6,"nx" = 11,"ny" = -3,"wx" = -4,"wy" = -3,"ex" = 5,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/stoneaxe/battle/abyssoraxe
	name = "Tidecleaver"
	desc = "An axe made in image and inspiration of the rumored Tidecleaver, an axe capable of parting the ocean itself. The steel hums the crash of waves."
	icon_state = "abyssoraxe"
	icon = 'icons/roguetown/weapons/axes32.dmi'
	max_integrity = 400 // higher int than usual
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/mace/warhammer/pick, /datum/intent/axe/bash)
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/sword/peel, /datum/intent/axe/bash)

//Pickaxe-axe ; Technically both a tool and a weapon, but it goes here due to weapon function. Subtype of woodcutter axe, mostly a weapon.
/obj/item/rogueweapon/stoneaxe/woodcut/pick
	name = "Pulaski axe"
	desc = "An odd mix of a pickaxe front and a hatchet blade back, capable of being switched between."
	icon_state = "paxe"
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/mace/warhammer/pick, /datum/intent/axe/bash)
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/mace/warhammer/pick, /datum/intent/axe/bash)
	smeltresult = /obj/item/ingot/steel
	wlength = WLENGTH_NORMAL
	toolspeed = 2

/obj/item/rogueweapon/stoneaxe/woodcut/wardenpick
	name = "Wardens' axe"
	desc = "A multi-use axe smithed by the Wardens since time immemorial for both it's use as a tool and a weapon."
	icon_state = "wardenpax"
	force = 22
	force_wielded = 28
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/mace/warhammer/pick, /datum/intent/axe/bash)
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/mace/warhammer/pick, /datum/intent/axe/bash)
	smeltresult = /obj/item/ingot/steel
	wlength = WLENGTH_NORMAL
	toolspeed = 2


// Copper Hatchet
/obj/item/rogueweapon/stoneaxe/handaxe/copper
	force = 13
	name = "copper hatchet"
	desc = "A copper hand axe. It is not very durable."
	max_integrity = 100 // Half of the norm
	icon_state = "chatchet"
	smeltresult = /obj/item/ingot/copper
	throwforce = 20 //You ever had an axe thrown at you? 
	throw_speed = 3 
	armor_penetration = 20

/obj/item/rogueweapon/stoneaxe/handaxe
	force = 19
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/sword/peel)
	name = "hatchet"
	desc = "An iron hand axe."
	icon_state = "hatchet"
	minstr = 1
	max_blade_int = 400
	smeltresult = /obj/item/ingot/iron
	gripped_intents = null
	wdefense = 2
	throwforce = 25 //You ever had an axe thrown at you? 
	throw_speed = 3 
	armor_penetration = 25
	

/obj/item/rogueweapon/stoneaxe/woodcut/bronze
	name = "bronze axe"
	icon_state = "bronzeaxe"
	desc = "An antiquital handstaff, fitted with a bronze axhead. Such a tool once allowed humenity to carve civilization out of Psydonia's wildernesses; now, it's a rare sight beyond the Deadland's nomadic barbarian-tribes."
	force = 23 //Basic balance idea. Damage's between iron and steel, but with a sharper edge than steel. Probably not historically accurate, but we're here to have fun.
	force_wielded = 27
	max_blade_int = 550
	smeltresult = /obj/item/ingot/bronze
	wdefense = 2
	armor_penetration = 22 //In-between a hurblat and hatchet. Far harder to reproduce.
	throwforce = 32
	throw_speed = 6
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 33, "embedded_fall_chance" = 2)

/obj/item/rogueweapon/stoneaxe/woodcut/steel
	name = "steel axe"
	icon_state = "saxe"
	desc = "A steel woodcutting axe. Performs much better than its iron counterpart."
	force = 26
	force_wielded = 28
	max_blade_int = 500
	smeltresult = /obj/item/ingot/steel
	wdefense = 3

/obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
	name = "ancient alloy axe"
	desc = "A hatchet of polished gilbranze. Vheslyn molested the hearts of Man with sin - of greed towards the better offerings, and of lust for His divinity. With a single blow, blood gouted from bone and seeped into the soil; the first murder."
	icon_state = "ahandaxe"
	smeltresult = /obj/item/ingot/aaslag

/datum/intent/axe/cut/long
	reach = 2

/datum/intent/axe/chop/long
	reach = 2

/obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter
	name = "woodcutter's axe"
	icon = 'icons/roguetown/weapons/64.dmi'
	icon_state = "woodcutter"
	desc = "A long-handled axe with a carved grip, made of high quality wood. Perfect for those in the lumber trade."
	max_integrity = 300		//100 higher than normal; basically it's main difference.
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop, /datum/intent/axe/bash, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/axe/cut/long, /datum/intent/axe/chop/long, /datum/intent/axe/bash, /datum/intent/sword/peel)
	wlength = WLENGTH_LONG
	w_class = WEIGHT_CLASS_BULKY
	demolition_mod = 2.5			//Base is 1.25, so 25% extra. Helps w/ caprentry and building kinda.
	slot_flags = ITEM_SLOT_BACK		//Needs to go on back.
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	
/obj/item/rogueweapon/stoneaxe/woodcut/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 4,"sy" = -4,"nx" = -6,"ny" = -3,"wx" = -4,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = -33,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/stoneaxe/boneaxe
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 18
	force_wielded = 22
	possible_item_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	name = "bone axe"
	desc = "A rough axe made of bones"
	icon_state = "boneaxe"
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	//dropshrink = 0.75
	parrysound = list('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/skill/combat/axes
	max_blade_int = 100
	minstr = 8
	wdefense = 1
	w_class = WEIGHT_CLASS_BULKY
	wlength = WLENGTH_SHORT
	pickup_sound = 'sound/foley/equip/rummaging-03.ogg'
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/stoneaxe/boneaxe/getonmobprop(tag)
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -9,"sy" = -8,"nx" = 9,"ny" = -7,"wx" = -7,"wy" = -8,"ex" = 3,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -90,"eturn" = 90,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = -7,"nx" = -6,"ny" = -3,"wx" = 3,"wy" = -4,"ex" = 4,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -44,"sturn" = 45,"wturn" = 47,"eturn" = 33,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
	return ..()

/obj/item/rogueweapon/stoneaxe/woodcut/silver
	name = "silver war axe"
	desc = "A hefty battle axe, fashioned from pure silver. Even with a one-handed grasp, an efforted swing carries enough momentum to cleave through maille-and-flesh alike."
	icon_state = "silveraxe"
	force = 20
	force_wielded = 25
	possible_item_intents = list(/datum/intent/axe/cut/battle, /datum/intent/axe/chop/battle, /datum/intent/axe/bash, /datum/intent/sword/peel)
	minstr = 11
	max_blade_int = 400
	smeltresult = /obj/item/ingot/silver
	gripped_intents = null
	wdefense = 5
	is_silver = TRUE
	blade_dulling = DULLING_SHAFT_METAL

/obj/item/rogueweapon/stoneaxe/woodcut/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/stoneaxe/battle/psyaxe
	name = "psydonic war axe"
	desc = "An ornate battle axe, plated in a ceremonial veneer of silver. The premiere instigator of conflict against elven attachees."
	icon_state = "psyaxe"
	force = 20
	force_wielded = 25
	minstr = 11
	wdefense = 6
	blade_dulling = DULLING_SHAFT_METAL
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/stoneaxe/battle/psyaxe/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 1,\
	)

/obj/item/rogueweapon/stoneaxe/battle/steppesman
	name = "aavnic valaška"
	desc = "A steel axe of Aavnic make that combines a deadly weapon with a walking stick - hence its pointed end. It has a flat head that fits the hand comfortably, and it's usable for chopping and smashing. You could probably stab someone if you tried really hard."
	possible_item_intents = list(/datum/intent/axe/cut/battle, /datum/intent/axe/chop/battle, /datum/intent/mace/smash, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/axe/cut/battle ,/datum/intent/axe/chop/battle, /datum/intent/stab, /datum/intent/sword/peel)
	force_wielded = 25	//No damage changes for wielded/unwielded
	icon_state = "valaska"
	demolition_mod = 2.5
	walking_stick = TRUE

/datum/intent/axe/cut/battle/greataxe
	reach = 2

/datum/intent/axe/chop/battle/greataxe
	reach = 2

/obj/item/rogueweapon/greataxe
	force = 15
	force_wielded = 30
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, SPEAR_BASH)
	name = "greataxe"
	desc = "A iron great axe, a long-handled axe with a single blade made for ruining someone's day beyond any measure.."
	icon_state = "igreataxe"
	icon = 'icons/roguetown/weapons/64.dmi'
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	bigboy = TRUE
	gripsprite = TRUE
	wlength = WLENGTH_GREAT
	w_class = WEIGHT_CLASS_BULKY
	minstr = 11
	max_blade_int = 200
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron
	associated_skill = /datum/skill/combat/axes
	wdefense = 6
	demolition_mod = 2

/obj/item/rogueweapon/greataxe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -7,"sy" = 2,"nx" = 7,"ny" = 3,"wx" = -2,"wy" = 1,"ex" = 1,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 30,"eturn" = -30,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -3,"nx" = -5,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/greataxe/steel
	force = 15
	force_wielded = 30
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, SPEAR_BASH)
	name = "steel greataxe"
	desc = "A steel great axe, a long-handled axe with a single blade made for ruining someone's day beyond any measure.."
	icon_state = "sgreataxe"
	icon = 'icons/roguetown/weapons/64.dmi'
	minstr = 11
	max_blade_int = 250
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/greataxe/silver
	force = 15
	force_wielded = 25
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/mace/strike) //When possible, add the longsword's 'alternate grip' mechanic to let people flip this around into a Mace-scaling weapon with swapped damage.
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, /datum/intent/mace/rangedthrust, /datum/intent/mace/strike) //Axe-equivalent to the Godendag or Grand Mace.
	name = "silver poleaxe"
	desc = "A poleaxe, fitted with a reinforced shaft and a beaked axhead of pure silver. It may not stop the darkness; but it will halt its march, long enough, to shepherd away the defenseless. </br>'O'er the Horizon, the stars and spirals I see; and below it, the horrors that've been felled by me. Through the darkness, I see my home and its beautiful light; and it will continue to shimmer, as long as I fight. Forever I stand, forever I'll hold - 'til the Horizon grows still, and my spirit trails home..'"
	icon_state = "silverpolearm"
	icon = 'icons/roguetown/weapons/64.dmi'
	minstr = 12
	max_blade_int = 350
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/greataxe/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greataxe/psy
	force = 15
	force_wielded = 25
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, /datum/intent/mace/strike) //When possible, add the longsword's 'alternate grip' mechanic to let people flip this around into a Mace-scaling weapon with swapped damage.
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, /datum/intent/mace/rangedthrust, /datum/intent/mace/strike) //Axe-equivalent to the Godendag or Grand Mace.
	name = "psydonic poleaxe"
	desc = "A poleaxe, fitted with a reinforced shaft and a beaked axhead of alloyed silver. As the fragility of swords've become more apparent, the Psydonic Orders - following the disastrous Massacre of Blastenghyll - have shifted their focus towards arming their paladins with longer-lasting greatweapons."
	icon_state = "silverpolearm"
	icon = 'icons/roguetown/weapons/64.dmi'
	minstr = 12
	max_blade_int = 350
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/greataxe/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greataxe/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/greataxe/steel/doublehead
	force = 15
	force_wielded = 35
	possible_item_intents = list(/datum/intent/axe/cut, /datum/intent/axe/chop, SPEAR_BASH) //bash is for nonlethal takedowns, only targets limbs
	gripped_intents = list(/datum/intent/axe/cut/battle/greataxe, /datum/intent/axe/chop/battle/greataxe, SPEAR_BASH)
	name = "double-headed steel greataxe"
	desc = "A steel great axe with a wicked double-bladed head. Perfect for cutting either men or trees into stumps.."
	icon_state = "doublegreataxe"
	icon = 'icons/roguetown/weapons/64.dmi'
	max_blade_int = 175
	minstr = 12

/obj/item/rogueweapon/greataxe/steel/doublehead/graggar
	name = "vicious greataxe"
	desc = "A greataxe who's edge thrums with the motive force, violence, oh, sweet violence!"
	icon_state = "graggargaxe"
	force = 20
	force_wielded = 40
	max_blade_int = 250
	icon = 'icons/roguetown/weapons/64.dmi'

/obj/item/rogueweapon/greataxe/steel/doublehead/graggar/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_HORDE, "AXE", "RENDERED ASUNDER")

////////////////////////////////////////
// Unique loot axes; mostly from mobs //
////////////////////////////////////////

/obj/item/rogueweapon/greataxe/steel/doublehead/minotaur
	name = "minotaur greataxe"
	desc = "An incredibly heavy and large axe, pried from the cold-dead hands of Dendor's most wicked of beasts."
	icon_state = "minotaurgreataxe"
	max_blade_int = 250
	minstr = 14 //Double-headed greataxe with extra durability. Rare dungeon loot in minotaur dungeons; no longer drops from every single minotaur.

/obj/item/rogueweapon/stoneaxe/woodcut/troll
	name = "crude heavy axe"
	desc = "An axe clearly made for some large crecher. Though crude in design, it appears to have a fair amount of weight to it.."
	icon_state = "trollaxe"
	force = 25
	force_wielded = 30					//Basically a slight better steel cutting axe.
	max_integrity = 150					//50% less than normal axe
	max_blade_int = 300
	minstr = 13							//Heavy, but still good.
	wdefense = 3						//Slightly better than norm, has 6 defense 2 handing it.
