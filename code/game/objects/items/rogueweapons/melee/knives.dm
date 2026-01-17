//intent datums ฅ^•ﻌ•^ฅ

/datum/intent/dagger
	clickcd = 8

/datum/intent/dagger/cut
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_CUT
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 0
	chargetime = 0
	swingdelay = 0
	clickcd = 10
	item_d_type = "slash"

/// For unusually heavy daggers with a strong cutting edge.
/datum/intent/dagger/cut/heavy
	name = "heavy cut"
	damfactor = 1.2
	penfactor = 20
	clickcd = 11

/datum/intent/dagger/thrust
	name = "thrust"
	icon_state = "instab"
	attack_verb = list("thrusts")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 40
	chargetime = 0
	clickcd = 8
	item_d_type = "stab"

// A slightly weaker thrust for daggers with a curved blade, or which otherwise aren't very good at stabbing.
/datum/intent/dagger/thrust/weak
	name = "lopsided thrust"
	damfactor = 0.8

/datum/intent/dagger/thrust/pick
	name = "icepick stab"
	icon_state = "inpick"
	attack_verb = list("stabs", "impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 80
	clickcd = 14
	swingdelay = 12
	damfactor = 1.1
	blade_class = BCLASS_PICK

/datum/intent/dagger/sucker_punch
	name = "unevadable punch"
	icon_state = "inpunch"
	attack_verb = list("punches", "jabs", "clocks", "swings past")
	animname = "strike"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/bluntsmall (1).ogg', 'sound/combat/hits/blunt/bluntsmall (2).ogg', 'sound/combat/hits/kick/kick.ogg')
	damfactor = 0.6 // Less damage than a normal attack I don't want this to be better than stabbing
	penfactor = BLUNT_DEFAULT_PENFACTOR
	clickcd = 14
	recovery = 10
	item_d_type = "blunt"
	intent_intdamage_factor = BLUNT_DEFAULT_INT_DAMAGEFACTOR
	canparry = FALSE
	candodge = FALSE

/datum/intent/dagger/chop
	name = "chop"
	icon_state = "inchop"
	attack_verb = list("chops")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 10
	damfactor = 1.5
	swingdelay = 5
	clickcd = 10
	item_d_type = "slash"

/datum/intent/dagger/chop/cleaver
	hitsound = list('sound/combat/hits/bladed/genchop (1).ogg', 'sound/combat/hits/bladed/genchop (2).ogg', 'sound/combat/hits/bladed/genchop (3).ogg')
	penfactor = 30

//knife and dagger objs ฅ^•ﻌ•^ฅ

/obj/item/rogueweapon/huntingknife
	force = 12
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust, /datum/intent/dagger/chop)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	name = "hunting knife"
	desc = "A hunter's prized possession. Keep it sharp, and it might last you through the wild."
	icon_state = "huntingknife"
	sheathe_icon = "huntingknife"
	icon = 'icons/roguetown/weapons/daggers32.dmi'
	item_state = "bone_dagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	gripsprite = FALSE
	//dropshrink = 0.75
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	max_blade_int = 200
	max_integrity = 175
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	associated_skill = /datum/skill/combat/knives
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	throwforce = 12
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	thrown_bclass = BCLASS_CUT
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/iron

	grid_height = 64
	grid_width = 32

	equip_delay_self = 1 SECONDS
	unequip_delay_self = 1 SECONDS
	inv_storage_delay = 1 SECONDS
	edelay_type = 1

	//flipping knives has a cooldown on to_chat to reduce chatspam
	COOLDOWN_DECLARE(flip_cooldown)

/obj/item/rogueweapon/huntingknife/Initialize()
	..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/peasantry/maciejowski_knife,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/item/rogueweapon/huntingknife/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = -10,"sy" = 0,"nx" = 11,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/huntingknife/rmb_self(mob/user)
	. = ..()
	if(.)
		return

	SpinAnimation(4, 2) // The spin happens regardless of the cooldown

	if(!COOLDOWN_FINISHED(src, flip_cooldown))
		return

	COOLDOWN_START(src, flip_cooldown, 3 SECONDS)
	if((user.get_skill_level(/datum/skill/combat/knives) < 3) && prob(40))
		user.visible_message(
			span_danger("While trying to flip [src] [user] drops it instead!"),
			span_userdanger("While trying to flip [src] you drop it instead!"),
		)
		var/mob/living/carbon/human/unfortunate_idiot = user
		var/dropped_knife_target = pick(
			BODY_ZONE_PRECISE_L_FOOT,
			BODY_ZONE_PRECISE_R_FOOT,
			)
		unfortunate_idiot.apply_damage(src.force, BRUTE, dropped_knife_target)
		user.dropItemToGround(src, TRUE)
	else
		user.visible_message(
			span_notice("[user] spins [src] around [user.p_their()] finger"),
			span_notice("You spin [src] around your finger"),
		)
		playsound(src, 'sound/foley/equip/swordsmall1.ogg', 20, FALSE)

	return

/obj/item/rogueweapon/huntingknife/copper
	name = "copper knife"
	desc = "A knife made of copper. Lacking in durability."
	icon_state = "cdagger"
	max_integrity = 75
	smeltresult = null // TODO: We don't have partial melt so coping time

/obj/item/rogueweapon/huntingknife/bronze
	name = "bronze dagger"
	desc = "A wide blade of bronze, fitted to a wooden handle. Ancient laborers and priests coveted this tool above all else: both as a means to handle the dae's labors, and to indulge in the rituos of sacrifice."
	icon_state = "bronzedagger"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/bronze, /datum/intent/dagger/sucker_punch, /datum/intent/dagger/thrust/bronze)
	force = 18
	throwforce = 18
	max_blade_int = 225
	max_integrity = 175
	smeltresult = /obj/item/ingot/bronze

/datum/intent/dagger/thrust/bronze
	name = "piercing thrust"
	icon_state = "inpick"
	attack_verb = list("stabs", "impales")
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 55
	clickcd = 12
	swingdelay = 6 //Halfway point between a 'stab' and 'pick'.
	damfactor = 1.05
	blade_class = BCLASS_PICK

/datum/intent/dagger/chop/bronze
	name = "wedged chop"
	icon_state = "inchop"
	attack_verb = list("chops")
	animname = "chop"
	blade_class = BCLASS_CHOP
	hitsound = list('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
	penfactor = 15
	damfactor = 1.3
	swingdelay = 5
	clickcd = 10
	item_d_type = "slash"

/obj/item/rogueweapon/huntingknife/wood
	name = "wooden dagger"
	desc = "This wooden dagger is great for training."
	icon_state = "wood_dagger"
	possible_item_intents = list(/datum/intent/dagger/cut/wood, /datum/intent/dagger/chop/wood, /datum/intent/dagger/sucker_punch, /datum/intent/dagger/thrust/wood)
	force = 5
	throwforce = 5
	max_blade_int = 100
	max_integrity = 150
	smeltresult = null

/datum/intent/dagger/cut/wood
	name = "cut"
	icon_state = "incut"
	attack_verb = list("cuts", "slashes")
	animname = "cut"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = 0
	chargetime = 0
	swingdelay = 0
	clickcd = 10
	item_d_type = "slash"

/datum/intent/dagger/thrust/wood
	name = "piercing thrust"
	icon_state = "inpick"
	attack_verb = list("stabs", "impales")
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = 55
	clickcd = 12
	swingdelay = 6 //Halfway point between a 'stab' and 'pick'.
	damfactor = 1.05
	blade_class = BCLASS_BLUNT

/datum/intent/dagger/chop/wood
	name = "wedged chop"
	icon_state = "inchop"
	attack_verb = list("chops")
	animname = "chop"
	blade_class = BCLASS_BLUNT
	hitsound = list('sound/combat/hits/blunt/metalblunt (1).ogg', 'sound/combat/hits/blunt/metalblunt (2).ogg', 'sound/combat/hits/blunt/metalblunt (3).ogg')
	penfactor = 15
	damfactor = 1.3
	swingdelay = 5
	clickcd = 10
	item_d_type = "slash"

/obj/item/rogueweapon/huntingknife/cleaver
	force = 15
	name = "cleaver"
	desc = "Chop, chop, chop!"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver)
	icon_state = "cleaver"
	icon = 'icons/roguetown/weapons/daggers32.dmi'
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	throwforce = 15
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CHOP
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/huntingknife/cleaver/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,
"sx" = -10,
"sy" = 0,
"nx" = 13,
"ny" = 2,
"wx" = -8,
"wy" = 2,
"ex" = 5,
"ey" = 2,
"northabove" = 0,
"southabove" = 1,
"eastabove" = 1,
"westabove" = 0,
"nturn" = 21,
"sturn" = -18,
"wturn" = -18,
"eturn" = 21,
"nflip" = 0,
"sflip" = 8,
"wflip" = 8,
"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/huntingknife/chefknife
	force = 15
	name = "chef's knife"
	desc = "Keep it in the kitchen!"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver, /datum/intent/dagger/thrust)
	icon_state = "chefsknife"
	icon = 'icons/roguetown/weapons/daggers32.dmi'
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	throwforce = 15
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CUT
	w_class = WEIGHT_CLASS_SMALL
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/huntingknife/combat //>Combat knife //>Literally never seen it used in combat
	force = 22 //Hunting knife's bigger, meaner older brother. No pick intent, so it deserves a slight damage bump.
	name = "seax"
	desc = "An intimidatingly large sidearm that's been used amongst the Grenzels and Northerners for centuries, both as a combat knife and as a tool for dae-to-dae laboring."
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/cut/combat, /datum/intent/dagger/sucker_punch, /datum/intent/dagger/thrust/combat)
	icon_state = "combatknife"
	sheathe_icon = "combatknife"
	icon = 'icons/roguetown/weapons/daggers32.dmi'
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	throwforce = 16
	minstr = 9
	wdefense = 4
	slot_flags = ITEM_SLOT_HIP
	thrown_bclass = BCLASS_CHOP
	w_class = WEIGHT_CLASS_NORMAL
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/huntingknife/combat/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.7,"sx" = -10,"sy" = 0,"nx" = 11,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 14,"sturn" = -14,"wturn" = 16,"eturn" = 17,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/datum/intent/dagger/thrust/combat
	name = "wedged thrust"
	icon_state = "instab"
	attack_verb = list("gouges")
	animname = "stab"
	blade_class = BCLASS_STAB
	hitsound = list('sound/combat/hits/bladed/genstab (1).ogg', 'sound/combat/hits/bladed/genstab (2).ogg', 'sound/combat/hits/bladed/genstab (3).ogg')
	penfactor = 20
	damfactor = 0.9
	chargetime = 0
	clickcd = 8
	item_d_type = "stab"

/datum/intent/dagger/cut/combat
	name = "wicked slice"
	icon_state = "inrend"
	attack_verb = list("slices", "dices")
	animname = "cut"
	blade_class = BCLASS_CHOP
	reach = 1
	swingdelay = 10
	penfactor = BLUNT_DEFAULT_PENFACTOR
	damfactor = 2
	clickcd = CLICK_CD_CHARGED
	no_early_release = TRUE
	hitsound = list('sound/combat/hits/bladed/genslash (1).ogg', 'sound/combat/hits/bladed/genslash (2).ogg', 'sound/combat/hits/bladed/genslash (3).ogg')
	item_d_type = "slash"
	misscost = 5 
	intent_intdamage_factor = 0.05

/obj/item/rogueweapon/huntingknife/idagger
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/cut, /datum/intent/dagger/thrust/pick, /datum/intent/dagger/sucker_punch)
	force = 15
	max_integrity = 100
	name = "iron dagger"
	desc = "This is a common dagger of iron."
	icon_state = "idagger"
	sheathe_icon = "idagger"
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/huntingknife/idagger/warden_machete
	possible_item_intents = list(/datum/intent/dagger/thrust/weak, /datum/intent/dagger/cut/heavy, /datum/intent/dagger/chop/cleaver, /datum/intent/dagger/sucker_punch) // Stronger cut and chop, but no pick.
	force = 22 // Slightly more damage than a steel dagger.
	max_integrity = 130 // Slightly less integrity than a steel dagger.
	name = "Wardens' seax"
	desc = "A well-worn seax utilised by the Fraternity of Wardens both as a tool and weapon. Nearly as effective for hacking \
	down men as it is foiliage, but not quite as durable as more modern steel tools. More suitable for cutting than for thrusting."
	icon_state = "warden_machete"
	sheathe_icon = "warden_machete"

/obj/item/rogueweapon/huntingknife/idagger/virtue
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/cut, /datum/intent/dagger/thrust/pick, /datum/intent/dagger/sucker_punch)
	force = 12
	throwforce = 12
	max_integrity = 100
	name = "parrying dagger"
	desc = "A dagger with an enlongated crossguard, curved upwards on both ends to catch oncoming strikes."
	icon_state = "ddagger"
	sheathe_icon = "idagger"
	smeltresult = /obj/item/ingot/iron
	wdefense = 7

/obj/item/rogueweapon/huntingknife/idagger/adagger
	name = "decrepit dagger"
	desc = "A short blade, wrought from frayed bronze and tanged within a rotwooden grip. Pieces of a former legionnaire's scabbard cling to the glimmerless alloy."
	force = 12
	max_integrity = 75
	icon_state = "adagger"
	sheathe_icon = "adagger"
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	name = "ancient dagger"
	desc = "A short blade, forged from polished gilbranze. It is violence that shepherds progress, and it is progress that will free this world from mortality's chains. Zizo, Zizo, Zizo - I call upon thee; bring forth the undying, so that your works may yet be done!"
	icon_state = "adagger"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/huntingknife/idagger/steel
	name = "steel dagger"
	desc = "This is a dagger made of solid steel, more durable."
	icon_state = "sdagger"
	sheathe_icon = "sdagger"
	force = 20
	max_integrity = 150
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/huntingknife/idagger/steel/corroded
	name = "corroded dagger"
	desc = "A wicked deliverer of poison, serrated and notched. Curved steel cradles the knuckles, ensuring that the wielder doesn't inflict the fatal dose on themselves. </br>I can coat this dagger in most poisons, ensuring that my next strike leaves a festering surprise."
	icon_state = "pdagger"
	sheathe_icon = "pdagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/corroded/Initialize()
	. = ..()
	AddElement(/datum/element/tipped_item)	//Lets you tip your weapon in poison

/obj/item/rogueweapon/huntingknife/idagger/steel/corroded/dirk
	name = "fanged dagger"
	desc = "A dagger modeled after the fang of an anthrax spider. Can be poisoned."
	icon_state = "spiderdagger"
	sheathe_icon = "spiderdagger"
	smeltresult = null

/obj/item/rogueweapon/huntingknife/idagger/steel/holysee
	name = "eclipsum dagger"
	desc = "A sliver of heaven, shaped into an elegant dagger. The alloy radiates with magnificence: a reminder that no matter how dark the nites grow, there will always be a dawn to follow. Such a dagger is reserved for the Holy See's bishops and priests - both as a symbol of their divine authority, and as a means of ritualistic bloodletting. </br>'..come forth, child o' myne, and be anointed in the Pantheon's light once more..'"
	force = 30 //The only instance of this dagger existing, outside of special admin-ran events, is when the Priest joins. They spawn with this on their person. Should be safe from Judgement-tier thefts.
	throwforce = 33
	throw_speed = 3
	armor_penetration = 50 //Only accounted for when thrown. Plays into the idea of 'divine intervention' - a literal 'hail mary' when facing down a terrible beast.
	embedding = list("embedded_pain_multiplier" = 1, "embed_chance" = 99, "embedded_fall_chance" = 0) //The 'last resort' for a Bishop. Ensures penetration and embedding, at the cost of the dagger itself.
	max_integrity = 222
	max_blade_int = 333
	icon_state = "gsdagger"
	sheathe_icon = "gsdagger"
	smeltresult = /obj/item/ingot/silver
	is_silver = TRUE

/obj/item/rogueweapon/huntingknife/idagger/steel/holysee/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle
	name ="plaguebringer sickle"
	desc = "A wicked edge brings feculent delights."
	icon_state = "pestrasickle"
	force = 22 // 10% - This is a 8 clickCD weapon
	max_integrity = 200

/obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle/Initialize()
	. = ..()
	AddElement(/datum/element/tipped_item)	//Lets you tip your weapon in poison

/obj/item/rogueweapon/huntingknife/idagger/dtace
	name = "'De Tace'"
	desc = "The right hand of the right hand, this narrow length of steel serves as a quick solution to petty greviences."
	icon_state = "stiletto"
	sheathe_icon = "stiletto"
	force = 25
	max_integrity = 200
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/huntingknife/idagger/steel/parrying
	name = "steel parrying dagger"
	force = 12
	throwforce = 12
	desc = "This is a parrying dagger made of solid steel, used to catch opponent's weapons in the handguard. It's a bit more dull, however."
	sheathe_icon = "spdagger"
	max_integrity = 175
	wdefense = 8		//This way with expert dagger skill you'd have ~12 defense. 1 higher than a kiteshield, but no arrow protection.

/obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero
	name = "sail dagger"
	force = 15
	throwforce = 15
	desc = "An exceptionally protective parrying dagger popular in the Etruscan Isles, this dagger features a plain metal guard in the shape of a ship's sail."
	max_integrity = 200
	wdefense = 9		//This way with expert dagger skill you'd have ~13 defense. 2 higher than a kiteshield, but no arrow protection.
	icon_state = "sail_dagger"

/obj/item/rogueweapon/huntingknife/idagger/steel/special
	icon_state = "sdaggeralt"
	sheathe_icon = "sdaggeralt"

/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
	name = "steel tanto"
	desc = "A steel dagger imported from the Kazengunese archipelago. A sturdy blade bears a subtle curve, set into a decorated circular crossguard. A waxed \
	wrapping of twisted cordage provides a secure grip."
	icon_state = "eastdagger"
	sheathe_icon = "tanto"

/obj/item/rogueweapon/huntingknife/idagger/silver
	name = "silver dagger"
	desc = "A dagger of pure silver; the bane of vampyres, verevolves, deadites, and all other unsaintly nitecreechers. Errant light transforms into a blinding glare, when cast along the blade's edge."
	icon_state = "sildagger"
	sheathe_icon = "sildagger"
	force = 15
	wdefense = 6
	sellprice = 50
	smeltresult = /obj/item/ingot/silver
	last_used = 0
	is_silver = TRUE

/obj/item/rogueweapon/huntingknife/idagger/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/rogueweapon/huntingknife/idagger/silver/stake
	name = "silver-tipped stake"
	desc = "A branch that has been broken off of a boswellia tree, sharpened to a fine point and tipped with blessed silver. It can lay most unholy creechers to rest, but only by piercing their hearts."
	icon_state = "stake" //Should hopefully autogenerate an inhand. Need to politely ask a coder to import a custom sprite for this stake, later.
	icon = 'icons/roguetown/items/natural.dmi'
	force = 20
	throwforce = 20
	wdefense = 0
	max_integrity = 50
	sellprice = 50
	slot_flags = ITEM_SLOT_HIP
	smeltresult = /obj/item/rogueore/coal
	last_used = 0
	is_silver = TRUE
	equip_delay_self = 0 //No delay when stowing away, without a scabbard.
	unequip_delay_self = 0 //No delay when drawing.
	inv_storage_delay = 0 //No delay when retrieving from a storage slot.

/obj/item/rogueweapon/huntingknife/idagger/silver/stake/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 0,\
		added_def = 0,\
	)

/obj/item/rogueweapon/huntingknife/idagger/silver/stake/preblessed/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 100,\
		added_int = 0,\
		added_def = 0,\
	)

/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger
	name = "psydonic dagger"
	desc = "An ornate dagger, plated in a ceremonial veneer of silver. The bane of vampyres and verevolves, in the hands of a faithful hunter."
	icon_state = "psydagger"
	sheathe_icon = "psydagger"
	smeltresult = /obj/item/ingot/silverblessed
	sellprice = 70

/obj/item/rogueweapon/huntingknife/idagger/silver/psydagger/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 2,\
	)
	sellprice += 200

/obj/item/weapon/knife/dagger/silver/arcyne
	name = "glowing purple silver dagger"
	desc = "This dagger glows a faint purple. Quicksilver runs across its blade."
	var/is_bled = FALSE

/obj/item/weapon/knife/dagger/silver/arcyne/Initialize()
	. = ..()
	filter(type="drop_shadow", x=0, y=0, size=2, offset=1, color=rgb(128, 0, 128, 1))

/obj/item/weapon/knife/dagger/silver/attackby(obj/item/M, mob/user, params)
	if(istype(M,/obj/item/rogueore/cinnabar))
		var/crafttime = (60 - ((user.get_skill_level(/datum/skill/magic/arcane)) * 5))
		if(do_after(user, crafttime, target = src))
			playsound(loc, 'sound/magic/scrapeblade.ogg', 100, TRUE)
			to_chat(user, span_notice("I press acryne magic into the blade and it throbs in a deep purple..."))
			var/obj/arcyne_knife = new /obj/item/weapon/knife/dagger/silver/arcyne
			qdel(M)
			qdel(src)
			user.put_in_active_hand(arcyne_knife)
	else
		return ..()

/obj/item/weapon/knife/dagger/silver/arcyne/attack_self(mob/living/carbon/human/user)
	if(!isarcyne(user))
		return
	var/obj/effect/decal/cleanable/roguerune/pickrune
	var/runenameinput = input(user, "Runes", "All Runes") as null|anything in GLOB.t4rune_types
	pickrune = GLOB.rune_types[runenameinput]
	if(!pickrune)
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/decal/cleanable/roguerune) in Turf)
		to_chat(user, span_cult("There is already a rune here."))
		return
	var/structures_in_way = check_for_structures_and_closed_turfs(loc, pickrune)
	if(structures_in_way == TRUE)
		to_chat(user, span_cult("There is a structure, rune or wall in the way."))
		return
	var/chosen_keyword
	if(pickrune.req_keyword)
		chosen_keyword = stripped_input(user, "Keyword for the new rune", "Runes", max_length = MAX_NAME_LEN)
		if(!chosen_keyword)
			return FALSE
	if(!is_bled)
		playsound(loc, get_sfx("genslash"), 100, TRUE)
		user.visible_message(span_warning("[user] cuts open [user.p_their()] palm!"), \
			span_cult("I slice open my palm!"))
		if(user.blood_volume)
			user.apply_damage(pickrune.scribe_damage, BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		is_bled = TRUE
	var/crafttime = (10 SECONDS - ((user.get_skill_level(/datum/skill/magic/arcane)) * 5))

	user.visible_message(span_warning("[user] begins to carve something with [user.p_their()] blade!"), \
		span_notice("I start to drag the blade in the shape of symbols and sigils."))
	playsound(loc, 'sound/magic/bladescrape.ogg', 100, TRUE)
	if(do_after(user, crafttime, target = src))
		if(QDELETED(src) || !pickrune)
			return
		user.visible_message(span_warning("[user] carves an arcyne rune with [user.p_their()] [src]!"), \
		span_notice("I finish dragging the blade in symbols and circles, leaving behind a [pickrune.name]."))
		new pickrune(Turf, chosen_keyword)

/obj/item/weapon/knife/dagger/proc/check_for_structures_and_closed_turfs(loc, obj/effect/decal/cleanable/roguerune/rune_to_scribe)
	for(var/turf/T in range(loc, rune_to_scribe.runesize))
		//check for /sturcture subtypes in the turf's contents
		for(var/obj/structure/S in T.contents)
			return TRUE		//Found a structure, no need to continue
		//check if turf itself is a /turf/closed subtype
		if(istype(T,/turf/closed))
			return TRUE
		//check if rune in the turfs contents
		for(var/obj/effect/decal/cleanable/roguerune/R in T.contents)
			return TRUE
		//Return false if nothing in range was found
	return FALSE

/obj/item/rogueweapon/huntingknife/stoneknife
	possible_item_intents = list(/datum/intent/dagger/cut,/datum/intent/dagger/chop)
	name = "stone knife"
	desc = "A crudely crafted knife made of stone."
	icon_state = "stone_knife"
	smeltresult = null
	max_integrity = 50
	max_blade_int = 100
	wdefense = 1
	resistance_flags = FLAMMABLE

/obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	name = "elvish dagger"
	desc = "This beautiful dagger is of intricate, elvish design. Sharper, too."
	force = 22
	icon_state = "elfdagger"
	item_state = "elfdag"
	last_used = 0
	is_silver = FALSE

/obj/item/rogueweapon/huntingknife/idagger/silver/elvish/drow
	name = "dark elvish dagger"
	desc = "A vicious wave-bladed dagger from the Underdark."
	force = 18
	last_used = 0
	is_silver = TRUE

/obj/item/rogueweapon/huntingknife/idagger/navaja
	possible_item_intents = list(/datum/intent/dagger/thrust,/datum/intent/dagger/cut,  /datum/intent/dagger/thrust/pick)
	name = "navaja"
	desc = "A folding Etruscan knife valued by merchants, mercenaries and peasants for its convenience. It possesses a long hilt, allowing for a sizeable blade with good reach."
	force = 5
	icon_state = "navaja_c"
	item_state = "elfdag"
	var/extended = FALSE
	wdefense = 2
	sellprice = 30 //shiny :o

/obj/item/rogueweapon/huntingknife/idagger/navaja/attack_self(mob/user)
	extended = !extended
	playsound(src.loc, 'sound/blank.ogg', 50, TRUE)
	if(extended)
		force = 20
		force_dynamic = 20
		wdefense = 6
		wdefense_dynamic = 6
		w_class = WEIGHT_CLASS_NORMAL
		throwforce = 23
		icon_state = "navaja_o"
		attack_verb = list("slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		sharpness = IS_SHARP
		playsound(user, 'sound/items/knife_open.ogg', 100, TRUE)
		equip_delay_self = initial(equip_delay_self)
		unequip_delay_self = initial(unequip_delay_self)
		inv_storage_delay = initial(inv_storage_delay)
	else
		force = 5
		force_dynamic = 5
		w_class = WEIGHT_CLASS_SMALL
		throwforce = 5
		icon_state = "navaja_c"
		attack_verb = list("stubbed", "poked")
		sharpness = IS_BLUNT
		wdefense = 2
		wdefense_dynamic = 2
		equip_delay_self = 0 SECONDS
		unequip_delay_self = 0 SECONDS
		inv_storage_delay = 0 SECONDS

/obj/item/rogueweapon/huntingknife/throwingknife
	name = "iron tossblade"
	desc = "Paradoxical; why is it called a blade when it is meant for tossing? Or is it the act of cutting post-toss that makes it a blade? ...Are arrows tossblades, too? </br>This dagger can be stowed away inside a pair of boots, permitting it to be quickly drawn when needed."
	item_state = "bone_dagger"
	force = 10
	throwforce = 22
	throw_speed = 4
	max_integrity = 50
	armor_penetration = 30
	wdefense = 1
	icon_state = "throw_knifei"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 25, "embedded_fall_chance" = 10)
	possible_item_intents = list(/datum/intent/dagger/thrust, /datum/intent/dagger/chop)
	smeltresult = null
	sellprice = 1
	thrown_damage_flag = "piercing"		//Checks piercing type like an arrow.

/obj/item/rogueweapon/huntingknife/throwingknife/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.5,"sx" = -10,"sy" = -3,"nx" = 11,"ny" = -3,"wx" = -4,"wy" = -3,"ex" = 5,"ey" = -3,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogueweapon/huntingknife/throwingknife/kazengun
	name = "eastern tossblade"
	desc = "A four pointed throwing knife ground and sharpened from a single piece of metal. The design is intended to solve one of weaknesses of basic tossblades; \
	more points means these are more likely to land point-first. </br>This dagger can be stowed away inside a pair of boots, permitting it to be quickly drawn when needed."
	icon_state = "easttossblade"

/obj/item/rogueweapon/huntingknife/throwingknife/aalloy
	name = "decrepit tossblade"
	desc = "Chunks of frayed bronze, crudely sharpened into throwing daggers. You might be better off chucking the silverware at them, at this rate. </br>This dagger can be stowed away inside a pair of boots, permitting it to be quickly drawn when needed."
	icon_state = "throw_knifea"
	color = "#bb9696"
	force = 7
	throwforce = 16
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/huntingknife/throwingknife/steel
	name = "steel tossblade"
	desc = "There are rumors of some sea-marauders loading these into metal tubes with explosive powder to launch then fast and far. Probably won't catch on. </br>This dagger can be stowed away inside a pair of boots, permitting it to be quickly drawn when needed."
	item_state = "bone_dagger"
	throwforce = 28
	max_integrity = 100
	armor_penetration = 40
	icon_state = "throw_knifes"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 30, "embedded_fall_chance" = 5)
	sellprice = 2

/obj/item/rogueweapon/huntingknife/throwingknife/steel/palloy
	name = "ancient alloy tossblade"
	desc = "A sliver of polished gilbranze, delicately carved into a throwing dagger. A favorite amongst Zizo's undying cabal, and especially amongst Her assassins; what better-a-tool to slip through another's neck? </br>This dagger can be stowed away inside a pair of boots, permitting it to be quickly drawn when needed."
	icon_state = "throw_knifea"

/obj/item/rogueweapon/huntingknife/throwingknife/silver
	name = "silver tossblade"
	desc = "A relative to the silver dagger; thinner, flimsier, but capable of being thrown with exceptional accuracy. Seasoned pursuers of unholy creechers oft-keep one hidden on themselves, just in case. </br>This dagger can be stowed away inside a pair of boots, permitting it to be quickly drawn when needed."
	item_state = "bone_dagger"
	force = 10
	throwforce = 20
	armor_penetration = 50
	max_integrity = 150
	wdefense = 3
	icon_state = "throw_knifesil"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 50, "embedded_fall_chance" = 0)
	is_silver = TRUE
	sellprice = 6

/obj/item/rogueweapon/huntingknife/throwingknife/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 3,\
	)

/obj/item/rogueweapon/huntingknife/throwingknife/psydon
	name = "psydonic tossblade"
	desc = "An unconventional method of delivering silver to a heretic; but one PSYDON smiles at, all the same. Doubles as an actual knife in a pinch, though obviously not as well. </br>This dagger can be stowed away inside a pair of boots, permitting it to be quickly drawn when needed."
	item_state = "bone_dagger"
	force = 10
	throwforce = 20
	armor_penetration = 50
	max_integrity = 150
	wdefense = 3
	icon_state = "throw_knifep"
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 50, "embedded_fall_chance" = 0)
	is_silver = TRUE
	sellprice = 6

/obj/item/rogueweapon/huntingknife/throwingknife/psydon/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 100,\
		added_def = 3,\
	)

/obj/item/rogueweapon/huntingknife/throwingknife/bauernwehr
	name = "bauernwehr"
	desc = "The pilgrim's fondest friend — a short but sharp blade fitted to a wooden handle. Known to Grenzelhoft as the 'bauernwehr', these knives ensure that no labors are without an answer. This knife can be stowed in a boot."
	icon_state = "throw_knifei"
	wdefense = 1
	max_blade_int = 250
	max_integrity = 250
	force = 10
	throwforce = 10
	throw_speed = 2
	armor_penetration = 20
	embedding = list("embedded_pain_multiplier" = 5, "embed_chance" = 75, "embedded_fall_chance" = 10)
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver, /datum/intent/snip, /datum/intent/dagger/sucker_punch)

/obj/item/rogueweapon/huntingknife/scissors
	possible_item_intents = list(/datum/intent/snip, /datum/intent/dagger/thrust, /datum/intent/dagger/cut)
	max_integrity = 100
	name = "iron scissors"
	desc = "Scissors made of iron that may be used to salvage usable materials from clothing."
	icon = 'icons/roguetown/weapons/misc32.dmi'
	icon_state = "iscissors"
	inv_storage_delay = null

/obj/item/rogueweapon/huntingknife/scissors/steel
	force = 14
	max_integrity = 150
	name = "steel scissors"
	desc = "Scissors made of solid steel that may be used to salvage usable materials from clothing, more durable and a tad more deadly than their iron conterpart."
	icon_state = "sscissors"
	smeltresult = /obj/item/ingot/steel

/datum/intent/snip // The salvaging intent!
	name = "snip"
	icon_state = "insnip"
	chargetime = 0
	noaa = TRUE
	candodge = FALSE
	canparry = FALSE
	misscost = 0
	no_attack = TRUE
	releasedrain = 0
	blade_class = BCLASS_PUNCH

/obj/item/rogueweapon/huntingknife/scissors/attack(mob/living/M, mob/living/user)
	// Check if using snip intent and targeting a human's head or skull
	if(user.used_intent.type == /datum/intent/snip && ishuman(M))
		var/mob/living/carbon/human/H = M
		// Check if targeting the head or skull zone
		if(user.zone_selected == BODY_ZONE_HEAD || user.zone_selected == BODY_ZONE_PRECISE_SKULL)
			var/list/options = list("hairstyle", "facial hairstyle")
			var/chosen = input(user, "What would you like to style?", "Hair Styling") as null|anything in options
			if(!chosen)
				return

			switch(chosen)
				if("hairstyle")
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/list/valid_hairstyles = list()
					for(var/hair_type in hair_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/head/hair = new hair_type()
						valid_hairstyles[hair.name] = hair_type

					var/new_style = input(user, "Choose their hairstyle", "Hair Styling") as null|anything in valid_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] hair..."))
						if(!do_after(user, 30 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/head/current_hair = null
							for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
								current_hair = hair_feature
								break

							if(current_hair)
								var/datum/customizer_entry/hair/hair_entry = new()
								hair_entry.hair_color = current_hair.hair_color

								// Preserve gradients and their colors
								if(istype(current_hair, /datum/bodypart_feature/hair/head))
									hair_entry.natural_gradient = current_hair.natural_gradient
									hair_entry.natural_color = current_hair.natural_color
									if(hasvar(current_hair, "hair_dye_gradient"))
										hair_entry.dye_gradient = current_hair.hair_dye_gradient
									if(hasvar(current_hair, "hair_dye_color"))
										hair_entry.dye_color = current_hair.hair_dye_color

								var/datum/bodypart_feature/hair/head/new_hair = new()
								new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)
								hair_choice.customize_feature(new_hair, H, null, hair_entry)

								head.remove_bodypart_feature(current_hair)
								head.add_bodypart_feature(new_hair)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] hair."))

				if("facial hairstyle")
					if(H.gender != MALE)
						to_chat(user, span_warning("They don't have facial hair to style!"))
						return
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/list/valid_facial_hairstyles = list()
					for(var/facial_type in facial_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/facial/facial = new facial_type()
						valid_facial_hairstyles[facial.name] = facial_type

					var/new_style = input(user, "Choose their facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s facial hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] facial hair..."))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/facial/current_facial = null
							for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
								current_facial = facial_feature
								break

							if(current_facial)
								var/datum/customizer_entry/hair/facial/facial_entry = new()
								facial_entry.hair_color = current_facial.hair_color
								facial_entry.accessory_type = current_facial.accessory_type

								var/datum/bodypart_feature/hair/facial/new_facial = new()
								new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
								facial_choice.customize_feature(new_facial, H, null, facial_entry)

								head.remove_bodypart_feature(current_facial)
								head.add_bodypart_feature(new_facial)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s facial hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] facial hair."))
			return TRUE
	// If not using snip intent on head/skull or not a human, proceed with normal attack
	if(user.used_intent.type == /datum/intent/snip)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			var/list/options = list("hairstyle", "facial hairstyle")
			var/chosen = input(user, "What would you like to style?", "Hair Styling") as null|anything in options
			if(!chosen)
				return

			switch(chosen)
				if("hairstyle")
					var/datum/customizer_choice/bodypart_feature/hair/head/humanoid/hair_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/head/humanoid)
					var/list/valid_hairstyles = list()
					for(var/hair_type in hair_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/head/hair = new hair_type()
						valid_hairstyles[hair.name] = hair_type

					var/new_style = input(user, "Choose their hairstyle", "Hair Styling") as null|anything in valid_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] hair..."))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/head/current_hair = null
							for(var/datum/bodypart_feature/hair/head/hair_feature in head.bodypart_features)
								current_hair = hair_feature
								break

							if(current_hair)
								var/datum/customizer_entry/hair/hair_entry = new()
								hair_entry.hair_color = current_hair.hair_color

								// Preserve gradients and their colors
								if(istype(current_hair, /datum/bodypart_feature/hair/head))
									hair_entry.natural_gradient = current_hair.natural_gradient
									hair_entry.natural_color = current_hair.natural_color
									if(hasvar(current_hair, "hair_dye_gradient"))
										hair_entry.dye_gradient = current_hair.hair_dye_gradient
									if(hasvar(current_hair, "hair_dye_color"))
										hair_entry.dye_color = current_hair.hair_dye_color

								var/datum/bodypart_feature/hair/head/new_hair = new()
								new_hair.set_accessory_type(valid_hairstyles[new_style], hair_entry.hair_color, H)
								hair_choice.customize_feature(new_hair, H, null, hair_entry)

								head.remove_bodypart_feature(current_hair)
								head.add_bodypart_feature(new_hair)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] hair."))

				if("facial hairstyle")
					if(H.gender != MALE)
						to_chat(user, span_warning("They don't have facial hair to style!"))
						return
					var/datum/customizer_choice/bodypart_feature/hair/facial/humanoid/facial_choice = CUSTOMIZER_CHOICE(/datum/customizer_choice/bodypart_feature/hair/facial/humanoid)
					var/list/valid_facial_hairstyles = list()
					for(var/facial_type in facial_choice.sprite_accessories)
						var/datum/sprite_accessory/hair/facial/facial = new facial_type()
						valid_facial_hairstyles[facial.name] = facial_type

					var/new_style = input(user, "Choose their facial hairstyle", "Hair Styling") as null|anything in valid_facial_hairstyles
					if(new_style)
						user.visible_message(span_notice("[user] begins styling [H]'s facial hair..."), span_notice("You begin styling [H == user ? "your" : "[H]'s"] facial hair..."))
						if(!do_after(user, 60 SECONDS, target = H))
							to_chat(user, span_warning("The styling was interrupted!"))
							return

						var/obj/item/bodypart/head/head = H.get_bodypart(BODY_ZONE_HEAD)
						if(head && head.bodypart_features)
							var/datum/bodypart_feature/hair/facial/current_facial = null
							for(var/datum/bodypart_feature/hair/facial/facial_feature in head.bodypart_features)
								current_facial = facial_feature
								break

							if(current_facial)
								var/datum/customizer_entry/hair/facial/facial_entry = new()
								facial_entry.hair_color = current_facial.hair_color
								facial_entry.accessory_type = current_facial.accessory_type

								var/datum/bodypart_feature/hair/facial/new_facial = new()
								new_facial.set_accessory_type(valid_facial_hairstyles[new_style], facial_entry.hair_color, H)
								facial_choice.customize_feature(new_facial, H, null, facial_entry)

								head.remove_bodypart_feature(current_facial)
								head.add_bodypart_feature(new_facial)
								H.update_hair()
								playsound(src, 'sound/items/flint.ogg', 50, TRUE)
								user.visible_message(span_notice("[user] finishes styling [H]'s facial hair."), span_notice("You finish styling [H == user ? "your" : "[H]'s"] facial hair."))
			return
	return ..()

/obj/item/rogueweapon/huntingknife/attack_obj(obj/O, mob/living/user)
	if(user.used_intent.type == /datum/intent/snip && istype(O, /obj/item))
		var/obj/item/item = O
		if(item.sewrepair && item.salvage_result) // We can only salvage objects which can be sewn!
			var/salvage_time = 70
			salvage_time = (70 - ((user.get_skill_level(/datum/skill/craft/sewing)) * 10))
			if(!do_after(user, salvage_time, target = user))
				return

			if(item.fiber_salvage) //We're getting fiber as base if fiber is present on the item
				new /obj/item/natural/fibers(get_turf(item))
			if(istype(item, /obj/item/storage))
				var/obj/item/storage/bag = item
				bag.emptyStorage()
			var/skill_level = user.get_skill_level(/datum/skill/craft/sewing)
			if(prob(50 - (skill_level * 10))) // We are dumb and we failed!
				to_chat(user, span_info("I ruined some of the materials due to my lack of skill..."))
				playsound(item, 'sound/foley/cloth_rip.ogg', 50, TRUE)
				qdel(item)
				user.mind.add_sleep_experience(/datum/skill/craft/sewing, (user.STAINT)) //Getting exp for failing
				return //We are returning early if the skill check fails!
			item.salvage_amount -= item.torn_sleeve_number
			for(var/i = 1; i <= item.salvage_amount; i++) // We are spawning salvage result for the salvage amount minus the torn sleves!
				var/obj/item/Sr = new item.salvage_result(get_turf(item))
				Sr.color = item.color
			user.visible_message(span_notice("[user] salvages [item] into usable materials."))
			playsound(item, 'sound/items/flint.ogg', 100, TRUE)
			qdel(item)
			user.mind.add_sleep_experience(/datum/skill/craft/sewing, (user.STAINT))
	return ..()
