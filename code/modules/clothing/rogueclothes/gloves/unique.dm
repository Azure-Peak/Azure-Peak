/obj/item/clothing/gloves/roguetown/plate/dwarven
	name = "grudgebearer dwarven gauntlets"
	desc = "Forged to fit the stubbiest of fingers."
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon_state = "dwarfhand"
	item_state = "dwarfhand"

/obj/item/clothing/gloves/roguetown/elven_gloves
	name = "woad elven gloves"
	desc = "The insides are lined with soft, living leaves and soil. They wick away moisture easily."
	allowed_race = list(/datum/species/elf/wood, /datum/species/human/halfelf, /datum/species/elf/dark)
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "welfhand"
	item_state = "welfhand"
	armor = ARMOR_BLACKOAK //Resistant to blunt and stab, super weak to slash.
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	max_integrity = ARMOR_INT_SIDE_IRON
	smeltresult = /obj/item/rogueore/coal
	anvilrepair = /datum/skill/craft/carpentry

/obj/item/clothing/gloves/roguetown/bandages
	name = "bandages"
	desc = "Thickly-woven bandages that've been wrapped around the hands. It soaks up the sweat from your palm, strengthens your fists, and protects your knuckles from dislodged teeth."
	sleeved = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon = 'icons/roguetown/clothing/gloves.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	icon_state = "clothwraps"
	item_state = "clothwraps"
	armor = ARMOR_PADDED_BAD //Light padding — worse than leather gloves, but offers some cushioning.
	max_integrity = 200
	resistance_flags = FIRE_PROOF
	blocksound = SOFTHIT
	break_sound = 'sound/foley/cloth_rip.ogg'
	drop_sound = 'sound/foley/dropsound/cloth_drop.ogg'
	anvilrepair = null
	sewrepair = TRUE
	salvage_result = /obj/item/natural/cloth
	unarmed_bonus = 3 //Light armor with good durability and a flat unarmed damage bonus. Loadout-selectable.

/obj/item/clothing/gloves/roguetown/bandages/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("Allows unarmed parrying, similar to bracers. Takes integrity damage when parrying. Expert Pugilists parry far more effectively with these.")

/obj/item/clothing/gloves/roguetown/bandages/weighted
	name = "weighted bandages"
	desc = "Thickly-woven bandages that've been wrapped around the hands, fitted with padded knuckleweights. It soaks up the sweat from your palm, strengthens your fists, and protects your knuckles from dislodged teeth."
	unarmed_bonus = 4 //Craftable. Given to non-specialized Monks and other certain subclasses.

/obj/item/clothing/gloves/roguetown/bandages/pugilist
	name = "pugilistic bandages"
	desc = "Thickly-woven bandages that've been wrapped around the hands, fitted with alloyed knuckleweights. It soaks up the sweat from your palm, strengthens your fists, and protects your knuckles from dislodged teeth."
	unarmed_bonus = 6 //Non-craftable. Restricted to Monks who've specialized in unarmed combat, and nothing else.

// Knuckledusters — high damage, moderate durability gloves. +8 bonus, 200 integrity. Still inferior to bandages (armor + higher bonus options) but not disposable.
/obj/item/clothing/gloves/roguetown/knuckles
	name = "steel knuckles"
	desc = "A mean looking pair of steel knuckles."
	icon = 'icons/roguetown/weapons/unarmed32.dmi'
	icon_state = "steelknuckle"
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/gloves.dmi'
	w_class = WEIGHT_CLASS_SMALL
	armor = ARMOR_PADDED_BAD
	max_integrity = ARMOR_INT_SIDE_LEATHER // 200 — small steel pieces, leather-tier durability
	anvilrepair = /datum/skill/craft/weaponsmithing
	smeltresult = /obj/item/ingot/steel
	unarmed_bonus = 8

/obj/item/clothing/gloves/roguetown/knuckles/get_mechanics_examine(mob/user)
	. = ..()
	. += span_notice("Allows unarmed parrying, similar to bracers. Takes integrity damage when parrying. Expert Pugilists parry far more effectively with these.")
	//. += span_notice("Activate - while held in your current hand - to turn these into knuckledusters, which can be wielded as a dedicated weapon for unarmed combat.")

/obj/item/clothing/gloves/roguetown/knuckles/bronze
	name = "bronze knuckles"
	desc = "A mean looking pair of bronze knuckles. Mildly heavier than its steel counterpart, making it a solid defensive option, if less wieldy."
	icon_state = "bronzeknuckle"
	smeltresult = /obj/item/ingot/bronze

/obj/item/clothing/gloves/roguetown/knuckles/psydon
	name = "psydonic knuckles"
	desc = "A simple piece of harm molded in a holy mixture of steel and silver, finished with three stumps - Psydon's crown - to crush the heretics' garments and armor into smithereens."
	icon_state = "psyknuckle"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silverblessed

/obj/item/clothing/gloves/roguetown/knuckles/psydon/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_PSYDONIAN,\
		silver_type = SILVER_PSYDONIAN,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/clothing/gloves/roguetown/knuckles/psydon/attack_self(mob/living/user)
	. = ..()
	user.visible_message(span_warning("[user] starts adjusting their grip on[src]."))
	if(do_after(user, 3 SECONDS))
		var/obj/item/clothing/gloves/roguetown/knuckles/psydon/P = new /obj/item/rogueweapon/knuckledusters/psy(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		P.obj_integrity = src.obj_integrity
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops adjusting their grip on [src]."))
		return

/obj/item/clothing/gloves/roguetown/knuckles/silver
	name = "silver knuckles"
	desc = "A simple piece of harm that has been molded from pure silver, and further studded to stop errant strikes dead in their tracks. Though ostensibly holy, these heftsome knuckleweights are \
	more strongly associated with underground pugilistic tournaments; a solid right hook could drive more-than-enough force to blow a yeoman's jaw clean off."
	icon_state = "silverknuckle"
	is_silver = TRUE
	smeltresult = /obj/item/ingot/silver

/obj/item/clothing/gloves/roguetown/knuckles/silver/ComponentInitialize()
	AddComponent(\
		/datum/component/silverbless,\
		pre_blessed = BLESSING_TENNITE,\
		silver_type = SILVER_TENNITE,\
		added_force = 0,\
		added_blade_int = 0,\
		added_int = 50,\
		added_def = 2,\
	)

/obj/item/clothing/gloves/roguetown/knuckles/silver/attack_self(mob/living/user)
	. = ..()
	user.visible_message(span_warning("[user] starts adjusting their grip on[src]."))
	if(do_after(user, 3 SECONDS))
		var/obj/item/clothing/gloves/roguetown/knuckles/silver/P = new /obj/item/rogueweapon/knuckledusters/silver(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		P.obj_integrity = src.obj_integrity
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops adjusting their grip on [src]."))
		return

/obj/item/clothing/gloves/roguetown/knuckles/psydon/old
	name = "enduring knuckles"
	desc = "A simple piece of harm molded in a holy mixture of steel and silver, its holy blessing long since faded. You are HIS weapon, you needn't fear Aeon."
	icon_state = "psyknuckle"
	is_silver = FALSE
	smeltresult = /obj/item/ingot/steel
	color = COLOR_FLOORTILE_GRAY

/obj/item/clothing/gloves/roguetown/knuckles/psydon/old/attack_self(mob/living/user)
	. = ..()
	user.visible_message(span_warning("[user] starts adjusting their grip on[src]."))
	if(do_after(user, 3 SECONDS))
		var/obj/item/clothing/gloves/roguetown/knuckles/psydon/old/P = new /obj/item/rogueweapon/knuckledusters/enduring(get_turf(src.loc))
		if(user.is_holding(src))
			user.dropItemToGround(src)
			user.put_in_hands(P)
		P.obj_integrity = src.obj_integrity
		qdel(src)
	else
		user.visible_message(span_warning("[user] stops adjusting their grip on [src]."))
		return

/obj/item/clothing/gloves/roguetown/knuckles/psydon/old/ComponentInitialize()
	return

/obj/item/clothing/gloves/roguetown/knuckles/decrepit
	name = "decrepit knuckles"
	desc = "A set of knuckles made of ancient metals, Aeon's grasp withers their form."
	icon_state = "aknuckle"
	max_integrity = 50 //Extra fragile — ancient and degraded.
	smeltresult = /obj/item/ingot/aalloy
	unarmed_bonus = 4

/obj/item/clothing/gloves/roguetown/knuckles/ancient
	name = "ancient knuckles"
	desc = "A set of knuckles made of ancient metals, Aeon's grasp has been lifted from their form."
	icon_state = "aknuckle"
	smeltresult = /obj/item/ingot/aaslag
	unarmed_bonus = 6

/obj/item/clothing/gloves/roguetown/knuckles/eora
	name = "close caress"
	desc = "Some times call for a more intimate approach."
	icon_state = "eoraknuckle"
	max_integrity = 150
	unarmed_bonus = 10//So they are better how they used to be
