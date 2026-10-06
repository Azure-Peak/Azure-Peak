/obj/item/bodypart/proc/prosthetic_attachment(mob/living/carbon/human/H, mob/user)
	if(!ishuman(H))
		return

	if(user.zone_selected != body_zone)
		to_chat(user, span_warning("[src] isn't the right type for [parse_zone(user.zone_selected)]."))
		return -1

	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
	if(affecting)
		return

	if(user.temporarilyRemoveItemFromInventory(src))
		attach_limb(H)
		user.visible_message(span_notice("[user] attaches [src] to [H]."))
		return 1

/obj/item/rogueweapon/contraption/bronzeprosthetic
	name = "bronze prosthetic"
	desc = "A prosthetic made of bronze. Use it in your hand to determine what limb it will function as."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prb_blank"

/obj/item/rogueweapon/contraption/ironprosthetic
	name = "iron prosthetic"
	desc = "A prosthetic made of iron. Use it in your hand to determine what limb it will function as."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_blank"
	smeltresult = /obj/item/ingot/iron

/obj/item/rogueweapon/contraption/steelprosthetic
	name = "steel prosthetic"
	desc = "A prosthetic made of steel. Use it in your hand to determine what limb it will function as."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_blank"
	smeltresult = /obj/item/ingot/steel

/obj/item/rogueweapon/contraption/goldprosthetic
	name = "golden prosthetic"
	desc = "A prosthetic made of gold. Use it in your hand to determine what limb it will function as."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_blank"
	smeltresult = /obj/item/ingot/gold

/obj/item/rogueweapon/contraption/aalloyprosthetic
	name = "gilbranze prosthetic"
	desc = "A prosthetic made of wrought of Gilbranze and Bone, which harnesses its wearer's very lux. Use it in your hand to determine what limb it will function as."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_blank"
	smeltresult = /obj/item/ingot/gold

/obj/item/rogueweapon/contraption/aalloyprosthetic/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Gilbranze limbs are of the highest grade. When worn in pairs, they add extra powers to the Overclock ability")
	. += span_info("A pair of Gilbranze Legs allows the user to leap and fall great distances")
	. += span_info("A pair of Gilbranze Arms affords the user greater strength, prowess with one's fists, and the ability to withdraw from grabs and smash through doors")
	. += span_info("However, these abilities come at the cost of the user's Lux. If the user has no lux to spare, they can only support one pair of Gilbranze Limbs, or one Artificed Organ")
	. += span_info("Whilst the wearer has Lux, they can support up to two Artificed Organs, or pairs of Gilbranze Limbs, without failure. An Artificed Heart increases this capacity by one")

/obj/item/rogueweapon/contraption/aalloyprosthetic/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_LUX_LIMB)

/obj/item/rogueweapon/contraption/bronzeprosthetic/attack_self(mob/user)
	. = ..()
	var/choice = input(user, "Choose the side and the limb") as null|anything in list("Left Arm", "Right Arm", "Left Leg", "Right Leg", "Cancel")
	switch(choice)
		if("Cancel")
			return
		if(null)
			return
		if("Left Arm")
			new /obj/item/bodypart/l_arm/prosthetic/bronzeleft(get_turf(src.loc))
			qdel(src)
			return
		if("Right Arm")
			new /obj/item/bodypart/r_arm/prosthetic/bronzeright(get_turf(src.loc))
			qdel(src)
			return
		if("Left Leg")
			new /obj/item/bodypart/l_leg/prosthetic/bronzeleft(get_turf(src.loc))
			qdel(src)
			return
		if("Right Leg")
			new /obj/item/bodypart/r_leg/prosthetic/bronzeright(get_turf(src.loc))
			qdel(src)
			return

/obj/item/rogueweapon/contraption/ironprosthetic/attack_self(mob/user)
	. = ..()
	var/choice = input(user, "Choose the side and the limb") as null|anything in list("Left Arm", "Right Arm", "Left Leg", "Right Leg", "Cancel")
	switch(choice)
		if("Cancel")
			return
		if(null)
			return
		if("Left Arm")
			new /obj/item/bodypart/l_arm/prosthetic/iron(get_turf(src.loc))
			qdel(src)
			return
		if("Right Arm")
			new /obj/item/bodypart/r_arm/prosthetic/iron(get_turf(src.loc))
			qdel(src)
			return
		if("Left Leg")
			new /obj/item/bodypart/l_leg/prosthetic/iron(get_turf(src.loc))
			qdel(src)
			return
		if("Right Leg")
			new /obj/item/bodypart/r_leg/prosthetic/iron(get_turf(src.loc))
			qdel(src)
			return

/obj/item/rogueweapon/contraption/steelprosthetic/attack_self(mob/user)
	. = ..()
	var/choice = input(user, "Choose the side and the limb") as null|anything in list("Left Arm", "Right Arm", "Left Leg", "Right Leg", "Cancel")
	switch(choice)
		if("Cancel")
			return
		if(null)
			return
		if("Left Arm")
			new /obj/item/bodypart/l_arm/prosthetic/steel(get_turf(src.loc))
			qdel(src)
			return
		if("Right Arm")
			new /obj/item/bodypart/r_arm/prosthetic/steel(get_turf(src.loc))
			qdel(src)
			return
		if("Left Leg")
			new /obj/item/bodypart/l_leg/prosthetic/steel(get_turf(src.loc))
			qdel(src)
			return
		if("Right Leg")
			new /obj/item/bodypart/r_leg/prosthetic/steel(get_turf(src.loc))
			qdel(src)
			return

/obj/item/rogueweapon/contraption/goldprosthetic/attack_self(mob/user)
	. = ..()
	var/choice = input(user, "Choose the side and the limb") as null|anything in list("Left Arm", "Right Arm", "Left Leg", "Right Leg", "Cancel")
	switch(choice)
		if("Cancel")
			return
		if(null)
			return
		if("Left Arm")
			new /obj/item/bodypart/l_arm/prosthetic/gold(get_turf(src.loc))
			qdel(src)
			return
		if("Right Arm")
			new /obj/item/bodypart/r_arm/prosthetic/gold(get_turf(src.loc))
			qdel(src)
			return
		if("Left Leg")
			new /obj/item/bodypart/l_leg/prosthetic/gold(get_turf(src.loc))
			qdel(src)
			return
		if("Right Leg")
			new /obj/item/bodypart/r_leg/prosthetic/gold(get_turf(src.loc))
			qdel(src)
			return

/obj/item/rogueweapon/contraption/aalloyprosthetic/attack_self(mob/user)
	. = ..()
	var/choice = input(user, "Choose the side and the limb") as null|anything in list("Left Arm", "Right Arm", "Left Leg", "Right Leg", "Cancel")
	switch(choice)
		if("Cancel")
			return
		if(null)
			return
		if("Left Arm")
			new /obj/item/bodypart/l_arm/prosthetic/aalloy(get_turf(src.loc))
			qdel(src)
			return
		if("Right Arm")
			new /obj/item/bodypart/r_arm/prosthetic/aalloy(get_turf(src.loc))
			qdel(src)
			return
		if("Left Leg")
			new /obj/item/bodypart/l_leg/prosthetic/aalloyleft(get_turf(src.loc))
			qdel(src)
			return
		if("Right Leg")
			new /obj/item/bodypart/r_leg/prosthetic/aalloyright(get_turf(src.loc))
			qdel(src)
			return

/////		ARMS		/////

/obj/item/bodypart/l_arm/prosthetic/woodleft
	name = "wooden left arm"
	desc = "A left arm of wood."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pr_arm"
	item_state = "pr_arm"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC	//allows removals
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 20
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	fingers = FALSE //can't swing weapons but can pick stuff up and punch
	anvilrepair = /datum/skill/craft/carpentry
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/l_arm/prosthetic/iron
	name = "iron left arm"
	desc = "A left arm of iron."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_arm"
	prosthetic_prefix = "pri"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	brute_reduction = 5
	burn_reduction = 5
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/iron

/obj/item/bodypart/l_arm/prosthetic/steel
	name = "steel left arm"
	desc = "A left arm of steel."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_arm"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 200
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	brute_reduction = 10
	burn_reduction = 10
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel

/obj/item/bodypart/l_arm/prosthetic/bronzeleft
	name = "bronze left arm"
	desc = "A replacement left arm, engineered out of bronze."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bp_arm"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 110
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	fingers = TRUE // it acts like a normal arm
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/l_arm/prosthetic/gold
	name = "golden left arm"
	desc = "A left arm of cogs and gold."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_arm"
	prosthetic_prefix = "prc"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_BULKY
	max_integrity = 300
	fingers = TRUE
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

/obj/item/bodypart/l_arm/prosthetic/aalloy
	name = "gilbranze left arm"
	desc = "A left arm wrought of gilbranze and bone. It moves with startling dexterity, betraying its lux-fueled nature. A normal human form could sustain no more than two at once."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pra_arm"
	prosthetic_prefix = "prc"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE
	max_damage = 200
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	brute_reduction = 10
	burn_reduction = 10
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/aalloy

/obj/item/bodypart/l_arm/prosthetic/aalloy/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_LUX_LIMB)

/obj/item/bodypart/l_arm/prosthetic/aalloy/is_disabled()
	if(owner.check_lux_organ_cap())
		return BODYPART_DISABLED_PARALYSIS
	return ..()

/obj/item/bodypart/l_arm/prosthetic/aalloy/on_life()
	update_disabled()
	return ..()

/obj/item/bodypart/l_arm/prosthetic/attack(mob/living/M, mob/user)
	prosthetic_attachment(M, user)

/obj/item/bodypart/r_arm/prosthetic/woodright
	name = "wooden right arm"
	desc = "A right arm of wood."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pr_arm"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 40
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	fingers = FALSE //can't swing weapons but can pick stuff up and punch
	anvilrepair = /datum/skill/craft/carpentry
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/r_arm/prosthetic/iron
	name = "iron right arm"
	desc = "A right arm of iron."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_arm"
	prosthetic_prefix = "pri"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	brute_reduction = 5
	burn_reduction = 5
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/iron

/obj/item/bodypart/r_arm/prosthetic/steel
	name = "steel right arm"
	desc = "A right arm of steel."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_arm"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 200
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	brute_reduction = 10
	burn_reduction = 10
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel

/obj/item/bodypart/r_arm/prosthetic/bronzeright
	name = "bronze right arm"
	desc = "A replacement right arm, engineered out of bronze."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bp_arm"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 110
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	fingers = TRUE // it acts like a normal arm
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/r_arm/prosthetic/gold
	name = "golden right arm"
	desc = "A right arm of cogs and gold."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_arm"
	prosthetic_prefix = "prc"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_BULKY
	max_integrity = 300
	fingers = TRUE
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

/obj/item/bodypart/r_arm/prosthetic/aalloy
	name = "gilbranze right arm"
	desc = "A right arm wrought of gilbranze and bone. It moves with startling dexterity, betraying its lux-fueled nature. A normal human form could sustain no more than two at once."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pra_arm"
	prosthetic_prefix = "prc"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE
	max_damage = 200
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	brute_reduction = 10
	burn_reduction = 10
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/aalloy

/obj/item/bodypart/r_arm/prosthetic/aalloy/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_LUX_LIMB)

/obj/item/bodypart/r_arm/prosthetic/aalloy/is_disabled()
	if(owner.check_lux_organ_cap())
		return BODYPART_DISABLED_PARALYSIS
	return ..()

/obj/item/bodypart/r_arm/prosthetic/aalloy/on_life()
	update_disabled()
	return ..()

/obj/item/bodypart/r_arm/prosthetic/attack(mob/living/M, mob/user)
	prosthetic_attachment(M, user)

/////		LEGS		/////

/obj/item/bodypart/l_leg/prosthetic
	name = "wooden left leg"
	desc = "A left leg made of wood."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pr_leg"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 40
	organ_slowdown = 0.75 // -75%
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	anvilrepair = /datum/skill/craft/carpentry
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/l_leg/prosthetic/iron
	name = "iron left leg"
	desc = "A left leg of iron."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_leg"
	prosthetic_prefix = "pri"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	max_damage = 150
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	organ_slowdown = 0.2 // -20%
	brute_reduction = 5
	burn_reduction = 5
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/iron

/obj/item/bodypart/l_leg/prosthetic/steel
	name = "steel left leg"
	desc = "A left leg of steel."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_leg"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	max_damage = 200
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	organ_slowdown = 0.1 // -10%
	brute_reduction = 10
	burn_reduction = 10
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel

/obj/item/bodypart/l_leg/prosthetic/bronzeleft
	name = "bronze left leg"
	desc = "A replacement left leg, engineered out of bronze."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bp_leg"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 220
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	organ_slowdown = 0.15 // -15%
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze

/obj/item/bodypart/l_leg/prosthetic/gold
	name = "golden left leg"
	desc = "A left leg of cogs and gold."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_leg"
	prosthetic_prefix = "prc"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	max_damage = 150
	w_class = WEIGHT_CLASS_BULKY
	max_integrity = 300
	organ_slowdown = 0
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

//evil wretch bad boy heresy prosthetics. Tanky, fast, uses your lux to function
/obj/item/bodypart/l_leg/prosthetic/aalloyleft
	name = "artificed left leg"
	desc = "A left leg, formed from Gilbranze and Bone. It moves with startling dexterity, betraying its lux-fueled nature. A normal human form could sustain no more than two at once."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pra_leg"
	prosthetic_prefix = "prc"// as bronze uses steel, we'll use gold sprites for now. Making sprites for each race sucks
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 10
	burn_reduction = 10
	max_damage = 220
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	organ_slowdown = 0
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/aalloy

/obj/item/bodypart/l_leg/prosthetic/aalloyleft/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_LUX_LIMB)

/obj/item/bodypart/l_leg/prosthetic/aalloyleft/is_disabled()
	if(owner.check_lux_organ_cap())
		return BODYPART_DISABLED_PARALYSIS
	return ..()

/obj/item/bodypart/l_leg/prosthetic/aalloyleft/on_life()
	update_disabled()
	return ..()

/obj/item/bodypart/l_leg/prosthetic/attack(mob/living/M, mob/user)
	prosthetic_attachment(M, user)

/obj/item/bodypart/r_leg/prosthetic
	name = "wooden right leg"
	desc = "A right leg made of wood."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pr_leg"
	resistance_flags = FLAMMABLE
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 40
	organ_slowdown = 0.75 // -75%
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	anvilrepair = /datum/skill/craft/carpentry
	dismember_wound = /datum/wound/bruise/large

/obj/item/bodypart/r_leg/prosthetic/iron
	name = "iron right leg"
	desc = "A right leg of iron."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_leg"
	prosthetic_prefix = "pri"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	organ_slowdown = 0.2 // -20%
	brute_reduction = 5
	burn_reduction = 5
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/iron

/obj/item/bodypart/r_leg/prosthetic/steel
	name = "steel right leg"
	desc = "A right leg of steel."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_leg"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 200
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	organ_slowdown = 0.1 // -10%
	brute_reduction = 10
	burn_reduction = 10
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/steel

/obj/item/bodypart/r_leg/prosthetic/bronzeright
	name = "bronze right leg"
	desc = "A replacement right leg, engineered out of bronze."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bp_leg"
	prosthetic_prefix = "prs"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 0
	burn_reduction = 0
	max_damage = 220
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	organ_slowdown = 0.15 // -15%
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/bronze

/obj/item/bodypart/r_leg/prosthetic/gold
	name = "golden right leg"
	desc = "A right leg of cogs and gold."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_leg"
	prosthetic_prefix = "prc"
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	max_damage = 150
	w_class = WEIGHT_CLASS_BULKY
	max_integrity = 300
	organ_slowdown = 0
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

//evil wretch bad boy heresy prosthetics. Tanky, fast, uses your lux to function
/obj/item/bodypart/r_leg/prosthetic/aalloyright
	name = "artificed right leg"
	desc = "A right leg, formed from Gilbranze and Bone. It moves with startling dexterity, betraying its lux-fueled nature. A normal human form could sustain no more than two at once."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pra_leg"
	prosthetic_prefix = "prc"// as bronze uses steel, we'll use gold sprites for now. Making sprites for each race sucks
	resistance_flags = FIRE_PROOF
	obj_flags = CAN_BE_HIT
	status = BODYPART_ROBOTIC
	static_icon = TRUE			//returns icon to initial icon state after removal under get_limb_icon
	brute_reduction = 10
	burn_reduction = 10
	max_damage = 220
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	organ_slowdown = 0
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/aalloy

/obj/item/bodypart/r_leg/prosthetic/aalloyright/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_LUX_LIMB)

/obj/item/bodypart/r_leg/prosthetic/aalloyright/is_disabled()
	if(owner.check_lux_organ_cap())
		return BODYPART_DISABLED_PARALYSIS
	return ..()

/obj/item/bodypart/r_leg/prosthetic/aalloyright/on_life()
	update_disabled()
	return ..()

/obj/item/bodypart/r_leg/prosthetic/attack(mob/living/M, mob/user)
	prosthetic_attachment(M, user)
