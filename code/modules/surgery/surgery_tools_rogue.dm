/obj/item/rogueweapon/surgery
	name = "surgical tool"
	desc = "Something that will tear your guts apart."
	icon = 'icons/roguetown/items/surgery.dmi'
	item_state = "bone_dagger"
	lefthand_file = 'icons/mob/inhands/weapons/swords_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/swords_righthand.dmi'
	gripsprite = FALSE
	wlength = WLENGTH_SHORT
	w_class = WEIGHT_CLASS_SMALL
	force = 12
	throwforce = 12
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	max_blade_int = 200
	max_integrity = 175
	thrown_bclass = BCLASS_CUT
	associated_skill = /datum/skill/combat/knives
	anvilrepair = /datum/skill/craft/blacksmithing
	smeltresult = null

	grid_width = 32
	grid_height = 64

/obj/item/rogueweapon/surgery/Initialize()
	. = ..()
	item_flags |= SURGICAL_TOOL //let's not stab patients for fun

/obj/item/rogueweapon/surgery/scalpel
	name = "scalpel"
	desc = "A tool used to carve precisely into the flesh of the sickly."
	icon_state = "scalpel"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/thrust)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	tool_behaviour = TOOL_SCALPEL
	smeltresult = null

/obj/item/rogueweapon/surgery/saw
	name = "saw"
	desc = "A tool used to carve through bone."
	icon_state = "bonesaw"
	possible_item_intents = list(/datum/intent/dagger/cut, /datum/intent/dagger/chop/cleaver)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedmedium (1).ogg','sound/combat/parry/bladed/bladedmedium (2).ogg','sound/combat/parry/bladed/bladedmedium (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshmed (1).ogg','sound/combat/wooshes/bladed/wooshmed (2).ogg','sound/combat/wooshes/bladed/wooshmed (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	force = 16
	throwforce = 16
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_CHOP
	tool_behaviour = TOOL_SAW
	smeltresult = null

/obj/item/rogueweapon/surgery/hemostat
	name = "forceps"
	desc = "A tool used to clamp down on soft tissue."
	icon_state = "forceps"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	sharpness = IS_BLUNT
	tool_behaviour = TOOL_HEMOSTAT
	smeltresult = null

/obj/item/rogueweapon/surgery/hemostat/first //Three different types now to allow multiple surgical sites at once.
	name = "\improper Tarsis forceps"

/obj/item/rogueweapon/surgery/hemostat/second
	name = "\improper Sisrat forceps"

/obj/item/rogueweapon/surgery/hemostat/third
	name = "\improper Medella forceps"

/obj/item/rogueweapon/surgery/retractor
	name = "speculum"
	desc = "A tool used to spread tissue open for surgical access."
	icon_state = "speculum"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	wdefense = 3
	wbalance = WBALANCE_SWIFT
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	tool_behaviour = TOOL_RETRACTOR
	smeltresult = null

/obj/item/rogueweapon/surgery/bonesetter
	name = "bone forceps"
	desc = "A tool used to clamp down on hard tissue."
	icon_state = "bonesetter"
	possible_item_intents = list(/datum/intent/use)
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	parrysound = list('sound/combat/parry/bladed/bladedsmall (1).ogg','sound/combat/parry/bladed/bladedsmall (2).ogg','sound/combat/parry/bladed/bladedsmall (3).ogg')
	swingsound = list('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
	pickup_sound = 'sound/foley/equip/swordsmall2.ogg'
	sharpness = IS_BLUNT
	tool_behaviour = TOOL_BONESETTER
	smeltresult = null

/obj/item/rogueweapon/surgery/cautery
	name = "cautery iron"
	desc = "A tool used to cauterize wounds. Heat it up before use."
	icon_state = "cauteryiron"
	possible_item_intents = list(/datum/intent/mace/strike, /datum/intent/mace/smash, /datum/intent/use)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	force = 18
	throwforce = 18
	wdefense = 3
	wbalance = WBALANCE_HEAVY	//huh?
	associated_skill = /datum/skill/combat/maces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT
	/// Timer to cool down
	var/cool_timer
	/// Whether or not we are heated up
	var/heated = FALSE
	smeltresult = null

/obj/item/rogueweapon/surgery/cautery/examine(mob/user)
	. = ..()
	if(heated)
		. += span_warning("The tip is hot to the touch.")

/obj/item/rogueweapon/surgery/cautery/update_icon_state()
	. = ..()
	icon_state = initial(icon_state)
	if(heated)
		icon_state = "[initial(icon_state)]_hot"

/obj/item/rogueweapon/surgery/cautery/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	var/heating = 0
	if(istype(A, /obj/machinery/light/rogue))
		var/obj/machinery/light/rogue/forge = A
		if(forge.on)
			heating = 20
	if(heating)
		user.visible_message(span_info("[user] heats [src]."))
		fire_act(heating)
		return TRUE
	return ..()

/obj/item/rogueweapon/surgery/cautery/fire_act(added, maxstacks)
	. = ..()
	if(!heated)
		playsound(src, 'sound/items/firelight.ogg', 100, vary = TRUE)
	update_heated(TRUE)
	if(cool_timer)
		deltimer(cool_timer)
	cool_timer = addtimer(CALLBACK(src, PROC_REF(update_heated), FALSE), added SECONDS, TIMER_STOPPABLE)

/obj/item/rogueweapon/surgery/cautery/get_temperature()
	if(heated)
		return FIRE_MINIMUM_TEMPERATURE_TO_SPREAD
	return ..()

/obj/item/rogueweapon/surgery/cautery/proc/update_heated(new_heated)
	heated = new_heated
	if(heated)
		damtype = BURN
		tool_behaviour = TOOL_CAUTERY
	else
		damtype = BRUTE
		tool_behaviour = null
	update_icon()

/obj/item/rogueweapon/surgery/hammer
	name = "examination hammer"
	desc = "A small hammer used to check a patient's reactions and diagnose their condition."
	icon_state = "kneehammer"
	possible_item_intents = list(/datum/intent/use, /datum/intent/mace/strike, /datum/intent/mace/smash)
	slot_flags = ITEM_SLOT_HIP
	parrysound = list('sound/combat/parry/parrygen.ogg')
	swingsound = BLUNTWOOSH_MED
	force = 10
	throwforce = 8
	wdefense = 3
	wbalance = -1
	associated_skill = /datum/skill/combat/maces
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_NORMAL
	thrown_bclass = BCLASS_BLUNT

/obj/item/rogueweapon/surgery/hammer/pre_attack(atom/A, mob/living/user, params)
	if(!istype(user.a_intent, /datum/intent/use))
		return ..()
	var/medskill = user.get_skill_level(/datum/skill/misc/medicine)
	if(medskill < SKILL_LEVEL_NOVICE)
		return ..()
	if(ishuman(A))
		if(A == user)
			user.visible_message("<span class='info'>[user] begins smacking themself with a small hammer.</span>")
		else
			user.visible_message("<span class='info'>[user] begins to smack [A] with a small hammer.</span>")
		if(do_after(user, ((medskill > SKILL_LEVEL_EXPERT) ? 1 SECONDS : 2.5 SECONDS), target = A))
			A.visible_message("<span class='info'>[A] jerks their knee after the hammer strikes!</span>")
			if(prob(10))
				playsound(user, 'sound/misc/bonk.ogg', 100, FALSE, -1)
			var/mob/living/carbon/human/human_target = A
			human_target.check_for_injuries(user)
	return ..()

////////////////////
//Improvised Tools//
////////////////////

//All are subtypes of the regular tools with worse behavior success chances.
/obj/item/rogueweapon/surgery/saw/improv
	name = "improvised saw"
	desc = "A tool used to carve through bone crudely, but better than nothing."
	icon_state = "bonesaw_wood"
	force = 12
	throwforce = 12
	wdefense = 3
	wbalance = 1
	tool_behaviour = TOOL_IMPROVISED_SAW
	sharpness = IS_BLUNT

/obj/item/rogueweapon/surgery/hemostat/improv
	name = "improvised clamp"
	desc = "A tool used to clamp down on soft tissue. A poor alternative to metal but better than nothing."
	icon_state = "forceps_wood"
	tool_behaviour = TOOL_IMPROVISED_HEMOSTAT

/obj/item/rogueweapon/surgery/retractor/improv
	name = "improvised retractor"
	desc = "A tool used to spread tissue open for surgical access in a tentative manner."
	icon_state = "speculum_wood"
	wdefense = 3
	wbalance = 1
	tool_behaviour = TOOL_IMPROVISED_RETRACTOR
