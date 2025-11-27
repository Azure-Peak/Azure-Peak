#define ENCHANT_DURATION 15 MINUTES
#define ENCHANT_DURATION_WILDERNESS 200 MINUTES

/obj/effect/proc_holder/spell/invoked/fittedclothing
	name = "Fit Clothing"
	desc = "Fit Clothing will allow you to fit a cloth or leather garment to an individual, allowing greater durability for a time \n\
	You can increase this time with an essence of wilderness, seeping it into the material\n\ "
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	recharge_time = 30 SECONDS
	antimagic_allowed = TRUE

/obj/effect/proc_holder/spell/invoked/fittedclothing/cast(list/targets, mob/user = usr)
	var/target = targets[1]
	var/obj/item/sacrifice

	//var/list/enchant_types = list("Durability" = DURABILITY_ENCHANT)

	for(var/obj/item/I in user.held_items)
		if(istype(I, /obj/item/natural/cured/essence))
			sacrifice = I

	if(istype(target, /obj/item/clothing/))
		var/obj/item/clothing/suit/roguetown/armor/clothingenchant = target
		if((!(clothingenchant.sewrepair)||isnull(clothingenchant.sewrepair) || !(clothingenchant.armor_class == ARMOR_CLASS_LIGHT)))
			to_chat(user, span_warning("You can only fit light armor pieces"))
			return
		var/enchant_type = DURABILITY_ENCHANT
		var/enchant_duration = sacrifice ? ENCHANT_DURATION_WILDERNESS : ENCHANT_DURATION
		if(sacrifice)
			qdel(sacrifice)
			to_chat(user, "I consumes the [sacrifice] to enchant [clothingenchant] permanently.")
		playsound(loc, 'sound/foley/sewflesh.ogg', 100, TRUE, -2)
		if(clothingenchant.GetComponent(/datum/component/fit_clothing))
			qdel(clothingenchant.GetComponent(/datum/component/fit_clothing))
		clothingenchant.AddComponent(/datum/component/fit_clothing, enchant_duration, TRUE, /datum/skill/magic/arcane, enchant_type)
		user.visible_message("[user] fits the [clothingenchant], allowing them to fit their wearer better")
		return TRUE
	else
		to_chat(user, span_warning("You can only fit light armor pieces"))
		revert_cast()
		return FALSE

#undef ENCHANT_DURATION
#undef ENCHANT_DURATION_WILDERNESS
