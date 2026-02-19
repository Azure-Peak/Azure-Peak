//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/sword/cut
	name = "strike"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	chargetime = 0
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	swingdelay = 0
	damfactor = 1.1
	item_d_type = "slash"

/datum/intent/sword/cut/arming
	damfactor = 1.2
	clickcd = 10 // Versatile, this create 26 EDPS instead of 20. But still easily beaten by the Sabre

/datum/intent/sword/cut/militia
	penfactor = 30
	damfactor = 1.2
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE

/datum/intent/sword/cut/short
	clickcd = 9
	damfactor = 1

/datum/intent/sword/cut/broadsword
	name = "cut with half-sworded technique"
	damfactor = 0.8 //Allows for utility-based carving with the broadswords. Technically combat viable, though you should probably take a Longsword if you're strictly using a Broadsword for cuts.
	clickcd = 10 //On par with an Arming Sword.

/datum/intent/sword/chop/militia
	penfactor = 50
	clickcd = CLICK_CD_CHARGED
	swingdelay = 0
	damfactor = 1.0
	no_early_release = TRUE

/datum/intent/sword/thrust
	name = "stab"
	icon_state = "instab"
	attack_verb = list("stabs")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 20
	chargetime = 0
	swingdelay = 0
	item_d_type = "stab"

/datum/intent/sword/thrust/short
	clickcd = 8
	damfactor = 1.1
	penfactor = 30

/datum/intent/sword/thrust/arming
	clickcd = 10 // Less than rapier
	penfactor = 35 // 22 + 35 = 57. Beats light leather slightly more than rapier per strike, but less strike

/datum/intent/sword/thrust/long
	penfactor = 30 // 2h Longsword already have 30 damage. This let it pierce light armor easily
	// Their cut is actually pretty decent when 2handed and should be inferior to zwei.

/datum/intent/sword/thrust/krieg
	damfactor = 0.9

/datum/intent/sword/thrust/blunt
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	attack_verb = list("prods", "pokes")
	penfactor = BLUNT_DEFAULT_PENFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/sword/strike
	name = "pommel strike"
	icon_state = "instrike"
	attack_verb = list("bashes", "clubs")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 0
	damfactor = NONBLUNT_BLUNT_DAMFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

// Freifechter Longsword intents //
/datum/intent/sword/cut/master
	name = "fendente"
	icon_state = "incutmaster"
	desc = "Strike the opponent from above with the true edge of the sword and penetrate light armour."
	attack_verb = list("masterfully tears", "artfully slits", "adroitly hacks")
	damfactor = 1.01
	penfactor = 50
	max_intent_damage = 35
	min_intent_damage = 31

/datum/intent/sword/thrust/long/master
	name = "stoccato"
	icon_state = "instabmaster"
	desc = "Enter a long guard and thrust forward with your entire upper body while advancing, maximizing the effectiveness of the thrust."
	attack_verb =  list("skillfully perforates", "artfully punctures", "deftly sticks")
	damfactor = 1.15
	max_intent_damage = 40.5

/datum/intent/effect/daze/longsword/clinch
	name = "clinch & swipe"
	desc = "Get up in your opponent's face and force them into a clinch, then swipe their face with the crossguard while they're distracted. Good against baited or exhausted opponents."
	icon_state = "inpunish"
	attack_verb = list("forcibly clinches and swipes")
	animname = "strike"
	target_parts = list(BODY_ZONE_HEAD)
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	damfactor = 0.8
	max_intent_damage = 24
	swingdelay = 8
	clickcd = 10
	recovery = 15
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	canparry = FALSE
	candodge = FALSE
	intent_effect = /datum/status_effect/debuff/dazed/swipe

/datum/intent/sword/thrust/long/halfsword
	name = "mezza spada"
	icon_state = "inimpale"
	desc = "Grip the dull portion of your longsword with either hand and use it as leverage to deliver precise, powerful strikes that can dig into gaps in plate and push past maille."
	attack_verb = list("goes into a half-sword stance and skewers", "enters a half-sword stance and impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 80
	clickcd = 12
	swingdelay = 10
	damfactor = 0.86
	blade_class = BCLASS_HALFSWORD
	max_intent_damage = 30

/datum/intent/sword/thrust/long/halfsword/lesser
	name = "halbschwert"
	clickcd = 16

/datum/intent/effect/daze/longsword
	name = "durchlauffen"
	desc = "Lock the opponent's arm in place and strike their nose with the pommel of your sword before tossing them, affecting their ability to dodge and feint. Can only be performed one-handed."
	attack_verb = list("masterfully pummels")
	intent_effect = /datum/status_effect/debuff/dazed/longsword
	target_parts = list(BODY_ZONE_PRECISE_NOSE)
	damfactor = 0.8
	clickcd = 14
	swingdelay = 6

/datum/intent/effect/daze/longsword2h
	name = "zorn ort"
	desc = "Block the opponent's weapon with a strike of your own and advance into a thrust towards the eyes, affecting their vision severely. Can only be performed two-handed."
	attack_verb = list("masterfully pokes")
	intent_effect = /datum/status_effect/debuff/dazed/longsword2h
	target_parts = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)
	blade_class = BCLASS_STAB
	damfactor = 1.1 //Same as master stab
	clickcd = 14
	swingdelay = 5

// A weaker strike for sword with high damage so that it don't end up becoming better than mace
/datum/intent/sword/strike/bad
	damfactor = 0.7 

/datum/intent/sword/peel
	name = "armor peel"
	icon_state = "inpeel"
	attack_verb = list("<font color ='#e7e7e7'>peels</font>")
	animname = "cut"
	blade_class = BCLASS_PEEL
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 0
	damfactor = 0.01
	item_d_type = "slash"
	peel_divisor = 4

/datum/intent/sword/peel/light
	name = "light peel"
	peel_divisor = 5

/datum/intent/sword/peel/big
	name = "big sword armor peel"
	reach = 2
	peel_divisor = 5

/datum/intent/sword/peel/weak
	name = "weak armor peel"
	peel_divisor = 8

/datum/intent/sword/chop
	name = "chop"
	icon_state = "inchop"
	attack_verb = list("chops", "hacks")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 30
	swingdelay = 8
	damfactor = 1.0
	item_d_type = "slash"

/datum/intent/sword/chop/short
	damfactor = 0.9

/datum/intent/sword/chop/long
	reach = 2

/datum/intent/sword/cut/falx
	penfactor = 20

/datum/intent/sword/chop/falx
	penfactor = 40

/datum/intent/sword/cut/krieg
	damfactor = 1.2
	clickcd = 10

/datum/intent/sword/chop/broadsword
	name = "heavy swing" //Standard penetration, but with a higher damage modifier.
	penfactor = 20
	damfactor = 1.15

/datum/intent/sword/thrust/long/broadsword
	name = "heavy thrust" //Ditto.
	penfactor = 20
	damfactor = 1.15
	swingdelay = 4 //Halved swingdelay compared to chopping.

/datum/intent/sword/chop/broadsword/heavy
	name = "efforted swing" //Standard penetration, but with a higher damage modifier. Exclusive to the Executioner Sword series, when two-handed - or the Berserker's Sword, when one-handed.
	penfactor = 30
	damfactor = 1.2
	swingdelay = 10
	clickcd = CLICK_CD_CHARGED

/datum/intent/sword/thrust/long/broadsword/heavy
	name = "impale" //Stabbing variant of the Chop intent. Higher damage, but slower and evadable. Exclusive to two-handed broadswords.
	icon_state = "inimpale"
	attack_verb = list("impales", "thrusts into")
	penfactor = 20
	damfactor = 1.2
	swingdelay = 8

/datum/intent/rend/krieg
	intent_intdamage_factor = 0.2

/datum/intent/rend/broadsword
	intent_intdamage_factor = 0.1

/datum/intent/sword/chop/cleave
	name = "cleave"
	icon_state = "intear"
	attack_verb = list("cleaves", "tears through")
	chargedrain = 1.8
	chargetime = 12
	swingdelay = 0
	damfactor = 1.3
	intent_intdamage_factor = 1.3
	desc = "A powerful blow that delivers Strength-scaling knockback and slowdown to the target. The amount of inflicted knockback scales off your Strength, ranging from X (1 tile) to XIII (3 tiles). </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile."
	var/maxrange = 3

/datum/intent/sword/chop/cleave/spec_on_apply_effect(mob/living/H, mob/living/user, params)
	var/chungus_khan_str = user.STASTR 
	if(H.has_status_effect(/datum/status_effect/debuff/yeetcd))
		return // Recently knocked back, cannot be knocked back again yet
	if(chungus_khan_str < 10)
		return // Too weak to have any effect
	var/scaling = CLAMP((chungus_khan_str - 10), 1, maxrange)
	H.apply_status_effect(/datum/status_effect/debuff/yeetcd)
	H.Slowdown(scaling)
	// Copypasta from knockback proc cuz I don't want the math there
	var/knockback_tiles = scaling // 1 to 4 tiles based on strength
	if(H.resting)
		knockback_tiles = max(1, knockback_tiles / 2)
	if(user?.client?.chargedprog < 100)
		knockback_tiles = 1 // Minimal knockback on non-charged smash.
	var/turf/edge_target_turf = get_edge_target_turf(H, get_dir(user, H))
	if(istype(edge_target_turf))
		H.safe_throw_at(edge_target_turf, \
		knockback_tiles, \
		scaling, \
		user, \
		spin = FALSE, \
		force = H.move_force)

/datum/intent/sword/chop/cleave/prewarning()
	if(mastermob)
		playsound(mastermob, pick('sound/combat/rend_start.ogg'), 100, FALSE)

//sword objs ฅ^•ﻌ•^ฅ
/obj/item/rogueweapon/sword
	name = "arming sword"
	desc = "A long steel blade attached to a hilt, separated by a crossguard. The arming sword has been Psydonia's implement of war by excellence for generations."
	slot_flags = ITEM_SLOT_HIP | ITEM_SLOT_BACK
	force = 22
	force_wielded = 25
	possible_item_intents = list(/datum/intent/sword/cut/arming, /datum/intent/sword/thrust/arming, /datum/intent/sword/strike, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut/arming, /datum/intent/sword/thrust/arming, /datum/intent/sword/strike, /datum/intent/sword/peel)
	damage_deflection = 14
	icon_state = "sword1"
	sheathe_icon = "sword1"
	icon = 'icons/roguetown/weapons/swords32.dmi'
	lefthand_file = 'icons/mob/inhands/weapons/rogue_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/rogue_righthand.dmi'
	parrysound = list(
		'sound/combat/parry/bladed/bladedmedium (1).ogg',
		'sound/combat/parry/bladed/bladedmedium (2).ogg',
		'sound/combat/parry/bladed/bladedmedium (3).ogg',
		)
	swingsound = BLADEWOOSH_MED
	associated_skill = /datum/skill/combat/swords
	max_blade_int = 200
	max_integrity = 150
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	pickup_sound = 'sound/foley/equip/swordlarge1.ogg'
	holster_sound = 'sound/items/wood_sharpen.ogg'
	flags_1 = CONDUCT_1
	throwforce = 10
	thrown_bclass = BCLASS_CUT
	//dropshrink = 0.75
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	minstr = 7
	sellprice = 30
	wdefense = 4
	grid_width = 32
	grid_height = 64

	equip_delay_self = 1.5 SECONDS
	unequip_delay_self = 1.5 SECONDS
	inv_storage_delay = 1.5 SECONDS
	edelay_type = 1
	special = /datum/special_intent/shin_swipe

/obj/item/rogueweapon/sword/Initialize()
	. = ..()
	var/rand_icon = "sword[rand(1,3)]"
	if(icon_state == "sword1")
		icon_state = "[rand_icon]"
		sheathe_icon = "[rand_icon]"

/obj/item/rogueweapon/sword/iron
	name = "iron arming sword"
	desc = "A long iron blade attached to a hilt, separated by a crossguard. The arming sword has been Psydonia's implement of war by excellence for generations, this one is cheaper than its steel brother."
	icon_state = "isword"
	minstr = 6
	smeltresult = /obj/item/ingot/iron
	max_integrity = 100
	sellprice = 10
	sheathe_icon = "isword"

/obj/item/rogueweapon/sword/bronze
	name = "bronze arming sword"
	desc = "A long bronze blade attached to a hilt, separated by a crossguard. The arming sword has been Psydonia's implement of war by excellence for generations - and this implement is the grandfather of them all. Though it lacks the gladii's girth, this arming sword still feels well-balanced for one-handed use."
	icon_state = "bronzesword"
	force = 23 //Iron- and steel arming swords have the same force. +2 to mimic the one-handed nature of bronze swords.
	force_wielded = 25
	minstr = 5
	smeltresult = /obj/item/ingot/bronze
	max_blade_int = 250
	max_integrity = 200
	sheathe_icon = "bronzesword" //Placeholder. Close enough.

/obj/item/rogueweapon/sword/falx
	name = "falx"
	desc = "An unusual type of curved sword that evolved from the farmer's sickle. It has an inwards edge, making it useful for cutting and chopping."
	force = 22
	possible_item_intents = list(/datum/intent/sword/cut/falx,  /datum/intent/sword/chop/falx, /datum/intent/sword/strike, /datum/intent/sword/peel)
	icon_state = "falx"
	max_blade_int = 250
	max_integrity = 125
	gripped_intents = null
	minstr = 4
	wdefense = 6

/obj/item/rogueweapon/sword/falx/stalker
	name = "stalker falx"
	desc = "A jagged blade with an in inward edge. Once a reputable weapon, now little more than a thug's tool."
	icon_state = "spiderfalx"
	wbalance = WBALANCE_SWIFT
	smeltresult = /obj/item/ingot/drow
	smelt_bar_num = 1

/obj/item/rogueweapon/sword/decorated
	name = "decorated arming sword"
	desc = "A valuable ornate arming sword made for the purpose of ceremonial fashion, with a fine leather grip and a carefully engraved golden crossguard."
	icon_state = "decsword1"
	sellprice = 140

/obj/item/rogueweapon/sword/decorated/Initialize()
	. = ..()
	var/rand_icon = "decsword[rand(1,3)]"
	if(icon_state == "decsword1")
		icon_state = "[rand_icon]"
		sheathe_icon = "[rand_icon]"

/obj/item/rogueweapon/sword/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.7,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/stone
	force = 17 //Weaker than a short sword
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/chop)
	gripped_intents = null
	name = "stone sword"
	desc = "A massive hunk of stone, chiseled down to form a crude flint-knapped blade. It has been pounded into a carved wooden handle, and further secured with tightly-wound fibers. </br>'Imitation is the sincerest form of flattery.'"
	icon_state = "stone_sword"
	max_blade_int = 100
	max_integrity = 70
	anvilrepair = /datum/skill/craft/crafting
	smeltresult = null
	minstr = 4
	wdefense = 4
	sellprice = 10

/obj/item/rogueweapon/sword/long
	name = "longsword"
	desc = "A lethal and perfectly balanced weapon. The longsword is the protagonist of endless tales and myths \
	all across Psydonia, seen in the hands of noblemen and an ever-decreasing quantity of master duelists. \
	It has great cultural significance in the empires of Grenzelhoft and Etrusca, where legendary swordsmen \
	have created and perfected many fighting techniques of todae."
	force = 25
	force_wielded = 30
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/sword/strike, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/sword/chop, /datum/intent/sword/peel)
	alt_intents = list(/datum/intent/sword/strike, /datum/intent/sword/bash, /datum/intent/effect/daze)
	mordhau = TRUE
	icon_state = "longsword"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	item_state = "longsword"
	sheathe_icon = "longsword"
	lefthand_file = 'icons/mob/inhands/weapons/roguebig_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/roguebig_righthand.dmi'
	swingsound = BLADEWOOSH_LARGE
	pickup_sound = 'sound/foley/equip/swordlarge2.ogg'
	bigboy = 1
	wlength = WLENGTH_LONG
	gripsprite = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	associated_skill = /datum/skill/combat/swords
	throwforce = 15
	thrown_bclass = BCLASS_CUT
	max_blade_int = 280
	wdefense_wbonus = 4
	smeltresult = /obj/item/ingot/steel
	special = /datum/special_intent/side_sweep

/obj/item/rogueweapon/sword/long/Initialize()
	. = ..()
	AddComponent(/datum/component/skill_blessed, TRAIT_LONGSWORDSMAN, /datum/skill/combat/swords, SKILL_LEVEL_MASTER)

/obj/item/rogueweapon/sword/long/broadsword
	name = "broadsword"
	desc = "A lethal and well-balanced weapon. The broadsword - better known as a 'hand-and-a-halfer' - has dutifully served the \
	swordsmen of Psydonia in their clashes against man-and-monster alike since time immemmorial. It is one of Rockhill's greatest \
	cultural hallmarks, just behind the concepts of 'zenny-a-mug' happy hours and 'killing people over minor disagreements.'"
	icon_state = "broadsword"
	sheathe_icon = "broadsword"
	swingsound = BLADEWOOSH_HUGE
	max_blade_int = 230 //Less of an edge than the longsword..
	max_integrity = 180 //..but tougher.
	wdefense_wbonus = 3 // Same defense when one-handed, but slightly reduced wielded defense compared to the longsword.
	possible_item_intents = list(/datum/intent/sword/chop/broadsword, /datum/intent/sword/thrust/long/broadsword, /datum/intent/sword/strike, /datum/intent/sword/peel/light)
	gripped_intents = list(/datum/intent/sword/chop/broadsword, /datum/intent/sword/thrust/long/broadsword/heavy, /datum/intent/sword/strike, /datum/intent/sword/peel/light)
	alt_intents = list(/datum/intent/sword/strike, /datum/intent/sword/bash, /datum/intent/effect/daze, /datum/intent/sword/cut/broadsword)
	smeltresult = /obj/item/ingot/iron //Sidegrade of the longswords and battle axes - non-blunt attacks hit harder, but are always telegraphed and swing-delayed.

/obj/item/rogueweapon/sword/long/broadsword/bronze
	name = "spatha"
	desc = "A hero needn't speak - for when they are gone, the world will speak for them."
	icon_state = "spatha"
	sheathe_icon = "spatha"
	wdefense = 3 //On par with the Gladius, as the Spatha is.. essentially.. a longer Gladius. Lowest WDEF of all longswords.
	wdefense_wbonus = 3
	max_blade_int = 295 //Inverse. Sharper..
	max_integrity = 125 //..but weaker.
	smeltresult = /obj/item/ingot/bronze //Like before, it falls under the unofficial 'broadsword' category with one-handed chops. Best to pack a shield!

/obj/item/rogueweapon/sword/long/broadsword/steel
	name = "steel broadsword"
	desc = "A lethal and well-balanced weapon. The broadsword - better known as a 'hand-and-a-halfer' - has dutifully served the \
	swordsmen of Psydonia in their clashes against man-and-monster alike since time immemmorial. Valoria's watchmen are renowned for \
	their use of these steel-bladed iterations: an expensive necessity, in order to lay their undying besiegers to rest for good."
	icon_state = "sbroadsword"
	sheathe_icon = "sbroadsword"
	max_blade_int = 330 //Sharper than a longsword, but with reduced defense. The use of steel balances its integrity out with a slight +10 bonus.
	max_integrity = 160 
	wdefense_wbonus = 3
	smeltresult = /obj/item/ingot/steel

////////////////////////
// TRIUMPH-EXCLUSIVE! //
////////////////////////

/obj/item/rogueweapon/sword/long/triumph
	name = "valorian longsword"
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This particular variant has a stouter crossguard and wider blade; a prevaling design \
	from the preceding century, oft-mantled in the homes of now-retired adventurers."
	icon = 'icons/roguetown/weapons/64.dmi'  //Framework for Triumph-purchasable longswords.
	icon_state = "longsword_triumph"

/obj/item/rogueweapon/sword/long/triumph/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.5,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/triumph/rockhill
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This particular variant has a narrow crossguard and lengthened blade; the proportions \
	of an ancient hero's claymore, resurrected through modern smithing techniques."
	icon_state = "longsword_rockhill"
	sheathe_icon = "gensword"

/obj/item/rogueweapon/sword/long/exe/rockhill //Alternate version of the Executioner Sword.
	name = "valorian claymore"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This sharp-edged variant has a narrow crossguard and lengthened blade; the proportions \
	of an ancient hero's claymore, resurrected through modern smithing techniques."
	icon_state = "longsword_rockhill"

/obj/item/rogueweapon/sword/long/exe/rockhill/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/broadsword/steel/rockhill //Alternate version of the Broadsword.
	name = "valorian broadsword"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and well-balanced weapon. The broadsword - better known as a 'hand-and-a-halfer' - has dutifully served the \
	swordsmen of Psydonia in their clashes against man-and-monster alike since time immemmorial. The edge glimmers with the hopes \
	and dreams of the Weeping God's children, imbuing your very soul with determination. ‎</br>‎‎ </br>'There's a light inside your \
	soul, that’s still shining in the cold: the truth, the promise in our hearts.. ..don't forget, I'm with you in the dark.'"
	icon_state = "longsword_rockhill"

/obj/item/rogueweapon/sword/long/broadsword/steel/rockhill/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/triumph/sabreguard
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This particular variant has a curved crossguard and stouter blade; hallmarks of nobility, \
	whether professed atop a saiga or against a villain's edge."
	icon_state = "longsword_sabreguard"
	sheathe_icon = "cutlass"

/obj/item/rogueweapon/sword/long/kriegmesser/sabreguard //Alternative variant for the Kriegmesser.
	name = "valorian greatsabre"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This broad-edged variant has a curved crossguard and stouter blade; hallmarks of nobility, \
	whether professed atop a saiga or against a villain's edge."
	icon_state = "longsword_sabreguard"
	sheathe_icon = "cutlass"

/obj/item/rogueweapon/sword/long/kriegmesser/sabreguard/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/triumph/wideguard
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This particular variant has a widened crossguard, adored by lightly-armored mercenaries \
	who cannot afford to leave a single riposte without interception."
	icon_state = "longsword_wideguard"
	sheathe_icon = "opsysword"

/obj/item/rogueweapon/sword/rapier/wideguard //Alternate variant for the Rapier.
	name = "valorian greatrapier"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This well-honed variant has a widened crossguard, adored by lightly-armored mercenaries \
	who cannot afford to leave a single riposte without interception."
	icon_state = "longsword_wideguard"
	sheathe_icon = "opsysword"

/obj/item/rogueweapon/sword/rapier/wideguard/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/triumph/psycrucifix
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This particular variant has a psycruciformed crossguard; a masterwork, held in silent \
	reverance by those who've vowed to never forget the ultimate sacrifice."
	icon_state = "longsword_psycrucifix"
	sheathe_icon = "opsysword"

/obj/item/rogueweapon/sword/long/psysword/psycrucifix //Alternate variant for the Psydonic Longswords.
	name = "valorian silver longsword"
	icon = 'icons/roguetown/weapons/64.dmi'
	desc = "A lethal and perfectly balanced weapon, the longsword is the protagonist of endless tales and myths \
	all across Psydonia. This silvered variant has a psycruciformed crossguard; a masterwork, held in silent \
	reverance by those who've vowed to never forget the ultimate sacrifice."
	icon_state = "longsword_psycrucifix"
	sheathe_icon = "opsysword"

/obj/item/rogueweapon/sword/long/psysword/psycrucifix/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

////////////////////////

/obj/item/rogueweapon/sword/long/training
	name = "training sword"
	desc = "Swords like these, with blunted tips and dull edges, are often used for practice without much risk of injury."
	force = 7
	force_wielded = 15
	sharpness = IS_BLUNT
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/sword/thrust/blunt, /datum/intent/sword/peel/weak)
	gripped_intents = list(/datum/intent/mace/strike, /datum/intent/sword/thrust/blunt, /datum/intent/sword/peel/weak)
	icon_state = "feder"
	throwforce = 5
	thrown_bclass = BCLASS_BLUNT

/obj/item/rogueweapon/sword/long/church
	name = "holy longsword"
	desc = "A blessed longsword, wielded by the Holy See's templars in their stalwart defense against evil. Originating in the wake of the Celestial Empire's collapse, legends say that it is the grandfather to longswords all across Psydonia: the triumph of an ancient Malumite priest, stricken with divine inspiration in humenity's darkest hour. Centuries later, it still remains the ideal choice for skewering infidels and monsters alike. </br>'I am the holder of light, in the dark abyss..' </br>'..I am the holder of order and ward against vileness..' </br>'..let the Gods guide my hand, and let the Inhumen cower before me.'"
	icon_state = "churchsword"
	max_blade_int = 250
	max_integrity = 180

/obj/item/rogueweapon/sword/long/undivided
	name = "decablade"
	desc = "A blessed longsword, held by the Holy See's templars in their stalwart defense against evil. The golden crossguard bares the winged motif of an angel, and psalms from the Pantheon's holy tome have been meticulously carved along the blade's edge. </br>'With a drop of holy Eclipsum, doth the blade rise..' </br>'..gilded, gleaming, radiant heat, warm my soul, immolate my enemies..' </br>'..and let me vanquish all those who would dare to Divide us, once more.'"
	icon_state = "eclipsum"
	sheathe_icon = "eclipsum"
	max_blade_int = 250
	max_integrity = 180
	force = 28
	force_wielded = 33

/obj/item/rogueweapon/sword/long/undivided/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.65,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.65,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("wielded") return list(
				"shrink" = 0.6,
				"sx" = 3,
				"sy" = 5,
				"nx" = -3,
				"ny" = 5,
				"wx" = -9,
				"wy" = 4,
				"ex" = 9,
				"ey" = 1,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 0,
				"eturn" = 15,
				"nflip" = 8,
				"sflip" = 0,
				"wflip" = 8,
				"eflip" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)


/obj/item/rogueweapon/sword/long/death
	color = CLOTHING_BLACK

/obj/item/rogueweapon/sword/long/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5, "sx" = -14, "sy" = -8, "nx" = 15, "ny" = -7, "wx" = -10, "wy" = -5, "ex" = 7, "ey" = -6, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -13, "sturn" = 110, "wturn" = -60, "eturn" = -30, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback") return list("shrink" = 0.5, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
			if("onbelt") return list("shrink" = 0.4, "sx" = -4, "sy" = -6, "nx" = 5, "ny" = -6, "wx" = 0, "wy" = -6, "ex" = -1, "ey" = -6, "nturn" = 100, "sturn" = 156, "wturn" = 90, "eturn" = 180, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)
			if("altgrip") return list("shrink" = 0.6,"sx" = 2,"sy" = 3,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)

/obj/item/rogueweapon/sword/long/etruscan
	name = "basket-hilted longsword"
	desc = "An uncommon and elaborate type of longsword with a compound hilt like those seen on rapiers and smallswords. It has a marked unsharpened section for safe unarmoured half-swording. The quality of the steel speaks for itself; this is a weapon made by masters, for masters."
	icon_state = "elongsword"
	sheathe_icon = "elongsword"
	icon = 'icons/roguetown/weapons/special/freifechter.dmi'
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/effect/daze/longsword/clinch, /datum/intent/effect/daze/longsword)
	gripped_intents = list(/datum/intent/sword/cut/master, /datum/intent/sword/thrust/long/master, /datum/intent/sword/thrust/long/halfsword, /datum/intent/effect/daze/longsword2h)
	alt_intents = list(/datum/intent/sword/strike, /datum/intent/sword/bash, /datum/intent/effect/daze)
	max_blade_int = 300
	max_integrity = 225

/obj/item/rogueweapon/sword/long/etruscan/freifechter
	name = "psydonic reformist longsword"
	desc = "A newly-smithed longsword with a reverse hilt in the shape of a reformist psydonian cross. It has the same kind of hand protection of an Etruscan longsword. The cross is upright when the weapon is sheathed, bronze pommel reflecting sunlight directly - and it becomes inverted when drawn, a symbol of distress. Ad pacem servandam."
	sheathe_icon = "reform"
	icon_state = "reformistsword"

/obj/item/rogueweapon/sword/long/fencerguy
	name = "grenzelhoftian longsword"
	desc = "A masterfully smithed, perfectly-balanced longsword that makes it easy for even a beginner to perform basic fencing maneuvers."
	icon_state = "germanlong"
	max_blade_int = 275
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/dagger/sucker_punch, /datum/intent/sword/bash)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust/long, /datum/intent/sword/thrust/long/halfsword/lesser, /datum/intent/sword/chop)

/obj/item/rogueweapon/sword/long/zizo
	name = "avantyne longsword"
	desc = "A wicked, unconventional, and otherwordly blade that was created by no swordsmith - a manifestation of hate for the state of this world that follows no design principles but spite and anger."
	icon_state = "zizosword"
	sheathe_icon = "zizosword"
	force = 30
	force_wielded = 35
	max_blade_int = 400
	max_integrity = 500
	equip_delay_self = 0
	unequip_delay_self = 0

/obj/item/rogueweapon/sword/long/zizo/Initialize()
	. = ..()
	AddComponent(/datum/component/cursed_item, TRAIT_CABAL, "SWORD")

/obj/item/rogueweapon/sword/long/heirloom
	name = "old longsword"
	desc = "A very old steel longsword that has since become a showpiece. Perhaps a family relic, or the weapon of a dead knight."
	force = 20
	force_wielded = 32
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/chop)
	icon_state = "heirloom"
	sheathe_icon = "heirloom"

/obj/item/rogueweapon/sword/long/heirloom/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list("shrink" = 0.5, "sx" = -14, "sy" = -8, "nx" = 15, "ny" = -7, "wx" = -10, "wy" = -5, "ex" = 7, "ey" = -6, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0, "nturn" = -13, "sturn" = 110, "wturn" = -60, "eturn" = -30, "nflip" = 1, "sflip" = 1, "wflip" = 8, "eflip" = 1)
			if("wielded") return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback") return list("shrink" = 0.5, "sx" = -1, "sy" = 2, "nx" = 0, "ny" = 2, "wx" = 2, "wy" = 1, "ex" = 0, "ey" = 1, "nturn" = 0, "sturn" = 0, "wturn" = 70, "eturn" = 15, "nflip" = 1, "sflip" = 1, "wflip" = 1, "eflip" = 1, "northabove" = 1, "southabove" = 0, "eastabove" = 0, "westabove" = 0)
			if("onbelt") return list("shrink" = 0.3, "sx" = -4, "sy" = -6, "nx" = 5, "ny" = -6, "wx" = 0, "wy" = -6, "ex" = -1, "ey" = -6, "nturn" = 100, "sturn" = 156, "wturn" = 90, "eturn" = 180, "nflip" = 0, "sflip" = 0, "wflip" = 0, "eflip" = 0, "northabove" = 0, "southabove" = 1, "eastabove" = 1, "westabove" = 0)

/obj/item/rogueweapon/sword/long/judgement
	name = "\"Judgement\""
	desc = "A noble longsword, and the cherished heirloom of Azuria's royal bloodline. Its blade is made from Aavnr's finest Vyšvou steel - held from an ornate carved ivory grip from the region's \"Mamük\" megafauna, and decorated with heraldric engravings of silver. ‎</br>‎‎ </br>'When you stand before thine lord, you cannot say, '..but I was told by others to do thus..', or that, '..virtue was not convenient at the time.' This will not suffice. Remember that.'"
	icon_state = "judgement"
	item_state = "judgement"
	sheathe_icon = "judgement"
	wbalance = WBALANCE_HEAVY
	sellprice = 363
	static_price = TRUE

/obj/item/rogueweapon/sword/long/judgement/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 5,"sy" = -2,"nx" = -6,"ny" = -2,"wx" = -6,"wy" = -2,"ex" = 7,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -28,"sturn" = 29,"wturn" = -35,"eturn" = 32,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/judgement/ascendant //meant to be insanely OP; solo antag wep
	name = "\"The Redentor\""
	desc = "A resplendent longsword, assembled from an otherworldly alloy. Intersecting visions from beyond-and-before cross your mind, as your fingers curl along the leather; all merging into a final truth, sailing across the star-speckled phlogiston. ‎</br>‎‎ </br>'And the preacher said: \"For the Lord is my tower, and He gives me the power to tear down the works of the enemy.\""
	force = 50
	force_wielded = 70
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/chop)
	icon_state = "crucified"
	sheathe_icon = "crucified"
	item_state = "judgement"
	smeltresult = /obj/item/ingot/steel
	sellprice = 999
	static_price = TRUE
	max_integrity = 999
	max_blade_int = 9999

/obj/item/rogueweapon/sword/long/judgement/vlord
	name = "\"Ichor Fang\""
	desc = "An unholy longsword, who's crystalline blade radiates with insurmountable sharpness. It has been brought forth unto this world for a singular purpose; not to bring peace, but to dominate all who'd dare to oppose the coming darkness. ‎</br>‎‎ </br>'And I looked, and beheld a pale horse - the name that sat upon Her was Death, and Hell followed with them.'"
	force = 40
	force_wielded = 55
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/chop)
	icon_state = "vlord"
	item_state = "vlord"
	wbalance = WBALANCE_NORMAL
	max_blade_int = 666
	max_integrity = 9999
	sellprice = 777
	static_price = TRUE
	equip_delay_self = 0
	unequip_delay_self = 0

/obj/item/rogueweapon/sword/long/judgement/vlord/Initialize()
	. = ..()
	SEND_GLOBAL_SIGNAL(COMSIG_NEW_ICHOR_FANG_SPAWNED, src)
	RegisterSignal(SSdcs, COMSIG_NEW_ICHOR_FANG_SPAWNED, PROC_REF(on_recall))

/obj/item/rogueweapon/sword/long/judgement/vlord/proc/on_recall(obj/new_sword)
	if(new_sword == src)
		return

	src.visible_message(span_warning("\The [src] crumbles to dust, the ashes spiriting away."))
	qdel(src)

/obj/item/rogueweapon/sword/long/marlin
	name = "shalal saber"
	desc = "A large yet surprisingly agile curved blade meant to be wielded in two hands. It has a similar composition to northwestern Psydonian longswords, but it's notably lighter."
	force = 26
	force_wielded = 31
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/strike, /datum/intent/sword/peel, /datum/intent/sword/chop)
	icon_state = "marlin"
	item_state = "marlin"
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = BLADEWOOSH_SMALL
	wlength = WLENGTH_LONG
	minstr = 6
	sellprice = 42
	wdefense = 5

/obj/item/rogueweapon/sword/long/marlin/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

//Slightly more expensive than a longsword by 1 iron, so gets to be slightly better.
/obj/item/rogueweapon/sword/long/exe
	name = "executioners sword"
	desc = "A heavy broadsword with a terrifyingly sharp edge, purpose-made to part heads from shoulders. Owing to its nature as a weapon of justice, it lacks the piercing tips that befit most battle-ready broadswords. If you're strong enough to wield such a weapon, however, then that probably won't stop you from finding a way."
	possible_item_intents = list(/datum/intent/sword/chop/broadsword, /datum/intent/sword/cut, /datum/intent/sword/thrust/exe, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/rend/broadsword, /datum/intent/sword/chop/broadsword/heavy, /datum/intent/sword/thrust/exe/heavy, /datum/intent/sword/cut)
	alt_intents = null
	icon_state = "exe"
	minstr = 12
	slot_flags = ITEM_SLOT_BACK
	swingsound = BLADEWOOSH_HUGE
	smeltresult = /obj/item/ingot/iron
	max_blade_int = 330 
	smelt_bar_num = 2 // 1 bar loss
	vorpal = TRUE // snicker snack this shit cuts heads off effortlessly (DO NOT PUT THIS ON ANYTHING ELSE UNLESS IT'S SUPER FUCKING RARE!!!)
	mordhau = FALSE

/datum/intent/sword/thrust/exe
	swingdelay = 4	//Slight delay to stab; big and heavy.
	penfactor = BLUNT_DEFAULT_PENFACTOR //Flat tip? I don't know, man. This intent is won't penetrate anything but it damages armor more.
	intent_intdamage_factor = 1.3 //This is basically like getting hit by a mace.

/datum/intent/sword/thrust/exe/heavy
	swingdelay = 6
	damfactor = 1.1

/obj/item/rogueweapon/sword/long/exe/astrata
	name = "\"Solar Judge\""
	desc = "An incredibly unusual executioner's sword clad in gold and brass. Two separate blades protude outwards and join near its intricately decorated crossguard. This weapon calls for order."
	icon_state = "astratasword"
	max_integrity = 200
	vorpal = TRUE

/obj/item/rogueweapon/sword/long/exe/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("altgrip") 
				return list("shrink" = 0.45,"sx" = 2,"sy" = 3,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)

/obj/item/rogueweapon/sword/long/exe/cloth
	icon_state = "terminusest"
	name = "\"Terminus Est\""
	desc = "An ornate executioner's sword, decorated with a golden pommel and crossguard. A bloody rag \
	winds around the ricasso, ever-present to keep its edge spotless for the executionee's final \
	judgement. The stout-angled blade bares an enscription along its length; </br>'WHEN THIS SWORDE I DOTH LYFT, I WISH THE SINNER ETERNAL LYFE AS THINE GYFT.'"
	smeltresult = /obj/item/ingot/gold // It is the most valuable component
	max_blade_int = 363 
	smelt_bar_num = 2

/obj/item/rogueweapon/sword/long/exe/cloth/rmb_self(mob/user)
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(user, "clothwipe", 100, TRUE)
	SEND_SIGNAL(src, COMSIG_COMPONENT_CLEAN_ACT, CLEAN_STRONG)
	user.visible_message(span_warning("[user] wipes [src] down with its cloth."),span_notice("I wipe [src] down with its cloth."))
	return

//

/obj/item/rogueweapon/sword/long/exe/silver
	name = "silver executioners sword"
	desc = "A thorned executioner's sword, who's massive silver blade lays mounted atop an intricately-carved \
	handle. Though the barbs dig into your hands, it's said that such pricklings will only draw blood if the \
	silvered edge falls upon the neck of the innocent."
	icon_state = "psygsword"
	force = 22
	force_wielded = 25
	minstr_req = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/sword/long/exe/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/datum/anvil_recipe/weapons/silver/exec
	name = "Executioners Sword, Silver (+3 Silver, +1 Small Log)"
	req_bar = /obj/item/ingot/silver
	additional_items = list(/obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/ingot/silver, /obj/item/grown/log/tree/small)
	created_item = /obj/item/rogueweapon/sword/long/exe/silver

//

/obj/item/rogueweapon/sword/long/exe/berserk
	name = "berserkers sword"
	desc = "A raw heap of iron, hewn into an intimidatingly massive cleaver. Most could never aspire to effectively swing such a laborsome blade about; those few that have the strength, however, can force even the strongest opponents to stagger back."
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "dragonslayer"
	possible_item_intents = list(/datum/intent/sword/chop/broadsword/heavy, /datum/intent/sword/cut, /datum/intent/sword/thrust/exe, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/sword/chop/cleave, /datum/intent/rend, /datum/intent/sword/cut, /datum/intent/sword/thrust/long/broadsword)
	wbalance = WBALANCE_HEAVY //Stronger but sturdier executioner's sword, exchanging its peelage for an armor-piercing variant of Ansari's knockback variable.
	minstr = 13 //Should be uncraftable, but obtainable through other variants. Challenge classes, dungeon rewards?
	wdefense = 9
	minstr_req = TRUE
	max_blade_int = 400

/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer
	name = "\"Daemonslayer\""
	desc = "The ultimate triumph. </br>His despair, channeled through His children's hands into hope-made-manifest. </br>Her bane, silvered with the very same power that empowered Her ascension. </br>Your world's fate; not to be decided by neither Man nor God - only you."
	icon_state = "machaslayer"
	force = 40
	force_wielded = 55
	minstr = 14
	wdefense = 14
	max_integrity = 777
	max_blade_int = 777
	is_silver = TRUE
	smeltresult = /obj/item/rogueweapon/sword/long/exe/berserk //How many forges does it take to get to the center of a superweapon?

/obj/item/rogueweapon/sword/long/exe/berserk/dragonslayer/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 0,\
		added_def = 0,\
	)

/obj/item/rogueweapon/sword/long/oldpsysword
	name = "enduring longsword"
	desc = "A steel longsword with an angled crossguard. The lesser clerics of the Psydonic Orders oft-carry these blades, and - though it may not carry the bite of silver - it still humbles men and monsters alike with a well-poised strike."
	icon_state = "opsysword"
	sheathe_icon = "opsysword"
	dropshrink = 1

/obj/item/rogueweapon/sword/long/psysword
	name = "psydonic longsword"
	desc = "A finely made longsword, plated in a ceremonial veneer of ornate silver - made for felling men and monsters alike. </br>'Psydon will deliver those who were mindful of Him to their place of ultimate triumph. No evil will touch them, nor will they grieve.'"
	icon_state = "psysword"
	sheathe_icon = "psysword"
	force = 20
	force_wielded = 25
	minstr = 9
	wdefense = 6
	dropshrink = 1
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/sword/long/psysword/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/long/psysword/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/long/silver
	name = "silver longsword"
	desc = "A longsword with a blade of pure silver. The weight doesn't just burden your hand, but your very soul as well; an unspoken oath, to stand against the horrors that lurk within the nite. </br>'Swing with precision and purpose, levyman o' the Gods. The nite is long and many-an-evil cur would engineer civilization's destruction, while Astrata's gaze leers elsewhere. So long as you wield this sword, you have a duty that beckons.'"
	icon_state = "silverlongsword"
	sheathe_icon = "psysword"
	force = 20
	force_wielded = 25
	minstr = 9
	wdefense = 6
	dropshrink = 1
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/sword/long/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/long/kriegmesser/silver
	name = "silver broadsword"
	desc = "A two-handed broadsword, fitted with a blade of pure silver. Each swing commands more effort than the last, but not without purpose. One blow to crack the deadite's leg in twain; and a heartbeat later, another to splatter the soil with bile and teeth."
	icon_state = "silverbroadsword"
	sheathe_icon = "psysword"
	swingsound = BLADEWOOSH_HUGE
	force = 20
	force_wielded = 25
	minstr = 11
	wdefense = 6
	possible_item_intents = list(/datum/intent/rend/broadsword, /datum/intent/sword/chop/broadsword, /datum/intent/sword/thrust/long/broadsword, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/rend/broadsword, /datum/intent/sword/chop/broadsword, /datum/intent/sword/thrust/long/broadsword/heavy, /datum/intent/sword/strike)
	alt_intents = list(/datum/intent/sword/strike, /datum/intent/sword/bash, /datum/intent/effect/daze, /datum/intent/sword/cut/broadsword)
	mordhau = TRUE
	smeltresult = /obj/item/ingot/silver
	is_silver = TRUE

/obj/item/rogueweapon/sword/long/kriegmesser/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/long/kriegmesser/psy
	name = "psydonic broadsword"
	desc = "Sunder, cleave, smite; a sea of coagulated blackness, speckled with crimson. Absolve, cherish, endure; the will of one, christened to save Psydonia when all else is lost. </br>'Even here it is not safe, and even this grave has been defaced. Yet, someone has written on this stone, in some angry hand - 'HOPE RIDES ALONE..'"
	icon_state = "silverbroadsword"
	sheathe_icon = "psysword"
	swingsound = BLADEWOOSH_HUGE
	force = 20
	force_wielded = 25
	minstr = 11
	wdefense = 6
	possible_item_intents = list(/datum/intent/rend/broadsword, /datum/intent/sword/chop/broadsword, /datum/intent/sword/thrust/long/broadsword, /datum/intent/sword/strike)
	gripped_intents = list(/datum/intent/rend/broadsword, /datum/intent/sword/chop/broadsword, /datum/intent/sword/thrust/long/broadsword/heavy, /datum/intent/sword/strike)
	alt_intents = list(/datum/intent/sword/strike, /datum/intent/sword/bash, /datum/intent/effect/daze, /datum/intent/sword/cut/broadsword)
	mordhau = TRUE
	smeltresult = /obj/item/ingot/silverblessed
	is_silver = TRUE

/obj/item/rogueweapon/sword/long/kriegmesser/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/short
	name = "steel shortsword"
	desc = "The arming sword's shorter and much older brother. Despite being centuries older than the swords of todae, it remains in use as a cheap sidearm for shieldbearers and archers."
	possible_item_intents = list(/datum/intent/sword/cut/short, /datum/intent/sword/thrust/short, /datum/intent/sword/peel)
	icon_state = "swordshort"
	sheathe_icon = "swordshort"
	gripped_intents = null
	minstr = 4
	wdefense = 4
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_NORMAL
	grid_width = 32
	grid_height = 96

/obj/item/rogueweapon/sword/short/kazengun
	name = "steel kodachi"
	desc = "A razor-edged sword with a wavy pattern weld apparent on its blade."
	possible_item_intents = list(
		/datum/intent/sword/cut/short,
		/datum/intent/sword/thrust/short,
		/datum/intent/sword/peel,
		/datum/intent/sword/chop/short,
		)
	icon_state = "eastshortsword"
	sheathe_icon = "kodachi"
	wbalance = WBALANCE_SWIFT

/obj/item/rogueweapon/sword/short/iron
	name = "iron shortsword"
	desc = "The arming sword's shorter and much older brother. Despite being centuries older than the swords of todae, it remains in use as a cheap sidearm for shieldbearers and archers. This iron variant predates them all."
	icon_state = "iswordshort"
	sheathe_icon = "iswordshort"
	wdefense = 3
	smeltresult = /obj/item/ingot/iron
	max_integrity = 100
	sellprice = 10

/obj/item/rogueweapon/sword/short/ashort
	name = "decrepit short sword"
	desc = "A chipped sidearm-sword, wrought from frayed bronze. It's hard to gauge whether it was naturally forged to be so short, or if it's all that remained of a longer blade."
	icon_state = "ashortsword"
	sheathe_icon = "ashortsword"
	max_integrity = 75
	force = 18
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/sword/short/pashortsword
	name = "ancient shortsword"
	desc = "A polished sidearm-sword, forged from gilbranze. From after His sacrifice, but before Her ascension; the tithe of a war without reason, waged between squabbling children who hadn't known that the world was about to end."
	icon_state = "ashortsword"
	sheathe_icon = "ashortsword"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/sword/short/falchion
	name = "falchion"
	desc = "A single-edged sword that is similar to a messer in appearance, its origins trace back to Otava. An implement of commoners and knights alike. It's good for cutting and thrusting."
	force = 20
	icon_state = "falchion"
	wdefense = 6
	w_class = WEIGHT_CLASS_BULKY // Did not fit in a bag before path rework. Does not fit in a bag now either.
	sheathe_icon = "falchion"

/obj/item/rogueweapon/sword/short/gladius
	name = "gladius"
	desc = "A hefty blade of bronze, sharp enough to disembowel and decapitate with-but a lone hand's force. Psydonia's ancient champions drove back the Archdevil's hordes with these shortswords, a thousand years ago; yet now, the end has crept forth to threaten lyfe once more. Move with the grace of your ancestors - spread your feet, brace your grasp, and make them bleed for every step they take."
	icon_state = "gladius"
	sheathe_icon = "gladius"
	max_integrity = 250
	max_blade_int = 300
	smeltresult = /obj/item/ingot/bronze
	wdefense = 3

/obj/item/rogueweapon/sword/short/gladius/decorated
	name = "decorated gladius"
	desc = "A beautiful depiction of justice, beflowered and besilked. The crimson engravings along its blade pay tribute to the ancient epics of Ravox's ascent to godlihood; for it was His wounding of the Sinistar's tentacled heart that forced the Archdevil to pause - first in disbelief, then in fascination."
	icon_state = "gladiusdec"
	sheathe_icon = "decgladius"
	max_integrity = 300
	smeltresult = /obj/item/ingot/gold
	sellprice = 100
	wdefense = 5

/obj/item/rogueweapon/sword/sabre/bronzekhopesh
	name = "khopesh"
	desc = "A sickle-shaped sword of Naledi origin that owes its design to a type of battle axe its ancient settlers once used - it represents a symbol of power and conquest. The glint along its bronzen edge shifts with every passing glance, yearning to be dulled-wet with the blood of long-extinct villains."
	icon_state = "bronzekhopesh"
	force = 22
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/chop/falx, /datum/intent/sword/peel)
	max_integrity = 175
	max_blade_int = 300
	smeltresult = /obj/item/ingot/bronze

/obj/item/rogueweapon/sword/short/gladius/agladius
	name = "decrepit gladius"
	desc = "A hefty shortsword, wrought from frayed bronze. Once, the sidearm of a proud legionnaire; now, a consequence of progress and sacrifice."
	force = 18
	max_integrity = 150
	icon_state = "agladius"
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/sword/short/gladius/pagladius
	name = "ancient gladius"
	desc = "A polished shortsword, forged from gilbranze. Favored by Zizo's undying legionnaires, this antiquated tool serves a simple purpose; to spill the innards of unenlightened fools."
	icon_state = "agladius"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/sword/short/iron/chipped
	name = "chipped iron shortsword"
	desc = "A damaged and ancient iron shortsword. It looks duller, and seems less effective."
	force = 17
	icon_state = "iswordshort_d"
	sheathe_icon = "iswordshort_d"
	max_integrity = 75

/obj/item/rogueweapon/sword/short/psy
	name = "psydonic shortsword"
	desc = "Otavan smiths worked with Grenzelhoftian artificers, and an esoteric sidearm was born: a shortsword with an unique design, dismissing a crossguard in favor of a hollow beak to hook and draw harm away from its user. Short in length, yet lethally light in weight."
	icon_state = "psyswordshort"
	sheathe_icon = "psyswordshort"
	force = 20
	force_wielded = 20
	minstr = 7
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/rogueweapon/sword/short/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/short/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/short/silver
	name = "silver shortsword"
	desc = "A shortsword with a blade of pure silver. In the marginalia of tomes depicting Psydonia's crusading orders, there is no sight more iconic than that of the hauberk-draped paladin; a kite shield in one hand, and this glimmering sidearm in the other."
	icon = 'icons/roguetown/weapons/daggers32.dmi'	
	icon_state = "silverswordshort"
	sheathe_icon = "psyswordshort"
	force = 20
	force_wielded = 20
	minstr = 7
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/rogueweapon/sword/short/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/short/messer
	name = "messer"
	desc = "A \"Großesmesser\" of disputed Grenzel origin, meaning greatknife. It's a basic single-edge sword for civilian and military use. It excels at slicing and chopping, and it's made of steel. \
	It can fill the exact function of a hunting sword, this one is more durable."
	icon_state = "smesser"
	force = 22	//Same damage as the iron messer
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/axe/chop, /datum/intent/sword/peel)
	minstr = 5
	wdefense = 4

/obj/item/rogueweapon/sword/short/messer/duelist
	name = "dueling messer"
	swingsound = BLADEWOOSH_SMALL
	wbalance = WBALANCE_SWIFT

/obj/item/rogueweapon/sword/short/messer/iron
	name = "hunting sword"
	desc = "A basic single-edge sword that is usually used to finish off hunted game. It excels at slicing and chopping, and it's made of iron. \
	It's a fairly reliable and affordable self-defense weapon."
	icon_state = "imesser"
	minstr = 4
	wdefense = 2
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = /obj/item/ingot/iron
	max_integrity = 100
	sellprice = 10
	sheathe_icon = "isword"

/obj/item/rogueweapon/sword/short/messer/iron/virtue
	name = "iron dueling messer"
	desc = "A basic single-edge iron hunting sword that has been modified for the express purpose of dueling, with an added guard and a leaner grip for comfort and speed."
	icon_state = "dmesser"
	swingsound = BLADEWOOSH_SMALL
	wdefense = 3
	wbalance = WBALANCE_SWIFT

/obj/item/rogueweapon/sword/short/messer/copper
	name = "copper messer"
	desc = "A copper hunting sword. Less lethal than its iron counterpart."
	force = 20 // Worse force. This weapon has steel integ instead of iron integ. Don't ask me why, it was that way before too.
	icon_state = "cmesser"
	minstr = 4
	wdefense = 2
	smeltresult = /obj/item/ingot/copper

/obj/item/rogueweapon/sword/sabre
	name = "sabre"
	desc = "A very popular backsword made for cavalrymen that originated in Naledi and spread its influence further north, reaching Aavnr as a \"Szablya\" and notoriously cementing itself as the preferred weapon of the Potentate's Hussars."
	icon_state = "saber"
	sheathe_icon = "saber"
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/sabre, /datum/intent/sword/strike, /datum/intent/sword/peel)
	gripped_intents = null
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	swingsound = BLADEWOOSH_SMALL
	minstr = 5
	wdefense = 7		//Same as rapier
	wbalance = WBALANCE_SWIFT
	special = /datum/special_intent/shin_swipe

/datum/intent/sword/cut/sabre
	clickcd = 8		//Faster than sword by 4
	damfactor = 1.25	//Better than rapier (Base is 1.1 for swords)
	penfactor = 10		//Very slight buff to pen on cut mode. Still weaker then sword-chop mode.

/datum/intent/sword/thrust/sabre
	clickcd = 9			//Fast but still not as fast as rapier n' shittier.
	damfactor = 0.9		//10% worse	than base

/obj/item/rogueweapon/sword/sabre/dec
	icon_state = "decsaber"
	sheathe_icon = "decsaber"
	sellprice = 140

/obj/item/rogueweapon/sword/saber/iron
	name = "iron saber"
	desc = "A Naledian sword mass produced for line infantry. Its fittings are simple, munitions grade, but the construction is sturdy and the blade as threatening \
	as any."
	smeltresult = /obj/item/ingot/iron
	max_integrity = 100
	icon_state = "isaber"
	sellprice = 10

/obj/item/rogueweapon/sword/sabre/steppesman
	name = "aavnic shashka"
	desc = "A single-edged, single-handed, and guardless blade of northern Aavnic make with a brass pommel in the shape of a zad's head. The gentle curve of its blade puts it midway between a radically curved sabre and a straight sword, effective for both cutting and thrusting but lacking raw defense potential."
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/sabre, /datum/intent/sword/chop, /datum/intent/rend)
	wdefense = 5
	minstr = 6
	icon_state = "shashka"
	sheathe_icon = "shashka"

/datum/intent/sword/cut/sabre/master
	name = "pokrajać"
	desc = "Perform a masterful wide-arc cut that's strong enough to penetrate light armour."
	attack_verb = list("masterfully cuts", "deftly slits", "quarts")
	clickcd = 7
	damfactor = 1.25
	penfactor = 55
	max_intent_damage = 29.7

/datum/intent/effect/daze/freisabre
	name = "uszkodzić"
	desc = "After a few misleading strikes, suddenly slash at your opponent's wrist to affect their speed and strength, preventing them from using their weapon effectively. This move can be parried, but not dodged."
	attack_verb = list("deftly wrist-slits")
	intent_effect = /datum/status_effect/debuff/dazed/freisabre
	target_parts = list(BODY_ZONE_PRECISE_L_HAND, BODY_ZONE_PRECISE_R_HAND)
	blade_class = BCLASS_CUT
	damfactor = 1.25
	clickcd = 12
	recovery = 8
	swingdelay = 3
	canparry = TRUE
	candodge = FALSE

/obj/item/rogueweapon/sword/sabre/freifechter
	name = "szöréndnížine sabre"
	desc = "A rare, specialty-made sabre domestic to Szöréndnížina, made similarly to those of the Potentate's Hussars. It has a large, open hilt with a cross-shaped guard formed from quillons and langets and a heavy curved blade. A chain is attached to the crossguard and into the pommel, protecting the hand. Unlike shorter and ligther sabres, it's large enough to reach the feet."
	icon = 'icons/roguetown/weapons/special/freifechter.dmi'
	possible_item_intents = list(/datum/intent/sword/cut/sabre/master, /datum/intent/sword/thrust/sabre, /datum/intent/effect/daze/freisabre, /datum/intent/rend)
	wdefense = 7
	minstr = 8
	icon_state = "szabla"
	sheathe_icon = "szabla"
	bigboy = 1
	max_integrity = 215
	max_blade_int = 275		//Similarly statted to the longswords
	inhand_x_dimension = 64
	inhand_y_dimension = 64

/obj/item/rogueweapon/sword/sabre/freifechter/Initialize()
	. = ..()
	AddComponent(/datum/component/skill_blessed, TRAIT_SABRIST, /datum/skill/combat/swords, SKILL_LEVEL_MASTER, TRUE)

//Unique church sword - slightly better than regular sabre due to falx chop.
/obj/item/rogueweapon/sword/sabre/nockhopesh
	name = "moonlight khopesh"
	desc = "A sickle-shaped sword of Naledi origin that owes its design to a type of battle axe its ancient settlers once used - it represents a symbol of power and conquest. This one in particular is made of blued steel."
	icon_state = "nockhopesh"
	force = 25	//Base is 22
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/chop/falx, /datum/intent/sword/peel)
	max_integrity = 200

/obj/item/rogueweapon/sword/sabre/alloy
	name = "decrepit khopesh"
	desc = "A hooked sword, wrought from frayed bronze. The design is not only baffling, but seems to predate history itself."
	force = 18
	max_integrity = 115
	icon_state = "akhopesh"
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/sword/sabre/palloy
	name = "ancient khopesh"
	desc = "A polished hook-sword, forged from gilbronze. The Comet Syon's glare once graced this blade; now, it's wielded by those who can't even remember what came before His sacrifice."
	smeltresult = /obj/item/ingot/aaslag
	icon_state = "akhopesh"

/obj/item/rogueweapon/sword/sabre/elf
	name = "elvish saber"
	desc = "A single-edged masterwork of Elven design, who's silvered blade glimmers under the sun's glare."
	icon_state = "esaber"
	item_state = "esaber"
	sheathe_icon = "esaber"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	force = 23 //Equalized with the Stalker Sabre, with a +1DMG boost to its original stats.
	force_wielded = 23
	minstr = 7
	wdefense = 7
	last_used = 0
	is_silver = TRUE //One of the rare silver-edged weapons that has a positive damage boost, due to it requiring both silver and gold to create.
	smeltresult = /obj/item/ingot/gold
	smelt_bar_num = 1

/obj/item/rogueweapon/sword/sabre/elf/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/sabre/stalker
	name = "stalker sabre"
	desc = "A once-elegant blade of ketryl, who's sunless edge now menaces with obsidian-hued mirth."
	icon_state = "spidersaber"
	force = 23
	force_wielded = 23
	minstr = 7
	wdefense = 8
	smeltresult = /obj/item/ingot/drow
	smelt_bar_num = 1

/obj/item/rogueweapon/sword/sabre/shamshir
	name = "shamshir"
	desc = "A curved one-handed longsword. This type of scimitar is the quintessential armament of Ranesheni horsemen, its name derived from Sama'glos for \"Tiger's claw\"."
	force = 24
	wdefense = 6	//Has chop mode, so slightly less defense. Slightly.
	icon_state = "tabi"
	icon = 'icons/roguetown/weapons/swords64.dmi'
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/peel, /datum/intent/sword/chop)
	alt_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/chop)
	bigboy = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	dropshrink = 0.75

/obj/item/rogueweapon/sword/sabre/shamshir/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -10,"sy" = -8,"nx" = 13,"ny" = -8,"wx" = -8,"wy" = -7,"ex" = 7,"ey" = -8,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 90,"sturn" = -90,"wturn" = -80,"eturn" = 81,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.6,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.5,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/rapier
	name = "rapier"
	desc = "A practically brand new sword type with a straight, slender and sharply pointed blade meant to be wielded in one hand. \
		Originating in the islands of Etrusca, its name comes from the term \"spada ropera\" (Literally \"dress sword\") due to its primary function being that of an accessory. \
		A very young type of fighting technique for this weapon is emerging in the island, aptly named \"Destreza\" for dexterity."
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "rapier"
	sheathe_icon = "rapier"
	bigboy = TRUE
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	dropshrink = 0.75
	possible_item_intents = list(/datum/intent/sword/thrust/rapier, /datum/intent/sword/cut/rapier, /datum/intent/sword/peel)
	special = /datum/special_intent/piercing_lunge
	gripped_intents = null
	parrysound = list(
		'sound/combat/parry/bladed/bladedthin (1).ogg',
		'sound/combat/parry/bladed/bladedthin (2).ogg',
		'sound/combat/parry/bladed/bladedthin (3).ogg',
		)
	swingsound = BLADEWOOSH_SMALL
	minstr = 6
	wdefense = 7
	wbalance = WBALANCE_SWIFT

/obj/item/rogueweapon/sword/rapier/vaquero
	name = "cup-hilt rapier"
	desc = "A special variant of an Etruscan rapier. The cup hilt of this weapon is both simpler to produce and more protective than the type of traditional design of current rapiers."
	icon_state = "cup_hilt_rapier"
	wdefense = 8
	force = 25

/obj/item/rogueweapon/sword/rapier/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.5,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.5,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)

/datum/intent/sword/cut/rapier
	clickcd = 10
	damfactor = 0.75

/datum/intent/sword/thrust/rapier
	clickcd = 8
	damfactor = 1.1
	penfactor = 30

/obj/item/rogueweapon/sword/rapier/dec
	name = "decorated rapier"
	desc = "A strange, cheap ring devoid of purpose, yet carrying an uncanny sense of nostalgia of grand upsets, felled short.\n<i>'You shall know his name. You shall know his purpose. You shall die.'</i>"
	icon_state = "decrapier"
	sheathe_icon = "decrapier"
	sellprice = 140

/obj/item/rogueweapon/sword/rapier/silver
	name = "silver rapier"
	desc = "A basket-hilted rapier, fitted with a thin blade of pure silver. Immortalized by Rockhill's witch hunters, this weapon - though cumberstone in an untrained hand - is surprisingly adept at both parrying and riposting."
	icon_state = "silverrapier"
	sheathe_icon = "psyrapier"
	max_integrity = 225
	max_blade_int = 225
	force = 20
	force_wielded = 20
	minstr = 8
	wdefense = 8
	smeltresult = /obj/item/ingot/silver
	is_silver = TRUE

/obj/item/rogueweapon/sword/rapier/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/psy
	name = "psydonic rapier"
	desc = "A basket-hilted rapier, fitted with a thin blade of pure silver. Such a resplendent weapon not only pierces the gaps within a heathen's maille, but also serves as the symbol of an Otavan diplomat's authority."
	icon_state = "silverrapier"
	sheathe_icon = "rapier"
	max_integrity = 225
	max_blade_int = 225
	force = 20
	force_wielded = 20
	minstr = 8
	wdefense = 8
	smeltresult = /obj/item/ingot/silverblessed
	is_silver = TRUE

/obj/item/rogueweapon/sword/rapier/psy/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/psy/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/psy/relic
	name = "Eucharist"
	desc = "Etruscan shape falling prey to Otavan craftsmanship. Saint Malum's smiths created an uniquely thin blade, capable of swiftly skewering the unholy and the miscreants through gaps that most claim to have never existed in the first place. <b> Silver-dipped steel crowned upon a basket hilt that keeps righteous hands safe from harm."
	icon_state = "psyrapier"
	sheathe_icon = "psyrapier"
	max_integrity = 300
	max_blade_int = 300
	force = 20
	force_wielded = 20
	minstr = 8
	wdefense = 8
	smeltresult = /obj/item/ingot/silver
	is_silver = TRUE

/obj/item/rogueweapon/sword/rapier/psy/relic/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 100,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/rapier/lord
	name = "sword of the Mad Duke"
	desc = "A royal heirloom whose spiraling basket hilt is inlaid with fine cut gems. It bears the burnish of \
	time, where once sharply defined features have been worn down by so many hands. An old rumor ties this implement \
	to the siege that smashed the Mad Duke's keep to rubble, and burnt the Duke himself to cinders."
	icon_state = "lordrap"
	sheathe_icon = "lordrapier"
	sellprice = 150
	max_integrity = 300
	max_blade_int = 300
	wdefense = 7

/obj/item/rogueweapon/sword/rapier/eora
	name = "\"Heartstring\""
	desc = "A specialty-made bilbo hilt rapier made in service to Lady Eora. For the time when soft words can no longer be spoken, and hearts are to be pierced."
	icon = 'icons/roguetown/weapons/swords32.dmi'
	icon_state = "eorarapier"
	sheathe_icon = "eorarapier"
	grid_width = 32
	grid_height = 64
	dropshrink = 0
	bigboy = FALSE
	force = 25 // Same statline as the cup hilted etruscan rapier
	wdefense = 8

/obj/item/rogueweapon/sword/rapier/courtphysician
	name = "cane blade"
	desc = "A steel blade with a gold handle, intended to be concealed inside of a cane, bears the visage of a vulture on its pommel."
	icon = 'icons/roguetown/weapons/swords32.dmi'
	icon_state = "doccaneblade"
	sheathe_icon = "doccaneblade"
	sellprice = 100 //Gold handle
	grid_width = 32
	grid_height = 64
	dropshrink = 0
	bigboy = FALSE
	possible_item_intents = list(/datum/intent/sword/thrust/rapier, /datum/intent/sword/cut/rapier)
	gripped_intents = null
	force_wielded = 0

/obj/item/rogueweapon/sword/rapier/hand
	name = "dark sister"
	desc = "A tool made for nobler tasks than shedding blood, discreet and every ready, as you should be too."
	icon = 'icons/roguetown/weapons/special/hand32.dmi'
	icon_state = "staffblade"
	item_state = "staffblade"
	sheathe_icon = "staffblade"

/obj/item/rogueweapon/sword/cutlass
	name = "cutlass"
	desc = "The mariner's special: A short, broad sabre with a slightly curved blade optimized for slashing."
	icon_state = "cutlass"
	force = 23
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/chop, /datum/intent/sword/peel)
	gripped_intents = null
	wdefense = 6
	wbalance = WBALANCE_SWIFT
	sheathe_icon = "cutlass"


/obj/item/rogueweapon/sword/silver
	name = "silver arming sword"
	desc = "An arming sword, fitted with a blade of pure silver. It is the bane of vampyres, nitebeasts, and deadites throughout all of Psydonia; cursed flesh erupts into holy fire, and unholy bravado twists into mortal fear."
	icon_state = "silversword"
	sheathe_icon = "silversword"
	force = 20
	force_wielded = 25
	minstr = 9
	wdefense = 5
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 2
	max_blade_int = 230
	max_integrity = 200

/obj/item/rogueweapon/sword/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/sword/long/rhomphaia
	name = "rhomphaia"
	desc = "An ancient sword similar to the falx, with the key difference of its curve being less pronounced - feared for its ability to strike and thrust with precision."
	force = 25
	force_wielded = 30
	possible_item_intents = list(/datum/intent/sword/cut/falx, /datum/intent/sword/strike, /datum/intent/sword/chop/falx, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut/falx, /datum/intent/sword/thrust, /datum/intent/sword/chop/falx, /datum/intent/sword/peel) //>Ability to strike and THRUST - No thrust intent? Nonsense.
	icon_state = "rhomphaia"
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/sword/long/rhomphaia/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.47,"sx" = -10,"sy" = -8,"nx" = 11,"ny" = -8,"wx" = -8,"wy" = -6,"ex" = 7,"ey" = -7,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 83,"sturn" = -83,"wturn" = -69,"eturn" = 60,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.45,"sx" = 9,"sy" = -4,"nx" = -7,"ny" = 1,"wx" = -9,"wy" = 2,"ex" = 10,"ey" = 2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 5,"sturn" = -190,"wturn" = -170,"eturn" = -10,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.7,"sx" = -3,"sy" = -2,"nx" = -7,"ny" = -2,"wx" = -11,"wy" = 7,"ex" = 11,"ey" = -3,"nturn" = -28,"sturn" = -30,"wturn" = 160,"eturn" = 32,"nflip" = 5,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("altgrip") 
				return list("shrink" = 0.45,"sx" = 2,"sy" = 3,"nx" = -7,"ny" = 1,"wx" = -8,"wy" = 0,"ex" = 8,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -135,"sturn" = -35,"wturn" = 45,"eturn" = 145,"nflip" = 8,"sflip" = 8,"wflip" = 1,"eflip" = 0)

/obj/item/rogueweapon/sword/long/rhomphaia/copper
	name = "copper rhomphaia"
	desc = "An ancient sword similar to the falx, with the key difference of its curve being less pronounced - feared for its ability to strike and thrust with precision. This one is made of copper, making it weaker."
	icon_state = "crhomphaia"
	force = 22
	force_wielded = 26
	max_integrity = 100
	smeltresult = /obj/item/ingot/copper

/obj/item/rogueweapon/sword/long/oathkeeper
	name = "Oathkeeper"
	desc = "An ornate golden longsword with a ruby embedded in the hilt, given to the Knight Commander for their valiant service to the crown."
	sellprice = 140
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust, /datum/intent/sword/strike)
	icon_state = "kingslayer"
	sheathe_icon = "kingslayer"

/obj/item/rogueweapon/sword/long/oathkeeper/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/oathkeeper/hand
	name = "Azurefyre"
	desc = "The Blade fit for the Hand, wielded in service to the crown and never mistaken for another."
	icon = 'icons/roguetown/weapons/special/hand64.dmi'
	sellprice = 250
	icon_state = "handsword"

/obj/item/rogueweapon/sword/long/holysee
	name = "eclipsum sword"
	desc = "A masterworked longsword, forged from the same divine alloy that decorates the Bishop's hip. As your fingers curl around the shaft, a blessed sensation rolls through your very soul: the resolve to stand against evil, and the determination to see it vanquished from this world. </br>'..blessed to hold strength and bring hope, whether it be during the dae or the nite..'"
	icon_state = "seeblade"
	force = 35
	force_wielded = 50
	possible_item_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/strike, /datum/intent/sword/peel)
	gripped_intents = list(/datum/intent/sword/cut, /datum/intent/sword/thrust, /datum/intent/sword/chop, /datum/intent/sword/peel)
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver
	smelt_bar_num = 2
	wdefense = 7
	max_blade_int = 777
	max_integrity = 999

/obj/item/rogueweapon/sword/long/holysee/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 0,\
		added_def = 0,\
	)

/obj/item/rogueweapon/sword/long/holysee/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.65,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.65,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("wielded") return list(
				"shrink" = 0.6,
				"sx" = 3,
				"sy" = 5,
				"nx" = -3,
				"ny" = 5,
				"wx" = -9,
				"wy" = 4,
				"ex" = 9,
				"ey" = 1,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 0,
				"eturn" = 15,
				"nflip" = 8,
				"sflip" = 0,
				"wflip" = 8,
				"eflip" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)

/obj/item/rogueweapon/sword/long/kriegmesser
	name = "kriegsmesser"
	desc = "A large two-handed sword with a single-edged blade, a crossguard and a knife-like hilt. \
	It is meant to be wielded with both hands and is a popular weapon amongst Grenzelhoftian mercenaries."
	icon_state = "kriegmesser"
	possible_item_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/chop/falx, /datum/intent/sword/strike, /datum/intent/rend/krieg)
	gripped_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/thrust/krieg, /datum/intent/sword/strike, /datum/intent/rend/krieg)
	alt_intents = null // Can't mordhau this
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
	name = "ssangsudo"
	desc = "A style of long blade used by the kouken of Kazengun. A weapon supremely skilled in the art of cutting."
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "ssangsudo"
	sheathe_icon = "ssangsudo"
	gripped_intents = list(/datum/intent/sword/cut/krieg, /datum/intent/sword/thrust/krieg, /datum/intent/rend, /datum/intent/sword/strike) // better rend by .05

/obj/item/rogueweapon/sword/long/kriegmesser/pestran
	name = "Cleansing Edge"
	desc = "A cut in time saves a life."
	icon_state = "pestranmesser"
	sheathe_icon = "pestranmesser"

/obj/item/rogueweapon/sword/long/dec
	name = "decorated longsword"
	desc = "A valuable ornate longsword made for the purpose of ceremonial fashion, with a fine leather grip and a carefully engraved golden crossguard. \
	Its blade bears twin inscriptions on either side. One reads, \"THY KINGDOM COME\" while the obverse reads, \"THY WILL BE DONE\"."
	icon_state = "declongsword"
	sellprice = 140

// kazengite content
// Stronger offense less defense sword meant to be paired w/ scabbard for parrying
/obj/item/rogueweapon/sword/sabre/mulyeog
	force = 25
	name = "hwando" // From Korean Hwangdo - Lit. Military Sword / Sabre, noted for less curves than a Japanese katana.
	desc = "A foreign single-edged sword used by cut-throats & thugs. There's a red tassel on the hilt, said to bring about good fortune."
	sheathe_icon = "mulyeog"
	icon_state = "eastsword1"
	smeltresult = /obj/item/ingot/steel
	wdefense = 3

/obj/item/rogueweapon/sword/sabre/mulyeog/rumahench
	name = "ruma hwando"
	desc = "A foreign steel single-edged sword with cloud patterns on the groove. The Ruma Clan's insignia is engraved on the blade."
	icon_state = "eastsword2"

/obj/item/rogueweapon/sword/sabre/mulyeog/rumacaptain
	force = 30
	name = "samjeongdo"
	desc = "A gold-stained sword with cloud patterns on the groove. One of a kind. It is a symbol of status within the Ruma clan."
	icon_state = "eastsword3"
	max_integrity = 180
	sharpness_mod = 2
	wdefense = 4

/obj/item/rogueweapon/sword/sabre/hook
	force = 20
	name = "hook sword"
	desc = "A steel sword with a hooked design at the tip of it; perfect for disarming enemies. Its back edge is sharpened and the hilt appears to have a sharpened tip."
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "hook_sword"
	possible_item_intents = list(/datum/intent/sword/cut/sabre, /datum/intent/sword/thrust/hook, /datum/intent/sword/strike, /datum/intent/sword/disarm)
	max_integrity = 180
	wdefense = 5

/obj/item/rogueweapon/sword/sabre/hook/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen") return list(
				"shrink" = 0.5,
				"sx" = -14,
				"sy" = -8,
				"nx" = 15,
				"ny" = -7,
				"wx" = -10,
				"wy" = -5,
				"ex" = 7,
				"ey" = -6,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				"nturn" = -13,
				"sturn" = 110,
				"wturn" = -60,
				"eturn" = -30,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 8,
				"eflip" = 1,
				)
			if("onback") return list(
				"shrink" = 0.5,
				"sx" = -1,
				"sy" = 2,
				"nx" = 0,
				"ny" = 2,
				"wx" = 2,
				"wy" = 1,
				"ex" = 0,
				"ey" = 1,
				"nturn" = 0,
				"sturn" = 0,
				"wturn" = 70,
				"eturn" = 15,
				"nflip" = 1,
				"sflip" = 1,
				"wflip" = 1,
				"eflip" = 1,
				"northabove" = 1,
				"southabove" = 0,
				"eastabove" = 0,
				"westabove" = 0,
				)
			if("onbelt") return list(
				"shrink" = 0.4,
				"sx" = -4,
				"sy" = -6,
				"nx" = 5,
				"ny" = -6,
				"wx" = 0,
				"wy" = -6,
				"ex" = -1,
				"ey" = -6,
				"nturn" = 100,
				"sturn" = 156,
				"wturn" = 90,
				"eturn" = 180,
				"nflip" = 0,
				"sflip" = 0,
				"wflip" = 0,
				"eflip" = 0,
				"northabove" = 0,
				"southabove" = 1,
				"eastabove" = 1,
				"westabove" = 0,
				)

/datum/intent/sword/thrust/hook
	damfactor = 0.9

//Snowflake version of hand-targeting disarm intent.
/datum/intent/sword/disarm
	name = "disarm"
	icon_state = "intake"
	animname = "strike"
	blade_class = null	//We don't use a blade class because it has on damage.
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = BLUNT_DEFAULT_PENFACTOR
	swingdelay = 2	//Small delay to hook
	damfactor = 0.1	//No real damage
	clickcd = 22	//Can't spam this; long delay.
	item_d_type = "blunt"

/obj/item/rogueweapon/sword/sabre/hook/attack(mob/living/M, mob/living/user, bodyzone_hit)
	. = ..()
	var/skill_diff = 0
	if(istype(user.used_intent, /datum/intent/sword/disarm))
		var/obj/item/I
		if(user.zone_selected == BODY_ZONE_PRECISE_L_HAND && M.active_hand_index == 1)
			I = M.get_active_held_item()
		else
			if(user.zone_selected == BODY_ZONE_PRECISE_R_HAND && M.active_hand_index == 2)
				I = M.get_active_held_item()
			else
				I = M.get_inactive_held_item()
		if(user.mind)
			skill_diff += (user.get_skill_level(/datum/skill/combat/swords))	//You check your sword skill
		if(M.mind)
			skill_diff -= (M.get_skill_level(/datum/skill/combat/wrestling))	//They check their wrestling skill to stop the weapon from being pulled.
		user.stamina_add(rand(3,8))
		var/probby = clamp((((3 + (((user.STASTR - M.STASTR)/4) + skill_diff)) * 10)), 5, 95)
		if(I)
			if(M.mind)
				if(I.associated_skill)
					probby -= M.get_skill_level(I.associated_skill) * 5
			var/obj/item/mainhand = user.get_active_held_item()
			var/obj/item/offhand = user.get_inactive_held_item()
			if(HAS_TRAIT(src, TRAIT_DUALWIELDER) && istype(offhand, mainhand))
				probby += 20	//We give notable bonus to dual-wielders who use two hooked swords.
			if(prob(probby))
				M.dropItemToGround(I, force = FALSE, silent = FALSE)
				user.stop_pulling()
				user.put_in_inactive_hand(I)
				M.visible_message(span_danger("[user] takes [I] from [M]'s hand!"), \
				span_userdanger("[user] takes [I] from my hand!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
				user.changeNext_move(12)//avoids instantly attacking with the new weapon
				playsound(src.loc, 'sound/combat/weaponr1.ogg', 100, FALSE, -1) //sound queue to let them know that they got disarmed
				if(!M.mind)	//If you hit an NPC - they pick up weapons instantly. So, we do more stuff.
					M.Stun(10)
			else
				probby += 20
				if(prob(probby))
					M.dropItemToGround(I, force = FALSE, silent = FALSE)
					M.visible_message(span_danger("[user] disarms [M] of [I]!"), \
					span_userdanger("[user] disarms me of [I]!"), span_hear("I hear a sickening sound of pugilism!"), COMBAT_MESSAGE_RANGE)
					if(!M.mind)
						M.Stun(20)	//high delay to pick up weapon
					else
						M.Stun(6)	//slight delay to pick up the weapon
				else
					user.Immobilize(10)
					M.Immobilize(10)
					M.visible_message(span_notice("[user.name] struggles to disarm [M.name]!"))
					playsound(src.loc, 'sound/foley/struggle.ogg', 100, FALSE, -1)
		if(!isliving(M))
			to_chat(user, span_warning("You cannot disarm this enemy!"))
			return
		else
			to_chat(user, span_warning("They aren't holding anything on that hand!"))
			return

/obj/item/rogueweapon/sword/long/shotel
	name = "steel shotel"
	icon_state = "shotel_steel"
	desc = "A long curved blade of Ranesheni Design."
	possible_item_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop/long) //Shotels get 2 tile reach.
	gripped_intents = list(/datum/intent/sword/cut/zwei, /datum/intent/sword/chop/long)
	swingsound = BLADEWOOSH_LARGE
	parrysound = "largeblade"
	pickup_sound = "brandish_blade"
	bigboy = TRUE
	wlength = WLENGTH_LONG
	gripsprite = FALSE // OAUGHHHH!!! OAUGUUGHh!!!!1 aaaaAAAAAHH!!!
	pixel_y = -16
	pixel_x = -16
	inhand_x_dimension = 64
	inhand_y_dimension = 64
	slot_flags = ITEM_SLOT_BACK|ITEM_SLOT_HIP
	dropshrink = 0.8
	max_integrity = 150 //Sword with two tile reach but very low integrity.
	max_blade_int = 150

/obj/item/rogueweapon/sword/long/shotel/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/long/shotel/iron
	name = "iron shotel"
	icon_state = "shotel_iron"
	swingsound = BLADEWOOSH_LARGE
	max_integrity = 100
	max_blade_int = 100
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/sword/long/shotel/iron/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -13,"sturn" = 110,"wturn" = -60,"eturn" = -30,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("altgrip")
				return list("shrink" = 0.5,"sx" = -14,"sy" = -8,"nx" = 15,"ny" = -7,"wx" = -10,"wy" = -5,"ex" = 7,"ey" = -6,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 167,"sturn" = 290,"wturn" = 120,"eturn" = 150,"nflip" = 1,"sflip" = 1,"wflip" = 8,"eflip" = 1)
			if("onback")
				return list("shrink" = 0.5,"sx" = -1,"sy" = 2,"nx" = 0,"ny" = 2,"wx" = 2,"wy" = 1,"ex" = 0,"ey" = 1,"nturn" = 0,"sturn" = 0,"wturn" = 70,"eturn" = 15,"nflip" = 1,"sflip" = 1,"wflip" = 1,"eflip" = 1,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)
			if("wielded")
				return list("shrink" = 0.4,"sx" = 3,"sy" = 4,"nx" = -1,"ny" = 4,"wx" = -8,"wy" = 3,"ex" = 7,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 15,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.4,"sx" = -4,"sy" = -6,"nx" = 5,"ny" = -6,"wx" = 0,"wy" = -6,"ex" = -1,"ey" = -6,"nturn" = 100,"sturn" = 156,"wturn" = 90,"eturn" = 180,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/sword/sabre/banneret // just a better sabre, unique banneret weapon
	name = "'Edict'"
	desc = "A lavish blacksteel sabre, inlaid with gold along the hilt and crossguard. The blade bears an inscription,\"FIAT JUSTITIA\"."
	icon_state = "capsabre"
	icon = 'icons/roguetown/weapons/special/captain.dmi'
	force = 25 // same as elvish sabre
	max_integrity = 200 // more integrity because blacksteel, a bit less than the flamberge
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	sellprice = 100 // lets not make it too profitable
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/rogueweapon/sword/sabre/bane
	name = "Bane's Edge"
	desc = "A stained sabre made of blacksteel, its edge is coated in long-dried blood as well as poison."
	icon_state = "poisonsaber"
	force = 25
	max_integrity = 200 
	parrysound = list('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
	sellprice = 50
	smeltresult = null
	special = /datum/special_intent/coat_blade

/obj/item/rogueweapon/sword/gold
	name = "golden arming sword"
	desc = "A heavenly arming sword, who's golden blade and besilked handle lays separated by a duocruciformic crossguard. This particular weapon seems to have innovatively combined the lethal cutting prowess of Psydonia's oldest weapon with the psychological damage of knowing that its wielder could likely bribe the Carriageman himself, and still chose to personally kill you."
	icon_state = "goldsword"
	smeltresult = /obj/item/ingot/gold
	force = 35
	force_wielded = 40
	minstr = 10
	max_integrity = 50 //For reference, regular attacks drain each 'max_' value by one point. Parries will quite literally cause this to explode.
	max_blade_int = 50
	anvilrepair = null //Ceremonial. This should break comedically easily, but still have just enough toughness to work with a few strikes.
	sellprice = 300
	sheathe_icon = "goldsword"
	wbalance = WBALANCE_HEAVY
	unenchantable = TRUE

/obj/item/rogueweapon/sword/gold/lordscepter
	name = "\"Godshand\""
	desc = "A royal arming sword, who's golden blade and besilked handle lays separated by a duocruciformic crossguard. Nestled within its glistening bosom is a shard of Astrata's divinity authority; when reason fails to rank amongst rage, let Her speak for you. ‎</br>‎‎ </br>'..And I will strike down upon thee with great vengeance and furious anger - those who would attempt to poison and destroy my brothers. And you will know that I am the Lord when I lay my vengeance upon thee!'"
	icon_state = "goldswordking"
	sheathe_icon = "goldswordking"
	anvilrepair = /datum/skill/craft/weaponsmithing
	minstr = 7
	max_integrity = 250
	max_blade_int = 250
	sellprice = 363
	possible_item_intents = list(/datum/intent/sword/cut/arming, /datum/intent/sword/thrust/arming, /datum/intent/lord_electrocute, /datum/intent/lord_silence)
	gripped_intents = list(/datum/intent/sword/cut/arming, /datum/intent/sword/thrust/arming, /datum/intent/sword/strike, /datum/intent/sword/peel)
	unenchantable = TRUE
	COOLDOWN_DECLARE(sceptersword)

/obj/item/rogueweapon/sword/gold/lordscepter/afterattack(atom/target, mob/user, flag)
	. = ..()
	if(get_dist(user, target) > 7)
		return
	
	user.changeNext_move(CLICK_CD_MELEE)

	if(ishuman(user))
		var/mob/living/carbon/human/HU = user

		if(HU.job != "Grand Duke")
			to_chat(user, span_danger("The sword's divine authority doesn't recognize me."))
			return

		if(ishuman(target))
			var/mob/living/carbon/human/H = target
			var/area/target_area = get_area(H)

			if(!istype(target_area, /area/rogue/indoors/town/manor))
				to_chat(user, span_danger("The sword's divine authority cannot be invoked on targets outside of the manor!"))
				return

			if(H == HU)
				return

			if(!COOLDOWN_FINISHED(src, sceptersword))
				to_chat(user, span_danger("The [src] is not ready yet! [round(COOLDOWN_TIMELEFT(src, sceptersword) / 10, 1)] seconds left!"))
				return

			if(H.anti_magic_check())
				to_chat(user, span_danger("Something is disrupting the sword's divine authority!"))
				return

			if(istype(user.used_intent, /datum/intent/lord_electrocute))
				HU.visible_message(span_warning("[HU] electrocutes [H] with the [src]."))
				user.Beam(target,icon_state="lightning[rand(1,12)]",time=5)
				H.electrocute_act(5, src)
				COOLDOWN_START(src, sceptersword, 20 SECONDS)
				to_chat(H, span_danger("I'm electrocuted by the sword's divine authority!"))
				return

			if(istype(user.used_intent, /datum/intent/lord_silence))
				HU.visible_message("<span class='warning'>[HU] silences [H] with \the [src].</span>")
				H.set_silence(20 SECONDS)
				COOLDOWN_START(src, sceptersword, 10 SECONDS)
				to_chat(H, "<span class='danger'>I'm silenced by the sword's divine authority!</span>")
				return

/obj/item/rogueweapon/sword/blacksteel
	name = "blacksteel arming sword"
	desc = "A broad blade of blacksteel, mounted to a rosawooden handle that perfectly compliments its wielder's grasp. It is the culmination of Psydonia's storied history with arming swords; a mastersmith's triumph, only fit for the hands of a true hero.. or a truer villain."
	icon_state = "bs_sword"
	sheathe_icon = "bs_sword"
	smeltresult = /obj/item/ingot/blacksteel
	force = 25
	force_wielded = 30
	wdefense = 6
	max_integrity = 350
	max_blade_int = 350
	sellprice = 150

/obj/item/rogueweapon/sword/blacksteel/decorated
	name = "decorated blacksteel arming sword"
	desc = "A broad blade of blacksteel, mounted atop a golden sabreguard that's been meticulously engraved with its commissoner's heraldry. It is a masterwork of unmatched opulance and lethality, and is - perhaps - the finest arming sword your eyes'll ever lay upon."
	icon_state = "bs_swordregal"
	sheathe_icon = "bs_swordregal"
	wdefense = 7
	sellprice = 250

/obj/item/rogueweapon/sword/short/gronn
	name = "gronnic hinterblade"
	desc = "Due to the shortage of forged steel in Gronn, their iron blades have become hardier and thicker than what one may see elsewhere. The favoured weapon of choice for any able-bodied northman of Gronn, the hinterblade is the heftier, unwieldy cousin of the arming sword."
	possible_item_intents = list(/datum/intent/sword/cut/militia, /datum/intent/sword/chop/militia, /datum/intent/sword/thrust/short, /datum/intent/sword/peel)
	icon_state = "gronnsword"
	sheathe_icon = "swordshort"
	gripped_intents = null
	minstr = 10 //NO TWINKS!!
	wdefense = 3 // Use it with a shield jackass
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_NORMAL
	wbalance = WBALANCE_HEAVY

	grid_width = 32
	grid_height = 96

//Elven weapons sprited and added by Jam
/obj/item/rogueweapon/sword/short/elvish
	name = "elvish shortsword"
	desc = "A finely crafted Elvish shortsword, light and swift, ideal for precise strikes."
	icon_state = "elfsword"
	sellprice = 40
	sheathe_icon = "elfsword"
	wbalance = WBALANCE_SWIFT //Elven designs tend to be light and swift
	max_blade_int = 220

/obj/item/rogueweapon/sword/long/elvish
	name = "elvish longsword"
	desc = "A mighty Elvish longsword, well-balanced and efficient, favored for both offense and defense."
	icon = 'icons/roguetown/weapons/swords64.dmi'
	icon_state = "elflongsword"
	sellprice = 50
	sheathe_icon = "elfsword"
	max_blade_int = 300
