//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/axe/cut
	name = "cut"
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("cuts", "slashes")
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	animname = "cut"
	penfactor = 0
	damfactor = 1.3
	demolition_mod = 2
	clickcd = CLICK_CD_HEAVY
	chargetime = 0
	item_d_type = "slash"

/datum/intent/axe/chop
	name = "chop"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("chops", "hacks")
	animname = "chop"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 25
	damfactor = 1.3
	demolition_mod = 4
	swingdelay = 6
	clickcd = CLICK_CD_HEAVY
	item_d_type = "slash"

/datum/intent/axe/chop/scythe
	reach = 2

/datum/intent/axe/chop/stone
	penfactor = 5

/datum/intent/axe/chop/halberd
	damfactor = 1.35
	swingdelay = 12
	penfactor = 20

/datum/intent/axe/thrust
	name = "stab"
	icon_state = "instab"
	attack_verb = list("stabs")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 0 
	damfactor = 0.9 //Lesser variant of the Stab intent for battle axes that have spikes on them. Mordhau-maxxing, as it were.
	chargetime = 0
	swingdelay = 0
	item_d_type = "stab"

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
	damfactor = NONBLUNT_BLUNT_DAMFACTOR //Not a real blunt weapon, so less damage.
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/axe/bash/battle
	name = "heavy bash"
	damfactor = 0.8 //Buttstrokes, in essence. +20% damage over the standard variant.

// Special Intents
/datum/intent/axe/chop/long/graggar
	penfactor = 40
