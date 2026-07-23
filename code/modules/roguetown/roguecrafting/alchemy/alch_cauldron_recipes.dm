/datum/alch_cauldron_recipe/antidote
	name = "Antidote"
	smells_like = "wet moss"
	output_reagents = list(/datum/reagent/medicine/antidote = 90)

/datum/alch_cauldron_recipe/strong_antidote
	name = "Antidote (Strong)"
	smells_like = "purity"
	output_reagents = list(/datum/reagent/medicine/strong_antidote = 90)

/datum/alch_cauldron_recipe/berrypoison
	name = "Poison (Berry)"
	smells_like = "death"
	skill_required = SKILL_LEVEL_JOURNEYMAN // Basic poison should be harder to handle
	output_reagents = list(/datum/reagent/berrypoison = 90)

/datum/alch_cauldron_recipe/doompoison
	name = "Poison (Doom)"
	smells_like = "doom"
	skill_required = SKILL_LEVEL_EXPERT // Strong poison should be more difficult to make
	output_reagents = list(/datum/reagent/strongpoison = 90)

/datum/alch_cauldron_recipe/stam_poison
	name = "Stamina Poison"
	smells_like = "a slow breeze"
	skill_required = SKILL_LEVEL_JOURNEYMAN // Basic poison should be harder to handle
	output_reagents = list(/datum/reagent/stampoison = 90)

/datum/alch_cauldron_recipe/big_stam_poison
	name = "Stamina Poison (Strong)"
	smells_like = "stagnant air"
	skill_required = SKILL_LEVEL_EXPERT // Strong poison should be more difficult to make
	output_reagents = list(/datum/reagent/strongstampoison = 90)

/datum/alch_cauldron_recipe/sleeping_poison
	name = "Sleep Poison"
	smells_like = "numbing mint"
	skill_required = SKILL_LEVEL_MASTER // Fairly potent, let's lock it behind high alchemy skill.
	output_reagents = list(/datum/reagent/sleep_powder = 90)

//Healing potions
/datum/alch_cauldron_recipe/health_potion
	name = "Elixir of Health"
	smells_like = "sweet berries"
	output_reagents = list(/datum/reagent/medicine/healthpot = 90)

/datum/alch_cauldron_recipe/big_health_potion
	name = "Elixir of Health (Strong)"
	smells_like = "berry pie"
	skill_required = SKILL_LEVEL_JOURNEYMAN // If it has "Strong", lock it roundstart for Apothecary or above
	output_reagents = list(/datum/reagent/medicine/stronghealth = 90)

/datum/alch_cauldron_recipe/mana_potion
	name = "Elixir of Mana"
	smells_like = "power"
	output_reagents = list(/datum/reagent/medicine/manapot = 90)

/datum/alch_cauldron_recipe/big_mana_potion
	name = "Elixir of Mana (Strong)"
	smells_like = "fear"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	output_reagents = list(/datum/reagent/medicine/strongmana = 90)

/datum/alch_cauldron_recipe/stamina_potion
	name = "Elixir of Fortitude"
	smells_like = "fresh air"
	output_reagents = list(/datum/reagent/medicine/stampot = 30)

/datum/alch_cauldron_recipe/big_stamina_potion
	name = "Elixir of Fortitude (Strong)"
	smells_like = "clean winds"
	skill_required = SKILL_LEVEL_JOURNEYMAN
	output_reagents = list(/datum/reagent/medicine/strongstam = 30)

/datum/alch_cauldron_recipe/restoration_potion
	name = "Elixir of Restoration"
	smells_like = "fizzling berries"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/medicine/restoration = 90)

//S.P.E.C.I.A.L. potions - Expert or above (roundstart Witch etc.)

/datum/alch_cauldron_recipe/str_potion
	name = "Potion of Mountain Muscles"
	smells_like = "petrichor"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/strength = 30)

/datum/alch_cauldron_recipe/per_potion
	name = "Potion of Keen Eye"
	smells_like = "fire"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/perception = 30)

/datum/alch_cauldron_recipe/end_potion
	name = "Potion of Enduring Fortitude"
	smells_like = "mountain air"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/endurance = 30)

/datum/alch_cauldron_recipe/con_potion
	name = "Potion of Stone Flesh"
	smells_like = "earth"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/constitution = 30)

/datum/alch_cauldron_recipe/int_potion
	name = "Potion of Keen Mind"
	smells_like = "water"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/intelligence = 30)

/datum/alch_cauldron_recipe/spd_potion
	name = "Potion of Fleet Foot"
	smells_like = "clean air"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/speed = 30)

/datum/alch_cauldron_recipe/lck_potion
	name = "Potion of Seven Clovers"
	smells_like = "calming"
	skill_required = SKILL_LEVEL_EXPERT
	output_reagents = list(/datum/reagent/buff/fortune = 30)

/datum/alch_cauldron_recipe/fire_potion
	name = "Potion of Fire Warding"
	smells_like = "authority"
	skill_required = SKILL_LEVEL_MASTER
	output_reagents =list(/datum/reagent/fire_resist = 30)

/datum/alch_cauldron_recipe/trait
	abstract_type = /datum/alch_cauldron_recipe/trait
	skill_required = SKILL_LEVEL_JOURNEYMAN // the difficulty in these is making the rubedo catalyst

/datum/alch_cauldron_recipe/trait/nitevision
	name = "Nocsight Elixir"
	smells_like = "crisp nite air"
	output_reagents =list(/datum/reagent/medicine/trait/nitevision = 90)

/datum/alch_cauldron_recipe/trait/sleepdraught
	name = "Restful Draught"
	smells_like = "calming florescence"
	output_reagents =list(/datum/reagent/medicine/trait/sleepdraught = 90)

/datum/alch_cauldron_recipe/trait/waterbreathing
	name = "Elixir of Hadal Grace"
	smells_like = "the sea"
	output_reagents =list(/datum/reagent/medicine/trait/waterbreathing = 30) // this one's slightly gamer potentially

/datum/alch_cauldron_recipe/trait/nutrientslurry
	name = "Nourishing Draught"
	smells_like = "fulfillment"
	output_reagents =list(/datum/reagent/medicine/trait/nutrientslurry = 90)

/datum/alch_cauldron_recipe/trait/ravenous
	name = "Ravenous Elixir"
	smells_like = "raw meat"
	output_reagents =list(/datum/reagent/medicine/trait/ravenous = 90)

/datum/alch_cauldron_recipe/trait/antidepressants
	name = "Draught of Numbness"
	smells_like = "tingly absence"
	output_reagents =list(/datum/reagent/medicine/trait/antidepressants = 90)

/datum/alch_cauldron_recipe/trait/wyrdlaborer
	name = "Laborer's Draught"
	smells_like = "earthiness"
	output_reagents =list(/datum/reagent/medicine/trait/wyrdlaborer = 90)

/datum/alch_cauldron_recipe/trait/negative
	abstract_type = /datum/alch_cauldron_recipe/trait/negative
	skill_required = SKILL_LEVEL_EXPERT // poisons are harder...

/datum/alch_cauldron_recipe/trait/negative/prodepressants
	name = "Stress Toxin"
	smells_like = "paranoia"
	output_reagents = list(/datum/reagent/medicine/trait/negative/prodepressants = 30) // ...and yield less

/datum/alch_cauldron_recipe/trait/negative/evilcaffiene
	name = "Restless Toxin"
	smells_like = "paranoia"
	output_reagents = list(/datum/reagent/medicine/trait/negative/evilcaffiene = 30)

/datum/alch_cauldron_recipe/trait/negative/singing
	name = "Xylix's Boon"
	smells_like = "exuberance"
	output_reagents = list(/datum/reagent/medicine/trait/negative/singing = 30)

/datum/alch_cauldron_recipe/trait/negative/funnyvoice
	name = "Xylix's Bane"
	smells_like = "whimsy"
	output_reagents = list(/datum/reagent/medicine/trait/negative/funnyvoice = 30)

/datum/alch_cauldron_recipe/repairelixir
	name = "Elixir of Restoring"
	smells_like = "mending"
	output_reagents = list(/datum/reagent/medicine/restoration = 30)
