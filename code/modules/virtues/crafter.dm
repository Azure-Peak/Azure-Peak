// Virtues that let you unlock crafter role
#define SKILLED_BSMITH "Blacksmith Apprentice"
#define SKILLED_TAILOR "Tailor Apprentice"
#define SKILLED_HUNTER "Hunter Apprentice"
#define SKILLED_PHYS "Physician Apprentice"
#define SKILLED_FORESTER "Forester Apprentice"
#define SKILLED_ARTIF "Artificer Apprentice"

/datum/virtue/utility/skilled
	name = "Skilled Apprentice"
	desc = "In my youth I had the privilege of being an apprentice to a notable craftsman, learning much and more from them."
	max_choices = 2
	stackable = TRUE
	softcap = TRUE
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2))
	choice_costs = list(0, 20)
	extra_choices = list(
		SKILLED_BSMITH,
		SKILLED_TAILOR,
		SKILLED_HUNTER,
		SKILLED_PHYS,
		SKILLED_FORESTER,
		SKILLED_ARTIF,
	)
	choice_tooltips = list(
		SKILLED_BSMITH	= "Grants Expert Forgehand. Weaponsmithing, Armorsmithing, Blacksmithing and Smelting raised to Apprentice.",
		SKILLED_TAILOR	= "Grants Expert Clothier. Butchering, Tanning raised to Apprentice. Sewing raised to Journeyman. Stashed Needle & Scissors.",
		SKILLED_HUNTER	= "Grants Expert Survivalist. Trapping, Tracking, Butchering, Sewing and Tanning raised to Apprentice.",
		SKILLED_PHYS	= "Grants Expert Physicker and Alchemist. Alchemy and Medicine raised to Apprentice. Grants secular diagnose and a stashed medicine pouch.",
		SKILLED_FORESTER= "Cooking, Athletics, Farming, Fishing, Lumberjacking raised to Apprentice. Stashed hoe.",
		SKILLED_ARTIF	= "Grants Expert Forgehand. Carpentry, Masonry, Engineering, Smelting and Ceramics raised to Apprentice. Stashed Hammer, Chisel and Hand Saw."
	)

/datum/virtue/utility/skilled/on_load()
	added_skills.Cut()	//This whole datum gets saved, so we need to make sure we aren't infinitely stacking these every time we join / save / load.
	added_traits.Cut()
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2))

/datum/virtue/utility/skilled/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(!triumph_check(recipient))
		return

	added_skills = list(list(/datum/skill/craft/crafting, 2, 2))
	for(var/choice in picked_choices)
		switch(choice)
			if(SKILLED_BSMITH)
				added_skills.Add(list(list(/datum/skill/craft/weaponsmithing, 2, 2)))
				added_skills.Add(list(list(/datum/skill/craft/armorsmithing, 2, 2)))
				added_skills.Add(list(list(/datum/skill/craft/blacksmithing, 2, 2)))
				added_skills.Add(list(list(/datum/skill/craft/smelting, 2, 2)))
				added_traits.Add(TRAIT_SMITHING_EXPERT)
			if(SKILLED_TAILOR)
				added_skills.Add(list(list(/datum/skill/labor/butchering, 2, 2)))
				added_skills.Add(list(list(/datum/skill/craft/sewing, 3, 3)))
				added_skills.Add(list(list(/datum/skill/craft/tanning, 2, 2)))
				added_traits.Add(TRAIT_SEWING_EXPERT)
				recipient.mind?.special_items["Needle"] = /obj/item/needle
				recipient.mind?.special_items["Scissors"] = /obj/item/rogueweapon/huntingknife/scissors
			if(SKILLED_HUNTER)
				added_skills.Add(list(list(/datum/skill/craft/traps, 2, 2)))
				added_skills.Add(list(list(/datum/skill/misc/tracking, 2, 2)))
				added_skills.Add(list(list(/datum/skill/labor/butchering, 2, 2)))
				added_skills.Add(list(list(/datum/skill/craft/sewing, 2, 2)))
				added_skills.Add(list(list(/datum/skill/craft/tanning, 2, 2)))
				added_traits.Add(TRAIT_SURVIVAL_EXPERT)
			if(SKILLED_PHYS)
				added_skills.Add(list(list(/datum/skill/craft/alchemy, 2, 2)))
				added_skills.Add(list(list(/datum/skill/misc/medicine, 2, 2)))
				added_traits.Add(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
				if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
					recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)
				recipient.mind?.special_items["Medicine Pouch"] = /obj/item/storage/belt/rogue/pouch/medicine
			if(SKILLED_FORESTER)
				added_skills.Add(list(list(/datum/skill/craft/cooking, 2, 2)))
				added_skills.Add(list(list(/datum/skill/misc/athletics, 2, 2)))
				added_skills.Add(list(list(/datum/skill/labor/farming, 2, 2)))
				added_skills.Add(list(list(/datum/skill/labor/fishing, 2, 2)))
				added_skills.Add(list(list(/datum/skill/labor/lumberjacking, 2, 2)))
				recipient.mind?.special_items["Trusty Hoe"] = /obj/item/rogueweapon/hoe
			if(SKILLED_ARTIF)
				added_skills.Add(list(list(/datum/skill/craft/carpentry, 2, 2)))
				added_skills.Add(list(list(/datum/skill/craft/masonry, 2, 2)))
				added_skills.Add(list(list(/datum/skill/craft/engineering, 2, 2)))
				added_skills.Add(list(list(/datum/skill/craft/smelting, 2, 2)))
				added_skills.Add(list(list(/datum/skill/craft/ceramics, 2, 2)))
				added_traits.Add(TRAIT_SMITHING_EXPERT)
				recipient.mind?.special_items["Hammer"] = /obj/item/rogueweapon/hammer/wood
				recipient.mind?.special_items["Chisel"] = /obj/item/rogueweapon/chisel
				recipient.mind?.special_items["Hand Saw"] = /obj/item/rogueweapon/handsaw


#undef SKILLED_BSMITH
#undef SKILLED_TAILOR
#undef SKILLED_HUNTER
#undef SKILLED_PHYS
#undef SKILLED_FORESTER
#undef SKILLED_ARTIF

/datum/virtue/utility/apprentice
	name = "Labourious Apprentice"
	desc = "I've toiled away a part of my lyfe at the behest of another labourer, learning a thing or two."
	added_stashed_items = list("Lamptern" = /obj/item/flashlight/flare/torch/lantern)
	max_choices = 4
	choice_costs = list(0, 0, 3, 3)
	extra_choices = list(
		"Mining Skill (+3, Up to Legendary)" = list(/datum/skill/labor/mining, TRAIT_SMITHING_EXPERT),
		"Lumberjacking Skill (+3, Up to Legendary)" = /datum/skill/labor/lumberjacking,
		"Stashed Steel Axe" = /obj/item/rogueweapon/stoneaxe/woodcut/steel/woodcutter,
		"Stashed Steel Pickaxe" = /obj/item/rogueweapon/pick/steel
	)

/datum/virtue/utility/apprentice/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	if(!triumph_check(recipient))
		return
	for(var/choice in picked_choices)
		if(islist(extra_choices[choice]))
			var/list/choicelist = extra_choices[choice]
			for(var/subchoice in choicelist)
				if(ispath(subchoice, /datum/skill))
					recipient.adjust_skillrank(subchoice, SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
				else if(subchoice in GLOB.roguetraits)
					ADD_TRAIT(recipient, subchoice, TRAIT_VIRTUE)
		if(ispath(extra_choices[choice], /datum/skill))
			recipient.adjust_skillrank(extra_choices[choice], SKILL_LEVEL_JOURNEYMAN, silent = TRUE)
		if(ispath(extra_choices[choice], /obj/item))
			var/obj/item/I = extra_choices[choice]
			recipient.mind?.special_items[capitalize(I::name)] = extra_choices[choice]



