/datum/advclass/mercenary/desert_rider_sahir
	name = "Desert Rider Sahir"
	tutorial = "You're a Sahir - a wisened Magi from the desert of Raneshen. You have spent your lyfe studying the arcyne arts. Some of your rank knows the way of the sword- a necessity when one happens upon monstrsities that are resilient to magyck in the desert. Sahir are granted Ziqa, a cantrip which allows them to easily evade foes and slip capture."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider_sahir
	class_select_category = CLASS_CAT_RANESHENI
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_WARMAGE)
	cmode_music = 'sound/music/combat_desertrider.ogg'
	subclass_languages = list(/datum/language/raneshi)
	traits_applied = list(TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_INT = 3,
		STATKEY_PER = 2
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 9, "ward" = TRUE)
	extra_context = "This subclass chooses between twin shamshirs or a more traditional staff."
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/arcyne = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/desert_rider_sahir/pre_equip(mob/living/carbon/human/H)
	..()

	// Gear - same as Almah, with a chosen martial focus + scholar's pouch
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/raneshen
	neck = /obj/item/clothing/neck/roguetown/gorget/copper
	mask = /obj/item/clothing/mask/rogue/facemask/copper
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	gloves = /obj/item/clothing/gloves/roguetown/angle
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	backr = /obj/item/storage/backpack/rogue/satchel/black

	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/clothing/neck/roguetown/shalal,
		/obj/item/rogueweapon/spellbook/greater,
		/obj/item/flashlight/flare/torch,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/sahir_sandstorm)
		var/weapons = list("Twin Shamshirs", "Greater Staff")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Twin Shamshirs")
				beltl = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
			if("Greater Staff")
				r_hand = /obj/item/rogueweapon/woodstaff/implement/greater

	H.merctype = 4

/datum/action/cooldown/spell/sahir_sandstorm
	name = "Ziqa"
	desc = "Rare is a spell not created by university magi; this is one such example. The Desert Riders created this out of practicality and necessity, combining the second-order schools of Geomancy and Displacement. \n\
	In wide open environments, this incant would typically create gigantic sandstorms to paralyze and disorient . Azuria does not have nearly so much loose particulate, but it's still a very useful way to make an escape. \n\
	Creates a dust and sand cloud around me, and briefly grants Phase."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune6"
	sound = 'sound/items/firesnuff.ogg'
	spell_color = "#C2A66B"
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE
	cooldown_time = 45 SECONDS
	spell_impact_intensity = SPELL_IMPACT_LOW
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/sahir_sandstorm/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/sahir = owner
	if(!istype(sahir))
		return FALSE

	playsound(sahir, 'sound/items/firesnuff.ogg', 70, TRUE)
	sahir.balloon_alert_to_viewers("<font color='[GLOW_COLOR_DISPLACEMENT]'>Phased!</font>")
	sahir.visible_message(span_warning("<b>Howling dust and sand flows from [sahir]!</b>"), span_notice("<b>I slip through dust and sand!</b>"))
	sahir.apply_status_effect(/datum/status_effect/buff/phase)

	for(var/turf/storm_turf in range(1, sahir))
		if(storm_turf.density)
			continue
		new /obj/effect/particle_effect/smoke/sahir_sandstorm(storm_turf)
	return TRUE

/obj/effect/particle_effect/smoke/sahir_sandstorm
	name = "sandstorm"
	color = "#e3c68a"
	lifetime = 3
	breathin = FALSE
