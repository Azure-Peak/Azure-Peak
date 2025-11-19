/obj/item/bodypart/proc/prosthetic_attachment(var/mob/living/carbon/human/H, var/mob/user)
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

/obj/item/contraption/bronzeprosthetic
	name = "bronze prosthetic"
	desc = "A prosthetic made of bronze. Use it in your hand to determine what limb it will function as."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prb_blank"

/obj/item/contraption/ironprosthetic
	name = "iron prosthetic"
	desc = "A prosthetic made of iron. Use it in your hand to determine what limb it will function as."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "pri_blank"
	smeltresult = /obj/item/ingot/iron

/obj/item/contraption/steelprosthetic
	name = "steel prosthetic"
	desc = "A prosthetic made of steel. Use it in your hand to determine what limb it will function as."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prs_blank"
	smeltresult = /obj/item/ingot/steel

/obj/item/contraption/goldprosthetic
	name = "golden prosthetic"
	desc = "A prosthetic made of gold. Use it in your hand to determine what limb it will function as."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "prc_blank"
	smeltresult = /obj/item/ingot/gold

/obj/item/contraption/bronzeprosthetic/attack_self(mob/user)
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

/obj/item/contraption/ironprosthetic/attack_self(mob/user)
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

/obj/item/contraption/steelprosthetic/attack_self(mob/user)
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

/obj/item/contraption/goldprosthetic/attack_self(mob/user)
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

/////     ARMS     /////

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
	sellprice = 30
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
	sellprice = 30
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
	sellprice = 40
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
	sellprice = 30
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
	sellprice = 70
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

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
	sellprice = 30
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
	sellprice = 30
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
	sellprice = 40
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
	max_damage = 220
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 350
	sellprice = 30
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
	sellprice = 70
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

/obj/item/bodypart/r_arm/prosthetic/attack(mob/living/M, mob/user)
	prosthetic_attachment(M, user)

/////     LEGS     /////

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
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	sellprice = 30
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
	organ_slowdown = 1.2
	brute_reduction = 5
	burn_reduction = 5
	sellprice = 30
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
	organ_slowdown = 1.1
	brute_reduction = 10
	burn_reduction = 10
	sellprice = 40
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
	sellprice = 30
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
	sellprice = 70
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

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
	w_class = WEIGHT_CLASS_NORMAL
	max_integrity = 300
	sellprice = 30
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
	organ_slowdown = 1.2
	brute_reduction = 5
	burn_reduction = 5
	sellprice = 30
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
	organ_slowdown = 1.1
	brute_reduction = 10
	burn_reduction = 10
	sellprice = 40
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
	sellprice = 30
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
	sellprice = 70
	anvilrepair = /datum/skill/craft/engineering
	smeltresult = /obj/item/ingot/gold

/obj/item/bodypart/r_leg/prosthetic/attack(mob/living/M, mob/user)
	prosthetic_attachment(M, user)
