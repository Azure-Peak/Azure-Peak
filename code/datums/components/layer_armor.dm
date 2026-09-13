/datum/component/layeredarmor
	/// Basic reference list for which armor types this component will use.
	var/list/damtypes = list("blunt", "slash", "stab", "piercing")

	/// Skills required to repair them along with their minimum level
	var/list/repair_skills = list()

	/// Obj types that can be used to repair layers by clicking on the parent with if they meet the other requirements.
	var/list/repair_items = list()

	/// Race restrictions for repair
	var/list/race_repair = list()

	/// How many hits a given damage type requires to decay a tier in the armor. Is meant to increase as the armor gets worse.
	var/list/hits_to_shred = list(
		"blunt" = 10,
		"slash" = 10,
		"stab" = 10,
		"piercing" = 10,
	)

	/// Total hits accrued by a given damage tier until it gets shredded. Resets to 0 when matches the entry from hits_to_shred.
	var/list/hit_count = list(
		"blunt" = 0,
		"slash" = 0,
		"stab" = 0,
		"piercing" = 0,
	)

	/// Armor rating a given damage type can be repaired up to.
	var/list/layer_max = list(
		"blunt" = 100,
		"slash" = 100,
		"stab" = 100,
		"piercing" = 100,
	)

	/// New hit count requirements per shredded layer. ex. going from 100 to 90 will require 5 hits, 90 to 80 will require 10, etc.
	/// MAKE SURE THE VALUES CORRELATE WITH YOUR SHRED_AMT AND STARTING ARMOR VALUES IF YOU WISH TO USE THIS
	var/list/hits_per_layer = list(
		"100"	= 10,
		"90"	= 10,
		"80"	= 20,
		"70"	= 25,
		"60"	= 30,
		"50"	= 30,
		"40"	= 30,
		"30"	= 30,
		"20"	= 50,
		"10"	= 100,
	)

	/// A multiplier to a damage type. One hit from that type will equal this number if it's bigger than 1. ONLY USE WHOLE NUMBERS.
	var/list/damtype_shred_ratio = list(
		"blunt" = 1,
		"slash" = 1,
		"stab" = 1,
		"piercing" = 1,
	)

	/// Populated during repair_check(), leave empty.
	var/list/repairable_damtypes = list()

	/// How much armor is lost when a layer is shredded. Increments of 10 are recommended, as they correspond to letter tiers on examine (S -> A+ -> A -> B+ etc)
	var/shred_amt = 10

	/// What the next layer's hit threshold will increase by if the hits_per_layer list is empty. Doubles at 50 integrity and below by default.
	var/hits_default = 10

	/// Minimum damage applied to the armor required to trigger shredding.
	var/minimum_damage_req = 15

	/// Layer repair multiplier applied to shred_amt when fixing layers.
	var/layer_repair = 1

	/// Sound that is played when a layer is shredded.
	var/shred_sound = 'sound/misc/layer_peel.ogg'

	/// Soudn that is played when layers are repaired.
	var/repair_sound = 'sound/misc/layer_repair.ogg'

	/// A trait equipping this armor might apply. Mostly used by Grudgebearers atm. Avoid giving this to multiple armors that can be worn at the same time.
	var/applied_trait = null
	var/trait_message_apply
	var/trait_message_remove

/datum/component/layeredarmor/Initialize(...)
	. = ..()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	RegisterSignal(parent, COMSIG_ITEM_EQUIPPED, PROC_REF(on_equip))
	RegisterSignal(parent, COMSIG_ITEM_DROPPED, PROC_REF(on_drop))
	RegisterSignal(parent, COMSIG_OBJ_TAKE_DAMAGE, PROC_REF(take_damage))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY,PROC_REF(attacked_by))

/datum/component/layeredarmor/proc/on_equip(datum/source, mob/user, slot)
	if(applied_trait)
		if(!HAS_TRAIT(user, applied_trait))
			ADD_TRAIT(user, applied_trait, TRAIT_GENERIC)
			to_chat(user, trait_message_apply)

/datum/component/layeredarmor/proc/on_drop(datum/source, mob/user)
	if(applied_trait)
		if(HAS_TRAIT(user, applied_trait))
			REMOVE_TRAIT(user, applied_trait, TRAIT_GENERIC)
			to_chat(user, trait_message_remove)

/datum/component/layeredarmor/proc/take_damage(datum/source, damage_amount, damage_type, damage_flag)
	if(damage_amount >= minimum_damage_req)
		if(damage_flag)
			if(damage_flag in damtypes)
				add_hit(damage_flag)
				if(check_hit(damage_flag))
					shred_layer(damage_flag)
	else if(damage_flag in damtypes)
		var/obj/item/I = parent
		if(I.armor.vars[damage_flag] > 100)	//S+ layer, it can't take direct damage, so there's an exception.
			add_hit(damage_flag)
			if(check_hit(damage_flag))
				shred_layer(damage_flag)

/datum/component/layeredarmor/proc/on_examine(datum/source, mob/user, list/examine_list)
	examine_list += span_info("<br>Remaining hits until a layer is shredded:")
	for(var/type in damtypes)
		var/ratio = 1
		if(damtype_shred_ratio[type] > 1)
			ratio = damtype_shred_ratio[type]
		var/val = ROUND_UP(((hits_to_shred[type] - hit_count[type]) / ratio))	//Round it up so it doesn't lie (ex 3.1 would actually still require 4 hits to shred)
		var/color
		switch(val)
			if(1 to 2)
				color = "#741010"
			if(3 to 4)
				color = "#cfc45f"
			if(5 to 10)
				color = "#3c9c24"
			if(11 to 999)
				color = "#fdfdfd"
		examine_list += span_info("<b>[type]:</b><font color = '[color]'> \Roman[val]</font>")
	//Can I do repairs on it at all?
	if(length(race_repair))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.dna.species.type in race_repair)
				examine_list += span_info("<i>My people and I can try to repair this.</i>")
			else
				examine_list += span_info("This is all too foreign for me to repair.")
				return
	//What can we repair them with?
	if(length(repair_items))
		if(!HAS_TRAIT(user, TRAIT_TRAINED_SMITH))
			examine_list += span_info("The layers on this armor can be repaired on:")
			var/dat = "| "
			for(var/item in repair_items)
				var/obj/O = item
				dat += "<b>[O::name]</b> | "
			examine_list += span_info("[dat]<br>")
		else
			examine_list += span_info("I can repair the layers anywhere.")
	//What skills are needed?
	if(length(repair_skills))
		examine_list += span_info("The layers on this armor requires these skills to be repaired:")
		for(var/skill in repair_skills)
			examine_list += span_info("[SSskills.all_skills[skill]] — [SSskills.level_names_plain[repair_skills[skill]]]")

/datum/component/layeredarmor/proc/attacked_by(datum/source, obj/item/I, mob/living/user)
	if(ishuman(user) && istype(I, /obj/item/rogueweapon/hammer))
		var/mob/living/carbon/human/H = user
		var/can_do
		if(length(repair_items) && !HAS_TRAIT(user, TRAIT_TRAINED_SMITH))
			var/obj/item/IP = parent
			var/suitable_spot
			for(var/item in repair_items)
				var/obj/O = item
				suitable_spot = locate(O) in (get_turf(IP))
			if(suitable_spot)
				can_do = TRUE
			else
				can_do = FALSE
				var/str
				for(var/itemrepair in repair_items)
					var/obj/OR = itemrepair
					str = "[initial(OR.name)] "
				to_chat(user, span_warn("I require \a [str]."))
				return

		if(length(race_repair))
			if(H.dna.species.type in race_repair)
				can_do = TRUE
			else
				can_do = FALSE
				to_chat(user,span_warn("These layers are too foreign to me."))
				return
		else
			can_do = TRUE

		if(length(repair_skills))
			for(var/skill in repair_skills)
				if(H.get_skill_level(skill) < repair_skills[skill])	//Checking their skill level vs skill threshold
					can_do = FALSE
					to_chat(user,span_warn("I'm not skilled enough to repair the layers, but I could be."))
					return

		if(H.STAINT < 10)
			can_do = FALSE
			to_chat(user,span_warn("This craft's layers are too fine for my level of intelligence."))
			return

		if(can_do)
			try_repair(user)

/datum/component/layeredarmor/proc/try_repair(mob/user)
	if(repair_check())
		for(var/damtype in repairable_damtypes)
			if(damtype)
				user.visible_message(span_warn("[user] repairs the [damtype] layers on [parent]."), span_warn("I repair the [damtype] layers."))
				playsound(user, repair_sound, 100)
				add_layer(damtype, layer_repair)
	else
		to_chat(user,span_warn("There's nothing to repair."))

/datum/component/layeredarmor/proc/add_hit(damtype)
	if(damtype in damtypes)
		if(damtype in damtype_shred_ratio)
			hit_count[damtype] += damtype_shred_ratio[damtype]

/datum/component/layeredarmor/proc/check_hit(damtype)
	if(damtype)
		if(hit_count[damtype] >= hits_to_shred[damtype])
			return TRUE
		else
			return FALSE

/datum/component/layeredarmor/proc/shred_layer(damtype)
	var/obj/item/I = parent
	if(I.armor)
		if(I.armor.vars[damtype] > 100)
			I.armor.vars[damtype] = 100
		else if(I.armor.vars[damtype] > 0)
			I.armor.vars[damtype] -= shred_amt
		playsound(I, shred_sound, 100)
		I.visible_message(span_warning("A <b>[damtype]</b> layer is shredded from [I]!"))
		adjusthits(damtype, I.armor.vars[damtype])

/datum/component/layeredarmor/proc/adjusthits(damtype, newarmor)
	if(damtype && newarmor)
		var/new_threshold
		var/check = newarmor
		if(isnum(check))
			if(length(hits_per_layer))
				if(num2text(check) in hits_per_layer)
					new_threshold = hits_per_layer[num2text(check)]
			if(!new_threshold)	//We have a mismatch in hits_per_layer with our armor value (very bad) or its empty. Either way, we fall back to hits_default.
				switch(check)
					if(60 to 100)
						new_threshold = hits_default
					if(0 to 59)
						new_threshold = hits_default * 2
			hits_to_shred[damtype] = new_threshold
			hit_count[damtype] = 0

/datum/component/layeredarmor/proc/add_layer(damtype)
	var/obj/item/I = parent
	if(I.armor)
		I.armor.vars[damtype] += shred_amt * layer_repair
		if(layer_max[damtype] > 100 && I.armor.vars[damtype] > 100)	//We have a layer that has a max of above 100, and our repair just made us go over 100.
			I.armor.vars[damtype] = layer_max[damtype]
		else
			I.armor.vars[damtype] = min(I.armor.vars[damtype], 100, layer_max[damtype])	//Make sure it's never above 100, or the layer_max of that type.
		adjusthits(damtype, I.armor.vars[damtype])

/datum/component/layeredarmor/proc/repair_check()
	var/obj/item/I = parent
	var/status = FALSE
	LAZYCLEARLIST(repairable_damtypes)
	for(var/type in damtypes)
		if(I.armor.vars[type] < layer_max[type])
			LAZYADD(repairable_damtypes, type)
			status = TRUE
	return status
