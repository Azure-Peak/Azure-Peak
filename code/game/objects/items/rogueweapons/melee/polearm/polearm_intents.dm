/datum/intent/spear/thrust
	name = "thrust"
	blade_class = BCLASS_STAB
	attack_verb = list("thrusts")
	animname = "stab"
	icon_state = "instab"
	reach = 2
	clickcd = CLICK_CD_CHARGED
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_HEAVY
	item_d_type = "stab"
	effective_range = 2
	effective_range_type = EFF_RANGE_EXACT

/datum/intent/spear/thrust/polearm
	name = "weak thrust"
	desc = "A weak thrust from a polearm not designed for stabbing. Doesn't care about effective range, \
	but also incapable of piercing all but the weakest cloth armor."
	penfactor = PEN_LIGHT
	damfactor = 1
	effective_range = null
	effective_range_type = EFF_RANGE_NONE

/datum/intent/spear/thrust/training
	name = "blunted thrust"
	penfactor = PEN_NONE
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')

/datum/intent/spear/thrust/oneh
	name = "one-handed thrust"
	reach = 1
	swingdelay = 14
	damfactor = 1.6
	penfactor = PEN_HEAVY
	clickcd = CLICK_CD_RESIST
	effective_range = null
	effective_range_type = EFF_RANGE_NONE
	sharpness_penalty = 3

/datum/intent/spear/thrust/oneh/training
	name = "blunted one-handed thrust"
	penfactor = PEN_NONE
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')

/datum/intent/spear/thrust/militia
	penfactor = PEN_MEDIUM

/datum/intent/spear/thrust/pike		//EXPERIMENTAL
	name = "pike thrust"
	desc = "Thrust your pike forward from its furthest end to reach farther ahead than any spear ever could. Only effective at three paces."
	damfactor = 1.15
	reach = 3
	effective_range = 3
	clickcd = CLICK_CD_CHARGED + 1
	swingdelay = 1.5

/datum/intent/spear/thrust/pike/skewer		//EXPERIMENTAL
	name = "pike lance"
	desc = "Grab your pike from a closer end and charge forward with your whole body for devastating damage."
	clickcd = CLICK_CD_HEAVY + 4
	swingdelay = 6
	damfactor = 1.5
	penfactor = PEN_MEDIUM
	max_intent_damage = 54
	reach = 2
	effective_range = 2
	icon_state = "inlance"
	attack_verb = list("lances", "runs through", "skewers")

/datum/intent/spear/thrust/short
	reach = 1
	damfactor = 0.9
	penfactor = PEN_MEDIUM
	effective_range = null
	effective_range_type = EFF_RANGE_NONE

/datum/intent/spear/bash
	name = "bash"
	blade_class = BCLASS_BLUNT
	penfactor = PEN_NONE
	icon_state = "inbash"
	attack_verb = list("bashes", "strikes")
	damfactor = NONBLUNT_BLUNT_DAMFACTOR
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

// Eaglebeak has a decent bash with range
/datum/intent/spear/bash/polehammer //Used for something that is not just eagle beak
	name = "crushing bash"
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	damfactor = 1
	reach = 2

/datum/intent/spear/bash/ranged
	reach = 2

/datum/intent/spear/cut
	name = "cut"
	blade_class = BCLASS_CUT
	attack_verb = list("cuts", "slashes")
	icon_state = "incut"
	damfactor = 1
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	reach = 2
	item_d_type = "slash"

/datum/intent/spear/cut/oneh
	name = "one-handed cut"
	reach = 1
	swingdelay = 6
	sharpness_penalty = 2

/datum/intent/spear/cut/oneh/pike
	name = "weak cut"
	desc = "An awkward one-handed slash with a pike too long to swing properly."
	damfactor = 0.6

/datum/intent/spear/cut/scythe
	reach = 3
	damfactor = 1

/datum/intent/spear/cut/bardiche/cleave
	name = "cleaving cut"
	icon_state = "incleave"
	attack_verb = list("cleaves", "carves through")
	clickcd = CLICK_CD_MASSIVE
	damfactor = 1.0
	cleave = /datum/cleave_pattern/forward_cleave
	desc = "A cleave that cuts through a second target behind the first."

/datum/intent/spear/cut/glaive
	damfactor = 1.2
	chargetime = 0

/datum/intent/spear/cut/glaive/sweep
	name = "sweeping cut"
	icon_state = "insweep"
	attack_verb = list("sweeps through", "cuts across")
	clickcd = CLICK_CD_GLACIAL
	cleave = /datum/cleave_pattern/horizontal_sweep
	desc = "A sweep that cuts through targets to the front."

/datum/intent/spear/cut/short
	reach = 1

/datum/intent/spear/cast
	name = "cast"
	chargetime = 0
	noaa = TRUE
	misscost = 0
	icon_state = "inuse"
	no_attack = TRUE

/datum/intent/spear/cut/naginata
	damfactor = 1.2
	chargetime = 0

/datum/intent/spear/cut/naginata/sweep
	name = "sweeping cut"
	icon_state = "insweep"
	attack_verb = list("sweeps through", "cuts across")
	clickcd = CLICK_CD_GLACIAL
	cleave = /datum/cleave_pattern/horizontal_sweep
	desc = "A sweep that cuts through targets to the front."

/datum/intent/rend
	name = "rend"
	icon_state = "inrend"
	attack_verb = list("rends", "cleaves")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	reach = 1
	swingdelay = 1 SECONDS
	swingdelay_type = SWINGDELAY_PENALTY
	penfactor = PEN_NONE
	damfactor = 2.5
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE
	item_d_type = "slash"
	misscost = 10
	intent_intdamage_factor = 0.05
	demolition_mod = 0.05

/datum/intent/rend/apophis
	damfactor = 2.2
	intent_intdamage_factor = 0.2

/datum/intent/rend/reach
	name = "long rend"
	penfactor = PEN_NONE
	misscost = 5
	swingdelay = 15
	clickcd = CLICK_CD_HEAVY
	damfactor = 2
	reach = 2

/datum/intent/rend/reach/partizan
	name = "rending thrust"
	attack_verb = list("skewers", "cleaves")
	blade_class = BCLASS_STAB
	swingdelay = 8
	misscost = 20
	damfactor = 1.8
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	item_d_type = "stab"
	no_early_release = TRUE
	intent_intdamage_factor = 0.1

// Billhook-specific intents.
/datum/intent/spear/dismount
	name = "dismounting hook"
	blade_class = BCLASS_STAB
	attack_verb = list("hooks")
	damfactor = 0.6
	animname = "stab"
	icon_state = "inlunge"
	reach = 2
	desc = "Hook an opponent with your polearm, forcefully dismounting them should they be on horseback. Must strike the rider themselves and not their mount and does not work on horseback."
	clickcd = CLICK_CD_CHARGED
	swingdelay_type = SWINGDELAY_CANCEL
	swingdelay = 1 SECONDS //1 second for the horse to pull out of range, pretty hard to land.
	clickcd = 1.3 SECONDS
	warnie = "mobwarning"
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_LIGHT //Bad for anything but its intended purpose
	item_d_type = "stab"
	effective_range = 2
	effective_range_type = EFF_RANGE_EXACT

/datum/intent/spear/dismount/spec_on_apply_effect(mob/living/H, mob/living/user, params)
	var/target_buckled = H.buckled ? TRUE : FALSE
	if(!target_buckled)
		return
	if(istype(H.buckled, /obj/structure/flora/roguegrass/maneater)) //We don't want this being used on people stuck in maneaters, as funny as that sounds.
		return
	H.buckled.unbuckle_mob(H)
	H.Knockdown(50)
	H.Paralyze(10)
	var/turf/edge_target_turf = get_edge_target_turf(H, get_dir(H, user))
	if(istype(edge_target_turf))
		H.safe_throw_at(edge_target_turf, 1, 1, user, spin = TRUE)
	user.visible_message(span_danger("[user] digs the hook of their weapon into [H] and brings them crashing down!"))
	playsound(H.loc, 'sound/foley/zfall.ogg', 100, FALSE)
	H.visible_message(span_danger("[H] falls off their mount!"))

// Polehammer-specific intents.
/datum/intent/mace/smash/eaglebeak
	reach = 2
	clickcd = CLICK_CD_HEAVY // Slightly longer since it has RANGE. Don't want to increase charge time more since it is unreliable.

// Spellblade-specific intents.
/datum/intent/spear/thrust/azurean
	name = "thrust"
	desc = "A quick, nimble two-handed thrust. Keeps reach but lacks the power to pierce armor."
	reach = 2
	clickcd = CLICK_CD_QUICK // Long range, quick poke, NO AP
	penfactor = PEN_NONE
	damfactor = 1
	effective_range = null
	effective_range_type = EFF_RANGE_NONE

/datum/intent/spear/thrust/azurean/oneh
	name = "one-handed thrust"
	desc = "A rapid jab from one hand. Fast with long range, but unable to penetrate armor."
	reach = 2
	clickcd = CLICK_CD_QUICK // capture that nimble feel
	penfactor = PEN_NONE
	damfactor = 1
	effective_range = null
	effective_range_type = EFF_RANGE_NONE

/datum/intent/spear/thrust/azurean/pick
	name = "pick"
	icon_state = "inpick"
	desc = "A shortspear is nimble enough to handle when two-handed and gripped toward the blade. Grasps it near the end and drive it into the weak point of your opponent's armor - hard to pull off but can be devastating if successful."
	blade_class = BCLASS_PICK
	attack_verb = list("impales", "drives into")
	hitsound = list('sound/combat/hits/pick/genpick (1).ogg', 'sound/combat/hits/pick/genpick (2).ogg')
	reach = 1
	clickcd = 18
	swingdelay = 14
	penfactor = PEN_HEAVY
	damfactor = 0.8
	item_d_type = "stab"
	effective_range = null
	effective_range_type = EFF_RANGE_NONE

// Lance-specific intents.
/datum/intent/spear/thrust/lance
	damfactor = 1.25 // Turns its base damage into 30 on the two-hand thrust. It keeps the spear thrust one handed.

/datum/intent/lance
	name = "lance"
	icon_state = "inlance"
	attack_verb = list("lances", "runs through", "skewers")
	animname = "stab"
	item_d_type = "stab"
	penfactor = PEN_NONE
	chargetime = 4 SECONDS
	damfactor = 4
	reach = 2
	cleave = /datum/cleave_pattern/lance

/datum/intent/lance/onehand
	chargetime = 4 SECONDS
	swingdelay = 1 SECONDS
	reach = 2
	damfactor = 4 // 25% less damage
	cleave = /datum/cleave_pattern/lance

//Quarterstaff-specific intents.
/datum/intent/spear/bash/staff
	name = "staff bash"
	damfactor = 1
	reach = 1
	intent_intdamage_factor = 1
	clickcd = CLICK_CD_CHARGED

/datum/intent/spear/bash/staff/onehand
	damfactor = NONBLUNT_BLUNT_DAMFACTOR

/datum/intent/spear/bash/woodstaff
	intent_intdamage_factor = 1

/datum/intent/spear/bash/ranged/woodstaff
	intent_intdamage_factor = 1

/datum/intent/spear/bash/ranged/quarterstaff
	damfactor = 1
	intent_intdamage_factor = 1

/datum/intent/spear/bash/quarterstaff
	damfactor = 0.8
	intent_intdamage_factor = 1

/datum/intent/spear/thrust/quarterstaff
	name = "jab"
	desc = "A quick, light jab with the end of the staff. Weaker than a bash, but faster. Unlike a spear's thrust, it has no sweet spot to find."
	blade_class = BCLASS_BLUNT
	attack_verb = list("jabs", "prods")
	hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg')
	penfactor = PEN_NONE
	damfactor = 0.9
	clickcd = CLICK_CD_QUICK
	item_d_type = "blunt"
	effective_range = null
	effective_range_type = EFF_RANGE_NONE
	intent_intdamage_factor = 1

/datum/intent/mace/smash/quarterstaff
	reach = 2

/datum/intent/sword/disarm/quarterstaff
	desc = "Slip the light shaft against the target's weapon and lever it away. While it deals no damage on its own, successfully striking the target while they're off-balanced will disarm them."
	attack_verb = list("hooks", "pries")
	reach = 2

/datum/intent/effect/hobble/quarterstaff
	name = "leg sweep"
	desc = "A low, sweeping strike at the legs with the iron-shod end of the staff, hobbling the target's movement."
	attack_verb = list("sweeps", "hobbles")
	reach = 2
	damfactor = 0.6

/datum/intent/effect/daze/quarterstaff
	name = "counterweight strike"
	desc = "Whip the metal-weighted butt of the staff up into the target's head, dazing them."
	attack_verb = list("cracks", "dazes")
	intent_intdamage_factor = 1

/datum/intent/spear/bash/quarterstaff/rapid
	name = "rapid strike"
	desc = "Short, quick blows from a choked-up grip. Keeps pressure on lightly armored foes."
	attack_verb = list("raps", "strikes", "cracks")
	damfactor = 0.85
	clickcd = CLICK_CD_MELEE

/datum/intent/mace/strike/dislocate/quarterstaff
	name = "joint strike"
	desc = "Drive the shaft into an elbow or knee from up close. </br>Deals TWIST damage instead of BLUNT damage. Critical hits cause DISLOCATIONS, instead of FRACTURES. </br>DISLOCATED ARMS and HANDS cannot wield, grab, or use anything. </br>DISLOCATED LEGS and FEET prevent the target from standing."
	attack_verb = list("jams", "levers", "cracks")
	damfactor = 1.1

/datum/intent/effect/daze/longsword/clinch/quarterstaff
	name = "shaft clinch"
	desc = "Step inside your opponent's guard and drive the middle of the shaft into their face. Very briefly reduces opponent's strength, making it easier to escape a grab."
	attack_verb = list("clinches and bars")
	intent_intdamage_factor = 1
	hitsound = list('sound/combat/hits/blunt/woodblunt (1).ogg', 'sound/combat/hits/blunt/woodblunt (2).ogg')

/datum/intent/spear/bash/quarterstaff/long
	name = "long swing"
	desc = "A wide, heavy swing from the very end of the staff, trading speed for leverage."
	attack_verb = list("swings at", "clubs", "wallops")
	reach = 2
	damfactor = 1.25
	swingdelay = 4
	clickcd = CLICK_CD_CHARGED
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/spear/thrust/quarterstaff/long
	name = "long thrust"
	desc = "Thrust from the butt of the staff to keep a foe at the furthest possible length. Only effective at three paces."
	reach = 3
	damfactor = 1.15
	effective_range = 3
	effective_range_type = EFF_RANGE_EXACT
	clickcd = CLICK_CD_CHARGED
	swingdelay = 1.5

/datum/intent/mace/smash/quarterstaff/long
	name = "levering smash"
	desc = "Swing the full length of the staff to drive a foe back. Delivers Strength-scaling knockback and slowdown to the target, ranging from X (1 tile) to XIII (3 tiles). </br>Cannot inflict any knockback or slowdown if your Strength is below X. </br>Cannot be used consecutively more than every 5 seconds on the same target. </br>Prone targets halve the knockback distance. </br>Not fully charging the attack limits knockback to 1 tile."
	maxrange = 3

/datum/intent/spear/bash/quarterstaff/overhead
	name = "overhead crack"
	desc = "A charged, two-handed overhead blow from the end of the staff, meant to batter armor rather than flesh."
	icon_state = "instrike"
	attack_verb = list("cracks down on", "batters")
	reach = 2
	damfactor = 1
	chargetime = 8
	chargedrain = 1
	clickcd = CLICK_CD_HEAVY
	intent_intdamage_factor = 1.5
