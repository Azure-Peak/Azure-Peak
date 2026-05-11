
//Javelins - Basically spears, but to get them working as proper javelins and able to fit in a bag, they are 'ammo'. (Maybe make an atlatl later?)
//Only ammo casing, no 'projectiles'. You throw the casing, as weird as it is.
/obj/item/ammo_casing/caseless/rogue/javelin
	force = 14
	throw_speed = 4
	ammo_weight = 5 // Javelins are bulky — 5 weight each in a javelinbag
	flags_ai_inventory = AI_ITEM_THROWING
	name = "iron javelin"
	desc = "A tool used for centuries, as early as recorded history. This one is tipped with a iron head; standard among militiamen and irregulars alike."
	icon_state = "ijavelin"
	wlength = WLENGTH_NORMAL
	w_class = WEIGHT_CLASS_BULKY
	armor_penetration = PEN_MEDIUM			//Redfined because.. it's not a weapon, it's an 'arrow' basically.
	max_integrity = 50						//Breaks semi-easy, stops constant re-use.
	wdefense = 3							//Worse than a spear
	thrown_bclass = BCLASS_STAB				//Knives are slash, lets try out stab and see if it's too strong in terms of wounding.
	throwforce = 25							//throwing knife is 22, slightly better for being bulkier.
	possible_item_intents = list(/datum/intent/sword/thrust, /datum/intent/spear/bash, /datum/intent/spear/cut)	//Sword-thrust to avoid having 2 reach.
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 35, "embedded_fall_chance" = 10)	//Better than iron throwing knife by 10%
	anvilrepair = /datum/skill/craft/weaponsmithing
	associated_skill = /datum/skill/combat/polearms
	heavy_metal = FALSE						//Stops spin animation, maybe.
	thrown_damage_flag = "piercing"			//Checks peircing protection.

/obj/item/ammo_casing/caseless/rogue/javelin/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.8,"sx" = -6,"sy" = -1,"nx" = 8,"ny" = 0,"wx" = -4,"wy" = 0,"ex" = 2,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = -38,"sturn" = 37,"wturn" = 32,"eturn" = -23,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("wielded")
				return list("shrink" = 0.8,"sx" = 4,"sy" = -2,"nx" = -3,"ny" = -2,"wx" = -5,"wy" = -1,"ex" = 3,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 7,"sturn" = -7,"wturn" = 16,"eturn" = -22,"nflip" = 8,"sflip" = 0,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/ammo_casing/caseless/rogue/javelin/aalloy
	name = "decrepit javelin"
	desc = "A missile of frayed bronze. Before you is your weapon; that which rose Man out of the mud, and brought the Beasts of Old Syon to heel. When were you last aware of any other part of you? Do you recall seeing the world in any other way?"
	icon_state = "ajavelin"
	throwforce = 20
	force = 10
	color = "#bb9696"
	embedding = list("embedded_pain_multiplier" = 6, "embed_chance" = 65, "embedded_fall_chance" = 5)
	smeltresult = null // Override iron inherit
	anvilrepair = null

/obj/item/ammo_casing/caseless/rogue/javelin/bronze
	name = "bronze javelin"
	desc = "A tool used for centuries, as early as recorded history. This one is tipped with a bronze head, wide and serrated - a death knell to the unarmored, and a staggering wound to the beplated."
	icon_state = "bjavelin"
	force = 20
	throwforce = 36	//Devastating against unarmored foes, but with nearly halved armor penetration.
	armor_penetration = PEN_LIGHT
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 80, "embedded_fall_chance" = 5)
	thrown_bclass = BCLASS_PICK
	smeltresult = null // 1 Ingot = 2 Javelins

/obj/item/ammo_casing/caseless/rogue/javelin/steel
	force = 16
	armor_penetration = PEN_HEAVY
	name = "steel javelin"
	desc = "A tool used for centuries, as early as recorded history. This one is tipped with a steel head; perfect for piercing armor!"
	icon_state = "javelin"
	max_integrity = 100						//In-line with other stabbing weapons.
	throwforce = 28							//Equal to steel knife BUT this has peircing damage type so..
	thrown_bclass = BCLASS_PICK				//Bypasses crit protection better than stabbing. Makes it better against heavy-targets.
	embedding = list("embedded_pain_multiplier" = 4, "embed_chance" = 45, "embedded_fall_chance" = 10) //Better than steel throwing knife by 10%
	smeltresult = null // 1 Ingot = 2 Javelins

/obj/item/ammo_casing/caseless/rogue/javelin/steel/paalloy
	name = "ancient javelin"
	desc = "A missile of polished gilbranze. Old Syon had drowned beneath His tears, and Her ascension had brought forth this world's end - so that You, with the killing blow, could become God."
	icon_state = "ajavelin"
	smeltresult = null // 1 Ingots = 2 Javelins

/obj/item/ammo_casing/caseless/rogue/javelin/silver
	name = "silver javelin"
	desc = "A tool used for centuries, as early as recorded history. This one is tipped with a silver head, perfect for sundering the supernatural from a safe distance."
	icon_state = "sjavelin"
	is_silver = TRUE
	throwforce = 25							//Less than steel because it's.. silver. Good at killing vampires/WW's still.
	armor_penetration = PEN_HEAVY
	thrown_bclass = BCLASS_PICK				//Bypasses crit protection better than stabbing. Makes it better against heavy-targets.
	smeltresult = null

/obj/item/ammo_casing/caseless/rogue/javelin/silver/ComponentInitialize()
	. = ..()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_NONE,\
		silver_type = SILVER_TENNITE,\
		added_force = -3,\
		added_blade_int = 50,\
		added_int = 50,\
		added_def = 3,\
	)

//Snowflake code to make sure the silver-bane is applied on hit to targeted mob. Thanks to Aurorablade for getting this code to work.
/obj/item/ammo_casing/caseless/rogue/javelin/silver/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	..()
	if(!iscarbon(hit_atom))
		return//abort
