// Virtues that let you unlock crafter role
/datum/virtue/utility/blacksmith
	name = "Blacksmith's Apprentice"
	desc = "In my youth, I worked under a skilled blacksmith, honing my skills with an anvil."
	added_traits = list(TRAIT_SMITHING_EXPERT)
	softcap = TRUE
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/weaponsmithing, 2, 2),
						list(/datum/skill/craft/armorsmithing, 2, 2),
						list(/datum/skill/craft/blacksmithing, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2)
	)

/datum/virtue/utility/apprentice
	name = "Labourious Apprentice"
	desc = "I've toiled away a part of my lyfe at the behest of another labourer, learning a thing or two."
	added_stashed_items = list("Lamptern" = /obj/item/flashlight/flare/torch/lantern)
	max_choices = 4
	choice_costs = list(0, 0, 2, 2)
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
			recipient.mind?.special_items[I::name] = extra_choices[choice]

/datum/virtue/utility/tailor
	name = "Tailor's Apprentice"
	desc = "In my youth, I worked under a skilled tailor, studying fabric and design."
	added_traits = list(TRAIT_SEWING_EXPERT)
	softcap = TRUE
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/labor/butchering, 2, 2),
						list(/datum/skill/craft/sewing, 2, 2),
						list(/datum/skill/craft/tanning, 2, 2),
	)
	added_stashed_items = list(
		"Needle" = /obj/item/needle,
		"Scissors" = /obj/item/rogueweapon/huntingknife/scissors
	)

/datum/virtue/utility/physician
	name = "Physician's Apprentice"
	desc = "In my youth, I worked under a skilled physician, studying medicine and alchemy."
	added_traits = list(TRAIT_MEDICINE_EXPERT, TRAIT_ALCHEMY_EXPERT)
	added_stashed_items = list("Medicine Pouch" = /obj/item/storage/belt/rogue/pouch/medicine)
	softcap = TRUE
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/alchemy, 2, 2),
						list(/datum/skill/misc/medicine, 2, 2)
	)

/datum/virtue/utility/physician/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient.mind?.has_spell(/obj/effect/proc_holder/spell/invoked/diagnose/secular))
		recipient.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/diagnose/secular)


/datum/virtue/utility/hunter
	name = "Hunter's Apprentice"
	desc = "In my youth, I trained under a skilled hunter, learning how to butcher animals and work with leather/hide."
	added_traits = list(TRAIT_SURVIVAL_EXPERT)
	softcap = TRUE
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/traps, 2, 2),
						list(/datum/skill/labor/butchering, 2, 2),
						list(/datum/skill/craft/sewing, 2, 2),
						list(/datum/skill/craft/tanning, 2, 2),
						list(/datum/skill/misc/tracking, 2, 2)
	)

/datum/virtue/utility/artificer
	name = "Artificer's Apprentice"
	desc = "In my youth, I worked under a skilled artificer, studying construction and engineering."
	added_traits = list(TRAIT_SMITHING_EXPERT)
	softcap = TRUE
	added_skills = list(list(/datum/skill/craft/crafting, 2, 2),
						list(/datum/skill/craft/carpentry, 2, 2),
						list(/datum/skill/craft/masonry, 2, 2),
						list(/datum/skill/craft/engineering, 2, 2),
						list(/datum/skill/craft/smelting, 2, 2),
						list(/datum/skill/craft/ceramics, 2, 2)
	)
	added_stashed_items = list(
		"Hammer" = /obj/item/rogueweapon/hammer/wood,
		"Chisel" = /obj/item/rogueweapon/chisel,
		"Hand Saw" = /obj/item/rogueweapon/handsaw
	)
