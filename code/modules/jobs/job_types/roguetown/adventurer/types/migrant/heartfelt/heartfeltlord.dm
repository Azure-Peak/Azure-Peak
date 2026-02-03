
/datum/job/roguetown/heartfelt/lord
	title = "Lord of Heartfelt"
	tutorial = "You are the Lord of Heartfelt, ruler of a prosperous borderlands now in Azuria. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = null
	total_positions = 1
	spawn_positions = 0
	job_traits = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_HEARTFELT)
	advclass_cat_rolls = list(CTAG_HFT_LORD)
	job_subclasses = list(
		/datum/advclass/heartfelt/lord/lord,
		/datum/advclass/heartfelt/lord/archmage,
		/datum/advclass/heartfelt/lord/chief,
		)

// DEFAULT - STANDARD OLD CLASS

/datum/advclass/heartfelt/lord/lord
	name = "Lord of Heartfelt"
	tutorial = "You are the Lord of Heartfelt, ruler of a prosperous borderlands now in Azuria. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be."
	category_tags = list(CTAG_HFT_LORD)
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/heartfelt/lord/lord
	pickprob = 100
	class_select_category = CLASS_CAT_HFT_COURT
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_HEARTFELT)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/heartfelt/lord/lord/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	armor = /obj/item/clothing/suit/roguetown/armor/heartfelt
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	r_hand = /obj/item/rogueweapon/sword/long/marlin
	beltr = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel // Paper and Feather
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 2,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		)
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt)
		// H.mind.AddSpell(new/obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget)
		H.verbs |= list(/mob/living/carbon/human/mind/proc/setordersheartfelt)

/datum/advclass/heartfelt/lord/archmage
	name = "Archmagos of Heartfelt"
	tutorial = "You are the Archmagos of Heartfelt, ruler of a acryne-borderlands in Azuria. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be."
	category_tags = list(CTAG_HFT_LORD)
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/heartfelt/lord/archmage
	pickprob = 100
	class_select_category = CLASS_CAT_HFT_COURT
	traits_applied = list(TRAIT_NOBLE, TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_INTELLECTUAL, TRAIT_HEARTFELT, TRAIT_ALCHEMY_EXPERT)

	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/heartfelt/lord/archmage/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/tights/black
	armor = /obj/item/clothing/cloak/poncho/fancycoat
	neck = /obj/item/storage/belt/rogue/pouch/coins/veryrich
	beltl = /obj/item/flashlight/flare/torch/lantern
	r_hand = /obj/item/rogueweapon/woodstaff/diamond
	beltr = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel // Paper and Feather
	backpack_contents = list(
		/obj/item/recipe_book/alchemy,
		/obj/item/roguegem/amethyst,
		/obj/item/spellbook_unfinished/pre_arcyne,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/strongmanapot = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	)
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
	if(H.mind)
		H?.mind.adjust_spellpoints(24)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE)
		H.change_stat("speed", -1)
		H.change_stat("intelligence", 1)
		H.change_stat("perception", 1)
		H?.mind.adjust_spellpoints(6)

// Funny role I thought I'd make. Reminded me of Canute and his Jarldom

/datum/advclass/heartfelt/lord/chief
	name = "Chieftain of Heartfelt"
	tutorial = "You are the Chieftain of Heartfelt, Chieftain of a once tribal lands over Azuria. Now, you rule it under the watchful gaze of the Grand Duchy. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be."
	category_tags = list(CTAG_HFT_LORD)
	maximum_possible_slots = 1
	outfit = /datum/outfit/job/heartfelt/lord/chief
	pickprob = 100
	class_select_category = CLASS_CAT_HFT_COURT
	traits_applied = list(TRAIT_NOBLE, TRAIT_MEDIUMARMOR, TRAIT_CIVILIZEDBARBARIAN, TRAIT_STRONGBITE, TRAIT_HEARTFELT)

	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 3,
		STATKEY_CON = 2,
		STATKEY_SPD = 1,
		STATKEY_PER = -2,
		STATKEY_INT = -1,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/heartfelt/lord/chief/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/beastskull
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/faulds
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	cloak = /obj/item/clothing/cloak/darkcloak/minotaur/red
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine
	neck = /obj/item/clothing/neck/roguetown/leather
	beltr = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel // Paper and Feather
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		)
	id = /obj/item/scomstone
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/heartfelt)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/charge)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt)
		// H.mind.AddSpell(new/obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget)
		H.verbs |= list(/mob/living/carbon/human/mind/proc/setordersheartfelt)
	var/weapons = list("Double-Headed Greataxe", "Great Mace", "Battle Axe + Shield", , "Warhammer + Shield")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Double-Headed Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead
		if("Great Mace")
			r_hand = /obj/item/rogueweapon/mace/goden/steel
		if("Battle Axe + Shield")
			r_hand = /obj/item/rogueweapon/stoneaxe/battle
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		if("Warhammer + Shield")
			r_hand = /obj/item/rogueweapon/mace/warhammer
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		else //In case they DC or don't choose close the panel, etc
			r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead


// Spells + Orders (Orders are ONLY For HFT Lord job and the Hand Marshal Subclass)

/obj/effect/proc_holder/spell/self/convertrole/heartfelt
	name = "Recruit Retinue"
	new_role = "Heartfeltian Retinue"
	overlay_state = "recruit_brother"
	recruitment_faction = "Heartfelt"
	recruitment_message = "Join in the service of Heartfelt, %RECRUIT!"
	accept_message = "For Heartfelt!"
	refuse_message = "I refuse."

/obj/effect/proc_holder/spell/self/convertrole/heartfelt/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(HAS_TRAIT(recruit, TRAIT_HEARTFELT))
		to_chat(recruiter, span_warning("They're already part of our cause!"))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_GUARDSMAN))
		to_chat(recruiter, span_warning("They're already part of the Peak's guard! They can't join our cause!"))
		return FALSE
	if(HAS_TRAIT(recruit, TRAIT_INQUISITION))
		to_chat(recruiter, span_warning("Their loyalty is to Psydon alone! They can't join our cause!"))
		return FALSE
	//If you're reading this, please refactor this once we have TRAIT_CLERGY thanks
	if(HAS_TRAIT(recruit, TRAIT_CLERGY))
		to_chat(recruiter, span_warning("Clergy cannot join our cause! Their loyalty is to the Ten!"))
		return FALSE
	..()

/obj/effect/proc_holder/spell/invoked/order/heartfelt/proc/can_order(mob/living/target, mob/living/user)
	if(target == user)
		to_chat(user, span_alert("I cannot order myself!"))
		return 0
	if(HAS_TRAIT(target, TRAIT_HEARTFELT))
		if(target == user)
			to_chat(user, span_alert("I cannot order myself!"))
			return 0
		else
			return 1
	if(!(target.job in list("Heartfeltian Retinue", "Knight of Heartfelt")))
		to_chat(user, span_alert("I cannot order one not in our cause!"))
		return 0
	return 1


/obj/effect/proc_holder/spell/invoked/order/heartfelt
    name = "Heartfelt Order"
    var/effect_to_apply
    var/message_varname

/obj/effect/proc_holder/spell/invoked/order/heartfelt/cast(list/targets, mob/living/user)
    . = ..()
    if(!isliving(targets[1]))
        revert_cast()
        return FALSE

    var/mob/living/target = targets[1]
    var/msg = user.mind.vars[message_varname]

    if(!msg)
        to_chat(user, span_alert("I must say something to give an order!"))
        return

    var/allowed = can_order(target, user)
    if(!allowed)
        return

    user.say("[msg]")
    target.apply_status_effect(effect_to_apply)
    on_success(user, target)
    return TRUE

/obj/effect/proc_holder/spell/invoked/order/heartfelt/proc/on_success(mob/living/user, mob/living/target)
    return

/***************************************************************
 *  INDIVIDUAL HEARTFELT ORDERS
 ***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/heartfelt/retreat
    name = "Retreat!"
    overlay_state = "movemovemove"
    effect_to_apply = /datum/status_effect/buff/order/heartfelt/retreat
    message_varname = "retreattext"

/datum/status_effect/buff/order/heartfelt/retreat
    id = "retreat"
    alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/retreat
    effectedstats = list(STATKEY_SPD = 3)
    duration = 30 SECONDS

/datum/status_effect/buff/order/heartfelt/retreat/on_apply()
    . = ..()
    to_chat(owner, span_blue("My commander orders me to fall back!"))

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/retreat
    name = "Retreat!"
    desc = "My commander orders me to fall back!"
    icon_state = "buff"

/***************************************************************/


/obj/effect/proc_holder/spell/invoked/order/heartfelt/bolster
    name = "Hold the Line!"
    overlay_state = "bolster"
    effect_to_apply = /datum/status_effect/buff/order/heartfelt/bolster
    message_varname = "bolstertext"

/datum/status_effect/buff/order/heartfelt/bolster
    id = "bolster"
    alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/bolster
    effectedstats = list(STATKEY_CON = 3)
    duration = 1 MINUTES

/datum/status_effect/buff/order/heartfelt/bolster/on_apply()
    . = ..()
    to_chat(owner, span_blue("My commander orders me to hold the line!"))

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/bolster
    name = "Hold the Line!"
    desc = "My commander inspires me to endure and last a little longer!"
    icon_state = "buff"

/***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt
    name = "Stand and fight!"
    overlay_state = "onfeet"
    effect_to_apply = /datum/status_effect/buff/order/heartfelt/forheartfelt
    message_varname = "onfeettext"

/obj/effect/proc_holder/spell/invoked/order/heartfelt/forheartfelt/on_success(mob/living/user, mob/living/target)
    if(!(target.mobility_flags & MOBILITY_STAND))
        target.SetUnconscious(0)
        target.SetSleeping(0)
        target.SetParalyzed(0)
        target.SetImmobilized(0)
        target.SetStun(0)
        target.SetKnockdown(0)
        target.set_resting(FALSE)

/datum/status_effect/buff/order/heartfelt/forheartfelt
    id = "forheartfelt"
    alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/forheartfelt
    duration = 15 SECONDS

/datum/status_effect/buff/order/heartfelt/forheartfelt/on_apply()
    . = ..()
    to_chat(owner, span_blue("I must stand and fight!"))
    ADD_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)

/datum/status_effect/buff/order/heartfelt/forheartfelt/on_remove()
    REMOVE_TRAIT(owner, TRAIT_NOPAIN, MAGIC_TRAIT)
    . = ..()

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/forheartfelt
    name = "Stand your Ground!"
    desc = "My commander has ordered me to stand proud for Heartfelt!"
    icon_state = "buff"

/***************************************************************/

/obj/effect/proc_holder/spell/invoked/order/heartfelt/charge
    name = "Charge!"
    overlay_state = "charge"
    effect_to_apply = /datum/status_effect/buff/order/heartfelt/charge
    message_varname = "chargetext"

/datum/status_effect/buff/order/heartfelt/charge
    id = "charge"
    alert_type = /atom/movable/screen/alert/status_effect/buff/order/heartfelt/charge
    effectedstats = list(STATKEY_STR = 2, STATKEY_LCK = 2)
    duration = 1 MINUTES

/datum/status_effect/buff/order/heartfelt/charge/on_apply()
    . = ..()
    to_chat(owner, span_blue("My commander orders me to charge! For Heartfelt!"))

/atom/movable/screen/alert/status_effect/buff/order/heartfelt/charge
    name = "Charge!"
    desc = "My commander wills it - now is the time to charge!"
    icon_state = "buff"

/***************************************************************/

// Doesn't work at the moment

// /obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget
    // name = "Focus Target!"
    // overlay_state = "focustarget"
    // effect_to_apply = /datum/status_effect/debuff/order/heartfelt/focustarget
    // message_varname = "targettext"

// /datum/status_effect/debuff/order/heartfelt/focustarget
	//id = "target"
	// alert_type = /atom/movable/screen/alert/status_effect/debuff/order/heartfelt/focustarget
	// effectedstats = list("fortune" = -2)
	// duration = 1 MINUTES
	// var/outline_colour = "#69050a"

// /atom/movable/screen/alert/status_effect/debuff/order/heartfelt/focustarget
	// name = "Targetted"
	// desc = "A officer has marked me for death!"
	// icon_state = "targetted"

// /datum/status_effect/debuff/order/heartfelt/focustarget/on_apply()
	// . = ..()
	// to_chat(owner, span_alert("I have been marked for death by a officer!"))
	// ADD_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	// return TRUE

// /datum/status_effect/debuff/order/heartfelt/focustarget/on_remove()
	// . = ..()
	// REMOVE_TRAIT(owner, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)

// /obj/effect/proc_holder/spell/invoked/order/heartfelt/focustarget
	// name = "Focus target!"
	// overlay_state = "focustarget"

// #undef TARGET_FILTER

/***************************************************************
 *  ORDER SETUP PROC
 ***************************************************************/

/mob/living/carbon/human/mind/proc/setordersheartfelt()
    set name = "Rehearse Orders"
    set category = "Voice of Command"

    #define ORDER_INPUT(varname, prompt) \
        mind.varname = input("Send a message.", prompt) as text|null; \
        if(!mind.varname) { to_chat(src, "I must rehearse something for this order..."); return }

    ORDER_INPUT(retreattext, "Fall back!!")
    ORDER_INPUT(chargetext, "Push them back!!")
    ORDER_INPUT(bolstertext, "Hold the line!!")
    ORDER_INPUT(onfeettext, "Stand proud for Heartfelt!!")

    #undef ORDER_INPUT
