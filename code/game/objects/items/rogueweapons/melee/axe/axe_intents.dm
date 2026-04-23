//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/axe/cut
	name = "cut"
	icon_state = "incut"
	blade_class = BCLASS_CUT
	attack_verb = list("cuts", "slashes")
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	animname = "cut"
	penfactor = PEN_LIGHT
	damfactor = 1.3
	demolition_mod = 2.5
	clickcd = CLICK_CD_CHARGED // Shield DPS: 10 / 1.4 = 8.9. Will out DPS sword no matter what.
	chargetime = 0
	item_d_type = "slash"

/datum/intent/axe/chop
	name = "chop"
	icon_state = "inchop"
	blade_class = BCLASS_CHOP
	attack_verb = list("chops", "hacks")
	animname = "chop"
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = PEN_MEDIUM
	damfactor = 1.5
	demolition_mod = 5
	swingdelay = 0.8 SECONDS
	swingdelay_type = SWINGDELAY_PENALTY
	clickcd = CLICK_CD_CHARGED // Effective Shield DPS: 25 / 2.4 = 10.4
	item_d_type = "slash"

/datum/intent/axe/chop/heavy
	name = "hack"
	icon_state = "inhack"
	penfactor = PEN_BSTEEL
	damfactor = 1.5
	swingdelay = 1 SECONDS
	
	candodge = FALSE
	canparry = FALSE
	swingdelay_type = SWINGDELAY_CANCEL

/datum/intent/axe/chop/scythe
	reach = 2

/datum/intent/axe/chop/stone
	penfactor = PEN_NONE

/datum/intent/axe/chop/halberd
	damfactor = 1.3
	reach = 2

/datum/intent/axe/bash
	name = "bash"
	icon_state = "inbash"
	attack_verb = list("bashes", "clubs")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	chargetime = 0
	penfactor = PEN_NONE
	swingdelay = 5
	damfactor = NONBLUNT_BLUNT_DAMFACTOR //Not a real blunt weapon, so less damage.
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/axe/bash/battle
	name = "heavy bash"
	damfactor = 0.8 //Buttstrokes, in essence. +20% damage over the standard variant.
