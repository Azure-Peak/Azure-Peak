/datum/component/silverbless
	var/is_blessed
	var/pre_blessed
	var/silver_type
	var/cursed_item_intdamage

/datum/component/silverbless/Initialize(pre_blessed = BLESSING_NONE, silver_type)
	if(!istype(parent, /obj/item/rogueweapon) && !istype(parent, /obj/item/clothing/gloves/roguetown/knuckles))
		return COMPONENT_INCOMPATIBLE
	src.pre_blessed = pre_blessed
	src.silver_type = silver_type
	if(pre_blessed)
		apply_bless(pre_blessed)

/datum/component/silverbless/RegisterWithParent()
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equipped))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_dropped))

/datum/component/silverbless/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_PARENT_EXAMINE, COMSIG_ITEM_EQUIPPED, COMSIG_ITEM_DROPPED))

/datum/component/silverbless/proc/on_equipped(obj/item/equipped, mob/user, slot)
	if(is_blessed && slot & ITEM_SLOT_HANDS)
		user.add_stress(/datum/stressevent/blessed_weapon)

/datum/component/silverbless/proc/on_dropped(obj/item/dropped, mob/user, slot)
	if(is_blessed)
		user.remove_stress(/datum/stressevent/blessed_weapon)

/datum/component/silverbless/proc/on_examine(datum/source, mob/user, list/examine_list)
	if(!is_blessed)
		if(silver_type & SILVER_PSYDONIAN)
			examine_list += span_info("<font color = '#cfa446'>This object may be blessed by the lingering shard of COMET SYON.</font>")
		else if(silver_type & SILVER_TENNITE)
			examine_list += span_info("<font color = '#cfa446'>This object may be blessed by a bishop.</font>")
	if(is_blessed == BLESSING_PSYDONIAN)
		examine_list += span_info("<font color = '#46bacf'>This object has been blessed by COMET SYON.</font>")
	else if(is_blessed == BLESSING_TENNITE)
		examine_list += span_info("<font color = '#46bacf'>This object has been blessed by THE TEN.</font>")

/datum/component/silverbless/proc/get_int_damage_multiplier()
	if(!is_blessed)
		return TRUE
	if(silver_type & SILVER_PSYDONIAN)
		return CURSEITEM_INT_DAMAGE_PSY_MULTIPLIER
	if(silver_type & SILVER_TENNITE)
		return CURSEITEM_INT_DAMAGE_TEN_MULTIPLIER
	return TRUE

/datum/component/silverbless/proc/try_bless(blessing_type)
	if(!is_blessed)
		apply_bless(blessing_type)
		play_effects()
		return TRUE
	else
		return FALSE

/datum/component/silverbless/proc/play_effects()
	if(isitem(parent))
		var/obj/item/I = parent
		playsound(I, 'sound/magic/holyshield.ogg', 100)
		if(silver_type == SILVER_PSYDONIAN) //Courtesy of @UntoldTactics, from PR #1354 on Scarlet Reach.
			I.visible_message(span_notice("[I] glistens with power as dust of COMET SYON lands upon it!"))
		else
			I.visible_message(span_notice("[I] glistens with power as a divine blessing is infused within!"))

/datum/component/silverbless/proc/apply_bless(blessing_type)
	if(blessing_type == BLESSING_TENNITE)
		cursed_item_intdamage = CURSEITEM_INT_DAMAGE_TEN_MULTIPLIER
	else
		cursed_item_intdamage = CURSEITEM_INT_DAMAGE_PSY_MULTIPLIER
	var/obj/item/rogueweapon/W = parent
	is_blessed = blessing_type
	W.name = "blessed [W.name]"
	W.AddComponent(/datum/component/metal_glint)
	W.on_blessed(blessing_type)
