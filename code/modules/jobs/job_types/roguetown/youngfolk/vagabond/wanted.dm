/datum/advclass/vagabond_wanted
	name = "Wanted"
	tutorial = "The long arm of the law reaches out for you - are you slippery enough to evade its grip this time, or is your head destined to end up in an Excidium's maw?"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/wanted
	category_tags = list(CTAG_VAGABOND)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
	)
	extra_context = "This class starts with a bounty. Luck is randomized."

/datum/outfit/job/roguetown/vagabond/wanted/pre_equip(mob/living/carbon/human/human)
	..()

	if(should_wear_femme_clothes(human))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	
	else if(should_wear_masc_clothes(human))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant

		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l

		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(33))
		cloak = /obj/item/clothing/cloak/half/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
	
	if(human.mind)
		human.change_stat(STATKEY_LCK, rand(-2, 2))
		var/my_crime = tgui_input_text(human, "What is your crime?", "Crime")

		if(!my_crime)
			my_crime = "crimes against the Crown"
		
		var/list/bounty_cats = list(
			"Meager" = rand(51, 200), 
			"Moderate" = rand(101, 150), 
			"Massive" = rand(150, 200),
			)
		
		var/bounty_amount = tgui_input_list(human, "How ample is your bounty?", "Blooded Gold", bounty_cats)
		var/race = human.dna.species
		var/gender = human.gender
		var/list/d_list = human.get_mob_descriptors()
		var/descriptor_height = build_coalesce_description_nofluff(d_list, human, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
		var/descriptor_body = build_coalesce_description_nofluff(d_list, human, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
		var/descriptor_voice = build_coalesce_description_nofluff(d_list, human, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")

		add_bounty(human.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_amount, FALSE, my_crime, "The Justiciary of Azuria")

		if(tgui_alert(human, "Am i known criminal?", "OUTLAW", list("Nae", "Yae")) == "Yae")
			GLOB.outlawed_players += human.real_name
			ADD_TRAIT(human, TRAIT_OUTLAW, JOB_TRAIT)

		to_chat(human, span_notice("I'm on the run from the law, and there's a [lowertext(bounty_amount)] sum of mammons out on my head... better lay low."))
