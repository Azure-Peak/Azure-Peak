// Arcyne Forge — merged Conjure Weapon + Conjure Tool.
// Conjured items have halved durability and a glow to indicate they are conjured.

/datum/action/cooldown/spell/arcyne_forge
	button_icon = 'icons/mob/actions/mage_conjure.dmi'
	name = "Arcyne Forge"
	desc = "Conjure a weapon or tool of your choice. Conjured items have halved durability.\n\
	Only one conjured item can exist at a time - conjuring a new one destroys the old."
	button_icon_state = "arcyne_forge"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_FERRAMANCY

	click_to_activate = TRUE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_CONJURE

	invocations = list("Conjura Telum!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = 2 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 5 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/obj/item/conjured_item

	var/list/conjure_options = list(
		// Weapons
		"Short Sword" = /obj/item/rogueweapon/sword/short/iron,
		"Hunting Sword" = /obj/item/rogueweapon/sword/short/messer/iron,
		"Arming Sword" = /obj/item/rogueweapon/sword/iron,
		"Cudgel" = /obj/item/rogueweapon/mace/cudgel,
		"Warhammer" = /obj/item/rogueweapon/mace/warhammer,
		"Dagger" = /obj/item/rogueweapon/huntingknife/idagger,
		"Axe" = /obj/item/rogueweapon/stoneaxe/woodcut,
		"Flail" = /obj/item/rogueweapon/flail,
		"Whip" = /obj/item/rogueweapon/whip,
		"Wooden Shield" = /obj/item/rogueweapon/shield/wood,
		// Tools
		"Pickaxe" = /obj/item/rogueweapon/pick,
		"Hoe" = /obj/item/rogueweapon/hoe,
		"Thresher" = /obj/item/rogueweapon/thresher,
		"Sickle" = /obj/item/rogueweapon/sickle,
		"Pitchfork" = /obj/item/rogueweapon/pitchfork,
		"Tongs" = /obj/item/rogueweapon/tongs,
		"Hammer" = /obj/item/rogueweapon/hammer/iron,
		"Shovel" = /obj/item/rogueweapon/shovel,
		"Handsaw" = /obj/item/rogueweapon/handsaw,
		"Fishing Rod" = /obj/item/fishingrod,
		"Frying Pan" = /obj/item/cooking/pan,
		"Pot" = /obj/item/reagent_containers/glass/bucket/pot,
		"Bowl" = /obj/item/reagent_containers/glass/bowl,
		"Fork" = /obj/item/kitchen/fork/iron,
		"Spoon" = /obj/item/kitchen/spoon/iron,
	)

/datum/action/cooldown/spell/arcyne_forge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/choice = tgui_input_list(H, "Choose what to conjure", "Arcyne Forge", conjure_options)
	if(!choice)
		return FALSE

	// Destroy previous conjured item
	if(conjured_item && !QDELETED(conjured_item))
		conjured_item.visible_message(span_warning("[conjured_item] shimmers and fades away!"))
		qdel(conjured_item)

	var/item_path = conjure_options[choice]
	var/obj/item/R = new item_path(H.drop_location())

	// Halve durability
	R.max_integrity = round(R.max_integrity * 0.5)
	R.obj_integrity = R.max_integrity

	// Mark as conjured — no salvage, no smelting
	R.smeltresult = null
	R.salvage_result = null
	R.fiber_salvage = FALSE

	// Conjured glow
	R.AddComponent(/datum/component/conjured_item, GLOW_COLOR_ARCANE)

	H.put_in_hands(R)
	conjured_item = R
	return TRUE

/datum/action/cooldown/spell/arcyne_forge/Destroy()
	if(conjured_item && !QDELETED(conjured_item))
		conjured_item.visible_message(span_warning("[conjured_item] shimmers and fades away!"))
		qdel(conjured_item)
	conjured_item = null
	return ..()

/datum/action/cooldown/spell/arcyne_forge/miracle
	point_cost = 0
	spell_tier = 0
	associated_skill = /datum/skill/magic/holy
