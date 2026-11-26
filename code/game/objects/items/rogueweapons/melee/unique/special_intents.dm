//Katar-specific intents.
/datum/intent/katar/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = PEN_LIGHT
	chargetime = 0
	swingdelay = 0
	damfactor = 1.2
	clickcd = CLICK_CD_QUICK
	item_d_type = "slash"

/datum/intent/katar/thrust
	name = "thrust"
	icon_state = "instab"
	attack_verb = list("thrusts")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = PEN_MEDIUM // This make them good vs other light armor users
	// So they don't need extra bonus damage on top
	chargetime = 0
	clickcd = CLICK_CD_QUICK
	item_d_type = "stab"

/datum/intent/axe/chop/arbelos
	damfactor = 1.3
	clickcd = CLICK_CD_QUICK //Quicker than a conventional axe, but slower than a katar.

/datum/intent/axe/cut/arbelos
	damfactor = 1.15
	clickcd = CLICK_CD_QUICK //Same speed as a katar, but with reduced penetration and half-damage. Main appeal's the chopper.

/datum/intent/katar/thrust/arbelos
	penfactor = PEN_LIGHT
	damfactor = 0.8
	clickcd = CLICK_CD_QUICK //Slower than a regular thrust, with slightly less penetration and damage. Inverse to the katar.

/datum/intent/axe/chop/arbelos
	damfactor = 1.3
	clickcd = CLICK_CD_QUICK //Quicker than a conventional axe, but slower than a katar.

/datum/intent/axe/cut/arbelos
	damfactor = 1.15
	clickcd = CLICK_CD_FAST //Same speed as a katar, but with reduced penetration and half-damage. Main appeal's the chopper.

/datum/intent/katar/thrust/arbelos
	penfactor = PEN_LIGHT
	damfactor = 0.8
	clickcd = CLICK_CD_QUICK //Slower than a regular thrust, with slightly less penetration and damage. Inverse to the katar.

// Scepter-specific intents.
/datum/intent/lordbash
	name = "bash"
	blade_class = BCLASS_BLUNT
	icon_state = "inbash"
	attack_verb = list("bashes", "strikes")
	penfactor = PEN_NONE
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR

/datum/intent/lord_electrocute
	name = "electrocute"
	desc = "Punish someone in the manor with a shocking bolt while they are within range of your rod. They must hold a Meister account. Can only be used by the Grand Duke."
	blade_class = null
	icon_state = "inshock"
	tranged = TRUE
	noaa = TRUE

/datum/intent/lord_electrocute/on_afterattack(atom/target, mob/living/user, proximity_flag, params)
	var/obj/item/rogueweapon/lordscepter/rod = masteritem
	if(!istype(rod))
		return
	var/mob/living/carbon/human/H = rod.get_rod_target(target, user)
	if(!H)
		return
	user.visible_message(span_warning("[user] electrocutes [H] with [rod]."))
	user.Beam(H, icon_state = "lightning[rand(1,12)]", time = 5)
	H.electrocute_act(5, rod)
	COOLDOWN_START(rod, scepter, 20 SECONDS)
	to_chat(H, span_danger("I'm electrocuted by the scepter!"))

/datum/intent/lord_silence
	name = "silence"
	desc = "Silence someone in the manor for twenty seconds while they are within range of your rod. They must hold a Meister account. Can only be used by the Grand Duke."
	blade_class = null
	icon_state = "insilence"
	tranged = TRUE
	noaa = TRUE

/datum/intent/lord_silence/on_afterattack(atom/target, mob/living/user, proximity_flag, params)
	var/obj/item/rogueweapon/lordscepter/rod = masteritem
	if(!istype(rod))
		return
	var/mob/living/carbon/human/H = rod.get_rod_target(target, user)
	if(!H)
		return
	user.visible_message(span_warning("[user] silences [H] with [rod]."))
	H.set_silence(20 SECONDS)
	COOLDOWN_START(rod, scepter, 10 SECONDS)
	to_chat(H, span_danger("I'm silenced by the scepter!"))

// Claw-specific intents.
/datum/intent/claw/chop
	name = "chop"
	icon_state = "inchop"
	attack_verb = list("chops", "hacks")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	item_d_type = "slash"
	penfactor = PEN_MEDIUM
	damfactor = 1.1
	swingdelay = 10
	clickcd = CLICK_CD_HEAVY

/datum/intent/claw/chop/gronn
	penfactor = PEN_NONE
	damfactor = 0.7
	intent_intdamage_factor = 3
	swingdelay = 11
	clickcd = CLICK_CD_MELEE

/datum/intent/claw/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	item_d_type = "slash"
	penfactor = PEN_LIGHT
	damfactor = 0.8
	clickcd = CLICK_CD_MELEE

/datum/intent/claw/cut/gronn
	damfactor = 0.6
	intent_intdamage_factor = 0.5
	clickcd = CLICK_CD_QUICK

/datum/intent/claw/rend
	name = "rend"
	icon_state = "inrend"
	attack_verb = list("rends")
	animname = "cut"
	blade_class = BCLASS_CHOP
	reach = 1
	penfactor = PEN_NONE
	swingdelay = 20
	damfactor = 2.5
	clickcd = CLICK_CD_HEAVY
	no_early_release = TRUE
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_d_type = "slash"
	misscost = 10
	intent_intdamage_factor = 0.05
	demolition_mod = 0.05
