// Arcyne Potential now gives 3 Spellpoints instead of 6 spellpoints so it is less of a "must take" for caster.
/datum/virtue/combat/magical_potential
	name = "Arcyne Potential"
	desc = "I am talented in the Arcyne arts, expanding my capacity for magic. I have become more intelligent from its studies. Other effects depends on what training I chose to focus on at a later age."
	custom_text = "Classes that has a combat trait (Medium / Heavy Armor Training, Dodge Expert or Critical Resistance) get only prestidigitation. Everyone else get +3 spellpoints (or +3 utility spellpoints if pool-based) and T1 Arcyne Potential if they don't have any Arcyne."
	added_skills = list(list(/datum/skill/magic/arcane, 1, 6))

/datum/virtue/combat/magical_potential/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.get_skill_level(/datum/skill/magic/arcane)) // we can do this because apply_to is always called first
		if (!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation))
			recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/targeted/touch/prestidigitation)
		if (!HAS_TRAIT(recipient, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(recipient, TRAIT_HEAVYARMOR) && !HAS_TRAIT(recipient, TRAIT_DODGEEXPERT) && !HAS_TRAIT(recipient, TRAIT_CRITICAL_RESISTANCE))
			ADD_TRAIT(recipient, TRAIT_ARCYNE_T1, TRAIT_GENERIC)
			add_arcyne_potential_spellpoints(recipient, 3)
	else
		add_arcyne_potential_spellpoints(recipient, 3)

/// Helper: adds spellpoints to utility pool if available, otherwise flat spellpoints
/datum/virtue/combat/magical_potential/proc/add_arcyne_potential_spellpoints(mob/living/carbon/human/recipient, amount)
	if(recipient.mind?.spell_point_pools?["utility"])
		recipient.mind.spell_point_pools["utility"] += amount
		recipient.mind.check_learnspell()
	else
		recipient.mind?.adjust_spellpoints(amount)
	
/datum/virtue/combat/devotee
	name = "Devotee"
	desc = "Though not officially of the Church, my relationship with my chosen Patron is strong enough to grant me the most minor of their blessings. I've also kept a psycross of my deity."

	custom_text = "You gain access to T0 miracles of your patron. As a non-combat role you also receive a minor passive devotion gain. If you already have access to Miracles, you get slightly increased passive devotion gain."

	added_skills = list(list(/datum/skill/magic/holy, 1, 6))

/datum/virtue/combat/devotee/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.mind)
		return
	if (!recipient.devotion)
		// Only give non-devotionists orison... and T0 for some reason (Bad ideas are fun!)
		var/datum/devotion/new_faith = new /datum/devotion(recipient, recipient.patron)
		if (!HAS_TRAIT(recipient, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(recipient, TRAIT_HEAVYARMOR) && !HAS_TRAIT(recipient, TRAIT_DODGEEXPERT) && !HAS_TRAIT(recipient, TRAIT_CRITICAL_RESISTANCE))
			new_faith.grant_miracles(recipient, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = (CLERIC_REQ_1 - 10)) // Passive devotion regen only for non-combat classes
		else
			new_faith.grant_miracles(recipient, cleric_tier = CLERIC_T0, passive_gain = FALSE, devotion_limit = (CLERIC_REQ_1 - 20))	//Capped to T0 miracles.
	else
		// for devotionists, give them an amount of passive devo gain.
		var/datum/devotion/our_faith = recipient.devotion
		our_faith.passive_devotion_gain += CLERIC_REGEN_DEVOTEE
		START_PROCESSING(SSobj, our_faith)
	switch(recipient.patron?.type)
		if(/datum/patron/divine/astrata)
			recipient.mind?.special_items["Astrata Psycross"] = /obj/item/clothing/neck/roguetown/psicross/astrata
		if(/datum/patron/divine/abyssor)
			recipient.mind?.special_items["Abyssor Psycross"] = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			recipient.mind?.special_items["Dendor Psycross"] = /obj/item/clothing/neck/roguetown/psicross/dendor
		if(/datum/patron/divine/necra)
			recipient.mind?.special_items["Necra Psycross"] = /obj/item/clothing/neck/roguetown/psicross/necra
		if(/datum/patron/divine/pestra)
			recipient.mind?.special_items["Pestra Psycross"] = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/eora) 
			recipient.mind?.special_items["Eora Psycross"] = /obj/item/clothing/neck/roguetown/psicross/eora
		if(/datum/patron/divine/noc)
			recipient.mind?.special_items["Noc Psycross"] = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/ravox)
			recipient.mind?.special_items["Ravox Psycross"] =/obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			recipient.mind?.special_items["Malum Psycross"] = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/old_god)
			ADD_TRAIT(recipient, TRAIT_PSYDONITE, TRAIT_GENERIC)
			recipient.mind?.special_items["Psycross"] = /obj/item/clothing/neck/roguetown/psicross

/datum/virtue/combat/devotee/astratan_affinity
	name = "Astratan Affinity (Racial, Sun Elves)"
	desc = "This Virtue is unlisted and should not be visible."
	unlisted = TRUE

/datum/virtue/combat/devotee/astratan_affinity/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.patron?.type == /datum/patron/divine/astrata)
		..()
	else
		return	//goofball you wasted your racial

/datum/virtue/combat/combat_virtue
	name = "Trained & Ready"
	desc = "There are many facets of lyfe that can end it. I've taken to learning some of them, and kept the tools for them close."
	max_choices = 5
	choice_costs = list(0, 0, 0, 2, 4, 4)
	extra_choices = list(
		"Swords Skill (JMAN)" = /datum/skill/combat/swords,
		"Shield Skill (JMAN)" = /datum/skill/combat/shields,
		"Dagger Skill (JMAN)" = /datum/skill/combat/knives,
		"Unarmed Skill (JMAN)" = /datum/skill/combat/unarmed,
		"Sling Skill (JMAN)" = /datum/skill/combat/slings,
		"Axe Skill (JMAN)" = /datum/skill/combat/axes,
		"Whip Skill (JMAN)" = /datum/skill/combat/whipsflails,
		"Mace Skill (JMAN)" = /datum/skill/combat/maces,
		"Polearm Skill (JMAN)" = /datum/skill/combat/polearms,
		"Staves Skill (JMAN)" = /datum/skill/combat/staves,
		"Stashed Messer & Parrying Dagger" = list(/obj/item/rogueweapon/sword/short/messer/iron/virtue, /obj/item/rogueweapon/huntingknife/idagger/virtue),
		"Stashed Shield & Arming Sword" = list(/obj/item/rogueweapon/shield/wood, /obj/item/rogueweapon/sword/iron),
		"Stashed Quarterstaff & Sling" = list(/obj/item/rogueweapon/woodstaff/quarterstaff/iron, /obj/item/gun/ballistic/revolver/grenadelauncher/sling, /obj/item/quiver/sling/iron),
		"Stashed Spear & Mace" = list(/obj/item/rogueweapon/spear, /obj/item/rogueweapon/mace),
		"Stashed Katar & Knuckles" = list(/obj/item/rogueweapon/katar/bronze, /obj/item/rogueweapon/knuckles/bronzeknuckles),
		"Stashed Axe & Whip" = list(/obj/item/rogueweapon/stoneaxe/woodcut, /obj/item/rogueweapon/whip)
	)

/datum/virtue/combat/combat_virtue/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(triumph_check(recipient))
		for(var/choice in picked_choices)
			if(ispath(extra_choices[choice], /datum/skill))
				recipient.adjust_skillrank_up_to(extra_choices[choice], SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
			else if(islist(extra_choices[choice]))	//stashed items
				var/list/stash = extra_choices[choice]
				for(var/stuff in stash)
					var/obj/item/I = stuff
					recipient.mind?.special_items[capitalize(I::name)] = I

/datum/virtue/combat/bowman
	name = "Toxophilite"
	desc = "I've had an interest in archery from a young age, and I always keep a spare bow and quiver around."
	custom_text = "+1 to Bows, Up to Legendary, Minimum Apprentice"
	added_stashed_items = list("Recurve Bow" = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve,
								"Quiver (Arrows)" = /obj/item/quiver/arrows
	)

/datum/virtue/combat/bowman/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.get_skill_level(/datum/skill/combat/bows) < SKILL_LEVEL_APPRENTICE)
		recipient.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_APPRENTICE, silent = TRUE)
	else
		added_skills = list(list(/datum/skill/combat/bows, 1, 6))


/datum/virtue/combat/crossbowman
	name = "Marksman"
	desc = "Warfare is changing, and the crossbow is the next pedestal. I have always been ahead of the curve, as compared to my peers."
	custom_text = "+1 to Crossbows, Up to Legendary, Minimum Apprentice"
	added_stashed_items = list(
		"Quiver (Bolts)" = /obj/item/quiver/bolt/standard
	)

/datum/virtue/combat/crossbowman/apply_to_human(mob/living/carbon/human/recipient)
	if(recipient.get_skill_level(/datum/skill/combat/crossbows) < SKILL_LEVEL_APPRENTICE)
		recipient.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_APPRENTICE, silent = TRUE)
	else
		added_skills = list(list(/datum/skill/combat/crossbows, 1, 6))

/datum/virtue/combat/guarded
	name = "Guarded"
	desc = "I have long kept my true capabilities and vices a secret. Sometimes being deceptively weak can save one's lyfe."
	custom_text = "Obfuscates information about you from all sorts of effects, including patron abilities & passives, Assess and other virtues."
	added_traits = list(TRAIT_DECEIVING_MEEKNESS)

/datum/virtue/combat/rotcured
	name = "Rotcured"
	desc = "I was once afflicted with the accursed rot, and was cured. It has left me changed: my limbs are weaker, but I feel no pain and have no need to breathe..."
	custom_text = "Colors your body a distinct, sickly green."
	// below is functionally equivalent to dying and being resurrected via astrata T4 - yep, this is what it gives you.
	added_traits = list(TRAIT_EASYDISMEMBER, TRAIT_NOPAIN, TRAIT_NOPAINSTUN, TRAIT_NOBREATH, TRAIT_TOXIMMUNE, TRAIT_ZOMBIE_IMMUNE, TRAIT_ROTMAN, TRAIT_SILVER_WEAK)

/datum/virtue/combat/rotcured/apply_to_human(mob/living/carbon/human/recipient)
	recipient.update_body() // applies the rot skin tone stuff

/datum/virtue/combat/dualwielder
	name = "Dual Wielder"
	desc = "Whether it was by the Naledi scholars, Etruscan privateers or even the Kazengan senseis. I've been graced with the knowledge of how to wield two weapons at once."
	added_traits = list(TRAIT_DUALWIELDER)

/datum/virtue/combat/sharp
	name = "Sentinel of Wits"
	desc = "Whether it's by having an annoying sibling that kept prodding me with a stick, or years of study and observation, I've become adept at both parrying and dodging stronger opponents, by learning their moves and studying them."
	added_traits = list(TRAIT_SENTINELOFWITS)

/datum/virtue/combat/combat_aware
	name = "Combat Aware"
	desc = "The opponent's flick of their wrist. The sound of maille snapping. The desperate breath as the opponent's stamina wanes. All of this is made more clear to you through intuition or experience."
	custom_text = "Shows a lot more combat information via floating text. Has a toggle."
	added_traits = list(TRAIT_COMBAT_AWARE)

/datum/virtue/combat/combat_aware/apply_to_human(mob/living/carbon/human/recipient)
	recipient.verbs += /mob/living/carbon/human/proc/togglecombatawareness
