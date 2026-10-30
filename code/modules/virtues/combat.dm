/datum/virtue/combat/magical_potential
	name = "Arcyne Potential"
	desc = "I am talented in the Arcyne arts, expanding my capacity for magic. I have become more intelligent from its studies. Other effects depends on what training I chose to focus on at a later age."
	ui_fa_icon = "hand-sparkles"
	custom_text = "Grants prestidigitation and arcyne trait if not already present. Also grants utility points: mages and non-mage classes with no combat traits (Medium / Heavy Armor Training, Dodge Expert, Critical Resistance, Thick Blooded, Painless or Enduring) get 4, nonmages with combat traits get 1."
	added_skills = list(list(/datum/skill/magic/arcane, 1, 6), list(/datum/skill/misc/reading, 1, 6))

/datum/virtue/combat/magical_potential/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.get_skill_level(/datum/skill/magic/arcane))
		if (!recipient.mind?.has_spell(/datum/action/cooldown/spell/touch/prestidigitation))
			recipient.mind?.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
		ADD_TRAIT(recipient, TRAIT_ARCYNE, TRAIT_GENERIC)
		add_arcyne_potential_utilities(recipient, (!HAS_TRAIT(recipient, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(recipient, TRAIT_HEAVYARMOR) && !HAS_TRAIT(recipient, TRAIT_DODGEEXPERT) && !HAS_TRAIT(recipient, TRAIT_CRITICAL_RESISTANCE) && !HAS_TRAIT(recipient, TRAIT_BLOOD_RESISTANCE) && !HAS_TRAIT(recipient, TRAIT_NOPAIN) && !HAS_TRAIT(recipient, TRAIT_NOPAINSTUN)) ? 4 : 1)
	else
		add_arcyne_potential_utilities(recipient, 4)

/datum/virtue/combat/magical_potential/proc/add_arcyne_potential_utilities(mob/living/carbon/human/recipient, amount)
	if(!recipient.mind)
		return
	if(!LAZYLEN(recipient.mind.mage_aspect_config))
		recipient.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 0), grant_attunement = FALSE)
	recipient.mind.mage_aspect_config["utilities"] += amount
	recipient.mind.check_learnspell()

/datum/virtue/combat/devotee
	name = "Devotee"
	desc = "Though not officially of the Church, my relationship with my chosen Patron is strong enough to grant me the most minor of their blessings. I've also kept a psycross of my deity."
	ui_fa_icon = "person-praying"

	custom_text = "You gain access to T0 miracles of your patron. As a non-combat role you also receive a minor passive devotion gain. If you already have access to Miracles, you get slightly increased passive devotion gain."

	added_skills = list(list(/datum/skill/magic/holy, 1, 6))

/datum/virtue/combat/devotee/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.mind)
		return
	if (!recipient.devotion)
		// Only give non-devotionists orison... and T0 for some reason (Bad ideas are fun!)
		var/datum/devotion/new_faith = new /datum/devotion(recipient, recipient.patron)
		new_faith.grant_miracles(recipient, cleric_tier = CLERIC_T0, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = (CLERIC_REQ_1 - 10))
	else
		// for devotionists, give them an amount of passive devo gain.
		var/datum/devotion/our_faith = recipient.devotion
		our_faith.passive_devotion_gain += CLERIC_REGEN_DEVOTEE
		START_PROCESSING(SSobj, our_faith)
	switch(recipient.patron?.type)
		if(/datum/patron/divine/astrata)
			recipient.mind?.special_items["Amulet of Astrata"] = /obj/item/clothing/neck/roguetown/psicross/astrata
		if(/datum/patron/divine/abyssor)
			recipient.mind?.special_items["Amulet of Abyssor"] = /obj/item/clothing/neck/roguetown/psicross/abyssor
		if(/datum/patron/divine/dendor)
			recipient.mind?.special_items["Amulet of Dendor"] = /obj/item/clothing/neck/roguetown/psicross/dendor
		if(/datum/patron/divine/necra)
			recipient.mind?.special_items["Amulet of Necra"] = /obj/item/clothing/neck/roguetown/psicross/necra
		if(/datum/patron/divine/pestra)
			recipient.mind?.special_items["Amulet of Pestra"] = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/eora)
			recipient.mind?.special_items["Amulet of Eora"] = /obj/item/clothing/neck/roguetown/psicross/eora
		if(/datum/patron/divine/noc)
			recipient.mind?.special_items["Amulet of Noc"] = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/ravox)
			recipient.mind?.special_items["Amulet of Ravox"] =/obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			recipient.mind?.special_items["Amulet of Malum"] = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/old_god)
			ADD_TRAIT(recipient, TRAIT_PSYDONITE, TRAIT_GENERIC)
			recipient.mind?.special_items["Psycross"] = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			recipient.mind?.special_items["Amulet of the Undivided"] = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/inhumen/matthios)
			recipient.mind?.special_items["Amulet of Matthios"] = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
		if(/datum/patron/inhumen/graggar)
			recipient.mind?.special_items["Amulet of Graggar"] = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
		if(/datum/patron/inhumen/baotha)
			recipient.mind?.special_items["Amulet of Baotha"] = /obj/item/clothing/neck/roguetown/psicross/inhumen/baotha
		if(/datum/patron/inhumen/zizo)
			recipient.mind?.special_items["Inverted Psycross"] = /obj/item/clothing/neck/roguetown/psicross/inhumen/iron

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
	ui_fa_icon = "shield"
	max_choices = 5
	choice_costs = list(0, 0, 0, 2, 4, 4)
	extra_choices = list(
		"Sword Skill (JMAN)" = /datum/skill/combat/swords,
		"Dagger Skill (JMAN)" = /datum/skill/combat/knives,
		"Unarmed Skill (JMAN)" = /datum/skill/combat/unarmed,
		"Sling Skill (JMAN)" = /datum/skill/combat/slings,
		"Axe Skill (JMAN)" = /datum/skill/combat/axes,
		"Whip Skill (JMAN)" = /datum/skill/combat/whipsflails,
		"Mace Skill (JMAN)" = /datum/skill/combat/maces,
		"Polearm Skill (JMAN)" = /datum/skill/combat/polearms,
		"Staves Skill (JMAN)" = /datum/skill/combat/staves,
		"Bow Skill (JMAN)" = /datum/skill/combat/bows, // this is JMAN now cause of ansari's changes making having PER mandatory, should be fine I hope? nerf later if it isn't
		"Crossbow Skill (JMAN)" = /datum/skill/combat/crossbows, // ditto also crossbows fucking suck at any level below expert D:
		"Stashed Dueling Messer" = list(/obj/item/rogueweapon/sword/short/messer/iron/virtue),
		"Stashed Arming Sword" = list(/obj/item/rogueweapon/sword/iron),
		"Stashed Parrying Dagger" = list(/obj/item/rogueweapon/huntingknife/idagger/virtue),
		"Stashed Axe" = list(/obj/item/rogueweapon/stoneaxe/woodcut),
		"Stashed Spear (& Strap)" = list(/obj/item/rogueweapon/spear, /obj/item/rogueweapon/scabbard/gwstrap),
		"Stashed Quarterstaff" = list(/obj/item/rogueweapon/woodstaff/quarterstaff/iron),
		"Stashed Mace" = list(/obj/item/rogueweapon/mace),
		"Stashed Knuckles" = list(/obj/item/clothing/gloves/roguetown/knuckles/bronze),
		"Stashed Katar" = list(/obj/item/rogueweapon/katar/bronze),
		"Stashed Whip" = list(/obj/item/rogueweapon/whip),
		"Stashed Sling" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/sling, /obj/item/quiver/sling/iron),
		// the idea is that, unlike the sling, you'll need to toast your triumphs to get your ammo in too, technically increasing the cost and not making this so free, or you can bite the bullet and not have other jman skills of course
		"Stashed Bow" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow), // the snazzier one!
		"Stashed Quiver" = list(/obj/item/quiver/arrows), // pls insert 1 more dosh
		"Stashed Crossbow" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/iron), // the weaker one!
		"Stashed Bolts" = list(/obj/item/quiver/bolt/standard), // pls insert 1 more dosh
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

/datum/virtue/combat/guarded
	name = "Guarded"
	desc = "I have long kept my true capabilities and vices a secret. Sometimes being deceptively weak can save one's lyfe."
	ui_fa_icon = "user-secret"
	custom_text = "Obfuscates information about you from all sorts of effects, including patron abilities & passives, combat information, Assess and other virtues."
	added_traits = list(TRAIT_DECEIVING_MEEKNESS)

/datum/virtue/combat/guarded/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	add_verb(recipient, /mob/living/carbon/human/proc/toggle_descriptors)
	add_verb(recipient, /mob/living/carbon/human/proc/emote_ffsalute)
	add_verb(recipient, /mob/living/carbon/human/proc/toggle_guarded)


/datum/virtue/combat/second_chance
	name = "Rotcured"
	desc = "I was once afflicted with the accursed rot, and was cured. It has left me changed: my limbs are weaker, but I feel no pain and have no need to breathe."
	custom_text = "Grants Easy Dismember, Painless, Breathless, Deathless, Poison Immune, Deadite Immune and Silver Weakness. You can also eat brains, you don't suffer nausea, and your heart does not beat."
	ui_fa_icon = "biohazard"
	restricted = TRUE
	races = list(/datum/species/construct/metal, /datum/species/gnoll)

/datum/virtue/combat/second_chance/apply_to_human(mob/living/carbon/human/recipient)
	spawn(80)
		if(QDELETED(src) || QDELETED(recipient))
			return

		if(recipient.mind.has_antag_datum(/datum/antagonist/skeleton) || recipient.mind.has_antag_datum(/datum/antagonist/lich) || recipient.mind.has_antag_datum(/datum/antagonist/vampire) || recipient.mind.has_antag_datum(/datum/antagonist/vampire/lord) || recipient.mind.has_antag_datum(/datum/antagonist/werewolf) || recipient.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(recipient, "Rotcured cannot be applied to your role, so it has been removed.")
			QDEL_NULL(src)
			return

		ADD_TRAIT(recipient, TRAIT_ROTMAN, TRAIT_VIRTUE)
		ADD_TRAIT(recipient, TRAIT_EASYDISMEMBER, TRAIT_VIRTUE)
		ADD_TRAIT(recipient, TRAIT_NOPAIN, TRAIT_VIRTUE)
		ADD_TRAIT(recipient, TRAIT_NOBREATH, TRAIT_VIRTUE)
		ADD_TRAIT(recipient, TRAIT_DEATHLESS, TRAIT_VIRTUE)
		ADD_TRAIT(recipient, TRAIT_TOXIMMUNE, TRAIT_VIRTUE)
		ADD_TRAIT(recipient, TRAIT_ZOMBIE_IMMUNE, TRAIT_VIRTUE)
		ADD_TRAIT(recipient, TRAIT_SILVER_WEAK, TRAIT_VIRTUE)
		to_chat(recipient, "You are no longer a rotting corpse, at least not a dying one.")

/datum/virtue/combat/dualwielder
	name = "Dual Wielder"
	desc = "A weapon in each hand, a threat from every angle. Through solitary practice or under the tutelage of masters, I've honed my skill in wielding two weapons at once."
	custom_text = "You can perform these attacks unarmed as well, though their finishers work a little differently. Journeyman proficiency or higher is still required. Being knocked down or leaving combat mode will reset your combo."
	ui_fa_icon = "2"
	added_traits = list(TRAIT_DUALWIELDER)

/datum/virtue/combat/sharp
	name = "Sentinel of Wits"
	desc = "Whether it's by having an annoying sibling that kept prodding me with a stick, or years of study and observation, I've become adept at both parrying and dodging stronger opponents, by learning their moves and studying them."
	ui_fa_icon = "user-ninja"
	added_traits = list(TRAIT_SENTINELOFWITS)

/datum/virtue/combat/combat_aware
	name = "Combat Aware"
	desc = "The opponent's flick of their wrist. The sound of maille snapping. The desperate breath as the opponent's stamina wanes. All of this is made more clear to you through intuition or experience."
	ui_fa_icon = "eye-o"
	custom_text = "Shows a lot more combat information via floating text. Has a toggle."
	added_traits = list(TRAIT_COMBAT_AWARE)

/datum/virtue/combat/combat_aware/apply_to_human(mob/living/carbon/human/recipient)
	add_verb(recipient, /mob/living/carbon/human/proc/togglecombatawareness)
