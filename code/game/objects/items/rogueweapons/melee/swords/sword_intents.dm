// GENERIC
//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/sword/cut
	name = "cut"
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
	clickcd = CLICK_CD_QUICK // Versatile, this create 26 EDPS instead of 20. But still easily beaten by the Sabre

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
	clickcd = CLICK_CD_QUICK //On par with an Arming Sword.

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
	clickcd = CLICK_CD_QUICK // Less than rapier
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
	desc = "Strike the opponent from above with the true edge of the sword and penetrate light armour. A cut so perfect requires precision and time."
	attack_verb = list("masterfully tears", "artfully slits", "adroitly hacks")
	damfactor = 1.01
	penfactor = 50
	max_intent_damage = 31
	swingdelay = 1

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
	clickcd = CLICK_CD_QUICK
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
	swingdelay = 16
	damfactor = 0.86
	blade_class = BCLASS_HALFSWORD
	max_intent_damage = 30

/datum/intent/sword/thrust/long/halfsword/lesser
	name = "halbschwert"
	clickcd = 22

/datum/intent/effect/daze/longsword
	name = "durchlauffen"
	desc = "Lock the opponent's arm in place and strike their nose with the pommel of your sword before tossing them, affecting their ability to dodge and feint. Can only be performed one-handed."
	attack_verb = list("masterfully pummels")
	intent_effect = /datum/status_effect/debuff/dazed/longsword
	target_parts = list(BODY_ZONE_PRECISE_NOSE)
	damfactor = 0.8
	clickcd = 14
	swingdelay = 8

/datum/intent/effect/daze/longsword2h
	name = "zorn ort"
	desc = "Block the opponent's weapon with a strike of your own and advance into a thrust towards the eyes, affecting their vision severely. Can only be performed two-handed."
	attack_verb = list("masterfully pokes")
	intent_effect = /datum/status_effect/debuff/dazed/longsword2h
	target_parts = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)
	blade_class = BCLASS_STAB
	damfactor = 1.1 //Same as master stab
	clickcd = 14
	swingdelay = 7

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
	clickcd = CLICK_CD_QUICK

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

/datum/intent/sword/bash
	name = "pommel bash"
	blade_class = BCLASS_BLUNT
	icon_state = "inbash"
	attack_verb = list("bashes", "strikes")
	penfactor = BLUNT_DEFAULT_PENFACTOR
	damfactor = NONBLUNT_BLUNT_DAMFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

// GREATSWORDS
/datum/intent/sword/cut/zwei
	reach = 2

/datum/intent/sword/cut/zwei/cleave
	name = "cleaving cut"
	icon_state = "incleave"
	desc = "A cleave that cuts through a second target behind the first."
	attack_verb = list("cleaves", "carves through")
	clickcd = CLICK_CD_HEAVY
	damfactor = 1.0
	reach = 1 // No!!
	cleave = /datum/cleave_pattern/forward_cleave

/datum/intent/sword/cut/zwei/sweep
	name = "sweeping cut"
	icon_state = "insweep"
	desc = "A heavy sweep that cuts through targets to the front."
	attack_verb = list("sweeps through", "cuts across")
	reach = 1
	clickcd = CLICK_CD_MASSIVE
	cleave = /datum/cleave_pattern/horizontal_sweep

/datum/intent/sword/thrust/zwei
	reach = 2

// ESTOC

/datum/intent/sword/thrust/estoc
	name = "thrust"
	penfactor = 57	//At 57 pen + 25 base (82 total), you will always pen 80 stab armor, but you can't do it at range unlike a spear.
	swingdelay = 8

/datum/intent/sword/lunge
	name = "lunge"
	icon_state = "inimpale"
	attack_verb = list("lunges")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	reach = 2
	damfactor = 1.3	//Zwei will still deal ~7-10 more damage at the same range, depending on user's STR.
	swingdelay = 8

