/datum/virtue/combat/magical_potential
	name = "Arcyne Potential"
	desc = "I am talented in the Arcyne arts, expanding my capacity for magic. I have become more intelligent from its studies. Other effects depends on what training I chose to focus on at a later age."
	custom_text = "Classes that has a combat trait (Medium / Heavy Armor Training, Dodge Expert, Critical Resistance, Thick Blooded, Painless or Enduring) get only prestidigitation. Everyone else get +3 utility points and Arcyne Training if they don't have any Arcyne."
	added_skills = list(list(/datum/skill/magic/arcane, 1, 6), list(/datum/skill/misc/reading, 1, 6))

/datum/virtue/combat/magical_potential/apply_to_human(mob/living/carbon/human/recipient)
	if (!recipient.get_skill_level(/datum/skill/magic/arcane))
		if (!recipient.mind?.has_spell(/datum/action/cooldown/spell/touch/prestidigitation))
			recipient.mind?.AddSpell(new /datum/action/cooldown/spell/touch/prestidigitation)
		if (!HAS_TRAIT(recipient, TRAIT_MEDIUMARMOR) && !HAS_TRAIT(recipient, TRAIT_HEAVYARMOR) && !HAS_TRAIT(recipient, TRAIT_DODGEEXPERT) && !HAS_TRAIT(recipient, TRAIT_CRITICAL_RESISTANCE) && !HAS_TRAIT(recipient, TRAIT_BLOOD_RESISTANCE) && !HAS_TRAIT(recipient, TRAIT_NOPAIN) && !HAS_TRAIT(recipient, TRAIT_NOPAINSTUN))
			ADD_TRAIT(recipient, TRAIT_ARCYNE, TRAIT_GENERIC)
			add_arcyne_potential_utilities(recipient, 3)
	else
		add_arcyne_potential_utilities(recipient, 3)

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
		"Stashed Messer" = list(/obj/item/rogueweapon/sword/short/messer/iron/virtue),
		"Stashed Parrying Dagger" = list(/obj/item/rogueweapon/huntingknife/idagger/virtue),
		"Stashed Arming Sword" = list(/obj/item/rogueweapon/sword/iron),
		"Stashed Quarterstaff" = list(/obj/item/rogueweapon/woodstaff/quarterstaff/iron),
		"Stashed Sling" = list(/obj/item/gun/ballistic/revolver/grenadelauncher/sling, /obj/item/quiver/sling/iron),
		"Stashed Spear (& Strap)" = list(/obj/item/rogueweapon/spear, /obj/item/rogueweapon/scabbard/gwstrap),
		"Stashed Mace" = list(/obj/item/rogueweapon/mace),
		"Stashed Katar" = list(/obj/item/rogueweapon/katar/bronze),
		"Stashed Knuckles" = list(/obj/item/clothing/gloves/roguetown/knuckles/bronze),
		"Stashed Axe" = list(/obj/item/rogueweapon/stoneaxe/woodcut),
		"Stashed Whip" = list(/obj/item/rogueweapon/whip)
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
	custom_text = "Obfuscates information about you from all sorts of effects, including patron abilities & passives, combat information, Assess and other virtues."
	added_traits = list(TRAIT_DECEIVING_MEEKNESS)

/datum/virtue/combat/guarded/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	add_verb(recipient, /mob/living/carbon/human/proc/toggle_descriptors)
	add_verb(recipient, /mob/living/carbon/human/proc/emote_ffsalute)
	add_verb(recipient, /mob/living/carbon/human/proc/toggle_guarded)


#define SC_ROTCURED "Rotcured"
#define SC_PALLID "Pallid"
#define SC_BLACKBLOOD "Blackblood"

/datum/virtue/combat/second_chance
	name = "Second Chance"
	desc = "Not many are given second chances. Somehow, you're among the lucky bastards who were. What foul, cruel fate did you narrowly escape, changed yet still living?"
	max_choices = 1
	restricted = TRUE
	races = list(/datum/species/construct/metal, /datum/species/gnoll)
	choice_costs = list(0, 0)

	extra_choices = list(
		SC_ROTCURED,
		SC_PALLID,
		SC_BLACKBLOOD,
	)
	choice_tooltips = list(
		SC_ROTCURED = "<font color='#4a8d48'>I was once afflicted with the accursed rot, and was cured. It has left me changed: my limbs are weaker, but I feel no pain and have no need to breathe.<br><br><font color=red>(Grants Easy Dismember, Painless, Breathless, Deathless, Poison Immune, Deadite Immune, Silver Weakness.)<font color=white><br><br>(Additionally, you can eat brains, you don't suffer nausea, and your heart does not beat.)</font>",
		SC_PALLID = "<font color='#8d4848'>I was once afflicted with vampirism, but was cured by somethign short of divine intervention. It has left me changed: silver burns my flesh, and the open sky fills me with unease. Yet I draw no breath, and my eyes pierce the darkness. Lingering traces of the curse that once claimed me. Traces I hope will fade in time.<br><br><font color=red>(Grants Darkvision, Breathless, Deadite Immunity and Silver Weakness.)<br><br><font color=white>(Additionally, being outdoors causes stress.)</font>",
		SC_BLACKBLOOD = "<font color='#8b488d'>I was once a nite-creacher, be it lycanthrope or vampyre, before the Otavan Inquisition subdued and exported me as a test subject of an experimental \"cure\" for my Quicksilver-resistant taint. This intense therapy had me warped, inside, outside, body and mind, into something 'idealistically' humen-like for Otavan standards, even if I am now no different than a sentient, hollowed ghoul.<br><br><font color=red>(Grants Darkvision, Strong Bite, Inhumen Digestion, and Silver Weakness.)<br><br><font color=white>(Additionally, healing miracles do not work on you, but consuming any food will grant a minor healing buff. You bleed slower and passively recover from wounds (while not hungry). You will feel stressed when exposed to Sunlight, and panic while being around or interacting with members of the Inquisition.)",
	)

/datum/virtue/combat/second_chance/apply_to_human(mob/living/carbon/human/recipient)
	spawn(80)
		if(QDELETED(src) || QDELETED(recipient))
			return

		if(recipient.mind.has_antag_datum(/datum/antagonist/skeleton) || recipient.mind.has_antag_datum(/datum/antagonist/lich) || recipient.mind.has_antag_datum(/datum/antagonist/vampire) || recipient.mind.has_antag_datum(/datum/antagonist/vampire/lord) || recipient.mind.has_antag_datum(/datum/antagonist/werewolf) || recipient.mind.has_antag_datum(/datum/antagonist/zombie))
			to_chat(recipient, "Second Chance cannot be applied to your role, so it has been removed.")
			QDEL_NULL(src)
			return

		for(var/choice in picked_choices)
			switch(choice)
				if(SC_ROTCURED)
					ADD_TRAIT(recipient, TRAIT_ROTMAN, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_EASYDISMEMBER, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_NOPAIN, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_NOBREATH, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_DEATHLESS, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_TOXIMMUNE, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_ZOMBIE_IMMUNE, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_SILVER_WEAK, TRAIT_VIRTUE)
					to_chat(recipient, "You are no longer a rotting corpse, at least not a dying one.</font>")

				if(SC_PALLID)
					ADD_TRAIT(recipient, TRAIT_PALLID, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_DARKVISION, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_NOBREATH, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_ZOMBIE_IMMUNE, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_SILVER_WEAK, TRAIT_VIRTUE)
					to_chat(recipient, "You are no longer one scorned by Astrata, by the mercy of the gods.</font>")
				
				if(SC_BLACKBLOOD)
					ADD_TRAIT(recipient, TRAIT_BLACKBLOOD, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_STRONGBITE, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_NASTY_EATER, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_NITEVISION, TRAIT_VIRTUE)
					ADD_TRAIT(recipient, TRAIT_SILVER_WEAK, TRAIT_VIRTUE)
					to_chat(recipient, "You are no longer one among the nite creechers, by the ingenuinity of HIS followers.</font>")

					// blackened blood, finally
					recipient.dna.species.blood_color = "#4b2e2e"

					// inquisition trauma goes here
					if(!(recipient.patron?.type == /datum/patron/old_god))
						var/datum/charflaw/averse/A
						for(var/datum/charflaw/averse/F in recipient.charflaws)
							A = F
							break
						if(A)
							A.chosen_group |= GLOB.averse_factions["Inquisition"]
							to_chat(recipient, span_blue("<i>You recall your horrid experiences with the Inquisition... It is rather traumatic. Best to avoid them.</i>"))
						else
							A = new
							A.set_jobflag("Inquisition")
							recipient.charflaws += A
							to_chat(recipient, span_blue("<i>You recall your horrid experiences with the Inquisition... It is rather traumatic. Best to avoid them.</i>"))
					else
						to_chat(recipient, span_blue("<i>You recall your horrid experiences with the Inquisition... But through your newfound faith in HIM, you ENDURE. You were but one wrong righted, after all.</i>"))
					to_chat(recipient, span_danger("DISCLAIMER: This Second Choice option exists to support roleplay and backstory continuity, not to diminish the threat or narrative weight of vampires, werewolves, or similar antagonistic entities. You are a tortured survivor of the Otavan Inquisition, and your very LUX fears them. Failure to roleplay this appropriately may result in this option's removal. Have fun and don't be cringe."))

#undef SC_ROTCURED
#undef SC_BLACKBLOOD
#undef SC_PALLID

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
	add_verb(recipient, /mob/living/carbon/human/proc/togglecombatawareness)
