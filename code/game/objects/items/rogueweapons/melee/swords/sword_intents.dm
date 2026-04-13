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
	penfactor = PEN_LIGHT
	damfactor = 1.2
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE

/datum/intent/sword/cut/short
	clickcd = 9
	damfactor = 1

/datum/intent/sword/chop/militia
	penfactor = PEN_MEDIUM
	clickcd = CLICK_CD_CHARGED
	swingdelay = 0
	damfactor = 1.0
	no_early_release = TRUE

/datum/intent/sword/chop/heavy
	penfactor = PEN_MEDIUM
	swingdelay = 6
	damfactor = 1.3

/datum/intent/sword/thrust
	name = "stab"
	icon_state = "instab"
	attack_verb = list("stabs")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_LIGHT
	chargetime = 0
	swingdelay = 0
	item_d_type = "stab"

/datum/intent/sword/thrust/short
	clickcd = 8
	damfactor = 1.1
	penfactor = PEN_LIGHT

/datum/intent/sword/thrust/arming
	clickcd = CLICK_CD_QUICK // Less than rapier
	penfactor = PEN_LIGHT

/datum/intent/sword/thrust/heavy
	name = "heavy thrust"
	icon_state = "inlunge"
	penfactor = PEN_HEAVY
	damfactor = 1.3
	swingdelay = 0.9 SECONDS
	swingdelay_type = SWINGDELAY_PENALTY

/datum/intent/sword/thrust/long
	penfactor = PEN_LIGHT // Longsword thrust — same pen tier, higher base damage

/datum/intent/sword/thrust/long/deep
	name = "deep lunge"
	icon_state = "inlunge"
	penfactor = PEN_MEDIUM
	damfactor = 1.1
	swingdelay = 0.6 SECONDS

/datum/intent/sword/thrust/long/halfsword
	name = "halfsword thrust"
	icon_state = "inimpale"
	clickcd = CLICK_CD_CHARGED
	penfactor = PEN_HEAVY
	damfactor = 0.8
	swingdelay_type = SWINGDELAY_PENALTY
	swingdelay = 0.7 SECONDS

/datum/intent/sword/thrust/long/halfsword/jab
	name = "jab"
	attack_verb = list("jabs")
	penfactor = PEN_LIGHT
	damfactor = 0.8
	clickcd = CLICK_CD_QUICK
	swingdelay = 0

/datum/intent/sword/thrust/blunt
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	attack_verb = list("prods", "pokes")
	penfactor = PEN_NONE
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/sword/strike
	name = "pommel strike"
	icon_state = "instrike"
	attack_verb = list("strikes")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = PEN_NONE
	swingdelay = 0
	damfactor = NONBLUNT_BLUNT_DAMFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/sword/strike/bash
	name = "pommel swing"
	icon_state = "inbash"
	attack_verb = list("bashes", "clubs")

/datum/intent/sword/strike/penalty
	name = "heavy blunted swing"
	icon_state = "incut"
	swingdelay_type = SWINGDELAY_PENALTY
	swingdelay = 1 SECONDS
	damfactor = 1.7

/datum/intent/sword/strike/cancel
	name = "sluggish blunted swing"
	icon_state = "inchop"
	swingdelay_type = SWINGDELAY_CANCEL
	swingdelay = 1 SECONDS
	damfactor = 3
	canparry = FALSE
	candodge = FALSE

// Freifechter Longsword intents //
/datum/intent/sword/cut/master
	name = "fendente"
	icon_state = "incutmaster"
	desc = "Strike the opponent with the true edge of the sword and penetrate lighter armour. A cut so perfect requires precision and time."
	attack_verb = list("masterfully tears", "artfully slits", "adroitly hacks")
	damfactor = 1.2
	penfactor = PEN_LIGHT // Master cut — cuts are for damaging armor, not penning it. Leave pen to the stabbin'
	max_intent_damage = 36
	min_intent_damage = 31
	swingdelay = 2 //sure

/datum/intent/sword/thrust/long/master
	name = "stoccato"
	icon_state = "instabmaster"
	desc = "Enter a long guard and thrust forward with your entire upper body while advancing, maximizing the effectiveness of the thrust."
	attack_verb =  list("skillfully perforates", "artfully punctures", "deftly sticks")
	damfactor = 1.2
	max_intent_damage = 36 //they do the same damage. one is for bleeding, the other is for critfishing. feels weird but they get a lot of toys

/datum/intent/effect/daze/longsword/clinch
	name = "clinch & swipe"
	desc = "Get too close to your opponent for them to attack you easily, slamming the pommel of your sword into their face. Very briefly reduces opponent's strength and constitution, making it more difficult for them to escape grabs. Can only be performed one-handed. Works on the head, skull, nose, and mouth."
	icon_state = "inpunish"
	attack_verb = list("forcibly clinches and swipes")
	animname = "strike"
	target_parts = list(BODY_ZONE_HEAD, BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_SKULL)
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	damfactor = 0.7
	max_intent_damage = 22
	swingdelay = 3
	swingdelay_type = SWINGDELAY_NORMAL
	clickcd = CLICK_CD_QUICK
	recovery = 6
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	canparry = FALSE
	candodge = FALSE
	intent_effect = /datum/status_effect/debuff/dazed/swipe

/datum/intent/sword/thrust/long/halfsword/frei
	name = "mezza spada"
	icon_state = "inimpale"
	desc = "Grip the dull portion of your longsword with either hand and use it as leverage to deliver precise, powerful strikes that can dig into gaps in plate and push past maille. Can only be performed half-sworded."
	attack_verb = list("skewers", "impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_HEAVY
	clickcd = CLICK_CD_MELEE
	swingdelay = 1.2 SECONDS
	damfactor = 0.95 //slightly nerfed. go use your debuffs dude
	blade_class = BCLASS_PICK
	max_intent_damage = 30

/datum/intent/sword/thrust/long/halfsword/lesser
	name = "halbschwert"
	clickcd = 22

/datum/intent/effect/daze/longsword
	name = "durchlauffen"
	desc = "Quickly flip your weapon around to the blunt end and slam an opponent in the throat, mouth, or nose, affecting their ability to breathe properly. Slow, and can be cancelled by being hit, but applies a long-lasting debuff. Can only be performed in roof guard."
	attack_verb = list("masterfully pummels")
	intent_effect = /datum/status_effect/debuff/dazed/longsword
	target_parts = list(BODY_ZONE_PRECISE_NOSE, BODY_ZONE_PRECISE_MOUTH, BODY_ZONE_PRECISE_NECK)
	damfactor = 0.3
	clickcd = 20
	swingdelay = 10
	swingdelay_type = SWINGDELAY_CANCEL //that debuff is fucking terrifying, and this should mostly be used when you have a big opening or are confident in your ability to dodge one or more attacks.

/datum/intent/effect/daze/longsword2h
	name = "zorn ort"
	desc = "Block the opponent's weapon with a strike of your own and advance into a thrust towards the eyes, affecting their vision severely. Can only be performed in half-sword, and can only target the eyes."
	attack_verb = list("masterfully pokes")
	intent_effect = /datum/status_effect/debuff/dazed/longsword2h
	target_parts = list(BODY_ZONE_PRECISE_R_EYE, BODY_ZONE_PRECISE_L_EYE)
	blade_class = BCLASS_STAB
	damfactor = 0.7 //they're stabbing you and it's going to hurt a little
	clickcd = 20
	swingdelay = 10
	swingdelay_type = SWINGDELAY_PENALTY //less scary but still debilitating debuff. you should be riposting against these on reaction if you can

// A weaker strike for sword with high damage so that it don't end up becoming better than mace
/datum/intent/sword/strike/bad
	damfactor = 0.5

/datum/intent/sword/strike/master //unused
	name = "ganvale"
	desc = "Hit your opponent with your sword's special crossguard, dealing slightly more damage than a regular sword's bash."
	attack_verb = list("deftly slams")
	damfactor = 0.75 //replaces clinch as the actual blunt damage dealer
	max_intent_damage = 24


/datum/intent/sword/chop
	name = "chop"
	icon_state = "inchop"
	attack_verb = list("chops", "hacks")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = PEN_LIGHT
	swingdelay = 8
	damfactor = 1.0
	item_d_type = "slash"

/datum/intent/sword/chop/short
	damfactor = 0.9

/datum/intent/sword/chop/long
	reach = 2

/datum/intent/sword/cut/light
	damfactor = 0.9

/datum/intent/sword/cut/long
	clickcd = CLICK_CD_QUICK // Longsword 2H cut — faster than default, no extra damage

/datum/intent/sword/cut/falx
	penfactor = PEN_LIGHT
	clickcd = CLICK_CD_QUICK

/datum/intent/sword/chop/falx
	penfactor = PEN_MEDIUM

/datum/intent/sword/cut/krieg
	damfactor = 1.2
	clickcd = CLICK_CD_QUICK

/datum/intent/sword/chop/sabre
	damfactor = 1.15
	penfactor = PEN_MEDIUM

/datum/intent/rend/krieg
	intent_intdamage_factor = 0.2

/datum/intent/sword/cut/rend
	name = "rend"
	icon_state = "inrend"
	attack_verb = list("rends", "cleaves")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	reach = 1
	swingdelay = 15
	penfactor = PEN_NONE
	damfactor = 2.5
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE
	item_d_type = "slash"
	misscost = 10
	intent_intdamage_factor = 0.05
	demolition_mod = 0.05

/datum/intent/sword/chop/cleave
	name = "cleave"
	icon_state = "intear"
	attack_verb = list("cleaves", "tears through")
	chargedrain = 1.8
	chargetime = 12
	swingdelay = 0
	damfactor = 1.5
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

/datum/intent/sword/chop/cleave/super
	name = "unstoppable cleave"
	penfactor = PEN_BSTEEL

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
	penfactor = PEN_HEAVY	// Penetrates mail/plate at same-tier 20%. Estoc's purpose — point blank, telegraphed.
	swingdelay_type = SWINGDELAY_PENALTY
	damfactor = 1.3
	swingdelay = 0.6 SECONDS

/datum/intent/sword/thrust/estoc/lunge
	name = "lunge"
	icon_state = "inlance"
	attack_verb = list("lunges")
	penfactor = PEN_LIGHT	// Fast attrition thrust — light pen, no swingdelay, quick clickcd.
	damfactor = 1.1
	swingdelay = 0
	clickcd = CLICK_CD_QUICK
	reach = 2

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

