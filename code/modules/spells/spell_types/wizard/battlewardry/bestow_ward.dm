/datum/action/cooldown/spell/bestow_ward
	name = "Bestow Ward"
	desc = "Channel arcyne energy to wrap an ally in a protective ward. The ward covers their entire body with light armor, \
	yielding coverage to any real armor they wear. The ward lasts for 2.5 minutes or until destroyed. \
	Cannot override an existing ward of equal or greater strength, and will never override non-arcyne protections."
	button_icon = 'icons/mob/actions/mage_battlewardry.dmi'
	button_icon_state = "bestow_ward"
	sound = 'sound/magic/whiteflame.ogg'
	spell_color = GLOW_COLOR_WARD
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_BATTLEWARDRY

	click_to_activate = TRUE
	cast_range = 2
	self_cast_possible = FALSE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	invocations = list("Aegis Impono!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/ward_type = /obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed
	var/ward_duration = 2.5 MINUTES

/datum/action/cooldown/spell/bestow_ward/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/caster = owner
	if(!istype(caster))
		return FALSE

	var/mob/living/carbon/human/target = cast_on
	if(!ishuman(target))
		to_chat(caster, span_warning("I can only bestow a ward upon a person."))
		return FALSE

	if(target == caster)
		to_chat(caster, span_warning("I cannot bestow a ward upon myself."))
		return FALSE

	// Safety: NEVER override non-arcyne skin armor (werewolf hide, etc)
	if(target.skin_armor)
		if(!istype(target.skin_armor, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward))
			to_chat(caster, span_warning("[target] is already protected by something beyond my power to overcome."))
			return FALSE
		var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/existing = target.skin_armor
		if(existing.arcyne_armor_tier >= ARCYNE_WARD_TIER_OTHER)
			// Refresh duration if same tier bestowed ward
			if(istype(existing, /obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed))
				var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed/bestowed = existing
				bestowed.refresh_duration(ward_duration)
				to_chat(caster, span_notice("I refresh [target]'s ward."))
				target.visible_message(span_notice("[target]'s arcyne ward shimmers brightly as it is renewed!"))
				return TRUE
			to_chat(caster, span_warning("[target] already bears a ward of equal or greater strength."))
			return FALSE

	var/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed/ward = new ward_type(target)
	target.skin_armor = ward
	ward.setup_ward(target)
	ward.set_duration(ward_duration)

	target.visible_message(span_notice("An arcyne ward shimmers into existence around [target]!"))
	to_chat(caster, span_notice("I bestow an arcyne ward upon [target]."))
	return TRUE

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed
	name = "bestowed ward"
	desc = "An arcyne ward placed by another mage. It cannot be dismissed - it must be weathered or destroyed."
	max_integrity = 200
	arcyne_armor_tier = ARCYNE_WARD_TIER_OTHER
	ward_color = GLOW_COLOR_WARD

	// Bestowed wards do not regenerate
	auto_repair_mode = FALSE
	repair_time = 0

	var/duration_timer

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed/armour_regen()
	return

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed/proc/set_duration(duration)
	if(duration_timer)
		deltimer(duration_timer)
	duration_timer = QDEL_IN(src, duration)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed/proc/refresh_duration(duration)
	if(duration_timer)
		deltimer(duration_timer)
	duration_timer = QDEL_IN(src, duration)
	obj_integrity = min(obj_integrity + 50, max_integrity)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed/Destroy()
	if(duration_timer)
		deltimer(duration_timer)
		duration_timer = null
	return ..()

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed/setup_ward(mob/living/carbon/human/H)
	ward_owner = H
	RegisterSignal(H, COMSIG_ITEM_EQUIPPED, PROC_REF(on_owner_equip_change))
	RegisterSignal(H, COMSIG_ITEM_DROPPED, PROC_REF(on_owner_equip_change))
	recalculate_coverage()
	// Very visible glow so everyone can see the warded person
	H.add_filter("bestowed_ward_glow", 2, list("type" = "outline", "color" = ward_color, "alpha" = 150, "size" = 2))

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/arcyne_ward/bestowed/cleanup_ward()
	if(ward_owner)
		ward_owner.remove_filter("bestowed_ward_glow")
	..()
